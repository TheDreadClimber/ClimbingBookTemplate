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
\def\guidebook@ingredientitemsep{0.003\textheight}
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
