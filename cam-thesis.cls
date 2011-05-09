%%%%%
%%
%% Class ``cam-thesis''
%%
%% Version: v0.2
%% Authors: Jean Martina, Rok Strnisa, Matej Urbas
%% Date: 30/07/2008
%%
%% Copyright (c) 2008-2011, Rok Strniša, Jean Martina, Matej Urbas
%% License: Simplified BSD License
%% License file: ./License
%% Original License URL: http://www.freebsd.org/copyright/freebsd-license.html
%%%%%

%%%%%
%%
%% Class identification.
%%
%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cam-thesis}[2008/07/30]

\typeout{}
\typeout{***********************************************}
\typeout{***********************************************}
\typeout{}

%%%%%
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

%%%%%
%%
%% Declared options.
%%
%%%%%

%%%%%
%%
%% Using report class as base.
%%
%%%%%
\PassOptionsToClass{a4paper,12pt,twoside,openright}{report}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass{report}

%%%%%
%%
%% Additional packages, and their options.
%%
%%%%%
\RequirePackage{amsmath,amssymb,amsthm,graphicx,makeidx,times}
\makeindex
\usepackage[pdffitwindow=true,colorlinks=true,linkcolor=black,citecolor=black,urlcolor=black]{hyperref}
\usepackage[all]{hypcap}


%%%%%
%%
%% Page margins (suitable for J.S. Wilson & Son).
%%
%%%%%
\setlength{\oddsidemargin}{4.6mm}  % 30 mm left margin
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\textwidth}{150.8mm}    % 20 mm right margin
\setlength{\topmargin}{-5.4mm}     % 20 mm top margin
\setlength{\headheight}{5mm}
\setlength{\headsep}{5mm}
\setlength{\footskip}{10mm}
\setlength{\textheight}{237mm}     % 20 mm bottom margin


% Font recommended by the Computer Laboratory (Adobe Sabon).
% Note: You might need to install it first.
%\renewcommand{\rmdefault}{psb}

% One-and-a-half spacing (required by board of graduate studies).
% (Should remove this for Computer Laboratory technical report.)
\renewcommand{\baselinestretch}{1.2}

%%%%%
%%
%% Variable definitions and default values.
%%
%%%%%

\newcommand{\@college}{}
\newcommand{\college}[1]{\renewcommand{\@college}{#1}}
\newcommand{\@abstract}{}
\renewcommand{\abstract}[1]{\renewcommand{\@abstract}{#1}}
\newcommand{\@acknowledgements}{}
\newcommand{\acknowledgements}[1]{\renewcommand{\@acknowledgements}{#1}}

%%%%%
%%
%% First page.
%%
%
%% FRONT MATTER:
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

\begin{center}
~\vspace{2.5cm}\\
\includegraphics[width=73mm]{CUni}\\
\vspace{4cm}
{\huge \@title{}}\\
\vspace{4cm}
{\large \@author{}}\\
\@college{}\\
\vspace{6.5cm}
A thesis submitted for the Degree of Doctor of Philosophy
\end{center}
\pagestyle{empty}

% Epigraph on odd page. (optional)

\chapter*{Abstract}
\thispagestyle{empty}
\@abstract{}

\chapter*{Declaration}
\thispagestyle{empty}
This thesis:
\begin{itemize}
\item is my own work and contains nothing which is the outcome of work done in
  collaboration with others, except where specified in the text;
\item is not substantially the same as any that I have submitted for a degree or
  diploma or other qualification at any other university; and
\item does not exceed the prescribed limit of 60,000 words.
\end{itemize}
\begin{flushright}
\@author{}\\
\@date{}\\
\end{flushright}
\vfill


\chapter*{Acknowledgements}
\thispagestyle{empty}
\@acknowledgements{}

\tableofcontents{}
% - list of figures (optional)
% - list of symbols (optional)
% - glossary (optional)
}

%%%%% EOF: cam-thesis.cls
