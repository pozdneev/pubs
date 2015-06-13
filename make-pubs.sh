#!/bin/bash

rm -f *.aux *.bbl *.blg *.dvi *.log

pdflatex pubs
pdflatex pubs

for file in *.aux ; do
    bibtex `basename $file .aux`
done

pdflatex pubs
pdflatex pubs
