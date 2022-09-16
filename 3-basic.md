# 기본적인 것들

## 주석

1줄 주석은 `--`이고 (C에서의 `//`)
여러줄 주석은 `{- ... -}`임 (C에서의 `/* ... */`)

## 타입

하스켈의 타입은  `a -> b` 처럼 표현됨. 이때 a, b는 C++의 `typename T`와 같은 임의의 자료형임.

따라서 `a -> b`라는 표현식은 임의의 타입 `a`를 받아 다른 임의의 타입 `b`를 반환하는 함수라고 생각할 수 있음

### Curring

하스켈의 모든 함수는 인자가 하나이고, 반환값도 하나인 함수임.
따라서 인자가 2개 이상인 함수를 표현하려면 `Curring`이라는 방법을 사용해야함

typescript 코드를 생각해 봤을 때
```ts

function add(a: number, b: number): number {
  return a + b
}

function curried_add(a: number): (b: number) => number {
  return (b: number) => {
    return a + b
  }
}
```
이때 `add(2, 3)`과 같은 동작을 하는 커리된 함수는 `curried_add(2)(3)`처럼 호출할 수 있음.

typescript에서는 add의 타입을 `(a: number, b: number) => number` 으로 표현하고,

curried_add의 타입을 `(a: number) => (b: number) => number`으로 표현할 수 있는데,

동등한 haskell에서의 타입은 `Int -> Int -> Int`임

haskell 타입 표현식은 Right-Associative이기 때문에 `Int -> (Int -> Int)`으로 생각할 수 있음.

## 함수

하스켈에서는 모든 것이 함수임.

`+ - $ <$> <*>` 같은 단순 연산자처럼 생긴 식별자도 함수임.

함수의 호출은 우선순위가 최상위이기 때문에 괄호 없이 함수를 호출할 수 있음.

ex.) `qsort [1, 2, 3]` 와 `qsort([1, 2, 3])`은 같은 의미를 가짐.

이때는 결합 방향이 Left-Associative이기 때문에 `(+1) (+2) 3` 같은 식은 유효하지 않음.
위 식을 올바르게 작성하려면 괄호를 추가해서 `(+1) ((+2) 3)` 으로 만들어야 함.

또는 연산자 우선순위가 낮고 아무런 일도 하지 않는 `$` 함수를 추가해서 `(+1) $ (+2) 3` 같이 괄호 없이 표현할 수 있음

함수는 `add x y = x + y`으로 정의할 수 있음. 좌측은 함수의 이름과, 인자를 정의하고, 우측은 동작을 정의함

같은 이름으로 인자의 형태가 다른 함수를 정의할 수 있음

ex.)
```haskell
isEmpty [] = True
isEmpty _ = False
```

다른 언어처럼 함수의 재귀 호출도 가능함. 명시적인 반복문 (for, while)문이 없는 haskell에게 재귀는 반복을 표현하는 주요한 방법임

ex.) 팩토리얼 계산
```haskell
fact 0 = 1
fact x = x * fact (x - 1)
```

### 익명 함수 (lambda)
이름이 없는 함수를 정의할 수 있음
`\x y -> x + y`

## 패턴 매칭
  다른 언어의 switch ... case과 비슷하지만 더 강력한 haskell의 문법으로, 인자의 __형태__ 를 기반으로 다른 동작을 하도록 만들 수 있음

ex.) 리스트의 맨 앞 원소를 가져오는 함수
```haskell
 -- l 의 형태에 따라서 맨 앞 원소를 가져오거나, 예외를 던진다.
getFront l = case l of
  -- x : xs 는 패턴의 일종으로 리스트의 원소가 1개 이상일 때 x는 맨 앞 원소,
  -- xs는 나머지 원소에 매칭된다.
  (x : xs) -> x
```

패턴 매칭에 실패할 경우 좌에서 우, 상에서 하 방향으로 다음 패턴을 시도하며, 모든 매칭이 실패했을 때 에러를 던짐.

`_`는 와일드카드로, 모든 형태에 매칭됨.

## 패턴 가드
인자의 __값__ 을 기반으로 다른 동작을 하도록 만들 수 있음

ex.)
```haskell
isOverTen x
  | x > 10 = True
  | otherwise = False
```

`=` 좌변에는 조건이 나오고(`Bool`) 우변에는 좌변이 `True`일 때 반환할 표현식이 나옴.

`otherwise`는 `True`와 같은데 패턴 가드의 가독성을 위해 존재함.
