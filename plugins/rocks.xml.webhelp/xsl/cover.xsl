<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="chapterBody">
        <body>
            <!-- FIXME HEADER IS HARDCODED! -->
            <header class="rocks-header sticky-top accent-background-color">
                <div class="d-flex flex-column flex-md-row align-items-center mb-4 main-header max-width">
                    <!--       TODO: use text dark for white background -->
                    <!--                        <a href="/" class="d-flex align-items-center text-dark text-decoration-none">-->
                    <a href="{$PATH2PROJ}index.html" class="d-flex align-items-center text-light text-decoration-none">
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="32" class="me-2" viewBox="0 0 118 94"
                             role="img"><title>Bootstrap</title>
                            <path fill-rule="evenodd" clip-rule="evenodd"
                                  d="M24.509 0c-6.733 0-11.715 5.893-11.492 12.284.214 6.14-.064 14.092-2.066 20.577C8.943 39.365 5.547 43.485 0 44.014v5.972c5.547.529 8.943 4.649 10.951 11.153 2.002 6.485 2.28 14.437 2.066 20.577C12.794 88.106 17.776 94 24.51 94H93.5c6.733 0 11.714-5.893 11.491-12.284-.214-6.14.064-14.092 2.066-20.577 2.009-6.504 5.396-10.624 10.943-11.153v-5.972c-5.547-.529-8.934-4.649-10.943-11.153-2.002-6.484-2.28-14.437-2.066-20.577C105.214 5.894 100.233 0 93.5 0H24.508zM80 57.863C80 66.663 73.436 72 62.543 72H44a2 2 0 01-2-2V24a2 2 0 012-2h18.437c9.083 0 15.044 4.92 15.044 12.474 0 5.302-4.01 10.049-9.119 10.88v.277C75.317 46.394 80 51.21 80 57.863zM60.521 28.34H49.948v14.934h8.905c6.884 0 10.68-2.772 10.68-7.727 0-4.643-3.264-7.207-9.012-7.207zM49.948 49.2v16.458H60.91c7.167 0 10.964-2.876 10.964-8.281 0-5.406-3.903-8.178-11.425-8.178H49.948z"
                                  fill="currentColor"></path>
                        </svg>
                    </a>
                    <!--       TODO: use text dark for white background -->
                    <!--                        <span class="fs-4 text-dark">Main book title</span>-->
                    <span class="fs-4 text-light">Main book title</span>
                    <nav class="d-inline-flex mt-2 mt-md-0 ms-md-auto">
                        <input class="form-control search" type="search" placeholder="Search" aria-label="Search"/>
                    </nav>
                </div>
            </header>

            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style"
                                 mode="add-ditaval-style"/>
            <xsl:if test="@outputclass">
                <xsl:attribute name="class" select="@outputclass"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="addAttributesToBody"/>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
            <xsl:call-template name="generateBreadcrumbs"/>
            <xsl:call-template name="gen-user-header"/>
            <xsl:call-template name="processHDR"/>
            <xsl:if test="$INDEXSHOW = 'yes'">
                <xsl:apply-templates
                        select="/*/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"/>
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
            <xsl:apply-templates select="$map" mode="toc"/>
            <xsl:call-template name="gen-endnotes"/>
            <xsl:call-template name="gen-user-footer"/>
            <xsl:call-template name="processFTR"/>
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            <xsl:call-template name="addFooterToHtmlBodyElement"/>
        </body>
    </xsl:template>

    <xsl:template match="*" mode="addHeaderToHtmlBodyElement">
        <xsl:variable name="header-content" as="node()*">
            <xsl:call-template name="generateBreadcrumbs"/>
            <xsl:call-template name="gen-user-header"/>  <!-- include user's XSL running header here -->
            <xsl:call-template name="processHDR"/>
            <xsl:if test="$INDEXSHOW = 'yes'">
                <xsl:apply-templates select="/*/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')] |
                                     /dita/*[1]/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"/>
            </xsl:if>
        </xsl:variable>
    </xsl:template>

    <xsl:template name="addFooterToHtmlBodyElement">

        <footer class="footer-container">
            <div class="d-flex flex-column footer-div max-width">
                <!-- FIXME HARDCODE! -->
                <a class="footer-text d-inline-flex mt-2 mt-md-0 ms-md-auto" href="#">Organization name © 2021</a>
            </div>
        </footer>
        <!-- TODO: get it out from there (make button and js independent from footer) -->
        <!-- Back to top button -->
        <button type="button"
                class="go-to-top accent-background-color"
                id="btn-back-to-top">
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
                <!--       TODO: use this svg for white background-->
                 <!--<svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
                     <g id="Layer_1">
                         <line stroke="#000" id="svg_7" y2="17.66667" x2="26.33332" y1="30.33333" x1="13.66667" stroke-width="4" fill="none"/>
                         <line transform="rotate(90.1903 29.9999 24)" stroke="#000" id="svg_10" y2="17.66667" x2="36.33323" y1="30.33333" x1="23.66658" stroke-width="4" fill="none"/>
                     </g>
                 </svg>-->
            </a>
        </button>
        <!-- XML Rocks JS -->
        <script src="{$PATH2PROJ}js/xml.rocks.js"></script>
    </xsl:template>

</xsl:stylesheet>