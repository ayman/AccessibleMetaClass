% File: meta.cls v1.0
% This class file provides basic functionality for producing
% PDFs that work with the accessibility" package and LaTeX2rtf%

% -------------------------------------------------------------
% Identification Part
% -------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{meta}
\typeout{ }
\typeout{meta.cls -- v1.0, April 2013}
\typeout{Provides multiple formatting options and works with latex2rtf}
\typeout{ }

% -------------------------------------------------------------
% Create Options
% -------------------------------------------------------------
% PDF properties
\pdfinterwordspaceon
\pdfminorversion=8

\RequirePackage{xifthen}

% Mark as draft
\newboolean{IsDraft}
\setboolean{IsDraft}{false}

% print links in black
\newboolean{blacklinks}
\setboolean{blacklinks}{true}

% memoir, book, report, article?
\newboolean{IsMemoir}
\setboolean{IsMemoir}{false}
\newboolean{IsBook}
\setboolean{IsBook}{false}
\newboolean{IsReport}
\setboolean{IsReport}{false}
\newboolean{IsArticle}
\setboolean{IsArticle}{false}

% do we have chapters?
\newboolean{HasChapters}
\setboolean{HasChapters}{false}

% tagged?
\newboolean{IsTagged}
\setboolean{IsTagged}{false}

% -------------------------------------------------------------
% Check for choice of package and formatting options
% -------------------------------------------------------------

% look out for draft
\DeclareOption{draft}{
	\setboolean{IsDraft}{true}
	\typeout{Formatting as draft}
	}
% book, report, article?
\DeclareOption{memoir}{
	\setboolean{IsMemoir}{true}
	\def\meta@class{memoir}
	}
\DeclareOption{book}{
	\setboolean{IsBook}{true}
	\setboolean{HasChapters}{true}
	\def\meta@class{book}
	\typeout{Using modified book class}
	}
\DeclareOption{report}{
	\setboolean{IsReport}{true}
	\setboolean{HasChapters}{true}
	\def\meta@class{report}
	\typeout{Using modified report class}
	}
\DeclareOption{article}{
	\setboolean{IsArticle}{true}
	\setboolean{HasChapters}{false}
	\def\meta@class{article}
	\typeout{Using modified article class}
	}
\DeclareOption{tagged}{
	\setboolean{IsTagged}{true}
	\typeout{PDF will be tagged}
	}

% -------------------------------------------------------------
% Process Options
% -------------------------------------------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\meta@class}}
\ExecuteOptions{12pt}
\ProcessOptions\relax
\LoadClass{\meta@class}

% -------------------------------------------------------------
% Package Loading
% -------------------------------------------------------------
% NAG: check for outdated packages
\RequirePackage[2tabu, orthodox]{nag}

% GEOMETRY: set page size
\RequirePackage[head=0.125in,top=1.5in,bottom=1in,inner=1in,outer=1in]{geometry}

% MATHPTMX Times for roman text and math (family ptm)
\RequirePackage{mathptmx}

% Helvetica for sans serif (family phv)
\RequirePackage{helvet}

% Courier for typewriter font (family pcr)
\RequirePackage{courier}

% ams math
\RequirePackage{amsfonts,amssymb,amsmath}

% gensymb. Required for degrees symbol
\RequirePackage{gensymb}

% better tables
\RequirePackage{booktabs}

% graphics
% can set the option 'final' to override 'draft' status
\RequirePackage{graphicx}

% For formatting the bibliography
\RequirePackage[sort]{natbib}

% use fonts of type T1
\RequirePackage[T1]{fontenc}

% colours
\RequirePackage{color}
\RequirePackage{xcolor}
\definecolor{prettyblue}{RGB}{0, 121, 193}

% set languages
\RequirePackage[english]{babel}
    \addto{\captionsenglish}{\renewcommand{\bibname}{References}}
    \addto\captionsenglish{\renewcommand{\contentsname}{Table of Contents}}

% enable subfigures
\RequirePackage{subfigure}

% To stop hyphenation in titles etc
\RequirePackage{hyphenat}

% spacing
\RequirePackage{setspace}
\RequirePackage{parskip}

% to-do notes
\RequirePackage{todonotes}

