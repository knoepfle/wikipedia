#!/bin/sh

#### USAGE ####

### Download the main data file to the current directory:
## curl -O http://snap.stanford.edu/data/bigdata/wikipedia08/enwiki-20080103.main.bz2

### Decompress and pipe the output through 'head -140' to print the first ten entries:
## bzcat enwiki-20080103.main.bz2 | head -140

### Decompress and transform the first ten entries, printing the output:
## bzcat enwiki-20080103.main.bz2 | head -140 | python wikipedia.py

### Decompress and transform the first thousand entries, sending the output to a plain
### text file named output.txt:
## bzcat enwiki-20080103.main.bz2 | head -14000 | python wikipedia.py > output.txt

### Decompress and transform the first thousand entries, sending the output to a
### bzip2-compressed file named output.txt.bz2:
## bzcat enwiki-20080103.main.bz2 | head -14000 | python wikipedia.py | bzip2 > output.txt.bz2

### Decompress, piping the output through the transformer and into a plain text file:
## bzcat enwiki-20080103.main.bz2 | ./wikipedia > output.txt

### Decompress and transform the entire main data file, sending the output to a
### bzip2-compressed file named output.txt.bz2:
## bzcat enwiki-20080103.main.bz2 | python wikipedia.py | bzip2 > output.txt.bz2 


#### TESTING ####

### Generate test data:
## curl -O http://snap.stanford.edu/data/bigdata/wikipedia08/enwiki-20080103.main.bz2
## bzcat enwiki-20080103.main.bz2 | head -1400 > wikipedia.txt

cat wikipedia.txt | ./wikipedia > output.cpp.txt
cat wikipedia.txt | python wikipedia.py > output.py.txt
cat wikipedia.txt | awk -f wikipedia.awk > output.awk.txt

## verify that outputs are identical
diff --from-file=output.cpp.txt output.py.txt output.awk.txt

## clean up
rm output.cpp.txt output.py.txt output.awk.txt

#### COMPILATION ####

### Compile the C++ version to an executable named 'wikipedia' in the current directory:
### (This assumes you have Boost somewhere in your include path.)
## g++ -O3 wikipedia.cpp -o wikipedia
