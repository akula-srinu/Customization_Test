-- Title
--   ydroptb.sql
-- Function
--   drop all of the Noetix Views tables (not the template tables)
--
-- Description
--
--   Drop all of the tables required for Noetix Views Generator Operation
--   with the exception of n_view_parameters and n_view_lookup_codes
--   these tables are dropped and created by the install1.sql script.
--
-- Inputs
--   none
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   26-Mar-95 D Cowles   Created from ycrtable.sql
--   28-Jun-95 M Turner   add "drop n_user_security_rules"
--   26-Mar-96 M Turner   add "drop n_app_to_app"
--   16-Apr-98 D Cowles   add "drop n_column_drill"
--   22-Apr-98 D Cowles   add "drop n_hr_work_freq_conv"
--   21-Sep-98 C Lee      add "n_noetix_column_lookup","n_cross_org_map_alias"
--   06-Oct-98 C Lee      add "n_xorg_to_do_views"
--   03-Mar-99 M Potluri  add "drop n_xorg_prob_views", 
--                            "n_xorg_global_comp_views"
--   20-Sep-99 R Lowe     Update copyright info.
--   16-Feb-00 H Sumanam  Update copyright info.
--   11-Dec-00 D Glancy   Update Copyright info.
--   15-Mar-01 R Lowe     add drop calls for answer tables and sequences
--   16-Apr-01 D Glancy   add drop calls for n_temp_install_status table
--   29-Jun-01 H Schmed   Add drop call for n_popbase_temp table.
--   05-Nov-01 H Schmed   Add drop call for n_installation_messages
--                        table and n_installation_messages_seq
--                        sequence.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   17-Jun-02 D Glancy   Add drop call for n_valid_characters,
--                        n_view_name_changes, and n_column_name changes tables.
--                        (Issue 7034)
--   03-Jun-03 D Glancy   Added statement to drop the n_long_dual table.
--                        (Issue 10716) 
--   21-Oct-03 D Glancy   Added statement to drop the n_searchby_temp table.
--                        (Issue 11515) 
--   19-Jan-04 D Glancy   Drop the new n_application_owner_globals and 
--                        n_gorg_temp tables. (Issue 11698 and 10843) 
--   21-Jan-04 H Schmed   Drop the new n_temp_lookup_headers table.
--                        (Issue 11839)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Mar-04 H Schmed   Added a statement to drop the n_help_codes and
--                        n_help_code_roles tables. (Sphinx Issue 11827)
--   12-Apr-04 D Glancy   Add drop for the n_fnd_descr_flex_temp table used in 
--                        attrp.  This new table helps performance a bit.
--                        (Issue 12211)
--   10-Jun-04 H Schmed   Removed the statements dropping the n_help_codes 
--                        and n_help_code_roles tables. We decided to handle 
--                        it within the help scripts.(Sphinx Issue 11827)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   03-Jul-06 H Schmed   Added drop statements for the tables used in 
--                        global seg processing (n_seg_id_flex_segments_reorder, 
--                        n_seg_id_flex_code_headers and 
--                        n_seg_id_flex_code_view_sql). (Issue 16499)
--   26-Jul-06 H Schmed   Added drop statements for:
--                        n_seg_key_flexfields. (Multnomah Issue 16499)
--                        n_view_table_key_views (Multnomah Issue 16592)
--   22-Aug-07 R Lowe     Added drop statements for tables used for
--                        custom columns and custom labels (PeopleSoft):
--                        n_custom_columns, 
--   26-Sep-07 H Schmed   Added drop for n_view_column_extensions for the 
--                        Trinity customization (Issue 17947).
--   17-Feb-09 R Raghudev Added drop to column properties and join relationships 
--                        tables. 
--                        (Issue 21542)
--   17-Mar-09 S Vital    Added drop to column properties sequence. 
--                        (Issue 21741)
--   05-Jan-10 C Kranthi  Added drop for datacache foundation tables and sequences
--                        (Issue 23190)
--   10-May-10 R Vattikonda Added drop for data cache load program run log tables and sequences.
--                        (Issue 23770)  
--   14-Feb-10 D Glancy   Added drop of new column_id related tables.
--                        (Issue 25640)
--   07-Mar-11 R Vattikonda Removed references of N_USER_SECURITY_RULES. 
--   30-Mar-11 R Vattikonda Add n_f_kff_blocked_structures. 
--   30-Jul-12 D Glancy   Add n_join_keys and n_join_key_columns tables/sequences to the drop list.
--                        (Issue 28846)
--   09-Mar-13 D Glancy   n_hr_work_freq_conv table is no longer dropped or truncated as part of the installation.  The seed values are re-populated if
--                        they do not exist.  This keeps the noetix_hr2_pkg valid during installations.
--                        (Issue 31973)
--   10-Apr-13 D Glancy   n_query_user_roles is being replaced with n_sm_granted_user_roles.  Updated to reflect this change.
--                        (Issue 31869).
--   22-May-13 D Glancy   Add n_pl_folder_templates/n_pl_folders metadata table support.
--                        This will be the source of the presentation layer folder structures that was in the API.
--                        (Issue 25293)
--   11-Jul-13 Srinivas   Added drop statement for the sequence n_sme_exp_imp_pgm_runs_s.
--                        (Issue 32533)
--   27-Sep-13 D Glancy   EBS 12.2 Support.
--                        1.  n_long_dual needs to have a clob column.  May need to implement n_long_clob, but not sure yet.
--   16-Oct-13 D Glancy   EBS 12.2 Support.
--                        Need to update how we do the synonyms.  For ebs 12.2 and above, we need to use the editioning views and not the direct table reference.
--                        (Issue 33617)
--   08-Jan-14 D Glancy   Removed n_searchby_temp as we will use n_tmp_all_ind_columns instead.
--                        (Issue 33617)
--   31-Mar-15 Madhu V    added code to drop the n_to_do_views_incr table. (NV-465)
@utlprmpt "Removing old versions of Noetix System Administration User Objects"

