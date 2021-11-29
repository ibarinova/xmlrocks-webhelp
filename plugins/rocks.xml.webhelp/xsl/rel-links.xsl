<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' topic/related-links ')]" mode="custom-breadcrumb">
        <xsl:for-each
                select="descendant-or-self::*[contains(@class, ' topic/related-links ') or contains(@class, ' topic/linkpool ')][*[@role = 'ancestor']]">

            <xsl:if test="$include.roles = 'ancestor'">
                <xsl:for-each select="*[@href][@role = 'ancestor']">
                    <xsl:apply-templates select="."/>
                    <xsl:text> &gt; </xsl:text>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="generate-custom-breadcrumbs">
        <div class="head-breadcrumb max-width">
            <span class="home">
                <a href="{concat($PATH2PROJ, 'index', $OUTEXT)}">
                    <xsl:text>Home</xsl:text>
                </a>
                <xsl:text> > </xsl:text>
            </span>

            <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]" mode="custom-breadcrumb"/>
            <xsl:value-of
                    select="descendant-or-self::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')][1]"/>
        </div>
    </xsl:template>
</xsl:stylesheet>