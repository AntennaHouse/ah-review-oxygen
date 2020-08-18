<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:ahs="http://www.antennahouse.com/names/XSLT/Document/Layout"
    exclude-result-prefixes="xs ahf"
    >
    
    <xsl:function name="ahf:getFoStyleAndProperty" as="attribute()*">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:sequence select="ahf:getFoStyle($prmElem)"/>
        <xsl:sequence select="ahf:getFoProperty($prmElem)"/>
        <xsl:copy-of select="$prmElem/@axf:*"/>
    </xsl:function>
    
</xsl:stylesheet>