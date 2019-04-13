<?xml version="1.0" encoding="UTF-8"?>
<!-- 
	Transformata generująca warstwę prezentacyjną dokumentów medycznych zgodnych z polskim HL7 CDA Implementation Guide,
	przygotowana przez Centrum Systemów Informacyjnych Ochrony Zdrowia.
	
	Wersja CDA_PL_IG_1.3.1:1.0
	
	Historia wersji:
	- CDA_PL_IG_1.0:1.0, 3703 linie kodu, autor Marcin Pusz, Pentacomp Systemy Informatyczne S.A.: wersja inicjalna
	- CDA_PL_IG_1.1:1.0, 5026 linii kodu, autor Marcin Pusz, Pentacomp Systemy Informatyczne S.A.: uwzględnienie uwag, uzupełnienie słowników
	- CDA_PL_IG_1.2:1.0, 5131 linii kodu, autor Marcin Pusz, Pentacomp Systemy Informatyczne S.A.: uwzględnienie uwag, obsługa dokumentów wbudowanych, obsługa elementu authenticator
	- CDA_PL_IG_1.3.1:1.0, 7428 linii kodu, autor jw.: uwzględnienie struktury IHE PRE wprowadzonej do PIK 1.3, kolory i powiększenie czcionki w bloku narracyjnym, czcionka preferowana "Noto sans" z dopuszczeniem sans-serif, obsługa dokumentów realizacji recept, obsługa brakujących elementów CDA niezdefiniowanych w PIK, wsparcie języka en-US w etykietach, usunięcie logo eZdrowie
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:hl7="urn:hl7-org:v3" xmlns:extPL="http://www.csioz.gov.pl/xsd/extPL/r2" version="1.0">

	<xsl:output method="html" version="4.01" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" media-type="text/html" doctype-system="about:legacy-compat"/>
	
	<xsl:variable name="LOWERCASE_LETTERS">aąbcćdeęfghijklłmnńoópqrsśtuvwxyzżź</xsl:variable>
	<xsl:variable name="UPPERCASE_LETTERS">AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWXYZŻŹ</xsl:variable>
	<!-- dokumenty medyczne posiadają etykiety w języku polskim za wyjątkiem części lub całych dokumentów, dla których wskazano język angielski kodem en-US -->
	<xsl:variable name="secondLanguage">en-US</xsl:variable>
	
	<xsl:template match="/">
		<xsl:apply-templates select="hl7:ClinicalDocument"/>
	</xsl:template>
	
	<!-- dokument medyczny, szablon bazowy 2.16.840.1.113883.3.4424.13.10.1.1, szablon bazowy dla P1 2.16.840.1.113883.3.4424.13.10.1.2 -->
	<xsl:template match="hl7:ClinicalDocument">
		<html>
			<head>
				<xsl:call-template name="styles"/>
			</head>
			<body>
				<div class="document">
					<div class="doc_theader">
						<xsl:choose>
							<!-- dla binarnych dokumentów embedowanych w XML HL7 CDA nagłówek jest inicjalnie zwinięty, dostępny pod definiowanym tu przyciskiem -->
							<xsl:when test="hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.3.55'">
								
								<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
								<xsl:variable name="show">
									<xsl:choose>
										<xsl:when test="$lang = $secondLanguage">
											<xsl:text>CDA Header</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Nagłówek CDA</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="hide">
									<xsl:choose>
										<xsl:when test="$lang = $secondLanguage">
											<xsl:text>Hide CDA Header</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Ukryj nagłówek CDA</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<input id="showCdaHeader" name="group" type="radio" class="show_cda_header"/>
								<label for="showCdaHeader" class="show_cda_header_label">
									<span><xsl:value-of select="$show"/></span>
								</label>
								<input id="hideCdaHeader" name="group" type="radio" class="hide_cda_header"/>
								<label for="hideCdaHeader" class="hide_cda_header_label">
									<span><xsl:value-of select="$hide"/></span>
								</label>
								
								<div class="doc_dheader">
									<xsl:call-template name="header"/>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="header"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					
					<div class="doc_body">	
						<xsl:call-template name="structuredBody"/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<!-- nagłówek -->
	<xsl:template name="header">
		<xsl:call-template name="title"/>
		<xsl:call-template name="headerElements"/>
		<xsl:call-template name="relatedDocument"/>
		<xsl:call-template name="versionRelated"/>
		<div class="doc_header">
			<div class="doc_header_2">
				<div class="patient_related_header">					
					<xsl:call-template name="recordTarget"/>
					<xsl:call-template name="authorization"/>
					<xsl:call-template name="informant"/>
					<xsl:call-template name="reimbursementRelated"/>
					<xsl:call-template name="informationRecipient"/>
					<xsl:call-template name="componentOf"/>
					<xsl:call-template name="inFulfillmentOf"/>
				</div>
				<div class="document_related_header">
					<xsl:call-template name="legalAuthenticator"/>
					<xsl:call-template name="author"/>
					<xsl:call-template name="authenticator"/>
					<xsl:call-template name="dataEnterer"/>
					<xsl:call-template name="documentationOf"/>
					<xsl:call-template name="participant"/><!-- uwaga, participant płatnik wyświetlany jest niezależnie w ramach reimbursementRelated -->
					<xsl:call-template name="custodian"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!-- tytuł dokumentu -->
	<xsl:template name="title">
		<div class="doc_title">
			<!-- element title jest zawsze wymagany w PL IG -->
			<span class="title_label">
				<xsl:value-of select="hl7:title"/>
			</span>
			<xsl:if test="hl7:code/hl7:translation[@code='04.12']/hl7:qualifier/hl7:name[@code='RRREC']">
				<!-- Rodzaj realizacji recepty i opcjonalnie awaryjny tryb jej realizacji -->
				<xsl:variable name="suffix_class">
					<xsl:text>title_suffix</xsl:text>
					<xsl:if test="hl7:code/hl7:translation[@code='04.12']/hl7:qualifier/hl7:name[@code='RRREC']/../hl7:value/@code = 'W'">
						<xsl:text> highlighted</xsl:text>
					</xsl:if>
				</xsl:variable>
				
				<span class="{$suffix_class}">
					<xsl:text>(</xsl:text>
					<xsl:value-of select="hl7:code/hl7:translation[@code='04.12']/hl7:qualifier/hl7:name[@code='RRREC']/../hl7:value/@displayName"/>
					<!-- Rodzaj realizacji recepty jest obowiązkowy dla dokumentu realizacji recepty, stąd awaryjny tryb wydania leku jedynie dopisuję do rodzaju -->
					<xsl:if test="hl7:code/hl7:translation[@code='04.12']/hl7:qualifier/hl7:name[@code='TWLEK']/../hl7:value/@code = 'A'">
						<xsl:text>, </xsl:text>
						<span class="toned">
							<xsl:text>awaryjnie</xsl:text>
						</span>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</span>
			</xsl:if>
		</div>
	</xsl:template>
	
	<!-- effectiveTime oraz id -->
	<xsl:template name="headerElements">
	
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="effectiveDateLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Effective date</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Data wystawienia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div class="doc_header_elements">
			<xsl:call-template name="dateTimeInDiv">
				<xsl:with-param name="date" select="hl7:effectiveTime"/>
				<xsl:with-param name="label" select="$effectiveDateLabel"/>
				<xsl:with-param name="divClass">effective_time_header_element doc_header_element header_element</xsl:with-param>
			</xsl:call-template>
			
			<div class="id_header_element doc_header_element header_element">
				<span class="header_label">
					<xsl:text>ID</xsl:text>
				</span>
				<div class="header_inline_value header_value">
					<xsl:call-template name="identifierOID">
						<xsl:with-param name="id" select="hl7:id"/>
						<xsl:with-param name="knownOnly" select="false()"/>
					</xsl:call-template>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!-- setId oraz versionNumber -->
	<xsl:template name="versionRelated">
		<!-- polskie recepty i zlecenia nie są wersjonowane (tj. nie mogą być korygowane, posiadają wersję 1), pozostałe typy dokumentów tak -->
		<xsl:if test="not(hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.3' or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.6' or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.7' or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.8' or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.26' or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.5')">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
			<xsl:variable name="versionLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Version</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Wersja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="setIdLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Set ID</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>ID zbioru wersji</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="doc_header_elements">
				<div class="version_header_element doc_header_element header_element">
					<span class="header_label">
						<xsl:value-of select="$versionLabel"/>
					</span>
					<xsl:choose>
						<xsl:when test="hl7:versionNumber/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="hl7:versionNumber"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<div class="header_inline_value header_value">
								<xsl:value-of select="hl7:versionNumber/@value"/>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="value_set_header_element doc_header_element header_element">
					<span class="header_label">
						<xsl:value-of select="$setIdLabel"/>
					</span>
					<div class="header_inline_value header_value">
						<xsl:call-template name="identifierOID">
							<xsl:with-param name="id" select="hl7:setId"/>
							<xsl:with-param name="knownOnly" select="false()"/>
						</xsl:call-template>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- relatedDocument 2.16.840.1.113883.3.4424.13.10.2.7 -->
	<xsl:template name="relatedDocument">
		<!-- dla dokumentów przechowywanych poza P1 krotność maksymalna to 2 -->
		<xsl:if test="hl7:relatedDocument">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
			<div class="doc_header_elements">
				<div class="related_document_header_element doc_header_element header_element">
					<xsl:for-each select="hl7:relatedDocument">
						<span class="header_label">
							<xsl:call-template name="translateRelatedDocumentCode">
								<xsl:with-param name="typeCode" select="./@typeCode"/>
								<xsl:with-param name="lang" select="$lang"/>
							</xsl:call-template>
						</span>
						<div class="header_inline_value header_value">
							<xsl:call-template name="identifierOID">
								<xsl:with-param name="id" select="./hl7:parentDocument/hl7:id"/>
								<xsl:with-param name="knownOnly" select="false()"/>
							</xsl:call-template>
						</div>
						<xsl:if test="position()!=last()">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>	
	
	<!-- główny author oraz legalAuthenticator: templateId 2.16.840.1.113883.3.4424.13.10.2.6 oraz 2.16.840.1.113883.3.4424.13.10.2.63 -->
	<xsl:template name="legalAuthenticator">
		
		<xsl:variable name="legalAuthenticator" select="hl7:legalAuthenticator"/>
		<!-- zdane wystawcy dokumentu zawarte są w jednym z elementów author, a wskazanie który z autorów jest wystawcą realizuje się poprzez umieszczenie conajmniej identyfikatora tego autora w elemencie legalAuthenticator -->
		<xsl:variable name="legalAuthor" select="/hl7:ClinicalDocument/hl7:author[hl7:assignedAuthor/hl7:id[@root=/hl7:ClinicalDocument/hl7:legalAuthenticator/hl7:assignedEntity/hl7:id/@root and @extension=/hl7:ClinicalDocument/hl7:legalAuthenticator/hl7:assignedEntity/hl7:id/@extension]]"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:variable name="legalAuthenticatorLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Legal authenticator</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Wystawca dokumentu</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="organizationLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Organization</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Miejsce wystawienia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="signature">
			<!-- pozostałe dwa typy kodu podpisu (I intended oraz X required) nie są wyświetlane -->
			<xsl:choose>
				<xsl:when test="not($legalAuthenticator/hl7:signatureCode/@nullFlavor) and $legalAuthenticator/hl7:signatureCode/@code = 'S' and $lang = $secondLanguage">
					<span class="signature_code_value">
						<xsl:text>signed electronically</xsl:text>
					</span>
				</xsl:when>
				<xsl:when test="not($legalAuthenticator/hl7:signatureCode/@nullFlavor) and $legalAuthenticator/hl7:signatureCode/@code = 'S'">
					<span class="signature_code_value">
						<xsl:text>dokument podpisany elektronicznie</xsl:text>
					</span>
				</xsl:when>
				<xsl:when test="$legalAuthenticator/hl7:signatureCode/@nullFlavor or $legalAuthenticator/hl7:signatureCode/@code != 'S' and $lang = $secondLanguage">
					<span class="signature_code_value">
						<xsl:text>unsigned</xsl:text>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="signature_code_value">
						<xsl:text>brak podpisu elektronicznego</xsl:text>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			<span class="signature_code_value_print">
				<xsl:choose>
					<xsl:when test="not($legalAuthenticator/hl7:signatureCode/@nullFlavor) and $legalAuthenticator/hl7:signatureCode/@code = 'S' and $lang = $secondLanguage">
						<xsl:text>printout of an electronic document</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>wydruk dokumentu elektronicznego</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:variable>
		
		<xsl:variable name="reimbursementRelatedContract">
			<!-- numer umowy z NFZ templateId 2.16.840.1.113883.3.4424.13.10.2.44 -->
			<xsl:if test="$legalAuthor/hl7:assignedAuthor/extPL:boundedBy">
				<div class="reimbursement_related_contract_element header_element">
					<span class="header_label">
						<xsl:choose>
							<xsl:when test="$lang = $secondLanguage">
								<xsl:text>NFZ contract number</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Numer umowy z NFZ</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:choose>
						<xsl:when test="$legalAuthor/hl7:assignedAuthor/extPL:boundedBy/extPL:reimbursementRelatedContract/extPL:id/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$legalAuthor/hl7:assignedAuthor/extPL:boundedBy/extPL:reimbursementRelatedContract/extPL:id"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<div class="header_inline_value header_value">
								<xsl:value-of select="$legalAuthor/hl7:assignedAuthor/extPL:boundedBy/extPL:reimbursementRelatedContract/extPL:id/@extension"/>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
		</xsl:variable>
		
		<xsl:call-template name="assignedEntity">
			<xsl:with-param name="entity" select="$legalAuthor/hl7:assignedAuthor"/>
			<xsl:with-param name="blockClass">header_block</xsl:with-param>
			<xsl:with-param name="blockLabel" select="$legalAuthenticatorLabel"/>
			<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
			<xsl:with-param name="knownIdentifiersOnly" select="true()"/>
			<xsl:with-param name="addToLevel1Label" select="$signature"/>
			<xsl:with-param name="addToLevel1" select="$reimbursementRelatedContract"/>
			<xsl:with-param name="hideSecondOrgLevel" select="true()"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- recordTarget templateId 2.16.840.1.113883.3.4424.13.10.2.3 -->
	<xsl:template name="recordTarget">
		<xsl:variable name="patientRole" select="hl7:recordTarget/hl7:patientRole"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="patientLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Patient</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Pacjent</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dateOfBirthLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Date of birth</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Data urodzenia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="multipleBirthOrderNumberLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Multiple birth order no</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Numer kolejny urodzenia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="addressLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Address</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Adres</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nameOfFatherLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Name of father</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Imię ojca</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nameOfMotherLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Name of mother</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Imię matki</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nameOfClosePersonLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Name of close person</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Imię osoby bliskiej</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div class="header_block">
			<span class="record_target_block_label header_block_label">
				<xsl:value-of select="$patientLabel"/>
			</span>
			
			<xsl:choose>
				<xsl:when test="hl7:recordTarget/@nullFlavor">
					<xsl:call-template name="translateNullFlavor">
						<xsl:with-param name="nullableElement" select="hl7:recordTarget"/>
					</xsl:call-template>
					<xsl:call-template name="confidentialityCode">
						<xsl:with-param name="cCode" select="hl7:confidentialityCode"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$patientRole/@nullFlavor">
					<xsl:call-template name="translateNullFlavor">
						<xsl:with-param name="nullableElement" select="$patientRole"/>
					</xsl:call-template>
					<xsl:call-template name="confidentialityCode">
						<xsl:with-param name="cCode" select="hl7:confidentialityCode"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- poziom wrażliwości dokumentu (poza template), dane dokumentu są danymi wrażliwymi z perspektywy pacjenta -->
					<xsl:call-template name="confidentialityCode">
						<xsl:with-param name="cCode" select="hl7:confidentialityCode"/>
					</xsl:call-template>
					
					<!-- istnieją dane wyłącznie jednego pacjenta w każdym dokumencie zgodnym z PL IG -->
					<!-- imiona i nazwiska pacjenta -->
					<xsl:call-template name="person">
						<xsl:with-param name="person" select="$patientRole/hl7:patient"></xsl:with-param>
					</xsl:call-template>
					
					<!-- identyfikatory pacjenta elementu patientRole, identyfikatory elementu patient nie są stosowane -->
					<xsl:call-template name="identifiersInDiv">
						<xsl:with-param name="ids" select="$patientRole/hl7:id"/>
						<xsl:with-param name="knownOnly" select="true()"/>
					</xsl:call-template>
					
					<!-- data urodzenia -->
					<xsl:call-template name="dateTimeInDiv">
						<xsl:with-param name="date" select="$patientRole/hl7:patient/hl7:birthTime"/>
						<xsl:with-param name="label" select="$dateOfBirthLabel"/>
						<xsl:with-param name="divClass">header_element</xsl:with-param>
						<xsl:with-param name="calculateAge" select="true()"/>
					</xsl:call-template>
					
					<!-- wyróżnik w przypadku noworodka z ciąży mnogiej -->
					<xsl:if test="$patientRole/hl7:patient/extPL:multipleBirthInd/@value and $patientRole/hl7:patient/extPL:multipleBirthOrderNumber">
						<div class="header_element">
							<span class="header_label">
								<xsl:value-of select="$multipleBirthOrderNumberLabel"/>
							</span>
							<div class="header_inline_value header_value">
								<xsl:choose>
									<xsl:when test="$patientRole/hl7:patient/extPL:multipleBirthOrderNumber/@nullFlavor">
										<xsl:call-template name="translateNullFlavor">
											<xsl:with-param name="nullableElement" select="$patientRole/hl7:patient/extPL:multipleBirthOrderNumber"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$patientRole/hl7:patient/extPL:multipleBirthOrderNumber/@value"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</div>
					</xsl:if>
					
					<xsl:call-template name="birthPlace">
						<xsl:with-param name="birthPlace" select="$patientRole/hl7:patient/hl7:birthplace"/>
					</xsl:call-template>
					
					<!-- elementy martialStatusCode, religiousAffiliationCode, raceCode, ethnicGroupCode, languageCommunication nie są wyświetlane -->
					
					<!-- płeć -->
					<xsl:call-template name="translateGenderCode">
						<xsl:with-param name="genderCode" select="$patientRole/hl7:patient/hl7:administrativeGenderCode"/>
					</xsl:call-template>
					
					<!-- dane osób bliskich, polskie rozszerzenie na potrzeby skierowania do szpitala psychiatrycznego -->
					<xsl:if test="$patientRole/hl7:patient/extPL:personalRelationship/extPL:templateId/@root = '2.16.840.1.113883.3.4424.13.10.2.9'">
						<xsl:for-each select="$patientRole/hl7:patient/extPL:personalRelationship">
							<div class="header_element">
								<span class="header_label">
									<xsl:choose>
										<xsl:when test="./extPL:code/@nullFlavor">
											<xsl:value-of select="$nameOfClosePersonLabel"/>
										</xsl:when>
										<xsl:when test="./extPL:code/@code = 'MTH'">
											<xsl:value-of select="$nameOfMotherLabel"/>
										</xsl:when>
										<xsl:when test="./extPL:code/@code = 'FTH'">
											<xsl:value-of select="$nameOfFatherLabel"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$nameOfClosePersonLabel"/>
										</xsl:otherwise>
									</xsl:choose>
								</span>
								<div class="header_inline_value header_value">
									<xsl:choose>
										<xsl:when test="./@nullFlavor">
											<xsl:call-template name="translateNullFlavor">
												<xsl:with-param name="nullableElement" select="."/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="./extPL:person/@nullFlavor">
											<xsl:call-template name="translateNullFlavor">
												<xsl:with-param name="nullableElement" select="./extPL:person"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="./extPL:person/extPL:name/@nullFlavor">
											<xsl:call-template name="translateNullFlavor">
												<xsl:with-param name="nullableElement" select="./extPL:person/extPL:name"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="./extPL:person/extPL:name/hl7:given/@nullFlavor">
											<xsl:call-template name="translateNullFlavor">
												<xsl:with-param name="nullableElement" select="./extPL:person/extPL:name/hl7:given"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="./extPL:person/extPL:name/hl7:given"/>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</div>
						</xsl:for-each>
					</xsl:if>
					
					<!-- dane adresowe i kontaktowe pacjenta, przy czym 
						 nullFlavor w adresie pacjenta w receptach, realizacjach, skierowaniach i zleceniach wyświetlany jest wyjątkowo jako NMZ -->
					<xsl:choose>
						<xsl:when test="(hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.3' 
						or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.27'
						or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.4' 
						or hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.1.5') and
						count($patientRole/hl7:addr[not(@nullFlavor)]) = 0">
							<div class="header_element">
								<span class="header_label"><xsl:value-of select="$addressLabel"/></span>
								<!-- kod ustalony legislacyjnie, nie podlega tłumaczeniu -->
								<xsl:text> NMZ</xsl:text>
							</div>
							<xsl:call-template name="addressTelecomInDivs">
								<xsl:with-param name="telecom" select="$patientRole/hl7:telecom"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="addressTelecomInDivs">
								<xsl:with-param name="addr" select="$patientRole/hl7:addr"/>
								<xsl:with-param name="telecom" select="$patientRole/hl7:telecom"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- providerOrganization - nie są wyświetlane dane właściciela rekordu medycznego, z którego pochodzą dane pacjenta
					<xsl:if test="$patientRole/hl7:providerOrganization/hl7:id or $patientRole/hl7:providerOrganization/hl7:name">
						<xsl:call-template name="organization">
							<xsl:with-param name="organization" select="$patientRole/hl7:providerOrganization"/>
							<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
							<xsl:with-param name="level" select="1"/>
							<xsl:with-param name="level1BlockLabel">Właściciel rekordu medycznego</xsl:with-param>
							<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
						</xsl:call-template>
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</div>
		
		<!-- opiekun -->
		<xsl:if test="$patientRole/hl7:patient/hl7:guardian">
			<xsl:call-template name="guardian">
				<xsl:with-param name="guardian" select="$patientRole/hl7:patient/hl7:guardian"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- guardian -->
	<xsl:template name="guardian">
		<xsl:param name="guardian"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="guardianLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Guardian</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Opiekun pacjenta</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="guardianOrganizationLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Guardian organization</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Instytucja opiekuna</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<div class="doc_guardian header_block">
			<span class="guardian_block_label header_block_label">
				<xsl:value-of select="$guardianLabel"/>
			</span>
			<xsl:choose>
				<xsl:when test="$guardian/@nullFlavor">
					<xsl:call-template name="translateNullFlavor">
						<xsl:with-param name="nullableElement" select="$guardian"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- istnieją dane maksymalnie jednego opiekuna: osoby lub instytucji -->
					<!-- imiona i nazwiska lub nazwa opiekuna -->
					<xsl:choose>
						<xsl:when test="$guardian/hl7:guardianPerson">
							<!-- nazwa osoby nie jest wymagana, dopuszczalne jest puste guardianPerson, w takiej sytuacji element nie wyświetla się -->
							<xsl:call-template name="person">
								<xsl:with-param name="person" select="$guardian/hl7:guardianPerson"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$guardian/hl7:guardianOrganization">
							<!-- nazwa instytucji nie jest wymagana, dopuszczale jest puste guardianOrganization, w takiej sytuacji element nie wyświetla się -->
							<xsl:if test="$guardian/hl7:guardianOrganization/hl7:name or $guardian/hl7:guardianOrganization/hl7:id[not(@displayable='false')]">
								<xsl:call-template name="organization">
									<xsl:with-param name="organization" select="$guardian/hl7:guardianOrganization"/>
									<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
									<xsl:with-param name="level" select="1"/>
									<xsl:with-param name="level1BlockLabel" select="$guardianOrganizationLabel"/>
									<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
					
					<!-- code relacji z pacjentem ze słownika 2.16.840.1.113883.5.111, nie zidentyfikowano potrzeby by wyświetlać
					<xsl:call-template name="codeInDiv">
						<xsl:with-param name="code" select="$guardian/hl7:code"/>
						<xsl:with-param name="label">Stopień pokrewieństwa</xsl:with-param>
					</xsl:call-template> -->
					
					<!-- wyświetlane są wyłącznie znane identyfikatory opiekuna -->
					<xsl:call-template name="identifiersInDiv">
						<xsl:with-param name="ids" select="$guardian/hl7:id"/>
						<xsl:with-param name="knownOnly" select="true()"/>
					</xsl:call-template>
					
					<!-- dane adresowe i kontaktowe opiekuna -->
					<xsl:call-template name="addressTelecomInDivs">
						<xsl:with-param name="addr" select="$guardian/hl7:addr"/>
						<xsl:with-param name="telecom" select="$guardian/hl7:telecom"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<!-- participant underwriter templateId 2.16.840.1.113883.3.4424.13.10.2.19 -->
	<xsl:template name="reimbursementRelated">
		<xsl:variable name="underwriter" select="hl7:participant[hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.2.19']"/>
 		
		<!-- IG ogranicza ilość płatników do 1, jeśli w przyszłości dopuści się wielu płatników, każdy powinien otrzymać własny blok -->
		<xsl:if test="$underwriter"> <!-- or $entitlementDocs or $coveragePlans or $coverageEligibilityConfirmation"> --> 
			<div class="doc_underwriter header_block">
				<xsl:call-template name="underwriter">
					<xsl:with-param name="underwriter" select="$underwriter"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- płatnik templateId 2.16.840.1.113883.3.4424.13.10.2.19 -->
	<xsl:template name="underwriter">
		<xsl:param name="underwriter"/>
		
		<!-- IG wymusza jeden znany identyfikator o wartości root:
				- 2.16.840.1.113883.3.4424.3.1 - numer oddziału NFZ
				- 2.16.840.1.113883.3.4424.11.1.49 - kod kraju płatnika wg przepisów o koordynacji -->
		<xsl:if test="$underwriter and count($underwriter) = 1">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="underwriterLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Underwriter</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Płatnik</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- poniższy div nie jest blokiem ani elementem, pełni rolę header_block
				 dla coverageEligibilityConfirmation, coveragePlan, entitlementDoc, teoretycznie może też nie istnieć -->
			<div>
				<span class="underwriter_block_label header_block_label">
					<xsl:value-of select="$underwriterLabel"/>
				</span>
				<div class="underwriter_id_value header_inline_value header_value">
					<xsl:choose>
						<xsl:when test="$underwriter/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$underwriter"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$underwriter/hl7:associatedEntity/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$underwriter/hl7:associatedEntity"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$underwriter/hl7:associatedEntity/hl7:id/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$underwriter/hl7:associatedEntity/hl7:id"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="identifierOID">
								<xsl:with-param name="id" select="$underwriter/hl7:associatedEntity/hl7:id"/>
								<xsl:with-param name="knownOnly" select="true()"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	
	<!-- custodian templateId 2.16.840.1.113883.3.4424.13.10.2.5 oraz 2.16.840.1.113883.3.4424.13.10.2.20 -->
	<xsl:template name="custodian">
		<xsl:variable name="custodian" select="hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization"/>
		
		<!-- wyświetlane są wyłącznie dane kustosza, dla którego możliwe jest wyświetlenie identyfikatora lub nazwy
			 brak obsługi nullFlavor w całym elemencie, 
			 informacja o kustoszu zawsze jest wymagana, znajduje się w dokumencie także gdy nie jest wyświetlana -->
		<xsl:if test="$custodian and (not($custodian/hl7:id/@displayable='false') or string-length($custodian/hl7:name) &gt;= 1)">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="custodianLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Custodian</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Kustosz</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="nameLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Name</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Nazwa</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="doc_custodian header_block">
				<span class="custodian_block_label header_block_label">
					<xsl:value-of select="$custodianLabel"/>
				</span>
				
				<xsl:call-template name="identifiersInDiv">
					<xsl:with-param name="ids" select="$custodian/hl7:id"/>
				</xsl:call-template>
				
				<xsl:if test="string-length($custodian/hl7:name) &gt;= 1">
					<div class="header_element">
						<span class="header_label">
							<xsl:value-of select="$nameLabel"/>
						</span>
						<div class="header_inline_value header_value">
							<xsl:value-of select="$custodian/hl7:name"/>
						</div>
					</div>
				</xsl:if>
				
				<!-- dane adresowe i kontaktowe kustosza -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$custodian/hl7:addr"/>
					<xsl:with-param name="telecom" select="$custodian/hl7:telecom"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- informantionRecipient templateId 2.16.840.1.113883.3.4424.13.10.2.61 -->
	<xsl:template name="informationRecipient">
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:variable name="prcpLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Intended recipient</xsl:text>
				</xsl:when>
				<!-- wyjątek dla skierowań, gdyż adresat dokumentu jest sugerowanym pacjentowi realizatorem skierowania -->
				<xsl:when test="hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.1.4']">
					<xsl:text>Sugerowane miejsce realizacji</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Adresat dokumentu</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="trcLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Secondary recipient</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Dodatkowy adresat dokumentu</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="prcpOrganizationLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Intended recipient organization</xsl:text>
				</xsl:when>
				<!-- wyjątek dla skierowań podobnie jak w przypadku samego realizatora -->
				<xsl:when test="hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.1.4']">
					<xsl:text>Instytucja realizatora</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Instytucja adresata</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:for-each select="hl7:informationRecipient">
			<xsl:choose>
				<xsl:when test="./@nullFlavor">
					<div class="header_block">
						<span class="header_block_label">
							<xsl:choose>
								<xsl:when test="./@typeCode = 'TRC'">
									<xsl:value-of select="$trcLabel"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$prcpLabel"/>
								</xsl:otherwise>
							</xsl:choose>
						</span>
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="."></xsl:with-param>
						</xsl:call-template>
					</div>
				</xsl:when>
				<!-- typ adresata główny PRCP lub dodatkowy TRC -->
				<xsl:when test="./@typeCode = 'TRC'">
					<xsl:call-template name="assignedEntity">
						<xsl:with-param name="entity" select="./hl7:intendedRecipient"/>
						<xsl:with-param name="context">intendedRecipient</xsl:with-param>
						<xsl:with-param name="blockClass">header_block</xsl:with-param>
						<xsl:with-param name="blockLabel" select="$trcLabel"/>
						<xsl:with-param name="organizationLevel1BlockLabel" select="$prcpOrganizationLabel"/>
						<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="assignedEntity">
						<xsl:with-param name="entity" select="./hl7:intendedRecipient"/>
						<xsl:with-param name="context">intendedRecipient</xsl:with-param>
						<xsl:with-param name="blockClass">header_block</xsl:with-param>
						<xsl:with-param name="blockLabel" select="$prcpLabel"/>
						<xsl:with-param name="organizationLevel1BlockLabel" select="$prcpOrganizationLabel"/>
						<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<!-- componentOf, dane wizyty lub pobytu 2.16.840.1.113883.3.4424.13.10.2.52, 2.16.840.1.113883.3.4424.13.10.2.66, 2.16.840.1.113883.3.4424.13.10.2.69 -->
	<xsl:template name="componentOf">
		<xsl:variable name="encounter" select="hl7:componentOf/hl7:encompassingEncounter"/>
		
		<!-- maksymalnie jedno zdarzenie medyczne jest dopuszczalne w dokumencie medycznym -->
		<xsl:if test="$encounter">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="encounterLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Encounter</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Wizyta, pobyt, zdarzenie medyczne</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="dateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="encounterCodeLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Specialty</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Specjalność placówki</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="dischargeDispositionLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Discharge disposition code</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Tryb wypisu</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<div class="doc_component_of header_block">
				<span class="component_of_block_label header_block_label">
					<xsl:value-of select="$encounterLabel"/>
				</span>
				<xsl:choose>
					<xsl:when test="hl7:componentOf/@nullFlavor">
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="hl7:componentOf"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$encounter/@nullFlavor">
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="$encounter"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="identifiersInDiv">
							<xsl:with-param name="ids" select="$encounter/hl7:id"/>
						</xsl:call-template>
						
						<!-- specjalność placówki, tj. VIII część kodu resortowego -->
						<xsl:call-template name="codeInDiv">
							<xsl:with-param name="code" select="$encounter/hl7:code"/>
							<xsl:with-param name="label" select="$encounterCodeLabel"/>
						</xsl:call-template>
						
						<xsl:call-template name="dateTimeInDiv">
							<xsl:with-param name="date" select="$encounter/hl7:effectiveTime"/>
							<xsl:with-param name="label" select="$dateLabel"/>
							<xsl:with-param name="divClass">header_element</xsl:with-param>
						</xsl:call-template>
						
						<xsl:call-template name="codeInDiv">
							<!-- wyłącznie value set 2.16.840.1.113883.3.4424.13.11.36 ze słownika 2.16.840.1.113883.3.4424.11.3.21 Tryb wypisu ze szpitala,
								 podane w value set nazwy wyświetlania powodują wymuszenie wartości displayName w kodzie w dokumencie -->
							<xsl:with-param name="code" select="$encounter/hl7:dischargeDispositionCode"/>
							<xsl:with-param name="label" select="$dischargeDispositionLabel"/>
						</xsl:call-template>
						
						<!-- location (healthcareFacility z place lub organization) 0:1 -->
						<xsl:call-template name="location">
							<xsl:with-param name="location" select="$encounter/hl7:location"/>
						</xsl:call-template>
						
						<!-- responsibleParty 0:1 -->
						<xsl:if test="$encounter/hl7:responsibleParty/hl7:assignedEntity">
							<xsl:variable name="responsiblePartyOrganizationLabel">
								<xsl:choose>
									<xsl:when test="$lang = $secondLanguage">
										<xsl:text>Organization</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Instytucja osoby odpowiedzialnej</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="responsiblePartyLabel">
								<xsl:choose>
									<xsl:when test="$lang = $secondLanguage">
										<xsl:text>Responsible party</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Osoba odpowiedzialna</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<div class="header_block0">
								<span class="header_block_label">
									<xsl:value-of select="$responsiblePartyLabel"/>
								</span>
								
								<xsl:call-template name="showDheaderEnabler">
									<xsl:with-param name="blockName">responsible_party</xsl:with-param>
								</xsl:call-template>
								
								<div class="header_dheader">
									<xsl:call-template name="assignedEntity">
										<xsl:with-param name="entity" select="$encounter/hl7:responsibleParty/hl7:assignedEntity"/>
										<xsl:with-param name="blockClass">header_block</xsl:with-param>
										<xsl:with-param name="blockLabel"/>
										<xsl:with-param name="organizationLevel1BlockLabel" select="$responsiblePartyOrganizationLabel"/>
										<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
									</xsl:call-template>
								</div>
							</div>						
						</xsl:if>
						
						
						<!-- encounterParticipant 0:* -->
						<xsl:if test="count($encounter/hl7:encounterParticipant) &gt; 0">
							<xsl:variable name="participantOrganizationLabel">
								<xsl:choose>
									<xsl:when test="$lang = $secondLanguage">
										<xsl:text>Organization</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Instytucja osoby uczestniczącej</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="participantLabel">
								<xsl:choose>
									<xsl:when test="$lang = $secondLanguage">
										<xsl:text>Encounter participant</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Osoba uczestnicząca</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="participantDateLabel">
								<xsl:choose>
									<xsl:when test="$lang = $secondLanguage">
										<xsl:text>Date</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Data</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="participantRoleLabel">
								<xsl:choose>
									<xsl:when test="$lang = $secondLanguage">
										<xsl:text>Role</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Rola</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>							
							
							<div class="header_block0">
								<span class="header_block_label">
									<xsl:value-of select="$participantLabel"/>
								</span>
								<xsl:call-template name="showDheaderEnabler">
									<xsl:with-param name="blockName">encounter_participant</xsl:with-param>
								</xsl:call-template>
								<div class="header_dheader">
									<xsl:for-each select="$encounter/hl7:encounterParticipant">
										<xsl:variable name="typeCodeAndTime">
											<div class="header_element">
												<span class="header_label">
													<xsl:value-of select="$participantRoleLabel"/>
												</span>
												<div class="header_inline_value header_value">
													<!-- wyłącznie value set 2.16.840.1.113883.1.11.19600 Uczestnik wizyty,
														 wartości tego słownika nie zostały przetłumaczone na język polski, próba w wywoływanej translacji -->
													<xsl:call-template name="translateEncounterParticipantTypeCode">
														<xsl:with-param name="typeCode" select="./@typeCode"/>
													</xsl:call-template>
												</div>
											</div>
											
											<xsl:call-template name="dateTimeInDiv">
												<xsl:with-param name="date" select="./hl7:time"/>
												<xsl:with-param name="label" select="$participantDateLabel"/>
												<xsl:with-param name="divClass">header_element</xsl:with-param>
											</xsl:call-template>
										</xsl:variable>
										
										<xsl:call-template name="assignedEntity">
											<xsl:with-param name="entity" select="./hl7:assignedEntity"/>
											<xsl:with-param name="blockClass">header_block</xsl:with-param>
											<xsl:with-param name="blockLabel"/>
											<xsl:with-param name="organizationLevel1BlockLabel" select="$participantOrganizationLabel"/>
											<xsl:with-param name="addToLevel1" select="$typeCodeAndTime"/>
											<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
										</xsl:call-template>
									</xsl:for-each>
								</div>
							</div>		
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- documentationOf templateId 2.16.840.1.113883.3.4424.13.10.2.51 -->
	<xsl:template name="documentationOf">
		<xsl:variable name="documentationOf" select="hl7:documentationOf"/>
		
		<xsl:if test="count($documentationOf) &gt; 0">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="serviceLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Documentation of service</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Dokumentacja wykonanej usługi</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="serviceCodeLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Procedure</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Procedura</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="serviceDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data wykonania</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="functionLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Function</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Funkcja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- element documentationOf (procedury, w wyniku których dokument powstał) -->
			<xsl:for-each select="$documentationOf">
				<div class="doc_documentation_of header_block">
					<span class="documentation_of_block_label header_block_label">
						<xsl:value-of select="$serviceLabel"/>
					</span>
					<xsl:choose>
						<xsl:when test="./@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="."/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="./hl7:serviceEvent/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="./hl7:serviceEvent"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="identifiersInDiv">
								<xsl:with-param name="ids" select="./hl7:serviceEvent/hl7:id"/>
							</xsl:call-template>
							
							<xsl:call-template name="dateTimeInDiv">
								<xsl:with-param name="date" select="./hl7:serviceEvent/hl7:effectiveTime"/>
								<xsl:with-param name="label" select="$serviceDateLabel"/>
								<xsl:with-param name="divClass">header_element</xsl:with-param>
							</xsl:call-template>
							
							<xsl:call-template name="codeInDiv">
								<xsl:with-param name="code" select="./hl7:serviceEvent/hl7:code"/>
								<xsl:with-param name="label" select="$serviceCodeLabel"/>
							</xsl:call-template>
							
							<xsl:variable name="performers" select="./hl7:serviceEvent/hl7:performer[@typeCode = 'PPRF']"/>
							<xsl:variable name="participants" select="./hl7:serviceEvent/hl7:performer[@typeCode != 'PPRF']"/>
							
							<xsl:if test="count($performers) &gt; 0">
								<xsl:variable name="performerLabel">
									<xsl:choose>
										<xsl:when test="count($performers) = 1 and $lang = $secondLanguage">
											<xsl:text>Performer</xsl:text>
										</xsl:when>
										<xsl:when test="count($performers) &gt; 1 and $lang = $secondLanguage">
											<xsl:text>Performers</xsl:text>
										</xsl:when>
										<xsl:when test="count($performers) = 1">
											<xsl:text>Osoba wykonująca</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Osoby wykonujące</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:call-template name="servicePerformer">
									<xsl:with-param name="performerList" select="$performers"/>
									<xsl:with-param name="performerLabel" select="$performerLabel"/>
									<xsl:with-param name="organizationLabel" select="$organizationLabel"/>
									<xsl:with-param name="functionLabel" select="$functionLabel"/>
									<xsl:with-param name="serviceDateLabel" select="$serviceDateLabel"/>
									<xsl:with-param name="enableLabel" select="$enableLabel"/>
									<xsl:with-param name="enablerBlockName">service_performer_pprf</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							
							<xsl:if test="count($participants) &gt; 0">
								<xsl:variable name="performerLabel">
									<xsl:choose>
										<xsl:when test="count($participants) = 1 and $lang = $secondLanguage">
											<xsl:text>Participant</xsl:text>
										</xsl:when>
										<xsl:when test="count($participants) &gt; 1 and $lang = $secondLanguage">
											<xsl:text>Participants</xsl:text>
										</xsl:when>
										<xsl:when test="count($participants) = 1">
											<xsl:text>Osoba uczestnicząca</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Osoby uczestniczące</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:call-template name="servicePerformer">
									<xsl:with-param name="performerList" select="$participants"/>
									<xsl:with-param name="performerLabel" select="$performerLabel"/>
									<xsl:with-param name="organizationLabel" select="$organizationLabel"/>
									<xsl:with-param name="functionLabel" select="$functionLabel"/>
									<xsl:with-param name="serviceDateLabel" select="$serviceDateLabel"/>
									<xsl:with-param name="enableLabel" select="$enableLabel"/>
									<xsl:with-param name="enablerBlockName">service_performer_prf</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<!-- dane osoby wykonującej usługę -->
	<xsl:template name="servicePerformer">
		<xsl:param name="performerList"/>
		<xsl:param name="performerLabel"/>
		<xsl:param name="organizationLabel"/>
		<xsl:param name="functionLabel"/>
		<xsl:param name="serviceDateLabel"/>
		<xsl:param name="enableLabel"/>
		<xsl:param name="enablerBlockName"/>
		
		<div class="header_block0">
			<span class="header_block_label">
				<xsl:value-of select="$performerLabel"/>
			</span>
			<xsl:call-template name="showDheaderEnabler">
				<xsl:with-param name="blockName" select="$enablerBlockName"/>
			</xsl:call-template>
			<div class="header_dheader">
				<xsl:for-each select="$performerList">
					<xsl:call-template name="assignedEntity">
						<xsl:with-param name="entity" select="./hl7:assignedEntity"/>
						<xsl:with-param name="blockClass">header_block</xsl:with-param>
						<xsl:with-param name="blockLabel"/>
						<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
						<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
					</xsl:call-template>
					
					<xsl:if test="./hl7:functionCode">
						<div class="header_element">
							<span class="header_label">
								<xsl:value-of select="$functionLabel"/>
							</span>
							<div class="header_inline_value header_value">
								<!-- wyłącznie value set 2.16.840.1.113883.1.11.10267 Funkcja osoby w ramach usługi (np. położna) -->
								<xsl:call-template name="translateServiceEventPerformerFunctionCode">
									<xsl:with-param name="functionCode" select="./hl7:functionCode/@code"/>
								</xsl:call-template>
							</div>
						</div>
					</xsl:if>
					
					<xsl:call-template name="dateTimeInDiv">
						<xsl:with-param name="date" select="./hl7:time"/>
						<xsl:with-param name="label" select="$serviceDateLabel"/>
						<xsl:with-param name="divClass">header_element</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
	
	<!-- inFulfillmentOf templateId 2.16.840.1.113883.3.4424.13.10.2.53 -->
	<xsl:template name="inFulfillmentOf">
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="orderLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Order</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Wykonano na podstawie zamówienia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Rodzaj</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="priorityLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Priority</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Priorytet</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="urgentLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>urgent</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>pilne</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- element inFulfillmentOf (zlecenie/skierowanie, na podstawie którego dokument powstał) -->
		<xsl:for-each select="hl7:inFulfillmentOf">
			<div class="doc_in_fulfillment_of header_block">
				<span class="in_fulfillment_of_block_label header_block_label">
					<xsl:value-of select="$orderLabel"/>
				</span>
				<xsl:choose>
					<xsl:when test="./@nullFlavor">
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="."/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="./hl7:order/@nullFlavor">
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="./hl7:order"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- identyfikator dokumentu -->
						<xsl:call-template name="identifiersInDiv">
							<xsl:with-param name="ids" select="./hl7:order/hl7:id"/>
							<xsl:with-param name="knownOnly" select="false()"/>
						</xsl:call-template>
						
						<!-- opcjonalny code z kodem słownika 2.16.840.1.113883.5.4 (nie został przetłumaczony na język polski) wyświetlany jest z dokumentu -->
						<xsl:call-template name="codeInDiv">
							<xsl:with-param name="code" select="./hl7:order/hl7:code"/>
							<xsl:with-param name="label" select="codeLabel"/>
						</xsl:call-template>
						
						<!-- kod pilności wyświetlany jest jedynie dla wartości z valueSet 2.16.840.1.113883.3.4424.13.11.26: UR, tj. pilne, 
							 wartość R normalna nie jest wyświetlana, pozostałe dopuszczalne template wartości są pomijane -->
						<xsl:if test="./hl7:order/hl7:priorityCode/@code = 'UR' and not(./hl7:order/hl7:priorityCode/@nullFlavor)">
							<div class="header_element">
								<span class="header_label">
									<xsl:value-of select="$priorityLabel"/>
								</span>
								<div class="urgent_priority_code_value header_inline_value header_value">
									<xsl:value-of select="$urgentLabel"/>
								</div>
							</div>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<!-- dataEnterer, dane osoby wypełniającej dokument wyświetlane są w popupie -->
	<xsl:template name="dataEnterer">
		<xsl:variable name="dataEnterer" select="hl7:dataEnterer"/>
		
		<!-- maksymalnie jeden możliwy wprowadzający dane -->
		<xsl:if test="$dataEnterer">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="transcriptionDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Transcription date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data wprowadzenia</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="dataEntererLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Data enterer</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Wprowadzający dane</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_block">
				<span class="header_block_label">
					<xsl:value-of select="$dataEntererLabel"/>
				</span>
				<xsl:call-template name="showDheaderEnabler">
					<xsl:with-param name="blockName">data_enterer</xsl:with-param>
				</xsl:call-template>
				<div class="header_dheader">
					<xsl:call-template name="assignedEntity">
						<xsl:with-param name="entity" select="$dataEnterer/hl7:assignedEntity"/>
						<xsl:with-param name="blockClass"/>
						<xsl:with-param name="blockLabel"/>
						<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
						<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
					</xsl:call-template>
					
					<!-- data urodzenia -->
					<xsl:call-template name="dateTimeInDiv">
						<xsl:with-param name="date" select="$dataEnterer/hl7:time"/>
						<xsl:with-param name="label" select="$transcriptionDateLabel"/>
						<xsl:with-param name="divClass">header_element</xsl:with-param>
						<xsl:with-param name="calculateAge" select="false()"/>
					</xsl:call-template>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!--  authenticator, osoby poświadczające -->
	<xsl:template name="authenticator">
		<xsl:variable name="authenticator" select="hl7:authenticator"/>
		
		<xsl:if test="count($authenticator)&gt;0">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="authenticatorDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="authenticatorLabel">
				<xsl:choose>
					<xsl:when test="count($authenticator) = 1 and $lang = $secondLanguage">
						<xsl:text>Authenticator</xsl:text>
					</xsl:when>
					<xsl:when test="count($authenticator) &gt; 1 and $lang = $secondLanguage">
						<xsl:text>Authenticators</xsl:text>
					</xsl:when>
					<xsl:when test="count($authenticator) = 1">
						<xsl:text>Poświadczający</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Poświadczający</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_block">
				<span class="header_block_label">
					<xsl:value-of select="$authenticatorLabel"/>
				</span>
				<xsl:call-template name="showDheaderEnabler">
					<xsl:with-param name="blockName">authenticator</xsl:with-param>
				</xsl:call-template>
				<div class="header_dheader">
					<xsl:for-each select="$authenticator">
						<xsl:call-template name="assignedEntity">
							<xsl:with-param name="entity" select="./hl7:assignedEntity"/>
							<xsl:with-param name="blockClass">header_block</xsl:with-param>
							<xsl:with-param name="blockLabel"/>
							<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
							<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
						</xsl:call-template>
						
						<xsl:if test="./hl7:signatureCode/@code = 'S'">
							<div class="header_element">
								<span class="header_label">
									<xsl:choose>
										<xsl:when test="$lang = $secondLanguage">
											<xsl:text>Signed electronically</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Złożono podpis elektroniczny</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</div>
						</xsl:if>
						<xsl:call-template name="dateTimeInDiv">
							<xsl:with-param name="date" select="./hl7:time"/>
							<xsl:with-param name="label" select="$authenticatorDateLabel"/>
							<xsl:with-param name="divClass">header_element</xsl:with-param>
							<xsl:with-param name="calculateAge" select="false()"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- author templateId 2.16.840.1.113883.3.4424.13.10.2.4 -->
	<xsl:template name="author">
		<!-- lista autorów za wyjątkiem autora będącego jednocześnie wystawcą dokumentu. Zgodnie z HL7 CDA autor może być osobą lub urządzeniem (w polskim IG urządzenie nie jest tu dopuszczalne, jednak zaimplementowano tę część na wypadek konieczności wyświetlenia dokumentu zewnętrznego -->
		<xsl:variable name="author" select="/hl7:ClinicalDocument/hl7:author[not(hl7:assignedAuthor/hl7:id[@root=/hl7:ClinicalDocument/hl7:legalAuthenticator/hl7:assignedEntity/hl7:id/@root and @extension=/hl7:ClinicalDocument/hl7:legalAuthenticator/hl7:assignedEntity/hl7:id/@extension])]"/>
		
		<xsl:if test="count($author)&gt;0">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="authorDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="authorLabel">
				<xsl:choose>
					<xsl:when test="count($author) = 1 and $lang = $secondLanguage">
						<xsl:text>Co-author</xsl:text>
					</xsl:when>
					<xsl:when test="count($author) &gt; 1 and $lang = $secondLanguage">
						<xsl:text>Co-authors</xsl:text>
					</xsl:when>
					<xsl:when test="count($author) = 1">
						<xsl:text>Współautor</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Współautorzy</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_block">
				<span class="header_block_label">
					<xsl:value-of select="$authorLabel"/>
				</span>
				<xsl:call-template name="showDheaderEnabler">
					<xsl:with-param name="blockName">author</xsl:with-param>
				</xsl:call-template>
				<div class="header_dheader">
					<xsl:for-each select="$author">
						<xsl:call-template name="assignedEntity">
							<xsl:with-param name="entity" select="./hl7:assignedAuthor"/>
							<xsl:with-param name="blockClass">header_block</xsl:with-param>
							<xsl:with-param name="blockLabel"/>
							<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
							<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
						</xsl:call-template>
						<xsl:call-template name="dateTimeInDiv">
							<xsl:with-param name="date" select="./hl7:time"/>
							<xsl:with-param name="label" select="$authorDateLabel"/>
							<xsl:with-param name="divClass">header_element</xsl:with-param>
							<xsl:with-param name="calculateAge" select="false()"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- informant 0:*, dane osoby, której relację spisano w dokumencie, wstępnie na poziomie headera, brak generycznego kodu dla sekcji -->
	<xsl:template name="informant">
		<xsl:variable name="informant" select="hl7:informant"/>
		
		<xsl:if test="count($informant)&gt;0">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="informationDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Information date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data informacji</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="informantLabel">
				<xsl:choose>
					<xsl:when test="count($informant) = 1 and $lang = $secondLanguage">
						<xsl:text>Informant</xsl:text>
					</xsl:when>
					<xsl:when test="count($informant) &gt; 1 and $lang = $secondLanguage">
						<xsl:text>Informants</xsl:text>
					</xsl:when>
					<xsl:when test="count($informant) = 1">
						<xsl:text>Informator</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Informatorzy</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<div class="header_block">
				<span class="header_block_label">
					<xsl:value-of select="$informantLabel"/>
				</span>
				<xsl:call-template name="showDheaderEnabler">
					<xsl:with-param name="blockName">informant</xsl:with-param>
				</xsl:call-template>
				<div class="header_dheader">
					<xsl:for-each select="$informant">
							<xsl:choose>
								<xsl:when test="./hl7:assignedEntity">
									<xsl:call-template name="assignedEntity">
										<xsl:with-param name="entity" select="./hl7:assignedEntity"/>
										<xsl:with-param name="blockClass">header_block</xsl:with-param>
										<xsl:with-param name="blockLabel"/>
										<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
										<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="assignedEntity">
										<xsl:with-param name="entity" select="./hl7:relatedEntity"/>
										<xsl:with-param name="context">relatedEntity</xsl:with-param>
										<xsl:with-param name="blockClass">header_block</xsl:with-param>
										<xsl:with-param name="blockLabel"/>
										<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
										<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
									</xsl:call-template>
									<xsl:call-template name="dateTimeInDiv">
										<xsl:with-param name="date" select="./hl7:relatedEntity/hl7:effectiveTime"/>
										<xsl:with-param name="label" select="$informationDateLabel"/>
										<xsl:with-param name="divClass">header_element</xsl:with-param>
										<xsl:with-param name="calculateAge" select="false()"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- authorization (consent, zgoda pacjenta) -->
	<xsl:template name="authorization">
		<xsl:variable name="authorization" select="hl7:authorization"/>
		
		<xsl:if test="count($authorization)&gt;0">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
			<xsl:variable name="authorizationLabel">
				<xsl:choose>
					<xsl:when test="count($authorization) = 1 and $lang = $secondLanguage">
						<xsl:text>The consent has been registered</xsl:text>
					</xsl:when>
					<xsl:when test="count($authorization) &gt; 1 and $lang = $secondLanguage">
						<xsl:text>The consents have been registered</xsl:text>
					</xsl:when>
					<xsl:when test="count($authorization) = 1">
						<xsl:text>Zarejestrowano zgodę</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Zarejestrowano zgody</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="consentCodeLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Consent type</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rodzaj zgody</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_block">
				<span class="header_block_label">
					<xsl:value-of select="$authorizationLabel"/>
				</span>
				<xsl:call-template name="showDheaderEnabler">
					<xsl:with-param name="blockName">authorization</xsl:with-param>
				</xsl:call-template>
				<div class="header_dheader">
					<xsl:for-each select="$authorization">
						<div class="header_block">
							<xsl:choose>
								<xsl:when test="./@nullFlavor">
									<xsl:call-template name="translateNullFlavor">
										<xsl:with-param name="nullableElement" select="."/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="./hl7:consent/@nullFlavor">
									<xsl:call-template name="translateNullFlavor">
										<xsl:with-param name="nullableElement" select="./hl7:consent"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<!-- identyfikator dokumentu zgody, przynajmniej jeden jest wymagany wg schematu, choć wg schemy tylko code jest wymagany -->
									<xsl:call-template name="identifiersInDiv">
										<xsl:with-param name="ids" select="./hl7:consent/hl7:id"/>
										<xsl:with-param name="knownOnly" select="false()"/>
									</xsl:call-template>
									
									<!-- opcjonalny code (wg schemy wymagany) z kodem nieokreślonego z góry słownika, dotyczy informacji na co wydano zgodę -->
									<xsl:call-template name="codeInDiv">
										<xsl:with-param name="code" select="./hl7:consent/hl7:code"/>
										<xsl:with-param name="label" select="$consentCodeLabel"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- participant (inny niż płatnik templateId 2.16.840.1.113883.3.4424.13.10.2.19) -->
	<xsl:template name="participant">
		<!-- element participant templateId 2.16.840.1.113883.3.4424.13.10.2.19 wyświetlany jest w ramach template reimbursementRelated -->
		<xsl:variable name="participant" select="hl7:participant[not(hl7:templateId/@root = '2.16.840.1.113883.3.4424.13.10.2.19')]"/>
		
		<xsl:if test="count($participant)&gt;0">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="participantDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Participation date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data udziału</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="participantLabel">
				<xsl:choose>
					<xsl:when test="count($participant) = 1 and $lang = $secondLanguage">
						<xsl:text>Participant</xsl:text>
					</xsl:when>
					<xsl:when test="count($participant) &gt; 1 and $lang = $secondLanguage">
						<xsl:text>Participants</xsl:text>
					</xsl:when>
					<xsl:when test="count($participant) = 1">
						<xsl:text>Współudział</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Współudział</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="enableLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Show more</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rozwiń</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_block">
				<span class="header_block_label">
					<xsl:value-of select="$participantLabel"/>
				</span>
				<xsl:call-template name="showDheaderEnabler">
					<xsl:with-param name="blockName">participant</xsl:with-param>
				</xsl:call-template>
				<div class="header_dheader">
					<xsl:for-each select="$participant">
						<xsl:call-template name="assignedEntity">
							<xsl:with-param name="entity" select="./hl7:associatedEntity"/>
							<xsl:with-param name="blockClass">header_block</xsl:with-param>
							<xsl:with-param name="blockLabel"/>
							<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
							<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
						</xsl:call-template>
						<xsl:call-template name="dateTimeInDiv">
							<xsl:with-param name="date" select="./hl7:time"/>
							<xsl:with-param name="label" select="$participantDateLabel"/>
							<xsl:with-param name="divClass">header_element</xsl:with-param>
							<xsl:with-param name="calculateAge" select="false()"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- ++++++++++++++++++++++++++++++++++++++ DRUGA LINIA +++++++++++++++++++++++++++++++++++++++++++-->
	
	<!-- osoba przypisana AssignedEntity templateId 2.16.840.1.113883.3.4424.13.10.2.49 
		 wykorzytywane też do wyświetlenia IntendedRecipient i RelatedEntity oraz w przypadku autora będącego urządzeniem, także AuthoringDevice -->
	<xsl:template name="assignedEntity">
		<xsl:param name="entity"/>
		<!-- kontekst domyślny, dodatkowo obsługa intendedRecipient i RelatedEntity -->
		<xsl:param name="context">assignedEntity</xsl:param>
		<xsl:param name="blockClass">header_block0</xsl:param>
		<xsl:param name="blockLabel">Blok danych</xsl:param>
		<xsl:param name="organizationLevel1BlockLabel" select="false()"/>
		<xsl:param name="knownIdentifiersOnly" select="true()"/>
		<!-- opcjonalna wartość RTF do dodania po identyfikatorach -->
		<xsl:param name="addToLevel1Label" select="false()"/>
		<xsl:param name="addToLevel1" select="false()"/>
		<xsl:param name="hideSecondOrgLevel" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<!-- id 1:*, code 0:1, addr 0:*, telecom 0:*, assignedPerson 0:1/1:1, representedOrganization 0:1 -->
		<!-- w RelatedEntity istnieje dodatkowo code relacji z pacjentem i czas złożenia informacji, brak za to id -->
		<xsl:if test="$entity">
			<!-- poziom stylu 0 oznacza w wizualizacji poziom Act, do którego przypisany jest byt entity -->
			<div class="{$blockClass}">
				<span class="header_block_label">
					<xsl:value-of select="$blockLabel"/>
				</span>
				<xsl:choose>
					<xsl:when test="$entity/@nullFlavor">
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="$entity"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="assignedEntityText">
							<xsl:if test="$addToLevel1Label">
								<xsl:copy-of select="$addToLevel1Label"/>
							</xsl:if>
							
							<!-- osoba przypisana, opcjonalnie również urządzenie w przypadku autora w kontekście assignedEntity -->
							<xsl:choose>
								<xsl:when test="$context = 'assignedEntity'">
									<xsl:choose>
										<xsl:when test="$entity/hl7:assignedPerson">
											<xsl:call-template name="person">
												<xsl:with-param name="person" select="$entity/hl7:assignedPerson"/>
											</xsl:call-template>
										</xsl:when>
										<!-- brak obsługi informacji o ostatnim przeglądzie urządzenia i serwisancie (MaintainedDevice) -->
										<xsl:when test="$entity/hl7:assignedAuthoringDevice">
											<xsl:call-template name="device">
												<xsl:with-param name="device" select="$entity/hl7:assignedAuthoringDevice"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$context = 'intendedRecipient'">
									<xsl:call-template name="person">
										<xsl:with-param name="person" select="$entity/hl7:informationRecipient"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$context = 'relatedEntity'">
									<xsl:call-template name="person">
										<xsl:with-param name="person" select="$entity/hl7:relatedPerson"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
							
							<!-- kod roli przypisanego bytu, wykorzystywane gdy jest to słownik zawodów medycznych i podana jest wartość displayName
								 użycie dla innych słowników wymaga zdefiniowania zastosowania tego kodu w IG dla tych słowników
								 dodatkowo zawód wyświetlany jest wyłącznie przy identyfikatorze, o ile podano przynajmniej jeden identyfikator
								 wprowadzając zgodność z IHE PRE zawartość z code została przeniesiona o poziom wyżej do functionCode, cofnięcie się o poziom wyżej jest bezpieczne -->
							<xsl:variable name="idPrefix">
								<xsl:choose>
									<xsl:when test="$entity/../hl7:functionCode/@codeSystem = '2.16.840.1.113883.3.4424.11.3.18' and string-length($entity/../hl7:functionCode/@displayName) &gt;= 1">
										<xsl:value-of select="$entity/../hl7:functionCode/@displayName"/>
									</xsl:when>
									<xsl:when test="$entity/hl7:code/@codeSystem = '2.16.840.1.113883.3.4424.11.3.18' and string-length($entity/hl7:code/@displayName) &gt;= 1">
										<xsl:value-of select="$entity/hl7:code/@displayName"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							
							<!-- identyfikator zwykle osoby w roli, nie używa się dla relatedEntity -->
							<xsl:if test="not($context = 'relatedEntity')">
								<xsl:call-template name="identifiersInDiv">
									<xsl:with-param name="ids" select="$entity/hl7:id"/>
									<xsl:with-param name="knownOnly" select="$knownIdentifiersOnly"/>
									<xsl:with-param name="prefix" select="$idPrefix"/>
								</xsl:call-template>
							</xsl:if>
							
							<!-- Specjalność autora, obowiązuje od PIK 1.2.1 zgodnie z IHE PRE -->
							<xsl:if test="$context = 'assignedEntity' and $entity/hl7:code and starts-with($entity/hl7:code/@codeSystem, '2.16.840.1.113883.3.4424.11.3.3')">
								<xsl:call-template name="personQualifiedEntity">
									<xsl:with-param name="qualificationCode" select="$entity/hl7:code"/>
								</xsl:call-template>
							</xsl:if>
							
							<!-- relacja z pacjentem (wyłącznie informant) -->
							<xsl:if test="$context = 'relatedEntity' and string-length($entity/hl7:code/@code) &gt;= 1">
								<xsl:variable name="relationshipLabel">
									<xsl:choose>
										<xsl:when test="$lang = $secondLanguage">
											<xsl:text>Relationship</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Relacja</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<div class="header_element">
									<span class="header_label">
										<xsl:value-of select="$relationshipLabel"/>
									</span>
									<div class="header_inline_value header_value">
										<xsl:call-template name="translatePersonalRelationshipRoleCode">
											<xsl:with-param name="roleCode" select="$entity/hl7:code/@code"/>
										</xsl:call-template>
									</div>
								</div>
							</xsl:if>
							
							<!-- czas poinformowania przez relatedEntity -->
							<xsl:if test="$context = 'relatedEntity' and $entity/hl7:effectiveTime">
								<xsl:variable name="informationDateLabel">
									<xsl:choose>
										<xsl:when test="$lang = $secondLanguage">
											<xsl:text>Information date</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Data poinformowania</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:call-template name="dateTimeInDiv">
									<xsl:with-param name="date" select="$entity/hl7:effectiveTime"/>
									<xsl:with-param name="label" select="$informationDateLabel"/>
									<xsl:with-param name="divClass">effective_time_header_element doc_header_element header_element</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							
							<xsl:if test="$addToLevel1">
								<xsl:copy-of select="$addToLevel1"/>
							</xsl:if>
							
							<!-- dane adresowe i kontaktowe przypisanego bytu -->
							<xsl:call-template name="addressTelecomInDivs">
								<xsl:with-param name="addr" select="$entity/hl7:addr"/>
								<xsl:with-param name="telecom" select="$entity/hl7:telecom"/>
							</xsl:call-template>
						</xsl:variable>
						
						<!-- variable assignedEntityText utworzona jest by zweryfikować 
							 czy poziom assignedEntity i person zawiera treść, 
							 jeżeli nie, dane organizacji wyświetlane są na pierwszym poziomie -->
						<xsl:copy-of select="$assignedEntityText"/>
						
						<xsl:variable name="addNextLevel" select="string-length($assignedEntityText) &gt; 0"/>
						
						<!-- dane instytucji dla AssignedEntity lub IntendedRecipient, nie istnieją dla relatedEntity -->
						<xsl:choose>
							<xsl:when test="$context = 'assignedEntity'">
								<!-- jeżeli cokolwiek wyświetlono z danych osoby lub osoby przypisanej, dane organizacji wyświetlane są na level 1 -->
								<xsl:call-template name="organization">
									<xsl:with-param name="organization" select="$entity/hl7:representedOrganization"/>
									<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
									<xsl:with-param name="level" select="1"/>
									<xsl:with-param name="level1BlockLabel" select="$organizationLevel1BlockLabel"/>
									<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
									<xsl:with-param name="addNextLevel" select="$addNextLevel"/>
									<xsl:with-param name="hideNextLevel" select="$hideSecondOrgLevel"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$context = 'intendedRecipient'">
								<xsl:call-template name="organization">
									<xsl:with-param name="organization" select="$entity/hl7:receivedOrganization"/>
									<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
									<xsl:with-param name="level" select="1"/>
									<xsl:with-param name="level1BlockLabel" select="$organizationLevel1BlockLabel"/>
									<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
									<xsl:with-param name="addNextLevel" select="$addNextLevel"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- organization templateId 2.16.840.1.113883.3.4424.13.10.2.2
		 rekurencyjnie dla nieznanych instytucji i płasko dla podmiotów i aptek -->
	<xsl:template name="organization">
		<xsl:param name="organization"/>
		<xsl:param name="showAddressAndContactInfo" select="false()"/>
		<xsl:param name="level" select="false()"/>
		<xsl:param name="level1BlockLabel" select="false()"/>
		<xsl:param name="knownIdentifiersOnly" select="false()"/>
		<xsl:param name="addNextLevel" select="false()"/>
		<xsl:param name="hideNextLevel" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="firstLevelLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>As part of institution</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Jako część instytucji</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="secondLevelLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Within organization</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>W ramach organizacji</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="typeOfActivityLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Rodzaj działalności</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- kod nieoptymalny z powodu wyświetlania jak najmniejszej ilości danych w najpopularniejszych przypadkach -->
		<xsl:if test="$organization">
			<xsl:choose>
				<!-- rozpoznanie szablonów szczegółowych tylko dla pierwszego poziomu -->
				<xsl:when test="not($level) or $level = 0 or $level = 1">
					<xsl:choose>
						<xsl:when test="$addNextLevel">
							<div class="doc_legal_authenticator_organization_{$level} header_block{$level}">
								<xsl:if test="$level1BlockLabel">
									<span class="legal_authenticator_organization_block_label header_block_label">
										<xsl:value-of select="$level1BlockLabel"/>
									</span>
								</xsl:if>
								<xsl:call-template name="organizationContent">
									<xsl:with-param name="organization" select="$organization"/>
									<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
									<xsl:with-param name="knownIdentifiersOnly" select="$knownIdentifiersOnly"/>
									<xsl:with-param name="hideNextLevel" select="$hideNextLevel"/>
								</xsl:call-template>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="organizationContent">
								<xsl:with-param name="organization" select="$organization"/>
								<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
								<xsl:with-param name="knownIdentifiersOnly" select="$knownIdentifiersOnly"/>
								<xsl:with-param name="hideNextLevel" select="$hideNextLevel"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$hideNextLevel">
					<!-- nagłówek dla każdego poziomu poza pierwszym w ramach ogólnego szablonu organizacji. 
						 Wyświetlane są tu wyłącznie nieznane typy instytucji. -->
					<span class="legal_authenticator_organization_block_label header_block_label">
						<xsl:value-of select="$firstLevelLabel"/>
					</span>
					
					<xsl:call-template name="showDheaderEnabler">
						<xsl:with-param name="blockName">legal_authenticator</xsl:with-param>
					</xsl:call-template>
					
					<div class="header_dheader">
						<xsl:call-template name="organizationLevelContent">
							<xsl:with-param name="organization" select="$organization"/>
							<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
						</xsl:call-template>
						<!-- rekurencja -->
						<xsl:if test="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization">
							<xsl:call-template name="organization">
								<xsl:with-param name="organization" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization"/>
								<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
								<xsl:with-param name="level" select="$level+1"/>
								<xsl:with-param name="knownIdentifiersOnly" select="$knownIdentifiersOnly"/>
							</xsl:call-template>
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<!-- nagłówek dla każdego poziomu poza pierwszym w ramach ogólnego szablonu organizacji. 
						 Wyświetlane są tu wyłącznie nieznane typy instytucji. -->
					<span class="legal_authenticator_organization_block_label header_block_label">
						<xsl:value-of select="$secondLevelLabel"/>
					</span>
					
					<xsl:call-template name="organizationLevelContent">
						<xsl:with-param name="organization" select="$organization"/>
						<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
					</xsl:call-template>
					<!-- rekurencja -->
					<xsl:if test="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization">
						<xsl:call-template name="organization">
							<xsl:with-param name="organization" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization"/>
							<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
							<xsl:with-param name="level" select="$level+1"/>
							<xsl:with-param name="knownIdentifiersOnly" select="$knownIdentifiersOnly"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="organizationContent">
		<xsl:param name="organization"/>
		<xsl:param name="typeOfActivityLabel"/>
		<xsl:param name="knownIdentifiersOnly" select="false()"/>
		<xsl:param name="hideNextLevel" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="typeOfJednostkaLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Rodzaj jednostki</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="typeOfPrzedsiebiorstwoLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Rodzaj przedsiębiorstwa</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="typeOfPodmiotLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Type</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Rodzaj podmiotu leczniczego</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.15']">
				<!-- Praktyka zawodowa -->
				<!-- nazwy instytucji -->
				<div class="header_element">
					<xsl:if test="string-length($organization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="string-length($organization/hl7:name) = 0 or $organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name != $organization/hl7:name">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
				</div>
				
				<!-- identyfikatory zbierane ręcznie -->
				<div class="identifiers header_element">
					<!-- id miejsca udzielania świadczeń, tj. id praktyki i id rodzaju działalności rozdzielone myślnikiem -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:id"/>
					</xsl:call-template>
					<!-- wyłącznie REGON jeżeli podano, gdyż id praktyki zawarty jest w id miejsca -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id[@root='2.16.840.1.113883.3.4424.2.2.1']"/>
					</xsl:call-template>
				</div>
				
				<!-- rodzaj działalności -->
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfActivityLabel"/>
				</xsl:call-template>
				
				<!-- adresy i dane kontaktowe -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:telecom"/>
				</xsl:call-template>
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="$organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.18'] and $organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.17']">
				<!-- Komórka organizacyjna w jednostce organizacyjnej -->
				<!-- UWAGA: jeżeli nazwa na dowolnym prócz pierwszego poziomie powtarza się lub nic nie wnosi, nie należy jej podawać w dokumencie -->
				<div class="header_element">
					<xsl:if test="string-length($organization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="string-length($organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="string-length($organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="string-length($organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
				</div>
				
				<!-- identyfikatory zbierane ręcznie -->
				<div class="identifiers header_element">
					<!-- id komórki -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:id"/>
					</xsl:call-template>
					<!-- id jednostki -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id"/>
					</xsl:call-template>
					<!-- id przedsiębiorstwa, tj. REGON 14-znakowy -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id"/>
					</xsl:call-template>
					<!-- id podmiotu leczniczego jest pomijany, zawiera się w id komórki -->
					<!-- <xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id[@root='2.16.840.1.113883.3.4424.2.3.1']"/>
					</xsl:call-template> -->
				</div>
				
				<!-- rodzaj działalności -->
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfActivityLabel"/>
				</xsl:call-template>
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfJednostkaLabel"/>
				</xsl:call-template>
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfPrzedsiebiorstwoLabel"/>
				</xsl:call-template>
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfPodmiotLabel"/>
				</xsl:call-template>
				
				<!-- adresy i dane kontaktowe -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:telecom"/>
				</xsl:call-template>
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="$organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.17'] or ($organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.18'] and $organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.16'])">
				<!-- Komórka organizacyjna bezpośrednio w przedsiębiorstwie lub jednostka organizacyjna w przedsiębiorstwie -->
				<div class="header_element">
					<xsl:if test="string-length($organization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="string-length($organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="string-length($organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
				</div>
				
				<!-- identyfikatory zbierane ręcznie -->
				<div class="identifiers header_element">
					<!-- id komórki lub jednostki -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:id"/>
					</xsl:call-template>
					<!-- id przedsiębiorstwa, tj. REGON 14-znakowy -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id"/>
					</xsl:call-template>
					<!-- id podmiotu leczniczego jest pomijany, zawiera się w id jednostki -->
					<!-- <xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id[@root='2.16.840.1.113883.3.4424.2.3.1']"/>
					</xsl:call-template> -->
				</div>
				
				<!-- rodzaj działalności -->
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfActivityLabel"/>
				</xsl:call-template>
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfPrzedsiebiorstwoLabel"/>
				</xsl:call-template>
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfPodmiotLabel"/>
				</xsl:call-template>
				
				<!-- adresy i dane kontaktowe -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:telecom"/>
				</xsl:call-template>
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="$organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.16']">
				<!-- Przedsiębiorstwo podmiotu leczniczego -->
				<div class="header_element">
					<xsl:if test="$organization/hl7:name and string-length($organization/hl7:name) &gt;= 1">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:name"/>
						</div>
					</xsl:if>
					<xsl:if test="not($organization/hl7:name) or string-length($organization/hl7:name) = 0 or $organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name != $organization/hl7:name">
						<div class="header_value">
							<xsl:value-of select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:name"/>
						</div>
					</xsl:if>
				</div>
				
				<!-- identyfikatory zbierane ręcznie -->
				<div class="identifiers header_element">
					<!-- id podmiotu leczniczego, wyłącznie numer wpisu bez 9-znakowego numeru REGON -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:id[@root='2.16.840.1.113883.3.4424.2.3.1']"/>
					</xsl:call-template>
					<!-- id przedsiębiorstwa, tj. REGON 14-znakowy -->
					<xsl:call-template name="listIdentifiersOID">
						<xsl:with-param name="ids" select="$organization/hl7:id"/>
					</xsl:call-template>
				</div>
				
				<!-- rodzaj działalności -->
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfActivityLabel"/>
				</xsl:call-template>
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfPodmiotLabel"/>
				</xsl:call-template>
				
				<!-- adresy i dane kontaktowe -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:telecom"/>
				</xsl:call-template>
				
				<!-- adresy i dane kontaktowe -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization/hl7:telecom"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="$organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.14']">
				<!-- Podmiot leczniczy -->
				<xsl:call-template name="organizationLevelContent">
					<xsl:with-param name="organization" select="$organization"/>
					<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="$organization/hl7:templateId[@root='2.16.840.1.113883.3.4424.13.10.2.31']">
				<!-- Apteka -->
				<xsl:call-template name="organizationLevelContent">
					<xsl:with-param name="organization" select="$organization"/>
					<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:call-template name="organizationLevelContent">
					<xsl:with-param name="organization" select="$organization"/>
					<xsl:with-param name="typeOfActivityLabel" select="$typeOfActivityLabel"/>
				</xsl:call-template>
				<!-- rekurencja rozpoczynana z pierwszego poziomu dla szablonu ogólnego organizacji -->
				<xsl:if test="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization">
					<xsl:call-template name="organization">
						<xsl:with-param name="organization" select="$organization/hl7:asOrganizationPartOf/hl7:wholeOrganization"/>
						<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
						<xsl:with-param name="level" select="2"/>
						<xsl:with-param name="knownIdentifiersOnly" select="$knownIdentifiersOnly"/>
						<xsl:with-param name="hideNextLevel" select="$hideNextLevel"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="organizationLevelContent">
		<xsl:param name="organization"/>
		<xsl:param name="typeOfActivityLabel"/>
		
		<xsl:choose>
			<xsl:when test="$organization/@nullFlavor">
				<xsl:call-template name="translateNullFlavor">
					<xsl:with-param name="nullableElement" select="$organization"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- nazwy instytucji -->
				<xsl:call-template name="organizationName">
					<xsl:with-param name="name" select="$organization/hl7:name"/>
				</xsl:call-template>
				
				<!-- identyfikatory -->
				<xsl:call-template name="identifiersInDiv">
					<xsl:with-param name="ids" select="$organization/hl7:id"/>
					<xsl:with-param name="knownOnly" select="false()"/>
				</xsl:call-template>
				
				<!-- rodzaj działalności -->
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$organization/hl7:standardIndustryClassCode"/>
					<xsl:with-param name="label" select="$typeOfActivityLabel"/>
				</xsl:call-template>
				
				<!-- adresy i dane kontaktowe -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$organization/hl7:addr"/>
					<xsl:with-param name="telecom" select="$organization/hl7:telecom"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- nazwy organizacji z obsługą nullFlavor -->
	<xsl:template name="organizationName">
		<xsl:param name="name"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="nameLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Name</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Nazwa</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$name">
			<div class="header_element">
				<!-- może istnieć wiele nazw instytucji, przy czym wyświetlana jest wyłącznie treść elementu name -->
				<xsl:for-each select="$name">
					<xsl:choose>
						<xsl:when test="./@nullFlavor">
							<span>
								<xsl:value-of select="$nameLabel"/>
							</span>
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="."/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="string-length(.) &gt;= 1">
							<div class="header_value">
								<xsl:value-of select="."/>
							</div>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- placówka w ramach danych wizyty -->
	<xsl:template name="location">
		<xsl:param name="location"/>
		<!-- brak obsługi nullFlavor, element nie jest wymagany -->
		<xsl:if test="$location">
			<xsl:variable name="facility" select="$location/hl7:healthCareFacility"/>
			
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="locationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Location</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Miejsce</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="typeLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Type</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Rodzaj</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Instytucja realizująca</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- place wg templateId 2.16.840.1.113883.3.4424.13.10.2.75 z uwzględnieniem identyfikatora i rodzaju -->
			<xsl:if test="$facility/hl7:id or string-length($facility/hl7:location/hl7:name) &gt;= 1 or $facility/hl7:location/hl7:addr or $facility/hl7:code">
				<span class="header_label">
					<xsl:value-of select="$locationLabel"/>
				</span>
				
				<!-- nazwa miejsca -->
				<xsl:if test="string-length($facility/hl7:location/hl7:name) &gt;= 1">
					<div class="header_element">
						<div class="header_value">
							<xsl:value-of select="$facility/hl7:location/hl7:name"/>
						</div>
					</div>
				</xsl:if>
				
				<xsl:call-template name="identifiersInDiv">
					<xsl:with-param name="ids" select="$facility/hl7:id"/>
				</xsl:call-template>
				
				<!-- rodzaj lub specjalność miejsca "ServiceDeliveryLocationRoleType"
			 		 value set nie został przetłumaczony na język polski, warto zastosować inny słownik -->
				<xsl:call-template name="codeInDiv">
					<xsl:with-param name="code" select="$facility/hl7:code"/>
					<xsl:with-param name="label" select="$typeLabel"/>
				</xsl:call-template>
				
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$facility/hl7:location/hl7:addr"/>
				</xsl:call-template>
			</xsl:if>
			
			<!-- placówka realizująca -->
			<xsl:call-template name="organization">
				<xsl:with-param name="organization" select="$facility/hl7:serviceProviderOrganization"/>
				<xsl:with-param name="showAddressAndContactInfo" select="true()"/>
				<xsl:with-param name="level" select="1"/>
				<xsl:with-param name="level1BlockLabel" select="$organizationLabel"/>
				<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- miejsce urodzenia: dopuszczalna nazwa, city i country, stąd brak wywołania template'u place -->
	<xsl:template name="birthPlace">
		<xsl:param name="birthPlace"/>
		
		<xsl:variable name="birthPlaceName" select="$birthPlace/hl7:place/hl7:name"/>
		<xsl:variable name="birthPlaceCity" select="$birthPlace/hl7:place/hl7:addr/hl7:city"/>
		<xsl:variable name="birthPlaceCountry" select="$birthPlace/hl7:place/hl7:addr/hl7:country"/>
		
		<xsl:if test="string-length($birthPlaceName) &gt;= 1 or string-length($birthPlaceCity) &gt;= 1 or string-length($birthPlaceCountry) &gt;= 1">
			
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="birthPlaceLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Place of birth</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Miejsce urodzenia</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="noInformationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>(no information)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>(nie podano)</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<div class="header_element">
				<span class="header_label">
					<xsl:value-of select="$birthPlaceLabel"/>
				</span>
				
				<div class="header_inline_value header_value">
					<xsl:choose>
						<!-- nullFlavor dla ewentualnych template'ów wymagających miejsca urodzenia podczas gdy informacja ta nie jest dostępna -->
						<xsl:when test="$birthPlace/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$birthPlace"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$birthPlace/hl7:place/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$birthPlace/hl7:place"/>
							</xsl:call-template>
						</xsl:when>
						
						<!-- podano nazwę miejsca -->
						<xsl:when test="string-length($birthPlaceName) &gt;= 1 and not($birthPlaceName/@nullFlavor)">
							<xsl:value-of select="$birthPlaceName"/>
							<xsl:if test="string-length($birthPlaceCity) &gt;= 1 and not($birthPlaceCity/@nullFlavor) and not($birthPlace/hl7:place/hl7:addr/@nullFlavor)">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="$birthPlaceCity"/>
							</xsl:if>
							<xsl:if test="string-length($birthPlaceCountry) &gt;= 1 and not($birthPlaceCountry/@nullFlavor) and not($birthPlace/hl7:place/hl7:addr/@nullFlavor) and not(translate($birthPlaceCountry, $LOWERCASE_LETTERS, $UPPERCASE_LETTERS) = 'POLSKA')">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="$birthPlaceCountry"/>
							</xsl:if>
						</xsl:when>
						
						<!-- nie podano nazwy miejsca, podano miejscowość urodzenia -->
						<xsl:when test="string-length($birthPlaceCity) &gt;= 1 and not($birthPlaceCity/@nullFlavor) and not($birthPlace/hl7:place/hl7:addr/@nullFlavor)">
							<xsl:value-of select="$birthPlaceCity"/>
							<xsl:if test="string-length($birthPlaceCountry) &gt;= 1 and not($birthPlaceCountry/@nullFlavor) and not(translate($birthPlaceCountry, $LOWERCASE_LETTERS, $UPPERCASE_LETTERS) = 'POLSKA')">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="$birthPlaceCountry"/>
							</xsl:if>
						</xsl:when>
						
						<!-- nie podano nazwy miejsca ani miejscowości, podano wyłącznie nazwę kraju - wyświetla się także "Polska" -->
						<xsl:when test="string-length($birthPlaceCountry) &gt;= 1 and not($birthPlaceCountry/@nullFlavor) and not($birthPlace/hl7:place/hl7:addr/@nullFlavor)">
							<xsl:value-of select="$birthPlaceCountry"/>
						</xsl:when>
						
						<!-- uproszczona obsługa nullFlavor -->
						<xsl:otherwise>
							<xsl:value-of select="$noInformationLabel"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- osoba templateId 2.16.840.1.113883.3.4424.13.10.2.1 bez specjalizacji -->
	<xsl:template name="person">
		<xsl:param name="person"/>
		
		<xsl:if test="$person">
			<xsl:choose>
				<xsl:when test="$person/@nullFlavor">
					<xsl:call-template name="translateNullFlavor">
						<xsl:with-param name="nullableElement" select="$person"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- imiona i nazwiska przypisanej osoby, brak innych istotnych danych w tym elemencie -->
					<xsl:if test="$person/hl7:name">
						<xsl:call-template name="personName">
							<xsl:with-param name="name" select="$person/hl7:name"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- nazwa urządzenia i oprogramowania oraz kod -->
	<xsl:template name="device">
		<xsl:param name="device"/>
		
		<xsl:if test="$device">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="deviceLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Authoring device</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Urządzenie</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="softwareLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Software</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Oprogramowanie</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- nazwę urządzenia wyświetlam także gdy nie podano, zajmując pierwszy wiersz nagłówkiem "Urządzenie" -->
			<div class="header_element">
				<span class="header_label">
					<xsl:value-of select="$deviceLabel"/>
				</span>
				<div class="header_inline_value header_value">
					<xsl:choose>
						<xsl:when test="$device/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$device"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$device/hl7:manufacturerModelName"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
			
			<!-- nazwę oprogramowania wyświetlam wyłącznie gdy istnieje -->
			<xsl:if test="$device/hl7:softwareName and string-length($device/hl7:softwareName) &gt;= 1">
				<div class="header_element">
					<span class="header_label">
						<xsl:value-of select="$softwareLabel"/>
					</span>
					<div class="header_inline_value header_value">
						<xsl:value-of select="$device/hl7:softwareName"/>
					</div>
				</div>
			</xsl:if>
			
			<!-- opcjonalny code z kodem nieokreślonego z góry słownika, dotyczy informacji o urządzeniu -->
			<xsl:call-template name="codeInDiv">
				<xsl:with-param name="code" select="$device/hl7:code"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- specjalizacja osoby, od PIK 1.2.1 zgodnie z IHE PRE -->
	<xsl:template name="personQualifiedEntity">
		<xsl:param name="qualificationCode"/>
		
		<!-- specjalizacja osoby, do wyświetlenia wymaga się displayName mimo że jest to element wymagany wyłącznie dla specjalizacji mnogich -->
		<xsl:if test="$qualificationCode/@displayName and string-length($qualificationCode/@displayName) &gt;= 1 and starts-with($qualificationCode/@codeSystem, '2.16.840.1.113883.3.4424.11.3.3')">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="specialtyLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Specialty</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Specializacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="specialtiesLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Specialties</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Specjalizacje</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="legal_authenticator_qualification_element header_element">
				<span class="header_label">
					<xsl:choose>
						<!-- pojedyncza specjalizacja -->
						<xsl:when test="$qualificationCode/@codeSystem = '2.16.840.1.113883.3.4424.11.3.3'">
							<xsl:value-of select="$specialtyLabel"/>
						</xsl:when>
						<!-- zapis specjalizacji mnogiej z OID 2.16.840.1.113883.3.4424.11.3.3.1 -->
						<xsl:otherwise>
							<xsl:value-of select="$specialtiesLabel"/>
						</xsl:otherwise>
					</xsl:choose>
				</span>
				<div class="header_inline_value header_value">
					<xsl:value-of select="$qualificationCode/@displayName"/>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- imiona i nazwiska osoby z prefiksem i suffiksem
		 templateId 2.16.840.1.113883.3.4424.13.10.7.2 -->
	<xsl:template name="personName">
		<xsl:param name="name"/>
		
		<xsl:if test="$name">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="unknownGivenNameLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>(unknown given name)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>(imienia nie podano)</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="unknownFamilyNameLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>(unknown family name)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>(nazwiska nie podano)</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="header_element">
				<!-- może istnieć wiele "nazw" osób, przy czym jedno imię i jedno nazwisko w polskim IG jest wymagane -->
				<xsl:for-each select="$name">
					<xsl:choose>
						<xsl:when test="./@nullFlavor">
							<span class="person_name_value header_value"><xsl:text>Imię i nazwisko</xsl:text></span>
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="."/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="./hl7:family">
							<div class="person_name_value header_value">
								<xsl:if test="string-length(./hl7:prefix) &gt;= 1">
									<xsl:value-of select="./hl7:prefix"/>
									<xsl:text> </xsl:text>
								</xsl:if>
								<xsl:for-each select="./hl7:given">
									<xsl:if test="./@nullFlavor">
										<xsl:value-of select="$unknownGivenNameLabel"/>
										<xsl:text> </xsl:text>
									</xsl:if>
									<xsl:if test="not(./@nullFlavor)">
										<xsl:value-of select="."/>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="./hl7:family">
									<xsl:if test="./@nullFlavor">
										<xsl:text> </xsl:text>
										<xsl:value-of select="$unknownGivenNameLabel"/>
									</xsl:if>
									<xsl:if test="not(./@nullFlavor)">
										<xsl:value-of select="."/>
										<xsl:if test="position()!=last()">
											<xsl:text> </xsl:text>
										</xsl:if>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="string-length(./hl7:suffix) &gt;= 1">
									<xsl:text> </xsl:text>
									<xsl:value-of select="./hl7:suffix"/>
								</xsl:if>
							</div>
						</xsl:when>
						<!-- na potrzeby wyświetlenia danych dokumentu zgodnego z ogólnym HL7 CDA wprowadzono poniższą opcję, gdy imię i nazwisko nie są rozdzielone na niezależne elementy -->
						<xsl:when test="string-length(.) &gt;= 1">
							<div class="person_name_value header_value">
								<xsl:value-of select="."/>
							</div>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- płeć -->
	<xsl:template name="translateGenderCode">
		<xsl:param name="genderCode"/>
		<xsl:if test="$genderCode">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:variable name="sexLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Gender</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Płeć</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_element">
				<span class="header_label">
					<xsl:value-of select="$sexLabel"/>
				</span>
				<div class="header_inline_value header_value">
					<xsl:choose>
						<xsl:when test="$genderCode/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$genderCode"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$genderCode/@code = 'F' and $lang = $secondLanguage">
							<xsl:text>female</xsl:text>
						</xsl:when>
						<xsl:when test="$genderCode/@code = 'F'">
							<xsl:text>kobieta</xsl:text>
						</xsl:when>
						<xsl:when test="$genderCode/@code = 'M' and $lang = $secondLanguage">
							<xsl:text>male</xsl:text>
						</xsl:when>
						<xsl:when test="$genderCode/@code = 'M'">
							<xsl:text>mężczyzna</xsl:text>
						</xsl:when>
						<xsl:when test="$genderCode/@code = 'UN' and $lang = $secondLanguage">
							<xsl:text>undifferentiated</xsl:text>
						</xsl:when>
						<xsl:when test="$genderCode/@code = 'UN'">
							<xsl:text>nieokreślona</xsl:text>
						</xsl:when>
						<xsl:when test="$lang = $secondLanguage">
							<xsl:text>- code unknown: </xsl:text>
							<xsl:value-of select="$genderCode/@code"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- kod nieznany, wyświetlany bezpośrednio -->
							<xsl:text>- kod płci nieznany: </xsl:text>
							<xsl:value-of select="$genderCode/@code"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- pełna, sformatowana lista identyfikatorów typu II, przy czym przed pierwszym umieścić można prefiks -->
	<xsl:template name="identifiersInDiv">
		<xsl:param name="ids"/>
		<xsl:param name="knownOnly" select="false()"/>
		<xsl:param name="prefix" select="false()"/>
		
		<xsl:variable name="displayableIds" select="$ids[not(@displayable='false')]"/>
		<xsl:variable name="count" select="count($displayableIds)"/>
		
		<xsl:if test="$count &gt; 0">
			<div class="identifiers header_element">
				<xsl:call-template name="listIdentifiersOID">
					<xsl:with-param name="ids" select="$displayableIds"/>
					<xsl:with-param name="knownOnly" select="$knownOnly"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!--  lista identyfikatorów OID -->
	<xsl:template name="listIdentifiersOID">
		<xsl:param name="ids"/>
		<xsl:param name="knownOnly" select="true()"/>
		<xsl:param name="prefix" select="false()"/>
		
		<xsl:for-each select="$ids">
			<div class="identifier header_value">
				<xsl:if test="$prefix and position() = 1">
					<span>
						<xsl:value-of select="$prefix"/>
						<xsl:text> </xsl:text>
					</span>
				</xsl:if>
				<xsl:call-template name="identifierOID">
					<xsl:with-param name="id" select="."/>
					<xsl:with-param name="knownOnly" select="$knownOnly"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<!--  identyfikator OID -->
	<xsl:template name="identifierOID">
		<xsl:param name="id"/>
		<xsl:param name="knownOnly"/>
		
		<xsl:choose>
			<xsl:when test="not($id) or $id/@nullFlavor">
				<span class="null_flavor_id oid">
					<xsl:text>ID </xsl:text>
				</span>
				<xsl:call-template name="translateNullFlavor">
					<xsl:with-param name="nullableElement" select="$id"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="rootName">
					<xsl:call-template name="translateOID">
						<xsl:with-param name="oid" select="$id/@root"/>
						<xsl:with-param name="ext" select="$id/@extension"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$knownOnly">
						<!-- identyfikator nie jest wyświetlany gdy nie jest znany, a knownOnly = true -->
						<xsl:if test="string-length($rootName) &gt;= 1">
							<span class="oid">
								<xsl:value-of select="$rootName"/>
								<xsl:if test="string-length($id/@extension) &gt;= 1">
									<xsl:text> </xsl:text>
									<xsl:value-of select="$id/@extension"/>
								</xsl:if>
							</span>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<span class="oid">
							<xsl:choose>
								<xsl:when test="string-length($rootName) &gt;= 1">
									<xsl:value-of select="$rootName"/>
								</xsl:when>
								<xsl:otherwise>
									<span class="not_known_id_prefix">
										<xsl:text>ID </xsl:text>
									</span>
									<xsl:value-of select="$id/@root"/>
									<xsl:if test="string-length($id/@assigningAuthorityName) &gt;= 1">
										<xsl:text> (</xsl:text>
										<xsl:value-of select="$id/@assigningAuthorityName"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="string-length($id/@extension) &gt;= 1">
								<xsl:text> </xsl:text>
								<xsl:value-of select="$id/@extension"/>
							</xsl:if>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- code typu CV i prostsze -->
	<!-- Jeśli zaistnieje potrzeba wyświetlania bardziej rozbudowanych typów kodów (CE, CD), należy rozwinąć ten template o translation i qualifier -->
	<xsl:template name="codeInDiv">
		<xsl:param name="code"/>
		<xsl:param name="label" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="codeLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>code </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>kod </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="codeSystemLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> code system: </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> wg słownika </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="versionLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> version </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> wersja </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$code">
			<div class="header_element">
				<xsl:if test="$label and string-length($label) &gt;= 1">
					<span class="header_label">
						<xsl:value-of select="$label"/>
					</span>
				</xsl:if>
				<div class="header_inline_value header_value">
					<xsl:choose>
						<!-- nullFlavor skutkuje pominięciem wszystkich danych elementu code, nie tylko samego kodu -->
						<xsl:when test="$code/@nullFlavor">
							<xsl:call-template name="translateNullFlavor">
								<xsl:with-param name="nullableElement" select="$code"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- definicja displayName: "A name or title for the code, under which the sending system shows the code value to its users." -->
							<!-- Przykład wyświetlenia przy dostępnym displayName: Procedura RTG klatki piersiowej (87.440) słownik ICD-9-PL wersja 1.0 -->
							<!-- Przykład wyświetlenia przy nieznanym displayName: Procedura 87.440 słownik 2.16.840.1.113883.3.4424.11.2.6 -->
							<xsl:if test="string-length($code/@displayName) &gt;= 1">
								<xsl:value-of select="$code/@displayName"/>
								<!-- ponieważ displayName nie może być traktowane w systemie odbiorcy dokumentu jako stuprocentowo pewne,
						 			 zawsze wyświetlany jest także kod -->
								<xsl:if test="$code/@code">
									<xsl:text> (</xsl:text>
									<xsl:value-of select="$codeLabel"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$code/@code">
								<xsl:value-of select="$code/@code"/>
							</xsl:if>
							<xsl:if test="string-length($code/@displayName) &gt;= 1 and $code/@code">
								<xsl:text>)</xsl:text>
							</xsl:if>
							<xsl:if test="string-length($code/@displayName) &gt;= 1 or $code/@code">
								<xsl:text> </xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not($code/@nullFlavor) and ($code/@codeSystemName or $code/@codeSystem)">
						<xsl:value-of select="$codeSystemLabel"/>
						<xsl:choose>
							<xsl:when test="string-length($code/@codeSystemName) &gt;= 1">
								<xsl:value-of select="$code/@codeSystemName"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="translateCodeSystemOID">
									<xsl:with-param name="oid" select="$code/@codeSystem"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="string-length($code/@codeSystemVersion) &gt;= 1">
							<xsl:value-of select="$versionLabel"/>
							<xsl:value-of select="$code/@codeSystemVersion"/>
						</xsl:if>
					</xsl:if>
				</div>
				
				<!-- słowne, często ręczne doprecyzowanie kodu -->
				<xsl:if test="not($code/@nullFlavor) and string-length($code/hl7:originalText) &gt;= 1">
					<div class="header_value">
						<xsl:value-of select="$code/hl7:originalText"/>
					</div>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- dane adresowe i kontaktowe -->
	<xsl:template name="addressTelecomInDivs">
		<xsl:param name="addr" select="false()"/>
		<xsl:param name="telecom" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="addressLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Contact</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Dane adresowe</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$addr">
	 		<xsl:variable name="countAddr" select="count($addr)"/>
			<xsl:if test="$countAddr &gt; 0">
				<div class="header_element">
					<xsl:choose>
						<xsl:when test="$countAddr &gt; 1">
							<span class="header_label">
								<xsl:value-of select="$addressLabel"/>
							</span>
							<div class="header_value">
								<xsl:call-template name="addresses">
									<xsl:with-param name="addresses" select="$addr"/>
								</xsl:call-template>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<span class="header_label">
								<xsl:call-template name="translateAddressUseCode">
									<xsl:with-param name="useCode" select="$addr/@use"/>
								</xsl:call-template>
							</span>
							
							<!-- adres w jednej linii wyłącznie gdy istnieją podstawowe elementy oraz jest to jeden adres -->
							<xsl:variable name="inline" select="not($addr/hl7:streetAddressLine or ($addr/hl7:postalCode/@postCity and $addr/hl7:postalCode/@postCity != $addr/hl7:city) or ($addr/hl7:country and translate($addr/hl7:country, $LOWERCASE_LETTERS, $UPPERCASE_LETTERS) != 'POLSKA'))"/>
							
							<xsl:element name="div">
								<xsl:choose>
									<xsl:when test="$inline">
										<xsl:attribute name="class">header_inline_value header_value</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">header_value</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:call-template name="address">
									<xsl:with-param name="addr" select="$addr"/>
									<xsl:with-param name="inline" select="$inline"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$telecom">
			<xsl:variable name="countTelecom" select="count($telecom)"/>
			
			<xsl:variable name="contactsLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Contact details</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Dane kontaktowe</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="contactLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Contact details </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Kontakt </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:if test="$countTelecom &gt; 0">
				<div class="header_element">
					<xsl:choose>
						<xsl:when test="$countTelecom &gt; 1">
							<span class="header_label">
								<xsl:value-of select="$contactsLabel"/>
							</span>
							<div class="header_value">
								<xsl:call-template name="telecoms">
									<xsl:with-param name="telecoms" select="$telecom"/>
								</xsl:call-template>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<span class="header_label">
								<xsl:value-of select="$contactLabel"/>
							</span>
							<xsl:call-template name="telecom">
								<xsl:with-param name="tele" select="$telecom"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- adresy -->
	<xsl:template name="addresses">
		<xsl:param name="addresses"/>
		
		<xsl:for-each select="$addresses">
			<div class="address_element">
				<span class="address_label">
					<xsl:call-template name="translateAddressUseCode">
						<xsl:with-param name="useCode" select="./@use"/>
					</xsl:call-template>
				</span>
				<div class="address_value header_value">
					<xsl:call-template name="address">
						<xsl:with-param name="addr" select="."/>
						<xsl:with-param name="inline" select="false()"/>
					</xsl:call-template>
				</div>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<!-- adres templateId 2.16.840.1.113883.3.4424.13.10.7.1 -->
	<xsl:template name="address">
		<xsl:param name="addr"/>
		<xsl:param name="inline" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="addressUnitLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> / </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> lok. </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="postOfficeLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Post office</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Poczta</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<!-- wyświetlenie informacji o braku wyłącznie gdy podano nullFlavor na poziomie całego adresu -->
			<xsl:when test="$addr/@nullFlavor">
				<xsl:call-template name="translateNullFlavor">
					<xsl:with-param name="nullableElement" select="$addr"/>
				</xsl:call-template>
			</xsl:when>
			<!-- adres prosty, jednoliniowy, jeżeli zawiera wyłącznie ulicę, numery, kod pocztowy i miejscowość
				 wprowadzony by zaoszczędzić miejsce w dokumencie -->
			<xsl:when test="$inline">
				<!-- ulica, numer domu, numer mieszkania, kod pocztowy, miejscowość -->
				<xsl:value-of select="$addr/hl7:streetName"/>
				<xsl:if test="string-length($addr/hl7:houseNumber) &gt;= 1">
					<xsl:text> </xsl:text>
					<xsl:value-of select="$addr/hl7:houseNumber"/>
					<xsl:if test="string-length($addr/hl7:unitID) &gt;= 1">
						<xsl:value-of select="$addressUnitLabel"/>
						<xsl:value-of select="$addr/hl7:unitID"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="string-length($addr/hl7:postalCode) &gt;= 1">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$addr/hl7:postalCode"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$addr/hl7:city"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- standardowa obsługa adresu, który nie mieści się w jednej linii
					 obsługiwane są wyłącznie podstawowe pola zdefiniowane w PL IG (bez unitType, 
					 w którym za granicą wyróżnia się typ lokalu, np. appartment) 
					 oraz pole streetAddressLine wspierające zapis adresów zagranicznych,
					 nie są wyświetlanie adresy wprowadzane w postaci nieanalitycznej, tzw. plain-text -->
				<xsl:if test="$addr/hl7:streetAddressLine or $addr/hl7:streetName or $addr/hl7:city or $addr/hl7:country">
					
					<!-- linie dla adresu zagranicznego, przy czym dopuszczalne jest stosowanie także innych elementów -->
					<xsl:for-each select="$addr/hl7:streetAddressLine">
						<div class="address_line address_street_address_line">
							<xsl:value-of select="."/>
						</div>
					</xsl:for-each>
					
					<!-- układ adresu polskiego, stosowanego także dla adresów zagranicznych z podanym city -->
					<xsl:if test="string-length($addr/hl7:city) &gt;= 1">
						<xsl:choose>
							<xsl:when test="string-length($addr/hl7:streetName) &gt;= 1">
								<!-- ulica, numer domu, numer mieszkania -->
								<div class="address_line address_street_line">
									<xsl:value-of select="$addr/hl7:streetName"/>
									<xsl:if test="string-length($addr/hl7:houseNumber) &gt;= 1">
										<xsl:text> </xsl:text>
										<xsl:value-of select="$addr/hl7:houseNumber"/>
										<xsl:if test="string-length($addr/hl7:unitID) &gt;= 1">
											<xsl:value-of select="$addressUnitLabel"/>
											<xsl:value-of select="$addr/hl7:unitID"/>
										</xsl:if>
									</xsl:if>
								</div>
								<xsl:choose>
									<xsl:when test="not($addr/hl7:postalCode/@postCity) or $addr/hl7:postalCode/@postCity = $addr/hl7:city">
										<!-- adres z ulicą i miejscowością posiadającą pocztę
											ul. Stroma 120
											41-400 Równe -->
										<div class="address_line address_city_line">
											<xsl:if test="string-length($addr/hl7:postalCode) &gt;= 1">
												<xsl:value-of select="$addr/hl7:postalCode"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:value-of select="$addr/hl7:city"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<!-- adres z ulicą, miejscowością i inną pocztą
											ul. Stroma 120
											Wygoniska
											Poczta: 41-400 Równe -->
										<div class="address_line address_city_line">
											<xsl:value-of select="$addr/hl7:city"/>
										</div>
										<div class="address_line address_postCity_line">
											<xsl:value-of select="$postOfficeLabel"/>
											<xsl:text>: </xsl:text>
											<xsl:if test="string-length($addr/hl7:postalCode) &gt;= 1">
												<xsl:value-of select="$addr/hl7:postalCode"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:value-of select="$addr/hl7:postalCode/@postCity"/>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- ulica nie istnieje w adresie -->
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="not($addr/hl7:postalCode/@postCity) or $addr/hl7:postalCode/@postCity = $addr/hl7:city">
										<!-- adres bez ulicy, z miejscowością posiadającą pocztę
											41-400 Równe 120 -->
										<div class="address_line address_city_line">
											<xsl:if test="string-length($addr/hl7:postalCode) &gt;= 1">
												<xsl:value-of select="$addr/hl7:postalCode"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:value-of select="$addr/hl7:city"/>
											<xsl:if test="string-length($addr/hl7:houseNumber) &gt;= 1">
												<xsl:text> </xsl:text>
												<xsl:value-of select="$addr/hl7:houseNumber"/>
												<xsl:if test="string-length($addr/hl7:unitID) &gt;= 1">
													<xsl:value-of select="$addressUnitLabel"/>
													<xsl:value-of select="$addr/hl7:unitID"/>
												</xsl:if>
											</xsl:if>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<!-- adres bez ulicy, z miejscowością i inną pocztą
											Wygoniska 120
											41-400 Równe -->
										<div class="address_line address_city_line">
											<xsl:value-of select="$addr/hl7:city"/>
											<xsl:if test="string-length($addr/hl7:houseNumber) &gt;= 1">
												<xsl:text> </xsl:text>
												<xsl:value-of select="$addr/hl7:houseNumber"/>
												<xsl:if test="string-length($addr/hl7:unitID) &gt;= 1">
													<xsl:value-of select="$addressUnitLabel"/>
													<xsl:value-of select="$addr/hl7:unitID"/>
												</xsl:if>
											</xsl:if>
										</div>
										<div class="address_line address_postCity_line">
											<xsl:value-of select="$postOfficeLabel"/>
											<xsl:text>: </xsl:text>
											<xsl:if test="string-length($addr/hl7:postalCode) &gt;= 1">
												<xsl:value-of select="$addr/hl7:postalCode"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:value-of select="$addr/hl7:postalCode/@postCity"/>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:if>
					<!-- kod teryt hl7:censusTract nie jest wyświetlany, powinien być obsługiwany elektronicznie -->
					
					<!-- kraj, region/stan nie jest wyświetlany -->
					<xsl:if test="string-length($addr/hl7:country) &gt;= 1">
						<div class="address_line address_country_line">
							<xsl:value-of select="$addr/hl7:country"/>
						</div>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- dane kontaktowe -->
	<xsl:template name="telecoms">
		<xsl:param name="telecoms"/>
		
		<xsl:for-each select="$telecoms">
			<div class="telecom">
				<xsl:call-template name="telecom">
					<xsl:with-param name="tele" select="."/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
	</xsl:template>	

	<!-- linia danych kontaktowych -->
	<xsl:template name="telecom">
		<xsl:param name="tele"/>
		
		<xsl:choose>
			<!-- wyświetlenie informacji o braku wyłącznie gdy podano nullFlavor -->
			<xsl:when test="$tele/@nullFlavor">
				<xsl:call-template name="translateNullFlavor">
					<xsl:with-param name="nullableElement" select="$tele"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- format <telecom use="PUB" value="tel: 22 2345 123"/> -->
				<xsl:variable name="address" select="substring-after($tele/@value, ':')"/>
				<xsl:variable name="protocol" select="substring-before($tele/@value, ':')"/>
				
				<xsl:choose>
					<xsl:when test="$address and $protocol">
						<xsl:call-template name="translateTelecomProtocolCode">
							<xsl:with-param name="protocolCode" select="$protocol"/>
						</xsl:call-template>
						
						<xsl:value-of select="$address"/>
						
						<xsl:if test="$tele/@use">
							<xsl:text> (</xsl:text>
							<xsl:call-template name="translateTelecomUseCode">
								<xsl:with-param name="useCode" select="$tele/@use"/>
							</xsl:call-template>
							<xsl:text>)</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<!-- dane w niepoprawnym formacie, są jednak wyświetlane -->
						<xsl:value-of select="$tele"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ++++++++++++++ obsługa dat ++++++++++++++++ -->
	
	<!-- ilość dni w miesiącu -->
	<xsl:template name="daysInMonth">
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		
		<xsl:choose>
			<xsl:when test="$month = 1 or $month = 3 or $month = 5 or $month = 7 or $month = 8 or $month = 10 or $month = 12">
				<xsl:value-of select="number(31)"/>
			</xsl:when>
			<xsl:when test="$month = 4 or $month = 6 or $month = 9 or $month = 11">
				<xsl:value-of select="number(30)"/>
			</xsl:when>
			<xsl:when test="$month = 2 and $year mod 4 = 0 and ($year mod 100 != 0 or $year mod 400 = 0)">
				<xsl:value-of select="number(29)"/>
			</xsl:when>
			<xsl:when test="$month = 2">
				<xsl:value-of select="number(28)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(0)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- data i czas jako @value lub hl7:high/@value i hl7:low/@value -->
	<!-- obsługa ograniczona do danych przeznaczonych do wizualizacji, brak wyświetlania szeregu atrybutów TS i IVL TS -->
	<xsl:template name="dateTimeInDiv">
		<xsl:param name="date"/>
		<xsl:param name="label"/>
		<xsl:param name="divClass"/>
		<xsl:param name="calculateAge" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="ageLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Age</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Wiek w dniu wystawienia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fromLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>from </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>od </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="toLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>to </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>do </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="noInformationLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>(no information)</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>(nie podano)</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$date">
			<div class="{$divClass}">
				<xsl:if test="$label">
					<span class="header_label">
						<xsl:value-of select="$label"/>
					</span>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$date/@nullFlavor">
						<xsl:call-template name="translateNullFlavor">
							<xsl:with-param name="nullableElement" select="$date"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$date/@value">
						<div class="header_inline_value header_value">
							<xsl:call-template name="formatDateTime">
								<xsl:with-param name="date" select="$date/@value"/>
							</xsl:call-template>
						</div>
						<xsl:if test="$calculateAge">
							<div class="age_element header_element">
								<span class="header_label">
									<xsl:value-of select="$ageLabel"/>
								</span>
								<div class="header_inline_value header_value">
									<xsl:call-template name="age">
										<xsl:with-param name="startDateValue" select="$date/@value"/>
									</xsl:call-template>
								</div>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$date/hl7:low/@value or $date/hl7:high/@value">
						<xsl:if test="$date/hl7:low/@value">
							<div class="header_inline_value header_value">
								<xsl:value-of select="$fromLabel"/>
								<xsl:call-template name="formatDateTime">
									<xsl:with-param name="date" select="$date/hl7:low/@value"/>
								</xsl:call-template>
							</div>
						</xsl:if>
						<xsl:if test="$date/hl7:high/@value">
							<div class="header_inline_value header_value">
								<xsl:value-of select="$toLabel"/>
								<xsl:call-template name="formatDateTime">
									<xsl:with-param name="date" select="$date/hl7:high/@value"/>
								</xsl:call-template>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$noInformationLabel"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="age">
		<xsl:param name="startDateValue"/>
		<xsl:variable name="docDateValue" select="hl7:effectiveTime/@value"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:if test="string-length($startDateValue) &gt;= 8 and string-length($docDateValue) &gt;= 8">
			<xsl:variable name="year" select="number(substring($startDateValue, 1, 4))"/>
			<xsl:variable name="month" select="number(substring($startDateValue, 5, 2))"/>
			<xsl:variable name="day" select="number(substring($startDateValue, 7, 2))"/>
			<xsl:variable name="currYear" select="number(substring($docDateValue, 1, 4))"/>
			<xsl:variable name="currMonth" select="number(substring($docDateValue, 5, 2))"/>
			<xsl:variable name="currDay" select="number(substring($docDateValue, 7, 2))"/>
			
			<!-- własny kod ze względu na ograniczenia XSLT 1.0 bez dodatkowych bibliotek -->
			<xsl:choose>
				<!-- powyżej 7 lat - w latach -->
				<xsl:when test="$currYear &gt; ($year+7) or ($currYear = ($year+7) and ($currMonth &gt; $month or ($currMonth = $month and $currDay &gt;= $day)))">
					<xsl:choose>
						<xsl:when test="$currMonth &gt; $month or ($currMonth = $month and $currDay &gt;= $day)">
							<xsl:call-template name="formatAge">
								<xsl:with-param name="years" select="$currYear - $year"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="formatAge">
								<xsl:with-param name="years" select="$currYear - $year - 1"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<!-- powyżej 3 lat w latach i połowach -->
				<xsl:when test="$currYear &gt; ($year+3) or ($currYear = ($year+3) and ($currMonth &gt; $month or ($currMonth = $month and $currDay &gt;= $day)))">
					<xsl:choose>
						<xsl:when test="$currMonth &gt; $month or ($currMonth = $month and $currDay &gt;= $day)">
							<xsl:call-template name="formatAge">
								<xsl:with-param name="years" select="$currYear - $year"/>
								<!-- w styczniu sie urodz i przekroczylem o więcej niż 6 mies -->
								<xsl:with-param name="half" select="$currMonth &gt; ($month+6) or ($currMonth = ($month+6) and $currDay &gt;= $day)"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- jest w tym roku, ale jeszcze nie skończył -->
							<xsl:call-template name="formatAge">
								<xsl:with-param name="years" select="$currYear - $year - 1"/>
								<!-- np. urodzony w grudniu i jest o mniej niz 6 miesięcy przed urodzinami -->
								<xsl:with-param name="half" select="($currMonth+6) &gt; $month or (($currMonth+6) = $month and $currDay &gt;= $day)"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<!-- powyżej roku w latach i miesiącach -->
				<xsl:when test="$currYear &gt; ($year+1) or ($currYear = ($year+1) and ($currMonth &gt; $month or ($currMonth = $month and $currDay &gt;= $day)))">
					<xsl:choose>
						<xsl:when test="$currMonth &gt; $month or ($currMonth = $month and $currDay &gt;= $day)">
							<!-- różnica w miesiącach -->
							<xsl:choose>
								<xsl:when test="$currDay &gt;= $day">
									<xsl:call-template name="formatAge">
										<xsl:with-param name="years" select="$currYear - $year"/>
										<xsl:with-param name="months" select="$currMonth - $month"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="formatAge">
										<xsl:with-param name="years" select="$currYear - $year"/>
										<xsl:with-param name="months" select="$currMonth - $month - 1"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- jest w tym roku, ale jeszcze nie skończył -->
							<!-- różnica w miesiącach od 12 -->
							<xsl:choose>
								<xsl:when test="$currDay &gt;= $day">
									<xsl:call-template name="formatAge">
										<xsl:with-param name="years" select="$currYear - $year - 1"/>
										<xsl:with-param name="months" select="12 + $currMonth - $month"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="formatAge">
										<xsl:with-param name="years" select="$currYear - $year - 1"/>
										<xsl:with-param name="months" select="12 + $currMonth - $month - 1"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<!-- powyżej 3 miesięcy - w miesiącach -->
				<xsl:when test="$currYear = ($year+1) and ($currMonth &gt; ($month - 9) or ($currMonth = ($month - 9) and $currDay &gt;= $day))
					or $currYear = $year and ($currMonth &gt; ($month+3) or ($currMonth = ($month+3) and $currDay &gt;= $day))">
					<xsl:choose>
						<xsl:when test="$currYear = $year">
							<xsl:choose>
								<xsl:when test="$currDay &gt;= $day">
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="$currMonth - $month"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="$currMonth - $month - 1"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$currDay &gt;= $day">
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="12 + $currMonth - $month"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="12 + $currMonth - $month - 1"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<!-- powyżej 1 miesiąca - w miesiącach i tygodniach-->
				<xsl:when test="$currYear = ($year+1) and ($currMonth &gt; ($month - 11)) or ($currMonth = ($month - 11) and $currDay &gt;= $day)
					or $currYear = $year and ($currMonth &gt; ($month+1) or ($currMonth = ($month+1) and $currDay &gt;= $day))">
					<xsl:choose>
						<xsl:when test="$currYear = $year">
							<xsl:choose>
								<xsl:when test="$currDay &gt;= $day">
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="$currMonth - $month"/>
										<!-- tygodnie powyżej wyznaczonej liczby miesięcy, czyli różnica między dniami/7 -->
										<xsl:with-param name="weeks" select="($currDay - $day) div 7"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="previousMonthLength">
										<xsl:call-template name="daysInMonth">
											<!-- bezpieczne $currMonth - 1 z uwagi na wcześniejsze warunki -->
											<xsl:with-param name="month" select="$currMonth - 1"/>
											<xsl:with-param name="year" select="$currYear"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="$currMonth - $month - 1"/>
										<!-- tygodnie powyżej wyznaczonej liczby miesięcy, uzupełniam o liczbę dni poprzedniego miesiąca -->
										<xsl:with-param name="weeks" select="($previousMonthLength + $currDay - $day) div 7"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$currDay &gt;= $day">
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="12 + $currMonth - $month"/>
										<!-- tygodnie powyżej wyznaczonej liczby miesięcy -->
										<xsl:with-param name="weeks" select="($currDay - $day) div 7"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="previousMonthLength">
										<xsl:choose>
											<xsl:when test="$currMonth = 1">
												<xsl:call-template name="daysInMonth">
													<xsl:with-param name="month" select="12"/>
													<xsl:with-param name="year" select="$currYear"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="daysInMonth">
													<xsl:with-param name="month" select="$currMonth - 1"/>
													<xsl:with-param name="year" select="$currYear"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="formatAge">
										<xsl:with-param name="months" select="12 + $currMonth - $month - 1"/>
										<!-- tygodnie powyżej wyznaczonej liczby miesięcy -->
										<xsl:with-param name="weeks" select="($previousMonthLength + $currDay - $day) div 7"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<!-- poniżej 1 miesiąca - w tygodniach i dniach -->
				<xsl:otherwise>
					<!-- liczba dni: rok nie jest istotny, miesiąc ten sam lub +1 lub grudzień/styczeń -->
					<xsl:choose>
						<xsl:when test="$currMonth = $month and $currDay = $day">
							<xsl:if test="$lang = $secondLanguage">
								<xsl:text>born in the day the document was issued</xsl:text>
							</xsl:if>
							<xsl:if test="$lang != $secondLanguage">
								<xsl:text>urodzony w dniu wystawienia dokumentu</xsl:text>
							</xsl:if>
						</xsl:when>
						<xsl:when test="$currMonth = $month">
							<xsl:call-template name="formatAge">
								<xsl:with-param name="weeks" select="($currDay - $day) div 7"/>
								<xsl:with-param name="days" select="($currDay - $day) mod 7"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="monthLength">
								<xsl:call-template name="daysInMonth">
									<xsl:with-param name="month" select="$month"/>
									<xsl:with-param name="year" select="$year"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:call-template name="formatAge">
								<xsl:with-param name="weeks" select="($monthLength + $currDay - $day) div 7"/>
								<xsl:with-param name="days" select="($monthLength + $currDay - $day) mod 7"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="formatAge">
		<xsl:param name="years" select="false()"/>
		<xsl:param name="half" select="false()"/>
		<xsl:param name="months" select="false()"/>
		<xsl:param name="weeks" select="false()"/>
		<xsl:param name="days" select="false()"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:if test="$years &gt; 0">
			<xsl:value-of select="$years"/>
			<xsl:variable name="year" select="format-number($years, '000')" />
			<xsl:variable name="tens" select="number(substring($year, 2, 1))"/>
			<xsl:variable name="decs" select="number(substring($year, 3, 1))"/>
			<xsl:choose>
				<xsl:when test="$years = 1 and $lang = $secondLanguage">
					<xsl:text> year</xsl:text>
				</xsl:when>
				<xsl:when test="$years = 1">
					<xsl:text> rok</xsl:text>
				</xsl:when>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> years</xsl:text>
				</xsl:when>
				<xsl:when test="$years &lt; 5">
					<xsl:text> lata</xsl:text>
				</xsl:when>
				<xsl:when test="$years &lt; 22">
					<xsl:text> lat</xsl:text>
				</xsl:when>
				<xsl:when test="$decs &gt;= 2 and $decs &lt;= 4 and $tens != 1">
					<xsl:text> lata</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> lat</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$half and $lang = $secondLanguage">
			<xsl:text> and a half</xsl:text>
		</xsl:if>
		<xsl:if test="$half">
			<xsl:text> i pół</xsl:text>
		</xsl:if>
		<xsl:if test="$months &gt; 0">
			<xsl:if test="$years &gt; 0 and $lang = $secondLanguage">
				<xsl:text> and </xsl:text>
			</xsl:if>
			<xsl:if test="$years &gt; 0 and $lang != $secondLanguage">
				<xsl:text> i </xsl:text>
			</xsl:if>
			<xsl:value-of select="$months"/>
			<xsl:choose>
				<xsl:when test="$months = 1 and $lang = $secondLanguage">
					<xsl:text> month</xsl:text>
				</xsl:when>
				<xsl:when test="$months = 1">
					<xsl:text> miesiąc</xsl:text>
				</xsl:when>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> months</xsl:text>
				</xsl:when>
				<xsl:when test="$months &lt; 5">
					<xsl:text> miesiące</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> miesięcy</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$weeks &gt;= 1">
			<!-- zaokrąglenie w dół w XSLT 1.0 -->
			<xsl:variable name="weeksRounded" select="format-number($weeks - 0.5, '##0')"/>
			<xsl:if test="$months &gt; 0 and $lang = $secondLanguage">
				<xsl:text> and </xsl:text>
			</xsl:if>
			<xsl:if test="$months &gt; 0 and $lang != $secondLanguage">
				<xsl:text> i </xsl:text>
			</xsl:if>
			<xsl:value-of select="$weeksRounded"/>
			<xsl:choose>
				<xsl:when test="$weeks = 1 and $lang = $secondLanguage">
					<xsl:text> week</xsl:text>
				</xsl:when>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> weeks</xsl:text>
				</xsl:when>
				<xsl:when test="$weeksRounded &gt;= 5">
					<xsl:text> tygodni</xsl:text>
				</xsl:when>
				<xsl:when test="$weeksRounded &gt;= 2">
					<xsl:text> tygodnie</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> tydzień</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$days &gt; 0">
			<xsl:if test="$weeks &gt;= 1 and $lang = $secondLanguage">
				<xsl:text> i </xsl:text>
			</xsl:if>
			<xsl:if test="$weeks &gt;= 1 and $lang != $secondLanguage">
				<xsl:text> i </xsl:text>
			</xsl:if>
			<xsl:value-of select="$days"/>
			<xsl:choose>
				<xsl:when test="$days = 1 and $lang = $secondLanguage">
					<xsl:text> day</xsl:text>
				</xsl:when>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text> days</xsl:text>
				</xsl:when>
				<xsl:when test="$days = 1">
					<xsl:text> dzień</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> dni</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- formatowanie daty i czasu -->
	<xsl:template name="formatDateTime">
		<xsl:param name="date"/>
		
		<xsl:param name="year" select="number(substring($date, 1, 4))"/>
		<xsl:param name="monthIndex" select="number(substring($date, 5, 2))"/>
		<xsl:param name="day" select="number(substring($date, 7, 2))"/>
		<xsl:param name="hour" select="substring($date, 9, 2)"/>
		<xsl:param name="minute" select="substring($date, 11, 2)"/>
		<xsl:param name="second" select="substring($date, 13, 2)"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="ageLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Age</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Wiek w dniu wystawienia</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$day">
				<xsl:value-of select="$day"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="translateFullDateMonth">
					<xsl:with-param name="month" select="$monthIndex"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$year"/>
				
				<xsl:if test="$lang != $secondLanguage">
					<xsl:text> r.</xsl:text>
				</xsl:if>
				
				<xsl:if test="$hour">
					<xsl:variable name="displayHour">
						<xsl:choose>
							<xsl:when test="$hour = 00">
								<xsl:value-of select="$hour"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($hour)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="$minute">
							<xsl:if test="$lang != $secondLanguage">
								<xsl:text> godz. </xsl:text>
							</xsl:if>
							<xsl:value-of select="$displayHour"/>
							<xsl:text>:</xsl:text>
							<xsl:value-of select="$minute"/>
							<xsl:if test="$second">
								<xsl:text>:</xsl:text>
								<xsl:value-of select="$second"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$lang != $secondLanguage">
								<xsl:text> godz. ok. </xsl:text>
								<xsl:value-of select="$displayHour"/>
								<xsl:text>.</xsl:text>
							</xsl:if>
							<xsl:if test="$lang = $secondLanguage">
								<xsl:text> at about </xsl:text>
								<xsl:value-of select="$displayHour"/>
								<xsl:text> hour</xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$monthIndex">
					<xsl:call-template name="translateMonth">
						<xsl:with-param name="month" select="$monthIndex"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$year"/>
				<xsl:if test="$lang != $secondLanguage">
					<xsl:text> r.</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++ KODY / ZBIORY WARTOŚCI +++++++++++++++++++++++++++++++++++++++++++++++++++++-->
	
	<!-- kod poufności -->
	<xsl:template name="confidentialityCode">
		<xsl:param name="cCode"/>
		<!-- kod poufności wyświetlany jest wyłącznie dla wyższych poziomów -->
		<xsl:if test="$cCode and $cCode/@code != 'N' and not($cCode/@nullFlavor)">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			<xsl:element name="span">
				<xsl:attribute name="class">confidentiality_code_value</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$cCode/@code = 'N' and $lang = $secondLanguage">
						<xsl:text>Normal confidentiality</xsl:text>
					</xsl:when>
					<xsl:when test="$cCode/@code = 'N'">
						<xsl:text>Poufność normalna</xsl:text>
					</xsl:when>
					<xsl:when test="$cCode/@code = 'R' and $lang = $secondLanguage">
						<xsl:text>RESTRICTED</xsl:text>
					</xsl:when>
					<xsl:when test="$cCode/@code = 'R'">
						<xsl:text>POUFNE</xsl:text>
					</xsl:when>
					<xsl:when test="$cCode/@code = 'V' and $lang = $secondLanguage">
						<xsl:text>VERY RESTRICTED</xsl:text>
					</xsl:when>
					<xsl:when test="$cCode/@code = 'V'">
						<xsl:text>WYSOCE POUFNE</xsl:text>
					</xsl:when>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Confidentiality: </xsl:text>
						<xsl:value-of select="$cCode/@code"/>
					</xsl:when>
					<xsl:otherwise>
						<!--Kod nieznany, wyświetlany bezpośrednio-->
						<xsl:text>Poufność: </xsl:text>
						<xsl:value-of select="$cCode/@code"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- źródło - HL7 V3 Data Types 2.19.2 Telecommunication Use Code -->
	<xsl:template name="translateTelecomUseCode">
		<xsl:param name="useCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<xsl:when test="($useCode='H' or $useCode='HP') and $lang = $secondLanguage">
				<xsl:text>home</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='H' or $useCode='HP'">
				<xsl:text>domowy</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='HV' and $lang = $secondLanguage">
				<xsl:text>vacation home</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='HV'">
				<xsl:text>podczas urlopu</xsl:text>
			</xsl:when>
			
			<xsl:when test="$useCode='WP' and $lang = $secondLanguage">
				<xsl:text>work place</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='WP'">
				<xsl:text>służbowy</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='DIR' and $lang = $secondLanguage">
				<xsl:text>direct</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='DIR'">
				<xsl:text>służbowy bezpośredni</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='PUB' and $lang = $secondLanguage">
				<xsl:text>public</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='PUB'">
				<xsl:text>rejestracja</xsl:text>
			</xsl:when>
			
			<xsl:when test="$useCode='TMP' and $lang = $secondLanguage">
				<xsl:text>temporary address</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='TMP'">
				<xsl:text>tymczasowy</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='EC' and $lang = $secondLanguage">
				<xsl:text>emergency</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='EC'">
				<xsl:text>w nagłych przypadkach</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='MC' and $lang = $secondLanguage">
				<xsl:text>mobile</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='MC'">
				<xsl:text>komórkowy</xsl:text>
			</xsl:when>
			
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>unrecognized: </xsl:text>
				<xsl:value-of select="$useCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>inny: </xsl:text>
				<xsl:value-of select="$useCode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- źródło - HL7 V3 Data Types 2.18.1 Protocol Code -->
	<xsl:template name="translateTelecomProtocolCode">
		<xsl:param name="protocolCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<xsl:when test="$protocolCode='tel' and $lang = $secondLanguage">
				<xsl:text>phone: </xsl:text>
			</xsl:when>
			<xsl:when test="$protocolCode='tel'">
				<xsl:text>tel: </xsl:text>
			</xsl:when>
			<xsl:when test="$protocolCode='fax' and $lang = $secondLanguage">
				<xsl:text>fax: </xsl:text>
			</xsl:when>
			<xsl:when test="$protocolCode='fax'">
				<xsl:text>faks: </xsl:text>
			</xsl:when>
			<xsl:when test="$protocolCode='http'">
				<xsl:text>Internet: </xsl:text>
			</xsl:when>
			<xsl:when test="$protocolCode='mailto'">
				<xsl:text>e-mail: </xsl:text>
			</xsl:when>
			<!-- pozostałe przypadki są nieistotne, będą jednak wyświetlane -->
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>unrecognized: </xsl:text>
				<xsl:value-of select="$protocolCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>inny: </xsl:text>
				<xsl:value-of select="$protocolCode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- źródło - HL7 V3 Data Types 2.21.1 Postal Address Use Code -->
	<xsl:template name="translateAddressUseCode">
		<xsl:param name="useCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<!-- podstawowy adres instytucji, biura lub pracy -->
			<xsl:when test="(not($useCode) or $useCode='WP' or $useCode='DIR' or $useCode='PUB' or $useCode='PHYS') and $lang = $secondLanguage">
				<xsl:text>Address</xsl:text>
			</xsl:when>
			<xsl:when test="not($useCode) or $useCode='WP' or $useCode='DIR' or $useCode='PUB' or $useCode='PHYS'">
				<xsl:text>Adres</xsl:text>
			</xsl:when>
			
			<xsl:when test="($useCode='H' or $useCode='HP') and $lang = $secondLanguage">
				<xsl:text>Home address</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='H' or $useCode='HP'">
				<xsl:text>Adres zamieszkania</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='HV' and $lang = $secondLanguage">
				<xsl:text>Vacation home</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='HV'">
				<xsl:text>Adres w trakcie urlopu</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='TMP' and $lang = $secondLanguage">
				<xsl:text>Temporary address</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='TMP'">
				<xsl:text>Adres tymczasowy</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='PST' and $lang = $secondLanguage">
				<xsl:text>Postal address</xsl:text>
			</xsl:when>
			<xsl:when test="$useCode='PST'">
				<xsl:text>Adres korespondencyjny</xsl:text>
			</xsl:when>
			
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>Address (</xsl:text>
				<xsl:value-of select="$useCode"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Inny adres (</xsl:text>
				<xsl:value-of select="$useCode"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- typy powiązań do dokumentu nadrzędnego -->
	<xsl:template name="translateRelatedDocumentCode">
		<xsl:param name="typeCode"/>
		<xsl:param name="lang"/>
		
		<xsl:choose>
			<xsl:when test="$typeCode='RPLC' and $lang = $secondLanguage">
				<xsl:text>Replacement of document with ID</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='RPLC'">
				<xsl:text>Korekta dokumentu o ID</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='APND' and $lang = $secondLanguage">
				<xsl:text>Addendum to document with ID</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='APND'">
				<xsl:text>Załącznik do dokumentu o ID</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='XFRM' and $lang = $secondLanguage">
				<xsl:text>Transformation of document with ID</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='XFRM'">
				<xsl:text>Wynik transformaty dokumentu o ID</xsl:text>
			</xsl:when>
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>Unknown relationship (</xsl:text>
				<xsl:value-of select="$typeCode"/>
				<xsl:text>) to document with ID</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Nieznane powiązanie (</xsl:text>
				<xsl:value-of select="$typeCode"/>
				<xsl:text>) z dokumentem o ID</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- rola uczestnika wizyty, value set 2.16.840.1.113883.1.11.19600 -->
	<xsl:template name="translateEncounterParticipantTypeCode">
		<xsl:param name="typeCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:choose>
			<xsl:when test="$typeCode='ADM' and $lang = $secondLanguage">
				<xsl:text>admitter</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='ADM'">
				<xsl:text>przyjmujący</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='ATND' and $lang = $secondLanguage">
				<xsl:text>attender</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='ATND'">
				<xsl:text>asystent</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='CON' and $lang = $secondLanguage">
				<xsl:text>consultant</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='CON'">
				<xsl:text>konsultant</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='DIS' and $lang = $secondLanguage">
				<xsl:text>discharger</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='DIS'">
				<xsl:text>wypisujący</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='REF' and $lang = $secondLanguage">
				<xsl:text>referrer</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='REF'">
				<xsl:text>kierujący</xsl:text>
			</xsl:when>
			
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>unrecognized role (</xsl:text>
				<xsl:value-of select="$typeCode"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>nieznana rola (</xsl:text>
				<xsl:value-of select="$typeCode"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- rola realizatora usługi, value set 2.16.840.1.113883.1.11.19601 -->
	<xsl:template name="translateServiceEventPerformerTypeCode">
		<xsl:param name="typeCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:choose>
			<xsl:when test="$typeCode='PRF' and $lang = $secondLanguage">
				<xsl:text>performer</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='PRF'">
				<xsl:text>wykonawca</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='PPRF' and $lang = $secondLanguage">
				<xsl:text>primary performer</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='PPRF'">
				<xsl:text>główny wykonawca</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='SPRF' and $lang = $secondLanguage">
				<xsl:text>secondary performer</xsl:text>
			</xsl:when>
			<xsl:when test="$typeCode='SPRF'">
				<xsl:text>wykonawca</xsl:text>
			</xsl:when>
			
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>unrecognized role (</xsl:text>
				<xsl:value-of select="$typeCode"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>nieznana rola (</xsl:text>
				<xsl:value-of select="$typeCode"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- funkcja realizatora usługi, value set 2.16.840.1.113883.1.11.10267 ze słownika 2.16.840.1.113883.5.88 -->
	<xsl:template name="translateServiceEventPerformerFunctionCode">
		<xsl:param name="functionCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:choose>
			<xsl:when test="$functionCode='ADMPHYS' and $lang = $secondLanguage">
				<xsl:text>admitting physician</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ADMPHYS'">
				<xsl:text>lekarz kwalifikujący</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ANEST' and $lang = $secondLanguage">
				<xsl:text>anesthesist</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ANEST'">
				<xsl:text>anestezjolog</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ANRS' and $lang = $secondLanguage">
				<xsl:text>anesthesia nurse</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ANRS'">
				<xsl:text>pielęgniarka anestezjologiczna</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ATTPHYS' and $lang = $secondLanguage">
				<xsl:text>attending physician</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='ATTPHYS'">
				<xsl:text>lekarz prowadzący</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='DISPHYS' and $lang = $secondLanguage">
				<xsl:text>discharging physician</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='DISPHYS'">
				<xsl:text>lekarz wypisujący</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='FASST' and $lang = $secondLanguage">
				<xsl:text>first assistant surgeon</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='FASST'">
				<xsl:text>pierwsza asysta chirurgiczna</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='MDWF' and $lang = $secondLanguage">
				<xsl:text>midwife</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='MDWF'">
				<xsl:text>położna</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='NASST' and $lang = $secondLanguage">
				<xsl:text>nurse assistant</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='NASST'">
				<!-- nurse assistant (non-sterile): pielęgniarka instrumentariuszka brudna -->
				<xsl:text>pielęgniarka asystująca</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='PCP' and $lang = $secondLanguage">
				<xsl:text>primary care physician</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='PCP'">
				<xsl:text>lekarz pierwszego kontaktu</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='PRISURG' and $lang = $secondLanguage">
				<xsl:text>primary surgeon</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='PRISURG'">
				<!-- primary surgeon: "chirurg prowadzący" zgodnie z Rozporządzeniem MZ § 33. 13) -->
				<xsl:text>chirurg prowadzący</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='RNDPHYS' and $lang = $secondLanguage">
				<xsl:text>rounding physician</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='RNDPHYS'">
				<xsl:text>lekarz wykonujący obchód</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='SASST' and $lang = $secondLanguage">
				<xsl:text>second assistant surgeon</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='SASST'">
				<!-- second assistant surgeon -->
				<xsl:text>druga asysta chirurgiczna</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='SNRS' and $lang = $secondLanguage">
				<xsl:text>scrub nurse</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='SNRS'">
				<!-- scrub nurse (sterile): pielęgniarka instrumentariuszka czysta -->
				<xsl:text>pielęgniarka operacyjna</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='TASST' and $lang = $secondLanguage">
				<xsl:text>third assistant</xsl:text>
			</xsl:when>
			<xsl:when test="$functionCode='TASST'">
				<!-- third assistant: występuje w rzadkich przypadkach, nie stosuje się słowa 'chirurgiczna' -->
				<xsl:text>trzecia asysta</xsl:text>
			</xsl:when>
			
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>unrecognized function (</xsl:text>
				<xsl:value-of select="$functionCode"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>inna funkcja (</xsl:text>
				<xsl:value-of select="$functionCode"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- relacje międzyludzkie, podstawowe, value set ... ze słownika 2.16.840.1.113883.5.111 http://wiki.hl7.de/index.php?title=2.16.840.1.113883.5.111 -->
	<xsl:template name="translatePersonalRelationshipRoleCode">
		<xsl:param name="roleCode"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<xsl:when test="$roleCode='MTH' and $lang = $secondLanguage"><xsl:text>Mother</xsl:text></xsl:when>
			<xsl:when test="$roleCode='MTH'"><xsl:text>Matka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='FTH' and $lang = $secondLanguage"><xsl:text>Father</xsl:text></xsl:when>
			<xsl:when test="$roleCode='FTH'"><xsl:text>Ojciec</xsl:text></xsl:when>
			<xsl:when test="$roleCode='CHILD' and $lang = $secondLanguage"><xsl:text>Child</xsl:text></xsl:when>
			<xsl:when test="$roleCode='CHILD'"><xsl:text>Dziecko</xsl:text></xsl:when>
			<xsl:when test="$roleCode='DAU' and $lang = $secondLanguage"><xsl:text>Daughter</xsl:text></xsl:when>
			<xsl:when test="$roleCode='DAU'"><xsl:text>Córka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='DAUC' and $lang = $secondLanguage"><xsl:text>Daughter</xsl:text></xsl:when>
			<xsl:when test="$roleCode='DAUC'"><xsl:text>Córka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SON' and $lang = $secondLanguage"><xsl:text>Son</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SON'"><xsl:text>Syn</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SONC' and $lang = $secondLanguage"><xsl:text>Son</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SONC'"><xsl:text>Syn</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NSON' and $lang = $secondLanguage"><xsl:text>Son</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NSON'"><xsl:text>Syn</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NDAU' and $lang = $secondLanguage"><xsl:text>Daughter</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NDAU'"><xsl:text>Córka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='COUSN' and $lang = $secondLanguage"><xsl:text>Cousin</xsl:text></xsl:when>
			<xsl:when test="$roleCode='COUSN'"><xsl:text>Kuzyn</xsl:text></xsl:when>
			<xsl:when test="$roleCode='CHLDINLAW' and $lang = $secondLanguage"><xsl:text>Child in-law</xsl:text></xsl:when>
			<xsl:when test="$roleCode='CHLDINLAW'"><xsl:text>Dziecko przybrane</xsl:text></xsl:when>
			<xsl:when test="$roleCode='CHLDADOPT' and $lang = $secondLanguage"><xsl:text>Adopted child</xsl:text></xsl:when>
			<xsl:when test="$roleCode='CHLDADOPT'"><xsl:text>Dziecko adoptowane</xsl:text></xsl:when>
			<xsl:when test="$roleCode='GRPRN' and $lang = $secondLanguage"><xsl:text>Grandparent</xsl:text></xsl:when>
			<xsl:when test="$roleCode='GRPRN'"><xsl:text>Dziadek/babcia</xsl:text></xsl:when>
			<xsl:when test="$roleCode='GRARNT' and $lang = $secondLanguage"><xsl:text>Grandparent</xsl:text></xsl:when>
			<xsl:when test="$roleCode='GRARNT'"><xsl:text>Dziadek/babcia</xsl:text></xsl:when>
			<xsl:when test="$roleCode='GRNDCHILD' and $lang = $secondLanguage"><xsl:text>Grandchild</xsl:text></xsl:when>
			<xsl:when test="$roleCode='GRNDCHILD'"><xsl:text>Wnuk/wnuczka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='FAMMEMB' and $lang = $secondLanguage"><xsl:text>Family member</xsl:text></xsl:when>
			<xsl:when test="$roleCode='FAMMEMB'"><xsl:text>Członek rodziny</xsl:text></xsl:when>
			<xsl:when test="$roleCode='AUNT' and $lang = $secondLanguage"><xsl:text>Aunt</xsl:text></xsl:when>
			<xsl:when test="$roleCode='AUNT'"><xsl:text>Ciotka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='UNCLE' and $lang = $secondLanguage"><xsl:text>Uncle</xsl:text></xsl:when>
			<xsl:when test="$roleCode='UNCLE'"><xsl:text>Wuj</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NPRN' and $lang = $secondLanguage"><xsl:text>Parent</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NPRN'"><xsl:text>Rodzic</xsl:text></xsl:when>
			<xsl:when test="$roleCode='PRN' and $lang = $secondLanguage"><xsl:text>Parent</xsl:text></xsl:when>
			<xsl:when test="$roleCode='PRN'"><xsl:text>Rodzic</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SIB' and $lang = $secondLanguage"><xsl:text>Sibling</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SIB'"><xsl:text>Rodzeństwo</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SPS' and $lang = $secondLanguage"><xsl:text>Spouse</xsl:text></xsl:when>
			<xsl:when test="$roleCode='SPS'"><xsl:text>Małżonek/małżonka</xsl:text></xsl:when>
			<xsl:when test="$roleCode='HUSB' and $lang = $secondLanguage"><xsl:text>Husband</xsl:text></xsl:when>
			<xsl:when test="$roleCode='HUSB'"><xsl:text>Mąż</xsl:text></xsl:when>
			<xsl:when test="$roleCode='WIFE' and $lang = $secondLanguage"><xsl:text>Wife</xsl:text></xsl:when>
			<xsl:when test="$roleCode='WIFE'"><xsl:text>Żona</xsl:text></xsl:when>
			<xsl:when test="$roleCode='PRNINLAW' and $lang = $secondLanguage"><xsl:text>Parent in-law</xsl:text></xsl:when>
			<xsl:when test="$roleCode='PRNINLAW'"><xsl:text>Rodzic przybrany</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NBOR' and $lang = $secondLanguage"><xsl:text>Neighbor</xsl:text></xsl:when>
			<xsl:when test="$roleCode='NBOR'"><xsl:text>Sąsiad</xsl:text></xsl:when>
			<xsl:when test="$roleCode='FRND' and $lang = $secondLanguage"><xsl:text>Unrelated friend</xsl:text></xsl:when>
			<xsl:when test="$roleCode='FRND'"><xsl:text>Przyjaciel</xsl:text></xsl:when>
			<xsl:when test="$roleCode='DOMPART' and $lang = $secondLanguage"><xsl:text>Domestic partner</xsl:text></xsl:when>
			<xsl:when test="$roleCode='DOMPART'"><xsl:text>Partner/partnerka</xsl:text></xsl:when>
			<xsl:when test="$lang = $secondLanguage">
				<xsl:text>unrecognized relationship (</xsl:text>
				<xsl:value-of select="$roleCode"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>inna relacja (</xsl:text>
				<xsl:value-of select="$roleCode"/>
				<xsl:text>)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- znane węzły OID -->
	<xsl:template name="translateOID">
		<xsl:param name="oid"/>
		<xsl:param name="ext"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:choose>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.1.1.616'">
				<xsl:text>PESEL</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.6.')">
				<xsl:text>NPWZ</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.2.1'">
				<xsl:text>REGON</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.2.2'">
				<xsl:text>REGON</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.1'">
				<xsl:text>NIP</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.3.1'">
				<xsl:text>cz. I sys. kod. res.</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.3.2'">
				<xsl:text>cz. I-V sys. kod. res.</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.3.3'">
				<xsl:text>cz. I-VII sys. kod. res.</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.6' and $lang = $secondLanguage">
				<xsl:text>Register of pharmacies</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.6'">
				<xsl:text>Wpis w Rejestrze Aptek</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.3.1'">
				<xsl:choose>
					<xsl:when test="$ext='01'">
						<xsl:text>Dolnośląski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='02'">
						<xsl:text>Kujawsko-Pomorski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='03'">
						<xsl:text>Lubelski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='04'">
						<xsl:text>Lubuski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='05'">
						<xsl:text>Łódzki Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='06'">
						<xsl:text>Małopolski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='07'">
						<xsl:text>Mazowiecki Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='08'">
						<xsl:text>Opolski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='09'">
						<xsl:text>Podkarpacki Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='10'">
						<xsl:text>Podlaski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='11'">
						<xsl:text>Pomorski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='12'">
						<xsl:text>Śląski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='13'">
						<xsl:text>Świętokrzyski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='14'">
						<xsl:text>Warmińsko-Mazurski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='15'">
						<xsl:text>Wielkopolski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='16'">
						<xsl:text>Zachodniopomorski Oddział NFZ</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='95'">
						<xsl:text>Minister Pracy i Polityki Społecznej</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='96'">
						<xsl:text>Minister Edukacji Narodowej</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='97'">
						<xsl:text>Minister Obrony Narodowej</xsl:text>
					</xsl:when>
					<xsl:when test="$ext='98'">
						<xsl:text>Minister Zdrowia</xsl:text>
					</xsl:when>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>other</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>inny</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.1.49' and $lang = $secondLanguage">
				<xsl:call-template name="translateISO3166alfa2orISO3166">
					<xsl:with-param name="codeValue" select="$ext"/>
				</xsl:call-template>
				<xsl:text> - country code </xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.1.49'">
				<xsl:call-template name="translateISO3166alfa2orISO3166">
					<xsl:with-param name="codeValue" select="$ext"/>
				</xsl:call-template>
				<xsl:text> - kod kraju </xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.')">
				<xsl:choose>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.50')"><xsl:text>Wpis OIL w Białymstoku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.51')"><xsl:text>Wpis OIL w Bielsku-Białej</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.52')"><xsl:text>Wpis OIL w Bydgoszczy</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.53')"><xsl:text>Wpis OIL w Gdańsku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.54')"><xsl:text>Wpis OIL w Gorzowie Wielkopolskim</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.55')"><xsl:text>Wpis OIL w Katowicach</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.56')"><xsl:text>Wpis OIL w Kielcach</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.57')"><xsl:text>Wpis OIL w Krakowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.58')"><xsl:text>Wpis OIL w Lublinie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.59')"><xsl:text>Wpis OIL w Łodzi</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.60')"><xsl:text>Wpis OIL w Olsztynie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.61')"><xsl:text>Wpis OIL w Opolu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.62')"><xsl:text>Wpis OIL w Płocku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.63')"><xsl:text>Wpis OIL w Poznaniu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.64')"><xsl:text>Wpis OIL w Rzeszowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.65')"><xsl:text>Wpis OIL w Szczecinie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.66')"><xsl:text>Wpis OIL w Tarnowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.67')"><xsl:text>Wpis OIL w Toruniu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.68')"><xsl:text>Wpis OIL w Warszawie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.69')"><xsl:text>Wpis OIL we Wrocławiu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.70')"><xsl:text>Wpis OIL w Zielonej Górze</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.72')"><xsl:text>Wpis Wojskowej Izby Lekarskiej</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.74')"><xsl:text>Wpis OIL w Koszalinie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.4.75')"><xsl:text>Wpis OIL w Częstochowie</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.')">
				<xsl:choose>
					<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.5.1' or $oid='2.16.840.1.113883.3.4424.2.5.1.1'"><xsl:text>Wpis OIPiP w Białej Podlaskiej</xsl:text></xsl:when>
					<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.5.2' or $oid='2.16.840.1.113883.3.4424.2.5.2.1'"><xsl:text>Wpis OIPiP w Białymstoku</xsl:text></xsl:when>
					<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.5.3' or $oid='2.16.840.1.113883.3.4424.2.5.3.1'"><xsl:text>Wpis OIPiP w Bielsku-Białej</xsl:text></xsl:when>
					<xsl:when test="$oid='2.16.840.1.113883.3.4424.2.5.4' or $oid='2.16.840.1.113883.3.4424.2.5.4.1'"><xsl:text>Wpis OIPiP w Bydgoszczy</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.5')"><xsl:text>Wpis OIPiP w Chełmnie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.6')"><xsl:text>Wpis OIPiP w Ciechanowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.7')"><xsl:text>Wpis OIPiP w Częstochowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.8')"><xsl:text>Wpis OIPiP w Elblągu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.9')"><xsl:text>Wpis OIPiP w Gdańsku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.10')"><xsl:text>Wpis OIPiP w Gorzowie Wielkopolskim</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.11')"><xsl:text>Wpis OIPiP w Jeleniej Górze</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.12')"><xsl:text>Wpis OIPiP w Kaliszu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.13')"><xsl:text>Wpis OIPiP w Katowicach</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.14')"><xsl:text>Wpis OIPiP w Kielcach</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.15')"><xsl:text>Wpis OIPiP w Koninie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.16')"><xsl:text>Wpis OIPiP w Koszalinie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.17')"><xsl:text>Wpis OIPiP w Krakowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.18')"><xsl:text>Wpis OIPiP w Krośnie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.19')"><xsl:text>Wpis OIPiP w Lesznie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.20')"><xsl:text>Wpis OIPiP w Lublinie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.21')"><xsl:text>Wpis OIPiP w Łomży</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.22')"><xsl:text>Wpis OIPiP w Łodzi</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.23')"><xsl:text>Wpis OIPiP w Olsztynie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.24')"><xsl:text>Wpis OIPiP w Opolu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.25')"><xsl:text>Wpis OIPiP w Ostrołęce</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.26')"><xsl:text>Wpis OIPiP w Pile</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.27')"><xsl:text>Wpis OIPiP w Płocku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.28')"><xsl:text>Wpis OIPiP w Poznaniu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.29')"><xsl:text>Wpis OIPiP w Przeworsku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.30')"><xsl:text>Wpis OIPiP w Radomiu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.31')"><xsl:text>Wpis OIPiP w Rzeszowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.32')"><xsl:text>Wpis OIPiP w Siedlcach</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.33')"><xsl:text>Wpis OIPiP w Sieradzu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.34')"><xsl:text>Wpis OIPiP w Słupsku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.35')"><xsl:text>Wpis OIPiP w Suwałkach</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.36')"><xsl:text>Wpis OIPiP w Szczecinie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.37')"><xsl:text>Wpis OIPiP w Nowym Sączu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.38')"><xsl:text>Wpis OIPiP w Tarnowie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.39')"><xsl:text>Wpis OIPiP w Toruniu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.40')"><xsl:text>Wpis OIPiP w Wałbrzychu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.41')"><xsl:text>Wpis OIPiP w Warszawie</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.42')"><xsl:text>Wpis OIPiP we Włocławku</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.43')"><xsl:text>Wpis OIPiP we Wrocławiu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.44')"><xsl:text>Wpis OIPiP w Zamościu</xsl:text></xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.2.5.45')"><xsl:text>Wpis OIPiP w Zielonej Górze</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.2' and $lang = $secondLanguage">
				<xsl:text>NFZ Certificate</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.2'">
				<xsl:text>Poświadczenie NFZ</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.3' and $lang = $secondLanguage">
				<xsl:text>EKUZ</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.3'">
				<xsl:text>Karta EKUZ</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.4' and $lang = $secondLanguage">
				<xsl:text>eWUŚ Certificate</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.4'">
				<xsl:text>Potwierdzenie eWUŚ</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.5' and $lang = $secondLanguage">
				<xsl:text>EKUZ Substitution</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.8.5'">
				<xsl:text>Certyfikat zastępujący EKUZ</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='1.3.160'">
				<xsl:text>GS1/EAN</xsl:text>
			</xsl:when>
			<!-- identyfikatory osób z pominięciem PESEL i NPWZ, które znajdują się wyżej ze względu na częstotliwość występowania -->
			<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.')">
				<xsl:call-template name="translateISO3166alfa2orISO3166">
					<xsl:with-param name="codeValue" select="substring($oid, 30, 3)"/>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.1.') and $lang = $secondLanguage">
						<xsl:text> - national ID</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.1.')">
						<xsl:text> - krajowy identyfikator osoby</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.2.') and $lang = $secondLanguage">
						<xsl:text> - identity card number</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.2.')">
						<xsl:text> - numer dowodu osobistego</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.3.') and $lang = $secondLanguage">
						<xsl:text> - driver's license number</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.3.')">
						<xsl:text> - numer prawa jazdy</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.5.') and $lang = $secondLanguage">
						<xsl:text> - sailor ID</xsl:text>
					</xsl:when>
					<xsl:when test="starts-with($oid, '2.16.840.1.113883.3.4424.1.5.')">
						<xsl:text> - numer książeczki żeglarskiej</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="starts-with($oid, '2.16.840.1.113883.4.330')">
				<xsl:call-template name="translateISO3166alfa2orISO3166">
					<xsl:with-param name="codeValue" select="substring($oid, 25, 3)"/>
				</xsl:call-template>
				<xsl:if test="$lang = $secondLanguage">
					<xsl:text> - passport number</xsl:text>
				</xsl:if>
				<xsl:if test="$lang != $secondLanguage">
					<xsl:text> - numer paszportu</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.2.4.6.3' and $lang = $secondLanguage">
				<xsl:text>Netherlands - national ID</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.2.4.6.3'">
				<xsl:text>Holandia - krajowy identyfikator osoby</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.578.1.12.4.1.4.1' and $lang = $secondLanguage">
				<xsl:text>Norway - national ID</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.578.1.12.4.1.4.1'">
				<xsl:text>Norwegia - krajowy identyfikator osoby</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="translateCodeSystemOID">
		<xsl:param name="oid"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.2.4' and $lang = $secondLanguage">
				<xsl:text>Specialty</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.2.4'">
				<xsl:text>Specjalność (cz. VIII sys. kod. res.)</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.2.6'">
				<xsl:text>ICD-9-PL</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.6.260'">
				<xsl:text>ICD-10 Dual Coding</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.6.1'">
				<xsl:text>LOINC</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.6.96'">
				<xsl:text>SNOMED CT</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.6.97'">
				<xsl:text>ICNP</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.3.21' and $lang = $secondLanguage">
				<xsl:text>Discharge disposition code</xsl:text>
			</xsl:when>
			<xsl:when test="$oid='2.16.840.1.113883.3.4424.11.3.21'">
				<xsl:text>Tryb wypisu ze szpitala</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$oid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- nullFlavor-->
	<xsl:template name="translateNullFlavor">
		<xsl:param name="nullableElement"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<!-- HL7 CDA dopuszcza podanie nullFlavor dla każdego kwantu danych i każdego elementu
			 obsłużono wyłącznie najważniejsze przypadki i najpopularniejsze kody:
			 NI = No Information. This is the most general and default null flavor.
			 NA = Not Applicable. Known to have no proper value (e.g., last menstrual period for a male).
			 UNK = Unknown. A proper value is applicable, but is not known.
			 ASKU = asked, but not known. Information was sought, but not found (e.g., the patient was asked but did not know).
			 NAV = temporarily unavailable. The information is not available, but is expected to be available later.
			 NASK = Not Asked. The patient was not asked. -->
		<xsl:if test="not($nullableElement) or $nullableElement/@nullFlavor">
			<span class="null_flavor">
				<xsl:choose>
					<xsl:when test="not($nullableElement) and $lang = $secondLanguage">
						<xsl:text>(no information)</xsl:text>
					</xsl:when>
					<xsl:when test="not($nullableElement)">
						<xsl:text>(nie podano)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NI' and $lang = $secondLanguage">
						<xsl:text>(no information)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NI'">
						<xsl:text>(brak informacji)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NA' and $lang = $secondLanguage">
						<xsl:text>(not applicable)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NA'">
						<xsl:text>(nie dotyczy)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='UNK' and $lang = $secondLanguage">
						<xsl:text>(unknown)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='UNK'">
						<xsl:text>(nieznane)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='ASKU' and $lang = $secondLanguage">
						<xsl:text>(asked but unknown)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='ASKU'">
						<xsl:text>(nie uzyskano informacji)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NAV' and $lang = $secondLanguage">
						<xsl:text>(temporarily unavailable)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NAV'">
						<xsl:text>(czasowo niedostępne)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NASK' and $lang = $secondLanguage">
						<xsl:text>(not asked)</xsl:text>
					</xsl:when>
					<xsl:when test="$nullableElement/@nullFlavor='NASK'">
						<xsl:text>(nie pytano)</xsl:text>
					</xsl:when>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>(no information)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>(nie podano)</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>
	
	<!-- nazwa miesiąca w pełnej dacie -->
	<xsl:template name="translateFullDateMonth">
		<xsl:param name="month"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<xsl:when test="$month='01' and $lang = $secondLanguage"><xsl:text>January</xsl:text></xsl:when>
			<xsl:when test="$month='01'"><xsl:text>stycznia</xsl:text></xsl:when>
			<xsl:when test="$month='02' and $lang = $secondLanguage"><xsl:text>February</xsl:text></xsl:when>
			<xsl:when test="$month='02'"><xsl:text>lutego</xsl:text></xsl:when>
			<xsl:when test="$month='03' and $lang = $secondLanguage"><xsl:text>March</xsl:text></xsl:when>
			<xsl:when test="$month='03'"><xsl:text>marca</xsl:text></xsl:when>
			<xsl:when test="$month='04' and $lang = $secondLanguage"><xsl:text>April</xsl:text></xsl:when>
			<xsl:when test="$month='04'"><xsl:text>kwietnia</xsl:text></xsl:when>
			<xsl:when test="$month='05' and $lang = $secondLanguage"><xsl:text>May</xsl:text></xsl:when>
			<xsl:when test="$month='05'"><xsl:text>maja</xsl:text></xsl:when>
			<xsl:when test="$month='06' and $lang = $secondLanguage"><xsl:text>June</xsl:text></xsl:when>
			<xsl:when test="$month='06'"><xsl:text>czerwca</xsl:text></xsl:when>
			<xsl:when test="$month='07' and $lang = $secondLanguage"><xsl:text>July</xsl:text></xsl:when>
			<xsl:when test="$month='07'"><xsl:text>lipca</xsl:text></xsl:when>
			<xsl:when test="$month='08' and $lang = $secondLanguage"><xsl:text>August</xsl:text></xsl:when>
			<xsl:when test="$month='08'"><xsl:text>sierpnia</xsl:text></xsl:when>
			<xsl:when test="$month='09' and $lang = $secondLanguage"><xsl:text>September</xsl:text></xsl:when>
			<xsl:when test="$month='09'"><xsl:text>września</xsl:text></xsl:when>
			<xsl:when test="$month='10' and $lang = $secondLanguage"><xsl:text>October</xsl:text></xsl:when>
			<xsl:when test="$month='10'"><xsl:text>października</xsl:text></xsl:when>
			<xsl:when test="$month='11' and $lang = $secondLanguage"><xsl:text>November</xsl:text></xsl:when>
			<xsl:when test="$month='11'"><xsl:text>listopada</xsl:text></xsl:when>
			<xsl:when test="$month='12' and $lang = $secondLanguage"><xsl:text>December</xsl:text></xsl:when>
			<xsl:when test="$month='12'"><xsl:text>grudnia</xsl:text></xsl:when>
			<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- nazwa miesiąca -->
	<xsl:template name="translateMonth">
		<xsl:param name="month"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:choose>
			<xsl:when test="$month='01' and $lang = $secondLanguage"><xsl:text>January</xsl:text></xsl:when>
			<xsl:when test="$month='01'"><xsl:text>styczeń</xsl:text></xsl:when>
			<xsl:when test="$month='02' and $lang = $secondLanguage"><xsl:text>February</xsl:text></xsl:when>
			<xsl:when test="$month='02'"><xsl:text>luty</xsl:text></xsl:when>
			<xsl:when test="$month='03' and $lang = $secondLanguage"><xsl:text>March</xsl:text></xsl:when>
			<xsl:when test="$month='03'"><xsl:text>marzec</xsl:text></xsl:when>
			<xsl:when test="$month='04' and $lang = $secondLanguage"><xsl:text>April</xsl:text></xsl:when>
			<xsl:when test="$month='04'"><xsl:text>kwiecień</xsl:text></xsl:when>
			<xsl:when test="$month='05' and $lang = $secondLanguage"><xsl:text>May</xsl:text></xsl:when>
			<xsl:when test="$month='05'"><xsl:text>maj</xsl:text></xsl:when>
			<xsl:when test="$month='06' and $lang = $secondLanguage"><xsl:text>June</xsl:text></xsl:when>
			<xsl:when test="$month='06'"><xsl:text>czerwiec</xsl:text></xsl:when>
			<xsl:when test="$month='07' and $lang = $secondLanguage"><xsl:text>July</xsl:text></xsl:when>
			<xsl:when test="$month='07'"><xsl:text>lipiec</xsl:text></xsl:when>
			<xsl:when test="$month='08' and $lang = $secondLanguage"><xsl:text>August</xsl:text></xsl:when>
			<xsl:when test="$month='08'"><xsl:text>sierpień</xsl:text></xsl:when>
			<xsl:when test="$month='09' and $lang = $secondLanguage"><xsl:text>September</xsl:text></xsl:when>
			<xsl:when test="$month='09'"><xsl:text>wrzesień</xsl:text></xsl:when>
			<xsl:when test="$month='10' and $lang = $secondLanguage"><xsl:text>October</xsl:text></xsl:when>
			<xsl:when test="$month='10'"><xsl:text>październik</xsl:text></xsl:when>
			<xsl:when test="$month='11' and $lang = $secondLanguage"><xsl:text>November</xsl:text></xsl:when>
			<xsl:when test="$month='11'"><xsl:text>listopad</xsl:text></xsl:when>
			<xsl:when test="$month='12' and $lang = $secondLanguage"><xsl:text>December</xsl:text></xsl:when>
			<xsl:when test="$month='12'"><xsl:text>grudzień</xsl:text></xsl:when>
			<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="translateISO3166alfa2orISO3166">
		<xsl:param name="codeValue"/>
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:variable name="code">
			<xsl:call-template name="fillUpToThreeChars">
				<xsl:with-param name="code" select="$codeValue"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="($code='0AF' or $code='004') and $lang = $secondLanguage"><xsl:text>Afghanistan</xsl:text></xsl:when>
			<xsl:when test="($code='0AF' or $code='004') and $lang != $secondLanguage"><xsl:text>Afganistan</xsl:text></xsl:when>
			<xsl:when test="($code='0AL' or $code='008')"><xsl:text>Albania</xsl:text></xsl:when>
			<xsl:when test="($code='0DZ' or $code='012') and $lang = $secondLanguage"><xsl:text>Algeria</xsl:text></xsl:when>
			<xsl:when test="($code='0DZ' or $code='012') and $lang != $secondLanguage"><xsl:text>Algieria</xsl:text></xsl:when>
			<xsl:when test="($code='0AD' or $code='020') and $lang = $secondLanguage"><xsl:text>Andorra</xsl:text></xsl:when>
			<xsl:when test="($code='0AD' or $code='020') and $lang != $secondLanguage"><xsl:text>Andora</xsl:text></xsl:when>
			<xsl:when test="($code='0AO' or $code='024')"><xsl:text>Angola</xsl:text></xsl:when>
			<xsl:when test="($code='0AI' or $code='660')"><xsl:text>Anguilla</xsl:text></xsl:when>
			<xsl:when test="($code='0AQ' or $code='010') and $lang = $secondLanguage"><xsl:text>Antarctica</xsl:text></xsl:when>
			<xsl:when test="($code='0AQ' or $code='010') and $lang != $secondLanguage"><xsl:text>Antarktyka</xsl:text></xsl:when>
			<xsl:when test="($code='0AG' or $code='028') and $lang = $secondLanguage"><xsl:text>Antigua and Barbuda</xsl:text></xsl:when>
			<xsl:when test="($code='0AG' or $code='028') and $lang != $secondLanguage"><xsl:text>Antigua i Barbuda</xsl:text></xsl:when>
			<xsl:when test="($code='0SA' or $code='682') and $lang = $secondLanguage"><xsl:text>Saudi Arabia</xsl:text></xsl:when>
			<xsl:when test="($code='0SA' or $code='682') and $lang != $secondLanguage"><xsl:text>Arabia Saudyjska</xsl:text></xsl:when>
			<xsl:when test="($code='0AR' or $code='032') and $lang = $secondLanguage"><xsl:text>Argentina</xsl:text></xsl:when>
			<xsl:when test="($code='0AR' or $code='032') and $lang != $secondLanguage"><xsl:text>Argentyna</xsl:text></xsl:when>
			<xsl:when test="($code='0AM' or $code='051')"><xsl:text>Armenia</xsl:text></xsl:when>
			<xsl:when test="($code='0AW' or $code='533')"><xsl:text>Aruba</xsl:text></xsl:when>
			<xsl:when test="($code='0AU' or $code='036')"><xsl:text>Australia</xsl:text></xsl:when>
			<xsl:when test="($code='0AT' or $code='040')"><xsl:text>Austria</xsl:text></xsl:when>
			<xsl:when test="($code='0AZ' or $code='031') and $lang = $secondLanguage"><xsl:text>Azerbaijan</xsl:text></xsl:when>
			<xsl:when test="($code='0AZ' or $code='031') and $lang != $secondLanguage"><xsl:text>Azerbejdżan</xsl:text></xsl:when>
			<xsl:when test="($code='0BS' or $code='044') and $lang = $secondLanguage"><xsl:text>Bahamas</xsl:text></xsl:when>
			<xsl:when test="($code='0BS' or $code='044') and $lang != $secondLanguage"><xsl:text>Bahamy</xsl:text></xsl:when>
			<xsl:when test="($code='0BH' or $code='048') and $lang = $secondLanguage"><xsl:text>Bahrain</xsl:text></xsl:when>
			<xsl:when test="($code='0BH' or $code='048') and $lang != $secondLanguage"><xsl:text>Bahrajn</xsl:text></xsl:when>
			<xsl:when test="($code='0BD' or $code='050') and $lang = $secondLanguage"><xsl:text>Bangladesh</xsl:text></xsl:when>
			<xsl:when test="($code='0BD' or $code='050') and $lang != $secondLanguage"><xsl:text>Bangladesz</xsl:text></xsl:when>
			<xsl:when test="($code='0BB' or $code='052')"><xsl:text>Barbados</xsl:text></xsl:when>
			<xsl:when test="($code='0BE' or $code='056') and $lang = $secondLanguage"><xsl:text>Belgium</xsl:text></xsl:when>
			<xsl:when test="($code='0BE' or $code='056') and $lang != $secondLanguage"><xsl:text>Belgia</xsl:text></xsl:when>
			<xsl:when test="($code='0BZ' or $code='084')"><xsl:text>Belize</xsl:text></xsl:when>
			<xsl:when test="($code='0BJ' or $code='204')"><xsl:text>Benin</xsl:text></xsl:when>
			<xsl:when test="($code='0BM' or $code='060') and $lang = $secondLanguage"><xsl:text>Bermuda</xsl:text></xsl:when>
			<xsl:when test="($code='0BM' or $code='060') and $lang != $secondLanguage"><xsl:text>Bermudy</xsl:text></xsl:when>
			<xsl:when test="($code='0BT' or $code='064')"><xsl:text>Bhutan</xsl:text></xsl:when>
			<xsl:when test="($code='0BY' or $code='112') and $lang = $secondLanguage"><xsl:text>Belarus</xsl:text></xsl:when>
			<xsl:when test="($code='0BY' or $code='112') and $lang != $secondLanguage"><xsl:text>Białoruś</xsl:text></xsl:when>
			<xsl:when test="($code='0BO' or $code='068') and $lang = $secondLanguage"><xsl:text>Bolivia</xsl:text></xsl:when>
			<xsl:when test="($code='0BO' or $code='068') and $lang != $secondLanguage"><xsl:text>Boliwia</xsl:text></xsl:when>
			<xsl:when test="($code='0BQ' or $code='535') and $lang = $secondLanguage"><xsl:text>Bonaire, Sint Eustatius and Saba</xsl:text></xsl:when>
			<xsl:when test="($code='0BQ' or $code='535') and $lang != $secondLanguage"><xsl:text>Bonaire, Sint Eustatius i Saba</xsl:text></xsl:when>
			<xsl:when test="($code='0BA' or $code='070') and $lang = $secondLanguage"><xsl:text>Bosnia and Herzegovina</xsl:text></xsl:when>
			<xsl:when test="($code='0BA' or $code='070') and $lang != $secondLanguage"><xsl:text>Bośnia i Hercegowina</xsl:text></xsl:when>
			<xsl:when test="($code='0BW' or $code='072')"><xsl:text>Botswana</xsl:text></xsl:when>
			<xsl:when test="($code='0BR' or $code='076') and $lang = $secondLanguage"><xsl:text>Brazil</xsl:text></xsl:when>
			<xsl:when test="($code='0BR' or $code='076') and $lang != $secondLanguage"><xsl:text>Brazylia</xsl:text></xsl:when>
			<xsl:when test="($code='0BN' or $code='096')"><xsl:text>Brunei</xsl:text></xsl:when>
			<xsl:when test="($code='0IO' or $code='086') and $lang = $secondLanguage"><xsl:text>British Indian Ocean Territory</xsl:text></xsl:when>
			<xsl:when test="($code='0IO' or $code='086') and $lang != $secondLanguage"><xsl:text>Brytyjskie Terytorium Oceanu Indyjskiego</xsl:text></xsl:when>
			<xsl:when test="($code='0VG' or $code='092') and $lang = $secondLanguage"><xsl:text>Virgin Islands, British</xsl:text></xsl:when>
			<xsl:when test="($code='0VG' or $code='092') and $lang != $secondLanguage"><xsl:text>Brytyjskie Wyspy Dziewicze</xsl:text></xsl:when>
			<xsl:when test="($code='0BG' or $code='100') and $lang = $secondLanguage"><xsl:text>Bulgaria</xsl:text></xsl:when>
			<xsl:when test="($code='0BG' or $code='100') and $lang != $secondLanguage"><xsl:text>Bułgaria</xsl:text></xsl:when>
			<xsl:when test="($code='0BF' or $code='854')"><xsl:text>Burkina Faso</xsl:text></xsl:when>
			<xsl:when test="($code='0BI' or $code='108')"><xsl:text>Burundi</xsl:text></xsl:when>
			<xsl:when test="($code='0CL' or $code='152')"><xsl:text>Chile</xsl:text></xsl:when>
			<xsl:when test="($code='0CN' or $code='156') and $lang = $secondLanguage"><xsl:text>China</xsl:text></xsl:when>
			<xsl:when test="($code='0CN' or $code='156') and $lang != $secondLanguage"><xsl:text>Chiny</xsl:text></xsl:when>
			<xsl:when test="($code='0HR' or $code='191') and $lang = $secondLanguage"><xsl:text>Croatia</xsl:text></xsl:when>
			<xsl:when test="($code='0HR' or $code='191') and $lang != $secondLanguage"><xsl:text>Chorwacja</xsl:text></xsl:when>
			<xsl:when test="($code='0CW' or $code='531')"><xsl:text>Curaçao</xsl:text></xsl:when>
			<xsl:when test="($code='0CY' or $code='196') and $lang = $secondLanguage"><xsl:text>Cyprus</xsl:text></xsl:when>
			<xsl:when test="($code='0CY' or $code='196') and $lang != $secondLanguage"><xsl:text>Cypr</xsl:text></xsl:when>
			<xsl:when test="($code='0TD' or $code='148') and $lang = $secondLanguage"><xsl:text>Chad</xsl:text></xsl:when>
			<xsl:when test="($code='0TD' or $code='148') and $lang != $secondLanguage"><xsl:text>Czad</xsl:text></xsl:when>
			<xsl:when test="($code='0ME' or $code='499') and $lang = $secondLanguage"><xsl:text>Montenegro</xsl:text></xsl:when>
			<xsl:when test="($code='0ME' or $code='499') and $lang != $secondLanguage"><xsl:text>Czarnogóra</xsl:text></xsl:when>
			<xsl:when test="($code='0CZ' or $code='203') and $lang = $secondLanguage"><xsl:text>Czechia</xsl:text></xsl:when>
			<xsl:when test="($code='0CZ' or $code='203')"><xsl:text>Czechy</xsl:text></xsl:when>
			<xsl:when test="($code='0UM' or $code='581') and $lang = $secondLanguage"><xsl:text>United States Minor Outlying Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0UM' or $code='581') and $lang != $secondLanguage"><xsl:text>Dalekie Wyspy Mniejsze Stanów Zjednoczonych</xsl:text></xsl:when>
			<xsl:when test="($code='0DK' or $code='208') and $lang = $secondLanguage"><xsl:text>Denmark</xsl:text></xsl:when>
			<xsl:when test="($code='0DK' or $code='208') and $lang != $secondLanguage"><xsl:text>Dania</xsl:text></xsl:when>
			<xsl:when test="($code='0CD' or $code='180') and $lang = $secondLanguage"><xsl:text>the Democratic Republic of the Congo</xsl:text></xsl:when>
			<xsl:when test="($code='0CD' or $code='180') and $lang != $secondLanguage"><xsl:text>Demokratyczna Republika Konga</xsl:text></xsl:when>
			<xsl:when test="($code='0DM' or $code='212') and $lang = $secondLanguage"><xsl:text>Dominica</xsl:text></xsl:when>
			<xsl:when test="($code='0DM' or $code='212') and $lang != $secondLanguage"><xsl:text>Dominika</xsl:text></xsl:when>
			<xsl:when test="($code='0DO' or $code='214') and $lang = $secondLanguage"><xsl:text>Dominican Republic</xsl:text></xsl:when>
			<xsl:when test="($code='0DO' or $code='214') and $lang != $secondLanguage"><xsl:text>Dominikana</xsl:text></xsl:when>
			<xsl:when test="($code='0DJ' or $code='262') and $lang = $secondLanguage"><xsl:text>Djibouti</xsl:text></xsl:when>
			<xsl:when test="($code='0DJ' or $code='262') and $lang != $secondLanguage"><xsl:text>Dżibuti</xsl:text></xsl:when>
			<xsl:when test="($code='0EG' or $code='818') and $lang = $secondLanguage"><xsl:text>Egypt</xsl:text></xsl:when>
			<xsl:when test="($code='0EG' or $code='818') and $lang != $secondLanguage"><xsl:text>Egipt</xsl:text></xsl:when>
			<xsl:when test="($code='0EC' or $code='218') and $lang = $secondLanguage"><xsl:text>Ecuador</xsl:text></xsl:when>
			<xsl:when test="($code='0EC' or $code='218') and $lang != $secondLanguage"><xsl:text>Ekwador</xsl:text></xsl:when>
			<xsl:when test="($code='0ER' or $code='232') and $lang = $secondLanguage"><xsl:text>Eritrea</xsl:text></xsl:when>
			<xsl:when test="($code='0ER' or $code='232') and $lang != $secondLanguage"><xsl:text>Erytrea</xsl:text></xsl:when>
			<xsl:when test="($code='0EE' or $code='233')"><xsl:text>Estonia</xsl:text></xsl:when>
			<xsl:when test="($code='0ET' or $code='231') and $lang = $secondLanguage"><xsl:text>Ethiopia</xsl:text></xsl:when>
			<xsl:when test="($code='0ET' or $code='231') and $lang != $secondLanguage"><xsl:text>Etiopia</xsl:text></xsl:when>
			<xsl:when test="($code='0FK' or $code='238') and $lang = $secondLanguage"><xsl:text>Falkland Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0FK' or $code='238') and $lang != $secondLanguage"><xsl:text>Falklandy</xsl:text></xsl:when>
			<xsl:when test="($code='0FJ' or $code='242') and $lang = $secondLanguage"><xsl:text>Fiji</xsl:text></xsl:when>
			<xsl:when test="($code='0FJ' or $code='242') and $lang != $secondLanguage"><xsl:text>Fidżi</xsl:text></xsl:when>
			<xsl:when test="($code='0PH' or $code='608') and $lang = $secondLanguage"><xsl:text>Philippines</xsl:text></xsl:when>
			<xsl:when test="($code='0PH' or $code='608') and $lang != $secondLanguage"><xsl:text>Filipiny</xsl:text></xsl:when>
			<xsl:when test="($code='0FI' or $code='246') and $lang = $secondLanguage"><xsl:text>Finland</xsl:text></xsl:when>
			<xsl:when test="($code='0FI' or $code='246') and $lang != $secondLanguage"><xsl:text>Finlandia</xsl:text></xsl:when>
			<xsl:when test="($code='0FR' or $code='250') and $lang = $secondLanguage"><xsl:text>France</xsl:text></xsl:when>
			<xsl:when test="($code='0FR' or $code='250') and $lang != $secondLanguage"><xsl:text>Francja</xsl:text></xsl:when>
			<xsl:when test="($code='0TF' or $code='260') and $lang = $secondLanguage"><xsl:text>French Southern Territories</xsl:text></xsl:when>
			<xsl:when test="($code='0TF' or $code='260') and $lang != $secondLanguage"><xsl:text>Francuskie Terytoria Południowe i Antarktyczne</xsl:text></xsl:when>
			<xsl:when test="($code='0GA' or $code='266')"><xsl:text>Gabon</xsl:text></xsl:when>
			<xsl:when test="($code='0GM' or $code='270')"><xsl:text>Gambia</xsl:text></xsl:when>
			<xsl:when test="($code='0GS' or $code='239') and $lang = $secondLanguage"><xsl:text>South Georgia and the South Sandwich Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0GS' or $code='239') and $lang != $secondLanguage"><xsl:text>Georgia Południowa i Sandwich Południowy</xsl:text></xsl:when>
			<xsl:when test="($code='0GH' or $code='288')"><xsl:text>Ghana</xsl:text></xsl:when>
			<xsl:when test="($code='0GI' or $code='292')"><xsl:text>Gibraltar</xsl:text></xsl:when>
			<xsl:when test="($code='0GR' or $code='300') and $lang = $secondLanguage"><xsl:text>Greece</xsl:text></xsl:when>
			<xsl:when test="($code='0GR' or $code='300') and $lang != $secondLanguage"><xsl:text>Grecja</xsl:text></xsl:when>
			<xsl:when test="($code='0GD' or $code='308') and $lang = $secondLanguage"><xsl:text>Saint Vincent and the Grenadines</xsl:text></xsl:when>
			<xsl:when test="($code='0GD' or $code='308') and $lang != $secondLanguage"><xsl:text>Grenada</xsl:text></xsl:when>
			<xsl:when test="($code='0GL' or $code='304') and $lang = $secondLanguage"><xsl:text>Greenland</xsl:text></xsl:when>
			<xsl:when test="($code='0GL' or $code='304') and $lang != $secondLanguage"><xsl:text>Grenlandia</xsl:text></xsl:when>
			<xsl:when test="($code='0GE' or $code='268') and $lang = $secondLanguage"><xsl:text>Georgia</xsl:text></xsl:when>
			<xsl:when test="($code='0GE' or $code='268') and $lang != $secondLanguage"><xsl:text>Gruzja</xsl:text></xsl:when>
			<xsl:when test="($code='0GU' or $code='316')"><xsl:text>Guam</xsl:text></xsl:when>
			<xsl:when test="($code='0GG' or $code='831')"><xsl:text>Guernsey</xsl:text></xsl:when>
			<xsl:when test="($code='0GF' or $code='254') and $lang = $secondLanguage"><xsl:text>French Guiana</xsl:text></xsl:when>
			<xsl:when test="($code='0GF' or $code='254') and $lang != $secondLanguage"><xsl:text>Gujana Francuska</xsl:text></xsl:when>
			<xsl:when test="($code='0GY' or $code='328') and $lang = $secondLanguage"><xsl:text>Guyana</xsl:text></xsl:when>
			<xsl:when test="($code='0GY' or $code='328') and $lang != $secondLanguage"><xsl:text>Gujana</xsl:text></xsl:when>
			<xsl:when test="($code='0GP' or $code='312') and $lang = $secondLanguage"><xsl:text>Guadeloupe</xsl:text></xsl:when>
			<xsl:when test="($code='0GP' or $code='312') and $lang != $secondLanguage"><xsl:text>Gwadelupa</xsl:text></xsl:when>
			<xsl:when test="($code='0GT' or $code='320') and $lang = $secondLanguage"><xsl:text>Guatemala</xsl:text></xsl:when>
			<xsl:when test="($code='0GT' or $code='320') and $lang != $secondLanguage"><xsl:text>Gwatemala</xsl:text></xsl:when>
			<xsl:when test="($code='0GW' or $code='624') and $lang = $secondLanguage"><xsl:text>Guinea Bissau</xsl:text></xsl:when>
			<xsl:when test="($code='0GW' or $code='624') and $lang != $secondLanguage"><xsl:text>Gwinea Bissau</xsl:text></xsl:when>
			<xsl:when test="($code='0GQ' or $code='226') and $lang = $secondLanguage"><xsl:text>Equatorial Guinea</xsl:text></xsl:when>
			<xsl:when test="($code='0GQ' or $code='226') and $lang != $secondLanguage"><xsl:text>Gwinea Równikowa</xsl:text></xsl:when>
			<xsl:when test="($code='0GN' or $code='324') and $lang = $secondLanguage"><xsl:text>Guinea</xsl:text></xsl:when>
			<xsl:when test="($code='0GN' or $code='324') and $lang != $secondLanguage"><xsl:text>Gwinea</xsl:text></xsl:when>
			<xsl:when test="($code='0HT' or $code='332')"><xsl:text>Haiti</xsl:text></xsl:when>
			<xsl:when test="($code='0ES' or $code='724') and $lang = $secondLanguage"><xsl:text>Spain</xsl:text></xsl:when>
			<xsl:when test="($code='0ES' or $code='724') and $lang != $secondLanguage"><xsl:text>Hiszpania</xsl:text></xsl:when>
			<xsl:when test="($code='0NL' or $code='528') and $lang = $secondLanguage"><xsl:text>Netherlands</xsl:text></xsl:when>
			<xsl:when test="($code='0NL' or $code='528') and $lang != $secondLanguage"><xsl:text>Holandia</xsl:text></xsl:when>
			<xsl:when test="($code='0HN' or $code='340')"><xsl:text>Honduras</xsl:text></xsl:when>
			<xsl:when test="($code='0HK' or $code='344') and $lang = $secondLanguage"><xsl:text>Hong Kong</xsl:text></xsl:when>
			<xsl:when test="($code='0HK' or $code='344') and $lang != $secondLanguage"><xsl:text>Hongkong</xsl:text></xsl:when>
			<xsl:when test="($code='0IN' or $code='356') and $lang = $secondLanguage"><xsl:text>India</xsl:text></xsl:when>
			<xsl:when test="($code='0IN' or $code='356') and $lang != $secondLanguage"><xsl:text>Indie</xsl:text></xsl:when>
			<xsl:when test="($code='0ID' or $code='360') and $lang = $secondLanguage"><xsl:text>Indonesia</xsl:text></xsl:when>
			<xsl:when test="($code='0ID' or $code='360') and $lang != $secondLanguage"><xsl:text>Indonezja</xsl:text></xsl:when>
			<xsl:when test="($code='0IQ' or $code='368') and $lang = $secondLanguage"><xsl:text>Iraq</xsl:text></xsl:when>
			<xsl:when test="($code='0IQ' or $code='368') and $lang != $secondLanguage"><xsl:text>Irak</xsl:text></xsl:when>
			<xsl:when test="($code='0IR' or $code='364')"><xsl:text>Iran</xsl:text></xsl:when>
			<xsl:when test="($code='0IE' or $code='372') and $lang = $secondLanguage"><xsl:text>Ireland</xsl:text></xsl:when>
			<xsl:when test="($code='0IE' or $code='372') and $lang != $secondLanguage"><xsl:text>Irlandia</xsl:text></xsl:when>
			<xsl:when test="($code='0IS' or $code='352') and $lang = $secondLanguage"><xsl:text>Iceland</xsl:text></xsl:when>
			<xsl:when test="($code='0IS' or $code='352') and $lang != $secondLanguage"><xsl:text>Islandia</xsl:text></xsl:when>
			<xsl:when test="($code='0IL' or $code='376') and $lang = $secondLanguage"><xsl:text>Israel</xsl:text></xsl:when>
			<xsl:when test="($code='0IL' or $code='376') and $lang != $secondLanguage"><xsl:text>Izrael</xsl:text></xsl:when>
			<xsl:when test="($code='0JM' or $code='388') and $lang = $secondLanguage"><xsl:text>Jamaica</xsl:text></xsl:when>
			<xsl:when test="($code='0JM' or $code='388') and $lang != $secondLanguage"><xsl:text>Jamajka</xsl:text></xsl:when>
			<xsl:when test="($code='0JP' or $code='392') and $lang = $secondLanguage"><xsl:text>Japan</xsl:text></xsl:when>
			<xsl:when test="($code='0JP' or $code='392') and $lang != $secondLanguage"><xsl:text>Japonia</xsl:text></xsl:when>
			<xsl:when test="($code='0YE' or $code='887') and $lang = $secondLanguage"><xsl:text>Yemen</xsl:text></xsl:when>
			<xsl:when test="($code='0YE' or $code='887') and $lang != $secondLanguage"><xsl:text>Jemen</xsl:text></xsl:when>
			<xsl:when test="($code='0JE' or $code='832')"><xsl:text>Jersey</xsl:text></xsl:when>
			<xsl:when test="($code='0JO' or $code='400') and $lang = $secondLanguage"><xsl:text>Jordan</xsl:text></xsl:when>
			<xsl:when test="($code='0JO' or $code='400') and $lang != $secondLanguage"><xsl:text>Jordania</xsl:text></xsl:when>
			<xsl:when test="($code='0KY' or $code='136') and $lang = $secondLanguage"><xsl:text>Cayman Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0KY' or $code='136') and $lang != $secondLanguage"><xsl:text>Kajmany</xsl:text></xsl:when>
			<xsl:when test="($code='0KH' or $code='116') and $lang = $secondLanguage"><xsl:text>Cambodia</xsl:text></xsl:when>
			<xsl:when test="($code='0KH' or $code='116') and $lang != $secondLanguage"><xsl:text>Kambodża</xsl:text></xsl:when>
			<xsl:when test="($code='0CM' or $code='120') and $lang = $secondLanguage"><xsl:text>Cameroon</xsl:text></xsl:when>
			<xsl:when test="($code='0CM' or $code='120') and $lang != $secondLanguage"><xsl:text>Kamerun</xsl:text></xsl:when>
			<xsl:when test="($code='0CA' or $code='124') and $lang = $secondLanguage"><xsl:text>Canada</xsl:text></xsl:when>
			<xsl:when test="($code='0CA' or $code='124') and $lang != $secondLanguage"><xsl:text>Kanada</xsl:text></xsl:when>
			<xsl:when test="($code='0QA' or $code='634') and $lang = $secondLanguage"><xsl:text>Qatar</xsl:text></xsl:when>
			<xsl:when test="($code='0QA' or $code='634') and $lang != $secondLanguage"><xsl:text>Katar</xsl:text></xsl:when>
			<xsl:when test="($code='0KZ' or $code='398') and $lang = $secondLanguage"><xsl:text>Kazakhstan</xsl:text></xsl:when>
			<xsl:when test="($code='0KZ' or $code='398') and $lang != $secondLanguage"><xsl:text>Kazachstan</xsl:text></xsl:when>
			<xsl:when test="($code='0KE' or $code='404') and $lang = $secondLanguage"><xsl:text>Kenya</xsl:text></xsl:when>
			<xsl:when test="($code='0KE' or $code='404') and $lang != $secondLanguage"><xsl:text>Kenia</xsl:text></xsl:when>
			<xsl:when test="($code='0KG' or $code='417') and $lang = $secondLanguage"><xsl:text>Kyrgyzstan</xsl:text></xsl:when>
			<xsl:when test="($code='0KG' or $code='417') and $lang != $secondLanguage"><xsl:text>Kirgistan</xsl:text></xsl:when>
			<xsl:when test="($code='0KI' or $code='296')"><xsl:text>Kiribati</xsl:text></xsl:when>
			<xsl:when test="($code='0CO' or $code='170') and $lang = $secondLanguage"><xsl:text>Colombia</xsl:text></xsl:when>
			<xsl:when test="($code='0CO' or $code='170') and $lang != $secondLanguage"><xsl:text>Kolumbia</xsl:text></xsl:when>
			<xsl:when test="($code='0KM' or $code='174') and $lang = $secondLanguage"><xsl:text>Comoros</xsl:text></xsl:when>
			<xsl:when test="($code='0KM' or $code='174') and $lang != $secondLanguage"><xsl:text>Komory</xsl:text></xsl:when>
			<xsl:when test="($code='0CG' or $code='178') and $lang = $secondLanguage"><xsl:text>Congo</xsl:text></xsl:when>
			<xsl:when test="($code='0CG' or $code='178') and $lang != $secondLanguage"><xsl:text>Kongo</xsl:text></xsl:when>
			<xsl:when test="($code='0KR' or $code='410') and $lang = $secondLanguage"><xsl:text>South Korea</xsl:text></xsl:when>
			<xsl:when test="($code='0KR' or $code='410') and $lang != $secondLanguage"><xsl:text>Korea Południowa</xsl:text></xsl:when>
			<xsl:when test="($code='0KP' or $code='408') and $lang = $secondLanguage"><xsl:text>North Korea</xsl:text></xsl:when>
			<xsl:when test="($code='0KP' or $code='408') and $lang != $secondLanguage"><xsl:text>Korea Północna</xsl:text></xsl:when>
			<xsl:when test="($code='0CR' or $code='188') and $lang = $secondLanguage"><xsl:text>Costa Rica</xsl:text></xsl:when>
			<xsl:when test="($code='0CR' or $code='188') and $lang != $secondLanguage"><xsl:text>Kostaryka</xsl:text></xsl:when>
			<xsl:when test="($code='0CU' or $code='192') and $lang = $secondLanguage"><xsl:text>Cuba</xsl:text></xsl:when>
			<xsl:when test="($code='0CU' or $code='192') and $lang != $secondLanguage"><xsl:text>Kuba</xsl:text></xsl:when>
			<xsl:when test="($code='0KW' or $code='414') and $lang = $secondLanguage"><xsl:text>Kuwait</xsl:text></xsl:when>
			<xsl:when test="($code='0KW' or $code='414') and $lang != $secondLanguage"><xsl:text>Kuwejt</xsl:text></xsl:when>
			<xsl:when test="($code='0LA' or $code='418')"><xsl:text>Laos</xsl:text></xsl:when>
			<xsl:when test="($code='0LS' or $code='426')"><xsl:text>Lesotho</xsl:text></xsl:when>
			<xsl:when test="($code='0LB' or $code='422') and $lang = $secondLanguage"><xsl:text>Lebanon</xsl:text></xsl:when>
			<xsl:when test="($code='0LB' or $code='422') and $lang != $secondLanguage"><xsl:text>Liban</xsl:text></xsl:when>
			<xsl:when test="($code='0LR' or $code='430')"><xsl:text>Liberia</xsl:text></xsl:when>
			<xsl:when test="($code='0LY' or $code='434') and $lang = $secondLanguage"><xsl:text>Lybia</xsl:text></xsl:when>
			<xsl:when test="($code='0LY' or $code='434') and $lang != $secondLanguage"><xsl:text>Libia</xsl:text></xsl:when>
			<xsl:when test="($code='0LI' or $code='438')"><xsl:text>Liechtenstein</xsl:text></xsl:when>
			<xsl:when test="($code='0LT' or $code='440') and $lang = $secondLanguage"><xsl:text>Lithuania</xsl:text></xsl:when>
			<xsl:when test="($code='0LT' or $code='440') and $lang != $secondLanguage"><xsl:text>Litwa</xsl:text></xsl:when>
			<xsl:when test="($code='0LU' or $code='442') and $lang = $secondLanguage"><xsl:text>Luxembourg</xsl:text></xsl:when>
			<xsl:when test="($code='0LU' or $code='442') and $lang != $secondLanguage"><xsl:text>Luksemburg</xsl:text></xsl:when>
			<xsl:when test="($code='0LV' or $code='428') and $lang = $secondLanguage"><xsl:text>Latvia</xsl:text></xsl:when>
			<xsl:when test="($code='0LV' or $code='428') and $lang != $secondLanguage"><xsl:text>Łotwa</xsl:text></xsl:when>
			<xsl:when test="($code='0MK' or $code='807')"><xsl:text>Macedonia</xsl:text></xsl:when>
			<xsl:when test="($code='0MG' or $code='450') and $lang = $secondLanguage"><xsl:text>Madagascar</xsl:text></xsl:when>
			<xsl:when test="($code='0MG' or $code='450') and $lang != $secondLanguage"><xsl:text>Madagaskar</xsl:text></xsl:when>
			<xsl:when test="($code='0YT' or $code='175') and $lang = $secondLanguage"><xsl:text>Mayotte</xsl:text></xsl:when>
			<xsl:when test="($code='0YT' or $code='175') and $lang != $secondLanguage"><xsl:text>Majotta</xsl:text></xsl:when>
			<xsl:when test="($code='0MO' or $code='446') and $lang = $secondLanguage"><xsl:text>Macao</xsl:text></xsl:when>
			<xsl:when test="($code='0MO' or $code='446') and $lang != $secondLanguage"><xsl:text>Makau</xsl:text></xsl:when>
			<xsl:when test="($code='0MW' or $code='454')"><xsl:text>Malawi</xsl:text></xsl:when>
			<xsl:when test="($code='0MV' or $code='462') and $lang = $secondLanguage"><xsl:text>Maldives</xsl:text></xsl:when>
			<xsl:when test="($code='0MV' or $code='462') and $lang != $secondLanguage"><xsl:text>Malediwy</xsl:text></xsl:when>
			<xsl:when test="($code='0MY' or $code='458') and $lang = $secondLanguage"><xsl:text>Malaysia</xsl:text></xsl:when>
			<xsl:when test="($code='0MY' or $code='458') and $lang != $secondLanguage"><xsl:text>Malezja</xsl:text></xsl:when>
			<xsl:when test="($code='0ML' or $code='466')"><xsl:text>Mali</xsl:text></xsl:when>
			<xsl:when test="($code='0MT' or $code='470')"><xsl:text>Malta</xsl:text></xsl:when>
			<xsl:when test="($code='0MP' or $code='580') and $lang = $secondLanguage"><xsl:text>Northern Mariana Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0MP' or $code='580') and $lang != $secondLanguage"><xsl:text>Mariany Północne</xsl:text></xsl:when>
			<xsl:when test="($code='0MA' or $code='504') and $lang = $secondLanguage"><xsl:text>Morocco</xsl:text></xsl:when>
			<xsl:when test="($code='0MA' or $code='504') and $lang != $secondLanguage"><xsl:text>Maroko</xsl:text></xsl:when>
			<xsl:when test="($code='0MQ' or $code='474') and $lang = $secondLanguage"><xsl:text>Martinique</xsl:text></xsl:when>
			<xsl:when test="($code='0MQ' or $code='474') and $lang != $secondLanguage"><xsl:text>Martynika</xsl:text></xsl:when>
			<xsl:when test="($code='0MR' or $code='478') and $lang = $secondLanguage"><xsl:text>Mauritania</xsl:text></xsl:when>
			<xsl:when test="($code='0MR' or $code='478') and $lang != $secondLanguage"><xsl:text>Mauretania</xsl:text></xsl:when>
			<xsl:when test="($code='0MU' or $code='480')"><xsl:text>Mauritius</xsl:text></xsl:when>
			<xsl:when test="($code='0MX' or $code='484') and $lang = $secondLanguage"><xsl:text>Mexico</xsl:text></xsl:when>
			<xsl:when test="($code='0MX' or $code='484') and $lang != $secondLanguage"><xsl:text>Meksyk</xsl:text></xsl:when>
			<xsl:when test="($code='0FM' or $code='583') and $lang = $secondLanguage"><xsl:text>Fedarated States of Micronesia</xsl:text></xsl:when>
			<xsl:when test="($code='0FM' or $code='583') and $lang != $secondLanguage"><xsl:text>Mikronezja</xsl:text></xsl:when>
			<xsl:when test="($code='0MM' or $code='104') and $lang = $secondLanguage"><xsl:text>Myanmar</xsl:text></xsl:when>
			<xsl:when test="($code='0MM' or $code='104') and $lang != $secondLanguage"><xsl:text>Mjanma</xsl:text></xsl:when>
			<xsl:when test="($code='0MD' or $code='498') and $lang = $secondLanguage"><xsl:text>Moldova</xsl:text></xsl:when>
			<xsl:when test="($code='0MD' or $code='498') and $lang != $secondLanguage"><xsl:text>Mołdawia</xsl:text></xsl:when>
			<xsl:when test="($code='0MC' or $code='492') and $lang = $secondLanguage"><xsl:text>Monaco</xsl:text></xsl:when>
			<xsl:when test="($code='0MC' or $code='492') and $lang != $secondLanguage"><xsl:text>Monako</xsl:text></xsl:when>
			<xsl:when test="($code='0MN' or $code='496')"><xsl:text>Mongolia</xsl:text></xsl:when>
			<xsl:when test="($code='0MS' or $code='500')"><xsl:text>Montserrat</xsl:text></xsl:when>
			<xsl:when test="($code='0MZ' or $code='508') and $lang = $secondLanguage"><xsl:text>Mozambique</xsl:text></xsl:when>
			<xsl:when test="($code='0MZ' or $code='508') and $lang != $secondLanguage"><xsl:text>Mozambik</xsl:text></xsl:when>
			<xsl:when test="($code='0NA' or $code='516')"><xsl:text>Namibia</xsl:text></xsl:when>
			<xsl:when test="($code='0NR' or $code='520')"><xsl:text>Nauru</xsl:text></xsl:when>
			<xsl:when test="($code='0NP' or $code='524')"><xsl:text>Nepal</xsl:text></xsl:when>
			<xsl:when test="($code='0DE' or $code='276') and $lang = $secondLanguage"><xsl:text>Germany</xsl:text></xsl:when>
			<xsl:when test="($code='0DE' or $code='276') and $lang != $secondLanguage"><xsl:text>Niemcy</xsl:text></xsl:when>
			<xsl:when test="($code='0NE' or $code='562')"><xsl:text>Niger</xsl:text></xsl:when>
			<xsl:when test="($code='0NG' or $code='566')"><xsl:text>Nigeria</xsl:text></xsl:when>
			<xsl:when test="($code='0NI' or $code='558') and $lang = $secondLanguage"><xsl:text>Nicaragua</xsl:text></xsl:when>
			<xsl:when test="($code='0NI' or $code='558') and $lang != $secondLanguage"><xsl:text>Nikaragua</xsl:text></xsl:when>
			<xsl:when test="($code='0NU' or $code='570')"><xsl:text>Niue</xsl:text></xsl:when>
			<xsl:when test="($code='0NF' or $code='574') and $lang = $secondLanguage"><xsl:text>Norfolk Island</xsl:text></xsl:when>
			<xsl:when test="($code='0NF' or $code='574') and $lang != $secondLanguage"><xsl:text>Norfolk</xsl:text></xsl:when>
			<xsl:when test="($code='0NO' or $code='578') and $lang = $secondLanguage"><xsl:text>Norway</xsl:text></xsl:when>
			<xsl:when test="($code='0NO' or $code='578') and $lang != $secondLanguage"><xsl:text>Norwegia</xsl:text></xsl:when>
			<xsl:when test="($code='0NC' or $code='540') and $lang = $secondLanguage"><xsl:text>New Caledonia</xsl:text></xsl:when>
			<xsl:when test="($code='0NC' or $code='540') and $lang != $secondLanguage"><xsl:text>Nowa Kaledonia</xsl:text></xsl:when>
			<xsl:when test="($code='0NZ' or $code='554') and $lang = $secondLanguage"><xsl:text>New Zealand</xsl:text></xsl:when>
			<xsl:when test="($code='0NZ' or $code='554') and $lang != $secondLanguage"><xsl:text>Nowa Zelandia</xsl:text></xsl:when>
			<xsl:when test="($code='0OM' or $code='512')"><xsl:text>Oman</xsl:text></xsl:when>
			<xsl:when test="($code='0PK' or $code='586')"><xsl:text>Pakistan</xsl:text></xsl:when>
			<xsl:when test="($code='0PW' or $code='585')"><xsl:text>Palau</xsl:text></xsl:when>
			<xsl:when test="($code='0PS' or $code='275') and $lang = $secondLanguage"><xsl:text>Palestine</xsl:text></xsl:when>
			<xsl:when test="($code='0PS' or $code='275') and $lang != $secondLanguage"><xsl:text>Palestyna</xsl:text></xsl:when>
			<xsl:when test="($code='0PA' or $code='591')"><xsl:text>Panama</xsl:text></xsl:when>
			<xsl:when test="($code='0PG' or $code='598') and $lang = $secondLanguage"><xsl:text>Papua New Guinea</xsl:text></xsl:when>
			<xsl:when test="($code='0PG' or $code='598') and $lang != $secondLanguage"><xsl:text>Papua-Nowa Gwinea</xsl:text></xsl:when>
			<xsl:when test="($code='0PY' or $code='600') and $lang = $secondLanguage"><xsl:text>Paraguay</xsl:text></xsl:when>
			<xsl:when test="($code='0PY' or $code='600') and $lang != $secondLanguage"><xsl:text>Paragwaj</xsl:text></xsl:when>
			<xsl:when test="($code='0PE' or $code='604')"><xsl:text>Peru</xsl:text></xsl:when>
			<xsl:when test="($code='0PN' or $code='612')"><xsl:text>Pitcairn</xsl:text></xsl:when>
			<xsl:when test="($code='0PF' or $code='258') and $lang = $secondLanguage"><xsl:text>French Polynesia</xsl:text></xsl:when>
			<xsl:when test="($code='0PF' or $code='258') and $lang != $secondLanguage"><xsl:text>Polinezja Francuska</xsl:text></xsl:when>
			<xsl:when test="($code='0PL' or $code='616') and $lang = $secondLanguage"><xsl:text>Poland</xsl:text></xsl:when>
			<xsl:when test="($code='0PL' or $code='616') and $lang != $secondLanguage"><xsl:text>Polska</xsl:text></xsl:when>
			<xsl:when test="($code='0PR' or $code='630') and $lang = $secondLanguage"><xsl:text>Puerto Rico</xsl:text></xsl:when>
			<xsl:when test="($code='0PR' or $code='630')"><xsl:text>Portoryko</xsl:text></xsl:when>
			<xsl:when test="($code='0PT' or $code='620') and $lang = $secondLanguage"><xsl:text>Portugal</xsl:text></xsl:when>
			<xsl:when test="($code='0PT' or $code='620') and $lang != $secondLanguage"><xsl:text>Portugalia</xsl:text></xsl:when>
			<xsl:when test="($code='0ZA' or $code='710') and $lang = $secondLanguage"><xsl:text>South Africa</xsl:text></xsl:when>
			<xsl:when test="($code='0ZA' or $code='710') and $lang != $secondLanguage"><xsl:text>Republika Południowej Afryki</xsl:text></xsl:when>
			<xsl:when test="($code='0CF' or $code='140') and $lang = $secondLanguage"><xsl:text>Central African Republic</xsl:text></xsl:when>
			<xsl:when test="($code='0CF' or $code='140') and $lang != $secondLanguage"><xsl:text>Republika Środkowoafrykańska</xsl:text></xsl:when>
			<xsl:when test="($code='0CV' or $code='132') and $lang = $secondLanguage"><xsl:text>Cape Verde</xsl:text></xsl:when>
			<xsl:when test="($code='0CV' or $code='132') and $lang != $secondLanguage"><xsl:text>Republika Zielonego Przylądka</xsl:text></xsl:when>
			<xsl:when test="($code='0RE' or $code='638')"><xsl:text>Réunion</xsl:text></xsl:when>
			<xsl:when test="($code='0RU' or $code='643') and $lang = $secondLanguage"><xsl:text>Russian Federation</xsl:text></xsl:when>
			<xsl:when test="($code='0RU' or $code='643') and $lang != $secondLanguage"><xsl:text>Rosja</xsl:text></xsl:when>
			<xsl:when test="($code='0RO' or $code='642') and $lang = $secondLanguage"><xsl:text>Romania</xsl:text></xsl:when>
			<xsl:when test="($code='0RO' or $code='642') and $lang != $secondLanguage"><xsl:text>Rumunia</xsl:text></xsl:when>
			<xsl:when test="($code='0RW' or $code='646')"><xsl:text>Rwanda</xsl:text></xsl:when>
			<xsl:when test="($code='0EH' or $code='732') and $lang = $secondLanguage"><xsl:text>Western Sahara</xsl:text></xsl:when>
			<xsl:when test="($code='0EH' or $code='732') and $lang != $secondLanguage"><xsl:text>Sahara Zachodnia</xsl:text></xsl:when>
			<xsl:when test="($code='0KN' or $code='659')"><xsl:text>Saint Kitts i Nevis</xsl:text></xsl:when>
			<xsl:when test="($code='0LC' or $code='662')"><xsl:text>Saint Lucia</xsl:text></xsl:when>
			<xsl:when test="($code='0VC' or $code='670')"><xsl:text>Saint Vincent i Grenadyny</xsl:text></xsl:when>
			<xsl:when test="($code='0BL' or $code='652')"><xsl:text>Saint-Barthélemy</xsl:text></xsl:when>
			<xsl:when test="($code='0MF' or $code='663')"><xsl:text>Saint-Martin</xsl:text></xsl:when>
			<xsl:when test="($code='0PM' or $code='666') and $lang = $secondLanguage"><xsl:text>Saint Pierre and Miquelon</xsl:text></xsl:when>
			<xsl:when test="($code='0PM' or $code='666') and $lang != $secondLanguage"><xsl:text>Saint-Pierre Miquelon</xsl:text></xsl:when>
			<xsl:when test="($code='0SV' or $code='222') and $lang = $secondLanguage"><xsl:text>El Salvador</xsl:text></xsl:when>
			<xsl:when test="($code='0SV' or $code='222') and $lang != $secondLanguage"><xsl:text>Salwador</xsl:text></xsl:when>
			<xsl:when test="($code='0AS' or $code='016') and $lang = $secondLanguage"><xsl:text>Amerikan Samoa</xsl:text></xsl:when>
			<xsl:when test="($code='0AS' or $code='016') and $lang != $secondLanguage"><xsl:text>Samoa Amerykańskie</xsl:text></xsl:when>
			<xsl:when test="($code='0WS' or $code='882')"><xsl:text>Samoa</xsl:text></xsl:when>
			<xsl:when test="($code='0SM' or $code='674')"><xsl:text>San Marino</xsl:text></xsl:when>
			<xsl:when test="($code='0SN' or $code='686')"><xsl:text>Senegal</xsl:text></xsl:when>
			<xsl:when test="($code='0RS' or $code='688')"><xsl:text>Serbia</xsl:text></xsl:when>
			<xsl:when test="($code='0SC' or $code='690') and $lang = $secondLanguage"><xsl:text>Seychelles</xsl:text></xsl:when>
			<xsl:when test="($code='0SC' or $code='690') and $lang != $secondLanguage"><xsl:text>Seszele</xsl:text></xsl:when>
			<xsl:when test="($code='0SL' or $code='694')"><xsl:text>Sierra Leone</xsl:text></xsl:when>
			<xsl:when test="($code='0SG' or $code='702') and $lang = $secondLanguage"><xsl:text>Singapore</xsl:text></xsl:when>
			<xsl:when test="($code='0SG' or $code='702') and $lang != $secondLanguage"><xsl:text>Singapur</xsl:text></xsl:when>
			<xsl:when test="($code='0SX' or $code='534')"><xsl:text>Sint Maarten</xsl:text></xsl:when>
			<xsl:when test="($code='0SK' or $code='703') and $lang = $secondLanguage"><xsl:text>Slovakia</xsl:text></xsl:when>
			<xsl:when test="($code='0SK' or $code='703') and $lang != $secondLanguage"><xsl:text>Słowacja</xsl:text></xsl:when>
			<xsl:when test="($code='0SI' or $code='705') and $lang = $secondLanguage"><xsl:text>Slovenia</xsl:text></xsl:when>
			<xsl:when test="($code='0SI' or $code='705') and $lang != $secondLanguage"><xsl:text>Słowenia</xsl:text></xsl:when>
			<xsl:when test="($code='0SO' or $code='706')"><xsl:text>Somalia</xsl:text></xsl:when>
			<xsl:when test="($code='0LK' or $code='144')"><xsl:text>Sri Lanka</xsl:text></xsl:when>
			<xsl:when test="($code='0US' or $code='840') and $lang = $secondLanguage"><xsl:text>United States of America</xsl:text></xsl:when>
			<xsl:when test="($code='0US' or $code='840') and $lang != $secondLanguage"><xsl:text>Stany Zjednoczone</xsl:text></xsl:when>
			<xsl:when test="($code='0SZ' or $code='748') and $lang = $secondLanguage"><xsl:text>Eswatini</xsl:text></xsl:when>
			<xsl:when test="($code='0SZ' or $code='748') and $lang != $secondLanguage"><xsl:text>Suazi</xsl:text></xsl:when>
			<xsl:when test="($code='0SD' or $code='729')"><xsl:text>Sudan</xsl:text></xsl:when>
			<xsl:when test="($code='0SS' or $code='728') and $lang = $secondLanguage"><xsl:text>South Sudan</xsl:text></xsl:when>
			<xsl:when test="($code='0SS' or $code='728') and $lang != $secondLanguage"><xsl:text>Sudan Południowy</xsl:text></xsl:when>
			<xsl:when test="($code='0SR' or $code='740') and $lang = $secondLanguage"><xsl:text>Suriname</xsl:text></xsl:when>
			<xsl:when test="($code='0SR' or $code='740') and $lang != $secondLanguage"><xsl:text>Surinam</xsl:text></xsl:when>
			<xsl:when test="($code='0SJ' or $code='744') and $lang = $secondLanguage"><xsl:text>Svalbard and Jan Mayen</xsl:text></xsl:when>
			<xsl:when test="($code='0SJ' or $code='744') and $lang != $secondLanguage"><xsl:text>Svalbard i Jan Mayen</xsl:text></xsl:when>
			<xsl:when test="($code='0SY' or $code='760')"><xsl:text>Syria</xsl:text></xsl:when>
			<xsl:when test="($code='0CH' or $code='756') and $lang = $secondLanguage"><xsl:text>Switzerland</xsl:text></xsl:when>
			<xsl:when test="($code='0CH' or $code='756') and $lang != $secondLanguage"><xsl:text>Szwajcaria</xsl:text></xsl:when>
			<xsl:when test="($code='0SE' or $code='752') and $lang = $secondLanguage"><xsl:text>Sweden</xsl:text></xsl:when>
			<xsl:when test="($code='0SE' or $code='752') and $lang != $secondLanguage"><xsl:text>Szwecja</xsl:text></xsl:when>
			<xsl:when test="($code='0TJ' or $code='762') and $lang = $secondLanguage"><xsl:text>Tajikistan</xsl:text></xsl:when>
			<xsl:when test="($code='0TJ' or $code='762') and $lang != $secondLanguage"><xsl:text>Tadżykistan</xsl:text></xsl:when>
			<xsl:when test="($code='0TH' or $code='764') and $lang = $secondLanguage"><xsl:text>Thailand</xsl:text></xsl:when>
			<xsl:when test="($code='0TH' or $code='764') and $lang != $secondLanguage"><xsl:text>Tajlandia</xsl:text></xsl:when>
			<xsl:when test="($code='0TW' or $code='158') and $lang = $secondLanguage"><xsl:text>Taiwan</xsl:text></xsl:when>
			<xsl:when test="($code='0TW' or $code='158') and $lang != $secondLanguage"><xsl:text>Tajwan</xsl:text></xsl:when>
			<xsl:when test="($code='0TZ' or $code='834')"><xsl:text>Tanzania</xsl:text></xsl:when>
			<xsl:when test="($code='0TZ' or $code='626') and $lang = $secondLanguage"><xsl:text>Timor-Leste</xsl:text></xsl:when>
			<xsl:when test="($code='0TL' or $code='626') and $lang != $secondLanguage"><xsl:text>Timor Wschodni</xsl:text></xsl:when>
			<xsl:when test="($code='0TG' or $code='768')"><xsl:text>Togo</xsl:text></xsl:when>
			<xsl:when test="($code='0TK' or $code='772')"><xsl:text>Tokelau</xsl:text></xsl:when>
			<xsl:when test="($code='0TO' or $code='776')"><xsl:text>Tonga</xsl:text></xsl:when>
			<xsl:when test="($code='0TT' or $code='780') and $lang = $secondLanguage"><xsl:text>Trinidad and Tobago</xsl:text></xsl:when>
			<xsl:when test="($code='0TT' or $code='780') and $lang != $secondLanguage"><xsl:text>Trynidad i Tobago</xsl:text></xsl:when>
			<xsl:when test="($code='0TN' or $code='788') and $lang = $secondLanguage"><xsl:text>Tunisia</xsl:text></xsl:when>
			<xsl:when test="($code='0TN' or $code='788') and $lang != $secondLanguage"><xsl:text>Tunezja</xsl:text></xsl:when>
			<xsl:when test="($code='0TR' or $code='792') and $lang = $secondLanguage"><xsl:text>Turkey</xsl:text></xsl:when>
			<xsl:when test="($code='0TR' or $code='792') and $lang != $secondLanguage"><xsl:text>Turcja</xsl:text></xsl:when>
			<xsl:when test="($code='0TM' or $code='795')"><xsl:text>Turkmenistan</xsl:text></xsl:when>
			<xsl:when test="($code='0TC' or $code='796') and $lang = $secondLanguage"><xsl:text>Turks and Caicos Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0TC' or $code='796') and $lang != $secondLanguage"><xsl:text>Turks i Caicos</xsl:text></xsl:when>
			<xsl:when test="($code='0TV' or $code='798')"><xsl:text>Tuvalu</xsl:text></xsl:when>
			<xsl:when test="($code='0UG' or $code='800')"><xsl:text>Uganda</xsl:text></xsl:when>
			<xsl:when test="($code='0UA' or $code='804') and $lang = $secondLanguage"><xsl:text>Ukraine</xsl:text></xsl:when>
			<xsl:when test="($code='0UA' or $code='804') and $lang != $secondLanguage"><xsl:text>Ukraina</xsl:text></xsl:when>
			<xsl:when test="($code='0UY' or $code='858') and $lang = $secondLanguage"><xsl:text>Uruguay</xsl:text></xsl:when>
			<xsl:when test="($code='0UY' or $code='858') and $lang != $secondLanguage"><xsl:text>Urugwaj</xsl:text></xsl:when>
			<xsl:when test="($code='0UZ' or $code='860')"><xsl:text>Uzbekistan</xsl:text></xsl:when>
			<xsl:when test="($code='0VU' or $code='548')"><xsl:text>Vanuatu</xsl:text></xsl:when>
			<xsl:when test="($code='0WF' or $code='876') and $lang = $secondLanguage"><xsl:text>Wallis and Futuna</xsl:text></xsl:when>
			<xsl:when test="($code='0WF' or $code='876') and $lang != $secondLanguage"><xsl:text>Wallis i Futuna</xsl:text></xsl:when>
			<xsl:when test="($code='0VA' or $code='336') and $lang = $secondLanguage"><xsl:text>Holy See</xsl:text></xsl:when>
			<xsl:when test="($code='0VA' or $code='336') and $lang != $secondLanguage"><xsl:text>Watykan</xsl:text></xsl:when>
			<xsl:when test="($code='0VE' or $code='862') and $lang = $secondLanguage"><xsl:text>Venezuela</xsl:text></xsl:when>
			<xsl:when test="($code='0VE' or $code='862') and $lang != $secondLanguage"><xsl:text>Wenezuela</xsl:text></xsl:when>
			<xsl:when test="($code='0HU' or $code='348') and $lang = $secondLanguage"><xsl:text>Hungary</xsl:text></xsl:when>
			<xsl:when test="($code='0HU' or $code='348') and $lang != $secondLanguage"><xsl:text>Węgry</xsl:text></xsl:when>
			<xsl:when test="($code='0GB' or $code='826') and $lang = $secondLanguage"><xsl:text>United Kingdom</xsl:text></xsl:when>
			<xsl:when test="($code='0GB' or $code='826') and $lang != $secondLanguage"><xsl:text>Wielka Brytania</xsl:text></xsl:when>
			<xsl:when test="($code='0VN' or $code='704') and $lang = $secondLanguage"><xsl:text>Viet Nam</xsl:text></xsl:when>
			<xsl:when test="($code='0VN' or $code='704') and $lang != $secondLanguage"><xsl:text>Wietnam</xsl:text></xsl:when>
			<xsl:when test="($code='0IT' or $code='380') and $lang = $secondLanguage"><xsl:text>Italy</xsl:text></xsl:when>
			<xsl:when test="($code='0IT' or $code='380') and $lang != $secondLanguage"><xsl:text>Włochy</xsl:text></xsl:when>
			<xsl:when test="($code='0CI' or $code='384') and $lang = $secondLanguage"><xsl:text>Côte d'Ivoire</xsl:text></xsl:when>
			<xsl:when test="($code='0CI' or $code='384') and $lang != $secondLanguage"><xsl:text>Wybrzeże Kości Słoniowej</xsl:text></xsl:when>
			<xsl:when test="($code='0BV' or $code='074') and $lang = $secondLanguage"><xsl:text>Bouvet Island</xsl:text></xsl:when>
			<xsl:when test="($code='0BV' or $code='074')"><xsl:text>Wyspa Bouveta</xsl:text></xsl:when>
			<xsl:when test="($code='0CX' or $code='162') and $lang = $secondLanguage"><xsl:text>Christmas Island</xsl:text></xsl:when>
			<xsl:when test="($code='0CX' or $code='162') and $lang != $secondLanguage"><xsl:text>Wyspa Bożego Narodzenia</xsl:text></xsl:when>
			<xsl:when test="($code='0IM' or $code='833') and $lang = $secondLanguage"><xsl:text>Isle of Man</xsl:text></xsl:when>
			<xsl:when test="($code='0IM' or $code='833') and $lang != $secondLanguage"><xsl:text>Wyspa Man</xsl:text></xsl:when>
			<xsl:when test="($code='0SH' or $code='654') and $lang = $secondLanguage"><xsl:text>Saint Helena, Ascension and Tristan da Cunha</xsl:text></xsl:when>
			<xsl:when test="($code='0SH' or $code='654') and $lang != $secondLanguage"><xsl:text>Wyspa Świętej Heleny, Wyspa Wniebowstąpienia i Tristan da Cunha</xsl:text></xsl:when>
			<xsl:when test="($code='0AX' or $code='248')"><xsl:text>Wyspy Alandzkie</xsl:text></xsl:when>
			<xsl:when test="($code='0CK' or $code='184') and $lang = $secondLanguage"><xsl:text>Cook Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0CK' or $code='184') and $lang != $secondLanguage"><xsl:text>Wyspy Cooka</xsl:text></xsl:when>
			<xsl:when test="($code='0VI' or $code='850') and $lang = $secondLanguage"><xsl:text>Virgin Islands, U.S.</xsl:text></xsl:when>
			<xsl:when test="($code='0VI' or $code='850') and $lang != $secondLanguage"><xsl:text>Wyspy Dziewicze Stanów Zjednoczonych</xsl:text></xsl:when>
			<xsl:when test="($code='0HN' or $code='334') and $lang = $secondLanguage"><xsl:text>Heard Island and McDonald Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0HN' or $code='334') and $lang != $secondLanguage"><xsl:text>Wyspy Heard i McDonalda</xsl:text></xsl:when>
			<xsl:when test="($code='0CC' or $code='166') and $lang = $secondLanguage"><xsl:text>Cocos Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0CC' or $code='166') and $lang != $secondLanguage"><xsl:text>Wyspy Kokosowe</xsl:text></xsl:when>
			<xsl:when test="($code='0MH' or $code='584') and $lang = $secondLanguage"><xsl:text>Marshall Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0MH' or $code='584') and $lang != $secondLanguage"><xsl:text>Wyspy Marshalla</xsl:text></xsl:when>
			<xsl:when test="($code='0FO' or $code='234') and $lang = $secondLanguage"><xsl:text>Faroe Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0FO' or $code='234') and $lang != $secondLanguage"><xsl:text>Wyspy Owcze</xsl:text></xsl:when>
			<xsl:when test="($code='0SB' or $code='090') and $lang = $secondLanguage"><xsl:text>Solomon Islands</xsl:text></xsl:when>
			<xsl:when test="($code='0SB' or $code='090') and $lang != $secondLanguage"><xsl:text>Wyspy Salomona</xsl:text></xsl:when>
			<xsl:when test="($code='0ST' or $code='678') and $lang = $secondLanguage"><xsl:text>Sao Tome and Principe</xsl:text></xsl:when>
			<xsl:when test="($code='0ST' or $code='678') and $lang != $secondLanguage"><xsl:text>Wyspy Świętego Tomasza i Książęca</xsl:text></xsl:when>
			<xsl:when test="($code='0ZM' or $code='894')"><xsl:text>Zambia</xsl:text></xsl:when>
			<xsl:when test="($code='0ZW' or $code='716')"><xsl:text>Zimbabwe</xsl:text></xsl:when>
			<xsl:when test="($code='0AE' or $code='784') and $lang = $secondLanguage"><xsl:text>United Arab Emirates</xsl:text></xsl:when>
			<xsl:when test="($code='0AE' or $code='784') and $lang != $secondLanguage"><xsl:text>Zjednoczone Emiraty Arabskie</xsl:text></xsl:when>
			<xsl:when test="$lang = $secondLanguage"><xsl:text>Unrecognized country code: </xsl:text><xsl:value-of select="$code"/></xsl:when>
			<xsl:otherwise><xsl:text>Kod kraju nieznany: </xsl:text><xsl:value-of select="$code"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="fillUpToThreeChars">
		<xsl:param name="code"/>
		<xsl:choose>
			<xsl:when test="string-length($code) = 3">
				<xsl:value-of select="$code"/>
			</xsl:when>
			<xsl:when test="string-length($code) = 2">
				<xsl:text>0</xsl:text>
				<xsl:value-of select="$code"/>
			</xsl:when>
			<xsl:when test="string-length($code) = 1">
				<xsl:text>00</xsl:text>
				<xsl:value-of select="$code"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- kod kraju nieznany -->
				<xsl:value-of select="$code"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- przykład translacji wartości słownika, zaniechano implementacji
		słownik jest zmienny w czasie, należy umieszczać displayName w dokumencie
		<xsl:template name="translateZawodMedycznyValueSet">
		<xsl:param name="code"/>
		
		<xsl:choose>
			<xsl:when test="$code='LEK'">
				<xsl:text>Lekarz</xsl:text>
			</xsl:when>
			<xsl:when test="$code='FEL'">
				<xsl:text>Felczer</xsl:text>
			</xsl:when>
			<xsl:when test="$code='LEKD'">
				<xsl:text>Lekarz dentysta</xsl:text>
			</xsl:when>
			<xsl:when test="$code='PIEL'">
				<xsl:text>Pielęgniarka</xsl:text>
			</xsl:when>
			<xsl:when test="$code='POL'">
				<xsl:text>Położna</xsl:text>
			</xsl:when>
			<xsl:when test="$code='FARM'">
				<xsl:text>Farmaceuta</xsl:text>
			</xsl:when>
			<xsl:when test="$code='DLAB'">
				<xsl:text>Diagnosta laboratoryjny</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template> -->
	
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++ POMOCNICZE +++++++++++++++++++++++++++++++++++++++++++++++++++++-->
	<!-- pierwiastek kwadratowy na potrzeby SVG (Sean B. Durkin) -->
	<xsl:template name="squareOfPositive">
		<xsl:param name="x"/>
		<xsl:choose>
			<xsl:when test="$x > 1">
				<xsl:call-template name="iterate-root">
					<xsl:with-param name="x" select="$x" />
					<xsl:with-param name="H" select="$x" />
					<xsl:with-param name="L" select="0" />
				</xsl:call-template>  
			</xsl:when>  
			<xsl:when test="($x = 1) or ($x &lt;= 0)">
				<xsl:value-of select="$x" />
			</xsl:when>  
			<xsl:otherwise>
				<xsl:variable name="inv-root">
					<xsl:call-template name="iterate-root">
						<xsl:with-param name="x" select="1 div $x" />
						<xsl:with-param name="H" select="1 div $x" />
						<xsl:with-param name="L" select="0" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="1 div $inv-root" />
			</xsl:otherwise>  
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="iterate-root">
		<xsl:param name="x"/>
		<xsl:param name="H"/>
		<xsl:param name="L"/>
		<xsl:variable name="M" select="($H + $L) div 2" />
		<xsl:variable name="g" select="($M * $M - $x) div $x" />
		<xsl:variable name="verysmall" select="0.001"/>
		<xsl:choose>
			<xsl:when test="(($g &lt; $verysmall) and ((- $g) &lt; $verysmall)) or (($H - $L) &lt; $verysmall)">
				<xsl:value-of select="$M"/>
			</xsl:when>
			<xsl:when test="$g > 0">
				<xsl:call-template name="iterate-root">
					<xsl:with-param name="x" select="$x" />
					<xsl:with-param name="H" select="$M" />
					<xsl:with-param name="L" select="$L" />
				</xsl:call-template>  
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="iterate-root">
					<xsl:with-param name="x" select="$x" />
					<xsl:with-param name="H" select="$H" />
					<xsl:with-param name="L" select="$M" />
				</xsl:call-template>  
			</xsl:otherwise>
		</xsl:choose>  
	</xsl:template>

	<!-- w trybie screen ukrywa część danych pozwalając na żądanie je odkryć -->
	<xsl:template name="showDheaderEnabler">
		<xsl:param name="blockName"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:variable name="show">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Show</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Rozwiń</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="hide">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Hide</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Ukryj</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<input id="show_{$blockName}_id" name="{$blockName}" type="radio" class="show_{$blockName}"/>
		<label for="show_{$blockName}_id" class="show_{$blockName}_label">
			<span><xsl:value-of select="$show"/></span>
		</label>
		<input id="hide_{$blockName}_id" name="{$blockName}" type="radio" class="hide_{$blockName}"/>
		<label for="hide_{$blockName}_id" class="hide_{$blockName}_label">
			<span><xsl:value-of select="$hide"/></span>
		</label>
	</xsl:template>
	
	<xsl:template name="showDheaderEnablerStyle">
		<xsl:param name="blockName"/>
		
		<xsl:text>
	#show_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_id {
		display:none;
	}
	.show_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_label {
		float: right;
		padding: 1px 6px 0 3px;
		font-size: 0.9em;
		cursor: pointer;
		color: blue;
		text-decoration: underline;
		background: white;
	}
	#hide_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_id {
	    display:none;
	}
	.hide_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_label {
		float: right;
		padding: 1px 6px 0 3px;
		font-size: 0.9em;
		cursor: pointer;
		color: blue;
		text-decoration: underline;
		background: white;
		display:none;
	}
	input#show_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_id:checked ~ .header_dheader {
		display:block;
	}
	input#hide_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_id:checked ~ .header_dheader {
	    display:none;
	}
	input#show_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_id:checked ~ .show_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_label {
		display:none;
	}
	input#show_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_id:checked ~ .hide_</xsl:text><xsl:value-of select="$blockName"/><xsl:text>_label {
	 	display:block;
	}
		</xsl:text>
	</xsl:template>

	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++ STYLE +++++++++++++++++++++++++++++++++++++++++++++++++++++-->
	
	<xsl:template name="styles">
		<!-- w trybie mobilnym wstrzymano się z włączeniem trybu pełnoekranowego
		<meta name="viewport" content="width=device-widht"/> -->
		
		<style type="text/css">
		
