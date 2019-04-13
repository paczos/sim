#include "rapidxml/rapidxml_utils.hpp"
#include "rapidxml/rapidxml_ext.h"

#include <string>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <vector>


using namespace std;
using namespace rapidxml;

int main() {
    string dcmFilePath;
    cout << "Podaj sciezke do pliku" << endl;
    cin >> dcmFilePath;
    string dcmj2pnmCommand;
    dcmj2pnmCommand = "dcmj2pnm --write-16-bit-png " + dcmFilePath + " photo.png";
    system(dcmj2pnmCommand.c_str());
    cout << "Done" << endl;

    string dcm2XmlCommand;
    cout << dcmFilePath << endl;
    dcm2XmlCommand = "dcm2xml " + dcmFilePath + " converted.xml";
    system(dcm2XmlCommand.c_str());


    //TODO create Hl7 here
    xml_document<> doc;
    xml_node<> *root_node;

    xml_node<> *new_node = doc.allocate_node(node_element, "Beer", "LOL");

    cout << "Hello :) this is the hl7 message:" << endl;
    cout << doc << endl;
    string renderingCommand =
            "xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -in hl7example.xml -out hl7example.html";
    system(renderingCommand.c_str());
    cout << "HL7 message converted to HTMl" << endl;

    return 0;
}
