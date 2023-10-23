<?xml version='1.0'?>
<!-- Copyright Lone Buffalo, Inc.
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
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/clientvars.xsl"/>

<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="headerXML" select="document(concat($webroot,'XML/stdHead.xml'))"/>
<xsl:variable name="footerXML" select="document(concat($webroot,'XML/stdFoot.xml'))"/>
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[FN,*-3], [M01]/[D01]/[Y01]')"/>

<xsl:variable name="clipDate" select="string(/CLIPSHEET/RELEASE_DATE)" />
<xsl:key name="inserted-key" match="ARTICLE" use="substring(INSERTED, 1, 10)" />

<xsl:output method="html" indent="yes" encoding="utf-8" />

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

	<table xsl:use-attribute-sets="table">
		<xsl:for-each select="/CLIPSHEET/ARTICLE[generate-id(.) = generate-id(key('inserted-key', substring(INSERTED, 1, 10))[1])]">
			<xsl:sort select="INSERTED" data-type="text" order="descending" />
			<xsl:if test="position()!=1">
				<tr><td colspan="2">&#xa0;</td></tr>
				<tr>
                                  <td colspan="2"><hr width="620" height="1" border="0"/></td>
				</tr>
				<tr>
					<td colspan="2" align="right" class="bannerDate"><xsl:value-of select="format-date(xs:date(substring(INSERTED, 1, 10)), $headerDateFormat,'en',(),())"/></td>
				</tr>
			</xsl:if>
			<xsl:apply-templates select="key('inserted-key', substring(INSERTED, 1, 10))">
				<xsl:sort select="INSERTED" data-type="text" order="descending" />
			</xsl:apply-templates>
		</xsl:for-each>
	</table>

</xsl:template>

<xsl:template match="ARTICLE">
	<tr class="breakinglist">
		<td valign="top" nowrap="true">&#xa0;</td>
		<td>
		<xsl:apply-templates select="HEADLINE" /> -
		<xsl:apply-templates select="PUBLICATION"/>
		</td>
	</tr>
</xsl:template>

<xsl:template match="HEADLINE">
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
</xsl:template>

<xsl:template match="PUBLICATION">
	<span class="articlePublication"><xsl:value-of disable-output-escaping="yes" select="." /></span>
</xsl:template>

<xsl:template match="LINKURL">
	<span class="linkURL">&#xa0;&#xa0;
		<a href="{string(.)}"
			onClick="window.open('','cal','WIDTH=600,HEIGHT=400,toolbar=yes,scrollbars=yes,resizable=yes,menubar=yes,status=yes');"
			target="cal"
			language="javascript">
                        <i>view story at source</i>
		</a>
	</span>
</xsl:template>

<xsl:template match="HEADER">
	<tr>
		<td colspan="2" valign="bottom" class="headerText">
			<xsl:value-of  disable-output-escaping="yes" select="CONTENT" />
		</td>
	</tr>
</xsl:template>

<xsl:template name="do-page-footer">
    <table width="580" align="center" xsl:use-attribute-sets="table">
    	<tr><td>&#xa0;</td></tr>
    	<tr><td>&#xa0;</td></tr>
    	<tr>
    		<td class="footerText" align="center">
				<xsl:apply-templates select="$footerXML/FOOTER" />
			</td>
    	</tr>
    	<tr><td>&#xa0;</td></tr>
    </table>
</xsl:template>

<xsl:template match="FOOTER">
	<xsl:value-of  disable-output-escaping="yes" select="CONTENT" />
</xsl:template>

<xsl:template name="do-nav">
	<table width="580" align="center" xsl:use-attribute-sets="table">
		<tr><td align="center" class="sectionNavText">&#xa0;</td></tr>
		<tr>
			<td align="center" colspan="3" class="sectionNavText">
				| <a href="{$webroot}index.cfm#Top Stories"><xsl:value-of select="$topStoriesLabel"/></a>
				| <a href="{$webroot}search.cfm">Search</a>
				|<br /><hr />
			</td>
		</tr>
		<tr>
			<td align="left" class="sectionNavText">
					<a href="JavaScript:document.selectionset.doselect.value=0;document.selectionset.submit()">Display Checked Stories</a>
			</td>
			<td align="center" class="sectionNavText">
					<a href="JavaScript:document.selectionset.doselect.value=1;document.selectionset.submit()">Print Checked Stories</a>
			</td>
			<td align="center" class="sectionNavText">
					<a href="JavaScript:document.selectionset.doselect.value=2;document.selectionset.submit()">Email Checked Stories</a>
			</td>
		</tr>
		<tr><td align="center" colspan="3" class="sectionNavText">&#xa0;</td></tr>
	</table>
</xsl:template>

<xsl:attribute-set name="table">
	<xsl:attribute name="width">100%</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="checkbox">
	 <xsl:attribute name="type">Checkbox</xsl:attribute>
	 <xsl:attribute name="value"><xsl:value-of select="@ID"/></xsl:attribute>
	 <xsl:attribute name="name">article_list</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
