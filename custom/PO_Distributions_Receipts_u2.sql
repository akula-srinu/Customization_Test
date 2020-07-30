@utlspon PO_Distributions_Receipts_u2

insert into n_join_key_templates 
  (VIEW_LABEL,
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
  ('PO_Receipts_Vsat',
   'PK_DIST_PID',
   'PO_Receipts_Vsat view Primary Key for column_based join relation ships.',
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
   SYSDATE,
   'Sakula',
   SYSDATE,
   null);
   
insert into N_JOIN_KEY_COL_TEMPLATES (T_JOIN_KEY_ID,
  T_COLUMN_POSITION, 
  COLUMN_LABEL, 
  KFF_TABLE_PK_COLUMN_NAME, 
  CREATED_BY, 
  CREATION_DATE, 
  LAST_UPDATED_BY, 
  LAST_UPDATE_DATE, 
  VERSION_ID)
select distinct t_join_key_id,
1,
column_label,
NULL,
'NOETIX',
SYSDATE,
'NOETIX',
SYSDATE,
NULL
from n_view_column_templates col, n_join_key_templates key
where col.view_label = key.view_label
and col.column_label = 'Distribution_Id'
and key.view_label = 'PO_Receipts_Vsat'
and key.key_name = 'PK_DIST_PID' ;


commit;


insert into n_join_key_templates
  (VIEW_LABEL,
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
  ('PO_All_Distribution_Vsat',
   'FK_DIST_RCPT_PID',
   'PO_All_Distribution_Vsat view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'Y',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'PO_Receipts_Vsat' and key_name = 'PK_DIST_PID'),
   '*',
   '',
   'Y',
   '',
   'NOETIX',
   SYSDATE,
   'Sakula',
   SYSDATE,
   null);
   
 insert into N_JOIN_KEY_COL_TEMPLATES (T_JOIN_KEY_ID,
  T_COLUMN_POSITION, 
  COLUMN_LABEL, 
  KFF_TABLE_PK_COLUMN_NAME, 
  CREATED_BY, 
  CREATION_DATE, 
  LAST_UPDATED_BY, 
  LAST_UPDATE_DATE, 
  VERSION_ID)
select 
distinct
t_join_key_id,
1,
column_label,
NULL,
'NOETIX',
SYSDATE,
'NOETIX',
SYSDATE,
NULL
from n_view_column_templates col, n_join_key_templates key
where col.view_label = key.view_label
and col.column_label = 'Distribution_Id'
and key.view_label = 'PO_All_Distribution_Vsat'
and key.key_name = 'FK_DIST_RCPT_PID' ;

commit;

@utlspoff


