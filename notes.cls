\NeedsTeXFormat{LaTeX2e}                                                        % what even is 2e
\LoadClassWithOptions{article}                                                  % load? or not? with options? or not?
\ProvidesClass{notes}[2022/03/31 Notes class]

% ==================== packages ==================== %

\RequirePackage[T1]{fontenc}                                                    % so fonts/accents work? idk
\RequirePackage[utf8]{inputenc}                                                 % dont know what exactly this does either
\RequirePackage[margin = 1in]{geometry}                                         % just copying over from template... maybe i can guess what this does
\RequirePackage{newpxtext}                                                      % palatino?
\RequirePackage{newpxmath}                                                      % palatino.
\RequirePackage{amsmath}                                                        % of course
\RequirePackage{amssymb}                                                        % this gives `\mathbb` and internally loads `amsfonts` and maybe does other stuff
\RequirePackage{esint}                                                          % fancy integrals
\let \openbox \relax                                                            % something in newpxtext / newpxmath defines \openbox and it breaks amsthm
\RequirePackage{amsthm}
\RequirePackage[framemethod = TikZ]{mdframed}                                   % boxes
\RequirePackage{enumitem}                                                       % https://tinyurl.com/use-enumitem
\RequirePackage{graphicx}                                                       % for `\includegraphics`
\RequirePackage{fancyhdr}                                                       % for header
\RequirePackage{hyperref}                                                       % for links
\RequirePackage{microtype}                                                      % for good spacing
\RequirePackage{xcolor}                                                         % for colors
\RequirePackage{xifthen}                                                        % for conditionals and `\isempty`
\RequirePackage{tikz-cd}
\usetikzlibrary{arrows, automata, positioning}
\RequirePackage{pgfplots}
\pgfplotsset{compat = 1.17}

% ==================== page setup ==================== %

\linespread{1.2}                                                                % this is more comfortable
\setlength{\parindent}{0pt}                                                     % dont need em
\setlength{\parskip}{0.8ex}                                                     % wow i didnt know default for `\parskip` was 0
\let \olditemize \itemize
\let \endolditemize \enditemize
\renewenvironment{itemize}{\begin{olditemize}[topsep = 0pt]}{\end{olditemize}}
\let \oldenumerate \enumerate
\let \oldendenumerate \endenumerate
\renewenvironment{enumerate}{\begin{oldenumerate}[topsep = 0pt]}{\end{oldenumerate}}

% ==================== variables ==================== %

