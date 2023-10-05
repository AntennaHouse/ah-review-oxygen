<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Tracking Change Merged-Middle File Stylesheet.
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
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math"
    version="2.0">
    
    <xsl:import href="dita2fo_change_tracking_param.xsl"/>
    <xsl:include href="dita2fo_change_tracking_const.xsl"/>

    <!-- 
     function:    draft-comment template
     param:       None
     return:      Copy if it is for tracking-change annotation
     note:        
     -->
    <xsl:template match="*[contains(@class,' topic/draft-comment ')]
                          [string(@disposition) = ($cDraftCommentDispositionInsert,
                                                    $cDraftCommentDispositionInsertSplit,
                                                    $cDraftCommentDispositionInsertEnd,
                                                    $cDraftCommentDispositionDelete,
                                                    $cDraftCommentDispositionDeleteEnd,
                                                    $cDraftCommentDispositionAttributes)]
                          [$gpOutputOxyChanges]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/draft-comment ')]
                          [string(@disposition) = ($cDraftCommentDispositionComment, 
                                                    $cDraftCommentDispositionCommentEnd)]
                            [$gpOutputOxyComments]">
                            <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    

</xsl:stylesheet>