-- Title
--   w_gseg_incr_refr_rset.sql
-- Function
--   1. Creates concurrent request set for the incremental refresh programs
--   2. Creates concurrent program for enabling the incremental refresh for a flex field 
--   3. Maintains the incremental refresh concurrent request set during the regeneration
-- Description
--
-- Parameters
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   02-Apr-10   Kranthi      Created.
--   24-May-10   R Vattikonda Corrected the logic for retaining previous settings. 
--   26-OCT-10   R Vattikonda Modified 'C' to 'Char' in independent value set.
--                            (Issue 25259).  
--   30-Mar-11   Sharas       Modified (Emerson 0 latency).
--   17-Feb-12   R Vattikonda Implementing Zero latency changes.(Issue 27565)
--   22-Mar-12   D Glancy     Grant execute to the renamed gseg utility package.
--                            Upgrade the concurrent manager executable for incremental refresh that use the old gseg utility package name.
--                            (Issue 29279)
--   09-Apr-12   R Vattikonda MSTK objects were dropping properly.(Issue 29363) 
--   17-Sep-13   N Mohan      moved the alter session of language to the top. (Issue 33403)
--   15-Sep-15	 Arvind       Changed the query to verify previous install.
--  						 (Issue NV-1080)
--

START utlspon w_gseg_incr_refr_rset_wrapper

DEFINE nao_application_name         = "Noetix Administration Objects"

DEFINE APPS_USERID = 'APPS'
COLUMN C_APPS_USERID    new_value APPS_USERID    noprint
SELECT DISTINCT ou.oracle_username c_apps_userid
           FROM fnd_oracle_userid_s ou
          WHERE read_only_flag = 'U' AND ROWNUM = 1;

DEFINE NOETIX_USER_ID_NUM = "0"
COLUMN C_NOETIX_USER_ID_NUM new_value NOETIX_USER_ID_NUM noprint
SELECT TO_CHAR (user_id) c_noetix_user_id_num
  FROM all_users
 WHERE username = USER AND ROWNUM = 1;

COLUMN c_old_lang         new_value old_lang         noprint
COLUMN c_old_language     new_value old_language     noprint
COLUMN c_install_language new_value install_language noprint

SELECT USERENV ('LANG') c_old_lang, 
       l.nls_language   c_old_language
  FROM fnd_languages_s l
 WHERE l.language_code = USERENV ('LANG');

SELECT l.nls_language c_install_language
  FROM fnd_languages_s l
 WHERE l.language_code = '&NOETIX_LANG';

-- change the language temporarily

BEGIN
   IF ('&OLD_LANG' <> '&NOETIX_LANG')
   THEN
      EXECUTE IMMEDIATE 'alter session set NLS_LANGUAGE = ''&INSTALL_LANGUAGE''';
   END IF;
END;
/
DEFINE nao_seg_valueset_name   = "NOETIX_FLEXFIELDS(UID-&NOETIX_USER_ID_NUM)"   

DECLARE
   l_parameter_name    VARCHAR2 (50)  := NULL;
   l_prog_location     VARCHAR2 (50)  := NULL;
   l_valueset_exists   BOOLEAN        := FALSE;
   l_value_set_name    VARCHAR2 (30);
   o_st_val            VARCHAR2 (100);
   l_value_set_id      NUMBER (10);
   l_v_found           NUMBER         := 0;
