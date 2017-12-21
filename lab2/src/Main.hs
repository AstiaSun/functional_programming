module Main where

import Haffman

main :: IO ()
main = do
    let res = createWeightedHaffmanTree 2 "a" > createWeightedHaffmanTree 3 "b"
    case res of
        True    -> putStrLn "True"
        False   -> putStrLn "False"
        _       -> error "Error"