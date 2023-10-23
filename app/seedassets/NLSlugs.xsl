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
<xsl:import href="https://lbpscdn.lonebuffalo.com/clients/_generic/assets/nlVars.xsl"/>

<xsl:variable name="formatName">Watch Report slugs</xsl:variable>
<!-- placeholder variables below -->
<!-- 
     template design specs: #d7dad9 - entire background
                            #f2f2f2 - content background
                            #ffffff - nav background
-->
<!-- ### Basic Configuration parameters #### -->
<xsl:variable name="style" select="string('slugs')" />
</xsl:stylesheet>
