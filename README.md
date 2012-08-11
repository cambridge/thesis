# cam-thesis

>   _a LaTeX thesis template for Cambridge PhD students_

Want to write a thesis? Well, here is what you need:

1.  this template (just clone it with git),
2.  one of the existing samples (which can be found in the [`./Samples/`](https://github.com/cambridge/thesis/tree/master/Samples) folder), and
3.  and some research content.

The samples are based on other PhD students' theses.

## Quicker start

Copy all files from this directory (where you found this `README` file) to your
desired location.

Now you can start writing your thesis using the `thesis.tex` file.

Finally, build the `PDF` document by running the following in the command line:

    make

If you're using the `glossaries` package, try using these:

    ./makepdf
    ./makeps

The above scripts work around a bug in the supplied makefile (i.e., the makefile forgets to rebuild the glossary index when pages change between LaTeX build runs).

## How will it look like?

Your thesis document will look something like this (using the Adobe Sabon font and the _clean_ sample, which can be found in [`./Samples/clean`](https://github.com/cambridge/thesis/tree/master/Samples/clean)):

>   [Thesis Sample (PDF)](https://github.com/downloads/cambridge/thesis/thesis.pdf)

The template also supports DVI and PS formats. All three formats can be generated
with the provided `Makefile`.

## Producing `PDF`, `DVI` and `PS` documents

### Build your thesis

To build the `PDF` version of your thesis, run:

    make

or

    ./makepdf

This build procedure uses `pdflatex` and will produce `thesis.pdf`.

To produce `DVI` and `PS` versions of your document, you should run:

    ./makeps

or

    make BUILD_STRATEGY=latex

This will use the `latex` command to build the document and will produce
`thesis.dvi`, `thesis.ps` and `thesis.pdf` documents.

### Clean unwanted files

To clean unwanted clutter (all LaTeX auto-generated files), run:

    make clean

__Note__: the `Makefile` itself is take from and maintained at
[here](http://code.google.com/p/latex-makefile/).

## Known issues

1.  When using the glossary, references are not pointing to the right page.

    __Workaround__: Build the document with:

        ./makepdf

    or

        make && makeglossaries thesis && makeindex thesis && pdflatex thesis.tex

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

*   `times`: tells the class to use the _times_ font.

*   `glossary`: puts the glossary after the TOC. The glossary contains a list of
    abbreviations, their explanations etc. Describe your abbreviations and add
    them to the glossary immediately after you introduce them in the body of
    your thesis. You can use the following command for this:

        \newglossaryentry{computer}
        {
          name=computer,
          description={is a programmable machine that receives input,
                       stores and manipulates data, and provides
                       output in a useful format}
        }

    After that, you can reference particular glossary entries like this:

        \gls{computer}

    You can also change the glossary style. For example, try putting this on the very top of the preamble (even before you define the document class with `\documentclass[glossary]{cam-thesis}`):

        \PassOptionsToPackage{style=altlong4colheader}{glossaries}

    Further instructions can be found [on LaTeX Wikibooks](http://en.wikibooks.org/wiki/LaTeX/Glossary) or the [user manual at CTAN](http://mirrors.ctan.org/macros/latex/contrib/glossaries/glossaries-user.pdf).

    _Note_: `glossaries` is the package used to create the glossary.

*   `index`: build the index, which you can put at the and of the thesis with
     the following command (it will create a new unnumbered chapter):

        \printthesisindex

    Instructions on how to use the index can be found [here](http://en.wikibooks.org/wiki/LaTeX/Indexing#Using_makeidx).

    _Note_: the package `makeidx` is used to create the index.

-------------------------------------------------------------------------------

# Troubleshooting

## _Q1_: I found a bug in the template. Where do I report bugs?

You can report issues through
[our GitHub repository](https://github.com/cambridge/thesis/issues).

You can also mail
[the maintainers](https://github.com/cambridge/thesis/contributors) directly.

## _Q2_: Where can I find the thesis formatting guidelines this class is based on?

The University of Cambridge guidelines:

> [http://www.admin.cam.ac.uk/students/studentregistry/exams/submission/phd/format.html](http://www.admin.cam.ac.uk/students/studentregistry/exams/submission/phd/format.html)

The Computer Laboratory guidelines:

> [http://www.cl.cam.ac.uk/local/phd/typography/](http://www.cl.cam.ac.uk/local/phd/typography/)     

The Computer Laboratory guidelines for technical reports:

> [http://www.cl.cam.ac.uk/techreports/submission.html](http://www.cl.cam.ac.uk/techreports/submission.html)

## _Q3_: Can I use my own Makefile?

By all means. We are currently using the very nice (and smart) `Makefile` built
specifically for LaTeX:

> [http://code.google.com/p/latex-makefile/](http://code.google.com/p/latex-makefile/)

## _Q4_: But what if I don't want the template files in my thesis directory?

Put the files and folders listed below into a directory where LaTeX can find them (for more
info see __[1]__):

    cam-thesis.cls
    CUni.eps
    CUni.pdf
    CollegeShields/
    Makefile
    Variables.ini


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

## _Q5_: Where can I find newer versions of the University of Cambridge logo?

The university updates its logo every now and then. You can find up-to-date
logos on [this page](http://www.admin.cam.ac.uk/offices/communications/services/logos/)
(subject to change without notice).

Download and exchange the new logos with `CUni.eps` and/or `CUni.pdf`.

## _Q6_: My college's shield/coat of arms/crest is not included. Why u no include it?

The shields are being added on the go (when somebody, who uses them, provides them).

If you find a distributable vector-based image of your college's shield you can report it as an issue or mail it to contributors directly (refer to question __Q1__ above).

## _Q7_: Where can I find extra fonts (like Adobe Sabon, Adobe Utopia etc.)?

The Computer Laboratory provides some [here](http://www.cl.cam.ac.uk/local/sys/unix/applications/tex/#clfonts).

After you've installed the fonts, add somewhere in the preamble (before `\begin{document}`) the following command:

    \renewcommand\rmdefault{psb}

## _Q8_: How should I count the number of words in my thesis?

There is [a page](http://www.cl.cam.ac.uk/local/phd/writingup.html) on the Computer Lab's web site. They recommend using this command:

    ps2ascii thesis.pdf | wc -w

--------------------------------------------------------------------------------

# TODO list

*   Fill out more PDF meta tags (e.g.: keywords, subject etc.).
