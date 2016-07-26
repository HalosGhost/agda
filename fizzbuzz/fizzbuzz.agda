module fizzbuzz where

open import IO               using    (run; putStrLn)
open import Function         using    (_$_; _∘_)
open import Data.Nat         using    (ℕ)
open import Data.Nat.Show    using    (show)
open import Data.Nat.DivMod  using    (_mod_)
open import Data.Fin         using    (toℕ)
open import Data.String      using    (String; unlines; _++_)
open import Data.List        using    (List; [_]; map; _∷_; []; drop; reverse)
open import Data.Bool        using    (if_then_else_; false) renaming (Bool to 𝔹)
open import Agda.Builtin.Nat using    (_==_; zero; suc)

_is-divisible-by_ : ℕ → ℕ → 𝔹
(suc n) is-divisible-by (suc m) = (toℕ $ (suc n) mod (suc m)) == zero
_       is-divisible-by _       = false

fizzbuzz : ℕ → String
fizzbuzz n =
  if n is-divisible-by 15 then "fizzbuzz" else
  if n is-divisible-by  5 then     "buzz" else
  if n is-divisible-by  3 then "fizz"     else (show n)

unwords : List String → String
unwords List.[]  = ""
unwords (x ∷ xs) = x ++ " " ++ unwords xs

private
  ι-helper : ℕ → List ℕ
  ι-helper zero    = [ 0 ]
  ι-helper (suc n) = (suc n) ∷ (ι-helper n)

ι : ℕ → List ℕ
ι = reverse ∘ ι-helper

[_to_] : ℕ → ℕ → List ℕ
[ n to m ] = drop n $ ι m

main : _
main = run ∘ putStrLn ∘ unwords $ map fizzbuzz [ 1 to 100 ]
