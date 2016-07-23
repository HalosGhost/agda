module hw where

open import IO       using (run; putStrLn)
open import Function using (_$_)

main : _
main = run $ putStrLn "Hello, World!"
