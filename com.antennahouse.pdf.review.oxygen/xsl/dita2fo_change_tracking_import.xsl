<?xml version="1.0" encoding="UTF-8"?>
<!--
  ****************************************************************
  DITA to XSL-FO Stylesheet 
  Module: Process oXygen Change Tracking Stylesheet.
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
    exclude-result-prefixes="xs math ahf"
    version="3.0">
    
    <xsl:include href="dita2fo_constants.xsl"/>
    <xsl:include href="dita2fo_util_error.xsl"/>
    <xsl:include href="dita2fo_util_dita.xsl"/>
    <xsl:include href="dita2fo_util_array.xsl"/>
    <xsl:include href="dita2fo_util_string.xsl"/>
    <xsl:include href="dita2fo_util_pi.xsl"/>
    
    <xsl:include href="dita2fo_global.xsl"/>
    <xsl:include href="dita2fo_dita_class.xsl"/>
    <xsl:include href="dita2fo_change_tracking_impl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step1_ctrl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step2_ctrl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step3_ctrl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step4_ctrl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step5_ctrl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step1_impl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step2_impl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step3_impl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step4_impl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_step5_impl.xsl"/>
    <xsl:include href="dita2fo_change_tracking_const.xsl"/>
    <xsl:include href="dita2fo_change_tracking_param.xsl"/>
    <xsl:include href="dita2fo_change_tracking_util_pi.xsl"/>
    <xsl:include href="dita2fo_change_tracking_util_color.xsl"/>
    <xsl:include href="dita2fo_change_tracking_util_string.xsl"/>
    <xsl:include href="dita2fo_change_tracking_util_map.xsl"/>
    <xsl:include href="dita2fo_change_tracking_util_node.xsl"/>
    <xsl:include href="dita2fo_change_tracking_gen_annotation_style.xsl"/>
    <xsl:include href="dita2fo_generate_history_id.xsl"/>
    
</xsl:stylesheet>