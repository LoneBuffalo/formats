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
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="xs xsl lbps xhtml">

        <xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Iroquois fulltext</xsl:variable>
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="webVersionURL" select="/CLIPSHEET/WEBVERSIONURL" />
<xsl:variable name="ClientName" select="/CLIPSHEET/CLIENT" />
<xsl:variable name="topMsg" select="/CLIPSHEET/TOPMSG" />
<xsl:variable name="botMsg" select="/CLIPSHEET/BOTMSG" />
<xsl:variable name="clipDate" select="string(/CLIPSHEET/LOCAL_DATE)" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[Y0001]-[M01]-[D01]')"/>
<xsl:variable name="dateArg" select="format-date(xs:date(substring($clipDate,1,10)), $dateArgFormat,'en',(),())"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="pubDateFormat" select="string('[FNn,*-3], [D1] [MNn,*-3] [Y]')"/>
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="parents" select="$allowedArticles[not(@PARENT!=0)]" />
<xsl:variable name="children" select="$allowedArticles[@PARENT!=0]" />
<xsl:variable name="topStories" select="$parents[@TOPSTORY!=0]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$parents[not(@TOPSTORY!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<xsl:variable name="FTXML" select="document(concat($webroot,'XML/stdFullStory?story_id=',$strAID))"/>

<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />

<xsl:template match="/">
	<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" style="margin:0;padding:0;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;height:100% !important;width:100% !important;">
	<center>
	<div style="font-family:Arial;">
		<table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;margin:0;padding:0;height: 100% !important;width: 100% !important;">
			<tr>
			<td align="center" valign="top" id="bodyCell" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;margin: 0;padding: 20px;border-top: 0;height: 100% !important;width: 100% !important;">
			<xsl:call-template name="begin-template" />
			</td>
			</tr>
		</table>
	</div>
	</center>
	</body>
</xsl:template>

<xsl:template name="begin-template">
	<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;border: 0;">
		<tr>
		<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
			<xsl:call-template name="do-preheader" />
		</td></tr>
		<tr><td>
			<xsl:call-template name="do-header" />
		</td></tr>
		<tr><td>
			<xsl:call-template name="do-content" />
		</td></tr>
		<tr><td>
			<xsl:call-template name="do-footer" />
		</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="do-preheader">
<table border="0" cellpadding="0" cellspacing="0" width="600" id="lbnlPreheader" style="border-collapse:collapse;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;border-top:0;border-bottom:0;">
	<tr>
	<td valign="top" class="preheaderContainer" style="padding-top:9px;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;">
		<table class="lbnlItemBlock" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
		<tbody class="lbnlItemBlockOuter">
		<tr>
		<td class="lbnlItemBlockInner" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
			<table class="lbnlItemContainer" align="left" border="0" cellpadding="0" cellspacing="0" width="366" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
			<tbody><tr>
			<td class="lbnlItem" style="padding-left:18px;padding-bottom:4px;padding-right:0;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;font-family:Helvetica;font-size:11px;line-height:125%;text-align:left;" valign="top">
			<xsl:if test="string-length($webVersionURL) &gt; 1">
				<a href="{$webVersionURL}">prefer this on the web?</a>
			</xsl:if> 
			</td>
			</tr>
			</tbody></table>
			<table class="lbnlItemContainer" align="right" border="0" cellpadding="0" cellspacing="0" width="197" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
			<tbody><tr>
			<td class="lbnlItem" style="padding-right:18px;padding-bottom:4px;padding-left:0;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;font-family:Helvetica;font-size:11px;line-height:125%;text-align:left;" valign="top">
			</td>
			</tr>
			</tbody></table>
		</td>
		</tr>
		</tbody>
		</table>
	</td>
	</tr>
</table>
</xsl:template>

<xsl:template name="do-header">
<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateHeader" style="border-collapse:collapse;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;border-top:0;border-bottom:0;">
<tr>
<td valign="top" class="headerContainer" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<table class="lbnlLogoBlock" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tbody class="lbnlLogoBlockOuter">
	<tr>
	<td style="padding: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="lbnlLogoBlockInner" valign="top">
		<table class="lbnlLogoContentContainer" align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
		<tbody><tr>
		<td class="lbnlLogoContent" style="padding-right: 9px;padding-left: 9px;padding-top: 0;padding-bottom: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" valign="top">
                    <div>
                       <xsl:value-of disable-output-escaping="yes" select="$topMsg" /> 
                    </div>
                    <div style="float:right;margin:0;padding:0;font-size:8pt;font-style:italic;">
                        <xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $pubDateFormat,'en',(),())" />
                    </div>
		</td>
		</tr>
		</tbody></table>
	</td>
	</tr>
	</tbody>
	</table>
