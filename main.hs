import Data.Char (isAlphaNum)
import Text.ParserCombinators.ReadP

alphaNum = satisfy isAlphaNum

jString =
  do
    char '"'
    cs <- many1 alphaNum
    char '"'
    pure cs
    <++ error "parse error"

parse = readP_to_S