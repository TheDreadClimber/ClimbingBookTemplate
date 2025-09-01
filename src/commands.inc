\newcommand*\boulder[4]{
    \subsection*{#1}#2#3
    \subsection*{Problems}
    \begin{multicols}{2}%
        \resetcstep#4
    \end{multicols}
}
\newcommand*\boulderfield[4]{%
% A boulder field contains boulders.
% name, description, header, content
    \section*{#1}
    \addcontentsline{toc}{section}{#1}#2#3
    \paragraph{Boulders}#4%
}
\newcommand*\climbcontainer[8]{
}
\newcommand*\climbheader[4]{%
    \def\tempa{}%
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
\newcommand*\crag[4]{%
% A Crag can contain any mix of walls, boulder fields, or boulders.
% name, description, header, content
    \section*{#1}
    \addcontentsline{toc}{section}{#1}#2#3#4%
}

\newcommand*\cliff[4]{%
% A cliff primarily contains routes, but can have boulder problems. Ideally there would be sector separators for the taller sectors ans shorter.
% name, description, header, content
    \section*{#1}
    \addcontentsline{toc}{section}{#1}#2#3%
    \section*{Routes}
    \begin{multicols}{2}%
        \resetcstep
        #4
    \end{multicols}
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

\newcommand*\boulderproblem[5]{%
    \StrLeft{#2}{1}[\charone]%
    \def\zeroval{0}%
    \def\period{1}
    \ifx\charone\zeroval% We have a grade < 10
        \StrMid{#2}{3}{3}[\slashval]
        \StrMid{#2}{2}{2}[\lowgrade]%
        \ifx\slashval\period
            \StrMid{#2}{4}{4}[\highgrade]%
            \def\vgrade{V\lowgrade/\highgrade}
        \else
            \def\vgrade{V\lowgrade}%
        \fi
    \else%
        \def\vgrade{V#2}%
    \fi%
    \index[boulderproblemsbygrade]{{V#2}@\vgrade!#1}%
    \index{#1}%
    {\color{ForestGreen}\cstep}%
    \textbf{#1} %
    {\fontfamily{phv}\selectfont \vgrade}\\#3\\#4' \textit{FA: #5}\bigskip\\%
}
