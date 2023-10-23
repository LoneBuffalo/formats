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
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/clientvars.xsl"/>

<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="breakingNewsLabel" select="string('Breaking News')"/>
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="clipDate" select="string(/CLIPSHEET/RELEASE_DATE)" />
<xsl:variable name="edition" select="string(/CLIPSHEET/REGION)" />

<xsl:output method="xhtml" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />

<xsl:template match="/">
<div class="banner">
	<div class="bannerText" style="float:right;margin:20px;margin-top:5px;">
		<xsl:value-of select="format-date(xs:date(substring($clipDate,1,10)), $headerDateFormat,'en',(),())" />
	</div>
	<div>
		<img src="{$assetroot}{$brandImage}" alt="" border="0" class="logo" />
		<span class="bannerTitle"><xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/@NAME" /></span>
	</div>
	<div class="headnav" style="width:100%;text-align:right;padding:1px;height:16px;">
		<xsl:if test="/CLIPSHEET/SECTION[NAME = $breakingNewsLabel]">
			<span class="headnav" style="margin-left:3em;">
			<a href="{$webroot}breakingnews.cfm" target="body">
				BREAKING NEWS
			</a>
	 		</span>
		</xsl:if>
		<span class="headnav" style="margin-right: 5em;" >
			<a href="{$webroot}?do=signup&amp;edition={$edition}">
				get the Clipsheet via e-mail!
			</a>
		</span>
		<span class="headnav" style="margin-right: 5em;">
			<!-- <a href="{$webroot}?do=tone">metrics</a> -->
		</span>
		<span class="headnav" style="margin-right: 5em;">
			<a href="mailto:tech@lonebuffalo.com">feedback</a>
		</span>
	</div>
</div>
</xsl:template>

<xsl:attribute-set name="table">
	 <xsl:attribute name="width">100%</xsl:attribute>
	 <xsl:attribute name="border">0</xsl:attribute>
	 <xsl:attribute name="cellspacing">0</xsl:attribute>
	 <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
