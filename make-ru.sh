#!/bin/bash

rm -f *.aux *.bbl *.blg *.dvi *.log

pdflatex main
pdflatex main

for file in *.aux ; do
    bibtex `basename $file .aux`
done

pdflatex main
pdflatex main
