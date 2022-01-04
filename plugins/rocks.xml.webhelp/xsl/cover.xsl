<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:param name="organization-name"/>

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="chapterBody">
        <body>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style" mode="add-ditaval-style"/>

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

            <main role="main" class="container max-width main-page-container">
                <xsl:call-template name="processHDR"/>

                <xsl:if test="$INDEXSHOW = 'yes'">
                    <xsl:apply-templates select="/*/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"/>
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

                <xsl:apply-templates select="$map" mode="tiles"/>

                <xsl:call-template name="gen-endnotes"/>
                <xsl:call-template name="gen-user-footer"/>
                <xsl:call-template name="processFTR"/>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            </main>
            <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement">
                <xsl:with-param name="map" select="/*"/>
            </xsl:apply-templates>
            <xsl:call-template name="insertJavaScript"/>
        </body>
        <xsl:call-template name="addSearchPage"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="tiles">
        <xsl:param name="pathFromMaplist"/>

        <xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')]">
            <div class="row row-cols-1 row-cols-md-3 mb-3 text-left main-page-tiles">
                <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="tiles">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                </xsl:apply-templates>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')]" mode="tiles">
        <xsl:param name="pathFromMaplist"/>

        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>

        <xsl:if test="normalize-space(@href)">
            <div class="col col-sm-4">
                <div class="card mb-4 rounded-card-rocks main-page-tile">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:variable name="current-href">
                                <xsl:choose>
                                    <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                        <xsl:if test="not(@scope = 'external')">
                                            <xsl:value-of select="$pathFromMaplist"/>
                                        </xsl:if>
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
                                        <xsl:if test="not(@scope = 'external')">
                                            <xsl:value-of select="$pathFromMaplist"/>
                                        </xsl:if>
                                        <xsl:call-template name="replace-extension">
                                            <xsl:with-param name="filename" select="@href"/>
                                            <xsl:with-param name="extension" select="$OUTEXT"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="not(@scope = 'external')">
                                            <xsl:value-of select="$pathFromMaplist"/>
                                        </xsl:if>
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
                            <xsl:value-of select="$current-href-fixed"/>
                        </xsl:attribute>

                        <xsl:if test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
                            <xsl:apply-templates select="." mode="external-link"/>
                        </xsl:if>

                        <xsl:value-of select="$title"/>
                    </a>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>