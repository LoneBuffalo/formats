<?xml version='1.0'?>
<!-- 
Copyright Lone Buffalo, Inc.
$Revision:: 968                  $ : Revision number of this file
$Date:: 2012-05-11 10:41:09 -070#$ : date of given revision and copyright
$Author:: tech@lonebuffalo.com   $ : the author of the given revision
 Notes:
 	Issues act as subsections
 	Top Stories treated specially; custom articles not linked to (dead-headlines)
-->
<xsl:stylesheet version="2.0" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs xsl lbps #default">
<xsl:import href="https://LB_CDN_BASE/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Abstracts with TOC</xsl:variable>
<xsl:variable name="pubDateFormat" select="string('[MNn,*-3] [D1] [Y]')"/>
<xsl:variable name="tocDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="webroot" select="string(/CLIPSHEET/LB_URL)" />
<xsl:variable name="internalroot" select="string(/CLIPSHEET/MAILURL)" />
<xsl:variable name="webVersionURL" select="string(/CLIPSHEET/WEBVERSIONURL)" />
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[FNn], [MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="/CLIPSHEET/CREATE_DATE" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="fullArticleList" select="$allowedArticles/@ID[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID] | $allowedArticles/@ID[not(boolean($thisDiv))]" />
<xsl:variable name="clipBrand" select="$allowedArticles[@ID=$fullArticleList]" />
<xsl:variable name="topStories" select="$clipBrand[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="clipFullText" select="$clipBrand[not(SRCURL/@REDIRECT=1)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$clipBrand[not(@PARENT!=0)][not(@TOPSTORY!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strLogo" select="string('http://images.lonebuffalo.com/graphics/SKDKLogo.png')" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="contact" select="string('skdk@lonebuffalo.com')"/>
<xsl:variable name="minWidth" select="string('480px;')" />
<xsl:variable name="width" select="string('680px;')" />
<xsl:variable name="FTXML" select="document(concat($webroot,'?story_id=0'))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:template match="/">
<body lang="EN-US">
<table xsl:use-attribute-sets="table" id="globalTable">
<tbody>
<tr>
<td valign="top" id="emailContainer">
	<div align="center">
	<table xsl:use-attribute-sets="tblFrame" id="newsletter">
	<tbody>
	<tr>
	<td id="headerContent">
		<table xsl:use-attribute-sets="table">
		<tbody>
		<tr>
		<td>

		<xsl:call-template name="do-report-head" />

		</td>
		</tr>
		</tbody>
		</table>
	</td>
	</tr>
	<tr>
	<td id="bodyContent">
		<table border="0" cellspacing="0" cellpadding="0">
		<tbody>
		<tr>
		<td style="page-break-after:always;margin-bottom:2em;padding-bottom:2em;">

		<xsl:call-template name="do-toc" />

		</td>
		</tr>
		<tr>
		<td>

		<xsl:call-template name="do-ft" />

		</td>
		</tr>
		</tbody>
		</table>
	</td>
	</tr>
<xsl:if test="string-length(/CLIPSHEET/BOTMSG)">
	<tr>
	<td  id="footerContent">
		<table border="0" cellspacing="0" cellpadding="0">
		<tbody>
		<tr>
		<td>
			<xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/BOTMSG" />
		</td>
		</tr>
		</tbody>
		</table>
	</td>
	</tr>
</xsl:if>
	</tbody>
	</table>
	</div>
</td>
</tr>
</tbody>
</table>
</body>
</xsl:template>

<xsl:template name="do-toc">
	<xsl:if test="$topStories">
		<table xsl:use-attribute-sets="table" id="topstories">
		<tbody>
		<xsl:call-template name="do-section-header">
			<xsl:with-param name="sectName" select="$topStoriesLabel" />
			<xsl:with-param name="nav" select="0" />
		</xsl:call-template>
		<xsl:apply-templates select="$topStories" mode="toc">
			<xsl:sort select="@TOPSTORY" data-type="number" />
		</xsl:apply-templates>
		</tbody>
		</table>
	</xsl:if>
	<xsl:apply-templates select="$sectList" mode="toc">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="do-ft">
	<xsl:if test="$topStories">
		<table xsl:use-attribute-sets="table">
		<tbody>
		<xsl:call-template name="do-section-header">
			<xsl:with-param name="sectName" select="$topStoriesLabel" />
			<xsl:with-param name="nav" select="0" />
		</xsl:call-template>
		<xsl:apply-templates select="$topStories" mode="ft">
			<xsl:sort select="@TOPSTORY" data-type="number" />
		</xsl:apply-templates>
		</tbody>
		</table>
	</xsl:if>
	<xsl:apply-templates select="$sectList" mode="ft">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="toc">
<xsl:variable name="sectID" select="ID" />
	<xsl:variable name="sectArticles" select="$clipBrand[SECTION/@ID=$sectID][not(@PARENT!=0)]"/>
	<xsl:variable name="sDivs" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$sectArticles/@ID]" />
	<table xsl:use-attribute-sets="table">
		<tbody>
		<xsl:call-template name="do-section-header">
			<xsl:with-param name="sectName" select="NAME" />
			<xsl:with-param name="nav" select="0" />
		</xsl:call-template>
		<xsl:apply-templates select="$sDivs" mode="toc">
			<xsl:with-param name="sArticles" select="$sectArticles" />
			<xsl:sort select="@NAME" data-type="text" />
		</xsl:apply-templates>
		<!-- get the orphans for this section -->
		<xsl:apply-templates select="$sectArticles[not(@ID=/CLIPSHEET/DIVISION/ARTICLE/@ID)]" mode="toc" >
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
		</tbody>
	</table>
</xsl:template>

<xsl:template match="SECTION" mode="ft">
<xsl:variable name="sectID" select="ID" />
	<xsl:variable name="sectArticles" select="$clipBrand[SECTION/@ID=$sectID][not(@PARENT!=0)]"/>
	<xsl:variable name="sDivs" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$sectArticles/@ID]" />
	<table xsl:use-attribute-sets="table">
		<tbody>
		<xsl:call-template name="do-section-header">
			<xsl:with-param name="sectName" select="NAME" />
			<xsl:with-param name="nav" select="0" />
		</xsl:call-template>
		<xsl:apply-templates select="$sDivs" mode="ft">
			<xsl:with-param name="sArticles" select="$sectArticles" />
			<xsl:sort select="@NAME" data-type="text" />
		</xsl:apply-templates>
		<!-- get the orphans for this section -->
		<xsl:apply-templates select="$sectArticles[not(@ID=/CLIPSHEET/DIVISION/ARTICLE/@ID)]" mode="ft" >
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
		</tbody>
	</table>
</xsl:template>

<xsl:template match="DIVISION" mode="toc">
	<xsl:param name="sArticles" />
	<xsl:variable name="divID" select="@ID" />
	<xsl:variable name="divArticles" select="$sArticles[@ID=/CLIPSHEET/DIVISION[@ID=$divID]/ARTICLE/@ID][not(@ID=/CLIPSHEET/DIVISION[@ID=$divID]/preceding-sibling::DIVISION/ARTICLE/@ID)]" />
	<xsl:if test="count($divArticles)">
		<tr><td class="name">
		<xsl:value-of disable-output-escaping="yes" select="@NAME" />
		</td></tr>
		<tr><td>
		<table class="portfolio"><tbody>
		<xsl:apply-templates select="$divArticles" mode="toc">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
		</tbody></table>
		</td></tr>
	</xsl:if>
</xsl:template>

<xsl:template match="DIVISION" mode="ft">
	<xsl:param name="sArticles" />
	<xsl:variable name="divID" select="@ID" />
	<xsl:variable name="divArticles" select="$sArticles[@ID=/CLIPSHEET/DIVISION[@ID=$divID]/ARTICLE/@ID][not(@ID=/CLIPSHEET/DIVISION[@ID=$divID]/preceding-sibling::DIVISION/ARTICLE/@ID)]" />
	<xsl:if test="count($divArticles)">
<!--		<tr><td class="name">
		<xsl:value-of disable-output-escaping="yes" select="@NAME" />
		</td></tr> -->
		<xsl:apply-templates select="$divArticles" mode="ft">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

<xsl:template match="ARTICLE" mode="toc">
	<tr><td class="article">
		<a href="#{@ID}" name="back{@ID}">
		<xsl:apply-templates select="PUBLICATION" mode="toc"/>
		<xsl:apply-templates select="HEADLINE" mode="toc" />
		<xsl:apply-templates select="@PUBLISHDATE" mode="toc"/>
		</a>
	</td></tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="ft">
	<xsl:variable name="aid" select="@ID" />
	<tr><td align="right" style="text-align:right;"><a style="text-size:x-small;font-style:italic;" name="{@ID}" href="#back{@ID}">back</a></td></tr>
	<tr><td style="margin-bottom:1em;padding-bottom:1em;page-break-after:always;">
		<p class="hed"><xsl:apply-templates select="HEADLINE" mode="ft" /></p>
		<p class="author"><xsl:apply-templates select="AUTHOR" /></p>
		<p class="publication"><xsl:apply-templates select="PUBLICATION" mode="ft"/></p>
		<p class="publishdate"><xsl:apply-templates select="@PUBLISHDATE" mode="ft" /></p>
		<ARTICLEBODY>
			<xsl:apply-templates select="ABSTRACT" />
		</ARTICLEBODY>
		<xsl:if test="$allowedArticles[@PARENT=$aid]">
			<ul>
			<xsl:apply-templates select="$allowedArticles[@PARENT=$aid]" mode="relatedArticle">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
			</xsl:apply-templates>
			</ul>
		</xsl:if>
	</td></tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="relatedArticle">
	<li>
	<a style="margin-right:1em;">
		<xsl:attribute name="href">
		<xsl:choose>
			<xsl:when test="SRCURL/@REDIRECT=1">
				<xsl:value-of select="SRCURL" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($internalroot,@ID)" />
			</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />		
	</a>
	<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />
	</li>
</xsl:template>

<xsl:template name="do-section-header">
	<xsl:param name="sectName" />
	<xsl:param name="nav" select="1" />
	<tr><td style="padding:0px;border-top:solid #EFEFED 1.0pt;">
		<table width="100%">
			<tbody>
				<tr><td class="section" width="80%">
			<xsl:value-of disable-output-escaping="yes" select="$sectName" /><a name="{$sectName}">&#xa0;</a>
			</td></tr></tbody>
		</table>
	</td></tr>
</xsl:template>

<xsl:template match="HEADLINE" mode="toc">
	<xsl:value-of select="." />
</xsl:template>

<xsl:template match="HEADLINE" mode="ft">
		<xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="PUBLICATION" mode="toc">
	<xsl:value-of disable-output-escaping="yes" select="." /> &#8212;
</xsl:template>

<xsl:template match="PUBLICATION" mode="ft">
	<xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="@PUBLISHDATE" mode="toc">
	<xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
	(<xsl:value-of select="format-date(xs:date(substring($strDate,1,10)), $tocDateFormat,'en',(),())" />)
</xsl:template>

<xsl:template match="@PUBLISHDATE" mode="ft">
	<xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
	<xsl:value-of select="format-date(xs:date(substring($strDate,1,10)), $pubDateFormat,'en',(),())" />
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:if test="position()=1">By </xsl:if>
    <xsl:choose>
    <xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
    <xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
    <xsl:otherwise /> <!-- not between authors, do nothing special -->
    </xsl:choose>
    <xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="SRCURL">
		<a class="extLink" href="{string(.)}" target="_blank">full story at source site</a>
</xsl:template>

<xsl:template match="ABSTRACT">
	<div class="articleBody">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
		<xsl:apply-templates select="../SRCURL" />
	</div>
</xsl:template>

<xsl:template name="do-report-head">
	<table xsl:use-attribute-sets="table">
		<tbody>
			<tr><td align="right" style="text-align:right;width:100%;"><a style="font-size:xx-small;" href="{$webVersionURL}">web version</a></td></tr>
			<tr><td valign="middle" height="50" style="height:50px;vertical-align:middle;">
				<img src="{$strLogo}" class="logo" style="vertical-align:middle;" />
				<span class="bannerTitle">&#xa0;<xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/@NAME" /></span>
			</td></tr>
			<xsl:if test="string-length(/CLIPSHEET/TOPMSG)">
			<tr><td>
				<xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/TOPMSG" />
			</td></tr>
			</xsl:if>
		</tbody>
	</table>
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<div class="articleBody">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</div>
</xsl:template>

<xsl:template name="make-strAID">
	<xsl:if test="$clipBrand/@ID!=0">
		<xsl:for-each select="$clipFullText/@ID">
			<xsl:value-of select="." />
			<xsl:if test="position()!=last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:attribute-set name="table">
	 <xsl:attribute name="width">100%</xsl:attribute>
	 <xsl:attribute name="border">0</xsl:attribute>
	 <xsl:attribute name="cellspacing">0</xsl:attribute>
	 <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="tblFrame">
	 <xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
	 <xsl:attribute name="border">0</xsl:attribute>
	 <xsl:attribute name="cellspacing">0</xsl:attribute>
	 <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
