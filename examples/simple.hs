{-# LANGUAGE OverloadedStrings #-}
module Main (
 main
) where

import Protocol.RESP (request, reply)
import System.Environment (getArgs)
import qualified Data.ByteString.Char8 as B (pack)

usage :: String
usage = "usage: ./simple <arg1> ... <argN>"

main :: IO ()
main = do
 argv <- getArgs
 case argv of
  [] -> putStrLn usage
  _ -> do
   let req = request $ map B.pack argv
   putStrLn $ "request: " ++ show req
   let rep = reply req
   putStrLn $ "reply: " ++ show rep
