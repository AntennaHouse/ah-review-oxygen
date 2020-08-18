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
    
</xsl:stylesheet>