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
	xmlns="http://www.w3.org/1999/xhtml">
<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Edelman Full Text</xsl:variable>
<xsl:variable name="apiroot" select="concat('https://subscriber-api.lonebuffalo.com/v1/clients/',string(/CLIPSHEET/@CID),'/')" />
<xsl:variable name="webroot" select="string(/CLIPSHEET/LB_URL)" />
<xsl:variable name="webVersionURL" select="/CLIPSHEET/WEBVERSIONURL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/RELEASE_DATE)" />
<xsl:variable name="region" select="translate(string(/CLIPSHEET/REGION),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="fullArticleList" select="$allowedArticles/@ID[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID] | $allowedArticles/@ID[not(boolean($thisDiv))]" />
<xsl:variable name="clipBrand" select="$allowedArticles[@ID=$fullArticleList]" />
<xsl:variable name="topStories" select="$clipBrand[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$clipBrand[not(@TOPSTORY!=0)][not(@PARENT!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<xsl:variable name="FTXML" select="document(concat($apiroot,'/articles?story_ids=',$strAID))"/>

<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" />

<xsl:template match="/">
	<table border="0" cellpadding="0" cellspacing="0" width="525" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
	<tbody><tr>
		<td><xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/TOPMSG" /></td>
		<td class="lbnlItem" style="padding-left:18px;padding-bottom:4px;padding-right:0;mso-table-lspace:0pt;mso-table-rspace:0pt;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;line-height:125%;text-align:right;" valign="top">
		<xsl:if test="string-length($webVersionURL) &gt; 1">
			<a href="{$webVersionURL}">web view</a>
		</xsl:if> 
		</td>
	</tr>
	</tbody></table>

	<table border="0" cellpadding="0">
		<tbody>
		<tr>
		<td width="525.0pt" style="border:solid #CCCCCC 1.0pt;padding:0.0pt 15.0pt 15.0pt 15.0pt">
		<div style="margin-left:.2em;margin-right:.2em;">
			<a name="NAV"></a>
			<xsl:apply-templates select="/CLIPSHEET/SECTION[NEWSLETTER!=0]" mode="ul">
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
			<xsl:apply-templates select="$sectList">
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
		</div>
		</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/BOTMSG" /></td>
		</tr>
		</tbody>
	</table>
</xsl:template>

<xsl:template match="SECTION">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<xsl:variable name="sectID" select="ID"/>
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="ul">
	<xsl:variable name="sectID" select="ID" />
	<xsl:call-template name="do-toc-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<ul style="margin:0px;margin-left:2px;">
	<xsl:choose>
	<xsl:when test="count($allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)])">
		<xsl:for-each select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
			<xsl:apply-templates select="." mode="ul" />
		</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
		<li style="margin:0px;">N/A</li>
	</xsl:otherwise>
	</xsl:choose>
	</ul>
</xsl:template>

<xsl:template match="ARTICLE">
	<xsl:variable name="backNav">
	<xsl:choose>
	<xsl:when test="position() &gt; 0">1</xsl:when>
	<xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>	
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<div class="article" style="margin:0px;">
		<a name="{@ID}" id="{@ID}" />
		<table width="525">
			<tr>
				<td colspan="2"><h3 style="margin:.2em;margin-top:.3em;"><xsl:apply-templates select="HEADLINE" /></h3></td>
			</tr>
			<tr>
				<td width="75%"><xsl:apply-templates select="PUBLICATION" /></td>
				<td align="right" style="text-align:right;font-style:italic;"><xsl:if test="$backNav = 1"><a href="#top{@ID}">back</a> : </xsl:if><a href="#NAV">top</a></td>
			</tr>
			<tr>
				<td colspan="2"><xsl:apply-templates select="@PUBLISHDATE" /></td>
			</tr>
			<tr>
				<td colspan="2"><xsl:apply-templates select="AUTHOR" /></td>
			</tr>
		</table>
		<xsl:choose>
		<xsl:when test="SRCURL/@REDIRECT=1">
			<div>
			<xsl:apply-templates select="ABSTRACT" />
			<xsl:apply-templates select="SRCURL" />
			</div>
			<p style="margin:.25em;">&#xa0;</p>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="ARTICLEBODY">
				<xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$id]/ARTICLEBODY" />
			</xsl:call-template>
			<p style="margin:.25em;">&#xa0;</p>
		</xsl:otherwise>
		</xsl:choose>
	<xsl:if test="$children">
	Also mentioned in:
	<xsl:for-each select="$children">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		<xsl:choose>
		<xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
		<xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
		<xsl:otherwise /> <!-- not between authors, do nothing special -->
		</xsl:choose>
		<xsl:choose>
		<xsl:when test="SRCURL/@REDIRECT=1">
		<a href="{SRCURL}" target="_blank">
			<xsl:apply-templates select="PUBLICATION" />
		</a>
		</xsl:when>
		<xsl:otherwise>
		<a href="{$webroot}story.cfm?story_id={@ID}" target="_blank">
			<xsl:apply-templates select="PUBLICATION" />
		</a>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	</xsl:if>
	</div>
