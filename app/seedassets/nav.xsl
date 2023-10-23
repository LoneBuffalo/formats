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
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/clientvars.xsl"/>

<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="assetroot" select="string('https://lbpscdn.lonebuffalo.com/')" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/RELEASE_DATE)" />
<xsl:variable name="region" select="translate(string(/CLIPSHEET/REGION),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
<xsl:variable name="sectList" select="/CLIPSHEET/SECTION[ID=/CLIPSHEET/ARTICLE[not(@TOPSTORY!=0)]/SECTION/@ID]" />
<xsl:variable name="dateArg" select="format-date(xs:date(substring($clipDate,1,10)), $dateArgFormat,'en',(),())" />
<xsl:variable name="edition" select="translate(string(/CLIPSHEET/REGION), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />

<xsl:template match="/">
<form action="index.cfm?do=results" method="post">
	<table style="border:solid 1px #6688CC; margin-bottom: 1em;" xsl:use-attribute-sets="table">
	
		<tbody>
		<tr>
			<td class="navHeading" colspan="2">
				QUICK SEARCH
			</td>
		</tr>
		<tr style="padding-top: 0.5em; padding-bottom: 1em;">
			<td align="center">
				<input name="ffkeywords" maxlength="255" size="10" />
			</td>
			<td align="right" style="padding-right: 1em;">
				<input type="hidden" name="ffsections" value="" />
				<input type="hidden" name="ffauthor" value="" />
				<input type="hidden" name="ffpublication" value="" />
				<input type="image" name="Search" src="{$assetroot}resources/img/go.gif" /> 
			</td>
		</tr>
		<tr style="padding-bottom: 1em;">
			<td class="navText" colspan="2">
				<a href="{$webroot}?do=search">
					Advanced Search
				</a>
			</td>
		</tr>
		</tbody>
	</table>
</form>
<table style="margin-bottom: 1em;" xsl:use-attribute-sets="table">
	<tbody>
	<tr>
		<td class="navHeading" colspan="2">
			TODAY'S REPORT
		</td>
	</tr>
	<tr style="padding-top: 0.5em; padding-bottom: 1em;">
		<td class="navText">
			<xsl:if test="/CLIPSHEET/ARTICLE[@TOPSTORY!=0]">
				<a href="{$webroot}index.cfm?edition={$region}&amp;today={$dateArg}#{translate($topStoriesLabel,' ','')}">
					<xsl:value-of select="$topStoriesLabel"/>
				</a><br/>
			</xsl:if>
			<xsl:apply-templates select="$sectList[DISPLAY!=0]">
				<xsl:sort select="ORDINAL" data-type="number" />
			</xsl:apply-templates>
		</td>
	</tr>
<!--	<tr style="padding-top: 0.5em;">
		<td class="navText">
			<script type="text/javascript" language="Javascript">
			<xsl:comment>
				function today_relocate() {
					box = document.today.today_url;
					destination = box.options[box.selectedIndex].value;
					if (destination) location.href = destination;
				}
			</xsl:comment>
			</script>
			<form name="today" method="post" target="_top">
				<select onchange="javascript:today_relocate();" name="today_url">
					<option value="{$webroot}index.cfm?edition=americas&amp;today={$dateArg}">
						<xsl:if test="$edition = 'americas'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						US
					</option>
					<option value="{$webroot}index.cfm?edition=europe&amp;today={$dateArg}">
						<xsl:if test="$edition = 'europe'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						International
					</option>
				</select>
			</form>

		</td>
	</tr> -->
	</tbody>
</table>
<table style="margin-bottom: 0.5em;" xsl:use-attribute-sets="table">
	<tbody>
	<tr>
		<td class="navHeading" colspan="2">
			ARCHIVES
		</td>
	</tr>
	</tbody>
</table>
</xsl:template>


<xsl:template match="SECTION">
	<a href="{$webroot}index.cfm?edition={$region}&amp;today={$dateArg}#{translate(NAME,' ', '')}">
		<xsl:value-of disable-output-escaping="yes" select="NAME"/>
	</a><br/>
</xsl:template>

<xsl:template match="SECTION" mode="otherResearch">
	<a href="{$webroot}view_section.cfm?section_id={ID}&amp;edition={$region}&amp;today={$dateArg}">
		<xsl:value-of disable-output-escaping="yes" select="NAME"/>
	</a><br/>
</xsl:template>

<xsl:attribute-set name="table">
	 <xsl:attribute name="width">100%</xsl:attribute>
	 <xsl:attribute name="border">0</xsl:attribute>
	 <xsl:attribute name="cellspacing">0</xsl:attribute>
	 <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="checkbox">
	 <xsl:attribute name="type">checkbox</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
