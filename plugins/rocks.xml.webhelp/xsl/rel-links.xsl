<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                exclude-result-prefixes="#all"
                version="2.0">

    <xsl:template match="*[contains(@class, ' topic/related-links ')]" mode="custom-breadcrumb">
        <xsl:for-each
                select="descendant-or-self::*[contains(@class, ' topic/related-links ') or contains(@class, ' topic/linkpool ')][*[@role = 'ancestor']]">

            <xsl:if test="$include.roles = 'ancestor'">
                <xsl:for-each select="*[@href][@role = 'ancestor']">
                    <xsl:apply-templates select="."/>
                    <xsl:text> </xsl:text>
                    <pre class="breadcrumbs-separator">&gt;</pre>
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="generate-custom-breadcrumbs">
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

            <button class="mobile-breadcrumbs-separator" id="mobile-separator-button" onclick="showBreadcrumbs()">
                <span class="mobile-button-breadcrumbs">
                    <img class="three-dots-separator" src="{$PATH2PROJ}images/three-dots.svg"/>
                </span>
            </button>

            <span class="head-breadcrumbs-child-elements">

                <button class="close-mobile-breadcrumbs">
                    <span class="close-breadcrumbs">
                        <img src="{$PATH2PROJ}images/search-close.svg"/>
                    </span>
            </button>
                <span class="child-elements">
                <xsl:apply-templates
                        select="descendant-or-self::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/related-links ')]"
                        mode="custom-breadcrumb"/>
                    <span class="head-breadcrumbs-child-last-elements">
                <xsl:apply-templates
                        select="descendant-or-self::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')][1]"
                        mode="text-only"/>
            </span>
                </span>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/link ')][@role = ('child', 'descendant')]" priority="2" name="topic.link_child">
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

    <xsl:template match="*" mode="determine-final-href">
        <xsl:choose>
            <xsl:when test="not(normalize-space(@href)) or empty(@href)"/>
            <!-- For non-DITA formats - use the href as is -->
            <xsl:when test="(empty(@format) and @scope = 'external') or (@format and not(@format = 'dita'))">
                <xsl:value-of select="@href"/>
            </xsl:when>
            <!-- For DITA - process the internal href -->
            <xsl:when test="starts-with(@href, '#')">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="dita-ot:generate-id(dita-ot:get-topic-id(@href), dita-ot:get-element-id(@href))"/>
            </xsl:when>
            <!-- It's to a DITA file - process the file name (adding the html extension)
          and process the rest of the href -->
            <xsl:when test="(empty(@scope) or @scope = ('local', 'peer')) and (empty(@format) or @format = 'dita')">
                <xsl:call-template name="replace-extension">
                    <xsl:with-param name="filename" select="@href"/>
                    <xsl:with-param name="extension" select="$OUTEXT"/>
                    <xsl:with-param name="ignore-fragment" select="true()"/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="(@role = 'child') and contains(@class, ' topic/link ')"/>
                    <xsl:when test="contains(@href, '#')">
                        <xsl:text>#</xsl:text>
                    <xsl:value-of select="dita-ot:generate-id(dita-ot:get-topic-id(@href), dita-ot:get-element-id(@href))"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="ditamsg:unknown-extension"/>
                <xsl:value-of select="@href"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>