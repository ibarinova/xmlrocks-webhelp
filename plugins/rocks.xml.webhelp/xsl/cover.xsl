<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="chapterBody">
        <body>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style"
                                 mode="add-ditaval-style"/>
            <xsl:if test="@outputclass">
                <xsl:attribute name="class" select="@outputclass"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="addAttributesToBody"/>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

            <xsl:variable name="header-content">
                <xsl:call-template name="gen-user-header"/>
            </xsl:variable>

            <xsl:if test="exists($header-content)">
                <header xsl:use-attribute-sets="banner">
                    <xsl:sequence select="$header-content"/>
                </header>
            </xsl:if>

            <xsl:call-template name="processHDR"/>
            <xsl:if test="$INDEXSHOW = 'yes'">
                <xsl:apply-templates
                        select="/*/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"/>
            </xsl:if>
            <xsl:call-template name="gen-user-sidetoc"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/title ')]">
                    <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@title"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="map" as="element()*">
                <xsl:apply-templates select="." mode="normalize-map"/>
            </xsl:variable>
            <xsl:apply-templates select="$map" mode="toc"/>
            <xsl:call-template name="gen-endnotes"/>
            <xsl:call-template name="gen-user-footer"/>
            <xsl:call-template name="processFTR"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
        </body>
    </xsl:template>
</xsl:stylesheet>