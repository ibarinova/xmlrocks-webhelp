<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]"
                  mode="toc" priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()"
                   as="element()*"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>

        <xsl:variable name="testId" select="count(preceding::*[contains(@class, ' map/topicref ')]) + count(ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>

        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <li>
                    <!-- Added @id to li's to highlight current topic in TOC when page is updated with jQuery -->
                    <xsl:attribute name="id" select="concat('li-', $testId)"/>
                    <xsl:if test=". is $current-topicref">
                        <xsl:attribute name="class">active</xsl:attribute>
                    </xsl:if>
                    <!-- Added span with + symbol to expand child topics in TOC  -->
                    <xsl:if test="child::*[contains(@class, ' map/topicref ')][not(contains(@class, ' ditavalref-d/ditavalref '))]">
                        <span id="{$testId}" class="expand-collapse-button" onclick="applyExpandedClass('#{$testId}')">+ </span>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="normalize-space(@href)">
                            <!-- href value is stored in current-href variable to pass it in getDynamicTopicData function -->
                            <xsl:variable name="current-href">
                                <xsl:if test="not(@scope = 'external')">
                                    <xsl:value-of select="$pathFromMaplist"/>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and
                                    (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                        <xsl:call-template name="replace-extension">
                                            <xsl:with-param name="filename" select="@copy-to"/>
                                            <xsl:with-param name="extension" select="$OUTEXT"/>
                                        </xsl:call-template>
                                        <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                            <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when
                                            test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                        <xsl:call-template name="replace-extension">
                                            <xsl:with-param name="filename" select="@href"/>
                                            <xsl:with-param name="extension" select="$OUTEXT"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@href"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <a>
                                <!-- Added @onclick which runs function getDynamicTopicData() -->
                                <!-- to update parts of web page without reloading the whole page -->
                                <xsl:attribute name="href" select="$current-href"/>
                                <xsl:attribute name="onclick" select="concat('getDynamicTopicData(''', $current-href, ''')')"/>
                                <xsl:value-of select="$title"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span>
                                <xsl:value-of select="$title"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="exists($children)">
                        <ul>
                            <xsl:apply-templates select="$children" mode="#current">
                                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                            </xsl:apply-templates>
                        </ul>
                    </xsl:if>
                </li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>