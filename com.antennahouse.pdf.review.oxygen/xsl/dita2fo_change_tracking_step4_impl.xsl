<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Stylesheet.
  Copyright © 2009-2020 Antenna House, Inc. All rights reserved.
  Antenna House is a trademark of Antenna House, Inc.
  URL    : http://www.antennahouse.com/
  E-mail : info@antennahouse.com
  ****************************************************************
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs map math ahf"
    version="3.0">
    
    <!--
       Step4: Comment processing instruction
     -->
    
    <!-- Comment features
        (1) Sometime comments PIs are nested each other. @mid expresses the range of one comment.
	         <p>The following
                <?oxy_comment_start author="toshi" timestamp="20250102T090534+0900" comment="Comment 1"?>symbols
                <?oxy_comment_start author="toshi" timestamp="20250102T090622+0900" comment="Nested comment 3" mid="6"?>are
                used<?oxy_comment_end?> in the
                <?oxy_comment_start author="toshi" timestamp="20250102T090600+0900" comment="Comment 2" mid="7"?>product<?oxy_comment_end mid="6"?>
                and user’s<?oxy_comment_end mid="7"?> manual to indicate that there are
                precautions for safety</p>
                
        (2) Sometimes comments are commented by another comment. @id and @parentId expresses the relationship of comments.
            <li id="li_B7B89E2F80574D109428E52091F4B9BA">In order to
              <?oxy_comment_start author="toshi" timestamp="20250102T051129+0900" comment="First comment" id="dzf_k3b_xdc"?>
              <?oxy_comment_start author="yuko" timestamp="20250102T051219+0900" parentID="dzf_k3b_xdc" comment="Good first comment!" mid="1"?>
              <?oxy_comment_start author="koichiro" timestamp="20250102T051403+0900" parentID="dzf_k3b_xdc" comment="Third comment!" mid="2"?>
              <?oxy_comment_start author="tomomi" timestamp="20250102T051425+0900" parentID="dzf_k3b_xdc" comment="Fouth comment!" mid="3"?>
              <?oxy_comment_start author="toshi" timestamp="20250102T051954+0900" parentID="dzf_k3b_xdc" comment="Reply!" mid="4"?>
              protect the system
              <?oxy_comment_end mid="4"?><?oxy_comment_end mid="3"?><?oxy_comment_end mid="2"?><?oxy_comment_end mid="1"?><?oxy_comment_end?>controlled
              by the product and the product itself and ensure safe operation, observe the
              safety precautions described in this user’s manual. We assume no liability for
              safety if users fail to observe these instructions when operating the product. </li>
              
         Limitation: If no text() exists between comment start PI and comment end PI and start/end PI is nested, this template generates multiple draft-comment elements for each.
    -->
    
    <xsl:mode name="MODE_STEP4" on-no-match="shallow-copy" use-accumulators="glCommentPi"/>
    
    <xsl:template match="*[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
        [. => ahf:nonTextChildElement()]
        [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
        mode="MODE_STEP4" priority="5">
        <xsl:param name="prmTopic"           as="element()"                  tunnel="yes" required="yes"/>
        <xsl:param name="prmCommentRangeMap" as="map(xs:string,node()*)"     tunnel="yes" required="yes"/>
        
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="processing-instruction()[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
        [. => ahf:isCommentStartPi()]
        [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
        mode="MODE_STEP4">
        <xsl:param name="prmTopic"           as="element()"              tunnel="yes" required="yes"/>
        <xsl:param name="prmCommentRangeMap" as="map(xs:string,node()*)" tunnel="yes" required="yes"/>
        
        <xsl:variable name="currentPi" as="processing-instruction()" select="."/>
        <xsl:variable name="currentPiXpath" as="xs:string" select="$currentPi => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep4Debug">
            <xsl:message select="'[processing-instruction] pi=' || ahf:getHistoryXpathStr(.)"/>
        </xsl:if>
        <xsl:copy/>
        <xsl:variable name="startPiXpath" as="xs:string?" select="accumulator-after('glCommentPi') => head() => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep4Debug">
            <xsl:message select="'$currentPiXpath='||$currentPiXpath"/>
            <xsl:message select="'$startPiXpath='||$startPiXpath"/>
        </xsl:if>
        <xsl:variable name="commentPiStartOrEndNode" as="node()*" select="if ($startPiXpath eq $currentPiXpath) then map:get($prmCommentRangeMap,$startPiXpath) else ()"/>
        <xsl:if test="$commentPiStartOrEndNode => exists() and ($commentPiStartOrEndNode[1] is $currentPi)">
            <xsl:if test="$gpStep4Debug">
                <xsl:message select="'[processing-instruction-stack] pi=',accumulator-after('glCommentPi')"/>
            </xsl:if>
            <xsl:call-template name="ahf:genDraftCommentFromCommentPis">
                <xsl:with-param name="prmCommentPi" select="accumulator-after('glCommentPi')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()
        [ancestor::*[@class => contains-token('topic/topic')] => exists()]
        [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
        mode="MODE_STEP4"
        >
        <xsl:param name="prmCommentRangeMap"  as="map(xs:string,node()*)"  tunnel="yes" required="yes"/>
        
        <xsl:variable name="currentText" as="text()" select="."/>
        <xsl:variable name="commentStartPi" as="processing-instruction()*" select="accumulator-before('glCommentPi')"/>
        <xsl:variable name="targetCommentStartPi" as="processing-instruction()*">
            <xsl:call-template name="ahf:getTargetCommentPi">
                <xsl:with-param name="prmCommentPi" as="processing-instruction()*" select="$commentStartPi"/>
                <xsl:with-param name="prmCurrent"   as="node()" select="$currentText"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="isCommented" as="xs:boolean" select="$commentStartPi => exists()"/>
        <xsl:choose>
            <xsl:when test="$isCommented">
                <xsl:variable name="commentFoProp" as="attribute()?">
                    <xsl:variable name="foProp" as="attribute()?" select="()"/>
                    <xsl:choose>
                        <xsl:when test="$isCommented">
                            <xsl:if test="$gpStep4Debug">
                                <xsl:message select="'[text(): ' || ahf:getHistoryXpathStr(.)"/>
                                <xsl:message select="'$startPI=',$commentStartPi ! ahf:getHistoryXpathStr(.)"/>
                            </xsl:if>
                            <xsl:copy-of select="$foProp => ahf:addBgColorToFoProp(ahf:getCommentBgColorSpecFromPi($commentStartPi))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$foProp"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <ph class="- topic/ph ">
                    <xsl:copy-of select="$commentFoProp"/>
                    <xsl:if test="$targetCommentStartPi => exists()">
                        <xsl:call-template name="ahf:genDraftCommentFromCommentPis">
                            <xsl:with-param name="prmCommentPi" select="$targetCommentStartPi"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:copy select="$currentText"/>
                </ph>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy select="$currentText"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

</xsl:stylesheet>