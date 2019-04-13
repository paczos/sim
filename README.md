# sim

DICOM -> HL7 CDA z obrazkiem (xml) sprawdzamy za pomoc xsd -> xslt do html


jak wybrac obrazek?
pierwszy

Pan Wanta 59


### Install DCMTK
``` bash
sudo apt-get update
sudo apt-get install dcmtk
```

### convert to png

``` bash
dcmj2pnm --write-16-bit-png photo.dcm photo.png
```

### create HL7
``` bash
sudo apt install librapidxml-dev
```
xml -> rapid xml

### transform HL7 to html
xslt -> http://xml.apache.org/xalan-c/

``` bash
sudo apt install xalan
```

How to transform file przyklad.xml to przyklad.html

``` bash
xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -in przyklad.xml -out przyklad.html
```




