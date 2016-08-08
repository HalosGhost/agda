\documentclass{article}

\usepackage{fontspec,tabu,mathtools,enumitem}
\usepackage{minted}
\newminted[code]{agda}{}
\usepackage[autostyle]{csquotes}

\setromanfont[Mapping=tex-text]{Linux Libertine O}
\setmonofont[Mapping=tex-text]{Pragmata Pro}

\begin{document}
\begin{code}
module hw where

open import IO       using (run; putStrLn)
open import Function using (_$_)

main : _
main = run $ putStrLn "Hello, World!"
\end{code}
\end{document}
