#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>

using namespace std;

int main() {
    string dcmFilePath;
    cout << "Podaj sciezke do pliku" << endl;
    cin >> dcmFilePath;
    dcmFilePath = "dcmj2pnm --write-16-bit-png " + dcmFilePath + " photo.png";
    system(dcmFilePath.c_str());
    cout << "Done" << endl;


    string renderingCommand =
            "xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -in hl7example.xml -out hl7example.html";
    system(renderingCommand.c_str());
    cout << "HL7 message converted to HTMl" << endl;

    return 0;
}
