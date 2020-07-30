-- Title
--    wnoetx_CM_Schedule_Defaults.sql
-- Function
--    Sets the defaults for the CM Schedule.
--    These defaults are only necessary for the first time the CM schedule is setup.
--    If the application/user/schedule information is already setup, then the administrator 
--    must log on to the Oracle EBS system and change the values there.
--    It expected that this script will only be run from the w_secmgr_config_cm_schedule.sql script.
--
-- Description
--    Sets the defaults form the CM Schedule.
--    These defaults are only necessary for the first time the CM schedule is setup.
--    If the application/user/schedule information is already setup, then the administrator 
--    must log on to the Oracle EBS system and change the values there.
--    It expected that this script will only be run from the w_secmgr_config_cm_schedule.sql script.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   07-Feb-08 D Glancy   Copyrights.
--   06-Nov-08 D Glancy   Add some notes for a proper value for NAO_APPLICATION_SHORT_NAME.
--   19-Feb-09 R Raghudev Added a variable for global seg. 
--                        (Issue 21542)
--   13-Oct-09 D Glancy   Separated out the variables used for scheduling the Security Manager 
--                        and GSEG data cache refresh jobs.
--                        (Issue 21542)
--   10-May-10 R Vattikonda Added variables for scheduling GSEG data cache incremental refresh programs.
--                        (Issue 23770)
--   31-Mar-11 D Glancy   Change the default scheduling for the security manager scheduling job and the 
--                        Incremental refresh job for KFFs.
--   15-Apr-11 Srinivas   Added variables for scheduling Parent Child Flattened Segment Hierarchy table refresh programs.
--                        (Issue 25330)
--   08-Jun-11 D Glancy   Added nao_user_name variable.  Customer had requirements that the application short name of the
--                        program and responsiblities be different from the user that these CM jobs are assigned.
--
-- ---------------------- DEFINE NOETIX COMMON REPOSITORY APPLICATION ----------------------
--
-- The following variables can be updated by the user if it is necessary for their particular 
-- environements.
--
-- The NAO_APPLICATION_SHORT_NAME is used to define the application label and apps user name that
-- is used for the Noetix Administration Objects
-- NOTE:  This value should not be longer than 5 characters and should begin with 'XX' as it
-- should conform to oracle's standards for custom application names.
define nao_application_short_name   = "XXNAO"
-- The NAO_user_name is used to define the EBS user name that is used to use for scheduling concurrent 
-- Manager jobs for the Noetix Administration Objects.  This name can be different from the Application short Name
-- used to own the noetix jobs.  By default, we will use the application short name, but the user can
-- specify any user name they require.
define nao_user_name                = "VSAT_SCHEDULE"
--
-- The following allow the user to adjust the default schedule information.
-- These values are only used if the schedule does not exist.
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- NOTE:    The following are no longer used.  We have two separate sets of variables now.  
--          One for GSEG and one for the security manager.  Keeping these around because we may
--          have some hook script issues for testing.
--          May want to eventually deprecated these.
define nao_repeat_time              = ""
define nao_repeat_interval          = 1
-- VALID VALUES (MONTHS/DAYS/HOURS/MINUTES)
define nao_repeat_unit              = "DAYS"
define nao_seg_repeat_unit          = "MONTHS"
define nao_repeat_type              = "END"
define nao_repeat_end_time          = ""
define nao_increment_dates          = ""
define nao_start_time               = ""
-- END NOTE
---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----
-- Security Manager Job Scheduling
----
define nao_sm_repeat_time              = ""
define nao_sm_repeat_interval          = 1
-- VALID VALUES (MONTHS/DAYS/HOURS/MINUTES)
define nao_sm_repeat_unit              = "DAYS"
define nao_sm_repeat_type              = "END"
define nao_sm_repeat_end_time          = ""
define nao_sm_increment_dates          = ""
define nao_sm_start_time               = ""

----
-- GSEG Job scheduling
----
define nao_seg_repeat_time              = ""
define nao_seg_repeat_interval          = 1
-- VALID VALUES (MONTHS/DAYS/HOURS/MINUTES)
define nao_seg_repeat_unit              = "DAYS"
define nao_seg_repeat_type              = "END"
define nao_seg_repeat_end_time          = ""
define nao_seg_increment_dates          = ""
define nao_seg_start_time               = ""
--     These variables are used for scheduling incremental refresh program.
--     These variables are used in utility package.
define nao_incr_seg_repeat_interval     = 1
define nao_incr_seg_repeat_unit         = "DAYS"
define nao_incr_seg_repeat_type         = "END"


----
-- Parent Child Job scheduling
----

define nao_hier_repeat_time              = ""
define nao_hier_repeat_interval          = 1
-- VALID VALUES (MONTHS/DAYS/HOURS/MINUTES)
define nao_hier_repeat_unit              = "MONTHS"
define nao_hier_repeat_type              = "END"
define nao_hier_repeat_end_time          = ""
define nao_hier_increment_dates          = ""
define nao_hier_start_time               = ""

--
-- Following are necessary to add responsibilty to user
-- If the user name or the responsibility key does not exist, then the 
-- user can update the following to correct the initialization of the 
-- CM Jobs.
define nao_sys_user_name            = 'SYSADMIN'
define nao_sys_resp_key             = 'SYSTEM_ADMINISTRATOR'
--
--------------------------------------------------------------------------------
--

-- end wnoetx_repository_defaults.sql