BEGIN
   BEGIN
      l_value_set_name := '&NAO_SEG_VALUESET_NAME';
      l_valueset_exists :=
         &APPS_USERID..xxnao_conc_manager_pkg.valueset_exists( l_value_set_name );

      IF ( l_valueset_exists ) THEN
         DBMS_OUTPUT.put_line( 'Mentioned Value Set Exists ' || l_value_set_name || '...' );

         SELECT flex_value_set_id
           INTO l_value_set_id
           FROM fnd_flex_value_sets_s
          WHERE flex_value_set_name = l_value_set_name;
      -- &APPS_USERID..xxnao_conc_manager_pkg.delete_valueset (l_value_set_name);
      ELSE
         DBMS_OUTPUT.put_line (' Creating incremental Refresh valueset');
         DBMS_OUTPUT.put_line (   'CREATING VALUESET  '
                               || l_value_set_name
                               || '...'
                              );
         &APPS_USERID..xxnao_conc_manager_pkg.create_independent_valueset
                   (i_value_set_name               => l_value_set_name,
                    i_description                  => 'Flexfields in Global SEG processing'
                                                      || USER,
                    i_security_available           => 'N',
                    i_enable_longlist              => 'N',
                    i_format_type                  => 'Char',
                    i_maximum_size                 => '25',
                    i_precision                    => NULL,
                    i_numbers_only                 => 'N',
                    i_uppercase_only               => 'N',
                    i_right_justify_zero_fill      => 'N',
                    i_min_value                    => '',
                    i_max_value                    => ''
                   );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERROR:  Unable to create value set');
         noetix_utility_pkg.add_installation_message
                                             ('w_gseg_incr_rset',
                                              'valueset creation',
                                              'ERROR',
                                                 'Unable to create value set'
                                              || SQLERRM
                                             );
         RAISE;
   END;

   BEGIN
      DBMS_OUTPUT.put_line
                (' Creating/updating incremental Refresh valueset parameters');

      IF NOT l_valueset_exists
      THEN
         FOR i IN ( SELECT   *
                      FROM ( SELECT distinct f.id_flex_code, 
                                    f.flexfield_name
                               FROM n_f_kff_flexfields f, 
                                    n_f_kff_flex_sources fs
                              WHERE fs.source_type = 'DC'
                                AND f.id_flex_code = fs.id_flex_code
                                AND 
                                  (    NVL(fs.zero_latency, 'N')               = 'N' 
                                    OR NVL(fs.descriptions_required_flag, 'N') = 'Y')
                              UNION ALL
                             SELECT 'ALL', 'All Flexfields' 
                               FROM DUAL)
                     ORDER BY id_flex_code )
         LOOP
            &APPS_USERID..xxnao_conc_manager_pkg.create_independent_vset_value
                                  (i_flex_value_set_name             => l_value_set_name,
                                   i_flex_value                      => i.id_flex_code,
                                   i_flex_value_meaning              => i.id_flex_code,
                                   i_description                     => i.flexfield_name,
                                   i_enabled_flag                    => 'Y',
                                   i_start_date_active               => NULL,
                                   i_end_date_active                 => NULL,
                                   i_summary_flag                    => 'N',
                                   i_structured_hierarchy_level      => NULL,
                                   i_hierarchy_level                 => NULL,
                                   o_storage_value                   => o_st_val
                                  );
         END LOOP;
      ELSE
         FOR i IN
            ( SELECT distinct 
                     f.id_flex_code, 
                     f.flexfield_name
                FROM n_f_kff_flexfields f, 
                     n_f_kff_flex_sources fs
               WHERE fs.source_type = 'DC'
                 AND f.id_flex_code = fs.id_flex_code
                 AND 
                   (    NVL(fs.zero_latency, 'N')               = 'N' 
                     OR NVL(fs.descriptions_required_flag, 'N') = 'Y')
                 AND f.id_flex_code NOT IN
                   ( SELECT fv.flex_value
                       FROM fnd_flex_values_s fv
                      WHERE fv.flex_value_set_id  = l_value_set_id
                        AND fv.flex_value        != 'ALL')            )
         LOOP
            &APPS_USERID..xxnao_conc_manager_pkg.create_independent_vset_value
                                  (i_flex_value_set_name             => l_value_set_name,
                                   i_flex_value                      => i.id_flex_code,
                                   i_flex_value_meaning              => i.id_flex_code,
                                   i_description                     => i.flexfield_name,
                                   i_enabled_flag                    => 'Y',
                                   i_start_date_active               => NULL,
                                   i_end_date_active                 => NULL,
                                   i_summary_flag                    => 'N',
                                   i_structured_hierarchy_level      => NULL,
                                   i_hierarchy_level                 => NULL,
                                   o_storage_value                   => o_st_val
                                  );
         END LOOP;

         FOR i IN (SELECT fv.flex_value, 
                          fv.description, 
                          fv.enabled_flag
                     FROM noetix_fnd_flex_values_vl fv
                    WHERE flex_value_set_id  = l_value_set_id
                      AND flex_value        != 'ALL')
         LOOP
             SELECT COUNT (1)
               INTO l_v_found
               FROM n_f_kff_flexfields   f,
                    n_f_kff_flex_sources fs
              WHERE f.id_flex_code = i.flex_value
                AND f.id_flex_code  = fs.id_flex_code
                AND 
                  (    NVL(fs.zero_latency, 'N')               = 'N' 
                    OR NVL(fs.descriptions_required_flag, 'N') = 'Y' )
                AND  fs.source_type = 'DC';

            &APPS_USERID..xxnao_conc_manager_pkg.update_independent_vset_value
                            (i_flex_value_set_name             => l_value_set_name,
                             i_flex_value                      => i.flex_value,
                             i_flex_value_meaning              => i.flex_value,
                             i_description                     => i.description,
                             i_enabled_flag                    => 
                                CASE
                                  WHEN (     l_v_found      = 0 
                                         AND i.enabled_flag = 'Y' ) THEN 'N'
                                  WHEN (     l_v_found     != 0 
                                         AND i.enabled_flag = 'N' ) THEN 'Y'
                                END,
                             i_start_date_active               => NULL,
                             i_end_date_active                 => NULL,
                             i_summary_flag                    => 'N',
                             i_structured_hierarchy_level      => NULL,
                             i_hierarchy_level                 => NULL,
                             o_storage_value                   => o_st_val
                            );
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERROR:  Unable to create value set values');
         noetix_utility_pkg.add_installation_message
                                      ('w_gseg_incr_rset',
                                       'Create Valueset values',
                                       'ERROR',
                                          'Unable to create value set values'
                                       || SQLERRM
                                      );
         RAISE;
   END;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.put_line ('ERROR:  Unable to create value set');
END;
/

DEFINE APPS_USERID = 'APPS'
COLUMN C_APPS_USERID    new_value APPS_USERID    noprint
SELECT DISTINCT ou.oracle_username c_apps_userid
  FROM fnd_oracle_userid_s ou
 WHERE ou.read_only_flag = 'U' 
   AND ROWNUM = 1;

DEFINE NOETIX_USER_ID_NUM = "0"
COLUMN C_NOETIX_USER_ID_NUM new_value NOETIX_USER_ID_NUM noprint
SELECT TO_CHAR(au.user_id) c_noetix_user_id_num
  FROM all_users au
 WHERE au.username = USER 
   AND ROWNUM = 1;

-- 
-- The NAO_APPLICATION_SHORT_NAME variable (defined in the wnoetx_cm_schedule_defaults) is used to define the 
-- default application short name, which is also used as the default Oracle EBS user  The default Oracle EBS user
-- is associated with the application.  If you need to update this default, then
-- you must update the wnoetx_cm_schedule_defaults script to have the expected name.
--
--
-- Update the default application short name and aol user name for the repository setup process.
-- You can also update schedule related information
START wnoetx_cm_schedule_defaults

COLUMN init_long_name     NEW_VALUE init_long_name    NOPRINT
COLUMN init_short_name    NEW_VALUE init_short_name   NOPRINT
COLUMN init_execution_file_name NEW_VALUE init_execution_file_name NOPRINT
COLUMN noetix_sys_user      NEW_VALUE p_noetix_admin      NOPRINT

DEFINE nao_application_name         = "Noetix Administration Objects"
DEFINE nao_application_base_path    = "&NAO_APPLICATION_SHORT_NAME._TOP"
--DEFINE nao_user_name                = "&NAO_APPLICATION_SHORT_NAME"
DEFINE nao_user_name                = "&NAO_USER_NAME" -- added
DEFINE nao_user_password            = "Welcome#1"
DEFINE nao_responsibility_name      = "&NAO_APPLICATION_NAME (&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])"
DEFINE nao_responsibility_key       = "&NAO_APPLICATION_SHORT_NAME..NOETIX(UID-&NOETIX_USER_ID_NUM)"
DEFINE nao_security_group_key       = "STANDARD"
DEFINE nao_menu_name                = "&NAO_APPLICATION_SHORT_NAME Menu"
DEFINE nao_menu_type                = "STANDARD"
DEFINE nao_menu_entry_function1     = 'FND_FNDRSRUN'
DEFINE nao_menu_entry_prompt1       = 'Submit Requests'
DEFINE nao_menu_entry_desc1         = 'Submit Requests for the &NAO_APPLICATION_NAME Application'
DEFINE nao_menu_entry_function2     = 'FND_FNDCPQCR'
DEFINE nao_menu_entry_prompt2       = 'View Requests'
DEFINE nao_menu_entry_desc2         = 'View Requests for the &NAO_APPLICATION_NAME Application'
DEFINE nao_request_group_name       = "&NAO_APPLICATION_NAME"
DEFINE nao_data_group_name          = "Standard"
DEFINE nao_schema_name              = "&NOETIX_USER"
DEFINE nao_seg_responsibility_name  = "&NAO_APPLICATION_NAME..KFF(&NOETIX_USER[UID-&NOETIX_USER_ID_NUM])"
DEFINE nao_seg_responsibility_key   = "&NAO_APPLICATION_SHORT_NAME..KFF-NOETIX(UID-&NOETIX_USER_ID_NUM)"
DEFINE nao_seg_request_group_name   = "&NAO_APPLICATION_SHORT_NAME._KFF"

