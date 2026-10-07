%----------------------------------------------------------------------------------------
%   Guidebook Template
%   LaTeX Class File
%----------------------------------------------------------------------------------------


%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{GuideBook}[2025/12/19 v1.0.0 Guidebook Template]

%----------------------------------------------------------------------------------------
%	LANGUAGE OPTIONS
%----------------------------------------------------------------------------------------

\def\guidebook@language{english}

\DeclareOption{english}{
	\def\guidebook@language{english}
}

% Page layout options
\def\guidebook@leftpage{even}
\def\guidebook@startpage{1}
\def\guidebook@listbefore{0pt}
\def\guidebook@columnsep{0.05\textwidth}
\def\guidebook@routeitemsep{0.003\textheight}
\def\guidebook@instructionitemsep{0.005\textheight}

% Bleed configuration
% Default bleed value (0.125in)
% Using only length register - can be used directly in \dimexpr and with \the in TikZ
\newlength{\guidebook@bleedlength}
\setlength{\guidebook@bleedlength}{0.125in}
\def\guidebook@guttermargin{0pt}
\def\guidebook@bleedimageratio{0.5} % Ratio defining how much of images should be in the bleed
% Temporary length registers for bleed calculations
\newlength{\guidebook@tempwidth}
\newlength{\guidebook@tempheight}
\newlength{\guidebook@scaledbleed} % For calculating scaled bleed based on bleedimageratio
\newlength{\guidebook@scaledbleedremainder} % For calculating the remainder of the bleed after the image ratio is applied

% Margin configuration
% Default margins for all sides
\def\guidebook@margintop{1.5cm}
\def\guidebook@marginbottom{1.5cm}
\def\guidebook@marginleft{1.5cm}
\def\guidebook@marginright{1.5cm}

% Boolean flag to track if bleed is enabled
\newif\ifguidebook@bleedenabled
\guidebook@bleedenabledfalse

% Boolean flag to track if bleed debug mode is enabled
\newif\ifguidebook@bleeddebug
\guidebook@bleeddebugfalse

% Left page option (key-value format: left=even or left=odd)
\DeclareOption{left=even}{\def\guidebook@leftpage{even}}
\DeclareOption{left=odd}{\def\guidebook@leftpage{odd}}

% Start page option (key-value format: startpage=1 or startpage=2)
\DeclareOption{startpage=1}{\def\guidebook@startpage{1}}
\DeclareOption{startpage=2}{\def\guidebook@startpage{2}}

% Bleed option (boolean: enables/disables bleed margins for print production)
% When enabled, uses \guidebook@bleedlength value (default: 0.125in)
\DeclareOption{bleed}{\guidebook@bleedenabledtrue}
% Bleed debug option: enables bleed and draws the bleed area boundaries
\DeclareOption{bleed=debug}{%
	\guidebook@bleedenabledtrue
	\guidebook@bleeddebugtrue
}

\DeclareOption*{%
	\PassOptionsToClass{\CurrentOption}{extbook}%
}

\ProcessOptions\relax

\LoadClass{extbook}

\setcounter{page}{\guidebook@startpage}

\RequirePackage[\guidebook@language]{babel}

%----------------------------------------------------------------------------------------
%	REQUIRED PACKAGES AND MISC CONFIGURATIONS
%----------------------------------------------------------------------------------------

\usepackage[english]{babel}
\usepackage{booktabs} % Professional table formatting with improved spacing
\usepackage{caption}
\usepackage{circledsteps}
\usepackage{etoolbox} % Conditional logic and command modification utilities
\usepackage[a4paper,left=9mm, right=9mm]{geometry}
\usepackage{graphicx}

\usepackage[xindy]{imakeidx}
\usepackage{multicol}
\usepackage{multido}
\usepackage{pgfplots}

\usepackage{wrapfig}
\usepackage[dvipsnames]{xcolor}
\usepackage{xstring}

%----------------------------------------------------------------------------------------
%	LANGUAGE STRINGS (using babel)
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	MARGINS AND BLEED
%----------------------------------------------------------------------------------------
% Remove paragraph indentations.
\setlength\parindent{0pt}

%----------------------------------------------------------------------------------------
%	FONTS
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	CUSTOM GRAPHICS
%----------------------------------------------------------------------------------------
\usepackage{tikz}

%----------------------------------------------------------------------------------------
%	CUSTOM COLORS
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	TEXT STYLING COMMANDS
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	COVER PAGE COMMAND
%----------------------------------------------------------------------------------------

