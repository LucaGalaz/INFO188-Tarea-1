GHC = ghc
FLAGS = -O2 -Wall
TARGET = prog

all: $(TARGET)

$(TARGET): main.hs Automata.hs
	$(GHC) $(FLAGS) main.hs Automata.hs -o $(TARGET)

run: $(TARGET)
	./$(TARGET) 90 31 8

clean:
	rm -f $(TARGET) $(TARGET).exe *.o *.hi