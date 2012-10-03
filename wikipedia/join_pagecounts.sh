#!/bin/sh

### Usage:
###     join_pagecounts.sh [-r|-i] (-s) [outfile] [infiles]
###
### Do
###     join_pagecounts.sh -r [outfile] [infiles]
### when [infiles] are raw pageview data files (i.e., downloaded with download_pagecounts.sh)
### e.g.:
###     for d in {01..31}; do join_pagecounts.sh -r join-200712${d}.txt ../pagecounts-200712${d}-??????.gz; done
###
### Do
###     join_pagecounts.sh -i [outfile] [infiles]
### when [infiles] are the output of join_pagecounts.sh
### e.g.:
###     join_pagecounts.sh -i join-200712.txt join-200712??.txt
###
### Adding the optional -s flag tells the script to pass the output through sum_pagecounts.py

function usage() {
    echo "Usage: `basename $0` [-r|-i] [-s] [outfile] [infiles]"
    exit 1
}

[[ $# -lt 3 ]] && usage

while getopts "ris" option
do
case $option in
r ) joincmd="join_raw" ;;
i ) joincmd="join_intermediate" ;;
s ) sum="sum" ;;
esac
done
shift $(($OPTIND - 1))

[[ "$joincmd" == "join_raw" ]] || [[ "$joincmd" == "join_intermediate" ]] || { echo "Specify raw or intermediate inputs" && usage; }

function add_file() {
    echo $1 "+" $2 ">" $3

    [[ "${1:(-2)}" == "gz" ]] && catcmd="gunzip -c" || catcmd="cat"

    $joincmd $1 $2 $3
}

function join_raw() {
    $catcmd $1 | grep "^en " | iconv -f LATIN1 -t UTF8 | cut -d' ' -f 2,3 | sort -k 1b,1 |  join -j 1 -a 1 -a 2 -t' ' $2 - > $3
}

function join_intermediate() {
    $catcmd $1 |  join -j 1 -a 1 -a 2 -t' ' $2 - > $3
}

tmpjoin="joined_tmp.txt"

outfile=$1
shift

: > $tmpjoin

cur_inp=$outfile
cur_out=$tmpjoin

for arg
do
    swapvar=$cur_inp
    cur_inp=$cur_out
    cur_out=$swapvar

    add_file $arg $cur_inp $cur_out
done

[[ "$cur_out" != "$outfile" ]] && mv $cur_out $outfile || rm $tmpjoin

[[ "$sum" == "sum" ]] && mv $outfile $tmpjoin && cat $tmpjoin | ./sum_pagecounts.py > $outfile
