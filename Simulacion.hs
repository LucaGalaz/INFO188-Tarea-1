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

-- imprime desde la generación 0 hasta la n
simular :: Int -> Automata -> IO ()
simular n ini = evalStateT (mostrar >> replicateM_ n (pasoM >> mostrar)) ini
