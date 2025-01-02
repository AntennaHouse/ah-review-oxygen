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
    exclude-result-prefixes="xs fo math ahf"
    version="3.0">
    
    <!--
        Step4: Comment processing instruction
     -->

    <xsl:template name="step4Ctrl">
        <xsl:param name="prmRoot" as="element()" required="yes"/>
        <xsl:param name="prmTopicAndUpperHistoryStr" as="xs:string" required="yes"/>
        <xsl:choose>
            <xsl:when test="($prmRoot => ahf:hasCommentPi()) and $gpOutputOxyComments">
                <xsl:variable name="commentRangeInlineMap" as="map(xs:string, node()*)">
                    <xsl:call-template name="generateCommentRangeInlineMap">
                        <xsl:with-param name="prmRoot" select="$prmRoot"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:apply-templates select="$prmRoot" mode="MODE_STEP4">
                    <xsl:with-param name="prmCommentRangeMap" as="map(xs:string,node()*)" tunnel="yes" select="$commentRangeInlineMap"/>
                    <xsl:with-param name="prmTopic"           as="element()"              tunnel="yes" select="$prmRoot"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" as="xs:string"      tunnel="yes" select="$prmTopicAndUpperHistoryStr"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$prmRoot"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>