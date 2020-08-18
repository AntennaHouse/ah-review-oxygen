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
        <xsl:sequence select="ahf:replace($prmStr,('&amp;amp;','&amp;lt;','&amp;gt;','&amp;quot;','&amp;apos;'),('&amp;','&lt;','&gt;','&quot;',&quot;&apos;&quot;))"/>
    </xsl:function>
    
</xsl:stylesheet>