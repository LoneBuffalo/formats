<?xml version='1.0'?>
<!-- 
	Copyright 2008 Lone Buffalo, Inc.
	File:	 selectionv1.xsl
	Content: XSLT for processing XML v1 Selection from snapshots
	Date:	 4/21/08
	Version: 1.0
History:
 A1.0:  -  Output will match stdFullStory for XMLv2 clients with
 		defaultcopyright and pubcopyright elements.
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:date="http://exslt.org/dates and times" 
				extension-element-prefixes="date" 
				>
<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/date.date-time.xsl"/>
<xsl:variable name="apiroot" select="concat('https://subscriber-api.lonebuffalo.com/v1/clients/',string(/CLIPSHEET/@CID),'/')" />
<xsl:variable name="webroot"></xsl:variable>

<xsl:variable name="tgtArticles" select="/CLIPSHEET/TARGET" />
<xsl:variable name="baseURL" select="string(/CLIPSHEET/LB_URL)" />
<xsl:variable name="region" select="translate(string(/CLIPSHEET/REGION), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
<xsl:variable name="selection" select="/CLIPSHEET/ARTICLE[@ID=$tgtArticles]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$selection[not(@TOPSTORY!=0)]/SECTION/@ID]" />
<xsl:variable name="orphans" select="/CLIPSHEET/ARTICLE[(@PARENT!=0) and not (@PARENT=$tgtArticles)][@ID=$tgtArticles]" />
<xsl:variable name="topStories" select="$selection[@TOPSTORY!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<!--
<xsl:variable name="FTXML" select="document(concat($baseURL,'XML/stdFullStoryv2.xml?story_id=',$strAID))" />
-->
<xsl:variable name="FTXML" select="document(concat($apiroot,'/articles?story_ids=',$strAID))"/>

<xsl:output method="xml" indent="yes" encoding="utf-8" />

<xsl:template match="/">
	<CLIPSHEET>
	<xsl:copy-of select="/CLIPSHEET/LOCAL_DATE" />
	<xsl:copy-of select="/CLIPSHEET/CREATE_DATE" />
	<xsl:copy-of select="/CLIPSHEET/REGION" />
	<xsl:copy-of select="$FTXML" />
	<xsl:copy-of select="$tgtArticles" />
	<xsl:copy-of select="$FTXML/CLIPSHEET/DEFAULTCOPYRIGHT" />
	<xsl:element name="KEYWORDS">
		<xsl:copy-of select="$FTXML/CLIPSHEET/KEYWORDS/BOLD" />
		<xsl:copy-of select="/CLIPSHEET/KEYWORDS/SRCHWRDS" />
	</xsl:element>
	<xsl:copy-of select="concat($baseURL,'XML/stdFullStoryv2.xml?story_id=',$strAID)" />
	<xsl:copy-of select="/ERROR" />
	<xsl:apply-templates select="$topStories">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<xsl:apply-templates select="$sectList">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	</CLIPSHEET>
</xsl:template>

<xsl:template match="SECTION">
	<xsl:variable name="sectID" select="ID" />
	<xsl:apply-templates select="$selection[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]">
		<xsl:with-param name="sectOrd" select="position()" />
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<xsl:apply-templates select="$orphans[SECTION/@ID=$sectID]">
		<xsl:with-param name="sectOrd" select="concat(position(),9)" />
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE">
	<xsl:param name="sectOrd" />
	<xsl:variable name="storyID" select="@ID" />
	<xsl:variable name="parentID" select="PARENT" />
	<xsl:copy>
	<xsl:element name="ID">
		<xsl:value-of select="@ID" />
	</xsl:element>
	<xsl:copy-of select="HEADLINE" />
	<xsl:copy-of select="SUBHEAD"/>
	<xsl:copy-of select="PUBLICATION"/>
	<xsl:element name="PUBCOPYRIGHT">
		<xsl:value-of select="COPYRIGHT"/>
	</xsl:element>
	<xsl:copy-of select="PUBLISHDATE"/>
	<xsl:copy-of select="AUTHOR"/>
	<xsl:copy-of select="LINKURL" />
	<xsl:copy-of select="ABSTRACT" />
	<xsl:copy-of select="$FTXML/CLIPSHEET/ARTICLE[ID=$storyID]/ARTICLEBODY" />
	<xsl:apply-templates select="/CLIPSHEET/ARTICLE[@PARENT=$storyID]" mode="childArticle">
		<xsl:with-param name="parentID" select="ID" />
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<xsl:apply-templates select="/CLIPSHEET/ARTICLE[@ID=$parentID]" mode="parentArticle">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<xsl:element name="ORDINAL">
		<xsl:value-of select="concat($sectOrd,position())" />
	</xsl:element>
	</xsl:copy>
</xsl:template>

<xsl:template match="ARTICLE" mode="childArticle">
	<xsl:param name="parentID" />
	<xsl:element name="RELATED">
		<xsl:copy-of select="ID" />
		<xsl:element name="PARENT">
			<xsl:value-of select="$parentID" />
		</xsl:element>
		<xsl:copy-of select="HEADLINE" />
		<xsl:copy-of select="PUBLICATION" />
		<xsl:copy-of select="PUBLISHDATE" />
		<xsl:element name="ORDINAL">
			<xsl:value-of select="position()" />
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="ARTICLE" mode="parentArticle">
	<xsl:element name="RELATED">
		<xsl:copy-of select="ID" />
		<xsl:copy-of select="HEADLINE" />
		<xsl:copy-of select="PUBLICATION" />
		<xsl:copy-of select="PUBLISHDATE" />
		<xsl:element name="ORDINAL">
			<xsl:value-of select="position()" />
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template name="make-strAID">
	<xsl:if test="/CLIPSHEET/TARGET">
		<xsl:for-each select="/CLIPSHEET/TARGET">
			<xsl:value-of select="." />
			<xsl:if test="position()!=last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>