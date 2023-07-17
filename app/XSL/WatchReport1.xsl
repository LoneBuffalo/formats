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
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs xsl lbps">

<xsl:import href="https://lbpscdn.lonebuffalo.com/resources/XSL/Keywords.xsl"/>

<xsl:variable name="formatName">Watch Report Base</xsl:variable>
<!-- placeholder variables below -->
<!-- 
     template design specs: #d7dad9 - entire background
                            #f2f2f2 - content background
                            #ffffff - nav background
-->
<xsl:variable name="style" select="string('bullets')" />
<xsl:variable name="doFT" select="true()" />
<xsl:variable name="doTags" select="true()" />
<xsl:variable name="dupeTop" select="false()" />
<xsl:variable name="extRelated" select="false()" />
<xsl:variable name="preferSrc" select="false()" />
<xsl:variable name="extOver" select="string('')" />
<xsl:variable name="execSectID" select="1" />
<xsl:variable name="brandImgURL" select="string('https://lbpscdn.lonebuffalo.com/resources/img/lbNLHeader.jpg')" />
<xsl:variable name="bottomLBBrand" select="string('https://lbpscdn.lonebuffalo.com/resources/img/lbNLbottomBrand.png')" />
<xsl:variable name="defaultCopyright">
    <![CDATA[<img src="https://lbpscdn.lonebuffalo.com/resources/img/DJbranding.png" align="right">]]>
</xsl:variable>
<xsl:variable name="boilerplate">
    <![CDATA[Content in this newsletter is for your use only and may not be republished.]]>
</xsl:variable>
<xsl:variable name="emptyLetterNote">
    <![CDATA[No articles found for this edition.]]>
</xsl:variable>
<xsl:variable name="clientName" select="/CLIPSHEET/@CLIENT" />
<xsl:variable name="reportTitle" select="/CLIPSHEET/@NAME" />
<xsl:variable name="mobilePrefText" select="string('mobile users may prefer this')" />
<xsl:variable name="bottommessage" select="/CLIPSHEET/BOTMSG" />
<xsl:variable name="lbCiteLink" select="string('http://lonebuffalo.com/')" />
<xsl:variable name="nlFeedbackAddr" select="string('hello@lonebuffalo.com')" />
<xsl:variable name="selfSubscribe" select="true()" />
<xsl:variable name="sectEmptyFlag" select="false()" />
<xsl:variable name="showSource" select="false()" />
<xsl:variable name="mediaType" select="false()" />
<xsl:variable name="max-width" select="string('690')" />
<xsl:variable name="min-width" select="string('690')" />
<xsl:variable name="bBlastThumbs" select="false()" />
<xsl:variable name="bHosted" select="true()" />
<xsl:variable name="topStoriesLabel" select="string('Top Stories')" />
<xsl:variable name="headerDateFormat" select="string('[MNn] [D1], [Y]')"/>
<xsl:variable name="boltDateFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="ftDateFormat" select="$boltDateFormat" />
<xsl:variable name="colorText" select="string('#231914')" />
<xsl:variable name="fontFamily" select="string('Arial,sans-serif')" />
<xsl:variable name="fontSize" select="string('1.2em')" />
<xsl:variable name="colorHead" select="string('#6d695f')" />
<xsl:variable name="colorBolt" select="string('#6d695f')" />
<xsl:variable name="colorLink" select="string('#d2503c')" />
<xsl:variable name="bgcolorHead" select="string('#231914')" />
<xsl:variable name="bgcolor" select="string('#e6e6e6')" />
<xsl:variable name="bgcolorContent" select="string('#f2f2f2')" />
<xsl:variable name="bgcolorNav" select="string('#ffffff')" />
<xsl:variable name="linkImgURL" select="string('https://lbpscdn.lonebuffalo.com/resources/img/linkout.png')" />
<xsl:variable name="imgAud" select="string('https://lbpscdn.lonebuffalo.com/resources/img/lb_audio.png')" />
<xsl:variable name="imgVid" select="string('https://lbpscdn.lonebuffalo.com/resources/img/lb_video.png')" />
<xsl:variable name="imgPic" select="string('https://lbpscdn.lonebuffalo.com/resources/img/lb_image.png')" />
<xsl:variable name="styleBody" select="concat('font-family:',$fontFamily,';font-size:',$fontSize,';background-color:',$bgcolor,';color:',$colorText,';')"/>
<xsl:variable name="styleSectionHead" select="string('font-size:2em;font-weight:bold;')" />
<xsl:variable name="styleIssueHead" select="concat('font-size:1em;font-weight:bold;color:',$colorLink,';')" />
<xsl:variable name="styleHeadline" select="string('font-weight:bold;font-size:1.5em;margin:0;padding:0;')" />
<xsl:variable name="styleSubHead" select="string('font-weight:bold;font-size:1em;margin:0;padding:0;')" />
<xsl:variable name="styleFamilyBolt" select="string('Courier')" />
<xsl:variable name="styleChildHed" select="string('font-weight:bold;font-size:1.2em;margin:0;padding:0;')" />
<xsl:variable name="styleReportTitle" select="string('font-size:1.8em;font-weight:bold;font-family:Courier;')" />
<xsl:variable name="UAID" select="string('UA-1191451-29')" />