@media screen {
	body {
		margin: 0px;
		display: block;
		background-color: #f1f1f1;
	}

	.document {
		margin: 15px auto;
		width: 756px;
		overflow: hidden;
		font-family: "Noto sans", sans-serif;
		font-size: 10pt;
		-webkit-box-shadow: 0px 0px 2px 2px #dcdcdc;
		box-shadow: 0px 0px 2px 2px #dcdcdc;
		background-color: white;
	}
	
				<xsl:call-template name="showDheaderEnablerStyle">
				<xsl:with-param name="blockName">responsible_party</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">encounter_participant</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">service_performer_pprf</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">service_performer_prf</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">data_enterer</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">authenticator</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">author</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">informant</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">authorization</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">participant</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="showDheaderEnablerStyle">
					<xsl:with-param name="blockName">legal_authenticator</xsl:with-param>
				</xsl:call-template>
				
				<xsl:text>
	
	.header_dheader {
		display: none;
	}
	
	#showCdaHeader {
	    display:none;
	}
	.show_cda_header_label {
		position: absolute;
		right: 12px;
		padding: 4px 5px 0px 5px;
		font-size: 0.9em;
		cursor: pointer;
		color: blue;
		text-decoration: underline;
		background: white;
	}
	#hideCdaHeader {
	    display:none;
	}
	.hide_cda_header_label {
		position: absolute;
		right: 12px;
		padding: 4px 5px 0px 5px;
		font-size: 0.9em;
		cursor: pointer;
		color: blue;
		text-decoration: underline;
		background: white;
		display:none;
	}
	
	.doc_dheader {
	    display:none;
	}
	input#showCdaHeader:checked ~ .doc_dheader {
		display:block;
	}
	input#hideCdaHeader:checked ~ .doc_dheader {
	    display:none;
	}
	input#showCdaHeader:checked ~ .show_cda_header_label {
		display:none;
	}
	input#showCdaHeader:checked ~ .hide_cda_header_label {
	 	display:block;
	}
		
	.doc_header {
	/**	background-image: url(data:image/png;base64,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);
		background-repeat: no-repeat;
		background-position: top center;
		background-size: contain;**/
	}
}

