# Wikipedia edits and views data - scripts for downloading and processing #

## Edits data from SNAP ##
Download the data from [SNAP](http://snap.stanford.edu/data/wiki-meta.html); process it as follows:

    bzcat enwiki-20080103.main.bz2 | python wikipedia.py | bzip2 > output.txt.bz2 

See `wikipedia.sh` for more on usage.  The AWK script `wikipedia.awk` and C++ program `wikipedia` are redundant implementations.

The scripts transform the input, which has records like so:

    REVISION 4781981 72390319 Steven_Strogatz 2006-08-28T14:11:16Z SmackBot 433328
    CATEGORY American_mathematicians
    IMAGE
    MAIN Boston_University MIT Harvard_University Cornell_University
    TALK
    USER
    USER_TALK
    OTHER De:Steven_Strogatz Es:Steven_Strogatz
    EXTERNAL http://www.edge.org/3rd_culture/bios/strogatz.html
    TEMPLATE Cite_book Cite_book Cite_journal
    COMMENT ISBN formatting &/or general fixes using [[WP:AWB|AWB]]
    MINOR 1
    TEXTDATA 229
    [blank line]

into a tab-separated format with 18 fields:

    4781981	72390319	Steven_Strogatz	2006-08-28T14:11:16Z	SmackBot	433328	American_mathematicians		Boston_University MIT Harvard_University Cornell_University				De:Steven_Strogatz Es:Steven_Strogatz	http://www.edge.org/3rd_culture/bios/strogatz.html	Cite_book Cite_book Cite_journal	ISBN formatting &/or general fixes using [[WP:AWB|AWB]]	1	229

The first six fields contain the data from the REVISION line split by tabs.  Each other line's data is put into a field verbatim; thus, within some of the other fields, there are several elements separated by spaces; e.g., the TEMPLATE field contains "Cite\_book Cite\_book Cite\_journal", and the OTHER field contains "De:Steven\_Strogatz Es:Steven\_Strogatz".

The output has a total of 116,590,856 records.

## Raw page views data ##

### Downloading ###
The `download_pagecounts.sh` script retrieves the raw views data from [dumps.wikimedia.org](http://dumps.wikimedia.org/other/pagecounts-raw/), saving it in the current directory.  To use it:

    bash download_pagecounts.sh

It can be re-run without redownloading any existing files and will check that each month downloaded properly using the MD5 sums.

Aside from MD5 checksumming and putting all files in the current directory, `download_pagecounts.sh` is easily replaced by

    wget -r --no-parent http://dumps.wikimedia.org/other/pagecounts-raw/

if `wget` is available (it isn't distributed with OS X, while `curl` is).

### Aggregating ###
The `join_pagecounts.sh` script combines the pageview files, producing files with the page name and a string of space-separated view counts on each line:

    Brown-eared 1 1 1
    Brown-eared_Bulbul 1 1 1 1
    Brown_eared-pheasant 1
    Brown-eared_Pheasant 2
    Brown_Eared_Pheasant 2 1 1 1 1 1 1
    Brown-eared_Woodpecker 1 1
    Brown-eared_Woolly_Opossum 1 1 1 3 1 1

The `sum_pagecounts.py` script acts as a filter, reducing the string of space-separated counts to their sums:

    Brown-eared 3
    Brown-eared_Bulbul 4
    Brown_eared-pheasant 1
    Brown-eared_Pheasant 2
    Brown_Eared_Pheasant 8
    Brown-eared_Woodpecker 2
    Brown-eared_Woolly_Opossum 8

The syntax for `join_pagecounts.sh` is `join_pagecounts.sh [raw|intermediate] [outfile] [infiles]`.  Use `-r` ("raw") if the inputs are the raw `pagecounts-????????-??????.gz` files.  For instance,

    join_pagecounts.sh -r join-20071210.txt ../pagecounts-20071210-??????.gz

joins the raw pageview files for 2007/12/10 into a file named `join-20071210.txt`.  Use `-i` ("intermediate") with output files like `join-20071210.txt`.  For instance,

    for d in {01..31}; do join_pagecounts.sh -r join-200712${d}.txt ../pagecounts-200712${d}-??????.gz; done
    
    join_pagecounts.sh -i join-200712.txt join-200712??.txt
    
first joins the raw pageview files for each day in December, 2007 into files named `join-20071210.txt`, `join-20071211.txt`, `join-20071212.txt`, ..., `join-20071231.txt`, then joins these files together to produce `join-200712.txt` (note that December, 2007 lacks raw pageview files prior to 2007/12/10).

At any point, you can aggregate the counts down to their sums by running the file through `sum_pagecounts.py`.  For instance,

    cat join-200712.txt | sum_pagecounts.py > sum-200712.txt

produces `sum-200712.txt`, containing the total number of pageviews for each page in December, 2007.

You can also add the optional `-s` flag to `join_pagecounts.sh` to tell it to sum the counts before outputting them.

To join and sum an entire year (e.g., 2008), do

    for m in {01..12}; do join_pagecounts.sh -r -s join-2008${m}.txt ../pagecounts-2008${m}??-??????.gz; done
    
    join_pagecounts.sh -i -s join-2008.txt join-2008??.txt
    
This results in a file, `join-2008.txt`, containing the total number of pageviews for each page in all of 2008, along with monthly totals in `join-200801.txt`, `join-200802.txt`, ..., `join-200812.txt`.


