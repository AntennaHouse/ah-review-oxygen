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
    <!-- IMPORTANT NOTICE
         The import side template (ex. dita2fo_shell.xsl in com.antennahouse.pdf5.ml) must:
         · Define variable $stMes800, $stMes800
         · Define template warningContinue
     -->

    <!-- 
         function:  Expand FO property into attribute()*
         param:     prmElem
         return:	Attribute node
         note:      XSL-FO attribute is authored in $prmElem/@fo:prop in CSS notation.
                    2014-04-22 t.makita
                    Remove stylesheet specific style (starts with "ahs-").
                    2016-02-20 t,makita
                    warningContinue, stMes802 should be defined in the PDF5-ML side 
                    because dita2fo_change_tracking_gen_annotation_shell.xsl is imported in PDF5-ML stylesheet.
                    Add $gpChangeTrackingFoPropName for change tracking specific FO processing.
                    2025-01-26 t.makita
    -->
    <xsl:function name="ahf:getFoProperty" as="attribute()*">
        <xsl:param name="prmElem" as="element()"/>
        
        <xsl:choose>
            <xsl:when test="exists($prmElem/@*[name() = ($gpFoPropName,$gpChangeTrackingFoPropName)])">
                <xsl:variable name="foAttr" as="xs:string">
                    <xsl:variable name="foProp" as="xs:string" select="normalize-space(string($prmElem/@*[name() eq $gpFoPropName]))"/>
                    <xsl:variable name="changeTrackingFoProp" as="xs:string">
                        <xsl:choose>
                            <xsl:when test="$gpOutputChangesOrCommentsOrHighlights">
                                <xsl:sequence select="normalize-space(string($prmElem/@*[name() eq $gpChangeTrackingFoPropName]))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:sequence select="if (ends-with($foProp,';')) then $foProp || $changeTrackingFoProp else $foProp || ';' || $changeTrackingFoProp"/>
                </xsl:variable>
                <xsl:for-each select="tokenize($foAttr, ';')">
                    <xsl:variable name="propDesc" select="normalize-space(string(.))"/>
                    <xsl:choose>
                        <xsl:when test="not(string($propDesc))"/>
                        <xsl:when test="contains($propDesc,':')">
                            <xsl:variable name="propName" as="xs:string">
                                <xsl:variable name="tempPropName" as="xs:string" select="normalize-space(substring-before($propDesc,':'))"/>
                                <xsl:variable name="axfExt" as="xs:string" select="'axf-'"/>
                                <xsl:variable name="ahsExt" as="xs:string" select="'ahs-'"/>
                                <xsl:choose>
                                    <xsl:when test="starts-with($tempPropName,$axfExt)">
                                        <xsl:sequence select="concat('axf:',substring-after($tempPropName,$axfExt))"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($tempPropName,$ahsExt)">
                                        <xsl:sequence select="''"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:sequence select="$tempPropName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>                            
                            <xsl:variable name="propValue" as="xs:string" select="normalize-space(substring-after($propDesc,':'))"/>
                            <xsl:choose>
                                <xsl:when test="not(string($propName))"/>
                                <!--"castable as xs:NAME" can be used only in Saxon PE or EE.
                                    If $propName does not satisfy above, xsl:attribute instruction will be faild!
                                    2014-04-22 t.makita
                                 -->
                                <!--xsl:when test="$propName castable as xs:NAME"-->
                                <xsl:when test="true()">
                                    <xsl:attribute name="{$propName}" select="$propValue"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="warningContinue">
                                        <xsl:with-param name="prmMes" select="ahf:replace($stMes802,('%propName','%xtrc','%xtrf'),($propName,string($prmElem/@xtrc),string($prmElem/@xtrf)))"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="warningContinue">
                                <xsl:with-param name="prmMes" select="ahf:replace($stMes800,('%foAttr','%xtrc','%xtrf'),($foAttr,string($prmElem/@xtrc),string($prmElem/@xtrf)))"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>