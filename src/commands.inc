\edef\tempa{}%

% Define a macro to move articles to the end
\newcommand{\movename}[2]{%
  \IfBeginWith{#1}{The }%
    {\StrGobbleLeft{#1}{4}[\rest]\edef#2{\rest, The}}%
    {%
      \IfBeginWith{#1}{A }%
        {\StrGobbleLeft{#1}{2}[\rest]\edef#2{\rest, A}}%
        {%
          \IfBeginWith{#1}{An }%
            {\StrGobbleLeft{#1}{3}[\rest]\edef#2{\rest, An}}%
            {\edef#2{#1}}%
        }%
    }%
}

\newcommand\fullpageimage[1]{
  \edef\tempb{#1}%
  \ifx\tempa\tempb
  \else
    \thispagestyle{empty}
    \newgeometry{left=0mm, right=0mm, top=0mm, bottom=0mm} % use full page
    \begin{figure}[p] % [p] Place it on a page containing only floats
      \includegraphics[width=\paperwidth, height=\paperheight]{#1}
    \end{figure}
    \restoregeometry % revert to the original geometry from now on
  \fi
}

\newcommand*\climbingregion[1]{
  \chapter*{#1}
  \addcontentsline{toc}{chapter}{#1}
  \markboth{#1}{#1}
}

\newcommand*\crag[3]{%
% A Crag can contain any mix of walls, boulder fields, or boulders.
% name, header, content
    \section*{#1}
    \addcontentsline{toc}{section}{#1}#2
    \begin{multicols}{2}%
        \resetcstep#3
    \end{multicols}
}

\newcommand*\boulderfield[3]{%
% A boulder field contains boulders.
% name, header, content
    \subsection*{#1}
    \addcontentsline{toc}{subsection}{#1}#2
    \paragraph{Boulders}#3%
}

\newcommand*\boulder[3]{
% @param name - boulder name
% @param header - boulder description
% @param problems - list of problems
    \subsubsection*{#1}#2
    \subsubsection*{Problems}
    \begin{multicols}{2}%
        \resetcstep#3
    \end{multicols}
}

\newcommand*\cliff[3]{%
% A cliff primarily contains routes, but can have boulder problems. Ideally there would be sector separators for the taller sectors ans shorter.
% name, description, header, content
    \subsection*{#1}
    \addcontentsline{toc}{subsection}{#1}#2%
    \subsection*{Routes}
    \begin{multicols}{2}%
        \resetcstep
        #3
    \end{multicols}
}

\newcommand*\sector[3]{%
% A sector is not indexed primarily contains routes, but can have boulder problems.
% name, header, content
    \subsubsection*{#1}#2%
    \subsection*{Routes}
    \begin{multicols}{2}%
        \resetcstep
        #3
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
\pgfkeys{/csteps/inner color=white}

\renewcommand{\cstep}{%
    \refstepcounter{cstepcnt}%
    \Circled{\small\arabic{cstepcnt}}%
}

\newcommand*\sportroute[6]{%
% {@param} #1 Name
% {@param} #2 Grade
% {@param} #3 Description
% {@param} #4 Height
% {@param} #5 Bolts
% {@param} #6 FA
  \begingroup
    \edef\ydssort{\ydssortorder{#2}}% expand to plain text
    \index[sportroutesbygrade]{\ydssort @#2!#1}%
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}{%
        \pgfkeys{/csteps/fill color=blue}%
        \cstep%
    } %
    \textbf{#1} {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4\heightunit #5 Bolts \textit{FA: #6}\par\bigskip
  \endgroup
}

\newcommand*\tradroute[5]{%
% {@param} #1 Name
% {@param} #2 Grade
% {@param} #3 Description
% {@param} #4 Height
% {@param} #6 FA
  \begingroup
    \edef\ydssort{\ydssortorder{#2}}% expand to plain text
    \index[tradroutesbygrade]{\ydssort @#2!#1}%
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}%
    {%
        \pgfkeys{/csteps/fill color=red}%
        \cstep%
    } %
    \textbf{#1} {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4\heightunit \textit{FA: #5}\par\bigskip
  \endgroup
}

\newcommand*\toproperoute[5]{%
% {@param} #1 Name
% {@param} #2 Grade
% {@param} #3 Description
% {@param} #4 Height
% {@param} #5 FA
  \begingroup
    \edef\ydssort{\ydssortorder{#2}}% expand to plain text
    \index[sportroutesbygrade]{\ydssort @#2!#1}%
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}{%
        \pgfkeys{/csteps/fill color=Plum}%
        \cstep%
    } %
    \textbf{#1} {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4\heightunit \textit{FA: #5}\par\bigskip
  \endgroup
}

\newcommand*\mixedroute[5]{%
% Mixed Ice Climb
% {@param} #1 Name
% {@param} #2 Grade
% {@param} #3 Description
% {@param} #4 Height
% {@param} #6 FA
  \begingroup
    \index[iceroutesbygrade]{#2!#1}%
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}{%
        \pgfkeys{/csteps/fill color=red}%
        \cstep%
    } %
    \textbf{#1} {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4\heightunit \textit{FA: #5}\par\bigskip
  \endgroup
}

\newcommand*\mixedtradroute[6]{%
% {@param} #1 Name
% {@param} #2 Grade
% {@param} #3 Description
% {@param} #4 Height
% {@param} #5 Bolts
% {@param} #6 FA
  \begingroup
    \edef\ydssort{\ydssortorder{#2}}% expand to plain text
    \index[tradroutesbygrade]{\ydssort @#2!#1}%
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}{%
        \pgfkeys{/csteps/fill color=red}%
        \cstep%
    } %
    \textbf{#1} {%
        \fontfamily{phv}%
        \selectfont #2%
    }%
    \\#3\\#4\heightunit #5 Bolts \textit{FA: #6}\par\bigskip
  \endgroup
}

\newcommand*\iceroute[5]{%
% {@param} #1 Name
% {@param} #2 Grade
% {@param} #3 Description
% {@param} #4 Height
% {@param} #5 FA
  \begingroup
    \index[iceroutesbygrade]{#2!#1}% sort by \vsort, display #2
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}%
    {%
      \pgfkeys{/csteps/fill color=cyan}%
      \cstep
    } %
    \textbf{#1} {\fontfamily{phv}\selectfont #2}\\%
    #3\\#4\heightunit \textit{FA: #5}\par\bigskip
  \endgroup
}

\makeatletter
% Lookup macro: expands to the numeric key
\newcommand*\vsortorder[1]{\@nameuse{vsort@#1}}

% === Grade table ===
\expandafter\def\csname vsort@VB-\endcsname{000}
\expandafter\def\csname vsort@VB\endcsname{001}
\expandafter\def\csname vsort@VB+\endcsname{002}
\expandafter\def\csname vsort@V0-\endcsname{003}
\expandafter\def\csname vsort@V0\endcsname{005}
\expandafter\def\csname vsort@V0+\endcsname{006}
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
    \index[boulderproblemsbygrade]{\vsort @#2!#1}% sort by \vsort, display #2
    \movename{#1}{\movedname}
    \StrChar{\movedname}{1}[\FirstChar]%
    \index{\FirstChar!\movedname}%
    {%
      \pgfkeys{/csteps/fill color=ForestGreen}%
      \cstep
    } %
    \textbf{#1} {\fontfamily{phv}\selectfont #2}\\%
    #3\\\textit{FA: #4}\par\bigskip
  \endgroup
}

\makeatletter
% Lookup macro: expands to the numeric key
\newcommand*\ydssortorder[1]{\@nameuse{ydssort@#1}}

% === Grade table ===
\expandafter\def\csname ydssort@4th\endcsname{000}
\expandafter\def\csname ydssort@5.0\endcsname{005}
\expandafter\def\csname ydssort@5.1\endcsname{010}
\expandafter\def\csname ydssort@5.2\endcsname{015}
\expandafter\def\csname ydssort@5.3\endcsname{020}
\expandafter\def\csname ydssort@5.4\endcsname{025}
\expandafter\def\csname ydssort@5.5\endcsname{030}
\expandafter\def\csname ydssort@5.6\endcsname{035}
\expandafter\def\csname ydssort@5.6+\endcsname{037}
\expandafter\def\csname ydssort@5.7\endcsname{040}
\expandafter\def\csname ydssort@5.7+\endcsname{042}
\expandafter\def\csname ydssort@5.8-\endcsname{044}
\expandafter\def\csname ydssort@5.8\endcsname{045}
\expandafter\def\csname ydssort@5.8+\endcsname{046}
\expandafter\def\csname ydssort@5.9-\endcsname{049}
\expandafter\def\csname ydssort@5.9\endcsname{050}
\expandafter\def\csname ydssort@5.9+\endcsname{051}
\expandafter\def\csname ydssort@5.10-\endcsname{053}
\expandafter\def\csname ydssort@5.10\endcsname{054}
\expandafter\def\csname ydssort@5.10a\endcsname{055}
\expandafter\def\csname ydssort@5.10a/b\endcsname{058}
\expandafter\def\csname ydssort@5.10b\endcsname{060}
\expandafter\def\csname ydssort@5.10c\endcsname{065}
\expandafter\def\csname ydssort@5.10d\endcsname{070}
\expandafter\def\csname ydssort@5.10+\endcsname{071}
\expandafter\def\csname ydssort@5.11-\endcsname{073}
\expandafter\def\csname ydssort@5.11\endcsname{074}
\expandafter\def\csname ydssort@5.11a\endcsname{075}
\expandafter\def\csname ydssort@5.11b\endcsname{080}
\expandafter\def\csname ydssort@5.11c\endcsname{085}
\expandafter\def\csname ydssort@5.11d\endcsname{090}
\expandafter\def\csname ydssort@5.11+\endcsname{091}
\expandafter\def\csname ydssort@5.12a\endcsname{095}
\expandafter\def\csname ydssort@5.12b\endcsname{100}
\expandafter\def\csname ydssort@5.12c\endcsname{105}
\expandafter\def\csname ydssort@5.12d\endcsname{110}
\expandafter\def\csname ydssort@5.13a\endcsname{120}
\expandafter\def\csname ydssort@5.13b\endcsname{125}
\expandafter\def\csname ydssort@5.13c\endcsname{130}
\expandafter\def\csname ydssort@5.13d\endcsname{135}
\expandafter\def\csname ydssort@5.14a\endcsname{140}
\expandafter\def\csname ydssort@5.14b\endcsname{145}
\expandafter\def\csname ydssort@Project\endcsname{150}
% === Fallback if grade is unknown ===
\expandafter\def\csname ydssort@\endcsname{999}
\makeatother
