<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Basic Node Utility.
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
    
    <!-- Basic Node Functions
      -->
    
    <!-- 
     function:  Determine $prmNode is located before/after or self of $prmBase
     param:     prmNode, prmBase
     return:    xs:boolean?
     note:      	
     -->
    <xsl:function name="ahf:isBeforeOrSelfNode" as="xs:boolean?">
        <xsl:param name="prmNode" as="node()?"/>
        <xsl:param name="prmBase" as="node()?"/>
        <xsl:sequence select="($prmNode &lt;&lt; $prmBase) or ($prmNode is $prmBase)"/>
    </xsl:function>
    
    <xsl:function name="ahf:isBeforeNode" as="xs:boolean?">
        <xsl:param name="prmNode" as="node()?"/>
        <xsl:param name="prmBase" as="node()?"/>
        <xsl:sequence select="$prmNode &lt;&lt; $prmBase"/>
    </xsl:function>
    
    <xsl:function name="ahf:isAfterOrSelfNode" as="xs:boolean?">
        <xsl:param name="prmNode" as="node()?"/>
        <xsl:param name="prmBase" as="node()?"/>
        <xsl:sequence select="($prmNode &gt;&gt; $prmBase) or ($prmNode is $prmBase)"/>
    </xsl:function>
    
    <xsl:function name="ahf:isAfterNode" as="xs:boolean?">
        <xsl:param name="prmNode" as="node()?"/>
        <xsl:param name="prmBase" as="node()?"/>
        <xsl:sequence select="$prmNode &gt;&gt; $prmBase"/>
    </xsl:function>

    <!-- 
     function:  Determine whether $prmNode is between $prmStartNode and $prmEndNode
     param:     prmNode, prmStartNode, prmEndNode
     return:    xs:boolean
     note:      
     -->
    <xsl:function name="ahf:isNodeInBetween" as="xs:boolean">
        <xsl:param name="prmNode" as="node()?"/>
        <xsl:param name="prmStartNode" as="node()"/>
        <xsl:param name="prmEndNode" as="node()"/>
        <xsl:variable name="isNodeInBetween" as="xs:boolean" select="$prmNode[. => ahf:isAfterOrSelfNode($prmStartNode)][. => ahf:isBeforeOrSelfNode($prmEndNode)] => exists()"/>
        <xsl:sequence select="$isNodeInBetween"/>
    </xsl:function>

    <!-- 
     function:  Get insert PI valance number
     param:     prmInsertEndPi, prmInsertStartPi, prmRoot
     return:    xs:integer
     note:      oxy_insert_start is counted as 1. oxy_insert_end is counted as -1.
     -->
    <!--xsl:function name="ahf:getInsertValanceCount" as="xs:integer">
        <xsl:param name="prmInsertStartPi" as="processing-instruction()"/>
        <xsl:param name="prmInsertEndPi" as="processing-instruction()"/>
        <xsl:param name="prmRoot" as="element()"/>
        <xsl:variable name="InsertPiBetween" as="processing-instruction()+" select="$prmRoot/descendant::processing-instruction()[ahf:isInsertStartPi(.) or ahf:isInsertEndPi(.)][. &gt;&gt; $prmInsertStartPi][. &lt;&lt; $prmInsertEndPi]|$prmInsertStartPi|$prmInsertEndPi"/>
        <xsl:sequence select="$InsertPiBetween ! ahf:getInsertPiValanceValue(.) => sum()"/>
    </xsl:function>

    <xsl:function name="ahf:getInsertPiValanceValue" as="xs:integer">
        <xsl:param name="prmInsertPi" as="processing-instruction()"/>
        <xsl:choose>
            <xsl:when test="ahf:isInsertStartPi($prmInsertPi)">
                <xsl:sequence select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="-1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function-->

    <!-- 
     function:  Get insert PI from text node
     param:     prmText, prmRoot
     return:    processing-instruction
     note:      
     -->
    <xsl:function name="ahf:getInsertStartPiFromText" as="processing-instruction()?">
        <xsl:param name="prmText" as="text()"/>
        <xsl:param name="prmRoot" as="element()"/>
        <xsl:sequence select="$prmRoot/descendant::processing-instruction()[. => ahf:isInsertStartPi()][. &lt;&lt; $prmText][last()]"/>
    </xsl:function>

    <!-- 
     function:  Judge whether $prmNode is the child of elements that have namespace-URI (SVG, MathML, ...)
     param:     prmNode
     return:    xs:boolean
     note:      
     -->
    <xsl:function name="ahf:hasSvgOrMathMlNameSpace" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode => namespace-uri() = ('http://www.w3.org/2000/svg', 'http://www.w3.org/1998/Math/MathML')"/>
    </xsl:function>
    
    <xsl:function name="ahf:isSvgOrMathMlElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="$prmNode/self::element() and ahf:hasSvgOrMathMlNameSpace($prmNode)"/>
    </xsl:function>
    
    <xsl:function name="ahf:isChildOfSvgOrMathMlElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:variable name="parentElem" as="element()?" select="$prmNode/parent::*"/>
        <xsl:choose>
            <xsl:when test="$parentElem => empty()">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="$parentElem/self::element() and ahf:isSvgOrMathMlElem($parentElem)">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="ahf:isNotChildOfSvgOrMathMlElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="ahf:isChildOfSvgOrMathMlElem($prmNode) => not()"/>
    </xsl:function>
    
    <xsl:function name="ahf:isChildOfAnyNameSpaceElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:variable name="parentElem" as="element()?" select="$prmNode/parent::*"/>
        <xsl:choose>
            <xsl:when test="$parentElem => empty()">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="ahf:isChildOfSvgOrMathMlElem($prmNode)">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="$parentElem => namespace-uri() eq ''">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="true()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="ahf:isNotChildOfAnyNameSpaceElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="ahf:isChildOfAnyNameSpaceElem($prmNode) => not()"/>
    </xsl:function>

    <xsl:function name="ahf:isDescendantOfSvgOrMathMlElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:variable name="hasAncestorSvgOrMathMlElem" as="xs:boolean" select="$prmNode/ancestor-or-self::*[ahf:isSvgOrMathMlElem(.)] => exists()"/>
        <xsl:sequence select="$hasAncestorSvgOrMathMlElem"/>
    </xsl:function>

    <xsl:function name="ahf:isNotDescendantOfSvgOrMathMlElem" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:sequence select="ahf:isDescendantOfSvgOrMathMlElem($prmNode) => not()"/>
    </xsl:function>

</xsl:stylesheet>