<!-- placeholder variables above -->

<xsl:variable name="dateArgFormat" select="string('[M01]/[D01]/[Y0001]')"/>
<xsl:variable name="apiroot" select="concat('https://subscriber-api.lonebuffalo.app/v1/clients/',string(/CLIPSHEET/@CID),'/')" />
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
<!--
<xsl:variable name="xmlPath" select="string('XML/stdFullStory?story_id=')" />
<xsl:variable name="FTXML" select="document(concat($webroot,$xmlPath,$strAID))"/>
-->
<xsl:variable name="FTXML" select="document(concat($apiroot,'/articles?story_ids=',$strAID))"/>
<xsl:variable name="keywords" select="$FTXML/CLIPSHEET" />

<xsl:output method="html" indent="yes" encoding="utf-8" />

<xsl:template match="/">
  <meta name="apple-itunes-app" content="app-id=1450569477" />
    <body style="{$styleBody}">
        <table xsl:use-attribute-sets="table" class="body" style="background-color:{$bgcolor};">
            <tr style="height:1px;">
                <th style="width:50%;"></th>
                <th style="min-width:{$min-width}px !important;max-width:{$max-width}px !important;background-color:{$bgcolorContent};margin:0;padding:0;"></th>
                <th style="width:50%;"></th>
            </tr>
            <tr>
            <td style="width:50%;">&#xa0;</td>
            <td style="min-width:{$min-width}px !important;max-width:{$max-width}px !important;background-color:{$bgcolorContent};margin:0;padding:0;">
                <xsl:if test="string-length($webVersionURL) &gt; 0">
                <div style="padding:0;margin:0;width:100%;text-align:center;font-size:.7777777em;">
                    <a href="{$webVersionURL}" style="color:{$colorLink}">
                        <xsl:value-of select="$mobilePrefText" />
                    </a>
                </div>
                </xsl:if>
                <table xsl:use-attribute-sets="table">
                    <xsl:call-template name="do-report-head" />
                    <xsl:if test="not(number($execSectID) = 1)">
                        <xsl:apply-templates select="$allowedArticles[number(SECTION/@ID)=number($execSectID)]" mode="execsum">
                            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                        </xsl:apply-templates>
                    </xsl:if>
                    <xsl:call-template name="do-report-nav" />
                    <xsl:call-template name="do-toc" />
                    <xsl:if test="xs:boolean($doFT)">
                        <xsl:call-template name="do-fulltext" />
                    </xsl:if>
                    <xsl:call-template name="do-report-foot"/>
                </table>
            </td>
            <td style="width:50%;">&#xa0;</td>
        </tr>
        <tr>
            <td style="width:50%;"></td>
            <td>
                <table xsl:use-attribute-sets="table">
                <xsl:call-template name="do-page-foot" />
                </table>
            </td>
            <td style="width:50%;"></td>
        </tr>
        </table>
    </body>
</xsl:template>

