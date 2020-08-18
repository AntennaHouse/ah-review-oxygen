<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Tracking Change Stylesheet.
  Copyright © 2009-2020 Antenna House, Inc. All rights reserved.
  Antenna House is a trademark of Antenna House, Inc.
  URL    : http://www.antennahouse.com/
  E-mail : info@antennahouse.com
  ****************************************************************
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math"
    version="2.0">

    <!-- 
     function:  Get li number
     param:     prmLi
     return:    x:integer
     note:      Count li without task/stepsection, @outputclass=""
     -->
    <xsl:function name="ahf:countLi" as="xs:integer">
        <xsl:param name="prmLi" as="element()"/>
        <xsl:sequence select="count($prmLi | $prmLi/preceding-sibling::*[contains(@class,' topic/li ')][not(contains(@class,' task/stepsection ')) and not(ahf:hasOutputClassValue(.,$cOutputClassDeleteAttributesLi))])"/>
    </xsl:function>

    <!-- 
     function:  Delete/Attributes li
     param:     
     return:    fo:list-item
     note:      Do not generate bullet.
     -->
    <xsl:template match="*[contains(@class,' topic/li ')][ahf:hasOutputClassValue(.,$cOutputClassDeleteAttributesLi)]" priority="4">
        <fo:list-item>
            <fo:list-item-label><fo:block/></fo:list-item-label>
            <fo:list-item-body>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
    
    <!-- 
     function:    get step number
     param:       prmStep 
     return:      xs:integer
     note:        Skip stepsection		
     -->
    <xsl:function name="ahf:getStepNumber" as="xs:integer">
        <xsl:param name="prmStep" as="element()"/>
        <xsl:sequence select="count($prmStep| $prmStep/preceding-sibling::*[contains(@class,' topic/li ')][not(contains(@class,' task/stepsection ')) and not(ahf:hasOutputClassValue(.,$cOutputClassDeleteAttributesLi))])"/>
    </xsl:function>

</xsl:stylesheet>