<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:variable name="childlang">
        <xsl:apply-templates select="/*" mode="get-first-topic-lang"/>
    </xsl:variable>

    <xsl:variable name="direction">
        <xsl:apply-templates select="." mode="get-render-direction">
            <xsl:with-param name="lang" select="$childlang"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="normalize-map">
        <data name="topicref-id" value="{generate-id()}"/>
        <xsl:next-match/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')]" mode="toc" priority="1">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>

        <xsl:variable name="navtitle">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>

        <xsl:variable name="orig-navtitle">
            <xsl:value-of select="@dita-ot:orig-navtitle"/>
        </xsl:variable>

        <xsl:variable name="title" select="if(normalize-space($navtitle)) then($navtitle) else($orig-navtitle)"/>

        <xsl:variable name="testId" select="preceding-sibling::data[@name = 'topicref-id'][1]/@value"/>
        <xsl:variable name="liLevel" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>
        <xsl:variable name="liLevelCorrected" select="if($liLevel gt 6) then('-extra') else($liLevel)"/>
        <xsl:variable name="liLevelNormalized" select="concat('level', $liLevelCorrected)"/>

        <xsl:if test="normalize-space($title)">
            <li>
                <xsl:attribute name="id" select="concat('li-', $testId)"/>

                <xsl:variable name="isActive">
                    <xsl:if test=". is $current-topicref">
                        <xsl:value-of select="'active'"/>
                    </xsl:if>
                </xsl:variable>

                <xsl:attribute name="class" select="concat($liLevelNormalized, ' ', $isActive)"/>

                <div class="toc-element-row">
                    <xsl:if test="child::*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')][not(contains(@class, ' ditavalref-d/ditavalref '))] and not(@chunk = 'to-content') and (normalize-space($direction) = 'rtl')">
                        <span id="{$testId}" class="button-toc-expand-collapse"
                              onclick="applyExpandedClass('#{$testId}')">
                        </span>
                    </xsl:if>

                    <xsl:choose>
                        <xsl:when test="normalize-space(@href)">
                            <xsl:variable name="current-href">
                                <xsl:if test="not(@scope = 'external')">
                                    <xsl:value-of select="$pathFromMaplist"/>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                        <xsl:call-template name="replace-extension">
                                            <xsl:with-param name="filename" select="@copy-to"/>
                                            <xsl:with-param name="extension" select="$OUTEXT"/>
                                        </xsl:call-template>

                                        <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                            <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
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
                            <xsl:variable name="current-href-fixed">
                                <xsl:choose>
                                    <xsl:when test="(@chunk = 'to-content') and contains($current-href, '#')">
                                        <xsl:value-of select="substring-before($current-href, '#')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$current-href"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <a>
                                <xsl:attribute name="href" select="$current-href-fixed"/>

                                <!-- Add left padding to TOC topics with levels greater than 6 (levels 1-6 are handled with CSS) -->
                                <xsl:choose>
                                    <xsl:when test="($liLevel gt 6) and not(normalize-space($direction) = 'rtl')">
                                        <xsl:attribute name="style" select="concat('padding-left: ', $liLevel + 0.5, 'em')"/>
                                    </xsl:when>
                                    <xsl:when test="($liLevel gt 6) and (normalize-space($direction) = 'rtl')">
                                        <xsl:attribute name="style" select="concat('padding-right: ', $liLevel + 0.5, 'em')"/>
                                    </xsl:when>
                                </xsl:choose>

                                <xsl:value-of select="$title"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="toc-title">
                                <xsl:value-of select="$title"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:if test="child::*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')][not(contains(@class, ' ditavalref-d/ditavalref '))] and not(@chunk = 'to-content') and not(normalize-space($direction) = 'rtl')">
                        <span id="{$testId}" class="button-toc-expand-collapse"
                              onclick="applyExpandedClass('#{$testId}')">
                        </span>
                    </xsl:if>
                </div>

                <xsl:if test="exists($children) and not(@chunk = 'to-content')">
                    <ul>
                        <xsl:apply-templates select="$children" mode="#current">
                            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>