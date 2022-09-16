# 하스켈 설치

## 언어 표준
  - [Haskell 98](https://www.haskell.org/onlinereport/)
  - [Haskell 2010](https://www.haskell.org/onlinereport/haskell2010/)

## 컴파일러
  - GHC (Glasgow Haskell Compiler)가 사실상의 표준

## 툴체인
  - 패키지 관리자
    - cabal
    - stack
  - HLS (haskell language server)
  - ghcup (haskell 툴체인 관리 도구)

## 설치 (vscode)
ghcup을 사용해서 설치

>$ curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

위의 명령을 사용하면 ghcup이 ~/.ghcup 위치에 설치됨.

다른 위치에 설치하려면 `GHCUP_INSTALL_BASE_PREFIX` 환경 변수를 설정해야 함

ex )
>$ export GHCUP_INSTALL_BASE_PREFIX=/Users/cjeon/goinfre

이후 vscode에서 [Haskell](https://marketplace.visualstudio.com/items?itemName=haskell.haskell) 확장을 설치하면 됨

