<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                exclude-result-prefixes="xs dita-ot">

    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="link-from">
        <xsl:if test="$include.roles = 'parent'">
            <xsl:apply-templates select="." mode="link-to-parent"/>
        </xsl:if>
        <xsl:apply-templates select="." mode="link-to-ancestor"/>
        <xsl:apply-templates select="." mode="link-to-prereqs"/>
        <xsl:if test="$include.roles = 'sibling'">
            <xsl:apply-templates select="." mode="link-to-siblings"/>
        </xsl:if>
        <xsl:if test="$include.roles = ('next', 'previous')">
            <xsl:apply-templates select="." mode="link-to-next-prev"/>
        </xsl:if>
        <xsl:if test="$include.roles = 'child'">
            <xsl:apply-templates select="." mode="link-to-children"/>
        </xsl:if>
        <xsl:if test="$include.roles = 'friend'">
            <xsl:apply-templates select="." mode="link-to-friends">
                <xsl:with-param name="linklist" select="false()" as="xs:boolean"/>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$include.roles = 'other'">
            <xsl:apply-templates select="." mode="link-to-other"/>
        </xsl:if>
    </xsl:template>


    <xsl:template
            match="*[contains(@class, ' map/topicref ')][not(ancestor::*[contains(concat(' ', @chunk, ' '), ' to-content ')])]"
            mode="link-to-ancestor" name="link-to-ancestor">
        <xsl:for-each select="ancestor::*[contains(@class, ' map/topicref ')]
                                            [@href and not(@href = '')]
                                            [not(@linking = ('none', 'sourceonly'))]
                                            [not(@processing-role = 'resource-only')]">

            <xsl:apply-templates select="." mode="link">
                <xsl:with-param name="role">ancestor</xsl:with-param>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>