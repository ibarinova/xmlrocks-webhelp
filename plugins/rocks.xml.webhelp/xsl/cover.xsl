<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="chapterBody">
        <body>

            <!--<xsl:if test="exists($header-content)">
                <header xsl:use-attribute-sets="banner">
                    <xsl:sequence select="$header-content"/>
                </header>
            </xsl:if>-->

            <header class="footer-container">
                <div class="d-flex flex-column footer-div max-width">
                    <a class="footer-text d-inline-flex mt-2 mt-md-0 ms-md-auto" href="#">Booktitle</a>
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
                <a class="footer-text d-inline-flex mt-2 mt-md-0 ms-md-auto" href="#">Organization name © 2021</a>
            </div>
        </footer>
        <!-- TODO get it out from there (make button and js independent from footer) -->
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
                <!--        use this svg for white background-->
                <!--<svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
                    <g id="Layer_1">
                        <line stroke="#000" id="svg_7" y2="17.66667" x2="26.33332" y1="30.33333" x1="13.66667" stroke-width="4" fill="none"/>
                        <line transform="rotate(90.1903 29.9999 24)" stroke="#000" id="svg_10" y2="17.66667" x2="36.33323" y1="30.33333" x1="23.66658" stroke-width="4" fill="none"/>
                    </g>
                </svg>-->
            </a>
        </button>
        <!-- XML Rocks JS -->
        <script src="js/xml.rocks.js"></script>
    </xsl:template>

</xsl:stylesheet>