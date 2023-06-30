<?xml version='1.0'?>
<!-- 
Copyright Lone Buffalo, Inc.
$Revision:: 968                  $ : Revision number of this file
$Date:: 2012-05-11 10:41:09 -070#$ : date of given revision and copyright
$Author:: tech@lonebuffalo.com   $ : the author of the given revision
 Notes:
-->
<xsl:stylesheet version="2.0" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions" >

<xsl:variable name="formatName">PepperComm 2</xsl:variable>
<xsl:variable name="webroot" select="string(/CLIPSHEET/LB_URL)" />
<xsl:variable name="topStoriesLabel" select="string('Highlights')"/>
<xsl:variable name="dateArg" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[D1] [MNn] [Y]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/RELEASE_DATE)" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="region" select="translate(string(/CLIPSHEET/REGION),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$allowedArticles[not(@PARENT!=0)][not(@CITEONLY=1)]/SECTION/@ID][DISPLAY!=0]" />
<xsl:variable name="topStories" select="$allowedArticles[@TOPSTORY!=0][not(@PARENT!=0)][not(@CITEONLY=1)]" />

<xsl:output method="html" indent="yes" encoding="utf-8" />

<xsl:template match="/">
        <xsl:call-template name="do-head"/>
        <xsl:if test="$topStories">
                <xsl:call-template name="do-section-header">
                        <xsl:with-param name="sectName" select="$topStoriesLabel" />
                </xsl:call-template>
                <xsl:apply-templates select="$topStories">
                        <xsl:sort select="@TOPSTORY" data-type="number" />
                </xsl:apply-templates>
        </xsl:if>
        <xsl:for-each select="$sectList">
                <xsl:sort select="ORDINAL" data-type="number" />
                <xsl:apply-templates select="." />
        </xsl:for-each>
</xsl:template>

<xsl:template match="SECTION">
	<xsl:variable name="sectID" select="ID"/>
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@PARENT!=0)]">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE">
    <p class="c0"><span class="c1">
	<xsl:value-of disable-output-escaping="yes" select="PUBLICATION"/>, <xsl:apply-templates select="@PUBLISHDATE"/>
    </span></p>
    <p class="c0">
        <span class="c1"><xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
    </span></p>
    <xsl:apply-templates select="ABSTRACT" />
    <xsl:apply-templates select="SRCURL" />
    <p class="c0 c2"><span class="c1"></span></p>
</xsl:template>

<xsl:template match="SRCURL">
    <p class="c0">
        <span class="c5">
            <a class="c6" href="{.}"><xsl:value-of select="." /></a>
        </span>
    </p>
</xsl:template>

<xsl:template name="do-section-header">
	<xsl:param name="sectName" />
        <p class="c0"><span class="c3">
	<xsl:value-of disable-output-escaping="yes" select="$sectName" />
        </span></p>
        <p class="c0 c2"><span class="c1"></span></p>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
	<xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
	<xsl:value-of select="format-date(xs:date($strDate), $headerDateFormat,'en',(),())" />
</xsl:template>

<xsl:template match="ABSTRACT">
    <p class="c0">
        <span class="c1"><xsl:value-of disable-output-escaping="yes" select="." />
    </span></p>
</xsl:template>

<xsl:template match="AUTHOR">
<xsl:if test="position()=1"> -- By </xsl:if>
    <xsl:choose>
    <xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
    <xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
    <xsl:otherwise /> <!-- not between authors, do nothing special -->
    </xsl:choose>
    <xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template name="do-head">
    <p class="c0">
        <span class="c1"><xsl:value-of select="format-dateTime(xs:dateTime($clipDate), $headerDateFormat,'en',(),())" /></span>
    </p>
    <p class="c0 c2"><span class="c3"></span></p>
</xsl:template>
	 
</xsl:stylesheet>
