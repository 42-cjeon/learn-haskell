-- Maybe 와 동일한 역할을 하는 Optional 타입 구현

data Optional a = Null | Value a deriving(Show)

instance Functor Optional where
  fmap f x = case x of
    Null -> Null
    Value x' -> Value (f x')
  
instance Applicative Optional where
  pure x = Value x

  f <*> x = case (f, x) of
    (Value f', Value x') -> Value (f' x')
    (_, _) -> Null

instance Monad Optional where
  a >>= b = case a of
    Null -> Null
    Value a' -> b a'
