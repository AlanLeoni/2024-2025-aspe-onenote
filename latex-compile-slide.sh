#!/bin/bash

# Verifica se è stato fornito un argomento (il nome del file .tex)
if [ $# -eq 0 ]; then
    echo "Usage: $0 <your_file.tex>"
    exit 1
fi

# Nome del file .tex senza estensione
filename=$(basename -- "$1")
filename_noext="${filename%.*}"

# Compila la versione regular
sed 's/\\documentclass{beamer}/\\documentclass{beamer}/' "$filename" > temp.tex
latexmk -pdf temp.tex -jobname="${filename_noext}__regular"
mv "${filename_noext}__regular.pdf" "${filename_noext}__regular.pdf"

# Compila la versione handout
sed 's/\\documentclass{beamer}/\\documentclass[handout]{beamer}/' "$filename" > temp.tex
latexmk -pdf temp.tex -jobname="${filename_noext}__handout"
mv "${filename_noext}__handout.pdf" "${filename_noext}__handout.pdf"

# Compila la versione notes
sed 's/\\documentclass{beamer}/\\documentclass{beamer}\\usepackage{pgfpages}\\setbeameroption{show notes on second screen=right}/' "$filename" > temp.tex
latexmk -pdf temp.tex -jobname="${filename_noext}__notes"
mv "${filename_noext}__notes.pdf" "${filename_noext}__notes.pdf"

# Rimuove i file temporanei e tutti i file generati da latexmk
rm -f temp.tex
latexmk -c "${filename_noext}__regular"
latexmk -c "${filename_noext}__handout"
latexmk -c "${filename_noext}__notes"

# Rimuove manualmente gli altri file intermedi
rm -f "${filename_noext}__regular".{aux,log,out,fls,fdb_latexmk,nav,snm,toc,blx.bib,run.xml}
rm -f "${filename_noext}__handout".{aux,log,out,fls,fdb_latexmk,nav,snm,toc,blx.bib,run.xml}
rm -f "${filename_noext}__notes".{aux,log,out,fls,fdb_latexmk,nav,snm,toc,blx.bib,run.xml}

echo "PDFs generati: ${filename_noext}__regular.pdf, ${filename_noext}__handout.pdf e ${filename_noext}__notes.pdf"