whenever sqlerror continue

start wdrop table    &NOETIX_USER n_to_do_views_incr
start wdrop table    &NOETIX_USER n_ans_column_totals
start wdrop table    &NOETIX_USER n_ans_param_values
start wdrop table    &NOETIX_USER n_ans_params
start wdrop table    &NOETIX_USER n_ans_columns
start wdrop table    &NOETIX_USER n_ans_tables
start wdrop table    &NOETIX_USER n_ans_wheres
start wdrop table    &NOETIX_USER n_ans_queries
start wdrop table    &NOETIX_USER n_ans_audiences
start wdrop table    &NOETIX_USER n_answers
start wdrop table    &NOETIX_USER n_help_questions
start wdrop sequence &NOETIX_USER n_help_question_seq
start wdrop sequence &NOETIX_USER n_answer_seq
start wdrop sequence &NOETIX_USER n_ans_column_seq
start wdrop sequence &NOETIX_USER n_ans_param_seq
start wdrop sequence &NOETIX_USER n_ans_param_value_seq
start wdrop sequence &NOETIX_USER n_ans_column_total_seq
start wdrop table    &NOETIX_USER n_to_do_profile_options
start wdrop table    &NOETIX_USER n_to_do_views
start wdrop table    &NOETIX_USER n_temp_lookups
start wdrop table    &NOETIX_USER n_temp_lookup_headers
start wdrop table    &NOETIX_USER n_view_properties
start wdrop sequence &NOETIX_USER n_view_properties_seq
start wdrop table    &NOETIX_USER n_view_column_extensions
start wdrop table    &NOETIX_USER n_view_columns
start wdrop sequence &NOETIX_USER n_view_columns_seq
-----------------------------------------------------------------------------
-- DEPRECATED with version 6.3 and above
start wdrop table    &NOETIX_USER n_view_table_key_views
-- DEPRECATED with version 6.3 and above
-----------------------------------------------------------------------------
start wdrop table    &NOETIX_USER n_view_tables
start wdrop table    &NOETIX_USER n_view_wheres
start wdrop table    &NOETIX_USER n_view_queries
start wdrop table    &NOETIX_USER n_role_views
-----------------------------------------------------------------------------
-- NEW WITH version 6.3 and above
start wdrop table    &NOETIX_USER n_join_key_columns
start wdrop table    &NOETIX_USER n_join_keys
start wdrop table    &NOETIX_USER n_pl_folders
start wdrop sequence &NOETIX_USER n_join_key_columns_seq
start wdrop sequence &NOETIX_USER n_join_keys_seq
start wdrop sequence &NOETIX_USER n_pl_folders_seq
-- NEW WITH version 6.3 and above
-----------------------------------------------------------------------------
start wdrop table    &NOETIX_USER n_views
start wdrop sequence &NOETIX_USER n_buffer_s
start wdrop table    &NOETIX_USER n_buffer
start wdrop table    &NOETIX_USER n_grant_tables
start wdrop table    &NOETIX_USER n_profile_options
-----------------------------------------------------------------------------
-- No longer dropped (6.3+) as we want the yconvqu to handle dropping this table.
-- Drop the constraints if the table happens to exist still.  Table will be dropped later.
-- start wdrop table    &NOETIX_USER n_query_user_roles
BEGIN
    execute immediate 'ALTER TABLE N_QUERY_USER_ROLES DROP CONSTRAINT N_QUERY_USER_ROLES_FK1 cascade drop index';
EXCEPTION 
    WHEN OTHERS THEN 
        NULL;
END;
/
BEGIN
    execute immediate 'ALTER TABLE N_QUERY_USER_ROLES DROP CONSTRAINT N_QUERY_USER_ROLES_FK2 cascade drop index';
EXCEPTION 
    WHEN OTHERS THEN 
        NULL;
