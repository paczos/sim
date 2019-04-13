#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>

using namespace std;

int main()
{
	string inputText;
	cout << "Podaj scierzke do pliku"<<endl;
	cin >> inputText;
	inputText = "dcmj2pnm --write-16-bit-png " + inputText + " photo.png";
	system(inputText.c_str());
	cout << "Done"<<endl;

  return 0;
}