<xsl:template name="do-toc">
    <xsl:if test="count($allowedArticles) = 0">
        <tr>
            <td>
    <p style="{$styleHeadline};text-align:center;margin:2em;" class="headline">
        <xsl:value-of select="$emptyLetterNote" /> 
    </p>
            </td>
        </tr>
    </xsl:if>
    <xsl:call-template name="do-top-stories">
        <xsl:with-param name="type" select="$style" />
    </xsl:call-template>
    <xsl:apply-templates select="$sectList" mode="process">
        <xsl:with-param name="type" select="$style"/>
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template name="do-fulltext">
    <xsl:call-template name="do-top-stories">
        <xsl:with-param name="type" select="string('fulltext')" />
    </xsl:call-template>
    <xsl:apply-templates select="$sectList" mode="process">
        <xsl:with-param name="type" select="string('fulltext')" />
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template name="do-top-stories">
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
                    <tr>
                        <td>
                            <xsl:value-of disable-output-escaping="yes" select="$defaultCopyright" />
                        </td>
                    </tr>
                </xsl:if>
                <xsl:apply-templates select="$topStories" mode="fulltext">
                    <xsl:sort select="@TOPSTORY" data-type="number" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<xsl:template match="SECTION" mode="process">
    <xsl:param name="type" select="$style" />
    <xsl:variable name="sid" select="ID" />
    <xsl:variable name="candidateArticles" select="if (number($extOver) = number($extOver)) then
        $allowedArticles[SECTION/@ID=$sid][not(@PARENT!=0)][number(SECTION/@ORDINAL) &lt;= number($extOver)] else
        $allowedArticles[SECTION/@ID=$sid][not(@PARENT!=0)]" />
    <xsl:variable name="heldArticles" select="if (number($extOver) = number($extOver)) then
        $allowedArticles[SECTION/@ID=$sid][not(@PARENT!=0)][number(SECTION/@ORDINAL) &gt; number($extOver)] else
        $allowedArticles[@ID=0]" />
    <xsl:variable name="sArticles" select="if ($dupeTop and $type!='fulltext') then $candidateArticles else $candidateArticles[not(@TOPSTORY!=0)]" />
    <xsl:variable name="issSArticles" select="$sArticles[@ID=$nlIssues/ARTICLE/@ID]" />
    <xsl:variable name="issList" select="$nlIssues[ARTICLE/@ID=$issSArticles/@ID]" />
    <xsl:variable name="non-issSArticles" select="$sArticles[not(@ID=$issSArticles/@ID)]" />
    <xsl:if test="string-length($defaultCopyright) &gt; 0 and count($sArticles) &gt; 0 and $type = 'fulltext'">
        <tr>
            <td>
                <xsl:value-of disable-output-escaping="yes" select="$defaultCopyright" />
            </td>
        </tr>
    </xsl:if>
    <xsl:if test="count($sArticles[not(@TOPSTORY!=0)]) &gt; 0 or xs:boolean($sectEmptyFlag)">
        <xsl:call-template name="do-section-head">
            <xsl:with-param name="sid" select="ID" />
            <xsl:with-param name="sectName" select="NAME" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="count($sArticles[not(@TOPSTORY!=0)]) = 0 and xs:boolean($sectEmptyFlag)">
        <tr>
            <td xsl:use-attribute-sets="tdContent">
                No Relevant News
            </td>
        </tr>
    </xsl:if>
    <xsl:apply-templates select="$issList">
        <xsl:with-param name="type" select="$type" />
        <xsl:with-param name="iArticles" select="$issSArticles" />
        <xsl:sort select="@ORDINAL" data-type="number" />
    </xsl:apply-templates>
    <xsl:if test="$non-issSArticles and $issSArticles">
        <xsl:call-template name="do-issue-head">
            <xsl:with-param name="issName" select="concat('Also in ',NAME)" />
        </xsl:call-template>
    </xsl:if>
    <xsl:choose>
        <xsl:when test="$type = 'bullets'">
            <xsl:apply-templates select="$non-issSArticles" mode="bullets">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                <xsl:sort select="@ID" data-type="number" order="descending" />
            </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$type = 'slugs'">
            <xsl:apply-templates select="$non-issSArticles" mode="slugs">
                <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                <xsl:sort select="@ID" data-type="number" order="descending" />
            </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$type = 'blast'">
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
        <tr>
            <td xsl:use-attribute-sets="tdContent">
                <a href="{$webroot}#{translate(./NAME,' ','')}">
                <xsl:value-of select="count($heldArticles)"/> more article<xsl:value-of select="if (count($heldArticles) &gt; 1) then string('s') else string('')" />
                </a>
            </td>
        </tr>
    </xsl:if>
