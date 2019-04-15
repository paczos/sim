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
    auto title = root_node->first_node("title"); // we are looking inside root_node because TITLE is contained in children of ClinicalDocument node
    title->value("Badanie RTG wygenerowane przez Kingę Kimnes, Wojciecha Wojciechowskiego, Pawła Paczuskiego"); // we can modify value of a node in this manner


    std::ostringstream doc_stream;
    doc_stream << doc;
    std::string string_stream = doc_stream.str();

    ofstream hl7_xml;
    hl7_xml.open("tmp.xml");
    hl7_xml << string_stream;
    hl7_xml.close();

    string rendering_command =
            "cat tmp.xml | xalan -xsl transformata_hl7/CDA_PL_IG_1.3.1.xsl -out out.html";
    system(rendering_command.c_str());
    remove("tmp.xml");

    cout << endl << " HL7 message converted to HTMl" << endl;
    return 0;
}

void setStringAttribute(
        xml_document<> &doc, xml_node<> *node,
        const string &attributeName, const string &attributeValue) {
    // allocate memory assigned to document for attribute value
    char *rapidAttributeValue = doc.allocate_string(attributeValue.c_str());
    // search for the attribute at the given node
    xml_attribute<> *attr = node->first_attribute(attributeName.c_str());
    if (attr != 0) { // attribute already exists
        // only change value of existing attribute
        attr->value(rapidAttributeValue);
    } else { // attribute does not exist
        // allocate memory assigned to document for attribute name
        char *rapidAttributeName = doc.allocate_string(attributeName.c_str());
        // create new a new attribute with the given name and value
        attr = doc.allocate_attribute(rapidAttributeName, rapidAttributeValue);
        // append attribute to node
        node->append_attribute(attr);
    }
}// this will be useful later