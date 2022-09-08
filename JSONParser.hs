{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}

module JSONParser where

import Data.Char (digitToInt, isDigit, isLower, isUpper)
import Data.List (intercalate)
import GHC.Generics (Generic)

data JValue
  = JNull
  | JBool Bool
  | JString String
  | JNumber Int
  | JArray [JValue]
  | JObject [(String, JValue)]
  deriving (Eq, Generic)

instance Show JValue where
  show value = case value of
    JNull -> "null"
    JBool True -> "true"
    JBool False -> "false"
    JString s -> showJString s
    JNumber k -> show k
    JArray arr -> "[" ++ intercalate ", " (map show arr) ++ "]"
    JObject obj -> "{\n" ++ intercalate ",\n" (map showKV obj) ++ "\n}"

showJString s = "\"" ++ s ++ "\""

showKV (k, v) = showJString k ++ ": " ++ show v

newtype Parser i o = Parser {parse :: i -> Maybe (i, o)}

-- _char1 :: Char -> String -> Parser String Char
-- _char1 _ [] = Nothing
-- _char1 c (x : xs)
--   | c == x = Just (xs, x)
--   | otherwise = Nothing

-- char1 :: Char -> Parser String Char
-- char1 c = Parser $ _char1 c

satisfy :: (a -> Bool) -> (a -> b) -> Parser [a] b
satisfy predicate transform = Parser $ \case
  (x : xs) | predicate x -> Just (xs, transform x)
  _ -> Nothing

char :: Char -> Parser String Char
char c = satisfy (== c) id

digit1 :: Parser String Int
digit1 = satisfy isDigit digitToInt

string1 :: String -> Parser String String
string1 s = case s of
  ""       -> Parser $ pure . (, "")
  (c : cs) -> Parser $ \i -> case parse (char c) i of
    Nothing -> Nothing
    Just (rest, _) -> fmap (c:) <$> parse (string1 cs) rest
  