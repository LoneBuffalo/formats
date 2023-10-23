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

<xsl:variable name="cdnroot">https://lbpscdn.lonebuffalo.com/</xsl:variable>
<xsl:variable name="assetroot"><xsl:value-of select="concat($cdnroot,'clients/_generic/')" /></xsl:variable>
<xsl:variable name="brandImage">assets/logo.png</xsl:variable>
<xsl:variable name="topStoriesLabel">Top Stories</xsl:variable>
</xsl:stylesheet>