% code listings
\RequirePackage{listings}
  
% --------------
% Main Code
% --------------

% Default is ragged right.
% Load ragged2e so \justifying and environment justify are available.
% Redefines \centering, \raggedleft, and \raggedright, and environments center flushleft and flushright to use versions made by ragged2e. Sets default alignment to ragged right. To override, use the command \justifying or the environment justify.
\RequirePackage[newcommands,document]{ragged2e}

%This changes parindent to 0
\setlength{\RaggedRightRightskip}{0pt plus 3em}

% -------------------------------------------
% Changes to TOC and list of figures/tables
% -------------------------------------------

\ifthenelse{\NOT \boolean{IsMemoir}}{  % not memoir class

	% improved table of contents and list of figures/tables
	\RequirePackage[subfigure]{tocloft}

	% remove numbering on bibliography but still allow in TOC
	\RequirePackage[nottoc, notlot, notlof]{tocbibind}

	% add Figure before # and a period after
	\renewcommand{\cftfigfont}{\fontfamily{phv} Figure }
	\renewcommand{\cfttabfont}{\fontfamily{phv} Table }
	\renewcommand{\cftfigaftersnum}{.}
	\renewcommand{\cfttabaftersnum}{.}

	% title font
	\ifthenelse{\boolean{HasChapters}}{
		\renewcommand{\cfttoctitlefont}{\color{prettyblue} \raggedright  \Large\sffamily\bfseries}
		\renewcommand{\cftloftitlefont}{\color{prettyblue} \raggedright  \Large\sffamily\bfseries}
		\renewcommand{\cftlottitlefont}{\color{prettyblue} \raggedright  \Large\sffamily\bfseries}

	}{ % no chapters (section has a smaller font size)
		\renewcommand{\cfttoctitlefont}{\color{prettyblue} \raggedright  \fontsize{12}{14}\sffamily\bfseries}
		\renewcommand{\cftloftitlefont}{\color{prettyblue} \raggedright  \fontsize{12}{14}\sffamily\bfseries}
		\renewcommand{\cftlottitlefont}{\color{prettyblue} \raggedright  \fontsize{12}{14}\sffamily\bfseries}
	}

	% add dotfill in toc
	\ifthenelse{\boolean{HasChapters}}{
		\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
	}{
		\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
	}

	% remove indentation
	\setlength{\cftfigindent}{0pt}
	\setlength{\cftsubfigindent}{0pt}
	\setlength{\cfttabindent}{0pt}
	\setlength{\cftsubtabindent}{0pt}

	% don't add extra spaces in list of figures between chapters
	\newcommand*{\noaddvspace}{\renewcommand*{\addvspace}[1]{}}
	\addtocontents{lof}{\protect\noaddvspace}
	\addtocontents{lot}{\protect\noaddvspace}
	\setlength{\cftbeforefigskip}{5pt}
	\setlength{\cftbeforetabskip}{5pt}
	\setlength{\cftaftertoctitleskip}{\baselineskip}
	\setlength{\cftafterloftitleskip}{\baselineskip}
	\setlength{\cftafterlottitleskip}{\baselineskip}

}{  % else IsMemoir

	% add Figure before # and a period after
	\renewcommand{\cftfigurefont}{\fontfamily{phv} Figure }
	\renewcommand{\cfttablefont}{\fontfamily{phv} Figure }
	\renewcommand{\cftfigureaftersnum}{.}
	\renewcommand{\cfttableaftersnum}{.}

	% title font
	\renewcommand{\printtoctitle}[1]{\color{prettyblue} \raggedright  \Large\sffamily\bfseries #1}
	\renewcommand{\printloftitle}[1]{\color{prettyblue} \raggedright  \Large\sffamily\bfseries #1}
	\renewcommand{\printlottitle}[1]{\color{prettyblue} \raggedright  \Large\sffamily\bfseries #1}
	% \renewcommand{\bibname}{\color{prettyblue} \raggedright  \Large\sffamily\bfseries Bibliography}

	% remove indentation
	\setlength{\cftsectionindent}{0pt}
	\setlength{\cftsubsectionindent}{2em}
	\setlength{\cftfigureindent}{0pt}
	\setlength{\cfttableindent}{0pt}

	% additional spacing
	\setlength{\cftbeforefigureskip}{5pt}
	\setlength{\cftbeforetableskip}{5pt}
}


% -------------------------------------------
% Changes to the chapter and section markings
% -------------------------------------------
% Assign numbers to headings chapter through subparagraph
\ifthenelse{\boolean{IsMemoir}}{% True (memoir)
	\setsecnumdepth{subsubsection}
	\maxtocdepth{subparagraph}
	}{% False (other classes)
	\setcounter{secnumdepth}{5}
	\setcounter{tocdepth}{5}
	}

% Chapter Headings
\ifthenelse{\boolean{HasChapters}}{% True
	\renewcommand{\@makechapterhead}[1]{%
	{\color{prettyblue} \parindent \z@ \raggedright \normalfont \interlinepenalty\@M
	\ifnum \c@secnumdepth >\m@ne
		\fontfamily{phv} \fontsize{14}{20}\fontseries{b}\selectfont
		\thechapter \hspace*{1em}#1
		\else
		\fontfamily{phv} \fontsize{14}{20}\fontseries{b}\selectfont #1
	\fi
	\par\nobreak
	\vspace*{12pt}}}

\renewcommand{\@makeschapterhead}[1]{%
	{\color{prettyblue} \parindent \z@ \raggedright \normalfont \interlinepenalty\@M
	\Large\sffamily\bfseries #1
	\par\nobreak
	\vspace*{12pt}}}
	}{% False
	}

% Section Headings
\renewcommand{\section}{%
	\@startsection{section}{1}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\color{prettyblue}\fontfamily{phv}\fontsize{12}{14}\fontseries{b}\selectfont}}
\renewcommand{\subsection}{%
	\@startsection{subsection}{2}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\color{prettyblue}\sffamily\normalsize\bfseries\slshape}}
\renewcommand{\subsubsection}{%
	\@startsection{subsubsection}{3}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\color{prettyblue}\sffamily\normalsize\itshape}}
