<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*" mode="addFooterToHtmlBodyElement">
        <xsl:param name="map" select="$input.map"/>

        <xsl:message>@@@@@@@@@@@@@@@@</xsl:message>
        <xsl:message><xsl:copy-of select="$map"/></xsl:message>
        <xsl:variable name="organization">
            <xsl:choose>
                <xsl:when test="$organization-name != ''">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="$map/descendant::*[contains(@class, ' bookmap/organization ')][1]">
                    <xsl:value-of select="$map/descendant::*[contains(@class, ' bookmap/organization ')][1]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <footer class="footer-container">
            <div class="d-flex flex-column footer-div max-width">
                <span class="footer-text d-inline-flex" href="#">
                    <xsl:value-of select="$organization-name"/>
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="insertCurrentYear">
                        <xsl:with-param name="map" select="$map"/>
                    </xsl:call-template>
                </span>
            </div>
        </footer>
    </xsl:template>

    <xsl:template name="insertCurrentYear">
        <xsl:param name="map"/>
        <xsl:message>!!!!!!!!!!!</xsl:message>
        <xsl:message><xsl:value-of select="$map"/></xsl:message>

<!--
        <xsl:choose>
            <xsl:when
                    test="$input.map/descendant::*[contains(@class, ' bookmap/copyrfirst ')] and $input.map/descendant::*[contains(@class, ' bookmap/copyrlast ')]">
                <span class="copyright_years">&#xa9;<xsl:value-of
                        select="$input.map/descendant::*[contains(@class, ' bookmap/copyrfirst ')][1]"/> -<xsl:value-of
                        select="$input.map/descendant::*[contains(@class, ' bookmap/copyrlast ')][1]"/>
                </span>
            </xsl:when>

            <xsl:when test="$input.map/descendant::*[contains(@class, ' bookmap/copyrlast ')]">
                <span class="copyright_years">&#xa9;<xsl:value-of
                        select="$input.map/descendant::*[contains(@class, ' bookmap/copyrlast ')]"/>
                </span>
            </xsl:when>

            <xsl:when test="$input.map/descendant::*[contains(@class, ' topic/copyryear ')]">
                <span class="copyright_years">&#xa9;<xsl:value-of
                        select="$input.map/descendant::*[contains(@class, ' topic/copyryear ')][1]"/>
                </span>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="year-from-date(current-date())"/>
            </xsl:otherwise>

        </xsl:choose>
-->

        <xsl:choose>
            <xsl:when
                    test="$map/descendant::*[contains(@class, ' bookmap/copyrfirst ')] and $map/descendant::*[contains(@class, ' bookmap/copyrlast ')]">
                <span class="copyright_years">&#xa9;<xsl:value-of
                        select="$map/descendant::*[contains(@class, ' bookmap/copyrfirst ')][1]"/> -<xsl:value-of
                        select="$map/descendant::*[contains(@class, ' bookmap/copyrlast ')][1]"/>
                </span>
            </xsl:when>

            <xsl:when test="$map/descendant::*[contains(@class, ' bookmap/copyrlast ')]">
                <span class="copyright_years">&#xa9;<xsl:value-of
                        select="$map/descendant::*[contains(@class, ' bookmap/copyrlast ')]"/>
                </span>
            </xsl:when>

            <xsl:when test="$map/descendant::*[contains(@class, ' topic/copyryear ')]">
                <span class="copyright_years">&#xa9;<xsl:value-of
                        select="$map/descendant::*[contains(@class, ' topic/copyryear ')][1]"/>
                </span>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="year-from-date(current-date())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>