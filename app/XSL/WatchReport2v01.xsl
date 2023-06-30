<?xml version='1.0'?>
<!--
Copyright Lone Buffalo, Inc.
$Revision:: 968                  $ : Revision number of this file
$Date:: 2012-05-11 10:41:09 -070#$ : date of given revision and copyright
$Author:: tech@lonebuffalo.com   $ : the author of the given revision
 Notes:
 CHANGES in WatchReport2v01(a)
 - New top-level variables:
	 - fontSizeSectionHead
   - fontSizeHeadline
   - fontSizeSubHead
   - fontWeight
   - fontWeightHead
   - several text-string variables
 - New templates (and their attribute sets + style variables):
 	 - match="ARTICLE" mode="head" (want to consolidate to do-section-head)
   - process-articles-block (WIP; do we use this or do-content-block?)
 - Updated templates:
 	 - match="SECTION" mode="process"
   - match="ISSUE"
   - do-issue-head
 - Removed templates:
 	 - do-report-nav (replaced by do-section-nav)
	 - do-toc (replaced by do-content)
	 - do-fulltext (replaced by do-content)

 GUIDELINES
 - no padding. horizontal space should be done with spaces, nbsp, align
 - elements manage their top margin. they do no bottom margin.
 - div does margins
 - span does text style
 NAMING
 - underscores separate variabledescriptor___block__element_modifier
 - hyphens separate multi-word-names (avoid camelCase), block-variants,
   AND the last hyphen shows the HTML element a given item is tied to
 - EX:
   meta___post-condensed__stats_platform-img
	 post-condensed__stats-td
	 post-condensed-td

########### LAYOUT #############################################################
~ Imports
~ Variables ~~ Standard style settings
~ Variables ~~ Basic configuration
~ Variables ~~ Template on/off switches
~ Variables ~~ Formatting values
~ Variables ~~ Image assets
~ Variables ~~ Text labels
~ Variables ~~ ETC
~ Variables ~~ Deprecated / kept for compatibility
~ Variables ~~ Style strings
~ Attribute sets ~~ Temporary
~ Attribute sets ~~ Common
~ Attribute sets ~~ Articles
~ Attribute sets ~~ Sections, issues, grouping
~ Attribute sets ~~ Report
~ Templates
################################################################################


-->

<xsl:stylesheet version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lbps="http://www.lonebuffalo.com/XSL/Functions"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs xsl lbps">

<!-- ######## ~ Imports #################################################### -->
<xsl:import href="https://LB_CDN_BASE/resources/XSL/Keywords.xsl"/>

<!-- ######## ~ Variables ~~ Standard style settings ####################### -->
<xsl:variable name="formatName">Watch Report 2v02 Base</xsl:variable>
<xsl:variable name="style" select="string('blast')" />
<xsl:variable name="doFT" select="true()" />

<!-- ######## ~ Variables ~~ Basic configuration ########################### -->
<xsl:variable name="showPortalCredentials" select="false()" />
<xsl:variable name="doEntities" select="false()" />
<xsl:variable name="doEntityTone" select="false()" />
<xsl:variable name="extOverOrdinal" select="string('')" />
<xsl:variable name="doTags" select="true()" />
<xsl:variable name="bHosted" select="true()" />
<xsl:variable name="sectEmptyFlag" select="false()" />
<xsl:variable name="selfSubscribe" select="true()" />
<xsl:variable name="dupeTop" select="false()" />
<xsl:variable name="extRelated" select="false()" />
<xsl:variable name="preferSrc" select="false()" />
<xsl:variable name="showSource" select="false()" />
<xsl:variable name="mediaType" select="false()" />
<xsl:variable name="bBlastThumbs" select="false()" />
<xsl:variable name="execSectID" select="1" />

<!-- ######## ~ Variables ~~ Template on/off switches ###################### -->
<xsl:variable name="bool___do-mobile-link" select="true()" />
<xsl:variable name="bool___do-section-nav" select="true()" />

<!-- ######## ~ Variables ~~ Formatting values ############################# -->
<xsl:variable name="headerImageMaxWidth" select="string('100%')" />
<xsl:variable name="max-width" select="string('690')" />
<xsl:variable name="min-width" select="string('690')" />
<xsl:variable name="fontFamily" select="string('Arial,sans-serif')" />
<xsl:variable name="fontFamilyBolt" select="string('Courier,serif')" />
<xsl:variable name="fontSize" select="string('1.2em')" />
<xsl:variable name="fontSizeSectionHead" select="string('2em')" />
<xsl:variable name="fontSizeHeadline" select="string('1.5em')" />
<xsl:variable name="fontSizeSubHead" select="string('1em')" />
<xsl:variable name="fontWeight" select="string('normal')" />
<xsl:variable name="fontWeightHead" select="string('bold')" />
<xsl:variable name="colorText" select="string('#231914')" />
<xsl:variable name="colorHead" select="string('#6d695f')" />
<xsl:variable name="color___block-title" select="string('#231914')" />
<xsl:variable name="colorBolt" select="string('#6d695f')" />
<xsl:variable name="colorLink" select="string('#d2503c')" />
<xsl:variable name="bgcolorNlFrame" select="string('#e6e6e6')" />
<xsl:variable name="bgcolorHead" select="string('#231914')" />
<xsl:variable name="bgcolorContent" select="string('#f2f2f2')" />
<xsl:variable name="bgcolorNav" select="string('#ffffff')" />

<!-- ######## ~ Variables ~~ Image assets ################################## -->
<xsl:variable name="brandImgURL" select="string('https://LB_CDN_BASE/graphics/lbNLHeader.jpg')" />
<xsl:variable name="linkImgURL" select="string('https://LB_CDN_BASE/graphics/linkout.png')" />
<xsl:variable name="bottomLBBrand" select="string('https://LB_CDN_BASE/graphics/lbNLbottomBrand.png')" />
<xsl:variable name="imgAud" select="string('https://LB_CDN_BASE/graphics/lb_audio.png')" />
<xsl:variable name="imgVid" select="string('https://LB_CDN_BASE/graphics/lb_video.png')" />
<xsl:variable name="imgPic" select="string('https://LB_CDN_BASE/graphics/lb_image.png')" />

<!-- ######## ~ Variables ~~ Text labels ################################### -->
<xsl:variable name="mobilePrefText" select="string('mobile users may prefer this')" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')" />
<xsl:variable name="nlFeedbackAddr" select="string('hello@lonebuffalo.com')" />
<xsl:variable name="preparedByLink" select="string('http://lonebuffalo.com/')" />
<xsl:variable name="boilerplate">
    <![CDATA[Content in this newsletter is for your use only and may not be republished.]]>
</xsl:variable>
<xsl:variable name="defaultCopyright">
</xsl:variable>
<xsl:variable name="text___section-issue__title_remaining-content">
	<xsl:value-of select="concat('Also in ' ,$text___section-issue__title_swap)" />
</xsl:variable>
<xsl:variable name="text___section-issue__title_swap">
	<xsl:value-of select="string('SECTION_NAME')" />
</xsl:variable>
<xsl:variable name="text___empty-section">
	<xsl:value-of select="string('No Relevant News')" />
</xsl:variable>
<xsl:variable name="text___held-articles_count">
	<xsl:value-of select="string('HELD_ARTICLES_COUNT more articles')" />
</xsl:variable>
<xsl:variable name="text___empty-letter">
    <![CDATA[No articles found for this edition.]]>
</xsl:variable>
<xsl:variable name="text___article-fulltext__nav">
	<xsl:value-of select="string('top')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__srcurl_descrip">
	<xsl:value-of select="string('Full content available at the source ')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__srcurl_link">
	<xsl:value-of select="string('here')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__srcurl_media-video">
	<xsl:value-of select="string('View the video at the source.')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__srcurl_media-audio">
	<xsl:value-of select="string('Hear the audio at the source.')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__srcurl_media-image">
	<xsl:value-of select="string('View the images at the source.')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__srcurl_media-text">
	<xsl:value-of select="string('Read this story at the source.')" />
</xsl:variable>
<xsl:variable name="text___article-fulltext__foot">
  <xsl:value-of select="string('&#x23;&#x23;&#x23;')" />
</xsl:variable>
<xsl:variable name="text___article-bullets_separator">
  <xsl:value-of select="string('&#x3A;')" />
</xsl:variable>
<xsl:variable name="text___article-ricochet_list-bullet">
  <xsl:value-of select="string('&#x2022;')" />
</xsl:variable>
<xsl:variable name="text___article-base__tags_separator">
  <xsl:value-of select="string(', ')" />
</xsl:variable>
<xsl:variable name="text___article-bolt_separator">
  <xsl:value-of select="string('&#xA0;&#x7C;&#xA0;')" />
</xsl:variable>
<xsl:variable name="text___nav_list-separator">
  <xsl:value-of select="string('&#xA0;&#x7C;&#xA0;')" />
</xsl:variable>
<xsl:variable name="text___nbsp">
  <xsl:value-of select="string('&#xA0;')" />
</xsl:variable>
<xsl:variable name="text___period">
  <xsl:value-of select="string('&#x2E;')" />
</xsl:variable>
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="boltDateFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="ftDateFormat" select="$boltDateFormat" />
<xsl:variable name="clientName" select="/CLIPSHEET/@CLIENT" />
<xsl:variable name="reportTitle" select="/CLIPSHEET/@NAME" />
<xsl:variable name="bottommessage" select="/CLIPSHEET/BOTMSG" />

<!-- ######## ~ Variables ~~ ETC ########################################### -->
<xsl:variable name="UAID" select="string('UA-1191451-29')" />
<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="webroot" select="/CLIPSHEET/LB_URL" />
<xsl:variable name="hostroot" select="/CLIPSHEET/MAILURL" />
<xsl:variable name="webVersionURL" select="/CLIPSHEET/WEBVERSIONURL" />
<xsl:variable name="clipDate" select="string(/CLIPSHEET/LOCAL_DATE | /CLIPSHEET/CREATE_DATE[not(boolean(/CLIPSHEET/RELEASE_DATE))])" />
<xsl:variable name="allowedArticles" select="/CLIPSHEET/ARTICLE[not(@CITEONLY=1)]" />
<xsl:variable name="topStories" select="$allowedArticles[@TOPSTORY!=0][not(@PARENT!=0)]" />
<xsl:variable name="nlIssues" select="/CLIPSHEET/ISSUE" />
<xsl:variable name="sectList" select="if ($sectEmptyFlag) then
    /CLIPSHEET/SECTION[DISPLAY!=0][NEWSLETTER!=0][number(ID)!=number($execSectID)] else
    /CLIPSHEET/SECTION[DISPLAY!=0][NEWSLETTER!=0][number(ID)!=number($execSectID)][ID=$allowedArticles/SECTION/@ID]" />
<xsl:variable name="fullTextIDs" select="$allowedArticles[not(SRCURL/@REDIRECT=1)]/@ID" />
<xsl:variable name="strAID">
  <xsl:call-template name="make-strAID">
    <xsl:with-param name="ids" select="$fullTextIDs" />
  </xsl:call-template>
</xsl:variable>
<xsl:variable name="xmlPath" select="string('XML/stdFullStory?story_id=')" />
<xsl:variable name="FTXML" select="document(concat($webroot,$xmlPath,$strAID))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />
<xsl:variable name="mobileAppId" select="string('1450569477')" />
<xsl:variable name="mobileAppLink" select="string('https://apps.apple.com/us/app/dispatch-by-lone-buffalo/id1450569477')" />

<!-- ######## ~ Variables ~~ Deprecated / kept for compatibility ########### -->
<xsl:variable name="bgcolor" select="$bgcolorNlFrame" />
<xsl:variable name="styleFamilyBolt" select="$fontFamilyBolt" />
<xsl:variable name="extOver" select="$extOverOrdinal" />
<xsl:variable name="lbCiteLink" select="$preparedByLink" />

<!-- ######## ~ Variables ~~ Style strings ################################# -->
<xsl:variable name="styleSectionHead" select="concat('font-size:2em;font-weight:bold;','font-family:',$fontFamily,';','color:',$color___block-title,';')" />
<xsl:variable name="styleIssueHead" select="concat('font-size:1em;font-weight:bold;color:',$colorLink,';')" />
<xsl:variable name="styleHeadline" select="string('font-weight:bold;font-size:1.5em;margin:0;padding:0;')" />
<xsl:variable name="styleSubHead" select="string('font-weight:bold;font-size:1em;margin:0;padding:0;')" />
<xsl:variable name="styleChildHed" select="string('font-weight:bold;font-size:1.2em;margin:0;padding:0;')" />
<xsl:variable name="styleReportTitle" select="string('font-size:1.8em;font-weight:bold;font-family:Courier;')" />

