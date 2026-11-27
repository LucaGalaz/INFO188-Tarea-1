module Main (main) where

import Data.Bits (shiftR, testBit)
import Data.Time.Clock.POSIX (getPOSIXTime)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)
import Text.Read (readMaybe)

import Automata (crearAleatorio, crearCentrado)
import Simulacion (simular)

-- parametros ya validados de la linea de comandos
data Config = Config
  { aleatorio :: Bool
  , reglaN    :: Int
  , ancho     :: Int
  , gens      :: Int
  }

uso :: String
uso = "Uso: ./prog [-r|--random] <regla 0-255> <ancho >= 1> <generaciones >= 1>"

esFlagRandom :: String -> Bool
esFlagRandom a = a `elem` ["-r", "--random"]

-- convierte un argumento a entero o entrega un error claro
leerEntero :: String -> String -> Either String Int
leerEntero nombre s =
  case readMaybe s of
    Just n  -> Right n
    Nothing -> Left (nombre ++ " debe ser un entero, se recibio: " ++ show s)

-- parsea y valida los argumentos
parseArgs :: [String] -> Either String Config
parseArgs args =
  case filter (not . esFlagRandom) args of
    [r, w, g] -> do
      regla' <- leerEntero "<regla>" r
      ancho' <- leerEntero "<ancho>" w
      gens'  <- leerEntero "<generaciones>" g
      if regla' < 0 || regla' > 255
        then Left "<regla> debe estar entre 0 y 255"
        else if ancho' < 1
          then Left "<ancho> debe ser al menos 1"
          else if gens' < 1
            then Left "<generaciones> debe ser al menos 1"
            else Right (Config (any esFlagRandom args) regla' ancho' gens')
    _ -> Left "numero de argumentos incorrecto"

-- generador congruencial lineal simple (evita depender del paquete random)
siguiente :: Int -> Int
siguiente s = s * 6364136223846793005 + 1442695040888963407

-- n celdas al azar a partir de una semilla
filaAleatoria :: Int -> Int -> [Bool]
filaAleatoria n semilla =
  take n (map (\s -> testBit (s `shiftR` 33) 0) (drop 1 (iterate siguiente semilla)))

main :: IO ()
main = do
  args <- getArgs
  case parseArgs args of
    Left err -> do
      hPutStrLn stderr ("Error: " ++ err)
      hPutStrLn stderr uso
      exitFailure
    Right cfg -> do
      ini <-
        if aleatorio cfg
          then do
            t <- getPOSIXTime
            let semilla = fromIntegral (floor (t * 1000000) :: Integer)
            return (crearAleatorio (reglaN cfg) (filaAleatoria (ancho cfg) semilla))
          else return (crearCentrado (reglaN cfg) (ancho cfg))
      simular (gens cfg) ini