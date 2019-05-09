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


xml_node<> *find_in_dicom_xml_by_name(xml_document<> &doc, string dicom_attr_name) {
    auto file_format = doc.first_node("file-format");
    auto data_set = file_format->first_node("data-set");
    auto root_node = data_set;
    auto data_name = root_node->first_attribute("name");

    for (xml_node<> *element_node = root_node->first_node(
            "element"); element_node; element_node = element_node->next_sibling()) {
        auto name_attr = element_node->first_attribute("name");
        if (name_attr->value() == dicom_attr_name) {

            return element_node;
        }
    }
    cerr << dicom_attr_name << " not found in converted.xml" << endl;

}

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
    ifstream template_file("report_hl7_template.xml");
    vector<char> buffer((istreambuf_iterator<char>(template_file)), istreambuf_iterator<char>());
    buffer.push_back('\0');
    // Parse the buffer using the xml file parsing library into doc
    doc.parse<0>(&buffer[0]);

    // open and parse converted.xml <- dicom metadata in xml form
    xml_document<> dicom_doc;
    ifstream dicom_xml_file("converted.xml");
    vector<char> dicom_buffer((istreambuf_iterator<char>(dicom_xml_file)), istreambuf_iterator<char>());
    buffer.push_back('\0');
    // Parse the buffer using the xml file parsing library into doc
    dicom_doc.parse<0>(&dicom_buffer[0]);


    //TODO modify Hl7 here

    xml_node<> *root_node = doc.first_node("ClinicalDocument");
    auto title = root_node->first_node(
            "title"); // we are looking inside root_node because TITLE is contained in children of ClinicalDocument node
    title->value(
            "Badanie RTG wygenerowane przez Kingę Kimnes, Wojciecha Wojciechowskiego, Pawła Paczuskiego"); // we can modify value of a node in this manner

    // example: copying birthdate from original dicom and puting it into HL7 Message
    auto birth_date_dcm = find_in_dicom_xml_by_name(dicom_doc,
                                                    "PatientBirthDate"); //find_in_dicom_xml_by_name -> custom function used to find nodes in converted.xml, PatientBirthName-> name attr from converted.xml

    // EXAMPLE
    // now we need to get pointer to the birthTime node in report_hl7_template.xml -> it is insice ClinicalDocument->recordTarget->patientRole->patient
    auto recordTarget = root_node->first_node(
            "recordTarget"); // we can later reuse this pointer, in case we use recordTarget in more than one places
    auto patientRole = recordTarget->first_node("patientRole");
    auto patient = patientRole->first_node("patient");
    auto birthTime = patient->first_node("birthTime");
    auto birthTime_value_attribute = birthTime->first_attribute(
            "value"); // in hl7 we need to put the birthTime in "value" attr -> see report_hl77_template.xml,
    birthTime_value_attribute->value(
            birth_date_dcm->value()); //this is how we set the value of an attribute. The attribute should be empty before setting its value, because we do not want our template to keep unimportant values
    // end of EXAMPLE

    auto physician = find_in_dicom_xml_by_name(dicom_doc, "PhysiciansOfRecord");

    auto author = root_node->first_node("author");
    auto assignedAuthor = author->first_node("assignedAuthor");
    auto assignedPerson = assignedAuthor->first_node("assignedPerson");
    auto name = assignedPerson->first_node("name");
    auto given = name->first_node("given");
    cout<<given->value()<<endl;
    given->value(physician->value());
    cout<<given->value()<<endl; // Correct node value replacement. Problem with conversion to HTML format?




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

