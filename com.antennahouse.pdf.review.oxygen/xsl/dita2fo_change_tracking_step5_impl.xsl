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
    exclude-result-prefixes="xs math ahf"
    version="3.0">
    
    <!--
        Step5: Highlight processing instruction
     -->
    
    <xsl:mode name="MODE_STEP5" on-no-match="shallow-copy" use-accumulators="glHighlightPi"/>
    
    <xsl:template match="*" mode="MODE_STEP5">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()
        [ancestor::*[@class => contains-token('topic/topic')] => exists()]
        [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
        mode="MODE_STEP5"
        >
        <xsl:param name="prmHighlightRangeMap"  as="map(xs:string,node()*)"     tunnel="yes" required="yes"/>
        <xsl:variable name="currentText" as="text()" select="."/>
        <xsl:variable name="highlightStartPi" as="processing-instruction()?" select="accumulator-before('glHighlightPi') => head()"/>
        <xsl:variable name="isHighlighted" as="xs:boolean" select="$highlightStartPi => exists()"/>
        <xsl:choose>
            <xsl:when test="$isHighlighted">
                <!-- Target text is controlled by $prmHighlightRangeMap -->
                <xsl:variable name="inlineTexts" as="node()*" select="map:get($prmHighlightRangeMap, ahf:getHistoryXpathStr($highlightStartPi))"/>
                <xsl:choose>
                    <xsl:when test="$inlineTexts[. is $currentText]">
                        <xsl:variable name="highlightFoProp" as="attribute()?">
                            <xsl:variable name="foProp" as="attribute()" select="ahf:getEmptyChangeTrackingFoPropertyHighlight()"/>
                            <xsl:sequence select="$foProp => ahf:addBgColorToFoProp(ahf:getColorFromPi($highlightStartPi)) => ahf:filterEmptyAttr()"/>
                        </xsl:variable>
                        <ph class="- topic/ph ">
                            <xsl:copy select="$highlightFoProp"/>
                            <xsl:copy select="$currentText"/>
                        </ph>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy select="$currentText"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy select="$currentText"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>