<!-- ######## ~ Attribute sets ~~ Temporary ################################ -->
<xsl:attribute-set name="bodyFont">
  <xsl:attribute name="class" select="string('bodyFont')" />
</xsl:attribute-set>
<xsl:attribute-set name="headlineFont">
  <xsl:attribute name="class" select="string('headlineFont')" />
</xsl:attribute-set>
<xsl:attribute-set name="titleFont">
  <xsl:attribute name="class" select="string('titleFont')" />
</xsl:attribute-set>

<!-- ######## ~ Attribute sets ~~ Common ################################### -->
<xsl:attribute-set name="table">
    <xsl:attribute name="width">100%</xsl:attribute>
    <xsl:attribute name="border">0</xsl:attribute>
    <xsl:attribute name="cellspacing">0</xsl:attribute>
    <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="tdContent">
  <xsl:attribute name="class" select="$nameTdContent" />
  <xsl:attribute name="style" select="$styleTdContent" />
</xsl:attribute-set>
<xsl:variable name="nameTdContent">
  <xsl:value-of select="string('tdContent')"  />
</xsl:variable>
<xsl:variable name="styleTdContent">
  <xsl:value-of select="concat( 'display:'  ,'block'  ,'; ' )" />
  <xsl:value-of select="concat( 'clear:'  ,'both'  ,'; ' )" />
  <xsl:value-of select="concat( 'max-width:'  ,$max-width  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'1em'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'1em'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'1.8'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="styleLink">
  <xsl:value-of select="concat( 'color:'  ,$colorLink  ,'; ' )" />
	<xsl:value-of select="concat( 'font-family:'  ,$fontFamily  ,'; ' )" />
</xsl:variable>

<!-- ######## ~ Attribute sets ~~ Articles ################################# -->
<xsl:attribute-set name="article-base-td">
  <xsl:attribute name="valign">
		<xsl:value-of select="string('top')" />
	</xsl:attribute>
	<xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base-td" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base-td" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base-td">
  <xsl:value-of select="string( 'article-base-td' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base-td" />
<xsl:variable name="style-lb___article-base-td">
</xsl:variable>

<xsl:attribute-set name="article-bullets-td">
	<xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-bullets-td" />
  </xsl:attribute>
  <xsl:attribute name="class">
		<xsl:value-of select="$name___article-bullets-td" />
		<xsl:value-of select="$text___nbsp" />
		<xsl:value-of select="string( 'bodyText' )" />
	</xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-bullets-td">
	<xsl:value-of select="string( 'article-bullets-td' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-bullets-td" />
<xsl:variable name="style-lb___article-bullets-td">
</xsl:variable>

<xsl:attribute-set name="article-ricochet-td">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-ricochet-td" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-ricochet-td" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-ricochet-td">
  <xsl:value-of select="string( 'article-ricochet-td' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-ricochet-td" />
<xsl:variable name="style-lb___article-ricochet-td">
</xsl:variable>

<xsl:attribute-set name="article-base__bolt-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__bolt-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__bolt-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__bolt-div">
  <xsl:value-of select="string( 'article-base__bolt-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__bolt-div" />
<xsl:variable name="style-lb___article-base__bolt-div">
	<xsl:value-of select="concat(  'margin-top:'  ,'0.4em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__bolt-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__bolt-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__bolt-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__bolt-span">
  <xsl:value-of select="string( 'article-base__bolt-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__bolt-span" />
<xsl:variable name="style-lb___article-base__bolt-span">
  <xsl:value-of select="concat(  'font-family:'  ,$fontFamilyBolt  ,'; ' )" />
  <xsl:value-of select="concat(  'color:'  ,$colorBolt  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__abstract-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__abstract-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__abstract-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__abstract-div">
  <xsl:value-of select="string( 'article-base__abstract-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__abstract-div" />
<xsl:variable name="style-lb___article-base__abstract-div">
  <xsl:value-of select="concat(  'margin-top:'  ,'0.7em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__abstract-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__abstract-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__abstract-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__abstract-span">
  <xsl:value-of select="string( 'article-base__abstract-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__abstract-span" />
<xsl:variable name="style-lb___article-base__abstract-span">
</xsl:variable>

<xsl:attribute-set name="article-base__articlebody-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__articlebody-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__articlebody-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__articlebody-div">
  <xsl:value-of select="string( 'article-base__articlebody-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__articlebody-div" />
<xsl:variable name="style-lb___article-base__articlebody-div">
  <xsl:value-of select="concat(  'margin-top:'  ,'0.7em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__articlebody-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__articlebody-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__articlebody-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__articlebody-span">
  <xsl:value-of select="string( 'article-base__articlebody-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__articlebody-span" />
<xsl:variable name="style-lb___article-base__articlebody-span">
  <xsl:value-of select="concat(  'margin-top:'  ,'0.7em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__pubcopyright-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__pubcopyright-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__pubcopyright-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__pubcopyright-div">
  <xsl:value-of select="string( 'article-base__pubcopyright-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__pubcopyright-div" />
<xsl:variable name="style-lb___article-base__pubcopyright-div">
  <xsl:value-of select="concat(  'margin:'  ,'0.5em 0 0 0'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding:'  ,'0'  ,'; ' )" />
  <xsl:value-of select="concat(  'float:'  ,'right'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__pubcopyright-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__pubcopyright-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__pubcopyright-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__pubcopyright-span">
  <xsl:value-of select="string( 'article-base__pubcopyright-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__pubcopyright-span" />
<xsl:variable name="style-lb___article-base__pubcopyright-span">
</xsl:variable>

<xsl:attribute-set name="article-base__copyright-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__copyright-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__copyright-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__copyright-div">
  <xsl:value-of select="string( 'article-base__copyright-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__copyright-div" />
<xsl:variable name="style-lb___article-base__copyright-div">
</xsl:variable>

<xsl:attribute-set name="article-base__copyright-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__copyright-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__copyright-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__copyright-span">
  <xsl:value-of select="string( 'article-base__copyright-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__copyright-span" />
<xsl:variable name="style-lb___article-base__copyright-span">
</xsl:variable>

<xsl:attribute-set name="article-base__tags-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__tags-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__tags-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__tags-span">
  <xsl:value-of select="string( 'article-base__tags-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__tags-span" />
<xsl:variable name="style-lb___article-base__tags-span">
</xsl:variable>

<xsl:attribute-set name="article-base__mention-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__mention-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__mention-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__mention-span">
  <xsl:value-of select="string( 'article-base__mention-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__mention-span" />
<xsl:variable name="style-lb___article-base__mention-span">
  <xsl:value-of select="concat(  'color:'  ,'red'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-style:'  ,'italic'  ,'; ' )" />
  <xsl:value-of select="concat(  'margin-left:'  ,'2em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__kidurl-a">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__kidurl-a" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__kidurl-a" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__kidurl-a">
  <xsl:value-of select="string( 'article-base__kidurl-a' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__kidurl-a" />
<xsl:variable name="style-lb___article-base__kidurl-a">
  <xsl:value-of select="concat(  'font-weight:'  ,'normal'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'70%'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding-left:'  ,'1em'  ,'; ' )" />
	<xsl:value-of select="concat(  'color:'  ,$colorLink  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__kidurl_linkout-img">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__kidurl_linkout-img" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__kidurl_linkout-img" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__kidurl_linkout-img">
  <xsl:value-of select="string( 'article-base__kidurl_linkout-img' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__kidurl_linkout-img" />
<xsl:variable name="style-lb___article-base__kidurl_linkout-img">
  <xsl:value-of select="concat(  'vertical-align:'  ,'middle'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__thumbnail-img">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__thumbnail-img" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__thumbnail-img" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__thumbnail-img">
  <xsl:value-of select="string( 'article-base__thumbnail-img' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__thumbnail-img" />
<xsl:variable name="style-lb___article-base__thumbnail-img">
  <xsl:value-of select="concat(  'object-fit:'  ,'none'  ,'; ' )" />
  <xsl:value-of select="concat(  'float:'  ,'right'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-base__mediatype_linkout-img">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-base__mediatype_linkout-img" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-base__mediatype_linkout-img" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-base__mediatype_linkout-img">
  <xsl:value-of select="string( 'article-base__mediatype_linkout-img' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-base__mediatype_linkout-img" />
<xsl:variable name="style-lb___article-base__mediatype_linkout-img">
  <xsl:value-of select="concat(  'vertical-align:'  ,'middle'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding-left:'  ,'0.5em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-fulltext__foot-div">
	<xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-fulltext__foot-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-fulltext__foot-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-fulltext__foot-div">
  <xsl:value-of select="string( 'article-fulltext__foot-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-fulltext__foot-div" />
<xsl:variable name="style-lb___article-fulltext__foot-div">
  <xsl:value-of select="concat(  'text-align:'  ,'center'  ,'; ' )" />
  <xsl:value-of select="concat(  'width:'  ,'100%'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-fulltext__foot-span">
	<xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-fulltext__foot-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-fulltext__foot-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-fulltext__foot-span">
  <xsl:value-of select="string( 'article-fulltext__foot-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-fulltext__foot-span" />
<xsl:variable name="style-lb___article-fulltext__foot-span">
</xsl:variable>

<xsl:attribute-set name="article-fulltext__srcurl-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-fulltext__srcurl-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-fulltext__srcurl-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-fulltext__srcurl-div">
  <xsl:value-of select="string( 'article-fulltext__srcurl-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-fulltext__srcurl-div" />
<xsl:variable name="style-lb___article-fulltext__srcurl-div">
	<xsl:value-of select="concat(  'margin:'  ,'1em 0 0 0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-fulltext__srcurl-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-fulltext__srcurl-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-fulltext__srcurl-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-fulltext__srcurl-span">
  <xsl:value-of select="string( 'article-fulltext__srcurl-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-fulltext__srcurl-span" />
<xsl:variable name="style-lb___article-fulltext__srcurl-span">
</xsl:variable>

<xsl:attribute-set name="article-fulltext__srcurl-a">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-fulltext__srcurl-a" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-fulltext__srcurl-a" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-fulltext__srcurl-a">
  <xsl:value-of select="string( 'article-fulltext__srcurl-a' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-fulltext__srcurl-a" />
<xsl:variable name="style-lb___article-fulltext__srcurl-a">
  <xsl:value-of select="concat(  'font-style:'  ,'italic'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__headline-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__headline-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__headline-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__headline-div">
  <xsl:value-of select="string( 'article-slugs__headline-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__headline-div" />
<xsl:variable name="style-lb___article-slugs__headline-div">
	<xsl:value-of select="concat(  'margin:'  ,'0.7em 0 0 0'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding:'  ,'0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__headline-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__headline-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__headline-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__headline-span">
  <xsl:value-of select="string( 'article-slugs__headline-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__headline-span" />
<xsl:variable name="style-lb___article-slugs__headline-span">
  <xsl:value-of select="concat(  'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'1.4em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__subhead-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__subhead-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__subhead-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__subhead-div">
  <xsl:value-of select="string( 'article-slugs__subhead-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__subhead-div" />
<xsl:variable name="style-lb___article-slugs__subhead-div">
  <xsl:value-of select="concat(  'margin:'  ,'0'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding:'  ,'0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__subhead-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__subhead-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__subhead-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__subhead-span">
  <xsl:value-of select="string( 'article-slugs__subhead-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__subhead-span" />
<xsl:variable name="style-lb___article-slugs__subhead-span">
  <xsl:value-of select="concat(  'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__sharing-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__sharing-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__sharing-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__sharing-div">
  <xsl:value-of select="string( 'article-slugs__sharing-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__sharing-div" />
<xsl:variable name="style-lb___article-slugs__sharing-div">
  <xsl:value-of select="concat(  'margin:'  ,'0.4em 0 0 0'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding:'  ,'0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__sharing-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__sharing-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__sharing-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__sharing-span">
  <xsl:value-of select="string( 'article-slugs__sharing-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__sharing-span" />
<xsl:variable name="style-lb___article-slugs__sharing-span">
  <xsl:value-of select="concat(  'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__sharing_big-value-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__sharing_big-value-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__sharing_big-value-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__sharing_big-value-span">
  <xsl:value-of select="string( 'article-slugs__sharing_big-value-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__sharing_big-value-span" />
<xsl:variable name="style-lb___article-slugs__sharing_big-value-span">
</xsl:variable>

