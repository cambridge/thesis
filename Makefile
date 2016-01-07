# Basic Makefile for LaTeX projects by Markus Kuhn

# requires GNU make
SHELL=/bin/bash

.DELETE_ON_ERROR:

# Build rules for LaTeX-related files
%.dvi %.aux %.idx %.ist %.glo: %.tex
	latex $<
	while grep 'Rerun to get ' $*.log ; do latex $< ; done
	-killall -USR1 -r xdvi || true
%.ps: %.dvi
	dvips -Ppdf -G0 $<
%.pdf %.aux %.idx %.ist %.glo: %.tex
	pdflatex $<
	while grep 'Rerun to get ' $*.log ; do pdflatex $< ; done
%.ind: %.idx
	makeindex $*
%.gls: %.ist %.glo
	makeglossaries $*
%.bbl: %.aux
	bibtex $*

# Examples of rules for convertion various graphics formats into EPS or PDF
# (so we can always clean intermediate EPS or PDF versions of figures)
PNMTOPS=pnmtops -rle -noturn -nosetpage
%.eps: %.png
	pngtopnm $< | $(PNMTOPS) > $@
%.eps: %.tif
	tifftopnm $< | $(PNMTOPS) > $@
%.eps: %.gif
	giftopnm $< | $(PNMTOPS) > $@
%.eps: %.jpg
	djpeg $< | $(PNMTOPS) > $@
%.eps: %.pbm
	$(PNMTOPS) $< > $@
%.eps: %.pgm
	$(PNMTOPS) $< > $@
%.eps: %.ppm
	$(PNMTOPS) $< > $@
%.pdf: %.eps
	epstopdf --outfile=$@ $<
%.ps: %.fig
	fig2dev -L ps -c -z A4 $< $@
%.eps: %.fig
	fig2dev -L eps $< $@
%.pstex %.pstex_t: %.fig
	fig2dev -L pstex_t -p $*.pstex $< $*.pstex_t
	fig2dev -L pstex $< $*.pstex
%.pdftex %.pdftex_t: %.fig
	fig2dev -L pdftex_t -p $*.pdftex $< $*.pdftex_t
	fig2dev -L pdftex $< $*.pdftex

all: thesis.pdf   # or thesis.ps

thesis.pdf thesis.dvi: thesis.bbl thesis.gls thesis.ind thesis.aux 

clean:
	rm -f *~ *.dvi *.log *.bak *.aux *.toc *.ps *.eps *.blg *.bbl
	rm -f *.glg *.glo *.gls *.idx *.ild *.ind *.ist *.ilg *.iso *.out
	rm -f *.pstex *.pstex_t
	rm -f thesis.pdf
