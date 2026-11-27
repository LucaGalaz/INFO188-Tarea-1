module Simulacion
  ( paso
  , simular
  ) where

import Control.Monad (replicateM_)
import Control.Monad.State
import Automata (Automata)
import qualified Automata as Aut

-- avanza una generación usando la mónada State
paso :: State Automata ()
paso = modify Aut.paso

-- el mismo paso, pero sirve también dentro de StateT (para poder imprimir)
pasoM :: MonadState Automata m => m ()
pasoM = state (runState paso)

-- imprime la generación actual
mostrar :: StateT Automata IO ()
mostrar = do
  a <- get
  liftIO (putStrLn (Aut.mostrarAutomata a))

-- imprime exactamente n filas: la condición inicial y n-1 pasos
simular :: Int -> Automata -> IO ()
simular n ini
  | n <= 0    = return ()
  | otherwise = evalStateT (mostrar >> replicateM_ (n - 1) (pasoM >> mostrar)) ini