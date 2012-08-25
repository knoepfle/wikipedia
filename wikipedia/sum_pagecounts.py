#!/usr/bin/python

import sys

for line in sys.stdin:
    (page, rest) = line.rstrip().split(' ', 1)
    counts = rest.split(' ')
    print page, sum(map(int, counts))