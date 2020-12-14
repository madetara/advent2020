module Main where

import qualified Data.Text as T

input :: FilePath
input = "test.txt"

main :: IO ()
main = do
    inp <- readLines input
    print . solve $ parse inp

parse :: [String] -> [String]
parse inp = map T.unpack $ T.split (==',') (T.pack $ last inp)

readLines :: FilePath -> IO [String]
readLines = fmap lines . readFile

-- works but slow, see /brutforce
solve :: [String] -> Integer
solve buses = departionTime - fst longestPeriod
    where
        departionTime = head $ filter (consequtiveDeparture constrainedBuses (fst longestPeriod)) [0, (snd longestPeriod)..]
        constrainedBuses = reverse . snd $ foldl calcConstraints (0, []) buses
        longestPeriod = maxKey snd constrainedBuses

calcConstraints :: (Integer, [(Integer, Integer)]) -> String -> (Integer, [(Integer, Integer)])
calcConstraints (k, v) "x" = (k + 1, v)
calcConstraints (k, v) x = (k + 1, (k, read x) : v)

consequtiveDeparture :: [(Integer, Integer)] -> Integer -> Integer -> Bool
consequtiveDeparture schedule delay departure = all (\x -> mod (departure + fst x - delay) (snd x) == 0) schedule

maxKey :: (Ord b) => (a -> b) -> [a] -> a
maxKey f = foldr1 (\a b -> if f a > f b then a else b)
