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
<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/Keywords.xsl"/>
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/clientvars.xsl"/>

<xsl:variable name="alertName">Full Text Story</xsl:variable>
<xsl:variable name="keywords" select="/CLIPSHEET" />
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="defCopyright" select="/CLIPSHEET/DEFAULTCOPYRIGHT" /> 
<xsl:variable name="clipDate" select="string(/CLIPSHEET/CREATE_DATE)" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=/CLIPSHEET/ARTICLE[not(@TOPSTORY!=0)]/SECTION/@ID]" />
<xsl:variable name="topStories" select="/CLIPSHEET/ARTICLE[@TOPSTORY!=0][not(@PARENT!=0)]" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" />

<xsl:template match="/">
	<xsl:call-template name="do-page-header"/>
		<!-- Top Stories category -->
		<xsl:apply-templates select="$topStories">
			<xsl:sort select="ORDINAL" data-type="number" />
		</xsl:apply-templates>
		<!-- get the top story orphans -->
		<xsl:apply-templates select="/CLIPSHEET/ARTICLE[@TOPSTORY!=0][@PARENT!=0][not(@PARENT=/CLIPSHEET/ARTICLE/@ID)]">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
		<!-- The normal categories -->
		<xsl:apply-templates select="$sectList">
			<xsl:sort select="ORDINAL" data-type="number" />
		</xsl:apply-templates>
		<!-- get the non-top story orphans -->
		<xsl:apply-templates select="/CLIPSHEET/ARTICLE[SECTION/@ID=999999][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=/CLIPSHEET/ARTICLE/@ID)]">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION">
	<xsl:variable name="sectID" select="ID" />
	<xsl:apply-templates select="/CLIPSHEET/ARTICLE[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<!-- get the orphans for this section -->
	<xsl:apply-templates select="/CLIPSHEET/ARTICLE[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][@PARENT!=0][not(@PARENT=/CLIPSHEET/ARTICLE/@ID)]">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="ARTICLE">
<xsl:variable name="thisPub" select="PUBLICATION" />
<div style="margin-left:10px;margin-right:20px;">
	<table cellpadding="5" xsl:use-attribute-sets="table">
	<tr>
		<td>
			<a name="{@ID}" />
			<p/>
			<xsl:apply-templates select="HEADLINE" />
			<xsl:apply-templates select="SUBHEAD" />
			<div>
				<xsl:apply-templates select="PUBLICATION" />
				&#xa0;&#xa0;
				<xsl:apply-templates select="@PUBLISHDATE" />
			</div>
			<div class="displayArticleAuthor">
				<xsl:apply-templates select="AUTHOR" />
			</div>
			<xsl:apply-templates select="PUBCOPYRIGHT" /> 
			<xsl:choose>
			<xsl:when test="SRCURL/@REDIRECT=1">
				<xsl:apply-templates select="ABSTRACT" />
				<xsl:apply-templates select="SRCURL" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="PUBLICATION/@AGTBRAND=1">
					<xsl:value-of disable-output-escaping="yes" select="$defCopyright" /> 
				</xsl:if>
				<xsl:apply-templates select="ARTICLEBODY" />
			</xsl:otherwise>
			</xsl:choose>
			<div><br/></div>
			<div><ul>
				<xsl:apply-templates select="RELATED/ARTICLE">
					<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				</xsl:apply-templates>
			</ul></div>
		</td>
	</tr>
	</table>
	<xsl:variable name="id" select="@ID" />
	<xsl:variable name="children" select="/CLIPSHEET/ARTICLE[@PARENT=$id]" />
	<xsl:apply-templates select="$children">
		<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	</xsl:apply-templates>
	<p/><hr/><p/>
</div>
</xsl:template>

