@utlspon POWITHCLM_Profile_Option_op

INSERT INTO N_PROFILE_OPTION_TEMPLATES (PROFILE_OPTION,
                                        PROFILE_DESCRIPTION,
                                        APPLICATION_LABEL,
                                        TABLE_APPLICATION_LABEL,
                                        TABLE_NAME,
                                        PROFILE_SELECT,
                                        ESSAY,
                                        PRODUCT_VERSION,
                                        INCLUDE_FLAG,
                                        CREATED_BY,
                                        CREATION_DATE,
                                        LAST_UPDATED_BY,
                                        LAST_UPDATE_DATE)
     VALUES (
               'POWITHCLM',
               'Check if EBS version is 12.2.3+ and CLM is Enabled',
               'PO',
               'FND',
               'FND_PROFILE_OPTIONS',
               'SELECT ''Y''   FROM DUAL WHERE NOT EXISTS               (SELECT DISTINCT ''Y''                  FROM APPLSYS.FND_PROFILE_OPTION_VALUES POV,                        APPLSYS.FND_PROFILE_OPTIONS PO                 WHERE     1 = 1                       AND POV.APPLICATION_ID = PO.APPLICATION_ID                       AND POV.PROFILE_OPTION_ID = PO.PROFILE_OPTION_ID                       AND PO.PROFILE_OPTION_NAME = UPPER (''PO_CLM_ENABLED'')) OR NOT EXISTS               (SELECT DISTINCT ''Y''                  FROM ALL_TABLES                 WHERE OWNER = REPLACE(''PO.'',''.'')                    AND TABLE_NAME =''PO_CLM_AGENCIES'') OR NOT EXISTS               (SELECT DISTINCT ''Y''                     FROM N_VIEW_PARAMETER_EXTENSIONS NVPE                    WHERE PARAMETER_NAME = ''GENERATE_CLM_VIEWS''                          AND INSTALL_STAGE = 4                          AND NVPE.VALUE = ''Y''                                  AND INSTALL_CREATION_DATE =                                 (SELECT MAX (NVP.CREATION_DATE)                                    FROM N_VIEW_PARAMETERS NVP                                   WHERE NVP.INSTALL_STAGE = 4))',
               'Determines whether the Oracle EBS version is 12.2.2 and above and if CLM is enabled or not.',
               '11.0+',
               'Y',
               'Noetix',
               SYSDATE,
               'Noetix',
               SYSDATE);

COMMIT;

@utlspoff