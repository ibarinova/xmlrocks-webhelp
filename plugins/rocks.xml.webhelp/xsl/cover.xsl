<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:param name="organization-name"/>

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="chapterBody">

        <div class="shading-container-wrapper" id="shading-wrapper"></div>
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
            <div id="back-to-top-button-container" class="max-width">
                <xsl:call-template name="insertBackToTopButton"/>
            </div>
            <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement">
                <xsl:with-param name="map" select="/*"/>
            </xsl:apply-templates>
            <xsl:call-template name="insertJavaScript"/>
            <script src="{$PATH2PROJ}lib/xml.rocks.main-page.js"></script>
        </body>
        <xsl:call-template name="addSearchPage"/>
        <xsl:call-template name="addColorSchemeCSS"/>
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
        <xsl:param name="topicrefTitle" select="''" tunnel="yes"/>
        <xsl:param name="skipShortdesc" select="false()" tunnel="yes"/>

        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="normalize-space($topicrefTitle)">
                    <xsl:value-of select="$topicrefTitle"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="get-navtitle"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="shortdesc">
            <xsl:choose>
                <xsl:when test="$skipShortdesc"/>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/shortdesc ')]" mode="text-only"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="normalize-space(@href)">
                <div class="card-container col col-sm-4">
                    <div class="card">
                        <div class="front face">
                            <div class="chapter-title">
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
                            <xsl:if test="normalize-space($shortdesc)">
                                <div class="flip-card-button-container">
                                    <button onclick="flipCard(this)" class="button-flip-card"><span class="tooltip-flip-card">See topic short description</span></button>
                                </div>
                            </xsl:if>
                        </div>
                        <xsl:if test="normalize-space($shortdesc)">
                            <div class="back face">
                                <div class="chapter-shortdesc">
                                    <xsl:value-of select="$shortdesc"/>
                                </div>
                                <div class="flip-card-button-container">
                                    <button onclick="flipCard(this)" class="button-flip-card"><span class="tooltip-flip-card">See topic title</span></button>
                                </div>
                            </div>
                        </xsl:if>
                    </div>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="descendant::*[contains(@class, ' map/topicref ')][normalize-space(@href)][1]" mode="tiles">
                    <xsl:with-param name="topicrefTitle" select="$title" tunnel="yes"/>
                    <xsl:with-param name="skipShortdesc" select="true()" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>