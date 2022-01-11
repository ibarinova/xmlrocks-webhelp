<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:mappull="http://dita-ot.sourceforge.net/ns/200704/mappull"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="xs dita-ot mappull ditamsg">

    <xsl:template match="*[contains(@class, ' map/topicref ')][(@format, @dita-ot:orig-format) = 'ditamap']" priority="10">
        <xsl:param name="refclass" select="(@dita-ot:orig-class, @class)[1]" as="xs:string"/>
        <xsl:param name="relative-path" as="xs:string" tunnel="yes">#none#</xsl:param>
        <xsl:param name="mapref-id-path" as="xs:string*"/>
        <xsl:param name="referTypeFlag" as="xs:string">#none#</xsl:param>

        <xsl:variable name="href" select="(@href, @dita-ot:orig-href)[1]" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="generate-id(.) = $mapref-id-path">
                <!-- it is mapref but it didn't pass the loop dependency check -->
                <xsl:call-template name="output-message">
                    <xsl:with-param name="id" select="'DOTX053E'"/>
                    <xsl:with-param name="msgparams">%1=<xsl:value-of select="$href"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="updated-id-path" select="($mapref-id-path, generate-id(.))" as="xs:string*"/>
                <xsl:variable name="file" as="document-node()?">
                    <xsl:variable name="fileurl" as="xs:string?">
                        <xsl:variable name="WORKDIR" as="xs:string">
                            <xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="empty($href)"/>
                            <xsl:when test="contains($href, '://')">
                                <xsl:value-of select="$href"/>
                            </xsl:when>
                            <xsl:when test="starts-with($href, '#')">
                                <xsl:value-of select="concat($WORKDIR, $file-being-processed)"/>
                            </xsl:when>
                            <xsl:when test="contains($href, '#')">
                                <xsl:value-of select="concat($WORKDIR, substring-before($href, '#'))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($WORKDIR, $href)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="exists($fileurl)">
                        <xsl:sequence select="document($fileurl, /)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="empty($file)">
                        <xsl:variable name="filename" as="xs:string?">
                            <xsl:choose>
                                <xsl:when test="empty($href)"/>
                                <!-- resolve the file name, if the @href contains :// then don't do anything -->
                                <xsl:when test="contains($href,'://')">
                                    <xsl:value-of select="$href"/>
                                </xsl:when>
                                <xsl:when test="starts-with($href,'#')">
                                    <xsl:value-of select="$file-being-processed"/>
                                </xsl:when>
                                <!-- if @href contains # get the part before # -->
                                <xsl:when test="contains($href,'#')">
                                    <xsl:value-of select="substring-before($href,'#')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$href"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="output-message">
                            <xsl:with-param name="id" select="'DOTX031E'"/>
                            <xsl:with-param name="msgparams">%1=<xsl:value-of select="$filename"/></xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="element-id" as="xs:string?">
                            <xsl:if test="contains($href, '#')">
                                <xsl:value-of select="substring-after($href, '#')"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="target" as="element()?">
                            <xsl:choose>
                                <xsl:when test="exists($element-id)">
                                    <xsl:sequence select="$file//*[@id = $element-id]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="$file/*"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="targetTitleAndTopicmeta" as="element()*"
                                      select="$file/*/*[contains(@class,' topic/title ') or contains(@class,' map/topicmeta ')]"/>
                        <xsl:variable name="contents" as="node()*">
                            <xsl:choose>
                                <xsl:when test="not(contains($href,'://') or empty($element-id) or $file/*[contains(@class,' map/map ')][@id = $element-id])">
                                    <xsl:sequence select="$file//*[contains(@class,' map/topicref ')][@id = $element-id]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="$file/*/*[contains(@class,' map/topicref ') or contains(@class,' map/navref ') or contains(@class,' map/anchor ')] |
                                        $file/*/processing-instruction()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <!-- retain key definition as a separate element -->
                        <xsl:if test="@keys">
                            <keydef class="+ map/topicref mapgroup-d/keydef ditaot-d/keydef " processing-role="resource-only">
                                <xsl:apply-templates select="@* except (@class | @processing-role | @href)"/>
                                <xsl:if test="@href">
                                    <xsl:choose>
                                        <xsl:when test="$relative-path != '#none#'">
                                            <xsl:attribute name="href" select="concat($relative-path, @href)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="@href"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]"/>
                            </keydef>
                        </xsl:if>
                        <!-- href and format need to be retained for keyref processing but must be put to an internal namespace to prevent other modules to interact with this element -->
                        <submap class="+ map/topicref mapgroup-d/topicgroup ditaot-d/submap "
                                dita-ot:orig-href="{$href}"
                                dita-ot:orig-format="{(@format, @dita-ot:orig-format)[1]}"
                                dita-ot:orig-class="{(@class, @dita-ot:orig-class)[1]}">
                            <xsl:attribute name="dita-ot:orig-href">
                                <xsl:if test="not($relative-path = ('#none#', ''))">
                                    <xsl:value-of select="$relative-path"/>
                                </xsl:if>
                                <xsl:value-of select="$href"/>
                            </xsl:attribute>
                            <xsl:attribute name="dita-ot:orig-navtitle">
                                <xsl:choose>
                                    <xsl:when test="normalize-space(*/*[contains(@class,' topic/navtitle ')])">
                                        <xsl:value-of select="normalize-space(*/*[contains(@class,' topic/navtitle ')])"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@navtitle"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="@keyscope | $target[@keyscope and contains(@class, ' map/map ')]">
                                <xsl:attribute name="keyscope">
                                    <xsl:variable name="keyscope">
                                        <xsl:value-of select="@keyscope"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="$target[contains(@class, ' map/map ')]/@keyscope"/>
                                    </xsl:variable>
                                    <xsl:value-of select="normalize-space($keyscope)"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:apply-templates select="$target/@chunk"/>
                            <xsl:apply-templates select="@* except (@class, @href, @dita-ot:orig-href, @format, @dita-ot:orig-format, @keys, @keyscope, @type)"/>
                            <xsl:apply-templates select="$target/@*" mode="preserve-submap-attributes"/>
                            <xsl:apply-templates select="$targetTitleAndTopicmeta" mode="preserve-submap-title-and-topicmeta">
                                <xsl:with-param name="relative-path" tunnel="yes">
                                    <xsl:choose>
                                        <xsl:when test="not($relative-path = ('#none#', ''))">
                                            <xsl:value-of select="$relative-path"/>
                                            <xsl:call-template name="find-relative-path">
                                                <xsl:with-param name="remainingpath" select="$href"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="find-relative-path">
                                                <xsl:with-param name="remainingpath" select="$href"/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="*[contains(@class, ' ditavalref-d/ditavalref ')]"/>
                            <xsl:apply-templates select="$contents">
                                <xsl:with-param name="refclass" select="$refclass"/>
                                <xsl:with-param name="mapref-id-path" select="$updated-id-path"/>
                                <xsl:with-param name="relative-path" tunnel="yes">
                                    <xsl:choose>
                                        <xsl:when test="not($relative-path = ('#none#', ''))">
                                            <xsl:value-of select="$relative-path"/>
                                            <xsl:call-template name="find-relative-path">
                                                <xsl:with-param name="remainingpath" select="$href"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="find-relative-path">
                                                <xsl:with-param name="remainingpath" select="$href"/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                                <xsl:with-param name="referTypeFlag" select="'element'"/>
                            </xsl:apply-templates>
                        </submap>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$child-topicref-warning = 'true' and *[contains(@class, ' map/topicref ')]
                                                            [not(contains(@class, ' ditavalref-d/ditavalref '))]">
                    <xsl:call-template name="output-message">
                        <xsl:with-param name="id" select="'DOTX068W'"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
