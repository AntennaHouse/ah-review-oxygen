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
    <!-- Short cut: Output changes, commnets and highlights -->
    <xsl:param name="PRM_OUTPUT_CHANGES_AND_COMMENTS" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpOutputChangesAndComments" as="xs:boolean" select="$PRM_OUTPUT_CHANGES_AND_COMMENTS eq $cYes"/>
    
    <!-- Do processing change tracking -->
    <xsl:param name="PRM_OUTPUT_OXY_CHANGES" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpOutputOxyChanges" as="xs:boolean" select="($PRM_OUTPUT_OXY_CHANGES eq $cYes) or $gpOutputChangesAndComments"/>

    <xsl:param name="PRM_OUTPUT_OXY_COMMENTS" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpOutputOxyComments" as="xs:boolean" select="($PRM_OUTPUT_OXY_COMMENTS eq $cYes) or $gpOutputChangesAndComments"/>

    <xsl:param name="PRM_OUTPUT_OXY_HIGHLIGHTS" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpOutputOxyHilights" as="xs:boolean" select="($PRM_OUTPUT_OXY_HIGHLIGHTS eq $cYes) or $gpOutputChangesAndComments"/>
    
    <!-- Output Change Bars -->
    <xsl:param name="PRM_OUTPUT_CHANGEBARS" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpOutputChangeBars" as="xs:boolean" select="($PRM_OUTPUT_CHANGEBARS eq $cYes) and $gpOutputOxyChanges"/>
    
    <!-- Output Change Icons -->
    <xsl:param name="PRM_OUTPUT_CHANGE_ICONS" as="xs:string" required="no" select="$cYes"/>
    <xsl:variable name="gpOutputChangeIcons" as="xs:boolean" select="$PRM_OUTPUT_CHANGE_ICONS eq $cYes"/>
    
    <!-- Insert Foreground Color : Applied for each author -->
    <xsl:param name="PRM_CHANGE_TRACKING_USER_INSERT_FG_COLOR" as="xs:string" required="no" select="'royalblue orange orchid teal violet'"/>
    <xsl:variable name="gpChangeTrackingUserInsertFgColor" as="xs:string+" select="$PRM_CHANGE_TRACKING_USER_INSERT_FG_COLOR => tokenize('[\s]+')"/>
    <xsl:variable name="gpChangeTrackingUserInsertFgColorCount" as="xs:integer" select="$gpChangeTrackingUserInsertFgColor => count()"/>
    
    <!-- Delete Foreground Color : Applied for each author -->
    <xsl:param name="PRM_CHANGE_TRACKING_USER_DELETE_FG_COLOR" as="xs:string" required="no" select="$PRM_CHANGE_TRACKING_USER_INSERT_FG_COLOR"/>
    <xsl:variable name="gpChangeTrackingUserDeleteFgColor" as="xs:string+" select="$PRM_CHANGE_TRACKING_USER_DELETE_FG_COLOR => tokenize('[\s]+')"/>
    <xsl:variable name="gpChangeTrackingUserDeleteFgColorCount" as="xs:integer" select="$gpChangeTrackingUserDeleteFgColor => count()"/>
    
    <!-- Insert Text Decoration CSS Spec -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_DECORATION" as="xs:string" required="no" select="'text-decoration:underline;'"/>
    <xsl:variable name="gpChangeTrackingInsertDecoration" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_DECORATION"/>
    
    <!-- Delete Text Decoration CSS Spec -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_DECORATION" as="xs:string" required="no" select="'text-decoration:line-through no-underline;'"/>
    <xsl:variable name="gpChangeTrackingDeleteDecoration" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_DECORATION"/>
    
    <!-- Comment Background Color : Applied for each author -->
    <xsl:param name="PRM_CHANGE_TRACKING_COMMENT_BG_COLOR" as="xs:string" required="no" select="'royalblue orange orchid teal violet'"/>
    <xsl:variable name="gpChangeTrackingCommentBgColor" as="xs:string+" select="$PRM_CHANGE_TRACKING_COMMENT_BG_COLOR => tokenize('[\s]+')"/>
    <xsl:variable name="gpChangeTrackingCommentBgColorCount" as="xs:integer" select="$gpChangeTrackingCommentBgColor => count()"/>

    <xsl:param name="PRM_CHANGE_TRACKING_COMMENT_BG_COLOR_OPACITY_BASE" as="xs:string" required="no" select="'0.15'"/>
    <xsl:variable name="gpChangeTrackingCommentBgColorOpacityBase" as="xs:double" select="$PRM_CHANGE_TRACKING_COMMENT_BG_COLOR_OPACITY_BASE => xs:double()"/>

    <xsl:param name="PRM_CHANGE_TRACKING_COMMENT_BG_COLOR_OPACITY_RATIO" as="xs:string" required="no" select="'0.15'"/>
    <xsl:variable name="gpChangeTrackingCommentBgColorOpacityRatio" as="xs:double" select="$PRM_CHANGE_TRACKING_COMMENT_BG_COLOR_OPACITY_RATIO => xs:double()"/>
    
    <!-- Annotation Type  -->
    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_TYPE" as="xs:string" required="no" select="'Text'"/>
    <xsl:variable name="gpChangeTrackingAnnotationType" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_TYPE"/>

    <!-- Annotation Open -->
    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_OPEN" as="xs:string" required="no" select="'false'"/>
    <xsl:variable name="gpChangeTrackingAnnotationOpen" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_OPEN"/>
    
    <!-- Insert Annotation Color -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_ANNOTATION_COLOR" as="xs:string" required="no" select="'dodgerblue'"/>
    <xsl:variable name="gpChangeTrackingInsertAnnotationColor" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_ANNOTATION_COLOR"/>
    
    <!-- Delete Annotation Color -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_ANNOTATION_COLOR" as="xs:string" required="no" select="'hotpink'"/>
    <xsl:variable name="gpChangeTrackingDeleteAnnotationColor" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_ANNOTATION_COLOR"/>
    
    <!-- Comment Annotation Color -->
    <xsl:param name="PRM_CHANGE_TRACKING_COMMENT_ANNOTATION_COLOR" as="xs:string" required="no" select="'mediumaquamarine'"/>
    <xsl:variable name="gpChangeTrackingCommentAnnotationColor" as="xs:string" select="$PRM_CHANGE_TRACKING_COMMENT_ANNOTATION_COLOR"/>

    <!-- Attributes Annotation Color -->
    <xsl:param name="PRM_CHANGE_TRACKING_ATTRIBUTES_ANNOTATION_COLOR" as="xs:string" required="no" select="'lightsteelblue'"/>
    <xsl:variable name="gpChangeTrackingAttributesAnnotationColor" as="xs:string" select="$PRM_CHANGE_TRACKING_ATTRIBUTES_ANNOTATION_COLOR"/>
    
    <!-- Insert Annotation Icon -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_ANNOTATION_ICON" as="xs:string" required="no" select="'Insert'"/>
    <xsl:variable name="gpChangeTrackingInsertAnnotationIcon" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_ANNOTATION_ICON"/>
    
    <!-- Delete Annotation Icon -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_ANNOTATION_ICON" as="xs:string" required="no" select="'Key'"/>
    <xsl:variable name="gpChangeTrackingDeleteAnnotationIcon" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_ANNOTATION_ICON"/>
    
    <!-- Comment Annotation Icon -->
    <xsl:param name="PRM_CHANGE_TRACKING_COMMENT_ANNOTATION_ICON" as="xs:string" required="no" select="'Comment'"/>
    <xsl:variable name="gpChangeTrackingCommentAnnotationIcon" as="xs:string" select="$PRM_CHANGE_TRACKING_COMMENT_ANNOTATION_ICON"/>

    <!-- Attributes Annotation Icon -->
    <xsl:param name="PRM_CHANGE_TRACKING_ATTRIBUTES_ANNOTATION_ICON" as="xs:string" required="no" select="'Note'"/>
    <xsl:variable name="gpChangeTrackingAttributesAnnotationIcon" as="xs:string" select="$PRM_CHANGE_TRACKING_ATTRIBUTES_ANNOTATION_ICON"/>
    
    <!-- Annotation Icon Position -->
    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_POSITION_HORIZONTAL" as="xs:string" required="no" select="'0mm'"/>
    <xsl:variable name="gpChangeTrackingAnnotationPositionHorizontal" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_POSITION_HORIZONTAL"/>
    
    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_POSITION_VERTICAL" as="xs:string" required="no" select="'-5.5mm'"/>
    <xsl:variable name="gpChangeTrackingAnnotationPositionVertical" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_POSITION_VERTICAL"/>

    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_POSITION_VERTICAL_FOR_NO_TEXT_CHILD_ELEMENT" as="xs:string" required="no" select="'0mm'"/>
    <xsl:variable name="gpChangeTrackingAnnotationPositionVerticalForNoTextChildElement" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_POSITION_VERTICAL_FOR_NO_TEXT_CHILD_ELEMENT"/>
    
    <!-- Annotation Icon Size -->
    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_WIDTH" as="xs:string" required="no" select="'5mm'"/>
    <xsl:variable name="gpChangeTrackingAnnotationWidth" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_WIDTH"/>
    
    <xsl:param name="PRM_CHANGE_TRACKING_ANNOTATION_HEIGHT" as="xs:string" required="no" select="'5mm'"/>
    <xsl:variable name="gpChangeTrackingAnnotationHeight" as="xs:string" select="$PRM_CHANGE_TRACKING_ANNOTATION_HEIGHT"/>

    <!-- Insert Change Bar Color -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_COLOR" as="xs:string" required="no" select="'dodgerblue'"/>
    <xsl:variable name="gpChangeTrackingInsertChangeBarColor" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_COLOR"/>
    
    <!-- Delete Change Bar Color -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_COLOR" as="xs:string" required="no" select="'hotpink'"/>
    <xsl:variable name="gpChangeTrackingDeleteChangeBarColor" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_COLOR"/>
    
    <!-- Insert Change Bar Style -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_STYLE" as="xs:string" required="no" select="'solid'"/>
    <xsl:variable name="gpChangeTrackingInsertChangeBarStyle" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_STYLE"/>

    <!-- Delete Change Bar Style -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_STYLE" as="xs:string" required="no" select="'solid'"/>
    <xsl:variable name="gpChangeTrackingDeleteChangeBarStyle" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_STYLE"/>
    
    <!-- Insert Change Bar Width -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_WIDTH" as="xs:string" required="no" select="'1pt'"/>
    <xsl:variable name="gpChangeTrackingInsertChangeBarWidth" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_WIDTH"/>
    
    <!-- Delete Change Bar Width -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_WIDTH" as="xs:string" required="no" select="'1pt'"/>
    <xsl:variable name="gpChangeTrackingDeleteChangeBarWidth" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_WIDTH"/>

    <!-- Insert Change Bar Placement -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_PLACEMENT" as="xs:string" required="no" select="'start'"/>
    <xsl:variable name="gpChangeTrackingInsertChangeBarPlacement" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_PLACEMENT"/>
    
    <!-- Delete Change Bar Placement -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_PLACEMENT" as="xs:string" required="no" select="'start'"/>
    <xsl:variable name="gpChangeTrackingDeleteChangeBarPlacement" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_PLACEMENT"/>

    <!-- Insert Change Bar Offset -->
    <xsl:param name="PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_OFFSET" as="xs:string" required="no" select="'5mm'"/>
    <xsl:variable name="gpChangeTrackingInsertChangeBarOffset" as="xs:string" select="$PRM_CHANGE_TRACKING_INSERT_CHANGE_BAR_OFFSET"/>
    
    <!-- Delete Change Bar Offset -->
    <xsl:param name="PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_OFFSET" as="xs:string" required="no" select="'3mm'"/>
    <xsl:variable name="gpChangeTrackingDeleteChangeBarOffset" as="xs:string" select="$PRM_CHANGE_TRACKING_DELETE_CHANGE_BAR_OFFSET"/>
    
    <!-- FO property name now defined as parameter!
     -->
    <xsl:param name="PRM_FO_PROP_NAME" as="xs:string" required="no" select="'fo:prop'"/>
    <xsl:variable name="gpFoPropName" as="xs:string" select="$PRM_FO_PROP_NAME"/>

    <!-- Degug Parameter
     -->
    <xsl:param name="PRM_STEP1_DEBUG" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpStep1Debug" as="xs:boolean" select="$PRM_STEP1_DEBUG eq $cYes"/>
    <xsl:param name="PRM_STEP2_DEBUG" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpStep2Debug" as="xs:boolean" select="$PRM_STEP2_DEBUG eq $cYes"/>
    <xsl:param name="PRM_STEP3_DEBUG" as="xs:string" required="no" select="$cNo"/>
    <xsl:variable name="gpStep3Debug" as="xs:boolean" select="$PRM_STEP3_DEBUG eq $cYes"/>
    
</xsl:stylesheet>