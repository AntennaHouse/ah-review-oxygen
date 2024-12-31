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
                <xsl:message select="'[processing-instruction] pi=',accumulator-after('glCommentPi')"/>
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