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

<xsl:variable name="formatName">Brunswick 1 with Divisions</xsl:variable>
<xsl:variable name="apiroot" select="concat('https://subscriber-api.lonebuffalo.com/v1/clients/',string(/CLIPSHEET/@CID),'/')" />
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="webVersionURL" select="/CLIPSHEET/WEBVERSIONURL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="minDiv" select="0" />
<xsl:variable name="clipDate" select="string(/CLIPSHEET/LOCAL_DATE)" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="fullArticleList" select="$allowedArticles/@ID[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID] | $allowedArticles/@ID[not(boolean($thisDiv))]" />
<xsl:variable name="clipBrand" select="$allowedArticles[@ID=$fullArticleList]" />
<xsl:variable name="parents" select="$clipBrand[not(@PARENT!=0)]" />
<xsl:variable name="topStories" select="$clipBrand[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$clipBrand[not(@TOPSTORY!=0)][not(@PARENT!=0)]/SECTION/@ID][DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<xsl:variable name="orderedDiv">
	<xsl:call-template name="divOrdered" />
</xsl:variable>
<xsl:variable name="FTXML" select="document(concat($apiroot,'/articles?story_ids=',$strAID))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" />

<xsl:template match="/">
		<xsl:call-template name="do-page-header"/>
		<xsl:if test="not($allowedArticles)">
			<div style="margin:2em;">No relevant stories for this edition</div>
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
		<xsl:if test="string-length(/CLIPSHEET/BOTMSG)">
			<xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/BOTMSG" />
		</xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="ul">
	<xsl:variable name="sectID" select="ID" />
	<xsl:variable name="sArticles" select="$parents[SECTION/@ID=$sectID][not(@TOPSTORY!=0)]" />
	<xsl:variable name="dArticles" select="$sArticles[@ID=/CLIPSHEET/DIVISION[count(ARTICLE) &gt; $minDiv]/ARTICLE/@ID]" />
	<xsl:variable name="ndArticles" select="$sArticles[not(@ID=$dArticles/@ID)]" />
	<xsl:variable name="divs" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$dArticles/@ID]" />
	<xsl:if test="count($sArticles)">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<ul>
		<xsl:apply-templates select="$orderedDiv/DIVISION[@ID=$divs/@ID]" mode="ul">
			<xsl:with-param name="articles" select="$dArticles" />
			<xsl:sort select="@ORDINAL" data-type="number" />
			<xsl:sort select="@NAME" data-type="text" />
		</xsl:apply-templates>
		<xsl:choose>
			<xsl:when test="count($dArticles) &gt; 1 and count($ndArticles) &gt; 1">
				<xsl:variable name="addlName" select="concat('Additional ',NAME)" /> 
				<xsl:call-template name="do-division-header">
					<xsl:with-param name="dName" select="$addlName" />
				</xsl:call-template>
			<ul>
				<xsl:apply-templates select="$ndArticles" mode="ul">
					<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				</xsl:apply-templates>
			</ul>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ndArticles" mode="ul">
					<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	<!-- get the orphans for this section -->
		<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=$allowedArticles/@ID)]" mode="ul" />
	</ul>
	</xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="fulltext">
	<xsl:variable name="sectID" select="ID" />
	<xsl:variable name="sArticles" select="$parents[SECTION/@ID=$sectID][not(@TOPSTORY!=0)]" />
	<xsl:variable name="dArticles" select="$sArticles[@ID=/CLIPSHEET/DIVISION[count(ARTICLE) &gt; $minDiv]/ARTICLE/@ID]" />
	<xsl:variable name="ndArticles" select="$sArticles[not(@ID=$dArticles/@ID)]" />
	<xsl:variable name="divs" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$dArticles/@ID]" />
	<xsl:if test="count($sArticles)">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
		<xsl:apply-templates select="$orderedDiv/DIVISION[@ID=$divs/@ID]" mode="fulltext">
			<xsl:with-param name="articles" select="$dArticles" />
			<xsl:sort select="@ORDINAL" data-type="number" />
			<xsl:sort select="@NAME" data-type="text" />
		</xsl:apply-templates>
		<xsl:choose>
			<xsl:when test="count($dArticles) &gt; 1 and count($ndArticles) &gt; 1">
				<xsl:variable name="addlName" select="concat('Additional ',NAME)" /> 
				<xsl:call-template name="do-division-header">
					<xsl:with-param name="dName" select="$addlName" />
				</xsl:call-template>
				<xsl:apply-templates select="$ndArticles" mode="fulltext">
					<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ndArticles" mode="fulltext">
					<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	<!-- get the orphans for this section -->
	<xsl:apply-templates select="$allowedArticles[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=$allowedArticles/@ID)]" mode="fulltext" />
	</xsl:if>
