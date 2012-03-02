# Quick start

Copy all files from this directory (where you found this readme file) to your
desired location.

Now you can start writing your thesis using the `thesis.tex` file.

## How will it look like?

Your thesis document will look something like this:

* [Thesis Sample (PDF)](https://github.com/downloads/cambridge/thesis/thesis-sample.pdf)

The template also supports DVI and PS formats. All three formats are generated
by the provided `Makefile`.

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

-------------------------------------------------------------------------------

# Usage details

## Class options

`cam-thesis` supports all the options of the standard `report` class (on which
it is based).

It also supports some custom options.

*   `techreport`: formats the document as a technical report. Here is a list of
    formatting points in which the technical report differs from a normal thesis
    (see [guidelines](http://www.cl.cam.ac.uk/techreports/submission.html) for
    more information):

    *   different margins (left and right margins are 25mm, top and bottom
        margins are 20mm),
    *   normal line spacing (instead of one-half spacing),
    *   no custom title page,
    *   no declaration,
    *   page count starts with 3,
    *   if the `hyperref` package is used, the option `pdfpagelabels=false` will
        be passed to it.

*   `notimes`: tells the class not to use the _times_ font. This option is
    implied by the `nopackages`.

*   `nopackages`: tells the class not to use any non-essential packages (this
    option implies the `notimes` option).

    _Note_: If this option is not specified, then the class will use the
    following non-essential packages:

    * `times` (can also be excluded by using the `notimes` option),
    * `amsmath`
    * `amssymb`
    * `amsthm`

-------------------------------------------------------------------------------

# Troubleshooting

## I have found a bug in the template. Where do I report bugs?

You can report issues through
[our GitHub repository](https://github.com/cambridge/thesis/issues).

You can also mail
[the maintainers](https://github.com/cambridge/thesis/contributors) directly.

## Where can I find the thesis formatting guidelines this class is based on?

The University of Cambridge guidelines:

> [http://www.admin.cam.ac.uk/offices/gradstud/exams/submission/phd/format.html](http://www.admin.cam.ac.uk/offices/gradstud/exams/submission/phd/format.html)

The Computer Laboratory guidelines:

> [http://www.cl.cam.ac.uk/local/phd/typography/](http://www.cl.cam.ac.uk/local/phd/typography/)     

## Can I use my own Makefile?

By all means. Here is a very nice (and smart) `Makefile` built specifically for
LaTeX:

> [http://code.google.com/p/latex-makefile/](http://code.google.com/p/latex-makefile/)

## But what if I don't want the template files in my thesis directory?

Put the files and folders listed below into a directory where LaTeX can find them (for more
info see __[1]__):

    cam-thesis.cls
    CUni.eps
    CUni.pdf
    CollegeShields/


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

--------------------------------------------------------------------------------

# TODO list

*   Fill PDF's meta tags (e.g.: author, title, keywords etc.).
*   It is debatable which packages are non-essential. We could reclassify this.
