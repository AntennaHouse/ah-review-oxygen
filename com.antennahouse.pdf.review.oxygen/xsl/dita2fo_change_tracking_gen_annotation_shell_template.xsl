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
    version="3.0">

    <!-- dita2fo_change_tracking_gen_annotation_import.xsl uses following common modules that should be implemented by import-side.
         dita2fo_constants.xsl
         dita2fo_util_dita_outputclass.xsl
         dita2fo_string_util.xsl
         dita2fo_message.xsl ($stMes800, $stMes802)
         dita2xml_error_util.xsl (warningContinue template)
         Keep in mind!
     -->
    <xsl:import  href="dita2fo_change_tracking_gen_annotation_import.xsl"/>
    <dita:extension id="com.antennahouse.pdf.review.oxygen.gen.annotation.xsl" behavior="org.dita.dost.platform.ImportXSLAction" xmlns:dita="http://dita-ot.sourceforge.net"/>
    
</xsl:stylesheet>