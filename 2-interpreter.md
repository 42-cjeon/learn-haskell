# 하스켈 인터프리터

$ -> 사용자 쉘

????\> -> 하스켈 인터프리터

>$ ghci

위 명령으로 인터프리터를 실행시킬 수 있음

>\> :load filename

줄 맨 앞에 콜론이 오면 코드가 아닌, GHCI자체에 보내는 명령으로 취급됨

`:load` 명령은 `filename`에 해당하는 파일의 코드를 읽고 해석함

## 실습

```haskell
-- filename: sort.hs

qsort [] = []
qsort (x : xs) = l ++ [x] ++ r
  where
    l = qsort [y | y <- xs, y < x]
    r = qsort [y | y <- xs, y >= x]
```

위 내용을 sort.hs에 붙여넣은 뒤
> $ ghci

> Prelude\> :load sort.hs

> *Main\> qsort [5, 4, 6, 7, 3, 1, 2]

을 순서대로 입력했을 때 입력한 배열이 정렬되어 출력되는 것을 확인할 수 있음