DEFINE nao_oracle_username          = '&APPS_USERID'

--set termout off

---Below script for incremental Refresh Request Set Creation
----


DECLARE
   l_prog_location            VARCHAR2 (500) := NULL;
   l_stage                    VARCHAR2 (50)  := NULL;
   l_old_stage                VARCHAR2 (50);
   l_new_stage                VARCHAR2 (50);
   l_stage_sequence           NUMBER         := NULL;
   l_error_msg                VARCHAR2 (200);
   l_prev_prog_short_name     VARCHAR2 (200);
   l_compatability_exists     BOOLEAN;
   l_schedule_exists          CHAR           := 'Y';
   l_errmsg                   VARCHAR2 (230);
   l_success                  BOOLEAN;
   l_requestset_exists        BOOLEAN;
   l_stage_exists             BOOLEAN;
   lc_process_type   CONSTANT VARCHAR2 (100) := 'GSEG';
   l_request_set_name         VARCHAR2 (200);
   l_reqset_short_name        VARCHAR2 (100);

   CURSOR c1 IS
      SELECT au.user_id
        FROM all_users au
       WHERE au.username = USER 
         AND ROWNUM = 1;

   CURSOR c_incr_rset_details (
      p_user_id            IN   NUMBER,
      p_request_set_name   IN   VARCHAR2
   )
   IS
      SELECT   s.*,
               (CASE
                   WHEN concurrent_program_id IS NULL
                      THEN NVL (max_pgm_seq, 0) + pgm_seq
                   ELSE pgm_seq
                END
               ) program_sequence
          FROM (SELECT MAX (pgm_rank) OVER () max_stages, pgm_rank stage_seq,
                       pgms4key, table_name, program_name, program_short_name,
                       CASE
                          WHEN pgm_rank = 1
                             THEN    'STG-'
                                  || TO_CHAR (p_user_id || '-DC-VALUE')
                          ELSE 'STG-' || TO_CHAR (p_user_id || '-DC-DESC')
                       END stage_name,
                       ROW_NUMBER () OVER (PARTITION BY pgm_rank ORDER BY program_id)
                                                                      pgm_seq,
                       MAX (program_sequence) OVER (PARTITION BY pgm_rank)
                                                                  max_pgm_seq,
                       request_set_stage_id, concurrent_program_id,
                       program_id, data_table_key
                  FROM (SELECT COUNT (*) OVER (PARTITION BY fsp.data_table_key)
                                                                     pgms4key,
                               DENSE_RANK () OVER (PARTITION BY fsp.data_table_key ORDER BY fsp.program_id)
                                                                     pgm_rank,
                               fsp.table_name, fsp.program_name,
                               fsp.program_short_name, fsp.program_id,
                               fsp.data_table_key,
                               frsp.SEQUENCE program_sequence,
                               frsp.concurrent_program_id,
                               frst.request_set_id, frsp.request_set_stage_id
                          FROM n_f_kff_flex_source_pgms fsp,
                               n_f_kff_flex_sources fs,
                               fnd_request_set_stages_tl_s frstg,
                               fnd_request_sets_tl_s       frst,
                               fnd_request_set_programs_s  frsp,
                               fnd_concurrent_programs_s   fcp
                         WHERE fsp.program_type = 'INCREMENTAL'
                           AND fcp.concurrent_program_name(+) =
                                                UPPER (fsp.program_short_name)
                           AND frsp.concurrent_program_id(+) =
                                                     fcp.concurrent_program_id
                           AND frsp.request_set_stage_id = frstg.request_set_stage_id(+)
                           AND frstg.LANGUAGE(+) LIKE
                                                   noetix_env_pkg.get_language
                           AND frstg.request_set_id = frst.request_set_id(+)
                           AND frst.LANGUAGE(+) LIKE
                                                   noetix_env_pkg.get_language
                           AND frst.user_request_set_name(+) =
                                                            p_request_set_name
                           AND fsp.data_table_key = fs.data_table_key
                           AND 
                             (    NVL(fs.zero_latency,'N')                = 'N' 
                               OR NVL(fs.descriptions_required_flag,'N')  = 'Y') ) ) s
      ORDER BY stage_seq, 
               program_id;

--remove request set programs
   CURSOR cur_unused_programs (p_request_set_name IN VARCHAR2)
   IS
      SELECT   frstg.user_stage_name stage_name, frsp.request_set_program_id,
               frstg.request_set_stage_id, frsp.concurrent_program_id,
               fcp.concurrent_program_name, frsp.SEQUENCE program_sequence,
               frsp.program_application_id
          FROM fnd_request_set_stages_tl_s frstg,
               fnd_request_sets_tl_s       frst,
               fnd_request_set_programs_s  frsp,
               fnd_concurrent_programs_s   fcp
         WHERE frstg.request_set_id         = frst.request_set_id
           AND frstg.LANGUAGE            LIKE noetix_env_pkg.get_language
           AND frst.user_request_set_name   = p_request_set_name
           AND frst.LANGUAGE             LIKE noetix_env_pkg.get_language
           AND frsp.request_set_id          = frst.request_set_id
           AND frsp.request_set_stage_id    = frstg.request_set_stage_id
           AND frsp.concurrent_program_id   = fcp.concurrent_program_id
           AND NOT EXISTS 
             ( SELECT 1
                 FROM n_f_kff_flex_source_pgms fsp,
                      n_f_kff_flex_sources fs
                WHERE fsp.program_type = 'INCREMENTAL'
                  AND fcp.concurrent_program_name =
                                               UPPER (fsp.program_short_name)
                  AND fsp.data_table_key = fs.data_table_key
                  AND 
                    (    NVL(fs.zero_latency,'N')                = 'N' 
                      OR NVL(fs.descriptions_required_flag,'N')  = 'Y') )
      ORDER BY frstg.request_set_stage_id;

