<?xml version='1.0'?>
<!--  Copyright Lone Buffalo, Inc.
Notes: A shell with padding set but variables for minWidth, colorFieldBG, colorContentBG
-->
<xsl:stylesheet version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs xsl lbps #default">
        
<xsl:variable name="colorFieldBG" select="string('#F2F2F2')"/>
<xsl:variable name="colorContentBG" select="string('#FFFFFF')"/>
<xsl:variable name="colorBotBrdr" select="string('#EFEFED')" />
<xsl:variable name="width" select="string('680px')" />
<xsl:variable name="minWidth" select="string('480px')" />
<xsl:variable name="colorBodyLink" select="string('#0563C1')" />
<xsl:variable name="colorBodyVLink" select="string('#954F72')" />
<xsl:variable name="fontSize" select="string('11pt')" />
<xsl:variable name="webVersionURL" select="string('')" />
<xsl:variable name="mobileNotice" select="string('mobile users may prefer this')" />

<xsl:template name="do-shell">
    <body link="{$colorBodyLink}" vlink="{$colorBodyVLink}" style="font-size:{$fontSize};">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;background:{$colorFieldBG};border-collapse:collapse;min-width:{$minWidth};">
        <tbody>
    <tr>
        <td valign="top" style="padding:15.0pt 15.0pt 37.5pt 15.0pt;width:{$width};background:{$colorFieldBG};" id="email_container">
            <div align="center"> 
                <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100%;border-collapse:collapse;min-width:{$minWidth};background:{$colorContentBG};">
            <tbody>
            <tr>
                <td style="padding:0pt 15pt 0pt 15pt;min-width:{$minWidth}" id="header_content"> 
                <xsl:if test="string-length($webVersionURL) &gt; 0">
                    <a style="font-size:x-small;font-style:italic;text-align:left;" href="{$webVersionURL}">
                        <xsl:value-of select="$mobileNotice" />
                    </a>
                </xsl:if>


                    <table border="0" cellspacing="0" cellpadding="0" style="border-collapse:collapse;min-width:{$minWidth};">
                    <tbody>
                    <tr style="height:100pt">
                        <td style="width:100%;border-bottom:solid {$colorBotBrdr} 1.0pt;background:{$colorContentBG};padding:21.0pt 0in 0.0pt 0in;height:100pt;min-width:{$minWidth}">
                    <xsl:call-template name="do-newsletter" />
                        </td>
                    </tr>
                    </tbody>
                    </table>
            </td>
            </tr>
            </tbody>
            </table>
            </div>
    </td>
    </tr>
    </tbody>
    </table>
    </body>
</xsl:template>

</xsl:stylesheet>
