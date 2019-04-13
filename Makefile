CC = g++  

all: 
	$(CC)  main.cpp -o sim-program -Xlinker --verbose

