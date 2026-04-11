\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fiwthesis}[2025/10/01 FIW Thesis]

% TODO print-specific options
\newlength\@bindingoffset
\setlength\@bindingoffset{0cm}

\newlength\@lmargin
\setlength\@lmargin{30mm}

\newlength\@rmargin
\setlength\@rmargin{30mm}

\newlength\@tmargin
\setlength\@tmargin{15mm}

\newlength\@bmargin
\setlength\@bmargin{15mm}

\newif\if@en
\newif\if@bild
\newif\if@picky

%% additional information in the same fashion as `\author' and `\date'
\DeclareRobustCommand*\thesis[1]{\gdef\@thesis{#1}}                %% type of thesis
\DeclareRobustCommand*\supervisor[1]{\gdef\@supervisor{#1}}        %% first supervisor
\DeclareRobustCommand*\secsupervisor[1]{\gdef\@secsupervisor{#1}}  %% second supervisor
\DeclareRobustCommand*\keywords[1]{\gdef\@keywords{#1}}            %% keywords

\def\@thesis{\@latex@warning@no@line{No \noexpand\thesis given}}
\def\@authors{} % TODO: add an author check
\def\@supervisor{}
\def\@secsupervisor{}
\gdef\@keywords{}

%% ===============
%%  Class Options
%% ===============

%% special document settings for printing
\DeclareOption{print}{%
  % TODO CMYK and FOGRA39 for print
  % TODO set binding offset
  % TODO pass option `cmyk' to package `xcolor'
  \OptionNotUsed
}

%% switch to english mode
\DeclareOption{en}{\@entrue}

%% set default image caption title
\DeclareOption{bild}{\@bildtrue}

%% enable special options
\DeclareOption{picky}{\@pickytrue}

%% pass remaining options to class `scrreprt'
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrreprt}}

%% process class options
\ProcessOptions\relax

%% load class `scrreprt' with required options
\LoadClass[
  fontsize=12pt,
  oneside,
  a4paper,
  parskip=half,
  listof=totoc,
  headsepline=on,
  bibliography=totoc,
  numbers=noenddot,
  captions=tableheading,
]{scrreprt}

%% ===================
%%  Required Packages
%% ===================

\RequirePackage{ifluatex}
\ifluatex
  \if@picky{%
    %% text encoding and special font support
    \RequirePackage[no-math]{fontspec}
    \RequirePackage[english,german]{selnolig}}
  \fi
\else
  \PackageError{fiwthesis}{Wrong compiler; LuaLaTeX required}
\fi

%% index creation
\RequirePackage{imakeidx}

%% include graphics in various formats
\RequirePackage{graphicx}

%% colors (must to be loaded before `pgfplots')
\RequirePackage[table]{xcolor}

%% source code listings
\RequirePackage{listings}

%% page geometry
\RequirePackage[
  left=\@lmargin,
  right=\@rmargin,
  top=\@tmargin,
  bottom=\@bmargin,
  includeheadfoot,
  % bindingoffset=0,
]{geometry}

%% KOMA script header
\RequirePackage[
  markcase=used,
  headsepline=0.5pt,
  plainheadsepline=on
]{scrlayer-scrpage}

%% suppress scrreprt warning
\RequirePackage{scrhack}

%% adjust spacing of list environments
\RequirePackage{enumitem}

%% appendices
\RequirePackage[
  title,
  titletoc,
  header
]{appendix}

\if@en
  \RequirePackage[english]{babel}
\else
  \RequirePackage[ngerman]{babel}
\fi

%% global numbering
\RequirePackage{chngcntr}

%% PDF hyperlinks
% TODO use colored links for the digital version
\RequirePackage[
  hidelinks,
  hyperindex=true,
  pdfpagelabels=true,
  breaklinks=true,
  colorlinks=false
]{hyperref}

%% glossary and list of acronyms
\RequirePackage[
  acronym=true,
  toc=true,
  counter=page,
  style=super, % XXX will be overwritten
  translate=babel
]{glossaries}

\RequirePackage{xltabular}

\RequirePackage[normalem]{ulem}

%% special quotation marks
\RequirePackage{csquotes}

%% bibliography settings
\RequirePackage[
  style=numeric,  %% IEEE style
  sorting=nyt,
  sortcites,      %% sort references by appearance
  backend=biber   %% use modern bibliography backend
]{biblatex}

%% enumeration tools
\RequirePackage{etoolbox}

%% file trees
\RequirePackage{dirtree}

\RequirePackage{setspace}

\RequirePackage{xparse}
\RequirePackage{array}

%% ========
%%  Colors
%% ========

%% charcoal / gray (HKS 97)
\definecolor{hswgray}{RGB/HTML}{47,50,41/2F3229}

%% silver / light gray (HKS 99)
\definecolor{hswlgray}{RGB/HTML}{175,175,175/AFAFAF}
\definecolor{hswsilver}{RGB/HTML}{175,175,175/AFAFAF}

%% blue (HKS 50) -- faculty of engineering
\definecolor{hswblue}{RGB/HTML}{0,177,219/00B1DB}
\colorlet{fiwblue}{hswblue}

%% green (HKS 65) -- business school
\definecolor{hswgreen}{RGB/HTML}{51,153,51/339933}
\colorlet{fwwgreen}{hswgreen}

%% orange (HKS 7) -- faculty of architecture and design
\definecolor{hsworange}{RGB/HTML}{255,93,2/FF5D02}
\colorlet{fgorange}{hsworange}

%% ==============
%%  Localization
%% ==============

\gdef\@titlepagefaculty{\if@en{Faculty of Engineering}\else{Fakultät für Ingenieurwissenschaften}\fi}
\gdef\@titlepagetitle{\if@en{Title Page}\else{Titelseite}\fi}
\gdef\@tasktitle{\if@en{Task}\else{Aufgabenstellung}\fi}
\gdef\@toctitle{\if@en{Contents}\else{Inhaltsverzeichnis}\fi}
\gdef\@apptitle{\if@en{Appendix}\else{Anhang}\fi}
\gdef\@mediatitle{\if@en{Data Carrier}\else{Datenträger}\fi}

\gdef\@infosubmission{\if@en{Submitted on}\else{Eingereicht am}\fi}
\gdef\@infoby{\if@en{by}\else{von}\fi}
\gdef\@infoborn{\if@en{born}\else{geboren am}\fi}
\gdef\@infoin{in}
\gdef\@infosupervisor{\if@en{Supervisor}\else{Betreuer}\fi}
\gdef\@infosubervisor{\if@en{Second Supervisor}\else{Zweitbetreuer}\fi}

\gdef\@lbibtitle{\if@en{Bibliography}\else{Literaturverzeichnis}\fi}
\gdef\@lacrtitle{\if@en{List of Acronyms}\else{Abkürzungsverzeichnis}\fi}
\gdef\@lsymtitle{\if@en{List of Symbols}\else{Symbolverzeichnis}\fi}
\gdef\@lalgtitle{\if@en{List of Algorithms}\else{Algorithmenverzeichnis}\fi}

\gdef\@doiwtitle{\if@en{Declaration of Independent Work}\else{Selbstständigkeitserklärung}\fi}
\gdef\@doiwplace{\if@en{Place}\else{Ort}\fi}
\gdef\@doiwdate{\if@en{Date}\else{Datum}\fi}
\gdef\@doiwsign{\if@en{Signature}\else{Unterschrift}\fi}
\gdef\@doiwtext{%
\if@en{%
  I hereby declare that I completed this work independently and that I have used no aids other than those referenced.
  \par The parts of the work, which include phrases or points taken from other sources, are clearly marked with the origin of the information.
  This also applies to diagrams, sketches, visual representations as well as for sources from the Internet.
  \par I also declare that I have not submitted this work in any other testing procedure as an examination paper, nor will I in the future.
  \par The submitted written work corresponds to the electronic version.
  I agree that an electronic copy may be made and stored to enable verification by anti-plagiarism software.
  }\else{%
  Hiermit erkläre ich, dass ich die vorliegende Arbeit selbständig verfasst und keine anderen als die angegebenen Hilfsmittel benutzt habe.
  Die Stellen der Arbeit, die anderen Quellen im Wortlaut oder dem Sinn nach entnommen wurden, sind durch Angaben der Herkunft kenntlich gemacht.
  Dies gilt auch für Zeichnungen, Skizzen, bildliche Darstellungen sowie für Quellen aus dem Internet.
  \par Ich erkläre ferner, dass ich die vorliegende Arbeit in keinem anderen Prüfungsverfahren als Prüfungsarbeit eingereicht habe oder einreichen werde.
  \par Die eingereichte schriftliche Arbeit entspricht der elektronischen Fassung.
  Ich stimme zu, dass eine elektronische Kopie gefertigt und gespeichert werden darf, um eine Überprüfung mittels Anti-Plagiatssoftware zu ermöglichen.
  }
  \fi
}

%% autoref labels
\if@en{%
\addto\extrasenglish{%
  \def\chapterautorefname{Chapter}%
  \def\sectionautorefname{Section}%
  \def\subsectionautorefname{Subsection}%
  \def\subsubsectionautorefname{Subsubsection}%
}%
}\else{%
}\fi

\gdef\@thesestitle{\if@en{Theses}\else{Thesen}\fi}

%% ==================
%%  Class Properties
%% ==================

%% always show the chapter name in the header
\automark*{chapter}
\clearpairofpagestyles{}
\rohead*{\headmark}
\renewcommand{\chaptermarkformat}{\if@en{Chapter}\else{Kapitel}\fi~\thechapter{}.\hspace{0.65em}}

%% show page numbers in the footer
\rofoot*{\thepage}

\pagestyle{scrheadings}

%% customize fonts
\setkomafont{sectioning}{\rmfamily\bfseries}          %% section titles
\setkomafont{caption}{\small}                         %% captions
\setkomafont{captionlabel}{\sffamily\bfseries\small}  %% caption labels
\setkomafont{chapterentry}{\small\bfseries}           %% TOC entry
\setkomafont{chapter}{\large\bfseries}                %% chapter
\setkomafont{section}{\normalsize}                    %% section
\setkomafont{subsection}{\normalsize}                 %% subsection
\setkomafont{subsubsection}{\normalsize}              %% subsubsection
\setkomafont{pageheadfoot}{\small}                    %% header and footer

%% customize listings
\lstset{%
  captionpos=b,
  abovecaptionskip=11pt,
  belowcaptionskip=-10pt,
  showstringspaces=false,
  basicstyle=\ttfamily\small,
  frame=single,
}

%% global continuous numbering for floats
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\AtBeginDocument{%
  \counterwithout{lstlisting}{chapter}
}

%% spacing between captions and floats
\setlength{\textfloatsep}{17pt}
\setlength{\floatsep}{15pt}
\setlength{\intextsep}{17pt plus 3pt minus 0pt}
\setlength{\belowcaptionskip}{-5pt}
\setlength{\abovecaptionskip}{11pt}
% \setlength{\parskip}{1cm plus4mm minus3mm}

%% suppress indentation after line breaks in long captions
\setcapindent{0em}

\AtBeginDocument{\onehalfspacing}

%% adjust spacing after section headings
\RedeclareSectionCommand[
  beforeskip=0.8\baselineskip,
  runin=false,
  afterskip=0.3\baselineskip
]{section}

\RedeclareSectionCommand[
  beforeskip=0.8\baselineskip,
  runin=false,
  afterskip=0.3\baselineskip
]{subsection}

\RedeclareSectionCommand[
  beforeskip=0.8\baselineskip,
  runin=false,
  afterskip=0.3\baselineskip
]{subsubsection}

%% spacing of list environments
\setlist{itemsep=-0.25\baselineskip}

%% penalties for breaking long URLs
\setcounter{biburllcpenalty}{9000}
\setcounter{biburlucpenalty}{9000}

\if@bild
  \renewcaptionname{ngerman}{\figurename}{Bild}
  \renewcommand{\listfigurename}{Bildverzeichnis}
\else
  \renewcaptionname{ngerman}{\figurename}{Abb.}
\fi

% \if@en
%   \relax
% \else
%   \SetupFloatingEnvironment{listing}{listname=Quellcodeverzeichnis}
% \fi

%% define macros for front matter and main matter, because they don't exist in `scrreprt`'
\newcommand*{\frontmatter}{\pagenumbering{roman}\setcounter{page}{1}}
\newcommand*{\mainmatter}{\pagenumbering{arabic}\setcounter{page}{1}}

\newcommand{\normalspacing}{\onehalfspacing}

% Author storage
\newcounter{authorcount}
\setcounter{authorcount}{0}

% Store for complete author information
\newcommand\@authorinfo{}

% Command to add an author
\renewcommand*{\author}[4]{%
    \ifnum\value{authorcount}=0    
        \gdef\@authors{#1} % Add name to authors list without comma
        \gdef\@authorinfo{%
            #1 
            \ifx\relax#2\relax % Check if matrikel number (field #2) is empty
                \\ % Do nothing if #2 is empty
            \else % If #2 is not empty print matrikelnumber with brackets
                (#2) \\
            \fi
            \ifx\relax#3\relax % Check if birth date (#3) is empty
            \else % If #3 is not empty
                \ifx\relax#4\relax % Check if  birth place (#4) is empty
                    % Do nothing if #4 is empty
                \else
                    % Both #3 and #4 are non-empty, include the birth info line
                    & \@infoborn~#3~\@infoin~#4 \\
                \fi
            \fi
            & \\
        }%
    \else    
        \expandafter\gdef\expandafter\@authors\expandafter{\@authors, #1} % Append name to authors list with comma
        \expandafter\gdef\expandafter\@authorinfo\expandafter{\@authorinfo
            & #1 
            \ifx\relax#2\relax % Check if matrikel number (field #2) is empty
                \\ % Do nothing if #2 is empty
            \else % If #2 is not empty print matrikelnumber with brackets
                (#2) \\
            \fi
            \ifx\relax#3\relax % Check if birth date (#3) is empty
            \else % If #3 is not empty
                \ifx\relax#4\relax % Check if  birth place (#4) is empty
                    % Do nothing if #4 is empty
                \else
                    % Both #3 and #4 are non-empty, include the birth info line
                    & \@infoborn~#3~\@infoin~#4 \\
                \fi
            \fi
            & \\
        }%
    \fi
    \stepcounter{authorcount}
}

\newcommand*{\makeinfo}{%
    \begin{tabular}{rl}
        \@infosubmission:     & \@date \\
                              & \\
        \@infoby:             & \@authorinfo
        \ifx\@supervisor\empty\else
            \@infosupervisor: & \@supervisor \\
        \fi
        \ifx\@secsupervisor\empty\else
            \@infosubervisor: & \@secsupervisor \\
        \fi
    \end{tabular}%
}

%% title page
\renewcommand{\maketitle}{%
  \pdfbookmark{\@titlepagetitle}{\@titlepagetitle}
  \begin{titlepage}
    \thispagestyle{empty}
    \setlength\headsep{-5mm}

    \begin{figure}[!h]
      \begin{minipage}{0.77\textwidth}
        \begin{flushleft}
          \textbf{Hochschule Wismar}\\
          University of Applied Sciences\\
          Technology, Business and Design\\
          \@titlepagefaculty\\
          \rule{\textwidth}{0.5pt}
        \end{flushleft}
      \end{minipage}
      \hspace*{\fill}
      \begin{minipage}{0.19\textwidth}
        \begin{flushright}
          \includegraphics[height=4cm]{FIW-Logo.pdf} % TODO switch between PDF and JPG depending on color model
        \end{flushright}
      \end{minipage}
    \end{figure}

    \begin{center}
      \vspace*{\fill} % centering Thesis and title in remaining space, after author info is placed
      \Huge
      \textbf{\@thesis}\\
      \vspace{2cm}
      \large\@title
      \vspace*{\fill} % centering Thesis and title in remaining space, after author info is placed
      \begin{table*}[b!] % set author info on this page on the bottom
        \makeinfo
      \end{table*}
    \end{center}

  \end{titlepage}
}

%% declaration of independent work
\newcommand*{\makedoiw}{%
  %% update header
  \markright{\@doiwtitle}

  \chapter*{\@doiwtitle}

  %% add this chapter to the TOC
  \addcontentsline{toc}{chapter}{\@doiwtitle}
  \@doiwtext
  \vspace{4cm}\\
  \begin{minipage}{0.5\textwidth}
    \@doiwplace,~\@doiwdate
  \end{minipage}
  \begin{minipage}{0.5\textwidth}
    \@doiwsign
  \end{minipage}
  % \newpage
}

%% thanks, https://tex.stackexchange.com/a/159170
\DeclareListParser*{\fortheseslist}{;}
\newcommand{\makeitemize}[1]{%
  \begin{itemize}[itemsep=0.33\baselineskip]
    \fortheseslist{\makeitemize@item}{#1}
  \end{itemize}
}
\newcommand{\makeitemize@item}[1]{\item{#1}}

%% theses (last page)
\newcommand{\maketheses}[1]{
  \newpage

  %% clear page style
  \clearpairofpagestyles
  \KOMAoptions{headsepline=0pt}

  \RedeclareSectionCommand[
    beforeskip=0.25\baselineskip,
    afterskip=0.25\baselineskip
  ]{chapter}

  \pdfbookmark{\@thesestitle}{theses}

  \chapter*{\@thesestitle}

  \textbf{\@thesis}

  \medskip

  \textbf{\@title}

  \medskip

  %% name, matriculation number, supervisors
  \begin{table*}[h]
    \makeinfo
  \end{table*}

  \medskip

  \makeitemize{#1}
}

\newcommand*{\thethesis}{\@thesis}
\newcommand*{\thetitle}{\@title}

%% wrapper for bibliography
\newcommand{\listofreferences}[1][]{%
  \printbibliography[
    title=\@lbibtitle\label{bib},
    #1  % insert other options here
  ]
}

%% wrapper for list of acronyms
\newcommand*{\listofacronyms}{%
  \printglossary[
    title=\@lacrtitle,
    toctitle=\@lacrtitle,
    type=\acronymtype,
  ]{}
}

%% wrapper for list of symbols
\newcommand*{\listofsymbols}{%
  \printglossary[
    type=symbolslist,
  ]{}
}

%% wrapper for list of listings
\newcommand*{\listoflistings}{%
  \lstlistoflistings
}

%% suppress hyphenation
\newcommand*{\nohyp}[1]{\mbox{#1}}

%% create a list of symbols
\newglossary[slg]{symbolslist}{syi}{syg}{\@lsymtitle}

%% define a new glossary style to utilize the entire text width
\newglossarystyle{superx}{%
  \setglossarystyle{super}
  \renewenvironment{theglossary}%
  {\xltabular{\textwidth}{lX}}{\endxltabular}
}
\setglossarystyle{superx}

%% appendices
\if@en
  \relax
\else
  \renewcommand{\appendixname}{\@apptitle}
  \renewcommand{\appendixpagename}{{\@apptitle}n}
\fi

\AtBeginEnvironment{appendices}{%
  \renewcommand{\chaptermarkformat}{\@apptitle~\thechapter{}.\hspace{0.65em}}
}

%% PDF metadata
\newcommand*{\makepdfmetadata}{%
  \hypersetup{%
    pdfauthor={\@authors},
    pdftitle={\@title},
    pdfsubject={\@thesis},
    pdfkeywords={\@keywords},
  }
}

%% task (placeholder)
\newcommand{\maketask}[1]{%
  \pdfbookmark{\@tasktitle}{task}
  \thispagestyle{empty}
  \markright{\@tasktitle}
  \section*{\@tasktitle}
  #1
  \newpage
}

%% abstract
\newcommand{\makeabstract}[2]{%
  \pdfbookmark{\if@en{Abstract}\else{Kurzfassung/Abstract}\fi}{abstract}
  \markright{\if@en{Abstract}\else{Kurzfassung}\fi}

  \section*{Kurzfassung}
  #1

  \section*{Abstract}
  #2

  \newpage{}
}

%% table of contents
\newcommand*{\maketoc}[1][]{%
  \def\contentsname{\@toctitle}
  \def\toc@compact{compact}
  \def\toc@arg{#1}%
  \ifx\toc@arg\toc@compact
    \singlespacing
  \fi
  \pdfbookmark{\@toctitle}{toc}
  \tableofcontents
  \setcounter{chapter}{0}
  \normalspacing
  \newpage
}

%% attached data carrier (CD, SD card)
\newcommand{\makecd}[1]{%
  \pdfbookmark{\@mediatitle}{cd}

  \markright{\@mediatitle}

  \chapter*{\@mediatitle}

  \setlength{\DTbaselineskip}{20pt}

  #1

  \newpage{}
}

%% combination of glossary entry and acronym
%% see: https://en.wikibooks.org/wiki/LaTeX/Glossary#Dual_entries_with_reference_to_a_glossary_entry_from_an_acronym
\DeclareDocumentCommand{\newdualentry}{ O{} O{} m m m m } {
  \newglossaryentry{gls-#3}{name={#5}, text={#5\glsadd{#3}}, description={#6}, #1}
  \makeglossaries
  \newacronym[see={[\if@en{Glossary}\else{Glossar}\fi:]{gls-#3}},#2]{#3}{#4}{#5\glsadd{gls-#3}}
}

%% new environment for landscape A3 pages for long tables, big figures, etc.
%% this actually doesn't do anything, but is used to mark the beginning and end of such pages
\newenvironment{a3page}{}{}

%% change the paper format without triggering a typearea warning
\BeforeBeginEnvironment{a3page}{%
\newpage
\KOMAoptions{paper=a3,paper=landscape,pagesize=auto,DIV=current} % this might cause some typearea warnings
\recalctypearea
\newgeometry{%
  layoutwidth=420mm,  % hardcoded A3 height
  layoutheight=297mm, % hardcoded A3 width
  left=\@lmargin,
  right=\@rmargin,
  top=\@tmargin,
  bottom=\@bmargin,
  includeheadfoot,
}
}

\AfterEndEnvironment{a3page}{%
\newpage
\KOMAoptions{paper=a4,paper=portrait,pagesize=auto,DIV=last}
\recalctypearea
\restoregeometry
}