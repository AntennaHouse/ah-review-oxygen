<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Global Variable Stylesheet.
  Copyright © 2009-2020 Antenna House, Inc. All rights reserved.
  Antenna House is a trademark of Antenna House, Inc.
  URL    : http://www.antennahouse.com/
  E-mail : info@antennahouse.com
  ****************************************************************
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- map or bookmap:  -->
    <xsl:variable name="gRoot"  as="element()" select="/*[1]"/>
    <xsl:variable name="gMap" as="element()" select="$gRoot/*[contains-token(@class,'map/map')][1]"/>
    
    <!-- topics -->
    <xsl:variable name="gTopics" as="element()*" select="$gRoot/*[contains-token(@class,'topic/topic')]"/>

    <!-- tracking change comment users -->
    <xsl:variable name="gUsers" as="xs:string*" select="$gTopics/descendant::processing-instruction() ! ahf:getAuthorFromPi(.) => distinct-values()"/>

</xsl:stylesheet>