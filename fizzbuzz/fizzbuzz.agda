module fizzbuzz where

open import IO               using    (run; putStrLn)
open import Function         using    (_$_; _∘_)
open import Data.Nat         using    (ℕ)
open import Data.Nat.Show    using    (show)
open import Data.Nat.DivMod  using    (_mod_)
open import Data.Fin         using    (toℕ)
open import Data.String      using    (String; unlines; _++_)
open import Data.List        using    (List; [_]; map; _∷_; []; drop; reverse)
open import Data.Bool        using    (if_then_else_)
open import Agda.Builtin.Nat using    (_==_; zero; suc)

fizzbuzz : ℕ → String
fizzbuzz n =
  if (toℕ $ n mod 15) == 0 then "fizzbuzz" else
  if (toℕ $ n mod  5) == 0 then     "buzz" else
  if (toℕ $ n mod  3) == 0 then "fizz"     else (show n)

unwords : List String → String
unwords List.[]  = ""
unwords (x ∷ xs) = x ++ " " ++ unwords xs

private ιlem : ℕ → List ℕ
ιlem zero    = [ 0 ]
ιlem (suc n) = (suc n) ∷ (ιlem n)

ι : ℕ → List ℕ
ι = reverse ∘ ιlem

[_to_] : ℕ → ℕ → List ℕ
[ n to m ] = drop n $ ι m

main : _
main = run ∘ putStrLn ∘ unwords $ map fizzbuzz [ 1 to 100 ]
