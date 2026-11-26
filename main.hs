module Main where

import qualified Automata as Aut

-- temporal para verificar Automata.hs, reemplazar por la simulación con State, CLI y opción --random

main :: IO ()
main = do
  let inicial = Aut.crearCentrado 90 31
      generaciones = take 8 (iterate Aut.paso inicial)
  mapM_ (putStrLn . Aut.mostrarAutomata) generaciones