<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xr="https://xml.rocks/"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:param name="header-bg-color"/>
    <xsl:param name="accent-bg-color"/>
    <xsl:param name="accent-color"/>
    <xsl:param name="footer-bg-color"/>
    <xsl:param name="main-hex-color"/>

    <xsl:template name="addColorSchemeCSS">
        <xsl:variable name="temp-header-bg-color">
            <xsl:call-template name="generateHeaderColor">
                <xsl:with-param name="hex-code" select="$main-hex-color"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="header-bg-color-value">
            <xsl:choose>
                <xsl:when test="normalize-space($header-bg-color)">
                    <xsl:value-of select="$header-bg-color"/>
                </xsl:when>
                <xsl:when test="normalize-space($temp-header-bg-color)">
                    <xsl:value-of select="$temp-header-bg-color"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'#0c213a'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="accent-bg-color-value">
            <xsl:choose>
                <xsl:when test="normalize-space($accent-bg-color)">
                    <xsl:value-of select="$accent-bg-color"/>
                </xsl:when>
                <xsl:when test="normalize-space($main-hex-color)">
                    <xsl:value-of select="$main-hex-color"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'#2c74eb'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="accent-color-value">
            <xsl:choose>
                <xsl:when test="normalize-space($accent-color)">
                    <xsl:value-of select="$accent-color"/>
                </xsl:when>
                <xsl:when test="normalize-space($main-hex-color)">
                    <xsl:value-of select="$main-hex-color"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'#2c74eb'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="footer-bg-color-value" select="if(normalize-space($footer-bg-color)) then($footer-bg-color) else('#000000')"/>

        <xsl:result-document href="{$PATH2PROJ}{$css-path-normalized}color-scheme.css" method="text">
:root {
    --header-bg-color: <xsl:value-of select="$header-bg-color-value"/>;
    --accent-bg-color: <xsl:value-of select="$accent-bg-color-value"/>;
    --accent-color: <xsl:value-of select="$accent-color-value"/>;
    --footer-bg-color: <xsl:value-of select="$footer-bg-color-value"/>;
}
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="generateHeaderColor">
        <xsl:param name="hex-code"/>
        <xsl:variable name="clean-hex" select="upper-case(substring-after(normalize-space($hex-code), '#'))"/>

        <xsl:choose>
            <xsl:when test="string-length($clean-hex) = 6">
                <xsl:variable name="red" select="substring($clean-hex, 1, 2)"/>
                <xsl:variable name="red-dec" select="xr:hexToDec($red)"/>

                <xsl:variable name="green" select="substring($clean-hex, 3, 2)"/>
                <xsl:variable name="green-dec" select="xr:hexToDec($green)"/>

                <xsl:variable name="blue" select="substring($clean-hex, 5, 2)"/>
                <xsl:variable name="blue-dec" select="xr:hexToDec($blue)"/>

                <xsl:variable name="header-bg-red-hex" select="string-join(xr:decToHex(round(number($red-dec) div 3.5)), '')"/>
                <xsl:variable name="header-bg-green-hex" select="string-join(xr:decToHex(round(number($green-dec) div 3.5)), '')"/>
                <xsl:variable name="header-bg-blue-hex" select="string-join(xr:decToHex(round(number($blue-dec) div 3.5)), '')"/>

                <xsl:variable name="header-bg-red-hex-normalized" select="if(string-length($header-bg-red-hex) = 1)
                                                                            then(concat('0', $header-bg-red-hex))
                                                                            else($header-bg-red-hex)"/>
                <xsl:variable name="header-bg-green-hex-normalized" select="if(string-length($header-bg-green-hex) = 1)
                                                                            then(concat('0', $header-bg-green-hex))
                                                                            else($header-bg-green-hex)"/>
                <xsl:variable name="header-bg-blue-hex-normalized" select="if(string-length($header-bg-blue-hex) = 1)
                                                                            then(concat('0', $header-bg-blue-hex))
                                                                            else($header-bg-blue-hex)"/>

                <xsl:value-of select="concat('#', $header-bg-red-hex-normalized, $header-bg-green-hex-normalized, $header-bg-blue-hex-normalized)"/>
            </xsl:when>
            <xsl:when test="string-length($clean-hex) = 3">
                <xsl:variable name="red" select="substring($clean-hex, 1, 1)"/>
                <xsl:variable name="red-dec" select="xr:hexToDec(concat($red, $red))"/>

                <xsl:variable name="green" select="substring($clean-hex, 2, 1)"/>
                <xsl:variable name="green-dec" select="xr:hexToDec(concat($green, $green))"/>

                <xsl:variable name="blue" select="substring($clean-hex, 3, 1)"/>
                <xsl:variable name="blue-dec" select="xr:hexToDec(concat($blue, $blue))"/>

                <xsl:variable name="header-bg-red-hex" select="string-join(xr:decToHex(round(number($red-dec) div 3.5)), '')"/>
                <xsl:variable name="header-bg-green-hex" select="string-join(xr:decToHex(round(number($green-dec) div 3.5)), '')"/>
                <xsl:variable name="header-bg-blue-hex" select="string-join(xr:decToHex(round(number($blue-dec) div 3.5)), '')"/>

                <xsl:variable name="header-bg-red-hex-normalized" select="if(string-length($header-bg-red-hex) = 1)
                                                                            then(concat('0', $header-bg-red-hex))
                                                                            else($header-bg-red-hex)"/>
                <xsl:variable name="header-bg-green-hex-normalized" select="if(string-length($header-bg-green-hex) = 1)
                                                                            then(concat('0', $header-bg-green-hex))
                                                                            else($header-bg-green-hex)"/>
                <xsl:variable name="header-bg-blue-hex-normalized" select="if(string-length($header-bg-blue-hex) = 1)
                                                                            then(concat('0', $header-bg-blue-hex))
                                                                            else($header-bg-blue-hex)"/>

                <xsl:value-of select="concat('#', $header-bg-red-hex-normalized, $header-bg-green-hex-normalized, $header-bg-blue-hex-normalized)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Error: Parameter 'main-hex-color' has invalid value.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="xr:hexToDec">
        <xsl:param name="str"/>
        <xsl:variable name="hexDigits" select="'0123456789ABCDEF'"/>
        <xsl:variable name="len" select="string-length($str)"/>

        <xsl:value-of select="if (string-length($str) &lt; 1) then 0
                                else xr:hexToDec(substring($str, 1, $len - 1)) * 16 + string-length(substring-before($hexDigits, substring($str, $len)))"/>
    </xsl:function>

    <xsl:function name="xr:decToHex">
        <xsl:param name="decimalNumber"/>
        <xsl:variable name="hexDigits" select="'0123456789ABCDEF'"/>

        <xsl:if test="$decimalNumber &gt;= 16">
            <xsl:value-of select="xr:decToHex(floor($decimalNumber div 16))"/>
        </xsl:if>

        <xsl:value-of select="substring($hexDigits, ($decimalNumber mod 16) + 1, 1)"/>
    </xsl:function>
</xsl:stylesheet>