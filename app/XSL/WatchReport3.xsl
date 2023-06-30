<?xml version='1.0'?>
<xsl:stylesheet version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs xsl lbps">

<xsl:import href="https://LB_CDN_BASE/resources/XSL/Keywords.xsl" />

<xsl:variable name="formatName">WatchReport3 base</xsl:variable>

<xsl:variable name="bool__do-toc-block" select="true()" />
<xsl:variable name="bool__do-summaries-block" select="true()" />
<xsl:variable name="bool__do-fulltext-block" select="true()" />
<xsl:variable name="bool__do-common-block" select="false()" />


<!-- #####  variables  -  feature options  ##### -->
<xsl:variable name="bool__use-hosted-portal" select="false()" />
<xsl:variable name="bool__disable-subscribe-via-portal" select="false()" />
<xsl:variable name="bool__show-empty-section" select="false()" />
<xsl:variable name="bool__duplicate-top-stories" select="false()" />
<xsl:variable name="bool__do-top-stories-as-section" select="true()" />
<xsl:variable name="bool__do-mobile-ref" select="true()" />
<xsl:variable name="bool__do-sharecount-sum" select="false()" />
<xsl:variable name="bool__do-section-head-breakline" select="false()" />
<xsl:variable name="opt__exec-sect-id" select="string('1')" />
<xsl:variable name="opt__hide-article-ordinal-gt" select="string('')" />


<!-- #####  variables  -  core style values  ##### -->
<xsl:variable name="attr-val__bg-color_frame" select="string('#e6e6e6')" />
<xsl:variable name="attr-val__bg-color_content" select="string('#ffffff')" />
<xsl:variable name="attr-val__bg-color_reference" select="string('#EEEEEE')" />
<xsl:variable name="attr-val__bg-color_contrast" select="string('#333333')" />

<xsl:variable name="attr-val__color_link" select="string('#000000')" />
<xsl:variable name="attr-val__color_title" select="string('#000000')" />
<xsl:variable name="attr-val__color_content" select="string('#333333')" />
<xsl:variable name="attr-val__color_reference" select="string('#666666')" />
<xsl:variable name="attr-val__color_contrast" select="string('#CCCCCC')" />
<xsl:variable name="attr-val__color_hilite" select="string('#d2503c')" />
<xsl:variable name="attr-val__color_break" select="string('#999999')" />

<xsl:variable name="attr-val__font-family_title">
  <xsl:value-of select="$attr-val__font-family_content" />
</xsl:variable>
<xsl:variable name="attr-val__font-family_content">
  <xsl:text disable-output-escaping="yes">'Arial' ,Arial ,sans-serif</xsl:text>
</xsl:variable>
<xsl:variable name="attr-val__font-family_bolt">
  <xsl:text disable-output-escaping="yes">'Courier' ,Courier ,serif</xsl:text>
</xsl:variable>
<xsl:variable name="attr-val__font-family_alt">
  <xsl:text disable-output-escaping="yes">'Infiniti Brand', 'Helvetica', Helvetica, Arial, sans-serif</xsl:text>
</xsl:variable>

<xsl:variable name="attr-val__box-border_frame-shade">
  <xsl:value-of select="concat( '1px solid ' ,$attr-val__bg-color_frame )" />
</xsl:variable>
<xsl:variable name="attr-val__box-border_content-shade">
  <xsl:value-of select="concat( '1px solid ' ,$attr-val__color_break )" />
</xsl:variable>
<xsl:variable name="attr-val__box-border_contrast-shade">
  <xsl:value-of select="concat( '1px solid ' ,$attr-val__color_contrast )" />
</xsl:variable>


<!-- #####  variables  -  processing  ##### -->
<xsl:variable name="opt__apple-app-id" select="string('1450569477')" />
<xsl:variable name="opt__google-analytics-UAID" select="string('UA-1191451-29')" />
<xsl:variable name="opt__google-analytics-date-arg-format" select="string('[M01]/[D01]/[Y0001]')"/>

<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="hostroot" select="/CLIPSHEET/MAILURL" />
<xsl:variable name="webVersionURL" select="/CLIPSHEET/WEBVERSIONURL" />
<xsl:variable name="xml__clip-date" select="string(/CLIPSHEET/LOCAL_DATE | /CLIPSHEET/CREATE_DATE[not(boolean(/CLIPSHEET/RELEASE_DATE))])" />

<xsl:variable name="xml__allowed-articles" select="
  /CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="xml__enabled-sections-list" select="
  /CLIPSHEET/SECTION[DISPLAY!=0][NEWSLETTER!=0][number(ID)!=number($opt__exec-sect-id)]" />
<xsl:variable name="xml__edition-sections-list" select="
  if ($bool__show-empty-section)
  then $xml__enabled-sections-list
  else $xml__enabled-sections-list[ID=$xml__allowed-articles/SECTION/@ID]" />
<xsl:variable name="xml__top-stories" select="$xml__allowed-articles[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="xml__edition-issues-list" select="/CLIPSHEET/ISSUE" />

<xsl:variable name="fullTextIDs" select="$xml__allowed-articles[not(SRCURL/@REDIRECT=1)]/@ID" />
<xsl:variable name="strAID">
<xsl:call-template name="make-strAID">
  <xsl:with-param name="ids" select="$fullTextIDs" />
</xsl:call-template>
</xsl:variable>
<xsl:variable name="xmlPath" select="string('XML/stdFullStory.xml?story_id=')" />
<xsl:variable name="FTXML" select="document(concat($webroot,$xmlPath,$strAID))"/>

<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />


<!-- #####  variables  -  WR3 legacy vars remapping  ##### -->
<xsl:variable name="attr-val__bg-color_highlight" select="$attr-val__bg-color_reference" />


<!-- #####  variables  -  WR1 & WR2 legacy vars remapping  ##### -->
<xsl:variable name="bHosted" select="$bool__use-hosted-portal" />
<xsl:variable name="sectEmptyFlag" select="$bool__show-empty-section" />
<xsl:variable name="doFT" select="$bool__do-fulltext-block" />
<xsl:variable name="execSectID" select="$opt__exec-sect-id" />
<xsl:variable name="extOver" select="$opt__hide-article-ordinal-gt" />
<xsl:variable name="extOverOrdinal" select="$opt__hide-article-ordinal-gt" />
<xsl:variable name="dupeTop" select="$bool__duplicate-top-stories" />
<xsl:variable name="brandImgURL" select="$href-val_report-head__marquee-img-src" />
<xsl:variable name="lbCiteLink" select="$href-val__prepared-by-link" />
<xsl:variable name="preparedByLink" select="$href-val__prepared-by-link" />
<xsl:variable name="allowedArticles" select="$xml__allowed-articles" />
<xsl:variable name="sectList" select="$xml__edition-sections-list" />
<xsl:variable name="topStories" select="$xml__top-stories" />
<xsl:variable name="nlIssues" select="$xml__edition-issues-list" />


<!-- #####  variables  -  WR1 copies  ##### -->
<xsl:variable name="preferSrc" select="true()" />
<xsl:variable name="extRelated" select="false()" />
<xsl:variable name="mediaType" select="true()" />
<xsl:variable name="linkImgURL" select="string('https://LB_CDN_BASE/graphics/linkout.png')" />


<!-- #####  variables  -  wip and unused  ##### -->
<xsl:variable name="blankNode" select="/CLIPSHEET[not(@CID=/CLIPSHEET/@CID)]" />
<xsl:variable name="mobileAppLink">
  <xsl:value-of select="string('https://apps.apple.com/us/app/dispatch-by-lone-buffalo/id1450569477')" />
</xsl:variable>



<!-- ######## templates ################################################### -->

<xsl:output method="html" indent="yes" encoding="utf-8" />

<!-- #### templates ### page-body ######################################### -->

<xsl:template match="/">
  <xsl:param name="myLbn" select="string('/')" />
  <meta name="apple-itunes-app">
    <xsl:attribute name="content" select="$fn-val__apple-itunes-app_content" />
  </meta>
  <body xsl:use-attribute-sets="body-element" lbname="{$myLbn}">
    <xsl:call-template name="page-body" />
  </body>
</xsl:template>

<xsl:variable name="fn-val__apple-itunes-app_content">
  <xsl:value-of select="concat('app-id=' ,$opt__apple-app-id)" />
</xsl:variable>

<xsl:attribute-set name="body-element">
  <xsl:attribute name="topmargin" select="string('0')" />
  <xsl:attribute name="style">
    <xsl:value-of select="concat( '-webkit-text-size-adjust:'  ,'none'  ,'; ' )" />
    <xsl:value-of select="concat( 'width:'  ,'100% !important'  ,'; ' )" />
    <xsl:value-of select="concat( '-webkit-font-smoothing:'  ,'antialiased'  ,'; ' )" />
    <xsl:value-of select="concat( 'padding:'  ,'0'  ,'; ' )" />
    <xsl:value-of select="concat( 'margin:'  ,'0'  ,'; ' )" />
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_frame  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_frame" />
</xsl:attribute-set>


<xsl:template name="page-body">
  <xsl:param name="myLbn" select="string('page-body')" />
  <xsl:call-template name="do-preview-text" />
  <table xsl:use-attribute-sets="page-body__frame-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <td lbname="{$myLbn}">
        <table xsl:use-attribute-sets="page-body__content-table" lbname="{$myLbn}">
          <tr lbname="{$myLbn}">
            <td xsl:use-attribute-sets="page-body__content-table-td" lbname="{$myLbn}">
              <!--<xsl:call-template name="do-mobile-ref" />-->
              <xsl:call-template name="do-report-head" />
              <xsl:call-template name="do-report-body" />
              <xsl:call-template name="do-report-foot"/>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:variable name="attr-val__page-width_value">
  <xsl:value-of select="string('690')" />
</xsl:variable>
<xsl:variable name="attr-val__page-width_unit">
  <xsl:value-of select="string('px')" />
</xsl:variable>

<xsl:attribute-set name="page-body__frame-table">
  <xsl:attribute name="role" select="string('presentation')" />
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_frame  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_frame" />
  <xsl:attribute name="width" select="string('100%')" />
</xsl:attribute-set>

<xsl:attribute-set name="page-body__content-table">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'width:'  ,$attr-val__page-width_value  ,$attr-val__page-width_unit   ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="role" select="string('presentation')" />
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="width" select="$attr-val__page-width_value" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="class" select="string('content-width')" />
</xsl:attribute-set>

<xsl:attribute-set name="page-body__content-table-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_content  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_content" />
</xsl:attribute-set>


<xsl:template name="do-preview-text">
	<xsl:param name="myLbn" select="string('do-preview-text')" />
  <xsl:param name="myContent" select="$disp-val__email-preview-description"/>
  <xsl:param name="mySections"
    select="/CLIPSHEET/SECTION[DISPLAY!=0][NEWSLETTER!=0][number(ID)!=number($opt__exec-sect-id)][ID=$xml__allowed-articles/SECTION/@ID]">
  </xsl:param>
  <xsl:param name="section-top-ordinal" select="$mySections[ORDINAL=min($mySections/ORDINAL)]" />
  <xsl:param name="section-first-id" select="$section-top-ordinal[ID=max($section-top-ordinal/ID)]/ID" />
  <xsl:param name="article-top-ordinal" select="$xml__allowed-articles[SECTION/@ID=$section-first-id][SECTION/@ORDINAL=min(SECTION/@ORDINAL)][@PARENT=0]" />
  <xsl:param name="article-first" select="$article-top-ordinal[@ID=max($article-top-ordinal/@ID)]" />
  <xsl:param name="myHeadline">
    <xsl:choose>
      <xsl:when test="$bool__do-top-stories-as-section and $xml__top-stories">
        <xsl:value-of select="$xml__top-stories[position()=1]/HEADLINE" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$article-first/HEADLINE" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="string-length($myHeadline) &gt; 0">
      <div xsl:use-attribute-sets="page-body__preview-text-div" lbname="{$myLbn}">
        <xsl:value-of select="$myHeadline" />
      </div>
    </xsl:when>
    <xsl:when test="string-length($myContent) &gt; 0">
      <div xsl:use-attribute-sets="page-body__preview-text-div" lbname="{$myLbn}">
        <xsl:value-of select="$myContent" />
      </div>
    </xsl:when>
    <xsl:otherwise />
  </xsl:choose>
</xsl:template>

<xsl:variable name="disp-val__email-preview-description">
  <xsl:text disable-output-escaping="yes">Today's newsletter: </xsl:text>
</xsl:variable>

<xsl:attribute-set name="page-body__preview-text-div">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'color:'  ,$attr-val__bg-color_frame  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,'1px'  ,'; ' )" />
    <xsl:value-of select="concat( 'display:'  ,'none'  ,'; ' )" />
    <xsl:value-of select="concat( 'overflow:'  ,'hidden'  ,'; ' )" />
    <xsl:value-of select="concat( 'visibility:'  ,'hidden'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="do-mobile-ref_OLD">
	<xsl:param name="myLbn" select="string('do-mobile-ref')" />
  <xsl:param name="doTemplate" select="$bool__do-mobile-ref"/>
  <xsl:if test="string-length($webVersionURL) &gt; 0 and $doTemplate">
    <table xsl:use-attribute-sets="common-table page-body__mobile-ref-table" lbname="{$myLbn}">
      <tr lbname="{$myLbn}">
        <td xsl:use-attribute-sets="mobile-spacer-td page-body__common-frame-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
        <td xsl:use-attribute-sets="page-body__common-frame-td page-body__mobile-ref-td" lbname="{$myLbn}">
          <a xsl:use-attribute-sets="page-body__web-version-link_l" lbname="{$myLbn}" >
            <xsl:attribute name="href" select="$webVersionURL" />
            <xsl:value-of select="$disp-val__mobile-version_l" />
          </a>
          <a xsl:use-attribute-sets="page-body__web-version-link_r" lbname="{$myLbn}" >
            <xsl:attribute name="href" select="$webVersionURL" />
            <xsl:value-of select="$disp-val__mobile-version_r" />
          </a>
        </td>
        <td xsl:use-attribute-sets="mobile-spacer-td page-body__common-frame-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      </tr>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template name="do-mobile-ref">
	<xsl:param name="myLbn" select="string('do-mobile-ref')" />
  <xsl:param name="doTemplate" select="$bool__do-mobile-ref"/>
  <xsl:if test="string-length($webVersionURL) &gt; 0 and $doTemplate">
    <a xsl:use-attribute-sets="page-body__web-version-link_l" lbname="{$myLbn}" >
      <xsl:attribute name="href" select="$webVersionURL" />
      <xsl:value-of select="$disp-val__mobile-version_l" />
    </a>
    <a xsl:use-attribute-sets="page-body__web-version-link_r" lbname="{$myLbn}" >
      <xsl:attribute name="href" select="$webVersionURL" />
      <xsl:value-of select="$disp-val__mobile-version_r" />
    </a>
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val__mobile-version_l">
  <xsl:value-of select="string('View mobile-friendly newsletter')" />
</xsl:variable>

<xsl:variable name="disp-val__mobile-version_r">
  <xsl:value-of select="$disp-val__nbsp" />
  <xsl:value-of select="$disp-val__right-chevron" />
</xsl:variable>

<xsl:variable name="style_page-body__mobile-ref-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_common__content-link">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_link  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_common__content-link_no-uline">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_link  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'none'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="page-body__mobile-ref-table">
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="class" select="string('full-width')" />
</xsl:attribute-set>

<xsl:attribute-set name="page-body__mobile-ref-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_frame  ,'; ' )" />
    <xsl:value-of select="$style_page-body__mobile-ref-td" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="page-body__web-version-link_l">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__content-link" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="page-body__web-version-link_r">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__content-link_no-uline" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="do-report-head">
  <xsl:param name="myLbn" select="string('do-report-head')" />
  <xsl:param name="doMarqueeLink" select="$bool__marquee-as-link" />
  <table xsl:use-attribute-sets="report-head__spacer-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td page-body__common-frame-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="page-body__common-frame-td page-body__mobile-ref-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
        <xsl:call-template name="do-mobile-ref" />
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td page-body__common-frame-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
   </tr>
  </table>
  <table xsl:use-attribute-sets="report-head__marquee-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <xsl:choose>
        <xsl:when test="$doMarqueeLink">
          <a lbname="{$myLbn}">
            <xsl:attribute name="href" select="$href-val_report-head__marquee-link" />
            <img xsl:use-attribute-sets="report-head__marquee-img" lbname="{$myLbn}" />
          </a>
        </xsl:when>
        <xsl:otherwise>
          <img xsl:use-attribute-sets="report-head__marquee-img" lbname="{$myLbn}" />
        </xsl:otherwise>
      </xsl:choose>
    </tr>
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="report-head__marquee-spacer-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:variable name="disp-val_report-head__marquee-alt">
	<xsl:value-of select="$disp-val__client-report-title" />
