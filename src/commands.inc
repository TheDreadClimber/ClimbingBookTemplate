\edef\tempa{}%
\newcommand\frontcover[1]{
  \edef\tempb{#1}%
  \ifx\tempa\tempb
  \else
    \thispagestyle{empty}
    \newgeometry{left=0mm, right=0mm, top=0mm, bottom=0mm} % use full page
    \begin{figure}[p] % [p] Place it on a page containing only floats
      \includegraphics[width=\paperwidth]{#1}
    \end{figure}
    \restoregeometry % revert to the original geometry from now on
  \fi
}

\newcommand*\climbingregion[1]{
  \chapter*{#1}
  \addcontentsline{toc}{chapter}{#1}
  \markboth{#1}{#1}
}

\newcommand*\crag[4]{%
% A Crag can contain any mix of walls, boulder fields, or boulders.
% name, description, header, content
    \section*{#1}
    \addcontentsline{toc}{section}{#1}#2#3#4%
}

\newcommand*\boulderfield[4]{%
% A boulder field contains boulders.
% name, description, header, content
    \section*{#1}
    \addcontentsline{toc}{section}{#1}#2#3
    \paragraph{Boulders}#4%
}

\newcommand*\boulder[4]{
    \subsection*{#1}#2#3
    \subsection*{Problems}
    \begin{multicols}{2}%
        \resetcstep#4
    \end{multicols}
}

\newcommand*\cliff[4]{%
% A cliff primarily contains routes, but can have boulder problems. Ideally there would be sector separators for the taller sectors ans shorter.
% name, description, header, content
    \subsection*{#1}
    \addcontentsline{toc}{section}{#1}#2#3%
    \subsection*{Routes}
    \begin{multicols}{2}%
        \resetcstep
        #4
    \end{multicols}
}

\newcommand*\climbheader[4]{%
    %\def\tempa{}%
    \def\tempb{#1}%
    \ifx\tempa\tempb
    \else
        \paragraph{Character}#1
    \fi
    \def\tempb{#2}%
    \ifx\tempa\tempb
    \else
        \paragraph{Access}#2
    \fi
    \def\tempb{#3}%
    \ifx\tempa\tempb
    \else
        \paragraph{Approach}#3
    \fi
    \def\tempb{#4}%
    \ifx\tempa\tempb
    \else
        \paragraph{Conditions}#4
    \fi
}

% Add a little more space around the numbers in the \Circled
\pgfkeys{/csteps/inner ysep=5pt}
\pgfkeys{/csteps/inner xsep=5pt}

\renewcommand{\cstep}{%
    \refstepcounter{cstepcnt}%
    \Circled{\small\arabic{cstepcnt}}%
}

\newcommand*\sportroute[6]{%
  \begin{minipage}{0.5\textwidth.}%
    \index[sportroutesbygrade]{#2!#1}
    \index{#1}%
    {%
        \color{blue}%
        \cstep%
    } %
    \textbf{#1} %
    {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4' #5 Bolts \textit{FA: #6}\bigskip\\%
  \end{minipage}
}

\newcommand*\tradroute[5]{%
    \index[tradroutesbygrade]{#2!#1}%
    \index{#1}%
    {%
        \color{red}%
        \cstep%
    } %
    \textbf{#1} %
    {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3 #4' \textit{FA: #5}\bigskip\\%
}

\newcommand*\mixedroute[6]{%
    \index[tradroutesbygrade]{#2!#1}%
    \index{#1}%
    {%
        \color{red}%
        \cstep%
    } %
    \textbf{#1} %
    {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4' #5 Bolts \textit{FA: #6}\bigskip\\%
}

\makeatletter
% Lookup macro: expands to the numeric key
\newcommand*\vsortorder[1]{\@nameuse{vsort@#1}}

% === Grade table ===
\expandafter\def\csname vsort@V0\endcsname{000}
\expandafter\def\csname vsort@V1\endcsname{010}
\expandafter\def\csname vsort@V1/2\endcsname{015}
\expandafter\def\csname vsort@V2\endcsname{020}
\expandafter\def\csname vsort@V2/3\endcsname{025}
\expandafter\def\csname vsort@V3\endcsname{030}
\expandafter\def\csname vsort@V3/4\endcsname{035}
\expandafter\def\csname vsort@V4\endcsname{040}
\expandafter\def\csname vsort@V4/5\endcsname{045}
\expandafter\def\csname vsort@V5\endcsname{050}
\expandafter\def\csname vsort@V5/6\endcsname{055}
\expandafter\def\csname vsort@V6\endcsname{060}
\expandafter\def\csname vsort@V6/7\endcsname{065}
\expandafter\def\csname vsort@V7\endcsname{070}
\expandafter\def\csname vsort@V7/8\endcsname{075}
\expandafter\def\csname vsort@V8\endcsname{080}
\expandafter\def\csname vsort@V8/9\endcsname{085}
\expandafter\def\csname vsort@V9\endcsname{090}
\expandafter\def\csname vsort@V9/10\endcsname{095}
\expandafter\def\csname vsort@V10\endcsname{100}
\expandafter\def\csname vsort@V10/11\endcsname{105}
\expandafter\def\csname vsort@V11\endcsname{110}
\expandafter\def\csname vsort@V11/12\endcsname{115}
\expandafter\def\csname vsort@V12\endcsname{120}
\expandafter\def\csname vsort@V12/13\endcsname{125}
\expandafter\def\csname vsort@V13\endcsname{130}
\expandafter\def\csname vsort@V13/14\endcsname{135}
\expandafter\def\csname vsort@V14\endcsname{140}
\expandafter\def\csname vsort@V14/15\endcsname{145}
\expandafter\def\csname vsort@V15\endcsname{150}
\expandafter\def\csname vsort@V15/16\endcsname{155}
\expandafter\def\csname vsort@V16\endcsname{160}
\expandafter\def\csname vsort@Project\endcsname{180}
% === Fallback if grade is unknown ===
\expandafter\def\csname vsort@\endcsname{999}
\makeatother

\newcommand*\boulderproblem[4]{%
  \begingroup
    \edef\vsort{\vsortorder{#2}}% expand to plain text
    \index[boulderproblemsbygrade]{\vsort@#2!#1}% sort by \vsort, display #2
    \index{#1}%
    {\color{ForestGreen}\cstep}%
    \textbf{#1} {\fontfamily{phv}\selectfont #2}\\%
    #3\\\textit{FA: #4}\par\bigskip
  \endgroup
}
