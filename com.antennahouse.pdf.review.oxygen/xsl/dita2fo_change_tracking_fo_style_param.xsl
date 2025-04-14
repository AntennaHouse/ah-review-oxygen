<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Parameter Stylesheet.
  Copyright © 2009-2020 Antenna House, Inc. All rights reserved.
  Antenna House is a trademark of Antenna House, Inc.
  URL    : http://www.antennahouse.com/
  E-mail : info@antennahouse.com
  ****************************************************************
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">

    <!-- FO property name now defined as parameter!
         The value of PRM_FO_PROP_NAME must be the same as PDF5-ML's one.
         PRM_CHNAGE_TRACKING_FO_PROP_NAME is specific to chage-tracking processing.
     -->
    <xsl:param name="PRM_FO_PROP_NAME" as="xs:string" required="no" select="'fo:prop'"/>
    <xsl:variable name="gpFoPropName" as="xs:string" select="$PRM_FO_PROP_NAME"/>
    
    <xsl:param name="PRM_CHANGE_TRACKING_FO_PROP_NAME_INSERT" as="xs:string" required="no" select="'fo:prop-change-tracking-insert'"/>
    <xsl:variable name="gpChangeTrackingFoPropNameInsert" as="xs:string" select="$PRM_CHANGE_TRACKING_FO_PROP_NAME_INSERT"/>
    
    <xsl:param name="PRM_CHANGE_TRACKING_FO_PROP_NAME_DELETE" as="xs:string" required="no" select="'fo:prop-change-tracking-delete'"/>
    <xsl:variable name="gpChangeTrackingFoPropNameDelete" as="xs:string" select="$PRM_CHANGE_TRACKING_FO_PROP_NAME_DELETE"/>
    
    <xsl:param name="PRM_CHANGE_TRACKING_FO_PROP_NAME_COMMENT" as="xs:string" required="no" select="'fo:prop-change-tracking-comment'"/>
    <xsl:variable name="gpChangeTrackingFoPropNameComment" as="xs:string" select="$PRM_CHANGE_TRACKING_FO_PROP_NAME_COMMENT"/>
    
    <xsl:param name="PRM_CHANGE_TRACKING_FO_PROP_NAME_HIGHLIGHT" as="xs:string" required="no" select="'fo:prop-change-tracking-highlight'"/>
    <xsl:variable name="gpChangeTrackingFoPropNameHighlight" as="xs:string" select="$PRM_CHANGE_TRACKING_FO_PROP_NAME_HIGHLIGHT"/>
    
</xsl:stylesheet>