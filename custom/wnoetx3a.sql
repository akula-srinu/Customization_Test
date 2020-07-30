-- Title                                                      
--   wnoetx3a.sql                                                 
--   @(#)wnoetx3a.sql                       
-- Function                                                   
--   @(#) Update N_USER_FORMAT_DEFAULTS table with custom format masks. 
-- Description                                                
--   The table has following columns
--      Format_Class  -- for format class        
--      Sys_Default_Format_Mask 
--      User_Default_Format_Mask
--   Each row in the table is for a format class and it has 
--   system defined format masks. Use the following update statemets
--   to update the default format mask, by changing the value in the
--   set statement.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History                                                    
--   23-Mar-01 R Kompella Created.
--   04-May-01 R Lowe     Update date and time formats to be acceptable
--                        SQL Server (NWQ) formats.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   17-Jul-03 D Glancy   Clean up the variables defined in this script upon exit.
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--
--
define n_create_table = 'N_USER_FORMAT_DEFAULTS'
column s_n_sys_user new_value n_sys_user noprint
select upper(user)   s_n_sys_user
from dual;
 
UPDATE &n_create_table
set user_default_format_mask='#,##0.00'
where format_class='Numeric Real';

UPDATE &n_create_table
set user_default_format_mask='#,##0'
where format_class='Numeric Integer';

UPDATE &n_create_table
set user_default_format_mask='$#,##0.00'
where format_class='Numeric Amount';

UPDATE &n_create_table
set user_default_format_mask='MM/dd/yyyy'
where format_class='Date';

UPDATE &n_create_table
set user_default_format_mask='hh:mm:ss'
where format_class='Time';

commit;

undefine N_CREATE_TABLE
undefine N_SYS_USER

-- end wnoetx3a.sql
