{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Missing NOINLINE pragma" #-}
module Lib where

import Text.Parsec
import GHC.IO (unsafePerformIO)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

datitos :: String
datitos = unsafePerformIO $ readFile "datitos/data.txt"

type Fila = [Int]

filas :: [Fila]
filas = fmap read . words <$> lines datitos

resultado :: Int
resultado = sum $ predecirSiguiente <$> filas

-- >>> diferenciasDe [0,3,6,9,12,15]
-- [3,3,3,3,3]
diferenciasDe :: Fila -> Fila
diferenciasDe [] = error "lista vacia"
diferenciasDe [_] = []
diferenciasDe (x:y:xs) = y - x : diferenciasDe (y:xs)

type Piramide = [Fila]

todosCeros :: Fila -> Bool
todosCeros = all (== 0)

-- >>> piramideDeDiferencias [0,3,6,9,12,15]
-- [[0,3,6,9,12,15],[3,3,3,3,3],[0,0,0,0]]
piramideDeDiferencias :: Fila -> Piramide
piramideDeDiferencias filaInicial
    | todosCeros filaInicial = []
    | otherwise = filaInicial : piramideDeDiferencias (diferenciasDe filaInicial)

-- [[0,3,6,9,12,15, B],
--   [3,3,3,3,3, A],
--    [0,0,0,0, 0]]

siguiente :: Int -> Int -> Int
siguiente diferencia anterior = diferencia + anterior

predecirSiguiente :: Fila -> Int
predecirSiguiente fila = foldr siguiente 0 (last <$> piramideDeDiferencias fila)
