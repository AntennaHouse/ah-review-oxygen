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
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    exclude-result-prefixes="xs map math ahf"
    version="3.0">
    
    <!-- Global Assignable Variable
         Comment processing instructions.
     -->
    <xsl:mode use-accumulators="glInsertPi glCommentPi glHighlightPi" on-no-match="shallow-copy"/>
    
    <!-- Accumulator acts as stack variable for insert, comment and highlight start/end processing instruction.
     -->
    <xsl:accumulator name="glInsertPi" as="processing-instruction()*" initial-value="()">
        <xsl:accumulator-rule match="processing-instruction()[ahf:isInsertStartPi(.)]" select="(., $value)"/>
        <xsl:accumulator-rule match="processing-instruction()[ahf:isInsertEndPi(.)]" select="remove($value,1)"/>
    </xsl:accumulator>

    <xsl:accumulator name="glCommentPi" as="processing-instruction()*" initial-value="()">
        <xsl:accumulator-rule match="processing-instruction()[ahf:isCommentStartPi(.)]" select="(., $value)"/>
        <xsl:accumulator-rule match="processing-instruction()[ahf:isCommentEndPi(.)]" select="ahf:removeStartPiFromAccumulator($value, .)"/>
    </xsl:accumulator>

    <xsl:accumulator name="glHighlightPi" as="processing-instruction()*" initial-value="()">
        <xsl:accumulator-rule match="processing-instruction()[ahf:isHighlightStartPi(.)]" select="(., $value)"/>
        <xsl:accumulator-rule match="processing-instruction()[ahf:isHighlightEndPi(.)]" select="remove($value,1)"/>
    </xsl:accumulator>
    
    <xsl:function name="ahf:removeStartPiFromAccumulator" as="processing-instruction()*">
        <xsl:param name="prmAccumulaterStartPi" as="processing-instruction()*"/>
        <xsl:param name="prmEndPi" as="processing-instruction()"/>
        <xsl:choose>
            <xsl:when test="$prmEndPi => ahf:hasMidPartInPi()">
                <xsl:variable name="mid" as="xs:string" select="$prmEndPi => ahf:getMidFromPiContent()"/>
                <xsl:sequence select="$prmAccumulaterStartPi[. => ahf:getMidFromPiContent() ne $mid]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="noMidPosStartPi" as="processing-instruction()" select="$prmAccumulaterStartPi[ahf:hasNoMidPartInPi(.)][1]"/>
                <xsl:sequence select="$prmAccumulaterStartPi[not(. is $noMidPosStartPi)]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  General Template
     param:     
     return:    Itself and child nodes.    
     note:		
     -->
    <!--xsl:template match="/" mode="#all" priority="5">
        <xsl:copy xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="#all">
        <xsl:copy/>
    </xsl:template-->

    <!--xsl:mode on-no-match="shallow-copy"/-->

    <!-- 
     function:  Topic Template
     param:     None
     return:    Topic itself and add draft-comment for oxy_xxx processing instruction
     note:      Topic has four steps:
                - Step1: Insert surround processing instruction
                - Step2: Insert split processing instruction
                - Step3: Insert, delete, attribute-change processing-instruction
                - Step4: Comment processing instruction
                - Step5: Highlight processing instruction
     -->
    <xsl:template match="*[@class => contains-token('topic/topic')][ancestor::*[@class => contains-token('topic/topic')] => empty()]">
        <xsl:variable name="topic" as="element()" select="."/>
        <xsl:variable name="topicAndUpperHistoryStr" as="xs:string" select="ahf:getHistoryStr($topic)"/>
        <xsl:variable name="step1Source" as="document-node()">
            <xsl:document>
                <xsl:copy-of select="$topic"/>
            </xsl:document>
        </xsl:variable>
        <xsl:variable name="step1Result" as="document-node()">
            <xsl:document>
                <xsl:variable name="root" as="element()" select="$step1Source/*[1]"/>
                <xsl:call-template name="step1Ctrl">
                    <xsl:with-param name="prmRoot" select="$root"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" select="$topicAndUpperHistoryStr"/>
                </xsl:call-template>
            </xsl:document>
        </xsl:variable>
        <xsl:if test="$gpStep1Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-1.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step1Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step2Result" as="document-node()">
            <xsl:document>
                <xsl:variable name="root" as="element()" select="$step1Result/*[1]"/>
                <xsl:call-template name="step2Ctrl">
                    <xsl:with-param name="prmRoot" select="$root"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" select="$topicAndUpperHistoryStr"/>
                </xsl:call-template>
            </xsl:document>
        </xsl:variable>
        <xsl:if test="$gpStep2Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-2.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step2Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step3Result" as="document-node()">
            <xsl:document>
                <xsl:variable name="root" as="element()" select="$step2Result/*[1]"/>
                <xsl:call-template name="step3Ctrl">
                    <xsl:with-param name="prmRoot" select="$root"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" select="$topicAndUpperHistoryStr"/>
                </xsl:call-template>
            </xsl:document>
        </xsl:variable>
        <xsl:if test="$gpStep3Debug or $gpStep4Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-3.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step3Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step4Result" as="document-node()">
            <xsl:document>
                <xsl:variable name="root" as="element()" select="$step3Result/*[1]"/>
                <xsl:call-template name="step4Ctrl">
                    <xsl:with-param name="prmRoot" select="$root"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" select="$topicAndUpperHistoryStr"/>
                </xsl:call-template>
            </xsl:document>
        </xsl:variable>
        <xsl:if test="$gpStep4Debug or $gpStep5Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-4.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step4Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step5Result" as="document-node()">
            <xsl:document>
                <xsl:variable name="root" as="element()" select="$step4Result/*[1]"/>
                <xsl:call-template name="step5Ctrl">
                    <xsl:with-param name="prmRoot" select="$root"/>
                    <xsl:with-param name="prmTopicAndUpperHistoryStr" select="$topicAndUpperHistoryStr"/>
                </xsl:call-template>
            </xsl:document>
        </xsl:variable>
        <xsl:if test="$gpStep5Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-5.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step5Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:copy-of select="$step5Result"/>
    </xsl:template>
    
</xsl:stylesheet>