@media print {
	body {
		margin: 0px;
		display: block;
		background-color: white;
	}

	.document {
		width: 200mm;
		overflow: hidden;
		font-family: "Noto sans", sans-serif;
		font-size: 10pt;
		background-color: white;
		background-repeat: no-repeat;
		background-image: none;
	}
	
	.doc_header_enabler {
		display:none;
	}
	
	input {
		display:none;
	}
	label {
		display:none;
	}
	
	.doc_header {
	/**	background-image: url(data:image/png;base64,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);
		background-repeat: no-repeat;
		background-position: top center;
		background-size: contain;**/
	}
}

.doc_title {
	font-size: 1.4em;
	text-align: center;
	font-weight: bold;
	border-bottom: 3px black solid;
	padding: 4px 0;
}

.title_suffix {
	font-size: 0.7em;
	font-weight: bold;
	position: absolute;
	margin: 5px;
}

.highlighted {
	color: red;
}
.toned {
	color: grey;
}

.doc_header_elements {
	clear: both;
	font-size: 1.0em;
}
.doc_header_elements > .doc_header_element {
	margin-top: 3px;
	margin-left: 15px;
}
.doc_header_elements>.doc_header_element > .header_label {
	font-size: 1.0em;
}

.header_elements_block_label {
	display: none;
}