</xsl:template>

<xsl:template match="ISSUE">
    <xsl:param name="type" select="$style" />
    <xsl:param name="iArticles" />
    <xsl:variable name="iid" select="@ID" />
    <xsl:call-template name="do-issue-head">
        <xsl:with-param name="issName" select="@NAME" />
    </xsl:call-template>
    <tr>
        <td style="padding-left:1em;">
            <table xsl:use-attribute-sets="table">
    <xsl:choose>
        <xsl:when test="$type = 'slugs'">
            <div style="padding-left:1.25em;">
                <xsl:apply-templates select="$iArticles[@ID=$nlIssues[@ID=$iid]/ARTICLE/@ID]" mode="slugs">
                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                    <xsl:sort select="@ID" data-type="number" order="descending" />
                </xsl:apply-templates>
            </div>
        </xsl:when>
        <xsl:when test="$type = 'bullets'">
            <div style="padding-left:1.25em;">
                <xsl:apply-templates select="$iArticles[@ID=$nlIssues[@ID=$iid]/ARTICLE/@ID]" mode="bullets">
                    <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                    <xsl:sort select="@ID" data-type="number" order="descending" />
                </xsl:apply-templates>
            </div>
        </xsl:when>
        <xsl:when test="$type = 'blast'">
            <div style="padding-left:1.25em;">
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

<xsl:template match="SECTION" mode="nav">
    <a href="#sect{ID}" class="nav" style="color:{$colorText};margin-left:3px;margin-right:3px;font-weight:bold;">
        <xsl:value-of disable-output-escaping="yes" select="NAME" />
    </a>
    <xsl:if test="position() != last()">
        |
    </xsl:if>
</xsl:template>

<xsl:template match="ARTICLE" mode="fulltext">
    <xsl:variable name="id" select="@ID" />
    <tr>
        <td xsl:use-attribute-sets="tdContent">
        <div>
            <xsl:apply-templates select="HEADLINE" mode="anchor"/>
            <xsl:apply-templates select="." mode="bolt" />
            <!--
            <xsl:apply-templates select="PUBLICATION" />
            <p style="margin:0px;"><xsl:apply-templates select="AUTHOR" /></p>
            <xsl:apply-templates select="@PUBLISHDATE" />
            -->
            <!--
            <xsl:apply-templates select="SRCURL" mode="site" /> 
            -->
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
            <div style="text-align:center;width:100%;">###</div>
        </div>
            
        </td>
    </tr>
    <xsl:if test="not($extRelated)">
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <xsl:apply-templates select="$children" mode="fulltext">
        <xsl:sort select="ORDINAL" data-type="number" />
    </xsl:apply-templates>
    </xsl:if>
</xsl:template>

<xsl:template match="ARTICLE" mode="bullets">
    <xsl:param name="bHR" select="xs:boolean(position() != 1)" />
    <xsl:variable name="id" select="@ID" />
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <tr>
        <td xsl:use-attribute-sets="tdContent" class="bodyText">
            <a name="{concat('top',$id)}" />
            <xsl:if test="$bHR">
                <hr style="margin:0;padding:0;" />
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

