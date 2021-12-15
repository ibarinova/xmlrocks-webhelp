<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:import href="plugin:rocks.xml.webhelp:xsl/topic.xsl"/>
  <xsl:import href="plugin:rocks.xml.webhelp:xsl/nav.xsl"/>
  <xsl:import href="plugin:rocks.xml.webhelp:xsl/rel-links.xsl"/>
  <xsl:import href="plugin:rocks.xml.webhelp:xsl/footnotes.xsl"/>
  <xsl:import href="plugin:rocks.xml.webhelp:xsl/dita2xmlrocks_common.xsl"/>
  <xsl:import href="plugin:rocks.xml.webhelp:xsl/tables.xsl"/>

  <dita:extension id="rocks.xsl.html5"
                  behavior="org.dita.dost.platform.ImportXSLAction"
                  xmlns:dita="http://dita-ot.sourceforge.net"/>
</xsl:stylesheet>