</xsl:variable>

<xsl:variable name="href-val_report-head__marquee-img-src">
  <xsl:value-of select="string('https://LB_CDN_BASE/graphics/lbNLHeader.jpg')" />
</xsl:variable>

<xsl:variable name="bool__marquee-as-link" select="false()" />

<xsl:variable name="href-val_report-head__marquee-link">
  <xsl:value-of select="string('https://lonebuffalo.com/')" />
</xsl:variable>

<xsl:variable name="attr-val_report-head__marquee-img-width">
  <xsl:value-of select="concat( $attr-val__page-width_value  ,$attr-val__page-width_unit )" />
</xsl:variable>

<xsl:variable name="attr-val_report-head__marquee-table-align">
  <xsl:value-of select="string('center')" />
</xsl:variable>

<xsl:variable name="style_report-head__marquee-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'24px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="report-head__spacer-table">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_content  ,'; ' )" />
    <xsl:value-of select="concat( 'width:'  ,$attr-val__page-width_value  ,$attr-val__page-width_unit  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_content" />
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="width" select="$attr-val__page-width_value" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="class" select="string('web')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-head__marquee-table">
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="width" select="$attr-val__page-width_value" />
  <xsl:attribute name="align" select="$attr-val_report-head__marquee-table-align" />
  <xsl:attribute name="id" select="string('marqueeImage')" />
  <xsl:attribute name="class" select="string('content-width')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-head__marquee-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-head__marquee-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="class" select="string('content-width')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-head__marquee-img">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'display:'  ,'block'  ,'; ' )" />
    <xsl:value-of select="concat( 'vertical-align:'  ,'top'  ,'; ' )" />
    <xsl:value-of select="concat( 'width:'  ,$attr-val_report-head__marquee-img-width  ,'; ' )" />
    <xsl:value-of select="concat( 'height:'  ,'auto'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="vspace" select="string('0')" />
  <xsl:attribute name="hspace" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="height" select="string('auto')" />
  <xsl:attribute name="width" select="$attr-val__page-width_value" />
  <xsl:attribute name="class" select="string('mobile-image')" />
  <xsl:attribute name="src" select="$href-val_report-head__marquee-img-src" />
  <xsl:attribute name="alt" select="$disp-val_report-head__marquee-alt" />
</xsl:attribute-set>

<xsl:attribute-set name="report-head__marquee-spacer-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'font-size:'  ,'8px'  ,'; ' )" />
    <xsl:value-of select="concat( 'line-height:'  ,'8px'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="class" select="string('content-width')" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="height" select="string('20')" />
</xsl:attribute-set>


<xsl:template name="do-report-foot">
  <xsl:param name="myLbn" select="string('do-report-foot')" />
  <table xsl:use-attribute-sets="report-foot__container-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td report-foot__shade-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="report-foot__service-reference-td report-foot__shade-box-td" lbname="{$myLbn}">
        <a xsl:use-attribute-sets="report-foot__service-reference-link" lbname="{$myLbn}">
          <xsl:attribute name="href" select="$href-val__prepared-by-link" />
          <xsl:value-of select="$disp-val__prepared-by-display" />
        </a>
        <xsl:value-of select="$disp-val__service-reference-separator" />
        <a xsl:use-attribute-sets="report-foot__service-reference-link" lbname="{$myLbn}">
          <xsl:attribute name="href" select="$href-val__subscribe-link" />
          <xsl:value-of select="$disp-val__subscribe-display" />
        </a>
        <xsl:value-of select="$disp-val__service-reference-separator" />
        <span xsl:use-attribute-sets="report-foot__service-reference-span" lbname="{$myLbn}">
          <xsl:value-of select="$disp-val__user-support-display_prefix" />
        </span>
        <xsl:value-of select="$disp-val__nbsp" />
        <a xsl:use-attribute-sets="report-foot__service-reference-link" lbname="{$myLbn}">
          <xsl:attribute name="href" select="$href-val__user-support-link" />
          <xsl:value-of select="$disp-val__user-support-display" />
        </a>
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td report-foot__shade-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td report-foot__branding-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="report-foot__service-advisory-td report-foot__branding-box-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__service-advisory-boilerplate" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td report-foot__branding-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td report-foot__branding-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="report-foot__service-branding-td report-foot__branding-box-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
        <img xsl:use-attribute-sets="report-foot__service-branding-img report-foot__branding-box-td" lbname="{$myLbn}" />
        <xsl:value-of select="$disp-val__nbsp" />
        <div>
          <xsl:call-template name="do-GApixel">
            <xsl:with-param name="UAID" select="$opt__google-analytics-UAID" />
            <xsl:with-param name="locationName" select="string('foot')" />
          </xsl:call-template>
        </div>
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td report-foot__branding-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </table>
</xsl:template>

<xsl:variable name="href-val__prepared-by-link">
  <xsl:value-of select="string('https://lonebuffalo.com/')" />
</xsl:variable>
<xsl:variable name="disp-val__prepared-by-display">
  <xsl:value-of select="string('Prepared by Lone Buffalo, LLC.')" />
</xsl:variable>
<xsl:variable name="disp-val__support-email-addr_feedback">
  <xsl:value-of select="string('hello@lonebuffalo.com')" />
</xsl:variable>
<xsl:variable name="disp-val__support-email-addr_subscribe">
  <xsl:value-of select="string('tech@lonebuffalo.com')" />
</xsl:variable>
<xsl:variable name="disp-val__subscribe-display">
  <xsl:value-of select="string('Manage your subscription')" />
</xsl:variable>
<xsl:variable name="href-val__subscribe-link_mailto">
  <xsl:value-of select="concat(
    'mailto:'
    ,$disp-val__support-email-addr_subscribe
    ,'?subject=Unsubscribe from '
    ,$disp-val__client-name
    ,' '
    ,$disp-val__report-name
    ,'&#x26;body=Please unsubscribe this email address from '
    ,$disp-val__client-name
    ,' '
    ,$disp-val__report-name
    )" />
</xsl:variable>
<xsl:variable name="href-val__subscribe-link_portal">
  <xsl:value-of select="concat(/CLIPSHEET/LB_URL,'?do=signup')" />
</xsl:variable>
<xsl:variable name="href-val__subscribe-link">
  <xsl:choose>
    <xsl:when test="$bool__disable-subscribe-via-portal">
      <xsl:value-of select="$href-val__subscribe-link_mailto" />
    </xsl:when>
    <xsl:when test="$bool__use-hosted-portal">
      <xsl:value-of select="$href-val__subscribe-link_portal" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$href-val__subscribe-link_mailto" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="disp-val__user-support-display_prefix">
  <xsl:value-of select="string('Feedback?')" />
</xsl:variable>
<xsl:variable name="href-val__user-support-link">
  <xsl:value-of select="concat('mailto:' ,$disp-val__support-email-addr_feedback)" />
</xsl:variable>
<xsl:variable name="disp-val__user-support-display">
  <xsl:value-of select="$disp-val__support-email-addr_feedback" />
</xsl:variable>
<xsl:variable name="disp-val__service-reference-separator">
  <xsl:value-of select="$disp-val__menu-separator" />
</xsl:variable>
<xsl:variable name="disp-val__service-advisory-boilerplate">
  <xsl:value-of select="string('Content in this newsletter is for your use only and may not be republished.')" />
</xsl:variable>
<xsl:variable name="disp-val__service-branding-alt">
	<xsl:value-of select="$disp-val__prepared-by-display" />
</xsl:variable>
<xsl:variable name="href-val__service-branding-img-src">
  <xsl:value-of select="string('https://LB_CDN_BASE/graphics/lbNLbottomBrand.png')" />
</xsl:variable>

<xsl:variable name="attr-val_report-foot__shade-box-bg-color">
  <xsl:value-of select="$attr-val__bg-color_contrast" />
</xsl:variable>

<xsl:variable name="style_report-foot__service-reference-link">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_contrast  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_report-foot__service-reference-span_prefix-text">
  <xsl:value-of select="concat( 'font-size:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_report-foot__service-reference-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_contrast  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'18px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_report-foot__service-advisory-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'22px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="report-foot__container-table">
  <xsl:attribute name="style">
    <xsl:value-of select="$attr-val__bg-color_frame" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_frame" />
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="width" select="string('100%')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="class" select="string('full-width')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__shade-box-td">
  <xsl:attribute name="bgcolor" select="$attr-val_report-foot__shade-box-bg-color" />
  <xsl:attribute name="valign" select="string('middle')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__service-reference-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-foot__service-reference-td" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__service-reference-link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-foot__service-reference-link" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__service-reference-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-foot__service-reference-span_prefix-text" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__branding-box-td">
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_frame" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__service-advisory-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-foot__service-advisory-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__service-branding-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>

<xsl:attribute-set name="report-foot__service-branding-img">
  <xsl:attribute name="height" select="string('54')" />
  <xsl:attribute name="width" select="string('70')" />
  <xsl:attribute name="src" select="$href-val__service-branding-img-src" />
  <xsl:attribute name="alt" select="$disp-val__service-branding-alt" />
</xsl:attribute-set>


<!-- #### templates ### report-body ####################################### -->

<xsl:template name="do-report-body">
  <xsl:param name="myLbn" select="string('do-report-body')" />
  <table xsl:use-attribute-sets="report-body__table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <td lbname="{$myLbn}">
        <xsl:call-template name="do-top-msg" />
        <xsl:call-template name="do-executive-summary" />
        <xsl:call-template name="do-empty-letter" />
        <xsl:call-template name="do-toc-block" />
        <xsl:call-template name="do-summaries-block" />
        <xsl:call-template name="do-fulltext-block" />
        <xsl:call-template name="do-bottom-msg" />
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:attribute-set name="report-body__table">
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="width" select="string('100%')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="class" select="string('full-width')" />
</xsl:attribute-set>


<xsl:template name="do-top-msg">
  <xsl:param name="myLbn" select="string('do-top-msg')" />
  <xsl:param name="myContent" select="/CLIPSHEET/TOPMSG" />
  <xsl:if test="string-length($myContent) &gt; 0">
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="report-body__top-msg-td" lbname="{$myLbn}">
        <xsl:value-of disable-output-escaping="yes" select="$myContent" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_report-body__top-msg-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-style:'  ,'italic'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'20px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="report-body__top-msg-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-body__top-msg-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="do-empty-letter">
  <xsl:param name="myLbn" select="string('do-empty-letter')" />
  <xsl:param name="doTemplate" select="$xml__allowed-articles" />
  <xsl:if test="not($doTemplate)">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="report-body__empty-letter-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__empty-letter" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val__empty-letter">
  <xsl:value-of select="string('No articles found for this edition.')" />
</xsl:variable>

<xsl:variable name="style_report-body__empty-letter-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'35px'  ,'; ' )" />
  <xsl:value-of select="$style_common__article-container-padding-left" />
</xsl:variable>

<xsl:attribute-set name="report-body__empty-letter-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-body__empty-letter-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="do-bottom-msg">
  <xsl:param name="myLbn" select="string('do-bottom-msg')" />
  <xsl:param name="myContent" select="/CLIPSHEET/BOTMSG" />
  <!--
  <tr>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td height="25" style="line-height:5px;" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  -->
  <xsl:if test="$myContent">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td report-body__shade-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="report-body__shade-box-td report-body__bottom-msg-td" lbname="{$myLbn}">
        <xsl:if test="string-length($myContent) &gt; 0">
          <xsl:value-of disable-output-escaping="yes" select="$myContent" />
        </xsl:if>
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td report-body__shade-box-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="attr-val_report-body__shade-box-td-bg-color">
  <xsl:value-of select="$attr-val__bg-color_reference" />
</xsl:variable>

<xsl:variable name="style_report-body__bottom-msg-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_alt  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'18px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'30px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="report-body__bottom-msg-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_report-body__bottom-msg-td" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="report-body__shade-box-td">
  <xsl:attribute name="bgcolor" select="$attr-val_report-body__shade-box-td-bg-color" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>


<!-- #### templates ### section processing ################################ -->

<xsl:template match="SECTION" mode="process">
  <xsl:param name="myLbn" select="string('SECTION___process')" />
  <xsl:param name="myStyle" />
  <xsl:variable name="sid" select="ID" />
  <xsl:variable name="candidateArticles" select="
    if (number($opt__hide-article-ordinal-gt) = number($opt__hide-article-ordinal-gt))
    then $xml__allowed-articles[SECTION/@ID=$sid][not(@PARENT!=0)][number(SECTION/@ORDINAL) &lt;= number($opt__hide-article-ordinal-gt)]
    else $xml__allowed-articles[SECTION/@ID=$sid][not(@PARENT!=0)]" />
  <xsl:variable name="heldArticles" select="
    if (number($opt__hide-article-ordinal-gt) = number($opt__hide-article-ordinal-gt))
    then $xml__allowed-articles[SECTION/@ID=$sid][not(@PARENT!=0)][number(SECTION/@ORDINAL) &gt; number($opt__hide-article-ordinal-gt)]
    else $xml__allowed-articles[@ID=0]" />
  <xsl:variable name="sArticles" select="
    if ($bool__duplicate-top-stories and $myStyle!='fulltext')
    then $candidateArticles
    else $candidateArticles[not(@TOPSTORY!=0)]" />
  <xsl:variable name="issSArticles" select="$sArticles[@ID=$xml__edition-issues-list/ARTICLE/@ID]" />
  <xsl:variable name="issList" select="$xml__edition-issues-list[ARTICLE/@ID=$issSArticles/@ID]" />
  <xsl:variable name="non-issSArticles" select="$sArticles[not(@ID=$issSArticles/@ID)]" />
  <xsl:call-template name="do-format-selector">
    <xsl:with-param name="myStyle" select="$myStyle" />
    <xsl:with-param name="myId" select="$sid" />
    <xsl:with-param name="myTitle" select="NAME" />
    <xsl:with-param name="myIssueList" select="$issList" />
    <xsl:with-param name="myIssueArticles" select="$issSArticles" />
    <xsl:with-param name="myGeneralArticles" select="$non-issSArticles" />
  </xsl:call-template>
</xsl:template>


<xsl:template name="do-format-selector">
  <xsl:param name="myLbn" select="string('do-format-selector')" />
  <xsl:param name="myStyle" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myIssueList" />
  <xsl:param name="myIssueArticles" />
  <xsl:param name="myGeneralArticles" />
  <xsl:choose>
    <xsl:when test=" $myStyle = 'toc' ">
      <xsl:call-template name="do-section-as-toc">
        <xsl:with-param name="myId" select="$myId" />
        <xsl:with-param name="myTitle" select="$myTitle" />
        <xsl:with-param name="myIssueList" select="$myIssueList" />
        <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
        <xsl:with-param name="myGeneralArticles" select="$myGeneralArticles" />
      </xsl:call-template>
    </xsl:when>
    <xsl:when test=" $myStyle = 'summaries' ">
      <xsl:call-template name="do-section-as-summaries">
        <xsl:with-param name="myId" select="$myId" />
        <xsl:with-param name="myTitle" select="$myTitle" />
        <xsl:with-param name="myIssueList" select="$myIssueList" />
        <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
        <xsl:with-param name="myGeneralArticles" select="$myGeneralArticles" />
      </xsl:call-template>
    </xsl:when>
    <xsl:when test=" $myStyle = 'fulltext' ">
      <xsl:call-template name="do-section-as-fulltext">
        <xsl:with-param name="myId" select="$myId" />
        <xsl:with-param name="myTitle" select="$myTitle" />
        <xsl:with-param name="myIssueList" select="$myIssueList" />
        <xsl:with-param name="myIssueArticles" select="$myIssueArticles[not(SRCURL/@REDIRECT=1)]" />
        <xsl:with-param name="myGeneralArticles" select="$myGeneralArticles[not(SRCURL/@REDIRECT=1)]" />
      </xsl:call-template>
    </xsl:when>
    <xsl:when test=" $myStyle = 'common' ">
      <xsl:call-template name="do-common-block">
        <xsl:with-param name="myId" select="$myId" />
        <xsl:with-param name="myTitle" select="$myTitle" />
        <xsl:with-param name="myIssueList" select="$myIssueList" />
        <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
        <xsl:with-param name="myGeneralArticles" select="$myGeneralArticles" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="do-common-block">
        <xsl:with-param name="myId" select="$myId" />
        <xsl:with-param name="myTitle" select="$myTitle" />
        <xsl:with-param name="myIssueList" select="$myIssueList" />
        <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
        <xsl:with-param name="myGeneralArticles" select="$myGeneralArticles" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- #####  templates  -  common components  ############################## -->