.related_document_header_element {
	float: right;
	margin-right: 15px;
}
.related_document_block_label {
	display: none;
}

.doc_header_element {
	display: inline-block;
}
.id_header_element {
	float: right;
	margin-right: 15px;
}

.confidentiality_code_label {
	display: none;
}
.confidentiality_code_value {
	float: right;
	color: red;
}

.version_header_element {
	margin-left: 15px;
}
.value_set_header_element {
	float: right;
	margin-right: 15px;
}


.doc_header {
	clear: left;
	float: left;
	width: 100%;
	overflow:hidden;
	border-top: 3px black solid;
	border-bottom: 3px black solid;
}

.doc_header_2 {
	float: left;
	width: 100%;
	position: relative;
	right: 50%;
	border-right: 2px solid #4d4d4d;
}

.patient_related_header {
	float: left;
	width: 46%;
	position: relative;
	left: 52%;
	overflow: hidden;
}

.document_related_header {
	float: left;
	width: 46%;
	position: relative;
	left: 56%;
	overflow: hidden;
}

.doc_theader {
	position:relative;
}


/*
.doc_dheader {
	display:none;
}

.doc_header_enabler {
	position: absolute;
	right: 30px;
	padding: 4px 5px 0px 5px;
	font-size: 0.9em;
	cursor: pointer;
	color: blue;
	text-decoration: underline;
	background: white;
}

.doc_header_enabler:focus + .doc_dheader {
	display: block;
}

.doc_header_enabler:focus {
	cursor: default;
}*/

