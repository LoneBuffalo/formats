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

<xsl:variable name="formatName">Kekst1 Format</xsl:variable>
<xsl:variable name="NLName" select="concat(/CLIPSHEET/@CLIENT, ' ', /CLIPSHEET/@NAME)" />
<xsl:variable name="dateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="timeFormat" select="string('[h]:[m01] [PN] [ZN,*-3]')"/>
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="clipDate" select="if (/CLIPSHEET/LOCAL_DATE) then /CLIPSHEET/LOCAL_DATE else /CLIPSHEET/CREATE_DATE" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE" />
<!--<xsl:variable name="fulltextArticles" select="$allowedArticles[not (SRCURL/@REDIRECT=1)]" />-->
<xsl:variable name="fulltextArticles" select="$allowedArticles" />
<xsl:variable name="parents" select="$allowedArticles[not (@PARENT &gt; 0)]" />
<xsl:variable name="bullSectList" select="/CLIPSHEET/SECTION[ID=$parents/SECTION/@ID][NEWSLETTER!=0][ORDINAL &lt; number(100)]" />
<xsl:variable name="blastSectList" select="/CLIPSHEET/SECTION[ID=$parents/SECTION/@ID][NEWSLETTER!=0][number(ORDINAL) &gt; number(99)]" />
<xsl:variable name="strAID">
    <xsl:call-template name="make-strAID">
        <xsl:with-param name="articles" select="$fulltextArticles" />
    </xsl:call-template>
</xsl:variable>
<xsl:variable name="markClass"><![CDATA[<mark class="mark">]]></xsl:variable>

<xsl:variable name="FTXML" select="document(concat($webroot,'XML/stdFullStory.xml?story_id=',$strAID))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:template match="/">
    <div lang="EN-US" link="#0563C1" vlink="#954F72">
        <div style="font-size:10.0pt;font-family:Arial,sans-serif;color:#222;">
            <p>&#xa0;</p>
            <xsl:call-template name="do-page-header" />
            <xsl:call-template name="do-report-divider">
                <xsl:with-param name="divTitle" select="string('Index')" />
            </xsl:call-template>
            <xsl:call-template name="do-toc" />
            <xsl:choose>
              <xsl:when test="count($parents) = 0">
                <div style="margin:1em;font-size:120%;font-weight:bold;">
                  No articles found for this edition.
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="do-report-divider">
                    <xsl:with-param name="divTitle" select="string('Media')" />
                </xsl:call-template>
                <p></p>
            <xsl:call-template name="do-full-text" />
              </xsl:otherwise>
            </xsl:choose>
        </div>
    </div>
</xsl:template>

<xsl:template name="do-page-header">
    <p align="center" style="text-align:center;margin:0;">
        <span style="font-weight:bold;color:#411c5a">
            <xsl:value-of select="$NLName" />
        </span>
    </p>
    <p align="center" style="text-align:center;margin:0;">
        <span style="font-weight:bold;font-style:italic;color:#a6a6a6">
            <xsl:value-of select="format-dateTime(xs:dateTime($clipDate[1]), $dateFormat,'en',(),())" />
        </span>
    </p>
    <p align="center" style="text-align:center;margin:0;">
        <span style="font-weight:bold;font-style:italic;color:#a6a6a6">
            <xsl:value-of select="format-dateTime(xs:dateTime($clipDate[1]),$timeFormat,'en',(),())" />
        </span>
    </p>
    <div align="center" style="text-align:center">
        <hr size="2" width="100%" align="center"/>
    </div>
</xsl:template>

<xsl:template name="do-report-divider">
    <xsl:param name="divTitle" />
    <p style="background:#525357">
        <span style="font-weight:bold;color:white;">
            <xsl:value-of select="$divTitle" />
        </span>
    </p>
    <p style="text-autospace:none">
    </p>
</xsl:template>

<xsl:template name="do-toc">
    <xsl:apply-templates select="$bullSectList" mode="toc-bullets">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
    <xsl:apply-templates select="$blastSectList" mode="toc-blast">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>

</xsl:template>

<xsl:template name="do-full-text">
    <xsl:apply-templates select="$bullSectList" mode="full-text">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
    <xsl:apply-templates select="$blastSectList" mode="full-text">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="toc-blast">
    <xsl:variable name="sid" select="ID" />
    <xsl:apply-templates select="." mode="head" />
    <xsl:apply-templates select="$parents[SECTION/@ID=$sid]" mode="blast">
        <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="toc-bullets">
    <xsl:variable name="sid" select="ID" />
    <xsl:apply-templates select="." mode="head" />
    <xsl:apply-templates select="$parents[SECTION/@ID=$sid]" mode="bullet">
        <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="full-text">
	  <xsl:variable name="sid" select="ID" />
	  <!--<xsl:variable name="sArticles" select="$fulltextArticles[SECTION/@ID=$sid]" />-->
		<xsl:variable name="sArticles" select="$parents[SECTION/@ID=$sid]" />
	  <xsl:apply-templates select="$sArticles" mode="fulltext">
	    	<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
	  </xsl:apply-templates>
</xsl:template>

