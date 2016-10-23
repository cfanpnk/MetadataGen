<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output method="text"  encoding="utf-8" indent="yes"/>
<xsl:template match="/"># $Header$

#
LANGUAGE = "US"
LDRCONFIG = "//IT/main/code/apps/oracle_apps/12/Appltop/NI/bin/ni_metadata.lct#1 $
"


#Source Database d1ebs

#RELEASE_NAME 12.1.3

# -- Begin Entity Definitions --

DEFINE NI_METADATA
  KEY   APPLICATION_SHORT_NAME          VARCHAR2(50)
  KEY   METADATA_NAME                   VARCHAR2(50)
  BASE  NAME                            VARCHAR2(240)
  BASE  DESCRIPTION                     VARCHAR2(240)
  BASE  LAST_UPDATE_DATE                VARCHAR2(20)
  BASE  LAST_UPDATED_BY                 VARCHAR2(100)
  BASE  CREATION_DATE                   VARCHAR2(20)
  BASE  CREATED_BY                      VARCHAR2(100)
  BASE  ENABLED_FLAG                    VARCHAR2(1)

  DEFINE NI_METADATA_SETTINGS
    BASE  APPLICATION_SHORT_NAME          VARCHAR2(50)
    BASE  METADATA_NAME                   VARCHAR2(50)
    KEY   SETTING_NAME                    VARCHAR2(50)
    BASE  DESCRIPTION                     VARCHAR2(100)
    BASE  LAST_UPDATE_DATE                VARCHAR2(20)
    BASE  LAST_UPDATED_BY                 VARCHAR2(100)
    BASE  CREATION_DATE                   VARCHAR2(20)
    BASE  CREATED_BY                      VARCHAR2(100)
    BASE  FLEX_VALUE_SET_NAME             VARCHAR2(60)
    BASE  USED_BY_FLEX_VALUE_SET_NAME     VARCHAR2(60)
    BASE  ENABLED_FLAG                    VARCHAR2(1)

    DEFINE NI_METADATA_VALUES
      BASE  APPLICATION_SHORT_NAME          VARCHAR2(50)
      BASE  METADATA_NAME                   VARCHAR2(50)
      BASE  SETTING_NAME                    VARCHAR2(50)
      BASE  USED_BY                         VARCHAR2(50)
      BASE  VALUE                           VARCHAR2(2000)
      BASE  ACTUAL_VALUE                    VARCHAR2(2000)
      BASE  LAST_UPDATE_DATE                VARCHAR2(20)
      BASE  LAST_UPDATED_BY                 VARCHAR2(100)
      BASE  CREATION_DATE                   VARCHAR2(20)
      BASE  CREATED_BY                      VARCHAR2(100)
      BASE  ENABLED_FLAG                    VARCHAR2(1)
    END NI_METADATA_VALUES
  END NI_METADATA_SETTINGS
END NI_METADATA

# -- End Entity Definitions --


BEGIN NI_METADATA "<xsl:value-of select="Metadata/applicationShortName"/>" "<xsl:value-of select="Metadata/metadataName"/>"
  NAME = "<xsl:value-of select="Metadata/name"/>"
  DESCRIPTION = "<xsl:value-of select="Metadata/description"/>"
  LAST_UPDATE_DATE = "26-JUN-2015 14:56:49"
  LAST_UPDATED_BY = "<xsl:value-of select="Metadata/createdBy"/>"
  CREATION_DATE = "26-JUN-2015 14:56:49"
  CREATED_BY = "<xsl:value-of select="Metadata/createdBy"/>"
  ENABLED_FLAG = "Y"
  <xsl:for-each select="Metadata/metadataSettings/MetadataSetting">
    <xsl:variable name="escaped-description">
    <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="./description"/>
        <xsl:with-param name="replace" select="'&quot;'" />
        <xsl:with-param name="with" select="'\&quot;'"/>
    </xsl:call-template>
    </xsl:variable>
    BEGIN NI_METADATA_SETTINGS "<xsl:value-of select="./settingName"/>"
      APPLICATION_SHORT_NAME = "<xsl:value-of select="/Metadata/applicationShortName"/>"
      METADATA_NAME = "<xsl:value-of select="/Metadata/metadataName"/>"
      DESCRIPTION = "<xsl:value-of select="$escaped-description"/>"
      LAST_UPDATE_DATE = "26-JUN-2015 15:00:02"
      LAST_UPDATED_BY = "<xsl:value-of select="Metadata/createdBy"/>"
      CREATION_DATE = "26-JUN-2015 14:58:30"
      CREATED_BY = "<xsl:value-of select="Metadata/createdBy"/>"
      ENABLED_FLAG = "Y"
      <xsl:for-each select="./metadataValues/MetadataValue">
      <xsl:variable name="escaped-value">
      <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="./value"/>
          <xsl:with-param name="replace" select="'&quot;'" />
          <xsl:with-param name="with" select="'\&quot;'"/>
      </xsl:call-template>
      </xsl:variable>
      BEGIN NI_METADATA_VALUES
        APPLICATION_SHORT_NAME = "<xsl:value-of select="/Metadata/applicationShortName"/>"
        METADATA_NAME = "<xsl:value-of select="/Metadata/metadataName"/>"
        SETTING_NAME = "<xsl:value-of select="./settingName"/>"
        USED_BY = "<xsl:value-of select="./usedBy" disable-output-escaping="yes"/>"
        VALUE = "<xsl:value-of select="$escaped-value" disable-output-escaping="yes"/>"
        ACTUAL_VALUE = "<xsl:value-of select="$escaped-value" disable-output-escaping="yes"/>"
        LAST_UPDATE_DATE = "26-JUN-2015 17:04:40"
        LAST_UPDATED_BY = "<xsl:value-of select="Metadata/createdBy"/>"
        CREATION_DATE = "26-JUN-2015 17:04:40"
        CREATED_BY = "<xsl:value-of select="Metadata/createdBy"/>"
        ENABLED_FLAG = "Y"
      END NI_METADATA_VALUES
    </xsl:for-each>
    END NI_METADATA_SETTINGS
</xsl:for-each>
END NI_METADATA
    </xsl:template>
    
        <xsl:template name="replace-string">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="with"/>
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$with"/>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text"
                        select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="with" select="$with"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