.header_bottom {
	clear: both;
}

.doc_body {
	width: 100%;
	float: left;
	font-size: 1.1em;
}

.header_block {
	margin: 0 0 3px 0;
	padding: 3px 0;
	/**border-top: 2px solid #4d4d4d;**/
}

.header_block:not(:first-child) {
	border-top: 2px solid black;
}

.header_block_label {
	font-size: 1.1em;
	font-weight: bold;
}
.header_element {
	margin-top: 4px;
	margin-bottom: 2px;
	margin-left: 7px;
}
.header_label {
	font-weight: bold;
	font-size: 1.0em;
}
.header_value {
	margin-left: 5px;
	margin-top: 3px;
}
.header_inline_value {
	display: inline;
}

.header_block0:not(:first-child) {
	border-top: 1px solid #909090;
	padding-top: 3px;
}
.header_block1 {
	border-top: 1px solid #909090;
	padding-top: 3px;
}
.header_block1 .header_block_label {
	font-size: 1em;
}

.header_block2 {
	border-top: 1px solid #909090;
	padding-top: 3px;
}
.header_block3 {
	border-top: 1px solid #909090;
	padding-top: 3px;
}
.header_block4 {
	border-top: 1px solid #909090;
	padding-top: 3px;
}

.person_name_label {
	display: none;
}
.person_name_value {
	font-size: 1.3em;
}
.organization_name_label {
	display: none;
}
.age_element {
	margin-left: 0px;
}
.id_label {
	display: none;
}
.null_flavor {
	margin-left: 4px;
}
.not_known_id_prefix {
	font-weight: bold;
}
.id_header_element > .header_value > span > .not_known_id_prefix {
	display: none;
}
.id_header_element > .header_value > .null_flavor_id {
	display: none;
}
.value_set_header_element > .header_value > span > .not_known_id_prefix {
	display: none;
}
.value_set_header_element > .header_value > .null_flavor_id {
	display: none;
}
.related_document_header_element > .header_value > span > .not_known_id_prefix {
	display: none;
}
.related_document_header_element > .header_value > .null_flavor_id {
	display: none;
}