<xsl:attribute-set name="article-slugs__sharing_mid-value-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__sharing_mid-value-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__sharing_mid-value-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__sharing_mid-value-span">
  <xsl:value-of select="string( 'article-slugs__sharing_mid-value-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__sharing_mid-value-span" />
<xsl:variable name="style-lb___article-slugs__sharing_mid-value-span">
	<xsl:value-of select="concat(  'opacity:'  ,'1.0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-slugs__sharing_low-value-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-slugs__sharing_low-value-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-slugs__sharing_low-value-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-slugs__sharing_low-value-span">
  <xsl:value-of select="string( 'article-slugs__sharing_low-value-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-slugs__sharing_low-value-span" />
<xsl:variable name="style-lb___article-slugs__sharing_low-value-span">
	<xsl:value-of select="concat(  'opacity:'  ,'1.0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-ricochet__headline-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-ricochet__headline-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-ricochet__headline-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-ricochet__headline-div">
  <xsl:value-of select="string( 'article-ricochet__headline-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-ricochet__headline-div" />
<xsl:variable name="style-lb___article-ricochet__headline-div">
  <xsl:value-of select="concat(  'margin:'  ,'0'  ,'; ' )" />
  <xsl:value-of select="concat(  'padding:'  ,'0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-ricochet__headline-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-ricochet__headline-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-ricochet__headline-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-ricochet__headline-span">
  <xsl:value-of select="string( 'article-ricochet__headline-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-ricochet__headline-span" />
<xsl:variable name="style-lb___article-ricochet__headline-span">
  <xsl:value-of select="concat(  'font-weight:'  ,'bold'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'1.2em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-ricochet__list-item-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-ricochet__list-item-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-ricochet__list-item-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-ricochet__list-item-div">
  <xsl:value-of select="string( 'article-ricochet__list-item-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-ricochet__list-item-div" />
<xsl:variable name="style-lb___article-ricochet__list-item-div">
</xsl:variable>

<xsl:attribute-set name="article-ricochet__list-item-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-ricochet__list-item-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-ricochet__list-item-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-ricochet__list-item-span">
  <xsl:value-of select="string( 'article-ricochet__list-item-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-ricochet__list-item-span" />
<xsl:variable name="style-lb___article-ricochet__list-item-span">
</xsl:variable>

<xsl:attribute-set name="article-ricochet_margin-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-ricochet_margin-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-ricochet_margin-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-ricochet_margin-div">
  <xsl:value-of select="string( 'article-ricochet_margin-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-ricochet_margin-div" />
<xsl:variable name="style-lb___article-ricochet_margin-div">
	<xsl:value-of select="concat(  'font-family:'  ,$fontFamily  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'0.9em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-anchor__headline-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-anchor__headline-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-anchor__headline-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-anchor__headline-div">
  <xsl:value-of select="string( 'article-anchor__headline-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-anchor__headline-div" />
<xsl:variable name="style-lb___article-anchor__headline-div">
  <xsl:value-of select="concat(  'margin:'  ,'0.5em 0 0 0'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-anchor__headline-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-anchor__headline-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-anchor__headline-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-anchor__headline-span">
  <xsl:value-of select="string( 'article-anchor__headline-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-anchor__headline-span" />
<xsl:variable name="style-lb___article-anchor__headline-span">
  <xsl:value-of select="concat(  'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-anchor__headline_nav-a">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-anchor__headline_nav-a" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-anchor__headline_nav-a" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-anchor__headline_nav-a">
  <xsl:value-of select="string( 'article-anchor__headline_nav-a' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-anchor__headline_nav-a" />
<xsl:variable name="style-lb___article-anchor__headline_nav-a">
  <xsl:value-of select="concat(  'color:'  ,$colorLink  ,'; ' )" />
	<xsl:value-of select="concat(  'font-size:'  ,'0.9em'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-style:'  ,'italic'  ,'; ' )" />
	<xsl:value-of select="concat(  'font-weight:'  ,'normal'  ,'; ' )" />
	<xsl:value-of select="concat(  'font-family:'  ,$fontFamily  ,'; ' )" />
  <xsl:value-of select="concat(  'text-decoration:'  ,'none'  ,'; ' )" />
  <xsl:value-of select="concat(  'float:'  ,'right'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-bullets-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-bullets-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-bullets-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-bullets-div">
  <xsl:value-of select="string( 'article-bullets-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-bullets-div" />
<xsl:variable name="style-lb___article-bullets-div">
</xsl:variable>

<xsl:attribute-set name="article-bullets__publication-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-bullets__publication-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-bullets__publication-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-bullets__publication-span">
  <xsl:value-of select="string( 'article-bullets__publication-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-bullets__publication-span" />
<xsl:variable name="style-lb___article-bullets__publication-span">
  <xsl:value-of select="concat(  'margin:'  ,'0em'  ,'; ' )" />
  <xsl:value-of select="concat(  'margin-right:'  ,'0.2em'  ,'; ' )" />
  <xsl:value-of select="concat(  'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="article-bullets__headline-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-bullets__headline-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-bullets__headline-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-bullets__headline-span">
  <xsl:value-of select="string( 'article-bullets__headline-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-bullets__headline-span" />
<xsl:variable name="style-lb___article-bullets__headline-span">
</xsl:variable>

<xsl:attribute-set name="article-bullets__headline_link-a">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___article-bullets__headline_link-a" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___article-bullets__headline_link-a" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___article-bullets__headline_link-a">
  <xsl:value-of select="string( 'article-bullets__headline_link-a' )" />
</xsl:variable>
<xsl:variable name="style-blank___article-bullets__headline_link-a" />
<xsl:variable name="style-lb___article-bullets__headline_link-a">
  <xsl:value-of select="concat(  'color:'  ,$colorLink  ,'; ' )" />
  <xsl:value-of select="concat(  'text-decoration:'  ,'none'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="styleEntity">
  <xsl:value-of select="concat( 'margin-top:'  ,'0.25em'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-bottom:'  ,'1em'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-family:'  ,$fontFamilyBolt  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="tableArticleBlast">
  <xsl:attribute name="class" select="string('tableArticleBlast')" />
  <xsl:attribute name="style" select="$styleTableArticleBlast" />
</xsl:attribute-set>
<xsl:attribute-set name="tableArticleSlugs">
  <xsl:attribute name="class" select="string('tableArticleSlugs')" />
  <xsl:attribute name="style" select="$styleTableArticleSlugs" />
</xsl:attribute-set>
<xsl:attribute-set name="tableArticleExecsum">
  <xsl:attribute name="class" select="string('tableArticleExecsum')" />
  <xsl:attribute name="style" select="$styleTableArticleExecsum" />
</xsl:attribute-set>
<xsl:variable name="styleTableArticleA">
  <!--<xsl:value-of select="concat(  'border-bottom:'  ,'solid 1px '  ,$colorBolt  ,'; ' )" />-->
  <!--<xsl:value-of select="concat(  'padding-bottom:'  ,'1em'  ,'; ' )" />-->
  <!--<xsl:value-of select="concat(  'margin-bottom:'  ,'1.2em'  ,'; ' )" />-->
</xsl:variable>
<xsl:variable name="styleTableArticleBlast">
  <xsl:value-of select="$styleTableArticleA" />
	<xsl:value-of select="concat(  'border-bottom:'  ,'solid 1px '  ,$colorBolt  ,'; ' )" />
</xsl:variable>
<xsl:variable name="styleTableArticleSlugs">
  <xsl:value-of select="$styleTableArticleA" />
	<xsl:value-of select="concat(  'border-bottom:'  ,'solid 1px '  ,$colorBolt  ,'; ' )" />
</xsl:variable>
<xsl:variable name="styleTableArticleExecsum">
  <xsl:value-of select="$styleTableArticleA" />
	<xsl:value-of select="concat(  'border-bottom:'  ,'solid 1px '  ,$colorBolt  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="tdThumbnailSlugs">
  <xsl:attribute name="class" select="$tdThumbnailSlugs--name" />
  <xsl:attribute name="width" select="string('*')" />
  <xsl:attribute name="align" select="string('right')" />
  <xsl:attribute name="valign" select="string('top')" />
  <xsl:attribute name="style" select="$tdThumbnailSlugs--style" />
</xsl:attribute-set>
<xsl:variable name="tdThumbnailSlugs--name" select="string( 'tdThumbnailSlugs' )" />
<xsl:variable name="tdThumbnailSlugs--style">
  <xsl:value-of select="concat(  'text-align:'  ,'right'  ,'; ' )" />
</xsl:variable>

<!-- ######## ~ Attribute sets ~~ Sections, issues, grouping ############### -->
<xsl:attribute-set name="tdDefaultCopyright">
</xsl:attribute-set>

<xsl:attribute-set name="tdSectHead">
  <xsl:attribute name="class" select="string('tdSectHead')" />
  <xsl:attribute name="style" select="$styleTdSectHead" />
</xsl:attribute-set>
<xsl:variable name="styleTdSectHead">
  <xsl:value-of select="concat( 'display:'  ,'block'  ,'; ' )" />
  <xsl:value-of select="concat( 'clear:'  ,'both'  ,'; ' )" />
  <xsl:value-of select="concat( 'max-width:'  ,$max-width  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-left:'  ,'1em'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding-right:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="div___section__head_margin">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___section__head_margin" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___section__head_margin" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___section__head_margin">
  <xsl:value-of select="string( 'section__head_margin' )" />
</xsl:variable>
<xsl:variable name="style-blank___section__head_margin" />
<xsl:variable name="style-lb___section__head_margin">
	<xsl:value-of select="concat(  'font-family:'  ,$fontFamily  ,'; ' )" />
  <xsl:value-of select="concat(  'font-size:'  ,'1.2em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="td___issue__head">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___issue__head" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___issue__head" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___issue__head">
  <xsl:value-of select="string( 'issue__head' )" />
</xsl:variable>
<xsl:variable name="style-blank___issue__head" />
<xsl:variable name="style-lb___issue__head">
  <xsl:value-of select="concat(  'display:'  ,'block'  ,'; ' )" />
  <xsl:value-of select="concat(  'clear:'  ,'both'  ,'; ' )" />
  <xsl:value-of select="concat(  'max-width:'  ,$max-width  ,'; ' )" />
  <xsl:value-of select="concat(  'padding-right:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="td___issue__head_extra-indent">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___issue__head_extra-indent" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___issue__head_extra-indent" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___issue__head_extra-indent">
  <xsl:value-of select="string( 'issue__head_extra-indent' )" />
</xsl:variable>
<xsl:variable name="style-blank___issue__head_extra-indent" />
<xsl:variable name="style-lb___issue__head_extra-indent">
  <xsl:value-of select="concat(  'padding-left:'  ,'2em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="td___issue__head_std-indent">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___issue__head_std-indent" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___issue__head_std-indent" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___issue__head_std-indent">
  <xsl:value-of select="string( 'issue__head_std-indent' )" />
</xsl:variable>
<xsl:variable name="style-blank___issue__head_std-indent" />
<xsl:variable name="style-lb___issue__head_std-indent">
  <xsl:value-of select="concat(  'padding-left:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="span___issue__title">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___issue__title" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___issue__title" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___issue__title">
  <xsl:value-of select="string( 'issue__title' )" />
</xsl:variable>
<xsl:variable name="style-blank___issue__title" />
<xsl:variable name="style-lb___issue__title">
  <xsl:value-of select="concat(  'font-size:'  ,$fontSizeSubHead  ,'; ' )" />
  <xsl:value-of select="concat(  'font-weight:'  ,$fontWeightHead  ,'; ' )" />
  <xsl:value-of select="concat(  'color:'  ,$colorLink  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="td___issue__body">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___issue__body" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___issue__body" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___issue__body">
  <xsl:value-of select="string( 'issue__body' )" />
</xsl:variable>
<xsl:variable name="style-blank___issue__body" />
<xsl:variable name="style-lb___issue__body">
  <xsl:value-of select="concat(  'padding-left:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="div___issue__content-item">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___issue__content-item" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___issue__content-item" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___issue__content-item">
  <xsl:value-of select="string( 'issue__content-item' )" />
</xsl:variable>
<xsl:variable name="style-blank___issue__content-item" />
<xsl:variable name="style-lb___issue__content-item">
  <xsl:value-of select="concat(  'padding-left:'  ,'1.25em'  ,'; ' )" />
</xsl:variable>

<!-- ######## ~ Attribute sets ~~ Report ################################### -->
<xsl:attribute-set name="bodyTag">
  <xsl:attribute name="style" select="$styleBody" />
