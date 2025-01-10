<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking String Utility Stylesheet.
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
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 
     function:  Unescape XML character in input 
     param:     prmStr
     return:    xs:string
     note:      Return un-escaped result.
     -->
    <xsl:function name="ahf:unEscapeXmlChar" as="xs:string">
        <xsl:param name="prmStr" as="xs:string"/>
        <xsl:sequence select="ahf:replace($prmStr,('&amp;lt;','&amp;gt;','&amp;amp;','&amp;quot;','&amp;apos;'),('&lt;','&gt;','&amp;','&quot;',&quot;&apos;&quot;))"/>
    </xsl:function>

    <!-- 
     function:  Parse XML fragment by adding root element 
     param:     prmStr
     return:    xs:string
     note:      Return document-node().
     -->
    <xsl:function name="ahf:parseXmlFragmentEx" as="document-node()?">
        <xsl:param name="prmStr" as="xs:string"/>
        <xsl:variable name="parseStr" as="xs:string" select="'&lt;root xmlns:m=&quot;http://www.w3.org/2005/xpath-functions/math&quot; &gt;' || $prmStr || '&lt;/root&gt;'"/>
        <xsl:try select="parse-xml-fragment($parseStr)">
            <xsl:catch errors="*">
                <xsl:message select="'[ahf:parseXmlFragmentEx] Failed to parse string. code=' || $err:code || ' description=' || $err:description || ' value=' || $err:value"/>
                <xsl:sequence select="()"/>
            </xsl:catch>
        </xsl:try>
    </xsl:function>
    

</xsl:stylesheet>