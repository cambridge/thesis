%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Class ``cam-thesis''
%%
%% Version: v0.2
%% Authors: Jean Martina, Rok Strnisa, Matej Urbas
%% Date: 30/07/2008
%%
%% Copyright (c) 2008-2012, Rok Strniša, Jean Martina, Matej Urbas
%% License: Simplified BSD License
%% License file: ./License
%% Original License URL: http://www.freebsd.org/copyright/freebsd-license.html
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% General guidelines on which this class is based:
%%
%%     http://www.cl.cam.ac.uk/local/phd/typography/
%%     http://www.admin.cam.ac.uk/offices/gradstud/exams/submission/phd/format.html
%%
%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Class identification.
%%
%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cam-thesis}[2012/04/12 University of Cambridge thesis class]

\typeout{}
\typeout{***********************************************}
\typeout{***********************************************}
\typeout{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% General Cambridge guidelines.
%%
%% LIMIT: 60k words (including tables and footnotes, excluding appendices, bib,
%% photos, diagrams); title and section headings should be capitalized as normal
%% sentences; citations should include authors' initials, and page numbers (if
%% possible); double-sided printing is permissible for the soft bound version;
%% however, single-sided is required for the text of the final, hard bound
%% library copy (diagrams on facing pages are acceptable); always make it
%% possible to create the ps file as well (required for technical reports).
%%
%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Package options (see README.md for a list of options with descriptions).
%%
%% These options can be provided within square brackets of the `documentclass'
%% command.
%%
%%%%%

% techreport - formats the thesis as a technical report.
\newif\ifcam@techreport\cam@techreportfalse
\DeclareOption{techreport}{\cam@techreporttrue}

% times - tells the class to use the times font.
\newif\ifcam@times\cam@timesfalse
\DeclareOption{times}{\cam@timestrue}

% glossary - puts the glossary (after the TOC).
%
\newif\ifcam@glossary\cam@glossaryfalse
\DeclareOption{glossary}{\cam@glossarytrue}

% index - puts the index at the end of the thesis.
%
\newif\ifcam@index\cam@indexfalse
\DeclareOption{withindex}{\cam@indextrue}

% 1st year report - omits abstract/declaration
%
\newif\ifcam@firstyr\cam@firstyrfalse
\DeclareOption{firstyr}{\cam@firstyrtrue}

% screen -- optimize output for on-screen reading
%
\newif\ifcam@screen\cam@screenfalse
\DeclareOption{screen}{\cam@screentrue}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Using report class as base.
%%
%%%%%
\PassOptionsToClass{a4paper,12pt,\ifcam@screen oneside \else twoside \fi,openright}{report}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass{report}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Additional packages, and their options.
%%
%%%%%
\RequirePackage{graphicx}           % Required for the UC Logo (on the title page)
\RequirePackage{calc}               % Used for calculating margins and laying out the title page
\RequirePackage{setspace}      	    % Used for selecting single or onehalf line spacing.
\RequirePackage{tikz}

% Hyperref should be included in any case, but we make it non-obtrusive (i.e.: no hyperlink borders).
% Why do we need a separate treatment of hyperref for the techreport? Because the guidelines say so. :)
\ifcam@techreport
    % TODO: If the thesis is compiled to PS, include the 'dvips' option to hyperref.
    \RequirePackage[
        pdfpagelabels=false,
        pdfborder={0 0 0},
        pdfusetitle=true
    ]{hyperref}
\else
    \RequirePackage[
        pdffitwindow=true,
        pdfpagelabels=true,
        colorlinks=false,
        pdfborder={0 0 0},
        pdfusetitle=true
    ]{hyperref}
\fi
\RequirePackage[all]{hypcap}        % Fixes links to floats (must be included after hyperref).

% Create the index
\ifcam@index
    \RequirePackage{makeidx}
    \makeindex
    \newcommand{\printthesisindex}{%
        \cleardoublepage
        \phantomsection%
        \addcontentsline{toc}{chapter}{Index}%
        \printindex}
\fi

% Create the glossary
\ifcam@glossary
    \RequirePackage{glossaries}
    \makeglossaries%
    \newcommand{\printthesisglossary}{\printglossary}
    \newcommand{\cam@printthesisglossary}{%
        \cleardoublepage
        \pagestyle{empty}%
        \renewcommand{\glossarypreamble}{\thispagestyle{empty}}%
        \printthesisglossary%
    }
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Page margins (suitable for J.S. Wilson & Son).
%%
%%%%%

% Setting the offsets to 'zero' (LaTeX calculates offsets 1in from the left and upper edges of the page) makes the calculation of margins a bit easier.
\setlength{\hoffset}{-1in}
\setlength{\voffset}{-1in}

\newlength{\cam@topmargin}
\newlength{\cam@bottommargin}


%% Calculate and set the margins properly (with parameters that actually have
%% some meaning for everyday thesis-writers).
%%
%% @param	1	odd side margin (inner margin).
%% @param	2	even side margin (outer margin).
%% @param	3	top margin.
%% @param	4	bottom margin.
\DeclareRobustCommand{\cam@calcpaperdims}[4]{%
% MARGINS
% 'Top margin' is the distance between the top of the text and the top of the page.
% 'Bottom margin' is the distance between the bottom of the footer (the page number) and the bottom of the page.
\setlength{\oddsidemargin}{#1}        % inner margin
\setlength{\evensidemargin}{#2}       % outer margin
\setlength{\cam@topmargin}{#3}        % top margin        (the distance from the top of the page to the top of the body text -- the header is located between)
\setlength{\cam@bottommargin}{#4}     % bottom margin     (the distance from the bottom of the page to the bottom of the body text -- the footer is located between)
% Horizontal spacing
\setlength{\textwidth}{\paperwidth-#1-#2}     % text takes the remaining width (210 - inner - outer)

\setlength{\marginparwidth}{\evensidemargin-8mm} % the margin only has 'outer' space available, so we have to make it a bit thinner.
\setlength{\marginparsep}{3mm}

% Vertical spacing
\setlength{\headheight}{5mm}      % The height of the box where the heading text lives
\setlength{\headsep}{5mm}         % The distance between the heading and the top of the text
\setlength{\topmargin}{#3-\headheight-\headsep}

\setlength{\textheight}{\paperheight-#3-1.7\cam@bottommargin}   % text takes the remaining height (297 - top margin - bottom margin)
\setlength{\footskip}{.7\cam@bottommargin} % The distance from the bottom of the text to the bottom of the footer
}
\ifcam@techreport
\cam@calcpaperdims{25mm}{25mm}{20mm}{20mm}
\else
\cam@calcpaperdims{30mm}{20mm}{20mm}{20mm}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Fonts
%%
%%%%%

% Font recommended by the Computer Laboratory (Adobe Sabon).
% Note: You might need to install it first.
% \renewcommand\rmdefault{psb}

% Use the times font if the user selected this option.
\ifcam@times
    \RequirePackage{times}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Line spacing
%%
%%%%%

% One-and-a-half spacing (required by board of graduate studies).
% (Should remove this for Computer Laboratory technical report.)
\ifcam@techreport\else%
    \onehalfspacing%
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Variable definitions and default values: these variables should be defined by
%% the user (somewhere in the preamble). For example, to put the abstract into
%% the thesis, the thesis writer should type the following somewhere in the
%% preamble (before the `\begin{document}` or `\frontmatter` commands are
%% called):
%%
%%      \abstract{This is my abstract.}
%%
%% See below (in the comments starting with 'DOCVAR: ') for a list of all
% variables
%% the thesis writer is expected to use.
%%
%%%%%

% DOCVAR: abstract (The text that will be instered into the abstract of the
% thesis.)
\newcommand{\@abstract}{}
\renewcommand{\abstract}[1]{\renewcommand{\@abstract}{#1}}

% DOCVAR: acknowledgements (The text that will be instered into the
% acknowledgments of the thesis.)
\newcommand{\@acknowledgements}{}
\newcommand{\acknowledgements}[1]{\renewcommand{\@acknowledgements}{#1}}

% DOCVAR: college (The name of the thesis writer's college, which will appear
% just below their name.)
\newcommand{\@college}{}
\newcommand{\college}[1]{\renewcommand{\@college}{#1}}

% DOCVAR: keywords (These keywords will appear in the PDF meta-information
% called `pdfkeywords`.)
\newcommand{\@keywords}{}
\newcommand{\keywords}[1]{\renewcommand{\@keywords}{#1}}

% DOCVAR: subjectline (This subject will appear in the PDF meta-information
% called `pdfsubject`.)
\newcommand{\@subjectline}{}
\newcommand{\subjectline}[1]{\renewcommand{\@subjectline}{#1}}

% DOCVAR: submissiondate (The date of the submission of this thesis. If the
% submission date is provided, it will be printed on the title page--within the
% `submissionnotice` by default. Note that the thesis writer can provide their
% own `submissionnotice`, in which case it is up to them whether they will use
% this date in their notice.)
\newif\ifcam@submissiondate\cam@submissiondatefalse
\newcommand{\@submissiondate}{}
\newcommand{\submissiondate}[1]{\renewcommand{\@submissiondate}{#1}\cam@submissiondatetrue}

% DOCVAR: submissionnotice (The submission notice is shown on the bottom of the
% title page.)
\newcommand{\@submissionnotice}{%
\ifcam@firstyr
First year report submitted
\else
This dissertation is submitted
\fi
\ifcam@submissiondate
    on \@submissiondate{}
\fi
\ifcam@firstyr
in partial fulfilment of the requirements
\fi
for the degree of Doctor of Philosophy%
}
\newcommand{\submissionnotice}[1]{\renewcommand{\@submissionnotice}{#1}}

% DOCVAR: collegeshield (The name of the file that contains the image of the
% college's shield. If `collegeshield' is provided, it will be included in the
% title page (just below the author's name and above the name of the college).
\newif\ifcam@collegeshield\cam@collegeshieldfalse
\newcommand{\@collegeshield}{}
\newcommand{\collegeshield}[1]{\renewcommand{\@collegeshield}{#1}\cam@collegeshieldtrue}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Chapter and section numbering
%%
% TODO: Check whether numbering up to the fourth level is okay. It is not
% specified in the guidelines.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Page color for lower on-screen contrast
%%
\ifcam@screen
\definecolor{pcolor}{HTML}{FFF6D5}
\pagecolor{pcolor}
\renewcommand\familydefault{\sfdefault}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Front matter
%%
%% - outside and inside front cover
%% - title leaf
%% Do not include the date of make!
%% Institution + department.
%% Names of referees. (optional)
%% Degree.
%% Date of submission and defense. (optional)
%% Place and date of publication and publishers (and other info by them).
%%%%%
\newcommand{\frontmatter}{

\pagestyle{empty}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Title page components
%%
%%%%%
\ifcam@techreport
% Technical report mustn't have the custom title page (a standard one will be
% prepended by the editor, see http://www.cl.cam.ac.uk/techreports/submission.html).
\else
% The boxes below are all that will be displayed on the title page. They are
% used to calculate exactly how much space should be left between them
% (vertically).

%% LOGO box
\newlength{\cam@logorightnudge}
\setlength{\cam@logorightnudge}{-0.5\paperwidth+12mm}
\newsavebox{\cam@logo}
\begin{lrbox}{\cam@logo}
\hspace*{\cam@logorightnudge}\includegraphics[width=73mm]{CollegeShields/CUni}
\end{lrbox}

%% Sweet vinyl flames
\tikz[remember picture,overlay] \node[opacity=0.3] at (-3,3) {
  \begin{tikzpicture}[overlay]
    \ifcam@screen
    \shade[bottom color=orange, top color=yellow]
    \else
    \draw
    \fi
    (5.702474, -27.086517)
    .. controls(0.098010, -21.579464) and (3.701048, -20.466264) .. (1.083470, -14.025014)
    .. controls(2.242739, -15.694357) and (3.490671, -14.426828) .. (4.723270, -17.269702)
    .. controls(4.403177, -14.103225) and (0.474041, -10.882329) .. (0.908343, -8.670443)
    .. controls(2.005136, -11.850772) and (5.804890, -12.299849) .. (7.241650, -14.256029)
    .. controls(3.529134, -8.803655) and (3.184968, -5.770257) .. (1.862249, -1.794255)
    .. controls(3.554398, -4.217861) and (4.724399, -8.615377) .. (7.927626, -9.321477)
    .. controls(7.727601, -4.212868) and (10.350486, -3.493937) .. (10.978797, -0.644914)
    .. controls(11.872170, -3.496780) and (7.975352, -8.922770) .. (11.804121, -9.119821)
    .. controls(14.705375, -9.269136) and (16.369801, -4.959644) .. (18.361966, -2.104253)
    .. controls(16.600959, -5.737451) and (17.592149, -8.909370) .. (13.908305, -14.397782)
    .. controls(16.054904, -13.463868) and (16.352666, -13.188222) .. (19.274362, -9.576118)
    .. controls(18.501640, -12.313610) and (16.436827, -15.435455) .. (15.610451, -18.411632)
    .. controls(17.473589, -15.284188) and (17.556411, -16.690675) .. (19.217338, -15.450942)
    .. controls(15.700212, -22.596077) and (18.543002, -24.525189) .. (14.265477, -27.673594)
    .. controls(15.721856, -24.646868) and (14.177128, -20.701422) .. (13.074611, -19.269126)
    .. controls(13.175745, -22.447688) and (9.955380, -22.261096) .. (9.607497, -25.154502)
    .. controls(9.136463, -22.631720) and (6.592149, -21.790823) .. (8.445488, -19.294593)
    .. controls(6.142686, -20.782515) and (4.753245, -23.697295) .. (5.702474, -27.086517);
  \end{tikzpicture}
};

%% THESIS TITLE box
\newsavebox{\cam@title}
\begin{lrbox}{\cam@title}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
        	\begin{spacing}{2}
            	{\Huge%
                    \ifcam@times\else%
                        \bfseries%
                    \fi%
                 {\@title{}}%
                 \ifcam@firstyr\\%
                 {\emph{\LARGE PhD Proposal}}%
                 \fi}%
        	\end{spacing}
        \end{center}
    \end{minipage}
\end{lrbox}

%% COLLEGESHIELD box (optional):
\ifcam@collegeshield%
    \newsavebox{\cam@collegeshieldbox}
    \begin{lrbox}{\cam@collegeshieldbox}
    \includegraphics[height=20mm]{\@collegeshield}
    \end{lrbox}
\fi

%% AUTHOR&COLLEGE box
\newsavebox{\cam@authorcollege}
\begin{lrbox}{\cam@authorcollege}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
        {\large \@author{}}\\[1ex]
        \ifcam@collegeshield%
            \vspace{2mm}{\usebox{\cam@collegeshieldbox}}\\
        \fi
        \@college{}
        \end{center}
    \end{minipage}
\end{lrbox}

%% SUBMISSION NOTICE box
\newsavebox{\cam@submitnotice}
\begin{lrbox}{\cam@submitnotice}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
            \@submissionnotice{}
        \end{center}
    \end{minipage}
\end{lrbox}

% Now calculate the exact free vertical space
\newlength{\cam@titlepagevspace}
\setlength{\cam@titlepagevspace}{\textheight%
	-\totalheightof{\usebox{\cam@logo}}%
	-\totalheightof{\usebox{\cam@submitnotice}}%
	-\totalheightof{\usebox{\cam@authorcollege}}%
	-\totalheightof{\usebox{\cam@title}}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Title Page: Put the components (logo, title, author, college and submit
%% notice) onto the title page.
%%
%%%%%
\begin{center}
~\vspace{.02\cam@titlepagevspace}\\
{\usebox{\cam@logo}}\\
\vspace{.28\cam@titlepagevspace}
{\usebox{\cam@title}}\\
\vspace{.23\cam@titlepagevspace}
{\usebox{\cam@authorcollege}}\\
\null\vfill
{\usebox{\cam@submitnotice}}
\end{center}
\hypersetup{pdfsubject={\@subjectline},pdfkeywords={\@keywords}}
\fi

% Epigraph on odd page. (optional)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Abstract
%%
%%%%%
\ifcam@techreport%
    \setcounter{page}{3}
\fi

\ifcam@firstyr
% First yr report doesn't need a standalone abstract
\else

\chapter*{Abstract}
\thispagestyle{empty}
\@abstract{}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Declaration
%%
%%%%%
\ifcam@techreport
% Technical report doesn't need the declaration
% (see http://www.cl.cam.ac.uk/techreports/submission.html).
\else
\ifcam@firstyr
% First yr report doesn't need the declaration
\else
\chapter*{Declaration}
\thispagestyle{empty}
This dissertation is my own work and contains nothing which is the outcome of
work done in collaboration with others, except where specified in the text. This
dissertation is not substantially the same as any that I have submitted for a
degree or diploma or other qualification at any other university. This
dissertation does not exceed the prescribed limit of 60\,000 words.

% Leaving some space for the signature:
\vspace{15mm}

\begin{flushright}
\@author{}\\
\@date{}\\
\end{flushright}
\vfill
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Acknowledgements
%%
%%%%%

\ifcam@firstyr
% First yr report doesn't need the declaration
\else
\chapter*{Acknowledgements}
\thispagestyle{empty}
\@acknowledgements{}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Table of contents, figures, symbols and glossary.
%%
%%%%%

% The following command prevents the page number to be displayed on the first
% page of the TOC.
\addtocontents{toc}{\protect\thispagestyle{empty}}
\pagestyle{empty}
\tableofcontents{}

\ifcam@glossary%
    \cam@printthesisglossary
\fi

\cleardoublepage
\pagestyle{plain}
}

%%%%% EOF: cam-thesis.cls