--remove request set stages
   CURSOR cur_unused_stage (p_request_set_name IN VARCHAR2) IS
      SELECT frstg.user_stage_name stage_name, frstg.request_set_stage_id
        FROM fnd_request_set_stages_tl_s frstg,
             fnd_request_sets_tl_s       frst
       WHERE frstg.request_set_id       = frst.request_set_id
         AND frstg.LANGUAGE          LIKE noetix_env_pkg.get_language
         AND frst.user_request_set_name = p_request_set_name
         AND frst.LANGUAGE           LIKE noetix_env_pkg.get_language
         AND frstg.user_stage_name   LIKE 'STG%-DC-DESC'
         AND NOT EXISTS 
           ( SELECT 1
               FROM n_f_kff_flex_source_pgms fsp, n_f_kff_flex_sources fs
              WHERE fsp.program_type = 'INCREMENTAL'
                AND fs.target_desc_object_name = fsp.table_name
                AND fs.descriptions_required_flag = 'Y'
                AND 
                  (    NVL(fs.zero_latency,'N')                = 'N' 
                    OR NVL(fs.descriptions_required_flag,'N')  = 'Y' ) );

   r1                         c1%ROWTYPE;
BEGIN
   OPEN c1;

   FETCH c1
    INTO r1;

   CLOSE c1;

   l_prog_location := 'Setting Session Mode';
   SAVEPOINT begin_requestset;
   &APPS_USERID..xxnao_conc_manager_pkg.apps_initialize
                                           --   ('&NAO_APPLICATION_SHORT_NAME', modified
										   ('&NAO_USER_NAME',
                                               '&NAO_SEG_RESPONSIBILITY_KEY'
                                              );
   l_request_set_name   := UPPER ('INCREMENTAL_REFRESH-' || USER || '[UID-' || r1.user_id || '])');
   l_reqset_short_name  := UPPER ('INCR_REFR' || '-RSET' || '(UID-' || r1.user_id || ')');
   l_prog_location      := 'Check the existence of request set for Incremental Refresh';
   l_requestset_exists  :=
      &APPS_USERID..xxnao_conc_manager_pkg.check_request_set( l_reqset_short_name,
                                                              '&NAO_APPLICATION_SHORT_NAME' );

   IF ( l_requestset_exists ) THEN
      l_prog_location    := 'Remove unused stages and programs';
      DBMS_OUTPUT.put_line('Remove unused stage and programs');

      FOR rec_usage IN cur_unused_stage (l_request_set_name)
      LOOP
         &APPS_USERID..xxnao_conc_manager_pkg.remove_stage_from_set
                         (i_request_set          => l_reqset_short_name,
                          i_set_application      => '&NAO_APPLICATION_SHORT_NAME',
                          i_stage                => rec_usage.stage_name
                         );
      END LOOP;

      COMMIT;

      FOR rec_upgm IN cur_unused_programs (l_request_set_name)
      LOOP
         &APPS_USERID..xxnao_conc_manager_pkg.remove_program_from_stage
                     (i_program                  => rec_upgm.concurrent_program_name,
                      i_program_application      => '&NAO_APPLICATION_SHORT_NAME',
                      i_request_set              => l_reqset_short_name,
                      i_set_application          => '&NAO_APPLICATION_SHORT_NAME',
                      i_stage                    => rec_upgm.stage_name,
                      i_program_sequence         => rec_upgm.program_sequence
                     );
      END LOOP;

      COMMIT;
   END IF;

   FOR rec_rs IN c_incr_rset_details (r1.user_id, l_request_set_name)
   -- c_incr_rset_details loop
   LOOP
      IF c_incr_rset_details%ROWCOUNT = 1 AND NOT l_requestset_exists
      THEN  -- Code to run only once in loop and Request set not exists  #CT1
         BEGIN
            DBMS_OUTPUT.put_line
                              ('Creating Request Set for Incremental Refresh');
            l_prog_location := 'Creating request set for Incremental Refresh';
            &APPS_USERID..xxnao_conc_manager_pkg.create_request_set
                             (i_name                           => l_request_set_name,
                              i_short_name                     => l_reqset_short_name,
                              i_application                    => '&NAO_APPLICATION_SHORT_NAME',
                              i_description                    => l_request_set_name,
                              i_incompatibilities_allowed      => 'Y'
                             );
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK TO begin_requestset;
               DBMS_OUTPUT.put_line
                           (   'ERROR:  Unable to create the Request Set  '
                            || l_reqset_short_name
                           );
               noetix_utility_pkg.add_installation_message
                                      ('w_gseg_incr_refr_rset',
                                       l_prog_location,
                                       'ERROR',
                                          'Unable to create the Request Set '
                                       || l_reqset_short_name
                                       || SQLERRM,
                                       SYSDATE,
                                       lc_process_type
                                      );
               RAISE;
         END;

         BEGIN
            l_prog_location := 'Adding request set to request group';
            &APPS_USERID..xxnao_conc_manager_pkg.add_set_to_group
                        (i_request_set            => l_reqset_short_name,
                         i_set_application        => '&NAO_APPLICATION_SHORT_NAME',
                         i_request_group          => '&NAO_SEG_REQUEST_GROUP_NAME',
                         i_group_application      => '&NAO_APPLICATION_SHORT_NAME'
                        );
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK TO begin_requestset;
               DBMS_OUTPUT.put_line
                          (   'ERROR:  Unable to add request set '
                           || l_reqset_short_name
                           || ' to request group  "&NAO_SEG_REQUEST_GROUP_NAME"'
                          );
               noetix_utility_pkg.add_installation_message
                       ('w_gseg_incr_refr_rset',
                        l_prog_location,
                        'ERROR',
                           'Unable to add request set '
                        || l_reqset_short_name
                        || ' to request group  "&NAO_SEG_REQUEST_GROUP_NAME"'
                        || SQLERRM,
                        SYSDATE,
                        lc_process_type
                       );
               RAISE;
         END;
      END IF;                                                           --#CT1

      DBMS_OUTPUT.put_line ('Adding Stages and Programs To Request Set ');

      IF (rec_rs.pgm_seq = 1)
      THEN                                       --First program in stage #FPS
         IF rec_rs.stage_seq = 1
         THEN
            l_old_stage := rec_rs.stage_name;
         END IF;

         l_stage_exists :=
            &APPS_USERID..xxnao_conc_manager_pkg.stage_in_request_set_exists
                           (i_stage                => rec_rs.stage_name,
                            i_request_set          => l_reqset_short_name,
                            i_set_application      => '&NAO_APPLICATION_SHORT_NAME'
                           );

         IF NOT l_stage_exists
         THEN                                                     --#STGEXISTS
            BEGIN
               l_prog_location := 'Creating Stage in request set';
               &APPS_USERID..xxnao_conc_manager_pkg.add_stage_to_set
                         (i_name                           => rec_rs.stage_name,
                          i_request_set                    => l_reqset_short_name,
                          i_set_application                => '&NAO_APPLICATION_SHORT_NAME',
                          i_short_name                     => rec_rs.stage_name,
                          i_description                    => rec_rs.stage_name,
                          i_display_sequence               => rec_rs.stage_seq,
                          i_start_stage                    => CASE
                             WHEN rec_rs.stage_seq = 1
                                THEN 'Y'
                             ELSE 'N'
                          END,
                          i_critical                       => 'Y',
                          i_incompatibilities_allowed      => 'Y'
                         );
            EXCEPTION
               WHEN OTHERS
               THEN
                  ROLLBACK TO begin_requestset;
                  DBMS_OUTPUT.put_line (   'ERROR:  Unable to add stage '
                                        || l_stage
                                        || ' to request set  '
                                        || l_reqset_short_name
                                       );
                  noetix_utility_pkg.add_installation_message
                                                   ('w_gseg_incr_refr_rset',
                                                    l_prog_location,
                                                    'ERROR',
                                                       'Unable to add stage '
                                                    || l_stage
                                                    || ' to request set  '
                                                    || l_reqset_short_name
                                                    || SQLERRM,
                                                    SYSDATE,
                                                    lc_process_type
                                                   );
                  RAISE;
            END;

            IF (rec_rs.stage_seq > 1)
            THEN                                                    --#LINKSTG
               l_prog_location :=
                       'Linking Stages in request set' || l_reqset_short_name;

               BEGIN
                  &APPS_USERID..xxnao_conc_manager_pkg.link_stages_in_set
                         (i_request_set          => l_reqset_short_name,
                          i_set_application      => '&NAO_APPLICATION_SHORT_NAME',
                          i_from_stage           => l_old_stage,
                          i_to_stage             => rec_rs.stage_name,
                          i_success              => 'Y'
                         );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     ROLLBACK TO begin_requestset;
                     DBMS_OUTPUT.put_line
                                        (   'ERROR:  Unable to link stage '
                                         || l_new_stage
                                         || ' to '
                                         || l_old_stage
                                        );
                     noetix_utility_pkg.add_installation_message
                                                   ('w_gseg_incr_refr_rset',
                                                    l_prog_location,
                                                    'ERROR',
                                                       'Unable to add stage '
                                                    || l_stage
                                                    || ' to request set  '
                                                    || l_reqset_short_name
                                                    || SQLERRM,
                                                    SYSDATE,
                                                    lc_process_type
                                                   );
                     RAISE;
               END;
            END IF;                                                -- #LINKSTG
         END IF;                                                  --#STGEXISTS
      END IF;                                                           --#FPS

      IF rec_rs.concurrent_program_id IS NULL
      THEN                                           -- Program already exists
         l_prog_location := 'Adding Programs to request set';

         BEGIN
            &APPS_USERID..xxnao_conc_manager_pkg.add_program_to_stage
                     (i_program                  => UPPER
                                                       (rec_rs.program_short_name
                                                       ),
                      i_program_application      => '&NAO_APPLICATION_SHORT_NAME',
                      i_request_set              => l_reqset_short_name,
                      i_set_application          => '&NAO_APPLICATION_SHORT_NAME',
                      i_stage                    => rec_rs.stage_name,
                      i_program_sequence         => rec_rs.program_sequence,
                      i_critical                 => 'Y',
                      i_number_of_copies         => 0,
                      i_save_output              => 'N',
                      i_style                    => NULL,
                      i_printer                  => NULL
                     );
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK TO begin_requestset;
               DBMS_OUTPUT.put_line (   'ERROR:  Unable to add program '
                                     || UPPER (rec_rs.program_short_name)
                                     || ' to '
                                     || l_reqset_short_name
                                    );
               noetix_utility_pkg.add_installation_message
                                          ('w_gseg_incr_refr_rset',
                                           l_prog_location,
                                           'ERROR',
                                              'Unable to add program '
                                           || UPPER (rec_rs.program_short_name)
                                           || ' to '
                                           || l_reqset_short_name
                                           || SQLERRM,
                                           SYSDATE,
                                           lc_process_type
                                          );
               RAISE;
         END;
      END IF;

      IF (rec_rs.pgms4key > 1) THEN    --If the program has descriptions add incompatibility #PGMINCOMP
         SELECT f.program_short_name
           INTO l_prev_prog_short_name
           FROM n_f_kff_flex_source_pgms f,
                n_f_kff_flex_sources fs
          WHERE f.data_table_key    = rec_rs.data_table_key
            AND f.program_type      = 'INCREMENTAL'
            AND f.program_id       <> rec_rs.program_id
            AND f.data_table_key    = fs.data_table_key
            AND 
              (    NVL(fs.zero_latency, 'N')               = 'N' 
                OR NVL(fs.descriptions_required_flag, 'N') = 'Y' )
            AND fs.source_type = 'DC';

         l_prog_location :=
            'Adding incompatability for the concurrent programs within request set';
         DBMS_OUTPUT.put_line
            ('Adding incompatability for the concurrent programs within request set'
            );

         BEGIN
            l_compatability_exists :=
               &APPS_USERID..xxnao_conc_manager_pkg.check_program_incompatibility
                   (i_program_short_name        => UPPER
                                                      (rec_rs.program_short_name
                                                      ),
                    i_application               => '&NAO_APPLICATION_SHORT_NAME',
                    i_inc_prog_short_name       => UPPER
                                                       (l_prev_prog_short_name),
                    i_inc_prog_application      => '&NAO_APPLICATION_SHORT_NAME'
                   );

            IF (NOT l_compatability_exists)
            THEN
               &APPS_USERID..xxnao_conc_manager_pkg.add_program_incompatibility
                   (i_program_short_name        => UPPER
                                                      (rec_rs.program_short_name
                                                      ),
                    i_application               => '&NAO_APPLICATION_SHORT_NAME',
                    i_inc_prog_short_name       => UPPER
                                                       (l_prev_prog_short_name),
                    i_inc_prog_application      => '&NAO_APPLICATION_SHORT_NAME'
                   );
            ELSE
               DBMS_OUTPUT.put_line
                  ('NOTE: Incompatability for the concurrent programs within request set already exists'
                  );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK TO begin_requestset;
               DBMS_OUTPUT.put_line
                  ('ERROR:  Unable to add incompatability for the concurrent programs within request set'
                  );
               noetix_utility_pkg.add_installation_message
                  ('w_gseg_incr_refr_rset',
                   'Add_Incompatability for programs within request set',
                   'ERROR',
                      'Unable to add incompatability for the concurrent programs'
                   || UPPER (rec_rs.program_short_name)
                   || 'and'
                   || UPPER (l_prev_prog_short_name)
                   || ' within request set - '
                   || SQLERRM,
                   SYSDATE,
                   lc_process_type
                  );
               RAISE;
         END;
      END IF;                                                    ---#PGMINCOMP
   END LOOP;                                -- end of c_incr_rset_details loop

   IF NOT l_requestset_exists
   THEN
      l_prog_location := 'Adding self Incompatability to request set';
      DBMS_OUTPUT.put_line (   'Adding self Incompatability to request set '
                            || l_reqset_short_name
                           );

      BEGIN
         l_compatability_exists :=
            &APPS_USERID..xxnao_conc_manager_pkg.check_req_set_incompatibility
                      (i_request_set              => l_reqset_short_name,
                       i_application              => '&NAO_APPLICATION_SHORT_NAME',
                       i_inc_request_set          => l_reqset_short_name,
                       i_inc_set_application      => '&NAO_APPLICATION_SHORT_NAME'
                      );

         IF (NOT l_compatability_exists)
         THEN
            &APPS_USERID..xxnao_conc_manager_pkg.add_req_set_incompatibility
                      (i_request_set              => l_reqset_short_name,
                       i_application              => '&NAO_APPLICATION_SHORT_NAME',
                       i_inc_request_set          => l_reqset_short_name,
                       i_inc_set_application      => '&NAO_APPLICATION_SHORT_NAME'
                      );
         ELSE
            DBMS_OUTPUT.put_line (   'NOTE: Incompatability for '
                                  || l_reqset_short_name
                                  || ' already exists'
                                 );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            ROLLBACK TO begin_requestset;
            DBMS_OUTPUT.put_line
                        ('ERROR:  Unable to create the Concurrent Program ');
            noetix_utility_pkg.add_installation_message
                      ('w_gseg_incr_refr_rset',
                       'Add_Incompatability',
                       'ERROR',
                          'Unable to add program to incompatability list - '
                       || SQLERRM,
                       SYSDATE,
                       lc_process_type
                      );
            RAISE;
      END;
   ELSE
      DBMS_OUTPUT.put_line ('Concurrentrequest set already exists');
   END IF;

   --update request_set_short_name
   BEGIN
      UPDATE n_f_kff_flex_source_pgms
         SET request_set_short_name = l_reqset_short_name
       WHERE program_type = 'INCREMENTAL';
   EXCEPTION
      WHEN OTHERS
      THEN
         noetix_utility_pkg.add_installation_message
                          ('w_gseg_incr_refr_rset',
                           l_prog_location,
                           'ERROR',
                              'Unable to update the request_set_short_name '
                           || SQLERRM,
                           SYSDATE,
                           lc_process_type
                          );
   END;

   --NO scheduling of the request
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20001,
                               l_prog_location || ': ' || SQLERRM (SQLCODE)
                              );
