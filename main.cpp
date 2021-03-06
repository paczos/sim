#include "rapidxml/rapidxml_utils.hpp"
#include "rapidxml/rapidxml_ext.h"

#include <string>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <time.h>
#include "base64.h"

using namespace std;
using namespace rapidxml;

std::vector <std::string> split(std::string strToSplit, char delimeter) {
    std::stringstream ss(strToSplit);
    std::string item;
    std::vector <std::string> splittedStrings;
    while (std::getline(ss, item, delimeter)) {
        splittedStrings.push_back(item);
    }
    return splittedStrings;
}


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

    xml_node<> *root_node = doc.first_node("ClinicalDocument");
    auto title = root_node->first_node(
            "title"); // we are looking inside root_node because TITLE is contained in children of ClinicalDocument node
    title->value(
            "Badanie CT wygenerowane przez King?? Kimnes, Wojciecha Wojciechowskiego, Paw??a Paczuskiego"); // we can modify value of a node in this manner

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

    // physician's name
    auto physician = find_in_dicom_xml_by_name(dicom_doc, "PhysiciansOfRecord");
    auto splitName = split(physician->value(), '^');

    auto author = root_node->first_node("author");
    auto assignedAuthor = author->first_node("assignedAuthor");
    auto assignedPerson = assignedAuthor->first_node("assignedPerson");
    auto name = assignedPerson->first_node("name");
    auto given = name->first_node("given");
    auto family = given->next_sibling("family");

    auto familyDcm = splitName[0];
    auto givenDcm = splitName[1];
    given->value(givenDcm.c_str());
    family->value(familyDcm.c_str());
    
    // Date the document was generated (Current date)
    auto effectiveTime_now = root_node->first_node("effectiveTime");
    auto effectiveTime_now_value_attribute = effectiveTime_now->first_attribute("value");

    time_t T= time(NULL);
    struct  tm tm = *localtime(&T);
    string time_now = "";
    if (tm.tm_mon < 9) time_now = to_string(tm.tm_year+1900) + "0" + to_string(tm.tm_mon+1);
    else time_now = to_string(tm.tm_year+1900) + to_string(tm.tm_mon+1);
    if (tm.tm_mday < 10) time_now += "0" + to_string(tm.tm_mday);
    else time_now += to_string(tm.tm_mday);

    effectiveTime_now_value_attribute->value(time_now.c_str());

    // ------------------------Patient informations------------------------------
    // Patient name
    auto patientName_dcm = find_in_dicom_xml_by_name(dicom_doc, "PatientName");
    auto splitPatientName_dcm = split(patientName_dcm->value(), '^');

    auto patient_name = patient->first_node("name");
    auto given1 = patient_name->first_node("given");
    auto given2 = patient_name->last_node("given");
    auto patientFamily = patient_name->first_node("family");

    patientFamily->value(splitPatientName_dcm[0].c_str());
    given1->value(splitPatientName_dcm[1].c_str());
    if(splitPatientName_dcm.size() >= 3) given2->value(splitPatientName_dcm[2].c_str());

    // Patient gender

    auto patientSex_dcm = find_in_dicom_xml_by_name(dicom_doc,"PatientSex");

    auto administrativeGenderCode = patient->first_node("administrativeGenderCode");
    auto administrativeGenderCode_codeValue = administrativeGenderCode->first_attribute("code");

    administrativeGenderCode_codeValue->value(patientSex_dcm->value());

    // Patient ID (PESEL)

    auto patientId_dcm = find_in_dicom_xml_by_name(dicom_doc,"PatientID");
    string temp_str = patientId_dcm->value();
    if (temp_str.find("PL") != string::npos) temp_str.erase(temp_str.find("PL"),2);
    patientId_dcm->value(temp_str.c_str());

    auto patientRole_id = patientRole->last_node("id");
    auto patientRole_id_extension_value = patientRole_id->first_attribute("extension");

    patientRole_id_extension_value->value(patientId_dcm->value());

    // clinic name and address
    auto clinic_name_dcm = find_in_dicom_xml_by_name(dicom_doc, "InstitutionName");
    auto clinic_address_dcm = find_in_dicom_xml_by_name(dicom_doc,
                                                        "InstitutionAddress");

    auto splitAddr = split(clinic_address_dcm->value(), '\n');

    auto representedOrganization = assignedAuthor->first_node("representedOrganization");
    auto addr = representedOrganization->first_node("addr");
    auto streetName = addr->first_node("streetName");
    auto city = addr->first_node("city");


    auto streetNameDcm = splitAddr[0];
    auto cityDcm = splitAddr[1];
    streetName->value(streetNameDcm.c_str());
    city->value(cityDcm.c_str());

    auto asOrganizationPartOf = representedOrganization->first_node("asOrganizationPartOf");
    auto wholeOrganization = asOrganizationPartOf->first_node("wholeOrganization");
    auto organizationName = wholeOrganization->first_node("name");
    organizationName->value(clinic_name_dcm->value());

    // study date
    auto study_date_dcm = find_in_dicom_xml_by_name(dicom_doc, "StudyDate");

    auto documentationOf = root_node->first_node("documentationOf");
    auto serviceEvent = documentationOf->first_node("serviceEvent");
    auto effectiveTime = serviceEvent->first_node("effectiveTime");
    auto effectiveTime_value_attribute = effectiveTime->first_attribute(
        "value"); // in hl7 we need to put the effectiveTime in "value" attr -> see report_hl77_template.xml,
    effectiveTime_value_attribute->value(study_date_dcm->value());

    auto componentOf = root_node->first_node("componentOf");
    auto encompassingEncounter = componentOf->first_node("encompassingEncounter");
    auto effectiveTime2 = encompassingEncounter->first_node("effectiveTime");
    auto effectiveTime2_value_attribute = effectiveTime2->first_attribute("value");

    effectiveTime2_value_attribute->value(study_date_dcm->value());

    // procedure description
    auto procedure_dcm = find_in_dicom_xml_by_name(dicom_doc, "RequestedProcedureDescription");

    auto code = serviceEvent->first_node("code");
    auto code_value_attribute = code->last_attribute("displayName");
    code_value_attribute->value(procedure_dcm->value());


    // store image in documentation
    string imageb64 = "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";
    auto component = root_node->first_node("component");
    auto structuredBody = component->first_node("structuredBody");
    auto structuredComponent = structuredBody->first_node("component");
    auto section = structuredComponent->first_node("section");
    auto entry = section->first_node("entry");
    auto observationMedia = entry->first_node("observationMedia");
    auto valueBase64 = observationMedia->first_node("value");
    // convert photo.png to base64
    std::ifstream input("photo.png", std::ios::binary);
    // copies all data into buffer

    string bufferPhoto(std::istreambuf_iterator<char>(input), {});
    string *photoEncoded = new string();
    Base64::Encode(bufferPhoto, photoEncoded);
    valueBase64->value(photoEncoded->c_str()); // xD

    // add study description (console)
    string study_description;
    cout << "Wprowadz opis badania." << endl;
    cin.ignore();
    getline(cin,study_description);

    auto text = section->first_node("text");
    auto text2 = text->next_sibling("text");
    text2->value(study_description.c_str());


    // save resulting doc as tmp.xml
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

