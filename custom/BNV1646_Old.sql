-- File: BNV1646.sql
--
-- To be called from  wnoetxu5_legacy.sql
--
-- To generate a PK join in APG0_Invoice_Distributions view
--
-- Reference support ticket # 00080028
--
-- Created By: VYARRAMSETTY
--
-- Created Date: 30/June/2016


@utlspon BNV1646



INSERT INTO N_VIEW_COLUMNS (VIEW_NAME,
                            VIEW_LABEL,
                            QUERY_POSITION,
                            COLUMN_NAME,
                            COLUMN_LABEL,
                            TABLE_ALIAS,
                            COLUMN_EXPRESSION,
                            COLUMN_POSITION,
                            COLUMN_TYPE,
                            DESCRIPTION,
                            KEY_VIEW_NAME,
                            GROUP_BY_FLAG,
                            APPLICATION_INSTANCE,
                            GEN_SEARCH_BY_COL_FLAG,
                            SOURCE_COLUMN_ID,
                            GENERATED_FLAG)
     VALUES (
               'APG0_Invoice_Distributions',
               'AP_Invoice_Distributions',
               4,
               'Z$APG0_Invoice_Distributions',
               'AP_INVOICE_DISTRIBUTIONS_ALL',
               'IDSTR',
               'rowid',
               (select max(column_position)+1 from n_view_columns where view_name='APG0_Invoice_Distributions' and query_position=4),
               'GEN',
               'Join to Column -- use it only to join to other views Z$ columns. Internal Oracle rowid for table AP_INVOICE_DISTRIBUTIONS_ALL.',
               'APG0_Invoice_Distributions',
               'N',
               'G0',
               'N',
               (select COLUMN_ID from n_view_columns where  view_name= 'APG0_Invoice_Distributions' and query_position=4 and column_label='IDSTR$AP_Invoice_Distributions'),
               'Y');


INSERT INTO N_VIEW_COLUMNS (VIEW_NAME,
                            VIEW_LABEL,
                            QUERY_POSITION,
                            COLUMN_NAME,
                            COLUMN_LABEL,
                            TABLE_ALIAS,
                            COLUMN_EXPRESSION,
                            COLUMN_POSITION,
                            COLUMN_TYPE,
                            DESCRIPTION,
                            KEY_VIEW_NAME,
                            GROUP_BY_FLAG,
                            APPLICATION_INSTANCE,
                            GEN_SEARCH_BY_COL_FLAG,
                            SOURCE_COLUMN_ID,
                            GENERATED_FLAG)
     VALUES (
               'APG0_Invoice_Distributions',
               'AP_Invoice_Distributions',
               6,
               'Z$APG0_Invoice_Distributions',
               'AP_INVOICE_DISTRIBUTIONS_ALL',
               'IDSTR',
               'rowid',
               (select max(column_position)+1 from n_view_columns where view_name='APG0_Invoice_Distributions' and query_position=6),--1503,
               'GEN',
               'Join to Column -- use it only to join to other views Z$ columns. Internal Oracle rowid for table AP_INVOICE_DISTRIBUTIONS_ALL.',
               'APG0_Invoice_Distributions',
               'N',
               'G0',
               'N',
               (select COLUMN_ID from n_view_columns where  view_name= 'APG0_Invoice_Distributions' and query_position=6 and column_label='IDSTR$AP_Invoice_Distributions'),
               'Y');


UPDATE n_join_keys
   SET omit_flag = 'N'
 WHERE view_name = 'APG0_Invoice_Distributions'
       AND key_name LIKE 'ROWID_PK';

UPDATE n_join_key_columns
   SET column_name = 'Z$APG0_Invoice_Distributions'
 WHERE t_join_key_id =
          (SELECT T_JOIN_KEY_ID
             FROM n_join_keys
            WHERE view_name LIKE 'APG0_Invoice_Distributions'
                  AND key_name LIKE 'ROWID_PK');



commit; 


@utlspoff