-- Title
--   ycrhxcv.sql
-- Function
--   create standalone view used in HXC_SS_Misssing_Timecards
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   09-Apr-09  Hatakesh  Created.
--                        (Issue 21941)
--   06-May-09  Hatakesh  Added missing filter to the view.
--                        (Issue 21941)
--   01-Apr-10  Hatakesh  Handling the new parameters added by the patch to the missing timecard function.
--                        (Issue 23549)
--   09-Mar-13  D Glancy  Use the new xxnao_hxc_wrapper_pkg.Has_HXC_115102_patch_flag Function
--                        to determine if HXC is patched.
--                        (Issue 31973)
--   29-Oct-13  D Glancy  EBS 12.2 support.
--                        (Issue 33617)
--   03-Jan-14  S Lakshminarayanan Use the new xxnao_hxc_wrapper_pkg.Has_HXC_115102_patch_flag Function
--                        to determine if HXC is patched.  However, it was not used correctly.  Need to check if the return value
--                        is set to Y to enable the patch.
--                        (Issue 33959)
--

@utlspon ycrhxcv

whenever sqlerror exit 452

DEFINE apps_userid       = 'APPS'
COLUMN s_apps_userid            new_value apps_userid           noprint
-- Determine the APPS user
SELECT max(oracle_username)    s_apps_userid
  FROM fnd_oracle_userid_s
 WHERE read_only_flag = 'U';
COLUMN s_apps_userid CLEAR

-- Determine if we are using HXC with patch for missing time periods
COLUMN c_hxc_115102_patch   NEW_VALUE hxc_115102_patch   NOPRINT
SELECT ( CASE COUNT(*)
           WHEN 0 THEN ' '
           ELSE ',  egc.entity_group_id, tr.time_recipient_id '
         END )                  c_hxc_115102_patch
  FROM dual
 WHERE &APPS_USERID..xxnao_hxc_wrapper_pkg.Has_HXC_115102_patch_flag = 'Y';
COLUMN c_hxc_115102_PATCH CLEAR

create or replace view n_hxc_missing_periods_v  as 
SELECT perd.start_time          start_date,
       perd.end_time            end_date, 
       ncal1.effective_date     date_from,
       ncal2.effective_date     date_to,
       asg.person_id            person_id,
       asg.assignment_id        assignment_id,
       asg.assignment_number    assignment_number,
       asg.effective_start_date assignment_eff_start_date,
       asg.effective_end_date   assignment_eff_end_date,
       asg.supervisor_id,
       asg.payroll_id,
       asg.organization_id,
       asg.location_id,
       asg.vendor_id,
       asg.effective_start_date,
       asg.effective_end_date,
       asg.position_id,
       asg.assignment_type,
       asg.business_group_id,
       tr.name application_name
  FROM per_all_assignments_f_s asg,
       noetix_calendar                   ncal1,
       noetix_calendar                   ncal2,
       hxc_entity_group_comps_s egc,
       hxc_time_recipients_s tr,
       TABLE( NOETIX_HXC_PKG.MISSING_TIME_PERIODS( ASG.PERSON_ID ,
                                                   ASG.ASSIGNMENT_ID,
                                                   NCAL1.EFFECTIVE_DATE,
                                                   NCAL2.EFFECTIVE_DATE
                                                   &HXC_115102_PATCH   ) ) PERD
 WHERE asg.assignment_type <> 'B'
   AND trunc( sysdate ) 
       BETWEEN asg.effective_start_date
           AND asg.effective_end_date
   AND asg.primary_flag     = 'Y'
   AND &APPS_USERID..XXNAO_HXC_WRAPPER_PKG.RETRIEVE_APPLICATION_ID( ASG.PERSON_ID ) 
                            = EGC.ENTITY_GROUP_ID
   AND egc.entity_type      = 'TIME_RECIPIENTS'
   AND tr.time_recipient_id = egc.entity_id;

-- dynamically create time category columns

-- execute NOETIX_HXC_PKG.POPULATE_TIME_CATEGORY_COLUMNS;

@utlspoff

undefine HXC_115102_PATCH
-- ycrhxcv.sql