END;
/
-----------------------------------------------------------------------------
start wdrop table    &NOETIX_USER n_roles
start wdrop table    &NOETIX_USER n_app_to_app
start wdrop table    &NOETIX_USER n_application_xref
start wdrop table    &NOETIX_USER n_application_config_parms
start wdrop table    &NOETIX_USER n_application_owners
start wdrop table    &NOETIX_USER n_application_owner_globals
start wdrop sequence &NOETIX_USER n_sme_exp_imp_pgm_runs_s
-----------------------------------------------------------------------------
-- No longer dropped (5.8.x+) as we want the yconvqu to handle dropping this table.
-- start wdrop table    &NOETIX_USER n_query_users
-----------------------------------------------------------------------------
start wdrop table    &NOETIX_USER n_custom_objects
start wdrop table    &NOETIX_USER n_column_drill
-----------------------------------------------------------------------------
-- No longer dropped as we want the noetix_hr2_pkg to remain valid during installations.
-- start wdrop table    &NOETIX_USER n_hr_work_freq_conv
-----------------------------------------------------------------------------
start wdrop table    &NOETIX_USER n_noetix_column_lookup
start wdrop table    &NOETIX_USER n_cross_org_map_alias
start wdrop table    &NOETIX_USER n_xorg_to_do_views
start wdrop table    &NOETIX_USER n_xorg_prob_views
start wdrop table    &NOETIX_USER n_xorg_global_comp_views
start wdrop table    &NOETIX_USER n_temp_install_status
start wdrop table    &NOETIX_USER n_installation_messages
start wdrop sequence &NOETIX_USER n_installation_messages_seq
-----------------------------------------------------------------------------
-- No longer dropped (6.4.1+).
-- start wdrop table    &NOETIX_USER n_searchby_temp
-----------------------------------------------------------------------------
start wdrop table    &NOETIX_USER n_popbase_temp
start wdrop table    &NOETIX_USER n_gorg_temp
start wdrop table    &NOETIX_USER n_fnd_descr_flex_temp
start wdrop table    &NOETIX_USER n_valid_characters
start wdrop table    &NOETIX_USER n_view_name_changes
start wdrop table    &NOETIX_USER n_column_name_changes
start wdrop table    &NOETIX_USER n_long_dual
start wdrop table    &NOETIX_USER n_seg_id_flex_code_headers
start wdrop table    &NOETIX_USER n_seg_id_flex_segments_reorder
start wdrop table    &NOETIX_USER n_seg_id_flex_code_view_sql
start wdrop table    &NOETIX_USER n_seg_key_flexfields
start wdrop table    &NOETIX_USER n_custom_columns
-- start wdrop table &NOETIX_USER n_protect_view_columns
start wdrop table    &NOETIX_USER n_view_col_properties
-----------------------------------------------------------------------------
-- DEPRECATED with version 6.3 and above
start wdrop table    &NOETIX_USER n_view_join_relationships
start wdrop sequence &NOETIX_USER n_view_join_relationships_seq
start wdrop trigger  &NOETIX_USER n_view_join_relationships_bri
-- DEPRECATED with version 6.3 and above
-----------------------------------------------------------------------------
start wdrop sequence &NOETIX_USER n_view_col_properties_seq
-----------------------------------------------------------------------------
--drop global seg related tables and sequences
start wdrop table    &NOETIX_USER n_kff_gl_acct1;  -- Added by Srini Akula for Viasat
start wdrop table    &NOETIX_USER n_f_kff_program_runs
start wdrop table    &NOETIX_USER n_f_kff_flex_source_pgms
start wdrop table    &NOETIX_USER n_f_kff_concatenations
start wdrop table    &NOETIX_USER n_f_kff_union_struct_groups
start wdrop table    &NOETIX_USER n_f_kff_unions
start wdrop table    &NOETIX_USER n_f_kff_struct_grp_flex_nums
start wdrop table    &NOETIX_USER n_f_kff_structure_groups
start wdrop table    &NOETIX_USER n_f_kff_qualifiers
start wdrop table    &NOETIX_USER n_f_kff_segments
start wdrop table    &NOETIX_USER n_f_kff_structures
start wdrop table    &NOETIX_USER n_f_kff_blocked_structures
start wdrop table    &NOETIX_USER n_f_kff_flex_sources
start wdrop table    &NOETIX_USER n_f_kff_flexfields
start wdrop table    &NOETIX_USER n_kff_struct_iden_templates
start wdrop table    &NOETIX_USER n_kff_struct_identifier
start wdrop sequence &NOETIX_USER n_f_kff_segments_s
start wdrop sequence &NOETIX_USER n_f_kff_flex_sources_s
start wdrop sequence &NOETIX_USER n_f_kff_structure_group_s
start wdrop sequence &NOETIX_USER n_f_kff_union_s
start wdrop sequence &NOETIX_USER n_f_kff_union_strgrp_s
start wdrop sequence &NOETIX_USER n_kff_struct_iden_templates_s
start wdrop sequence &NOETIX_USER n_f_kff_program_runs_s
-- end ydroptb.sql
