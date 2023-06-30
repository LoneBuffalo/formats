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
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs xsl lbps">

<xsl:import href="https://lonebuffalo.secure.footprint.net/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Teneo 6 (Thomas's style -brand subdivision)</xsl:variable>
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="bulletDateFormat" select="string('[D01] [MNn] [Y0001]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/LOCAL_DATE | /CLIPSHEET/CREATE_DATE[not(boolean(/CLIPSHEET/RELEASE_DATE))])" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="articlesIDs" select="$allowedArticles[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID]/@ID | $allowedArticles[not(boolean($thisDiv))]/@ID" />
<xsl:variable name="articles" select="$allowedArticles[@ID=$articlesIDs]" />
<xsl:variable name="topStories" select="$articles[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[DISPLAY!=0][NEWSLETTER!=0]" />
<xsl:variable name="strAID">
	<xsl:call-template name="make-strAID" />
</xsl:variable>
<xsl:variable name="FTXML" select="document(concat($webroot,'XML/stdFullStory?story_id=',$strAID))"/>

<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="html" indent="yes" encoding="utf-8" />

<xsl:template match="/">
    <xsl:call-template name="do-page-head" />
    <xsl:call-template name="do-toc" />
    <xsl:call-template name="do-body" />
    <xsl:call-template name="do-page-foot"/> 
</xsl:template>

<xsl:template name="do-toc">
    <xsl:call-template name="do-top-stories">
        <xsl:with-param name="type" select="string('short')" />
    </xsl:call-template>
    <xsl:apply-templates select="$sectList">
        <xsl:with-param name="type" select="string('short')" />
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template name="do-body">
    <xsl:call-template name="do-top-stories">
        <xsl:with-param name="type" select="string('full')" />
    </xsl:call-template>
    <xsl:apply-templates select="$sectList">
        <xsl:with-param name="type" select="string('full')" />
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template name="do-top-stories">
    <xsl:param name="type" select="string('short')" />
    <xsl:if test="$topStories">
    <xsl:call-template name="section-head">
        <xsl:with-param name="sectName" select="$topStoriesLabel" />
    </xsl:call-template>
    <xsl:choose>
        <xsl:when test="$type = 'short'">
        <xsl:apply-templates select="$topStories" mode="ul">
            <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        <xsl:apply-templates select="$topStories" mode="full">
            <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:if>
</xsl:template>

<xsl:template match="SECTION">
    <xsl:param name="type" select="string('short')" />
    <xsl:variable name="sid" select="ID" />
    <xsl:variable name="sArticles" select="$articles[SECTION/@ID=$sid]" />
    <xsl:variable name="divSArticles" select="$sArticles[@ID=/CLIPSHEET/DIVISION/ARTICLE/@ID]" />
    <xsl:variable name="divList" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$divSArticles/@ID]" />
    <xsl:variable name="non-divSArticles" select="$sArticles[not(@ID=$divSArticles/@ID)]" />
    <xsl:call-template name="section-head">
        <xsl:with-param name="sectName" select="NAME" />
    </xsl:call-template>
    <xsl:if test="count($articles[SECTION/@ID=$sid][not(@TOPSTORY!=0)]) = 0">
	<div style="padding:1em;">
		No Relevant News
	</div>
    </xsl:if>
    <xsl:apply-templates select="$divList">
        <xsl:with-param name="type" select="$type" />
        <xsl:with-param name="dArticles" select="$divSArticles" />
    </xsl:apply-templates>
    <xsl:if test="$non-divSArticles and $divSArticles">
        <xsl:call-template name="division-head">
            <xsl:with-param name="divName" select="concat('Also in ',NAME)" />
        </xsl:call-template>
    </xsl:if>
    <xsl:choose>
        <xsl:when test="$type = 'short'">
        <xsl:apply-templates select="$non-divSArticles" mode="ul">
            <xsl:sort select="SECTION/@ORDINAL" />
        </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
        <xsl:apply-templates select="$non-divSArticles" mode="fulltext">
            <xsl:sort select="SECTION/@ORDINAL" />
        </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="DIVISION">
    <xsl:param name="type" select="string('short')" />
    <xsl:param name="dArticles" />
    <xsl:variable name="did" select="@ID" />
    <xsl:call-template name="division-head">
        <xsl:with-param name="divName" select="@NAME" />
    </xsl:call-template>
    <xsl:choose>
        <xsl:when test="$type = 'short'">
            <div style="padding-left:20px;">
        <xsl:apply-templates select="$dArticles[@ID=/CLIPSHEET/DIVISION[@ID=$did]/ARTICLE/@ID]" mode="ul">
            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
        </xsl:apply-templates>
            </div>
        </xsl:when>
        <xsl:otherwise>
        <xsl:apply-templates select="$dArticles[@ID=/CLIPSHEET/DIVISION[@ID=$did]/ARTICLE/@ID]" mode="fulltext">
            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
        </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ########## LOGIC ABOVE ################# -->
<!-- ########## OUTPUT BELOW ################ -->

<xsl:template match="ARTICLE" mode="fulltext">
	<xsl:variable name="id" select="@ID" />
	<div>
		<xsl:apply-templates select="HEADLINE" mode="anchor"/>
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
		<xsl:apply-templates select="HEADLINE" mode="link" /></p>
	<xsl:apply-templates select="@MEDIAID" />
	<p class="bullet"><xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /></p>
	<p class="bullet">&#xa0;</p>
	<xsl:apply-templates select="MENTION" />
	<xsl:apply-templates select="$children" mode="ul">
		<xsl:sort select="ORDINAL" data-type="number" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="section-head">
	<xsl:param name="sectName" />
        <p style="font-weight:bold;text-decoration:underline;">
            <xsl:value-of disable-output-escaping="yes" select="$sectName" />
        </p>
</xsl:template>

<xsl:template name="division-head">
	<xsl:param name="divName" />
        <p style="font-weight:bold;font-style:italic;padding-left:20px;">
            <xsl:value-of disable-output-escaping="yes" select="$divName" />
        </p>
</xsl:template>

<xsl:template match="HEADLINE" mode="link">
	<a href="#{../@ID}" name="top{../@ID}">
	<xsl:value-of disable-output-escaping="yes" select="." />
	</a>
</xsl:template>

<xsl:template match="HEADLINE" mode="anchor">
	<a name="{../@ID}" style="float:right;" href="#top{../@ID}"><i>top</i></a>
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
      <a href="{string(.)}" target="_blank">
      <i>get the full story . . .</i>
      </a>
  </div>
</xsl:template>

<xsl:template match="SRCURL" mode="site">
	<p>Link: <a href="{string(.)}"><xsl:value-of select="." /></a></p>
</xsl:template>

<xsl:template match="MENTION">
	<span style="color:red;font-style:italic;margin-left:2em;"><xsl:value-of select="." /></span>
</xsl:template>

<xsl:template name="do-page-head">
    <p><xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" /></p>
    <a name="head" />
</xsl:template>

<xsl:template name="do-page-foot">
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