END;
/

SPOOL off

--end of request set creation for incremental refresh program

START utlspon w_gseg_incr_refr_enable_pgm

-- Grant execute on the package used by the concurrent manager to the APPS userid.
set serveroutput on size 1000000
execute n_grant_object_access( 'EXECUTE',   '&NOETIX_USER', 'N_GSEG_PGM_UTL_PKG',           '&APPS_USERID' )

DECLARE
   lb_applicationexists       BOOLEAN;
   lb_executable_exists       BOOLEAN;
   li_application_id          INTEGER;
   li_executable_id           INTEGER;
--    lb_program_exists       BOOLEAN;
   lv_program_exists          VARCHAR2 (1);
   l_program_short_name       VARCHAR2 (100)
                              := 'N_KFF_ENABLE_INCR_REFR-&NOETIX_USER_ID_NUM';
   l_execution_file_name      VARCHAR2 (100)
                              := '&NAO_SCHEMA_NAME..N_GSEG_PGM_UTL_PKG.ENBL_INCR';
   -- This is the name prior to NVA 6.1
   ls_old_execution_file_name VARCHAR2 (100)
                              := '&NAO_SCHEMA_NAME..N_GSEG_UTILITY_PKG.ENBL_INCR';
   l_program_name             VARCHAR2 (100)
      := 'Enable Incremental Refresh-(&NAO_SCHEMA_NAME[UID-&NOETIX_USER_ID_NUM])';
   lb_program_in_group        BOOLEAN;
   lv_schedule_exists         VARCHAR2 (1);
   lv_compatability_exists    BOOLEAN;
   lv_compile_menu            VARCHAR2 (2000);
   lc_schedule_program        CHAR;
   ln_request_id              NUMBER;
   lv_value_set_name          VARCHAR2 (100);
   lv_parameter_name          VARCHAR2 (100);
   lc_process_type   CONSTANT VARCHAR2 (100)  := 'GSEG';
