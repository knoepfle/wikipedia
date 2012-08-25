#!/usr/bin/python

import sys


'''
Here are a few sample lines from one file:
    
    
    fr.b Special:Recherche/Achille_Baraguey_d%5C%27Hilliers 1 624
    fr.b Special:Recherche/Acteurs_et_actrices_N 1 739
    fr.b Special:Recherche/Agrippa_d/%27Aubign%C3%A9 1 743
    fr.b Special:Recherche/All_Mixed_Up 1 730
    fr.b Special:Recherche/Andr%C3%A9_Gazut.html 1 737
    
    
In the above, the first column "fr.b" is the project name. The following abbreviations are used:
    
    wikibooks: ".b"
    wiktionary: ".d"
    wikimedia: ".m"
    wikipedia mobile: ".mw"
    wikinews: ".n"
    wikiquote: ".q"
    wikisource: ".s"
    wikiversity: ".v"
    mediawiki: ".w"
    
These are hourly statistics, so in the line
    
    en Main_Page 242332 4737756101
    
we see that the main page of the English language Wikipedia was requested over 240 thousand times during the specific hour. These are not unique visits.
'''


### naive implementation runs out of memory (unsurprisingly)
# vals = dict()


### file-backed dictionary using shove
### fails with the following error:
'''
    [03:01]knoepfle@tyrone:~/Desktop$ cat pagecounts-2007* | /Library/Frameworks/Python.framework/Versions/2.7/bin/python ~/Dropbox/wikipedia/wikipedia/aggregate_pag
    ecounts.py > pagecounts-aggregated.txt
    Traceback (most recent call last):
    File "/Users/knoepfle/Dropbox/wikipedia/wikipedia/aggregate_pagecounts.py", line 44, in <module>
    vals[key] = visits
    File "/Library/Python/2.7/site-packages/shove-0.5.3-py2.7.egg/shove/core.py", line 41, in __setitem__
    self._cache[key] = self._buffer[key] = value
    File "/Library/Python/2.7/site-packages/shove-0.5.3-py2.7.egg/shove/cache.py", line 45, in __setitem__
    self._cull()
    File "/Library/Python/2.7/site-packages/shove-0.5.3-py2.7.egg/shove/cache.py", line 55, in _cull
    for num, key in enumerate(self):
    RuntimeError: dictionary changed size during iteration
'''

import os
import base64

from shove import Shove
vals = Shove('dbm://data.db', 'memory://')

#for line in sys.stdin:
for iter in range(100000):
    #(project, page, visits, size) = line.rstrip().split(' ')
    #key = project + ' ' + page
    
    key = base64.b16encode(os.urandom(5))
    value = 1
    if key in vals:
        vals[key] = str(long(vals[key]) + long(value))
    else:
        vals[key] = value
    if iter % 10000 == 1:
        print >> sys.stderr, iter

for key, value in vals.iteritems():
    print(key + ' ' + value)


