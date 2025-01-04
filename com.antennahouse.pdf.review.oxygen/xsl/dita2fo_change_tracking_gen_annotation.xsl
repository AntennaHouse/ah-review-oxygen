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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    version="3.0">

    <!-- 
     function:  Draft-comment Template For Change-Tracking
     param:     None
     return:    
     note:		
     -->
    <xsl:template match="*[contains(@class,' topic/draft-comment ')]
                          [string(@disposition) = ($cDraftCommentDispositionInsert, 
                           $cDraftCommentDispositionInsertSurround, 
                           $cDraftCommentDispositionInsertSplit, 
                           $cDraftCommentDispositionInsertEnd, 
                           $cDraftCommentDispositionInsertSurroundEnd, 
                           $cDraftCommentDispositionInsertSplitEnd, 
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
            <xsl:variable name="comment" as="xs:string" select="string(@comment)"/>
            <xsl:variable name="id" as="xs:string" select="string(@id)"/>
            <xsl:variable name="outputclass" as="xs:string" select="string(@outputclass)"/>
            <xsl:choose>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsert">
                    <xsl:call-template name="draftCommentInsert">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertSurround">
                    <xsl:call-template name="draftCommentInsertSurround">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertSplit">
                    <xsl:call-template name="draftCommentInsertSplit">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertEnd">
                    <xsl:call-template name="draftCommentInsertEnd">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertSurroundEnd">
                    <xsl:call-template name="draftCommentInsertSurroundEnd">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionInsertSplitEnd">
                    <xsl:call-template name="draftCommentInsertSplitEnd">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionDelete">
                    <xsl:call-template name="draftCommentDelete">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionDeleteEnd">
                    <xsl:call-template name="draftCommentDeleteEnd">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionComment">
                    <xsl:call-template name="draftCommentComment">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionCommentEnd">
                    <xsl:call-template name="draftCommentCommentEnd">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$disposition eq $cDraftCommentDispositionAttributes">
                    <xsl:call-template name="draftCommentAttribute">
                        <xsl:with-param name="prmAuthor" select="$author"/>
                        <xsl:with-param name="prmTime" select="$time"/>
                        <xsl:with-param name="prmComment" select="$comment"/>
                        <xsl:with-param name="prmId" select="$id"/>
                        <xsl:with-param name="prmOutputClass" select="$outputclass"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>            
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>