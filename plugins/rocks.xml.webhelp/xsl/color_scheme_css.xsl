<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:param name="header-bg-color"/>
    <xsl:param name="accent-bg-color"/>
    <xsl:param name="accent-color"/>
    <xsl:param name="footer-bg-color"/>

    <xsl:variable name="header-bg-color-value" select="if(not(normalize-space($header-bg-color) = ('', '${header-bg-color}')))
                                                        then($header-bg-color) else('#0c213a')"/>
    <xsl:variable name="accent-bg-color-value" select="if(not(normalize-space($accent-bg-color) = ('', '${accent-bg-color}')))
                                                        then($accent-bg-color) else('#2c74eb')"/>
    <xsl:variable name="accent-color-value" select="if(not(normalize-space($accent-color) = ('', '${accent-color}')))
                                                    then($accent-color) else('#2c74eb')"/>
    <xsl:variable name="footer-bg-color-value" select="if(not(normalize-space($footer-bg-color) = ('', '${footer-bg-color}')))
                                                        then($footer-bg-color) else('#000000')"/>

    <xsl:template name="addColorSchemeCSS">
        <xsl:result-document href="{$PATH2PROJ}{$css-path-normalized}color-scheme.css" method="text">
:root {
    --header-bg-color: <xsl:value-of select="$header-bg-color-value"/>;
    --accent-bg-color: <xsl:value-of select="$accent-bg-color-value"/>;
    --accent-color: <xsl:value-of select="$accent-color-value"/>;
    --footer-bg-color: <xsl:value-of select="$footer-bg-color-value"/>;
}
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>