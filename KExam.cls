%% KExam.cls
%% Copyright 2023 Abdelkrime Aries <kariminfo0@gmail.com>
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Abdelkrime Aries
%
% This work consists of the files KExam.cls and example.tex



\NeedsTeXFormat{LaTeX2e} %[2009/09/24]
\ProvidesClass{KExam}[2023/06/07 Create an exam]
%===============================================================
% Options
%===============================================================

\newif\ifanswers % a boolean variable to check if answers
\answersfalse % by default no answers
\DeclareOption{answers}{\answerstrue}

\ProcessOptions\relax

\LoadClass[12pt, a4paper]{article}

%===============================================================
% Requirements
%===============================================================
\RequirePackage{times}
\RequirePackage{tabularray}
\RequirePackage{xcolor}
\RequirePackage{wasysym}
\RequirePackage{listofitems}
%\RequirePackage{titlesec}

\def\ptop{1cm}
\def\pleft{1cm}
\def\pright{1cm}
\def\pbottom{1.25cm}
\RequirePackage[left=\pleft,right=\pright,top=\ptop,bottom=\pbottom]{geometry}


%===============================================================
% Internal commands and variables
%===============================================================
\def\@answer@color{black}
\def\@grade@color{black}
\def\choiceFalse{\Square}
\def\choiceTrue{\CheckedBox}
\newcounter{question@count}
\newcounter{choices@count}
\newcounter{choices@max}
\newcounter{tmp@count}

%===============================================================
% Tunning instructions
%===============================================================
\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\fboxrule}{1pt}
\setlength{\fboxsep}{5pt}
\setsepchar{&}
\raggedbottom

%===============================================================
% Overriding 
%===============================================================
\renewcommand{\section}[1]{%
	\vskip 4ex plus 1ex minus .2ex
	{\large \bfseries #1}\\[-6pt]
	\rule{\textwidth}{2pt}
	\vskip 1ex plus .2ex
}

%===============================================================
% Setters
%===============================================================
\newcommand{\setAnswerColor}[1]{\def\@answer@color{#1}}
\newcommand{\setGradeColor}[1]{\def\@grade@color{#1}}


%===============================================================
% Questions and grades
%===============================================================

\newcommand{\grade}[1]{}
\ifanswers
	\renewcommand{\grade}[1]{{\color{\@grade@color}\bfseries #1}}
\fi


\newenvironment{question}{%
	\vskip 1ex plus 0.5ex minus .2ex
	\def\@response{}
	\stepcounter{question@count}
	\textbf{(\arabic{question@count})}
}{%
	\@response
	\def\@response{}
}


%===============================================================
% Simple answers
%===============================================================

\newcommand{\simpleAnswer}[2][1em]{
	\ifanswers
		\def\@simple@answer{\parbox[][][t]{\the\dimexpr\textwidth-12pt\relax}{\color{\@answer@color} #2}}
	\else 
		\def\@simple@answer{\parbox[][#1][t]{\textwidth}{\phantom{answer}}}
	\fi
	\def\@response{ 
		\fbox{\unexpanded\expandafter{\@simple@answer}}
	}
}


%===============================================================
% Choices
%===============================================================

\newcommand{\@b@choices}[1]{
	\def\first{#1}\newcount\N\N=\number\first
	\def\@response{\begin{tblr}{colspec = {|[1pt]Q[l, wd=1pt]*{\the\N}{Q[l, wd=\the\dimexpr (\textwidth-5pt)/\the\N - 2pt\relax]}|[1pt]}, rowsep = 1pt, colsep=1pt}\hline}
	\setcounter{choices@count}{0}
	\setcounter{choices@max}{\N}
}

\newcommand{\bMultiChoices}[1][1]{
	\@b@choices{#1}
	\def\choiceFalse{\Square}
	\def\choiceTrue{\CheckedBox}
}

\newcommand{\bSingleChoice}[1][1]{
	\@b@choices{#1}
	\def\choiceFalse{\Circle}
	\def\choiceTrue{\CIRCLE}
}

\newcommand{\eChoices}{
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response \\ \hline \end{tblr}}}
}

\newcommand{\choice}[2][\relax]{
	\def\@nrow{}
	\ifnum\value{choices@count}=\value{choices@max}
	\def\@nrow{ \\ }
	\setcounter{choices@count}{0}
	\fi
	
%	\def\@ncol{}
%	\ifnum\value{choices@count}>0
	\def\@ncol{ & }
%	\fi
	
	\def\@ncolor{}
	\def\@choice@sel{\choiceFalse}
	\ifx c#1 
	\ifanswers
	\def\@choice@sel{\choiceTrue}
	\def\@ncolor{\color{\@answer@color}}
	\fi
	\fi
	
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response} \@nrow \@ncol \unexpanded\expandafter{\@ncolor} \unexpanded\expandafter{\@choice@sel} #2}
	\stepcounter{choices@count}
}


%===============================================================
% Comparaisons
%===============================================================

\newcommand{\@b@cmp}[2]{
	\readlist\lst{#2}
	\newcount\N\N=\lstlen
	\setcounter{tmp@count}{2}
	\addtocounter{tmp@count}{\N}
	\def\@response{
		\begin{tblr}{
				colspec = {|[1pt]Q[l, wd=1pt]Q[l, wd=\the\dimexpr \textwidth - ((2pt + #1) * \the\N) - 6pt\relax]*{\the\N}{|Q[c, wd=#1]}|[1pt]}, 
				rowsep = 1pt, colsep=1pt, vline{1}={1}{0pt}}
				\cline{3-\value{tmp@count}}
				&& #2 \\
				\hline
	}
	\setcounter{choices@max}{\N}
}
		

\newcommand{\bMultiCmp}[2]{
	\@b@cmp{#1}{#2}
	\def\choiceFalse{\Square}
	\def\choiceTrue{\CheckedBox}
}
		
\newcommand{\bSingleCmp}[2]{
	\@b@cmp{#1}{#2}
	\def\choiceFalse{\Circle}
	\def\choiceTrue{\CIRCLE}
}

\newcommand{\eCmp}{
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response \end{tblr}}}
}

\newcommand{\cmp}[2]{
	
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response} & #1}
	
	\def\@choice@sel{\choiceFalse}
	
	\def\argtwo{#2}
	\ifx\argtwo\empty\else 
		\readlist\lst{#2}
	\fi
	
	\newcount\i\i=\value{choices@max}
	\loop
	\def\@ncolor{}
	\def\@choice@sel{\choiceFalse}
	\ifanswers
		\ifx\argtwo\empty\else 
		\foreachitem\l\in\lst{
			\ifnum\i=\l
				\def\@choice@sel{\choiceTrue}
				\def\@ncolor{\color{\@answer@color}}
			\fi
		}
		\fi	
	\fi
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response} & \unexpanded\expandafter{\@ncolor} \unexpanded\expandafter{\@choice@sel}}
	\advance \i -1
	\ifnum \i>0
	\repeat
	
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response \\ \hline}}
}
