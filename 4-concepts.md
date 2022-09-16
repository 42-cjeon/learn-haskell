# 자주 쓰이는 함수 / 클래스

## List

### map (lift)

- `map :: (a -> b) -> t a -> t b`

  리스트의 모든 원소에 대해서 주어진 함수를 실행하고, 그 결과를 반환

  ex.)
  ```haskell
  map (*2) [1, 2, 3, 4]
  -- [2, 4, 6, 8]
  ```

### foldr, foldl (reduce)

- `fold :: (a -> b -> b) -> b -> t a -> b`

  리스트의 맨 앞 원소부터 `(앞서 실행한 함수 반환값, 현재 원소)`를 인자를 받은 함수를 실행한 결과를 반환
  foldr은 왼쪽 -> 오른쪽 순서로 인자를 처리하고
  foldl은 오른쪽 -> 왼쪽 순서로 인자를 처리함

  ex.)
  ```haskell
  -- 실행할 함수 (인자를 2개 받는 함수), 초기값, 적용할 리스트
  foldr (+) 0 [1..100]
  -- 5050
  ```

### filter

- `filter :: (a -> Bool) -> t a -> t a`

  원소 하나를 받아 `Boolean`을 반환하는 함수를 받고, 그 함수를 리스트의 모든 원소에 적용시킨 후, `True`를 반환하는 원소만을 걸러서 새로운 리스트로 만듬

  ex.)
  ```haskell
  -- 실행할 함수 (인자를 2개 받는 함수), 초기값, 적용할 리스트
  filter (<10) [1, 5, 10, 20, 30]
  -- [1, 5]
  ```

## General

- Required는 해당 클래스에 속하기 위해 꼭 구현해야 하는 함수임,

- Optional은 Required에서 자동으로 유도되지만, 성능을 위해 따로 구현할 수 있는 함수임.

- 설명에서 자주 사용할 `Maybe`는 `Monad`에 속함.
  
  주로 상황에 따라서 값이 유효하지 않을 수 있을 때 사용함
    - `Nothing` -> 유효하지 않은 값
    - `Just a`  -> 유효한 값

  간략한 타입 선언은 `newtype Maybe a = Nothing | Just a`

### Class `Functor`

#### Required
  - `fmap :: (a -> b) -> t a -> t b`
    
    map 의 일반화된 버전. `Functor` 조건을 만족하려면 무조건 구현해야 함.

    중위 연산자 버전으로 `<$>`, 역방향 중위 연산자 버전으로 `<&>`을 사용할 수 있음.

    fmap의 구현은 반드시 아래 조건을 만족해야 함.
      - (identity) `fmap id == id`
      - (composition) `fmap (f . g) == fmap f . fmap g`

    ex.)
    ```haskell
    fmap (*2) $ Just 2
    --- Just 4
    fmap (*2) Nothing
    --- Nothing
    ```
#### Optional
  - `<$ :: a -> t b -> t a`

    `t b`에서 모든 `b` 원소를 `a` 원소로 대체함.

    기본 정의는 `fmap . const`임

    ex.)
     ```haskell
    1 <$ (Just 2)
    --- Just 1
    1 <$ Nothing
    --- Nothing
    ```
  - `$> :: f a -> b -> f b`
    
    `<$` 의 `flip` 버전.
  

### Class `Applicative`

`Functor`를 내포함

#### Required
  - `pure :: a -> t a`

    `a` 타입을 `t a` 타입으로 변환함.

    모든 `Applicative`는 `pure`를 구현하기 때문에, 문맥에 결과 타입 `t`가 변할 수 있음

    ex.)
    ```haskell
    -- in file pure.hs
    add :: Maybe Int -> Maybe Int -> Maybe Int
    add x y = case (x, y) of
      (Just x', Just y') -> Just (x' + y')
      _ -> Nothing
    
    -- in ghci
    add (pure 1) (pure 2)
    -- Just 3
    ```

  - `<*> :: t (a -> b) -> t a -> t b`
    
    Apply 라고 읽음.

    `map`과는 다르게 `a -> b`가 아니라 `t (a -> b)`를 첫 인자로 받음.

    ex.)
    ```haskell
    Nothing <*> Just 2
    --- Nothing

    Just (*2) <*> Just 2
    --- Just 4

    Just (*2) <*> Nothing
    --- Nothing
    ```

    만약 `liftA2`가 구현되어있으면 거기에서부터 유도할 수 있음.
    
    `(<*>) = liftA2 id`

#### Optional

  - `(*>) :: f a -> f b -> f b`

    첫번째 인자를 무시함

    ex.)
    ```haskell
    Just 2 *> Just 3
    -- Just 3
    Nothing *> Just 3
    -- Nothing
    ```

  - `(<*) :: f a -> f b -> f a`

    두 번째 인자를 무시함
   
### Class `Monad`

`Applicative`를 내포함

  - `>>= :: t a -> t (a -> b) -> t b`

    bind 라고 읽음.