<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'0 document(s) found for'"/>
                                </xsl:call-template>
                                <b>
                                    <span id="keyword-text"/>
                                </b>
                            </div>
                            <!-- FIXME Search results are temporary hardcoded -->
                            <div id="search-results">
                                <div class="search-result-block">
                                    <p class="search-result-title"><a href="index.html">Dummy search result block</a></p>
                                    <p class="search-result-body">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
                                </div>
                                <div class="search-result-block">
                                    <p class="search-result-title"><a href="index.html">Dummy search result block2</a></p>
                                    <p class="search-result-body">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
                                </div>
                                <div class="search-result-block">
                                    <p class="search-result-title"><a href="index.html">Dummy search result block3</a></p>
                                    <p class="search-result-body">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
                                </div>
                            </div>
                        </div>
                    </main>

                    <div id="back-to-top-button-container" class="max-width">
                        <xsl:call-template name="insertBackToTopButton"/>
                    </div>

                    <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement">
                        <xsl:with-param name="map" select="/*"/>
                    </xsl:apply-templates>

                    <xsl:call-template name="insertJavaScript"/>
                    <script src="{$PATH2PROJ}lib/xml.rocks.search-page.js"></script>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>