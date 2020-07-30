-- Title
--   xupdate.sql
--
-- Function
--   Perform an update of NoetixViews with an update disk provided by Noetix
--   Corp.
--
-- Description
--
-- Inputs  
--
--   Certain sql*plus variables must be set prior to execution of this script
--
-- Copyright Noetix Corporation 1992-2013  All Rights Reserved
--
-- History
--   29-Nov-94 D Cowles   Created 
--   07-Jun-95 D Cowles   add wnoetxu2
--   03-Jan-96 M Turner   call xtruncal.sql before calling wloadata.sql
--   17-Mar-97 D West     added calls to getver.sql, prdvercl.sql and verflag.sql
--   17-May-97 D Cowles   added call to wtblupd
--   18-May-97 D Cowles   removed pause
--   04-May-98 D Cowles   added new wnoetxu? scripts and moved xu2 to after 
--                        wloadata so existing scripts work better
--   12-Aug-99 R Lowe     changed wnoetxul to wnoetxu9 to eliminate multiple uses
--                        of wnoetxul (also in xgenall2)
--   20-Sep-99 R Lowe     Update copyright info.
--   16-Feb-00 H Sumanam  Update copyright info.
--   19-Jul-00 R Kompella Deleted the call to getver script called after 
--                        wnoetxu2 as it is obsolete.
--   29-Sep-00 R Kompella Added call to woe2ont for 11.5+ versions,
--                        this changes OE references point to ONT.
--   11-Dec-00 D Glancy   Update Copyright info.
--   04-May-01 H Schmed   Added a call to ycrseqtm to create the template
--                        table sequences.
--   08-May-01 H Schmed   Added a call to wlovoff.sql which sets the 
--                        include flag to N on all LOV views if the customer
--                        did not purchase answers.
--   08-May-01 H Schmed   Moved the call to wlovoff.sql to a point after
--                        verflag because verflag was changing the include_
--                        flag back to Y.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   11-Jan-02 D Glancy   Add checks to see if the restart_label is populated.
--                        If so and it is the meta_data_load restart label, then skip
--                        the code through wloadata.sql.
--                        (Issue #4320) 
--   31-Jan-02 D Glancy   Moved the restart point for meta-data after the wnoetxu2.sql
--                        script.  We want to insert we don't pick up any inserts
--                        since this is mainly where the inserts into templates is 
--                        accomplished.  (Issue #4320) 
--   12-Feb-02 D Glancy   The utlif on the wnoetxu2.sql is incorrect.   It should be 
--                        "'&skip_dataload_flag' = 'N'" instead of 
--                        "'&skip_dataload_flag' = 'Y'".  (Issue #4320) 
--   12-Dec-02 D Glancy   Corrected spelling error.
--                        (Issue 8907).
--   12-Jan-03 H Schmed   Added the call to wmdswtch.sql. (Issue 9030)
--   03-Mar-03 D Glancy   Removed the call to wmdswtch.sql. (Issue 10096)
--   22-Aug-03 D Glancy   Perform the first pass through non-profile optioned table name changes record.
--                        On this pass, we process all table name change records that do not have
--                        profile options.
--                        (Issue 11160)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Sep-08 D Glancy   Moved r12 suppression to xupdate.sql.  (Issue 20745)
--   22-Sep-08 D Glancy   Add support for OKS. (Issue 20767)
--   22-Jan-08 D Glancy   Add support for HXC (OTL).
--                        (Issue 21430)
--   22-Jan-08 D Glancy   Add r12 support for FV (Federal).
--                        (Issue 21442)
--   13-Mar-09 D Glancy   Any module that has at least one view with the security code set for Budget Levels or GL KFF security,
--                        enable the advanced security operating mode.
--                        (Issue 21378)
--   12-Apr-09 D Glancy   Open up OPM for R12 support.
--                        (Issue 21104)
--   06-May-09 D Glancy   Remove r12 support for OPM.  5.8.6 will not fully support this feature for now.
--                        (Issue 21104)
--   15-Jul-09 D Glancy   Add back support for OPM R12.
--                        (Issue 21104)
--   20-Nov-09 C Kranthi  Added code block for removing KFF view metadata when the checkpoint feature is activated.
--   25-Nov-09 D Glancy   Modified the XXKFF purge such that we can tell if it ran or not.  It now generates a .lst file if it runs.
--   02-Feb-10 D Glancy   Use uppercase for all pl/sql array functions as a standard.
--   25-May-11 Srinivas   Add support for XXHIE (Hierarchies).
--                        (Issue 25330)
--   05-Sep-11 D Glancy   Add local copy of add_installation_message to the gseg pl/sql block.  noetix_utility_pkg
--                        doesn't exist at this point.
--   28-Sep-11 D Glancy   Added a new column to n_application_owner_templates called sec_rules_fin_appl_flag.
--                        This column will be used by the Accounting KFF security to specify which applications
--                        belong to the financials family of applications.  If an application belongs to this family,
--                        then Accounting KFF security will process responsibilities within the financials family in
--                        a certain manner (eg no detected rules mean full access).   For non-financials responsiblity
--                        applications, no access is granted if no rules are detected.
--                        (Issue 27782).
--   22-Feb-12 D Glancy   Add cash management support for 12+.
--                        (Issue 29038)
--   04-Sep-12 D Glancy   Add errors and spooling.
--                        (Issue 29931)
--   09-Oct-12 D Glancy   Add check for upgrading existing key_view_labels at the table level.
--                        (Issue 28846)
--   24-May-13 D Glancy   Move the insert into n_application_owner_templates for all the application_id's that are not in metadata in the fnd_application table 
--                        if they are tied to a product from apps.sql so that workbench can use them for view and role inserts.
--                        (Issue 28711)
--   13-Nov-13 kkondaveeti Added support for OKE.
--

define skip_dataload_flag = "N"
column s_skip_dataload_flag new_value skip_dataload_flag noprint
select 'Y'              s_skip_dataload_flag
  from n_view_lookups    vl,
       n_view_parameters vp
 where vp.creation_date  = 
     ( select max(vp1.creation_date)
         from n_view_parameters vp1
        where vp1.install_stage = 4 )
   and vp.install_stage  = 4
   and vl.lookup_type    = 'INSTALL4_CHECKPOINT'
   and vl.lookup_code    = nvl(vp.restart_label,'NONE')
   and vl.sort_order    >= 
     ( select max(vl1.sort_order)
         from n_view_lookups vl1
        where vl1.lookup_type = 'INSTALL4_CHECKPOINT'
          and vl1.lookup_code = 'META_DATA_LOAD' );

start utlif "utlspon t_purge_xxkff" -
    "'&SKIP_DATALOAD_FLAG' = 'Y'" 

-- Remove KFF data cache view metadata if the SKIP_DATALOAD_FLAG is set.
set serveroutput on size &MAX_SERVEROUTPUT_SIZE
DECLARE
    CURSOR c1 IS
    SELECT v.view_label
      FROM N_VIEW_TEMPLATES v
     WHERE v.application_label = 'XXKFF';
    --
    TYPE typ_view_label     is table of n_view_templates.view_label%TYPE       index by binary_integer;
    --
    lt_view_label              typ_view_label;
    --
    procedure Add_Installation_Message( p_script_name   VARCHAR2,
                                        p_location      VARCHAR2,
                                        p_message_type  VARCHAR2,
                                        p_message       VARCHAR2,
                                        p_creation_date DATE     DEFAULT SYSDATE,
                                        p_process_type  VARCHAR2 DEFAULT NULL ) IS
    -- Declare the local variables
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_msg    VARCHAR2(2000);
    l_error  VARCHAR2(2000);
    --
    begin
        insert into n_installation_messages
             ( script_name, 
               location, 
               message_seq,
               message_type, 
               message, 
               creation_date,
               process_type )
        values
             ( p_script_name,
               p_location,
               n_installation_messages_seq.nextval,
               p_message_type,
               p_message,
               p_creation_date,
               p_process_type );
          
          COMMIT;
          
    exception
       when OTHERS then
          l_msg := substrb(sqlerrm,1,255);
          l_error := 'Error inserting into '||
                     'n_installation_messages. ('||
                     p_script_name ||'/';
          l_error := l_error||
                     substr(p_location, 1, 254-lengthb(l_error))||
                     ')';
          dbms_output.put_line(l_error);
          dbms_output.put_line(l_msg);
          --
    end add_installation_message;
BEGIN
    IF ( '&SKIP_DATALOAD_FLAG' = 'Y' ) THEN

        dbms_output.put_line( 'Remove KFF data cache view metadata since the SKIP_DATALOAD_FLAG is set to ''Y'' .' );

        if ( c1%ISOPEN ) THEN
            close c1;
        end if;

        open c1;

        FETCH c1 BULK COLLECT
         INTO lt_view_label;

        close c1;

        FORALL i in 1..lt_view_label.COUNT
            DELETE FROM n_view_column_templates c
             WHERE c.view_label = lt_view_label(i);
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_view_column_templates. ' );

        FORALL i in 1..lt_view_label.COUNT
            DELETE FROM n_view_where_templates w
             WHERE w.view_label = lt_view_label(i);
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_view_where_templates. ' );

        FORALL i in 1..lt_view_label.COUNT
            DELETE FROM n_view_table_templates t
             WHERE t.view_label = lt_view_label(i);
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_view_table_templates. ' );

        FORALL i in 1..lt_view_label.COUNT
            DELETE FROM n_view_query_templates q
             WHERE q.view_label = lt_view_label(i);
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_query_column_templates. ' );

        FORALL i in 1..lt_view_label.COUNT
            DELETE FROM n_role_view_templates r
             WHERE r.view_label = lt_view_label(i);
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_role_view_templates. ' );

        DELETE FROM n_view_templates v
         WHERE v.application_label = 'XXKFF';
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_view_templates. ' );

        DELETE FROM n_role_templates r
         WHERE r.application_label = 'XXKFF';
        dbms_output.put_line( 'Deleted '||SQL%ROWCOUNT||' XXKFF rows from n_role_templates. ' );

        COMMIT;
    END IF;
EXCEPTION
   WHEN OTHERS THEN 
        ROLLBACK;
        add_installation_message( 'xupdate',
                                  'Removing the KFF data cache view metadata when META_DATA_LOAD checkpoint is selected.',
                                  'ERROR',
                                  SQLERRM,
                                  SYSDATE,
                                  'GSEG'  );
        if ( c1%ISOPEN ) THEN
            close c1;
        end if;
        raise_application_error (-20001, SQLERRM);
END;
/
start utlif utlspoff -
    "'&SKIP_DATALOAD_FLAG' = 'Y'" 

start utlif wnoetixu -
    "'&SKIP_DATALOAD_FLAG' = 'N'" 

start utlif xtruncal -
    "'&SKIP_DATALOAD_FLAG' = 'N'" 

start utlif wnoetxuj -
    "'&SKIP_DATALOAD_FLAG' = 'N'" 

start utlif wloadata -
    "'&SKIP_DATALOAD_FLAG' = 'N'" 

-- Create the template table sequences; initialize them based on
-- the loaded data.
@ycrseqtm

-- Issue 30475 ycr_templates_md_api_pkg addition
start utlif "utlprmpt ''Install the n_templates_md_api_pkg.''" -
     "n_compare_function_version( 'n_templates_md_api_pkg.get_version','&N_SCRIPTS_VERSION' )  < 0" 
start utlif "ycr_templates_md_api_pkg" -
     "n_compare_function_version( 'n_templates_md_api_pkg.get_version','&N_SCRIPTS_VERSION' )  < 0" 

-- Add the triggers on the templates tables.
@ycrtmplt

start utlif woe2ont "&PRODUCT_VERSION >= 11.5"

-- Issue 27792
-- Define the list of applications that are considered to be part of financials for the purposes of Accounting KFF rule 
-- processing.  If no rules are defined and the current responsibility is a financials related application, security
-- will be expected provide full access.  IF a non-financials application is specified, then access should be denied for 
-- all roles.  By default, only "GL" is considered to be in the financials category.  Others can be added via the wnoetxu2
-- hook script.
--
update n_application_owner_templates aot
   set aot.sec_rules_fin_appl_flag = 'Y'
 where aot.application_label in ( 'GL' );

-- Moved from below wtblupd.sql to here 5/3/98
-- NOTE:  ALL inserts/Updates to the templates tables should be put in this script.
--        DO NOT include any other sql statements in this script.  Otherwise, the
--        restart capability function may not work correctly.
--

-- Check for KEY_VIEW_LABELS set at the table level
-- As of 6.3, there should be no KVLs at the table level as they've been migrated to the Join Key Tables
-- Flag a warning (more for development if there exists any KVLs at the table level.
DECLARE
    li_table_count      BINARY_INTEGER := 0;
BEGIN
    SELECT count(*)
      INTO li_table_count
      FROM n_view_table_templates t
     WHERE t.key_view_label is not null;

    IF ( li_table_count > 0 ) THEN
        --
        INSERT INTO n_installation_messages
             ( script_name, 
               location, 
               message_seq,
               message_type, 
               message, 
               creation_date,
               process_type )
        VALUES
             ( 'xupdate',
               'Check for Key_View_Labels at table level.',
               n_installation_messages_seq.nextval,
               'DEBUG',
               'Key_View_Labels have been defined at the n_view_table_templates level.  May need to investigate why as this feature has been removed.',
               sysdate,
               null );
          --
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- Find any applications that are not in n_application_owner_templates and add them.
INSERT INTO n_application_owner_templates aot
     ( application_id,
       application_label,
       base_application,
       context_code,
       single_instances_allowed,
       single_instances_enabled,
       xop_instances_allowed,
       xop_instances_enabled,
       global_instance_allowed,
       global_instance_enabled,
       advanced_security_allowed,
       advanced_security_enabled,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date )
SELECT distinct
       fa.application_id,
       substr( ( CASE nvl(fa.product_code,
                          fa.application_short_name)
                   WHEN 'PER'      THEN ( CASE fa.application_id 
                                            WHEN 800 THEN 'HR'
                                            ELSE fa.application_short_name
                                          END )
                   WHEN 'SYSADMIN' THEN 'ADMIN'
                   WHEN 'GL'       THEN ( CASE fa.application_id
                                            WHEN 168 THEN fa.application_short_name
                                            ELSE nvl(fa.product_code,fa.application_short_name)
                                          END )
                   ELSE nvl(fa.product_code,
                            fa.application_short_name)
                 END  ),1,10 )           application_label,
       'N',
       'NONE',
       'N',
       'N',
       'N',
       'N',
       'Y',
       'Y',
       'N',
       'N',
       'NOETIX',
       sysdate,
       'NOETIX',
       sysdate
  FROM &APPLSYS_USERID..fnd_application           fa,
       &APPLSYS_USERID..fnd_oracle_userid         fou,
       &APPLSYS_USERID..fnd_product_installations fpi
 WHERE fa.application_id         = fpi.application_id 
   AND fpi.oracle_id             = fou.oracle_id
   AND not exists
     ( SELECT 'app label already exists'
         FROM n_application_owner_templates aot
        WHERE aot.application_label   = substr( ( CASE nvl(fa.product_code,
                                                           fa.application_short_name)
                                                    WHEN 'PER'      THEN ( CASE fa.application_id 
                                                                             WHEN 800 THEN 'HR'
                                                                             ELSE fa.application_short_name
                                                                           END )
                                                    WHEN 'SYSADMIN' THEN 'ADMIN'
                                                    WHEN 'GL'       THEN ( CASE fa.application_id
                                                                             WHEN 168 THEN fa.application_short_name
                                                                             ELSE nvl(fa.product_code,fa.application_short_name)
                                                                           END )
                                                    ELSE nvl(fa.product_code,
                                                             fa.application_short_name)
                                                 END ),1,10) );

whenever sqlerror exit 591
whenever oserror  exit 591
@utlspon wnoetxu2

start utlif wnoetxu2 -
    "'&SKIP_DATALOAD_FLAG' = 'N'" 

spool off
whenever sqlerror continue
whenever oserror  continue

-- Update the checkpoint information - Post View Creation
update N_VIEW_PARAMETERS
   set current_checkpoint_label  = 'META_DATA_LOAD',
       last_update_date          = sysdate
 where creation_date = 
       ( select max(creation_date)
           from n_view_parameters
          where install_stage = 4 )
   and install_stage = 4;

commit;

-- Let the user know that we're skipping to a restart point.
start utlif "utlprmpt ''Restarting from the META_DATA_LOAD Checkpoint.'' " -
    "'&SKIP_DATALOAD_FLAG' = 'Y'" 

undefine skip_dataload_flag

@w_metadata_definitions

--@utlprmpt "Get Product Version"

-- Add the include_flag to all tables that have a product_version column.
@utlprmpt "Convert Product Version information"
@prdvercl

-- Set the include_flag based on the product_version.
@utlprmpt "Determine view definitions for this application version"
@verflag

-- Turn off LOV views if the customer did not purchase answers
start utlif "wlovoff.sql" "'&dat_answers' = 'N' "

--
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--
-- The following is temporary code until we can resolve all r12 changes.
-- For the time being, we will prevent the installer from generating
-- views on modules where we do not support r12+.
-- Issue 18126
whenever sqlerror continue

set termout  off
set head     off
set echo     off
set verify   off
set feedback off
set linesize 120
set serveroutput on size &MAX_SERVEROUTPUT_SIZE
set termout  on

DECLARE
    CURSOR c_appl_list is
    SELECT ao.application_label,
           r.role_label
      FROM n_role_templates              r,
           n_application_owner_templates ao
     WHERE ao.base_application = 'Y'
       AND 
         ( (      '&DAT_TYPE' = 'Views'
              AND ao.application_label not in
                  -- This is the list of installable modules that we can support for Oracle EBS 12+
                  -- We'll un-comment out the lines as we are able to support those modules for EBS 12+
                  ( 'AOL',
                    'AP',
                    'AR',
                    'BEN',
                    'BOM',
                    'CE',
                    'CS',
                    'CSD',
                    'CSF',
                    'CSI',
                    'CST',
                    'EAM',
                    'FA',
                    'FV',
                    'GL',
                    'GMD',
                    'GME',
                    'GMF',
                    'GMI',
                    'GMP',
                    'GMS',
                    'HR',
                    'HXC',
                    -- 'IGW',
                    'INV',
                    'MRP',
                    'MSC',
                    'OE',
					'OKE',
                    'OKS',
                    'PA',
                    'PAY',
                    'PB',
                    'PC',
                    'PJM',
                    'PO',
                    'PS',
                    'QA',
                    -- 'QOT',
                    'WIP',
                    'XXNAO',
                    'XXHIE'   )
         OR (     '&DAT_TYPE' = 'DW'
              AND ao.application_label not in
                  -- This is the list of installable modules that we can support for Oracle EBS 12+
                  -- We'll un-comment out the lines as we are able to support that modules for EBS 12+
                  ( -- 'AOL',
                    -- 'AP',
                    -- 'AR',
                    -- 'GL',
                    -- 'HR',
                    -- 'NOETIX',
                    -- 'OE',
                    'NONE'   ) ) ) )
     AND r.application_label  = ao.application_label
     AND &FND_VERSION        >= 12;
     
    CURSOR c_role_view_list( p_application_label  VARCHAR2 ) is
    SELECT rv.role_label,
           rv.view_label,
           nvl(rv.include_flag,'Y') rv_include_flag,
           nvl(v.include_flag,'Y')  v_include_flag
      FROM n_view_templates              v,
           n_role_view_templates         rv,
           n_role_templates              r
     WHERE r.application_label       = p_application_label
       AND rv.role_label             = r.role_label
       AND v.view_label              = rv.view_label
       AND (    NVL(rv.include_flag,'Y')  = 'Y'
             OR NVL(v.include_flag,'Y')   = 'Y' );

    CURSOR c_disable_app_list( p_application_label VARCHAR2 ) is
    SELECT ao.application_label
      FROM n_application_owner_templates ao
     WHERE ao.application_label      = p_application_label
       AND ao.base_application       = 'S'
       AND not exists
         ( select 'Application is used'
             from n_view_templates v
            where v.application_label = p_application_label
              and v.include_flag      = 'Y' 
              and rownum = 1
            UNION
           select 'Application is used'
             from n_view_table_templates t,
                  n_view_templates       v
            where t.application_label = p_application_label
              and v.view_label        = t.view_label
              and v.include_flag      = 'Y' 
              and rownum = 1
            UNION
           select 'Application is used'
             from n_view_column_templates c,
                  n_view_templates        v
            where c.ref_application_label = p_application_label
              and v.view_label        = c.view_label
              and v.include_flag      = 'Y' 
              and rownum = 1
            UNION
           select 'Application is used'
             from n_view_where_templates w,
                  n_view_templates       v
            where w.WHERE_CLAUSE like '%&'||p_application_label||'.%'
              and v.view_label        = w.view_label
              and v.include_flag      = 'Y' 
              and rownum = 1 );
    
    TYPE DisabledAppsListTyp IS TABLE OF VARCHAR2(100)
    INDEX BY binary_integer;
    
    li_loop_count    BINARY_INTEGER := 0;
    li_view_count    BINARY_INTEGER := 0;
    g_DisabledApps   DisabledAppsListTyp;

    procedure Add_Installation_Message( p_script_name   VARCHAR2,
                                        p_location      VARCHAR2,
                                        p_message_type  VARCHAR2,
                                        p_message       VARCHAR2,
                                        p_creation_date date       DEFAULT sysdate ) IS
    -- Declare the local variables
    l_msg    VARCHAR2(2000);
    l_error  VARCHAR2(2000);
    --
    begin
        insert into n_installation_messages
        ( script_name, 
          location, 
          message_seq,
          message_type, 
          message, 
          creation_date
        )
        values
        ( p_script_name,
          p_location,
          n_installation_messages_seq.nextval,
          p_message_type,
          p_message,
          p_creation_date );
    exception
       when OTHERS then
          l_msg := substrb(sqlerrm,1,255);
          l_error := 'Error inserting into '||
                     'n_installation_messages. ('||
                     p_script_name ||'/';
          l_error := l_error||
                     substr(p_location, 1, 254-lengthb(l_error))||
                     ')';
          dbms_output.put_line(l_error);
          dbms_output.put_line(l_msg);
          --
    end add_installation_message;         
BEGIN
    
    -- First determine which roles/views we want to disable.
    -- Disable the n_application_owner entry by turning the base flag to S(hare).  
    -- Did not turn to N because we don't really know if they need to be shared or not.
    for r_appl_list in c_appl_list loop
        if ( li_loop_count = 0 ) then
            dbms_output.put_line( '. ' );
            dbms_output.put_line( '---------------------------------------------------------------- ' );
            dbms_output.put_line( '. ' );
            dbms_output.put_line( 'WARNING: The following applications will not work with Oracle ' );
            dbms_output.put_line( '.        E-Business Suite R12+ and will not be installed:' );
            dbms_output.put_line( '.        ' );
            
            Add_Installation_Message( 'xupdate.sql',
                                      'Determine applications/views that will be disabled.',
                                      'WARNING',
                                      'WARNING: The following applications will not work with Oracle ' );
            Add_Installation_Message( 'xupdate.sql',
                                      'Determine applications/views that will be disabled.',
                                      'WARNING',
                                      '.        E-Business Suite R12+ and will not be installed:' );
            Add_Installation_Message( 'xupdate.sql',
                                      'Determine applications/views that will be disabled.',
                                      'WARNING',
                                      '.        ' );
        end if;
        li_loop_count := li_loop_count+1; 
                   
        dbms_output.put_line( '.        - '||r_appl_list.application_label );
        Add_Installation_Message( 'xupdate.sql',
                                  'Determine applications/views that will be disabled.',
                                  'WARNING',
                                  '.        - '||r_appl_list.application_label );
        g_DisabledApps(li_loop_count) := r_appl_list.application_label;
        
        -- Disable the application
        update n_application_owner_templates a
           set a.base_application = 'S'
         where a.application_label = g_DisabledApps(li_loop_count);
    end loop;
    commit;
    
    -- If we found some application labels that needed to be unloaded,
    -- go ahead and set the include_flag to 'N' for all role/view records associated with the applications we disabled.
    -- If the view is used in another active role, we won't update the include_flag.
    IF ( li_loop_count > 0 ) THEN    
        -- Print out the last part of the user message.
        dbms_output.put_line( '. ' );
        dbms_output.put_line( '---------------------------------------------------------------- ' );

        FOR i IN g_DisabledApps.FIRST..g_DisabledApps.LAST LOOP
            FOR r_role_view_list IN c_role_view_list( g_DisabledApps(i) ) LOOP
            
                -- Update the role view list
                UPDATE n_role_view_templates rv
                   SET rv.include_flag = 'N'
                 WHERE rv.role_label            = r_role_view_list.role_label
                   AND rv.view_label            = r_role_view_list.view_label
                   AND NVL(rv.include_flag,'Y') = 'Y';
                
                -- Determine if the view is used elsewhere
                SELECT count(*)
                  INTO li_view_count
                  FROM n_role_view_templates rv2
                 WHERE rv2.role_label           <> r_role_view_list.role_label
                   AND rv2.view_label            = r_role_view_list.view_label
                   AND NVL(rv2.include_flag,'Y') = 'Y';

                -- Update the view if it is not used by another role
                IF ( li_view_count <= 0 ) THEN
                    UPDATE n_view_templates v
                       SET v.include_flag          = 'N'
                     WHERE v.view_label            = r_role_view_list.view_label
                       AND NVL(v.include_flag,'Y') = 'Y' ;
                END IF;
                               
            END LOOP;
            commit;   
        END LOOP;
        
        -- Not unset the share status
        FOR i IN g_DisabledApps.FIRST..g_DisabledApps.LAST LOOP
            FOR r_disable_app_list IN c_disable_app_list( g_DisabledApps(i) ) LOOP
                 -- Disable the application
                 update n_application_owner_templates a
                    set a.base_application         = 'N',
                        a.single_instances_enabled = 'N',
                        a.xop_instances_enabled    = 'N',
                        a.global_instance_enabled  = 'N'
                  where a.application_label = g_DisabledApps(i);
            END LOOP;
        END LOOP;

    END IF;
END;
/

start utlif 'utlexit 445' - 
  "not exists ( select 'Role Enabled' from n_application_owner_templates where base_application = 'Y' and rownum = 1 )"

set termout &LEVEL2
-- 
-- END OF ISSUE 18126
--
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--

-- Set the advanced_security_enabled flag if any of the views in a role will 
-- include GL KFF security or Budget Level security.  For these modules,
-- we will need to force the advanced security modes on.
--
update n_application_owner_templates aot
   set aot.advanced_security_enabled = 'Y',
       aot.advanced_security_allowed = 'Y'
 where aot.application_label in
     ( select v.application_label
         from n_view_templates v
        where v.special_process_code in ( 'ACCOUNT','BUDLVL' )
          and nvl(v.include_flag,'Y') = 'Y'
        group by v.application_label );
commit;

@wnoetxu9

@utlprmpt "Change table names if necessary for this application version"
@wtblupd N

@wnoetxuk

@xgenall

-- Do not add a pause here it will cause an invisible pause
-- and will not return the the form for prefix editting properly

-- End xupdate.sql
