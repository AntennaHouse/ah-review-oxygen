<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Draft-comment
          Utility Stylesheet.
  Copyright © 2009-2025 Antenna House, Inc. All rights reserved.
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
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- 
     function:  Judge $prmElem is draft-comment for change tracking
     param:     prmElem
     return:    xs:boolean
     note:      
     -->
    <xsl:function name="ahf:isChangeTrackingDraftComment" as="xs:boolean">
        <xsl:param name="prmElem" as="node()"/>
        <xsl:sequence select="$prmElem/self::element()[@class => contains-token('topic/draft-comment')]
                                                      [string(@disposition) = ($cDraftCommentDispositionInsert, 
                                                        $cDraftCommentDispositionInsertSurround, 
                                                        $cDraftCommentDispositionInsertSplit, 
                                                        $cDraftCommentDispositionInsertEnd, 
                                                        $cDraftCommentDispositionInsertSurroundEnd, 
                                                        $cDraftCommentDispositionInsertSplitEnd, 
                                                        $cDraftCommentDispositionDelete, 
                                                        $cDraftCommentDispositionDeleteEnd, 
                                                        $cDraftCommentDispositionComment,
                                                        $cDraftCommentDispositionCommentEnd,
                                                        $cDraftCommentDispositionAttributes)] =>exists()"
        />
    </xsl:function>

</xsl:stylesheet>