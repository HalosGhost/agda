\documentclass{article}

\usepackage{fontspec,tabu,mathtools,enumitem}
\usepackage{minted}
\newminted[code]{agda}{}
\usepackage[autostyle]{csquotes}

\setromanfont[Mapping=tex-text]{Linux Libertine O}
\setmonofont[Mapping=tex-text]{Pragmata Pro}

\begin{document}

This document is an exploration of Literate Programming
\footnote{A term coined by Donald E. Knuth to refer to structuring code addressed to a reader rather than a computer.}
in Agda
\footnote{A Programming language descended from Haskell with a focus on dependent typing and theorem proving.}
.
As a result, this document is both runnable source-code and a valid \LaTeX document.

Without further introduction, I would like to dive into the programming project for today: a fizzbuzz
\footnote{A very simple, introductory programming problem.}
.

\section{The Problem}
Most typically, the fizzbuzz problem can be described as follows:

\begin{quote}
    Given the range of numbers \([1,100]\), print each number.
    If the number is divisible by \(3\), print ``fizz'' instead of the number.
    If the number is divisible by \(5\), print ``buzz'' instead of the number.
    If the number is divisible by both \(3\) and \(5\), print ``fizzbuzz'' instead of the number.
\end{quote}

Given this definition, there are already a few things we clearly need:

\begin{itemize}
    \item{Some definition of numbers}
    \item{A range function to create a container full of the numbers we need}
    \item{A mapping function that can be applied to the container to get the necessary strings}
    \item{A way to print the strings to the screen}
\end{itemize}

And now, armed with the problem definition and a basic list of what we need, let us start coding!

\section{The Code}

Though module definitions are technically optional in Agda, it is good practice to give all modules a representative name.
Additionally, Agda requires that module names reflect our filename; so, for the purposes of this program, we will use the module name \verb|fizzbuzz| and assume that our filename is \verb|fizzbuzz.lagda|.

\begin{code}
module fizzbuzz where
\end{code}

Now, we can begin filling out the definitions to meet our list of requirements.
The Agda standard library offers a definition of ℕ which we can use for our numbers:

\begin{code}
open import Data.Nat         using (ℕ)
open import Data.Nat.Show    using (show)
open import Data.Nat.DivMod  using (_mod_)
open import Data.Fin         using (toℕ)
open import Agda.Builtin.Nat using (_==_; zero; suc)
open import Data.Bool        using (if_then_else_; false) renaming (Bool to 𝔹)
open import Function         using (_$_; _∘_)
\end{code}

A few of these imports will be obvious (e.g., the type constructor and the show function to create a String), however, some of these may be less transparent.
We will need the \verb|_mod_| operator to test divisibility.
And, due to how \verb|_mod_| is defined, it returns a \verb|Fin|, not a ℕ, so we will need \verb|toℕ| to convert the result back to a natural number.
The \verb|_==_| operator is also needed for testing divisibility, and the \verb|zero| and \verb|suc| data constructors are necessary only to give some of our functions a little sugar syntax without causing trouble for Agda's termination checker
\footnote{
Agda, unlike many other languages, requires that all programs terminate (meaning it is not a Turing-complete language).
This simplifies a lot of problems and eliminates several whole classes of bugs (while of course disallowing many otherwise-valid programs).
}.
We also import a self-explanatory function for booleans (\verb|if_then_else_|), a data constructor for it (we will only need \verb|false|, not \verb|true|), and renaming the type constructor to 𝔹 to remain consistent.
Finally, we import two functions for functional syntax (these could be replaced with parentheses, but make the program far simpler to read).

Now that we have imported everything needed for numbers and the basic part of our logic, we can begin defining some functions:

\begin{code}
_is-divisible-by_ : ℕ → ℕ → 𝔹
(suc n) is-divisible-by (suc m) = (toℕ $ (suc n) mod (suc m)) == zero
_       is-divisible-by _       = false
\end{code}

