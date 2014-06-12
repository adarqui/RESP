{-# LANGUAGE OverloadedStrings #-}
module Protocol.RESP.Include (
 Reply(..)
) where

import Data.ByteString.Char8 (ByteString)

-- |Low-level representation of replies from the Redis server.
data Reply =
 SingleLine ByteString
 | Error ByteString
 | Integer Integer
 | Bulk (Maybe ByteString)
 | MultiBulk (Maybe [Reply])
 deriving (Eq, Show)
