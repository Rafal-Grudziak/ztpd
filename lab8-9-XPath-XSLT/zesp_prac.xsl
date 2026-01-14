<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Zad 5 -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Zespoly</title>
                <style>
                    table { border-collapse: collapse; margin-bottom: 6px; }
                    th, td { border: 1px solid #999; padding: 3px 6px; }
                    h2 { margin-top: 18px; margin-bottom: 0; }
                    h2.adres { margin-top: 0; margin-bottom: 18px; }
                </style>
            </head>
            <body>

                <h1>ZESPOŁY:</h1>

                <!-- Zad 6b i Zad 9 -->
                <ol>
                    <xsl:apply-templates select="/ZESPOLY/ROW" mode="list"/>
                </ol>

                <!-- Zad 7–14 -->
                <xsl:apply-templates select="/ZESPOLY/ROW" mode="details"/>

            </body>
        </html>
    </xsl:template>

    <!-- Zad 6 i Zad 9 -->
    <xsl:template match="ROW" mode="list">
        <li>
            <a>
                <xsl:attribute name="href">#<xsl:value-of select="ID_ZESP"/></xsl:attribute>
                <xsl:value-of select="NAZWA"/>
            </a>
        </li>
    </xsl:template>

    <!-- Zad 7 -->
    <xsl:template match="ROW" mode="details">

        <!-- Zad 9 -->
        <h2>
            <xsl:attribute name="id"><xsl:value-of select="ID_ZESP"/></xsl:attribute>
            NAZWA: <xsl:value-of select="NAZWA"/>
        </h2>

        <h2 class="adres">
            ADRES: <xsl:value-of select="ADRES"/>
        </h2>

        <!-- Zad 14 -->
        <xsl:choose>
            <xsl:when test="count(PRACOWNICY/ROW) &gt; 0">
                <!-- Zad 8 -->
                <table>
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Płaca pod.</th>
                        <th>Szef</th>
                    </tr>

                    <!-- Zad 10 -->
                    <xsl:for-each select="PRACOWNICY/ROW">
                        <xsl:sort select="NAZWISKO" data-type="text" order="ascending"/>

                        <tr>
                            <td><xsl:value-of select="NAZWISKO"/></td>
                            <td><xsl:value-of select="ETAT"/></td>
                            <td><xsl:value-of select="ZATRUDNIONY"/></td>
                            <td><xsl:value-of select="PLACA_POD"/></td>

                            <!-- Zad 11–12 -->
                            <td>
                                <xsl:variable name="bossId" select="ID_SZEFA"/>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($bossId)) = 0">brak</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="/ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC = $bossId]/NAZWISKO"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>

                    </xsl:for-each>
                </table>

                <!-- Zad 13 -->
                <div>
                    Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
                </div>
            </xsl:when>

            <xsl:otherwise>
                <!-- Zad 13 + Zad 14 -->
                <div>
                    Liczba pracowników: 0
                </div>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
