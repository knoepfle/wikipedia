#!/bin/bash

### download all raw page views data from http://dumps.wikimedia.org/other/pagecounts-raw/

years="2007 2008 2009 2010 2011 2012"

function get_year_months() {
    year=$1
    if [[ ! -e index-$year.html ]]
    then
        echo -n "Downloading index for year $year: "
        curl -s http://dumps.wikimedia.org/other/pagecounts-raw/$year/ -o index-$year.html
        echo "done"
    fi
    sed -n '/>[0-9]\{4\}-[0-9]\{2\}</ s/.*>\([0-9]\{4\}-[0-9]\{2\}\)<.*/\1/ p' index-$year.html > months-$year.txt
}

function get_month_files() {
    year=$1
    month=$2
    if [[ ! -e index-$month.html ]]
    then
        echo -n "Downloading index for month $month: "
        curl -s http://dumps.wikimedia.org/other/pagecounts-raw/$year/$month/ -o index-$month.html
        echo "done"
    fi
    sed -n '/\.gz/ s/.*>\(pagecounts[-0-9]*\.gz\)<.*/\1/ p' index-$month.html > files-$month.txt
}

function download_month() {
    year=$1
    month=$2
    echo "Downloading files for month $month"
    curl -s http://dumps.wikimedia.org/other/pagecounts-raw/$yyyy/$month/md5sums.txt -o md5sums-$month.txt
    for f in `cat files-$month.txt`
    do
        if [[ ! -e $f ]]
        then
            echo -n "Downloading $f: "
            curl -s http://dumps.wikimedia.org/other/pagecounts-raw/$year/$month/$f -o $f
            echo "done"
        fi
    done
}

function md5_check() {
    year=$1
    month=$2
    f=$3
    md5val=$(md5 -q $f)
    grep -q "$md5val  $f" md5sums-$month.txt
    return $?
}

function md5_check_month() {
    year=$1
    month=$2
    echo -n "Checking files for $month: "
    
    if command -v md5sum
    then
        ## system has md5sum; use it

        md5invalid=$(md5sum --quiet -c md5sums-$month.txt 2>/dev/null)
        md5status=$?
        broken_files=$(echo "$md5invalid" | sed -n '/FAILED$/ s/\(pagecounts-[-0-9]*\.gz\):.*/\1/ p' )
    else
        ## no md5sum, probably running on Mac OS X; use md5 instead

        md5status=0
        for f in `cat files-$month.txt`
        do
            if [[ -e $f ]]
            then
                md5_check $year $month $f || broken_files="$broken_files $f" && let "md5status += 1"
            else
                let "md5status += 1"
            fi
        done
        
    fi

    if [[ $md5status -ne 0 ]]
    then
        echo "FAILED"
        
        for b in $broken_files
        do
            echo "File $b has invalid MD5 checksum and has been deleted"
            rm $b
        done
        echo "Some files were invalid or missing; attempting to redownload"
        return 1
    else
        echo "PASSED"
        return 0
    fi
}

for yyyy in $years
do
    get_year_months $yyyy
done

for yyyy in $years
do
    for month in `cat months-$yyyy.txt`
    do
        get_month_files $yyyy $month
    done
done

for yyyy in $years
do
    for month in `cat months-$yyyy.txt`
    do
        download_month $yyyy $month
        md5_check_month $yyyy $month || download_month $yyyy $month && md5_check_month $yyyy $month || echo "Redownload failed."
    done
done

echo "cleaning up"
rm months-*.txt files-*.txt index-*.html md5sums-*.txt

echo "done"
