-- *******************************************************************************
-- FileName:  BNV1646.sql
--
-- Change History
--    20-JUN-2016  Venkat 
--
--
--
-- *******************************************************************************
-- output to BNV1646.lst file

@utlspon BNV1646

update  n_view_column_templates
set product_Version=9
 where view_label like 'AP_Invoice_Distributions'
   and column_type  like 'ROWID'
   and column_label like 'IDSTR$AP_Invoice_Distributions';

   update  n_view_column_templates
set product_Version=9
 where view_label like 'PO_Invoice_Payments'
   and column_type  like 'ROWID'
   and column_label like 'IDSTR$AP_Invoice_Distributions';
   
   update  n_view_column_templates
set product_Version=9
 where view_label like 'PO_Invoices'
   and column_type  like 'ROWID'
   and column_label like 'IDSTR$AP_Invoice_Distributions';


insert into n_join_key_templates
  (   VIEW_LABEL,
   KEY_NAME,
   DESCRIPTION,
   JOIN_KEY_CONTEXT_CODE,
   KEY_TYPE_CODE,
   COLUMN_TYPE_CODE,
   OUTERJOIN_FLAG,
   OUTERJOIN_DIRECTION_CODE,
   KEY_RANK,
   PL_REF_PK_VIEW_NAME_MODIFIER,
   PL_ROWID_COL_NAME_MODIFIER,
   KEY_CARDINALITY_CODE,
   REFERENCED_PK_T_JOIN_KEY_ID,
   PRODUCT_VERSION,
   PROFILE_OPTION,
   INCLUDE_FLAG,
   USER_INCLUDE_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   VERSION_ID)
values
  (   'AP_Invoice_Distributions',
   'PK1',
   ' AP_Invoice_Distributionsview Primary Key for column label based join relationships.',
   '',
   'PK',
   'COL',
   '',
   '',
   1,
   '',
   '',
   '1',
   null,
   '*',
   '',
   'Y',
   '',
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('10-06-2013', 'dd-mm-yyyy'),
   null);

   
   

insert into n_join_key_col_templates
  (T_JOIN_KEY_ID,
   T_COLUMN_POSITION,
   COLUMN_LABEL,
   KFF_TABLE_PK_COLUMN_NAME,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   VERSION_ID)
values
  ((select T_JOIN_KEY_ID from n_join_key_templates where view_label ='AP_Invoice_Distributions' and KEY_TYPE_CODE ='PK' and COLUMN_TYPE_CODE='COL'),
   1,
   'Invoice_Distribution_ID',
   '',
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   null);
   

   insert into n_view_column_templates
  (VIEW_LABEL,
   QUERY_POSITION,
   COLUMN_LABEL,
   TABLE_ALIAS,
   COLUMN_EXPRESSION,
   COLUMN_POSITION,
   COLUMN_TYPE,
   DESCRIPTION,
   REF_APPLICATION_LABEL,
   REF_TABLE_NAME,
   KEY_VIEW_LABEL,
   REF_LOOKUP_COLUMN_NAME,
   REF_DESCRIPTION_COLUMN_NAME,
   REF_LOOKUP_TYPE,
   ID_FLEX_APPLICATION_ID,
   ID_FLEX_CODE,
   GROUP_BY_FLAG,
   FORMAT_MASK,
   FORMAT_CLASS,
   GEN_SEARCH_BY_COL_FLAG,
   LOV_VIEW_LABEL,
   LOV_COLUMN_LABEL,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   INCLUDE_FLAG,
   USER_INCLUDE_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE)
