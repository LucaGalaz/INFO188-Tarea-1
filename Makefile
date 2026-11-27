GHC = ghc
FLAGS = -O2 -Wall
TARGET = prog
SRC = main.hs Automata.hs Simulacion.hs

all: $(TARGET)

$(TARGET): $(SRC)
	$(GHC) $(FLAGS) main.hs -o $(TARGET)

run: $(TARGET)
	./$(TARGET) 90 31 8

random: $(TARGET)
	./$(TARGET) --random 30 41 20

clean:
	rm -f $(TARGET) $(TARGET).exe *.o *.hi

.PHONY: all run random clean