</xsl:template>

<xsl:template match="ARTICLE" mode="ul">
	<xsl:variable name="id" select="@ID" />
	<a id="top{@ID}" />
	<li style="margin:0px;">
	<a href="#{@ID}"><xsl:value-of disable-output-escaping="yes" select="HEADLINE" /></a> (<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />)
	<xsl:apply-templates select="@PUBLISHDATE" />
	</li>
</xsl:template>

<xsl:template name="do-section-header">
	<xsl:param name="sectName" />
	<a name="{translate($sectName, ' ','')}" id="{translate($sectName, ' ','')}" />
	<p style="margin:.25em;">&#xa0;</p>
	<table width="525" style="margin-top:1em;">
		<tr class="section">
			<td width="80%">
			<h2><xsl:value-of disable-output-escaping="yes" select="$sectName" /></h2>
			</td>
			<td>
				<a href="#top{translate($sectName, ' ','')}" >back</a> : <a href="#NAV" >top</a>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="do-toc-section-header">
	<xsl:param name="sectName" />
	<a id="top{translate($sectName, ' ','')}" name="top{translate($sectName, ' ','')}" />
	<h3 style="margin-bottom:0px;margin-top:.2em;">
		<a href="#{translate($sectName, ' ','')}"><xsl:value-of disable-output-escaping="yes" select="$sectName" /></a>
	</h3>
</xsl:template>

<xsl:template match="HEADLINE">
	<xsl:choose>
	<xsl:when test="../SRCURL/@REDIRECT=1">
	<a href="{../SRCURL}" target="_blank">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</a>
	</xsl:when>
	<xsl:otherwise>
	<a href="{$webroot}story.cfm?story_id={../@ID}" target="_blank">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</a>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="SUBHEAD">
	<br/>
	<span class="articleSubTitle">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</span>
</xsl:template>

<xsl:template match="IMAGE">
	&#xa0;<span style="color:red;font-style:italic;">photo</span>
</xsl:template>

<xsl:template match="PUBLICATION">
	<span style="font-style:italic;">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</span>
</xsl:template>

<xsl:template match="PUBLISHDATE">
	<span class="articleReleaseDate"><xsl:value-of select="." /></span>
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

<xsl:template match="LANGGRPH">
	<xsl:param name="LangImg" />
	<span class="languageflag"><img class="languageflag" src="{$LangImg}" /></span>
</xsl:template>

<xsl:template match="SRCURL">
	<div class="linkURL" style="font-style:italic;">
		<a href="{string(.)}"><xsl:value-of select="." /></a>
	</div>
</xsl:template>

<xsl:template match="ABSTRACT">
	<xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<div>
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</div>
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

<xsl:attribute-set name="table">
	 <xsl:attribute name="style">margin-left:5%;</xsl:attribute>
	 <xsl:attribute name="width">90%</xsl:attribute>
	 <xsl:attribute name="border">0</xsl:attribute>
	 <xsl:attribute name="cellspacing">0</xsl:attribute>
	 <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="checkbox">
	 <xsl:attribute name="type">checkbox</xsl:attribute>
	 <xsl:attribute name="value"><xsl:value-of select="ID"/></xsl:attribute>
	 <xsl:attribute name="name">article_list</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
