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
    version="3.0">

    <!-- 
     function:  Draft-comment Insert Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentInsert" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        
        <xsl:if test="$gpOutputInsertChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barInsertBegin,$prmId)"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$gpOutputChangeIcons and $gpChangeTrackingOutputInsertAnnotation">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationInsert"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="if (string($prmComment)) then $prmTime || ' Inserted: ' || $prmComment else $prmTime || ' Inserted'"/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="$gpOutputOxyComments and string($prmComment)">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationComment"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="$prmComment => ahf:unEscapeXmlChar()"/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  Draft-comment Insert Surround Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentInsertSurround" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        <xsl:if test="$gpOutputInsertChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barInsertBegin,$prmId)"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$gpOutputChangeIcons and $gpChangeTrackingOutputInsertAnnotation">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationInsert"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="if (string($prmComment)) then $prmTime || ' Inserted (Surround): ' || $prmComment else $prmTime || ' Inserted (Surround)'"/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="$gpOutputOxyComments and string($prmComment)">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationComment"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="$prmComment => ahf:unEscapeXmlChar()"/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Draft-comment Insert Split Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentInsertSplit" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        <xsl:if test="$gpOutputInsertChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barInsertBegin,$prmId)"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$gpOutputChangeIcons and $gpChangeTrackingOutputInsertAnnotation">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationInsert"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="if (string($prmComment)) then $prmTime || ' Inserted (Split): ' || $prmComment else $prmTime || ' Inserted (Split)'"/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="$gpOutputOxyComments and string($prmComment)">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationComment"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="$prmComment => ahf:unEscapeXmlChar()"/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Draft-comment Insert End Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentInsertEnd" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        
        <xsl:if test="$gpOutputInsertChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barInsertEnd,$prmId)"/>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  Draft-comment Insert Surround End Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentInsertSurroundEnd" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        
        <xsl:if test="$gpOutputInsertChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barInsertEnd,$prmId)"/>
        </xsl:if>
    </xsl:template>

    <!-- 
     function:  Draft-comment Insert Split End Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentInsertSplitEnd" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        
        <xsl:if test="$gpOutputInsertChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barInsertEnd,$prmId)"/>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  Draft-comment Delete Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentDelete" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
        <xsl:if test="$gpOutputDeleteChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barDeleteBegin,$prmId)"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$gpOutputChangeIcons and $gpChangeTrackingOutputDeleteAnnotation">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationDelete"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="$prmTime || (if (string($prmComment)) then ' Deleted: ' else ' Deleted') || $prmComment"/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="$gpOutputOxyComments and string($prmComment)">
                <fo:inline>
                    <xsl:copy-of select="$atsAnnotationComment"/>
                    <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                    <xsl:attribute name="axf:annotation-contents" select="$prmComment => ahf:unEscapeXmlChar()"/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- 
     function:  Draft-comment Delete End Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentDeleteEnd" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>

        <xsl:if test="$gpOutputDeleteChangeBars">
            <xsl:copy-of select="ahf:addChangeBar($barDeleteEnd,$prmId)"/>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  Draft-comment Comment Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentComment" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>

        <xsl:if test="$gpOutputOxyComments">
            <fo:inline>
                <xsl:copy-of select="$atsAnnotationComment"/>
                <xsl:attribute name="axf:annotation-author" select="$prmAuthor"/>
                <xsl:attribute name="axf:annotation-contents" select="$prmComment => ahf:unEscapeXmlChar()"/>
                <xsl:if test="string($prmOutputClass)">
                    <xsl:variable name="offset" as="xs:string" select="replace($prmOutputClass,'^(' || $cDraftCommentOffset || ')(\d+)$','$2')"/>
                    <xsl:attribute name="axf:annotation-position-horizontal" select="$gpChangeTrackingAnnotationPositionHorizontal || ' + ' || $offset || 'mm'"/>
                    <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVertical || ' - ' || $offset || 'mm'"/>
                </xsl:if>
            </fo:inline>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  Draft-comment Comment End Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentCommentEnd" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>
    </xsl:template>

    <!-- 
     function:  Draft-comment Attribute Template For Change-Tracking
     param:     See probe
     return:    element()*
     note:	  
     -->
    <xsl:template name="draftCommentAttribute" as="element()*">
        <xsl:param name="prmAuthor" required="yes" as="xs:string"/>
        <xsl:param name="prmTime" required="yes" as="xs:string"/>
        <xsl:param name="prmComment" required="yes" as="xs:string"/>
        <xsl:param name="prmId" required="yes" as="xs:string"/>
        <xsl:param name="prmOutputClass" required="yes" as="xs:string"/>

        <fo:inline>
            <xsl:copy-of select="$atsAnnotationComment"/>
            <xsl:attribute name="axf:annotation-contents" select="$prmComment"/>
        </fo:inline>
    </xsl:template>
    
    
    <!-- 
     function:  Genrate Change Bar
     param:     prmType
     return:	fo:change-bar-begin, fo:change-bar-end
     note:		
     -->
    <xsl:variable name="barInsertBegin" as="xs:string" static="yes" select="'barInsertBegin'"/>
    <xsl:variable name="barInsertEnd"   as="xs:string" static="yes" select="'barInsertEnd'"/>
    <xsl:variable name="barDeleteBegin" as="xs:string" static="yes" select="'barDeleteBegin'"/>
    <xsl:variable name="barDeleteEnd"   as="xs:string" static="yes" select="'barDeleteEnd'"/>
    
    <xsl:function name="ahf:addChangeBar" as="element()">
        <xsl:param name="prmType" as="xs:string"/>
        <xsl:param name="prmId"   as="xs:string"/>
        
        <xsl:variable name="changeBarClass" as="xs:string" select="'CHGBAR_' || $prmId"/>
        <xsl:choose>
            <xsl:when test="$prmType eq $barInsertBegin">
                <fo:change-bar-begin>
                    <xsl:copy-of select="$atsChangeBarInsert"/>
                    <xsl:attribute name="change-bar-class" select="$changeBarClass"/>
                </fo:change-bar-begin>
            </xsl:when>
            <xsl:when test="$prmType eq $barInsertEnd">
                <fo:change-bar-end>
                    <xsl:attribute name="change-bar-class" select="$changeBarClass"/>
                </fo:change-bar-end>
            </xsl:when>
            <xsl:when test="$prmType eq $barDeleteBegin">
                <fo:change-bar-begin>
                    <xsl:copy-of select="$atsChangeBarDelete"/>
                    <xsl:attribute name="change-bar-class" select="$changeBarClass"/>
                </fo:change-bar-begin>
            </xsl:when>
            <xsl:when test="$prmType eq $barDeleteEnd">
                <fo:change-bar-end>
                    <xsl:attribute name="change-bar-class" select="$changeBarClass"/>
                </fo:change-bar-end>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>