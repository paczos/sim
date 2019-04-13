CC = g++  

all: 
	$(CC)  xmlload.cpp -o sim -Xlinker --verbose