<xsl:variable name="disp-val__client-report-title">
	<xsl:value-of select="concat(/CLIPSHEET/@CLIENT ,' ' ,/CLIPSHEET/@NAME)" />
</xsl:variable>

<xsl:variable name="disp-val__client-name">
	<xsl:value-of select="string(/CLIPSHEET/@CLIENT)" />
</xsl:variable>

<xsl:variable name="disp-val__report-name">
	<xsl:value-of select="string(/CLIPSHEET/@NAME)" />
</xsl:variable>

<xsl:variable name="disp-val__section-title_top-stories">
	<xsl:value-of select="string('Top Stories')" />
</xsl:variable>

<xsl:variable name="disp-val__issue-title_general-articles">
	<xsl:value-of select="concat('Also in ' ,$disp-val__issue-title_swap)" />
</xsl:variable>
<xsl:variable name="disp-val__issue-title_swap">
	<xsl:value-of select="string('SECTION_NAME')" />
</xsl:variable>

<xsl:variable name="disp-val__no-relevant-content">
	<xsl:value-of disable-output-escaping="yes" select="string('No relevant news')" />
</xsl:variable>


<xsl:variable name="disp-val__nbsp">
  <xsl:value-of select="string('&#xA0;')" />
</xsl:variable>

<xsl:variable name="disp-val__nbhyphen">
  <xsl:value-of select="string('&#x2011;')" />
</xsl:variable>

<xsl:variable name="disp-val__link-out-icon">
  <xsl:value-of select="string('&#x2192;')" />
</xsl:variable>

<xsl:variable name="disp-val__link-down-icon">
  <xsl:value-of select="string('&#x2193;')" />
</xsl:variable>

<xsl:variable name="disp-val__media-play-icon">
  <xsl:value-of select="string('&#x25b6;')" />
</xsl:variable>

<xsl:variable name="disp-val__right-chevron">
  <xsl:value-of select="string('&#x203a;')" />
</xsl:variable>

<xsl:variable name="disp-val__menu-separator">
  <xsl:value-of select="string('&#xA0;')" />
  <xsl:value-of select="string('&#x7C;')" />
  <xsl:value-of select="string('&#x20;')" />
</xsl:variable>

<xsl:variable name="style_common__article-container-padding-left">
  <xsl:value-of select="concat( 'padding-left:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_common__block-head-td-border">
  <xsl:value-of select="concat( 'border-top:'  ,'10px solid ' ,$attr-val__bg-color_frame  ,'; ' )" />
</xsl:variable>


<xsl:attribute-set name="page-body__common-frame-td">
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_frame" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>

<xsl:attribute-set name="mobile-spacer-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,'6px'  ,'; ' )" />
    <xsl:value-of select="concat( 'line-height:'  ,'6px'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="width" select="string('30')" />
  <xsl:attribute name="class" select="string('mobile-spacer')" />
</xsl:attribute-set>

<xsl:attribute-set name="common-table">
  <xsl:attribute name="cellpadding" select="string('0')" />
  <xsl:attribute name="cellspacing" select="string('0')" />
  <xsl:attribute name="border" select="string('0')" />
  <xsl:attribute name="width" select="string('100%')" />
</xsl:attribute-set>

<xsl:attribute-set name="common-td">
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="common__spacer-row">
  <xsl:param name="myLbn" select="string('common__spacer-row')" />
  <xsl:param name="trackingLocation" select="string('')" />
  <xsl:param name="myHeight" select="string('20px')" />
  <xsl:param name="myContent" select="$disp-val__nbsp" />
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_common__spacer-row-td" />
        <xsl:value-of select="concat( 'font-size:'  ,$myHeight  ,'; ' )" />
        <xsl:value-of select="concat( 'line-height:'  ,$myHeight  ,'; ' )" />
      </xsl:attribute>
      <xsl:value-of select="$disp-val__nbsp" />
      <xsl:if test="string-length($trackingLocation) &gt; 0">
        <xsl:call-template name="do-GApixel">
          <xsl:with-param name="UAID" select="$opt__google-analytics-UAID" />
          <xsl:with-param name="locationName" select="$trackingLocation" />
        </xsl:call-template>
      </xsl:if>
      <xsl:value-of select="$myContent" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="style_common__spacer-row-td">
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'0px'  ,'; ' )" />
</xsl:variable>


<xsl:template name="common__section-head">
  <xsl:param name="myLbn" select="string('common__section-head')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myBlock" select="string('common')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myStyleTd" select="$style_common__section-head-td" />
  <xsl:param name="myStyleTdColor" select="$style_common__section-head-td-color" />
  <xsl:param name="myStyleTdBreakline" select="$style_common__section-head-td_breakline" />
  <xsl:param name="doTemplate" select="true()" />
  <tr>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$myStyleTd" />
        <xsl:value-of select="$myStyleTdColor" />
        <xsl:if test="$bool__do-section-head-breakline">
          <xsl:value-of select="$myStyleTdBreakline" />
        </xsl:if>
      </xsl:attribute>
      <a lbname="{$myLbn}">
        <xsl:attribute name="id" select="concat($myBlock ,$myLayer ,$myId)" />
        <xsl:attribute name="name" select="concat($myBlock ,$myLayer ,$myId)" />
      </a>
      <xsl:value-of select="$myTitle" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  <xsl:if test="$bool__do-section-head-breakline">
    <xsl:call-template name="common__spacer-row">
      <xsl:with-param name="myHeight" select="string('10px')" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_common__section-head-td">
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'24px'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'25px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_common__section-head-td-color">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_common__section-head-td_breakline">
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,'2px solid '  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>


<xsl:template match="ARTICLE" mode="bolt">
	<xsl:param name="myLbn" select="string('ARTICLE___bolt')" />
  <xsl:variable name="bPD" select="xs:boolean(string-length(@PUBLISHDATE))" />
  <xsl:variable name="bAU" select="xs:boolean(string-length(AUTHOR[1]))" />
  <xsl:variable name="bPB" select="xs:boolean(string-length(PUBLICATION))" />
	<span xsl:use-attribute-sets="common__article-bolt-span" lbname="{$myLbn}">
    <xsl:value-of disable-output-escaping="yes" select="PUBLICATION" />
    <xsl:if test="$bPB and $bPD">
      <xsl:value-of select="$disp-val__bolt-separator" />
    </xsl:if>
    <xsl:apply-templates select="@PUBLISHDATE" />
    <xsl:if test="$bPD and $bAU">
      <xsl:value-of select="$disp-val__bolt-separator" />
    </xsl:if>
    <xsl:apply-templates select="AUTHOR" />
	</span>
</xsl:template>

<xsl:variable name="disp-val__bolt-separator">
  <xsl:value-of select="$disp-val__menu-separator" />
</xsl:variable>

<xsl:attribute-set name="common__article-bolt-span">
</xsl:attribute-set>


<xsl:template match="@PUBLISHDATE">
  <xsl:param name="myLbn" select="string('PUBLISHDATE')" />
  <xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
  <xsl:value-of disable-output-escaping="yes" select="format-date(xs:date($strDate), $boltDateFormat,'en',(),())" />
</xsl:template>

<xsl:variable name="boltDateFormat" select="string('[M01]/[D01]/[Y0001]')"/>


<xsl:template match="AUTHOR">
  <xsl:param name="myLbn" select="string('AUTHOR')" />
  <xsl:choose>
    <xsl:when test="position()=1">
      <xsl:value-of select="string('By ')" />
    </xsl:when>
    <xsl:when test="position()!=1 and position()!=last()">
      <xsl:value-of select="string(', ')" />
    </xsl:when>
    <xsl:when test="position()!=1 and position() =last()">
      <xsl:value-of select="string(' and ')" />
    </xsl:when>
    <xsl:otherwise />
  </xsl:choose>
  <xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>


<xsl:template match="SHARING" mode="sharecount-sum">
	<xsl:param name="myLbn" select="string('SHARING___sharecount-sum')" />
  <xsl:param name="doTemplate" select="$bool__do-sharecount-sum" />
  <xsl:param name="myDisplayText" select="$disp-val__sharecount-sum_text" />
  <xsl:param name="myDisplayText_swap" select="$disp-val__sharecount-sum_swap" />
  <xsl:param name="myDisplayText_oneShare" select="$disp-val__sharecount-sum_text-one-share" />
  <xsl:param name="displayAbbrevNum" select="false()" />
  <xsl:param name="valueSumSharecount" select="sum(PLATFORM/@SHARECOUNT)" />
	<xsl:param name="displaySumSharecount">
		<xsl:choose>
			<xsl:when test="$displayAbbrevNum and $valueSumSharecount &gt; 999000000">
				<xsl:value-of select="format-number($valueSumSharecount div 1000000000, '#,##0.0')" />
				<xsl:value-of select="string('B')" />
			</xsl:when>
			<xsl:when test="$displayAbbrevNum and $valueSumSharecount &gt; 999000">
				<xsl:value-of select="format-number($valueSumSharecount div 1000000, '#,##0.0')" />
				<xsl:value-of select="string('M')" />
			</xsl:when>
			<xsl:when test="$displayAbbrevNum and $valueSumSharecount &gt; 999">
				<xsl:value-of select="format-number($valueSumSharecount div 1000, '#,##0')" />
				<xsl:value-of select="string('K')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number($valueSumSharecount, '#,##0')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
  <xsl:choose>
    <xsl:when test="$doTemplate and $valueSumSharecount > 1">
      <xsl:value-of select="$disp-val__bolt-separator" />
    	<span xsl:use-attribute-sets="common__sharecount-sum-span" lbname="{$myLbn}">
        <xsl:value-of select="replace($myDisplayText ,$myDisplayText_swap ,$displaySumSharecount)" />
    	</span>
    </xsl:when>
    <xsl:when test="$doTemplate and $valueSumSharecount = 1">
      <xsl:value-of select="$disp-val__bolt-separator" />
    	<span xsl:use-attribute-sets="common__sharecount-sum-span" lbname="{$myLbn}">
        <xsl:value-of select="$myDisplayText_oneShare" />
    	</span>
    </xsl:when>
    <xsl:otherwise />
  </xsl:choose>
</xsl:template>

<xsl:variable name="disp-val__sharecount-sum_text-one-share">
	<xsl:value-of select="concat('Shared' ,$disp-val__nbsp ,'once')" />
</xsl:variable>
<xsl:variable name="disp-val__sharecount-sum_text">
	<xsl:value-of select="concat('Shared' ,$disp-val__nbsp ,$disp-val__sharecount-sum_swap ,$disp-val__nbsp ,'times')" />
</xsl:variable>
<xsl:variable name="disp-val__sharecount-sum_swap">
	<xsl:value-of select="string('SHARECOUNT_VALUE')" />
</xsl:variable>

<xsl:attribute-set name="common__sharecount-sum-span">
</xsl:attribute-set>


<xsl:template match="PUBLICATION" mode="authreq-msg">
	<xsl:param name="myLbn" select="string('PUBLICATION___authreq-msg')" />
  <xsl:param name="myContent" select="$disp-val__publication-authreq-msg" />
  <xsl:param name="doTemplate" select="$bool__do-publication-authreq-msg" />
  <xsl:choose>
    <xsl:when test="$doTemplate and @AUTHREQ=1 and ../SRCURL/@REDIRECT=1">
      <xsl:value-of select="$disp-val__bolt-separator" />
      <span xsl:use-attribute-sets="common__publication-authreq-msg-span" lbname="{$myLbn}">
        <xsl:value-of disable-output-escaping="yes" select="$myContent" />
      </span>
    </xsl:when>
    <xsl:when test="$doTemplate and @AUTHREQ=1 and ../SRCURL=../AGTURL">
    </xsl:when>
    <xsl:otherwise />
  </xsl:choose>
</xsl:template>

<xsl:variable name="bool__do-publication-authreq-msg" select="false()" />

<xsl:variable name="disp-val__publication-authreq-msg">
	<xsl:value-of disable-output-escaping="yes" select="string('Subscription may be required')" />
</xsl:variable>

<xsl:variable name="style_common__publication-authreq-msg-span">
  <xsl:value-of select="concat( 'font-style:'  ,'italic'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="common__publication-authreq-msg-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__publication-authreq-msg-span" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="do-tags">
	<xsl:param name="myLbn" select="string('do-tags')" />
  <xsl:param name="AID" />
  <xsl:variable name="printTag" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$AID]" />
  <xsl:for-each select="$printTag">
    <span lbname="{$myLbn}">
      <xsl:attribute name="class">
        <xsl:value-of select="@NAME" />
        <xsl:value-of select="string(' tag')" />
      </xsl:attribute>
      <xsl:value-of disable-output-escaping="yes" select="@NAME" />
      <xsl:if test="position()!=last() and count($printTag)!=1">
        <xsl:value-of select="$disp-val__tags-separator" />
      </xsl:if>
    </span>
  </xsl:for-each>
</xsl:template>

<xsl:variable name="disp-val__tags-separator">
  <xsl:value-of select="string(', ')" />
</xsl:variable>


<xsl:template name="make-strAID">
  <xsl:param name="ids" />
  <xsl:choose>
    <xsl:when test="count($ids) &gt; 0">
      <xsl:for-each select="$ids">
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


<xsl:template name="do-GApixel">
  <xsl:param name="UAID" select="string('UA-1191451-29')" />
  <xsl:param name="gaCID" select="string('016458c3-fd2b-4008-b067-644bc3595d08')" />
  <xsl:param name="locationName" select="string('')" />
  <xsl:variable name="gaEA" select="encode-for-uri( concat($formatName ,'_' ,$locationName) )" />
  <xsl:variable name="gaEC" select="encode-for-uri($disp-val__client-name)" />
  <xsl:variable name="gaEL" select="format-date(xs:date(substring($xml__clip-date,1,10)), $opt__google-analytics-date-arg-format,'en',(),())" />
  <xsl:variable name="gaCS" select="encode-for-uri($disp-val__client-name)" />
  <img src="https://www.google-analytics.com/collect?v=1&amp;tid={$UAID}&amp;cid={$gaCID}&amp;t=event&amp;ec={$gaEC}&amp;ea={$gaEA}&amp;el={$gaEL}&amp;ni=1&amp;sc=start" width="0" height="0" />
</xsl:template>


<!-- #####  templates  -  default block  ################################## -->

<xsl:template name="do-common-block">
  <xsl:param name="myLbn" select="string('do-common-block')" />
  <xsl:param name="myStyle" select="string('common')" />
  <xsl:param name="doTemplate" select="$bool__do-common-block" />

  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myIssueList" />
  <xsl:param name="myIssueArticles" />
  <xsl:param name="myGeneralArticles" />

  <xsl:if test="$doTemplate">
  </xsl:if>
</xsl:template>


<!-- #####  templates  -  executive-summary block  ######################## -->

<xsl:template name="do-executive-summary">
  <xsl:param name="myLbn" select="string('do-executive-summary')" />
  <xsl:param name="myStyle" select="string('execsum')" />
  <xsl:param name="myTitle" select="/CLIPSHEET/SECTION/NAME[../ID=$opt__exec-sect-id]" />
  <xsl:param name="doTitle" select="false()"/>
  <xsl:param name="doTemplate" select="$bool__do-executive-summary"/>
  <xsl:param name="myContent" select="$xml__allowed-articles[number(SECTION/@ID)=number($opt__exec-sect-id)]" />
  <xsl:if test="$doTemplate and not(number($opt__exec-sect-id) = 1) and $myContent">
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="executive-summary__container-td" lbname="{$myLbn}">
        <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
          <xsl:if test="$doTitle">
            <tr>
              <td xsl:use-attribute-sets="executive-summary__section-title-td" lbname="{$myLbn}">
                <xsl:value-of disable-output-escaping="yes" select="$myTitle" />
              </td>
            </tr>
          </xsl:if>
          <xsl:apply-templates select="$myContent" mode="executive-summary">
            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
          </xsl:apply-templates>
        </table>
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
    <xsl:call-template name="common__spacer-row">
      <xsl:with-param name="trackingLocation" select="$myStyle" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:variable name="bool__do-executive-summary" select="true()" />

