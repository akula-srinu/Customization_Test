-- File Name: qa_nmr_det_dispo_vsat_nmr_u2.sql
--
-- Date Created: 30-01-2015
--
-- Purpose: Addition of Columns and joins to the existing view QA_NMR_Det_Dispo_Vsat.
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
-- 31-01-2018     Srinivas    Created. 

-- This file is called from wnoetxu2.sql

-- ****************************************************************************

-- output to .lst file

@utlspon qa_nmr_det_dispo_vsat_nmr_u2


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
  ('QA_NMR_Det_Dispo_Vsat',
   'FK_QIR_NMR_DET_DISPO_ID',
   'QA_NMR_Det_Dispo_Vsat view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'Y',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'QA_NMR_Detail_Vsat' and key_name = 'PK_QIR_NMR_ID'),
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
and col.column_label = 'Occurrence'
and key.view_label = 'QA_NMR_Det_Dispo_Vsat'
and key.key_name = 'FK_QIR_NMR_DET_DISPO_ID' ;

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
2,
column_label,
NULL,
'NOETIX',
SYSDATE,
'NOETIX',
SYSDATE,
NULL
from n_view_column_templates col, n_join_key_templates key
where col.view_label = key.view_label
and col.column_label = 'Plan_ID'
and key.view_label = 'QA_NMR_Det_Dispo_Vsat'
and key.key_name = 'FK_QIR_NMR_DET_DISPO_ID' ;

commit;


@utlspoff