</td>
</tr>
</table>
</xsl:template>

<xsl:template name="do-content">
<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateBody" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;border-top: 0;border-bottom: 0;">
<tr>
<td align="center" valign="top" width="590" class="lbnlArea" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateBodyInner" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tr>
	<td valign="top" class="bodyContainer" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<xsl:if test="$topStories">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="$topStoriesLabel" />
	</xsl:call-template>
	<xsl:apply-templates select="$topStories" mode="toc">
		<xsl:sort select="@TOPSTORY" data-type="number" />
	</xsl:apply-templates>
	</xsl:if>
	<xsl:apply-templates select="$sectList" mode="toc">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	</td>
	</tr>
	</table>
</td>
</tr>
<tr>
<td align="center" valign="top" width="590" class="lbnlArea" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateBodyInner" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tr>
	<td valign="top" class="bodyContainer" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<xsl:apply-templates select="$topStories" mode="main">
		<xsl:sort select="@TOPSTORY" data-type="number" />
	</xsl:apply-templates>
	<xsl:apply-templates select="$sectList" mode="main">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	</td>
	</tr>
	</table>

</td>
</tr>
</table>
</xsl:template>

<xsl:template match="ARTICLE" mode="main">
    <xsl:variable name="aid" select="@ID" />
    <xsl:variable name="kids" select="$children[@PARENT=$aid]" />
<table class="lbnlItemBlock" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
<tbody class="lbnlItemBlockOuter">
<tr>
<td class="lbnlItemBlockInner" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<a name="{$aid}" href="#t{$aid}" style="float:right;font-size:xx-small;font-style:italic;">back to top</a>
	<table class="lbnlItemContainer" align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tbody><tr>
	<td class="lbnlItem" style="padding-right:18px;padding-bottom:4px;padding-left:18px;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;font-family:Helvetica;font-size:15px;line-height:150%;text-align:left;" valign="top">
	<h3><xsl:value-of disable-output-escaping="yes" select="HEADLINE" /></h3>
        <p style="font-style:italic;margin:0;padding:0;padding-left:10pt;"><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></p>
        <p style="margin:0;padding:0;padding-left:10pt;">
	<xsl:apply-templates select="AUTHOR" />
        </p>
	<p style="margin:0;padding:0;padding-left:10pt;padding-bottom:10pt;"><xsl:apply-templates select="@PUBLISHDATE" /></p>
	<xsl:choose>
	<xsl:when test="SRCURL/@REDIRECT=1">
		<xsl:apply-templates select="ABSTRACT" />
		<xsl:apply-templates select="SRCURL" />
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="ARTICLEBODY">
			<xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$aid]/ARTICLEBODY" />
		</xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>
	</td>
	</tr>
	</tbody>
	</table>
</td>
</tr>
</tbody>
</table>
<xsl:apply-templates select="$kids" mode="main">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="toc">
    <xsl:variable name="aid" select="@ID" />
    <xsl:variable name="kids" select="$children[@PARENT=$aid]" />

<table class="lbnlItemBlock" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
<tbody class="lbnlItemBlockOuter">
<tr>
<td class="lbnlItemBlockInner" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;padding-bottom:24px;">
	<table class="lbnlItemContainer" align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tbody><tr>
	<td class="lbnlItem" style="padding-right:18px;padding-bottom:0;padding-left:18px;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;font-family:Helvetica;font-size:15px;line-height:150%;text-align:left;" valign="top">
	<a href="#{@ID}" name="t{@ID}">
	<h4><xsl:value-of disable-output-escaping="yes" select="HEADLINE" /></h4>
	</a>
        <PUBLICATION><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></PUBLICATION>  -- 
        <PUBLISHDATE><xsl:apply-templates select="@PUBLISHDATE" /></PUBLISHDATE>
        <div>
            <xsl:value-of disable-output-escaping="yes" select="ABSTRACT" />
        </div>
	</td>
	</tr>
	</tbody>
	</table>
        <xsl:apply-templates select="$kids" mode="kid">
            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
        </xsl:apply-templates>
</td>
</tr>
</tbody>
</table>
</xsl:template>

