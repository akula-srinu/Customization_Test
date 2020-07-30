-- Title
--   w_parentchild_config_cm_schedule.sql
--
-- Called By
--  xgenall3.sql
-- Function
--   Creating a concurrent program for total or full refresh of flattened segment hierarchy table 
--   as part of parent child hierarchy processing.
-- Description
--   1.Build the concurrent program, executable for refreshing the flattened segment hierarchy table 
--   2.Create a request set and add the above concurrent program to the request set.
--
-- Parameters
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   15-Apr-11   Srinivas       Created (Issue 25330)
--   17-May-11   D Glancy     Grant execute on the package used by the concurrent manager to the APPS userid.
--                            (Issue 23681)  
--   08-Jun-11   D Glancy     Added nao_user_name variable to defaults.  Customer had requirements that the application short name of the
--                            program and responsiblities be different from the user that these CM jobs are assigned.
--   17-Feb-12 D Glancy       Use wprivs instead of the direct grant.
--                            (Issue 29004)
--   24-Feb-12 D Glancy       Using a new routine called n_grant_object_access.  This routine does not set/reset env settings.
--                            Based on the old wprivs.sql command.
--                            (Issue 29004)
--

set linesize 120
set termout  off
set feedback off
set verify   off
set echo     off

DEFINE APPS_USERID = 'APPS'
COLUMN C_APPS_USERID    new_value APPS_USERID    noprint
SELECT distinct 
       ou.oracle_username           C_APPS_USERID
  FROM fnd_oracle_userid_s  ou
 WHERE ou.read_only_flag = 'U'
   AND rownum         = 1;

DEFINE NOETIX_USER_ID_NUM = "0"
COLUMN C_NOETIX_USER_ID_NUM new_value NOETIX_USER_ID_NUM noprint
SELECT TO_CHAR(u.user_id) C_NOETIX_USER_ID_NUM
  FROM sys.all_users u
 WHERE u.username = user
   AND rownum     = 1;
   
-- 
-- The NAO_APPLICATION_SHORT_NAME variable (defined in the wnoetx_cm_schedule_defaults) is used to define the 
-- default application short name, which is also used as the default Oracle EBS user  The default Oracle EBS user
-- is associated with the application.  If you need to update this default, then
-- you must update the wnoetx_cm_schedule_defaults script to have the expected name.
--
--
-- Update the default application short name and aol user name for the repository setup process.
-- You can also update schedule related information
start wnoetx_cm_schedule_defaults

COLUMN init_long_name           NEW_VALUE init_long_name            NOPRINT
COLUMN init_short_name          NEW_VALUE init_short_name           NOPRINT
COLUMN init_execution_file_name NEW_VALUE init_execution_file_name  NOPRINT
COLUMN noetix_sys_user          NEW_VALUE p_noetix_admin            NOPRINT

define nao_application_name         = "Noetix Administration Objects"
define nao_application_base_path    = "&NAO_APPLICATION_SHORT_NAME._TOP"
define nao_user_name                = "&NAO_USER_NAME"
define nao_user_password            = "Welcome#1"
define nao_responsibility_name      = "&NAO_APPLICATION_NAME (&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])"
define nao_responsibility_key       = "&NAO_APPLICATION_SHORT_NAME..NOETIX(UID-&NOETIX_USER_ID_NUM)"
define nao_security_group_key       = "STANDARD"
define nao_menu_name                = "&NAO_APPLICATION_SHORT_NAME Menu"
define nao_menu_type                = "STANDARD"
define nao_menu_entry_function1     = 'FND_FNDRSRUN'
define nao_menu_entry_prompt1       = 'Submit Requests'
define nao_menu_entry_desc1         = 'Submit Requests for the &NAO_APPLICATION_NAME Application'
define nao_menu_entry_function2     = 'FND_FNDCPQCR'
define nao_menu_entry_prompt2       = 'View Requests'
define nao_menu_entry_desc2         = 'View Requests for the &NAO_APPLICATION_NAME Application'
define nao_request_group_name       = "&NAO_APPLICATION_NAME"
define nao_data_group_name          = "Standard"
define nao_schema_name              = "&NOETIX_USER"

define nao_submit_description       = "Noetix Segment Flattened Table Refresh (&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])"
define nao_hier_responsibility_name  = "&NAO_APPLICATION_NAME..HIER(&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])"
define nao_hier_responsibility_key   = "&NAO_APPLICATION_SHORT_NAME..HIER-NOETIX(UID-&NOETIX_USER_ID_NUM)"
define nao_hier_request_group_name   = "&NAO_APPLICATION_SHORT_NAME._HIER"
define nao_hier_cm_out_file          = "w_parentchild_config_cm_schedule"

define nao_executable_name          = "Noetix Segment Hierarchy Table Refresh (&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])"
define nao_executable_short_name    = "&NAO_APPLICATION_SHORT_NAME..LOADFLAT(UID-&NOETIX_USER_ID_NUM)"
define nao_execution_file_name      = "&NOETIX_USER..n_parentchild_pkg.n_hier_proc"

