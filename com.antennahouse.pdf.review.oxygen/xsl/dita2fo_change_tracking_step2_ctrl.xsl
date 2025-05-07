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
        Step2: Insert split processing instruction
     -->
    <xsl:variable name="mesInsertSplitPiTargetElementNotFound" as="xs:string" select="'[Insert split PI] Target element is not found. PI='"/>
    <xsl:variable name="mesInsertSplitPiEndPiNotFound" as="xs:string" select="'[Insert split PI] Target insert end processing-instruction() is not found. PI='"/>
    
    <!-- Important notice:
         If insert split PI is the child of body, $targetElement is the first element that follows PI.
         If insert split PI is not the child of body, $targetElement is the parent element of PI.
     -->
    <xsl:template name="step2Ctrl">
        <xsl:param name="prmRoot" as="element()" required="yes"/>
        <xsl:param name="prmTopicAndUpperHistoryStr" as="xs:string" required="yes"/>
        <!-- Exclude PI that is the child of SVG or MathML elements -->
        <xsl:variable name="insertStartSplitPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[ahf:isInsertStartPi(.)][ahf:isInsertStartSplitPi(.)][ahf:isNotChildOfSvgOrMathMlElem(.)]"/>
        <xsl:choose>
            <xsl:when test="$insertStartSplitPis => exists() and $gpOutputOxyInserts">
                <xsl:variable name="insertSplitPiInfo" as="array(item())*">
                    <xsl:for-each select="$insertStartSplitPis">
                        <xsl:variable name="insertStartSplitPi" as="processing-instruction()" select="."/>
                        <xsl:variable name="isChildOfBody" as="xs:boolean" select="$insertStartSplitPi/parent::*[contains-token(@class,'topic/body')] => exists()"/>
                        <xsl:variable name="targetElement" as="element()?">
                            <xsl:choose>
                                <xsl:when test="$isChildOfBody">
                                    <xsl:sequence select="$insertStartSplitPi/following::*[1]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="$insertStartSplitPi/parent::*"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="insertSplitEndPi" as="processing-instruction()?">
                            <xsl:sequence select="$insertStartSplitPi/following::processing-instruction()[. => ahf:isInsertEndPi()][1]"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$targetElement => exists() and $insertSplitEndPi => exists()">
                                <xsl:sequence select="array{$insertStartSplitPi,$targetElement,$insertSplitEndPi}"/>
                            </xsl:when>
                            <xsl:when test="$targetElement => empty()">
                                <xsl:call-template name="errorContinueWithFileInfo">
                                    <xsl:with-param name="prmMes" select="$mesInsertSplitPiTargetElementNotFound || ahf:PiToText($insertStartSplitPi)"/>
                                    <xsl:with-param name="prmElem" select="$prmRoot"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="errorContinueWithFileInfo">
                                    <xsl:with-param name="prmMes" select="$mesInsertSplitPiEndPiNotFound || ahf:PiToText($insertStartSplitPi)"/>
                                    <xsl:with-param name="prmElem" select="$prmRoot"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="insertElement" as="element()*" select="ahf:arraySeqGet($insertSplitPiInfo,2)"/>
                <xsl:variable name="insertSplitStartPi" as="processing-instruction()*" select="ahf:arraySeqGet($insertSplitPiInfo,1)"/>
                <xsl:variable name="insertSplitEndPi" as="processing-instruction()*" select="ahf:arraySeqGet($insertSplitPiInfo,3)"/>
                <xsl:apply-templates select="$prmRoot" mode="MODE_STEP2">
                    <xsl:with-param name="prmInsertElement" as="element()*"  tunnel="yes" select="$insertElement"/>
                    <xsl:with-param name="prmInsertSplitStartPi"   as="processing-instruction()*" tunnel="yes" select="$insertSplitStartPi"/>
                    <xsl:with-param name="prmInsertSplitEndPi"   as="processing-instruction()*" tunnel="yes" select="$insertSplitEndPi"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" as="xs:string"       tunnel="yes" select="$prmTopicAndUpperHistoryStr"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$prmRoot"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>