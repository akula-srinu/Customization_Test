-- File Name: hr_emp_sal_pro_current_u2.sql
--
-- Date Created: 30-09-2014
--
-- Purpose: Addition of Columns and joins to the existing view HR_Emp_Sal_Pro_Current.
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
-- 30-09-2014	 Speddireddy    Created. 

-- This file is called from wnoetxu2.sql

-- ****************************************************************************

-- output to .lst file

@utlspon hr_emp_sal_pro_current_u2

INSERT INTO N_VIEW_COLUMN_TEMPLATES (
   VIEW_LABEL,
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
   GROUP_BY_FLAG,
   FORMAT_MASK,
   FORMAT_CLASS,
   GEN_SEARCH_BY_COL_FLAG,
   LOV_VIEW_LABEL,
   LOV_COLUMN_LABEL,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE
 ) VALUES (
   'HR_Emp_Sal_Pro_Current',
   1,
   'Emp_Assignment_ID',
   'ASG',
   'ASSIGNMENT_ID',
   97.1,
   'COL',
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   'N',
   null,
   'STRING',
   'N',
   null,
   null,
   null,
   '%',
   'Speddireddy',
   SYSDATE,
   'Speddireddy',
   SYSDATE );
   

      
-- Foreign key column for HR_Emp_Sal_Pro_Current to create col relationships
   
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
  ('HR_Emp_Sal_Pro_Current',
   'FK_Assign',
   'HR_Emp_Sal_Pro_Current view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'N',
   '',
   1,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'HR_Emp_Asg_Details' and key_name = 'PK_Assign'),
   '*',
   '',
   'Y',
   '',
   'NOETIX',
   SYSDATE,
   'Speddireddy',
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
and col.column_label = 'Emp_Assignment_ID'
and key.view_label = 'HR_Emp_Sal_Pro_Current'
and key.key_name = 'FK_Assign' ;

-- Effective Start Date Column
  
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
and col.column_label = 'Effective_Start_Date'
and key.view_label = 'HR_Emp_Sal_Pro_Current'
and key.key_name = 'FK_Assign' ;

-- Effective End Date Column
 
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
3,
column_label,
NULL,
'NOETIX',
SYSDATE,
'NOETIX',
SYSDATE,
NULL
from n_view_column_templates col, n_join_key_templates key
where col.view_label = key.view_label
and col.column_label = 'Effective_End_Date_Stored'
and key.view_label = 'HR_Emp_Sal_Pro_Current'
and key.key_name = 'FK_Assign' ;

commit;

@utlspoff