</xsl:attribute-set>
<xsl:variable name="styleBody">
  <xsl:value-of select="concat( 'font-family:'  ,$fontFamily  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,$fontSize  ,'; ' )" />
  <xsl:value-of select="concat( 'color:'  ,$colorText  ,'; ' )" />
  <xsl:value-of select="concat( 'background-color:'  ,$bgcolorNlFrame  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="bodyTable">
  <xsl:attribute name="class" select="string('body')" />
  <xsl:attribute name="style" select="$styleBgcolorNlFrame" />
</xsl:attribute-set>
<xsl:variable name="styleBgcolorNlFrame">
  <xsl:value-of select="concat(  'background-color:'  ,$bgcolorNlFrame  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="trHead">
  <xsl:attribute name="style">
    <xsl:value-of select="concat(  'height:'  ,'1px'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="nlFrameColumn">
  <xsl:attribute name="style">
    <xsl:value-of select="concat(  'width:'  ,'auto'  ,'; ' )" />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="nlMainColumn">
  <xsl:attribute name="style">
    <xsl:value-of select="$styleNlMainCol"  />
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="nlMainColWindow">
  <xsl:attribute name="style">
    <xsl:value-of select="$styleNlMainCol"  />
    <xsl:value-of select="$styleBgcolorContent"  />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="styleNlMainCol">
  <xsl:value-of select="concat( 'max-width:'  ,$max-width  ,' !important'  ,'; ' )" />
  <xsl:value-of select="concat( 'min-width:'  ,$min-width  ,' !important'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin:'  ,'0'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding:'  ,'0'  ,'; ' )" />
</xsl:variable>
<xsl:variable name="styleBgcolorContent">
  <xsl:value-of select="concat(  'background-color:'  ,$bgcolorContent  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="tdHead">
  <xsl:attribute name="class" select="$nameTdHead" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="style" select="$styleTdHead" />
</xsl:attribute-set>
<xsl:variable name="nameTdHead">
  <xsl:value-of select="string('tdHead')"  />
</xsl:variable>
<xsl:variable name="styleTdHead">
  <xsl:value-of select="concat( 'display:'  ,'block'  ,'; ' )" />
  <xsl:value-of select="concat( 'clear:'  ,'both'  ,'; ' )" />
  <xsl:value-of select="concat( 'line-height:'  ,'1.8'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="tdReportNav">
  <xsl:attribute name="class" select="string('nlNav')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="style" select="$styleNav" />
</xsl:attribute-set>
<xsl:variable name="styleNav">
  <xsl:value-of select="concat( 'text-align:'  ,'center'  ,'; ' )" />
  <xsl:value-of select="concat( 'background-color:'  ,$bgcolorNav  ,'; ' )" />
  <xsl:value-of select="concat( 'height:'  ,'3.75em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="td___report__foot">
	<xsl:attribute name="colspan">
		<xsl:value-of select="string('2')" />
	</xsl:attribute>
	<xsl:attribute name="style">
    <xsl:value-of select="$style-lb___report__foot" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___report__foot" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___report__foot">
  <xsl:value-of select="string( 'report__foot' )" />
</xsl:variable>
<xsl:variable name="style-blank___report__foot" />
<xsl:variable name="style-lb___report__foot">
  <xsl:value-of select="concat(  'padding:'  ,'1em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="a___nav_link">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___nav_link" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___nav_link" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___nav_link">
  <xsl:value-of select="string( 'nav_link' )" />
</xsl:variable>
<xsl:variable name="style-blank___nav_link" />
<xsl:variable name="style-lb___nav_link">
  <xsl:value-of select="concat( 'color:'  ,$colorText  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-left:'  ,'3px'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-right:'  ,'3px'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-weight:'  ,'bold'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="tdTopMsg">
  <xsl:attribute name="class" select="string('nlTopMsg nlNav')" />
  <xsl:attribute name="align" select="string('center')" />
  <xsl:attribute name="style" select="$styleTopMsg" />
</xsl:attribute-set>
<xsl:variable name="styleTopMsg">
  <xsl:value-of select="$styleNav"  />
  <xsl:value-of select="concat( 'border-bottom:'  ,'1px dotted'  ,'; ' )" />
</xsl:variable>

<xsl:variable name="styleMobilePref">
  <xsl:value-of select="concat( 'width:'  ,'100%'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin:'  ,'0'  ,'; ' )" />
  <xsl:value-of select="concat( 'padding:'  ,'0'  ,'; ' )" />
  <xsl:value-of select="concat( 'text-align:'  ,'center'  ,'; ' )" />
  <xsl:value-of select="concat( 'font-size:'  ,'0.7777777em'  ,'; ' )" />
	<xsl:value-of select="concat( 'font-family:'  ,$fontFamily  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="imgReportHead">
  <xsl:attribute name="class" select="string('imgReportHead')" />
  <xsl:attribute name="border" select="0" />
  <xsl:attribute name="style" select="$styleImgReportHead" />
</xsl:attribute-set>
<xsl:variable name="styleImgReportHead">
  <xsl:value-of select="concat( 'max-width:'  ,$headerImageMaxWidth  ,' !important'  ,'; ' )" />
  <xsl:value-of select="concat( 'display:'  ,'block'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-left:'  ,'auto'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-right:'  ,'auto'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-top:'  ,'0.7em'  ,'; ' )" />
  <xsl:value-of select="concat( 'margin-bottom:'  ,'0.7em'  ,'; ' )" />
  <xsl:value-of select="concat(	'max-width:'  ,'100%'  ,'; ' )" />
	<xsl:value-of select="concat(	'height:'  ,'auto'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="empty-letter-div">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___empty-letter-div" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___empty-letter-div" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___empty-letter-div">
  <xsl:value-of select="string( 'empty-letter-div' )" />
</xsl:variable>
<xsl:variable name="style-blank___empty-letter-div" />
<xsl:variable name="style-lb___empty-letter-div">
  <xsl:value-of select="concat(  'text-align:'  ,'center'  ,'; ' )" />
  <xsl:value-of select="concat(  'margin:'  ,'2em'  ,'; ' )" />
</xsl:variable>

<xsl:attribute-set name="empty-letter-span">
  <xsl:attribute name="style">
    <xsl:value-of select="$style-lb___empty-letter-span" />
  </xsl:attribute>
  <xsl:attribute name="class">
    <xsl:value-of select="$name___empty-letter-span" />
  </xsl:attribute>
</xsl:attribute-set>
<xsl:variable name="name___empty-letter-span">
  <xsl:value-of select="string( 'empty-letter-span' )" />
</xsl:variable>
<xsl:variable name="style-blank___empty-letter-span" />
<xsl:variable name="style-lb___empty-letter-span">
</xsl:variable>

<!-- ######## ~ Templates ################################################## -->
<xsl:output method="html" indent="yes" encoding="utf-8" />

<!-- NOTES-ON match="/"
- added width, margin, padding styles to bottom-center td
- changed left three & right three td width to auto from 50%
- TO-DO: work out kinks of new content-block logic
- TO-DO: relative links from one block to another
- TO-DO: how to define blocks in nl setup options?
- TO-DO: add width for %, use max/min for px (Carlyle)
- TO-DO: make more templates to break this up? remove (most) HTML?
-->
<xsl:template match="/">
	<xsl:param name="myName" select="string('report')" />
  <meta name="apple-itunes-app" content="app-id=1450569477" />
  <body xsl:use-attribute-sets="bodyTag" lbname="{$myName}">
    <table xsl:use-attribute-sets="table bodyTable" lbname="{$myName}">
      <tr xsl:use-attribute-sets="trHead" lbname="{$myName}">
        <th xsl:use-attribute-sets="nlFrameColumn" lbname="{$myName}" />
        <th xsl:use-attribute-sets="nlMainColWindow" lbname="{$myName}" />
        <th xsl:use-attribute-sets="nlFrameColumn" lbname="{$myName}" />
      </tr>
      <tr lbname="{$myName}">
        <td xsl:use-attribute-sets="nlFrameColumn" lbname="{$myName}">
          <xsl:value-of select="$text___nbsp" />
        </td>
        <td xsl:use-attribute-sets="nlMainColWindow" lbname="{$myName}">
          <xsl:call-template name="do-mobile-link" />
          <table xsl:use-attribute-sets="table" lbname="{$myName}">
            <xsl:call-template name="do-report-head" />
            <xsl:if test="not(number($execSectID) = 1)">
              <xsl:apply-templates select="$allowedArticles[number(SECTION/@ID)=number($execSectID)]" mode="execsum">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
              </xsl:apply-templates>
            </xsl:if>
            <xsl:call-template name="do-top-msg" />
            <xsl:call-template name="do-section-nav" />
            <xsl:call-template name="do-empty-letter" />
            <xsl:call-template name="do-content" />
            <xsl:call-template name="do-report-foot"/>
          </table>
        </td>
        <td xsl:use-attribute-sets="nlFrameColumn" lbname="{$myName}">
          <xsl:value-of select="$text___nbsp" />
        </td>
      </tr>
      <tr lbname="{$myName}">
        <td xsl:use-attribute-sets="nlFrameColumn" lbname="{$myName}">
          <xsl:value-of select="$text___nbsp" />
        </td>
        <td xsl:use-attribute-sets="nlMainColumn" lbname="{$myName}">
          <table xsl:use-attribute-sets="table" lbname="{$myName}">
            <xsl:call-template name="do-page-foot" />
          </table>
        </td>
        <td xsl:use-attribute-sets="nlFrameColumn" lbname="{$myName}">
          <xsl:value-of select="$text___nbsp" />
        </td>
      </tr>
    </table>
  </body>
</xsl:template>

<!-- NOTES-ON "do-content"
-
-->
<xsl:template name="do-content">
	<xsl:param name="myName" select="string('do-content')" />
	<xsl:param name="param___style" select="$style" />
	<!--<xsl:call-template name="do-article-groups" />-->
  <xsl:call-template name="do-content-block">
    <xsl:with-param name="param___block-style" select="$param___style" />
  </xsl:call-template>
  <xsl:if test="xs:boolean($doFT)">
    <xsl:call-template name="do-content-block">
      <xsl:with-param name="param___block-style" select="string('fulltext')" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON "do-content-block"
-
-->
<xsl:template name="do-content-block">
	<xsl:param name="myName" select="string('do-content-block')" />
  <xsl:param name="param___block-style" select="$style" />
  <xsl:call-template name="do-top-stories">
    <xsl:with-param name="type" select="$param___block-style" />
  </xsl:call-template>
  <xsl:apply-templates select="$sectList" mode="process">
    <xsl:with-param name="param___block-style" select="$param___block-style" />
    <xsl:sort select="ORDINAL" data-type="number" />
  </xsl:apply-templates>
</xsl:template>

<!-- NOTES-ON name="do-top-stories"
- added do-default-copyright
-->
<xsl:template name="do-top-stories">
	<xsl:param name="myName" select="string('do-top-stories')" />
  <xsl:param name="type" select="$style" />
  <xsl:if test="$topStories">
    <xsl:call-template name="do-section-head">
      <xsl:with-param name="sectName" select="$topStoriesLabel" />
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="number($execSectID) = 1">
        <xsl:apply-templates select="$topStories" mode="execsum">
          <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$type = 'bullets'">
        <xsl:apply-templates select="$topStories" mode="bullets">
          <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$type = 'slugs'">
        <xsl:apply-templates select="$topStories" mode="slugs">
          <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$type = 'blast'">
        <xsl:apply-templates select="$topStories" mode="blast">
          <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="string-length($defaultCopyright) &gt; 0 and count($topStories) &gt; 0">
          <xsl:call-template name="do-default-copyright" />
        </xsl:if>
        <xsl:apply-templates select="$topStories" mode="fulltext">
          <xsl:sort select="@TOPSTORY" data-type="number" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON match="SECTION" mode="process"
