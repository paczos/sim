#include <iostream>
#include "imebra/imebra.h"
#include <string>

using namespace std;

int main()
{

unique_ptr<imebra::DataSet> loadedDataSet(imebra::CodecFactory::load("IM1"));
wstring patientNameCharacter = loadedDataSet->getUnicodeString(imebra::TagId(imebra::tagId_t::PatientName_0010_0010), 0);

string str(begin( patientNameCharacter), end(patientNameCharacter) );
cout<<"good'ol string"<<str<<endl;


  return 0;
}
