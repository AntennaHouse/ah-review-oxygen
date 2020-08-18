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

    <!-- Insert annotation -->
    <xsl:variable name="atsAnnotationInsert" as="attribute()+">
        <xsl:attribute name="axf:annotation-title">Insert</xsl:attribute>
        <xsl:attribute name="axf:annotation-type" select="$gpChangeTrackingAnnotationType"/>
        <xsl:attribute name="axf:annotation-color" select="$gpChangeTrackingInsertAnnotationColor"/>
        <xsl:attribute name="axf:annotation-open" select="$gpChangeTrackingAnnotationOpen"/>
        <xsl:attribute name="axf:annotation-icon-name" select="$gpChangeTrackingInsertAnnotationIcon"/>
        <xsl:attribute name="axf:annotation-position-horizontal" select="$gpChangeTrackingAnnotationPositionHorizontal"/>
        <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVertical"/>
        <xsl:attribute name="axf:annotation-width" select="$gpChangeTrackingAnnotationWidth"/>
        <xsl:attribute name="axf:annotation-height" select="$gpChangeTrackingAnnotationHeight"/>
        <xsl:attribute name="keep-with-next.within-line" select="'always'"/>
    </xsl:variable>
    
    <!-- Delete annotation -->
    <xsl:variable name="atsAnnotationDelete" as="attribute()+">
        <xsl:attribute name="axf:annotation-title">Delete</xsl:attribute>
        <xsl:attribute name="axf:annotation-type" select="$gpChangeTrackingAnnotationType"/>
        <xsl:attribute name="axf:annotation-color" select="$gpChangeTrackingDeleteAnnotationColor"/>
        <xsl:attribute name="axf:annotation-open" select="$gpChangeTrackingAnnotationOpen"/>
        <xsl:attribute name="axf:annotation-icon-name" select="$gpChangeTrackingDeleteAnnotationIcon"/>
        <xsl:attribute name="axf:annotation-position-horizontal" select="$gpChangeTrackingAnnotationPositionHorizontal"/>
        <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVertical"/>
        <xsl:attribute name="axf:annotation-width" select="$gpChangeTrackingAnnotationWidth"/>
        <xsl:attribute name="axf:annotation-height" select="$gpChangeTrackingAnnotationHeight"/>
        <xsl:attribute name="keep-with-next.within-line" select="'always'"/>
    </xsl:variable>

    <!-- Comment annotation -->
    <xsl:variable name="atsAnnotationComment" as="attribute()+">
        <xsl:attribute name="axf:annotation-title">Comment</xsl:attribute>
        <xsl:attribute name="axf:annotation-type" select="$gpChangeTrackingAnnotationType"/>
        <xsl:attribute name="axf:annotation-color" select="$gpChangeTrackingCommentAnnotationColor"/>
        <xsl:attribute name="axf:annotation-open" select="$gpChangeTrackingAnnotationOpen"/>
        <xsl:attribute name="axf:annotation-icon-name" select="$gpChangeTrackingCommentAnnotationIcon"/>
        <xsl:attribute name="axf:annotation-position-horizontal" select="$gpChangeTrackingAnnotationPositionHorizontal"/>
        <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVertical"/>
        <xsl:attribute name="axf:annotation-width" select="$gpChangeTrackingAnnotationWidth"/>
        <xsl:attribute name="axf:annotation-height" select="$gpChangeTrackingAnnotationHeight"/>
        <xsl:attribute name="keep-with-next.within-line" select="'always'"/>
    </xsl:variable>

    <!-- Attributes annotation -->
    <xsl:variable name="atsAnnotationAttributes" as="attribute()+">
        <xsl:attribute name="axf:annotation-title">Attributes</xsl:attribute>
        <xsl:attribute name="axf:annotation-type" select="$gpChangeTrackingAnnotationType"/>
        <xsl:attribute name="axf:annotation-color" select="$gpChangeTrackingAttributesAnnotationColor"/>
        <xsl:attribute name="axf:annotation-open" select="$gpChangeTrackingAnnotationOpen"/>
        <xsl:attribute name="axf:annotation-icon-name" select="$gpChangeTrackingAttributesAnnotationIcon"/>
        <xsl:attribute name="axf:annotation-position-horizontal" select="$gpChangeTrackingAnnotationPositionHorizontal"/>
        <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVertical"/>
        <xsl:attribute name="axf:annotation-width" select="$gpChangeTrackingAnnotationWidth"/>
        <xsl:attribute name="axf:annotation-height" select="$gpChangeTrackingAnnotationHeight"/>
    </xsl:variable>

    <xsl:variable name="atsAnnotationAttributesForNoTextChildElement" as="attribute()+">
        <xsl:copy-of select="$atsAnnotationAttributes"/>
        <xsl:attribute name="axf:annotation-position-vertical" select="$gpChangeTrackingAnnotationPositionVerticalForNoTextChildElement"/>
    </xsl:variable>

    <!-- Change bar for insert -->
    <xsl:variable name="atsChangeBarInsert" as="attribute()+">
        <xsl:attribute name="change-bar-style" select="$gpChangeTrackingInsertChangeBarStyle"/>
        <xsl:attribute name="change-bar-color" select="$gpChangeTrackingInsertChangeBarColor"/>
        <xsl:attribute name="change-bar-width" select="$gpChangeTrackingInsertChangeBarWidth"/>
        <xsl:attribute name="change-bar-placement" select="$gpChangeTrackingInsertChangeBarPlacement"/>
        <xsl:attribute name="change-bar-offset" select="$gpChangeTrackingInsertChangeBarOffset"/>
    </xsl:variable>
    
    <!-- Change bar for delete -->
    <xsl:variable name="atsChangeBarDelete" as="attribute()+">
        <xsl:attribute name="change-bar-style" select="$gpChangeTrackingDeleteChangeBarStyle"/>
        <xsl:attribute name="change-bar-color" select="$gpChangeTrackingDeleteChangeBarColor"/>
        <xsl:attribute name="change-bar-width" select="$gpChangeTrackingDeleteChangeBarWidth"/>
        <xsl:attribute name="change-bar-placement" select="$gpChangeTrackingDeleteChangeBarPlacement"/>
        <xsl:attribute name="change-bar-offset" select="$gpChangeTrackingDeleteChangeBarOffset"/>
    </xsl:variable>
    
</xsl:stylesheet>