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

\raggedbottom

\def\ptop{1cm}
\def\pleft{1cm}
\def\pright{1cm}
\def\pbottom{1.25cm}


\RequirePackage[left=\pleft,right=\pright,top=\ptop,bottom=\pbottom]{geometry}

\pagestyle{empty}

\setlength{\parindent}{0pt}


% ==============================================


\renewcommand{\section}[1]{
	{\large \bfseries #1}\\[-6pt]
	\rule{\textwidth}{2pt}
	\vskip6pt
	
%	\immediate\write\kxo@file{{\noexpand\large \noexpand\bfseries #1}\\[-6pt]}
%	\immediate\write\kxo@file{\noexpand\rule{\textwidth}{2pt}}
%	\immediate\write\kxo@file{\noexpand\vskip6pt}
}

\newwrite\kxo@file

%\makeatletter
\AtBeginDocument{%
	\immediate\openout\kxo@file=\jobname.kxo
}
\AtEndDocument{%
	\immediate\closeout\kxo@file
	\input{\jobname.kxo}
}
%\makeatother

\def\addQuestions{
	\immediate\closeout\kxo@file
	\input{\jobname.kxo}
	\immediate\openout\kxo@file=\jobname.kxo
}


\def\@answer@color{black}

\newcommand{\setAnswerColor}[1]{\def\@answer@color{#1}}



\newcommand{\@question@clear}{
	\def\@query{}
	\def\@response{}
}

\@question@clear


\newcounter{question@count}


\newenvironment{question}{%
	\def\@response{}
}{%
	\stepcounter{question@count}
	\immediate\write\kxo@file{}
	\immediate\write\kxo@file{\noexpand\vskip6pt}
	\immediate\write\kxo@file{\noexpand\textbf{(\arabic{question@count})} \unexpanded\expandafter{\@query}}
	\immediate\write\kxo@file{}
	\immediate\write\kxo@file{\noexpand\vskip2pt}
	\immediate\write\kxo@file{}
	\immediate\write\kxo@file{\@response}
	\@question@clear
}


\newcommand{\query}[1]{\def\@query{#1}}


\newcommand{\simpleAnswer}[2][1em]{
	\def\@simple@answer{}
	\ifanswers
		\long\xdef\@simple@answer{\noexpand\color{\@answer@color} \unexpanded\expandafter{#2}}
	\fi
	\def\@response{ 
		\noexpand\begin{tblr}{
		colspec = {|[1pt]Q[l, wd=\textwidth]|[1pt]},
		rowsep = 2pt,
		rowspec = {|[1pt]Q[t, ht=#1]|[1pt]},
		} 
		\unexpanded\expandafter{\@simple@answer} \\ 
		\noexpand\end{tblr}
	}
}

%\makeatletter

%\newif\ifmultiple
%\multiplefalse 
\def\choiceFalse{\noexpand\Square}
\def\choiceTrue{\noexpand\CheckedBox}

\newcounter{choices@count}
\newcounter{choices@max}

\newcommand{\@b@choices}[1]{
	\def\first{#1}\newcount\N\N=\number\first
	\def\@response{\noexpand\begin{tblr}{colspec = {|[1pt]*{\the\N}{Q[l, wd=\the\dimexpr \textwidth/\the\N - (2pt * \the\N)\relax]}|[1pt]},rowsep = 0pt,}\noexpand\hline}
		\setcounter{choices@count}{0}
		\setcounter{choices@max}{\N}
}

\newcommand{\@b@cmp}[2]{
	\def\first{#1}\newcount\N\N=\number\first
	\def\@response{
		\noexpand\begin{tblr}{colspec = {|[1pt]Q[l, wd=\the\dimexpr \textwidth - ((1pt + #2) * \the\N)\relax]*{\the\N}{|Q[c, wd=#2]}|[1pt]},rowsep = 0pt, colsep=2pt}
			\noexpand\hline
	}
	\setcounter{choices@max}{\N}
}

\newcommand{\bMultiChoices}[1][1]{
	\@b@choices{#1}
	\def\choiceFalse{\noexpand\Square}
	\def\choiceTrue{\noexpand\CheckedBox}
}

\newcommand{\bMultiCmp}[2][1]{
	\@b@cmp{#1}{#2}
	\def\choiceFalse{\noexpand\Square}
	\def\choiceTrue{\noexpand\CheckedBox}
}

\newcommand{\bSingleChoice}[1][1]{
	\@b@choices{#1}
	\def\choiceFalse{\noexpand\Circle}
	\def\choiceTrue{\noexpand\CIRCLE}
}

\newcommand{\bSimpleCmp}[2][1]{
	\@b@cmp{#1}{#2}
	\def\choiceFalse{\noexpand\Circle}
	\def\choiceTrue{\noexpand\CIRCLE}
}

\newcommand{\eChoices}{
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response \\ \noexpand\hline \noexpand\end{tblr}}}
}

\newcommand{\eCmp}{
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response \noexpand\end{tblr}}}
}

\newcommand{\choice}[2][\relax]{
	\def\@nrow{}
	\ifnum\value{choices@count}=\value{choices@max}
		\def\@nrow{ \\ }
		\setcounter{choices@count}{0}
	\fi
	
	\def\@ncol{}
	\ifnum\value{choices@count}>0
		\def\@ncol{ & }
	\fi
	
	\def\@ncolor{}
	\def\@choice@sel{\choiceFalse}
	\ifx c#1 
		\ifanswers
			\def\@choice@sel{\choiceTrue}
			\def\@ncolor{\noexpand\color{\@answer@color}}
		\fi
	\fi
	
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response} \@nrow \@ncol \unexpanded\expandafter{\@ncolor} \unexpanded\expandafter{\@choice@sel} #2}
	\stepcounter{choices@count}
}


\newcommand{\cmp}[2]{
	
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response} 
		#1}
	
	\def\@choice@sel{\choiceFalse}
	
	\newcount\i\i=\value{choices@max}
	\loop
		\let\@old@response\@response
		\long\xdef\@response{\unexpanded\expandafter{\@old@response} & \unexpanded\expandafter{\@choice@sel}}
		\advance \i -1
		\ifnum \i>0
	\repeat
	
	\let\@old@response\@response
	\long\xdef\@response{\unexpanded\expandafter{\@old@response \\ \noexpand\hline}}
}

%\makeatother

%\let\oldemph\emph
%\renewcommand{\emph}[1]{\textbf{\oldemph{#1}}}