<xsl:template match="ARTICLE" mode="kid">
	<table class="lbnlItemContainer" align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tbody><tr>
	<td class="lbnlItem" style="padding-right:18px;padding-bottom:4px;padding-left:30px;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;font-family:Helvetica;font-size:15px;line-height:150%;text-align:left;" valign="top">
	<a href="#{@ID}" name="t{@ID}">
	<h5><xsl:value-of disable-output-escaping="yes" select="HEADLINE" /></h5>
	</a>
        <PUBLICATION><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></PUBLICATION>  -- 
        <PUBLISHDATE><xsl:apply-templates select="@PUBLISHDATE" /></PUBLISHDATE>
	</td>
	</tr>
	</tbody>
	</table>
</xsl:template>

<xsl:template match="SECTION" mode="toc">
	<xsl:variable name="sectID" select="ID" />
	<xsl:if test="count($parents[SECTION/@ID=$sectID][not(@TOPSTORY!=0)])">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
        <xsl:apply-templates select="$parents[SECTION/@ID=$sectID][not(@TOPSTORY!=0)]" mode="toc">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<!-- get the orphans for this section -->
	<xsl:apply-templates select="$children[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT=$parents/@ID)]" mode="toc">
            <xsl:with-param name="bAbs" select="0" />
            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
        </xsl:apply-templates>
	</xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="main">
	<xsl:variable name="sectID" select="ID" />
	<xsl:if test="count($parents[SECTION/@ID=$sectID][not(@TOPSTORY!=0)])">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<xsl:apply-templates select="$parents[SECTION/@ID=$sectID][not(@TOPSTORY!=0)]" mode="main">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<!-- get the orphans for this section -->
	<xsl:apply-templates select="$children[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT=$parents/@ID)]" mode="main" />
	</xsl:if>
</xsl:template>

<xsl:template match="@MEDIAID">
	<xsl:if test=". &gt; 0">
		<xsl:choose>
			<xsl:when test=".=1">[image]</xsl:when>
			<xsl:when test=".=2">[video]</xsl:when>
			<xsl:otherwise>[audio]</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
	<xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
	<xsl:value-of select="format-date(xs:date(substring($strDate,1,10)), $pubDateFormat,'en',(),())" />
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:choose>
	<xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
	<xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
	<xsl:otherwise />
	</xsl:choose>
	<xsl:if test="position()=1">By </xsl:if><xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="COPYRIGHT">
	<div>
		<span class="articleCopyright"><xsl:value-of disable-output-escaping="yes" select="." /></span>
	</div>
</xsl:template>

<xsl:template match="ABSTRACT">
	<ARTICLEBODY>
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
	</ARTICLEBODY>
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<ARTICLEBODY>
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</ARTICLEBODY>
</xsl:template>

<xsl:template match="SRCURL">
	<SRCURL>
		<a href="{string(.)}"><i>get the full story . . .</i></a>
	</SRCURL>
</xsl:template>

<xsl:template name="do-tags">
	<xsl:param name="AID" />
	<xsl:variable name="printTag" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$AID]" />
	<xsl:for-each select="$printTag">
		<span class="tag" style="font-size:x-small;font-style:italic;font-weight:normal;">
		<xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
		<xsl:value-of disable-output-escaping="yes" select="@NAME" />
		</span>
	</xsl:for-each>
</xsl:template>

<xsl:template name="do-section-header">
	<xsl:param name="sectName" />
	<div class="section">
		<xsl:value-of disable-output-escaping="yes" select="$sectName" />
	</div>
</xsl:template>

<xsl:template name="do-footer">
<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateFooter" style="border-collapse:collapse;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;border-top:0;border-bottom:0;">
<tr>
<td valign="top" class="footerContainer" style="padding-bottom:9px;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;">
	<table class="lbnlItemBlock" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse:collapse;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;">
	<tbody class="lbnlItemBlockOuter">
	<tr>
	<td class="lbnlItemBlockInner" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
		<table class="lbnlItemContainer" align="left" border="0" cellpadding="0" cellspacing="0" width="600" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
		<tbody>
		<tr>
		<td class="lbnlItem" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;" valign="top">
		<xsl:value-of disable-output-escaping="yes" select="$botMsg" />
		</td>
		</tr>
		</tbody>
		</table>
	</td>
	</tr>
	</tbody>
	</table>
</td>
</tr>
</table>
</xsl:template>

<xsl:template match="HEADER">
	<tr>
		<td colspan="2" valign="bottom" class="headerText">
			<xsl:value-of  disable-output-escaping="yes" select="CONTENT" />
		</td>
	</tr>
</xsl:template>

<xsl:template match="MENTION">
	<span class="mention" style="font-style:italic;margin-left:2em;"><xsl:value-of select="." /></span>
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
