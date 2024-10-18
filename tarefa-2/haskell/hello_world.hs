module HelloWorld (hello) where

hello :: String
hello = "Hello, World!" -- create a function with arity 0 that returns a string

main :: IO()
main = print hello -- prints the return of function hello
