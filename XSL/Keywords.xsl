<?xml version='1.0'?>
<!--
Copyright Lone Buffalo, Inc.
$Revision:: 968                  $ : Revision number of this file
$Date:: 2012-05-11 10:41:09 -070#$ : date of given revision and copyright
$Author:: tech@lonebuffalo.com   $ : the author of the given revision
 Notes:
-->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions" >

<xsl:function name="lbps:cleanWML">
	<xsl:param name="text"/>
	<!--
	// handle '$' (used to denote variables in WML, so need '$$' for each '$')
	// handle IMG tags (replace with '[IMAGE]').
	// WML is a little more picky about <p> tags (can't be nested)
		assume the text we've been given will be placed with <p></p>
		tags, so replace any embedded <p> or </p> tags with <br/>
		to avoid potential <p> tag nesting
	// make <br> tags into legal xml (<br/>)
	// handle the &#039; ("'") inserted by the publish system - shouldn't need this
	-->
	<xsl:variable name="fixDollar" select="replace($text,'\$','\$\$','i')" />
	<xsl:variable name="remImage" select="replace($fixDollar,'&lt;img[^&gt;]*&gt;','[IMAGE]','i')" />
	<xsl:variable name="fixP" select="replace($remImage,'&lt;/?p[^&gt;]*&gt;','&lt;br/&gt;','i')" />
	<xsl:variable name="fixBR" select="replace($fixP,'&lt;br[^/&gt;]*&gt;','&lt;br/&gt;','i')" />
	<xsl:variable name="fixApo" select="replace($fixBR,'&amp;#039;','''')" />
	<xsl:value-of select="$fixApo" />
</xsl:function>

<xsl:function name="lbps:do-keywords">
	<xsl:param name="text"/>
	<xsl:param name="keywords"/>
	<xsl:call-template name="do-replace-keys">
		<xsl:with-param name="text" select="$text"/>
		<xsl:with-param name="keys" select="$keywords/KEYWORDS/*"/>
	</xsl:call-template>
</xsl:function>

<xsl:template name="do-replace-keys">
    <xsl:param name="text"/>
    <xsl:param name="keys"/>
    <xsl:choose>

    <xsl:when test="$keys[self::BOLD]">
        <xsl:variable name="boldwords">
            <xsl:for-each select="$keys[self::BOLD]">
                <xsl:if test="position()!=1">|</xsl:if>
                <xsl:value-of select="." />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="regex">
            <xsl:text>([\p{P}\p{Z}\p{S}]|^)(</xsl:text>
			<xsl:value-of select="translate(string($boldwords), ',', '|')"/>
            <xsl:text>)([\p{P}\p{Z}p{S}]|$)</xsl:text>
        </xsl:variable>
        <xsl:variable name="first">
		<xsl:analyze-string select="normalize-space($text)" regex="{$regex}" flags="i">
			<xsl:matching-substring>
			<xsl:value-of select="regex-group(1)" />&lt;b&gt;<xsl:value-of select="regex-group(2)"/>&lt;/b&gt;<xsl:value-of select="regex-group(3)" />
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
		</xsl:variable>
        <xsl:call-template name="do-replace-keys">
            <xsl:with-param name="text" select="$first"/>
            <xsl:with-param name="keys" select="$keys[not(self::BOLD)]"/>
        </xsl:call-template>
    </xsl:when>

    <xsl:when test="$keys[self::SRCHWRDS]">
        <xsl:variable name="srchwrds">
            <xsl:for-each select="$keys[self::SRCHWRDS]">
                <xsl:if test="position()!=1">|</xsl:if>
                <xsl:value-of select="." />
            </xsl:for-each>
        </xsl:variable>
	<xsl:variable name="regex">
            <xsl:text>([\p{P}\p{Z}])(</xsl:text>
		<xsl:value-of select="translate(string($srchwrds), ',', '|')" />
            <xsl:text>)([\p{P}\p{Z}])</xsl:text>
	</xsl:variable>
        <xsl:variable name="first">
		<xsl:analyze-string select="normalize-space($text)" regex="{$regex}" flags="i">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(1)" />
				&lt;span class=&quot;srchwd&quot;&gt;<xsl:value-of select="regex-group(2)"/>&lt;/span&gt;
				<xsl:value-of select="regex-group(3)" />
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
        </xsl:variable>
        <xsl:call-template name="do-replace-keys">
            <xsl:with-param name="text" select="$first"/>
            <xsl:with-param name="keys" select="$keys[not(self::SRCHWRDS)]"/>
        </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
        <xsl:value-of select="$text"/>
    </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>