<?xml version='1.0'?>
<!--  Copyright Lone Buffalo, Inc.
 Notes: Incorporate shell xsl from other file 
-->
<xsl:stylesheet version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs xsl lbps #default">
<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/Keywords.xsl"/>
<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/WatchReport2v01.xsl"/>
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/tableShell.xsl"/>
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/clientvars.xsl"/>

<xsl:variable name="formatName">Generic Newsletter format</xsl:variable>
<xsl:variable name="pubDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="tocName" select="string('TABLE OF CONTENTS')"/>
<xsl:variable name="webroot" select="string(/CLIPSHEET/LB_URL)" />
<xsl:variable name="footer" select="document(concat($webroot,'XML/footer/'))"/>
<xsl:variable name="internalroot" select="string(/CLIPSHEET/MAILURL)" />
<xsl:variable name="webVersionURL" select="/CLIPSHEET/WEBVERSIONURL" />
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="/CLIPSHEET/CREATE_DATE" />
<xsl:variable name="region" select="translate(string(/CLIPSHEET/REGION),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="fullArticleList" select="$allowedArticles/@ID[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID] | $allowedArticles/@ID[not(boolean($thisDiv))]" />
<xsl:variable name="clipArticles" select="$allowedArticles[@ID=$fullArticleList]" />
<xsl:variable name="parents" select="$clipArticles[not(@PARENT!=0)]" />
<xsl:variable name="topStories" select="$parents[@TOPSTORY!=0]" />
<xsl:variable name="clipFullText" select="$clipArticles[not(SRCURL/@REDIRECT=1)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$parents[not(@TOPSTORY!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="doFT" select="1" />
<xsl:variable name="minWidth" select="string('400px')" />
<xsl:variable name="width" select="string('680px')" />
<xsl:variable name="fontSize" select="string('12pt')" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>

<xsl:variable name="FTXML" select="document(concat($webroot,'XML/stdFullStory?story_id=',$strAID))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>

<xsl:template match="/">
    <xsl:call-template name="do-shell" />
</xsl:template>

<xsl:template name="do-newsletter">
    <xsl:call-template name="do-head" />
    <xsl:choose>
        <xsl:when test="$parents">
            <xsl:call-template name="do-toc" />
            <xsl:if test="$doFT = 1">
                <xsl:call-template name="do-fulltext" />
            </xsl:if>
            <xsl:call-template name="do-footer" />
        </xsl:when>
        <xsl:otherwise>
            <ul style="margin:0;padding:2em;">
                <li style="margin:0;padding:0;padding-bottom:10px;font-size:{$fontSize};font-family:Arial;display:list-item;list-style-type:disc;list-style-position:inside;mso-special-format:bullet;">
                No relevant coverage today.</li>
            </ul>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="do-head">
    <xsl:apply-templates select="/CLIPSHEET/TOPMSG" />
    <div class="header" style="border-bottom:solid 1px #333333; padding-bottom:10px;">
        <table cellspacing="0" cellpadding="0" style="width:100%;font-family:Arial;">
            <tr>
                <td colspan="2" style="width:100%;">
                    <img src="{$assetroot}{$brandImage}" alt="{$clientName}" style=""/>
                </td>
            </tr>
            <tr>
                <td style="padding-top:10px;">
            <xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/@NAME" />
                </td>
                <td style="text-align:right;" >
            <xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" />
                </td>
            </tr>
        </table>
    </div>
    <xsl:if test="$topStories">
    <xsl:call-template name="do-docsection-head">
        <xsl:with-param name="sName" select="$topStoriesLabel" />
    </xsl:call-template>
    <div style="margin:0;padding:0;padding-bottom:.3em;">
        <xsl:apply-templates select="$topStories" mode="top" />
    </div>
    </xsl:if>
</xsl:template>

<xsl:template name="do-toc">
    <xsl:apply-templates select="$sectList" mode="toc">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates> 
</xsl:template>

<xsl:template name="do-fulltext">
    <xsl:apply-templates select="$sectList" mode="fulltext">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="TOPMSG">
    <div style="border:none;border-bottom:solid windowtext 1.0pt;padding:0in 0in 1.0pt 0in">
        <p><xsl:value-of disable-output-escaping="yes" select="." /></p>
    </div>
</xsl:template>

<xsl:template match="BOTMSG">
    <div style="border:none;border-top:solid windowtext 1.0pt;padding:0in 0in 1.0pt 0in">
        <p><xsl:value-of disable-output-escaping="yes" select="." /></p>
    </div>
