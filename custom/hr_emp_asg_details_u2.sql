-- File Name: hr_emp_asg_details_u2.sql
--
-- Date Created: 30-09-2014
--
-- Purpose: Addition of Columns to the existing view HR_Emp_Asg_Details.
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

@utlspon hr_emp_asg_details_u2

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
   'HR_Emp_Asg_Details',
   1,
   'Emp_Assignment_ID',
   'ASG',
   'ASSIGNMENT_ID',
   78.1,
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
   'HR_Emp_Asg_Details',
   1,
   'Effective_End_Date_Stored',
   'ASG',
   'EFFECTIVE_END_DATE',
   79.1,
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
  ('HR_Emp_Asg_Details',
   'PK_Assign',
   'HR_Emp_Asg_Details view Primary Key for column_based join relation ships.',
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
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'PK_Assign' ;

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
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'PK_Assign' ;

-- Effective End Date Join

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
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'PK_Assign' ;

commit;

-----------------  For SI Type views join ------------------------------

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
  ('HR_Emp_Asg_Details',
   'PK_Emp',
   'HR_Emp_Asg_Details view Primary Key for column_based join relation ships (Employee_ID).',
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
   '',
   '',
   'NOETIX',
   SYSDATE,
   'sakula',
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
and col.column_label = 'Employee_ID'
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'PK_Emp' ;

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
and col.column_label = 'Emp_Effective_Start_Date'
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'PK_Emp' ;

-- Effective End Date Join

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
and col.column_label = 'Emp_Effective_End_Date'
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'PK_Emp' ;

commit;

---------------

@utlspoff