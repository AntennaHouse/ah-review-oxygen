<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: FO property utilities
  Copyright © 2009-2025 Antenna House, Inc. All rights reserved.
  Antenna House is a trademark of Antenna House, Inc.
  URL    : http://www.antennahouse.com/
  E-mail : info@antennahouse.com
  ****************************************************************
 -->
<xsl:stylesheet version="3.0" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:ahs="http://www.antennahouse.com/names/XSLT/Document/Layout"
    exclude-result-prefixes="xs ahf"
    >
    <!-- 
         function:  Get chage-tracking insert FO attribute
         param:     prmElem
         return:	attribute()
         note:      
    -->
    <xsl:function name="ahf:getChangeTrackingFoPropertyInsert" as="attribute()">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="insertFoProp" as="attribute()?" select="$prmElem/@*[name() eq $gpChangeTrackingFoPropNameInsert]"/>
        <xsl:attribute name="{$gpChangeTrackingFoPropNameInsert}" select="string($insertFoProp)"/>        
    </xsl:function>

    <xsl:function name="ahf:getEmptyChangeTrackingFoPropertyInsert" as="attribute()">
        <xsl:attribute name="{$gpChangeTrackingFoPropNameInsert}" select="''"/>        
    </xsl:function>
    
    <!-- 
         function:  Get chage-tracking delete FO attribute
         param:     prmElem
         return:	attribute()
         note:      
    -->
    <xsl:function name="ahf:getChangeTrackingFoPropertyDelete" as="attribute()?">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="deleteFoProp" as="attribute()?" select="$prmElem/@*[name() eq $gpChangeTrackingFoPropNameDelete]"/>
        <xsl:attribute name="{$gpChangeTrackingFoPropNameDelete}" select="string($deleteFoProp)"/>        
    </xsl:function>
    
    <xsl:function name="ahf:getEmptyChangeTrackingFoPropertyDelete" as="attribute()">
        <xsl:attribute name="{$gpChangeTrackingFoPropNameDelete}" select="''"/>        
    </xsl:function>
    
    
    <!-- 
         function:  Get chage-tracking comment FO attribute
         param:     prmElem
         return:	attribute()
         note:      
    -->
    <xsl:function name="ahf:getChangeTrackingFoPropertyComment" as="attribute()">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="commentFoProp" as="attribute()?" select="$prmElem/@*[name() eq $gpChangeTrackingFoPropNameComment]"/>
        <xsl:attribute name="{$gpChangeTrackingFoPropNameComment}" select="string($commentFoProp)"/>
    </xsl:function>

    <xsl:function name="ahf:getEmptyChangeTrackingFoPropertyComment" as="attribute()">
        <xsl:attribute name="{$gpChangeTrackingFoPropNameComment}" select="''"/>
    </xsl:function>
    
    <!-- 
         function:  Get chage-tracking highlight FO attribute
         param:     prmElem
         return:	attribute()
         note:      
    -->
    <xsl:function name="ahf:getChangeTrackingFoPropertyHighlight" as="attribute()?">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="highlightFoProp" as="attribute()?" select="$prmElem/@*[name() eq $gpChangeTrackingFoPropNameHighlight]"/>
        <xsl:attribute name="{$gpChangeTrackingFoPropNameHighlight}" select="string($highlightFoProp)"/>
    </xsl:function>

    <xsl:function name="ahf:getEmptyChangeTrackingFoPropertyHighlight" as="attribute()">
        <xsl:attribute name="{$gpChangeTrackingFoPropNameHighlight}" select="''"/>
    </xsl:function>
    
    <!-- 
         function:  Normalize CSS notation string
         param:     prmCssStr
         return:	xs:string
         note:      
    -->
    <xsl:function name="ahf:normalizeCssNotation" as="xs:string">
        <xsl:param name="prmCssStr" as="xs:string"/>
        <xsl:variable name="normalizedCssStr" as="xs:string" select="normalize-space($prmCssStr)"/>
        <xsl:choose>
            <xsl:when test="$normalizedCssStr eq ''">
                <xsl:sequence select="$normalizedCssStr"/>
            </xsl:when>
            <xsl:when test="$normalizedCssStr => ends-with(';')">
                <xsl:sequence select="$normalizedCssStr"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$normalizedCssStr || ';'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
         function:  Filter empty attribute
         param:     prmAttr
         return:	attribute()?
         note:      
    -->
    <xsl:function name="ahf:filterEmptyAttr" as="attribute()?">
        <xsl:param name="prmAttr" as="attribute()?"/>
        <xsl:choose>
            <xsl:when test="string($prmAttr)">
                <xsl:sequence select="$prmAttr"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
         function:  Null to zero (Empty to specified item)
         param:     prmItem, prmBool, prmRetFalse
         return:	item()*
         note:      
    -->
    <xsl:function name="ahf:nz" as="item()*">
        <xsl:param name="prmItem" as="item()*"/>
        <xsl:param name="prmBool" as="xs:boolean"/>
        <xsl:param name="prmRetFalse" as="item()*"/>
        <xsl:choose>
            <xsl:when test="$prmBool">
                <xsl:sequence select="$prmItem"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$prmRetFalse"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>