</xsl:template>

<xsl:template name="do-docsection-head">
    <xsl:param name="sName" />
    <p style="font-size:18.0pt;font-family:Arial,sans-serif;color:#959A71;margin-bottom:.2em;padding-bottom:.2em;">
        <xsl:value-of select="$sName" />
    </p>
</xsl:template>

<xsl:template match="SECTION" mode="toc">
    <xsl:variable name="sid" select="ID" />
    <xsl:variable name="sArticles" select="$parents[SECTION/@ID=$sid][not(@TOPSTORY!=0)]" />
    <xsl:variable name="iArticles" select="$sArticles[@ID=/CLIPSHEET/ISSUE/ARTICLE/@ID]" />
    <xsl:variable name="niArticles" select="$sArticles[not(@ID=$iArticles/@ID)]" />
    <xsl:variable name="iss" select="/CLIPSHEET/ISSUE[ARTICLE/@ID=$iArticles/@ID]" />
	<xsl:if test="count($sArticles)">
        <xsl:apply-templates select="." mode="head" />
        <ul style="margin:0;padding:0;">
            <xsl:apply-templates select="$iss" mode="toc">
                    <xsl:with-param name="articles" select="$iArticles" />
                    <xsl:sort select="@ORDINAL" data-type="number" />
                    <xsl:sort select="@NAME" data-type="text" />
            </xsl:apply-templates>
            <xsl:choose>
                    <xsl:when test="count($iArticles) &gt; 1 and count($niArticles) &gt; 1">
                            <xsl:variable name="addlName" select="concat('Additional ',NAME)" />
                            <xsl:call-template name="do-issue-header">
                                    <xsl:with-param name="iName" select="$addlName" />
                            </xsl:call-template>
                        <ul>
                            <xsl:apply-templates select="$niArticles" mode="toc">
                                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            </xsl:apply-templates>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:apply-templates select="$niArticles" mode="toc">
                                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            </xsl:apply-templates>
                    </xsl:otherwise>
            </xsl:choose>
	</ul>
	</xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="fulltext">
    <xsl:variable name="sid" select="ID" />
    <xsl:variable name="sArticles" select="$parents[SECTION/@ID=$sid][not(@TOPSTORY!=0)]" />
    <xsl:variable name="iArticles" select="$sArticles[@ID=/CLIPSHEET/ISSUE/ARTICLE/@ID]" />
    <xsl:variable name="niArticles" select="$sArticles[not(@ID=$iArticles/@ID)]" />
    <xsl:variable name="iss" select="/CLIPSHEET/ISSUE[ARTICLE/@ID=$iArticles/@ID]" />
	<xsl:if test="count($sArticles)">
        <xsl:apply-templates select="." mode="head" />
            <xsl:apply-templates select="$iss" mode="fulltext">
                    <xsl:with-param name="articles" select="$iArticles" />
                    <xsl:sort select="@ORDINAL" data-type="number" />
                    <xsl:sort select="@NAME" data-type="text" />
            </xsl:apply-templates>
            <xsl:choose>
                    <xsl:when test="count($iArticles) &gt; 1 and count($niArticles) &gt; 1">
                            <xsl:variable name="addlName" select="concat('Additional ',NAME)" />
                            <xsl:call-template name="do-issue-header">
                                    <xsl:with-param name="iName" select="$addlName" />
                            </xsl:call-template>
                            <xsl:apply-templates select="$niArticles" mode="fulltext">
                                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:apply-templates select="$niArticles" mode="fulltext">
                                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            </xsl:apply-templates>
                    </xsl:otherwise>
            </xsl:choose>
    </xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="head">
    <p style="font-size:14.0pt;font-family:Arial,sans-serif;color:#301543"><a name="_Toc{./ID}"></a>
        <xsl:value-of disable-output-escaping="yes" select="NAME" />
    </p>
</xsl:template>

<xsl:template match="ISSUE" mode="toc">
	<xsl:param name="articles" />
	<xsl:variable name="aids" select="ARTICLE/@ID" />
		<xsl:call-template name="do-issue-header">
			<xsl:with-param name="iName" select="@NAME" />
		</xsl:call-template>
	<ul>
		<xsl:apply-templates select="$articles[@ID=$aids]" mode="toc">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
	</ul>
    </xsl:template>