-
-->
<xsl:template match="SECTION" mode="process">
	<xsl:param name="myName" select="string('section-process')" />
  <xsl:param name="param___block-style" select="$style" />
	<xsl:param name="param___block-title" select="NAME" />
  <xsl:variable name="sid" select="ID" />
  <xsl:variable name="candidateArticles" select="if (number($extOverOrdinal) = number($extOverOrdinal)) then
    $allowedArticles[SECTION/@ID=$sid][not(@PARENT!=0)][number(SECTION/@ORDINAL) &lt;= number($extOverOrdinal)] else
    $allowedArticles[SECTION/@ID=$sid][not(@PARENT!=0)]" />
  <xsl:variable name="heldArticles" select="if (number($extOverOrdinal) = number($extOverOrdinal)) then
    $allowedArticles[SECTION/@ID=$sid][not(@PARENT!=0)][number(SECTION/@ORDINAL) &gt; number($extOverOrdinal)] else
    $allowedArticles[@ID=0]" />
  <xsl:variable name="sArticles" select="if ($dupeTop and $param___block-style!='fulltext') then $candidateArticles else $candidateArticles[not(@TOPSTORY!=0)]" />
  <xsl:variable name="issSArticles" select="$sArticles[@ID=$nlIssues/ARTICLE/@ID]" />
  <xsl:variable name="issList" select="$nlIssues[ARTICLE/@ID=$issSArticles/@ID]" />
  <xsl:variable name="non-issSArticles" select="$sArticles[not(@ID=$issSArticles/@ID)]" />
	<xsl:if test="string-length($defaultCopyright) &gt; 0 and count($sArticles) &gt; 0 and $param___block-style = 'fulltext'">
		<xsl:call-template name="do-default-copyright" />
	</xsl:if>
	<xsl:if test="count($sArticles[not(@TOPSTORY!=0)]) &gt; 0 or xs:boolean($sectEmptyFlag)">
		<xsl:call-template name="do-section-head">
			<xsl:with-param name="sid" select="$sid" />
			<xsl:with-param name="sectName" select="$param___block-title" />
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="count($sArticles[not(@TOPSTORY!=0)]) = 0 and xs:boolean($sectEmptyFlag)">
    <xsl:call-template name="do-empty-section" />
  </xsl:if>
	<xsl:apply-templates select="$issList">
    <xsl:with-param name="type" select="$param___block-style" />
    <xsl:with-param name="iArticles" select="$issSArticles" />
    <xsl:sort select="@ORDINAL" data-type="number" />
  </xsl:apply-templates>
	<xsl:if test="$non-issSArticles and $issSArticles">
		<xsl:call-template name="do-issue-head">
			<xsl:with-param name="issName" select="replace( $text___section-issue__title_remaining-content ,$text___section-issue__title_swap ,$param___block-title )" />
      <xsl:with-param name="param___alt-style" select="true()" />
		</xsl:call-template>
	</xsl:if>
	<xsl:choose>
    <xsl:when test="$param___block-style = 'bullets'">
      <xsl:apply-templates select="$non-issSArticles" mode="bullets">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$param___block-style = 'slugs'">
      <xsl:apply-templates select="$non-issSArticles" mode="slugs">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$param___block-style = 'blast'">
      <xsl:apply-templates select="$non-issSArticles" mode="blast">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$non-issSArticles" mode="fulltext">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="count($heldArticles) &gt; 0 and $bHosted">
    <xsl:call-template name="do-held-articles">
      <xsl:with-param name="heldArticles" select="$heldArticles" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON do-article-groups"
-

<xsl:key name="file-by-date" match="ARTICLE" use="substring(INSERTED, 1, 10)" />
<xsl:template name="do-article-groups">
	<xsl:param name="myName" select="string('do-article-groups')" />
  <xsl:param name="param___block-style" select="$style" />
  <xsl:param name="param___block-id" />
	<xsl:param name="param___block-title" />
  <xsl:variable name="candidateArticles" select="if (number($extOverOrdinal) = number($extOverOrdinal)) then
    $allowedArticles[not(@PARENT!=0)][number(SECTION/@ORDINAL) &lt;= number($extOverOrdinal)] else
    $allowedArticles[not(@PARENT!=0)]" />
  <xsl:variable name="heldArticles" select="if (number($extOverOrdinal) = number($extOverOrdinal)) then
    $allowedArticles[not(@PARENT!=0)][number(SECTION/@ORDINAL) &gt; number($extOverOrdinal)] else
    $allowedArticles[@ID=0]" />
  <xsl:variable name="sArticles" select="if ($dupeTop and $param___block-style!='fulltext') then $candidateArticles else $candidateArticles[not(@TOPSTORY!=0)]" />
  <xsl:variable name="issSArticles" select="$sArticles[@ID=$nlIssues/ARTICLE/@ID]" />
  <xsl:variable name="issList" select="$nlIssues[ARTICLE/@ID=$issSArticles/@ID]" />
  <xsl:variable name="non-issSArticles" select="$sArticles[not(@ID=$issSArticles/@ID)]" />
	<xsl:for-each select="$sArticles[count(. | key('file-by-date', substring(INSERTED, 1, 10))[1]) = 1]">
		<xsl:sort select="INSERTED" data-type="text" order="descending" />
		<xsl:apply-templates select="." mode="head" />
		<xsl:apply-templates select="key('file-by-date', substring(INSERTED, 1, 10))" mode="blast">
			<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
			<xsl:sort select="@ID" data-type="number" order="descending" />
		</xsl:apply-templates>
	</xsl:for-each>
</xsl:template>
-->

<!-- NOTES-ON process-articles-block
-

<xsl:template name="process-articles-block">
	<xsl:param name="param___block-title" />
  <xsl:param name="param___block-style" />
  <xsl:param name="param___block-id" />
  <xsl:param name="candidateArticles___param" />
  <xsl:param name="heldArticles___param" />
  <xsl:param name="sArticles___param" />
  <xsl:param name="issSArticles___param" />
  <xsl:param name="issList___param" />
  <xsl:param name="non-issSArticles___param" />
	<xsl:if test="string-length($defaultCopyright) &gt; 0 and count($sArticles___param) &gt; 0 and $param___block-style = 'fulltext'">
		<xsl:call-template name="do-default-copyright" />
	</xsl:if>
	<xsl:if test="count($sArticles___param[not(@TOPSTORY!=0)]) &gt; 0 or xs:boolean($sectEmptyFlag)">
		<xsl:call-template name="do-section-head">
			<xsl:with-param name="sid" select="$param___block-id" />
			<xsl:with-param name="sectName" select="$param___block-title" />
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="count($sArticles___param[not(@TOPSTORY!=0)]) = 0 and xs:boolean($sectEmptyFlag)">
    <xsl:call-template name="do-empty-section" />
  </xsl:if>
	<xsl:apply-templates select="$issList___param">
    <xsl:with-param name="type" select="$param___block-style" />
    <xsl:with-param name="iArticles" select="$issSArticles___param" />
    <xsl:sort select="@ORDINAL" data-type="number" />
  </xsl:apply-templates>
	<xsl:if test="$non-issSArticles___param and $issSArticles___param">
		<xsl:call-template name="do-issue-head">
			<xsl:with-param name="issName" select="replace( $text___section-issue__title_remaining-content ,'SECTION_NAME' ,$param___block-title )" />
		</xsl:call-template>
	</xsl:if>
	<xsl:choose>
    <xsl:when test="$param___block-style = 'bullets'">
      <xsl:apply-templates select="$non-issSArticles___param" mode="bullets">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$param___block-style = 'slugs'">
      <xsl:apply-templates select="$non-issSArticles___param" mode="slugs">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$param___block-style = 'blast'">
      <xsl:apply-templates select="$non-issSArticles___param" mode="blast">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$non-issSArticles___param" mode="fulltext">
				<xsl:sort select="SECTION/@ORDINAL" data-type="number" />
				<xsl:sort select="@ID" data-type="number" order="descending" />
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="count($heldArticles___param) &gt; 0 and $bHosted">
    <xsl:call-template name="do-held-articles">
      <xsl:with-param name="heldArticles" select="$heldArticles___param" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>
-->

<!-- NOTES-ON match="ISSUE"
- TO-DO: can i collapse nl variants into one, removing xsl:choose ?
	Results are negative, so far.
- TO-DO: should dif block varieties get their own issue formats ?
- TO-DO: should i separate the logic and HTML ?
-->
<xsl:template match="ISSUE">
	<xsl:param name="myName" select="string('issue')" />
  <xsl:param name="type" select="$style" />
  <xsl:param name="iArticles" />
  <xsl:variable name="iid" select="@ID" />
  <xsl:call-template name="do-issue-head">
    <xsl:with-param name="issName" select="@NAME" />
  </xsl:call-template>
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="td___issue__body" lbname="{$myName}">
      <table xsl:use-attribute-sets="table" lbname="{$myName}">
        <xsl:choose>
          <xsl:when test="$type = 'slugs'">
            <div xsl:use-attribute-sets="div___issue__content-item" lbname="{$myName}">
              <xsl:apply-templates select="$iArticles[@ID=$nlIssues[@ID=$iid]/ARTICLE/@ID]" mode="slugs">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                <xsl:sort select="@ID" data-type="number" order="descending" />
              </xsl:apply-templates>
            </div>
          </xsl:when>
          <xsl:when test="$type = 'bullets'">
            <div xsl:use-attribute-sets="div___issue__content-item" lbname="{$myName}">
              <xsl:apply-templates select="$iArticles[@ID=$nlIssues[@ID=$iid]/ARTICLE/@ID]" mode="bullets">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                <xsl:sort select="@ID" data-type="number" order="descending" />
              </xsl:apply-templates>
            </div>
          </xsl:when>
          <xsl:when test="$type = 'blast'">
            <div xsl:use-attribute-sets="div___issue__content-item" lbname="{$myName}">
              <xsl:apply-templates select="$iArticles[@ID=$nlIssues[@ID=$iid]/ARTICLE/@ID]" mode="blast">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                <xsl:sort select="@ID" data-type="number" order="descending" />
              </xsl:apply-templates>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$iArticles[@ID=$nlIssues[@ID=$iid]/ARTICLE/@ID]" mode="fulltext">
              <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
              <xsl:sort select="@ID" data-type="number" order="descending" />
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </table>
    </td>
  </tr>
</xsl:template>

<!-- ########## LOGIC ABOVE ################# -->
<!-- ########## OUTPUT BELOW ################ -->

<!-- NOTES-ON match="SECTION" mode="nav"
-
-->
<xsl:template match="SECTION" mode="nav">
	<xsl:param name="myName" select="string('section-nav')" />
  <a xsl:use-attribute-sets="a___nav_link" lbname="{$myName}">
    <xsl:attribute name="href" select="concat('#sect' ,ID)" />
    <xsl:value-of disable-output-escaping="yes" select="NAME" />
  </a>
  <xsl:if test="position() != last()">
    <xsl:value-of select="$text___nav_list-separator" />
  </xsl:if>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="fulltext"
-
-->
<xsl:template match="ARTICLE" mode="fulltext">
	<xsl:param name="myName" select="string('article-fulltext')" />
  <xsl:variable name="id" select="@ID" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
      <div lbname="{$myName}">
        <xsl:apply-templates select="HEADLINE" mode="anchor"/>
        <xsl:apply-templates select="." mode="bolt" />
        <xsl:choose>
          <xsl:when test="SRCURL/@REDIRECT=1">
            <xsl:apply-templates select="ABSTRACT" />
            <xsl:apply-templates select="SRCURL" mode="rights" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="PUBCOPYRIGHT" />
            <xsl:call-template name="ARTICLEBODY">
              <xsl:with-param name="article" select="$FTXML/CLIPSHEET/ARTICLE[@ID=$id]/ARTICLEBODY" />
            </xsl:call-template>
            <xsl:if test="$showSource">
              <xsl:apply-templates select="SRCURL" mode="site" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <div xsl:use-attribute-sets="article-fulltext__foot-div" lbname="{$myName}">
					<span xsl:use-attribute-sets="article-fulltext__foot-span" lbname="{$myName}">
          	<xsl:value-of select="$text___article-fulltext__foot" />
					</span>
        </div>
      </div>
    </td>
  </tr>
  <xsl:if test="not($extRelated)">
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <xsl:apply-templates select="$children" mode="fulltext">
      <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
      <xsl:sort select="@ID" data-type="number" order="descending" />
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="bullets"
- TO-DO: <hr> styling, can it be moved out of here?
-->
<xsl:template match="ARTICLE" mode="bullets">
	<xsl:param name="myName" select="string('article-bullets')" />
  <xsl:param name="bHR" select="xs:boolean(position() != 1)" />
  <xsl:variable name="id" select="@ID" />
  <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent article-bullets-td" lbname="{$myName}">
			<div xsl:use-attribute-sets="article-bullets-div" lbname="{$myName}">
	      <a name="{concat('top',$id)}" lbname="{$myName}" />
	      <xsl:if test="$bHR">
	        <hr style="margin:0;padding:0;" lbname="{$myName}" />
	      </xsl:if>
	      <xsl:apply-templates select="PUBLICATION" mode="bullets" />
	      <xsl:apply-templates select="HEADLINE" mode="bullets" />
	      <xsl:if test="$mediaType">
	        <xsl:apply-templates select="@MEDIAID[.!=0]" />
	      </xsl:if>
	      <xsl:if test="$doTags">
	        <xsl:call-template name="do-tags">
	          <xsl:with-param name="AID" select="$id" />
	        </xsl:call-template>
	      </xsl:if>
			</div>
    </td>
  </tr>
  <xsl:if test="not($extRelated)">
  <xsl:apply-templates select="$children" mode="bullets">
    <xsl:with-param name="bHR" select="true()" />
    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
    <xsl:sort select="@ID" data-type="number" order="descending" />
  </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="slugs"