BEGIN
   SAVEPOINT begin_cmschedule;
   DBMS_OUTPUT.put_line ('**');
   ----
   --
   ----
   DBMS_OUTPUT.put_line ('Creating Executable - ' || l_execution_file_name);

   BEGIN
      lb_executable_exists :=
         &APPS_USERID..xxnao_conc_manager_pkg.executable_exists( i_short_name  => UPPER( l_program_short_name ),
                                                                 i_application => '&NAO_APPLICATION_SHORT_NAME'  );

      IF ( lb_executable_exists ) THEN
        BEGIN
          -- Check to see if we need to upgrade the executable file name
          -- Looking for an fnd_executable record with the old execution file name used prior to 6.1.
          SELECT exe.application_id,
                 exe.executable_id
            INTO li_application_id,
                 li_executable_id
            FROM fnd_executables_s exe
           WHERE UPPER(exe.executable_name)        = UPPER(l_program_short_name)
             AND UPPER(exe.execution_file_name)    = UPPER(ls_old_execution_file_name);

          DBMS_OUTPUT.put_line( 'NOTE:  Upgrading Executable '|| l_program_short_name );
          -- We must have found the old package, so upgrade the existing executable
          &APPS_USERID..xxnao_conc_manager_pkg.update_executable( i_application_id           => li_application_id,
                                                                  i_executable_id            => li_executable_id,
                                                                  i_executable               => l_program_short_name,
                                                                  i_description              => l_program_short_name,
                                                                  i_execution_method         => 'PL/SQL Stored Procedure',
                                                                  i_execution_file_name      => l_execution_file_name,
                                                                  i_execution_file_path      => NULL,
                                                                  i_subroutine_name          => NULL  );

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              -- Did not find the old execution package in the executable
              DBMS_OUTPUT.put_line( 'NOTE:  Executable '|| l_program_short_name || ' already exists' );
        END;
      ELSE
         &APPS_USERID..xxnao_conc_manager_pkg.create_executable( i_executable               => l_program_short_name,
                                                                 i_application              => '&NAO_APPLICATION_SHORT_NAME',
                                                                 i_short_name               => UPPER(l_program_short_name),
                                                                 i_description              => l_program_short_name,
                                                                 i_execution_method         => 'PL/SQL Stored Procedure',
                                                                 i_execution_file_name      => l_execution_file_name,
                                                                 i_execution_file_path      => NULL,
                                                                 i_subroutine_name          => NULL );
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK TO begin_cmschedule;
         DBMS_OUTPUT.put_line( 'ERROR:  Unable to create the Executable ' || l_program_short_name );
         noetix_utility_pkg.add_installation_message
                                       ('w_gseg_incr_refr_rset',
                                        'Create_exectutable',
                                        'ERROR',
                                           'Unable to create the Executable '
                                        || l_program_short_name
                                        || ' - '
                                        || SQLERRM,
                                        SYSDATE,
                                        lc_process_type
                                       );
         RAISE;
   END;

   DBMS_OUTPUT.put_line ('**');
   ----
   --
   ----
   DBMS_OUTPUT.put_line (   'Creating Concurrent Program for '
                         || l_program_short_name
                        );

   BEGIN
      -- Even through we are using i_program as the parameter for the program_exists function call,
      -- It actually requires the short name of the program.
      lv_program_exists :=
         &APPS_USERID..xxnao_conc_manager_pkg.program_exists
                              (i_program          => UPPER
                                                         (l_program_short_name),
                               i_application      => '&NAO_APPLICATION_SHORT_NAME'
                              );

      IF (lv_program_exists = 'N')
      THEN
         -- The i_program parameter for create_conc_program requires the executable long name (not the short name).
         &APPS_USERID..xxnao_conc_manager_pkg.create_conc_program
                  (i_program                     => l_program_name,
                   i_application                 => '&NAO_APPLICATION_SHORT_NAME',
                   i_enabled                     => 'Y',
                   i_short_name                  => UPPER
                                                         (l_program_short_name),
                   i_description                 => l_program_short_name,
                   i_executable_short_name       => UPPER
                                                         (l_program_short_name),
                   i_executable_application      => '&NAO_APPLICATION_SHORT_NAME',
                   i_use_in_srs                  => 'Y'
                  );
      ELSE
         DBMS_OUTPUT.put_line (   'NOTE:  Concurrent Program '
                               || l_program_short_name
                               || ' already exists'
                              );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK TO begin_cmschedule;
         DBMS_OUTPUT.put_line
                     (   'ERROR:  Unable to create the Concurrent Program '
                      || l_program_short_name
                     );
         noetix_utility_pkg.add_installation_message
                               ('w_gseg_incr_refr_rset',
                                'Create_exectutable',
                                'ERROR',
                                   'Unable to create the Concurrent Program '
                                || l_program_short_name
                                || ' - '
                                || SQLERRM,
                                SYSDATE,
                                lc_process_type
                               );
         RAISE;
   END;

   DBMS_OUTPUT.put_line ('**');
   ----
   --
   DBMS_OUTPUT.put_line ('Creating Parameters - ' || l_program_short_name);

   BEGIN
      IF (lv_program_exists = 'N')
      THEN
         lv_value_set_name := 'NOETIX_FLEXFIELDS(UID-&NOETIX_USER_ID_NUM)';
         lv_parameter_name := 'Flex_Code';
         &APPS_USERID..xxnao_conc_manager_pkg.create_parameter
                        (i_program_short_name          => UPPER
                                                             (l_program_short_name
                                                             ),
                         i_application                 => '&NAO_APPLICATION_NAME',
                         i_sequence                    => 10,
                         i_parameter                   => lv_parameter_name,
                         i_description                 => NULL,
                         i_enabled                     => 'Y',
                         i_value_set                   => lv_value_set_name,
                         i_default_type                => 'Constant',
                         i_default_value               => 'ALL',
                         i_required                    => 'Y',
                         i_enable_security             => 'N',
                         i_range                       => '',
                         i_display                     => 'Y',
                         i_display_size                => 30,
                         i_description_size            => 50,
                         i_concatenated_desc_size      => 25,
                         i_prompt                      => 'Flexfield Code',
                         i_token                       => NULL,
                         i_cd_parameter                => NULL
                        );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK TO begin_cmschedule;
         DBMS_OUTPUT.put_line (   'ERROR:  Unable to create the parameter '
                               || lv_parameter_name
                               || ' to the program '
                               || l_program_short_name
                              );
         noetix_utility_pkg.add_installation_message
                                             ('wsegconfigCMSchedule',
                                              'Create_parameters',
                                              'ERROR',
                                                 'Unable to create parameter '
                                              || lv_parameter_name
                                              || ' to the program '
                                              || l_program_short_name
                                              || ' - '
                                              || SQLERRM
                                             );
         RAISE;
   END;

   ----
   DBMS_OUTPUT.put_line (   'Adding Concurrent Program to Request Group for '
                         || l_program_short_name
                        );

   BEGIN
      lb_program_in_group :=
         &APPS_USERID..xxnao_conc_manager_pkg.program_in_group
                     (i_program_short_name       => UPPER
                                                         (l_program_short_name),
                      i_program_application      => '&NAO_APPLICATION_SHORT_NAME',
                      i_request_group            => '&NAO_SEG_REQUEST_GROUP_NAME',
                      i_group_application        => '&NAO_APPLICATION_SHORT_NAME'
                     );

      IF (NOT lb_program_in_group)
      THEN
         &APPS_USERID..xxnao_conc_manager_pkg.add_program_to_group
                     (i_program_short_name       => UPPER
                                                         (l_program_short_name),
                      i_program_application      => '&NAO_APPLICATION_SHORT_NAME',
                      i_request_group            => '&NAO_SEG_REQUEST_GROUP_NAME',
                      i_group_application        => '&NAO_APPLICATION_SHORT_NAME'
                     );
      ELSE
         DBMS_OUTPUT.put_line
               (   'NOTE:  Concurrent Program '
                || UPPER (l_program_short_name)
                || 'already exists in Request Group &NAO_SEG_REQUEST_GROUP_NAME'
               );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK TO begin_cmschedule;
         DBMS_OUTPUT.put_line
                        (   'ERROR:  Unable to add the Concurrent Program '
                         || UPPER (l_program_short_name)
                         || ' to Request Group "&NAO_SEG_REQUEST_GROUP_NAME"'
                        );
         noetix_utility_pkg.add_installation_message
                     ('w_gseg_incr_refr_rset',
                      'add_program_to_group',
                      'ERROR',
                         'Unable to add the Concurrent Program '
                      || UPPER (l_program_short_name)
                      || ' to Request Group "&NAO_SEG_REQUEST_GROUP_NAME" - '
                      || SQLERRM,
                      SYSDATE,
                      lc_process_type
                     );
         RAISE;
   END;

   COMMIT;