<xsl:template match="ISSUE" mode="fulltext">
	<xsl:param name="articles" />
	<xsl:variable name="aids" select="ARTICLE/@ID" />
		<xsl:call-template name="do-issue-header">
			<xsl:with-param name="iName" select="@NAME" />
		</xsl:call-template>
		<xsl:apply-templates select="$articles[@ID=$aids]" mode="fulltext">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="top">
    <p style="margin:0;padding:0;">
        <xsl:value-of disable-output-escaping="yes" select="ABSTRACT" />
    </p>
</xsl:template>

<xsl:template match="ARTICLE" mode="toc">
    <xsl:variable name="aid" select="@ID" />
    <xsl:variable name="kids" select="$clipArticles[@PARENT=$aid]" />
    <li style="margin:0;padding:0;padding-bottom:10px;font-size:{$fontSize};font-family:Arial;display:list-item;list-style-type:disc;list-style-position:inside;mso-special-format:bullet;">
        <a name="toc{$aid}" id="toc{$aid}">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$doFT = 1">
                        <xsl:value-of select="concat('#',$aid)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="SRCURL" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />
        &#8211;
        <xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
    </a>
    <xsl:apply-templates select="ABSTRACT" mode="toc" />
    </li>
    <xsl:apply-templates select="$kids" mode="toc">
        <xsl:sort select="SECTION/@ORDINAL" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="fulltext">
    <xsl:variable name="aid" select="@ID" />
    <xsl:variable name="kids" select="$clipArticles[@PARENT=$aid]" />
    <p style="padding:0;margin:0;font-size:{$fontSize};font-family:Arial;">
        <a name="{$aid}" id="{$aid}">
            <b>
            <xsl:value-of select="PUBLICATION" />
            &#8211; 
            <xsl:value-of select="HEADLINE" />
            </b>
        </a>
    </p>
    <p style="padding:0;margin:0;font-size:{$fontSize};font-family:Arial;">
        <b><xsl:value-of select="AUTHOR" /></b>
    </p>
    <p style="margin:0;padding:0;">
        <xsl:apply-templates select="@PUBLISHDATE" />
    </p>
    <div style="padding:0;margin:0;font-size:{$fontSize};font-familiy:Arial;">
    <xsl:choose>
        <xsl:when test="SRCURL/@REDIRECT=1">
            <xsl:apply-templates select="ABSTRACT" mode="ftsubstitute" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="ARTICLEBODY">
                    <xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$aid]/ARTICLEBODY" />
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
    <div style="width:95%;text-align:right;">
        <a href="#toc{$aid}" style="font-size:small;font-style:italic;">back to top</a>
    </div>
    <p>&#xa0;</p>
    </div>
    <xsl:apply-templates select="$kids" mode="fulltext">
        <xsl:sort select="SECTION/@ORDINAL" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
	<xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
        <b style="font-size:{$fontSize};">
            <xsl:value-of select="format-date(xs:date(substring($strDate,1,10)), $pubDateFormat,'en',(),())" />
        </b>
</xsl:template>

<xsl:template match="ABSTRACT" mode="toc">
    <div style="margin:0;padding:0;padding-top:5px;padding-bottom:10px;">
        <xsl:if test="string-length(../THUMBNAIL) &gt; 0">
            <img src="{../THUMBNAIL}" alt="{../@ID} thumb" align="right" />
        </xsl:if>
        <xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
        <br clear="all" />
	</div>
</xsl:template>

<xsl:template match="ABSTRACT" mode="ftsubstitute">
	<div style="margin-top:.3em;padding-top:.3em;padding-bottom:1em;margin-bottom:1em;">
            <xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
            <xsl:apply-templates select="../SRCURL" />
	</div>
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<div style="margin-top:.3em;padding-top:.3em;padding-bottom:1em;margin-bottom:1em;">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</div>
</xsl:template>

<xsl:template match="ARTICLE/SRCURL">
    <p style="padding-top5px;padding-left:15px;font-size:small;font-style:italic;">
        <a href="{string(.)}">view full text at source . . . </a>
    </p>
</xsl:template>

<xsl:template name="do-issue-header">
	<xsl:param name="iName" />
	<div class="issue">
		<xsl:value-of disable-output-escaping="yes" select="$iName" />
	</div>
</xsl:template>

<xsl:template name="do-footer">
    <xsl:apply-templates select="/CLIPSHEET/BOTMSG" />
    <xsl:value-of disable-output-escaping="yes" select="$footer" />
</xsl:template>

<xsl:template name="make-strAID">
	<xsl:if test="$clipFullText/@ID!=0">
		<xsl:for-each select="$clipFullText/@ID">
			<xsl:value-of select="." />
			<xsl:if test="position()!=last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
