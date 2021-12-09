<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="2.0">
    <xsl:template match="*[contains(@class, ' topic/fn ')]" name="topic.fn">
        <xsl:param name="xref"/>
        <xsl:param name="xref-elem"/>
        <!-- when FN has an ID, it can only be referenced, otherwise, output an a-name & a counter -->
        <xsl:choose>
            <xsl:when test="@id and not($xref)"/>
            <xsl:otherwise>
                <xsl:variable name="fnid">
                    <xsl:call-template name="getFnID">
                        <xsl:with-param name="context" select="."/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="callout">
                    <xsl:choose>
                        <xsl:when test="@callout">
                            <xsl:value-of select="normalize-space(@callout)"/>
                        </xsl:when>
                        <xsl:when test="$xref and $xref-elem/*[not(contains(@class, ' topic/desc '))]"/>
                        <xsl:when test="$xref and $xref-elem/text()">
                            <xsl:apply-templates select="$xref-elem/text()"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="convergedcallout" select="if (string-length(normalize-space($callout)) > 0) then $callout else $fnid"/>
                <a name="fnsrc_{$fnid}" href="#fntarg_{$fnid}">
                    <sup>
                        <xsl:value-of select="$convergedcallout"/>
                    </sup>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getFnID">
        <xsl:param name="context" as="element()"/>

        <xsl:variable name="precedingFns" select="count($context/preceding::*[contains(@class, ' topic/fn ')][not(@id)])"/>
        <xsl:variable name="precedingXrefs">
            <xsl:for-each select="$context/preceding::*[contains(@class, ' topic/xref ')][@type = 'fn']">
                <xsl:variable name="href" select="@href"/>
                <xsl:if test="not(preceding::*[contains(@class, ' topic/xref ')][@type = 'fn'][@href = $href])">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$precedingFns + count($precedingXrefs/*) + 1"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/xref ')]" mode="genXrefFn">
        <xsl:variable name="href" select="translate(@href, '\', '/')"/>
        <xsl:variable name="fnId" select="tokenize($href, '/')[last()]"/>
        <xsl:variable name="fn" select="/descendant::*[contains(@class, ' topic/fn ')][@id = $fnId][1]"/>
        <xsl:if test="exists($fn)">
            <xsl:apply-templates select="$fn">
                <xsl:with-param name="xref" select="true()"/>
                <xsl:with-param name="xref-elem" select="."/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/xref ')]" name="topic.xref">
        <xsl:choose>
            <xsl:when test="@type = 'fn'">
                <xsl:apply-templates select="." mode="genXrefFn"/>
            </xsl:when>
            <xsl:when test="@href and normalize-space(@href)">
                <xsl:apply-templates select="." mode="add-xref-highlight-at-start"/>
                <a>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="add-linking-attributes"/>
                    <xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
                    <!-- if there is text or sub element other than desc, apply templates to them
                    otherwise, use the href as the value of link text. -->
                    <xsl:choose>
                        <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                            <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                            <!--use xref content-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="href"/><!--use href text-->
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
                <xsl:apply-templates select="." mode="add-xref-highlight-at-end"/>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
                    <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="gen-endnotes">
        <!-- Skip any footnotes that are in draft elements when draft = no -->
        <xsl:variable name="endnotes">
            <xsl:apply-templates select="//*[contains(@class, ' topic/fn ')][not( (ancestor::*[contains(@class, ' topic/draft-comment ')] or ancestor::*[contains(@class, ' topic/required-cleanup ')]) and $DRAFT = 'no')]" mode="genEndnote"/>
        </xsl:variable>
        <xsl:if test="$endnotes/*">
            <div class="endnotes">
                <xsl:for-each select="$endnotes/*">
<!--                    <xsl:sort select="a"/>-->
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/xref ')][@type = 'fn']" mode="genEndnote">
        <xsl:param name="fn"/>
        <div class="fn">
            <xsl:variable name="fnid">
                <xsl:call-template name="getFnID">
                    <xsl:with-param name="context" select="."/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="callout" select="normalize-space($fn/@callout)"/>
            <xsl:variable name="convergedcallout" select="if (string-length($callout) > 0) then $callout else $fnid"/>

            <a>
                <xsl:attribute name="name" select="concat('fntarg_', $fnid)"/>
                <xsl:attribute name="href" select="concat('#fnsrc_', $fnid)"/>

                <xsl:value-of select="$convergedcallout"/>
                <xsl:if test="matches($convergedcallout, '\d+')">.</xsl:if>
                <xsl:text> </xsl:text>
            </a>

            <xsl:apply-templates select="$fn/node()"/>
        </div>

    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fn ')]" mode="genEndnote">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:variable name="id" select="@id"/>
                <xsl:if test="/descendant::*[contains(@class, ' topic/xref ')][@type = 'fn'][ends-with(@href, concat('/', $id))]">
                    <xsl:apply-templates select="/descendant::*[contains(@class, ' topic/xref ')][@type = 'fn'][ends-with(@href, concat('/', $id))][1]" mode="genEndnote">
                        <xsl:with-param name="fn" select="."/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <div class="fn">
                    <xsl:variable name="fnid">
                        <xsl:call-template name="getFnID">
                            <xsl:with-param name="context" select="."/>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:variable name="callout" select="normalize-space(@callout)"/>
                    <xsl:variable name="convergedcallout" select="if (string-length($callout) > 0) then $callout else $fnid"/>

                    <xsl:call-template name="commonattributes"/>
                    <a>
                        <xsl:attribute name="name" select="concat('fntarg_', $fnid)"/>
                        <xsl:attribute name="href" select="concat('#fnsrc_', $fnid)"/>

                        <xsl:value-of select="$convergedcallout"/>
                        <xsl:if test="matches($convergedcallout, '\d+')">.</xsl:if>
                        <xsl:text> </xsl:text>
                    </a>

                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>