values
  ('PO_Invoice_Payments',
   1,
   'Invoice_Distribution_ID',
   'IDSTR',
   'INVOICE_DISTRIBUTION_ID',
   114,
   'COL',
   'Invoice distribution identifier.',
   '',
   '',
   '',
   '',
   '',
   '',
   null,
   '',
   'N',
   '',
   'NUMERIC INTEGER',
   'N',
   '',
   '',
   '',
   '*',
   'Y',
   '',
   'NOETIX',
   to_date('11-08-2015', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('11-08-2015', 'dd-mm-yyyy'));
   
   
insert into n_join_key_templates
  (   VIEW_LABEL,
   KEY_NAME,
   DESCRIPTION,
   JOIN_KEY_CONTEXT_CODE,
   KEY_TYPE_CODE,
   COLUMN_TYPE_CODE,
   OUTERJOIN_FLAG,
   OUTERJOIN_DIRECTION_CODE,
   KEY_RANK,
   PL_REF_PK_VIEW_NAME_MODIFIER,
   PL_ROWID_COL_NAME_MODIFIER,
   KEY_CARDINALITY_CODE,
   REFERENCED_PK_T_JOIN_KEY_ID,
   PRODUCT_VERSION,
   PROFILE_OPTION,
   INCLUDE_FLAG,
   USER_INCLUDE_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   VERSION_ID)
values
  (   'PO_Invoice_Payments',
   'FK-Invoice_Distribution_ID',
   ' PO_Invoice_Payments view Foregin Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   '',
   '',
   1,
   '',
   '',
   '1',
   (select T_JOIN_KEY_ID from n_join_key_templates where view_label ='AP_Invoice_Distributions' and KEY_TYPE_CODE ='PK' and COLUMN_TYPE_CODE='COL'),
   '*',
   '',
   'Y',
   '',
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('10-06-2013', 'dd-mm-yyyy'),
   null);
   
   insert into n_join_key_col_templates
  (T_JOIN_KEY_ID,
   T_COLUMN_POSITION,
   COLUMN_LABEL,
   KFF_TABLE_PK_COLUMN_NAME,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   VERSION_ID)
values
  ((select T_JOIN_KEY_ID from n_join_key_templates where view_label ='PO_Invoice_Payments' and KEY_TYPE_CODE ='FK' and COLUMN_TYPE_CODE='COL'),
   1,
   'Invoice_Distribution_ID',
   '',
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   null);
   
   
   insert into n_view_column_templates
  (VIEW_LABEL,
   QUERY_POSITION,
   COLUMN_LABEL,
   TABLE_ALIAS,
   COLUMN_EXPRESSION,
   COLUMN_POSITION,
   COLUMN_TYPE,
   DESCRIPTION,
   REF_APPLICATION_LABEL,
   REF_TABLE_NAME,
   KEY_VIEW_LABEL,
   REF_LOOKUP_COLUMN_NAME,
   REF_DESCRIPTION_COLUMN_NAME,
   REF_LOOKUP_TYPE,
   ID_FLEX_APPLICATION_ID,
   ID_FLEX_CODE,
   GROUP_BY_FLAG,
   FORMAT_MASK,
   FORMAT_CLASS,
   GEN_SEARCH_BY_COL_FLAG,
   LOV_VIEW_LABEL,
   LOV_COLUMN_LABEL,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   INCLUDE_FLAG,
   USER_INCLUDE_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE)
values
  ('PO_Invoices',
   2,
   'Invoice_Distribution_ID',
   'IDSTR',
   'INVOICE_DISTRIBUTION_ID',
   114,
   'COL',
   'Invoice distribution identifier.',
   '',
   '',
   '',
   '',
   '',
   '',
   null,
   '',
   'N',
   '',
   'NUMERIC INTEGER',
   'N',
   '',
   '',
   '',
   '*',
   'Y',
   '',
   'NOETIX',
   to_date('11-08-2015', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('11-08-2015', 'dd-mm-yyyy'));
 
 
 insert into n_join_key_templates
  (   VIEW_LABEL,
   KEY_NAME,
   DESCRIPTION,
   JOIN_KEY_CONTEXT_CODE,
   KEY_TYPE_CODE,
   COLUMN_TYPE_CODE,
   OUTERJOIN_FLAG,
   OUTERJOIN_DIRECTION_CODE,
   KEY_RANK,
   PL_REF_PK_VIEW_NAME_MODIFIER,
   PL_ROWID_COL_NAME_MODIFIER,
   KEY_CARDINALITY_CODE,
   REFERENCED_PK_T_JOIN_KEY_ID,
   PRODUCT_VERSION,
   PROFILE_OPTION,
   INCLUDE_FLAG,
   USER_INCLUDE_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   VERSION_ID)
values
  (   'PO_Invoices',
   'FK-Invoice_Distribution_ID',
   ' PO_Invoices view Foregin Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   '',
   '',
   1,
   '',
   '',
   '1',
   (select T_JOIN_KEY_ID from n_join_key_templates where view_label ='AP_Invoice_Distributions' and KEY_TYPE_CODE ='PK' and COLUMN_TYPE_CODE='COL'),
   '*',
   '',
   'Y',
   '',
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('10-06-2013', 'dd-mm-yyyy'),
   null);
   
   insert into n_join_key_col_templates
  (T_JOIN_KEY_ID,
   T_COLUMN_POSITION,
   COLUMN_LABEL,
   KFF_TABLE_PK_COLUMN_NAME,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   VERSION_ID)
values
  ((select T_JOIN_KEY_ID from n_join_key_templates where view_label ='PO_Invoices' and KEY_TYPE_CODE ='FK' and COLUMN_TYPE_CODE='COL'),
   1,
   'Invoice_Distribution_ID',
   '',
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   'NOETIX',
   to_date('14-11-2012', 'dd-mm-yyyy'),
   null);
   
@utlspoff 