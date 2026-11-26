module Automata
  ( Automata(..)
  , crearCentrado
  , crearAleatorio
  , paso
  , mostrarAutomata
  ) where

import Data.Bits (testBit)

-- guarda los datos del automata en cada turno
data Automata = Automata
  { celdas     :: [Bool]
  , regla      :: Int
  , generacion :: Int
  } deriving (Show, Eq)

-- arma la fila inicial con una sola celula viva justo al medio
crearCentrado :: Int -> Int -> Automata
crearCentrado r ancho =
  let centro = ancho `div` 2
      fila   = [ i == centro | i <- [0 .. ancho - 1] ]
  in Automata { celdas = fila, regla = r, generacion = 0 }

-- arma el automata usando una fila al azar que le pasamos
crearAleatorio :: Int -> [Bool] -> Automata
crearAleatorio r fila =
  Automata { celdas = fila, regla = r, generacion = 0 }

-- ve si la celula vive o muere segun sus vecinas y la regla
-- pasa los 3 estados a un numero del 0 al 7 para revisar esa posicion en la regla
aplicarRegla :: Int -> (Bool, Bool, Bool) -> Bool
aplicarRegla r (izq, cen, der) =
  let indice = (if izq then 4 else 0)
             + (if cen then 2 else 0)
             + (if der then 1 else 0)
  in testBit r indice

-- junta cada celula con sus dos vecinas conectando los bordes de la fila
vecindades :: [Bool] -> [(Bool, Bool, Bool)]
vecindades []  = []
vecindades [x] = [(x, x, x)]
vecindades xs  =
  let n          = length xs
      ciclo      = cycle xs
      izquierdas = take n (drop (n - 1) ciclo)
      derechas   = take n (drop 1 ciclo)
  in zip3 izquierdas xs derechas

-- avanza el automata a la siguiente generacion
paso :: Automata -> Automata
paso aut =
  let nuevasCeldas = map (aplicarRegla (regla aut)) (vecindades (celdas aut))
  in aut { celdas = nuevasCeldas, generacion = generacion aut + 1 }

-- pasa la fila a texto usando # para las vivas y espacios para las muertas
mostrarAutomata :: Automata -> String
mostrarAutomata aut =
  map (\viva -> if viva then '#' else ' ') (celdas aut)