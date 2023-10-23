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
     function:  Draft-comment Template For Change-Tracking
     param:     None
     return:    
     note:		
     -->
    <xsl:template match="*[contains(@class,' topic/draft-comment ')]
                          [string(@disposition) = ($cDraftCommentDispositionInsert, 
                                                   $cDraftCommentDispositionInsertSplit, 
                                                   $cDraftCommentDispositionInsertEnd, 
                                                   $cDraftCommentDispositionDelete, 
                                                   $cDraftCommentDispositionDeleteEnd, 
                                                   $cDraftCommentDispositionComment,
                                                   $cDraftCommentDispositionAttributes)]" 
                  priority="5">
        <xsl:param name="prmGetContent" as="xs:boolean" tunnel="yes" required="no" select="false()"/>
        <xsl:if test="$prmGetContent eq false()">
            <xsl:variable name="draftComment" as="element()" select="."/>
            <xsl:variable name="author" as="xs:string" select="string(@author)"/>
            <xsl:variable name="time" as="xs:string" select="string(@time)"/>
            <xsl:variable name="disposition" as="xs:string" select="string(@disposition)"/>
            <xsl:variable name="comment" as="xs:string" select="string($draftComment)"/>
            <xsl:variable name="id" as="xs:string" select="string(@id)"/>
            <xsl:variable name="outputclass" as="xs:string" select="string(@outputclass)"/>
            <xsl:choose>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsert">
                    <xsl:if test="$gpOutputChangeBars">
                        <xsl:copy-of select="ahf:addChangeBar($barInsertBegin,$id)"/>
                    </xsl:if>
                    <xsl:if test="$gpOutputChangeIcons">
                        <fo:inline>
                            <xsl:copy-of select="$atsAnnotationInsert"/>
                            <xsl:attribute name="axf:annotation-author" select="$author"/>
                            <xsl:attribute name="axf:annotation-contents" select="if (string($comment)) then $time || ' Inserted: ' || $comment else $time || ' Inserted'"/>
                        </fo:inline>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertSplit">
                    <xsl:if test="$gpOutputChangeBars">
                        <xsl:copy-of select="ahf:addChangeBar($barInsertBegin,$id)"/>
                    </xsl:if>
                    <xsl:if test="$gpOutputChangeIcons">
                        <fo:inline>
                            <xsl:copy-of select="$atsAnnotationInsert"/>
                            <xsl:attribute name="axf:annotation-author" select="$author"/>
                            <xsl:attribute name="axf:annotation-contents" select="if (string($comment)) then $time || ' Inserted (Split): ' || $comment else $time || ' Inserted (Split)'"/>
                        </fo:inline>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertEnd">
                    <xsl:if test="$gpOutputChangeBars">
                        <xsl:copy-of select="ahf:addChangeBar($barInsertEnd,$id)"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionDelete">
                    <xsl:if test="$gpOutputChangeBars">
                        <xsl:copy-of select="ahf:addChangeBar($barDeleteBegin,$id)"/>
                    </xsl:if>
                    <xsl:if test="$gpOutputChangeIcons">
                        <fo:inline>
                            <xsl:copy-of select="$atsAnnotationDelete"/>
                            <xsl:attribute name="axf:annotation-author" select="$author"/>
                            <xsl:attribute name="axf:annotation-contents" select="$time || (if (string($comment)) then ' Deleted: ' else ' Deleted') || $comment"/>
                        </fo:inline>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionDeleteEnd">
                    <xsl:if test="$gpOutputChangeBars">
                        <xsl:copy-of select="ahf:addChangeBar($barDeleteEnd,$id)"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionComment">
                    <fo:inline>
                        <xsl:copy-of select="$atsAnnotationComment"/>
                        <xsl:attribute name="axf:annotation-author" select="$author"/>
                        <xsl:attribute name="axf:annotation-contents" select="$comment => ahf:unEscapeXmlChar()"/>
                        <xsl:if test="string($outputclass)">
                            <xsl:variable name="offset" as="xs:string" select="replace($outputclass,'^(' || $cDraftCommentOffset || ')(\d+)$','$2')"/>
                            <xsl:attribute name="axf:annotation-position-horizontal" select="$gpChangeTrackingAnnotationPositionHorizontal || ' + ' || $offset || 'mm'"/>
                            <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVertical || ' - ' || $offset || 'mm'"/>
                        </xsl:if>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionCommentEnd">
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionAttributes">
                    <fo:inline>
                        <xsl:copy-of select="$atsAnnotationComment"/>
                        <xsl:attribute name="axf:annotation-contents" select="$comment"/>
                    </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>            
            </xsl:choose>
        </xsl:if>
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