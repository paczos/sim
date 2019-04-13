<?xml version="1.0" encoding="UTF-8"?>
<!-- 
	Transformata ilustrująca sposób zapisania bloku narracyjnego recepty na podstawie danych strukturalnych.
	Celem jest poprawienie czytelności bloku narracyjnego recepty.
	Transformata nie jest zgodna z HL7 CDA, wykorzystuje dane entry co jest niezgodne z HL7 CDA, 
	dodatkowo w systemie gabinetowym dane bloku narracyjnego muszą być edytowalne dla wystawcy dokumentu recepty. 
	
	Wersja CDA_PL_IG_1.3.1:1.0
	
	Historia wersji:
	- CDA_PL_IG_1.3.1:1.0, 3703 linie kodu, autor Marcin Pusz, Pentacomp Systemy Informatyczne S.A.: wersja inicjalna
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:hl7="urn:hl7-org:v3" xmlns:pharm="urn:ihe:pharm" xmlns:extPL="http://www.csioz.gov.pl/xsd/extPL/r2" version="1.0">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" media-type="text/x-hl7-text+xml"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="hl7:ClinicalDocument"/>
	</xsl:template>
	
	<xsl:template match="hl7:ClinicalDocument">
		<xsl:if test="hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.3.4']/hl7:entry/hl7:substanceAdministration">
			<xsl:call-template name="gotowy">
				<xsl:with-param name="sa" select="hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.3.4']/hl7:entry/hl7:substanceAdministration"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- szablon Pozycja recepty na lek gotowy lub ŚSSPŻ 2.16.840.1.113883.3.4424.13.10.4.3 -->
	<xsl:template name="gotowy">
		<xsl:param name="sa"/>
		
		<ClinicalDocument>
			<component>
		        <structuredBody>
		            <component>
	    	            <section>
							<title>
								<xsl:value-of select="/hl7:ClinicalDocument/hl7:code[@code = '57833-6']/hl7:translation/hl7:qualifier[hl7:name/@code = 'KDLEK']/hl7:value/@code"/>
								<xsl:if test="$sa/hl7:entryRelationship/hl7:supply/hl7:priorityCode[@code = 'UR']">
									<xsl:text> (Cito)</xsl:text>
								</xsl:if>
							</title>
							<text>
								<!-- informacje o leku -->
								<xsl:apply-templates select="$sa"/>
								
								<!-- nie zamieniać -->
								<xsl:apply-templates select="$sa/hl7:entryRelationship/hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.56']"/>
								
								<!-- potwierdzenie ilości substancji czynnej (wymagane tylko dla Rpw) -->
								<xsl:apply-templates select="$sa/hl7:entryRelationship/hl7:supply/hl7:entryRelationship/hl7:observation[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.80']"/>
								
								<!-- Data wydania leku od dnia, jeżeli podano późniejszą niż data wystawienia recepty -->
								<xsl:apply-templates select="$sa/hl7:entryRelationship/hl7:supply/hl7:effectiveTime/@value"/>
								
								<!-- odpłatność -->
								<xsl:apply-templates select="$sa/hl7:entryRelationship/hl7:supply/hl7:entryRelationship/hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.57']"/>
								
								<!-- stosowanie -->
								<xsl:apply-templates select="$sa/hl7:entryRelationship/hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.74']"/>
								
								<!-- informacja dla osoby wydającej lek -->
								<xsl:apply-templates select="$sa/hl7:entryRelationship/hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.75']"/>
							</text>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
	
	<!-- Informacje o leku gotowym i ŚSSPŻ -->
	<xsl:template match="hl7:substanceAdministration[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.3']">
		<xsl:element name="paragraph">
			<xsl:apply-templates select="./hl7:text/hl7:reference/@value"/>
			<xsl:element name="content">
				<xsl:attribute name="styleCode">xPLbig</xsl:attribute>
				<xsl:value-of select="./hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:name"/>
			</xsl:element>
			<br/>
			<xsl:element name="content">
				<xsl:value-of select="./hl7:entryRelationship/hl7:supply/hl7:quantity/@value"/>
				<xsl:text> {edytuj}</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- Informacje o leku recepturowym -->
	<xsl:template match="hl7:substanceAdministration[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.48']">
		<xsl:element name="paragraph">
			<xsl:apply-templates select="./hl7:text/hl7:reference/@value"/>
			
			<!-- opcjonalnie nazwa i ilość leku, zwykle lekarz zamieszcza np. ilość maści w ramach składnika aqua -->
			<xsl:if test="string-length(./hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:name) &gt;= 1">
				<content>
					<xsl:value-of select="./hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:name"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./hl7:entryRelationship/hl7:supply/hl7:quantity/@value"/>
					<xsl:value-of select="./hl7:entryRelationship/hl7:supply/hl7:quantity/@unit"/>
				</content>
			</xsl:if>
			
			<!-- prosta lista składników nie jest recepturą, jednak może ułatwiać edycję receptury -->
			<list styleCode="Disc" listType="unordered">
				<xsl:for-each select="./hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/pharm:ingredient/pharm:ingredient/pharm:name">
					<xsl:element name="item">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:for-each>
			</list>
			<!-- zwykle zamieszcza się informację co zrobić ze składnikami, typu zamieszaj aż uzyskasz maść -->
			<content>
				<xsl:text>{edytuj}</xsl:text>
			</content>
		</xsl:element>
	</xsl:template>
	
	<!-- NZ - nie zamieniać, sama obecność treści oznacza istnienie takiej deklaracji -->
	<xsl:template match="hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.56']">
		<xsl:element name="paragraph">
			<caption>NZ</caption>
		</xsl:element>
	</xsl:template>
	
	<!-- Potwierdzenie ilości substancji czynnej (wymagane tylko dla Rpw) -->
	<xsl:template match="hl7:observation[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.80']">
		<xsl:element name="paragraph">
			<xsl:apply-templates select="./hl7:text/hl7:reference/@value"/>
			<xsl:element name="content">
				<xsl:text>Potwierdzenie ilości substancji czynnej: </xsl:text>
				<xsl:value-of select="./hl7:value/@value"/>
				<xsl:value-of select="./hl7:value/@unit"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- Data wydania leku od dnia -->
	<xsl:template match="hl7:supply/hl7:effectiveTime/@value">
		
		<xsl:variable name="documentDateValue" select="/hl7:ClinicalDocument/hl7:effectiveTime/@value"/>
		<!-- przemnażanie na wypadek gdyby nie było np. dni w dacie, co jest dopuszczalne czysto teoretycznie -->
		<xsl:variable name="supplyDate" select="10000 * substring(., 1, 4) + 100 * substring(., 5, 2) + substring(., 7, 2)"/>
    	<xsl:variable name="documentDate" select="10000 * substring($documentDateValue, 1, 4) + 100 * substring($documentDateValue, 5, 2) + substring($documentDateValue, 7, 2)"/>
		
		<xsl:if test="$supplyDate &gt; $documentDate">
			<xsl:element name="paragraph">
				<caption>Data realizacji od</caption>
				<xsl:element name="content">
					<xsl:attribute name="styleCode">xPLred Bold</xsl:attribute>
					<xsl:text> </xsl:text>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="date" select="."/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- formatowanie daty i czasu -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		
		<xsl:param name="year" select="number(substring($date, 1, 4))"/>
		<xsl:param name="monthIndex" select="number(substring($date, 5, 2))"/>
		<xsl:param name="day" select="number(substring($date, 7, 2))"/>
		
		<xsl:value-of select="$day"/>
		
		<xsl:text> </xsl:text>
		<xsl:call-template name="translateFullDateMonth">
			<xsl:with-param name="month" select="$monthIndex"/>
		</xsl:call-template>

		<xsl:text> </xsl:text>
		<xsl:value-of select="$year"/>
		<xsl:text> r.</xsl:text>
	</xsl:template>
	
	<!-- nazwa miesiąca w pełnej dacie -->
	<xsl:template name="translateFullDateMonth">
		<xsl:param name="month"/>
		
		<xsl:choose>
			<xsl:when test="$month='01'"><xsl:text>stycznia</xsl:text></xsl:when>
			<xsl:when test="$month='02'"><xsl:text>lutego</xsl:text></xsl:when>
			<xsl:when test="$month='03'"><xsl:text>marca</xsl:text></xsl:when>
			<xsl:when test="$month='04'"><xsl:text>kwietnia</xsl:text></xsl:when>
			<xsl:when test="$month='05'"><xsl:text>maja</xsl:text></xsl:when>
			<xsl:when test="$month='06'"><xsl:text>czerwca</xsl:text></xsl:when>
			<xsl:when test="$month='07'"><xsl:text>lipca</xsl:text></xsl:when>
			<xsl:when test="$month='08'"><xsl:text>sierpnia</xsl:text></xsl:when>
			<xsl:when test="$month='09'"><xsl:text>września</xsl:text></xsl:when>
			<xsl:when test="$month='10'"><xsl:text>października</xsl:text></xsl:when>
			<xsl:when test="$month='11'"><xsl:text>listopada</xsl:text></xsl:when>
			<xsl:when test="$month='12'"><xsl:text>grudnia</xsl:text></xsl:when>
			<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Odpłatność -->
	<xsl:template match="hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.57']">
		<xsl:variable name="poziom" select="./hl7:entryRelationship/hl7:act/hl7:code[@code = 'PUBLICPOL']/hl7:qualifier/hl7:value/@code"/>
		
		<xsl:if test="string-length($poziom) &gt;= 1">
			<xsl:element name="paragraph">
				<!-- rezygnuje się z nagłówka paragrafu (pogrubienia) -->
				<!-- <caption>Odpłatność</caption> -->
				<xsl:text>Odpłatność</xsl:text>
				<xsl:element name="content">
					<xsl:apply-templates select="./hl7:text/hl7:reference/@value"/>
					<!-- dopuszczalne wartości ze słownika to B, R, 30%, 50%, 100% - kolor zielony dla wszystkich poza 100% -->
					<xsl:if test="$poziom != '100%'">
						<!-- polskie rozszerzenie standardu o kolory czcionek w formacie wymaganym przez HL7 CDA, np. xPLred -->
						<xsl:attribute name="styleCode">xPLgreen Bold</xsl:attribute>
					</xsl:if>
					<xsl:text> </xsl:text>
					<!-- wyjątkowo nie wyświetla się displayName, tylko powszechnie rozumiany code -->
					<xsl:value-of select="$poziom"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template> 
	
	<!-- Opis stosowania -->
	<xsl:template match="hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.74']">
		<xsl:element name="paragraph">
			<caption>D.S.</caption>
			<xsl:element name="content">
				<xsl:apply-templates select="./hl7:text/hl7:reference/@value"/>
				<xsl:text> </xsl:text>
				<xsl:text>{edytuj}</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- Informacja dla osoby wydającej lek -->
	<xsl:template match="hl7:act[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.4.75']">
		<xsl:element name="paragraph">
			<xsl:element name="content">
				<xsl:apply-templates select="./hl7:text/hl7:reference/@value"/>
				<xsl:text>Informacja dla osoby wydającej lek: {edytuj}</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="hl7:text/hl7:reference/@value">
		<xsl:if test="string-length(.) &gt;= 2">
			<xsl:attribute name="ID">
				<xsl:value-of select="substring-after(., '#')"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>