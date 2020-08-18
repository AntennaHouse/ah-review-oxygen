<?xml version='1.0' encoding="UTF-8" ?>
<!--
    ****************************************************************
    DITA to XSL-FO Stylesheet
    Module: Define DITA class related function
    Copyright © 2009-2020 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL    : http://www.antennahouse.com/
    E-mail : info@antennahouse.com
    ****************************************************************
-->
<xsl:stylesheet version="3.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>
    
    <!-- Non text child elements or other redundant elements.
         The child text nodes are redundant.
     -->
    <xsl:variable name="nonTextChildClasses" as="xs:string+" select="(
        'topic/topic',
        'topic/prolog',
        'topic/body',
        'topic/related-links',
        'topic/dl',
        'topic/dlhead',
        'topic/dlentry',
        'topic/draft-comment',(:Intended include! :)
        'topic/fig',
        'topic/figgroup',
        'topic/image',
        'topic/longdescref',
        'topic/longquoteref',
        'topic/object',
        'topic/ol',
        'topic/param',
        'topic/sl',
        'topic/ul',
        'topic/table',
        'topic/tgroup',
        'topic/tgroup',
        'topic/thead',
        'topic/tbody',
        'topic/row',
        'topic/simpletable',
        'topic/sthead',
        'topic/strow',
        'topic/link',
        'topic/linklist',
        'topic/linkpool',
        'topic/required-cleanup',
        'ui-d/menucascade',
        'hazard-d/hazardstatement'
     )"/>

    <!-- 
     function:  Return $prmElem/@class has value in $blockElementClasses
     param:     $prmElem
     return:    xs:boolean
     note:      abstract/shortdesc is assumed as block level.
                floatfig is assumed as inline level.
     -->
    <xsl:function name="ahf:nonTextChildElement" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:choose>
            <xsl:when test="$prmNode instance of element()">
                <xsl:variable name="class" as="xs:string*" select="string($prmNode/@class) => tokenize('[\s]+')"/>
                <xsl:variable name="isOneOfNonTextChildElement" as="xs:boolean" select="$class = $nonTextChildClasses"/>
                <xsl:sequence select="$isOneOfNonTextChildElement"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Block elements or wrapper elements where text child node and block elements are allowed.
         Stylesheet must generate <p> from child text node and inline elements sequence.
         hazard-d domain is specialized from 'li". But it is not mixed content element.
         Rather they are set of inline elements.
     -->
    <xsl:variable name="mixedContentElementClasses" as="xs:string+" select="
        (
        'topic/title',
        'topic/navtitle',
        'topic/searchtitle',
        'topic/shortdesc',
        'topic/abstract',
        'topic/bodydiv',
        'topic/alt',
        'topic/cite',
        'topic/dd',
        'topic/ddhd',
        'topic/dt',
        'topic/dthd',
        'topic/div',
        (: 'topic/draft-comment',Intended exclude! :)
        'topic/example',
        'topic/entry',
        'topic/example',
        'topic/fn',
        'topic/keyword',
        'topic/li',
        'topic/lines',
        'topic/lq',
        'topic/note',
        'topic/p',
        'topic/ph',
        'topic/pre',
        'topic/q',
        'topic/section',
        'topic/sectiondiv',
        'topic/sli',
        'topic/term',
        'topic/text',
        'text/tm',
        'topic/entry',
        'topic/stentry',
        'topic/linktext',
        'topic/linkinfo',
        'topic/data',
        'topic/itemgroup'
        )"/>
    
    <!-- 
     function:  Return $prmElem/@class has value in $mixedContentElementClasses
     param:     $prmElem
     return:    xs:boolean
     note:		
     -->
    <xsl:function name="ahf:isMixedContentElement" as="xs:boolean">
        <xsl:param name="prmNode" as="node()"/>
        <xsl:variable name="class" as="xs:string*" select="string($prmNode/@class) => tokenize('[\s]+')"/>
        <xsl:variable name="isOneOfMixedContentElement" as="xs:boolean" select="$class = $mixedContentElementClasses"/>
        <xsl:sequence select="$isOneOfMixedContentElement"/>
    </xsl:function>

</xsl:stylesheet>
