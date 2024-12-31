<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to FO Stylesheet
    Utility Templates
    **************************************************************
    File Name : dita2fo_util_pi.xsl
    **************************************************************
    Copyright © 2009 2024 Antenna House, Inc. All rights reserved.
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
     PI Utility Templates
    ===============================================
    -->
    
    <!--
     function:   get text representation of PI
     param:      prmPi
     return:     xs:string
     note:       
    -->
    <xsl:function name="ahf:PiToText" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="resultSeq" as="xs:string*">
            <xsl:sequence select="'&lt;?'"/>
            <xsl:sequence select="$prmPi => name()"/>
            <xsl:sequence select="' '"/>
            <xsl:sequence select="$prmPi => string()"/>
            <xsl:sequence select="'?&gt;'"/>
        </xsl:variable>
        <xsl:sequence select="string-join($resultSeq)"/>
    </xsl:function>
    
    <!-- end of stylesheet -->
</xsl:stylesheet>
