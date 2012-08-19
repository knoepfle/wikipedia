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

## Raw page views data ##
The `download_pagecounts.sh` script retrieves the raw views data from [dumps.wikimedia.org](http://dumps.wikimedia.org/other/pagecounts-raw/), saving it in the current directory.  To use it:

    bash download_pagecounts.sh

It can be re-run without redownloading any existing files and will check that each month downloaded properly using the MD5 sums.

Aside from MD5 checksumming and putting all files in the current directory, `download_pagecounts.sh` is easily replaced by

    wget -r --no-parent http://dumps.wikimedia.org/other/pagecounts-raw/

if `wget` is available (it isn't distributed with OS X, while `curl` is).