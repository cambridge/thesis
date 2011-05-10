# Quick start

Copy all files from this directory (where you found this readme file) to your
desired location.

Now you can start writing your thesis using the `thesis.tex` file.

## How will it look like?

Your thesis document will look something like this:

* [Thesis Sample (PS)](https://github.com/downloads/cambridge/thesis/thesis.ps)
* [Thesis Sample (DVI)](https://github.com/downloads/cambridge/thesis/thesis.dvi)
* [Thesis Sample (PDF)](https://github.com/downloads/cambridge/thesis/thesis.pdf)

## Producing PDF, DVI and PS documents

### Build your thesis

To build your thesis, run:

    make

This should build `thesis.dvi`, `thesis.ps` and `thesis.pdf` documents.

### Clean unwanted files

To clean unwanted clutter (all LaTeX auto-generated files), run:

    make clean

To clean absolutely all files produced by `make`, run:

    make distclean

For other build options, refer to the `Makefile` file itself.

# Troubleshooting

## Can I use my own Makefile?

By all means. Here is a very nice (and smart) `Makefile` built specifically for
LaTeX:

> [http://code.google.com/p/latex-makefile/](http://code.google.com/p/latex-makefile/)

## But what if I don't want the template files in my thesis directory?

Put the files listed below into a directory where LaTeX can find them (for more
info see __[1]__):

    cam-thesis.cls
    CUni.eps
    CUni.pdf


> __[1]__ You can put these files either into the standard LaTeX directory for
> classes __[2]__, or a directory listed in your `TEXINPUTS` environment variable.
>
> __[2]__ The location of the standard LaTeX class directory depends on which LaTeX
> installation and operating system you use. For example, for TeX Live on Fedora
> 14 it is `/usr/share/texmf/tex/latex/base`.
>
> In any case, after this, LaTeX will still not be able find your class. You
> will have to rebuild the package index. This procedure also depends on your
> installation specifics, but for TeX Live you have to run the `texhash` command.
>
> For more comprehensive information refer to
> [LaTeX Wikibooks](http://en.wikibooks.org/wiki/LaTeX/Packages/Installing_Extra_Packages).

## Where can I find newer versions of the University of Cambridge logo?

The university updates its logo every now and then. You can find up-to-date
logos on [this page](http://www.admin.cam.ac.uk/offices/communications/services/logos/)
(subject to change without notice).

Download and exchange the new logos with `CUni.eps` and/or `CUni.pdf`.