define nao_oracle_username          = '&APPS_USERID'

set termout off

column c_old_lang         new_value old_lang         noprint
column c_old_language     new_value old_language     noprint
column c_install_language new_value install_language noprint

SELECT USERENV('LANG')      c_old_lang,
       fl.nls_language      c_old_language
  FROM fnd_languages_s fl
 WHERE fl.language_code = USERENV('LANG');
 
SELECT fl.nls_language  c_install_language
  FROM fnd_languages_s fl
 WHERE fl.language_code = '&NOETIX_LANG';

-- change the language temporarily
begin
    if ( '&OLD_LANG' <> '&NOETIX_LANG' ) then
        execute immediate 'alter session set NLS_LANGUAGE = ''&INSTALL_LANGUAGE''';
    end if;
end;
/

start utlspon &NAO_HIER_CM_OUT_FILE 

-- Grant execute on the package used by the concurrent manager to the APPS userid.
set serveroutput on size 1000000
execute n_grant_object_access( 'EXECUTE',   '&NOETIX_USER', 'N_PARENTCHILD_PKG',           '&APPS_USERID' )

DECLARE
    lb_applicationExists    BOOLEAN;
    lb_menu_exists          BOOLEAN;
    lb_menu_entry_exists    BOOLEAN;
    lb_menu_entry_added     BOOLEAN   := FALSE;
    lb_req_group_exists     BOOLEAN;
    lb_resp_exists          BOOLEAN;
    lb_user_exists          BOOLEAN;
    lb_executable_exists    BOOLEAN;
    lv_program_exists       VARCHAR2(1);
    lb_program_in_group     BOOLEAN;
    lv_schedule_exists      VARCHAR2(1);
    lv_compatability_exists BOOLEAN;
    lv_compile_menu         VARCHAR2(2000);
    lc_Schedule_Program     CHAR;
    ln_request_id           NUMBER;
    lc_process_type  CONSTANT VARCHAR2(100) := 'HIER'; 
