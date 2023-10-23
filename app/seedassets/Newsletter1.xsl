<?xml version="1.0" encoding="UTF-8"?>
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

<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/WatchReport2v01.xsl"/>

<xsl:variable name="formatName">Watch Report Newsletter1</xsl:variable>
<!-- placeholder variables below -->
<!-- 
     template design specs: #d7dad9 - entire background
                            #f2f2f2 - content background
                            #ffffff - nav background
-->
<!-- ### Basic Configuration parameters #### -->
<xsl:variable name="style" select="string('bullets')" />
<xsl:variable name="doFT" select="false()" />
<xsl:variable name="bHosted" select="true()" />
<xsl:variable name="sectEmptyFlag" select="false()" />
<xsl:variable name="width" select="string('690')" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')" />

<!-- ### branding header #### 
<xsl:variable name="brandImgURL" select="string('https://lbpscdn.lonebuffalo.com/resources/img/lbNLHeader.jpg')" />
-->
<xsl:variable name="reportTitle" select="/CLIPSHEET/@NAME" />
<xsl:variable name="bBlastThumbs" select="false()" />
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="boltDateFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="ftDateFormat" select="$boltDateFormat" />
<xsl:variable name="colorText" select="string('#231914')" />
<xsl:variable name="fontFamily" select="string('Arial,sans-serif')" />
<xsl:variable name="fontSize" select="string('62.5%')" />
<xsl:variable name="colorHead" select="string('#6d695f')" />
<xsl:variable name="colorBolt" select="string('#6d695f')" />
<xsl:variable name="colorLink" select="string('#d2503c')" />
<xsl:variable name="bgcolorHead" select="string('#231914')" />
<xsl:variable name="bgcolor" select="string('#d7dad9')" />
<xsl:variable name="bgcolorContent" select="string('#f2f2f2')" />
<xsl:variable name="bgcolorNav" select="string('#ffffff')" />
<xsl:variable name="linkImgURL" select="string('https://lbpscdn.lonebuffalo.com/resources/img/linkout.png')" />
<xsl:variable name="styleBody" select="concat('font-family:',$fontFamily,';background-color:',$bgcolor,';color:',$colorText,';')"/>
<xsl:variable name="styleSectionHead" select="string('font-size:2em;font-weight:bold;margin-right:.25em;')" />
<xsl:variable name="styleHeadline" select="string('font-weight:bold;font-size:1.5em;margin:0;padding:0;')" />
<xsl:variable name="styleChildHed" select="string('font-weight:bold;font-size:1.2em;margin:0;padding:0;')" />
<xsl:variable name="styleReportTitle" select="string('font-size:1.8em;font-weight:bold;font-family:Courier;')" />
<!-- placeholder variables above -->
</xsl:stylesheet>
