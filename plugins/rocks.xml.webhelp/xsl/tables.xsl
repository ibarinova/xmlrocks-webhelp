<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" mode="title-number">
        <xsl:param name="number" as="xs:integer"/>
        <xsl:if test="not(normalize-space($table-numbering) = ('no', 'false'))">
            <xsl:sequence select="concat(dita-ot:get-variable(., 'Table'), ' ', $number, '. ')"/>
        </xsl:if>
    </xsl:template>

    <xsl:template mode="title-number" priority="1" match="*[contains(@class, ' topic/table ')][dita-ot:get-current-language(.) = ('hu', 'hu-hu')]/*[contains(@class, ' topic/title ')]">
        <xsl:param name="number" as="xs:integer"/>

        <xsl:choose>
            <xsl:when test="not(normalize-space($table-numbering) = ('no', 'false'))">
                <xsl:sequence select="concat($number, '. ', dita-ot:get-variable(., 'Table'), ' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="concat(dita-ot:get-variable(., 'Table'), ' ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>