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

<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/RELEASE_DATE)" />
<xsl:variable name="region" select="translate(string(/CLIPSHEET/REGION),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
<xsl:variable name="thisDiv" select="/CLIPSHEET/TARGETDIVISION" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="fullArticleList" select="$allowedArticles[@ID=/CLIPSHEET/DIVISION[@ID=$thisDiv]/ARTICLE/@ID]/@ID | $allowedArticles/@ID[not(boolean($thisDiv))]" />
<xsl:variable name="clipDiv" select="$allowedArticles[@ID=$fullArticleList]" />
<xsl:variable name="topStories" select="$clipDiv[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=$clipDiv[not(@TOPSTORY!=0)][not(@PARENT!=0)]/SECTION/@ID][DISPLAY!=0 or /CLIPSHEET/REGION = 'preview']" />

<xsl:output method="html" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />

<xsl:template match="/">
	<table xsl:use-attribute-sets="table">
        <tr><td align="center">
        <table cellpadding="7" cellspacing="0" border="0" >
	<tbody>
            <tr>
                <td style="height:40px">
                    <a href="?do=edition">Latest Edition</a>
                </td>
                <td>
                    <a href="?do=breakingnews">Breaking News</a>
                </td>
            </tr>
	</tbody>
	</table>
	</td></tr>
	<tr><td>&#xa0;&#xa0;</td></tr>
	</table>
    <!--
	<form name="selectionset" action="selection.cfm" method="post" target="_blank">
		<input type="hidden" name="doselect" value="0" />
		<input type="hidden" name="today" value="{format-date(xs:date(substring($clipDate,1,10)), $dateArgFormat,'en',(),())}" /> 
                <input type="hidden" name="edition" value="{$region}" /> 
                -->
		<xsl:choose>
		<xsl:when test="count($clipDiv)">
		<!-- Top Stories category -->
		<xsl:if test="$topStories">
			<xsl:call-template name="do-section-header">
				<xsl:with-param name="sectName" select="$topStoriesLabel" />
			</xsl:call-template>
			<table xsl:use-attribute-sets="table"><tbody>
				<xsl:apply-templates select="$topStories">
					<xsl:sort select="@TOPSTORY" data-type="number" />
				</xsl:apply-templates>
			</tbody></table>
		</xsl:if>
		<!-- The normal categories -->
		<xsl:for-each select="$sectList">
			<xsl:sort select="ORDINAL" data-type="number" />
			<xsl:apply-templates select="." />
		</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<div style="margin:2em;">There are no articles for this date for the given portfolio company</div>
		</xsl:otherwise>
            </xsl:choose>
            <!--
        </form>
        -->
</xsl:template>

<xsl:template match="SECTION">
	<xsl:call-template name="do-section-header">
		<xsl:with-param name="sectName" select="NAME" />
	</xsl:call-template>
	<table xsl:use-attribute-sets="table">
	<tbody>
		<xsl:variable name="sectID" select="ID"/>
		<xsl:apply-templates select="$clipDiv[SECTION/@ID=$sectID][not(@TOPSTORY!=0)][not(@PARENT!=0)]">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
		</xsl:apply-templates>
	</tbody>
	</table>
</xsl:template>

<xsl:template match="ARTICLE">
	<tr>
            <td><!--<input xsl:use-attribute-sets="checkbox"/>-->&#xa0;</td>
		<td>
	 		<div>
                            <span class="articleTitle">
                                <xsl:apply-templates select="HEADLINE" mode="parent" />
				<xsl:apply-templates select="MENTION" />
                            </span>
                            <!--
				<xsl:call-template name="do-tags" >
					<xsl:with-param name="AID" select="@ID" />
                                </xsl:call-template>
                                -->
				<xsl:apply-templates select="SUBHEAD" />
	 		</div>
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<div>
				<span class="articlePublication"><xsl:apply-templates select="PUBLICATION"/></span>
				&#xa0; &#xa0;
				<xsl:apply-templates select="@PUBLISHDATE"/>
				<span class="articleAuthor">
					<xsl:apply-templates select="AUTHOR"/>
				</span>
			</div>
			<xsl:apply-templates select="ABSTRACT" />
			<xsl:variable name="articleID" select="@ID"/>
			<xsl:apply-templates select="$allowedArticles[@PARENT=$articleID]" mode="relatedArticle">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
			</xsl:apply-templates>
		</td>
	</tr>
	<tr><td>&#xa0;</td></tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="relatedArticle">
	<div class="relatedArticle">
		<input xsl:use-attribute-sets="checkbox"/>
		<img src="{$cdnroot}resources/img/bluearrow.gif" border="0" alt="bullet" />
                <span class="relatedTitle">
                    <xsl:apply-templates select="HEADLINE" mode="kid" />
		</span>
		<xsl:apply-templates select="LANGGRPH">
				<xsl:with-param name="LangImg" select="LANGGRPH" />
		</xsl:apply-templates>
	</div>
