# Wikipedia edits and views data - scripts for downloading and processing #

## Edits data from SNAP ##
Download the data from [SNAP](http://snap.stanford.edu/data/wiki-meta.html); process it as follows:

    bzcat enwiki-20080103.main.bz2 | python wikipedia.py | bzip2 > output.txt.bz2 

See `wikipedia.sh` for more on usage.

## Raw page views data ##
The `download_pagecounts.sh` script retrieves the raw views data from [dumps.wikimedia.org](http://dumps.wikimedia.org/other/pagecounts-raw/), saving it in the current directory.  To use it:

    bash download_pagecounts.sh

It can be re-run without redownloading any existing files and will check that each month downloaded properly using the MD5 sums.