<xsl:template match="ARTICLE" mode="slugs">
    <xsl:variable name="id" select="@ID" />
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <tr>
        <td xsl:use-attribute-sets="tdContent">
            <a name="{concat('top',$id)}" />
            <table xsl:use-attribute-sets="table" style="border-bottom:solid 1px {$colorBolt};padding-bottom:1em;margin-bottom:1.2em;">
                <tr>
                    <td valign="top">
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
                        <table xsl:use-attribute-sets="table">
                        <xsl:apply-templates select="$children" mode="ricochet">
                            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            <xsl:sort select="@ID" data-type="number" order="descending" />
                        </xsl:apply-templates>
                        </table>
                    </xsl:if>
                    <xsl:apply-templates select="." mode="buildurl" />
                </td>
                <xsl:if test="string-length(THUMBNAIL) &gt; 0">
                    <td width="*" align="right" style="text-align:right;" valign="top">
                        <xsl:apply-templates select="THUMBNAIL" />
                    </td>
                </xsl:if>
                </tr>
            </table>
        </td>
    </tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="ricochet">
    <xsl:variable name="id" select="@ID" />
    <tr>
        <td valign="top">
        <a name="{concat('top',$id)}" />
        <span style="padding-right:.25em;">&#x2022;</span>
        </td>
        <td>
        <xsl:apply-templates select="HEADLINE" mode="ricochet" />
        <xsl:apply-templates select="." mode="bolt" />
        </td>
    </tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="blast">
    <xsl:variable name="id" select="@ID" />
    <xsl:variable name="children" select="$allowedArticles[@PARENT=$id]" />
    <tr>
        <td xsl:use-attribute-sets="tdContent">
            <a name="{concat('top',$id)}" />
            <table xsl:use-attribute-sets="table" style="border-bottom:solid 1px {$colorBolt};padding-bottom:1em;margin-bottom:1.2em;">
                <tr>
                    <td valign="top">
                    <xsl:if test="$bBlastThumbs">
                    <xsl:apply-templates select="THUMBNAIL" />
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
                    <xsl:apply-templates select="ABSTRACT" />
                    <xsl:if test="string-length(SRCURL) or $bHosted">
                        <div style="padding-top:1.25em;padding-bottom:1.5em;">
                        <xsl:apply-templates select="." mode="buildurl" />
                      </div>
                    </xsl:if>
                    <xsl:if test="not($extRelated) and count($children) &gt; 0">
                        <table xsl:use-attribute-sets="table">
                        <xsl:apply-templates select="$children" mode="ricochet">
                            <xsl:sort select="SECTION/@ORDINAL" data-type="number" />
                            <xsl:sort select="@ID" data-type="number" order="descending" />
                        </xsl:apply-templates>
                        </table>
                    </xsl:if>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</xsl:template>

<xsl:template match="ARTICLE" mode="execsum">
    <xsl:variable name="id" select="@ID" />
    <tr>
        <td xsl:use-attribute-sets="tdContent">
            <table xsl:use-attribute-sets="table" style="border-bottom:solid 1px {$colorBolt};padding-bottom:1em;margin-bottom:1.2em;">
                <tr>
                    <td valign="top">
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

<xsl:template match="ARTICLE" mode="bolt">
    <xsl:variable name="bPD" select="xs:boolean(string-length(@PUBLISHDATE))" />
    <xsl:variable name="bAU" select="xs:boolean(string-length(AUTHOR[1]))" />
    <xsl:variable name="bPB" select="xs:boolean(string-length(PUBLICATION))" />
    <p class="bolt" style="font-family:{$styleFamilyBolt};color:{$colorBolt}">
        <xsl:value-of select="PUBLICATION" /> 
            <xsl:if test="$bPB and $bPD">
                &#xa0;|&#xa0;
            </xsl:if>
            <xsl:apply-templates select="@PUBLISHDATE" />
            <xsl:if test="$bPD and $bAU">
                &#xa0;|&#xa0;
            </xsl:if>
            <xsl:apply-templates select="AUTHOR" />
        </p>
</xsl:template>

<xsl:template match="THUMBNAIL">
    <img src="{.}" 
        width="100" height="100"
        style="object-fit:none;float:right; padding:1em;" />
</xsl:template>
                        
<xsl:template name="do-section-head">
    <xsl:param name="sectName" />
    <xsl:param name="sid" select="string('ts')" />
    <tr>
        <td xsl:use-attribute-sets="tdSectHead">
            <a name="sect{$sid}" id="sect{$sid}"></a>
            <table xsl:use-attribute-sets="table" style="padding-bottom:1em;padding-top:1.6em;">
                <tr>
                    <td width="1%" valign="bottom" style="white-space:nowrap;">
                        <span style="{$styleSectionHead}" class="sectionHead">
                            <xsl:value-of disable-output-escaping="yes" select="$sectName" />
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

<xsl:template name="do-issue-head">
    <xsl:param name="issName" />
    <tr>
        <td xsl:use-attribute-sets="tdIssueHead">
            <span style="{$styleIssueHead}" class="issueHead">
            <xsl:value-of disable-output-escaping="yes" select="$issName" />
            </span>
        </td>
    </tr>
</xsl:template>

