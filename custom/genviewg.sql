-- Title
--    genviewg.sql
-- Function
--    Generate global views from the Noetix tables
-- Description
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   01-Feb-06 D Glancy   Created to support new global role.
--                        (Issue 15240)
--   25-APR-06 D Glancy   Update sqlerror number to make it unique.
--   14-Sep-06 P Vemuru   Changed the update script assigning omit_flag to Y for Non Base view by commenting "BASEVIEW" line
--   30-Nov-06 D Glancy   Do not set the omit_flag to 'Y' anymore for base views.
--                        (Issue 12031)
--   20-Feb-09 S Vital    Added code to consider global SEG views for global processing 
--                        (Issue 21542)
--   21-Jun-11 D Glancy   Added new XXHIE application for global parent child hierarchies.
--   31-Mar-15 Madhu V    modified the code to process the installation for NVA as well as IR process. (NV-465)
--	 31-Mar-15 Madhu V    NVA_IR_FLAG parameter will check for NVA or IR installation if the parameter NVA_IR_FLAG =NVA then the code will run for the NVA installation 
--						  if the NVA_IR_FLAG=IR then the code will run for the IR installation.(NV-465)
--
--

@utlspon genviewg
set linesize  132
set arraysize 100
set recsep    off

whenever sqlerror exit 421
begin
if ('&NVA_IR_FLAG'!='IR') then
-- NVA_IR_FLAG flag will check for NVA installation condition
dbms_output.put_line('Executing NON-IR Process');
INSERT INTO n_to_do_views
     ( view_name, 
       session_id, 
       creation_date, 
       last_update_date )
SELECT v.view_name, 
       USERENV ('sessionid'), 
       SYSDATE, 
       SYSDATE
  FROM n_views v
 WHERE v.application_label in  ( 'XXKFF', 'XXHIE' )
   AND NVL(v.omit_flag,'N') = 'N';
commit;

-- ----------------------- Added by Srini ---------------------------

/*

delete from  n_to_do_views todo
where 1=1
and todo.view_name in 
(
'POG0_SOX_WO_Open_POs_Vsat',
'INVG0_SOX_Onhand_Quantities_Vs',
'INVG0_SOX_Cycle_Count_Apprv_Vs',
'WIPG0_SOX_Routing_Resources',
'GLG0_SOX_All_Je_Lines',
'POG0_SOX_Receipts_Vsat'
);

commit;

*/

-- ----------------------- Added by Srini ---------------------------

n_genview_proc1('GLOBAL');
commit;
else
-- NVA_IR_FLAG flag is going for the IR installation
dbms_output.put_line('IR-PROCESS: In Process');
n_genview_incr_proc1('GLOBAL');
commit;
end if;
end;
/

--
--
@utlprmpt "Add 'Create View' statements to the mkviewg.sql file (Global Extension Views) "
--
--
--  Views have been generated into n_buffer
--  now select the text and store it into a sqlplus file
--
--
-- set arraysize to 1
--
set arraysize &default_arraysize
@utlspoff
--
-- spool output to temp file for later execution 
--
column text format a80 
@utlspsql 80 mkviewg 
--
-- select view output generated from pl/sql 
--
-- chr(1) embedded in text is put there by look.sql
-- replace it with a double quote so it will get picked up
-- properly when the mkview.sql script is run
--
prompt set scan off
select rtrim(text) from n_buffer 
 where session_id = userenv('SESSIONID')
 order by line_number
;
prompt set scan on
spool off
--
-- rollback rows inserted in pl/sql 
--
--prompt 'rollback n_buffer'
--rollback;
--set termout on
prompt 'delete from n_buffer'
--delete from n_buffer where session_id = userenv('SESSIONID');
truncate table n_buffer;

--
-- generate the views written to the temp file 
-- and save the log file
--
-- turn off scanning for substitutions in case ampersand is in coded values
--
@utlstrtm mkviewg continue

set recsep   wrapped
--
-- set omit flag to prevent NOETIX owned views from
-- getting into help or being directly granted to the roles
-- 
-- NOTE:  I don't think we generate any views with an application label of NOETIX anymore,
--        so I think this can be deprecated.  Adding bug to do further analysis.
--
update n_views
   set omit_flag            = 'Y'
 where application_label    = 'NOETIX'
--   and not exists                           
--     ( select 'xo' 
--         from n_application_owners
--        where substr(application_instance,1,1) in ( 'G', 'X' )
--          and rownum = 1 )
;

commit;
--
-- end genviewg.sql
