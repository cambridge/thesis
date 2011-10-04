SHELL=/bin/bash
LATEX=latex
MAKEINDEX=makeindex
BIBTEX=bibtex
DVIPDF=dvipdf
PDFLATEX=pdflatex
DVIPS=dvips -Ppdf -G0

SRC=thesis.tex thesis.bib cam-thesis.cls

.PHONY: thesis thesis_quick clean distclean

thesis: thesis.pdf thesis.ps

thesis.pdf: $(SRC)
	$(PDFLATEX) thesis && $(MAKEINDEX) thesis && $(BIBTEX) thesis && \
        $(PDFLATEX) thesis && $(PDFLATEX) thesis

thesis.ps: thesis.dvi
	$(DVIPS) thesis

thesis.dvi: $(SRC)
	$(LATEX) thesis && $(MAKEINDEX) thesis && $(BIBTEX) thesis && \
        $(LATEX) thesis && $(LATEX) thesis

thesis_quick:
	$(LATEX) thesis && $(DVIPDF) thesis

clean:
	@rm -rf thesis.{aux,bbl,blg,idx,ilg,ind,log,out,toc}

distclean: clean
	@rm -rf thesis.{dvi,pdf,ps}