<xsl:variable name="style_executive-summary__container-td">
  <xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="$style_common__article-container-padding-left" />
  <xsl:value-of select="concat( 'border-top:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'border-right:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'border-left:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_executive-summary__section-title-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="executive-summary__container-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_executive-summary__container-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="executive-summary__section-title-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_executive-summary__section-title-td" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="executive-summary">
  <xsl:param name="myLbn" select="string('ARTICLE___executive-summary')" />
  <xsl:param name="doHeadline" select="true()"/>
  <xsl:if test="$doHeadline">
    <tr>
      <td xsl:use-attribute-sets="executive-summary__headline-td" lbname="{$myLbn}">
        <xsl:value-of disable-output-escaping="yes" select="HEADLINE" />
      </td>
    </tr>
  </xsl:if>
  <tr>
    <td xsl:use-attribute-sets="executive-summary__abstract-td" lbname="{$myLbn}">
      <xsl:value-of disable-output-escaping="yes" select="ABSTRACT" />
    </td>
  </tr>
  <xsl:if test="position()!=last()">
    <tr>
      <td style="line-height:5px;" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_executive-summary__headline-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_executive-summary__abstract-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="executive-summary__headline-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_executive-summary__headline-td" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="executive-summary__abstract-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_executive-summary__abstract-td" />
  </xsl:attribute>
</xsl:attribute-set>


<!-- #####  templates  -  toc block  ###################################### -->

<xsl:template name="do-toc-block">
  <xsl:param name="myLbn" select="string('do-toc-block')" />
  <xsl:param name="myStyle" select="string('toc')" />
  <xsl:param name="doTemplate" select="$bool__do-toc-block" />
  <xsl:param name="doHead" select="$bool_toc__do-block-head" />
  <xsl:param name="doNav" select="$bool_toc__do-block-nav-list" />
  <xsl:if test="$doTemplate and ($xml__top-stories or $xml__edition-sections-list)">
    <xsl:call-template name="toc__block-head">
      <xsl:with-param name="doTemplate" select="$doHead" />
    </xsl:call-template>
    <xsl:call-template name="toc__nav-list">
      <xsl:with-param name="doTemplate" select="$doNav" />
      <xsl:with-param name="myStyle" select="$myStyle" />
    </xsl:call-template>
    <xsl:if test="$bool__do-top-stories-as-section and $xml__top-stories">
      <xsl:call-template name="do-format-selector">
        <xsl:with-param name="myStyle" select="$myStyle" />
        <xsl:with-param name="myId" select="string('TopStories')" />
        <xsl:with-param name="myTitle" select="$disp-val__section-title_top-stories" />
        <xsl:with-param name="myIssueList" select="$blankNode" />
        <xsl:with-param name="myIssueArticles" select="$blankNode" />
        <xsl:with-param name="myGeneralArticles" select="$xml__top-stories" />
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="$xml__edition-sections-list" mode="process">
      <xsl:with-param name="myStyle" select="$myStyle" />
      <xsl:sort select="ORDINAL" data-type="number" order="ascending" />
      <xsl:sort select="NAME" data-type="text" order="ascending" />
      <xsl:sort select="ID" data-type="number" order="descending" />
    </xsl:apply-templates>
    <xsl:call-template name="common__spacer-row">
      <xsl:with-param name="trackingLocation" select="$myStyle" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:variable name="bool_toc__do-block-head" select="false()" />
<xsl:variable name="bool_toc__do-block-nav-list" select="true()" />


<xsl:template name="toc__block-head">
  <xsl:param name="myLbn" select="string('toc__block-head')" />
  <xsl:param name="myTitle" select="$disp-val_toc__block-title" />
  <xsl:param name="doTemplate" select="false()" />
  <xsl:if test="$doTemplate">
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td toc__block-head-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="toc__block-head-td_title" lbname="{$myLbn}">
        <xsl:value-of select="$myTitle" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td toc__block-head-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_toc__block-title">
  <xsl:value-of select="string('Headlines')" />
</xsl:variable>

<xsl:variable name="style_toc__block-head-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__block-head-td_title">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__block-head-td-border" />
    <xsl:value-of select="$style_toc__block-head-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="toc__block-head-td_mobile-spacer">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__block-head-td-border" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="toc__nav-list">
  <xsl:param name="myLbn" select="string('toc__nav-list')" />
  <xsl:param name="myStyle" select="string('toc')" />
  <xsl:param name="myContent" select="$xml__edition-sections-list" />
  <xsl:param name="doTemplate" select="false()" />
  <xsl:if test="$doTemplate and $myContent and count($xml__enabled-sections-list) &gt; 1">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="toc__nav-list-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
        <xsl:apply-templates select="$myContent" mode="toc__nav-list">
          <xsl:with-param name="myStyle" select="$myStyle" />
        </xsl:apply-templates>
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_toc__nav-list-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'18px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__nav-list-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_reference  ,'; ' )" />
    <xsl:value-of select="$style_toc__nav-list-td" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_reference" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>


<xsl:template match="SECTION" mode="toc__nav-list">
	<xsl:param name="myLbn" select="string('SECTION___toc__nav-list')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myStyle" select="string('toc')" />
  <a xsl:use-attribute-sets="toc__nav-list-link" lbname="{$myLbn}">
    <xsl:attribute name="href" select="concat('#' ,$myStyle ,$myLayer ,ID)" />
    <xsl:value-of disable-output-escaping="yes" select="replace( NAME ,' ' ,$disp-val__nbsp )" />
  </a>
  <xsl:if test="position() != last()">
		<xsl:value-of select="$disp-val_toc__nav-list-separator" />
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_toc__nav-list-separator">
  <xsl:value-of select="$disp-val__menu-separator" />
</xsl:variable>

<xsl:variable name="style_toc__nav-list-link">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__nav-list-link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__nav-list-link" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="do-section-as-toc">
  <xsl:param name="myLbn" select="string('do-section-as-toc')" />
  <xsl:param name="myStyle" select="string('toc')" />
  <xsl:param name="myGatewayBlockStyle" select="string('')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myIssueList" />
  <xsl:param name="myIssueArticles" />
  <xsl:param name="myGeneralArticles" />
  <xsl:call-template name="toc__section-head">
    <xsl:with-param name="myStyle" select="$myStyle" />
    <xsl:with-param name="myId" select="$myId" />
    <xsl:with-param name="myTitle" select="$myTitle" />
    <xsl:with-param name="navReturnToBlock" select="$myGatewayBlockStyle" />
  </xsl:call-template>
  <xsl:if test="count($myIssueArticles) &lt; 1 and count($myGeneralArticles) &lt; 1">
    <xsl:call-template name="toc__supplement-content">
      <xsl:with-param name="myBodyText" select="$disp-val__no-relevant-content" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates select="$myIssueList" mode="toc">
    <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
  </xsl:apply-templates>
  <xsl:if test="$myGeneralArticles and $myIssueArticles">
    <xsl:call-template name="toc__issue-head">
      <xsl:with-param name="myTitle" select="replace( $disp-val__issue-title_general-articles ,$disp-val__issue-title_swap ,$myTitle )" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates select="$myGeneralArticles" mode="toc">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
    <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
    <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
</xsl:template>


<xsl:template name="toc__section-head">
  <xsl:param name="myLbn" select="string('toc__section-head')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myStyle" select="string('toc')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="navReturnToBlock" />
  <xsl:param name="navReturnToSection" select="concat('#' ,$navReturnToBlock ,$myLayer ,$myId)" />
  <xsl:param name="doTemplate" select="$bool_toc__do-section-head" />
  <xsl:if test="$doTemplate and count($xml__enabled-sections-list) &gt; 1">
    <xsl:call-template name="common__section-head">
      <xsl:with-param name="myLayer" select="$myLayer" />
      <xsl:with-param name="myBlock" select="$myStyle" />
      <xsl:with-param name="myId" select="$myId" />
      <xsl:with-param name="myTitle" select="$myTitle" />
      <xsl:with-param name="myStyleTdColor" select="$style_toc__section-head-td-color" />
      <xsl:with-param name="myStyleTdBreakline" select="$style_toc__section-head-td_breakline" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:variable name="bool_toc__do-section-head" select="true()" />

<xsl:variable name="style_toc__section-head-td-color">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_toc__section-head-td_breakline">
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,'2px solid '  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>


<xsl:template match="ISSUE" mode="toc">
	<xsl:param name="myLbn" select="string('ISSUE___toc')" />
  <xsl:param name="myIssueArticles" />
  <xsl:variable name="issueId" select="@ID" />
  <xsl:call-template name="toc__issue-head">
    <xsl:with-param name="myId" select="$issueId" />
    <xsl:with-param name="myTitle" select="@NAME" />
  </xsl:call-template>
  <xsl:apply-templates select="$myIssueArticles[@ID=$xml__edition-issues-list[@ID=$issueId]/ARTICLE/@ID]" mode="toc">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
    <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
    <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
</xsl:template>

<xsl:variable name="style_toc__issue-content-td-padding">
  <xsl:value-of select="$style_common__article-container-padding-left" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__issue-content-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__issue-content-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="toc__issue-head">
  <xsl:param name="myLbn" select="string('toc__issue-head')" />
  <xsl:param name="myLayer" select="string('Issue')" />
  <xsl:param name="myStyle" select="string('toc')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <tr>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="toc__issue-head-td">
      <a lbname="{$myLbn}">
        <xsl:attribute name="id" select="concat($myStyle ,$myLayer ,$myId)" />
        <xsl:attribute name="name" select="concat($myStyle ,$myLayer ,$myId)" />
      </a>
      <xsl:value-of disable-output-escaping="yes" select="$myTitle" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="style_toc__issue-head-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_toc__issue-head-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'1px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'1px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__issue-head-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__issue-head-td-font" />
    <xsl:value-of select="$style_toc__issue-head-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="toc__supplement-content">
  <xsl:param name="myLbn" select="string('toc__supplement-content')" />
  <xsl:param name="myTitle" />
  <xsl:param name="myBodyText" />
  <xsl:if test="$myTitle or $myBodyText">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="toc__article-clip-td" lbname="{$myLbn}">
        <xsl:value-of select="$myBodyText" />
        <xsl:apply-templates select="HEADLINE" mode="toc" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>


<!-- #### templates ### toc__article #### -->

<xsl:template match="ARTICLE" mode="toc">
  <xsl:param name="myLbn" select="string('ARTICLE___toc')" />
  <xsl:param name="myId" select="@ID" />
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="toc__article-clip-td" lbname="{$myLbn}">
      <xsl:apply-templates select="PUBLICATION" mode="toc" />
      <xsl:apply-templates select="HEADLINE" mode="toc" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  <!--
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="toc__article-clip-container-td" lbname="{$myLbn}">
        <xsl:attribute name="style">
          <xsl:value-of select="$style_toc__article-clip-container-td-padding" />
          <xsl:value-of select="$style_toc__article-clip-container-td-padding_clip-foot" />
        </xsl:attribute>
        <xsl:apply-templates select="." mode="summaries__clip-foot" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  -->
</xsl:template>

<xsl:variable name="style_toc__article-clip-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_toc__article-clip-container-td-padding_clip-foot">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__article-clip-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__article-clip-td" />
    <xsl:value-of select="$style_common__article-container-padding-left" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="toc__anchor">
  <xsl:param name="myLbn" select="string('ARTICLE___toc__anchor')" />
  <a>
    <xsl:attribute name="name" select="concat('top' ,@ID)" />
  </a>
</xsl:template>


<xsl:template match="HEADLINE" mode="toc">
  <xsl:param name="myLbn" select="string('HEADLINE___toc')" />
  <xsl:variable name="href">
    <xsl:apply-templates select=".." mode="build-href" />
  </xsl:variable>
  <xsl:variable name="name">
    <xsl:value-of select="concat('top' ,../@ID)" />
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="string-length(../SRCURL) &gt; 4 or string-length(../AGTURL) &gt; 4">
      <a xsl:use-attribute-sets="toc__headline-link" lbname="{$myLbn}">
        <xsl:attribute name="href" select="$href" />
        <xsl:value-of disable-output-escaping="yes" select="." />
      </a>
      <a xsl:use-attribute-sets="toc__headline-link_icon" lbname="{$myLbn}">
        <xsl:attribute name="href" select="$href" />
        <xsl:choose>
          <xsl:when test="$doFT and not (../SRCURL/@REDIRECT=1)">
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__link-down-icon" />
          </xsl:when>
          <xsl:when test="../@MEDIAID > 1">
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__media-play-icon" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__link-out-icon" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of disable-output-escaping="yes" select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="style_toc__headline-link">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_toc__headline-link_icon">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'none'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__headline-link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__headline-link" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="toc__headline-link_icon">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__headline-link_icon" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="PUBLICATION" mode="toc">
  <xsl:param name="myLbn" select="string('PUBLICATION___toc')" />
  <xsl:if test="string-length(.) &gt; 0">
    <span xsl:use-attribute-sets="toc__publication-span" lbname="{$myLbn}">
      <xsl:value-of disable-output-escaping="yes" select="." />
      <xsl:value-of select="string(': ')" />
    </span>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_toc__publication-span">
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="toc__publication-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_toc__publication-span" />
  </xsl:attribute>
</xsl:attribute-set>


<!-- #####  templates  -  summaries block  ################################ -->

<xsl:template name="do-summaries-block">
  <xsl:param name="myLbn" select="string('do-summaries-block')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="doTemplate" select="$bool__do-summaries-block" />
  <xsl:param name="doHead" select="$bool_summaries__do-block-head" />
  <xsl:param name="doNav" select="$bool_summaries__do-block-nav-list" />
  <xsl:if test="$doTemplate and ($xml__top-stories or $xml__edition-sections-list)">
    <xsl:call-template name="summaries__block-head">
      <xsl:with-param name="doTemplate" select="$doHead" />
    </xsl:call-template>
    <xsl:call-template name="summaries__nav-list">
      <xsl:with-param name="doTemplate" select="$doNav" />
      <xsl:with-param name="myStyle" select="$myStyle" />
    </xsl:call-template>
    <xsl:if test="$bool__do-top-stories-as-section and $xml__top-stories">
      <xsl:call-template name="do-format-selector">
        <xsl:with-param name="myStyle" select="$myStyle" />
        <xsl:with-param name="myId" select="string('TopStories')" />
        <xsl:with-param name="myTitle" select="$disp-val__section-title_top-stories" />
        <xsl:with-param name="myIssueList" select="$blankNode" />
        <xsl:with-param name="myIssueArticles" select="$blankNode" />
        <xsl:with-param name="myGeneralArticles" select="$xml__top-stories" />
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="$xml__edition-sections-list" mode="process">
      <xsl:with-param name="myStyle" select="$myStyle" />
      <xsl:sort select="ORDINAL" data-type="number" order="ascending" />
      <xsl:sort select="NAME" data-type="text" order="ascending" />
      <xsl:sort select="ID" data-type="number" order="descending" />
    </xsl:apply-templates>
    <xsl:call-template name="common__spacer-row">
      <xsl:with-param name="trackingLocation" select="$myStyle" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:variable name="bool_summaries__do-block-head" select="false()" />
<xsl:variable name="bool_summaries__do-block-nav-list" select="true()" />


<xsl:template name="summaries__block-head">
  <xsl:param name="myLbn" select="string('summaries__block-head')" />
  <xsl:param name="myTitle" select="$disp-val_summaries__block-title" />
  <xsl:param name="doTemplate" select="false()" />
  <xsl:if test="$doTemplate">
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td summaries__block-head-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="summaries__block-head-td_title" lbname="{$myLbn}">
        <xsl:value-of select="$myTitle" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td summaries__block-head-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_summaries__block-title">
  <xsl:value-of select="string('Article Summaries')" />
</xsl:variable>

<xsl:variable name="style_summaries__block-head-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__block-head-td_title">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__block-head-td-border" />
    <xsl:value-of select="$style_summaries__block-head-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="summaries__block-head-td_mobile-spacer">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__block-head-td-border" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="summaries__nav-list">
  <xsl:param name="myLbn" select="string('summaries__nav-list')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="myContent" select="$xml__edition-sections-list" />
  <xsl:param name="doTemplate" select="false()" />
  <xsl:if test="$doTemplate and $myContent and count($xml__enabled-sections-list) &gt; 1">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="summaries__nav-list-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
        <xsl:apply-templates select="$myContent" mode="summaries__nav-list">
          <xsl:with-param name="myStyle" select="$myStyle" />
        </xsl:apply-templates>
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_summaries__nav-list-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'18px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__nav-list-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_reference  ,'; ' )" />
    <xsl:value-of select="$style_summaries__nav-list-td" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_reference" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>


<xsl:template match="SECTION" mode="summaries__nav-list">
	<xsl:param name="myLbn" select="string('SECTION___summaries__nav-list')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="myContent_0" select="NAME" />
  <xsl:param name="myContent_1" select="replace( $myContent_0 ,' ' ,$disp-val__nbsp )" />
  <xsl:param name="myContent" select="replace( $myContent_1 ,'-' ,$disp-val__nbhyphen )" />
  <a xsl:use-attribute-sets="summaries__nav-list-link" lbname="{$myLbn}">
    <xsl:attribute name="href" select="concat('#' ,$myStyle ,$myLayer ,ID)" />
    <xsl:value-of disable-output-escaping="yes" select="$myContent" />
  </a>
  <xsl:if test="position() != last()">
		<xsl:value-of select="$disp-val_summaries__nav-list-separator" />
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_summaries__nav-list-separator">
  <xsl:value-of select="$disp-val__menu-separator" />