-
-->
<xsl:template match="ARTICLE" mode="slugs">
	<xsl:param name="myName" select="string('article-slugs')" />
  <xsl:variable name="id" select="@ID" />
  <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
      <a name="{concat('top',$id)}" lbname="{$myName}" />
      <table xsl:use-attribute-sets="table tableArticleSlugs" lbname="{$myName}">
        <tr lbname="{$myName}">
          <td xsl:use-attribute-sets="article-base-td" lbname="{$myName}">
            <xsl:if test="string-length(THUMBNAIL) &gt; 0">
              <xsl:attribute name="colspan" select="string('2')" />
            </xsl:if>
            <xsl:apply-templates select="HEADLINE" mode="slugs" />
            <xsl:if test="$mediaType">
              <xsl:apply-templates select="@MEDIAID[.!=0]" />
            </xsl:if>
            <xsl:if test="$doTags">
              <xsl:call-template name="do-tags">
                <xsl:with-param name="AID" select="$id" />
              </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="SUBHEAD" mode="slugs" />
            <xsl:apply-templates select="." mode="bolt" />
            <xsl:if test="count($children) &gt; 0">
              <table xsl:use-attribute-sets="table" lbname="{$myName}">
                <xsl:apply-templates select="$children" mode="ricochet">
                  <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                  <xsl:sort select="@ID" data-type="number" order="descending" />
                </xsl:apply-templates>
              </table>
            </xsl:if>
            <xsl:apply-templates select="." mode="buildurl" />
          </td>
          <xsl:if test="string-length(THUMBNAIL) &gt; 0">
            <td xsl:use-attribute-sets="tdThumbnailSlugs" lbname="{$myName}">
              <xsl:apply-templates select="THUMBNAIL" />
            </td>
          </xsl:if>
        </tr>
      </table>
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="ricochet"
- TO-DO: extend attributes to second td?
  Testing has shown no difference so far (Outlook on Win, html in Chrome)
-->
<xsl:template match="ARTICLE" mode="ricochet">
	<xsl:param name="myName" select="string('article-ricochet')" />
  <xsl:variable name="id" select="@ID" />
	<tr lbname="{$myName}">
		<td lbname="{$myName}">
			<div xsl:use-attribute-sets="article-ricochet_margin-div" lbname="{$myName}">
				<xsl:value-of select="$text___nbsp" />
			</div>
		</td>
	</tr>
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="article-base-td article-ricochet-td" lbname="{$myName}">
			<div xsl:use-attribute-sets="article-ricochet__list-item-div" lbname="{$myName}">
	      <a name="{concat('top',$id)}" lbname="{$myName}" />
	      <span xsl:use-attribute-sets="article-ricochet__list-item-span" lbname="{$myName}">
	        <xsl:value-of select="$text___article-ricochet_list-bullet" />
					<xsl:value-of select="$text___nbsp" />
	      </span>
			</div>
    </td>
    <td xsl:use-attribute-sets="article-ricochet-td" lbname="{$myName}">
      <xsl:apply-templates select="HEADLINE" mode="ricochet" />
      <xsl:apply-templates select="." mode="bolt" />
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="blast"
- made headlines into links
- removed article-base-td as attribute set from td within table
	(this removes align=top)
- TO-DO: try again to move bottom break line from table to hr
- TO-DO: allow choices on how to do links (in-headline or after abstract)
- TO-DO: fix up doSharesBool and doEntities logic
- TO-DO: fix up application of style
- TO-DO: merge headline-slugs and the headline buildurl section below
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

<!-- NOTES-ON match="ARTICLE" mode="execsum"
-
-->
<xsl:template match="ARTICLE" mode="execsum">
	<xsl:param name="myName" select="string('article-execsum')" />
  <xsl:variable name="id" select="@ID" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
      <table xsl:use-attribute-sets="table tableArticleExecsum" lbname="{$myName}">
        <tr lbname="{$myName}">
          <td xsl:use-attribute-sets="article-base-td" lbname="{$myName}">
            <xsl:if test="$bBlastThumbs">
              <xsl:apply-templates select="THUMBNAIL" />
            </xsl:if>
            <xsl:apply-templates select="HEADLINE" mode="slugs" />
            <xsl:if test="$doTags">
              <xsl:call-template name="do-tags">
                <xsl:with-param name="AID" select="$id" />
              </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="ABSTRACT" />
          </td>
        </tr>
      </table>
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="buildurl"
Sheesh. CONSOLIDATE FUNCTIONS ACROSS covid-19, PG2_WatchReport, WR1, etc
- DID I BREAK links to pubtool for articles with no web/source url? see playground2 2020-03-03 articles
  - TO-DO: how to make headline into link?
    see prev examples (Danone, General Atlantic, Carlyle)
  - TO-DO: rework "related articles" count to be like held articles,
    and move to separate template if possible
  - TO-DO: add ability to suppress/restyle linkout icon
  - TO-DO: pull out styles
-->
<xsl:template match="ARTICLE" mode="buildurl">
		<xsl:param name="myName" select="string('article-buildurl')" />
    <xsl:param name="linkText" select="string('View Full Coverage')" />
    <xsl:param name="linkColor" select="$colorLink" />
    <xsl:param name="suppressLinkoutIcon" select="true()" />
    <xsl:variable name="id" select="@ID" />
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <xsl:choose>
        <xsl:when test="$doFT and not (SRCURL/@REDIRECT=1)">
            <a lbname="{$myName}">
                <xsl:attribute name="href" select="concat('#',./@ID)" />
                <xsl:attribute name="name" select="concat('top',./@ID)" />
                <xsl:attribute name="style" select="concat('color:',$linkColor,';','font-family:',$fontFamily,';')" />
                <xsl:value-of select="$linkText" />
            </a>
        </xsl:when>
        <xsl:when test="$bHosted and not (SRCURL/@REDIRECT=1) and not ($preferSrc)">
            <a lbname="{$myName}">
                <xsl:attribute name="href" select="concat($hostroot,./@ID)" />
                <xsl:attribute name="style" select="concat('color:',$linkColor,';','font-family:',$fontFamily,';')" />
                <xsl:value-of select="$linkText" />
            </a>
        </xsl:when>
        <xsl:when test="SRCURL/@REDIRECT=1 or $preferSrc">
            <a lbname="{$myName}">
            <xsl:choose>
                <xsl:when test ="$preferSrc and string-length(AGTURL) &gt; 4 and not (SRCURL/@REDIRECT=1) and not (string-length(WEBURL) &gt; 4)">
                    <xsl:attribute name="href" select="concat($hostroot,./@ID)" />
                    <xsl:attribute name="style" select="concat('color:',$linkColor,';','font-family:',$fontFamily,';')" />
                </xsl:when>
                <xsl:when test = "$suppressLinkoutIcon">
                    <xsl:attribute name="href" select="SRCURL" />
                    <xsl:attribute name="style" select="concat('color:',$linkColor,';','font-family:',$fontFamily,';')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="href" select="SRCURL" />
                    <xsl:attribute name="style" select="concat('color:',$linkColor,';','font-family:',$fontFamily,';')" />
                    <img src="{$linkImgURL}" style="vertical-align:middle;" lbname="{$myName}"/>
                </xsl:otherwise>
            </xsl:choose>
                <xsl:value-of select="$linkText" />
            </a>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$extRelated and count($children) &gt; 0">
        <span class="extrelated" style="font-size:90%;font-style:italic;padding-left:1em;" lbname="{$myName}">
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
<!--
<xsl:template match="ARTICLE" mode="buildurl">
    <xsl:param name="linkText" select="string('View Full Coverage')" />
    <xsl:variable name="id" select="@ID" />
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
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
-->

<!-- NOTES-ON match="ARTICLE" mode="kidurl"
-
-->
<xsl:template match="ARTICLE" mode="kidurl">
	<xsl:param name="myName" select="string('article-kidurl')" />
  <xsl:param name="linkText" select="string('View')" />
  <xsl:variable name="id" select="@ID" />
  <xsl:choose>
    <xsl:when test="not($doFT) and not($bHosted)">
      <a xsl:use-attribute-sets="article-base__kidurl-a" lbname="{$myName}">
        <xsl:attribute name="href" select="SRCURL" />
        <img src="{$linkImgURL}" xsl:use-attribute-sets="article-base__kidurl_linkout-img" lbname="{$myName}" />
        <xsl:value-of select="$linkText" />
      </a>
    </xsl:when>
    <xsl:when test="$doFT">
      <a xsl:use-attribute-sets="article-base__kidurl-a" lbname="{$myName}">
        <xsl:attribute name="href" select="concat('#',./@ID)" />
        <xsl:attribute name="name" select="concat('top',./@ID)" />
        <xsl:value-of select="$linkText" />
      </a>
    </xsl:when>
    <xsl:when test="SRCURL/@REDIRECT=1">
      <a xsl:use-attribute-sets="article-base__kidurl-a" lbname="{$myName}">
        <xsl:attribute name="href" select="SRCURL" />
        <img src="{$linkImgURL}" xsl:use-attribute-sets="article-base__kidurl_linkout-img" />
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

<!-- NOTES-ON match="ARTICLE" mode="bolt"
-
-->
<xsl:template match="ARTICLE" mode="bolt">
	<xsl:param name="myName" select="string('article-bolt')" />
  <xsl:variable name="bPD" select="xs:boolean(string-length(@PUBLISHDATE))" />
  <xsl:variable name="bAU" select="xs:boolean(string-length(AUTHOR[1]))" />
  <xsl:variable name="bPB" select="xs:boolean(string-length(PUBLICATION))" />
  <div xsl:use-attribute-sets="article-base__bolt-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-base__bolt-span" lbname="{$myName}">
	    <xsl:value-of select="PUBLICATION" />
	    <xsl:if test="$bPB and $bPD">
	      <xsl:value-of select="$text___article-bolt_separator" />
	    </xsl:if>
	    <xsl:apply-templates select="@PUBLISHDATE" />
	    <xsl:if test="$bPD and $bAU">
	      <xsl:value-of select="$text___article-bolt_separator" />
	    </xsl:if>
	    <xsl:apply-templates select="AUTHOR" />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="ARTICLE" mode="head"
- copy of do-section-head
-->
<xsl:template match="ARTICLE" mode="head">
		<xsl:param name="sid" select="string('ts')" />
    <xsl:param name="param___article-head-title" />
    <tr>
        <td xsl:use-attribute-sets="tdSectHead">
            <a name="sect{$sid}" id="sect{$sid}"></a>
            <table xsl:use-attribute-sets="table" style="padding-bottom:1em;padding-top:1.6em;">
                <tr>
                    <td width="1%" valign="bottom" style="white-space:nowrap;">
                        <span style="{$styleSectionHead}" class="sectionHead">
													<xsl:choose>
														<xsl:when test="string-length($param___article-head-title)>0">
                            	<xsl:value-of disable-output-escaping="yes" select="$param___article-head-title" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:apply-templates select="INSERTED" mode="text-format" />
														</xsl:otherwise>
													</xsl:choose>
                        </span>
                    </td>
                    <td style="border-bottom:solid 2px {$colorText};width:*;">
                        &#xa0;
                    </td>
                </tr>
            </table>
            <a name="sect{$sid}" id="sect{$sid}"></a>
        </td>
    </tr>
</xsl:template>

<!-- NOTES-ON match="THUMBNAIL"
-
-->
<xsl:template match="THUMBNAIL">
	<xsl:param name="myName" select="string('thumbnail')" />
  <img src="{.}" xsl:use-attribute-sets="article-base__thumbnail-img" lbname="{$myName}" />
</xsl:template>