.legal_authenticator_id_value > div {
	display: inline;
}
.legal_authenticator_qualification_element {
	font-size: 0.9em;
}
.assigned_entity_code_header_element {
	font-size: 0.9em;
	float: left;
	margin: 5px 7px 1px 12px;
}

@media screen {
	.signature_code_value {
		float: right;
		font-size: 0.8em;
		margin-top: 3px;
	}
	.signature_code_value_print {
		display: none;
	}
}
@media print {
	.signature_code_value {
		display: none;
	}
	.signature_code_value_print {
		float: right;
		font-size: 8pt;
		margin-top: 1mm;
	}
}

.reimbursement_related_contract_element {
}
.reimbursement_related_contract_element > .header_label {
	font-size: 0.9em;
}
.reimbursement_related_contract_element > .header_value {
	font-size: 0.9em;
}

.header_block2, .header_block2 > .header_element > .header_block_label {
	font-size: 0.9em !important;
}
.header_block3, .header_block3 > .header_element > .header_block_label {
	font-size: 0.9em !important;
}
.header_block4, .header_block4 > .header_element > .header_block_label {
	font-size: 0.9em !important;
}

.doc_underwriter {
}
.underwriter_label {
}
.underwriter_id_label {
}
.underwriter_id_value {
	font-size: 1.1em;
}

