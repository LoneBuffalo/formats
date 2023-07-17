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

<xsl:variable name="formatName">525 TOC to Full Text</xsl:variable>
<xsl:variable name="webroot" select="string(/CLIPSHEET/LB_URL)" />
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
<xsl:variable name="FTXML" select="document(concat($webroot,'XML/stdFullStory?story_id=',$strAID))"/>

<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" />

<xsl:template match="/">
	<table border="0" cellpadding="0">
		<tbody>
		<tr>
		<td width="525.0pt" style="border:solid #CCCCCC 1.0pt;padding:0.0pt 15.0pt 15.0pt 15.0pt">
<!--		<table width="100%">
			<tr>
				<td align="center">
					Mobile version and searchable archives available at <a href="{$webroot}" target="_blank"><xsl:value-of select="$webroot" /></a>
				</td>
			</tr>
		</table> -->
		<table><tbody><tr><td style="border:solid #CCCCCC 2.0pt;width:525.0pt;">
			<img border="0" alt="" src="{$webroot}sheetimgs/logo.png" style="vertical-align:middle;" />
			<h3 style="margin:0px;padding:0px"><xsl:value-of select="/CLIPSHEET/@CLIENT" /></h3>
			<h2 class="section" style="margin-top:0px;padding-top:0px;"><xsl:value-of select="/CLIPSHEET/@NAME" /></h2>
		</td></tr></tbody></table>
		<div style="margin-left:.2em;margin-right:.2em;">
			<a name="NAV"></a>
			<xsl:apply-templates select="$sectList" mode="ul">
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
			<xsl:apply-templates select="$sectList">
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
		</div>
		</td>
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
	<xsl:if test="count($allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)])">
	<xsl:call-template name="do-toc-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<ul style="margin:0px;margin-left:2px;">
	<xsl:for-each select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		<xsl:apply-templates select="." mode="ul" />
	</xsl:for-each>
	</ul>
	</xsl:if>
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
		<div style="float:right;">&#xa0;<br />
		<xsl:if test="$backNav = 1"><a href="#top{@ID}">back</a> : </xsl:if><a href="#NAV">top</a></div>
		<h4 style="margin:.2em;margin-top:.3em;">
			<xsl:apply-templates select="HEADLINE" />
		</h4>
		<xsl:apply-templates select="PUBLICATION" />
		<xsl:apply-templates select="AUTHOR" />
		<xsl:choose>
		<xsl:when test="SRCURL/@REDIRECT=1">
			<xsl:apply-templates select="ABSTRACT" />
			<xsl:apply-templates select="SRCURL" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="ARTICLEBODY">
				<xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$id]/ARTICLEBODY" />
			</xsl:call-template>
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
	</li>
</xsl:template>

<xsl:template name="do-section-header">
	<xsl:param name="sectName" />
	<a name="{translate($sectName, ' ','')}" id="{translate($sectName, ' ','')}" />
	<h3 class="section">
		<div style="float:right;"><a href="#top{translate($sectName, ' ','')}" style="font-size:x-small;">back</a> : <a href="#NAV" style="font-size:x-small;">top</a></div>
		<xsl:value-of disable-output-escaping="yes" select="$sectName" />
	</h3>
</xsl:template>

<xsl:template name="do-toc-section-header">
	<xsl:param name="sectName" />
	<a id="top{translate($sectName, ' ','')}" name="top{translate($sectName, ' ','')}" />
	<h4 style="margin-bottom:0px;margin-top:.2em;">
		<a href="#{translate($sectName, ' ','')}"><xsl:value-of disable-output-escaping="yes" select="$sectName" /></a>
	</h4>
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

<xsl:template match="LINKURL">
	<span class="linkURL">&#xa0;&#xa0;
		<a href="{string(.)}"
			onClick="window.open('','cal','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="cal"
			language="javascript"
			>
			&#xa0;<span style="color:red;font-style:italic;">internet</span>
		</a>
	</span>
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
