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
     note:      Key: XPath of oxy_insert_start PI, value=inline start node, inline last before (or self of) the oxy_insert_end PI
                Apply range refinement to eliminate space only redundant nodes.
     -->
    <xsl:template name="generateInsertRangeInlineMap" as="map(xs:string, node()*)">
        <xsl:param name="prmRoot" as="element()"/>
        <xsl:variable name="insertStartPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[. => ahf:isInsertStartPi()]"/>
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
                                <xsl:when test="$range => count() eq 1 and $range[1] instance of text() and normalize-space($range[1]) eq ''">
                                    <xsl:sequence select="($insertStartPi,$insertEndPi)"/>
                                </xsl:when>
                                <xsl:when test="$range => count() eq 2 and $range[1] instance of text() and normalize-space($range[1]) eq '' and $range[2] instance of text() and normalize-space($range[2]) eq ''">
                                    <xsl:sequence select="($insertStartPi,$insertEndPi)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$range => count() gt 2 and $range[1] instance of text() and normalize-space($range[1]) eq '' and $range[last()] instance of text() and normalize-space($range[last()]) eq ''">
                                            <xsl:sequence select="subsequence($range,2,$range => count() - 2)"/>
                                        </xsl:when>
                                        <xsl:when test="$range => count() gt 2 and $range[1] instance of text() and normalize-space($range[1]) eq ''">
                                            <xsl:sequence select="subsequence($range, 2)"/>
                                        </xsl:when>
                                        <xsl:when test="$range => count() gt 2 and $range[last()] instance of text() and normalize-space($range[last()]) eq ''">
                                            <xsl:sequence select="subsequence($range, 1, $range => count() - 1)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:sequence select="$range"/>
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
     note:      Key: XPath of oxy_comment_start PI, value=inline start node, inline last before (or self of) the oxy_comment_end PI
     -->
    <xsl:template name="generateCommentRangeInlineMap" as="map(xs:string, node()*)">
        <xsl:param name="prmRoot" as="element()"/>
        <xsl:variable name="commentStartPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[. => ahf:isCommentStartPi()]"/>
        <xsl:variable name="commentRangeInlineMap" as="map(xs:string, node()*)">
            <!-- Make Inline to Pi Map-->
            <xsl:map>
                <xsl:for-each select="$commentStartPis">
                    <xsl:variable name="commentStartPi" as="processing-instruction()" select="."/>
                    <xsl:variable name="mid" as="xs:string" select="ahf:getMidFromPiContent($commentStartPi)"/>
                    <xsl:variable name="commentEndPi" as="processing-instruction()?">
                        <xsl:choose>
                            <xsl:when test="$mid ne ''">
                                <xsl:sequence select="($prmRoot/descendant::processing-instruction()[. => ahf:isCommentEndPi()][. => ahf:isAfterNode($commentStartPi)][$mid eq ahf:getMidFromPiContent(.)])[1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="($prmRoot/descendant::processing-instruction()[. => ahf:isCommentEndPi()][. => ahf:isAfterNode($commentStartPi)])[1]"/>                                                
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="rangeInline" as="node()*">
                        <xsl:variable name="range" as="node()*" select="$prmRoot/descendant::node()[self::text()][parent::*[. => ahf:isMixedContentElement()] => exists()][. => ahf:isAfterOrSelfNode($commentStartPi)][. => ahf:isBeforeOrSelfNode($commentEndPi)]"/>
                        <xsl:variable name="rangeRevised" as="node()*" select="if ($range => empty()) then ($commentStartPi,$commentEndPi) else $range" />
                        <xsl:sequence select="$rangeRevised"/>
                    </xsl:variable>
                    <xsl:if test="$gpStep2Debug">
                        <xsl:message select="'[Comment Range Map] Key: ' || $commentStartPi => ahf:getHistoryXpathStr() || ' Start Node=' || (if (exists($rangeInline[1])) then $rangeInline[1] => ahf:getHistoryXpathStr() else 'NULL') || ' End Node=' || (if (exists($rangeInline[last()])) then $rangeInline[last()] => ahf:getHistoryXpathStr() else 'NULL')"/>
                    </xsl:if>
                    <xsl:map-entry key="$commentStartPi => ahf:getHistoryXpathStr()" select="$rangeInline[1],$rangeInline[last()]"/>
                </xsl:for-each>
            </xsl:map>
        </xsl:variable>
        <xsl:sequence select="$commentRangeInlineMap"/>
    </xsl:template>
    
    <!-- 
     function:  Generate Highlight PI Range Map 
     param:     prmTopic
     return:    xsl:map
     note:      Key: XPath of oxy_comment_start PI, value=inline start node, inline last before (or self of) the oxy_comment_end PI
     -->
    <xsl:template name="generateHighlightRangeInlineMap" as="map(xs:string, node()*)">
        <xsl:param name="prmRoot" as="element()"/>
        <xsl:variable name="highlightStartPis" as="processing-instruction()*" select="$prmRoot/descendant::processing-instruction()[. => ahf:isHighlightStartPi()]"/>
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
                    <xsl:map-entry key="$highlightStartPi => ahf:getHistoryXpathStr()" select="$rangeInline[1],$rangeInline[last()]"/>
                </xsl:for-each>
            </xsl:map>
        </xsl:variable>
        <xsl:sequence select="$highlightRangeInlineMap"/>
    </xsl:template>
    
</xsl:stylesheet>