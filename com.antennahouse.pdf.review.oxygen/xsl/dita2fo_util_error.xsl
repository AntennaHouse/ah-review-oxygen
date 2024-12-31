<?xml version="1.0" encoding="UTF-8" ?>
<!--
    **************************************************************
    DITA to XML Stylesheet
    Error processing Templates
    **************************************************************
    Copyright © 2009 2023 Antenna House, Inc. All rights reserved.
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
     Error processing
    ===============================================
    -->
    
    <!-- Error message prefixes -->
    <xsl:variable name="internalErrorPrefixStr" as="xs:string" select="'[INTERNAL ERROR][CALL DEVELOPER]'"/>
    <xsl:variable name="fatalErrorPrefixStr" as="xs:string" select="'[FATAL ERROR]'"/>
    <xsl:variable name="errorPrefixStr" as="xs:string" select="'[ERROR]'"/>
    <xsl:variable name="warningPrefixStr" as="xs:string" select="'[WARNING]'"/>
    <xsl:variable name="infoPrefixStr" as="xs:string" select="'[INFO]'"/>
    
    <!-- 
     function:  Internal Error Exit template
     param:     prmMes: message body
     return:    none
     note:      Program logical error
    -->
    <xsl:template name="internalError">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="yes" select="$internalErrorPrefixStr || $prmMes"/>
    </xsl:template>
    
    <xsl:template name="internalErrorWithFileInfo">
        <xsl:param name="prmElem" required="yes" as="element()"/>
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:variable name="elemFileInfo" as="xs:string" select="ahf:getFileInfoOfElem($prmElem)"/>
        <xsl:message terminate="yes" select="$internalErrorPrefixStr || $prmMes || ' ' || $elemFileInfo"/>
    </xsl:template>
    
    <xsl:template name="internalErrorContinue">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="no" select="$internalErrorPrefixStr || $prmMes"/>
    </xsl:template>
    
    <xsl:template name="internalErrorContinueWithFileInfo">
        <xsl:param name="prmElem" required="yes" as="element()"/>
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:variable name="elemFileInfo" as="xs:string" select="ahf:getFileInfoOfElem($prmElem)"/>
        <xsl:message terminate="no" select="$internalErrorPrefixStr || $prmMes || ' ' || $elemFileInfo"/>
    </xsl:template>
    
    <!-- 
     function:  Error Exit template
     param:     prmMes: message body
     return:    none
     note:      none
    -->
    <xsl:template name="errorExit">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="yes" select="$fatalErrorPrefixStr || $prmMes"/>
    </xsl:template>
    
    <xsl:template name="errorExitWithFileInfo">
        <xsl:param name="prmElem" required="yes" as="element()"/>
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:variable name="elemFileInfo" as="xs:string" select="ahf:getFileInfoOfElem($prmElem)"/>
        <xsl:message terminate="yes" select="$fatalErrorPrefixStr || $prmMes || ' ' || $elemFileInfo"/>
    </xsl:template>
    
    <!-- 
     function:  Error Continue template
     param:     prmMes: message body
     return:    none
     note:      none
    -->
    <xsl:template name="errorContinue">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="no" select="$errorPrefixStr || $prmMes"/>
    </xsl:template>
    
    <xsl:template name="errorContinueWithFileInfo">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:param name="prmElem" required="yes" as="element()"/>
        <xsl:variable name="elemFileInfo" as="xs:string" select="ahf:getFileInfoOfElem($prmElem)"/>
        <xsl:message terminate="no" select="$errorPrefixStr || $prmMes || ' ' || $elemFileInfo"/>
    </xsl:template>
    
    <!-- 
     function:  Warning display template
     param:     prmMes: message body
     return:    none
     note:      none
    -->
    <xsl:template name="warningContinue">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="no" select="$warningPrefixStr || $prmMes"/>
    </xsl:template>
    
    <xsl:template name="warningContinueWithFileInfo">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:param name="prmElem" required="yes" as="element()"/>
        <xsl:variable name="elemFileInfo" as="xs:string" select="ahf:getFileInfoOfElem($prmElem)"/>
        <xsl:message terminate="no" select="$warningPrefixStr || $prmMes || ' ' || $elemFileInfo"/>
    </xsl:template>
    
    <!-- 
     function:  Warning display template
     param:     prmMes: message body
     return:    none
     note:      none
    -->
    <xsl:template name="infoContinue">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:message terminate="no" select="$infoPrefixStr || $prmMes"/>
    </xsl:template>
    
    <xsl:template name="infoContinueWithFileInfo">
        <xsl:param name="prmMes" required="yes" as="xs:string"/>
        <xsl:param name="prmElem" required="yes" as="element()"/>
        <xsl:variable name="elemFileInfo" as="xs:string" select="ahf:getFileInfoOfElem($prmElem)"/>
        <xsl:message terminate="no" select="$infoPrefixStr || $prmMes || ' ' || $elemFileInfo"/>
    </xsl:template>
    
    <!-- end of stylesheet -->
</xsl:stylesheet>
