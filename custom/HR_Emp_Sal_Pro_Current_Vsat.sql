@utlspon HR_Emp_Sal_Pro_Current_Vsat

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
  ('HR_Reports_Cost_Centers_Vsat',
   'PK_CC_ROW_ID',
   'HR_Reports_Cost_Centers_Vsat view Primary Key for column_based join relation ships.',
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
select t_join_key_id,
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
and col.column_label = 'Z_COST_CENTER'
and key.view_label = 'HR_Reports_Cost_Centers_Vsat'
and key.key_name = 'PK_CC_ROW_ID' ;

commit;

-----------


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
  ('HR_Reports_Focal_Months_Vsat',
   'PK_FM_ROW_ID',
   'HR_Reports_Focal_Months_Vsat view Primary Key for column_based join relation ships.',
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
select t_join_key_id,
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
and col.column_label = 'Z_FOCAL_MONTH'
and key.view_label = 'HR_Reports_Focal_Months_Vsat'
and key.key_name = 'PK_FM_ROW_ID' ;

commit;

-----------------------

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
  ('HR_Reports_Locations_Vsat',
   'PK_LOC_ROW_ID',
   'HR_Reports_Locations_Vsat view Primary Key for column_based join relation ships.',
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
select t_join_key_id,
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
and col.column_label = 'Z_ENG_LOC'
and key.view_label = 'HR_Reports_Locations_Vsat'
and key.key_name = 'PK_LOC_ROW_ID' ;

commit;

------------------

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
  ('HR_Emp_Sal_Pro_Current_Vsat',
   'FK_CC_ROW_ID',
   'HR_Emp_Sal_Pro_Current_Vsat view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'N',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'HR_Reports_Cost_Centers_Vsat' and key_name = 'PK_CC_ROW_ID'),
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
select t_join_key_id,
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
and col.column_label = 'Z_COST_CENTER'
and key.view_label = 'HR_Emp_Sal_Pro_Current_Vsat'
and key.key_name = 'FK_CC_ROW_ID' ;

commit;

---------------

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
  ('HR_Emp_Sal_Pro_Current_Vsat',
   'FK_FM_ROW_ID',
   'HR_Emp_Sal_Pro_Current_Vsat view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'N',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'HR_Reports_Focal_Months_Vsat' and key_name = 'PK_FM_ROW_ID'),
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
select t_join_key_id,
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
and col.column_label = 'Z_FOCAL_MONTH'
and key.view_label = 'HR_Emp_Sal_Pro_Current_Vsat'
and key.key_name = 'FK_FM_ROW_ID' ;

commit;

----------

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
  ('HR_Emp_Sal_Pro_Current_Vsat',
   'FK_LOC_ROW_ID',
   'HR_Emp_Sal_Pro_Current_Vsat view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'N',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'HR_Reports_Locations_Vsat' and key_name = 'PK_LOC_ROW_ID'),
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
select t_join_key_id,
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
and col.column_label = 'Z_ENG_LOC'
and key.view_label = 'HR_Emp_Sal_Pro_Current_Vsat'
and key.key_name = 'FK_LOC_ROW_ID' ;

commit;

@utlspoff