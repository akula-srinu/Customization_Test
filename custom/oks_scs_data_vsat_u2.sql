-- File Name: OKS_Scs_Data_Vsat_u2.sql
--
-- Date Created: 30-09-2014
--
-- Purpose: Addition of Columns and joins to the existing view OKS_Scs_Data_Vsat.
--
-- Requested By: Viasat.
--
-- Versions:
-- - Oracle EBS:R12
-- - Oracle DB:
-- - NoetixViews:6.3
--
-- Change History:
-- ===============
-- Date         Who            Comments
-- -----------  -------------  ---------
-- 13-11-2014	 Srinivas    Created. 
-- 06-May-2016		Selwyn		Reversed joins for upgrade

-- This file is called from wnoetxu2.sql

-- ****************************************************************************

-- output to .lst file

@utlspon OKS_Scs_Data_Vsat_u2


 --Primary Key join
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
  ('CSD_Serv_Diag_Code_Vsat',
   'PK_REP_LINE_PID',
   'CSD_Serv_Diag_Code_Vsat view Primary Key for column_based join relation ships.',
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
and col.column_label = 'Repair_Line_Id'
and key.view_label = 'CSD_Serv_Diag_Code_Vsat'
and key.key_name = 'PK_REP_LINE_PID' ;


-----------------

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
  ('OKS_Scs_Data_Vsat',
   'FK_REP_LINE_PID',
   'OKS_Scs_Data_Vsat view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'Y',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'CSD_Serv_Diag_Code_Vsat' and key_name = 'PK_REP_LINE_PID'),
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
and col.column_label = 'Repair_Line_Id'
and key.view_label = 'OKS_Scs_Data_Vsat'
and key.key_name = 'FK_REP_LINE_PID' ;

commit;


@utlspoff