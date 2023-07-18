<?xml version='1.0'?>
<!-- Copyright Lone Buffalo, Inc.
$Revision:: 968                  $ : Revision number of this file
$Date:: 2012-05-11 10:41:09 -070#$ : date of given revision and copyright
$Author:: tech@lonebuffalo.com   $ : the author of the given revision
 Notes:
-->
<xsl:stylesheet version="2.0" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions" 
	exclude-result-prefixes="lbps xsl xs">
<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Kekst Standard Newletter Format</xsl:variable>
<xsl:variable name="apiroot" select="concat('https://subscriber-api.lonebuffalo.com/v1/clients/',string(/CLIPSHEET/@CID),'/')" />
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="pubDateFormat" select="string('[D1] [MNn] [Y]')"/>
<xsl:variable name="timeFormat" select="string('[h]:[m01] [PN]')" />
<xsl:variable name="clipDate" select="xs:dateTime(string(/CLIPSHEET/CREATE_DATE))"/>
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="topStories" select="$allowedArticles[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$allowedArticles[not(@TOPSTORY!=0)][not(@PARENT!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<xsl:variable name="FTXML" select="document(concat($apiroot,'/articles?story_ids=',$strAID))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="html" indent="yes" encoding="utf-8" />

<xsl:template match="/">
	<div class="WordSection1" style="font-family:Arial; font-size:10pt;">
		<xsl:call-template name="do-header" />
		<a name="Index"></a>
		<xsl:choose>
			<xsl:when test="$allowedArticles">
			<xsl:apply-templates select="$sectList" mode="TOC" >
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
			<xsl:apply-templates select="$sectList" mode="fulltext" >
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<p class="MsoNormal" align="center" style="text-align:center"><i><span style='font-size:10.0pt;color:#444444;'>
			No Relevant articles for <xsl:value-of select="format-dateTime($clipDate, $headerDateFormat,'en',(),())" />
			</span></i></p>
		</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

<xsl:template match="SECTION" mode="TOC">
	<xsl:variable name="sectID" select="ID" />
	<xsl:apply-templates select="NAME" mode="TOC" />
	<ul>
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@PARENT!=0)][not(@TOPSTORY!=0)]" mode="TOC">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	</ul>
</xsl:template>

<xsl:template match="SECTION" mode="fulltext">
	<xsl:variable name="sectID" select="ID" />
	<xsl:apply-templates select="NAME" mode="fulltext" />
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@PARENT!=0)][not(@TOPSTORY!=0)]" mode="fulltext" >
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="fulltext">
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<h2><a name="{$id}"></a>
		<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />
		&#x02014;
		<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />	
	</h2>
	<p class="MsoNormal"><b><xsl:apply-templates select="AUTHOR" /></b></p>
	<p class="MsoNormal"><b><xsl:apply-templates select="@PUBLISHDATE" /></b></p>
	<p class="MsoNormal"></p>
	<p class="MsoNormal">
	<xsl:if test="string-length(SRCURL)">
		<a href="{SRCURL}">View on the web</a>
	</xsl:if>
	<xsl:call-template name="ARTICLEBODY">
		<xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$id]/ARTICLEBODY" />
	</xsl:call-template>
	</p>
	<p class="MsoNormal"></p>
	<p class="MsoNormal"><a href="#Index">Return to index</a></p>
	<p class="MsoNormal">&#xa0;</p>
	<p class="MsoNormal">&#xa0;</p>
	<xsl:apply-templates select="$children" mode="fulltext">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="TOC">
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<li class="MsoListParagraph" style="mso-margin-top-alt:12.0pt;margin-right:0in;margin-bottom:12.0pt;margin-left:.5in;mso-list:l0 level1 lfo2">
		<a href="#{$id}">
		<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />
		&#x02014;
		<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
		</a>
		<xsl:if test="$children">
		<ul>
		<xsl:apply-templates select="$children" mode="TOC">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
		</ul>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template match="NAME" mode="TOC">
	<p class="MsoNormal">&#xa0;</p>
	<div style="mso-element:para-border-div;border:solid white 1.0pt;padding:1.0pt 4.0pt 1.0pt 4.0pt;background:#525357">
		<p class="Greyheader" style="background:#525357">
		<xsl:value-of select="." />
		</p>
	</div>
</xsl:template>

<xsl:template match="NAME" mode="fulltext">
	<p class="MsoNormal">&#xa0;</p>
	<div style="mso-element:para-border-div;border:solid white 1.0pt;padding:1.0pt 4.0pt 1.0pt 4.0pt;background:#525357">
		<p class="Greyheader" style="background:#525357">
		<xsl:value-of select="." /> Full Text
		</p>
	</div>
	<p class="MsoNormal">&#xa0;</p>
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:choose>
	<xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
	<xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
	<xsl:otherwise />
	</xsl:choose>
	<xsl:if test="position()=1">By </xsl:if><xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<p style="margin-bottom:0in; font-weight:normal">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</p>
</xsl:template>

<xsl:template name="do-header">
	<p class="MsoNormal" align="center" style="text-align:center"><b><span style='font-size:12.0pt;color:#411C5A'>
	<xsl:value-of select="concat(string(/CLIPSHEET/@CLIENT),' ',string(/CLIPSHEET/@NAME))" />
	</span></b></p>
	<p class="MsoNormal" align="center" style="text-align:center"></p>
	<p class="MsoNormal" align="center" style="text-align:center"><b><i><span style="color:#525357">
	<xsl:value-of select="format-dateTime($clipDate, $headerDateFormat,'en',(),())" />
	</span></i></b></p>
	<p class="MsoNormal" align="center" style="text-align:center"><b><i><span style="color:#525357">
	<xsl:value-of select="format-dateTime($clipDate, $timeFormat, 'en', (), ())" /> ET
	</span></i></b></p>
	<p class="MsoNormal" align="center" style="text-align:center"></p>
	<div class="MsoNormal" align="center" style="text-align:center"><hr size="2" width="100%" align="center" /></div>
</xsl:template>

<xsl:template name="make-strAID">
	<xsl:if test="$allowedArticles/@ID!=0">
		<xsl:for-each select="$allowedArticles/@ID">
			<xsl:value-of select="." />
			<xsl:if test="position()!=last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