BEGIN

    IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN 
        dbms_output.enable(NULL);
    ELSE
        dbms_output.enable(1000000);
    END IF;

    savepoint begin_cmschedule;
    dbms_output.put_line( '**' );
    dbms_output.put_line('Creating Executable - "&NAO_EXECUTABLE_NAME"');

    BEGIN
        lb_executable_exists := &APPS_USERID..xxnao_conc_manager_pkg.executable_Exists
                        ( i_short_name    => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                          i_application   => '&NAO_APPLICATION_SHORT_NAME'       );

        IF ( NOT lb_executable_exists ) THEN
            &APPS_USERID..xxnao_conc_manager_pkg.create_executable  
                ( i_executable            => '&NAO_EXECUTABLE_NAME',
                  i_application           => '&NAO_APPLICATION_SHORT_NAME',
                  i_short_name            => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                  i_description           => '&NAO_EXECUTABLE_NAME',
                  i_execution_method      => 'PL/SQL Stored Procedure',
                  i_execution_file_name   => '&NAO_EXECUTION_FILE_NAME',
                  i_execution_file_path   => NULL,
                  i_subroutine_name       => NULL);
        ELSE
            dbms_output.put_line('NOTE:  Executable "&NAO_EXECUTABLE_NAME" already exists');        
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            rollback to begin_cmschedule;
            dbms_output.put_line('WARNING:  Unable to create the Executable "&NAO_EXECUTABLE_NAME"');
            noetix_utility_pkg.Add_Installation_Message( 'w_parentchild_config_cm_schedule',
                                                         'Create_exectutable',
                                                         'WARNING',
                                                         'Unable to create the Executable "&NAO_EXECUTABLE_NAME" - '||
                                                         sqlerrm,
                                                         sysdate,
                                                         lc_process_type);
            raise;
    END;

    dbms_output.put_line( '**' );
    dbms_output.put_line( 'Creating Concurrent Program for "&NAO_EXECUTABLE_NAME"' );

    BEGIN

        -- Even through we are using i_program as the parameter for the program_exists function call,
        -- It actually requires the short name of the program.
        lv_program_exists := &APPS_USERID..xxnao_conc_manager_pkg.Program_Exists( i_program        => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                                                                                  i_application    => '&NAO_APPLICATION_SHORT_NAME' ) ;

        IF ( lv_program_exists = 'N' ) THEN
            -- The i_program parameter for create_conc_program requires the executable long name (not the short name).
            &APPS_USERID..xxnao_conc_manager_pkg.create_conc_program ( 
                    i_program                => '&NAO_EXECUTABLE_NAME',
                    i_application            => '&NAO_APPLICATION_SHORT_NAME',
                    i_enabled                => 'Y',
                    i_short_name             => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                    i_description            => '&NAO_EXECUTABLE_NAME',
                    i_executable_short_name  => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                    i_executable_application => '&NAO_APPLICATION_SHORT_NAME',
                    i_use_in_srs             => 'Y');

        ELSE
            dbms_output.put_line('NOTE:  Concurrent Program &NAO_EXECUTABLE_NAME already exists');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            rollback to begin_cmschedule;
            dbms_output.put_line('WARNING:  Unable to create the Concurrent Program &NAO_EXECUTABLE_NAME');
            noetix_utility_pkg.Add_Installation_Message( 'w_parentchild_config_cm_schedule',
                                                         'Create_exectutable',
                                                         'WARNING',
                                                         'Unable to create the Concurrent Program &NAO_EXECUTABLE_NAME - '||
                                                         sqlerrm,
                                                         sysdate,
                                                         lc_process_type);
            raise;
    END;
    dbms_output.put_line( '**' );
    ----
    ----
    dbms_output.put_line( 'Adding Concurrent Program to Request Group for "&NAO_EXECUTABLE_NAME"' );

    BEGIN
        lb_program_in_group := &APPS_USERID..xxnao_conc_manager_pkg.program_in_group
                        ( i_program_short_name    => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                          i_program_application   => '&NAO_APPLICATION_SHORT_NAME',
                          i_request_group         => '&NAO_HIER_REQUEST_GROUP_NAME',
                          i_group_application     => '&NAO_APPLICATION_SHORT_NAME');
        
        IF ( NOT lb_program_in_group ) THEN
            &APPS_USERID..xxnao_conc_manager_pkg.add_program_to_group 
                ( i_program_short_name   => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                  i_program_application  => '&NAO_APPLICATION_SHORT_NAME',
                  i_request_group        => '&NAO_HIER_REQUEST_GROUP_NAME',
                  i_group_application    => '&NAO_APPLICATION_SHORT_NAME' );
        ELSE
            dbms_output.put_line('NOTE:  Concurrent Program '|| Upper('&NAO_EXECUTABLE_SHORT_NAME')|| 'already exists in Request Group &NAO_REQUEST_GROUP_NAME');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            rollback to begin_cmschedule;
            dbms_output.put_line('WARNING:  Unable to add the Concurrent Program "&NAO_EXECUTABLE_SHORT_NAME" to Request Group "&NAO_HIER_REQUEST_GROUP_NAME"');
            noetix_utility_pkg.Add_Installation_Message( 'w_parentchild_config_cm_schedule',
                                                         'add_program_to_group',
                                                         'WARNING',
                                                         'Unable to add the Concurrent Program "&NAO_EXECUTABLE_SHORT_NAME" to Request Group "&NAO_HIER_REQUEST_GROUP_NAME" - '||
                                                         sqlerrm,
                                                         sysdate,
                                                         lc_process_type);
            raise;
    END;
    dbms_output.put_line( '**' );

    dbms_output.put_line( 'Adding self incompatability for concurrent Program "&NAO_EXECUTABLE_NAME"' );

    BEGIN

        lv_compatability_exists := &APPS_USERID..xxnao_conc_manager_pkg.check_program_incompatibility( 
                                                            i_program_short_name      => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                                                            i_application             => '&NAO_APPLICATION_SHORT_NAME',
                                                            i_inc_prog_short_name     => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                                                            i_inc_prog_application    => '&NAO_APPLICATION_SHORT_NAME');

        IF (NOT lv_compatability_exists) THEN

            &APPS_USERID..xxnao_conc_manager_pkg.add_program_incompatibility( 
                                                            i_program_short_name         => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                                                            i_application                => '&NAO_APPLICATION_SHORT_NAME',
                                                            i_inc_prog_short_name        => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                                                            i_inc_prog_application       => '&NAO_APPLICATION_SHORT_NAME'                                                            
                                                             );

        ELSE
            dbms_output.put_line('NOTE: Incompatability for Concurrent Program &NAO_EXECUTABLE_NAME already exists');
        END IF;

       
    EXCEPTION
        WHEN OTHERS THEN
            rollback to begin_cmschedule;
            dbms_output.put_line('WARNING:  Unable to create the Concurrent Program &NAO_EXECUTABLE_NAME');
            noetix_utility_pkg.Add_Installation_Message( 'w_parentchild_config_cm_schedule',
                                                         'Add_Incompatability',
                                                         'WARNING',
                                                         'Unable to add program to incompatability list &NAO_EXECUTABLE_NAME - '||
                                                         sqlerrm,
                                                         sysdate,
                                                         lc_process_type);
            raise;
    END;


    dbms_output.put_line( 'Scheduling and Submitting Concurrent Program for "&NAO_EXECUTABLE_NAME"' );
    
    DECLARE
        ls_start_time VARCHAR2(30);
    BEGIN

        dbms_output.put_line('Creating schedule for Concurrent Program "&NAO_EXECUTABLE_SHORT_NAME"');

        lv_schedule_exists := &APPS_USERID..xxnao_conc_manager_pkg.Schedule_Exists 
                                    ( i_app_short_name   => '&NAO_APPLICATION_SHORT_NAME',
                                      i_resp_key         => '&NAO_HIER_RESPONSIBILITY_KEY',
                                      i_program_name     => UPPER('&NAO_EXECUTABLE_SHORT_NAME') ) ;

        IF ( '&NAO_HIER_START_TIME' IS NULL ) THEN
            ls_start_time := 
                        TO_CHAR(( CASE '&NAO_HIER_REPEAT_UNIT'
                                    WHEN 'DAYS'    THEN SYSDATE + TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL')
                                    WHEN 'MONTHS'  THEN ADD_MONTHS (SYSDATE, TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL'))
                                    WHEN 'HOURS'   THEN SYSDATE + TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL') / 24
                                    WHEN 'MINUTES' THEN SYSDATE + TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL') / 1440
                                    ELSE TO_DATE(NULL)
                                  END ),'DD-MON-YYYY');
        END IF;

        &APPS_USERID..xxnao_conc_manager_pkg.Schedule_And_Submit
                    ( i_repeat_time        => '&NAO_HIER_REPEAT_TIME' ,
                      i_repeat_interval    => '&NAO_HIER_REPEAT_INTERVAL',
                      i_repeat_unit        => '&NAO_HIER_REPEAT_UNIT',
                      i_repeat_type        => '&NAO_HIER_REPEAT_TYPE',
                      i_repeat_end_time    => '&NAO_HIER_REPEAT_END_TIME',
                      i_increment_dates    => '&NAO_HIER_INCREMENT_DATES',
                      i_application        => '&NAO_APPLICATION_SHORT_NAME',
                      i_program            => UPPER('&NAO_EXECUTABLE_SHORT_NAME'),
                      i_description        => '&NAO_SUBMIT_DESCRIPTION',
                      i_start_time         => ls_start_time,
                      i_sub_request        => NULL,
                      i_user_name          => '&NAO_USER_NAME', 
                      i_resp_key           => '&NAO_HIER_RESPONSIBILITY_KEY',
                      o_request_id         => ln_request_id);

    EXCEPTION
        WHEN OTHERS THEN
            rollback to begin_cmschedule;
            dbms_output.put_line('WARNING:  Unable to add schedule for Concurrent Program "&NAO_EXECUTABLE_SHORT_NAME"');
            noetix_utility_pkg.Add_Installation_Message( 'w_parentchild_config_cm_schedule',
                                                         'Schedule_And_Submit',
                                                         'WARNING',
                                                         'Unable to add schedule for Concurrent Program "&NAO_EXECUTABLE_SHORT_NAME" - '||
                                                         sqlerrm,
                                                         sysdate,
                                                         lc_process_type);
            raise;
    END;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(' ' );
        dbms_output.put_line('WARNING:  Concurrent Manager job for scheduling the Noetix Segment Flattened Table Refresh Program' );
        dbms_output.put_line('.         was terminated prematurely.  Consult the Administrators Guide for more details ' );
        dbms_output.put_line('.         or contact support.  In the interim you many need to manually schedule this task  ');
        dbms_output.put_line(' ' );
END;
/

---
---Below script is to create a Request Set which contains the concurrent program to refresh the segment hierarchy flattening table
----

DECLARE
    ls_prog_location           VARCHAR2(500)                  := NULL;
    ls_stage                   VARCHAR2(50)                   := NULL;
    ls_old_stage               VARCHAR2(50);
    ls_new_stage               VARCHAR2(50);
    li_stage_sequence          NUMBER                         := NULL;
    ls_prev_prog_short_name    VARCHAR2(200);
    lb_compatability_exists    BOOLEAN;
    ls_schedule_exists         VARCHAR2(1)                    := 'Y';
    ls_errmsg                  VARCHAR2(230);
    lb_success                 BOOLEAN;
    ls_requestid               NUMBER(15)                     := 0;
    lb_Requestset_exists       BOOLEAN;
    le_stop_program            EXCEPTION;
    lc_process_type   CONSTANT VARCHAR2(100) := 'HIER'; 
    ln_request_id              NUMBER;

    CURSOR c1 IS
    SELECT au.user_id
      FROM all_users au
     WHERE au.username = USER 
       AND ROWNUM      = 1;

    CURSOR c_requestset_details (p_user_id IN NUMBER) IS
    SELECT UPPER( 'HIERARCHIES' || '-Request_set' || USER || '[UID-' ||p_user_id
                    || '])' ) request_set_name,
           UPPER( 'HIERARCHIES' || '-RSET' || '(UID-' || p_user_id || ')'  ) reqset_short_name
      from dual;

    CURSOR c_conc_details IS
    SELECT 'N_HIERARCHIES' table_name,
           'Noetix Segment Hierarchy Table Refresh (&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])' program_name,
           '&NAO_APPLICATION_SHORT_NAME..LOADFLAT(UID-&NOETIX_USER_ID_NUM)' program_short_name,
           '&NOETIX_USER..n_parentchild_pkg.n_hier_proc'  program_executable,               
           1 stage_sequence_number
      FROM dual;
    
    CURSOR c_schedule_stage (p_request_set IN VARCHAR2) IS
    SELECT frstgl.user_stage_name Stage_Name, 
           frstgl.request_set_stage_id,
           frsp.concurrent_program_id, 
           fcp.concurrent_program_name
      FROM fnd_request_set_stages_tl_s frstgl,
           fnd_request_sets_tl_s       frstl,
           fnd_request_set_programs_s  frsp,
           fnd_concurrent_programs_s   fcp
     WHERE frstgl.request_set_id          = frstl.request_set_id
       AND frstl.user_request_set_name LIKE  p_request_set
       AND frstl.LANGUAGE              LIKE NOETIX_ENV_PKG.GET_LANGUAGE
       AND frsp.request_set_id            = frstl.request_set_id
       AND frstgl.LANGUAGE             LIKE NOETIX_ENV_PKG.GET_LANGUAGE
       AND frsp.request_set_stage_id      = frstgl.request_set_stage_id
       AND frsp.concurrent_program_id     = fcp.concurrent_program_id
     ORDER BY frstgl.request_set_stage_id;

    v_requestset_details      c_requestset_details%ROWTYPE;
    r1                        c1%ROWTYPE;
BEGIN

    dbms_output.put_line('Inside Req Set');

    OPEN  c1;
    FETCH c1 
     INTO r1;
    CLOSE c1;

    ls_prog_location := 'Setting Session Mode';

    OPEN  c_requestset_details (r1.user_id);
    FETCH c_requestset_details    INTO v_requestset_details;
    CLOSE c_requestset_details;

    SAVEPOINT begin_requestset;

    &APPS_USERID..xxnao_conc_manager_pkg.APPS_INITIALIZE('&NAO_USER_NAME', 
                                                          '&NAO_HIER_RESPONSIBILITY_KEY' ); -- modified

    lb_Requestset_exists := &APPS_USERID..xxnao_conc_manager_pkg.check_request_set
                                                        ( v_requestset_details.reqset_short_name,
                                                          '&NAO_APPLICATION_SHORT_NAME'   );

    IF ( NOT lb_Requestset_exists ) THEN
        BEGIN
    
            DBMS_OUTPUT.put_line('Creating Request Set ');
    
            ls_prog_location := 'Creating request set';
    
            &APPS_USERID..xxnao_conc_manager_pkg.create_request_set
                    ( i_name                           => v_requestset_details.reqset_short_name,
                      i_short_name                     => v_requestset_details.reqset_short_name,
                      i_application                    => '&NAO_APPLICATION_SHORT_NAME',
                      i_description                    => v_requestset_details.reqset_short_name,
                      i_incompatibilities_allowed      => 'Y'  );
        EXCEPTION
            WHEN OTHERS   THEN
                ROLLBACK TO begin_requestset;
                DBMS_OUTPUT.put_line( 'WARNING:  Unable to create the Request Set  '|| v_requestset_details.reqset_short_name  );
                noetix_utility_pkg.add_installation_message
                              ('w_parentchild_config_cm_schedule',
                               ls_prog_location,
                               'WARNING',
                                  'Unable to create the Request Set '
                               || v_requestset_details.reqset_short_name
                               || SQLERRM,
                               sysdate,
                               lc_process_type
                              );
                RAISE;
        END;
    
        BEGIN
            ls_prog_location := 'Adding request set to request group';
            &APPS_USERID..xxnao_conc_manager_pkg.add_set_to_group( i_request_set            => v_requestset_details.reqset_short_name,
                                                                   i_set_application        => '&NAO_APPLICATION_SHORT_NAME',
                                                                   i_request_group          => '&NAO_HIER_REQUEST_GROUP_NAME',
                                                                   i_group_application      => '&NAO_APPLICATION_SHORT_NAME'  );
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO begin_requestset;
                DBMS_OUTPUT.put_line( 'WARNING:  Unable to add request set '
                                   || v_requestset_details.reqset_short_name
                                   || ' to request group  "&nao_hier_REQUEST_GROUP_NAME"'   );
                noetix_utility_pkg.add_installation_message
                  ('w_parentchild_config_cm_schedule',
                   ls_prog_location,
                   'WARNING',
                      'Unable to add request set '
                   || v_requestset_details.reqset_short_name
                   || ' to request group  "&nao_hier_REQUEST_GROUP_NAME"'
                   || SQLERRM,
                   sysdate,
                   lc_process_type
                  );
                RAISE;
        END;
    
        DBMS_OUTPUT.put_line('Adding Stages and Programs To Request Set ');
    
        FOR v_conc_details IN c_conc_details LOOP
    
            li_stage_sequence := v_conc_details.stage_sequence_number;
    
            IF ( v_conc_details.stage_sequence_number > 1 )   THEN
                ls_old_stage := ls_stage;
            END IF;
    
            ls_stage     :=  'STG-'|| TO_CHAR (r1.user_id|| '-'|| v_conc_details.table_name);
            ls_new_stage := ls_stage;
    
            BEGIN
                ls_prog_location := 'Creating Stage in request set';
                &APPS_USERID..xxnao_conc_manager_pkg.add_stage_to_set
                     (i_name                           => ls_stage,
                      i_request_set                    => v_requestset_details.reqset_short_name,
                      i_set_application                => '&NAO_APPLICATION_SHORT_NAME',
                      i_short_name                     => ls_stage,
                      i_description                    => ls_stage,
                      i_display_sequence               => v_conc_details.stage_sequence_number,
                      i_start_stage                    => CASE WHEN v_conc_details.stage_sequence_number = 1 THEN 'Y'
                                                              ELSE 'N' END,
                      i_critical                       => 'Y',
                      i_incompatibilities_allowed      => 'Y'
                     );
            EXCEPTION
                WHEN OTHERS  THEN
            
                   ROLLBACK TO begin_requestset;
                   DBMS_OUTPUT.put_line (   'WARNING:  Unable to add stage '
                                 || ls_stage
                                 || ' to request set  '
                                 || v_requestset_details.reqset_short_name
                                );
                   noetix_utility_pkg.add_installation_message
                                ('w_parentchild_config_cm_schedule',
                                 ls_prog_location,
                                 'WARNING',
                                    'Unable to add stage '
                                 || ls_stage
                                 || ' to request set  '
                                 || v_requestset_details.reqset_short_name
                                 || SQLERRM,
                                 sysdate,
                                 lc_process_type
                                );
                   RAISE;
            END;
    
    
            IF (v_conc_details.stage_sequence_number > 1)   THEN
    
                ls_prog_location :=  'Linking Stages in request set' || v_requestset_details.reqset_short_name;
    
                BEGIN
                     &APPS_USERID..xxnao_conc_manager_pkg.link_stages_in_set
                           (i_request_set          => v_requestset_details.reqset_short_name,
                            i_set_application      => '&NAO_APPLICATION_SHORT_NAME',
                            i_from_stage           => ls_old_stage,
                            i_to_stage             => ls_new_stage,
                            i_success              => 'Y'
                            );
                EXCEPTION
                    WHEN OTHERS  THEN
                        ROLLBACK TO begin_requestset;
                        DBMS_OUTPUT.put_line (   'WARNING:  Unable to link stage '
                                   || ls_new_stage
                                   || ' to '
                                   || ls_old_stage
                                  );
                        noetix_utility_pkg.add_installation_message
                                  ('w_parentchild_config_cm_schedule',
                                   ls_prog_location,
                                   'WARNING',
                                      'Unable to add stage '
                                   || ls_stage
                                   || ' to request set  '
                                   || v_requestset_details.reqset_short_name
                                   || SQLERRM,
                                   sysdate,
                                   lc_process_type
                                  );
                        RAISE;
                END;
            END IF;
    
            ls_prog_location := 'Adding Programs to request set';
    
            BEGIN
                &APPS_USERID..xxnao_conc_manager_pkg.add_program_to_stage
                   (i_program                  => UPPER
                                                    (v_conc_details.program_short_name
                                                    ),
                   i_program_application      => '&NAO_APPLICATION_SHORT_NAME',
                   i_request_set              => v_requestset_details.reqset_short_name,
                   i_set_application          => '&NAO_APPLICATION_SHORT_NAME',
                   i_stage                    => ls_stage,
                   i_program_sequence         => 1,
                   i_critical                 => 'Y',
                   i_number_of_copies         => 0,
                   i_save_output              => 'N',
                   i_style                    => NULL,
                   i_printer                  => NULL
                  );
            EXCEPTION
                WHEN OTHERS    THEN
                    ROLLBACK TO begin_requestset;
                    DBMS_OUTPUT.put_line (   'WARNING:  Unable to add program '
                                || UPPER (v_conc_details.program_short_name)
                                || ' to '
                                || v_requestset_details.reqset_short_name
                               );
                     noetix_utility_pkg.add_installation_message
                                 ('w_parentchild_config_cm_schedule',
                                  ls_prog_location,
                                  'WARNING',
                                     'Unable to add program '
                                  || UPPER
                                          (v_conc_details.program_short_name)
                                  || ' to '
                                  || v_requestset_details.reqset_short_name
                                  || SQLERRM,
                                  sysdate,
                                  lc_process_type
                                 );
                     RAISE;
            END;
    
            IF ( li_stage_sequence > 1 )      THEN
                SELECT program_short_name
                  INTO ls_prev_prog_short_name
                  FROM ( SELECT 'N_HIERARCHIES' table_name,
                                'Noetix Segment Hierarchy Table Refresh (&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])' program_name,
                                '&NAO_APPLICATION_SHORT_NAME..LOADFLAT(UID-&NOETIX_USER_ID_NUM)' program_short_name,
                                '&NOETIX_USER..n_parentchild_pkg.n_hier_proc'  program_executable,               
                                1 stage_sequence_number
                           FROM dual )
                 WHERE stage_sequence_number = li_stage_sequence - 1;
    
                 DBMS_OUTPUT.put_line( 'Adding incompatability for the concurrent programs within request set' );
    
                 BEGIN
    
                     lb_compatability_exists :=
                                  &APPS_USERID..xxnao_conc_manager_pkg.check_program_incompatibility
                                                      (i_program_short_name        => UPPER(v_conc_details.program_short_name),
                                                       i_application               => '&NAO_APPLICATION_SHORT_NAME',
                                                       i_inc_prog_short_name       => UPPER(ls_prev_prog_short_name),
                                                       i_inc_prog_application      => '&NAO_APPLICATION_SHORT_NAME'     );
    
                     IF ( NOT lb_compatability_exists )  THEN
    
                         &APPS_USERID..xxnao_conc_manager_pkg.add_program_incompatibility
                                                    (i_program_short_name        => UPPER(v_conc_details.program_short_name),
                                                     i_application               => '&NAO_APPLICATION_SHORT_NAME',
                                                     i_inc_prog_short_name       => UPPER(ls_prev_prog_short_name),
                                                     i_inc_prog_application      => '&NAO_APPLICATION_SHORT_NAME'       );
                     ELSE
                               DBMS_OUTPUT.put_line
                                          ('NOTE: Incompatability for the concurrent programs within request set already exists');
                     END IF;
                 EXCEPTION
    
                     WHEN OTHERS    THEN
                         ROLLBACK TO begin_requestset;
                         DBMS_OUTPUT.put_line('WARNING:  Unable to add incompatability for the concurrent programs within request set');
                         noetix_utility_pkg.add_installation_message
                               ('w_parentchild_config_cm_schedule',
                                'Add_Incompatability for programs within request set',
                                'WARNING',
                                'Unable to add incompatability for the concurrent programs'
                                              || UPPER (v_conc_details.program_short_name)
                                              || 'and'
                                              || UPPER (ls_prev_prog_short_name)
                                              || ' within request set - '
                                              || SQLERRM,
                                              sysdate,
                                              lc_process_type );
                         RAISE;
                 END;
             END IF;
    
             li_stage_sequence := v_conc_details.stage_sequence_number;
    
        END LOOP;
    
        ls_prog_location := 'Adding self Incompatability to request set';
        DBMS_OUTPUT.put_line ( 'Adding self Incompatability to request set ' || v_requestset_details.reqset_short_name  );
    
        BEGIN
            lb_compatability_exists :=
                        &APPS_USERID..xxnao_conc_manager_pkg.check_req_set_incompatibility
                                  ( i_request_set              => v_requestset_details.reqset_short_name,
                                    i_application              => '&NAO_APPLICATION_SHORT_NAME',
                                    i_inc_request_set          => v_requestset_details.reqset_short_name,
                                    i_inc_set_application      => '&NAO_APPLICATION_SHORT_NAME'     );
    
            IF ( NOT lb_compatability_exists )  THEN
    
                &APPS_USERID..xxnao_conc_manager_pkg.add_req_set_incompatibility
                                  ( i_request_set              => v_requestset_details.reqset_short_name,
                                    i_application              => '&NAO_APPLICATION_SHORT_NAME',
                                    i_inc_request_set          => v_requestset_details.reqset_short_name,
                                    i_inc_set_application      => '&NAO_APPLICATION_SHORT_NAME'        );
            ELSE
                 DBMS_OUTPUT.put_line( 'NOTE: Incompatability for Concurrent Program &NAO_EXECUTABLE_NAME already exists' );
            END IF;
        EXCEPTION
            WHEN OTHERS  THEN
                ROLLBACK TO begin_requestset;
                DBMS_OUTPUT.put_line( 'WARNING:  Unable to create the Concurrent Program &NAO_EXECUTABLE_NAME' );
                noetix_utility_pkg.add_installation_message
                     ('w_parentchild_config_cm_schedule',
                      'Add_Incompatability',
                      'WARNING',
                      'Unable to add program to incompatability list &NAO_EXECUTABLE_NAME - '
                       || SQLERRM,
                       sysdate,
                       lc_process_type
                     );
             RAISE;
        END;
    ELSE 
        DBMS_OUTPUT.put_line('Concurrentrequest set already exists');
    END IF;

    BEGIN

          ls_schedule_exists :=  &APPS_USERID..xxnao_conc_manager_pkg.schedule_exists
                                                     ( i_app_short_name      => '&NAO_APPLICATION_SHORT_NAME',
                                                       i_resp_key            => '&nao_hier_RESPONSIBILITY_KEY',
                                                       i_program_name        => v_requestset_details.reqset_short_name    );

          IF ( ls_schedule_exists = 'N' )  THEN
              DBMS_OUTPUT.put_line('Scheduling Request Set ');

              BEGIN
                  ls_prog_location := 'Setting Repeat Options for Request Set';
                  DBMS_OUTPUT.put_line(ls_prog_location);

                  lb_success :=   &APPS_USERID..xxnao_conc_manager_pkg.schedule_options ( i_repeat_interval => '&NAO_HIER_REPEAT_INTERVAL',
                                                                                          i_repeat_unit     => '&NAO_HIER_REPEAT_UNIT',
                                                                                          i_repeat_type     => '&NAO_HIER_REPEAT_TYPE');
                  IF ( NOT lb_success ) THEN
                      ls_errmsg  := SQLERRM (SQLCODE); 
                      RAISE le_stop_program;  
                   END IF;
              END;

              DBMS_OUTPUT.put_line('Submitting Request Set ');

              DECLARE 
                  ls_start_time VARCHAR2(30);
              BEGIN


                  ls_prog_location := 'Setting Context for Request Set';
                   /* set the context for the request set */
                  lb_success :=
                         &APPS_USERID..xxnao_conc_manager_pkg.request_set_context
                                    ( '&NAO_APPLICATION_SHORT_NAME',
                                      v_requestset_details.reqset_short_name );

                  IF ( NOT lb_success ) THEN
                      ls_errmsg  := SQLERRM (SQLCODE); 
                      RAISE le_stop_program;
                  ELSE

                      FOR v_schedule_stage IN  c_schedule_stage (v_requestset_details.reqset_short_name) LOOP
                          ls_prog_location := 'Submitting Stage for Request Set';
                          lb_success       := &APPS_USERID..xxnao_conc_manager_pkg.submit_request_set_program
                                                      ( '&NAO_APPLICATION_SHORT_NAME',
                                                        v_schedule_stage.concurrent_program_name,
                                                        v_schedule_stage.stage_name               );
                          IF (NOT lb_success) THEN
                                ls_errmsg  := SQLERRM (SQLCODE); 
                                RAISE le_stop_program;
                          END IF;
                      END LOOP;

                      ls_start_time := TO_CHAR(( CASE '&NAO_HIER_REPEAT_UNIT'
                                                   WHEN 'DAYS'    THEN SYSDATE + TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL')
                                                   WHEN 'MONTHS'  THEN ADD_MONTHS (SYSDATE, TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL'))
                                                   WHEN 'HOURS'   THEN SYSDATE + TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL') / 24
                                                   WHEN 'MINUTES' THEN SYSDATE + TO_NUMBER ('&NAO_HIER_REPEAT_INTERVAL') / 1440
                                                   ELSE TO_DATE(NULL)
                                                 END ),'DD-MON-YYYY');

                      ls_prog_location  := 'Submitting Request Set';
                      ls_requestid      := &APPS_USERID..xxnao_conc_manager_pkg.submit_request_set(ls_start_time, FALSE);
                      DBMS_OUTPUT.put_line (   'Request ID for Request Set : '|| ls_requestid);

                  END IF;
              END;
          END IF; --end of check schedule exists for request set


    EXCEPTION
        WHEN le_stop_program  THEN
            ROLLBACK TO begin_requestset;
            DBMS_OUTPUT.PUT_LINE ('Step :' || ls_prog_location || ' Message :' || ls_errmsg );
            noetix_utility_pkg.add_installation_message
                          ('w_parentchild_config_cm_schedule',
                           ls_prog_location,
                           'WARNING',
                           'Unable to schedule Concurrent request set  - '
                           ||  ls_errmsg,
                           sysdate,
                           lc_process_type
                          );
            RAISE;
        WHEN OTHERS  THEN
            ROLLBACK TO begin_requestset;
            DBMS_OUTPUT.put_line( 'WARNING:  Unable to schedule for Concurrentrequest set' );
            noetix_utility_pkg.add_installation_message
                          ('w_parentchild_config_cm_schedule',
                           ls_prog_location,
                           'WARNING',
                              'Unable to schedule Concurrent request set  - '
                           ||  ls_errmsg,
                           sysdate,
                           lc_process_type
                          );
            RAISE;
    END;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        raise_application_error ( -20001,
                                  ls_prog_location || ': ' || SQLERRM (SQLCODE)    );
END;
/

SPOOL off

-- change the language back to the original installation language
begin
    if ( '&OLD_LANG' <> '&NOETIX_LANG' ) then
        execute immediate 'alter session set NLS_LANGUAGE = ''&OLD_LANGUAGE''';
    end if;
end;
/

undefine install_language
undefine old_language
undefine old_lang

undefine nao_application_short_name
undefine nao_hier_repeat_time
undefine nao_hier_repeat_interval
undefine nao_hier_repeat_unit
undefine nao_hier_repeat_type
undefine nao_hier_repeat_end_time
undefine nao_hier_increment_dates
undefine nao_hier_start_time
undefine nao_sys_user_name
undefine nao_sys_resp_key

undefine nao_application_name
undefine nao_application_base_path
undefine nao_user_name
undefine nao_user_password
undefine nao_responsibility_name
undefine nao_responsibility_key
undefine nao_security_group_key
undefine nao_menu_name
undefine nao_menu_type
undefine nao_menu_entry_function
undefine nao_menu_entry_prompt
undefine nao_menu_entry_desc
undefine nao_request_group_name
undefine nao_data_group_name
undefine nao_schema_name
undefine nao_executable_name
undefine nao_executable_short_name
undefine nao_execution_file_name
undefine nao_submit_description
undefine nao_oracle_username
undefine nao_hier_responsibility_name
undefine nao_hier_responsibility_key
undefine nao_hier_request_group_name
undefine nao_hier_cm_out_file

--
-- end w_parentchild_config_cm_schedule.sql
