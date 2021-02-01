# sim

DICOM -> HL7 CDA z obrazkiem (xml) sprawdzamy za pomoc xsd -> xslt do html


jak wybrac obrazek?
pierwszy

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

examples of usage:

https://github.com/ashish-harman/RapidXML_Tutorial/blob/master/Update_XML_Node.cpp

https://gist.github.com/luisgustavomiki/5282610



### transform HL7 to html
xslt -> http://xml.apache.org/xalan-c/

``` bash
sudo apt install xalan
```

How to transform file przyklad.xml to przyklad.html

``` bash
xalan -xsl transformata_hl7/narrative-block-1.3.1/CDA_PL_IG_1.3.1.xsl -in przyklad.xml -out przyklad.html
```


## Our program

compile
``` bash
make
```

run
```
./sim-program
```

examplary DICOM file:

`image.dcm`