<xsl:template match="HEADLINE" mode="bullets">
    <a style="color:{$colorLink};text-decoration:none;">
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
</xsl:template>

<xsl:template match="HEADLINE" mode="slugs">
    <p style="{$styleHeadline}" class="headline">
        <xsl:value-of disable-output-escaping="yes" select="." />
    </p>
</xsl:template>

<xsl:template match="HEADLINE" mode="ricochet">
    <p class="ricochet" style="{$styleChildHed}">
        <xsl:value-of disable-output-escaping="yes" select="." />
        <xsl:apply-templates select=".." mode="kidurl" />
    </p>
</xsl:template>

<xsl:template match="HEADLINE" mode="anchor">
    <a name="{../@ID}"  style="color:{$colorLink};text-decoration:none;float:right;" href="#top{../@ID}"><i>top</i></a>
    <p style="font-weight:bold;margin-bottom:0em;"><xsl:value-of disable-output-escaping="yes" select="." /></p>
</xsl:template>

<xsl:template match="SUBHEAD" mode="slugs">
    <xsl:if test="string-length(.)>0">
        <div style="{$styleSubHead}" class="subhead">
            <xsl:value-of disable-output-escaping="yes" select="." />
        </div>
    </xsl:if>
</xsl:template>

<xsl:template match="@MEDIAID[.!=0]">
    <img style="vertical-align:middle;padding-left:.5em;">
        <xsl:attribute name="src">
        <xsl:choose>
            <xsl:when test=".=1"><xsl:value-of select="$imgPic" /></xsl:when>
            <xsl:when test=".=2"><xsl:value-of select="$imgVid" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$imgAud" /></xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
    </img>
</xsl:template>

<xsl:template match="PUBLICATION" mode="bullets">
    <span style="margin:0em;margin-right:.2em;font-weight:bold;"><xsl:value-of disable-output-escaping="yes" select="." />:</span>
</xsl:template>

<xsl:template match="@PUBLISHDATE">
    <xsl:variable name="strDate" select="concat(substring(.,7),'-',substring(.,1,2),'-',substring(.,4,2))" />
    <xsl:value-of select="format-date(xs:date($strDate), $boltDateFormat,'en',(),())" />
</xsl:template>

<xsl:template match="AUTHOR">
    <xsl:choose>
        <xsl:when test="position()!=1 and position()!=last()">, </xsl:when>
        <xsl:when test="position()!=1 and position() =last()"> and </xsl:when>
        <xsl:otherwise />
    </xsl:choose>
    <xsl:if test="position()=1">By </xsl:if><xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="COPYRIGHT">
    <div>
        <span class="articleCopyright"><xsl:value-of disable-output-escaping="yes" select="." /></span>
    </div>
</xsl:template>

<xsl:template match="ABSTRACT">
    <div style="padding-top:.25em;" class="bodyText">
        <xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string(.),$keywords)" />
    </div>
</xsl:template>

<xsl:template match="PUBCOPYRIGHT">
    <div style="margin:0;padding:.5em;float:right;">
        <xsl:value-of disable-output-escaping="yes" select="." />
    </div>
</xsl:template>

<xsl:template name="ARTICLEBODY">
    <xsl:param name="article" />
    <div style="margin-top:1em;" class="bodyText">
        <xsl:value-of disable-output-escaping="yes" select="lbps:do-keywords(string($article),$keywords)" />
    </div>
</xsl:template>

<xsl:template match="SRCURL" mode="site">
    <div class="linkURL">
        <a href="{string(.)}" style="font-style:italic;">
            <xsl:apply-templates select="../@MEDIAID[.!=0]" />
            <xsl:choose>
                <xsl:when test="../@MEDIAID=2">
                    View the video at the source.
                </xsl:when>
                <xsl:when test="../@MEDIAID=3">
                    Hear the audio at the source. 
                </xsl:when>
                <xsl:when test="../@MEDIAID=1">
                    View the images at the source.
                </xsl:when>
                <xsl:otherwise>
                    Read this story at the source.
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </div>
</xsl:template>

<xsl:template match="SRCURL" mode="rights">
    <xsl:apply-templates select="../@MEDIAID[.!=0]" />
    Full content available at the source
    <a href="{string(.)}" style="font-style:italic;">
        here.
    </a>
