module fizzbuzz where

open import IO               using (run; putStrLn)
open import Function         using (_$_; _∘_)
open import Data.Nat         using (ℕ)
open import Data.Nat.Show    using (show)
open import Data.Nat.DivMod  using (_mod_)
open import Data.Fin         using (toℕ)
open import Data.String      using (String; unlines; _++_)
open import Data.List        using (List; [_]; map; _∷_)
open import Data.Bool        using (if_then_else_)
open import Agda.Builtin.Nat using (_==_)

fizzbuzz : ℕ → String
fizzbuzz n =
  if (toℕ $ n mod 15) == 0 then "fizzbuzz" else
  if (toℕ $ n mod  5) == 0 then     "buzz" else
  if (toℕ $ n mod  3) == 0 then "fizz"     else (show n)

unwords : List String → String
unwords List.[]  = ""
unwords (x ∷ xs) = x ++ " " ++ unwords xs

lst : List ℕ
lst =  1 ∷  2 ∷  3 ∷  4 ∷  5 ∷  6 ∷  7 ∷  8 ∷  9 ∷ 10 ∷ 11 ∷ 12 ∷ 13 ∷ 14 ∷ 15 ∷
      16 ∷ 17 ∷ 18 ∷ 19 ∷ 20 ∷ 21 ∷ 22 ∷ 23 ∷ 24 ∷ 25 ∷ 26 ∷ 27 ∷ 28 ∷ 29 ∷ 30 ∷
      31 ∷ 32 ∷ 33 ∷ 34 ∷ 35 ∷ 36 ∷ 37 ∷ 38 ∷ 39 ∷ 40 ∷ 41 ∷ 42 ∷ 43 ∷ 44 ∷ 45 ∷
      46 ∷ 47 ∷ 48 ∷ 49 ∷ 50 ∷ 51 ∷ 52 ∷ 53 ∷ 54 ∷ 55 ∷ 56 ∷ 57 ∷ 58 ∷ 59 ∷ 60 ∷
      61 ∷ 62 ∷ 63 ∷ 64 ∷ 65 ∷ 66 ∷ 67 ∷ 68 ∷ 69 ∷ 70 ∷ 71 ∷ 72 ∷ 73 ∷ 74 ∷ 75 ∷
      76 ∷ 77 ∷ 78 ∷ 79 ∷ 80 ∷ 81 ∷ 82 ∷ 83 ∷ 84 ∷ 85 ∷ 86 ∷ 87 ∷ 88 ∷ 89 ∷ 90 ∷
      91 ∷ 92 ∷ 93 ∷ 94 ∷ 95 ∷ 96 ∷ 97 ∷ 98 ∷ 99 ∷ [ 100 ]

main : _
main = run ∘ putStrLn ∘ unwords $ map fizzbuzz lst
