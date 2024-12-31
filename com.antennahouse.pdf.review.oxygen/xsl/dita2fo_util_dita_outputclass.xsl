<?xml version="1.0" encoding="UTF-8" ?>
<!--
**************************************************************
DITA to XSL-FO Stylesheet
Utility Templates
**************************************************************
File Name : dita2fo_dita_util.xsl
**************************************************************
Copyright © 2009 2014 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL : http://www.antennahouse.com/
**************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
 	xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 	exclude-result-prefixes="xs ahf" >

    <!--
    ===============================================
     DITA Utility Templates
    ===============================================
    -->
    
    <!-- 
      ============================================
         toc utility
      ============================================
    -->
    
    <!-- 
     function:	Get @output class value as xs:string*
     param:		prmElem
     return:	xs:string*
     note:		
     -->
    <xsl:function name="ahf:getOutputClass" as="xs:string*">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="outputClass" as="xs:string" select="normalize-space(string($prmElem/@outputclass))"/>
        <xsl:sequence select="tokenize($outputClass,' ')"/>
    </xsl:function>

    <!-- 
     function:	Judge @outputclass has specified value
     param:		prmElem, prmValue
     return:	xs:boolean
     note:		
     -->
    <xsl:function name="ahf:hasOutputClassValue" as="xs:boolean">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:param name="prmValue" as="xs:string"/>
        <xsl:sequence select="$prmValue = ahf:getOutputClass($prmElem)"/>
    </xsl:function>

    <!-- 
     function:  Get @output class value with regex
     param:     prmElem, prmRegx, prmReplace
     return:    xs:string
     note:      prmRegEx must have several parts using "(" and ")"
                Ex: outputclass="width60" & prmRegx="(width)(\d+)" & prmReplace="\$2"
     -->
    <xsl:function name="ahf:getOutputClassRegx" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:param name="prmRegx" as="xs:string"/>
        <xsl:param name="prmReplace" as="xs:string"/>
        <xsl:variable name="outputClassValues" as="xs:string*" select="ahf:getOutputClass($prmElem)"/>
        <xsl:variable name="value" as="xs:string?">
            <xsl:for-each select="$outputClassValues[matches(.,$prmRegx)][1]">
                <xsl:sequence select="replace(.,$prmRegx,$prmReplace)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="if (exists($value)) then $value else ''"/>
    </xsl:function>
    
    <xsl:function name="ahf:getOutputClassRegxWithDefault" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:param name="prmRegx" as="xs:string"/>
        <xsl:param name="prmReplace" as="xs:string"/>
        <xsl:param name="prmDefault" as="xs:string"/>
        <xsl:variable name="result" as="xs:string" select="ahf:getOutputClassRegx($prmElem,$prmRegx,$prmReplace)"/>
        <xsl:sequence select="if ($result eq '') then $prmDefault else $result"/>
    </xsl:function>

    <!-- end of stylesheet -->
</xsl:stylesheet>