<!-- NOTES-ON "do-section-head"
- TO-DO: organize style & vars
-->
<xsl:template name="do-section-head">
	<xsl:param name="myName" select="string('do-section-head')" />
  <xsl:param name="sectName" />
  <xsl:param name="sid" select="string('ts')" />
	<tr lbname="{$myName}">
		<td lbname="{$myName}">
			<div xsl:use-attribute-sets="div___section__head_margin" lbname="{$myName}">
				<xsl:value-of select="$text___nbsp" />
			</div>
		</td>
	</tr>
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdSectHead" lbname="{$myName}">
      <a name="sect{$sid}" id="sect{$sid}" lbname="{$myName}"></a>
      <table xsl:use-attribute-sets="table" lbname="{$myName}">
        <tr lbname="{$myName}">
          <td lbname="{$myName}">
            <table xsl:use-attribute-sets="table" lbname="{$myName}">
              <tr lbname="{$myName}">
                <td width="1%" valign="bottom" style="white-space:nowrap;border-bottom:solid 2px {$color___block-title};" lbname="{$myName}">
                  <span lbname="{$myName}">
                    <xsl:attribute name="class" select="string('sectionHead titleFont')" />
                    <xsl:attribute name="style" select="string($styleSectionHead)" />
                    <xsl:value-of disable-output-escaping="yes" select="$sectName" />
                  </span>
                </td>
                <td style="border-bottom:solid 2px {$color___block-title};" lbname="{$myName}">
                  <xsl:value-of select="$text___nbsp" />
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON "do-held-articles"
- reworked how responsive text is generated, to allow for variable-izing
-->
<xsl:template name="do-held-articles">
	<xsl:param name="myName" select="string('do-held-articles')" />
  <xsl:param name="heldArticles" />
  <xsl:variable name="countHeldArticles" select="count($heldArticles)" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
      <a lbname="{$myName}">
        <xsl:attribute name="href" select="concat($webroot ,'#' ,translate(./NAME,' ','') )" />
        <xsl:value-of select="replace((
          if ($countHeldArticles = 1)
            then replace( $text___held-articles_count ,'articles' ,'article' )
            else $text___held-articles_count )
          ,'HELD_ARTICLES_COUNT'
          ,string($countHeldArticles) )" />
      </a>
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON "do-empty-section"
-
-->
<xsl:template name="do-empty-section">
	<xsl:param name="myName" select="string('do-empty-section')" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
			<div xsl:use-attribute-sets="bodyFont">
      	<xsl:value-of disable-output-escaping="yes" select="$text___empty-section" />
			</div>
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON name="do-issue-head"
-
-->
<xsl:template name="do-issue-head">
	<xsl:param name="myName" select="string('do-issue-head')" />
  <xsl:param name="issName" />
  <xsl:param name="param___alt-style" select="false()" />
  <xsl:choose>
    <xsl:when test="$param___alt-style">
      <tr lbname="{$myName}">
        <td xsl:use-attribute-sets="td___issue__head td___issue__head_std-indent" lbname="{$myName}">
          <span xsl:use-attribute-sets="span___issue__title" lbname="{$myName}">
            <xsl:value-of disable-output-escaping="yes" select="$issName" />
          </span>
        </td>
      </tr>
    </xsl:when>
    <xsl:otherwise>
      <tr lbname="{$myName}">
        <td xsl:use-attribute-sets="td___issue__head td___issue__head_extra-indent" lbname="{$myName}">
          <span xsl:use-attribute-sets="span___issue__title" lbname="{$myName}">
            <xsl:value-of disable-output-escaping="yes" select="$issName" />
          </span>
        </td>
      </tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- NOTES-ON match="HEADLINE" mode="bullets"
-
-->
<xsl:template match="HEADLINE" mode="bullets">
	<xsl:param name="myName" select="string('headline-bullets')" />
	<span xsl:use-attribute-sets="article-bullets__headline-span" lbname="{$myName}">
	  <a xsl:use-attribute-sets="article-bullets__headline_link-a" lbname="{$myName}">
	    <xsl:choose>
	      <xsl:when test="xs:boolean($doFT)">
	        <xsl:attribute name="href" select="concat('#',../@ID)" />
	        <xsl:attribute name="name" select="concat('top',../@ID)" />
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:choose>
	          <xsl:when test="$bHosted">
	            <xsl:attribute name="href">
	              <xsl:value-of select="concat($hostroot,../@ID)" />
	            </xsl:attribute>
	          </xsl:when>
	          <xsl:otherwise>
	            <xsl:attribute name="href">
	              <xsl:value-of select="../SRCURL" />
	            </xsl:attribute>
	          </xsl:otherwise>
	        </xsl:choose>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:value-of disable-output-escaping="yes" select="." />
	  </a>
	</span>
</xsl:template>

<!-- NOTES-ON match="HEADLINE" mode="slugs"
-
-->
<xsl:template match="HEADLINE" mode="slugs">
	<xsl:param name="myName" select="string('headline-slugs')" />
  <div xsl:use-attribute-sets="article-slugs__headline-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-slugs__headline-span bodyFont" lbname="{$myName}">
    	<xsl:value-of disable-output-escaping="yes" select="." />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="HEADLINE" mode="ricochet"
-
-->
<xsl:template match="HEADLINE" mode="ricochet">
	<xsl:param name="myName" select="string('headline-ricochet')" />
  <div xsl:use-attribute-sets="article-ricochet__headline-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-ricochet__headline-span bodyFont" lbname="{$myName}">
	    <xsl:value-of disable-output-escaping="yes" select="." />
			<xsl:value-of select="$text___nbsp" />
	    <xsl:apply-templates select=".." mode="kidurl" />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="HEADLINE" mode="anchor"
-
-->
<xsl:template match="HEADLINE" mode="anchor">
	<xsl:param name="myName" select="string('headline-anchor')" />
  <div xsl:use-attribute-sets="article-anchor__headline-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-anchor__headline-span bodyFont" lbname="{$myName}">
			<xsl:value-of disable-output-escaping="yes" select="." />
			<xsl:value-of select="$text___nbsp" />
			<a name="{../@ID}" href="#top{../@ID}" xsl:use-attribute-sets="article-anchor__headline_nav-a" lbname="{$myName}">
		    <xsl:value-of disable-output-escaping="yes" select="$text___article-fulltext__nav" />
		  </a>
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="SUBHEAD" mode="slugs"
-
-->
<xsl:template match="SUBHEAD" mode="slugs">
	<xsl:param name="myName" select="string('subhead-slugs')" />
  <xsl:if test="string-length(.)>0">
    <div xsl:use-attribute-sets="article-slugs__subhead-div" lbname="{$myName}">
			<span xsl:use-attribute-sets="article-slugs__subhead-span bodyFont" lbname="{$myName}">
      	<xsl:value-of disable-output-escaping="yes" select="." />
			</span>
    </div>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON match="@MEDIAID[.!=0]"
- TO-DO: work on logic, maybe expand use
-->
<xsl:template match="@MEDIAID[.!=0]">
	<xsl:param name="myName" select="string('mediaid')" />
  <img xsl:use-attribute-sets="article-base__mediatype_linkout-img" lbname="{$myName}">
    <xsl:attribute name="src">
      <xsl:choose>
        <xsl:when test=".=1">
          <xsl:value-of select="$imgPic" />
        </xsl:when>
        <xsl:when test=".=2">
          <xsl:value-of select="$imgVid" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$imgAud" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </img>
</xsl:template>

<!-- NOTES-ON match="PUBLICATION" mode="bullets"
-
-->
<xsl:template match="PUBLICATION" mode="bullets">
	<xsl:param name="myName" select="string('publication-bullets')" />
  <span xsl:use-attribute-sets="article-bullets__publication-span" lbname="{$myName}">
    <xsl:value-of disable-output-escaping="yes" select="." />
    <xsl:value-of disable-output-escaping="yes" select="$text___article-bullets_separator" />
  </span>
</xsl:template>

<!-- NOTES-ON match="@PUBLISHDATE"
-
-->
<xsl:template match="@PUBLISHDATE">
	<xsl:param name="myName" select="string('publishdate')" />
  <xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
  <xsl:value-of select="format-date(xs:date($strDate), $boltDateFormat,'en',(),())" />
</xsl:template>

<!-- NOTES-ON match="INSERTED" mode="text-format"
-
-->
<xsl:template match="INSERTED" mode="text-format">
	<xsl:param name="myName" select="string('inserted-text-format')" />
  <xsl:variable name="strDate" select="substring(.,1,10)" />
  <xsl:value-of select="format-date(xs:date($strDate), $headerDateFormat,'en',(),())" />
</xsl:template>

<!-- NOTES-ON match="AUTHOR"
- TO-DO: variable-ize separators
- TO-DO: add span, attribute set, lbname
-->
<xsl:template match="AUTHOR">
	<xsl:param name="myName" select="string('author')" />
  <xsl:choose>
    <xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
    <xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
    <xsl:otherwise />
  </xsl:choose>
  <xsl:if test="position()=1">By </xsl:if><xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<!-- NOTES-ON match="COPYRIGHT"
- TO-DO: is this used anywhere?
-->
<xsl:template match="COPYRIGHT">
	<xsl:param name="myName" select="string('copyright')" />
  <div xsl:use-attribute-sets="article-base__copyright-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-base__copyright-span" lbname="{$myName}">
    	<xsl:value-of disable-output-escaping="yes" select="." />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="ABSTRACT"
-
-->
<xsl:template match="ABSTRACT">
	<xsl:param name="myName" select="string('abstract')" />
  <div xsl:use-attribute-sets="article-base__abstract-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-base__abstract-span bodyFont" lbname="{$myName}">
    	<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="PUBCOPYRIGHT"
-
-->
<xsl:template match="PUBCOPYRIGHT">
	<xsl:param name="myName" select="string('pubcopyright')" />
  <div xsl:use-attribute-sets="article-base__pubcopyright-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-base__pubcopyright-span bodyFont" lbname="{$myName}">
    	<xsl:value-of disable-output-escaping="yes" select="." />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON name="ARTICLEBODY"
-
-->
<xsl:template name="ARTICLEBODY">
	<xsl:param name="myName" select="string('articlebody')" />
  <xsl:param name="article" />
  <div xsl:use-attribute-sets="article-base__articlebody-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-base__articlebody-span bodyFont" lbname="{$myName}">
    	<xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="SRCURL" mode="site"
- TO-DO: variable-ize text
-->
<xsl:template match="SRCURL" mode="site">
	<xsl:param name="myName" select="string('srcurl-site')" />
  <div xsl:use-attribute-sets="article-fulltext__srcurl-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-fulltext__srcurl-span bodyFont" lbname="{$myName}">
	    <a href="{string(.)}" xsl:use-attribute-sets="article-fulltext__srcurl-a" lbname="{$myName}">
	      <xsl:apply-templates select="../@MEDIAID[.!=0]" />
	      <xsl:choose>
	        <xsl:when test="../@MEDIAID=2">
						<xsl:value-of select="$text___article-fulltext__srcurl_media-video" />
	        </xsl:when>
	        <xsl:when test="../@MEDIAID=3">
						<xsl:value-of select="$text___article-fulltext__srcurl_media-audio" />
	        </xsl:when>
	        <xsl:when test="../@MEDIAID=1">
						<xsl:value-of select="$text___article-fulltext__srcurl_media-image" />
	        </xsl:when>
	        <xsl:otherwise>
						<xsl:value-of select="$text___article-fulltext__srcurl_media-text" />
	        </xsl:otherwise>
	      </xsl:choose>
	    </a>
		</span>
  </div>
</xsl:template>

<!-- NOTES-ON match="SRCURL" mode="rights"
-
-->
<xsl:template match="SRCURL" mode="rights">
	<xsl:param name="myName" select="string('srcurl-rights')" />
	<div xsl:use-attribute-sets="article-fulltext__srcurl-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-fulltext__srcurl-span bodyFont" lbname="{$myName}">
			<xsl:apply-templates select="../@MEDIAID[.!=0]" />
			<xsl:value-of select="$text___article-fulltext__srcurl_descrip" />
		  <a href="{string(.)}" xsl:use-attribute-sets="article-fulltext__srcurl-a" lbname="{$myName}">
		    <xsl:value-of select="$text___article-fulltext__srcurl_link" />
		  </a>
			<xsl:value-of select="$text___period" />
		</span>
	</div>
</xsl:template>

<!-- NOTES-ON match="MENTION"
-
-->
<xsl:template match="MENTION">
	<xsl:param name="myName" select="string('mention')" />
  <span xsl:use-attribute-sets="article-base__mention-span" lbname="{$myName}">
    <xsl:value-of select="." />
  </span>
</xsl:template>