</xsl:template>

<xsl:template match="ARTICLE" mode="fulltext">
	<xsl:variable name="id" select="@ID" />
	<div style="margin-left:.3em;">
		<a name="{@ID}" id="{@ID}" />
		<a href="#head">top</a>
		<xsl:apply-templates select="HEADLINE" />
		<xsl:apply-templates select="SUBHEAD" />
		<xsl:apply-templates select="PUBLICATION" />
		<xsl:apply-templates select="@PUBLISHDATE" />
		<h5 style="margin:0em;"><xsl:apply-templates select="AUTHOR" /></h5>
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
	<xsl:param name="tag" select="0" />
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
	<li>
	<a href="#{@ID}"><xsl:value-of disable-output-escaping="yes" select="HEADLINE" /></a>
	<xsl:apply-templates select="@MEDIAID" />
	(<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />)
	<xsl:call-template name="do-tags">
		<xsl:with-param name="AID" select="@ID" />
	</xsl:call-template>
	<xsl:apply-templates select="MENTION" />
	<xsl:if test="$tag">
		<xsl:call-template name="do-tags">
			<xsl:with-param name="AID" select="$id" />
		</xsl:call-template>
	</xsl:if>
	</li>
	<xsl:apply-templates select="$children" mode="ul">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="DIVISION" mode="ul">
	<xsl:param name="articles" />
	<xsl:variable name="aids" select="ARTICLE/@ID" />
		<xsl:call-template name="do-division-header">
			<xsl:with-param name="dName" select="@NAME" />
		</xsl:call-template>
	<ul>
		<xsl:apply-templates select="$articles[@ID=$aids]" mode="ul">
			<xsl:with-param name="tag" select="0" />
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
	</ul>
</xsl:template>

<xsl:template match="DIVISION" mode="fulltext">
	<xsl:param name="articles" />
	<xsl:variable name="aids" select="ARTICLE/@ID" />
		<xsl:call-template name="do-division-header">
			<xsl:with-param name="dName" select="@NAME" />
		</xsl:call-template>
		<xsl:apply-templates select="$articles[@ID=$aids]" mode="fulltext">
			<xsl:with-param name="tag" select="0" />
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
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
	<div>
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
	</div>
</xsl:template>

<xsl:template name="ARTICLEBODY">
	<xsl:param name="article" />
	<div>
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
	</div>
</xsl:template>

<xsl:template match="SRCURL">
	<div class="linkURL">
		<a href="{string(.)}"
			onClick="window.open('','cal','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="cal"
			language="javascript"
			>
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

<xsl:template name="do-division-header">
	<xsl:param name="dName" />
	<div class="division">
		<xsl:value-of disable-output-escaping="yes" select="$dName" />
	</div>
</xsl:template>

<xsl:template name="do-page-header">
	<xsl:if test="string-length($webVersionURL) &gt; 1">
		<div style="float:right;">
		<a href="{$webVersionURL}">View this on the web</a>
		</div>
	</xsl:if>
	<h3><xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" /></h3>
	<a name="head" id="head" />
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

<xsl:template name="divOrdered">
	<xsl:variable name="setOrd" select="doc-available(concat($webroot,'XSL/divOrder.xml'))" />
	<xsl:variable name="divOrd">
		<xsl:choose>
			<xsl:when test="$setOrd">
				<xsl:value-of select="doc(concat($webroot,'XSL/divOrder.xml'))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/CLIPSHEET/DIVISION" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:for-each select="/CLIPSHEET/DIVISION">
		<xsl:variable name="did" select="@ID" />
		<xsl:copy>
			<xsl:attribute name="ORDINAL">
			<xsl:choose>
			<xsl:when test="$setOrd">
				<xsl:value-of select="$divOrd/CLIPSHEET/DIVORDER[@ID=$did]/@ORDINAL" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0" />
			</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:for-each>
</xsl:template>

<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:attribute-set name="table">
	<xsl:attribute name="width">90%</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
