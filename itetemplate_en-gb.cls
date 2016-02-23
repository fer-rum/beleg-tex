%% Definition der neuen Klasse basierend auf article
%% Optionen:
%%   npsec - Beginnt jeden Abschnitt auf einer neuen Seite.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{itetemplate_en-gb}[
	2003/09/20 preusser@ite.inf.tu-dresden.de, 
	2014/10/27 fredo.erxleben@tu-dresden.de]	

%%
%% TODO make this multilingual
%%

	
\LoadClass[
	BCOR1cm,
	DIV15,
	fontsize=11pt,%Satzspiegel
	titlepage,
	abstract=true,
	numbers=noenddot,%
	twoside, %% unrecognized option
	open=right,
	cleardoublepage,%
	chapterprefix=false,
	appendixprefix,%
	bibliography=totoc % bibliography in table of contents
]{scrreprt}

% Packages
\usepackage{times,mathptmx,color}
\usepackage[british]{babel}	% language choice
\usepackage[utf8]{inputenc}% Erlaubt direkte Umlauteingabe
\usepackage[T1]{fontenc}     % Automatische Trennung von Worten mit Umlauten
%\usepackage[dvips]{graphicx} % Zum Einbinden von .eps - Grafiken
% conflicts with tikz
% which already includes graphicx
\usepackage{scrpage2}        % Seitenstil
\usepackage{titling}
\usepackage{multicol}
\usepackage[colorlinks]{hyperref}
\usepackage[xindy, acronym, numberedsection, toc, nomain, nopostdot]{glossaries} % use option [toc] if you want the glossary to be in the table of contents
\usepackage[xindy]{imakeidx}
%\usepackage{chapterbib}
\usepackage{xcolor}
\usepackage{listings}
\usepackage{caption}
\usepackage{subcaption}


% Gliederung und Numerierung
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}

% Zeilenabstand
\linespread{1.15}

% Header and Footer
\clearscrheadings
\ohead{\pagemark}
\ihead{\headmark}
\setlength{\headheight}{4\baselineskip}
\setheadsepline{.5pt}
\automark[section]{chapter}
\renewcommand*{\chapterpagestyle}{empty}

% Floats
\renewcommand{\fps@figure}{!t}
\renewcommand{\fps@table}{!t}

% Beliebige Beschriftungsvergabe: \captionof{table}{Caption Text}
\renewcommand\captionof[1]{\def\@captype{#1}\caption}

% Headers of list of listings
\renewcommand\lstlistingname{Listing}
\renewcommand\lstlistlistingname{List of Listings}

% Dokumentanfang mit Präambelerzeugung
\newcommand{\preamble}{%

	\parbox{\linewidth}{
		\section*{Declaration of Academic Honesty}
		Hereby I declare, that I created this document at hand by myself, using only the mentioned sources and auxiliary means. 
		All quotations are marked as such.
		\vspace{25mm}

		\begin{tabular}{l@{\hspace{5mm}}p{4cm}}
			Dresden, \makeatletter\@date	&\\\cline{2-2}
											& \@author
		\end{tabular}
	}
	\mbox{}
	\vfill
	\subsection*{Trademarks}
	All trademarks remain property of their respective owners. 
	Unless otherwise specified, no association between the author and any trademark holder is expressed or implied. 
	No endorsement of the author is expressed or implied by the mention of such trademarks.

	\begin{abstract}
		\makeabstract
	\end{abstract}

	\tableofcontents
	\clearpage
	
	\begingroup
		\let\cleardoublepage\relax
		\let\clearpage\relax		

		\listoffigures
		\listoftables
		\lstlistoflistings
	\endgroup
	
}

\publishers{
	\parbox{\linewidth}{
		~\vspace{-5mm}\\
		\begin{center}
			Technische Universität Dresden\\
			Fakultät Informatik\\
			Institut für Technische Informatik\vspace{12mm}

			\normalsize\begin{tabular}{ll}
				Supervising Professor:	& \supervisingprof\\
				Supervisor:				& \supervisor
			\end{tabular}
		\end{center}
	}
}



%%
%% Special options for the title page
%%
\pretitle{
	\begin{center}
		\Large
		\sffamily
		\bfseries 
		\makeatletter\@subject\par
		\Huge
}
\posttitle{
	\par
	\end{center}
	\vskip 0.5em
}
\preauthor{
	\begin{center}
	\Large
	\bfseries
	\lineskip 0.5em%
}
\postauthor{
	\par
	\normalsize
	\normalfont
	Born \bornat in \bornin\\
	Matriculation number \matriculation\\
	\end{center}
}
\predate{
	~\vspace{50mm}
	\begin{center}
	\large
}
\postdate{
	\par
	\end{center}
}

% add publisher info
\renewcommand{\maketitlehookd}{	
	\makeatletter\@publishers
}


\let\@altdoc=\document
\let\end@altdoc=\enddocument
\renewenvironment{document}{%
\begin{@altdoc}%
\maketitle%
\begingroup
	\setcounter{page}{2}\renewcommand{\thepage}{}%
	\cleardoublepage
\endgroup
\preamble
\cleardoublepage%
\pagestyle{scrheadings}%
\setcounter{page}{1}\renewcommand{\thepage}{\arabic{page}}\sloppy%

% Selbstständigkeitserklärung und Marken-Disclaimer


}{\end{@altdoc}}

% Appendix mit kapiteleigener Seitennumerierung
\let\@altappendix=\appendix
\renewcommand{\appendix}{%
\cleardoublepage%
\@altappendix%
\let\@altchapter=\chapter%
\renewcommand{\chapter}{\cleardoublepage\setcounter{page}{1}\@altchapter}%
\renewcommand{\thepage}{\thechapter\,--\,\arabic{page}}%
}
