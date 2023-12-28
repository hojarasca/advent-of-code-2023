{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Missing NOINLINE pragma" #-}
module Lib () where

import Text.Parsec
import GHC.IO (unsafePerformIO)
import Data.List (findIndex, elemIndex)
import Data.Maybe (fromJust)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

datitos :: String
datitos = unsafePerformIO $ readFile "datitos/data.txt"

mapa :: [[Char]]
mapa = lines datitos

type Posicion = (Int, Int)

posicionInicial :: Posicion
posicionInicial = (columnaInicial, filaInicial)
    where
        filaInicial = fromJust $ findIndex (elem 'S') mapa
        columnaInicial = fromJust $ elemIndex 'S' (mapa !! filaInicial)

ciclo :: [Posicion]
ciclo = go [posicionInicial] posicionInicial
    where
        go yaVisitadas posicionActual = case proximoPaso yaVisitadas posicionActual of
            Nothing -> yaVisitadas
            Just siguiente -> go (siguiente:yaVisitadas) siguiente

distanciaMaxima :: Int
distanciaMaxima = length ciclo `div` 2

-- >>> distanciaMaxima
-- 6870

headOption :: [Posicion] -> Maybe Posicion
headOption [] = Nothing
headOption xs = Just (head xs)

proximoPaso :: [Posicion] -> Posicion -> Maybe Posicion
proximoPaso posicionesVisitadas posicionActual =
    headOption $ filter (`notElem` posicionesVisitadas) $ posicionesConectadasA posicionActual

posicionesConectadasA :: Posicion -> [Posicion]
posicionesConectadasA (columna, fila) = case (mapa !! fila) !! columna of
    '|' -> [arriba, abajo]
    '-' -> [izquierda, derecha]
    'L' -> [arriba, derecha]
    'J' -> [arriba, izquierda]
    '7' -> [abajo, izquierda]
    'F' -> [abajo, derecha]
    'S' -> filter (elem (columna, fila) . posicionesConectadasA) [arriba, abajo, izquierda, derecha]
    _ -> error ""
    where
        arriba = (columna, fila-1)
        abajo = (columna, fila+1)
        izquierda = (columna-1, fila)
        derecha = (columna+1, fila)

-- >>> proximoPaso [posicionInicial] posicionInicial
-- (1,2)
