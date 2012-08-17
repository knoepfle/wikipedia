#!/bin/bash

### download all raw page views data from http://dumps.wikimedia.org/other/pagecounts-raw/

years="2007 2008 2009 2010 2011 2012"

function get_year_months() {
    year=$1
    if [[ ! -e index-$year.html ]]
    then
        curl http://dumps.wikimedia.org/other/pagecounts-raw/$year/ -o index-$year.html
    fi
    sed -n '/>[0-9]\{4\}-[0-9]\{2\}</ s/.*>\([0-9]\{4\}-[0-9]\{2\}\)<.*/\1/ p' index-$year.html > months-$year.txt
}

function get_month_files() {
    year=$1
    month=$2
    if [[ ! -e index-$month.html ]]
    then
        curl http://dumps.wikimedia.org/other/pagecounts-raw/$year/$month/ -o index-$month.html
    fi
    sed -n '/\.gz/ s/.*>\(pagecounts[-0-9]*\.gz\)<.*/\1/ p' index-$month.html > files-$month.txt
}

function download_month() {
    year=$1
    month=$2
    echo "Downloading files for month $2"
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

function md5_check_month() {
    year=$1
    month=$2
    echo -n "Checking files for $month: "
    
    md5invalid=$(md5sum --quiet -c md5sums-$month.txt 2>/dev/null)
    
    if [[ $? -ne 0 ]]
    then
        echo "FAILED"
        broken_files=$(echo "$md5invalid" | sed -n '/FAILED$/ s/\(pagecounts-[-0-9]*\.gz\):.*/\1/ p' )
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