</xsl:variable>

<xsl:variable name="style_summaries__nav-list-link">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__nav-list-link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__nav-list-link" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="do-section-as-summaries">
  <xsl:param name="myLbn" select="string('do-section-as-summaries')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="myGatewayBlockStyle" select="string('')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myIssueList" />
  <xsl:param name="myIssueArticles" />
  <xsl:param name="myGeneralArticles" />
  <xsl:call-template name="summaries__section-head">
    <xsl:with-param name="myStyle" select="$myStyle" />
    <xsl:with-param name="myId" select="$myId" />
    <xsl:with-param name="myTitle" select="$myTitle" />
    <xsl:with-param name="navReturnToBlock" select="$myGatewayBlockStyle" />
  </xsl:call-template>
  <xsl:if test="count($myIssueArticles) &lt; 1 and count($myGeneralArticles) &lt; 1">
    <xsl:call-template name="summaries__supplement-content">
      <xsl:with-param name="myBodyText" select="$disp-val__no-relevant-content" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates select="$myIssueList" mode="summaries">
    <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
  </xsl:apply-templates>
  <xsl:if test="$myGeneralArticles and $myIssueArticles">
    <xsl:call-template name="summaries__issue-head">
      <xsl:with-param name="myTitle" select="replace( $disp-val__issue-title_general-articles ,$disp-val__issue-title_swap ,$myTitle )" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates select="$myGeneralArticles" mode="summaries">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
    <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
    <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
</xsl:template>

<!-- is this used or replaced at all? -->
<xsl:variable name="style_summaries__section-container-td-border">
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
</xsl:variable>


<xsl:template name="do-section-as-summaries_OLD">
  <xsl:param name="myLbn" select="string('do-section-as-summaries_OLD')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="myGatewayBlockStyle" select="string('')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myIssueList" />
  <xsl:param name="myIssueArticles" />
  <xsl:param name="myGeneralArticles" />
  <xsl:call-template name="summaries__section-head">
    <xsl:with-param name="myStyle" select="$myStyle" />
    <xsl:with-param name="myId" select="$myId" />
    <xsl:with-param name="myTitle" select="$myTitle" />
    <xsl:with-param name="navReturnToBlock" select="$myGatewayBlockStyle" />
  </xsl:call-template>
  <xsl:apply-templates select="$myIssueList" mode="summaries">
    <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
  </xsl:apply-templates>
  <xsl:if test="$myGeneralArticles and $myIssueArticles">
    <xsl:call-template name="summaries__issue-head">
      <xsl:with-param name="myTitle" select="replace( $disp-val__issue-title_general-articles ,$disp-val__issue-title_swap ,$myTitle )" />
    </xsl:call-template>
  </xsl:if>

  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="summaries__section-container-td" lbname="{$myLbn}">
      <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
        <tr lbname="{$myLbn}">
          <th lbname="{$myLbn}" />
          <th lbname="{$myLbn}" />
        </tr>
        <xsl:apply-templates select="$myGeneralArticles" mode="summaries_OLD">
          <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
          <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
          <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
          <xsl:sort select="@ID" data-type="number" order="descending" />
        </xsl:apply-templates>
      </table>
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>

</xsl:template>

<xsl:variable name="style_summaries__section-container-td">
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
  <xsl:value-of select="$style_common__article-container-padding-left" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__section-container-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__section-container-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="summaries__section-head">
  <xsl:param name="myLbn" select="string('summaries__section-head')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="navReturnToBlock" />
  <xsl:param name="navReturnToSection" select="concat('#' ,$navReturnToBlock ,$myLayer ,$myId)" />
  <xsl:param name="doTemplate" select="$bool_summaries__do-section-head" />
  <xsl:if test="$doTemplate and count($xml__enabled-sections-list) &gt; 1">
    <xsl:call-template name="common__section-head">
      <xsl:with-param name="myLayer" select="$myLayer" />
      <xsl:with-param name="myBlock" select="$myStyle" />
      <xsl:with-param name="myId" select="$myId" />
      <xsl:with-param name="myTitle" select="$myTitle" />
      <xsl:with-param name="myStyleTdColor" select="$style_summaries__section-head-td-color" />
      <xsl:with-param name="myStyleTdBreakline" select="$style_summaries__section-head-td_breakline" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:variable name="bool_summaries__do-section-head" select="true()" />

<xsl:variable name="style_summaries__section-head-td-color">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__section-head-td_breakline">
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,'2px solid '  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>


<xsl:template match="ISSUE" mode="summaries">
	<xsl:param name="myLbn" select="string('ISSUE___summaries')" />
  <xsl:param name="myIssueArticles" />
  <xsl:variable name="issueId" select="@ID" />
  <xsl:call-template name="summaries__issue-head">
    <xsl:with-param name="myId" select="$issueId" />
    <xsl:with-param name="myTitle" select="@NAME" />
  </xsl:call-template>
  <xsl:apply-templates select="$myIssueArticles[@ID=$xml__edition-issues-list[@ID=$issueId]/ARTICLE/@ID]" mode="summaries">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
    <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
    <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
</xsl:template>

<xsl:variable name="style_summaries__issue-content-td-padding">
  <xsl:value-of select="$style_common__article-container-padding-left" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__issue-content-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__issue-content-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="summaries__issue-head">
  <xsl:param name="myLbn" select="string('summaries__issue-head')" />
  <xsl:param name="myLayer" select="string('Issue')" />
  <xsl:param name="myStyle" select="string('summaries')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <tr>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="summaries__issue-head-td">
      <a lbname="{$myLbn}">
        <xsl:attribute name="id" select="concat($myStyle ,$myLayer ,$myId)" />
        <xsl:attribute name="name" select="concat($myStyle ,$myLayer ,$myId)" />
      </a>
      <xsl:value-of disable-output-escaping="yes" select="$myTitle" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="style_summaries__issue-head-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__issue-head-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'1px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'1px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__issue-head-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__issue-head-td-font" />
    <xsl:value-of select="$style_summaries__issue-head-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="summaries__supplement-content">
  <xsl:param name="myLbn" select="string('summaries__supplement-content')" />
  <xsl:param name="myTitle" />
  <xsl:param name="myBodyText" />
  <xsl:if test="$myTitle">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="summaries__article-clip-container-td summaries__supplement-content-title-td" lbname="{$myLbn}">
        <xsl:value-of select="$myTitle" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
  <xsl:if test="$myBodyText">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="summaries__article-clip-container-td summaries__supplement-content-body-td" lbname="{$myLbn}">
        <xsl:value-of select="$myBodyText" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
  <xsl:if test="$myTitle or $myBodyText">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="summaries__article-clip-container-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:attribute-set name="summaries__supplement-content-title-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__article-clip-container-td-padding" />
    <xsl:value-of select="$style_summaries__headline-td" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="summaries__supplement-content-body-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__article-clip-container-td-padding" />
    <xsl:value-of select="$style_summaries__abstract-td" />
  </xsl:attribute>
</xsl:attribute-set>


<!-- #### templates ### summaries__article #### -->

<xsl:template match="ARTICLE" mode="summaries">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries')" />
  <xsl:param name="myId" select="@ID" />
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="summaries__article-clip-container-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_summaries__article-clip-container-td-padding" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="summaries__clip-card" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="summaries__article-clip-container-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_summaries__article-clip-container-td-padding" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="summaries__clip-body" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="summaries__article-clip-container-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_summaries__article-clip-container-td-padding" />
        <xsl:value-of select="$style_summaries__article-clip-container-td-padding_clip-foot" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="summaries__clip-foot" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="style_summaries__article-clip-container-td-padding">
  <xsl:value-of select="$style_common__article-container-padding-left" />
</xsl:variable>

<xsl:variable name="style_summaries__article-clip-container-td-padding_clip-foot">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__article-clip-container-td">
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="summaries__clip-card">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__clip-card')" />
  <xsl:param name="myId" select="@ID" />
  <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <th lbname="{$myLbn}" />
      <th lbname="{$myLbn}" />
    </tr>
    <tr lbname="{$myLbn}">

      <xsl:if test="string-length(THUMBNAIL) &gt; 0">
        <xsl:apply-templates select="THUMBNAIL" mode="summaries" />
      </xsl:if>

      <td xsl:use-attribute-sets="summaries__clip-card-text-td" lbname="{$myLbn}">
        <xsl:choose>
          <xsl:when test="string-length(THUMBNAIL) &lt; 1">
            <xsl:attribute name="colspan" select="string('2')" />
            <xsl:attribute name="style">
              <xsl:value-of select="$style_summaries__clip-card-td" />
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="style">
              <xsl:value-of select="$style_summaries__clip-card-td" />
              <xsl:value-of select="$style_summaries__clip-card-td_right" />
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
          <tr lbname="{$myLbn}">
            <xsl:apply-templates select="." mode="summaries__tags" />
          </tr>
          <tr lbname="{$myLbn}">
            <xsl:apply-templates select="HEADLINE" mode="summaries" />
          </tr>
          <tr lbname="{$myLbn}">
            <xsl:apply-templates select="." mode="summaries__bolt" />
          </tr>
        </table>
      </td>
    </tr>
    <!--
    <tr>
      <td xsl:use-attribute-sets="summaries__clip-card-border-td" lbname="{$myLbn}">
        <xsl:attribute name="style">
          <xsl:value-of select="$style_summaries__clip-card-border-td" />
        </xsl:attribute>
        <a xsl:use-attribute-sets="summaries__clip-foot-link_icon" lbname="{$myLbn}">
          <xsl:attribute name="href" select="concat('#top' ,@ID)" />
          <xsl:value-of select="string('&#x2191;&#8239;')" />
        </a>
        <a xsl:use-attribute-sets="summaries__clip-foot-link" lbname="{$myLbn}">
          <xsl:attribute name="href" select="concat('#top' ,@ID)" />
          <xsl:value-of select="string('TOP')" />
        </a>
      </td>
    </tr>
    -->
  </table>
</xsl:template>

<xsl:variable name="style_summaries__clip-card-td">
  <!--<xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />-->
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__clip-card-td_right">
  <xsl:value-of select="concat( 'padding-left:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__clip-card-border-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'11px'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-align:'  ,'right'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__clip-card-text-td">
</xsl:attribute-set>

<xsl:attribute-set name="summaries__clip-card-border-td">
  <xsl:attribute name="colspan" select="string('2')" />
  <xsl:attribute name="valign" select="string('top')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="summaries__clip-body">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__clip-body')" />
  <xsl:param name="myId" select="@ID" />
  <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <xsl:apply-templates select="SUBHEAD" mode="summaries" />
    </tr>
    <tr lbname="{$myLbn}">
      <xsl:apply-templates select="ABSTRACT" mode="summaries" />
    </tr>
  </table>
</xsl:template>

<!--
<xsl:variable name="style_summaries__clip-body-text-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'22px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__clip-body-text-td-padding_abstract">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'0px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__clip-body-text-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__clip-body-text-td-font" />
    <xsl:value-of select="$style_summaries__clip-body-text-td-padding_abstract" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>
-->


<xsl:template match="ARTICLE" mode="summaries__clip-foot">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__clip-foot')" />
  <xsl:param name="myId" select="@ID" />
  <xsl:variable name="myChildren" select="$xml__allowed-articles[@PARENT=$myId]" />
  <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">

    <xsl:choose>
      <xsl:when test="not($extRelated) and count($myChildren) &gt; 0">
        <xsl:apply-templates select="." mode="summaries__children-of">
          <xsl:with-param name="myContent" select="$myChildren" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>

    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="summaries__clip-foot-td" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:variable name="style_summaries__clip-foot-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__clip-foot-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__clip-foot-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="summaries_OLD">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries_OLD')" />
  <xsl:param name="myId" select="@ID" />
  <xsl:variable name="myChildren" select="$xml__allowed-articles[@PARENT=$myId]" />
  <tr lbname="{$myLbn}">
    <xsl:if test="string-length(THUMBNAIL) &gt; 0">
      <xsl:apply-templates select="THUMBNAIL" mode="summaries" />
    </xsl:if>
    <td xsl:use-attribute-sets="summaries__article-text-td" lbname="{$myLbn}">
      <xsl:if test="string-length(THUMBNAIL) &lt; 1">
        <xsl:attribute name="colspan" select="string('2')" />
      </xsl:if>
      <xsl:choose>
        <xsl:when test="position()=last()">
          <xsl:attribute name="style" select="$style_summaries__article-text-td-font" />
          <xsl:attribute name="style" select="$style_summaries__article-text-td-padding" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style" select="$style_summaries__article-text-td-font" />
          <xsl:attribute name="style" select="$style_summaries__article-text-td-padding" />
          <xsl:attribute name="style" select="$style_summaries__article-text-td-border" />
        </xsl:otherwise>
      </xsl:choose>
      <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
        <xsl:apply-templates select="." mode="summaries__anchor" />
        <xsl:apply-templates select="." mode="summaries__tags" />
        <xsl:apply-templates select="HEADLINE" mode="summaries" />
        <xsl:apply-templates select="." mode="summaries__bolt" />
        <xsl:apply-templates select="SUBHEAD" mode="summaries" />
        <xsl:apply-templates select="ABSTRACT" mode="summaries" />
        <xsl:choose>
          <xsl:when test="not($extRelated) and count($myChildren) &gt; 0">
            <xsl:apply-templates select="." mode="summaries__children-of">
              <xsl:with-param name="myContent" select="$myChildren" />
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise />
        </xsl:choose>
      </table>
    </td>
  </tr>
</xsl:template>

<xsl:variable name="style_summaries__article-text-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'22px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__article-text-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__article-text-td-border">
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__article-text-td">
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="summaries__bolt">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__bolt')" />
  <td xsl:use-attribute-sets="summaries__bolt-td" lbname="{$myLbn}">
    <xsl:apply-templates select="." mode="bolt" />
    <xsl:apply-templates select="SHARING" mode="sharecount-sum" />
    <xsl:apply-templates select="PUBLICATION" mode="authreq-msg" />
  </td>
</xsl:template>

<xsl:variable name="style_summaries__bolt-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_bolt  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__bolt-td">
  <xsl:attribute name="style">
    <xsl:attribute name="style" select="$style_summaries__bolt-td" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="summaries__anchor">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__anchor')" />
  <a>
    <xsl:attribute name="name" select="concat('top' ,@ID)" />
  </a>
</xsl:template>


<xsl:template match="ARTICLE" mode="summaries__tags">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__tags')" />
  <td xsl:use-attribute-sets="summaries__tags-td">
    <xsl:call-template name="do-tags">
      <xsl:with-param name="AID" select="@ID" />
    </xsl:call-template>
  </td>
</xsl:template>

<xsl:variable name="style_summaries__tags-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'11px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'0px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__tags-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__tags-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="HEADLINE" mode="summaries">
  <xsl:param name="myLbn" select="string('HEADLINE___summaries')" />
  <xsl:variable name="href">
    <xsl:apply-templates select=".." mode="build-href" />
  </xsl:variable>
  <td xsl:use-attribute-sets="summaries__headline-td" lbname="{$myLbn}">
    <xsl:apply-templates select=".." mode="summaries__anchor" />
    <a xsl:use-attribute-sets="summaries__headline-link" lbname="{$myLbn}">
      <xsl:attribute name="href" select="$href" />
      <xsl:value-of disable-output-escaping="yes" select="." />
    </a>
    <a xsl:use-attribute-sets="summaries__headline-link_icon" lbname="{$myLbn}">
      <xsl:attribute name="href" select="$href" />
      <xsl:choose>
        <xsl:when test="$doFT and not (../SRCURL/@REDIRECT=1)">
          <xsl:value-of select="$disp-val__nbsp" />
          <xsl:value-of select="$disp-val__link-down-icon" />
        </xsl:when>
        <xsl:when test="../@MEDIAID > 1">
          <xsl:value-of select="$disp-val__nbsp" />
          <xsl:value-of select="$disp-val__media-play-icon" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$disp-val__nbsp" />
          <xsl:value-of select="$disp-val__link-out-icon" />
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </td>
</xsl:template>

