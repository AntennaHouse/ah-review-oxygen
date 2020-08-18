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
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs math"
    version="2.0">

    <xsl:import  href="dita2fo_change_tracking_param.xsl"/>
    <xsl:include href="dita2fo_change_tracking_const.xsl"/>
    <xsl:include href="dita2fo_change_tracking_gen_annotation.xsl"/>
    <xsl:include href="dita2fo_change_tracking_gen_annotation_style.xsl"/>
    <xsl:include href="dita2fo_change_tracking_gen_li_processing.xsl"/>
    <xsl:include href="dita2fo_change_tracking_util_string.xsl"/>
    <xsl:include href="dita2fo_fo_property.xsl"/>
    
</xsl:stylesheet>