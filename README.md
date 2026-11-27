# INFO188 Tarea 1: Autómata celular 1D

Autómata celular elemental unidimensional en Haskell, con reglas de Wolfram (0 a 255) y bordes periódicos.

## Informe

Este tarea implementa en Haskell un autómata celular elemental unidimensional con reglas de Wolfram (0 a 255) y bordes periódicos. El autómata se modela como un registro Automata con las celdas ([Bool]), el número de regla y la generación actual. Para cada vecindad (izquierda, centro, derecha) se calcula un índice entre 0 y 7 (4*izq + 2*centro + der), y el nuevo valor de la celda es el bit de la regla en esa posición, obtenido con testBit. Los bordes son periódicos: la primera y la última celda son vecinas entre sí. La simulación usa la mónada State: paso :: State Automata () avanza una generación con modify, y la ejecución completa combina get y replicateM_ sobre StateT Automata IO para imprimir cada fila, sin pasar el estado a mano entre funciones. El programa se ejecuta como ./prog [-r|--random] <regla> <ancho> <generaciones>, valida los argumentos y parte, por defecto, con una sola célula viva al centro; con -r genera una condición inicial aleatoria mediante un generador congruencial lineal sembrado con la hora. Se utilizó IA como apoyo en el desarrollo, y el código fue revisado y comprendido por el equipo.

## Estructura

| Archivo | Contenido |
|---|---|
| `main.hs` | Parseo y validación de argumentos, condición inicial (centrada o aleatoria) |
| `Automata.hs` | Registro `Automata`, regla de Wolfram, vecindad periódica, `paso` |
| `Simulacion.hs` | Simulación con la mónada `State` (`paso :: State Automata ()`, `replicateM_`, `get`, `modify`) |
| `Makefile` | Compilación (`make`), ejecución de ejemplo (`make run`, `make random`), limpieza (`make clean`) |

## Modelo

```haskell
data Automata = Automata { celdas :: [Bool], regla :: Int, generacion :: Int }
```

La regla se aplica con `testBit regla i`, donde `i = 4*izq + 2*centro + 1*der`
(vecindad `111` = bit 7, ..., `000` = bit 0). Los bordes son periódicos: la
primera y la última celda son vecinas.

## Compilar y ejecutar

```
make
./prog [-r|--random] <regla> <ancho> <generaciones>
```

- `<regla>`: entero entre 0 y 255.
- `<ancho>`: entero >= 1.
- `<generaciones>`: entero >= 1 (número de filas impresas).
- `-r` / `--random`: condición inicial aleatoria (por defecto, una sola célula viva al centro).

Ante argumentos inválidos se imprime el error y el uso por `stderr` y el programa termina con código distinto de 0.

Ejemplo:

```
$ ./prog 90 31 8
```

## Extras

- **Condición inicial aleatoria**: generador congruencial lineal sembrado con la hora (sin dependencias externas).
- **Mónada State**: el estado no se pasa a mano; se usa `modify`, `get`, `state` y `replicateM_`.

## Requisitos

GHC con los paquetes `mtl` y `time` (vienen con la instalación estándar de GHC).