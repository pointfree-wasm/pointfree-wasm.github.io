-- |
-- Module:     Pointfree.Wasm
-- Copyright:  (c) Sergey Vinokurov 2024
-- License:    Apache-2.0 (see LICENSE)
-- Maintainer: serg.foo@gmail.com

module Pointfree.Wasm (pointfreeWasm) where

import Control.Monad
import Data.Foldable
import GHC.Wasm.Prim
import Pointfree (pointfree)

-- Ignore output here
foreign import javascript unsafe "new Array"
  js_emptyArr :: IO JSVal

foreign import javascript unsafe "$1.push($2)"
  js_push :: JSVal -> JSString -> IO JSVal

foreign export javascript "pointfreeWasm"
  pointfreeWasm :: JSString -> IO JSVal

mkArr :: IO JSVal
mkArr = js_emptyArr

pushArr :: JSVal -> JSString -> IO ()
pushArr arr str = void $ js_push arr str

pointfreeWasm :: JSString -> IO JSVal
pointfreeWasm input = do
  let input' = fromJSString input
  let results :: [String]
      results = pointfree input'
  arr <- mkArr
  for_ results $ \res ->
    pushArr arr $ toJSString res
  pure arr

_fromJSString' :: JSString -> String
_fromJSString' = fromJSString

_toJSString' :: String -> JSString
_toJSString' = toJSString