<xsl:template match="ARTICLE" mode="related">
	<li class="ra">
		<div>
			<xsl:variable name="relatedID" select="@ID" />
			<xsl:choose>
			<xsl:when test="/CLIPSHEET/ARTICLE[@ID=$relatedID]">
				<a href="#{$relatedID}">
					<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$webroot}story.cfm?story_id={@ID}">
					<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
				</a>
			</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="content_fltxt_10">
			<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />&#xa0;&#xa0;<xsl:value-of select="@PUBLISHDATE" />
		</div>
	</li>
</xsl:template>

<xsl:template match="RELATED/ARTICLE">
	<xsl:variable name="relatedID" select="ID" />
	<xsl:if test="position()=1">
		<span class="content_fltxt_10">
			<xsl:choose>
			<xsl:when test="not(@PARENT!=0)">Main Story</xsl:when>
			<xsl:when test="count(.)=1">Related Story</xsl:when>
			<xsl:otherwise>Related Stories</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:if>
	<li class="ra">
	<span class="articlePublication"><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /><span style="margin:1em;"><xsl:value-of select="PUBLISHDATE" /></span></span>
		<xsl:choose>
		<xsl:when test="/CLIPSHEET/ARTICLE[@ID=$relatedID]">
			<a href="#{$relatedID}">
				<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
			</a>
		</xsl:when>
		<xsl:otherwise>
			<a href="{$webroot}story.cfm?story_id={@ID}">
				<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
			</a>
		</xsl:otherwise>
		</xsl:choose>
	</li>
</xsl:template>

<xsl:template match="HEADLINE">
	<div>
		<span class="displayArticleTitle"><xsl:value-of disable-output-escaping="yes" select="." /></span>
	</div>
</xsl:template>

<xsl:template match="SUBHEAD">
<xsl:if test="string-length(.)>0">
	<div class="displayArticleSubTitle">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</div>
</xsl:if>
</xsl:template>

<xsl:template match="PUBLICATION">
	<span>
		<xsl:choose>
		<xsl:when test="string(.)='Broadcast News'">
			<xsl:attribute name="class">broadcastPublication</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<xsl:attribute name="class">articlePublication</xsl:attribute>
		</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of disable-output-escaping="yes" select="." />
	</span>
</xsl:template>

<xsl:template match="PUBLISHDATE">
	<span class="articleReleaseDate"><xsl:value-of select="." /></span>
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:if test="position()=1">Author<xsl:if test="last()>1">s</xsl:if>: </xsl:if>
	<xsl:choose>
	<xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
	<xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
	<xsl:otherwise />
	</xsl:choose>
	<xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="PUBCOPYRIGHT">
	<div>
		<span class="articleCopyright"><xsl:value-of disable-output-escaping="yes" select="." /></span>
	</div>
</xsl:template>

<xsl:template match="ABSTRACT">
	<div class="articleBody">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
	</div>
</xsl:template>

<xsl:template match="ARTICLEBODY">
	<div class="articleBody">
		<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
	</div>
</xsl:template>

<xsl:template match="SRCURL">
	<div class="linkURL">
		<br/>
		<a href="{string(.)}"
			onClick="window.open('','cal','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="cal"
			language="javascript"
			>
                        <i>view story at source</i>
		</a>
	</div>
</xsl:template>

<xsl:template name="do-page-header">
<div class="banner">
	<div class="bannerText" style="float:right;margin:20px;">
		<xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" />&#xa0;
	</div>
	<div style="height:90px;">
		<img src="{$webroot}{$brandImage}" style="vertical-align:middle;margin:10px;margin-left:30px;" alt="" border="0" class="logo" /> 
		<span class="bannerTitle"><xsl:value-of select="/CLIPSHEET/@NAME" /></span>
	</div>
	<div class="headnav" style="width:100%;text-align:right;padding:1px;height:16px;">
	</div>
</div>
</xsl:template>

<xsl:template match="HEADER">
	<tr>
		<td colspan="2" valign="bottom" class="headerText">
			<xsl:value-of  disable-output-escaping="yes" select="CONTENT" />
		</td>
	</tr>
</xsl:template>


<xsl:attribute-set name="table">
	<xsl:attribute name="width">100%</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
