module First where

import qualified Data.Text as T

input :: FilePath
input = "input.txt"

main :: IO ()
main = do
    inp <- readLines input
    print . uncurry solve $ parse inp

parse :: [String] -> (Integer, [Integer])
parse inp = (read $ head inp , map read . filter (/="x") . map T.unpack $ T.split (==',') (T.pack $ last inp))

readLines :: FilePath -> IO [String]
readLines = fmap lines . readFile

solve :: Integer -> [Integer] -> Integer
solve departing buses = a * b
    where (a, b) = minKey fst (map (\b -> (b - mod departing b, b)) buses)

minKey :: Ord b => (a -> b) -> [a] -> a
minKey f = foldr1 (\a b -> if f a < f b then a else b)
