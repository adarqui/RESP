{-# LANGUAGE OverloadedStrings #-}
module Main (
 main
) where

import Protocol.RESP (request)
import Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Char8 as B (pack)
import Criterion.Config (Config(..), defaultConfig, cfgPerformGC, ljust)
import Criterion.Main (defaultMainWith, bgroup, bench, nf)

config :: Config
config = defaultConfig {
 cfgPerformGC = ljust True
}

pack :: Int -> Int -> [ByteString]
pack size count = map B.pack $ foldl (\x _ -> replicate size 'A' : x) [] [1..count]

packIncr :: Int -> Int -> [ByteString]
packIncr start finish = map B.pack $ scanl (\x y -> show y ++ x) [] [start..finish]

main :: IO ()
main = do
 let packedMicro = pack 1 iter
 let packedModerate = pack 1024 iter
 let packedLarge = pack 10024 iter
-- let packedExtraLarge = pack 100024 iter
 let packedIncremental = packIncr 1 iter

 defaultMainWith config (return ()) [
  bgroup "Requests" [
    bench "Micro data" $ nf request packedMicro,
    bench "Moderate data" $ nf request packedModerate,
    bench "Large data" $ nf request packedLarge,
--    bench "ExtraLarge data" $ nf request packedExtraLarge,
    bench "Incremental data" $ nf request packedIncremental
   ]
  ]
 return ()
 where
  iter = 10000
