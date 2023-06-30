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

  <xsl:import href="https://LB_CDN_BASE/resources/XSL/WatchReport2v01.xsl"/>

  <!-- ### Standard style variables #### -->
  <xsl:variable name="formatName">Breaking News Scroll</xsl:variable>
  <xsl:variable name="style" select="string('blast')" />
  <xsl:variable name="doFT" select="false()" />
  <xsl:variable name="bool___self-subscribe" select="false()" />
  <xsl:variable name="bool___do-section-nav" select="false()"/>
  <xsl:variable name="bool___do-mobile-link" select="false()" />
  <xsl:variable name="bool___do-tags" select="true()" />
  <xsl:variable name="bool___do-entities" select="false()" />
  <xsl:variable name="bool___do-social-shares" select="true()" />
  <xsl:variable name="font-family___text" select="string('Arial,sans-serif')" />
  <xsl:variable name="text___boilerplate">
    <![CDATA[Content in this alert is for your use only and may not be republished.]]>
  </xsl:variable>
  <xsl:variable name="text___empty-letter">
    <![CDATA[No current articles found for this alert.]]>
  </xsl:variable>
  <xsl:variable name="img-url___brand-header">
    <xsl:value-of select="string('https://LB_CDN_BASE/graphics/lbAlertHeader.jpg')" />
  </xsl:variable>
  <xsl:variable name="date-format___header">
  	<xsl:value-of select="string('[MNn] [D1], [Y]')"/>
  </xsl:variable>
  <xsl:variable name="date-format___bolt">
  	<xsl:value-of select="string('[M01]/[D01]/[Y0001]')"/>
  </xsl:variable>
  <xsl:variable name="date-format___ft">
  	<xsl:value-of select="$date-format___bolt" />
  </xsl:variable>
  <xsl:variable name="hostroot" select="string('?story_id=')" />
  <xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE" />

  <!-- ### Deprecated variables #### -->
  <xsl:variable name="boilerplate" select="$text___boilerplate" />
  <xsl:variable name="selfSubscribe" select="$bool___self-subscribe" />
  <xsl:variable name="brandImgURL" select="$img-url___brand-header" />
  <xsl:variable name="headerDateFormat" select="$date-format___header"/>
  <xsl:variable name="boltDateFormat" select="$date-format___bolt"/>
  <xsl:variable name="ftDateFormat" select="$date-format___ft" />
  <xsl:variable name="fontFamily" select="$font-family___text" />
  <xsl:variable name="style-lb___article-slugs__headline-div" select="$style___article-slugs__headline-div" />

  <!-- ### Custom variables #### -->
  <xsl:variable name="bool___group-by-date" select="true()"/>
  <!--<xsl:variable name="sectioned-articles" select="$allowedArticles[SECTION/@ID=$sectList/ID]" />-->

  <xsl:variable name="style___article-slugs__headline-div">
  	<xsl:value-of select="concat(  'margin:'  ,'0 0 0 0'  ,'; ' )" />
    <xsl:value-of select="concat(  'padding:'  ,'0'  ,'; ' )" />
  </xsl:variable>

  <xsl:attribute-set name="article-base__inserted-div">
    <xsl:attribute name="style">
      <xsl:value-of select="$style___article-base__inserted-div" />
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:value-of select="$name___article-base__inserted-div" />
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:variable name="name___article-base__inserted-div">
    <xsl:value-of select="string( 'article-base__inserted-div' )" />
  </xsl:variable>
  <xsl:variable name="style___article-base__inserted-div">
  	<xsl:value-of select="concat( 'margin-top:'  ,'0.9em'  ,'; ' )" />
  </xsl:variable>

  <xsl:attribute-set name="article-base__inserted-span">
    <xsl:attribute name="style">
      <xsl:value-of select="$style___article-base__inserted-span" />
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:value-of select="$name___article-base__inserted-span" />
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:variable name="name___article-base__inserted-span">
    <xsl:value-of select="string( 'article-base__inserted-span' )" />
  </xsl:variable>
  <xsl:variable name="style___article-base__inserted-span">
    <xsl:value-of select="concat( 'font-family:'  ,$font-family___text  ,'; ' )" />
    <xsl:value-of select="concat( 'color:'  ,string('#6d695f')  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,string('0.7777777em')  ,'; ' )" />
  </xsl:variable>


  <!-- ### Custom templates #### -->
  <xsl:key name="file-by-date" match="ARTICLE" use="substring(INSERTED, 1, 10)" />

  <xsl:template name="do-content-block">
    <xsl:param name="param___block-style" select="$style" />
    <xsl:choose>
      <xsl:when test=" $bool___group-by-date and $param___block-style = 'blast' ">
        <xsl:for-each select="$allowedArticles[count(. | key('file-by-date', substring(INSERTED, 1, 10))[1]) = 1]">
          <xsl:sort select="INSERTED" data-type="text" order="descending" />
          <xsl:apply-templates select="." mode="head">
            <xsl:with-param name="param___article-head-title">
              <xsl:apply-templates select="INSERTED" mode="title-format" />
            </xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="key('file-by-date', substring(INSERTED, 1, 10))[@ID=$allowedArticles/@ID]" mode="blast">
            <xsl:sort select="INSERTED" data-type="text" order="descending" />
            <xsl:sort select="@ID" data-type="number" order="descending" />
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$allowedArticles" mode="blast">
          <xsl:sort select="INSERTED" data-type="text" order="descending" />
          <xsl:sort select="@ID" data-type="number" order="descending" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="INSERTED" mode="title-format">
  	<xsl:param name="myName" select="string('inserted-title-format')" />
    <xsl:variable name="strDate" select="substring(.,1,10)" />
    <xsl:value-of select="format-date(xs:date($strDate), $date-format___header,'en',(),())" />
  </xsl:template>

  <xsl:template match="INSERTED" mode="article-format">
    <xsl:param name="myName" select="string('inserted-article-format')" />
    <xsl:variable name="strDate" select="replace( . ,' ' ,'T' )" />
    <div xsl:use-attribute-sets="article-base__inserted-div">
      <span xsl:use-attribute-sets="article-base__inserted-span">
        <xsl:value-of select="string('Added ')" />
        <xsl:value-of select="format-dateTime(xs:dateTime($strDate),'[h1]:[m01] [P] E.T.')"/>
      </span>
    </div>
  </xsl:template>

  <!-- this blast will break when WR2 is updated. replace with new blast, or...
      - change sumShares to sharecount-sum
      - change tdContent to content-td
      - change "table tableArticleBlast" to article-blast-table
  -->
  <xsl:template match="ARTICLE" mode="blast">
    <xsl:param name="myName" select="string('article-blast')" />
    <xsl:param name="doSharesBool" select="true()" />
    <xsl:param name="doSharesSection" select="string('111')" />
    <xsl:variable name="id" select="@ID" />
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <tr lbname="{$myName}">
      <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
        <a name="{concat('top',$id)}" lbname="{$myName}" />
        <table xsl:use-attribute-sets="table tableArticleBlast" lbname="{$myName}">
          <tr lbname="{$myName}">
            <td xsl:use-attribute-sets="" lbname="{$myName}">
              <xsl:if test="$bBlastThumbs">
                <xsl:apply-templates select="THUMBNAIL" />
              </xsl:if>
              <xsl:apply-templates select="INSERTED" mode="article-format" />
              <xsl:choose>
                <xsl:when test="string-length(SRCURL) &gt; 4">
                  <div xsl:use-attribute-sets="article-slugs__headline-div article-slugs__headline-span bodyFont">
                    <xsl:apply-templates select="." mode="buildurl">
                      <xsl:with-param name="linkText">
                        <xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
                      </xsl:with-param>
                      <xsl:with-param name="linkColor" select="$colorText" />
                      <xsl:with-param name="suppressLinkoutIcon" select="true()" />
                    </xsl:apply-templates>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="HEADLINE" mode="slugs" />
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$mediaType">
                <xsl:apply-templates select="@MEDIAID[.!=0]" />
              </xsl:if>
              <xsl:if test="$doTags">
                <xsl:call-template name="do-tags">
                  <xsl:with-param name="AID" select="$id" />
                </xsl:call-template>
              </xsl:if>
              <xsl:apply-templates select="SUBHEAD" mode="slugs" />
              <xsl:if test="$doSharesBool and count(SHARING) &gt; 0">
                <xsl:apply-templates select="SHARING" mode="sumShares">
                  <xsl:sort select="@ORDINAL" data-type="number" />
                </xsl:apply-templates>
              </xsl:if>
              <xsl:if test="$doEntities and count(ENTITIES/ENTITY) &gt; 0">
                <xsl:apply-templates select="ENTITIES/ENTITY" mode="name">
                  <xsl:sort select="@ORDINAL" data-type="number" />
                </xsl:apply-templates>
              </xsl:if>
              <xsl:apply-templates select="." mode="bolt" />
              <xsl:apply-templates select="ABSTRACT" />
              <!--
              <xsl:if test="string-length(SRCURL) or $bHosted">
                <div style="padding-top:1.25em;padding-bottom:1.5em;">
                  <xsl:apply-templates select="." mode="buildurl" />
                </div>
              </xsl:if>
              -->
              <xsl:if test="not($extRelated) and count($children) &gt; 0">
                <table xsl:use-attribute-sets="table" lbname="{$myName}">
                  <xsl:apply-templates select="$children" mode="ricochet">
                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                    <xsl:sort select="@ID" data-type="number" order="descending" />
                  </xsl:apply-templates>
                </table>
              </xsl:if>
            </td>
          </tr>
  				<tr lbname="{$myName}">
  					<td lbname="{$myName}">
  						<div xsl:use-attribute-sets="article-ricochet_margin-div" lbname="{$myName}">
  							<xsl:value-of select="$text___nbsp" />
  							<!--<hr style="margin-right:2%; margin-left:2%; border-style: solid; border-width:0.5px; color:{$colorBolt};"/>-->
  						</div>
  					</td>
  				</tr>
          <!--
          <xsl:if test="string-length(SRCURL) or $bHosted">
            <tr lbname="{$myName}">
              <td lbname="{$myName}">
                <xsl:apply-templates select="." mode="buildurl" />
              </td>
            </tr>
          </xsl:if>
          -->
        </table>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