<xsl:variable name="style_summaries__headline-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'17px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'24px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__headline-link">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__headline-link_icon">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'none'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__headline-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__headline-td" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="summaries__headline-link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__headline-link" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="summaries__headline-link_icon">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__headline-link_icon" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="SUBHEAD" mode="summaries">
  <xsl:param name="myLbn" select="string('SUBHEAD___summaries')" />
  <td xsl:use-attribute-sets="summaries__subhead-td" lbname="{$myLbn}">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </td>
</xsl:template>

<xsl:variable name="style_summaries__subhead-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__subhead-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__subhead-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ABSTRACT" mode="summaries">
  <xsl:param name="myLbn" select="string('ABSTRACT___summaries')" />
  <td xsl:use-attribute-sets="summaries__abstract-td" lbname="{$myLbn}">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </td>
</xsl:template>

<xsl:variable name="style_summaries__abstract-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__abstract-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__abstract-td" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="THUMBNAIL" mode="summaries">
  <xsl:param name="myLbn" select="string('THUMBNAIL___summaries')" />
  <td xsl:use-attribute-sets="summaries__article-thumbnail-td" lbname="{$myLbn}">
    <img src="{.}" xsl:use-attribute-sets="summaries__article-thumbnail-img" lbname="{$myLbn}" />
  </td>
</xsl:template>

<xsl:variable name="style_summaries__article-thumbnail-td">
  <xsl:value-of select="$style_summaries__clip-card-td" />
  <xsl:value-of select="concat( 'padding-right:'  ,'10px'  ,'; ' )" />
  <!--<xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />-->
  <!--<xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />-->
</xsl:variable>

<xsl:attribute-set name="summaries__article-thumbnail-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__article-thumbnail-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="summaries__article-thumbnail-img">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'display:'  ,'block'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="alt" select="string('')" />
  <xsl:attribute name="height" select="string('100')" />
  <xsl:attribute name="width" select="string('100')" />
</xsl:attribute-set>


<xsl:template match="SHARING" mode="summaries__sharecount-sum">
	<xsl:param name="myLbn" select="string('SHARING___summaries__sharecount-sum')" />
  <xsl:param name="doTemplate" select="$bool_summaries__do-sharecount-sum" />
  <xsl:param name="displayAbbrevNum" select="false()" />
  <xsl:param name="valueSumSharecount" select="sum(PLATFORM/@SHARECOUNT)" />
	<xsl:param name="displaySumSharecount">
		<xsl:choose>
			<xsl:when test="$displayAbbrevNum and $valueSumSharecount &gt; 999000000">
				<xsl:value-of select="format-number($valueSumSharecount div 1000000000, '#,##0.0')" />
				<xsl:value-of select="string('B')" />
			</xsl:when>
			<xsl:when test="$displayAbbrevNum and $valueSumSharecount &gt; 999000">
				<xsl:value-of select="format-number($valueSumSharecount div 1000000, '#,##0.0')" />
				<xsl:value-of select="string('M')" />
			</xsl:when>
			<xsl:when test="$displayAbbrevNum and $valueSumSharecount &gt; 999">
				<xsl:value-of select="format-number($valueSumSharecount div 1000, '#,##0')" />
				<xsl:value-of select="string('K')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number($valueSumSharecount, '#,##0')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
  <xsl:choose>
    <xsl:when test="$doTemplate and $valueSumSharecount > 1">
    	<span xsl:use-attribute-sets="summaries__sharecount-sum-span" lbname="{$myLbn}">
        <xsl:value-of select="replace($disp-val_summaries__sharecount-sum_text ,$disp-val__sharecount-sum_swap ,$displaySumSharecount)" />
    	</span>
    </xsl:when>
    <xsl:when test="$doTemplate and $valueSumSharecount = 1">
    	<span xsl:use-attribute-sets="summaries__sharecount-sum-span" lbname="{$myLbn}">
        <xsl:value-of select="$disp-val_summaries__sharecount-sum_text-one-share" />
    	</span>
    </xsl:when>
    <xsl:otherwise />
  </xsl:choose>
</xsl:template>

<xsl:variable name="bool_summaries__do-sharecount-sum" select="false()" />

<xsl:variable name="disp-val_summaries__sharecount-sum_text-one-share">
	<xsl:value-of select="concat($disp-val__bolt-separator ,'Shared' ,$disp-val__nbsp ,'once')" />
</xsl:variable>
<xsl:variable name="disp-val_summaries__sharecount-sum_text">
	<xsl:value-of select="concat($disp-val__bolt-separator ,'Shared' ,$disp-val__nbsp ,$disp-val__sharecount-sum_swap ,$disp-val__nbsp ,'times')" />
</xsl:variable>

<xsl:attribute-set name="summaries__sharecount-sum-span">
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="summaries__children-of">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__children-of')" />
  <xsl:param name="myId" select="@ID" />
  <xsl:param name="myContent" select="$xml__allowed-articles[@PARENT=$myId]" />
  <!--<xsl:apply-templates select="$myContent" mode="summaries__child_two-row" />-->
  <xsl:apply-templates select="$myContent" mode="summaries__child" />
</xsl:template>


<xsl:template match="ARTICLE" mode="summaries__child">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__child')" />
  <xsl:param name="myId" select="@ID" />
  <tr lbname="{$myLbn}">
    <!--
    <xsl:if test="string-length(THUMBNAIL) &gt; 0">
      <xsl:apply-templates select="THUMBNAIL" mode="summaries" />
    </xsl:if>
    -->
    <td xsl:use-attribute-sets="summaries__child-td" lbname="{$myLbn}">
      <!--
      <xsl:if test="string-length(THUMBNAIL) &lt; 1">
        <xsl:attribute name="colspan" select="string('2')" />
      </xsl:if>
      -->
      <xsl:attribute name="style">
        <xsl:value-of select="$style_summaries__child-headline-td" />
        <xsl:value-of select="concat( 'text-indent:'  ,'-10px'  ,'; ' )" />
        <xsl:choose>
          <xsl:when test="position()=1">
            <xsl:value-of select="$style_summaries__child-td_first-item-head" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$style_summaries__child-td_next-item-head" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:value-of select="$style_summaries__child-td_last-item-foot" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$style_summaries__child-td_next-item-foot" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="summaries__anchor" />
      <xsl:apply-templates select="PUBLICATION" mode="summaries__child" />
      <xsl:apply-templates select="HEADLINE" mode="summaries__child" />
    </td>
  </tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="summaries__child_two-row">
  <xsl:param name="myLbn" select="string('ARTICLE___summaries__child_two-row')" />
  <xsl:param name="myId" select="@ID" />
  <tr lbname="{$myLbn}">
    <!--
    <xsl:if test="string-length(THUMBNAIL) &gt; 0">
      <xsl:apply-templates select="THUMBNAIL" mode="summaries" />
    </xsl:if>
    -->
    <td xsl:use-attribute-sets="summaries__child-td" lbname="{$myLbn}">
      <!--
      <xsl:if test="string-length(THUMBNAIL) &lt; 1">
        <xsl:attribute name="colspan" select="string('2')" />
      </xsl:if>
      -->
      <xsl:attribute name="style">
        <xsl:value-of select="$style_summaries__child-headline-td" />
        <xsl:choose>
          <xsl:when test="position()=1">
            <xsl:value-of select="$style_summaries__child-td_first-item-head" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$style_summaries__child-td_next-item-head" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="summaries__anchor" />
      <xsl:apply-templates select="HEADLINE" mode="summaries__child_two-row" />
    </td>
  </tr>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="summaries__child-td" lbname="{$myLbn}">
      <!--
      <xsl:if test="string-length(THUMBNAIL) &lt; 1">
        <xsl:attribute name="colspan" select="string('2')" />
      </xsl:if>
      -->
      <xsl:attribute name="style">
        <xsl:value-of select="$style_summaries__child-bolt-td" />
        <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:value-of select="$style_summaries__child-td_next-item-head" />
            <xsl:value-of select="$style_summaries__child-td_last-item-foot" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$style_summaries__child-td_next-item-head" />
            <xsl:value-of select="$style_summaries__child-td_next-item-foot" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="bolt" />
    </td>
  </tr>
</xsl:template>

<xsl:variable name="style_summaries__child-headline-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'25px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__child-bolt-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_bolt  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <!--<xsl:value-of select="concat( 'line-height:'  ,'20px'  ,'; ' )" />-->
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'25px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__child-td_first-item-head">
  <xsl:value-of select="concat( 'padding-top:'  ,'5px'  ,'; ' )" />
</xsl:variable>
<xsl:variable name="style_summaries__child-td_next-item-head">
  <xsl:value-of select="concat( 'padding-top:'  ,'8px'  ,'; ' )" />
</xsl:variable>
<xsl:variable name="style_summaries__child-td_next-item-foot">
  <xsl:value-of select="concat( 'padding-bottom:'  ,'8px'  ,'; ' )" />
</xsl:variable>
<xsl:variable name="style_summaries__child-td_last-item-foot">
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__child-td">
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="HEADLINE" mode="summaries__child">
  <xsl:param name="myLbn" select="string('HEADLINE___summaries__child')" />
  <xsl:variable name="href">
    <xsl:apply-templates select=".." mode="build-href" />
  </xsl:variable>
  <xsl:variable name="name">
    <xsl:value-of select="concat('top' ,../@ID)" />
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="string-length(../SRCURL) &gt; 4 or string-length(../AGTURL) &gt; 4">
      <a xsl:use-attribute-sets="summaries__child-link_headline" lbname="{$myLbn}">
        <xsl:attribute name="href" select="$href" />
        <xsl:value-of disable-output-escaping="yes" select="." />
      </a>
      <a xsl:use-attribute-sets="summaries__child-link_icon" lbname="{$myLbn}">
        <xsl:attribute name="href" select="$href" />
        <xsl:choose>
          <xsl:when test="$doFT and not (../SRCURL/@REDIRECT=1)">
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__link-down-icon" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__link-out-icon" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of disable-output-escaping="yes" select="string('&#x2b;&#xa0;')" />
      <xsl:value-of disable-output-escaping="yes" select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="HEADLINE" mode="summaries__child_two-row">
  <xsl:param name="myLbn" select="string('HEADLINE___summaries__child_two-row')" />
  <xsl:variable name="href">
    <xsl:apply-templates select=".." mode="build-href" />
  </xsl:variable>
  <xsl:variable name="name">
    <xsl:value-of select="concat('top' ,../@ID)" />
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="string-length(../SRCURL) &gt; 4 or string-length(../AGTURL) &gt; 4">
      <a xsl:use-attribute-sets="summaries__child-link_headline" lbname="{$myLbn}">
        <xsl:attribute name="href" select="$href" />
        <xsl:value-of disable-output-escaping="yes" select="string('&#x2b;&#xa0;')" />
        <xsl:value-of disable-output-escaping="yes" select="." />
      </a>
      <a xsl:use-attribute-sets="summaries__child-link_icon" lbname="{$myLbn}">
        <xsl:attribute name="href" select="$href" />
        <xsl:choose>
          <xsl:when test="$doFT and not (../SRCURL/@REDIRECT=1)">
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__link-down-icon" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$disp-val__nbsp" />
            <xsl:value-of select="$disp-val__link-out-icon" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of disable-output-escaping="yes" select="string('&#x2b;&#xa0;')" />
      <xsl:value-of disable-output-escaping="yes" select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="style_summaries__child-link_headline">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_summaries__child-link_icon">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'none'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__child-link_headline">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__child-link_headline" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="summaries__child-link_icon">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__child-link_icon" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="PUBLICATION" mode="summaries__child">
  <xsl:param name="myLbn" select="string('PUBLICATION___summaries__child')" />
  <xsl:value-of disable-output-escaping="yes" select="string('&#x2b;&#8239;')" />
  <span xsl:use-attribute-sets="summaries__child-publication-span" lbname="{$myLbn}">
    <xsl:value-of disable-output-escaping="yes" select="." />
    <xsl:value-of select="string(': ')" />
  </span>
</xsl:template>

<xsl:variable name="style_summaries__child-publication-span">
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="summaries__child-publication-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_summaries__child-publication-span" />
  </xsl:attribute>
</xsl:attribute-set>

<!--
<xsl:template match="HEADLINE" mode="summaries__child">
  <xsl:param name="myLbn" select="string('HEADLINE___summaries__child')" />
  <xsl:variable name="href">
    <xsl:apply-templates select=".." mode="build-href" />
  </xsl:variable>
  <xsl:variable name="name">
    <xsl:value-of select="concat('top' ,../@ID)" />
  </xsl:variable>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="summaries__child-headline-td" lbname="{$myLbn}">
      <xsl:choose>
        <xsl:when test="string-length(SRCURL) &gt; 4 or string-length(AGTURL) &gt; 4">
          <a xsl:use-attribute-sets="summaries__child-link_headline" lbname="{$myLbn}">
            <xsl:attribute name="href" select="$href" />
            <xsl:value-of disable-output-escaping="yes" select="." />
            <xsl:choose>
              <xsl:when test="$doFT and not (SRCURL/@REDIRECT=1)">
                <xsl:value-of select="$disp-val__link-down-icon" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$disp-val__link-out-icon" />
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of disable-output-escaping="yes" select="." />
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>

<xsl:attribute-set name="summaries__child-headline-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
    <xsl:value-of select="concat( 'line-height:'  ,'24px'  ,'; ' )" />
    <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="summaries__child-link_headline">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
    <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>
-->


<!-- #####  templates  -  fulltext block  ################################# -->

<xsl:template name="do-fulltext-block">
  <xsl:param name="myLbn" select="string('do-fulltext-block')" />
  <xsl:param name="myStyle" select="string('fulltext')" />
  <xsl:param name="doTemplate" select="$bool__do-fulltext-block" />
  <xsl:param name="doHead" select="$bool_fulltext__do-block-head" />
  <xsl:param name="doLicense" select="$bool_fulltext__do-block-content-license" />
  <xsl:param name="doNav" select="$bool_fulltext__do-block-nav-list" />
  <xsl:if test="$doTemplate and $xml__allowed-articles[not(SRCURL/@REDIRECT=1)] and ($xml__top-stories or $xml__edition-sections-list)">
    <xsl:call-template name="fulltext__block-head">
      <xsl:with-param name="doTemplate" select="$doHead" />
    </xsl:call-template>
    <xsl:call-template name="fulltext__block-license">
      <xsl:with-param name="doTemplate" select="$doLicense" />
    </xsl:call-template>
    <xsl:call-template name="fulltext__nav-list">
      <xsl:with-param name="doTemplate" select="$doNav" />
      <xsl:with-param name="myStyle" select="$myStyle" />
    </xsl:call-template>
    <xsl:if test="$bool__do-top-stories-as-section and $xml__top-stories">
      <xsl:call-template name="do-format-selector">
        <xsl:with-param name="myStyle" select="$myStyle" />
        <xsl:with-param name="myId" select="string('TopStories')" />
        <xsl:with-param name="myTitle" select="$disp-val__section-title_top-stories" />
        <xsl:with-param name="myIssueList" select="$blankNode" />
        <xsl:with-param name="myIssueArticles" select="$blankNode" />
        <xsl:with-param name="myGeneralArticles" select="$xml__top-stories" />
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="$xml__edition-sections-list" mode="process">
      <xsl:with-param name="myStyle" select="$myStyle" />
      <xsl:sort select="ORDINAL" data-type="number" order="ascending" />
      <xsl:sort select="NAME" data-type="text" order="ascending" />
      <xsl:sort select="ID" data-type="number" order="descending" />
    </xsl:apply-templates>
    <xsl:call-template name="fulltext__block-copyright" />
  </xsl:if>
</xsl:template>

<xsl:variable name="bool_fulltext__do-block-head" select="true()" />
<xsl:variable name="bool_fulltext__do-block-content-license" select="true()" />
<xsl:variable name="bool_fulltext__do-block-nav-list" select="false()" />


<xsl:template name="fulltext__block-head">
  <xsl:param name="myLbn" select="string('fulltext__block-head')" />
  <xsl:param name="myTitle" select="$disp-val_fulltext__block-title" />
  <xsl:param name="doTemplate" select="true()" />
  <xsl:if test="$doTemplate">
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td fulltext__block-head-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="fulltext__block-head-td_title" lbname="{$myLbn}">
        <xsl:value-of select="$myTitle" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td fulltext__block-head-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_fulltext__block-title">
  <xsl:value-of select="string('Full Articles')" />
</xsl:variable>

