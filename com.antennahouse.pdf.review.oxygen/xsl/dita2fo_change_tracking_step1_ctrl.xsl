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

    <xsl:template name="step1Ctrl">
        <xsl:param name="prmRoot" as="element()" required="yes"/>
        <xsl:param name="prmTopicAndUpperHistoryStr" as="xs:string" required="yes"></xsl:param>
        <xsl:variable name="insertSurroundPi" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[ahf:isInsertStartPi(.)][ahf:isInsertStartSurroundPi(.)]"/>
        <xsl:choose>
            <xsl:when test="$insertSurroundPi => exists() and $gpOutputOxyInserts">
                <xsl:variable name="insertElement" as="element()*">
                    <xsl:for-each select="$insertSurroundPi">
                        <xsl:variable name="pi" as="processing-instruction()" select="."/>
                        <xsl:variable name="targetElement" as="element()?" select="$pi/following-sibling::*[1]"/>
                        <xsl:variable name="insertEndPi" as="processing-instruction()?" select="$targetElement/child::processing-instruction()[. => ahf:isInsertEndPi()][1]"/>
                        <xsl:choose>
                            <xsl:when test="$targetElement => exists() and $insertEndPi => exists()">
                                <xsl:sequence select="$targetElement"/>
                            </xsl:when>
                            <xsl:when test="$targetElement => empty()">
                                <xsl:assert test="false()" select="'[Insert surround PI] Target element is not found. Invalid document'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:assert test="false()" select="'[Insert surround PI] Target insert end processing-instruction() is not found. Invalid document'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="insertSurroundEndPi" as="processing-instruction()*">
                    <xsl:for-each select="$insertSurroundPi">
                        <xsl:variable name="pi" as="processing-instruction()" select="."/>
                        <xsl:variable name="targetElement" as="element()?" select="$pi/following-sibling::*[1]"/>
                        <xsl:variable name="insertEndPi" as="processing-instruction()" select="$targetElement/child::processing-instruction()[. => ahf:isInsertEndPi()][1]"/>
                        <xsl:choose>
                            <xsl:when test="$targetElement => exists() and $insertEndPi => exists()">
                                <xsl:sequence select="$insertEndPi"/>
                            </xsl:when>
                            <xsl:when test="$targetElement => empty()">
                                <xsl:assert test="false()" select="'[Insert surround PI] Target element is not found. Invalid document'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:assert test="false()" select="'[Insert surround PI] Target end processing-instruction() is not found. Invalid document'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:apply-templates select="$prmRoot" mode="MODE_STEP1">
                    <xsl:with-param name="prmInsertElement" as="element()*"  tunnel="yes" select="$insertElement"/>
                    <xsl:with-param name="prmInsertSurroundEndPi"   as="processing-instruction()*" tunnel="yes" select="$insertSurroundEndPi"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" as="xs:string"       tunnel="yes" select="$prmTopicAndUpperHistoryStr"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$prmRoot"/>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:template>

</xsl:stylesheet>