\newcommand{\var}[2]{                                                           % ok now this is definitely hacking
  \expandafter\providecommand\expandafter{\csname #1\endcsname}[1]%
    {\expandafter\renewcommand\expandafter{\csname @#1\endcsname}{##1}}
  \expandafter\providecommand\expandafter{\csname @#1\endcsname}{#2}
}

\newcommand{\varswitch}[2]{
  \expandafter\providecommand\expandafter{\csname #1\endcsname}%
    {\expandafter\renewcommand\expandafter{\csname @#1\endcsname}{true}}
  \expandafter\providecommand\expandafter{\csname not#1\endcsname}%
    {\expandafter\renewcommand\expandafter{\csname @#1\endcsname}{false}}
  \expandafter\providecommand\expandafter{\csname @#1\endcsname}{#2}
}

\newcommand{\varcommand}[2]{
  \expandafter\providecommand\expandafter{\csname #1\endcsname}[1]%
    {\expandafter\renewcommand\expandafter{\csname @#1\endcsname}%
    {\csname ##1\endcsname}}
  \expandafter\providecommand\expandafter{\csname @#1\endcsname}%
    {\csname #2\endcsname}
}

\var{class}{Class}
\varswitch{usingsection}{true}
\varswitch{usingsubsection}{true}

% ==================== header ==================== %

\pagestyle{fancy}                                                               % fancy = good :sunglasses:

\lhead{}
\chead{\@class{}}
\rhead{}

% ==================== title page ==================== %

\renewcommand{\maketitle}{
  \thispagestyle{plain}                                                         % no header on this page
  
  \vspace*{20ex}
  \begin{center}
    { \Large \@class{} }

    \today
  \end{center}
  
  \newpage
}

\AtBeginDocument{\maketitle}                                                    % force make title page at beginning of document

% ==================== equation numbering ==================== %

\AtBeginDocument{
  \ifthenelse{\equal{\@usingsection}{true}}
  {
    \ifthenelse{\equal{\@usingsubsection}{true}}
    {
      \renewcommand{\theequation}{\arabic{section}.\arabic{subsection}.%
        \arabic{equation}}
    }{
      \renewcommand{\theequation}{\arabic{section}.\arabic{equation}}
    }
  }{
    \renewcommand{\theequation}{\arabic{equation}}
  }
}

% ==================== counter ==================== %

\newcounter{cnt}
\AtBeginDocument{
  \ifthenelse{\equal{\@usingsection}{true}}
  {
    \ifthenelse{\equal{\@usingsubsection}{true}}
    {
      \renewcommand{\thecnt}{\arabic{section}.\arabic{subsection}.\arabic{cnt}}
    }{
      \renewcommand{\thecnt}{\arabic{section}.\arabic{cnt}}
    }
  }{
    \renewcommand{\thecnt}{\arabic{cnt}}
  }
}

\AtBeginDocument{
  \ifthenelse{\equal{\@usingsection}{true}}
  {
    \ifthenelse{\equal{\@usingsubsection}{true}}
    {
      \let \oldsubsection \subsection
      \renewcommand{\subsection}[1]{\oldsubsection{#1} \setcounter{cnt}{0}}
    }{
      \let \oldsection \section
      \renewcommand{\section}[1]{\oldsection{#1} \setcounter{cnt}{0}}
    }
  }{}
}

% ==================== definition & lemma & theorem & corollary ==================== %

\newcommand{\newtheoremenvironment}[2]{                                         % https://texblog.org/2015/09/30/fancy-boxes-for-theorem-lemma-and-proof-with-mdframed/

  \newenvironment{#1}[1][]
  {
    \refstepcounter{cnt}
    \ifstrempty{##1}{
      \mdfsetup{
        frametitle = {
          \tikz[baseline = (current bounding box.east), outer sep = 0pt]
          \node[anchor = east, rectangle, fill = black, text = white]
          {\strut #2~\thecnt};
        }
      }
    }{
      \mdfsetup{
        frametitle = {
          \tikz[baseline = (current bounding box.east), outer sep = 0pt]
          \node[anchor = east, rectangle, fill = black, text = white]
          {\strut #2~\thecnt:~##1};
        }
      }
    }
    \mdfsetup{
      innertopmargin = 2pt, 
      innerbottommargin = 8pt, 
      skipabove = 12pt, 
      skipbelow = 2pt, 
      linecolor = black,
      linewidth = 2pt, 
      topline = true,
      frametitleaboveskip = \dimexpr-\ht\strutbox\relax
    }
    \begin{mdframed}\phantomsection\label{#1:\thecnt}
  }{
    \end{mdframed}
  }
}

\newtheoremenvironment{defn}{Definition}
\newtheoremenvironment{lem}{Lemma}
\newtheoremenvironment{thm}{Theorem}
\newtheoremenvironment{cor}{Corollary}

% ==================== proof ==================== %

\newenvironment{prf}
{
  \textit{Proof.}
}{
  \qed
}

% ==================== example ==================== %

\newenvironment{eg}
{
  \refstepcounter{cnt}
  \textbf{Example \thecnt.}\phantomsection\label{eg:\thecnt}
}{}

% ==================== note & remark ==================== %

\newenvironment{note}
{
  \textbf{Note.}
}{}

\newenvironment{rmk}
{
  \textbf{Remark.}
}{}