<xsl:variable name="style_fulltext__block-head-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__block-head-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'20px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'0px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__block-head-td_title">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__block-head-td-border" />
    <xsl:value-of select="$style_fulltext__block-head-td-font" />
    <xsl:value-of select="$style_fulltext__block-head-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__block-head-td_mobile-spacer">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_common__block-head-td-border" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="fulltext__block-license">
  <xsl:param name="myLbn" select="string('fulltext__block-license')" />
  <xsl:param name="myContent" select="$disp-val_fulltext__block-license" />
  <xsl:param name="doTemplate" select="true()" />
  <xsl:if test="$doTemplate">
    <tr>
      <td xsl:use-attribute-sets="mobile-spacer-td fulltext__block-license-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="fulltext__block-license-td_title" lbname="{$myLbn}">
        <xsl:value-of select="$myContent" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td fulltext__block-license-td_mobile-spacer" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_fulltext__block-license">
  <xsl:value-of select="concat('Licensed by ' ,$disp-val__client-name ,'&#8239;&#x204e;')" />
</xsl:variable>

<xsl:variable name="style_fulltext__block-license-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-style:'  ,'italic'  ,'; ' )" />
  <!--<xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />-->
</xsl:variable>

<xsl:variable name="style_fulltext__block-license-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'1px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__block-license-td_title">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__block-license-td-font" />
    <xsl:value-of select="$style_fulltext__block-license-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__block-license-td_mobile-spacer">
  <xsl:attribute name="style">
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="fulltext__nav-list">
  <xsl:param name="myLbn" select="string('fulltext__nav-list')" />
  <xsl:param name="myStyle" select="string('fulltext')" />
  <xsl:param name="myContent" select="$xml__edition-sections-list" />
  <xsl:param name="doTemplate" select="false()" />
  <xsl:if test="$doTemplate and $myContent and count($xml__enabled-sections-list) &gt; 1">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="fulltext__nav-list-td" lbname="{$myLbn}">
        <xsl:apply-templates select="$myContent" mode="fulltext__nav-list">
          <xsl:with-param name="myStyle" select="$myStyle" />
        </xsl:apply-templates>
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:variable name="style_fulltext__nav-list-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'18px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__nav-list-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'15px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'15px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__nav-list-td">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'background-color:'  ,$attr-val__bg-color_reference  ,'; ' )" />
    <xsl:value-of select="$style_fulltext__nav-list-td-font" />
    <xsl:value-of select="$style_fulltext__nav-list-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_reference" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('center')" />
</xsl:attribute-set>


<xsl:template match="SECTION" mode="fulltext__nav-list">
	<xsl:param name="myLbn" select="string('SECTION___fulltext__nav-list')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myStyle" select="string('fulltext')" />
  <a xsl:use-attribute-sets="fulltext__nav-list-link" lbname="{$myLbn}">
    <xsl:attribute name="href" select="concat('#' ,$myStyle ,$myLayer ,ID)" />
    <xsl:value-of disable-output-escaping="yes" select="NAME" />
  </a>
  <xsl:if test="position() != last()">
		<xsl:value-of select="$disp-val_fulltext__nav-list-separator" />
  </xsl:if>
</xsl:template>

<xsl:variable name="disp-val_fulltext__nav-list-separator">
  <xsl:value-of select="$disp-val__menu-separator" />
</xsl:variable>

<xsl:variable name="style_fulltext__nav-list-link-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'text-decoration:'  ,'underline'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__nav-list-link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__nav-list-link-font" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="do-section-as-fulltext">
  <xsl:param name="myLbn" select="string('do-section-as-fulltext')" />
  <xsl:param name="myStyle" select="string('fulltext')" />
  <xsl:param name="myGatewayBlockStyle" select="string('')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="myIssueList" />
  <xsl:param name="myIssueArticles" />
  <xsl:param name="myGeneralArticles" />
  <xsl:call-template name="fulltext__section-head">
    <xsl:with-param name="myStyle" select="$myStyle" />
    <xsl:with-param name="myId" select="$myId" />
    <xsl:with-param name="myTitle" select="$myTitle" />
    <xsl:with-param name="navReturnToBlock" select="$myGatewayBlockStyle" />
  </xsl:call-template>
  <xsl:if test="count($myIssueArticles) &lt; 1 and count($myGeneralArticles) &lt; 1">
    <xsl:call-template name="fulltext__supplement-content">
      <xsl:with-param name="myBodyText" select="$disp-val__no-relevant-content" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates select="$myIssueList" mode="fulltext">
    <xsl:with-param name="myIssueArticles" select="$myIssueArticles" />
  </xsl:apply-templates>
  <xsl:if test="$myGeneralArticles and $myIssueArticles">
    <xsl:call-template name="fulltext__issue-head">
      <xsl:with-param name="myTitle" select="replace( $disp-val__issue-title_general-articles ,$disp-val__issue-title_swap ,$myTitle )" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates select="$myGeneralArticles" mode="fulltext">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
    <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
    <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
</xsl:template>


<xsl:template name="fulltext__section-head">
  <xsl:param name="myLbn" select="string('fulltext__section-head')" />
  <xsl:param name="myLayer" select="string('Section')" />
  <xsl:param name="myStyle" select="string('fulltext')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <xsl:param name="navReturnToBlock" />
  <xsl:param name="navReturnToSection" select="concat('#' ,$navReturnToBlock ,$myLayer ,$myId)" />
  <xsl:param name="doTemplate" select="$bool_fulltext__do-section-head" />
  <xsl:choose>
    <xsl:when test="$doTemplate and count($xml__enabled-sections-list) &gt; 1">
      <xsl:call-template name="common__section-head">
        <xsl:with-param name="myLayer" select="$myLayer" />
        <xsl:with-param name="myBlock" select="$myStyle" />
        <xsl:with-param name="myId" select="$myId" />
        <xsl:with-param name="myTitle" select="$myTitle" />
        <xsl:with-param name="myStyleTdColor" select="$style_fulltext__section-head-td-color" />
        <xsl:with-param name="myStyleTdBreakline" select="$style_fulltext__section-head-td_breakline" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="common__spacer-row" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="bool_fulltext__do-section-head" select="true()" />

<xsl:variable name="style_fulltext__section-head-td-color">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__section-head-td_breakline">
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,'2px solid '  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>


<xsl:template match="ISSUE" mode="fulltext">
	<xsl:param name="myLbn" select="string('ISSUE___fulltext')" />
  <xsl:param name="myIssueArticles" />
  <xsl:variable name="issueId" select="@ID" />
  <xsl:call-template name="fulltext__issue-head">
    <xsl:with-param name="myId" select="$issueId" />
    <xsl:with-param name="myTitle" select="@NAME" />
  </xsl:call-template>
  <xsl:apply-templates select="$myIssueArticles[@ID=$xml__edition-issues-list[@ID=$issueId]/ARTICLE/@ID]" mode="fulltext">
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" order="ascending" />
    <xsl:sort select="@PUBLISHDATE" data-type="number" order="descending" />
    <xsl:sort select="PUBLICATION/@LBPUBWT" data-type="number" order="descending" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
</xsl:template>


<xsl:template name="fulltext__issue-head">
  <xsl:param name="myLbn" select="string('fulltext__issue-head')" />
  <xsl:param name="myLayer" select="string('Issue')" />
  <xsl:param name="myStyle" select="string('fulltext')" />
  <xsl:param name="myId" />
  <xsl:param name="myTitle" />
  <tr>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="fulltext__issue-head-td">
      <a lbname="{$myLbn}">
        <xsl:attribute name="id" select="concat($myStyle ,$myLayer ,$myId)" />
        <xsl:attribute name="name" select="concat($myStyle ,$myLayer ,$myId)" />
      </a>
      <xsl:value-of disable-output-escaping="yes" select="$myTitle" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="style_fulltext__issue-head-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_hilite  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'26px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__issue-head-td-padding">
  <xsl:value-of select="concat( 'padding-top:'  ,'1px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'12px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__issue-head-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__issue-head-td-font" />
    <xsl:value-of select="$style_fulltext__issue-head-td-padding" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template name="fulltext__block-copyright">
  <xsl:param name="myLbn" select="string('fulltext__block-copyright')" />
  <xsl:param name="myImgSrc" select="$href-val_fulltext__block-copyright-img-src" />
  <xsl:param name="myImgAlt" select="$disp-val_fulltext__block-copyright-img-alt" />
  <xsl:param name="myText" select="$disp-val_fulltext__block-copyright-notice" />
  <tr>
    <td xsl:use-attribute-sets="mobile-spacer-td fulltext__block-copyright-container-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="fulltext__block-copyright-container-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="/CLIPSHEET/BOTMSG">
            <xsl:value-of select="$style_fulltext__block-copyright-container-td" />
            <xsl:value-of select="$style_fulltext__block-copyright-container-td_border" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$style_fulltext__block-copyright-container-td" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
        <tr>
          <td xsl:use-attribute-sets="fulltext__block-copyright-td" lbname="{$myLbn}">
            <img width="150" height="44" alt="">
              <xsl:attribute name="alt" select="$myImgAlt" />
              <xsl:attribute name="src" select="$myImgSrc" />
            </img>
          </td>
          <td xsl:use-attribute-sets="fulltext__block-copyright-td fulltext__block-copyright-td_text" lbname="{$myLbn}">
            <xsl:value-of select="$myText" />
          </td>
        </tr>
      </table>
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td fulltext__block-copyright-container-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="href-val_fulltext__block-copyright-img-src">
  <xsl:value-of select="string('https://LB_CDN_BASE/graphics/DJbranding.png')" />
</xsl:variable>

<xsl:variable name="disp-val_fulltext__block-copyright-img-alt">
  <xsl:value-of select="string('Dow Jones')" />
</xsl:variable>

<xsl:variable name="disp-val_fulltext__block-copyright-notice">
  <xsl:value-of select="concat('*Some full text licensed by ' ,$disp-val__client-name ,' through their agreements with Factiva and Financial Times.')" />
</xsl:variable>

<xsl:variable name="style_fulltext__block-copyright-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'18px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__block-copyright-container-td">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__block-copyright-container-td_border">
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_content-shade  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__block-copyright-container-td">
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_reference" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__block-copyright-td">
  <xsl:attribute name="bgcolor" select="$attr-val__bg-color_reference" />
  <xsl:attribute name="valign" select="string('middle')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__block-copyright-td_text">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__block-copyright-font" />
    <xsl:value-of select="concat( 'padding-left:'  ,'20px'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template name="fulltext__supplement-content">
  <xsl:param name="myLbn" select="string('fulltext__supplement-content')" />
  <xsl:param name="myTitle" />
  <xsl:param name="myBodyText" />
  <xsl:if test="$myTitle">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
        <xsl:attribute name="style">
          <xsl:value-of select="$style_fulltext__section-container-td-padding" />
          <xsl:value-of select="$style_fulltext__section-container-td-padding_clip-card" />
          <xsl:value-of select="$style_fulltext__headline-td" />
        </xsl:attribute>
        <xsl:value-of select="$myTitle" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
  <xsl:if test="$myBodyText">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
        <xsl:attribute name="style">
          <xsl:value-of select="$style_fulltext__section-container-td-padding" />
          <xsl:value-of select="$style_fulltext__clip-body-text-td-font" />
        </xsl:attribute>
        <xsl:value-of select="$myBodyText" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
  <xsl:if test="$myTitle or $myBodyText">
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
      <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
        <xsl:attribute name="style">
          <xsl:value-of select="$style_fulltext__section-container-td-padding" />
          <xsl:value-of select="$style_fulltext__clip-body-text-td-padding_abstract" />
        </xsl:attribute>
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
      <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    </tr>
  </xsl:if>
</xsl:template>


<!-- #### templates ### fulltext__article #### -->

<xsl:template match="ARTICLE" mode="fulltext">
  <xsl:param name="myLbn" select="string('ARTICLE___fulltext')" />
  <xsl:param name="myId" select="@ID" />
  <xsl:param name="pubcopyright-img-src">
    <xsl:apply-templates select="PUBCOPYRIGHT" mode="img-src-extract" />
  </xsl:param>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_fulltext__section-container-td-padding" />
        <xsl:value-of select="$style_fulltext__section-container-td-padding_clip-card" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="fulltext__clip-card" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_fulltext__section-container-td-padding" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="fulltext__clip-body" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
  <tr lbname="{$myLbn}">
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
    <td xsl:use-attribute-sets="common-td" lbname="{$myLbn}">
      <xsl:attribute name="style">
        <xsl:value-of select="$style_fulltext__section-container-td-padding" />
        <xsl:value-of select="$style_fulltext__section-container-td-padding_clip-foot" />
      </xsl:attribute>
      <xsl:apply-templates select="." mode="fulltext__clip-foot" />
    </td>
    <td xsl:use-attribute-sets="mobile-spacer-td" lbname="{$myLbn}"><xsl:value-of select="$disp-val__nbsp" /></td>
  </tr>
</xsl:template>

<xsl:variable name="style_fulltext__section-container-td-padding">
  <xsl:value-of select="$style_common__article-container-padding-left" />
</xsl:variable>

<xsl:variable name="style_fulltext__section-container-td-padding_clip-card">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__section-container-td-padding_clip-foot">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'25px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__section-container-td">
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="fulltext__clip-card">
  <xsl:param name="myLbn" select="string('ARTICLE___fulltext__clip-card')" />
  <!--<xsl:param name="myId" select="@ID" />-->
  <xsl:param name="pubcopyright-img-src">
    <xsl:apply-templates select="PUBCOPYRIGHT" mode="img-src-extract" />
  </xsl:param>
  <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <th lbname="{$myLbn}" />
      <th lbname="{$myLbn}" />
    </tr>
    <tr lbname="{$myLbn}">
      <xsl:if test="string-length($pubcopyright-img-src) &gt; 0">
        <xsl:apply-templates select="PUBCOPYRIGHT" mode="fulltext__pubcopyright-img">
          <xsl:with-param name="img-src" select="$pubcopyright-img-src" />
        </xsl:apply-templates>
      </xsl:if>
      <td xsl:use-attribute-sets="fulltext__clip-card-text-td" lbname="{$myLbn}">
        <xsl:choose>
          <xsl:when test="string-length($pubcopyright-img-src) &lt; 1">
            <xsl:attribute name="colspan" select="string('2')" />
            <xsl:attribute name="style" select="$style_fulltext__clip-card-text-td" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="style" select="$style_fulltext__clip-card-text-td_right" />
          </xsl:otherwise>
        </xsl:choose>
        <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
          <tr lbname="{$myLbn}">
            <xsl:apply-templates select="HEADLINE" mode="fulltext" />
          </tr>
          <tr lbname="{$myLbn}">
            <xsl:apply-templates select="." mode="fulltext__bolt" />
          </tr>
          <tr>
            <td xsl:use-attribute-sets="fulltext__clip-card-border-td" lbname="{$myLbn}">
              <xsl:attribute name="style">
                <xsl:value-of select="$style_fulltext__clip-card-border-td" />
              </xsl:attribute>
              <a xsl:use-attribute-sets="fulltext__clip-foot-link_icon" lbname="{$myLbn}">
                <xsl:attribute name="href" select="concat('#top' ,@ID)" />
                <xsl:value-of select="string('&#x2191;&#8239;')" />
              </a>
              <a xsl:use-attribute-sets="fulltext__clip-foot-link" lbname="{$myLbn}">
                <xsl:attribute name="href" select="concat('#top' ,@ID)" />
                <xsl:value-of select="string('TOP')" />
              </a>
            </td>
          </tr>
        </table>
      </td>
    </tr>

  </table>
</xsl:template>

<xsl:variable name="style_fulltext__clip-card-text-td">
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_contrast-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__clip-card-text-td_right">
  <xsl:value-of select="$style_fulltext__clip-card-text-td" />
  <xsl:value-of select="concat( 'padding-left:'  ,'10px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__clip-card-border-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'11px'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-align:'  ,'right'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__clip-card-text-td">
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__clip-card-border-td">
  <xsl:attribute name="colspan" select="string('2')" />
  <xsl:attribute name="valign" select="string('top')" />
</xsl:attribute-set>


<xsl:template match="HEADLINE" mode="fulltext">
  <xsl:param name="myLbn" select="string('HEADLINE___fulltext')" />
  <td xsl:use-attribute-sets="fulltext__headline-td" lbname="{$myLbn}">
    <a name="{../@ID}" lbname="{$myLbn}" />
    <xsl:value-of disable-output-escaping="yes" select="." />
  </td>
</xsl:template>

<xsl:variable name="style_fulltext__headline-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_title  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'16px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'22px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__headline-td">
  <xsl:attribute name="style" select="$style_fulltext__headline-td" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="fulltext__bolt">
  <xsl:param name="myLbn" select="string('ARTICLE___fulltext__bolt')" />
  <td xsl:use-attribute-sets="fulltext__bolt-td" lbname="{$myLbn}">
    <xsl:apply-templates select="." mode="bolt" />
    <xsl:apply-templates select="SHARING" mode="sharecount-sum" />
    <xsl:apply-templates select="PUBLICATION" mode="authreq-msg" />
  </td>
