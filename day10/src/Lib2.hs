{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Missing NOINLINE pragma" #-}
{-# LANGUAGE TupleSections #-}
module Lib2 where

import GHC.IO (unsafePerformIO)
import Data.List (findIndex, elemIndex, intercalate)
import Data.Maybe (fromJust)

datitos :: String
datitos = unsafePerformIO $ readFile "datitos/facil.txt"

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

caracterEn :: Posicion -> Char
caracterEn (columna, fila) = (mapa !! fila) !! columna

posicionesConectadasA :: Posicion -> [Posicion]
posicionesConectadasA posicion@(columna, fila) = case caracterEn posicion of
    '|' -> [arriba, abajo]
    '-' -> [izquierda, derecha]
    'L' -> [arriba, derecha]
    'J' -> [arriba, izquierda]
    '7' -> [abajo, izquierda]
    'F' -> [abajo, derecha]
    'S' -> filter (elem posicion . posicionesConectadasA) [arriba, abajo, izquierda, derecha]
    '.' -> []
    x -> error (show x)
    where
        arriba = (columna, fila-1)
        abajo = (columna, fila+1)
        izquierda = (columna-1, fila)
        derecha = (columna+1, fila)

-- >>> proximoPaso [posicionInicial] posicionInicial
-- (1,2)

-- Parte 2

todasLasPosiciones :: [Posicion]
todasLasPosiciones = [(columna, fila)| fila <- [0..length mapa - 1], columna <- [0..length (head mapa) - 1]]

cantidadPuntosAdentro :: Int
cantidadPuntosAdentro = length puntosAdentro

puntosAdentro :: [Posicion]
puntosAdentro = filter estáDentroDeCiclo . filter esGround $ todasLasPosiciones

estáDentroDeCiclo :: Posicion -> Bool
estáDentroDeCiclo posicion = odd . contarParedes $ paredesAbajoDe posicion

contarParedes :: [Char] -> Int
contarParedes = contarParedes' . filter (`notElem` ['|', 'S'])
    where
        contarParedes' [] = 0
        contarParedes' ('-':cs) = 1 + contarParedes' cs
        contarParedes' ('F':'L':cs) = contarParedes' cs
        contarParedes' ('7':'J':cs) = contarParedes' cs
        contarParedes' ('F':'J':cs) = 1 + contarParedes' cs
        contarParedes' ('7':'L':cs) = 1 + contarParedes' cs
        contarParedes' cs = error cs

paredesAbajoDe :: Posicion -> [Char]
paredesAbajoDe (columna, fila) = map caracterEn posicionesAbajoEnCiclo
    where
        filasAbajo = [fila..length mapa - 1]
        posicionesAbajo = map (columna,) filasAbajo
        posicionesAbajoEnCiclo = filter (`elem` ciclo) posicionesAbajo

esGround :: Posicion -> Bool
esGround = (`notElem` ciclo)

-- >>> cantidadPuntosAdentro
-- 29
