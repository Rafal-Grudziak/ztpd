<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <PRACOWNICY>
            <xsl:for-each select="/ZESPOLY/ROW/PRACOWNICY/ROW[normalize-space(NAZWISKO) != '']">
                <xsl:sort select="number(ID_PRAC)" data-type="number" order="ascending"/>

                <PRACOWNIK>
                    <xsl:attribute name="ID_PRAC"><xsl:value-of select="ID_PRAC"/></xsl:attribute>
                    <xsl:attribute name="ID_ZESP"><xsl:value-of select="ID_ZESP"/></xsl:attribute>

                    <xsl:if test="normalize-space(ID_SZEFA) != ''">
                        <xsl:attribute name="ID_SZEFA"><xsl:value-of select="ID_SZEFA"/></xsl:attribute>
                    </xsl:if>


                    <xsl:copy-of select="*[not(self::ID_PRAC or self::ID_ZESP or self::ID_SZEFA)]"/>
                </PRACOWNIK>

            </xsl:for-each>
        </PRACOWNICY>
    </xsl:template>

</xsl:stylesheet>
