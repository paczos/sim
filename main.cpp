#include "rapidxml/rapidxml_utils.hpp"
#include "rapidxml/rapidxml_ext.h"

#include <string>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

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

    xml_node<> *root_node = doc.allocate_node(node_element, "ClinicalDocument", "");
    auto attr = doc.allocate_attribute("xsi:type", "extPL:ClinicalDocument");
    root_node->append_attribute(attr);
    doc.append_node(root_node);
    auto typeId = doc.allocate_node(node_element, "typeId");
    auto extension = doc.allocate_attribute("extension", "POCD_HD00040");
    typeId->append_attribute(extension);
    root_node->append_node(typeId);

    cout << "Hello :) this is the hl7 message:" << endl;

    std::ostringstream doc_stream;
    doc_stream << doc;
    std::string stringStream = doc_stream.str();
    cout << stringStream << endl;
    string renderingCommand =
            "printf \"" + stringStream + "\" | " +
            "xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -out out.html";


    cout << "command " << renderingCommand << endl;

    system(renderingCommand.c_str());
    cout << "HL7 message converted to HTMl" << endl;

    return 0;
}