<xsl:template match="SECTION" mode="head">
    <p class="sectionHead" style="text-autospace:none">
        <span style="font-weight:bold;text-decoration:underline;">
            <xsl:value-of disable-output-escaping="yes" select="NAME" />
        </span>
    </p>
</xsl:template>

<xsl:template match="ARTICLE" mode="bullet">
  <xsl:variable name="aid" select="@ID" />
  <xsl:variable name="kids" select="$allowedArticles[@PARENT = $aid]" />
  <p class="MsoListParagraph">
          <xsl:choose>
              <xsl:when test="count($kids) &gt; 0">
                  <xsl:attribute name="style">
                  <xsl:value-of select="string('margin-bottom:0;padding-bottom:0;')" />
                  </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
          </xsl:choose>
    <xsl:call-template name="do-indent" />
    <span style="font-weight:bold;">
        <xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /> –
    </span>
    <span>
        <xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
    </span>
    <xsl:if test="count($kids) &gt; 0">
        <ul style="margin-top:0;padding-top:0">
            <xsl:apply-templates select="$kids" mode="kid-bullet">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
            </xsl:apply-templates>
    </ul>
    </xsl:if>
    </p>
</xsl:template>
<xsl:template match="ARTICLE" mode="kid-bullet">
        <li>(<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />)
        <xsl:value-of disable-output-escaping="yes" select="HEADLINE" /></li>
</xsl:template>

<xsl:template match="ARTICLE" mode="blast">
    <p>
    <xsl:call-template name="do-indent" />
    <span style="font-weight:bold;">
        <xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /> –
    </span>
    <span>
        <xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
    </span>
    </p>
    <p>
        <xsl:value-of select="ABSTRACT" />
    </p>
</xsl:template>

<xsl:template match="ARTICLE" mode="fulltext">
	  <xsl:variable name="aid" select="@ID" />
    <xsl:variable name="kids" select="$allowedArticles[@PARENT = $aid]" />
		<xsl:variable name="abstractString" select="string(ABSTRACT)" />
		<div class="mediaBlock__wrapper" style="margin-top:0;margin-right:0;margin-bottom:2.4em;margin-left:0;">
			  <p class="MsoNormal" style="margin:0;">
				    <span style="font-weight:bold;">
				      	<xsl:value-of disable-output-escaping="yes" select="PUBLICATION" /> –
				      	<xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
				    </span>
			  </p>
			  <p class="MsoNormal" style="margin:0;">
					  <span style="font-weight:bold;">
					    	<xsl:apply-templates select="AUTHOR" />
					  </span>
			  </p>
			  <p class="MsoNormal" style="margin:0;">
					  <span style="font-weight:bold;">
					    	<xsl:apply-templates select="@PUBLISHDATE" />
					  </span>
			  </p>
				<xsl:choose>
						<xsl:when test="SRCURL/@REDIRECT=1">
								<p class="mediaBlock__articleTextWrapper" style="font-weight:normal;margin-top:1em;margin-right:0;margin-bottom:1em;margin-left:0;">
										<xsl:value-of disable-output-escaping="yes" select="$abstractString" />
								</p>
								<p class="MsoNormal" style="margin:0;">
										<a href="{SRCURL}" style="font-weight:normal;">Link to clip</a>
								</p>
						</xsl:when>
						<xsl:when test="not(SRCURL/@REDIRECT=1)">
								<p class="mediaBlock__articleTextWrapper" style="margin-top:1em;margin-right:0;margin-bottom:1em;margin-left:0;">
										<xsl:call-template name="ARTICLEBODY">
									    	<xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$aid]/ARTICLEBODY" />
									  </xsl:call-template>
								</p>
						</xsl:when>
						<xsl:otherwise>
								<p class="MsoNormal" style="margin:0;">
								</p>
						</xsl:otherwise>
				</xsl:choose>
                            </div>
                            <xsl:apply-templates select="$kids" mode="fulltext">
                                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            </xsl:apply-templates>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
    <xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
    <xsl:value-of select="format-date(xs:date($strDate), $dateFormat,'en',(),())" />
</xsl:template>

<xsl:template match="AUTHOR">
	<xsl:if test="position()=1">By </xsl:if>
    <xsl:choose>
    <xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
    <xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
    <xsl:otherwise /> <!-- not between authors, do nothing special -->
    </xsl:choose>
    <xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template name="ARTICLEBODY">
    <xsl:param name="article" />
    <div class="articleFullText" style="font-weight:normal;margin-top:1em;">
        <xsl:value-of disable-output-escaping="yes" select="$article" />
    </div>
</xsl:template>

<xsl:template name="do-indent">
    <span style="font-size:10.0pt;font-family:Symbol">
        <span>·
            <span>
            &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
            </span>
        </span>
    </span>
</xsl:template>

<xsl:template name="make-strAID">
    <xsl:param name="articles" />
    <xsl:choose>
        <xsl:when test="count($articles) &gt; 0">
            <xsl:for-each select="$articles/@ID">
                <xsl:value-of select="." />
                <xsl:if test="position()!=last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="string('0')" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