</xsl:template>

<xsl:variable name="style_fulltext__bolt-td">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_bolt  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'5px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__bolt-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__bolt-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>

<!--
<xsl:attribute-set name="fulltext__top-link">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
    <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_bolt  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,'11px'  ,'; ' )" />
    <xsl:value-of select="concat( 'font-weight:'  ,'normal'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="align" select="string('right')" />
</xsl:attribute-set>
-->


<xsl:template match="PUBCOPYRIGHT" mode="img-src-extract">
	<xsl:param name="myLbn" select="string('PUBCOPYRIGHT___img-src-extract')" />
  <xsl:variable name="src-url-substr-a">
    <xsl:value-of select="substring-after(.,'src=')" />
  </xsl:variable>
  <xsl:variable name="src-url-substr-a_len">
    <xsl:value-of select="string-length($src-url-substr-a)" />
  </xsl:variable>
  <xsl:variable name="src-url-substr-b">
    <xsl:value-of select="substring($src-url-substr-a,2,$src-url-substr-a_len - 1)" />
  </xsl:variable>
  <xsl:variable name="src-url-substr-c">
    <xsl:value-of select="substring-before($src-url-substr-b,' />')" />
  </xsl:variable>
  <xsl:variable name="src-url-substr-c_len">
    <xsl:value-of select="string-length($src-url-substr-c)" />
  </xsl:variable>
  <xsl:variable name="src-url-extract">
    <xsl:value-of select="substring($src-url-substr-c,1,$src-url-substr-c_len - 1)" />
  </xsl:variable>
  <xsl:value-of select="$src-url-extract" />
</xsl:template>


<xsl:template match="PUBCOPYRIGHT" mode="fulltext__pubcopyright-img">
  <xsl:param name="myLbn" select="string('PUBCOPYRIGHT___fulltext__pubcopyright-img')" />
  <xsl:param name="img-src" />
  <td xsl:use-attribute-sets="fulltext__pubcopyright-td" lbname="{$myLbn}">
    <xsl:if test="string-length($img-src) &gt; 0">
      <img src="{$img-src}" width="80" height="auto" alt=""/>
    </xsl:if>
  </td>
</xsl:template>

<xsl:variable name="style_fulltext__pubcopyright-td">
  <xsl:value-of select="concat( 'border-top:'  ,$attr-val__box-border_contrast-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'border-right:'  ,$attr-val__box-border_contrast-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_contrast-shade  ,'; ' )" />
  <xsl:value-of select="concat( 'border-left:'  ,$attr-val__box-border_contrast-shade  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__pubcopyright-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__pubcopyright-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('middle')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="width" select="string('100')" />
</xsl:attribute-set>


<xsl:template match="ARTICLE" mode="fulltext__clip-body">
  <xsl:param name="myLbn" select="string('ARTICLE___fulltext__clip-body')" />
  <xsl:param name="myId" select="@ID" />
  <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <xsl:apply-templates select="SUBHEAD" mode="fulltext" />
    </tr>
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="fulltext__clip-body-text-td">
        <xsl:choose>
          <xsl:when test="SRCURL/@REDIRECT=1">
            <xsl:attribute name="style">
              <xsl:value-of select="$style_fulltext__clip-body-text-td-font" />
              <xsl:value-of select="$style_fulltext__clip-body-text-td-padding_abstract" />
            </xsl:attribute>
            <xsl:apply-templates select="ABSTRACT" mode="fulltext" />
            <!--<xsl:apply-templates select="SRCURL" mode="rights" />-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="style">
              <xsl:value-of select="$style_fulltext__clip-body-text-td-font" />
              <xsl:value-of select="$style_fulltext__clip-body-text-td-padding_articletext" />
            </xsl:attribute>
            <!--<xsl:apply-templates select="PUBCOPYRIGHT" />-->
            <xsl:call-template name="ARTICLEBODY">
              <xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$myId]/ARTICLEBODY" />
            </xsl:call-template>
            <!--
            <xsl:if test="$showSource">
              <xsl:apply-templates select="SRCURL" mode="site" />
            </xsl:if>
            -->
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:variable name="style_fulltext__clip-body-text-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'22px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__clip-body-text-td-padding_abstract">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'0px'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="style_fulltext__clip-body-text-td-padding_articletext">
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'0px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__clip-body-text-td">
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="SUBHEAD" mode="fulltext">
  <xsl:param name="myLbn" select="string('SUBHEAD___fulltext')" />
  <td xsl:use-attribute-sets="fulltext__subhead-td" lbname="{$myLbn}">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </td>
</xsl:template>

<xsl:variable name="style_fulltext__subhead-td">
  <xsl:value-of select="$style_fulltext__clip-body-text-td-font" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-top:'  ,'10px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-bottom:'  ,'0px'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'0px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__subhead-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__subhead-td" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
</xsl:attribute-set>


<xsl:template match="ABSTRACT" mode="fulltext">
  <xsl:param name="myLbn" select="string('ABSTRACT___summaries')" />
  <xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>


<xsl:template name="ARTICLEBODY">
  <xsl:param name="myLbn" select="string('ARTICLEBODY')" />
  <xsl:param name="article" />
  <xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
</xsl:template>


<xsl:template match="ARTICLE" mode="fulltext__clip-foot">
  <xsl:param name="myLbn" select="string('ARTICLE___fulltext__clip-foot')" />
  <xsl:param name="myId" select="@ID" />
  <table xsl:use-attribute-sets="common-table" lbname="{$myLbn}">
    <tr lbname="{$myLbn}">
      <th lbname="{$myLbn}" />
      <th lbname="{$myLbn}" />
      <th lbname="{$myLbn}" />
    </tr>
    <xsl:if test="string-length(PUBCOPYRIGHT) &gt; 0">
      <tr lbname="{$myLbn}">
        <td xsl:use-attribute-sets="fulltext__clip-foot-td_left" lbname="{$myLbn}">
          <xsl:apply-templates select="PUBCOPYRIGHT" mode="fulltext__pubcopyright-text" />
        </td>
        <td xsl:use-attribute-sets="fulltext__clip-foot-td_center">
          <xsl:value-of select="$disp-val__nbsp" />
        </td>
        <td xsl:use-attribute-sets="fulltext__clip-foot-td_right" lbname="{$myLbn}">
          <a xsl:use-attribute-sets="fulltext__clip-foot-link_icon" lbname="{$myLbn}">
            <xsl:attribute name="href" select="concat('#top' ,@ID)" />
            <xsl:value-of select="string('&#x2191;&#8239;')" />
          </a>
          <a xsl:use-attribute-sets="fulltext__clip-foot-link" lbname="{$myLbn}">
            <xsl:attribute name="href" select="concat('#top' ,@ID)" />
            <xsl:value-of select="string('TOP')" />
          </a>
        </td>
      </tr>
    </xsl:if>
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="fulltext__clip-foot-td_center">
        <xsl:attribute name="colspan" select="string('3')" />
        <xsl:value-of select="$disp-val__nbsp" />
        <xsl:value-of disable-output-escaping="yes" select="$disp-val_fulltext__article-foot" />
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
    </tr>
    <tr lbname="{$myLbn}">
      <td xsl:use-attribute-sets="fulltext__clip-foot-td_center">
        <xsl:attribute name="colspan" select="string('3')" />
        <xsl:value-of select="$disp-val__nbsp" />
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:variable name="disp-val_fulltext__article-foot">
  <xsl:value-of select="string('&#x23;&#x23;&#x23;')" />
</xsl:variable>

<xsl:variable name="style_fulltext__clip-foot-td-font">
  <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$attr-val__font-family_content  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'14px'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="fulltext__clip-foot-td_left">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__clip-foot-td-font" />
    <xsl:value-of select="concat( 'font-size:'  ,'12px'  ,'; ' )" />
    <xsl:value-of select="concat( 'font-style:'  ,'italic'  ,'; ' )" />
    <xsl:value-of select="concat( 'text-align:'  ,'left'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('left')" />
  <xsl:attribute name="width" select="string('49%')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__clip-foot-td_center">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__clip-foot-td-font" />
    <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
    <xsl:value-of select="concat( 'font-style:'  ,'italic'  ,'; ' )" />
    <xsl:value-of select="concat( 'text-align:'  ,'center'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('bottom')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="width" select="string('auto')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__clip-foot-td_border">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__clip-foot-td-font" />
    <xsl:value-of select="concat( 'font-size:'  ,'14px'  ,'; ' )" />
    <xsl:value-of select="concat( 'font-style:'  ,'italic'  ,'; ' )" />
    <xsl:value-of select="concat( 'text-align:'  ,'center'  ,'; ' )" />
    <xsl:value-of select="concat( 'border-bottom:'  ,$attr-val__box-border_contrast-shade  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('bottom')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="width" select="string('auto')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__clip-foot-td_right">
  <xsl:attribute name="style">
    <xsl:value-of select="$style_fulltext__clip-foot-td-font" />
    <xsl:value-of select="concat( 'text-align:'  ,'right'  ,'; ' )" />
  </xsl:attribute>
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="align" select="string('right')" />
  <xsl:attribute name="width" select="string('49%')" />
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__clip-foot-link">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,'11px'  ,'; ' )" />
    <xsl:value-of select="concat( 'text-decoration:'  ,'none'  ,'; ' )" />
    <xsl:value-of select="concat( 'text-transform:'  ,'uppercase'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="fulltext__clip-foot-link_icon">
  <xsl:attribute name="style">
    <xsl:value-of select="concat( 'color:'  ,$attr-val__color_reference  ,'; ' )" />
    <xsl:value-of select="concat( 'font-size:'  ,'8px'  ,'; ' )" />
    <xsl:value-of select="concat( 'text-decoration:'  ,'none'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>


<xsl:template match="PUBCOPYRIGHT" mode="fulltext__pubcopyright-text">
  <xsl:param name="myLbn" select="string('PUBCOPYRIGHT___fulltext__pubcopyright-text')" />
  <xsl:value-of disable-output-escaping="yes" select="concat($disp-val__pubcopyright-pre-text ,../PUBLICATION)" />
</xsl:template>

<xsl:variable name="disp-val__pubcopyright-pre-text">
  <xsl:value-of select="string('Copyright © ')" />
</xsl:variable>


<!-- ###################################################################### -->
<!-- ######## templates ### wip ########################################### -->
<!-- ###################################################################### -->

<xsl:template match="ARTICLE" mode="url-values">
  <xsl:param name="myLbn" select="string('ARTICLE___url-values')" />
  <xsl:param name="linkText" select="string('View Full Coverage')" />
  <xsl:variable name="id" select="@ID" />
  <xsl:variable name="children" select="$xml__allowed-articles[@PARENT=$id]" />
  <xsl:choose>
    <xsl:when test="$doFT and not (SRCURL/@REDIRECT=1)">
      <xsl:variable name="href" select="concat('#',./@ID)" />
      <xsl:variable name="name" select="concat('top',./@ID)" />
      <xsl:variable name="img-src" />
      <xsl:variable name="text" select="$linkText" />
    </xsl:when>
    <xsl:when test="$bHosted and not (SRCURL/@REDIRECT=1) and not ($preferSrc)">
      <xsl:variable name="href" select="concat($hostroot,./@ID)" />
      <xsl:variable name="name" />
      <xsl:variable name="img-src" />
      <xsl:variable name="text" select="$linkText" />
    </xsl:when>
    <xsl:when test="string-length(SRCURL) &gt; 1 and ( SRCURL/@REDIRECT=1 or $preferSrc )">
      <xsl:choose>
        <xsl:when test ="$preferSrc and string-length(AGTURL) &gt; 4 and not (SRCURL/@REDIRECT=1) and not (string-length(WEBURL) &gt; 4)">
          <xsl:variable name="href" select="concat($hostroot,./@ID)" />
          <xsl:variable name="name" />
          <xsl:variable name="img-src" />
          <xsl:variable name="text" select="$linkText" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="href" select="SRCURL" />
          <xsl:variable name="name" />
          <xsl:variable name="img-src" select="$linkImgURL" />
          <xsl:variable name="text" select="$linkText" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="href" />
      <xsl:variable name="name" />
      <xsl:variable name="img-src" />
      <xsl:variable name="text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="ARTICLE" mode="build-href">
  <xsl:param name="myLbn" select="string('ARTICLE___build-href')" />
  <xsl:variable name="id" select="@ID" />
  <xsl:choose>
    <xsl:when test="$doFT and not (SRCURL/@REDIRECT=1)">
      <xsl:value-of select="concat('#',./@ID)" />
      <!--<xsl:variable name="name" select="concat('top',./@ID)" />-->
    </xsl:when>
    <xsl:when test="$bHosted and not (SRCURL/@REDIRECT=1) and not ($preferSrc)">
      <xsl:value-of select="concat($hostroot,./@ID)" />
    </xsl:when>
    <xsl:when test="string-length(SRCURL) &gt; 1 and ( SRCURL/@REDIRECT=1 or $preferSrc )">
      <xsl:choose>
        <xsl:when test ="$preferSrc and string-length(AGTURL) &gt; 4 and not (SRCURL/@REDIRECT=1) and not (string-length(WEBURL) &gt; 4)">
          <xsl:value-of select="concat($hostroot,./@ID)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="SRCURL" />
          <!--<xsl:variable name="img-src" select="$linkImgURL" />-->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="ARTICLE" mode="buildurl">
  <xsl:param name="linkText" select="string('View Full Coverage')" />
  <xsl:variable name="id" select="@ID" />
  <xsl:variable name="children" select="$xml__allowed-articles[@PARENT=$id]" />
  <xsl:choose>
    <xsl:when test="$doFT and not (SRCURL/@REDIRECT=1)">
      <a>
        <xsl:attribute name="href" select="concat('#',./@ID)" />
        <xsl:attribute name="name" select="concat('top',./@ID)" />
        <xsl:value-of select="$linkText" />
      </a>
    </xsl:when>
    <xsl:when test="$bHosted and not (SRCURL/@REDIRECT=1) and not ($preferSrc)">
      <a>
        <xsl:attribute name="href" select="concat($hostroot,./@ID)" />
        <xsl:value-of select="$linkText" />
      </a>
    </xsl:when>
    <xsl:when test="string-length(SRCURL) &gt; 1 and ( SRCURL/@REDIRECT=1 or $preferSrc )">
      <a>
        <xsl:choose>
          <xsl:when test ="$preferSrc and string-length(AGTURL) &gt; 4 and not (SRCURL/@REDIRECT=1) and not (string-length(WEBURL) &gt; 4)">
            <xsl:attribute name="href" select="concat($hostroot,./@ID)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="href" select="SRCURL" />
            <img src="{$linkImgURL}" style="vertical-align:middle;"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$linkText" />
      </a>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$extRelated and count($children) &gt; 0">
    <span class="extrelated" style="font-size:90%;font-style:italic;padding-left:1em;">
      <xsl:value-of select="count($children)" /> related
      <xsl:choose>
        <xsl:when test="count($children) != 1" >
        articles
        </xsl:when>
        <xsl:otherwise>
        article
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:if>
  <xsl:if test="$mediaType">
    <xsl:apply-templates select="@MEDIAID[.!=0]" />
  </xsl:if>
</xsl:template>


<xsl:template match="ARTICLE" mode="kidurl">
    <xsl:param name="linkText" select="string('View')" />
    <xsl:variable name="id" select="@ID" />
    <xsl:choose>
        <xsl:when test="not($doFT) and not($bHosted)">
            <a style="font-weight:normal;font-size:70%;padding-left:1em;">
                <xsl:attribute name="href" select="SRCURL" />
                <img src="{$linkImgURL}" style="vertical-align:middle;"/>
                <xsl:value-of select="$linkText" />
            </a>
        </xsl:when>
        <xsl:when test="$doFT">
            <a style="font-weight:normal;font-size:70%;padding-left:1em;">
                <xsl:attribute name="href" select="concat('#',./@ID)" />
                <xsl:attribute name="name" select="concat('top',./@ID)" />
                <xsl:value-of select="$linkText" />
            </a>
        </xsl:when>
        <xsl:when test="SRCURL/@REDIRECT=1">
            <a style="font-weight:normal;font-size:70%;padding-left:1em;">
                <xsl:attribute name="href" select="SRCURL" />
                <img src="{$linkImgURL}" style="vertical-align:middle;"/>
                <xsl:value-of select="$linkText" />
            </a>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$mediaType">
        <xsl:apply-templates select="@MEDIAID[.!=0]" />
    </xsl:if>
</xsl:template>

<!-- ###################################################################### -->


</xsl:stylesheet>
