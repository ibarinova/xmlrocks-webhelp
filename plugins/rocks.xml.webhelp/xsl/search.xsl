<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template name="addSearchPage">
        <xsl:result-document href="search.html">
            <html>
                <xsl:call-template name="setTopicLanguage"/>
                <xsl:call-template name="chapterHead"/>

                <body id="search-page">
                    <div class="shading-container-wrapper" id="shading-wrapper"></div>
                    <xsl:variable name="header-content">
                        <xsl:call-template name="gen-user-header"/>
                    </xsl:variable>

                    <xsl:if test="exists($header-content)">
                        <header xsl:use-attribute-sets="banner">
                            <xsl:sequence select="$header-content"/>
                        </header>
                    </xsl:if>

                    <div class="breadcrumb-container max-width">
                        <div class="head-breadcrumb max-width">
                            <span class="home">
                                <a href="{concat($PATH2PROJ, 'index', $OUTEXT)}">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Home'"/>
                                    </xsl:call-template>
                                </a>
                                <xsl:text> </xsl:text>
                                <pre class="breadcrumbs-separator">&gt;</pre>
                                <xsl:text> </xsl:text>
                            </span>

                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Search'"/>
                            </xsl:call-template>
                        </div>
                    </div>

                    <div class="search-page-results-container max-width">
                        <span id="search-results-text">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Search results'"/>
                            </xsl:call-template>
                        </span>
                    </div>

                    <div class="search-input-container-wrapper">
                        <div class="search-input-container max-width">
                            <input class="form-control search search-input" id="body-search-input" type="search">
                                <xsl:attribute name="placeholder">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Search'"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="arial-label">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Search'"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </input>
                            <button id="body-search-cancel-button"></button>
                            <div class="body-search-buttons-separator"></div>
                            <button id="body-search-button"></button>
                        </div>
                    </div>

                    <main role="main" class="container main-search-page max-width">
                        <div id="search-main-wrapper">
                            <div id="empty-keyword">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'Search keyword cannot be empty'"/>
                                </xsl:call-template>
                            </div>

                            <div id="search-results-info">
                                <span id="search-documents-number"></span>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="' document(s) found for '"/>
                                </xsl:call-template>
                                <b>
                                    <span id="keyword-text"/>
                                </b>
                            </div>
                        </div>
                        <div id="wrapper">
                            <section>
                                <div class="data-container"></div>
                                <div id="pagination-demo1"></div>
                                <div class="data-container"></div>
                                <div id="pagination-demo2"></div>
                            </section>
                        </div>
                    </main>

                    <div id="back-to-top-button-container" class="max-width">
                        <xsl:call-template name="insertBackToTopButton"/>
                    </div>

                    <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement">
                        <xsl:with-param name="map" select="/*"/>
                    </xsl:apply-templates>

                    <xsl:call-template name="insertJavaScript"/>
                    <script src="https://unpkg.com/lunr/lunr.js"></script>
                    <script src="{$PATH2PROJ}lib/pagination.min.js"></script>
                    <script src="{$PATH2PROJ}lib/xml.rocks.search-topics.js"></script>
                    <script src="{$PATH2PROJ}lib/xml.rocks.search-page.js"></script>
                </body>
            </html>
        </xsl:result-document>

        <xsl:result-document href="lib/xml.rocks.search-topics.js" method="text">
var documents = [
            <xsl:call-template name="searchResultTopics">
                <xsl:with-param name="map" select="/*"/>
            </xsl:call-template>
{}]
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="searchResultTopics">
        <xsl:param name="map"/>
        <xsl:param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
        <xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>

        <xsl:variable name="workFilePath" select="document-uri(/)"/>
        <xsl:variable name="workFilePathNormalized" select="translate($workFilePath, '\', '/')"/>
        <xsl:variable name="workFileName" select="tokenize($workFilePathNormalized, '/')[last()]"/>
        <xsl:variable name="workDir" select="substring-before($workFilePathNormalized, $workFileName)"/>

        <xsl:for-each select="$map/descendant::*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')]">
            <xsl:variable name="navtitle">
                <xsl:apply-templates select="." mode="get-navtitle"/>
            </xsl:variable>

            <xsl:variable name="orig-navtitle">
                <xsl:value-of select="@dita-ot:orig-navtitle"/>
            </xsl:variable>

            <xsl:variable name="title" select="if(normalize-space($navtitle)) then($navtitle) else($orig-navtitle)"/>

            <xsl:if test="normalize-space($title)">
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

                <xsl:variable name="topicPath" select="concat($workDir, @href)"/>

                <xsl:variable name="topicBody">
                    <xsl:if test="doc-available($topicPath)">
                        <xsl:value-of select="document($topicPath)"/>
                    </xsl:if>
                </xsl:variable>
{
"name": "<xsl:value-of select="normalize-space(translate($title, '&#xA;&#xD;&gt;&lt;&quot;', '    '))"/>",
"href": "<xsl:value-of select="$current-href-fixed"/>",
"text": "<xsl:value-of select="normalize-space(replace(translate($topicBody, '&#xA;&#xD;&gt;&lt;&quot;', '    '), '\\', '\\\\'))"/>"
},
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>