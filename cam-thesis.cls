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

% MARGINS
\setlength{\oddsidemargin}{35mm}        % inner margin
\setlength{\evensidemargin}{30mm}       % outer margin
\setlength{\cam@topmargin}{35mm}        % top margin        (the distance from the top of the page to the top of the body text -- the header is located between)
\setlength{\cam@bottommargin}{45mm}     % bottom margin     (the distance from the bottom of the page to the bottom of the body text -- the footer is located between)

% TODO: Shouldn't the 'top margin' rather indicate the distance between the top of the header and the top of the page?
% TODO: Shouldn't the 'bottom margin' rather indicate the distance between the bottom of the footer and the bottom of the page?

% Calculate the lengths for the rest of the page
\DeclareRobustCommand{\cam@calcpaperdims}[4]{%
% Horizontal spacing
\setlength{\textwidth}{\paperwidth}     % text takes the remaining width (210 - inner - outer)
\addtolength{\textwidth}{-#1}
\addtolength{\textwidth}{-#2}

\setlength{\marginparwidth}{\evensidemargin} % the margin only has 'outer' space available, so we have to make it a bit thinner.
\addtolength{\marginparwidth}{-8mm}
\setlength{\marginparsep}{3mm}

% Vertical spacing
\setlength{\headheight}{5mm}      % The height of the box where the heading text lives
\setlength{\headsep}{5mm}         % The distance between the heading and the top of the text
\setlength{\topmargin}{#3}
\addtolength{\topmargin}{-\headheight}
\addtolength{\topmargin}{-\headsep}

\setlength{\textheight}{\paperheight}   % text takes the remaining height (297 - top margin - bottom margin)
\addtolength{\textheight}{-#3}
\addtolength{\textheight}{-#4}
\setlength{\footskip}{.5#4} % The distance from the bottom of the text to the bottom of the footer
}
\cam@calcpaperdims{\oddsidemargin}{\evensidemargin}{\cam@topmargin}{\cam@bottommargin}

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
{\huge \@title{}}
\end{lrbox}

%% AUTHOR&COLLEGE box
\newsavebox{\cam@authorcollege}
\begin{lrbox}{\cam@authorcollege}
    \begin{minipage}[c][\height][c]{\textwidth}
        \begin{center}
        {\large \@author{}}\\
        \@college{}
        \end{center}
    \end{minipage}
\end{lrbox}

%% SUBMISSION NOTICE box
\newsavebox{\cam@submitnotice}
\begin{lrbox}{\cam@submitnotice}
    \begin{minipage}[c][\height][c]{\textwidth}
        \begin{center}
            A thesis submitted for the Degree of Doctor of Philosophy
        \end{center}
    \end{minipage}
\end{lrbox}

% Now calculate the exact free vertical space
\newlength{\cam@titlepagevspace}
% The actual calculation:
\newlength{\cam@tmplen}
\setlength{\cam@titlepagevspace}{\textheight}
\settoheight{\cam@tmplen}{\usebox{\cam@logo}}\addtolength{\cam@titlepagevspace}{-\cam@tmplen}
\settoheight{\cam@tmplen}{\usebox{\cam@title}}\addtolength{\cam@titlepagevspace}{-\cam@tmplen}
\settoheight{\cam@tmplen}{\usebox{\cam@authorcollege}}\addtolength{\cam@titlepagevspace}{-\cam@tmplen}
\settoheight{\cam@tmplen}{\usebox{\cam@submitnotice}}\addtolength{\cam@titlepagevspace}{-5\cam@tmplen}


\begin{center}
~\vspace{.02\cam@titlepagevspace}\\
\usebox{\cam@logo}\\
\vspace{.23\cam@titlepagevspace}
\usebox{\cam@title}\\
\vspace{.25\cam@titlepagevspace}
\usebox{\cam@authorcollege}\\
\vspace{.37\cam@titlepagevspace}
\usebox{\cam@submitnotice}
\null\vfill
\end{center}

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

\pagestyle{plain}
}

%%%%% EOF: cam-thesis.cls