\renewcommand{\paragraph}{%
	\@startsection{paragraph}{4}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\bfseries\normalsize}}
\renewcommand{\subparagraph}{%
	\@startsection{subparagraph}{5}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\bfseries\normalsize\itshape}}

% change the formatting of the TOC heading
\ifthenelse{\boolean{IsMemoir}}{%True
	\def\chapterheadstart{}
	\renewcommand\printtoctitle[1]{%
		\parindent \z@ \raggedright \normalfont \interlinepenalty\@M
		\fontfamily{phv} \fontsize{14}{20} \fontseries{b}\selectfont #1}
	\def\afterchaptertitle{%
		\par\nobreak
		\vspace*{12pt}}
	}{% False
	}

% To harmonise the font sizes
\ifthenelse{\boolean{IsMemoir}}{% True
	\renewcommand{\chapnumfont}{\chaptitlefont}
	\renewcommand{\chapnamefont}{\chaptitlefont}
	}{% False
	}

% use dots as the separator
\ifthenelse{\boolean{IsMemoir}}{% True
	\renewcommand*{\cftchapterdotsep}{\cftdotsep}
	}{% False
	}

% inherit fonts etc from TOC
\let\printlottitle\printtoctitle
\let\printloftitle\printtoctitle

% Format Captions
\RequirePackage[format=plain,
	labelformat=simple,
	font={small,sf,bf},
	labelfont={small,sf,bf},
	textfont={small,sf,bf},
	indention=0cm,
	labelsep=period,
	justification=centering,
	singlelinecheck=true,
	tableposition=top,
	figureposition=bottom]{caption}


% number continuously across chapters
\ifthenelse{\boolean{HasChapters}}{
	\RequirePackage{chngcntr}
	\counterwithout{figure}{chapter}
	\counterwithout{table}{chapter}
}

% Create some figure and table caption styles that are narrower than textwidth. These look better with small floats.
\DeclareCaptionStyle{narrow}{width=4.5in,
							labelsep=period,
							font={sf,normalsize},
							labelfont=bf,
							format=plain}

% Indenting and spacing between paragraphs
\setlength{\parindent}{0pt}
\ifthenelse{\boolean{IsMemoir}}{% True
	\nonzeroparskip
	}{% False
	}

%-----------------------
% GENERAL CODE
%-----------------------
% Require at least 3 characters before a hyphenation.
\lefthyphenmin=3

% Don't hyphenate the months (or any proper noun---other proper nouns must be addressed in the tex file
\hyphenation{January February April July August September October December Department Energy National Renewable Laboratory Washington Colorado Standard}

% Enumerate list environment -- change the default numbering to match our style
\renewcommand{\theenumi}{\arabic{enumi}}
\renewcommand{\theenumii}{\Alph{enumii}}
\renewcommand{\theenumiii}{\roman{enumiii}}
\renewcommand{\theenumiv}{\alph{enumiv}}
\renewcommand{\labelenumi}{\theenumi.}
\renewcommand{\labelenumii}{\theenumii.}
\renewcommand{\labelenumiii}{\theenumiii.}
\renewcommand{\labelenumiv}{\theenumiv)}

