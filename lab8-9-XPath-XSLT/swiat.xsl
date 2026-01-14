<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">

    <!-- Zad. 12: ID kontynentu pobrane dynamicznie po nazwie -->
    <xsl:variable name="europeId" select="/SWIAT/KONTYNENTY/KONTYNENT[NAZWA='Europe']/@ID"/>

    <html>
      <head>
        <link href="swiat.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>

        <!-- Zad. 13–15: liczba krajów w Europie -->
        <p>
          Liczba krajów w Europie:
          <strong>
            <xsl:value-of select="count(/SWIAT/KRAJE/KRAJ[@KONTYNENT=$europeId])"/>
          </strong>
        </p>

        <table>
          <tr>
            <!-- Zad. 16–19: dodanie kolumny lp -->
            <th>LP</th>
            <th>Kraj</th>
            <th>Stolica</th>
          </tr>

          <!-- Zad. 9: wybór krajów zamiast kontynentów -->
          <!-- Zad. 12: filtr na Europę -->
          <xsl:apply-templates select="/SWIAT/KRAJE/KRAJ[@KONTYNENT=$europeId]">
            <!-- Zad. 20–21: sortowanie po nazwie kraju -->
            <xsl:sort select="NAZWA" data-type="text" order="ascending"/>
          </xsl:apply-templates>
        </table>

      </body>
    </html>
  </xsl:template>

  <xsl:template match="KRAJ">
    <tr>
      <!-- Zad. 16–19: numerowanie wierszy -->
      <td><xsl:value-of select="position()"/></td>
      <td><xsl:value-of select="NAZWA"/></td>
      <td><xsl:value-of select="STOLICA"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
