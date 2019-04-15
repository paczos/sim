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
    string dcm_file_path;
    cout << "Podaj sciezke do pliku" << endl;
    cin >> dcm_file_path;
    string dcmj2pnm_command;
    dcmj2pnm_command = "dcmj2pnm --write-16-bit-png " + dcm_file_path + " photo.png";
    system(dcmj2pnm_command.c_str());

    cout << "Done" << endl;

    string dcm_2_xml_command;
    cout << dcm_file_path << endl;
    dcm_2_xml_command = "dcm2xml " + dcm_file_path + " converted.xml";
    system(dcm_2_xml_command.c_str());

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
    std::string string_stream = doc_stream.str();
    cout << string_stream << endl;
    string rendering_command =
            "cat << EOF \n " + string_stream +
            "\n EOF |   xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -out out.html";

    cout << "command " << rendering_command << endl;

    system(rendering_command.c_str());
    cout << "HL7 message converted to HTMl" << endl;

    return 0;
}
