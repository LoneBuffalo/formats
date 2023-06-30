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

        <xsl:import href="https://LB_CDN_BASE/resources/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Teneo 4 (Keurig-like)</xsl:variable>
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="bulletDateFormat" select="string('[D01] [MNn] [Y0001]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/LOCAL_DATE)" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="clipBrandIDs" select="$allowedArticles[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID]/@ID | $allowedArticles[not(boolean($thisDiv))]/@ID" />
<xsl:variable name="clipBrand" select="$allowedArticles[@ID=$clipBrandIDs]" />
<xsl:variable name="topStories" select="$clipBrand[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$clipBrand[not(@TOPSTORY!=0)][not(@PARENT!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<xsl:variable name="FTXML" select="document(concat($webroot,'XML/stdFullStory?story_id=',$strAID))"/>

<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" />

<xsl:template match="/">
		<xsl:call-template name="do-page-header"/>
		<xsl:if test="not($allowedArticles)">
			<div style="margin:2em;font-family:Calibri;font-size:11pt;">No relevant stories for this edition</div>
		</xsl:if>
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
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]" mode="ul">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<!-- get the orphans for this section -->
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=$allowedArticles/@ID)]" mode="ul" />
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
	<div>
		<a name="{@ID}" />
		<xsl:apply-templates select="HEADLINE" />
		<xsl:apply-templates select="PUBLICATION" />
		<p style="margin:0px;"><xsl:apply-templates select="AUTHOR" /></p>
		<xsl:apply-templates select="@PUBLISHDATE" />
		<xsl:apply-templates select="SRCURL" mode="site" />
		<!-- <xsl:apply-templates select="COPYRIGHT" /> -->
		<xsl:choose>
		<xsl:when test="SRCURL/@REDIRECT=1">
			<xsl:apply-templates select="ABSTRACT" />
			<xsl:apply-templates select="SRCURL" mode="rights" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="ARTICLEBODY">
				<xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$id]/ARTICLEBODY" />
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
		<div style="text-align:center;width:100%;">###</div>
	</div>
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<xsl:apply-templates select="$children" mode="fulltext">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE" mode="ul">
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<p class="head">
	<a href="#{@ID}">
	<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
	</a>
	</p>
	<xsl:apply-templates select="@MEDIAID" />
	<p class="bullet"><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></p>
	<p class="bullet">&#xa0;</p>
	<!-- <xsl:call-template name="do-tags">
		<xsl:with-param name="AID" select="@ID" />
	</xsl:call-template>
	<xsl:apply-templates select="MENTION" /> -->
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
		<span class="relatedReleaseDate">&#xa0;&#xa0;<xsl:value-of select="@PUBLISHDATE" /></span>
	</li>
</xsl:template>

<xsl:template match="HEADLINE">
	<p style="font-weight:bold;margin-bottom:0em;"><xsl:value-of disable-output-escaping="yes" select="." /></p>
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
	<p style="margin:0em;"><xsl:value-of disable-output-escaping="yes" select="." /></p>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
	<xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
	<p style="margin:0em;">	<xsl:value-of select="format-date(xs:date($strDate), $bulletDateFormat,'en',(),())" /></p>
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:choose>
	<xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
	<xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
	<xsl:otherwise />
	</xsl:choose>
	<xsl:if test="position()=1">By: </xsl:if><xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="COPYRIGHT">
	<div>
		<span class="articleCopyright"><xsl:value-of disable-output-escaping="yes" select="." /></span>
	</div>
</xsl:template>

<xsl:template match="ABSTRACT">
	<div>
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
	</div>
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<div style="margin-top:1em;">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</div>
</xsl:template>

<xsl:template match="SRCURL" mode="rights">
	<div class="linkURL">
		<a href="{string(.)}"
			onClick="window.open('','cal','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="cal"
			language="javascript">
			<i>get the full story . . .</i>
		</a>
	</div>
</xsl:template>

<xsl:template match="SRCURL" mode="site">
	<p>Link: <a href="{string(.)}"><xsl:value-of select="." /></a></p>
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
	<p style="font-weight:bold;text-decoration:underline;"><xsl:value-of disable-output-escaping="yes" select="$sectName" /></p>
</xsl:template>

<xsl:template name="do-page-header">
	<p><xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" /></p>
	<a name="head" />
	<xsl:if test="$topStories">
		<xsl:call-template name="do-section-header">
			<xsl:with-param name="sectName" select="$topStoriesLabel" />
		</xsl:call-template>
		<xsl:apply-templates select="$topStories" mode="ul">
			<xsl:sort select="@TOPSTORY" data-type="number" />
		</xsl:apply-templates>
	</xsl:if>
	<xsl:apply-templates select="$sectList" mode="ul">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<p></p>
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
