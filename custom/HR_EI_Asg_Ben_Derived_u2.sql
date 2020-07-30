-- File Name: HR_EI_Asg_Ben_Derived_u2.sql
--
-- Date Created: 30-09-2014
--
-- Purpose: Addition of Columns and joins to the existing view HR_SI_Type.
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
-- 07-10-2014     Sakula    Created. 
-- 09-05-2016     Srinivas  Reversed the join metadata as part of NV upgrade.

-- This file is called from wnoetxu2.sql

-- ****************************************************************************

-- output to .lst file

@utlspon HR_EI_Asg_Ben_Derived_u2

-----------------  Suppress Existing Join ------------------------------

update n_join_key_templates a
set product_version = '9' 
where view_label like 'HR_EI_Asg_Ben_Derived'
and A.REFERENCED_PK_T_JOIN_KEY_ID in 
       (select t_join_key_id from n_join_key_templates a where view_label like 'HR_Emp_Asg_Details');

commit;


-----------------  For EI Type views join ------------------------------

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
  ('HR_EI_Asg_Ben_Derived',
   'PK_Emp1',
   'HR_EI_Asg_Ben_Derived view Primary Key for column_based join relation ships (Employee_ID).',
   '',
   'PK',
   'COL',
   '',
   '',
   2,
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
and col.column_label = 'Employee_ID'
and key.view_label = 'HR_EI_Asg_Ben_Derived'
and key.key_name = 'PK_Emp1' ;

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
and col.column_label = 'Emp_Effective_Start_Date'
and key.view_label = 'HR_EI_Asg_Ben_Derived'
and key.key_name = 'PK_Emp1' ;

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
select distinct t_join_key_id,
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
and key.view_label = 'HR_EI_Asg_Ben_Derived'
and key.key_name = 'PK_Emp1' ;

commit;

   -- Foreign key column for HR_Emp_Asg_Details to create col relationships
   
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
   'FK_EI_Asg_Ben',
   'HR_Emp_Asg_Details view Foreign Key for column label based join relationships.',
   '',
   'FK',
   'COL',
   'Y',
   '',
   2,
   '',
   '',
   'N',
   (SELECT T_JOIN_KEY_ID FROM N_JOIN_KEY_TEMPLATES where view_label = 'HR_EI_Asg_Ben_Derived' and key_name = 'PK_Emp1'),
   '*',
   '',
   'Y',
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
and col.column_label = 'Employee_ID'
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'FK_EI_Asg_Ben' ;

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
and col.column_label = 'Emp_Effective_Start_Date'
and key.view_label = 'HR_Emp_Asg_Details'
and key.key_name = 'FK_EI_Asg_Ben' ;

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
select distinct t_join_key_id,
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
and key.key_name = 'FK_EI_Asg_Ben' ;

commit;

@utlspoff