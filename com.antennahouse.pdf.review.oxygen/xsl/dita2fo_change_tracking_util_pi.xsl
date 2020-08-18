<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Utility Stylesheet.
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
    
    <!-- oXygen Processing Instruction Specific Functions.
     -->
    
    <!-- 
     function:  Judge PI name
     param:     prmNode
     return:    xs:boolean
     note:      
     -->
    <xsl:function name="ahf:isInsertStartPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cInsertStartPiName] => exists()"/>
    </xsl:function>

    <xsl:function name="ahf:isInsertEndPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cInsertEndPiName] => exists()"/>
    </xsl:function>
    
    <xsl:function name="ahf:hasInsertPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/descendant-or-self::processing-instruction()[. => ahf:isInsertStartPi() or . => ahf:isInsertEndPi()] => exists()"/>
    </xsl:function>

    <xsl:function name="ahf:isDeletePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cDeletePiName] => exists()"/>
    </xsl:function>

    <xsl:function name="ahf:hasDeletePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/descendant-or-self::processing-instruction()[. => ahf:isDeletePi()] => exists()"/>
    </xsl:function>
    
    <xsl:function name="ahf:isCommentStartPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cCommentStartPiName] => exists()"/>
    </xsl:function>
    
    <xsl:function name="ahf:isCommentEndPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cCommentEndPiName] => exists()"/>
    </xsl:function>

    <xsl:function name="ahf:hasCommentPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/descendant-or-self::processing-instruction()[. => ahf:isCommentStartPi() or . => ahf:isCommentEndPi()] => exists()"/>
    </xsl:function>
    
    <xsl:function name="ahf:isAttributeChangePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cAttributeChangePiName] => exists()"/>
    </xsl:function>

    <xsl:function name="ahf:hasAttributeChangePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/descendant-or-self::processing-instruction()[. => ahf:isAttributeChangePi()] => exists()"/>
    </xsl:function>
    
    <xsl:function name="ahf:isHighlightStartPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cCustomStartPiName] => exists() and ahf:getTypeFromPi($prmNode) eq $cCustomTypeHighlight"/>
    </xsl:function>
    
    <xsl:function name="ahf:isHighlightEndPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() eq $cCustomEndPiName] => exists()"/>
    </xsl:function>

    <xsl:function name="ahf:hasHighlightPi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/descendant-or-self::processing-instruction()[. => ahf:isHighlightStartPi() or . => ahf:isHighlightEndPi()] => exists()"/>
    </xsl:function>
    
    <xsl:function name="ahf:isTrackingChangePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::processing-instruction()[name() = ($cInsertStartPiName, $cInsertEndPiName, $cDeletePiName, $cAttributeChangePiName, $cCustomEndPiName)] => exists() or $prmNode[. => ahf:isHighlightStartPi()] => exists()"/>        
    </xsl:function>
  
    <xsl:function name="ahf:isNotTrackingChangePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode => ahf:isTrackingChangePi() => not()"/>
    </xsl:function>  
    
    <xsl:function name="ahf:isFirstElementAfterAttributeChangePi" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:choose>
            <xsl:when test="$prmNode/self::element()">
                <xsl:variable name="precedingFirstAttributeChangePi" as="processing-instruction()?" select="$prmNode/preceding-sibling::processing-instruction()[. => ahf:isAttributeChangePi()][1]"/>
                <xsl:variable name="nodesBetween" as="node()*" select="$precedingFirstAttributeChangePi/following-sibling::node()[. &lt;&lt; $prmNode]"/>
                <xsl:choose>
                    <xsl:when test="$precedingFirstAttributeChangePi => exists()">
                        <xsl:choose>
                            <xsl:when test="$nodesBetween => empty()">
                                <xsl:sequence select="true()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="every $node in $nodesBetween satisfies ($node/self::text()[. => normalize-space() eq ''] => exists() or $node/self::comment() => exists() or $node/self::processing-instruction()[. => ahf:isNotTrackingChangePi()] => exists())"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:function>

    <!-- 
     function:  Get Content of PI
     param:     prmPi
     return:    xs:string
     note:      Extract content from PI
     -->
    <xsl:function name="ahf:getPiContent" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()?"/>
        <xsl:variable name="piContent" as="xs:string" select="' ' || $prmPi => string()"/>
        <xsl:sequence select="$piContent"/>
    </xsl:function>
    
    <!-- 
     function:  Get Author from PI content
     param:     prmPi
     return:    xs:string
     note:      Extract author portion from PI
     -->
    <xsl:function name="ahf:getAuthorFromPi" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()?"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="authorPart" as="xs:string" select="$piContent => substring-after(' author=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="$authorPart"/>
    </xsl:function>
    
    <!-- 
     function:  Get Comment from PI content
     param:     prmPi
     return:    xs:string
     note:      Extract comment portion from PI
     -->
    <xsl:function name="ahf:getCommentFromPi" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="commentPart" as="xs:string?" select="$piContent => substring-after(' comment=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="$commentPart"/>
    </xsl:function>

    <!-- 
     function:  Get Content from PI content
     param:     prmPi
     return:    xs:string
     note:      Extract content portion from PI
     -->
    <xsl:function name="ahf:getContentFromPi" as="xs:string?">
        <xsl:param name="prmPi" as="processing-instruction()?"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="contentPart" as="xs:string?" select="$piContent => substring-after(' content=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="if (string($contentPart)) then $contentPart else ()"/>
    </xsl:function>

    <!-- 
     function:  Get Type from PI content
     param:     prmPi
     return:    xs:string
     note:      Extract type portion from PI
     -->
    <xsl:function name="ahf:getTypeFromPi" as="xs:string?">
        <xsl:param name="prmPi" as="processing-instruction()?"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="typePart" as="xs:string?" select="$piContent => substring-after(' type=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="if (string($typePart)) then $typePart else ()"/>
    </xsl:function>

    <!-- 
     function:  Get Time-stamp from PI content
     param:     prmPi
     return:    xs:string
     note:      Extract time-stamp portion from PI
     -->
    <xsl:function name="ahf:getTimeStampFromPi" as="xs:string?">
        <xsl:param name="prmPi" as="processing-instruction()?"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="timeStampPart" as="xs:string?" select="$piContent => substring-after(' timestamp=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="if (string($timeStampPart)) then $timeStampPart else ()"/>
    </xsl:function>
    
    <!-- 
     function:  Get xs:dateTime type from PI time-stamp content
     param:     prmTimeStamp
     return:    xs:dateTime?
     note:      Extract time-stamp portion from PI
     -->
    <xsl:function name="ahf:convertToDateTime" as="xs:dateTime?">
        <xsl:param name="prmTimeStamp" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="string($prmTimeStamp)">
                <xsl:variable name="date" as="xs:date" select="xs:date(substring($prmTimeStamp,1,4) || '-' || substring($prmTimeStamp,5,2) || '-' || substring($prmTimeStamp,7,2))"/>
                <xsl:variable name="time" as="xs:time" select="xs:time(substring($prmTimeStamp,10,2) || ':' || substring($prmTimeStamp,12,2) || ':' || substring($prmTimeStamp,14,2))"/>
                <xsl:sequence select="dateTime($date, $time)"/>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  Formate dateTime via general format
     param:     prmDateTime (xs:dateTime)
     return:    xs:string
     note:      ex. 2020-06-01 14:43
     -->
    <xsl:function name="ahf:formatDateTimeGeneral" as="xs:string">
        <xsl:param name="prmDateTime" as="xs:dateTime?"/>
        <xsl:sequence select="if ($prmDateTime => exists()) then format-dateTime($prmDateTime,'[Y,4-4]-[M,2-2]-[D,2-2] [H,2-2]:[m,2-2]') else ''"/>
    </xsl:function>
    
    <!-- 
     function:  Generate date/time formatted string from PI time-stamp content
     param:     prmPi
     return:    xs:string
     note:      ex. 2020-06-01 14:43
     -->
    <xsl:function name="ahf:getFormattedTimeStampStrFromPi" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()?"/>
        <xsl:sequence select="$prmPi => ahf:getTimeStampFromPi() => ahf:convertToDateTime() => ahf:formatDateTimeGeneral()"/>
    </xsl:function>
    
    <!-- 
     function:  Get id="xx" part from commnet PI content
     param:     prmPi
     return:    xs:string → xx
     note:      The id part should contain preceding space:
                <?oxy_comment_start author="yuko" timestamp="20200607T194314+0900" comment="Comment1" id="ups_ph1_zlb"?>
                It should be distinguished from "mid=".
     -->
    <xsl:function name="ahf:getIdFromPiContent" as="xs:string?">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="idPart" as="xs:string" select="$piContent => substring-after(' id=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="if ($idPart eq '') then () else $idPart"/>
    </xsl:function>

    <xsl:function name="ahf:getParentIdFromPiContent" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="parentIdPart" as="xs:string" select="$piContent => substring-after(' parentID=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="$parentIdPart"/>
    </xsl:function>

    <!-- 
     function:  Get comment PI nesting level
     param:     prmPi
     return:    xs:integer
     note:      If $prmPi has "Reply" comment, it should be removed from count.
     -->
    <xsl:function name="ahf:getCommentPiNestingLevel" as="xs:integer">
        <xsl:param name="prmCommentPi" as="processing-instruction()*"/>
        <xsl:variable name="nestLevel" as="xs:integer" select="$prmCommentPi[. => ahf:getParentIdFromPiContent() eq ''] => count()"/>
        <xsl:sequence select="$nestLevel"/>
    </xsl:function>

    <!-- 
     function:  Get mid="xx" part from PI content
     param:     prmPi
     return:    xs:string → xx
     note:      Important: Compare with "mid=", not " mid=" because end PI has no preceding space.
                <?oxy_comment_end mid="19"?>
                The start PI has preceding space:
                <?oxy_comment_start author="guten" timestamp="20200607T194400+0900" comment="Comment 3" id="jls_4h1_zlb" mid="15"?>
                Resolved: ahf:getPiContent() adds one space before contents.
     -->
    <xsl:function name="ahf:getMidFromPiContent" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => ahf:getPiContent()"/>
        <xsl:variable name="midPart" as="xs:string" select="$piContent => substring-after(' mid=&quot;') => substring-before('&quot;')"/>
        <xsl:sequence select="$midPart"/>
    </xsl:function>

    <xsl:function name="ahf:hasMidPartInPi" as="xs:boolean">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:sequence select="$prmPi => ahf:getMidFromPiContent() ne ''"/>
    </xsl:function>

    <xsl:function name="ahf:hasNoMidPartInPi" as="xs:boolean">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:sequence select="$prmPi => ahf:hasMidPartInPi() => not()"/>
    </xsl:function>
    
    <!-- fo:prop related function
         fo:prop is specially implemented in PDF5-ML plug-in to enable applying FO property directly to the result.
     -->
    
    <!-- 
     function:  Add insert decoration to fo:prop 
     param:     prmFoProp
     return:    fo:prop attribute
     note:      Add 'text-decoration:underline;' to last part of fo:prop.
     -->
    <xsl:function name="ahf:addInsertDecorationToFoProp" as="attribute()">
        <xsl:param name="prmFoProp" as="attribute()?"/>
        <xsl:variable name="foProp" as="xs:string" select="$prmFoProp => string() => normalize-space()"/>
        <xsl:variable name="foPropRevised" as="xs:string" select="if (ends-with($foProp,';') or string($foProp) => not()) then $foProp else $foProp || ';'"/>
        <xsl:attribute name="{$gpFoPropName}" select="$foPropRevised || $gpChangeTrackingInsertDecoration"/>
    </xsl:function>
    
    <!-- 
     function:  Add delete decoration to fo:prop 
     param:     prmFoProp
     return:    fo:prop attribute
     note:      Add 'text-decoration:line-through;' to last part of fo:prop.
     -->
    <xsl:function name="ahf:addDeleteDecorationToFoProp" as="attribute()">
        <xsl:param name="prmFoProp" as="attribute()?"/>
        <xsl:variable name="foProp" as="xs:string" select="$prmFoProp => string() => normalize-space()"/>
        <xsl:variable name="foPropRevised" as="xs:string" select="if (ends-with($foProp,';') or string($foProp) => not()) then $foProp else $foProp || ';'"/>
        <xsl:attribute name="{$gpFoPropName}" select="$foPropRevised || $gpChangeTrackingDeleteDecoration"/>
    </xsl:function>

    <!-- 
     function:  Get Target Comment Info (author, time-stamp, comment 
     param:     prmCommentPi
     return:    element()
     note:      Return generated draft-comment.
     -->
    <xsl:template name="ahf:genDraftCommentFromCommentPis" as="element()*">
        <xsl:param name="prmCommentPi" as="processing-instruction()*" required="yes"/>
        <xsl:param name="prmCurrent" as="node()" required="no" select="."/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[ahf:genDraftCommentFromCommentPis] $prmCommentPi=', $prmCommentPi"/>
            <xsl:message select="'[ahf:genDraftCommentFromCommentPis] $prmCurrent=', $prmCurrent => ahf:getHistoryXpathStr()"/>
        </xsl:if>
        <xsl:variable name="commentInfo" as="xs:string*" select="ahf:getTargetCommentInfo($prmCommentPi)"/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[ahf:genDraftCommentFromCommentPis] $commentInfo=(' || count($commentInfo) ||')', $commentInfo"></xsl:message>
        </xsl:if>
        <xsl:if test="$commentInfo => exists()">
            <xsl:for-each-group select="$commentInfo" group-adjacent="((position() - 1) div 3) => xs:integer()" >
                <xsl:if test="$gpStep2Debug">
                    <xsl:message select="'[ahf:genDraftCommentFromCommentPis] current-grouping-key()=',current-grouping-key(),' current-group()=('||count(current-group()) || ')', current-group()"/>
                </xsl:if>
                <xsl:variable name="position" as="xs:integer" select="position()"/>
                <xsl:copy-of select="ahf:addDraftCommentWithOffset($cDraftCommentDispositionComment,
                                                         current-group()[1], 
                                                         current-group()[2], 
                                                         current-group()[3],
                                                         '',
                                                         if ($position eq 1) then '' else $cDraftCommentOffset || ($position - 1))"/>
            </xsl:for-each-group>
        </xsl:if>
    </xsl:template>

    <!-- 
     function:  Get Target Comment Pi 
     param:     prmCommentPi
     return:    processing-instruction()
     note:      Return non-hierarchy and parent comment PI that should output annotation at prmNode.
     -->
    <xsl:template name="ahf:getTargetCommentPi" as="processing-instruction()*">
        <xsl:param name="prmCommentPi" as="processing-instruction()*" required="yes"/>
        <xsl:param name="prmCurrent"   as="node()" required="yes"/>
        <xsl:param name="prmCommentRangeMap"  as="map(xs:string,node()*)"  tunnel="yes" required="yes"/>
        <xsl:sequence select="$prmCommentPi[map:get($prmCommentRangeMap, . => ahf:getHistoryXpathStr())[1] is $prmCurrent]"/>
    </xsl:template>
    
    <!-- 
     function:  Get Target Comment Info (author, time-stamp, comment 
     param:     prmCommentPis
     return:    xs:string*
     note:      Return sequence of author, time-stamp, comment.
                The comments can be:
                - Nested
                - Replied
                It is better to reverse stack for getting normal comment order.
     -->
    <xsl:function name="ahf:getTargetCommentInfo" as="xs:string*">
        <xsl:param name="prmCommentPi" as="processing-instruction()*"/>
        <xsl:variable name="commentPiOrg" as="processing-instruction()*" select="$prmCommentPi => reverse()"/>
        <xsl:variable name="ids" as="xs:string*" select="$commentPiOrg ! ahf:getIdFromPiContent(.) => distinct-values()"/>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'$ids=('||count($ids) || ') ', $ids"></xsl:message>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$ids => empty()">
                <xsl:for-each select="$commentPiOrg">
                    <xsl:variable name="commentPi" as="processing-instruction()" select="."/>
                    <xsl:variable name="author" as="xs:string" select="$commentPi => ahf:getAuthorFromPi()"/>
                    <xsl:variable name="timeStamp" as="xs:string" select="$commentPi => ahf:getFormattedTimeStampStrFromPi()"/>
                    <xsl:variable name="comment" as="xs:string" select="$commentPi => ahf:getCommentFromPi()"/>
                    <xsl:sequence select="$author"/>
                    <xsl:sequence select="$timeStamp"/>
                    <xsl:sequence select="$timeStamp || ' ' || $author || ': ' || $comment"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$ids">
                    <xsl:variable name="id" as="xs:string" select="."/>
                    <xsl:variable name="parentCommentPi" as="processing-instruction()" select="$prmCommentPi[ahf:getIdFromPiContent(.) eq $id]"/>
                    <xsl:variable name="author" as="xs:string" select="$parentCommentPi => ahf:getAuthorFromPi()"/>
                    <xsl:variable name="timeStamp" as="xs:string" select="$parentCommentPi => ahf:getFormattedTimeStampStrFromPi()"/>
                    <xsl:variable name="comment" as="xs:string" select="$timeStamp || ' ' || $author || ': ' || $parentCommentPi => ahf:getCommentFromPi() || (if ($prmCommentPi[ahf:getParentIdFromPiContent(.) eq $id] => exists()) then '&#x0A;' else '')"/>
                    <xsl:variable name="commentSeq" as="xs:string*">
                        <xsl:sequence select="$comment"/>
                        <xsl:for-each select="$commentPiOrg[ahf:getParentIdFromPiContent(.) eq $id]">
                            <xsl:variable name="childCommentPi" as="processing-instruction()" select="."/>
                            <xsl:variable name="author" as="xs:string" select="$childCommentPi => ahf:getAuthorFromPi()"/>
                            <xsl:variable name="timeStamp" as="xs:string" select="$childCommentPi => ahf:getFormattedTimeStampStrFromPi()"/>
                            <xsl:variable name="comment" as="xs:string" select="$childCommentPi => ahf:getCommentFromPi()"/>
                            <xsl:sequence select="$timeStamp || ' ' || $author || ': ' || $comment || (if (position() ne last()) then '&#x0A;' else '')"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:sequence select="$author"/>
                    <xsl:sequence select="$timeStamp"/>
                    <xsl:sequence select="$commentSeq => string-join('')"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  Get Target Attributes Info (author, time-stamp, comment) 
     param:     prmAttributesPi, prmNode
     return:    xs:string*
     note:      Return sequence of author, time-stamp, comment.
     -->
    <xsl:function name="ahf:genCommentsFromAttributesPi" as="xs:string">
        <xsl:param name="prmAttributesPi" as="processing-instruction()"/>
        <xsl:variable name="attributesContentsReConstructed" as="xs:string" select="replace($prmAttributesPi => string(), '\s*(.*?)=&quot;(.*?)&quot;', '&amp;lt;attribute name=&quot;$1&quot;&amp;gt;$2&amp;lt;/attribute&amp;gt;')"/>
        <xsl:variable name="parseTarget" as="xs:string" select="'&lt;root&gt;' || $attributesContentsReConstructed => ahf:unEscapeXmlChar() || '&lt;/root&gt;'"/>
        <xsl:variable name="parsedDoc" as="document-node()?" select="parse-xml($parseTarget)"/>
        <xsl:variable name="parsedResult" as="xs:string*">
            <xsl:apply-templates select="$parsedDoc/*" mode="MODE_ATTRIBUTES_PI">
                <xsl:with-param name="prmTargetElem" as="element()?" tunnel="yes" select="$prmAttributesPi/following-sibling::*[1]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:sequence select="string-join($parsedResult,'')"/>
    </xsl:function>
    
    <xsl:template match="/" mode="MODE_ATTRIBUTES_PI" as="xs:string*">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="root" mode="MODE_ATTRIBUTES_PI" as="xs:string*">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="attribute" mode="MODE_ATTRIBUTES_PI" as="xs:string">
        <xsl:param name="prmTargetElem" as="element()?" tunnel="yes" required="yes"/>
        <xsl:variable name="name" select="@name => string()"/>
        <xsl:variable name="change" as="element()?" select="child::change[1]"/>
        <xsl:variable name="targetName" as="xs:string" select="if ($prmTargetElem => exists()) then $prmTargetElem => name() else 'unknown??'"/>
        <xsl:variable name="type" as="xs:string" select="$change/@type => string()"/>
        <xsl:variable name="oldValue" as="xs:string" select="$change/@oldValue => string()"/>
        <xsl:variable name="newValue" as="xs:string" select="$prmTargetElem/@*[name() eq $name] => string()"/>
        <xsl:variable name="author" as="xs:string" select="$change/@author => string()"/>
        <xsl:variable name="timeStamp" as="xs:string" select="$change/@timestamp => string() => ahf:convertToDateTime() => ahf:formatDateTimeGeneral()"/>
        <xsl:choose>
            <xsl:when test="$type eq 'change'">
                <xsl:sequence select="$timeStamp || ' ' || $author || ' changed ' || $targetName || '/@' || $name || ' from ' || '''' || $oldValue || ''' to ''' || $newValue || '''.' || (if (following-sibling::attribute) then '&#x0A;' else '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$timeStamp || ' ' || $author || ' inserted ' || $targetName || '/@' || $name || ' as ' || '''' || $newValue || '''.' || (if (following-sibling::attribute) then '&#x0A;' else '')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  Generate draft-comment 
     param:     prmDisposition, prmAuthor, prmTimeStamp, prmComment, $prmId
     return:    draft-comment element
     note:      Auto generated draft-comment is treated specially by overridden template (dita2fo_change_tracking_gen_annotation.xsl).
     -->
    <xsl:function name="ahf:addDraftComment" as="element()">
        <xsl:param name="prmDisposition" as="xs:string"/>
        <xsl:param name="prmAuthor" as="xs:string"/>
        <xsl:param name="prmTimeStamp" as="xs:string?"/>
        <xsl:param name="prmComment" as="xs:string"/>
        <xsl:param name="prmId" as="xs:string"/>
        <draft-comment class="- topic/draft-comment ">
            <xsl:attribute name="author" select="$prmAuthor"/>
            <xsl:attribute name="time" select="$prmTimeStamp"/>
            <xsl:attribute name="disposition" select="$prmDisposition"/>
            <xsl:if test="$prmId ne ''">
                <xsl:attribute name="id" select="$prmId"/>
            </xsl:if>
            <xsl:value-of select="$prmComment"/>
        </draft-comment>
    </xsl:function>

    <xsl:function name="ahf:addDraftCommentWithOffset" as="element()">
        <xsl:param name="prmDisposition" as="xs:string"/>
        <xsl:param name="prmAuthor" as="xs:string"/>
        <xsl:param name="prmTimeStamp" as="xs:string?"/>
        <xsl:param name="prmComment" as="xs:string"/>
        <xsl:param name="prmId" as="xs:string"/>
        <xsl:param name="prmOffset" as="xs:string"/>
        <draft-comment class="- topic/draft-comment ">
            <xsl:attribute name="author" select="$prmAuthor"/>
            <xsl:attribute name="time" select="$prmTimeStamp"/>
            <xsl:attribute name="disposition" select="$prmDisposition"/>
            <xsl:if test="$prmId ne ''">
                <xsl:attribute name="id" select="$prmId"/>
            </xsl:if>
            <xsl:if test="$prmOffset ne ''">
                <xsl:attribute name="outputclass" select="$prmOffset"/>
            </xsl:if>
            <xsl:value-of select="$prmComment"/>
        </draft-comment>
    </xsl:function>
    
</xsl:stylesheet>