</xsl:template>

<xsl:template name="do-tags">
	<xsl:param name="AID" />
	<xsl:variable name="printTag" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$AID]" />
	<xsl:for-each select="$printTag">
		<xsl:sort select="@NAME" data-type="text" />
		<span>
		<xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
		<xsl:value-of disable-output-escaping="yes" select="@NAME" />
		</span>
	</xsl:for-each>
</xsl:template>

<xsl:template name="do-section-header">
	<xsl:param name="sectName" />
		<div class="section">
			<a name="{translate($sectName,' ','')}">&#xa0;</a><xsl:value-of disable-output-escaping="yes" select="$sectName" />
		</div>
	<xsl:call-template name="do-nav"/>
</xsl:template>

<xsl:template match="HEADLINE" mode="parent">
    <xsl:variable name="tgtURL">
        <xsl:choose>
            <xsl:when test="string-length(../TRACKURL) &gt; 0">
                <xsl:value-of select="../TRACKURL" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="../SRCURL" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <a href="{$tgtURL}" target="_blank">
            <xsl:value-of disable-output-escaping="yes" select="." />
            <xsl:apply-templates select="@MEDIAID"/>
            <xsl:apply-templates select="LANGGRPH">
                            <xsl:with-param name="LangImg" select="LANGGRPH" />
            </xsl:apply-templates>
    </a>
</xsl:template>

<xsl:template match="HEADLINE" mode="kid">
    <xsl:variable name="tgtURL">
        <xsl:choose>
            <xsl:when test="string-length(../TRACKURL) &gt; 0">
                <xsl:value-of select="../TRACKURL" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="../SRCURL" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <a href="{$tgtURL}" target="_blank">
            <xsl:value-of disable-output-escaping="yes" select="." />
    </a>
    <span class="relatedPublication"> - <xsl:value-of disable-output-escaping="yes" select="../PUBLICATION" /></span> 
    <span class="relatedReleaseDate">&#xa0; <xsl:value-of select="../@PUBLISHDATE" /></span>
</xsl:template>

<xsl:template match="MENTION">
	<span style="color:red;font-style:italic;margin-left:2em;"><xsl:value-of select="." /></span>
</xsl:template>

<xsl:template match="SUBHEAD">
	<br/>
	<span class="articleSubTitle">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</span>
</xsl:template>

<xsl:template match="IMAGE">
	&#xa0;<img src="{$cdnroot}resources/img/photo.gif" alt="This article has a photo" border="0" />
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

<xsl:template match="@PUBLISHDATE">
	<span class="articleReleaseDate"><xsl:value-of select="." /></span>
</xsl:template>

<xsl:template match="@MEDIAID">
	<xsl:choose>
	<xsl:when test=".=1">
		&#xa0;<img src="{$cdnroot}resources/img/photo.gif" alt="This article has a photo" border="0"/>
	</xsl:when>
	<xsl:otherwise>
		&#xa0;
	</xsl:otherwise>
	</xsl:choose>
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
	<span class="linkURL">&#xa0;&#xa0;
		<a href="{string(.)}"
			onClick="window.open('','pop','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="pop"
			language="javascript">See the story
		</a>
	</span>
</xsl:template>

<xsl:template match="ABSTRACT">
	<div class="articleBody">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</div>
</xsl:template>

<xsl:template match="ARTICLEBODY">
	<div class="articleBody">
		<xsl:value-of disable-output-escaping="yes" select="." />
	</div>
</xsl:template>


<xsl:template name="do-nav">
    <table cellpadding="7" cellspacing="0" border="0" >
	<tbody>
		<tr>
			<td class="getSelected">
				<span class="arrow">&gt;&#xa0;</span>
				<a href="javascript:document.selectionset.doselect.value=0;document.selectionset.submit();">
					Display Selected Stories
				</a>
			</td>
			<td class="getSelected">
				<span class="arrow">&gt;&#xa0;</span>
				<a href="javascript:document.selectionset.doselect.value=1;document.selectionset.submit();">
					Print Selected Stories
				</a>
			</td>
			<td class="getSelected">
				<a href="javascript:document.selectionset.doselect.value=2;document.selectionset.submit();">
					Email Selected Stories &gt;&gt;
				</a>
			</td>

		</tr>
	</tbody>
	</table>
</xsl:template>
	 

<xsl:attribute-set name="table">
	 <xsl:attribute name="width">95%</xsl:attribute>
	 <xsl:attribute name="border">0</xsl:attribute>
	 <xsl:attribute name="cellspacing">0</xsl:attribute>
	 <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="checkbox">
	 <xsl:attribute name="type">checkbox</xsl:attribute>
	 <xsl:attribute name="value"><xsl:value-of select="@ID"/></xsl:attribute>
	 <xsl:attribute name="name">article_list</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