.doc_custodian {
}
.custodian_block_label {
}

.identifier {
	font-size: 0.9em;
}

.address_element {
}

.address_value {
	margin-left: 15px;
	margin-bottom: 7px;
}

.section_element_1 {
	padding: 7px;
	border-top: 1px black solid;
}
.doc_body > .section_element_1:first-child {
  border-top: none;
}



.popup_container {
	position: relative;
	float: right;
}

.section_dheader_enabler {
	float: right;
	padding: 0 6px 0 3px;
	font-size: 0.9em;
	cursor: pointer;
	color: blue;
	text-decoration: underline;
	background: white;
}

.section_popup {
	font-size: 0.9em;
	white-space: nowrap;
}

.section_dheader {
	display: none;
}

.section_dheader_enabler:focus + .section_dheader {
	position: absolute;
	right: 0;
	margin-top: 20px;
	padding: 3px 7px 0 7px;
	z-index: 100;
	background: white;
	box-shadow: 0px 0px 2px 2px #dcdcdc;
	display: block;
}

.section_dheader_enabler:focus {
	cursor: default;
}

.section_title_1 {
	font-size: 1.1em;
	font-weight: bold;
}
.section_text_1 {
	padding: 7px;
}

.section_element_2 {
	padding: 7px;
}
.section_title_2 {
	font-size: 1.1em;
	font-weight: bold;
}
.section_text_2 {
	padding: 7px;
}

