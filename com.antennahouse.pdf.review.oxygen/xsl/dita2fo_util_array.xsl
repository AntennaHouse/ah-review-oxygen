<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to FO Stylesheet
    Utility Templates
    **************************************************************
    File Name : dita2fo_util_array.xsl
    **************************************************************
    Copyright © 2009 2024 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:array="http://www.w3.org/2005/xpath-functions/array"
	xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
	exclude-result-prefixes="xs ahf array" >

    <!--
    ===============================================
     Array Utility Templates
    ===============================================
    -->
    
    <!--
     function:   get contents from sequence of array by index
     param:      prmArrays, prmIndex
     return:     item()*
     note:       
    -->
    <xsl:function name="ahf:arraySeqGet" as="item()*">
        <xsl:param name="prmArrays" as="array(item())*"/>
        <xsl:param name="prmIndex" as="xs:integer"/>
        <xsl:for-each select="$prmArrays">
            <xsl:variable name="array" as="array(item())" select="."/>
            <xsl:sequence select="array:get($array,$prmIndex)"/>
        </xsl:for-each>
    </xsl:function>
    
    <!-- end of stylesheet -->
</xsl:stylesheet>
