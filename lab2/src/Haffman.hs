{-# LANGUAGE DeriveGeneric #-}

module Haffman where

import GHC.Generics
import Weighted

data HaffmanTree a = HaffmanLeaf a | HaffmanNode (HaffmanTree a) (HaffmanTree a)
    deriving(Show, Eq, Generic)

createHaffmanTree :: a -> HaffmanTree a
createHaffmanTree = HaffmanLeaf

mergeHaffmanTree :: HaffmanTree a -> HaffmanTree a -> HaffmanTree a
mergeHaffmanTree = HaffmanNode

type WeightedHaffmanTree a = Weighted (HaffmanTree a)

createWeightedHaffmanTree :: Int -> a -> WeightedHaffmanTree a
createWeightedHaffmanTree w = WeightedPair w . createHaffmanTree

mergeWeightedHaffmanTree :: WeightedHaffmanTree a -> WeightedHaffmanTree a -> WeightedHaffmanTree a
mergeWeightedHaffmanTree (WeightedPair w1 ht1) (WeightedPair w2 ht2) =
    WeightedPair (w1 + w2) (mergeHaffmanTree ht1 ht2)