.header_inline_value > .oid {
	display: inline;
}

.caption {
	font-weight: bold;
}
.paragraph {
	margin-bottom: 7px;
}
.paragraph_caption {
	padding-right: 3px;
}
.paragraph_text {
	margin: 2px 14px;
}

.footnote_div {
	border-top: 1px solid #dcdcdc;
	padding: 7px;
}
.footnote_text_inline {
}
.footnote_label {
	font-size: 1.0em;
	font-weight: bold;
}
.footnote_values {
	font-size: 0.9em;
	/**font-family: Georgia, serif;**/
}
.footnote_value {
	margin: 2px 0 0 15px;
}

img {
    height: 100%;
	width: 100%;
	max-width: 718px;
}
svg {
    height: 100%;
	width: 100%;
	max-width: 718px;
}

.multimedia_under_region_of_interest {
	position: relative;
	height: 100%;
	width: 100%;
    max-width: 718px;
}
.region_of_interest {
	position: absolute;
	top: 0;
	left: 0;
	height: 100%;
	width: 100%;
    max-width: 718px;
}

.multimedia_pdf {
	width: 100%;
	height: 1012px;
	padding-top: 5px;
}

.box {
	position: relative;
}

ol, ul {
	margin: 0;
}

.table_caption {
	font-weight: bold;
}
table {
	border-collapse: collapse;
}
th, td {
	padding: 5px;
}
			</xsl:text>
			
			<!-- jeśli nie użyto żadnych stylów typu Rrule Lrule Toprule Botrule, 
				 dodawany jest styl delikatnej szarej linii -->
			<xsl:if test="//hl7:table and not(//*[contains(@styleCode, 'Botrule')] or //*[contains(@styleCode, 'Lrule')] or //*[contains(@styleCode, 'Rrule')] or //*[contains(@styleCode, 'Toprule')])">
				<xsl:text>
table, th, td {
	border: 1px solid #dcdcdc;
}
				</xsl:text>
			</xsl:if>
		</style>
	</xsl:template>
	
	
	<!-- ++++++++++++++++++++++++++++++++++++++ STRUCTURED BODY +++++++++++++++++++++++++++++++++++++++++++-->
	
	<!-- structuredBody  -->
	<xsl:template name="structuredBody">
		<xsl:for-each select="hl7:component/hl7:structuredBody/hl7:component/hl7:section">
			<xsl:call-template name="section"/>
		</xsl:for-each>
	</xsl:template>
	
	<!-- główne sekcje dokumentu -->
	<xsl:template name="section">
		<div class="section_element_1">
			<xsl:call-template name="sectionParticipants"/>
			<xsl:if test="hl7:title">
				<xsl:call-template name="mainSectionTitle">
					<xsl:with-param name="title" select="hl7:title"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="mainSectionText"/>
			<xsl:for-each select="hl7:component/hl7:section">
				<xsl:call-template name="subSection">
					<xsl:with-param name="level" select="2"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:call-template name="footnotesOnTheBottom"/>
		</div>
	</xsl:template>
	
	<!-- tytuł głównej sekcji -->
	<xsl:template name="mainSectionTitle">
		<xsl:param name="title"/>
		<span class="section_title_1">
			<xsl:value-of select="$title"/>
		</span>
	</xsl:template>
	
	<!-- treść głównej sekcji -->
	<xsl:template name="mainSectionText">
		<div class="section_text_1">
			<xsl:call-template name="sectionText">
				<xsl:with-param name="text" select="hl7:text"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<!-- sekcje zagnieżdżone, wywołanie rekurencyjne -->
	<xsl:template name="subSection">
		<xsl:param name="level"/>
		<div class="section_element_{$level}">
			<xsl:call-template name="sectionParticipants"/>
			<span class="section_title_{$level}">
				<xsl:value-of select="hl7:title"/>
			</span>
			<div class="section_text_{$level}">
				<xsl:call-template name="sectionText">
					<xsl:with-param name="text" select="hl7:text"/>
				</xsl:call-template>
			</div>
		</div>
		<xsl:for-each select="hl7:component/hl7:section">
			<xsl:call-template name="subSection">
				<xsl:with-param name="level" select="$level+1"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="sectionText">
		<xsl:param name="text"/>
		<xsl:apply-templates select="$text"/>
	</xsl:template>
	
	<xsl:template name="sectionParticipants">
		<xsl:if test="hl7:subject or count(hl7:informant)&gt;0 or count(hl7:author)&gt;0">
		
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
	    	<xsl:variable name="organizationLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Organization</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Organizacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="popup_container">
				<xsl:if test="count(hl7:author)&gt;0">
				
					<xsl:variable name="authorDateLabel">
						<xsl:choose>
							<xsl:when test="$lang = $secondLanguage">
								<xsl:text>Date</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Data</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<span class="section_dheader_enabler" tabindex='0'>
						<xsl:choose>
							<xsl:when test="count(hl7:author) = 1 and $lang = $secondLanguage">
								<xsl:text>Section author</xsl:text>
							</xsl:when>
							<xsl:when test="count(hl7:author) &gt; 1 and $lang = $secondLanguage">
								<xsl:text>Section authors</xsl:text>
							</xsl:when>
							<xsl:when test="count(hl7:author) = 1">
								<xsl:text>Autor</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Autorzy</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<div class="section_dheader">
						<xsl:for-each select="hl7:author">
							<xsl:call-template name="assignedEntity">
								<xsl:with-param name="entity" select="./hl7:assignedAuthor"/>
								<xsl:with-param name="blockClass">header_block section_popup</xsl:with-param>
								<xsl:with-param name="blockLabel"/>
								<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
								<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
							</xsl:call-template>
							<xsl:call-template name="dateTimeInDiv">
								<xsl:with-param name="date" select="./hl7:time"/>
								<xsl:with-param name="label" select="$authorDateLabel"/>
								<xsl:with-param name="divClass">header_element</xsl:with-param>
								<xsl:with-param name="calculateAge" select="false()"/>
							</xsl:call-template>
						</xsl:for-each>
					</div>
				</xsl:if>
				
				<xsl:if test="count(hl7:informant)&gt;0">
					<span class="section_dheader_enabler" tabindex='0'>
						<xsl:choose>
							<xsl:when test="count(hl7:informant) = 1 and $lang = $secondLanguage">
								<xsl:text>Informant</xsl:text>
							</xsl:when>
							<xsl:when test="count(hl7:informant) &gt; 1 and $lang = $secondLanguage">
								<xsl:text>Informants</xsl:text>
							</xsl:when>
							<xsl:when test="count(hl7:informant) = 1">
								<xsl:text>Informator</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Informatorzy</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<div class="section_dheader">
						<xsl:for-each select="hl7:informant">
							<xsl:choose>
								<xsl:when test="./hl7:assignedEntity">
									<xsl:call-template name="assignedEntity">
										<xsl:with-param name="entity" select="./hl7:assignedEntity"/>
										<xsl:with-param name="blockClass">header_block section_popup</xsl:with-param>
										<xsl:with-param name="blockLabel"/>
										<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
										<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
									</xsl:call-template>
								</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="assignedEntity">
									<xsl:with-param name="entity" select="./hl7:relatedEntity"/>
									<xsl:with-param name="context">relatedEntity</xsl:with-param>
									<xsl:with-param name="blockClass">header_block section_popup</xsl:with-param>
									<xsl:with-param name="blockLabel"/>
									<xsl:with-param name="organizationLevel1BlockLabel" select="$organizationLabel"/>
									<xsl:with-param name="knownIdentifiersOnly" select="false()"/>
								</xsl:call-template>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</div>
				</xsl:if>
				
				<xsl:if test="hl7:subject">
					<span class="section_dheader_enabler" tabindex='0'>
						<xsl:choose>
							<xsl:when test="$lang = $secondLanguage">
								<xsl:text>Different subject</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Dotyczy osoby</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<div class="section_dheader">
						<xsl:call-template name="sectionSubject"/>
					</div>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- Dane podmiotu (zawsze wyłącznie osoba) związanego z sekcją, templateId 2.16.840.1.113883.3.4424.13.10.4.15 -->
	<xsl:template name="sectionSubject">
		<xsl:variable name="subject" select="hl7:subject/hl7:relatedSubject"/>
		
		<xsl:if test="$subject">
			<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
			
	    	<xsl:variable name="relationshipLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Relationship</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Relacja</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="birthDateLabel">
				<xsl:choose>
					<xsl:when test="$lang = $secondLanguage">
						<xsl:text>Birth date</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Data urodzenia</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="header_block section_popup">
				<xsl:if test="$subject/hl7:subject/hl7:name">
					<xsl:call-template name="personName">
						<xsl:with-param name="name" select="$subject/hl7:subject/hl7:name"/>
					</xsl:call-template>
				</xsl:if>
				
				<!-- kod relacji z pacjentem -->
				<div class="header_element">
					<span class="header_label">
						<xsl:value-of select="$relationshipLabel"/>
					</span>
					<div class="header_inline_value header_value">
						<xsl:call-template name="translatePersonalRelationshipRoleCode">
							<xsl:with-param name="roleCode" select="$subject/hl7:code/@code"/>
						</xsl:call-template>
					</div>
				</div>
				
				<xsl:call-template name="dateTimeInDiv">
					<xsl:with-param name="date" select="$subject/hl7:subject/hl7:birthTime"/>
					<xsl:with-param name="label" select="$birthDateLabel"/>
					<xsl:with-param name="divClass">header_element</xsl:with-param>
					<xsl:with-param name="calculateAge" select="false()"/>
				</xsl:call-template>
				
				<!-- płeć -->
				<xsl:call-template name="translateGenderCode">
					<xsl:with-param name="genderCode" select="$subject/hl7:subject/hl7:administrativeGenderCode"/>
				</xsl:call-template>
				
				<!-- dane adresowe i kontaktowe podmiotu -->
				<xsl:call-template name="addressTelecomInDivs">
					<xsl:with-param name="addr" select="$subject/hl7:addr"/>
					<xsl:with-param name="telecom" select="$subject/hl7:telecom"/>
				</xsl:call-template>
			</div>
		</xsl:if>
    </xsl:template>
	
	<!-- autor sekcji ukryty w elemencie rozwijanym --> 
    <xsl:template name="sectionAuthor">
        <!-- 
        <xsl:if test="count(n1:author)&gt;0">
            <div style="margin-left : 2em;">
                <b>
                    <xsl:text>Section Author: </xsl:text>
                </b>
                <xsl:for-each select="n1:author/n1:assignedAuthor">
                    <xsl:choose>
                        <xsl:when test="n1:assignedPerson/n1:name">
                            <xsl:call-template name="show-name">
                                <xsl:with-param name="name" select="n1:assignedPerson/n1:name"/>
                            </xsl:call-template>
                            <xsl:if test="n1:representedOrganization">
                                <xsl:text>, </xsl:text>
                                <xsl:call-template name="show-name">
                                    <xsl:with-param name="name" select="n1:representedOrganization/n1:name"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="n1:assignedAuthoringDevice/n1:softwareName">
                            <xsl:value-of select="n1:assignedAuthoringDevice/n1:softwareName"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="n1:id">
                                <xsl:call-template name="show-id"/>
                                <br/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <br/>
            </div>
        </xsl:if> 
        -->
	</xsl:template>
    
    

<!-- Transformata przekodowuje tagi MIME type "text/x-hl7-text+xml" na html:
	<content> - odpowiednik <span> w HTML, posiada opcjonalny identyfikator wykorzystywany do wskazywania tego tekstu w bloku entry. 
					Tag ten służy też do wyróżniania zmian w tekście pomiędzy wersjami dokumentu przy wykorzytaniu atrybutu @revised.
	<sub> oraz <sup> - identyczne jak w HTML
	<br> - identyczne jak w HTML
	<footnote> oraz <footnoteRef> - bez odpowiedników w HTML, należy oprogramować 
	<caption> - nagłówek elementów paragraph, list, list item, table, table cell, renderMultimedia. Może zawierać linki, przypisy, sub, sup.
	<paragraph> - odpowiednik <p> w HTML
	<linkHtml> - odpowiednik <a> w HTML, nie identyczny
	<renderMultiMedia> - odpowiednik <img> w HTML
	<list> z atrybutem @listType oraz elementem <item> - odpowiednik list <ol> i <ul> z elementem <li> w HTML
	<table> z elementami <thead>, <tbody>, <tfoot>, <th>, <td>, <tr>, <colgroup>, <col>, <caption> - identyczne jak w HTML
	atrybut styleCode:
	 - z listą prymitywnych wartości 
	 - od IG 1.3.1 z polskimi rozszerzeniami umożliwiającym użycie podstawowych kolorów CSS dla czcionek: 
	 	xPLred, xPLblue, xPLgreen, xPLlime, xPLgray, xPLviolet, xPLpurple, xPLorange, xPLolive, xPLnavy, xPLsilver,
	 	i powiększonego rozmiaru czcionki xPLbig.
	-->

	<!-- content -->
	<xsl:template match="hl7:content">
		<xsl:choose>
			<xsl:when test="@revised='delete'">
				<!-- content wyróżniający fragmenty tekstu jako usunięte z poprzedniej wersji dokumentu -->
				<!-- tekst nie jest wyświetlany, pomijana jest cała usunięta zawartość, 
					 można rozważyć czy dodać specjalną obsługę revised (insert/delete), aktualnie uznano, że są to informacje nadmiarowe -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="span">
					<xsl:apply-templates select="@styleCode"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- sup -->
	<xsl:template match="hl7:sup">
		<xsl:element name="sup">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- sub -->
	<xsl:template match="hl7:sub">
		<xsl:element name="sub">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- br -->
	<xsl:template match="hl7:br">
		<xsl:element name='br'>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- przypis w sekcji -->
	<xsl:template match="hl7:footnote">
		<xsl:variable name="referenceId" select="@ID"/>
		<sup>
			<xsl:text>[</xsl:text>
			<xsl:choose>
				<xsl:when test="$referenceId">
					<a href="#przypis-{$referenceId}">
						<xsl:value-of select="$referenceId"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<!-- pojedyncze wystąpienie bez ID, brak odnośnika -->
					<span class="footnote_text_inline">
						<xsl:apply-templates/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>]</xsl:text>
		</sup>
	</xsl:template>
	
	<!-- odnośnik do przypisu -->
	<xsl:template match="hl7:footnoteRef">
		<xsl:variable name="referencedId" select="@IDREF"/>
		<sup>
			<xsl:text>[</xsl:text>
			<a href="#przypis-{$referencedId}">
				<xsl:value-of select="$referencedId"/>
			</a>
			<xsl:text>]</xsl:text>
		</sup>
	</xsl:template>
	
	<!-- przypis - wyświetlenie -->
	<xsl:template name="footnotesOnTheBottom">
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		
		<xsl:variable name="footnoteLabel">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Footnotes</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Przypisy</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="footnotes" select=".//hl7:footnote[@ID]"/>
		
		<xsl:if test="$footnotes">
			<div class="footnote_div">
				<span class="footnote_label">
					<xsl:value-of select="$footnoteLabel"/>
				</span>
				<div class="footnote_values">
					<xsl:for-each select="$footnotes">
						<xsl:if test="./@ID">			
							<div class="footnote_value">
								<a id="przypis-{./@ID}">
									<xsl:value-of select="./@ID"/>
									<xsl:text>. </xsl:text>	
									<xsl:apply-templates/>
								</a>	
								
							</div>
						</xsl:if>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- nagłówek akapitu
		parametr intentionally wyokrzystywany jest do wyjęcia <caption> z elementu <paragraph> 
		w sytuacji gdy caption nie jest pierwszym węzłem paragraph,
		umieszczenie tekstu w <paragraph> przed elementem <caption> jest zgodne z XSD 
		o ile tekst nie zawiera innych elementów, nie jest jednak zalecane -->
	<xsl:template match="hl7:paragraph/hl7:caption">
		<xsl:param name="intentionally" select="false()"/>
		<xsl:if test="$intentionally">
			<xsl:element name="span">
				<xsl:attribute name="class">paragraph_caption caption</xsl:attribute>
				<xsl:apply-templates select="@styleCode"/>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<!-- paragraph -->
	<xsl:template match="hl7:paragraph">
		<div class="paragraph">
			<xsl:element name="div">
				<xsl:attribute name="class">paragraph_text</xsl:attribute>
				<xsl:apply-templates select="@styleCode"/>
				<xsl:apply-templates select="hl7:caption">
					<xsl:with-param name="intentionally" select="true()"/>
				</xsl:apply-templates>
				<!-- spowoduje wywołanie template'ów dla wszystkich węzłów i dla caption, 
					jednak template caption nie wykona się bez parametru "intentionally" -->
				<xsl:apply-templates/>
			</xsl:element>
		</div>
	</xsl:template>
	
	<!-- list -->
	<xsl:template match="hl7:list">
		
		<xsl:apply-templates select="hl7:caption">
			<xsl:with-param name="intentionally" select="true()"/>
		</xsl:apply-templates>
		
		<xsl:choose>
			<xsl:when test="@listType='ordered'">
				<xsl:element name="ol">
					<xsl:choose>
						<!-- HTML5 nie wspiera tych typów -->
						<xsl:when test="contains(@styleCode, 'Arabic')">
							 <xsl:attribute name="type">1</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(@styleCode, 'BigAlpha')">
							 <xsl:attribute name="type">A</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(@styleCode, 'BigRoman')">
							 <xsl:attribute name="type">I</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(@styleCode, 'LittleAlpha')">
							 <xsl:attribute name="type">a</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(@styleCode, 'LittleRoman')">
							 <xsl:attribute name="type">i</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:apply-templates select="@styleCode"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="ul">
					<xsl:choose>
						<!-- HTML5 nie wspiera tych typów -->
						<xsl:when test="contains(@styleCode, 'Circle')">
							 <xsl:attribute name="type">circle</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(@styleCode, 'Disc')">
							 <xsl:attribute name="type">disc</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(@styleCode, 'Square')">
							 <xsl:attribute name="type">square</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:apply-templates select="@styleCode"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- nagłówek listy przed głównym elementem listy
		 kolejny zabieg z intentionally pozwala uniknąć operatora exerpt z XPATH 2.0 -->
	<xsl:template match="hl7:list/hl7:caption">
		<xsl:param name="intentionally" select="false()"/>
		
		<xsl:if test="$intentionally">
			<xsl:element name="span">
				<xsl:attribute name="class">list_caption caption</xsl:attribute>
				<xsl:apply-templates select="@styleCode"/>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="hl7:list/hl7:item">
		<xsl:element name="li">
			<xsl:apply-templates select="@styleCode"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- nagłówek elementu listy -->
	<xsl:template match="hl7:list/hl7:item/hl7:caption">
		<xsl:element name="span">
			<xsl:attribute name="class">list_caption caption</xsl:attribute>
			<xsl:apply-templates select="@styleCode"/>
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<!-- zmiana nazwy bez przepisywania ze względów bezpieczeństwa, wyłącznie dla znanych wartości, 
		w tym poza stylami HL7 CDA dodano dopuszczalne przez ten standard polskie rozszerzenia dot. kolorów czcionek
		(zastosowano style, gdyż jest silniejsze niż przypisany class) -->
	<xsl:template match="@styleCode">
		<xsl:if test="string-length(.) &gt;= 1">
			<xsl:attribute name="style">
				<xsl:if test="contains(., 'Italics')"> font-style: italic;</xsl:if>
				<xsl:if test="contains(., 'Bold')"> font-weight: bold;</xsl:if>
				<xsl:if test="contains(., 'Underline')"> text-decoration: underline;</xsl:if>
				<xsl:if test="contains(., 'Emphasis')"> font-style: bold;</xsl:if>
				<xsl:if test="contains(., 'xPLred')"> color: red;</xsl:if>
				<xsl:if test="contains(., 'xPLgreen')"> color: green;</xsl:if>
				<xsl:if test="contains(., 'xPLblue')"> color: blue;</xsl:if>
				<xsl:if test="contains(., 'xPLlime')"> color: lime;</xsl:if>
				<xsl:if test="contains(., 'xPLolive')"> color: olive;</xsl:if>
				<xsl:if test="contains(., 'xPLorange')"> color: orange;</xsl:if>
				<xsl:if test="contains(., 'xPLnavy')"> color: navy;</xsl:if>
				<xsl:if test="contains(., 'xPLviolet')"> color: violet;</xsl:if>
				<xsl:if test="contains(., 'xPLpurple')"> color: purple;</xsl:if>
				<xsl:if test="contains(., 'xPLsilver')"> color: silver;</xsl:if>
				<xsl:if test="contains(., 'xPLgray')"> color: gray;</xsl:if>
				<xsl:if test="contains(., 'xPLbig')"> font-size: 1.1em;</xsl:if>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!--  Tabele  -->
	
	<!-- tabele są identyczne jak w HTML (poza atrybutem styleCode), są więc kopiowane bez zmian
		 XSD dopuszcza wiele atrybutów nieobsługiwanych w HTML5, ale dopuszczalnych tutaj. -->
	<xsl:template match="hl7:table | hl7:col | hl7:colgroup | hl7:tbody | hl7:td | hl7:tfoot | hl7:th | hl7:thead | hl7:tr">
		<xsl:element name="{local-name()}">
		
		<xsl:call-template name="copyTableAttributes">
			<xsl:with-param name="tagName" select="local-name()"/>
			<xsl:with-param name="attributes" select="./@*"/>
		</xsl:call-template>
		<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- pełna kontrola nad tym co jest kopiowane -->
	<xsl:template name="copyTableAttributes">
		<xsl:param name="tagName"/>
		<xsl:param name="attributes"/>
		
		<xsl:variable name="tagNameUppercase" select="translate($tagName, $LOWERCASE_LETTERS, $UPPERCASE_LETTERS)"/>
		
		<xsl:for-each select="$attributes">
			<!-- Znaki dopuszczalne w atrybutach tabel, obsługa w XPATH 1.0, tj. bez wyrażeń regularnych -->
			<xsl:if test="string-length(translate(., 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ,.-_!', '')) = 0">
				<xsl:choose>
					<xsl:when test="local-name(.) = 'styleCode'">
						<xsl:if test="string-length(.) &gt;= 1">
							<xsl:attribute name="style">
								<xsl:if test="contains(., 'Italics')"> font-style: italic;</xsl:if>
								<xsl:if test="contains(., 'Bold')"> font-weight: bold;</xsl:if>
								<xsl:if test="contains(., 'Underline')"> text-decoration: underline;</xsl:if>
								<xsl:if test="contains(., 'Emphasis')"> font-style: bold;</xsl:if>
								<xsl:if test="contains(., 'Botrule')"> border-bottom: 1pt solid #dcdcdc;</xsl:if>
								<xsl:if test="contains(., 'Lrule')"> border-left: 1pt solid #dcdcdc;</xsl:if>
								<xsl:if test="contains(., 'Rrule')"> border-right: 1pt solid #dcdcdc;</xsl:if>
								<xsl:if test="contains(., 'Toprule')"> border-top: 1pt solid #dcdcdc;</xsl:if>
							</xsl:attribute>
						</xsl:if>
					</xsl:when>
					<!-- atrybuty pochodzące z HTML dopuszczalne w XSD Narrative Block dla elementów tabeli
		 				 wszystkie wartości tych atrybutów będą przepisywane bez zmian niniejszą transformatą z postaci "text/x-hl7-text+xml" do "text/html"
		 				 zapis celowo nieco nieoptymalny -->
					<xsl:when test="$tagNameUppercase = 'COL' and contains(';ID;language;span;width;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'COLGROUP' and contains(';ID;language;span;width;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'TABLE' and contains(';ID;language;summary;width;border;frame;rules;cellspacing;cellpadding;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'TBODY' and contains(';ID;language;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'TD' and contains(';ID;language;abbr;axis;headers;scope;rowspan;colspan;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'TFOOT' and contains(';ID;language;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'TH' and contains(';ID;language;abbr;axis;headers;scope;rowspan;colspan;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'THEAD' and contains(';ID;language;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="$tagNameUppercase = 'TR' and contains(';ID;language;align;char;charoff;valign;', concat(';',local-name(.),';'))">
						<xsl:copy-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!-- nagłówek tabeli to standardowo i wyjątkowo element html caption -->
	<xsl:template match="hl7:table/hl7:caption">
		<xsl:element name="caption">
			<xsl:attribute name="class">table_caption caption</xsl:attribute>
			<xsl:apply-templates select="@styleCode"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	
	<!-- odnośnik -->
	<xsl:template match="hl7:linkHtml">
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="./@href"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- wyświetlanie załączonych multimediów -->
	<xsl:template match="hl7:renderMultiMedia">
		<xsl:variable name="multimediaObservationId" select="@referencedObject"/>
		<!-- docelowe observationMedia musi istnieć w entry sekcji, może istnieć w relacji do regionOfInterest, observation itp. -->
		<!-- zawartość do wyświetlenia może znajdować się w postaci base64Binary w treści dokumentu, lub w zewnętrznym pliku -->
		<xsl:variable name="roi" select="//hl7:regionOfInterest[@ID=$multimediaObservationId]"/>
		
		<xsl:apply-templates select="./hl7:caption"/>
		
		<!-- uwaga, dane elementów regionOfInterest i observationMedia definiowane są poza schemą Narrative Block, w schemie POCD_MT000040.xsd
		z danych tych korzysta się wyłącznie z mediaType, value, code --> 
		<xsl:choose>
			<!-- sprawdzam czy zdefiniowano Region Of Interest, zbieram jego dane -->
			<xsl:when test="$roi">
				<xsl:variable name="overlayType" select="$roi/hl7:code/@code"/>
				<xsl:variable name="overlayPoints" select="$roi/hl7:value/@value"/>
				
				<div class="box">
					<div class="multimedia_under_region_of_interest floatTL">
						<xsl:call-template name="renderED">
							<xsl:with-param name="valueEDType" select="$roi//hl7:observationMedia/hl7:value"/>
						</xsl:call-template>
					</div>
					<div class="region_of_interest floatTL">
						<svg xmlns="http://www.w3.org/2000/svg">
							<xsl:choose>
								<xsl:when test="$overlayType = 'CIRCLE'">
									<xsl:variable name="cx" select="$roi/hl7:value[position() = 1]/@value"/>
									<xsl:variable name="cy" select="$roi/hl7:value[position() = 2]/@value"/>
									<xsl:variable name="px" select="$roi/hl7:value[position() = 3]/@value"/>
									<xsl:variable name="py" select="$roi/hl7:value[position() = 4]/@value"/>
									<xsl:element name="circle">
										<xsl:attribute name="cx"><xsl:value-of select="$cx"/></xsl:attribute>
										<xsl:attribute name="cy"><xsl:value-of select="$cy"/></xsl:attribute>
										<xsl:attribute name="r">
											<xsl:choose>
												<xsl:when test="$cx = $px">
													<!-- zamiennik abs dla XSLT 1.0, np.: -30*(1-2*(1)) lub 30*(1-2*(0)) -->
													<xsl:value-of select="($py - $cy) * (1 - 2*(($py - $cy) &lt; 0))"/>
												</xsl:when>
												<xsl:when test="$cy = $py">
													<xsl:value-of select="($px - $cx) * (1 - 2*(($px - $cx) &lt; 0))"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:variable name="d2x" select="($px - $cx)*($px - $cx)"/>
													<xsl:variable name="d2y" select="($py - $cy)*($py - $cy)"/>
													<xsl:call-template name="squareOfPositive">
														<xsl:with-param name="x" select="$d2x + $d2y"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="style"><xsl:text>fill:none;stroke:red;stroke-width:3</xsl:text></xsl:attribute>
									</xsl:element>
								</xsl:when>
								<xsl:when test="$overlayType = 'ELLIPSE'">
									<xsl:variable name="major1x" select="$roi/hl7:value[position() = 1]/@value"/>
									<xsl:variable name="major1y" select="$roi/hl7:value[position() = 2]/@value"/>
									<xsl:variable name="major2x" select="$roi/hl7:value[position() = 3]/@value"/>
									<xsl:variable name="major2y" select="$roi/hl7:value[position() = 4]/@value"/>
									<xsl:variable name="minor1x" select="$roi/hl7:value[position() = 5]/@value"/>
									<xsl:variable name="minor1y" select="$roi/hl7:value[position() = 6]/@value"/>
									<xsl:variable name="minor2x" select="$roi/hl7:value[position() = 7]/@value"/>
									<xsl:variable name="minor2y" select="$roi/hl7:value[position() = 8]/@value"/>
									<!-- elipsa jest jedynie symulowana, wstrzymano przeliczenia punktów standardu CDA na punkty SVG -->
									<polyline points="{$major1x},{$major1y} {$minor1x},{$minor1y} {$major2x},{$major2y} {$minor2x},{$minor2y} {$major1x},{$major1y}" style="fill:none;stroke:red;stroke-width:3"/>
								</xsl:when>
								<xsl:when test="$overlayType = 'POINT'">
									<xsl:for-each select="$roi/hl7:value[position() mod 2 = 1]">
										<circle cx="{./@value}" cy="{following-sibling::*[1]/@value}" r="2" stroke="red" stroke-width="4" fill="none"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="$overlayType = 'POLY'">
									<xsl:element name="polyline">
										<xsl:attribute name="points">
											<xsl:for-each select="$roi/hl7:value[position() mod 2 = 1]">
												<xsl:value-of select="./@value"/>
												<xsl:text>,</xsl:text>
												<xsl:value-of select="following-sibling::*[1]/@value"/>
												<xsl:if test="position()!=last()">
													<xsl:text> </xsl:text>
												</xsl:if>
											</xsl:for-each>
										</xsl:attribute>
										<xsl:attribute name="style">fill:none;stroke:red;stroke-width:3</xsl:attribute>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
						</svg>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- multimedia bez ROI -->
				<xsl:call-template name="renderED">
					<xsl:with-param name="valueEDType" select="//hl7:observationMedia/hl7:value"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- nagłówek multimediów -->
	<xsl:template match="hl7:renderMultiMedia/hl7:caption">
		<xsl:element name="span">
			<xsl:attribute name="class">list_caption caption</xsl:attribute>
			<xsl:apply-templates select="@styleCode"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- ten template może zostać rozszerzony do obsługi wszystkich typów zapisywanych w ED -->
	<xsl:template name="renderED">
		<xsl:param name="valueEDType"/>
		
		<xsl:variable name="lang" select="(ancestor-or-self::*/hl7:languageCode/@code)[position()=last()]"/>
		<xsl:variable name="mediaType" select="$valueEDType/@mediaType"/>
		
		<xsl:variable name="alt">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Cannot display media content of type </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Twoje oprogramowanie nie potrafi wyświetlić multimediów typu </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$mediaType"/>
			<xsl:text>.</xsl:text>
		</xsl:variable>
		<xsl:variable name="altPDF">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Cannot display PDF media content.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Twoje oprogramowanie nie potrafi wyświetlić multimediów typu PDF.</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="altOther">
			<xsl:choose>
				<xsl:when test="$lang = $secondLanguage">
					<xsl:text>Media content of type </xsl:text>
					<xsl:value-of select="$mediaType"/>
					<xsl:text> is not supported.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Multimedialny format </xsl:text>
					<xsl:value-of select="$mediaType"/>
					<xsl:text> nie jest obsługiwany.</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="src">
			<xsl:choose>
				<xsl:when test="$valueEDType/hl7:reference/@value">
					<xsl:value-of select="$valueEDType/hl7:reference/@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('data:', $mediaType, ';base64,', $valueEDType/text())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$mediaType='image/gif' or $mediaType='image/jpeg' or $mediaType='image/jpg' or $mediaType='image/png' or $mediaType='image/tif' or $mediaType='image/tiff'">
				<xsl:element name="img">
					<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$mediaType='text/plain' or $mediaType='text/x-hl7-ft' or $mediaType='text/html'">
				<!-- nie spodziewamy się wartości tekstowych, umieszczane są w standardowy sposób bez ewentualnych tagów -->
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:when test="$mediaType='application/pdf'">
				<object class="multimedia_pdf" data="{$src}" type="application/pdf">
					<xsl:value-of select="$altPDF"/>
				</object>
			</xsl:when>
			<xsl:when test="$mediaType='audio/basic' or $mediaType='audio/mpeg' or $mediaType='application/ogg' or $mediaType='video/mpeg'">
				<div>
					<object width="300" data="{$src}" type="{$mediaType}">
						<embed src="{$src}" type="{$mediaType}" />
						<xsl:value-of select="$alt"/>
					</object>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$altOther"/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA
			AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO
			9TXL0Y4OHwAAAABJRU5ErkJggg==" alt="Red dot"/> - przykład
		</xsl:if> -->
	</xsl:template>
</xsl:stylesheet>