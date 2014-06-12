{-# LANGUAGE OverloadedStrings #-}
module Protocol.RESP.Internal (
 renderRequest,
 request,
 parseReply,
 reply
) where

import Protocol.RESP.Include (Reply(..))

import Prelude hiding (error, take)
import Control.Applicative ((<$>),(<*),(*>))
import Data.Attoparsec (takeTill)
import Data.Attoparsec.Char8 hiding (takeTill)
import Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Char8 as B


-- Request --

request :: [ByteString] -> ByteString
request = renderRequest

renderRequest :: [ByteString] -> ByteString
renderRequest req = B.concat (argCnt:args)
 where
  argCnt = B.concat ["*", showBS (length req), crlf]
  args   = map renderArg req

renderArg :: ByteString -> ByteString
renderArg arg = B.concat ["$",  argLen arg, crlf, arg, crlf]
 where
  argLen = showBS . B.length

showBS :: (Show a) => a -> ByteString
showBS = B.pack . show

crlf :: ByteString
crlf = "\r\n"


-- Reply parsers --

reply :: ByteString -> Maybe Reply
reply input =
 case (parse parseReply input) of
  (Fail _ _ _) -> Nothing
  (Done _ r) -> Just r


parseReply :: Parser Reply
parseReply = choice [singleLine, integer, bulk, multiBulk, error]

singleLine :: Parser Reply
singleLine = SingleLine <$> (char '+' *> takeTill isEndOfLine <* endOfLine)

error :: Parser Reply
error = Error <$> (char '-' *> takeTill isEndOfLine <* endOfLine)

integer :: Parser Reply
integer = Integer <$> (char ':' *> signed decimal <* endOfLine)

bulk :: Parser Reply
bulk = Bulk <$> do
 len <- char '$' *> signed decimal <* endOfLine
 if len < 0
  then return Nothing
  else Just <$> take len <* endOfLine

multiBulk :: Parser Reply
multiBulk = MultiBulk <$> do
 len <- char '*' *> signed decimal <* endOfLine
 if len < 0
  then return Nothing
  else Just <$> count len parseReply
