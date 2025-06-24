<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Map Utility Stylesheet.
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
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 
     function:  Generate Insert PI Range Map 
     param:     prmTopic
     return:    xsl:map
     note:      Key: XPath of oxy_insert_start PI, value=inline start node(start Pi or text()), inline last node(end PI or text()).
                Apply range refinement to eliminate space only redundant nodes.
     -->
    <xsl:variable name="mesInsertEndPiNotFound" as="xs:string" select="'[Insert PI] Target insert end processing-instruction() is not found. PI='"/>
    
    <xsl:template name="generateInsertRangeInlineMap" as="map(xs:string, node()*)">
        <xsl:param name="prmRoot" as="element()"/>
        <!-- Exclude PI that is the child of SVG or MathML elements -->
        <xsl:variable name="insertStartPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[. => ahf:isInsertStartPi()][ahf:isNotChildOfSvgOrMathMlElem(.)]"/>
        <xsl:variable name="insertRangeInlineMap" as="map(xs:string, node()*)">
            <!-- Make Inline to Pi Map-->
            <xsl:map>
                <xsl:for-each select="$insertStartPis">
                    <xsl:variable name="insertStartPi" as="processing-instruction()" select="."/>
                    <xsl:variable name="insertEndPi" as="processing-instruction()?">
                        <xsl:sequence select="($prmRoot/descendant::processing-instruction()[. => ahf:isInsertEndPi()][. => ahf:isAfterNode($insertStartPi)])[1]"/> 
                    </xsl:variable>
                    <xsl:variable name="rangeBetweenPis" as="node()*">
                        <xsl:choose>
                            <xsl:when test="$insertEndPi => empty()">
                                <xsl:call-template name="errorContinueWithFileInfo">
                                    <xsl:with-param name="prmMes" select="$mesInsertEndPiNotFound || ahf:PiToText($insertStartPi)"/>
                                    <xsl:with-param name="prmElem" select="$prmRoot"/>
                                </xsl:call-template>
                                <xsl:sequence select="()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="$prmRoot/descendant::node()[. => ahf:isAfterNode($insertStartPi)][. => ahf:isBeforeNode($insertEndPi)]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="hasBlockImage" as="xs:boolean" select="$rangeBetweenPis[self::*[@class => contains-token('topic/image')][@placement => string() eq 'break']] => exists()"/>
                    <xsl:variable name="rangeInline" as="node()*">
                        <xsl:variable name="parent" as="element()?" select="$insertStartPi/parent::*[ahf:isMixedContentElement(.)][1]"/>
                        <xsl:variable name="range" as="node()*" select="$prmRoot/descendant::node()[self::text()[parent::*[ahf:isMixedContentElement(.)]][. => ahf:isAfterOrSelfNode($insertStartPi)][. => ahf:isBeforeOrSelfNode($insertEndPi)]]"/>
                        <xsl:variable name="rangeRevised" as="node()*">
                            <xsl:choose>
                                <xsl:when test="$hasBlockImage">
                                    <xsl:sequence select="($insertStartPi,$insertEndPi)"/>
                                </xsl:when>
                                <xsl:when test="$range => empty()">
                                    <xsl:sequence select="($insertStartPi,$insertEndPi)"/>
                                </xsl:when>
                                <xsl:when test="$range => count() eq 1 and normalize-space($range[1]) eq ''">
                                    <xsl:sequence select="($insertStartPi,$insertEndPi)"/>
                                </xsl:when>
                                <xsl:when test="$range => count() eq 2 and normalize-space($range[1]) eq '' and normalize-space($range[2]) eq ''">
                                    <xsl:sequence select="($insertStartPi,$insertEndPi)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$range => count() gt 2 and normalize-space($range[1]) eq '' and normalize-space($range[last()]) eq ''">
                                            <xsl:sequence select="subsequence($range,2,$range => count() - 2)"/>
                                        </xsl:when>
                                        <xsl:when test="$range => count() gt 2 and normalize-space($range[1]) eq ''">
                                            <xsl:sequence select="subsequence($range, 2)"/>
                                        </xsl:when>
                                        <xsl:when test="$range => count() gt 2 and normalize-space($range[last()]) eq ''">
                                            <xsl:sequence select="subsequence($range, 1, $range => count() - 1)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:sequence select="($range[1],$range[last()])"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:sequence select="$rangeRevised"/>
                    </xsl:variable>
                    <xsl:if test="$gpStep1Debug">
                        <xsl:message select="'[InsertRangeInlineMap] Key: Insert Start PI=' || $insertStartPi => ahf:getHistoryXpathStr() || ' Insert End PI=' || (if (exists($insertEndPi)) then $insertEndPi => ahf:getHistoryXpathStr() else 'NULL') || ' Start Node=' || (if (exists($rangeInline[1])) then $rangeInline[1] => ahf:getHistoryXpathStr() else 'NULL') || ' End Node=' || (if (exists($rangeInline[last()])) then $rangeInline[last()] => ahf:getHistoryXpathStr() else 'NULL')"/>
                    </xsl:if>
                    <!-- Key: XPath of oxy_insert_start PI, value=inline start node, inline last before (or self of) the oxy_insert_end PI -->
                    <xsl:map-entry key="$insertStartPi => ahf:getHistoryXpathStr()" select="$rangeInline[1],$rangeInline[last()]"/>
                </xsl:for-each>
            </xsl:map>
        </xsl:variable>
        <xsl:sequence select="$insertRangeInlineMap"/>
    </xsl:template>
    
    <!-- 
     function:  Generate Comment PI Range Map 
     param:     prmTopic
     return:    xsl:map
     note:      Key: XPath of oxy_comment_start PI, value=start text node or start PI (if text() does not exist), end text node or PI (if text() does not exist).
                Start PI is needed to generate comment annotation when no text node exists.
                Comment Pi sometimes overlapped by specifying $mid.
     -->
    <xsl:variable name="mesCommentEndPiNotFound" as="xs:string" select="'[Comment PI] Target comment end processing-instruction() is not found. PI='"/>
    
    <xsl:template name="generateCommentRangeInlineMap" as="map(xs:string, node()*)">
        <xsl:param name="prmRoot" as="element()"/>
        <!-- key: XPath of comment-start PI, data: comment-end PI --> 
        <xsl:variable name="commentPiMap" as="map(xs:string,node())">
            <xsl:call-template name="generateCommentPiMap">
                <xsl:with-param name="prmRoot" select="$prmRoot"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- PI that is the child of SVG or MathML elements are excluded in this map-->
        <xsl:variable name="commentStartPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[. => ahf:isCommentStartPi()][ahf:isNotChildOfSvgOrMathMlElem(.)]"/>
        <xsl:variable name="commentRangeInlineMap" as="map(xs:string, node()*)">
            <!-- Make PI to inline Map-->
            <xsl:map>
                <xsl:for-each select="$commentStartPis">
                    <xsl:variable name="commentStartPi" as="processing-instruction()" select="."/>
                    <xsl:variable name="commentEndPi" as="processing-instruction()?" select="map:get($commentPiMap,$commentStartPi => ahf:getHistoryXpathStr())"/>
                    <xsl:choose>
                        <xsl:when test="$commentEndPi => exists()">
                            <xsl:variable name="rangeInline" as="node()*">
                                <!-- Ignore text of equation-block which contains mathml or svg-container -->
                                <xsl:variable name="range" as="node()*" select="$prmRoot/descendant::node()
                                    [self::text()]
                                    [parent::*[. => ahf:isMixedContentElement()] => exists()]
                                    [ahf:isNotChildOfSvgOrMathMlElem(.)]
                                    [. => ahf:isAfterOrSelfNode($commentStartPi)]
                                    [. => ahf:isBeforeOrSelfNode($commentEndPi)]"/>
                                <xsl:variable name="rangeRevised" as="node()*">
                                    <xsl:choose>
                                        <xsl:when test="$range => exists()">
                                            <xsl:sequence select="$range"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- text() does not exist -->
                                            <xsl:variable name="followingSiblingElem" as="element()?" select="$commentStartPi/following-sibling::element()[1]"/>
                                            <xsl:variable name="commentPiBetween" as="processing-instruction()*">
                                                <xsl:choose>
                                                    <xsl:when test="$followingSiblingElem => exists()">
                                                        <xsl:sequence select="$commentStartPi/following-sibling::processing-instruction()[ahf:isCommentStartPi(.)][. &gt;&gt; $commentStartPi][. &lt;&lt; $followingSiblingElem]"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:sequence select="()"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="$commentPiBetween => exists()">
                                                    <!-- return comment-PI itself -->
                                                    <xsl:sequence select=" ($commentStartPi,$commentEndPi)"/>
                                                </xsl:when>
                                                <xsl:when test="$followingSiblingElem =>exists()">
                                                    <!-- return nearest element -->
                                                    <xsl:sequence select=" ($followingSiblingElem,$followingSiblingElem)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- That's impossible! -->
                                                    <xsl:sequence select=" ($commentStartPi,$commentEndPi)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:sequence select="$rangeRevised"/>
                            </xsl:variable>
                            <xsl:if test="$gpStep4Debug">
                                <xsl:message select="'[Comment Range Map] Key: ' || $commentStartPi => ahf:getHistoryXpathStr() || ' Start Node=' || (if (exists($rangeInline[1])) then $rangeInline[1] => ahf:getHistoryXpathStr() else 'NULL') || ' End Node=' || (if (exists($rangeInline[last()])) then $rangeInline[last()] => ahf:getHistoryXpathStr() else 'NULL')"/>
                            </xsl:if>
                            <xsl:map-entry key="$commentStartPi => ahf:getHistoryXpathStr()" select="$rangeInline"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="errorContinueWithFileInfo">
                                <xsl:with-param name="prmMes" select="$mesCommentEndPiNotFound || ahf:PiToText($commentStartPi)"/>
                                <xsl:with-param name="prmElem" select="$prmRoot"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:map>
        </xsl:variable>
        <xsl:sequence select="$commentRangeInlineMap"/>
    </xsl:template>

    <!-- 
     function:  Generate Comment PI start & end Map 
     param:     prmRoot
     return:    xsl:map(xs:string,node()?)
     note:      Generate comment PI start & end map using 'glCommentPiForGenMap' accumulator
     -->
    <xsl:template name="generateCommentPiMap" as="map(xs:string, node())">
        <xsl:param name="prmRoot" as="element()" required="yes"/>
        <xsl:map>
            <xsl:apply-templates select="$prmRoot" mode="MODE_GEN_COMMENT_PI_MAP"/>
        </xsl:map>
    </xsl:template>

    <xsl:accumulator name="glCommentPiForGenMap" as="processing-instruction()*" initial-value="()">
        <xsl:accumulator-rule match="processing-instruction()[ahf:isCommentStartPi(.)]" select="(., $value)" phase="start"/>
        <xsl:accumulator-rule match="processing-instruction()[ahf:isCommentEndPi(.)]" select="ahf:removeStartPiFromAccumulator($value, .)" phase="end"/>
    </xsl:accumulator>

    <xsl:mode name="MODE_GEN_COMMENT_PI_MAP" use-accumulators="glCommentPiForGenMap"/>
    
    <xsl:template match="processing-instruction()[ahf:isCommentEndPi(.)]" mode="MODE_GEN_COMMENT_PI_MAP" priority="5">
        <xsl:variable name="commentEndPi" as="processing-instruction()" select="."/>
        <xsl:variable name="commentStartPis" as="processing-instruction()*" select="accumulator-before('glCommentPiForGenMap')"/>
        <xsl:variable name="commentStartPi" as="processing-instruction()?" select="$commentStartPis => ahf:getCorrespondingCommentStartPiFromEndPi($commentEndPi)"/>
        <!--xsl:message select="'$commentStartPis=',$commentStartPis"/>
        <xsl:message select="'$commentEndPi=' || ahf:getHistoryXpathStr($commentEndPi)"/>
        <xsl:message select="'$commentStartPi=' || (if (exists($commentStartPi)) then ahf:getHistoryXpathStr($commentStartPi) else '''''')"/>
        <xsl:message select="'$commentStartPi',$commentStartPi"/-->
        <xsl:choose>
            <xsl:when test="exists($commentStartPi)">
                <xsl:map-entry key="$commentStartPi => ahf:getHistoryXpathStr()" select="$commentEndPi"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="node()" mode="MODE_GEN_COMMENT_PI_MAP">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <!-- 
     function:  Get corresponding comment start PI from comment end PI 
     param:     prmStartAndEndPi, prmEndPi 
     return:    processing-instruction()?
     note:      
     -->
    <xsl:function name="ahf:getCorrespondingCommentStartPiFromEndPi" as="processing-instruction()?">
        <xsl:param name="prmCommentStartPis" as="processing-instruction()*"/>
        <xsl:param name="prmCommentEndPi" as="processing-instruction()"/>
        <xsl:choose>
            <xsl:when test="$prmCommentEndPi => ahf:hasMidPartInPi()">
                <xsl:variable name="mid" as="xs:string" select="$prmCommentEndPi => ahf:getMidFromPiContent()"/>
                <xsl:sequence select="$prmCommentStartPis[. => ahf:getMidFromPiContent() eq $mid][1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="noMidPosStartPi" as="processing-instruction()?" select="$prmCommentStartPis[ahf:hasNoMidPartInPi(.)][1]"/>
                <xsl:sequence select="$noMidPosStartPi"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  Generate Highlight PI Range Map 
     param:     prmTopic
     return:    xsl:map
     note:      Key: XPath of oxy_comment_start PI, value=inline start node, inline last before (or self of) the oxy_comment_end PI
                Highlight PIs are not overlapped for each other.
                Hightlight PIs does not generate annotation. It generates only background coloring.
     -->
    <xsl:template name="generateHighlightRangeInlineMap" as="map(xs:string, node()*)">
        <xsl:param name="prmRoot" as="element()"/>
        <!-- Exclude PI that is child of SVG or MathML elements -->
        <xsl:variable name="highlightStartPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[. => ahf:isHighlightStartPi()][ahf:isNotChildOfSvgOrMathMlElem(.)]"/>
        <xsl:variable name="highlightRangeInlineMap" as="map(xs:string, node()*)">
            <!-- Make Inline to Pi Map-->
            <xsl:map>
                <xsl:for-each select="$highlightStartPis">
                    <xsl:variable name="highlightStartPi" as="processing-instruction()" select="."/>
                    <xsl:variable name="highlightEndPi" as="processing-instruction()?">
                        <xsl:sequence select="($prmRoot/descendant::processing-instruction()[. => ahf:isHighlightEndPi()][. => ahf:isAfterNode($highlightStartPi)])[1]"/>                                                
                    </xsl:variable>
                    <xsl:variable name="rangeInline" as="node()*">
                        <xsl:variable name="range" as="node()*" select="$prmRoot/descendant::node()[self::*[ahf:isMixedContentElement(.)] or self::text()[parent::*[ahf:isMixedContentElement(.)]]][. => ahf:isAfterOrSelfNode($highlightStartPi)][. => ahf:isBeforeOrSelfNode($highlightEndPi)]"/>
                        <xsl:variable name="rangeRevised" as="node()*" select="if ($range => empty()) then ($highlightStartPi,$highlightEndPi) else $range" />
                        <xsl:sequence select="$rangeRevised"/>
                    </xsl:variable>
                    <xsl:if test="$gpStep3Debug">
                        <xsl:message select="'[Map] Key: ' || $highlightStartPi => ahf:getHistoryXpathStr() || ' Start Node=' || (if (exists($rangeInline[1])) then $rangeInline[1] => ahf:getHistoryXpathStr() else 'NULL')(:|| ' End Node=' || $rangeInline[last()] => ahf:getHistoryXpathStr():)"/>
                    </xsl:if>
                    <!-- Key: XPath of oxy_comment_start PI, value=inline start node, inline last before (or self of) the oxy_comment_end PI -->
                    <xsl:map-entry key="$highlightStartPi => ahf:getHistoryXpathStr()" select="$rangeInline"/>
                </xsl:for-each>
            </xsl:map>
        </xsl:variable>
        <xsl:sequence select="$highlightRangeInlineMap"/>
    </xsl:template>
    
</xsl:stylesheet>