% Cover page parameters
\define@key{cover}{title}{\def\cover@title{#1}}
\define@key{cover}{titlefontsize}{\def\cover@titlefontsize{#1}}
\define@key{cover}{subtitle}{\def\cover@subtitle{#1}}
\define@key{cover}{subtitlefontsize}{\def\cover@subtitlefontsize{#1}}
\define@key{cover}{author}{\def\cover@author{#1}}
\define@key{cover}{authorfontsize}{\def\cover@authorfontsize{#1}}
\define@key{cover}{textcolor}{\def\cover@textcolor{#1}}
\define@key{cover}{shadowcolor}{\def\cover@shadowcolor{#1}}
\define@key{cover}{shadowoffset}{\def\cover@shadowoffset{#1}}
\define@key{cover}{image}{\def\cover@image{#1}}
\define@key{cover}{opacity}{\def\cover@opacity{#1}}
\define@key{cover}{bgcolor}{\def\cover@bgcolor{#1}}

% Cover page commands
\NewDocumentCommand{\cover@init}{}{%
	\def\cover@title{}
	\def\cover@titlefontsize{\fontsize{48pt}{52pt}}
	\def\cover@subtitle{}
	\def\cover@subtitlefontsize{\fontsize{28pt}{30pt}}
	\def\cover@author{}
	\def\cover@authorfontsize{\fontsize{20pt}{22pt}}
	\def\cover@textcolor{darkgrey}
	\def\cover@shadowcolor{black}
	\def\cover@shadowoffset{0.05cm}
	\def\cover@image{}
	\def\cover@opacity{1}
	\def\cover@bgcolor{}
}


% Create a cover page
\NewDocumentCommand{\makecoverpage}{+m}{%
	% Initialize cover properties with defaults
	\cover@init

	% Process the key-value pairs
	\setkeys{cover}{#1}

	% Set flag to suppress page numbers on cover page
	\nopagenumberstyletrue

	% Set page counter before titlepage to ensure hyperref tracks it correctly
	\setcounter{page}{\cookbook@startpage}
	\phantomsection
	\label{coverpage}
	\begin{titlepage}
		\thispagestyle{empty}
		\noindent
		\begin{adjustwidth}{\cookbook@bleedextension}{\cookbook@bleedextension}% Extend to page edges including bleed
			\begin{tikzpicture}[remember picture, overlay]
				% Background color
				\ifx\cover@bgcolor\@empty\else
					\fill[\cover@bgcolor]
					(current page.south west) rectangle (current page.north east);
				\fi

				% Add cover image if provided
				\ifx\cover@image\@empty\else
					\begin{scope}
						% Extend image into bleed area
						\ifcookbook@bleedenabled
							\clip ([xshift=\cookbook@scaledbleed,yshift=\cookbook@scaledbleed]current page.south west) rectangle ([xshift=-\cookbook@scaledbleed,yshift=-\cookbook@scaledbleed]current page.north east);
							\path[fill overzoom image={\cover@image},fill image opacity={\cover@opacity}]
							($(current page.south west)+(\the\cookbook@scaledbleed,\the\cookbook@scaledbleed)$)
							rectangle
							($(current page.north east)-(\the\cookbook@scaledbleed,\the\cookbook@scaledbleed)$);
						\else
							\clip (current page.south west) rectangle (current page.north east);
							\path[fill overzoom image={\cover@image},fill image opacity={\cover@opacity}]
							(current page.south west)
							rectangle
							(current page.north east);
						\fi
					\end{scope}
				\fi

				% Add title and subtitle with drop shadow for visibility
				% First draw the shadow (offset behind the text)
				\node[text=\cover@shadowcolor, font=\sourcesanspro\bfseries,
					align=center] at ($(current page.center)+(\cover@shadowoffset,-\cover@shadowoffset)$) {
					{\cover@titlefontsize\selectfont\MakeUppercase{\cover@title}}
					\\[20pt]
					\ifx\cover@subtitle\@empty
					\\[10pt]
					\else
					{\cover@subtitlefontsize\selectfont\cover@subtitle}
					\\[20pt]
					\fi
					{\cover@authorfontsize\selectfont\cover@author}
				};
				% Then draw the actual text on top
				\node[text=\cover@textcolor, font=\sourcesanspro\bfseries,
					align=center] at (current page.center) {
					{\cover@titlefontsize\selectfont\MakeUppercase{\cover@title}}
					\\[20pt]
					\ifx\cover@subtitle\@empty
					\\[10pt]
					\else
					{\cover@subtitlefontsize\selectfont\cover@subtitle}
					\\[20pt]
					\fi
					{\cover@authorfontsize\selectfont\cover@author}
				};
			\end{tikzpicture}
		\end{adjustwidth}
	\end{titlepage}
	\clearpage
	\nopagenumberstylefalse % Clear flag after cover page
}
%----------------------------------------------------------------------------------------
%	TABLE OF CONTENTS
%----------------------------------------------------------------------------------------
% Set the TOC's name to "Table of Contents" instead of "Contents"
\setlocalecaption{english}{contents}{Table of Contents}

% change the 50pt vertical skip to 0pt.
\makeatletter
\patchcmd{\@makeschapterhead}{\vspace*{50\p@}}{\vspace*{0\p@}}{}{}
\makeatother

%----------------------------------------------------------------------------------------
%	AREA ENVIRONMENT COMMANDS
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	CRAG ENVIRONMENT COMMANDS
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	ROUTE ENVIRONMENT COMMANDS
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	INDEX
%----------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------
%	HYPERREF AND BOOKMARK (load at the end to fix TOC links)
%----------------------------------------------------------------------------------------

% Load hyperref as the last package to avoid conflicts
\usepackage[hidelinks]{hyperref}
