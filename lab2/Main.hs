module Main where

import System.Environment
import System.FilePath
import System.Directory
import Control.Arrow
import Data.List
import qualified Data.Map as M
import Data.Function


dir_walk :: FilePath -> (FilePath -> IO a) -> (FilePath -> [a] -> IO a) -> IO a

dir_walk top filefunc dirfunc = do
  isDirectory <- doesDirectoryExist top

  if isDirectory
    then do
      files <- getDirectoryContents top
      let nonDotFiles = filter (not . (`elem` [".", ".."])) files
      results <- mapM (\file -> dir_walk (top </> file) filefunc dirfunc) nonDotFiles
      dirfunc top results
    else
      filefunc top


--This typeclass is supposed to make life _a bit_ easier.

 class Eq a => Bits a where
     zer :: a
     one :: a

 instance Bits Int where
     zer = 0
     one = 1

 instance Bits Bool where
     zer = False
     one = True


--Codemap is generated from a Huffman tree. It is used for fast encoding.

 type Codemap a = M.Map Char [a]


--Huffman tree is a simple binary tree. Each leaf contains a Char and its weight.
--Fork (node with children) also has weight = sum of weights of its children.

 data HTree  = Leaf Char Int
             | Fork HTree HTree Int
             deriving (Show)

 weight :: HTree -> Int
 weight (Leaf _ w)    = w
 weight (Fork _ _ w)  = w

--The only useful operation on Huffman trees is merging, that is we take
--two trees and make them children of a new Fork-node.

 merge t1 t2 = Fork t1 t2 (weight t1 + weight t2)


--`freqList` is an utility function. It takes a string and produces a list
--of pairs (character, number of occurences of this character in the string).

 freqList :: String -> [(Char, Int)]
 freqList = M.toList . M.fromListWith (+) . map (flip (,) 1)

--`buildTree` builds a Huffman tree from a list of character frequencies
--(obtained, for example, from `freqList` or elsewhere).
--It sorts the list in ascending order by frequency, turns each (char, freq) pair
--into a one-leaf tree and keeps merging two trees with the smallest frequencies
--until only one tree is remaining.

 buildTree :: [(Char, Int)] -> HTree
 buildTree = bld . map (uncurry Leaf) . sortBy (compare `on` snd)
     where  bld (t:[])    = t
            bld (a:b:cs)  = bld $ insertBy (compare `on` weight) (merge a b) cs

--The next function traverses a Huffman tree to obtain a list of codes for
--all characters and converts this list into a `Map`.

 buildCodemap :: Bits a => HTree -> Codemap a
 buildCodemap = M.fromList . buildCodelist
     where  buildCodelist (Leaf c w)    = [(c, [])]
            buildCodelist (Fork l r w)  = map (addBit zer) (buildCodelist l) ++ map (addBit one) (buildCodelist r)
              where addBit b = second (b :)

--Simple functions to get a Huffman tree or a `Codemap` from a `String`.

 stringTree :: String -> HTree
 stringTree = buildTree . freqList

 stringCodemap :: Bits a => String -> Codemap a
 stringCodemap = buildCodemap . stringTree

--Time to do the real encoding and decoding!
--
--Encoding function just represents each character of a string by corresponding
--sequence of `Bit`s.

 encode :: Bits a => Codemap a -> String -> [a]
 encode m = concat . map (m M.!)

 encode' :: Bits a => HTree -> String -> [a]
 encode' t = encode $ buildCodemap t

--Decoding is a little trickier. We have to traverse the tree until
--we reach a leaf which means we've just finished reading a sequence
--of `Bit`s corresponding to a single character.
--We keep doing this to process the whole list of `Bit`s.

 decode :: Bits a => HTree -> [a] -> String
 decode tree = dcd tree
     where  dcd (Leaf c _) []        = [c]
            dcd (Leaf c _) bs        = c : dcd tree bs
            dcd (Fork l r _) (b:bs)  = dcd (if b == zer then l else r) bs

--main = do
--        [f,g] <- getArgs
--        s     <- readFile f
--        writeFile g s