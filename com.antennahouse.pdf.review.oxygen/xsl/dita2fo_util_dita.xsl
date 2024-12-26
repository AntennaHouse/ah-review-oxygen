<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to FO Stylesheet
    Utility Templates
    **************************************************************
    File Name : dita2fo_util_dita.xsl
    **************************************************************
    Copyright © 2009 2024 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL : http://www.antennahouse.com/
    **************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
 	xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
 	xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 	xmlns:ahd="http://www.antennahouse.com/names/XSLT/Debugging"
 	exclude-result-prefixes="xs ahf" >

    <!--
    ===============================================
     DITA Utility Templates
    ===============================================
    -->
    
    <!--
     function:   get line number & column number from @xtrc
     param:      prmElem
     return:     xs:string+
     note:       
    -->
    <xsl:variable name="cUnavailableNumber" as="xs:string" select="'Unavailable'"/>

    <xsl:function name="ahf:getLineAndColumnNumberOfElem" as="xs:string+">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="xtrc" as="xs:string?" select="$prmElem/@xtrc => string()"/>
        <xsl:choose>
            <xsl:when test="$xtrc eq ''">
                <xsl:sequence select="($cUnavailableNumber,$cUnavailableNumber)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="lineAndColumnPart" as="xs:string" select="substring-after($xtrc,';')"/>
                <xsl:choose>
                    <xsl:when test="$lineAndColumnPart eq ''">
                        <xsl:sequence select="($cUnavailableNumber,$cUnavailableNumber)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="line" as="xs:string" select="substring-before($lineAndColumnPart,':')"/>
                        <xsl:variable name="column" as="xs:string" select="substring-after($lineAndColumnPart,':')"/>
                        <xsl:sequence select="(if ($line eq '') then $cUnavailableNumber else $line, if ($column eq '') then $cUnavailableNumber else $column)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!--
     function:   get file path from @xtrf
     param:      prmElem
     return:     xs:string
     note:       
    -->
    <xsl:variable name="cUnavailableFile" as="xs:string" select="'Unavailable'"/>
    
    <xsl:function name="ahf:getFileNameOfElem" as="xs:string+">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="xtrf" as="xs:string?" select="$prmElem/@xtrf => string()"/>
        <xsl:sequence select="if (exists($xtrf)) then $xtrf else $cUnavailableFile"/>
    </xsl:function>        

    <!--
     function:   get file path, line and column information from element
     param:      prmElem
     return:     xs:string
     note:       
     -->
    <xsl:function name="ahf:getFileInfoOfElem" as="xs:string">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="filePath" as="xs:string" select="ahf:getFileNameOfElem($prmElem)"/>
        <xsl:variable name="lineAndColumn" as="xs:string+" select="ahf:getLineAndColumnNumberOfElem($prmElem)"/>
        <xsl:sequence select="'Path=''' || $filePath || ''' Line=' || $lineAndColumn[1] || ' Column=' || $lineAndColumn[2] "/>
    </xsl:function>     
    
    <!-- end of stylesheet -->
</xsl:stylesheet>
