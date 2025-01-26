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
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math ahf"
    version="3.0">
    
    <!--
        Step1: Insert surround processing instruction
     -->

    <xsl:mode name="MODE_STEP1" on-no-match="shallow-copy"/>
    
    <!-- 
     function:  Templates for elements that have preceding <?oxy_insert_start type="surround"?> 
     param:     
     return:    Itself and oxy_insert_end processing instruction
     note:      
     -->
    <xsl:template match="*" mode="MODE_STEP1" priority="5">
        <xsl:param name="prmInsertElement" as="element()*"  tunnel="yes" required="yes"/>
        <xsl:param name="prmTopicAndUpperHistoryStr" as="xs:string" tunnel="yes" required="yes"/>
        <xsl:variable name="elem" as="element()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmInsertElement[. is $elem] => exists()">
                <xsl:variable name="insertStartSurroundPi" as="processing-instruction()" select="$elem/preceding-sibling::processing-instruction()[ahf:isInsertStartSurroundPi(.)][1]"/>
                <xsl:variable name="insertFoProp" as="attribute()?">
                    <xsl:variable name="foProp" as="attribute()?" select="$elem/@*[name(.) eq $gpChangeTrackingFoPropName]"/>
                    <xsl:copy-of select="ahf:addColorToFoProp($foProp,ahf:getInsertFgColorSpecFromPi($insertStartSurroundPi)) => ahf:addInsertDecorationToFoProp()"/>
                </xsl:variable>
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>
                    <xsl:copy-of select="$insertFoProp"/>
                    <xsl:choose>
                        <xsl:when test="$elem[ahf:isMixedContentElement(.)]">
                            <ph class="- topic/ph ">
                                <xsl:copy-of select="$insertFoProp"/>
                                <xsl:copy-of select="ahf:addDraftComment(
                                    $cDraftCommentDispositionInsert, 
                                    $insertStartSurroundPi => ahf:getAuthorFromPi(), 
                                    $insertStartSurroundPi => ahf:getFormattedTimeStampStrFromPi(), 
                                    $insertStartSurroundPi => ahf:getCommentFromPi(),
                                    ahf:getHistoryStrWithPiTextFixed($insertStartSurroundPi,$prmTopicAndUpperHistoryStr))"/>
                            </ph>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="ahf:addDraftComment(
                                $cDraftCommentDispositionInsert, 
                                $insertStartSurroundPi => ahf:getAuthorFromPi(), 
                                $insertStartSurroundPi => ahf:getFormattedTimeStampStrFromPi(), 
                                $insertStartSurroundPi => ahf:getCommentFromPi(),
                                ahf:getHistoryStrWithPiTextFixed($insertStartSurroundPi,$prmTopicAndUpperHistoryStr))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates mode="#current"/>
                    <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionInsertSurroundEnd,
                        '', 
                        '', 
                        '',
                        ahf:getHistoryStrWithPiTextFixed($insertStartSurroundPi,$prmTopicAndUpperHistoryStr))"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="#current"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Templates for processing-instructions <?oxy_insert_start type="surround"?> 
     param:     
     return:    Dummy PI or itself
     note:      
     -->
    <xsl:template match="processing-instruction()[ahf:isInsertStartSurroundPi(.)]" mode="MODE_STEP1" priority="5">
        <xsl:param name="prmInsertSurroundStartPi" as="processing-instruction()*" tunnel="yes" required="yes"/>
        <xsl:variable name="pi" as="processing-instruction()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmInsertSurroundStartPi[. is $pi] => exists()">
                <xsl:processing-instruction name="{$cInsertStartPiSurroundName}">
                    <xsl:value-of select="string($pi)"/>
                </xsl:processing-instruction>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Templates for processing-instructions <?oxy_insert_end?> 
     param:     
     return:    Dummy PI or itself
     note:      
     -->
    <xsl:template match="processing-instruction()[ahf:isInsertEndPi(.)]" mode="MODE_STEP1" priority="5">
        <xsl:param name="prmInsertSurroundEndPi" as="processing-instruction()*"  tunnel="yes" required="yes"/>
        <xsl:variable name="pi" as="processing-instruction()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmInsertSurroundEndPi[. is $pi] => exists()">
                <xsl:processing-instruction name="{$cInsertEndPiSurroundName}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>