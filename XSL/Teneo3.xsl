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
	exclude-result-prefixes="xs xsl lbps" >

        <xsl:import href="https://lonebuffalo.secure.footprint.net/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Teneo 3 (Caesars-like)</xsl:variable>
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/LOCAL_DATE)" />
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

<xsl:output method="html" indent="yes" encoding="utf-8" />

<xsl:template match="/">
		<xsl:call-template name="do-page-header"/>
		<!-- The normal categories -->
		<xsl:if test="$topStories">
			<xsl:call-template name="do-section-header">
				<xsl:with-param name="sectName" select="$topStoriesLabel" />
			</xsl:call-template>
			<xsl:apply-templates select="$topStories" mode="fulltext">
				<xsl:sort select="@TOPSTORY" data-type="number" />
			</xsl:apply-templates>
		</xsl:if>
		<xsl:apply-templates select="$sectList" mode="fulltext">
			<xsl:sort select="ORDINAL" data-type="number" />
		</xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="ul">
	<xsl:variable name="sectID" select="ID" />
	<xsl:if test="count($allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)])">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<ul>
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]" mode="ul">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<!-- get the orphans for this section -->
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=$allowedArticles/@ID)]" mode="ul" />
	</ul>
	</xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="fulltext">
	<xsl:variable name="sectID" select="ID" />
		<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]" mode="fulltext">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
		<!-- get the orphans for this section -->
		<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=$allowedArticles/@ID)]" mode="fulltext" />
</xsl:template>

<xsl:template match="ARTICLE" mode="fulltext">
	<xsl:variable name="id" select="@ID" />
	<div style="margin:.5em;">
		<a name="{@ID}" />
		<a href="#head">top</a>
		<xsl:apply-templates select="HEADLINE" />
		<xsl:apply-templates select="SUBHEAD" />
		<xsl:apply-templates select="PUBLICATION" />
		<xsl:apply-templates select="@PUBLISHDATE" />
		<h5 style="margin:0em;margin-bottom:.5em;"><xsl:apply-templates select="AUTHOR" /></h5>
		<!-- <xsl:apply-templates select="COPYRIGHT" /> -->
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
		<hr />
	</div>
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<xsl:apply-templates select="$children" mode="fulltext">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="ul">
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<li><div style="margin-bottom:1em;">
	<!--  <xsl:value-of disable-output-escaping="yes" select="HEADLINE" /> -->
	<i><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></i>&#xa0;
	<xsl:apply-templates select="ABSTRACT" /><a href="#{@ID}" style="margin-left:1em;">Full Article</a>
	</div></li>
	<xsl:apply-templates select="$children" mode="ul">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="RELATED">
	<xsl:if test="position()=1">
		<span class="relatedLabel">
			<xsl:choose>
			<xsl:when test="not(@PARENT!=0)">Main Story</xsl:when>
			<xsl:when test="last()=1">Related Story</xsl:when>
			<xsl:otherwise>Related Stories</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:if>
	<li>
		<span class="relatedTitle">
			<xsl:variable name="relatedID" select="ID" />
			<xsl:choose>
			<xsl:when test="$allowedArticles[@ID=$relatedID]">
				<a href="#{$relatedID}">
					<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$webroot}story.cfm?story_id={ID}">
					<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
				</a>
			</xsl:otherwise>
			</xsl:choose>
		</span>
		<span class="relatedPublication"> - <xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></span> 
		<span class="relatedReleaseDate">&#xa0;&#xa0;<xsl:value-of select="PUBLISHDATE" /></span>
	</li>
</xsl:template>

<xsl:template match="HEADLINE">
	<h3 style="margin-bottom:0em;"><xsl:value-of disable-output-escaping="yes" select="." /></h3>
</xsl:template>

<xsl:template match="SUBHEAD">
<xsl:if test="string-length(.)>0">
	<div style="margin:0em;">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</div>
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

<xsl:template match="PUBLICATION">
	<h4 style="margin:0em;"><xsl:value-of disable-output-escaping="yes" select="." /></h4>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
	<h4 style="margin:0em;"><xsl:value-of select="." /></h4>
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:choose>
	<xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
	<xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
	<xsl:otherwise />
	</xsl:choose>
	<xsl:if test="position()=1">Author<xsl:if test="last()>1">s</xsl:if>: </xsl:if><xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="COPYRIGHT">
	<div>
		<span class="articleCopyright"><xsl:value-of disable-output-escaping="yes" select="." /></span>
	</div>
</xsl:template>

<xsl:template match="ABSTRACT">
	<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<div class="articlebody">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</div>
</xsl:template>

<xsl:template match="SRCURL">
	<div class="linkURL">
		<a href="{string(.)}"
			onClick="window.open('','cal','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="cal"
			language="javascript">
			<i>get the full story . . .</i>
		</a>
	</div>
</xsl:template>

<xsl:template name="do-tags">
	<xsl:param name="AID" />
	<xsl:variable name="printTag" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$AID]" />
	<xsl:for-each select="$printTag">
		<span>
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

<xsl:template name="do-page-header">
	<h3><xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" /></h3>
	<a name="head" />
	<xsl:if test="$topStories">
		<xsl:call-template name="do-section-header">
			<xsl:with-param name="sectName" select="$topStoriesLabel" />
		</xsl:call-template>
		<ul>
		<xsl:apply-templates select="$topStories" mode="ul">
			<xsl:sort select="@TOPSTORY" data-type="number" />
		</xsl:apply-templates>
		</ul>
	</xsl:if>
	<xsl:apply-templates select="$sectList" mode="ul">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="HEADER">
	<tr>
		<td colspan="2" valign="bottom" class="headerText">
			<xsl:value-of  disable-output-escaping="yes" select="CONTENT" />
		</td>
	</tr>
</xsl:template>

<xsl:template match="MENTION">
	<span style="color:red;font-style:italic;margin-left:2em;"><xsl:value-of select="." /></span>
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
	<xsl:attribute name="width">90%</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>