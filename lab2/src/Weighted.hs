{-# LANGUAGE DeriveFunctor #-}

module Weighted ( Weighted(..) )where

data Weighted a = WeightedPair { _wWeight :: Int, _wItem   :: a
                        } deriving (Show, Functor)

instance Eq (Weighted a) where
    WeightedPair w1 _ == WeightedPair w2 _ = w1 == w2

instance Ord (Weighted a) where
    compare (WeightedPair w1 _) (WeightedPair w2 _) = compare w1 w2