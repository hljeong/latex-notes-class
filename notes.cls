\NeedsTeXFormat{LaTeX2e}                                                        % what even is 2e
\LoadClassWithOptions{article}                                                  % load? or not? with options? or not?
\ProvidesClass{notes}[2022/03/29 Notes class]

% ==================== packages ==================== %

\RequirePackage[T1]{fontenc}                                                    % so fonts/accents work? idk
\RequirePackage[utf8]{inputenc}                                                 % dont know what exactly this does either
\RequirePackage[margin = 1in]{geometry}                                         % just copying over from template... maybe i can guess what this does

\RequirePackage{amsmath}                                                        % of course
\RequirePackage{amssymb}                                                        % this gives `\mathbb` and internally loads `amsfonts` and maybe does other stuff
\RequirePackage{esint}                                                          % fancy integrals

\RequirePackage{enumitem}                                                       % https://tinyurl.com/use-enumitem

\RequirePackage{graphicx}                                                       % for `\includegraphics`

\RequirePackage{fancyhdr}                                                       % for header

\RequirePackage{hyperref}                                                       % for links

\RequirePackage{microtype}                                                      % for good spacing

\RequirePackage{xcolor}                                                         % for colors

\RequirePackage{xifthen}                                                        % for conditionals and `\isempty`

% ==================== page setup ==================== %

\linespread{1.2}                                                                % this is more comfortable
\setlength{\parindent}{0pt}                                                     % dont need em
\setlength{\parskip}{0.8ex}                                                     % wow i didnt know default for `\parskip` was 0

% ==================== variables ==================== %

\newcommand{\var}[2]{                                                           % ok now this is definitely hacking
  \expandafter\providecommand\expandafter{\csname #1\endcsname}[1]%
    {\expandafter\renewcommand\expandafter{\csname @#1\endcsname}{##1}}
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

% ==================== header ==================== %

\pagestyle{fancy}                                                               % fancy = good :sunglasses:

\lhead{\@class{}}                                                               % actual header content

% ==================== title page ==================== %

\renewcommand{\maketitle}{
  \thispagestyle{plain}                                                         % no header on this page
  
  \vspace*{20em}
  \begin{center}
    { \Large \@class{} }

    \today
  \end{center}
  
  \newpage
}

\AtBeginDocument{\maketitle}                                                    % force make title page at beginning of document