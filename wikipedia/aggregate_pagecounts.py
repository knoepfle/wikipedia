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



vals = dict()
for line in sys.stdin:
    (project, page, visits, size) = line.rstrip().split(' ')
    vals[(project, page)] = vals.get((project, page), 0) + int(visits)

for (key, value) in vals.iteritems():
    (project, page) = key
    print(' '.join([ project, page, str(value) ]))