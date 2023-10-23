<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Color Utility Stylesheet.
  Copyright © 2009-2020 Antenna House, Inc. All rights reserved.
  Antenna House is a trademark of Antenna House, Inc.
  URL    : http://www.antennahouse.com/
  E-mail : info@antennahouse.com
  ****************************************************************
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 
     function:  Add color property to fo:prop (foreground/background) 
     param:     prmColor
     return:    fo:prop
     note:      Add 'color:$prmColor;' to last part of fo:prop.
     -->
    <xsl:function name="ahf:addColorToFoProp" as="attribute()?">
        <xsl:param name="prmFoProp" as="attribute()?"/>
        <xsl:param name="prmColor" as="xs:string"/>
        <xsl:variable name="foProp" as="xs:string" select="$prmFoProp => string() => normalize-space()"/>
        <xsl:variable name="foPropRevised" as="xs:string" select="if (ends-with($foProp,';') or string($foProp) => not()) then $foProp else $foProp || ';'"/>
        <xsl:choose>
            <xsl:when test="string($prmColor)">
                <xsl:attribute name="{$gpFoPropName}" select="$foPropRevised || 'color:' || $prmColor || ';'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$prmFoProp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="ahf:addBgColorToFoProp" as="attribute()?">
        <xsl:param name="prmFoProp" as="attribute()?"/>
        <xsl:param name="prmColor" as="xs:string"/>
        <xsl:variable name="foProp" as="xs:string" select="$prmFoProp => string() => normalize-space()"/>
        <xsl:variable name="foPropRevised" as="xs:string" select="if (ends-with($foProp,';') or string($foProp) => not()) then $foProp else $foProp || ';'"/>
        <xsl:choose>
            <xsl:when test="string($prmColor)">
                <xsl:attribute name="{$gpFoPropName}" select="$foPropRevised || 'background-color:' || $prmColor || ';'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$prmFoProp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  Get Color Spec from PI content
     param:     prmPi
     return:    xs:string
     note:      Extract color portion from PI as RGB specification
     -->
    <xsl:function name="ahf:getColorFromPi" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="piContent" as="xs:string" select="$prmPi => string()"/>
        <xsl:variable name="piDecomposed" as="xs:string*" select="$piContent => tokenize('[\s]+')"/>
        <xsl:variable name="colorPart" as="xs:string?" select="$piDecomposed[. => starts-with('color=&quot;')][1]"/>
        <xsl:assert test="$colorPart => exists()" select="'[ahf:getColorFromPi] Empty color sepc. PI=',$prmPi"/>
        <xsl:sequence select="'rgb(' || substring($colorPart, 8, string-length($colorPart) - 8) || ')'"/>
    </xsl:function>

    <!-- 
     function:  Get insert foreground color by referencing user
     param:     prmPi (Insert)
     return:    xs:string
     note:      
     -->
    <xsl:function name="ahf:getInsertFgColorSpecFromPi" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="author" as="xs:string" select="$prmPi => ahf:getAuthorFromPi()"/>
        <xsl:choose>
            <xsl:when test="$author ne ''">
                <xsl:variable name="authorIndex" as="xs:integer?" select="($gUsers => index-of($author))[1]"/>
                <xsl:assert test="$authorIndex => exists()" select="'[ahf:getInsertFgSpecFromPi] Missing author=' || $author"/>
                <xsl:variable name="colorIndex" as="xs:integer" select="if ($authorIndex le $gpChangeTrackingUserInsertFgColorCount) then $authorIndex else $authorIndex mod $gpChangeTrackingUserInsertFgColorCount + 1"/>
                <xsl:variable name="fgColor" as="xs:string" select="$gpChangeTrackingUserInsertFgColor[$colorIndex]"/>
                <xsl:sequence select="$fgColor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  Get delete foreground color by referencing user
     param:     prmPi (Delete)
     return:    xs:string
     note:      
     -->
    <xsl:function name="ahf:getDeleteFgColorSpecFromPi" as="xs:string">
        <xsl:param name="prmPi" as="processing-instruction()"/>
        <xsl:variable name="author" as="xs:string" select="$prmPi => ahf:getAuthorFromPi()"/>
        <xsl:choose>
            <xsl:when test="$author ne ''">
                <xsl:variable name="authorIndex" as="xs:integer?" select="($gUsers => index-of($author))[1]"/>
                <xsl:assert test="$authorIndex => exists()" select="'[ahf:getDeleteFgSpecFromPi] Missing author=' || $author"/>
                <xsl:variable name="colorIndex" as="xs:integer" select="if ($authorIndex le $gpChangeTrackingUserDeleteFgColorCount) then $authorIndex else $authorIndex mod $gpChangeTrackingUserDeleteFgColorCount + 1"/>
                <xsl:variable name="fgColor" as="xs:string" select="$gpChangeTrackingUserDeleteFgColor[$colorIndex]"/>
                <xsl:sequence select="$fgColor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  Get comment background color by referencing user
     param:     prmCommentPi
     return:    xs:string (rgba)
     note:      $prmCommentPis is the stack of comment processing-instruction.
     -->
    <xsl:function name="ahf:getCommentBgColorSpecFromPi" as="xs:string">
        <xsl:param name="prmCommentPis" as="processing-instruction()*"/>
        <xsl:variable name="firstAuthor" as="xs:string">
            <xsl:choose>
                <xsl:when test="$prmCommentPis => empty()">
                    <xsl:sequence select="''"/>
                </xsl:when>
                <xsl:when test="$prmCommentPis[1] => ahf:getParentIdFromPiContent() ne ''">
                    <xsl:sequence select="$prmCommentPis[. => ahf:getIdFromPiContent() ne ''][1] => ahf:getAuthorFromPi()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$prmCommentPis[1] => ahf:getAuthorFromPi()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$gpStep2Debug">
            <xsl:message select="'[ahf:getCommentBgColorSpecFromPi] $firstAuthor=' || $firstAuthor"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$firstAuthor ne ''">
                <xsl:variable name="firstAuthorIndex" as="xs:integer?" select="($gUsers => index-of($firstAuthor))[1]"/>
                <xsl:assert test="$firstAuthorIndex => exists()" select="'[ahf:getCommentColor] Missing author=' || $firstAuthor"/>
                <xsl:variable name="colorIndex" as="xs:integer" select="if ($firstAuthorIndex le $gpChangeTrackingCommentBgColorCount) then $firstAuthorIndex else $firstAuthorIndex mod $gpChangeTrackingCommentBgColorCount + 1"/>
                <xsl:variable name="bgColor" as="xs:string" select="$gpChangeTrackingCommentBgColor[$colorIndex]"/>
                <xsl:variable name="commentPiNestLevel" as="xs:integer" select="$prmCommentPis => ahf:getCommentPiNestingLevel() - 1"/>
                <xsl:variable name="bgColorOpacity" as="xs:double" select="$gpChangeTrackingCommentBgColorOpacityBase + $gpChangeTrackingCommentBgColorOpacityRatio * $commentPiNestLevel"/>
                <xsl:variable name="bgColorOpacityRevised" as="xs:double" select="if ($bgColorOpacity gt 1.0) then 1.0 else $bgColorOpacity"/>
                <xsl:variable name="bgColorOpacityRevisedStr" as="xs:string" select="format-number($bgColorOpacityRevised,'0.000')"/>
                <xsl:variable name="bgColorRgbASpec" as="xs:string" select="'rgba(' || $bgColor || ',' || $bgColorOpacityRevisedStr || ')'"/>
                <xsl:sequence select="$bgColorRgbASpec"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>