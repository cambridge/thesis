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
%% General guidelines on which this class is based:
%%
%%     http://www.cl.cam.ac.uk/local/phd/typography/
%%     http://www.admin.cam.ac.uk/offices/gradstud/exams/submission/phd/format.html
%%
%%%%%


%%%%%
%%
%% Class identification.
%%
%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cam-thesis}[2008/07/30 University of Cambridge thesis class]

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
%% Package options (see README.markdown for a list of options with
%% 					descriptions)
%%
%%%%%

\newif\ifcam@techreport\cam@techreportfalse
\DeclareOption{techreport}{\cam@techreporttrue}


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
% TODO: Add an option to not use any non-essential packages
% TODO: Add an option to not use the 'times' font.
\RequirePackage{amsmath}    % Not essential
\RequirePackage{amssymb}    % Not essential
\RequirePackage{amsthm}     % Not essential
\RequirePackage{graphicx}   % Required for the UC Logo (on the title page)
\RequirePackage{makeidx}    % Not essential
\RequirePackage{times}      % Not essential
\makeindex
\RequirePackage[pdffitwindow=true,colorlinks=true,linkcolor=black,citecolor=black,urlcolor=black]{hyperref} % Not essential
\RequirePackage[all]{hypcap} % Not essential
\RequirePackage{calc}      	% Used for calculating margins and laying out the title page
\RequirePackage{setspace}      	% Used for calculating margins and laying out the title page


%%%%%
%%
%% Page margins (suitable for J.S. Wilson & Son).
%%
%%%%%

% Setting the offsets to 'zero' (LaTeX calculates offsets 1in from the left and upper edges of the page) makes the calculation of margins a bit easier.
\setlength{\hoffset}{-1in}
\setlength{\voffset}{-1in}

\newlength{\cam@topmargin}
\newlength{\cam@bottommargin}

%%%%
%% Calculate the lengths for the rest of the page.
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
\cam@calcpaperdims{35mm}{30mm}{35mm}{25mm}
\fi

%%%%%
%%
%% Fonts
%%
%%%%%

% Font recommended by the Computer Laboratory (Adobe Sabon).
% Note: You might need to install it first.
%\renewcommand{\rmdefault}{psb}


%%%%%
%%
%% Line spacing
%%
%%%%%

% One-and-a-half spacing (required by board of graduate studies).
% (Should remove this for Computer Laboratory technical report.)
% TODO: Add an option, which checks whether our document is a technical report.
\ifcam@techreport
\else
\onehalfspacing%
\fi


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

%%%%%
%%
%% Title page
%%
%%%%%

% The boxes below are all that will be displayed on the title page. They are
% used to calculate exactly how much space should be left between them
% (vertically).

%% LOGO box
\newsavebox{\cam@logo}
\begin{lrbox}{\cam@logo}
\includegraphics[width=73mm]{CUni}
\end{lrbox}

%% THESIS TITLE box
\newsavebox{\cam@title}
\begin{lrbox}{\cam@title}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
        	\begin{spacing}{2}
            	{\huge \@title{}}
        	\end{spacing}
        \end{center}
    \end{minipage}
\end{lrbox}

%% AUTHOR&COLLEGE box
\newsavebox{\cam@authorcollege}
\begin{lrbox}{\cam@authorcollege}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
        {\large \@author{}}\\[1ex]
        \@college{}
        \end{center}
    \end{minipage}
\end{lrbox}

%% SUBMISSION NOTICE box
\newsavebox{\cam@submitnotice}
\begin{lrbox}{\cam@submitnotice}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
            A thesis submitted for the Degree of Doctor of Philosophy
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

%% Put the logo, title, author, college and submit notice onto the title page
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

% Epigraph on odd page. (optional)

%%%%%
%%
%% Abstract
%%
%%%%%

\chapter*{Abstract}
\thispagestyle{empty}
\@abstract{}

%%%%%
%%
%% Declaration
%%
%%%%%

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

%%%%%
%%
%% Acknowledgements
%%
%%%%%

\chapter*{Acknowledgements}
\thispagestyle{empty}
\@acknowledgements{}

%%%%%
%%
%% Table of contents
%%
%%%%%

\tableofcontents{}
% - list of figures (optional)
% - list of symbols (optional)
% - glossary (optional)

\pagestyle{plain}
}

%%%%% EOF: cam-thesis.cls
