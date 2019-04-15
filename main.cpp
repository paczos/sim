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

    xml_document<> doc;
    ifstream theFile("report_hl7_template.xml");
    vector<char> buffer((istreambuf_iterator<char>(theFile)), istreambuf_iterator<char>());
    buffer.push_back('\0');
    // Parse the buffer using the xml file parsing library into doc
    doc.parse<0>(&buffer[0]);

    //TODO modify Hl7 here

    xml_node<> *root_node = doc.first_node("ClinicalDocument");
    auto attr = doc.allocate_attribute("xsi:kupka", "extPL:dupsko");
    root_node->append_attribute(attr);

    std::ostringstream doc_stream;
    doc_stream << doc;
    std::string stringStream = doc_stream.str();
    cout << stringStream << endl;
    string renderingCommand =
            "cat << EOF \n " + stringStream +
            "\n EOF |   xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -out out.html";

    cout << "command " << renderingCommand << endl;

    system(renderingCommand.c_str());
    cout << "HL7 message converted to HTMl" << endl;

    return 0;
}