This definition offers us the ability to now write out divisibility tests in nearly plain English.
A more obvious definition is as follows:

\begin{verbatim}
_is-divisible-by_ : ℕ → ℕ → 𝔹
0 is-divisible-by _ = false
_ is-divisible-by 0 = false
n is-divisible-by m = (toℕ $ n mod m) == 0
\end{verbatim}

However, Agda will inform you that the above definition fails to pass the decidability checker, hence the more elaborate definition above which uses the native data constructors rather than the sugar literals.
With this definition of divisibility checking, we can define the core of the program:

\begin{code}
open import Data.String      using (String; _++_)

fizzbuzz : ℕ → String
fizzbuzz n =
  if n is-divisible-by 15 then "fizzbuzz" else
  if n is-divisible-by  5 then     "buzz" else
  if n is-divisible-by  3 then "fizz"     else (show n)
\end{code}

Testing if \(n\) is divisible by \(15\) is simply a more efficient way to test if \(n\) is divisible by both \(3\) and \(5\).
We will be using the \verb|_++_| operator in a later function.

Now, we can move on to one of the more interesting parts of this task for Agda.
Unlike many other programming languages, Agda does not include a function to generate a range of numbers in the standard library, so we will have to define on ourselves.
Luckily, such a function is simple if you have a definition of Lists:

\begin{code}
open import Data.List        using (List; [_]; _∷_; []; map; drop; reverse)
\end{code}

Here, we import the basic type constructor and three data constructors (along with three other functions which will be of use later).

One simple way to create a range of numbers is to start by generating a list of all numbers.
The definition of Lists in Agda would allow us to accomplish this in two ways: appending members with concatenation or prepending members with the \verb|_∷_| operator (and then reversing the list since it will be backwards.
Both are valid conceptually, but prepending followed by reversal happens to be far more performant, so we will follow the latter option.

\begin{code}
private
  ι-helper : ℕ → List ℕ
  ι-helper zero    = [ 0 ]
  ι-helper (suc n) = (suc n) ∷ (ι-helper n)
\end{code}

Again, you may have a cleaner definition in-mind, but if you use the sugar literals too-often, you may find Agda's decidability checker struggling.
With this helper function, we can now create a function that will give us the correctly-ordered list of numbers:

\begin{code}
ι : ℕ → List ℕ
ι = reverse ∘ ι-helper
\end{code}

We use \verb|ι| in reference to APL's range operator which used the same name.
While we do not actually need to define any further sugar syntax for the range, it would be nice if we could select an arbitrary (increasing) range of natural numbers, so we move on to define the following (similar to the \verb|[n..m]| syntax available in Haskell).

\begin{code}
[_,_] : ℕ → ℕ → List ℕ
[ n , m ] = drop n $ ι m
\end{code}

With the above definitions, we can now use \verb|map fizzbuzz [ 1 , 100 ]| to create a list of strings.
Now, all that is left is printing them; for the sake of simplicity, we will choose to define \verb|unwords| which is a function that collapses a list of strings into a single string by interspersing them with spaces:

\begin{code}
unwords : List String → String
unwords List.[]  = ""
unwords (x ∷ xs) = x ++ " " ++ unwords xs
\end{code}

Now, finally we can import our IO-required functions and define our \verb|main| function:

\begin{code}
open import IO               using (run; putStrLn)

main : _
main = run ∘ putStrLn ∘ unwords $ map fizzbuzz [ 1 , 100 ]
\end{code}

\section{The Conclusion}
This is one of the more verbose fizzbuzz implementations you may find in the wild.
\footnote{Excepting those which are specifically aiming for verbosity out of a sense of humor or satire.}
All told, the basic source code of this program is \oldstylenums{31} sloc.
Of course, we could easily make it shorter by simply defining less sugar syntax; however, one of the mor enjoyable parts of this exercise (at least in the author's opinion) was to create the missing pieces that most languages would provide.

\end{document}
