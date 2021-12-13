<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:topicpull="http://dita-ot.sourceforge.net/ns/200704/topicpull"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' topic/fig ')][not(*[contains(@class,' topic/title ')])][not(@spectitle)]" mode="topicpull:resolvelinktext">
        <xsl:variable name="fig-count-actual">
            <xsl:apply-templates select="*[contains(@class,' topic/title ')][1]" mode="topicpull:fignumber"/>
        </xsl:variable>
        <xsl:apply-templates select="." mode="topicpull:figure-linktext">
            <xsl:with-param name="figtext">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Figure'"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="figcount" select="''"/>
            <xsl:with-param name="figtitle" select="''">
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="topicpull:figure-linktext">
        <xsl:param name="figtext"/>
        <xsl:param name="figcount"/>
        <xsl:param name="figtitle"/>
        <xsl:choose>
            <xsl:when test="$FIGURELINK='TITLE'">
                <xsl:apply-templates select="$figtitle" mode="text-only"/>
            </xsl:when>
            <xsl:when test="($figtitle = '') and ($figcount = '')">
                <xsl:value-of select="$figtext"/>
            </xsl:when>
            <xsl:otherwise> <!-- Default: FIGURELINK='NUMBER' -->
                <xsl:value-of select="$figtext"/>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'figure-number-separator'"/>
                </xsl:call-template>
                <xsl:value-of select="$figcount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/table ')][not(*[contains(@class,' topic/title ')])][not(@spectitle)]" mode="topicpull:resolvelinktext">
        <xsl:variable name="tbl-count-actual">
            <xsl:apply-templates select="*[contains(@class,' topic/title ')][1]" mode="topicpull:tblnumber"/>
        </xsl:variable>
        <xsl:apply-templates select="." mode="topicpull:table-linktext">
            <xsl:with-param name="tbltext"><xsl:call-template name="getVariable"><xsl:with-param name="id" select="'Table'"/></xsl:call-template></xsl:with-param>
            <xsl:with-param name="tblcount" select="''"/>
            <xsl:with-param name="tbltitle" select="''"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="topicpull:table-linktext">
        <xsl:param name="tbltext"/>
        <xsl:param name="tblcount"/>
        <xsl:param name="tbltitle"/> <!-- Currently unused, but may be picked up by an override -->
        <xsl:choose>
            <xsl:when test="$TABLELINK='TITLE'">
                <xsl:apply-templates select="$tbltitle" mode="text-only"/>
            </xsl:when>
            <xsl:when test="($tbltitle = '') and ($tblcount = '')">
                <xsl:value-of select="$tbltext"/>
            </xsl:when>
            <xsl:otherwise> <!-- Default: TABLELINK='NUMBER' -->
                <xsl:value-of select="$tbltext"/>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'figure-number-separator'"/>
                </xsl:call-template>
                <xsl:value-of select="$tblcount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>