% Draft mode
\ifthenelse{\boolean{IsDraft}}{ % tue
	\RequirePackage{draftwatermark}
	\SetWatermarkAngle{60}
	\SetWatermarkLightness{0.875}
	\SetWatermarkFontSize{6cm}
	\setboolean{blacklinks}{false}
	}{% False
	}

% Add .pdf links
\ifthenelse{\boolean{blacklinks}}{% True
	\RequirePackage[unicode, pdfa, final, linktocpage, colorlinks, linktoc=all, linkcolor=black, citecolor=black, menucolor=black, urlcolor=black, pdfborder={0 0 0}, unicode]{hyperref}
	}{% False
	\RequirePackage[unicode, pdfa, final, linktocpage, colorlinks, linktoc=all, linkcolor=blue, citecolor=blue, menucolor=blue, urlcolor=blue, pdfborder={0 0 0},unicode]{hyperref}
	}
\RequirePackage{cmap}

% Enable tooltips
\RequirePackage[linewidth = 1]{pdfcomment}

\ifthenelse{\boolean{IsMemoir}}{ % for some reason this is overridden from above so need to define at end
	\renewcommand{\printtoctitle}[1]{\color{prettyblue} \raggedright  \Large\sffamily\bfseries #1}
	\renewcommand{\printloftitle}[1]{\color{prettyblue} \raggedright  \Large\sffamily\bfseries #1}
	\renewcommand{\printlottitle}[1]{\color{prettyblue} \raggedright  \Large\sffamily\bfseries #1}
}

% CODE / VERBATIM
\@ifundefined{lstlisting}{}{%
  \let\verbatim\relax%
  \lstnewenvironment{verbatim}{\lstset{language=[LaTeX]TeX,                     % the language of the code
  basicstyle=\small\sffamily,
  numbers=left,                   % where to put the line-numbers
  numberstyle=\tiny\color{gray},  % the style that is used for the line-numbers
  stepnumber=1,                   % the step between two line-numbers. If it's 1, each line will be numbered
  numbersep=5pt,                  % how far the line-numbers are from the code
  backgroundcolor=\color{white},  % choose the background color. You must add \usepackage{color}
  showspaces=false,               % show spaces adding particular underscores
  showstringspaces=false,         % underline spaces within strings
  breaklines=true,                % sets automatic line breaking
  breakatwhitespace=true,        % sets if automatic breaks should only happen at whitespace
  keywordstyle=\color{blue},      % keyword style
  commentstyle=\color{gray},   % comment style
  stringstyle=\color{green},      % string literal style
  escapeinside={\%*}{*)},         % if you want to add a comment within your code
  morekeywords={*,...}}%            % if you want to add more keywords to the set
}{}%
}

%% ACCESSIBILITY
\ifthenelse{\boolean{IsTagged}}{% True
	\RequirePackage[tagged]{accessibility_meta}
	}{ %else
	% nothing
}

%% THINGS WE NEED TO DO AT THE START OF THE DOCUMENT
\AtBeginDocument{
	\makeatletter
	\hypersetup{
		pdftitle = {\@title},
		pdfauthor = {\@author}
	}
	\makeatother
	\maketitle
	\clearpage	
}


% end of file