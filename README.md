# sim

DICOM -> HL7 CDA z obrazkiem (xml) sprawdzamy za pomoc xsd -> xslt do html

dicomxml*xsl=html

|dicom+xsd=xml
|xml+xsl=html

jak wybrac obrazek?
pierwszy

Pan Wanta 59


### Install DCMTK
sudo apt-get update
sudo apt-get install dcmtk

### convert to png

dcmj2pnm --write-16-bit-png photo.dcm photo.png


### create HL7
xml -> rapid xml

### transform HL7 to html
xslt -> http://xml.apache.org/xalan-c/