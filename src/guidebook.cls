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

\setlength{\parindent}{0pt}

\usepackage{changepage} % Dynamic page margin and text block indentation
\usepackage{fancyhdr} % Customizable headers and footers

\usepackage{eso-pic} % Background images and page decorations
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

% Commands to override margin values (call after \documentclass)
% Usage: \setmargintop{2cm}, \setmarginbottom{2cm}, \setmarginleft{2cm}, \setmarginright{2cm}
\NewDocumentCommand{\setmargintop}{m}{%
	\def\guidebook@margintop{#1}%
	\geometry{top=#1}%
}
\NewDocumentCommand{\setmarginbottom}{m}{%
	\def\guidebook@marginbottom{#1}%
	\geometry{bottom=#1}%
}
\NewDocumentCommand{\setmarginleft}{m}{%
	\def\guidebook@marginleft{#1}%
	\if@twoside
		\geometry{inner=#1}%
	\else
		\geometry{left=#1}%
	\fi
}
\NewDocumentCommand{\setmarginright}{m}{%
	\def\guidebook@marginright{#1}%
	\if@twoside
		\geometry{outer=#1}%
	\else
		\geometry{right=#1}%
	\fi
}

% Store original paper dimensions before bleed is applied
\newlength{\guidebook@origpaperwidth}
\newlength{\guidebook@origpaperheight}

% Helper command to apply bleed geometry adjustments
\NewDocumentCommand{\guidebook@applybleedgeometry}{}{%
	% FIRST: Store original paper dimensions BEFORE any changes
	\setlength{\guidebook@origpaperwidth}{\paperwidth}%
	\setlength{\guidebook@origpaperheight}{\paperheight}%

	% Calculate new paper dimensions
	\setlength{\guidebook@tempwidth}{\dimexpr\paperwidth+2\guidebook@bleedlength\relax}%
	\setlength{\guidebook@tempheight}{\dimexpr\paperheight+2\guidebook@bleedlength\relax}%
	% Expand dimension values to strings
	\edef\guidebook@paperwidthval{\the\guidebook@tempwidth}%
	\edef\guidebook@paperheightval{\the\guidebook@tempheight}%
	% Calculate new margins that include bleed
	\edef\guidebook@leftwithbleed{\the\dimexpr\guidebook@marginleft+\guidebook@bleedlength\relax}%
	\edef\guidebook@rightwithbleed{\the\dimexpr\guidebook@marginright+\guidebook@bleedlength\relax}%
	\edef\guidebook@topwithbleed{\the\dimexpr\guidebook@margintop+\guidebook@bleedlength\relax}%
	\edef\guidebook@bottomwithbleed{\the\dimexpr\guidebook@marginbottom+\guidebook@bleedlength\relax}%
	\if@twoside
		% For twoside documents, use inner/outer
		\geometry{
			paperwidth=\guidebook@paperwidthval,
			paperheight=\guidebook@paperheightval,
			inner=\guidebook@leftwithbleed,
			outer=\guidebook@rightwithbleed,
			top=\guidebook@topwithbleed,
			bottom=\guidebook@bottomwithbleed,
		}%
	\else
		% For oneside documents, use left/right
		\geometry{
			paperwidth=\guidebook@paperwidthval,
			paperheight=\guidebook@paperheightval,
			left=\guidebook@leftwithbleed,
			right=\guidebook@rightwithbleed,
			top=\guidebook@topwithbleed,
			bottom=\guidebook@bottomwithbleed,
		}%
	\fi
}

% Helper command to calculate and set bleed extension
% This centralizes the bleed extension calculation
\NewDocumentCommand{\guidebook@updatebleedextension}{}{%
	\ifguidebook@bleedenabled
		% With bleed: extend by margin + bleed to reach the paper edge
		\setlength{\guidebook@bleedextension}{\dimexpr-\guidebook@margintop-\guidebook@bleedlength\relax}%
	\else
		\setlength{\guidebook@bleedextension}{-\guidebook@margintop}%
	\fi
}

% Helper macros to get effective paper dimensions for content positioning
% When bleed is enabled, use original paper dimensions for positioning
% When disabled, use current paper dimensions
\NewDocumentCommand{\guidebook@contentpaperwidth}{}{%
	\ifguidebook@bleedenabled
		\guidebook@origpaperwidth
	\else
		\paperwidth
	\fi
}

\NewDocumentCommand{\guidebook@contentpaperheight}{}{%
	\ifguidebook@bleedenabled
		\guidebook@origpaperheight
	\else
		\paperheight
	\fi
}

% Command to override the bleed value (call after \documentclass)
% Usage: \setbleedvalue{0.125in} or \setbleedvalue{3.175mm}
% This sets the bleed amount that will be used when bleed is enabled
\NewDocumentCommand{\setbleedvalue}{m}{%
	% Update the length register
	\setlength{\guidebook@bleedlength}{#1}%
	% Update scaled bleed
	\guidebook@updatescaledbleed
	% If bleed is already enabled, recalculate geometry with new bleed value
	\ifguidebook@bleedenabled
		\guidebook@applybleedgeometry
		\guidebook@updatebleedextension
	\fi
}

% Command to enable bleed and optionally set a custom value
% Usage: \enablebleed or \enablebleed{0.125in}
\NewDocumentCommand{\enablebleed}{O{}}{%
	\guidebook@bleedenabledtrue%
	\ifx#1\@empty\else
		% Update the length register
		\setlength{\guidebook@bleedlength}{#1}%
	\fi
	% Update scaled bleed
	\guidebook@updatescaledbleed
	% Apply bleed to geometry
	\guidebook@applybleedgeometry
	\guidebook@updatebleedextension
}

% Calculate bleed extension for edge content (negative margin adjustment)
\newlength{\guidebook@bleedextension}
\setlength{\guidebook@bleedextension}{0pt}

% Command to set gutter margin (for print binding)
% Usage: \setguttermargin{0.5in} or \setguttermargin{1.25cm}
% Adds the specified value to the inner margin for binding (left on right pages, right on left pages)
% Note: Gutter is only for two-sided printing, so it always uses inner margin
\NewDocumentCommand{\setguttermargin}{m}{%
	\def\guidebook@guttermargin{#1}%
	\geometry{inner=\dimexpr\guidebook@marginleft+\guidebook@guttermargin\relax}%
}

% Command to set bleed image ratio
% Usage: \setbleedimageratio{1} or \setbleedimageratio{0.5}
% Defines how much of the images should be in the bleed (1 = full bleed, 0.5 = half bleed, etc.)
\NewDocumentCommand{\setbleedimageratio}{m}{%
	\def\guidebook@bleedimageratio{#1}%
	% Update scaled bleed
	\guidebook@updatescaledbleed
}

% Set up geometry - load first, then adjust for bleed if needed
% This approach allows us to reference \paperwidth and \paperheight after they're set
% Use inner/outer for twoside documents, left/right for oneside documents
\if@twoside
	\usepackage[
		top=\guidebook@margintop,
		bottom=\guidebook@marginbottom,
		inner=\guidebook@marginleft,
		outer=\guidebook@marginright,
		%showframe % Enable to display margin boundaries for layout debugging
	]{geometry}
\else
	\usepackage[
		top=\guidebook@margintop,
		bottom=\guidebook@marginbottom,
		left=\guidebook@marginleft,
		right=\guidebook@marginright,
		%showframe % Enable to display margin boundaries for layout debugging
	]{geometry}
\fi

% Apply bleed adjustments if enabled
% When bleed is enabled, we:
% 1. Increase paper size by 2*bleed (bleed on each side)
% 2. Shift content area by bleed amount (hoffset/voffset)
% 3. Maintain text margins (these become safety margins from trim edge)
\ifguidebook@bleedenabled
	% Adjust geometry for bleed - now we can reference \paperwidth and \paperheight
	\guidebook@applybleedgeometry
\fi
% Set bleed extension for edge content (works for both enabled and disabled states)
\guidebook@updatebleedextension

%----------------------------------------------------------------------------------------
%	FONTS
%----------------------------------------------------------------------------------------

\usepackage{fontspec} % Modern font selection for LuaLaTeX/XeLaTeX
\usepackage{unicode-math} % Unicode math support
\usepackage{newunicodechar} % Support for Unicode character mapping
\usepackage{xfrac} % Inline fractions with proper formatting

\setmainfont{TeX Gyre Pagella} % Palatino-like font with full Unicode support
% Pin the emoji font to Noto Color Emoji, which ships with TeX Live, instead of
% the platform default. This keeps emoji rendering identical across systems and
% avoids a luaotfload/HarfBuzz crash ("attempt to index a nil value") when
% multi-codepoint emoji (e.g. hot-pepper, which includes a variation selector)
% are rendered with Apple Color Emoji on macOS. Must run after the math/font
% packages are set up: calling it right after \usepackage{emoji} derails the
% later math-mode configuration (\genfrac errors in ingredient fractions).
\setemojifont{Noto Color Emoji}
\setmathfont{TeX Gyre Pagella Math} % Matching math font

% Map Unicode fraction characters to proper LaTeX fractions
% Using \sfrac for inline fractions that look natural in text
% Automated mapping using a list-based approach
\ExplSyntaxOn
\cs_new_protected:Npn \cb_define_fraction:nnn #1#2#3
{
	\AtBeginDocument{\newunicodechar{#1}{\sfrac{#2}{#3}}}
}
\clist_map_inline:nn
{
	{½}{1}{2},
	{⅓}{1}{3}, {⅔}{2}{3},
	{¼}{1}{4}, {¾}{3}{4},
	{⅛}{1}{8}, {⅜}{3}{8}, {⅝}{5}{8}, {⅞}{7}{8},
	{⅙}{1}{6}
}
{ \cb_define_fraction:nnn #1 }
\ExplSyntaxOff

% Activate the language after Unicode character setup completes
% This ensures our translation captions are applied and babel shorthands
% don't interfere with the Unicode fraction processing
\AtBeginDocument{\selectlanguage{\cookbook@language}}

% Source Sans Pro font command (using system sans-serif as fallback)
\NewDocumentCommand{\sourcesanspro}{+m}{{\sffamily\selectfont #1}}

\usepackage{microtype} % Improve typography

\usepackage{titlesec} % Format titles
\usepackage{tocloft} % Customize Table of Contents, List of Figures, and List of Tables

%----------------------------------------------------------------------------------------
%	CUSTOM GRAPHICS
%----------------------------------------------------------------------------------------
\usepackage{tikz} % Vector graphics and diagram creation
\usetikzlibrary{calc} % Coordinate calculations and transformations
\usetikzlibrary{shadows} % Drop shadows and shadow effects for shapes
\usetikzlibrary{backgrounds} % Background layers for layered graphics

%----------------------------------------------------------------------------------------
%	CUSTOM PAGE STYLES
%----------------------------------------------------------------------------------------

% Define length for page number box minimum height (defined once, used in \pagenumberbox)
\newlength{\pagenumberbox@textheight}
\newlength{\pagenumberbox@minimumheight}

\NewDocumentCommand{\pagenumberbox}{m m}{%
	\begin{tikzpicture}[remember picture, overlay]
		\begin{pgfonlayer}{foreground}
			\begin{scope}
				\ifguidebook@bleedenabled
					\setlength{\pagenumberbox@minimumheight}{\dimexpr1.5cm+\guidebook@bleedlength\relax}
					\setlength{\pagenumberbox@textheight}{\dimexpr1.2cm+\guidebook@bleedlength\relax}
				\else
					\setlength{\pagenumberbox@minimumheight}{1.5cm}
					\setlength{\pagenumberbox@textheight}{1.2cm}
				\fi
				\node[
					text height=\pagenumberbox@textheight,
					text depth=0.2cm,
					draw,
					fill=black,
					text=white,
					rectangle,
					minimum width=0.8cm,
					minimum height=\pagenumberbox@minimumheight,
					anchor=#1
				] at (#2) {\thepage};
			\end{scope}
		\end{pgfonlayer}
	\end{tikzpicture}%
}

\fancypagestyle{custompagestyle}{
	\fancyhf{} % Clear all header and footer fields
	\renewcommand{\headrulewidth}{0pt} % Remove the line at the top of the header
}

% Flag to track if page numbers should be suppressed
\newif\ifnopagenumberstyle
\nopagenumberstylefalse

% Helper macros to check if current page is left or right based on guidebook@leftpage setting
% These create conditional flags that can be used with \ifguidebook@isleftpage and \ifguidebook@isrightpage
\newif\ifguidebook@isleftpage
\newif\ifguidebook@isrightpage

% This command determines whether the current page is a "left" or "right" page based on:
% 1. The user's configuration (left=even or left=odd)
% 2. The actual page number (odd or even)
%
% The logic works as follows:
% - If left=even: Even page numbers (2, 4, 6...) are left pages, odd (1, 3, 5...) are right
% - If left=odd: Odd page numbers (1, 3, 5...) are left pages, even (2, 4, 6...) are right
%
% This is essential for proper page number placement and chapter/image positioning
% in two-page spreads, as different book conventions use different page numbering schemes.
\NewDocumentCommand{\guidebook@checkpageparity}{}{%
	\def\guidebook@tempeven{even}%
	\ifx\guidebook@leftpage\guidebook@tempeven
		% Left pages are even (standard book convention)
		\ifodd\value{page}%
			% Current page is odd → it's a right page
			\guidebook@isleftpagefalse
			\guidebook@isrightpagetrue
		\else
			% Current page is even → it's a left page
			\guidebook@isleftpagetrue
			\guidebook@isrightpagefalse
		\fi
	\else
		% Left pages are odd (alternative convention)
		\ifodd\value{page}%
			% Current page is odd → it's a left page
			\guidebook@isleftpagetrue
			\guidebook@isrightpagefalse
		\else
			% Current page is even → it's a right page
			\guidebook@isleftpagefalse
			\guidebook@isrightpagetrue
		\fi
	\fi
}

\AddToShipoutPictureFG{%
	\ifnum\value{page}>0
		% Draw bleed area boundaries if debug mode is enabled
		\ifguidebook@bleeddebug
			\begin{tikzpicture}[remember picture, overlay]
				\ifguidebook@bleedenabled
					% With margin-based bleed, current page = full PDF paper (including bleed)

					% BLUE SOLID LINE = Bleed edge (actual PDF paper boundary)
					\draw[blue, solid, line width=1pt]
					(current page.south west) rectangle (current page.north east);

					% RED DASHED LINE = Trim edge (where page will be cut, inset by bleed amount)
					\draw[red, dashed, line width=1pt]
					([xshift=\the\guidebook@bleedlength, yshift=\the\guidebook@bleedlength]current page.south west)
					rectangle
					([xshift=-\the\guidebook@bleedlength, yshift=-\the\guidebook@bleedlength]current page.north east);
				\else
					% When bleed is disabled, current page is the trim edge
					\draw[red, dashed, line width=1pt]
					(current page.south west) rectangle (current page.north east);
				\fi
			\end{tikzpicture}%
		\fi
		\ifnopagenumberstyle\else
			\guidebook@checkpageparity
			\ifguidebook@isrightpage
				% Right page - number on the right
				\ifguidebook@bleedenabled
					\pagenumberbox{north east}{[xshift=-1cm-\the\guidebook@bleedlength, yshift=0.5cm]current page.north east}%
				\else
					\pagenumberbox{north east}{[xshift=-1cm, yshift=0.5cm]current page.north east}%
				\fi
			\else
				% Left page - number on the left
				\ifguidebook@bleedenabled
					\pagenumberbox{north west}{[xshift=1cm+\the\guidebook@bleedlength, yshift=0.5cm]current page.north west}%
				\else
					\pagenumberbox{north west}{[xshift=1cm, yshift=0.5cm]current page.north west}%
				\fi
			\fi
		\fi
	\fi
}

\pagestyle{custompagestyle}

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
	\setcounter{page}{\guidebook@startpage}
	\phantomsection
	\label{coverpage}
	\begin{titlepage}
		\thispagestyle{empty}
		\noindent
		\begin{adjustwidth}{\guidebook@bleedextension}{\guidebook@bleedextension}% Extend to page edges including bleed
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
						\ifguidebook@bleedenabled
							\clip ([xshift=\guidebook@scaledbleed,yshift=\guidebook@scaledbleed]current page.south west) rectangle ([xshift=-\guidebook@scaledbleed,yshift=-\guidebook@scaledbleed]current page.north east);
							\path[fill overzoom image={\cover@image},fill image opacity={\cover@opacity}]
							($(current page.south west)+(\the\guidebook@scaledbleed,\the\guidebook@scaledbleed)$)
							rectangle
							($(current page.north east)-(\the\guidebook@scaledbleed,\the\guidebook@scaledbleed)$);
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