<!-- NOTES-ON match="SHARING" mode="sumShares"
-
-->
<xsl:template match="SHARING" mode="sumShares">
	<xsl:param name="myName" select="string('sharing-sumshares')" />
	<xsl:param name="param___do-template" select="false()" />
	<xsl:param name="param___abbrev-nums" select="true()" />
	<xsl:param name="param___sum-of-shares">
		<xsl:choose>
			<xsl:when test="param___abbrev-nums and sum(PLATFORM/@SHARECOUNT) &gt; 999000000">
				<xsl:value-of select="format-number(sum(PLATFORM/@SHARECOUNT) div 1000000000, '#,##0.0')" />
				<xsl:value-of select="string('B')" />
			</xsl:when>
			<xsl:when test="param___abbrev-nums and sum(PLATFORM/@SHARECOUNT) &gt; 999000">
				<xsl:value-of select="format-number(sum(PLATFORM/@SHARECOUNT) div 1000000, '#,##0.0')" />
				<xsl:value-of select="string('M')" />
			</xsl:when>
			<xsl:when test="param___abbrev-nums and sum(PLATFORM/@SHARECOUNT) &gt; 999">
				<xsl:value-of select="format-number(sum(PLATFORM/@SHARECOUNT) div 1000, '#,##0')" />
				<xsl:value-of select="string('K')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(sum(PLATFORM/@SHARECOUNT), '#,##0')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<div xsl:use-attribute-sets="article-slugs__sharing-div" lbname="{$myName}">
		<span xsl:use-attribute-sets="article-slugs__sharing-span" lbname="{$myName}">
	    <xsl:value-of select="string('Social Shares: ')" />
			<xsl:choose>
				<xsl:when test="param___abbrev-nums and sum(PLATFORM/@SHARECOUNT) &gt; 99900000">
					<span xsl:use-attribute-sets="article-slugs__sharing_big-value-span" lbname="{$myName}">
						<xsl:value-of select="$param___sum-of-shares" />
					</span>
				</xsl:when>
				<xsl:when test="param___abbrev-nums and sum(PLATFORM/@SHARECOUNT) &gt; 99900">
					<span xsl:use-attribute-sets="article-slugs__sharing_mid-value-span" lbname="{$myName}">
						<xsl:value-of select="$param___sum-of-shares" />
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span xsl:use-attribute-sets="article-slugs__sharing_low-value-span" lbname="{$myName}">
						<xsl:value-of select="$param___sum-of-shares" />
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</div>
</xsl:template>

<!-- NOTES-ON match="ENTITY" mode="name"
- TO-DO: figure out how to use these classes
- TO-DO: new styling with logic and images
-->
<xsl:template match="ENTITY" mode="name">
	<xsl:param name="myName" select="string('entity-name')" />
  <xsl:choose>
    <xsl:when test="$doEntityTone and string-length(@TONE) &gt; 0">
      <xsl:choose>
        <xsl:when test="number(@TONE) = 1">
          <span lbname="{$myName}">
            <xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
            <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'color:','#cf5140',';')" /></xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="." />
          </span>
        </xsl:when>
        <xsl:when test="number(@TONE) = 4">
          <span lbname="{$myName}">
            <xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
            <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'color:','#79917e',';')" /></xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="." />
          </span>
        </xsl:when>
        <xsl:otherwise>
          <span lbname="{$myName}">
            <xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
            <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'color:',$colorBolt,';')" /></xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="." />
          </span>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="." mode="tone" />
      <xsl:if test="position() != last()">
        <span lbname="{$myName}">
          <xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
          <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'color:',$colorBolt,';')" /></xsl:attribute>
          <xsl:value-of disable-output-escaping="yes" select="string(' - ')" />
        </span>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <span lbname="{$myName}">
        <xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
        <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'color:',$colorBolt,';')" /></xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="." />
        <xsl:if test="position() != last()">
          <xsl:value-of disable-output-escaping="yes" select="string(' - ')" />
        </xsl:if>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- NOTES-ON match="ENTITY" mode="tone"
-  TO-DO: add class & style...
-->
<xsl:template match="ENTITY" mode="tone">
	<xsl:param name="myName" select="string('entity-tone')" />
  <xsl:choose>
    <xsl:when test="@TONE = 1">
      <span lbname="{$myName}">
        <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'font-size:80%;','color:',$colorBolt,';')" /></xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="string(' (Negative)')" />
      </span>
    </xsl:when>
    <xsl:when test="@TONE = 2">
      <span lbname="{$myName}">
        <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'font-size:80%;','color:',$colorBolt,';')" /></xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="string(' (Neutral)')" />
      </span>
    </xsl:when>
    <xsl:when test="@TONE = 3">
      <span lbname="{$myName}">
        <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'font-size:80%;','color:',$colorBolt,';')" /></xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="string(' (Balanced)')" />
      </span>
    </xsl:when>
    <xsl:when test="@TONE = 4">
      <span lbname="{$myName}">
        <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'font-size:80%;','color:',$colorBolt,';')" /></xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="string(' (Positive)')" />
      </span>
    </xsl:when>
    <xsl:otherwise>
      <span lbname="{$myName}">
        <xsl:attribute name="style"><xsl:value-of select="concat($styleEntity,'font-size:80%;','color:',$colorBolt,';')" /></xsl:attribute>
        <xsl:value-of disable-output-escaping="yes" select="string(' (Sentiment N/A)')" />
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- NOTES-ON "do-mobile-link"
-
-->
<xsl:template name="do-mobile-link">
	<xsl:param name="myName" select="string('do-mobile-link')" />
  <xsl:param name="param___do-template" select="$bool___do-mobile-link"/>
  <xsl:param name="link-2" select="$mobileAppLink" />
  <xsl:if test="string-length($webVersionURL) &gt; 0 and $param___do-template">
    <div lbname="{$myName}">
      <xsl:attribute name="style" select="$styleMobilePref" />
      <a lbname="{$myName}">
        <xsl:attribute name="href" select="$webVersionURL" />
        <xsl:attribute name="style" select="$styleLink" />
        <xsl:value-of select="$mobilePrefText" />
      </a>
    </div>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON "do-report-head"
- added variable 'headerImageMaxWidth'
- added max-width 100% and height auto to style
- TO-DO: responsive? background + foreground image? Outlook?
-->
<xsl:template name="do-report-head">
	<xsl:param name="myName" select="string('do-report-head')" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdHead" lbname="{$myName}">
      <img src="{$brandImgURL}" xsl:use-attribute-sets="imgReportHead" lbname="{$myName}" />
    </td>
  </tr>
</xsl:template>

<!-- NOTES-ON "do-tags"
- added comma & space after tags, excluding last/only logic
- TO-DO: proper spacing between multiple tags
-->
<xsl:template name="do-tags">
	<xsl:param name="myName" select="string('do-tags')" />
  <xsl:param name="AID" />
  <xsl:variable name="printTag" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$AID]" />
  <xsl:for-each select="$printTag">
    <span xsl:use-attribute-sets="article-base__tags-span" lbname="{$myName}">
      <xsl:attribute name="class">
        <xsl:value-of select="@NAME" />
        <xsl:value-of select="string(' tag')" />
      </xsl:attribute>
      <xsl:value-of disable-output-escaping="yes" select="@NAME" />
      <xsl:if test="position()!=last() and count($printTag)!=1">
        <xsl:value-of select="$text___article-base__tags_separator" />
      </xsl:if>
    </span>
  </xsl:for-each>
</xsl:template>

<!-- NOTES-ON "do-section-nav"
- What is do-block-nav for (in PG2_WatchReport.xsl) and do i want to add it here?
-->
<xsl:template name="do-section-nav">
	<xsl:param name="myName" select="string('do-section-nav')" />
	<xsl:param name="param___do-template" select="$bool___do-section-nav" />
  <xsl:if test="count($sectList) &gt; 0 and $param___do-template">
    <tr lbname="{$myName}">
      <td xsl:use-attribute-sets="tdReportNav" lbname="{$myName}">
        <xsl:apply-templates select="$sectList" mode="nav" />
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON "do-top-msg"
-
-->
<xsl:template name="do-top-msg">
	<xsl:param name="myName" select="string('do-top-msg')" />
	<xsl:if test="string-length(/CLIPSHEET/TOPMSG) &gt; 0">
    <tr lbname="{$myName}">
      <td xsl:use-attribute-sets="tdTopMsg" lbname="{$myName}">
        <xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/TOPMSG" />
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON "do-empty-letter"
-
-->
<xsl:template name="do-empty-letter">
	<xsl:param name="myName" select="string('do-empty-letter')" />
  <xsl:if test="count($allowedArticles) = 0">
    <tr lbname="{$myName}">
      <td lbname="{$myName}">
        <div xsl:use-attribute-sets="empty-letter-div article-slugs__headline-div" lbname="{$myName}">
					<span xsl:use-attribute-sets="empty-letter-span" lbname="{$myName}">
          	<xsl:value-of select="$text___empty-letter" />
					</span>
        </div>
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<!-- NOTES-ON "do-default-copyright"
-
-->
<xsl:template name="do-default-copyright">
	<xsl:param name="myName" select="string('do-default-copyright')" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdDefaultCopyright" lbname="{$myName}">
      <xsl:value-of disable-output-escaping="yes" select="$defaultCopyright" />
    </td>
  </tr>
</xsl:template>

<!-- WR1 -->
<xsl:template name="do-page-foot">
    <tr>
        <td colspan="3" style="text-align:center;font-size:70%;">
            &#xa0;
        </td>
    </tr>
    <xsl:if test="string-length($boilerplate)">
        <tr>
            <td colspan="3" style="text-align:center;font-size:70%;">
                <xsl:value-of disable-output-escaping="yes" select="$boilerplate" />
            </td>
        </tr>
    </xsl:if>
    <tr>
        <td colspan="3" style="color:{$colorBolt}">
            <table xsl:use-attribute-sets="table">
                <tr>
                    <td style="font-size:70%;text-align:left;padding:1em;">
                        Prepared by <a href="{$preparedByLink}" style="font-color:{$colorLink}">Lone Buffalo, LLC.</a>
                    </td>
                    <td style="font-size:70%;text-align:center;padding:1em;">
                        <xsl:if test="$selfSubscribe">
                        Manage your subscription
                        <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat(/CLIPSHEET/LB_URL,'?do=signup')" />
                        </xsl:attribute>
                        here</a>.
                        </xsl:if>
                    </td>
                    <td style="font-size:70%;text-align:right;padding:1em;">
                        Feedback? <a href="mailto:{$nlFeedbackAddr}" style="font-color:{$colorLink}"><xsl:value-of select="$nlFeedbackAddr" /></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="text-align:center;">
            <img src="{$bottomLBBrand}" />
        </td>
    </tr>
    <tr>
        <td colspan="3" style="text-align:center;">
    <xsl:call-template name="do-GApixel">
        <xsl:with-param name="UAID" select="$UAID" />
    </xsl:call-template>
        </td>
    </tr>
</xsl:template>

<!-- NOTES-ON "do-report-foot"
- TO-DO: reformat & attribute-ize <hr />, maybe as td border-top
-->
<xsl:template name="do-report-foot">
	<xsl:param name="myName" select="string('do-report-foot')" />
  <tr lbname="{$myName}">
    <td xsl:use-attribute-sets="tdContent" lbname="{$myName}">
      <hr />
      <table xsl:use-attribute-sets="table" lbname="{$myName}">
        <xsl:if test="string-length($bottommessage) &gt; 0">
          <tr lbname="{$myName}">
            <td xsl:use-attribute-sets="td___report__foot" lbname="{$myName}">
              <xsl:value-of disable-output-escaping="yes" select="$bottommessage" />
            </td>
          </tr>
        </xsl:if>
      </table>
    </td>
  </tr>
</xsl:template>

<!-- WR1 -->
<xsl:template name="do-GApixel">
    <xsl:param name="UAID" select="string('UA-1191451-29')" />
    <xsl:param name="gaCID" select="string('016458c3-fd2b-4008-b067-644bc3595d08')" />
    <xsl:variable name="gaEA" select="encode-for-uri($formatName)" />
    <xsl:variable name="gaEC" select="encode-for-uri($clientName)" />
    <xsl:variable name="gaEL" select="format-date(xs:date(substring($clipDate,1,10)), $dateArgFormat,'en',(),())" />
    <xsl:variable name="gaCS" select="encode-for-uri($clientName)" />
    <img src="https://www.google-analytics.com/collect?v=1&amp;tid={$UAID}&amp;cid={$gaCID}&amp;t=event&amp;ec={$gaEC}&amp;ea={$gaEA}&amp;el={$gaEL}&amp;ni=1&amp;sc=start" width="0" height="0" />
</xsl:template>

<!-- NOTES-ON "make-strAID"
-
-->
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

</xsl:stylesheet>
