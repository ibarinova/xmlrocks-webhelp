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
                                    <xsl:text>Home</xsl:text>
                                </a>
                                <xsl:text> </xsl:text>
                                <pre class="breadcrumbs-separator">&gt;</pre>
                                <xsl:text> </xsl:text>
                            </span>

                            <xsl:value-of select="'Search'"/>
                        </div>
                    </div>

                    <div class="search-page-results-container max-width">
                        <span id="search-results-text">Search results</span>
                    </div>

                    <div class="search-input-container-wrapper">
                        <div class="search-input-container max-width">
                            <input class="form-control search search-input" type="search" placeholder="Search" aria-label="Search"/>
                        </div>
                    </div>

                    <main role="main" class="container main-search-page max-width">
                        <div id="main-wrapper">
                            <div id="search-results">0 document(s) found for
                                <b>
                                    <p id="keyword-text"/>
                                </b>
                            </div>
                            <div id="empty-keyword">Search keyword cannot be empty</div>
                        </div>
                    </main>

                    <div id="back-to-top-button-container" class="max-width">
                        <xsl:call-template name="insertBackToTopButton"/>
                    </div>

                    <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement">
                        <xsl:with-param name="map" select="/*"/>
                    </xsl:apply-templates>

                    <xsl:call-template name="insertJavaScript"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>