--Below code to enable incremental refresh with the previous settings.
--The below script will only be executed if its a regeneration of existing install.
   DECLARE
      l_prev_stage_creation_date   DATE   := NULL;
      l_request_id                 NUMBER := NULL;
   BEGIN
      --Verify previous install stage
      BEGIN
         SELECT creation_date
           INTO l_prev_stage_creation_date
           FROM (SELECT creation_date, install_status,
                        DENSE_RANK () OVER (PARTITION BY install_stage ORDER BY creation_date DESC) rk
                   FROM n_view_parameters
                  WHERE install_stage = 4 
and install_status ='Completed')
          WHERE rk = 1 AND install_status = 'Completed' ;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_prev_stage_creation_date := NULL;
      END;

      IF l_prev_stage_creation_date IS NOT NULL
      THEN
         DBMS_OUTPUT.put_line
            (' Applying the previous setting for Incremental Refresh programs'
            );

         FOR rec_flex IN
            (SELECT f.id_flex_code, ROWNUM rn
               FROM n_f_kff_flexfields f
              WHERE INSTR
                       ( n_view_parameters_api_pkg.get_parameter_ext_value
                                                 ('TRACK_INCR_REFRESH_UPDATE',
                                                  4,
                                                  l_prev_stage_creation_date
                                                 ),
                        id_flex_code
                       ) > 0
                AND EXISTS
                  ( SELECT NULL 
                      FROM n_f_kff_flex_sources fs
                     WHERE fs.id_flex_code = f.id_flex_code  
                       AND 
                         (    NVL(fs.zero_latency, 'N')               = 'N' 
                           OR NVL(fs.descriptions_required_flag, 'N') = 'Y' )
                       AND fs.source_type = 'DC' ) )
         LOOP
            IF rec_flex.rn = 1
            THEN
               DBMS_OUTPUT.put_line
                     (' Submiting Enable Incremental Refresh programs for...');
            END IF;

            --Mark the enable_incr_refresh_flag to I
            --This is to indicate that this is a regeneration install and complete refresh is not required to be submitted.
            UPDATE n_f_kff_flexfields
               SET enable_incr_refresh_flag = 'I'
             WHERE id_flex_code = rec_flex.id_flex_code;

            &APPS_USERID..xxnao_conc_manager_pkg.submit_request
               (i_user_name        => '&NAO_USER_NAME',
                i_resp_key         => '&NAO_SEG_RESPONSIBILITY_KEY',
                i_application      => '&NAO_APPLICATION_SHORT_NAME',
                i_program          => UPPER (l_program_short_name),
                i_description      => 'Enable Incremental Refresh with previous settings',
                i_argument1        => rec_flex.id_flex_code,
                o_request_id       => l_request_id
               );
            DBMS_OUTPUT.put_line (   '  Flex Code :'
                                  || rec_flex.id_flex_code
                                  || ' Request Id :'
                                  || l_request_id
                                 );
         END LOOP;

         COMMIT;
      END IF;

      IF l_request_id IS NULL
      THEN
         DBMS_OUTPUT.put_line
            (' Previous settings for Incremental Refresh programs not available'
            );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         DBMS_OUTPUT.put_line (' ');
         DBMS_OUTPUT.put_line
            ('WARNING:  Unable to enable Incremental Refresh with previous settings, the program'
            );
         DBMS_OUTPUT.put_line
            ('.         was terminated prematurely.  Consult the Administrators Guide for more details '
            );
         DBMS_OUTPUT.put_line
            ('.         or contact support.  In the interim you many need to manually enable the incremental refresh  '
            );
         DBMS_OUTPUT.put_line (' ');
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line
         ('WARNING:  Concurrent Manager job for the Noetix data cache table Incremental Refresh Program'
         );
      DBMS_OUTPUT.put_line
         ('.         was terminated prematurely.  Consult the Administrators Guide for more details '
         );
      DBMS_OUTPUT.put_line
         ('.         or contact support.  In the interim you many need to manually schedule this task  '
         );
      DBMS_OUTPUT.put_line (' ');
