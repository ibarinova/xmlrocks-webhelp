<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:param name="using-input"/>
    <xsl:param name="includes-pdf"/>
    <xsl:param name="table-numbering"/>
    <xsl:param name="figure-numbering"/>
    <xsl:param name="save-to-google-drive"/>
    <xsl:param name="organization-name"/>
    <xsl:param name="two-col-fig-callouts" select="'false'"/>
    <xsl:param name="name-of-map"/>
    <xsl:param name="include.rellinks"
               select="'#default parent child sibling friend next previous cousin ancestor descendant sample external other'"
               as="xs:string"/>

    <xsl:variable name="css-path-normalized" select="if($CSSPATH = '/') then('') else($CSSPATH)"/>

    <xsl:variable name="output-pdf-name" select="concat($name-of-map, '.pdf')"/>
    <xsl:variable name="output-pdf-full-path" select="concat($PATH2PROJ, 'pdf/',$output-pdf-name)"/>

    <xsl:variable name="include.roles" select="tokenize(normalize-space($include.rellinks), '\s+')" as="xs:string*"/>

    <xsl:variable name="separate-fig-callouts" select="$two-col-fig-callouts = ('yes', 'true')"/>

    <xsl:variable name="preceding-sibling-topicref" select="$current-topicref/preceding-sibling::*[not(@toc = 'no')]
                                                            [not(@processing-role = 'resource-only')][not(ancestor::*[contains(@chunk, 'to-content')])][@href][1]"/>
    <xsl:variable name="preceding-topicref" select="$current-topicref/preceding::*[not(@toc = 'no')]
                                                    [not(@processing-role = 'resource-only')][not(ancestor::*[contains(@chunk, 'to-content')])][@href][1]"/>
    <xsl:variable name="ancestor-topicref" select="$current-topicref/ancestor::*[not(@toc = 'no')][not(@processing-role = 'resource-only')]
                                                    [not(ancestor::*[contains(@chunk, 'to-content')])][@href][1]"/>
    <xsl:variable name="child-topicref" select="$current-topicref/child::*[not(@toc = 'no')][not(@processing-role = 'resource-only')]
                                                [not(ancestor::*[contains(@chunk, 'to-content')])][@href][1]"/>
    <xsl:variable name="following-topicref" select="$current-topicref/following::*[not(@toc = 'no')][not(@processing-role = 'resource-only')]
                                                    [not(ancestor::*[contains(@chunk, 'to-content')])][@href][1]"/>

    <xsl:attribute-set name="banner">
        <xsl:attribute name="class">rocks-header</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template match="*" mode="chapterHead">
        <head>
            <xsl:call-template name="generateCharset"/>
            <xsl:apply-templates select="." mode="generateDefaultCopyright"/>
            <xsl:call-template name="generateDefaultMeta"/>
            <xsl:apply-templates select="." mode="getMeta"/>
            <xsl:call-template name="insertViewport"/>
            <xsl:call-template name="copyright"/>
            <xsl:call-template name="generateCssLinks"/>
            <xsl:call-template name="addFavicon"/>
            <xsl:call-template name="generateChapterTitle"/>
            <xsl:call-template name="gen-user-head"/>
            <xsl:call-template name="gen-user-scripts"/>
            <xsl:call-template name="gen-user-styles"/>
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
                <xsl:with-param name="urltext" select="concat($css-path-normalized, $CSS)"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$direction = 'rtl' and $urltest ">
                <link rel="stylesheet" type="text/css" href="{$css-path-normalized}{$bidi-dita-css}"/>
            </xsl:when>
            <xsl:when test="$direction = 'rtl' and not($urltest)">
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$css-path-normalized}{$bidi-dita-css}"/>
            </xsl:when>
            <xsl:when test="$urltest">
                <link rel="stylesheet" type="text/css" href="{$css-path-normalized}{$dita-css}"/>
            </xsl:when>
            <xsl:otherwise>
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$css-path-normalized}{$dita-css}"/>
            </xsl:otherwise>
        </xsl:choose>

        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$css-path-normalized}bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$css-path-normalized}xml.rocks.css"/>

        <xsl:if test="string-length($CSS) > 0">
            <xsl:choose>
                <xsl:when test="$urltest">
                    <link rel="stylesheet" type="text/css" href="{$css-path-normalized}{$CSS}"/>
                </xsl:when>
                <xsl:otherwise>
                    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$css-path-normalized}{$CSS}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertViewport">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    </xsl:template>

    <xsl:template name="addFavicon">
        <link rel="icon" type="image/png" href="{$PATH2PROJ}images/favicon.png"/>
    </xsl:template>

    <xsl:template match="*" mode="chapterBody">
        <body>
            <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
            <xsl:call-template name="setaname"/>
            <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>

            <div class="breadcrumb-container max-width">
                <xsl:call-template name="generate-custom-breadcrumbs"/>
            </div>

            <div class="top-nav-buttons-container-wrapper">
                <div class="top-nav-buttons-container max-width">
                    <xsl:choose>
                        <xsl:when test="$preceding-sibling-topicref/@href">
                            <xsl:call-template name="insertNavPrevButton">
                                <xsl:with-param name="prev-topicref" select="$preceding-topicref"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$ancestor-topicref/@href">
                            <xsl:call-template name="insertNavPrevButton">
                                <xsl:with-param name="prev-topicref" select="$ancestor-topicref"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$preceding-topicref/@href">
                            <xsl:call-template name="insertNavPrevButton">
                                <xsl:with-param name="prev-topicref" select="$preceding-topicref"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="$child-topicref/@href">
                            <xsl:call-template name="insertNavNextButton">
                                <xsl:with-param name="next-topicref" select="$child-topicref"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$following-topicref/@href">
                            <xsl:call-template name="insertNavNextButton">
                                <xsl:with-param name="next-topicref" select="$following-topicref"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </div>
            </div>

            <div class="main-button-container-wrapper">
                <div class="main-button-container max-width">
                    <div class="mobile-menu-button-container">
                        <button id="mobile-menu-button"/>
                    </div>
                    <div class="left-buttons-container">
                        <div class="button-hide-show-toc-container">
                            <button onclick="hideOrShowTOC()" id="button-hide-show-toc">
                                <span class="tooltip-hide-toc">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Hide navigation'"/>
                                    </xsl:call-template>
                                </span>
                                <span class="tooltip-show-toc">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Show navigation'"/>
                                    </xsl:call-template>
                                </span>
                            </button>
                        </div>

                        <div class="button-expand-collapse-container">
                            <button onclick="expandCollapseAll()" id="button-expand-collapse">
                                <span class="tooltip-expand-all">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Expand all'"/>
                                    </xsl:call-template>
                                </span>
                                <span class="tooltip-collapse-all">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Collapse all'"/>
                                    </xsl:call-template>
                                </span>
                            </button>
                        </div>

                        <div class="button-show-active-container">
                            <button onclick="showActive()" id="button-show-active">
                                <span class="tooltip-show-active">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Show active topic'"/>
                                    </xsl:call-template>
                                </span>
                            </button>
                        </div>
                    </div>

                    <div class="right-buttons-container">
                        <xsl:choose>
                            <xsl:when test="$includes-pdf = ('yes', 'true')">
                                <div class="dropdown-download">
                                    <button onclick="dropdownDownload()" class="button-dropdown-download">
                                        <span class="tooltip-download">
                                            <xsl:call-template name="getVariable">
                                                <xsl:with-param name="id" select="'Download'"/>
                                            </xsl:call-template>
                                        </span>
                                    </button>

                                    <div id="menu-dropdown-download" class="dropdown-content-download">
                                        <button id="download-page-btn" onclick="exportPdf()">
                                            <div class="download-page">
                                                <xsl:call-template name="getVariable">
                                                    <xsl:with-param name="id" select="'Download topic PDF'"/>
                                                </xsl:call-template>
                                            </div>
                                        </button>
                                        <button id="download-output-btn">
                                            <a href="{$output-pdf-full-path}" target="_blank">
                                                <div class="download-output">
                                                    <xsl:call-template name="getVariable">
                                                        <xsl:with-param name="id" select="'Download common PDF'"/>
                                                    </xsl:call-template>
                                                </div>
                                            </a>
                                        </button>
                                    </div>
                                </div>
                            </xsl:when>

                            <xsl:otherwise>
                                <div class="dropdown-download">
                                    <button onclick="exportPdf()" class="button-dropdown-download">
                                        <span class="tooltip-download-current-page">
                                            <xsl:call-template name="getVariable">
                                                <xsl:with-param name="id" select="'Download topic PDF'"/>
                                            </xsl:call-template>
                                        </span>
                                    </button>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>

                        <div>
                            <xsl:attribute name="class" select="if($includes-pdf = ('yes', 'true') and $save-to-google-drive = ('yes', 'true'))
                                                                then('button-print-container')
                                                                else('button-print-container last-right-container')"/>

                            <button onclick="window.print()" id="printbtn" class="button-print">
                                <span class="tooltip-print">
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Print topic'"/>
                                    </xsl:call-template>
                                </span>
                            </button>
                        </div>

                        <xsl:if test="$includes-pdf = ('yes', 'true') and $save-to-google-drive = ('yes', 'true')">
                            <div class="dropdown-google-drive last-right-container">
                                <button onclick="dropdownGoogleDrive()" class="button-dropdown-share-google-drive">
                                    <span class="tooltip-google-drive">
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="'Save to Google Drive'"/>
                                        </xsl:call-template>
                                    </span>
                                </button>

                                <div id="menu-dropdown-google-drive" class="dropdown-content-google-drive">
                                    <xsl:text disable-output-escaping="yes">&lt;script src="https://apis.google.com/js/platform.js" async defer&gt;&lt;/script&gt;</xsl:text>
                                    <input type="button" class="g-savetodrive"
                                           data-src="{$output-pdf-full-path}"
                                           data-filename="{$output-pdf-name}"
                                           data-sitename="PDF output">
                                    </input>
                                </div>
                            </div>
                        </xsl:if>

                        <div class="expand-collapse-search-container">
                            <div class="buttons-separator"></div>
                            <button onclick="expandCollapseSearch()" class="expand-collapse-search"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="topic-page-sticky-search-container">
                <div class="search-input-container max-width">
                    <input class="form-control search search-input" type="search">
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
                    <button id="sticky-search-cancel-button"></button>
                    <div class="sticky-search-buttons-separator"></div>
                    <button id="sticky-search-button"></button>
                </div>
            </div>

            <div class="shading-container-wrapper" id="shading-wrapper"></div>

            <main role="main">
                <xsl:attribute name="class" select="'container max-width'"/>

                <div class="row row-cols-1 row-cols-md-3 mb-3 text-left" id="main-wrapper">
                    <div class="col col-sm-4" id="toc-wrapper">
                        <div class="toc-container">
                            <xsl:call-template name="gen-user-sidetoc"/>
                        </div>
                    </div>

                    <div class="col col-sm-8" id="article-wrapper">
                        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>

                        <div class="bottom-nav-buttons-container">
                            <xsl:choose>
                                <xsl:when test="$preceding-sibling-topicref/@href">
                                    <xsl:call-template name="insertNavPrevButton">
                                        <xsl:with-param name="prev-topicref" select="$preceding-topicref"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="$ancestor-topicref/@href">
                                    <xsl:call-template name="insertNavPrevButton">
                                        <xsl:with-param name="prev-topicref" select="$ancestor-topicref"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="$preceding-topicref/@href">
                                    <xsl:call-template name="insertNavPrevButton">
                                        <xsl:with-param name="prev-topicref" select="$preceding-topicref"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>

                            <xsl:choose>
                                <xsl:when test="$child-topicref/@href">
                                    <xsl:call-template name="insertNavNextButton">
                                        <xsl:with-param name="next-topicref" select="$child-topicref"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="$following-topicref/@href">
                                    <xsl:call-template name="insertNavNextButton">
                                        <xsl:with-param name="next-topicref" select="$following-topicref"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </div>
                    </div>
                </div>
            </main>
            <div id="back-to-top-button-container" class="max-width">
                <xsl:call-template name="insertBackToTopButton"/>
            </div>
            <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
            <xsl:call-template name="insertJavaScript"/>
        </body>
    </xsl:template>

    <xsl:template match="/|node()|@*" mode="gen-user-header">
        <div class="d-flex flex-column flex-md-row align-items-center mb-4 main-header max-width">
            <div class="logo-header">
                <a href="{$PATH2PROJ}index.html"
                   class="d-flex align-items-center text-light text-decoration-none header-logo">
                </a>
                <span class="tooltip-logo">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Home'"/>
                    </xsl:call-template>
                </span>
            </div>

            <span class="header-title">
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*[contains(@class, ' map/map ')]">
                        <xsl:value-of
                                select="ancestor-or-self::*[contains(@class, ' map/map ')][1]/*[contains(@class, ' topic/title ')][1]"/>
                    </xsl:when>
                    <xsl:when
                            test="$input.map/*[contains(@class, ' map/map ')][1]/*[contains(@class, ' topic/title ')][1]">
                        <xsl:value-of
                                select="$input.map/*[contains(@class, ' map/map ')][1]/*[contains(@class, ' topic/title ')][1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$input.map/@title"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>

            <nav class="header-search-wrapper">
                <input id="header-search-input" class="form-control search" type="search">
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
                <button id="search-cancel-button"/>
                <div class="search-buttons-separator"></div>
                <button id="search-button"/>
            </nav>
        </div>
    </xsl:template>

    <xsl:template match="*" mode="addContentToHtmlBodyElement">
        <article xsl:use-attribute-sets="article" id="topic-article">
            <xsl:attribute name="aria-labelledby">
                <xsl:apply-templates select="*[contains(@class,' topic/title ')] |
                                       self::dita/*[1]/*[contains(@class,' topic/title ')]"
                                     mode="return-aria-label-id"/>
            </xsl:attribute>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <xsl:apply-templates select="*[not(contains(@class, ' topic/related-links '))]"/>
            <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]"/>
            <xsl:call-template name="gen-endnotes"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
        </article>
    </xsl:template>

    <xsl:template name="insertBackToTopButton">
        <button type="button" class="go-to-top accent-background-color" id="button-back-to-top" onclick="backToTop()">
            <img src="{$PATH2PROJ}images/go-to-top.svg"/>
        </button>
    </xsl:template>

    <xsl:template name="insertJavaScript">
        <script src="{$PATH2PROJ}lib/jquery-3.6.0.min.js"></script>
        <script src="{$PATH2PROJ}lib/platform.js"></script>
        <script src="{$PATH2PROJ}lib/angular.min.js"></script>
        <script src="{$PATH2PROJ}lib/jszip.min.js"></script>
        <script src="{$PATH2PROJ}lib/kendo.all.min.js"></script>
        <script src="{$PATH2PROJ}lib/xml.rocks.js"></script>
    </xsl:template>

    <xsl:template name="insertNavPrevButton">
        <xsl:param name="prev-topicref"/>

        <a class="prev-button">
            <xsl:attribute name="href">
                <xsl:call-template name="replace-extension">
                    <xsl:with-param name="filename" select="$prev-topicref/@href"/>
                    <xsl:with-param name="extension" select="$OUTEXT"/>
                </xsl:call-template>
            </xsl:attribute>

            <pre class="button-prev-nav"/>
            <xsl:text>&#32;</xsl:text>

            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Previous topic'"/>
            </xsl:call-template>

            <span class="prev-button-tooltip">
                <xsl:apply-templates select="$prev-topicref" mode="get-navtitle"/>
            </span>
        </a>
    </xsl:template>

    <xsl:template name="insertNavNextButton">
        <xsl:param name="next-topicref"/>
        <a class="next-button">
            <xsl:attribute name="href">
                <xsl:call-template name="replace-extension">
                    <xsl:with-param name="filename" select="$next-topicref/@href"/>
                    <xsl:with-param name="extension" select="$OUTEXT"/>
                </xsl:call-template>
            </xsl:attribute>

            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Next topic'"/>
            </xsl:call-template>

            <xsl:text>&#32;</xsl:text>
            <pre class="button-next-nav"/>

            <span class="next-button-tooltip">
                <xsl:apply-templates select="$next-topicref" mode="get-navtitle"/>
            </span>
        </a>
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

    <xsl:template match="*[contains(@class, ' topic/row ')]"
                  mode="get-output-class">table-row
    </xsl:template>

    <xsl:template match="*" mode="set-output-class">
        <xsl:param name="default"/>

        <xsl:variable name="output-class">
            <xsl:apply-templates select="." mode="get-output-class"/>
        </xsl:variable>

        <xsl:variable name="draft-revs" as="xs:string*">
            <xsl:if test="$DRAFT = 'yes'">
                <xsl:sequence select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop/@val"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="flag-outputclass" as="xs:string*"
                      select="tokenize(normalize-space(*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass), '\s+')"/>

        <xsl:variable name="using-output-class" as="xs:string*">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($output-class)) > 0">
                    <xsl:value-of select="tokenize(normalize-space($output-class), '\s+')"/>
                </xsl:when>
                <xsl:when test="string-length(normalize-space($default)) > 0">
                    <xsl:value-of select="tokenize(normalize-space($default), '\s+')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="ancestry" as="xs:string?">
            <xsl:if test="$PRESERVE-DITA-CLASS = 'yes'">
                <xsl:value-of>
                    <xsl:apply-templates select="." mode="get-element-ancestry"/>
                </xsl:value-of>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="outputclass-attribute" as="xs:string">
            <xsl:value-of>
                <xsl:apply-templates select="@outputclass" mode="get-value-for-class"/>
            </xsl:value-of>
        </xsl:variable>

        <xsl:variable name="classes" as="xs:string*"
                      select="tokenize($ancestry, '\s+'),
                          $using-output-class,
                          $draft-revs,
                          tokenize($outputclass-attribute, '\s+'),
                          $flag-outputclass"/>

        <xsl:variable name="no-default-values-classes" as="xs:string*"
                      select="$using-output-class,
                      $draft-revs,
                      tokenize($outputclass-attribute, '\s+'),
                      $flag-outputclass"/>

        <xsl:choose>
            <xsl:when test="contains(@class, ' topic/row ')">
                <xsl:attribute name="class" select="distinct-values($no-default-values-classes)" separator=" "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="class" select="distinct-values($classes)" separator=" "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="process.note.common-processing">
        <xsl:param name="type" select="@type"/>
        <xsl:param name="othertype" select="@othertype"/>

        <xsl:param name="title">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:variable name="image-name">
            <xsl:choose>
                <xsl:when test="lower-case(normalize-space($type)) = ('caution', 'danger', 'note', 'tip', 'warning', 'important')">
                    <xsl:value-of select="lower-case(normalize-space($type))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'note'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <table class="admonition-table">
            <tbody>
                <tr>
                    <td>
                        <img src="{concat($PATH2PROJ, 'images/', $image-name)}.svg" class="admonition-icon"/>
                    </td>
                    <td>
                        <div>
                            <xsl:call-template name="commonattributes">
                                <xsl:with-param name="default-output-class"
                                                select="string-join(($type, concat('note_', $type)), ' ')"/>
                            </xsl:call-template>
                            <xsl:call-template name="setidaname"/>
                            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
                                                 mode="ditaval-outputflag"/>
                            <span class="note__title">
                                <xsl:copy-of select="$title"/>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'ColonSymbol'"/>
                                </xsl:call-template>
                            </span>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
                                                 mode="ditaval-outputflag"/>
                            <xsl:apply-templates/>
                            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                                                 mode="out-of-line"/>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/ol ')] | *[contains(@class,' topic/fig ')]/*[contains(@class,' topic/sl ')]">
        <xsl:variable name="isOl" select="self::*[contains(@class,' topic/ol ')]"/>
        <xsl:choose>
            <xsl:when test="$separate-fig-callouts and (count(*) &gt; 3)">
                <xsl:variable name="odd-callouts">
                    <xsl:for-each select="*[(count(preceding-sibling::*) mod 2) = 0]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="even-callouts">
                    <xsl:for-each select="*[(count(preceding-sibling::*) mod 2) != 0]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <table class="table-callouts">
                    <tbody>
                        <xsl:for-each select="$odd-callouts/*">
                            <xsl:variable name="odd-callout-pos" select="position()"/>
                            <tr>
                                <td>
                                    <xsl:if test="$isOl">
                                        <xsl:value-of select="$odd-callout-pos + count(preceding-sibling::*)"/>
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="node()"/>
                                </td>
                                <td>
                                    <xsl:if test="$even-callouts/*[position() = $odd-callout-pos] and $isOl">
                                        <xsl:value-of select="$odd-callout-pos + count(preceding-sibling::*) + 1"/>
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="$even-callouts/*[position() = $odd-callout-pos]/node()"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lines ')]//text()">
        <xsl:analyze-string select="replace(., '  ', '')" regex="&#xA;">
            <xsl:matching-substring>
                <br/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/object ')][child::param[@name = 'movie'][@value]]">
        <embed>
            <xsl:attribute name="src" select="child::param[@name = 'movie'][1]/@value"/>
        </embed>
    </xsl:template>

    <xsl:template name="place-fig-lbl">
        <xsl:param name="stringName"/>
        <xsl:variable name="fig-count-actual" select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"/>

        <xsl:variable name="ancestorlang">
            <xsl:call-template name="getLowerCaseLang"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="*[contains(@class, ' topic/title ')]">
                <div class="figure-title">
                    <xsl:if test="not(normalize-space($figure-numbering) = ('no', 'false'))">
                        <span class="fig--title-label">
                            <xsl:choose>      <!-- Hungarian: "1. Figure " -->
                                <xsl:when test="$ancestorlang = ('hu', 'hu-hu')">
                                    <xsl:value-of select="$fig-count-actual"/>
                                    <xsl:text>.&#32;</xsl:text>
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Figure'"/>
                                    </xsl:call-template>
                                    <xsl:text>&#32;</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Figure'"/>
                                    </xsl:call-template>
                                    <xsl:text>&#32;</xsl:text>
                                    <xsl:value-of select="$fig-count-actual"/>
                                    <xsl:text>.&#32;</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                    </xsl:if>
                        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle"/>
                        <xsl:if test="*[contains(@class, ' topic/desc ')]">
                            <xsl:text>.&#32;</xsl:text>
                        </xsl:if>
                        <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
                            <span class="figdesc">
                                <xsl:call-template name="commonattributes"/>
                                <xsl:apply-templates select="." mode="figdesc"/>
                            </span>
                        </xsl:for-each>
                </div>
            </xsl:when>
            <xsl:when test="*[contains(@class, ' topic/desc ')]">
                <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
                    <figcaption>
                        <xsl:call-template name="commonattributes"/>
                        <xsl:apply-templates select="." mode="figdesc"/>
                    </figcaption>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="gen-topic">
        <xsl:param name="nestlevel" as="xs:integer">
            <xsl:choose>
                <xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 9">9</xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="parent::dita and not(preceding-sibling::*)">
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style" mode="add-ditaval-style"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="commonattributes">
                    <xsl:with-param name="default-output-class" select="concat('nested', $nestlevel)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="gen-toc-id"/>
        <xsl:call-template name="setidaname"/>
        <xsl:apply-templates select="*[not(contains(@class, ' topic/related-links '))]"/>
        <xsl:apply-templates select="*[contains(@class, ' topic/related-links ')]"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]" name="topic.fig">
        <xsl:variable name="default-fig-class">
            <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
        </xsl:variable>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <figure>
            <xsl:if test="$default-fig-class != ''">
                <xsl:attribute name="class" select="$default-fig-class"/>
            </xsl:if>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="$default-fig-class"/>
            </xsl:call-template>
            <xsl:call-template name="setscale"/>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ') or contains(@class, ' topic/desc ')]"/>
        </figure>
        <xsl:call-template name="place-fig-lbl"/>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </xsl:template>
</xsl:stylesheet>