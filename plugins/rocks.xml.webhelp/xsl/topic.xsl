<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:param name="using-input"/>
    <xsl:param name="includes-pdf"/>
    <xsl:param name="organization-name"/>
    <xsl:param name="name-of-map"/>
    <xsl:param name="include.rellinks"
               select="'#default parent child sibling friend next previous cousin ancestor descendant sample external other'"
               as="xs:string"/>

    <xsl:variable name="output-pdf-name" select="concat($name-of-map, '.pdf')"/>
    <xsl:variable name="output-pdf-full-path" select="concat($PATH2PROJ, 'pdf/',$output-pdf-name)"/>

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
        <xsl:variable name="css-path-normalized" select="if($CSSPATH = '/') then('') else($CSSPATH)"/>

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
        <link rel="icon" type="image/png" href="{$PATH2PROJ}img/favicon.png"/>
    </xsl:template>

    <xsl:template match="*" mode="chapterBody">
        <body>
            <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
            <xsl:call-template name="setaname"/>
            <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
            <div class="breadcrumb-container max-width">
                <xsl:call-template name="generate-custom-breadcrumbs"/>
            </div>

            <main role="main">
                <xsl:attribute name="class" select="'container max-width'"/>
                <div class="button-bar">
                    <div class="dropdown-download">
                        <button onclick="dropdownDownload()" class="button-dropdown-download">
                            <span class="tooltip-download">Click here to download page</span>
                        </button>

                        <div id="menu-dropdown-download" class="dropdown-content-download">
                            <input type="button" id="downloadbtn" value="Download this page as PDF"
                                    onclick="getPDF()"/>

                            <xsl:if test="$includes-pdf = ('yes', 'true')">
                                <a href="{$output-pdf-full-path}" target="_blank" download="{$output-pdf-name}">Download PDF output</a>
                            </xsl:if>
                        </div>
                    </div>

                    <div class="button-print-container">
                        <button onclick="window.print()" id="printbtn" class="button-print">
                            <span class="tooltip-print">Click here to print page</span>
                        </button>
                    </div>

                    <xsl:if test="$includes-pdf = ('yes', 'true')">
                        <div class="dropdown-google-drive">
                            <button onclick="dropdownGoogleDrive()" class="button-dropdown-share-google-drive">
                                <span class="tooltip-google-drive">Click here to save to Google Drive</span>
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
                </div>

                <div class="row row-cols-1 row-cols-md-3 mb-3 text-left">
                    <div class="col col-sm-4" id="toc-wrapper">
                        <div class="card mb-4 rounded-card-rocks">
                            <div class="toc-container">
                                <xsl:call-template name="gen-user-sidetoc"/>
                            </div>
                        </div>
                    </div>

                    <div class="col col-sm-8">
                        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
                        <xsl:call-template name="insertBackToTopButton"/>
                    </div>
                </div>
            </main>
            <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
            <xsl:call-template name="insertJavaScript"/>
        </body>
    </xsl:template>

    <xsl:template match="/|node()|@*" mode="gen-user-header">
        <div class="d-flex flex-column flex-md-row align-items-center mb-4 main-header max-width">
            <div class="logo-header">
                <a href="{$PATH2PROJ}index.html"
                   class="d-flex align-items-center text-light text-decoration-none header-logo">
                    <img src="{$PATH2PROJ}img/logo.svg"/>
                </a>
                <span class="tooltip-logo">Click here to go to the main page</span>
            </div>

            <span class="fs-4 text-light">
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

            <nav class="d-inline-flex mt-2 mt-md-0 ms-md-auto">
                <input class="form-control search" type="search" placeholder="Search" aria-label="Search"/>
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
            <xsl:apply-templates/>
            <xsl:call-template name="gen-endnotes"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
        </article>
    </xsl:template>

    <xsl:template match="*" mode="addFooterToHtmlBodyElement">
        <xsl:variable name="organization-name">
            <xsl:choose>
                <xsl:when test="$organization-name != '${organization-name}'">
                    <xsl:value-of select="$organization-name"/>
                </xsl:when>
                <xsl:when
                        test="$input.map/descendant::*[contains(@class, ' bookmap/organization ')][1]">
                    <xsl:value-of
                            select="$input.map/descendant::*[contains(@class, ' bookmap/organization ')][1]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <footer class="footer-container">
            <div class="d-flex flex-column footer-div max-width">
                <a class="footer-text d-inline-flex" href="#">
                    <xsl:value-of select="$organization-name"/>
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="insertCurrentYear"/>
                </a>
            </div>
        </footer>
    </xsl:template>

    <xsl:template name="insertBackToTopButton">
        <button type="button"
                class="go-to-top accent-background-color"
                id="button-back-to-top">
            <a href="#">
                <svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
                    <g id="Layer_1">
                        <line stroke="#fff" id="svg_7" y2="17.66667" x2="26.33332" y1="30.33333" x1="13.66667"
                              stroke-width="4"
                              fill="none"/>
                        <line transform="rotate(90.1903 29.9999 24)" stroke="#fff" id="svg_10" y2="17.66667"
                              x2="36.33323"
                              y1="30.33333" x1="23.66658" stroke-width="4" fill="none"/>
                    </g>
                </svg>
            </a>
        </button>
    </xsl:template>

    <xsl:template name="insertJavaScript">
        <script src="{$PATH2PROJ}lib/jquery-3.6.0.min.js"></script>
        <script src="{$PATH2PROJ}lib/jspdf-1.5.3.min.js"></script>
        <script src="{$PATH2PROJ}lib/html2canvas-1.3.2.js"></script>
        <script src="{$PATH2PROJ}lib/popper.min.js"></script>
        <script src="{$PATH2PROJ}lib/platform.js"></script>
        <script src="{$PATH2PROJ}lib/xml.rocks.js"></script>
    </xsl:template>

    <xsl:template name="insertCurrentYear">
        <xsl:variable name="currentDate" as="xs:date" select="current-date()"/>
        <xsl:value-of select="year-from-date($currentDate)"/>
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

    <xsl:template match="*[contains(@class, ' topic/link ')][@role = ('child', 'descendant')]" priority="2"
                  name="topic.link_child">
        <li class="ulchildlink">
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'ulchildlink'"/>
            </xsl:call-template>
            <xsl:apply-templates select="*[contains(@class, ' topic/data ') or contains(@class, ' topic/foreign ')]"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

            <strong>
                <xsl:apply-templates select="." mode="related-links:unordered.child.prefix"/>
                <xsl:apply-templates select="." mode="add-link-highlight-at-start"/>

                <a class="ullink-ahref">
                    <xsl:apply-templates select="." mode="add-linking-attributes"/>
                    <xsl:apply-templates select="." mode="add-hoverhelp-to-child-links"/>
                    <xsl:choose>
                        <xsl:when test="*[contains(@class, ' topic/linktext ')]">
                            <xsl:apply-templates select="*[contains(@class, ' topic/linktext ')]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="href"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <xsl:apply-templates select="." mode="add-link-highlight-at-end"/>
            </strong>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            <br/>
            <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"/>
        </li>
    </xsl:template>
</xsl:stylesheet>