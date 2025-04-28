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
        Step3: Insert, delete, attribute-change processing-instruction
     -->

    <xsl:template name="step3Ctrl">
        <xsl:param name="prmRoot" as="element()" required="yes"/>
        <xsl:param name="prmTopicAndUpperHistoryStr" as="xs:string" required="yes"/>
        <xsl:choose>
            <xsl:when test="($prmRoot => ahf:hasInsertPi() and $gpOutputOxyInserts) or ($prmRoot => ahf:hasDeletePi() and $gpOutputOxyDeletes) or ($prmRoot => ahf:hasAttributeChangePi() and $gpOutputOxyAttributes)">
                <!-- PI that is the child of SVG or MathML elements are excluded in this map-->
                <xsl:variable name="insertRangeInlineMap" as="map(xs:string, node()*)">
                    <xsl:call-template name="generateInsertRangeInlineMap">
                        <xsl:with-param name="prmRoot" select="$prmRoot"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:apply-templates select="$prmRoot" mode="MODE_STEP3">
                    <xsl:with-param name="prmInsertRangeMap" as="map(xs:string, node()*)"  tunnel="yes" select="$insertRangeInlineMap"/>
                    <xsl:with-param name="prmTopic"          as="element()"                tunnel="yes" select="$prmRoot"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" as="xs:string"       tunnel="yes" select="$prmTopicAndUpperHistoryStr"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$prmRoot"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>