<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">
    <!--Param & varaible for creating breadcrumbs-->
    <xsl:param name="include.rellinks"
               select="'#default parent child sibling friend next previous cousin ancestor descendant sample external other'"
               as="xs:string"/>
    <xsl:variable name="include.roles" select="tokenize(normalize-space($include.rellinks), '\s+')" as="xs:string*"/>

    <xsl:attribute-set name="banner">
        <xsl:attribute name="class">rocks-header sticky-top accent-background-color</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template match="*" mode="chapterHead">
        <head>
            <xsl:call-template name="generateCharset"/>
            <xsl:apply-templates select="." mode="generateDefaultCopyright"/>
            <xsl:call-template name="generateDefaultMeta"/>
            <xsl:apply-templates select="." mode="getMeta"/>
            <xsl:call-template name="copyright"/>
            <xsl:call-template name="generateCssLinks"/>
            <xsl:call-template name="addFavicon"/>
            <xsl:call-template name="generateChapterTitle"/>
            <xsl:call-template name="gen-user-head" />
            <xsl:call-template name="gen-user-scripts" />
            <xsl:call-template name="gen-user-styles" />
            <xsl:call-template name="processHDF"/>
        </head>
    </xsl:template>

    <xsl:template name="generateCssLinks">
        <xsl:variable name="childlang" as="xs:string">
            <xsl:variable name="lang">
                <xsl:choose>
                    <xsl:when test="self::dita[not(@xml:lang)]">
                        <xsl:for-each select="*[1]">
                            <xsl:call-template name="getLowerCaseLang"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getLowerCaseLang"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:sequence select="($lang, $DEFAULTLANG)[normalize-space(.)][1]"/>
        </xsl:variable>
        <xsl:variable name="direction">
            <xsl:apply-templates select="." mode="get-render-direction">
                <xsl:with-param name="lang" select="$childlang"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="urltest" as="xs:boolean">
            <xsl:call-template name="url-string">
                <xsl:with-param name="urltext" select="concat($CSSPATH, $CSS)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$direction = 'rtl' and $urltest ">
                <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$bidi-dita-css}"/>
            </xsl:when>
            <xsl:when test="$direction = 'rtl' and not($urltest)">
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$bidi-dita-css}"/>
            </xsl:when>
            <xsl:when test="$urltest">
                <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$dita-css}"/>
            </xsl:when>
            <xsl:otherwise>
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$dita-css}"/>
            </xsl:otherwise>
        </xsl:choose>

        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}xml.rocks.css" />

        <xsl:if test="string-length($CSS) > 0">
            <xsl:choose>
                <xsl:when test="$urltest">
                    <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}"/>
                </xsl:when>
                <xsl:otherwise>
                    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="addFavicon">
        <link rel="icon" type="image/png" href="{$PATH2PROJ}img/favicon.png"/>
    </xsl:template>

    <xsl:template match="*" mode="chapterBody">
        <body>
            <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
            <xsl:call-template name="setaname"/>
            <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
            <main role="main">
                <xsl:attribute name="class" select="'container max-width'"/>
                <xsl:call-template name="generateBreadcrumbs"/>

                <div class="dropdown">
                    <button onclick="myFunction()" class="dropbtn"></button>
                    <div id="myDropdown" class="dropdown-content">
                        <input type="button" id="downloadbtn" value="Download HTML as PDF" onclick="getPDF()"/>
                        <input type="button" value="Download PDF File" onclick="DownloadFile('bm_dude.pdf')"/>
                    </div>

                    <input type="button" id="printbtn" onclick="printDiv('topic-article')"/>

                </div>

                <div class="row row-cols-1 row-cols-md-3 mb-3 text-left">
                    <div class="col col-sm-4">
                        <div class="card mb-4 rounded-card-rocks">
                            <div class="toc-container">
                                <xsl:call-template name="gen-user-sidetoc"/>
                            </div>
                        </div>
                    </div>
                    <div class="col col-sm-8">
                        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
                    </div>
                </div>
            </main>
            <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
        </body>
    </xsl:template>

    <xsl:template match="/|node()|@*" mode="gen-user-header">
        <div class="d-flex flex-column flex-md-row align-items-center mb-4 main-header max-width">
            <!--       TODO: use text-dark for white background -->
            <a href="{$PATH2PROJ}index.html" class="d-flex align-items-center text-light text-decoration-none header-logo">
                <img src="{$PATH2PROJ}img/logo.svg"/>
            </a>
            <!--       TODO: use text-dark for white background -->
            <span class="fs-4 text-light">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*[contains(@class, ' map/map ')]">
                        <xsl:value-of select="ancestor-or-self::*[contains(@class, ' map/map ')][1]/*[contains(@class, ' topic/title ')][1]"/>
                    </xsl:when>
                    <xsl:when test="$input.map/*[contains(@class, ' map/map ')][1]/*[contains(@class, ' topic/title ')][1]">
                        <xsl:value-of select="$input.map/*[contains(@class, ' map/map ')][1]/*[contains(@class, ' topic/title ')][1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$input.map/@title"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <nav class="d-inline-flex mt-2 mt-md-0 ms-md-auto">
                <input class="form-control search" type="search" placeholder="Search" aria-label="Search"/>
            </nav>
        </div>
    </xsl:template>

    <xsl:template match="*" mode="addContentToHtmlBodyElement">
        <article xsl:use-attribute-sets="article" id="topic-article" class="topic-article">
            <xsl:attribute name="aria-labelledby">
                <xsl:apply-templates select="*[contains(@class,' topic/title ')] |
                                       self::dita/*[1]/*[contains(@class,' topic/title ')]"
                                     mode="return-aria-label-id"/>
            </xsl:attribute>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <xsl:apply-templates/>
            <xsl:call-template name="gen-endnotes"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]" mode="breadcrumb"/>
        </article>
    </xsl:template>

    <xsl:template match="*" mode="addFooterToHtmlBodyElement">
        <footer class="footer-container">
            <div class="d-flex flex-column footer-div max-width">
                <!-- FIXME HARDCODE! -->
                <a class="footer-text d-inline-flex mt-2 mt-md-0 ms-md-auto" href="#">Organization name ©
                    <xsl:call-template name="insertCurrentYear"/>
                </a>
            </div>
        </footer>
        <!-- TODO: get it out from there (make button and js independent from footer) -->
        <!-- Back to top button -->
        <button type="button"
                class="go-to-top accent-background-color"
                id="button-back-to-top">
            <a href="#">
                <svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
                    <g id="Layer_1">
                        <line stroke="#fff" id="svg_7" y2="17.66667" x2="26.33332" y1="30.33333" x1="13.66667" stroke-width="4"
                              fill="none"/>
                        <line transform="rotate(90.1903 29.9999 24)" stroke="#fff" id="svg_10" y2="17.66667" x2="36.33323"
                              y1="30.33333" x1="23.66658" stroke-width="4" fill="none"/>
                    </g>
                </svg>
                <!--       TODO: use this svg for white background-->
                 <!--<svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
                     <g id="Layer_1">
                         <line stroke="#000" id="svg_7" y2="17.66667" x2="26.33332" y1="30.33333" x1="13.66667" stroke-width="4" fill="none"/>
                         <line transform="rotate(90.1903 29.9999 24)" stroke="#000" id="svg_10" y2="17.66667" x2="36.33323" y1="30.33333" x1="23.66658" stroke-width="4" fill="none"/>
                     </g>
                 </svg>-->
            </a>
        </button>
        <!-- Go back button-->
        <button onclick="goBack()"
                class="go-back accent-background-color"
                id="btn-go-back">Back
        </button>

        <!-- JS -->
        <script src="{$PATH2PROJ}lib/jquery-3.6.0.min.js"></script>
        <script src="{$PATH2PROJ}lib/jspdf-1.5.3.min.js"></script>
        <script src="{$PATH2PROJ}lib/html2canvas-1.3.2.js"></script>
        <script src="{$PATH2PROJ}lib/popper.min.js"></script>
        <script src="{$PATH2PROJ}lib/xml.rocks.js"></script>
    </xsl:template>

    <xsl:template name="insertCurrentYear">
        <xsl:variable name="currentDate" as="xs:date" select="current-date()"/>
        <xsl:value-of select="year-from-date($currentDate)"/>
    </xsl:template>

    <xsl:template match="*" mode="breadcrumb1" priority="-1">
        <xsl:apply-templates select="node()" mode="breadcrumb1"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/related-links ')]" mode="breadcrumb">
        <xsl:for-each
                select="descendant-or-self::*[contains(@class, ' topic/related-links ') or contains(@class, ' topic/linkpool ')][*[@role = 'ancestor']]">

                <xsl:if test="$include.roles = 'previous'">
                    <!--output previous link first, if it exists-->
                    <xsl:if test="*[@href][@role = 'previous']">
                        <xsl:apply-templates select="*[@href][@role = 'previous'][1]" mode="breadcrumb"/>
                    </xsl:if>
                </xsl:if>
                <!--if both previous and next links exist, output a separator bar-->
                <xsl:if test="$include.roles = 'previous' and $include.roles = 'next'">
                    <xsl:if test="*[@href][@role = 'next'] and *[@href][@role = 'previous']">
                        <xsl:text> | </xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$include.roles = 'next'">
                    <!--output next link, if it exists-->
                    <xsl:if test="*[@href][@role = 'next']">
                        <xsl:apply-templates select="*[@href][@role = 'next'][1]" mode="breadcrumb"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$include.roles = 'previous' and $include.roles = 'next' and $include.roles = 'ancestor'">
                    <!--if we have either next or previous, plus ancestors, separate the next/prev from the ancestors with a vertical bar-->
                    <xsl:if test="(*[@href][@role = 'next'] or *[@href][@role = 'previous']) and *[@href][@role = 'ancestor']">
                        <xsl:text> | </xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$include.roles = 'ancestor'">
                    <!--if ancestors exist, output them, and include a greater-than symbol after each one, including a trailing one-->
                    <xsl:for-each select="*[@href][@role = 'ancestor']">
                        <xsl:apply-templates select="."/>
                        <xsl:text> &gt; </xsl:text>
                    </xsl:for-each>
                </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--create breadcrumbs for each grouping of ancestor links; include previous, next, and ancestor links, sorted by linkpool/related-links parent. If there is more than one linkpool that contains ancestors, multiple breadcrumb trails will be generated-->
    <xsl:template match="*[contains(@class, ' topic/related-links ')]" mode="breadcrumb1">
        <xsl:for-each select="ancestor-or-self::*[contains(@class, ' topic/related-links ')]">
            <xsl:apply-templates select="*[@href][@role = 'parent'][1]" mode="breadcrumb"/>
        </xsl:for-each>

        <xsl:value-of select="ancestor::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')][1]"/>
    </xsl:template>

    <xsl:template match="*" mode="addHeaderToHtmlBodyElement">
        <xsl:variable name="header-content">
            <xsl:call-template name="gen-user-header"/>
            <xsl:call-template name="processHDR"/>

            <xsl:if test="$INDEXSHOW = 'yes'">
                <xsl:apply-templates select="/*/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')] |
                                     /dita/*[1]/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"/>
            </xsl:if>
        </xsl:variable>

        <xsl:if test="exists($header-content)">
            <header xsl:use-attribute-sets="banner">
                <xsl:sequence select="$header-content"/>
            </header>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generateBreadcrumbs">
        <div class="breadcrumb">
            <span class="home">
                <a href="{concat($PATH2PROJ, 'index', $OUTEXT)}">
                    <xsl:text>Home</xsl:text>
                </a>
                <xsl:text> > </xsl:text>
            </span>

            <!-- Insert previous/next/ancestor breadcrumbs links at the top of the html5. -->
            <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]" mode="breadcrumb"/>
            <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]" mode="breadcrumb1"/>
        </div>
    </xsl:template>
</xsl:stylesheet>