</xsl:template>

<xsl:template match="MENTION">
    <span style="color:red;font-style:italic;margin-left:2em;"><xsl:value-of select="." /></span>
</xsl:template>

<xsl:template name="do-report-head">
    <tr>
        <td xsl:use-attribute-sets="tdHead">
            <img src="{$brandImgURL}" border="0" style="max-width:100% !important;"/>
        </td>
    </tr>
</xsl:template>

<xsl:template name="do-tags">
    <xsl:param name="AID" />
    <xsl:variable name="printTag" select="/CLIPSHEET/DIVISION[ARTICLE/@ID=$AID]" />
    <xsl:for-each select="$printTag">
            <span>
            <xsl:attribute name="class"><xsl:value-of select="@NAME" /> tag</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="@NAME" />
            </span>
    </xsl:for-each>
</xsl:template>

<xsl:template name="do-report-nav">
   <xsl:if test="string-length(/CLIPSHEET/TOPMSG) &gt; 0">
    <tr>
        <td align="center" style="text-align:center;height:3.75em;background-color:{$bgcolorNav};border-bottom:1px dotted;">
            <xsl:value-of disable-output-escaping="yes" select="/CLIPSHEET/TOPMSG" />
        </td>
    </tr>
</xsl:if>

<xsl:if test="count($sectList) &gt; 0">
    <tr>
        <td align="center" style="text-align:center;height:3.75em;background-color:{$bgcolorNav};">
            <xsl:apply-templates select="$sectList" mode="nav" /> 
        </td>
    </tr>
</xsl:if>
</xsl:template>

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
                        Prepared by <a href="{$lbCiteLink}" style="font-color:{$colorLink}">Lone Buffalo, LLC.</a>
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

<xsl:template name="do-report-foot">
    <tr>
        <td xsl:use-attribute-sets="tdContent">
            <hr />
            <table xsl:use-attribute-sets="table">
                <xsl:if test="string-length($bottommessage) &gt; 0">
                    <tr>
                        <td colspan="2" style="padding:1em;">
                            <xsl:value-of disable-output-escaping="yes" select="$bottommessage" />
                        </td>
                    </tr>
                </xsl:if>
            </table>
        </td>
    </tr>
</xsl:template>

<xsl:template name="do-GApixel">
    <xsl:param name="UAID" select="string('UA-1191451-29')" />
    <xsl:param name="gaCID" select="string('016458c3-fd2b-4008-b067-644bc3595d08')" />
    <xsl:variable name="gaEA" select="encode-for-uri($formatName)" />
    <xsl:variable name="gaEC" select="encode-for-uri($clientName)" />
    <xsl:variable name="gaEL" select="format-date(xs:date(substring($clipDate,1,10)), $dateArgFormat,'en',(),())" />
    <xsl:variable name="gaCS" select="encode-for-uri($clientName)" />
    <img src="https://www.google-analytics.com/collect?v=1&amp;tid={$UAID}&amp;cid={$gaCID}&amp;t=event&amp;ec={$gaEC}&amp;ea={$gaEA}&amp;el={$gaEL}&amp;ni=1&amp;sc=start" width="0" height="0" />
</xsl:template>

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

<xsl:attribute-set name="tdHead">
    <xsl:attribute name="style">
        max-width:<xsl:value-of select="$max-width" />px;
        display:block;clear:both;line-height:1.8;
    </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="tdContent">
    <xsl:attribute name="style">
        max-width:<xsl:value-of select="$max-width" />px;
        display:block;clear:both;padding-left:1em;padding-right:1em;
        line-height:1.8;
    </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="tdSectHead">
    <xsl:attribute name="style">
        max-width:<xsl:value-of select="$max-width" />px;
        display:block;clear:both;padding-left:1em;padding-right:1em;
    </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="tdIssueHead">
    <xsl:attribute name="style">
        max-width:<xsl:value-of select="$max-width" />px;
        display:block;clear:both;padding-left:2em;padding-right:1em;
    </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table">
    <xsl:attribute name="width">100%</xsl:attribute>
    <xsl:attribute name="border">0</xsl:attribute>
    <xsl:attribute name="cellspacing">0</xsl:attribute>
    <xsl:attribute name="cellpadding">0</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
