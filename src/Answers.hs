module Answers where

import Types

import Data.Maybe
import qualified Data.Set as S
import qualified Data.Map as M
import qualified Data.HashSet as H
import qualified Data.Algorithms.KMP as KMP
import qualified Data.Vector as V

{- | Find most frequently occuring elts in list

Clarifying questions
  - What if no elts in list?
  - What if there's a tie in frequency?

I am choosing to model the result as a set of the
the item(s) with maximal frequency.

Strategy notes:
  - Build map from items to their frequency
  - Find the maximal frequency in the map
  - Filter map for only keys with that frequency
  - Return keys as result set

Time complexity:
  occurrenceGroups: n log n
  maxFrequency: n
  filter: n
  keysSet: n
  = n log n + 3n ~ n log n
-}
mostFreq :: Ord a => [a] -> S.Set a
mostFreq xs =
  let grouped = occurrenceGroups xs
      maxFrequency = M.foldr max 0 grouped in
  M.keysSet $
    M.filter (==maxFrequency) grouped

{- | Helper for array frequency questions

Complexity: n log n
  insertWith: log n
-}
occurrenceGroups :: Ord a => [a] -> M.Map a Int
occurrenceGroups = foldr
  (\k m -> M.insertWith (+) k 1 m) M.empty

{- | Find pairs of integers in a list which add to n.

Clarifying assumptions
  - No duplicate pairs allowed
  - Output canonical pairs, i.e. (a,b) for a <= b

Strategy notes:
  - Populate a hash set of values present in the array
  - Traverse each and search for its additive complement
  - If found add unordered pair to result set

Naive quadratic implementation with ordered pairs
  \ns -> [(a,b) | a <- ns, b <- ns, a+b==n]

Time complexity: for arbitrary list length but bounded W
  H.fromList: n*min(10, W) ~ n (for small W)
  H.member: min(10, W) ~ 1
  H.insert: min(10, W) ~ 1
  = n + n*(1 + 1 + 1) ~ n
-}
adders :: Int -> [Int] -> H.HashSet (UnorderedPair Int)
adders n is = foldr
  (\i result ->
    if H.member (n-i) values
       then H.insert (makeUnordered (i, n-i)) result
       else result
  ) H.empty values
 where values = H.fromList is

{- | Are two lists rotations of one another?

Strategy notes:
  - The idea is to do a sublist search with modular arithmetic
  - Avoid modular arithmetic by self-concatenating one of the strings
  - Then use a standard substring search

Naive quadratic implementation
  \u v -> any (u==) [ rotate i v | i <- [0..V.length v - 1] ]
    where
      rotate i = (\(a,b) -> b V.++ a) . V.splitAt i

Time complexity:
  length: n
  KMP.build: n
  KMP.match n+m
  (++): n+m
  = n + n + 2n + n + 2n + n ~ n
-}
cycleEq :: Eq a => [a] -> [a] -> Bool
cycleEq a b = length a == length b &&
  (not . null $ KMP.match (KMP.build a) (b++b))

{- | Find the only element in an array which occurs only once.

Clarifying questions
  - What if there is none? More than one?

I am choosing to model the result as a set of the
the item(s) which occur exactly once.

Strategy notes:
  - Similar to finding the most frequent item
  - Build map from items to their frequency
  - Filter map for keys with one occurrence
  - Return keys as result set

Complexity:
  occurrenceGroups: n log n
  maxFrequency: n
  filter: n
  keysSet: n
  = n log n + 2n ~ n log n
-}
loners :: Ord a => [a] -> S.Set a
loners = M.keysSet . M.filter (==1) . occurrenceGroups

{- | Find the common elements of two lists

Strategy
  - The standard library implementation dodges the question
  - I'll do it properly when writing the data structures by hand

Complexity:
  S.fromList: n log n
  S.intersection: m+n
  = n log n + m + n + m log m ~ n log n (for n similar to m)
-}
commonElts :: Ord a => [a] -> [a] -> S.Set a
commonElts a b = S.fromList a `S.intersection` S.fromList b

{- | Binary search in a sorted array

Assumption
  - Input sorted in ascending order

Strategy
  - Divide and conquer with indices

Complexity
  log n
-}
searchSorted :: Ord a => a -> V.Vector a -> Maybe Int
searchSorted a ar =
  inRange 0 (V.length ar - 1)
 where
  inRange lo hi
    | lo > hi = Nothing
    | a == guess = Just mid
    | a > guess = inRange (mid+1) hi
    | a < guess = inRange lo (mid-1)
    where
      mid = (hi+lo) `div` 2
      guess = ar V.! mid

{- | Binary search in a sorted-then-rotated array

Assumption
  - Input was sorted in ascending order then rotated

Strategy
  - Generalization of binary search since sorted list is trivial rotation
  - At any pivot either the left or the right side is sorted (proof?)
  - If the left (right) is sorted and needle lies in its bounds then if the
    needle exists at all it must be on that side
  - Else if the needle exists it must be in the other side

Complexity
  log n
-}
searchRotated :: Ord a => a -> V.Vector a -> Maybe Int
searchRotated a ar =
  inRange 0 (V.length ar - 1)
 where
  inRange lo hi
    | lo > hi = Nothing
    | a == mdval = Just mid
    | losorted && loval <= a && a < mdval = inRange lo (mid-1)
    | hisorted && mdval < a && a <= hival = inRange (mid+1) hi
    | not losorted = inRange lo (mid-1)
    | not hisorted = inRange (mid+1) hi
    | otherwise = Nothing  --both sides sorted but elt not there
    where
      mid = (hi+lo) `div` 2
      loval = ar V.! lo
      mdval = ar V.! mid
      hival = ar V.! hi
      losorted = loval <= mdval
      hisorted = mdval < hival
