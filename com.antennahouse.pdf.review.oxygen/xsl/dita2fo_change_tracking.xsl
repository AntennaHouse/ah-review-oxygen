<?xml version="1.0" encoding="UTF-8"?>
<!--  ****************************************************************
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
    <xsl:mode use-accumulators="glInsertPi glCommentPi glHighlightPi"/>
    
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
    <xsl:template match="/" mode="#all" priority="5">
        <xsl:copy xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node()" mode="#all">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="#all">
        <xsl:copy/>
    </xsl:template>
    
    <!-- 
     function:  Topic Template
     param:     None
     return:    Topic itself and add draft-comment for oxy_xxx processing instruction
     note:      Topic has four steps:
                - Step1: Insert surround processing instruction
                - Step2: Insert, delete, attribute-change processing-instruction
                - Step3: Comment processing instruction
                - Step4: Highlight processing instruction
                In the step 2, pass map{insert end node, insert start id} as tunnel parameter to close fo:change-bar.
     -->
    <xsl:template match="*[@class => contains-token('topic/topic')][ancestor::*[@class => contains-token('topic/topic')] => empty()]" as="element()">
        <xsl:variable name="topic" as="element()" select="."/>
        <xsl:variable name="step1Result" as="element()">
            <xsl:variable name="root" as="element()" select="$topic"/>
            <xsl:variable name="insertSurroundPi" as="processing-instruction()*" select="$root/descendant-or-self::processing-instruction()[. => ahf:isInsertStartPi()][. => ahf:getTypeFromPi() => string() eq 'surround']"/>
            <xsl:choose>
                <xsl:when test="$insertSurroundPi => exists()">
                    <xsl:variable name="insertElement" as="element()*">
                        <xsl:for-each select="$insertSurroundPi">
                            <xsl:variable name="pi" as="processing-instruction()" select="."/>
                            <xsl:variable name="targetElement" as="element()?" select="$pi/following-sibling::*[1]"/>
                            <xsl:variable name="insertEndPi" as="processing-instruction()?" select="$pi/following::processing-instruction()[. => ahf:isInsertEndPi()][1]"/>
                            <xsl:if test="$targetElement => exists() and $insertEndPi => exists()">
                                <xsl:sequence select="$targetElement"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="insertEndPi" as="processing-instruction()*">
                        <xsl:for-each select="$insertSurroundPi">
                            <xsl:variable name="pi" as="processing-instruction()" select="."/>
                            <xsl:variable name="targetElement" as="element()?" select="$pi/following-sibling::*[1]"/>
                            <xsl:variable name="insertEndPi" as="processing-instruction()?" select="$pi/following::processing-instruction()[. => ahf:isInsertEndPi()][1]"/>
                            <xsl:if test="$targetElement => exists() and $insertEndPi => exists()">
                                <xsl:sequence select="$insertEndPi"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:apply-templates select="$root" mode="MODE_STEP1">
                        <xsl:with-param name="prmInsertElement" as="element()*"  tunnel="yes" select="$insertElement"/>
                        <xsl:with-param name="prmInsertEndPi"   as="processing-instruction()*" tunnel="yes" select="$insertEndPi"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$root"/>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:variable>
        <xsl:if test="$gpStep1Debug or $gpStep2Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-1.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step1Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step2Result" as="element()">
            <xsl:variable name="root" as="element()" select="$step1Result"/>
            <xsl:choose>
                <xsl:when test="($root => ahf:hasInsertPi() or $root => ahf:hasDeletePi() or $root => ahf:hasAttributeChangePi()) and $gpOutputOxyChanges">
                    <xsl:variable name="insertRangeInlineMap" as="map(xs:string, node()*)">
                        <xsl:call-template name="generateInsertRangeInlineMap">
                            <xsl:with-param name="prmRoot" select="$root"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:apply-templates select="$root" mode="MODE_STEP2">
                        <xsl:with-param name="prmInsertRangeMap" as="map(xs:string, node()*)"  tunnel="yes" select="$insertRangeInlineMap"/>
                        <xsl:with-param name="prmTopic"          as="element()"                tunnel="yes" select="$root"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$root"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$gpStep2Debug or $gpStep3Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-2.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step2Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step3Result" as="element()">
            <xsl:variable name="root" as="element()" select="$step2Result"/>
            <xsl:choose>
                <xsl:when test="($root => ahf:hasCommentPi()) and $gpOutputOxyComments">
                    <xsl:variable name="commentRangeInlineMap" as="map(xs:string, node()*)">
                        <xsl:call-template name="generateCommentRangeInlineMap">
                            <xsl:with-param name="prmRoot" select="$root"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:apply-templates select="$root" mode="MODE_STEP3">
                        <xsl:with-param name="prmCommentRangeMap" as="map(xs:string,node()*)" tunnel="yes" select="$commentRangeInlineMap"/>
                        <xsl:with-param name="prmTopic"           as="element()"              tunnel="yes" select="$root"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$root"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$gpStep3Debug or $gpStep4Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-3.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step3Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:variable name="step4Result" as="element()">
            <xsl:variable name="root" as="element()" select="$step3Result"/>
            <xsl:choose>
                <xsl:when test="($root => ahf:hasHighlightPi()) and $gpOutputOxyHilights">
                    <xsl:variable name="highlightRangeInlineMap" as="map(xs:string, node()*)">
                        <xsl:call-template name="generateHighlightRangeInlineMap">
                            <xsl:with-param name="prmRoot" select="$root"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:apply-templates select="$root" mode="MODE_STEP4">
                        <xsl:with-param name="prmHighlightRangeMap" as="map(xs:string,node()*)" tunnel="yes" select="$highlightRangeInlineMap"/>
                        <xsl:with-param name="prmTopic" as="element()" tunnel="yes" select="$root"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$root"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$gpStep4Debug">
            <xsl:result-document href="{ahf:getHistoryStr($topic) || '-4.xml'}" exclude-result-prefixes="#all" byte-order-mark="no" encoding="UTF-8" method="xml" indent="no">
                <xsl:copy-of select="$step4Result"/>
            </xsl:result-document>
        </xsl:if>
        <xsl:sequence select="$step4Result"/>
    </xsl:template>

    <!-- 
     function:  Templates for elements that have preceding <?oxy_insert_start type="surround"?> 
     param:     
     return:    Itself and oxy_insert_end processing instruction
     note:      
     -->
    <xsl:template match="*" mode="MODE_STEP1" priority="5">
        <xsl:param name="prmInsertElement" as="element()*"  tunnel="yes" required="yes"/>
        <xsl:variable name="elem" as="element()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmInsertElement[. is $elem] => exists()">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:copy>
                <xsl:processing-instruction name="{$cInsertEndPiName}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates mode="#current"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  Templates for processing-instructions <?oxy_insert_end?> 
     param:     
     return:    None or itself
     note:      
     -->
    <xsl:template match="processing-instruction()[. => ahf:isInsertEndPi()]" mode="MODE_STEP1" priority="5">
        <xsl:param name="prmInsertEndPi" as="processing-instruction()*"  tunnel="yes" required="yes"/>
        <xsl:variable name="pi" as="processing-instruction()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmInsertEndPi[. is $pi] => exists()">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Templates for elements that have no text() 
     param:     
     return:    Itself
     note:      Remove descendant of prolog element.
                Group child nodes by oXygen processing-instruction pattern and pass tunnel parameter.
     -->
    <xsl:template match="*[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
                          [. => ahf:nonTextChildElement()]
                          [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP2" priority="5">
        <xsl:param name="prmTopic"                     as="element()"                tunnel="yes" required="yes"/>
        <xsl:param name="prmInsertRangeMap"            as="map(xs:string, node()*)"  tunnel="yes" required="yes"/>
        <xsl:param name="prmAttributesAnnotationProps" as="attribute()*" required="no" select="()"/>
        
        <xsl:variable name="currentElem" as="element()" select="."/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[MODE_STEP2] currentElem=',$currentElem"/>
        </xsl:if>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="$prmAttributesAnnotationProps"/>
            <xsl:for-each-group select="node()" group-adjacent=". => ahf:genPiEnclosingPatternFirstMode($prmTopic)">
                <xsl:variable name="nodeGrouped" as="node()+" select="current-group()"/>
                <xsl:variable name="groupKey" as="xs:string" select="current-grouping-key()"/>
                <xsl:variable name="isDeletePi" as="xs:boolean" select="$groupKey => ahf:isPatternDeletePi()"/>
                <xsl:variable name="isFirstElementAfterAttributesPi" as="xs:boolean" select="$groupKey => ahf:isPatternFirstElementAfterAttributesPi()"/>
                <xsl:if test="$gpStep2Debug">
                    <xsl:message select="'[MODE_STEP2] $groupKey=',$groupKey,' $nodeGrouped=',$nodeGrouped" />
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$isDeletePi">
                        <xsl:variable name="deletePi" as="processing-instruction()" select="$nodeGrouped[1]"/>
                        <xsl:variable name="deleteFoProp" as="attribute()" select="ahf:addColorToFoProp((),ahf:getDeleteFgColorSpecFromPi($deletePi)) => ahf:addDeleteDecorationToFoProp()"/>
                        <xsl:choose>
                            <xsl:when test="parent::*[@class => contains-token('topic/body')]">
                                <bodydiv class="- topic/bodydiv ">
                                    <xsl:call-template name="genDeletePiContents">
                                        <xsl:with-param name="prmDeletePi" select="$deletePi"/>
                                        <xsl:with-param name="prmDeleteFoProp" select="$deleteFoProp"/>
                                    </xsl:call-template>
                                </bodydiv>
                            </xsl:when>
                            <xsl:when test="parent::*[@class => contains-token('task/steps')]">
                                <step class="- topic/li task/step " outputclass="{$cOutputClassDeleteAttributesLi}">
                                    <cmd class="- topic/ph task/cmd ">
                                        <xsl:call-template name="genDeletePiContents">
                                            <xsl:with-param name="prmDeletePi" select="$deletePi"/>
                                            <xsl:with-param name="prmDeleteFoProp" select="$deleteFoProp"/>
                                        </xsl:call-template>
                                    </cmd>
                                </step>
                            </xsl:when>
                            <xsl:when test="parent::*[@class => ahf:seqContainsToken(('topic/ol','topic/ul'))]">
                                <li class="- topic/li " outputclass="{$cOutputClassDeleteAttributesLi}">
                                    <xsl:call-template name="genDeletePiContents">
                                        <xsl:with-param name="prmDeletePi" select="$deletePi"/>
                                        <xsl:with-param name="prmDeleteFoProp" select="$deleteFoProp"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:when test="parent::*[@class => contains-token('topic/sl')]">
                                <sli class="- topic/sli ">
                                    <xsl:call-template name="genDeletePiContents">
                                        <xsl:with-param name="prmDeletePi" select="$deletePi"/>
                                        <xsl:with-param name="prmDeleteFoProp" select="$deleteFoProp"/>
                                    </xsl:call-template>
                                </sli>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$isFirstElementAfterAttributesPi">
                        <xsl:variable name="firstElementAfterAttributesPi" as="element()" select="$nodeGrouped[1]"/>
                        <xsl:variable name="attributesPi" as="processing-instruction()" select="$firstElementAfterAttributesPi/preceding-sibling::processing-instruction()[. => ahf:isAttributeChangePi()][1]"/>
                        <!-- Here, add directly annotation property -->
                        <xsl:apply-templates select="$firstElementAfterAttributesPi" mode="#current">
                            <xsl:with-param name="prmAttributesAnnotationProps" as="attribute()*">
                                <xsl:copy-of select="$atsAnnotationAttributesForNoTextChildElement"/>
                                <xsl:attribute name="axf:annotation-contents" select="ahf:genCommentsFromAttributesPi($attributesPi,$firstElementAfterAttributesPi)"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$nodeGrouped" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
     function:  Generate Delete PI contents
     param:     prmDeletePi, prmDeleteFoProp
     return:    ph with draft-comment
     note:      
     -->
    <xsl:template name="genDeletePiContents" as="element()">
        <xsl:param name="prmDeletePi" as="processing-instruction()"/>
        <xsl:param name="prmDeleteFoProp" as="attribute()"/>
        <ph class="- topic/ph ">
            <xsl:copy-of select="$prmDeleteFoProp"/>
            <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionDelete, 
                                                     $prmDeletePi => ahf:getAuthorFromPi(), 
                                                     $prmDeletePi => ahf:getFormattedTimeStampStrFromPi(), 
                                                     $prmDeletePi => ahf:getCommentFromPi(), 
                                                     ahf:getHistoryStrWithPiText($prmDeletePi))"/>
            <xsl:choose>
                <xsl:when test="$gpChangeTrackingIncludeTagInDeleteContent">
                    <xsl:value-of select="$prmDeletePi => ahf:getContentFromPi() => ahf:unEscapeXmlChar()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$prmDeletePi => ahf:getContentFromPi() => ahf:unEscapeXmlChar() => ahf:parseXmlFragmentEx() => string()"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionDeleteEnd, 
                                                     $prmDeletePi => ahf:getAuthorFromPi(), 
                                                     $prmDeletePi => ahf:getFormattedTimeStampStrFromPi(), 
                                                     '', 
                                                     ahf:getHistoryStrWithPiText($prmDeletePi))"/>
        </ph>
    </xsl:template>

    <xsl:template match="*[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
                          [. => ahf:nonTextChildElement()]
                          [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP3" priority="5">
        <xsl:param name="prmTopic"           as="element()"                  tunnel="yes" required="yes"/>
        <xsl:param name="prmCommentRangeMap" as="map(xs:string,node()*)"     tunnel="yes" required="yes"/>

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[ancestor::*[@class => contains-token('topic/topic')] => exists()]
                          [. => ahf:nonTextChildElement()]
                          [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP4">
        <xsl:param name="prmTopic"             as="element()"                  tunnel="yes" required="yes"/>
        <xsl:param name="prmHighlightRangeMap" as="map(xs:string,node()*)"     tunnel="yes" required="yes"/>

        <xsl:variable name="currentElem" as="element()" select="."/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <!-- 
     function:  Generate PI enclosing pattern string
     param:     prmNode, prmRoot
     return:    xs:string
     note:      There are four possible patterns:
                1. $prmNode is enclosed by <?oxy_comment_start?>～<?oxy_comment_end?>.
                2. $prmNode is enclosed by <?oxy_custom_start type="oxy_content_highlight"?>～<?oxy_custom_end?>.
                3. $prmNode is <?oxy_delete?> itself.
                4. $prmNode is the first element of after <?oxy_attributes?> PI.
                Revised comment based on implementation. 2024-11-05 t.makita
                Return: String
                  First char:  "1" $prmNode is delete PI itself
                               "0" $prmNode is not delete PI
                  Second char: "1" $prmNode is first element after attribute change PI
                               "0" $prmNode is not first element after attribute change PI
     -->
    <xsl:variable name="commentCountPic" as="xs:string" select="'000'"/>

    <xsl:function name="ahf:genPiEnclosingPatternFirstMode" as="xs:string">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:param name="prmRoot" as="node()"/>
        <xsl:variable name="patternIsDeletePi" as="xs:string" select="if ($prmNode[. => ahf:isDeletePi()] => exists()) then '1' else '0'"/>
        <xsl:variable name="patternIsFirstElementAfterAttributesPi" as="xs:string" select="if ($prmNode[. => ahf:isFirstElementAfterAttributeChangePi()] => exists()) then '1' else '0'"/>
        <xsl:sequence select="$patternIsDeletePi || $patternIsFirstElementAfterAttributesPi"/>
    </xsl:function>
    
    <xsl:function name="ahf:isPatternDeletePi" as="xs:boolean">
        <xsl:param name="prmPattern" as="xs:string"/>
        <xsl:sequence select="$prmPattern => substring(1, 1) eq '1'"/>
    </xsl:function>
    
    <xsl:function name="ahf:isPatternFirstElementAfterAttributesPi" as="xs:boolean">
        <xsl:param name="prmPattern" as="xs:string"/>
        <xsl:sequence select="$prmPattern => substring(2,1) eq '1'"/>
    </xsl:function>
    
    <!-- 
     function:  Templates for elements that can have text() & elements as the child node
     param:     
     return:    Itself
     note:      Remove descendant of prolog element.
                If $prmIsInserted = "true()", set @color="[insert color]"
                draft-comment will be converted into PDF annotation.
     -->
    <xsl:template match="*[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
                          [. => ahf:isMixedContentElement()]
                          [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP2">
        <xsl:param name="prmTopic"                     as="element()"                  tunnel="yes" required="yes"/>
        <xsl:param name="prmInsertRangeMap"            as="map(xs:string, node()*)"  tunnel="yes" required="yes"/>
        <xsl:param name="prmAttributesAnnotationProps" as="attribute()*" required="no" select="()"/>
        
        <xsl:variable name="currentElem" as="element()" select="."/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[ahf:isMixedContentElement()] ' || ahf:getHistoryXpathStr(.)"/>
        </xsl:if>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="$prmAttributesAnnotationProps"/>
            <xsl:for-each-group select="node()" group-adjacent=". => ahf:genPiEnclosingPatternFirstMode($prmTopic)">
                <xsl:variable name="nodeGrouped" as="node()+" select="current-group()"/>
                <xsl:variable name="groupKey" as="xs:string" select="current-grouping-key()"/>
                <xsl:variable name="isDeletePi" as="xs:boolean" select="$groupKey => ahf:isPatternDeletePi()"/>
                <xsl:variable name="isFirstElementAfterAttributesPi" as="xs:boolean" select="$groupKey => ahf:isPatternFirstElementAfterAttributesPi()"/>
                <xsl:choose>
                    <xsl:when test="$isDeletePi">
                        <xsl:variable name="deletePi" as="processing-instruction()" select="$nodeGrouped[1]"/>
                        <xsl:if test="$gpStep2Debug">
                            <xsl:message select="'$deletePi=',$deletePi"/>
                        </xsl:if>
                        <xsl:variable name="deleteFoProp" as="attribute()" select="ahf:addColorToFoProp((),ahf:getDeleteFgColorSpecFromPi($deletePi)) => ahf:addDeleteDecorationToFoProp()"/>
                        <ph class="- topic/ph ">
                            <xsl:copy-of select="$deleteFoProp"/>
                            <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionDelete, 
                                                                     $deletePi => ahf:getAuthorFromPi(), 
                                                                     $deletePi => ahf:getFormattedTimeStampStrFromPi(), 
                                                                     $deletePi => ahf:getCommentFromPi(), 
                                                                     ahf:getHistoryStrWithPiText($deletePi))"/>
                            <xsl:value-of select="$deletePi => ahf:getContentFromPi() => ahf:unEscapeXmlChar()"/>
                            <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionDeleteEnd, 
                                                                     $deletePi => ahf:getAuthorFromPi(), 
                                                                     $deletePi => ahf:getFormattedTimeStampStrFromPi(), 
                                                                     '', 
                                                                     ahf:getHistoryStrWithPiText($deletePi))"/>
                        </ph>
                    </xsl:when>
                    <xsl:when test="$isFirstElementAfterAttributesPi">
                        <xsl:variable name="firstElementAfterAttributesPi" as="element()" select="$nodeGrouped[1]"/>
                        <xsl:variable name="attributesPi" as="processing-instruction()" select="$firstElementAfterAttributesPi/preceding-sibling::processing-instruction()[. => ahf:isAttributeChangePi()][1]"/>
                        <!-- Here, add directly annotation property -->
                        <xsl:apply-templates select="$firstElementAfterAttributesPi" mode="#current">
                            <xsl:with-param name="prmAttributesAnnotationProps" as="attribute()*">
                                <xsl:copy-of select="$atsAnnotationAttributes"/>
                                <xsl:attribute name="axf:annotation-contents" select="ahf:genCommentsFromAttributesPi($attributesPi,$firstElementAfterAttributesPi)"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$nodeGrouped" mode="#current"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[ancestor::*[@class => contains-token('topic/topic')] => exists()]
                          [. => ahf:isMixedContentElement()]
                          [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP4">
        <xsl:param name="prmTopic"                 as="element()"                  tunnel="yes" required="yes"/>
        <xsl:param name="prmHighlightRangeMap"     as="map(xs:string,node()*)"     tunnel="yes" required="yes"/>
        
        <xsl:variable name="currentElem" as="element()" select="."/>
        <xsl:if test="$gpStep4Debug">
            <xsl:message select="'[ahf:isMixedContentElement()] ' || ahf:getHistoryXpathStr(.)"/>
        </xsl:if>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <!-- Don't handle processing instruction on element level.
                 It should be handles in text() level.
             -->
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <!-- 
     function:  Templates for processing-instrution() 
     param:     See probe
     return:    ph or itself
     note:      
     -->
    <xsl:template match="processing-instruction()[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
                                                 [. => ahf:isInsertStartPi()]
                                                 (: [./parent::* => ahf:isMixedContentElement()] :)
                                                 [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP2">
        <xsl:param name="prmTopic"          as="element()"              tunnel="yes" required="yes"/>
        <xsl:param name="prmInsertRangeMap" as="map(xs:string,node()*)" tunnel="yes" required="yes"/>
        
        <xsl:variable name="insertPi" as="processing-instruction()" select="."/>
        <xsl:variable name="insertPiXpath" as="xs:string" select="$insertPi => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[processing-instruction] pi=' || ahf:getHistoryXpathStr(.)"/>
        </xsl:if>
        <xsl:copy/>
        <xsl:variable name="startPiXpath" as="xs:string?" select="accumulator-after('glInsertPi') => head() => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'$insertPiXpath='||$insertPiXpath"/>
            <xsl:message select="'$startPiXpath='||$startPiXpath"/>
        </xsl:if>
        <xsl:variable name="insertPiStartOrEndNode" as="node()*" select="if ($startPiXpath eq $insertPiXpath) then map:get($prmInsertRangeMap,$startPiXpath) else ()"/>
        <xsl:if test="$insertPiStartOrEndNode => exists() and ($insertPiStartOrEndNode[1] is $insertPi)">
            <xsl:if test="$gpStep2Debug">
                <xsl:message select="'[processing-instruction] pi=',accumulator-after('glInsertPi')"/>
            </xsl:if>
            <xsl:variable name="insertFoProp" as="attribute()?">
                <xsl:variable name="foProp" as="attribute()?" select="()"/>
                <xsl:copy-of select="ahf:addColorToFoProp($foProp,ahf:getInsertFgColorSpecFromPi($insertPi)) => ahf:addInsertDecorationToFoProp()"/>
            </xsl:variable>
            <xsl:variable name="type" as="xs:string" select="ahf:getTypeFromPi($insertPi) => string()"/>
            <xsl:choose>
                <xsl:when test="$insertPi/parent::*[ahf:isMixedContentElement(.)]">
                    <ph class="- topic/ph ">
                        <xsl:copy-of select="$insertFoProp"/>
                        <xsl:copy-of select="ahf:addDraftComment(if ($type eq 'split') then $cDraftCommentDispositionInsertSplit else $cDraftCommentDispositionInsert, 
                            $insertPi => ahf:getAuthorFromPi(), 
                            $insertPi => ahf:getFormattedTimeStampStrFromPi(), 
                            $insertPi => ahf:getCommentFromPi(),
                            ahf:getHistoryStrWithPiText($insertPi))"/>
                    </ph>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="ahf:addDraftComment(if ($type eq 'split') then $cDraftCommentDispositionInsertSplit else $cDraftCommentDispositionInsert, 
                        $insertPi => ahf:getAuthorFromPi(), 
                        $insertPi => ahf:getFormattedTimeStampStrFromPi(), 
                        $insertPi => ahf:getCommentFromPi(),
                        ahf:getHistoryStrWithPiText($insertPi))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Remove parent condition: [./parent::* => ahf:isMixedContentElement()]
         to generate fo:change-bar-end normally. 
         2023-11-30 t.makita 
     -->
    <xsl:template match="processing-instruction()[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
                                                 [. => ahf:isInsertEndPi()]
                                                 [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP2">
        <xsl:param name="prmTopic"          as="element()"              tunnel="yes" required="yes"/>
        <xsl:param name="prmInsertRangeMap" as="map(xs:string,node()*)" tunnel="yes" required="yes"/>

        <xsl:variable name="insertEndPi" as="processing-instruction()" select="."/>
        <xsl:variable name="insertPi" as="processing-instruction()" select="$prmTopic/descendant::processing-instruction()[. => ahf:isInsertStartPi()][. => ahf:isBeforeOrSelfNode($insertEndPi)][last()]"/>
        <xsl:variable name="insertPiXpath" as="xs:string" select="$insertPi => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[processing-instruction] pi=' || ahf:getHistoryXpathStr(.)"/>
        </xsl:if>
        <xsl:copy/>
        <xsl:variable name="startPiXpath" as="xs:string?" select="$insertPi => ahf:getHistoryXpathStr()"/>
        <xsl:variable name="insertPiStartOrEndNode" as="node()*" select="if ($startPiXpath eq $insertPiXpath) then map:get($prmInsertRangeMap,$startPiXpath) else ()"/>
        <xsl:if test="$insertPiStartOrEndNode => exists() and ($insertPiStartOrEndNode[2] is $insertEndPi)">
            <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionInsertEnd,
                                                     '', 
                                                     '', 
                                                     '',
                                                     ahf:getHistoryStrWithPiText($insertPi))"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="processing-instruction()[ancestor-or-self::*[@class => contains-token('topic/topic')] => exists()]
                                                 [. => ahf:isCommentStartPi()]
                                                 [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP3">
        <xsl:param name="prmTopic"           as="element()"              tunnel="yes" required="yes"/>
        <xsl:param name="prmCommentRangeMap" as="map(xs:string,node()*)" tunnel="yes" required="yes"/>
        
        <xsl:variable name="currentPi" as="processing-instruction()" select="."/>
        <xsl:variable name="currentPiXpath" as="xs:string" select="$currentPi => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep3Debug">
            <xsl:message select="'[processing-instruction] pi=' || ahf:getHistoryXpathStr(.)"/>
        </xsl:if>
        <xsl:copy/>
        <xsl:variable name="startPiXpath" as="xs:string?" select="accumulator-after('glCommentPi') => head() => ahf:getHistoryXpathStr()"/>
        <xsl:if test="$gpStep3Debug">
            <xsl:message select="'$currentPiXpath='||$currentPiXpath"/>
            <xsl:message select="'$startPiXpath='||$startPiXpath"/>
        </xsl:if>
        <xsl:variable name="commentPiStartOrEndNode" as="node()*" select="if ($startPiXpath eq $currentPiXpath) then map:get($prmCommentRangeMap,$startPiXpath) else ()"/>
        <xsl:if test="$commentPiStartOrEndNode => exists() and ($commentPiStartOrEndNode[1] is $currentPi)">
            <xsl:if test="$gpStep3Debug">
                <xsl:message select="'[processing-instruction] pi=',accumulator-after('glCommentPi')"/>
            </xsl:if>
            <xsl:call-template name="ahf:genDraftCommentFromCommentPis">
                <xsl:with-param name="prmCommentPi" select="accumulator-after('glCommentPi')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  Templates for text() 
     param:     See probe
     return:    ph or itself
     note:      Remove descendant of prolog element.
                If $prmIsInserted = "true()", set @color="[insert color]"
                draft-comment will be converted into PDF annotation.
     -->
    <xsl:template match="text()[ancestor::*[@class => contains-token('topic/topic')] => exists()]
                               [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                mode="MODE_STEP2"
        >
        <xsl:param name="prmInsertRangeMap" as="map(xs:string, node()*)"  tunnel="yes" required="yes"/>
        
        <xsl:variable name="currentText" as="text()" select="."/>
        <xsl:variable name="insertPi" as="processing-instruction()?" select="accumulator-before('glInsertPi') => head()"/>
        <xsl:variable name="isInserted" as="xs:boolean" select="$insertPi => exists()"/>
        <xsl:variable name="insertInlineStartAndEnd" as="node()*" select="if ($isInserted) then map:get($prmInsertRangeMap,$insertPi => ahf:getHistoryXpathStr()) else ()"/>
        
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[text(MODE_STEP2)] ' || ahf:getHistoryXpathStr(.)"/>
            <xsl:message select="'[isInserted] is ' || $isInserted"/>
            <xsl:message select="'[text(MODE_STEP2)] insertInlineStartAndEnd[1]=' || string(if ($insertInlineStartAndEnd[1] => exists()) then ahf:getHistoryXpathStr($insertInlineStartAndEnd[1]) else 'NULL')"></xsl:message>
            <xsl:message select="'[text(MODE_STEP2)] insertInlineStartAndEnd[2]=' || string(if ($insertInlineStartAndEnd[2] => exists()) then ahf:getHistoryXpathStr($insertInlineStartAndEnd[2]) else 'NULL')"></xsl:message>
        </xsl:if>
        
        <xsl:choose>
            <xsl:when test="$isInserted and $currentText/parent::*[. => ahf:isMixedContentElement()]">
                <xsl:variable name="insertFoProp" as="attribute()?">
                    <xsl:variable name="foProp" as="attribute()?" select="()"/>
                    <xsl:choose>
                        <xsl:when test="$isInserted">
                            <xsl:copy-of select="ahf:addColorToFoProp($foProp,ahf:getInsertFgColorSpecFromPi($insertPi)) => ahf:addInsertDecorationToFoProp()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$foProp"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <ph class="- topic/ph ">
                    <xsl:copy-of select="$insertFoProp"/>
                    <xsl:if test="$currentText is $insertInlineStartAndEnd[1]">
                        <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionInsert, 
                                                                 $insertPi => ahf:getAuthorFromPi(), 
                                                                 $insertPi => ahf:getFormattedTimeStampStrFromPi(), 
                                                                 $insertPi => ahf:getCommentFromPi(),
                                                                 ahf:getHistoryStrWithPiText($insertPi))"/>
                    </xsl:if>
                    <xsl:copy select="$currentText"/>
                </ph>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy select="$currentText"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$isInserted and $insertInlineStartAndEnd => exists() and $currentText is $insertInlineStartAndEnd[2]">
            <xsl:copy-of select="ahf:addDraftComment($cDraftCommentDispositionInsertEnd, 
                                                     '', 
                                                     '', 
                                                     '', 
                                                     ahf:getHistoryStrWithPiText($insertPi))"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()
                         [ancestor::*[@class => contains-token('topic/topic')] => exists()]
                         [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
                  mode="MODE_STEP3"
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
                            <xsl:if test="$gpStep3Debug">
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

    <xsl:template match="text()
        [ancestor::*[@class => contains-token('topic/topic')] => exists()]
        [ancestor-or-self::*[@class => contains-token('topic/prolog')] => empty()]"
        mode="MODE_STEP4"
        >
        <xsl:param name="prmHighlightRangeMap"  as="map(xs:string,node()*)"     tunnel="yes" required="yes"/>
        
        <xsl:variable name="currentText" as="text()" select="."/>
        <xsl:variable name="highlightStartPi" as="processing-instruction()?" select="accumulator-before('glHighlightPi') => head()"/>
        <xsl:variable name="isHighlighted" as="xs:boolean" select="$highlightStartPi => exists()"/>
        <xsl:choose>
            <xsl:when test="$isHighlighted">
                <xsl:variable name="highlightFoProp" as="attribute()?">
                    <xsl:variable name="foProp" as="attribute()?" select="()"/>
                    <xsl:choose>
                        <xsl:when test="$isHighlighted">
                            <xsl:copy-of select="$foProp => ahf:addBgColorToFoProp(ahf:getColorFromPi($highlightStartPi))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$foProp"/>
                        </xsl:otherwise>
                    </xsl:choose>
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
    </xsl:template>
    
</xsl:stylesheet>