-- *******************************************************************************
-- FileName:             PO_PO_Acceptances.sql
--
-- Date Created:         2017/Jan/04 
-- Created By:           Apatel
-- Reference SF Incident No : 00090395 
--
-- *******************************************************************************
-- output to PO_PO_Acceptances.lst file


@utlspon PO_PO_Acceptances

INSERT INTO N_VIEW_TABLE_TEMPLATES (VIEW_LABEL,
                                    QUERY_POSITION,
                                    TABLE_ALIAS,
                                    FROM_CLAUSE_POSITION,
                                    APPLICATION_LABEL,
                                    TABLE_NAME,
                                    PRODUCT_VERSION,
                                    INCLUDE_FLAG,
                                    BASE_TABLE_FLAG,
                                    SUBQUERY_FLAG,
                                    CREATED_BY,
                                    CREATION_DATE,
                                    LAST_UPDATED_BY,
                                    LAST_UPDATE_DATE,
                                    GEN_SEARCH_BY_COL_FLAG)
     VALUES ('PO_PO_Acceptances',
             1,
             'ACTBY',
             4,
             'AR',
             'HZ_PARTIES',
             '*',
             'Y',
             'Y',
             'N',
             'Noetix_Custom',
             TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
             'Noetix_Custom',
             TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
             'Y');


INSERT INTO N_VIEW_TABLE_TEMPLATES (VIEW_LABEL,
                                    QUERY_POSITION,
                                    TABLE_ALIAS,
                                    FROM_CLAUSE_POSITION,
                                    APPLICATION_LABEL,
                                    TABLE_NAME,
                                    PRODUCT_VERSION,
                                    INCLUDE_FLAG,
                                    BASE_TABLE_FLAG,
                                    SUBQUERY_FLAG,
                                    CREATED_BY,
                                    CREATION_DATE,
                                    LAST_UPDATED_BY,
                                    LAST_UPDATE_DATE,
                                    GEN_SEARCH_BY_COL_FLAG)
     VALUES ('PO_PO_Acceptances',
             1,
             'FU',
             10,
             'FND',
             'FND_USER',
             '*',
             'Y',
             'Y',
             'N',
             'Noetix_Custom',
             TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
             'Noetix_Custom',
             TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
             'Y');
			 
UPDATE n_view_column_templates
   SET table_alias = '',
       column_expression = 'DECODE (FU.USER_NAME,''SYSADMIN'', NULL, ''ANONYMOUS'', NULL, FU.USER_NAME)',
       column_type = 'EXPR',
       ref_application_label = NULL,
       ref_table_name = NULL,
       gen_search_by_col_flag = 'Y'
 WHERE view_label LIKE 'PO_PO_Acceptances'
       AND column_label LIKE 'Accepted_By';

INSERT INTO N_VIEW_COLUMN_TEMPLATES (VIEW_LABEL,
                                     QUERY_POSITION,
                                     COLUMN_LABEL,
                                     COLUMN_EXPRESSION,
                                     COLUMN_POSITION,
                                     COLUMN_TYPE,
                                     DESCRIPTION,
                                     GROUP_BY_FLAG,
                                     FORMAT_CLASS,
                                     GEN_SEARCH_BY_COL_FLAG,
                                     PRODUCT_VERSION,
                                     INCLUDE_FLAG,
                                     CREATED_BY,
                                     CREATION_DATE,
                                     LAST_UPDATED_BY,
                                     LAST_UPDATE_DATE)
     VALUES ('PO_PO_Acceptances',
             1,
             'Accepted_By_Number',
             'TO_CHAR(NULL)',
             130,
             'EXPR',
             'Accepted_By_Number',
             'N',
             'STRING',
             'N',
             '*',
             'Y',
             'Noetix_Custom',
             TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
             'Noetix_Custom',
             TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));




INSERT INTO N_VIEW_WHERE_TEMPLATES (VIEW_LABEL,
                                    QUERY_POSITION,
                                    WHERE_CLAUSE_POSITION,
                                    WHERE_CLAUSE,
                                    PRODUCT_VERSION,
                                    INCLUDE_FLAG,
                                    CREATED_BY,
                                    CREATION_DATE,
                                    LAST_UPDATED_BY,
                                    LAST_UPDATE_DATE)
     VALUES (
               'PO_PO_Acceptances',
               1,
               10,
               'AND FU.customer_id = ACTBY.party_id(+)',
               '*',
               'Y',
               'NOETIX_CUSTOM',
               TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
               'NOETIX_CUSTOM',
               TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));



INSERT INTO N_VIEW_WHERE_TEMPLATES (VIEW_LABEL,
                                    QUERY_POSITION,
                                    WHERE_CLAUSE_POSITION,
                                    WHERE_CLAUSE,
                                    PRODUCT_VERSION,
                                    INCLUDE_FLAG,
                                    CREATED_BY,
                                    CREATION_DATE,
                                    LAST_UPDATED_BY,
                                    LAST_UPDATE_DATE)
     VALUES (
               'PO_PO_Acceptances',
               1,
               11,
               'AND FU.user_id(+) = ACEPT.created_by',
               '*',
               'Y',
               'NOETIX_CUSTOM',
               TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
               'NOETIX_CUSTOM',
               TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));


INSERT INTO N_VIEW_WHERE_TEMPLATES (VIEW_LABEL,
                                    QUERY_POSITION,
                                    WHERE_CLAUSE_POSITION,
                                    WHERE_CLAUSE,
                                    PRODUCT_VERSION,
                                    INCLUDE_FLAG,
                                    CREATED_BY,
                                    CREATION_DATE,
                                    LAST_UPDATED_BY,
                                    LAST_UPDATE_DATE)
     VALUES (
               'PO_PO_Acceptances',
               1,
               12,
               'AND (ACEPT.EMPLOYEE_ID IS NULL OR TO_CHAR (FU.START_DATE, ''YYYYMMDDHH24MISS'') || TO_CHAR (FU.END_DATE, ''YYYYMMDDHH24MISS'') = (SELECT MAX (TO_CHAR (FU.START_DATE, ''YYYYMMDDHH24MISS'') || TO_CHAR (FU.END_DATE, ''YYYYMMDDHH24MISS'')) FROM APPLSYS.FND_User FU WHERE FU.user_ID = ACEPT.created_by))',
               '*',
               'Y',
               'NOETIX_CUSTOM',
               TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),
               'NOETIX_CUSTOM',
               TO_DATE ('01/04/2017 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));


COMMIT;

@utlspoff