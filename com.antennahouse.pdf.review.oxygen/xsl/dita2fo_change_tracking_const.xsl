<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Tracking Change Constants Stylesheet.
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
    
    <!-- PI Names -->
    <xsl:variable name="cInsertStartPiName"      as="xs:string" static="yes"  select="'oxy_insert_start'"/>
    <xsl:variable name="cInsertEndPiName"        as="xs:string" static="yes"  select="'oxy_insert_end'"/>
    <xsl:variable name="cDeletePiName"           as="xs:string" static="yes"  select="'oxy_delete'"/>
    <xsl:variable name="cCommentStartPiName"     as="xs:string" static="yes"  select="'oxy_comment_start'"/>
    <xsl:variable name="cCommentEndPiName"       as="xs:string" static="yes"  select="'oxy_comment_end'"/>
    <xsl:variable name="cAttributeChangePiName"  as="xs:string" static="yes"  select="'oxy_attributes'"/>
    <xsl:variable name="cCustomStartPiName"      as="xs:string" static="yes"  select="'oxy_custom_start'"/>
    <xsl:variable name="cCustomEndPiName"        as="xs:string" static="yes"  select="'oxy_custom_end'"/>
    <xsl:variable name="cCustomTypeHighlight"    as="xs:string" static="yes"  select="'oxy_content_highlight'"/>
    
    <!-- Auto Generated draft-comment/@disposition -->
    <xsl:variable name="cDraftCommentDispositionInsert"      as="xs:string" static="yes"  select="'__insert'"/>
    <xsl:variable name="cDraftCommentDispositionInsertSplit" as="xs:string" static="yes"  select="'__insert_split'"/>
    <xsl:variable name="cDraftCommentDispositionInsertEnd"   as="xs:string" static="yes"  select="'__insert_end'"/>
    <xsl:variable name="cDraftCommentDispositionDelete"      as="xs:string" static="yes"  select="'__delete'"/>
    <xsl:variable name="cDraftCommentDispositionDeleteEnd"   as="xs:string" static="yes"  select="'__delete_end'"/>
    <xsl:variable name="cDraftCommentDispositionComment"     as="xs:string" static="yes"  select="'__comment'"/>
    <xsl:variable name="cDraftCommentDispositionCommentEnd"  as="xs:string" static="yes"  select="'__comment_end'"/>
    <xsl:variable name="cDraftCommentDispositionAttributes"  as="xs:string" static="yes"  select="'__attributes'"/>

    <!-- Indicates Delete/Attribute information li -->
    <xsl:variable name="cOutputClassDeleteAttributesLi"     as="xs:string" static="yes" select="'__DeleteAttributesLi'"/>
    
    <!-- Comment annotation offset -->
    <xsl:variable name="cDraftCommentOffset" as="xs:string" static="yes" select="'offset-'"/>
</xsl:stylesheet>