END;
/

SPOOL off

-- change the language back to the original installation language

BEGIN
   IF ('&OLD_LANG' <> '&NOETIX_LANG')
   THEN
      EXECUTE IMMEDIATE 'alter session set NLS_LANGUAGE = ''&OLD_LANGUAGE''';
   END IF;
END;
/

UNDEFINE install_language
UNDEFINE old_language
UNDEFINE old_lang

UNDEFINE nao_application_short_name
UNDEFINE nao_SEG_repeat_time
UNDEFINE nao_SEG_repeat_interval
UNDEFINE nao_SEG_repeat_unit
UNDEFINE nao_SEG_repeat_type
UNDEFINE nao_SEG_repeat_end_time
UNDEFINE nao_SEG_increment_dates
UNDEFINE nao_SEG_start_time
UNDEFINE nao_sys_user_name
UNDEFINE nao_sys_resp_key

UNDEFINE nao_application_name
UNDEFINE nao_application_base_path
UNDEFINE nao_user_name
UNDEFINE nao_user_password
UNDEFINE nao_responsibility_name
UNDEFINE nao_responsibility_key
UNDEFINE nao_security_group_key
UNDEFINE nao_menu_name
UNDEFINE nao_menu_type
UNDEFINE nao_menu_entry_function
UNDEFINE nao_menu_entry_prompt
UNDEFINE nao_menu_entry_desc
UNDEFINE nao_request_group_name
UNDEFINE nao_seg_request_group_name
UNDEFINE nao_data_group_name
UNDEFINE nao_schema_name
UNDEFINE nao_oracle_username
--
UNDEFINE nao_incr_seg_repeat_interval
UNDEFINE nao_incr_seg_repeat_unit
UNDEFINE nao_incr_seg_repeat_type
-- end w_gseg_incr_refr_rset.sql