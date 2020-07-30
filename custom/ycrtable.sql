-- Title
--   ycrtable.sql
-- Function
--   create all of the NoetixViews tables
--
-- Description
--
--   Create all of the tables required for NoetixViews Generator Operation
--   with the exception of n_view_parameters and n_view_lookup_codes
--   these tables are created by the install1.sql script.
--
-- Inputs
--
--   &TABLES_TABLESPACE - command to create the table within a specific
--                        tablespace. Optional, must be null if not specified.
--                        Tables will get created in Users default tablespace
--                        if null.
--                        If set must be of the form:
--                           "tablespace specified_tablespace_name"
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   20-Nov-94 D Cowles   Header created
--   06-Dec-94 M Turner   added install_status to n_application_owners
--                        added table n_application_xref
--   08-Dec-94 M Turner   widened where_clause to 1000 char
--   O1-Mar-95 M Turner   widened column_expression to 2000 char
--   10-Mar-95 M Turner   add role_prefix to n_application_owners
--   13-Mar-95 M Turner   add unique index on role_prefix
--   23-Mar-95 M Turner   move out the templates to crtmpl.sql
--                        use wdrop.sql to suppress bogus error messages
--                        use constraint to make n_view_columns.table_alias not
--                        null only except when expression or constant.
--   25-Mar-95 D Cowles   add owner to wdrop call
--   08-Mar-95 M Turner   Allow "UNION ALL" in queries
--   16-May-95 D Cowles   Add storage clauses to all tables and indexes
--   31-May-95 D Cowles   Change organization_name to 60 chars
--   07-Jun-95 D Cowles   change storage clauses to make largest 1M
--   23-Jun-95 M Turner   add security_code, special_process_code to n_views
--                        create table n_user_security_rules
--                        add column security_rules to n_query_users
--                        add column segment_qualifier to n_view_columns
--                        add column currency_code to n_application_owners
--                        allow n_view_columns.column_type of SEGP
--   30-Jun-95 D Cowles   add trigger to populate n_query_users.security_rules
--   04-Jul-95 M Turner   commented out trigger until it can be fixed.
--   15-Oct-95 D Cowles   remove call to genrpdat and genqudat
--   26-Dec-95 M Turner   changed INTERSECTION to INTERSECT in n_view_queries
--   04-Jan-96 M Turner   added column n_view_tables.subquery_flag
--   14-Feb-96 M Turner   add CATEGORY to special_process_code
--   18-Feb-96 D Cowles   Add support for KEYD type of column
--   26-Mar-96 M Turner   add table n_app_to_app.
--                        add columns master_organization_id,
--                        cost_organization_id to n_application_owners
--   10-Apr-96 M Turner   add QUERYOBJECT to special_process_code + column_type
--   22-Jul-96 D Cowles   add option to create synonyms for query user
--   31-Jul-96 M Turner   allow G in application_instance for multi-inv orgs.
--   01-Aug-96 D Cowles   move foreign key constraints to the end to avoid
--                        Oracle issue with table not found
--   30-Aug-96 D Cowles   add org_id
--   05-Sep-96 M Turner   add storage clause to N_APP_2_APP for primary key.
--   24-Sep-96 R Bullin   Add special process codes BASEVIEW and
--                        PA_CATEGORY_CLASS to N_VIEWS
--   19-Dec-96 M Turner   Extend the n_views.special_process_code to 30 char.
--   02-Apr-97 D Cowles   Add flex_value_set_id for eulgen
--   08-May-97 M Turner   Add column_type BASECOL
--   18-May-97 D Cowles   remove check that GEN columns cannot be expressions
--   21-May-97 W Bonneau  Add column org_name to n_application_owners
--   06-Jun-97 D West     Added statements to (re)create custom objects table
--   11-Jun-97 M Turner   add LOOKDESC to list of column_type
--   15-Dec-97 D Cowles   add BUSINESS_GROUP_ID to n_application_owners
--   05-Jan-98 D Cowles   add special process code of HR_SPECIAL_INFO
--   16-Apr-98 D Cowles   add n_column_drill
--   13-Jul-98 C Lee      added cross org columns, pk change, added index
--   02-AUG-98 S Kuhn     modified n_application_owners.organization_name column
--   16-Sep-98 D Glancy   Added index to enhance install performance.
--   11-Nov-98 D Glancy   Added delete_flag column to n_query_users and
--                        n_query_user_roles.  Support new delete functionality.
--   26-Apr-99 H Schmed   Changed the column size on set_of_books_name columns
--                        from 30 to 60.
--   27-Apr-99 H Schmed   Changed the column size on set_of_books_name,
--                        org_name,and organization_name (in
--                        n_application_owners and n_roles) to accommodate
--                        the cross-op name strings.
--   21-Jun-99 D Glancy   Added the special process code 'XOPORG' to the
--                        n_view_templates definition.
--   08-Jul-99 M Potluri  Removed some columns related to XOP from
--                        n_application_owners, these are not needed.
--   13-Jul-99 H Schmed   Added chart_of_accounts_name and master_organization_
--                        name to n_application_owners.  These are used in
--                        creating help for xop views.
--   18-AUG-99 S Varana   Added the period_set_name and global_multi_calendar
--                        columns to n_application_owners for xop.
--   25-Aug-99 R Kompella Added XOP_INSTANCE column to n_application_owners
--                        table to support custom scripts for dropping a role
--                        under standard but not in XOP etc.
--   20-Sep-99 R Lowe     Update copyright info.
--   16-Feb-00 H Sumanam  Update copyright info.
--   21-Mar-00 D Glancy   Added user_type column to n_query_users.
--   04-Apr-00 H Schmed   Added column types of ATTREXPR, ATTRSTRUCT, SEGEXPR
--                        and SEGSTRUCT to the n_view_columns constraints.
--                        These column types are used in the interface views.
--   10-Apr-00 R Lowe     Call script to create and populate the error table
--                        used by interface views.
--   13-Jun-00 H Schmed   Modified the n_view_columns_C2 constraint
--                        to allow for the ATTR/ATTRSTRUCT changes.
--                        Increased n_view_column_templates.
--                        ref_description_column_name to 40 characters.
--   06-Jul-00 R Lowe     Modified the n_view_columns_C2 constraint
--                        to remove restrictions from the GEN column type.
--   18-Jul-00 D Glancy   Added the language_code column to n_query_users.
--   07-Nov-00 R Wisler   Added constraint to table n_view_columns constraint
--                        name n_view_columns_c2 for column_type of HINT
--   10-Nov-00 D Glancy   Added the HINT column_type to the table
--                        n_view_columns constraint n_view_columns_c7.
--   11-Dec-00 D Glancy   Update Copyright info.
--   14-Mar-01 R Lowe     Update tables for Answers; create new Answer tables,
--                        create sequences needed for Answer tables.
--   20-Mar-01 R Lowe     Modify n_views_c3 constraint to allow new
--                        special process codes LOV and ANSWERVIEW.
--   30-Mar-01 R Lowe     Move call to ycrinter to end of script.
--                        Add t_column_id and t_break_column_id to
--                        n_ans_column_totals.
--   04-Apr-01 R Lowe     Change valid column types in n_ans_columns_c1.
--   06-Apr-01 H Schmed   Added a column_sub_type column to n_ans_columns.
--                        This will be used to track flexfield column
--                        types.
--   09-Apr-01 R Lowe     Make param_filter_type in n_ans_params not null.
--   11-Apr-01 R Kompella Add n_temp_install_status table, use it to get
--                        the install status for each stage.
--   27-Apr-01 H Schmed   Added n_ans_column_totals.t_total_id and
--                        n_ans_param_values.t_param_value_id so that we can
--                        cleanly link back to the template tables.
--   01-May-01 R Lowe     Added column generator_view to n_answers for use
--                        in the Answer Generator process.
--   29-Jun-01 H Schmed   Added the drop and creation of the temporary
--                        installer table n_popbase_temp.
--   16-Jul-01 H Schmed   Removed the n_role_views_fk1 constraint. We had
--                        to remove this when we added the product version
--                        to the primary key of n_role_view_templates.
--   05-Nov-01 H Schmed   Added the creation of the installer messages
--                        table n_installation_messages and sequence
--                        n_installation_messages_seq.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   15-Nov-01 D Glancy   Create table statement for n_installation_messages
--                        was missing a comma.
--   27-Nov-01 H Schmed   Increased the n_installation_messages
--                        message_type column from 4 to 10 characters.
--   09-Jan-02 H Schmed   Modified the n_ans_table insert statement to allow
--                        NULL values in the table_name field (Issue 4322)
--   11-Jan-02 D Glancy   Added define of the created_by variable so that we can
--                        run ycrtable independently of ycrtmpl.sql.
--                        Fixed error in the alter table for n_view_columns.
--                        The foreign key constraints were never being created.
--                        (Issue# 4320)
--   10-Apr-02 H Schmed   Added a call to ycravw.sql which creates views of
--                        the answer non-template metadata. (Issue 5795) Added
--                        command to explicitly end the ycrtable.lst spooling.
--   17-Jun-02 D Glancy   Add create table statements for n_valid_characters,
--                        n_view_name_changes, and n_column_name changes tables.
--                        (Issue 7034)
--   22-Jul-02 D Glancy   Added Creation_date Column to the n_column_drill
--                        table.
--   26-Aug-02 D Glancy   Added the gen_search_by_col_flag to n_view_tables
--                        table.
--                        Added the mandatory_flag and
--                        match_answer_column_string to the n_ans_columns
--                        table.  Support for new dumptodo.
--   11-Nov-02 D Glancy   Create/load the noetix_calendar table.
--   03-Feb-03 D Glancy   Modified the n_query_users and n_user_security_rules
--                        tables to support the new GL Security Model.
--                        (Issue # 9090,9225,7869,9254)
--   04-Feb-03 D Glancy   Changed the defaults for chart_of_accounts_id and
--                        set_of_books_id columns in n_user_security_rules
--                        to -999.999.  (Issue # 9090,9225,7869,9254)
--   25-Feb-03 D Glancy   Updated the storage parameters for n_view_columns,
--                        n_temp_lookups, and n_help_questions.
--                        (Issue 8588)
--   03-Jun-03 D Glancy   Added the n_long_dual table to support UNION ALL
--                        queries where one query has a long column and the
--                        corresponding view is using an expression
--                        (to_char(null)).  This causes problems in view
--                        creation. (Issue 10716)
--   17-Jul-03 D Glancy   Added undefine statements to clean up environment.
--                        (Issue #8561)
--   21-Oct-03 D Glancy   1.  Added statements to create the n_searchby_temp
--                        table. (Issue 11515)
--                        2.  Added the view_name_upper column and appropriate
--                        indexes to the n_popbase_temp table.  This helps to
--                        increase performance in popview.sql and autojoin.sql.
--                        (Issue 11513 and 11514)
--   31-Oct-03 D Glancy   Limit Varchar2() size for n_searchby_temp to 2000 if
--                        the column if server is 7.3.x.
--                        (Issue 11513 and 11514)
--   26-Nov-03 D Glancy   Increase the size of fields in n_application_owners
--                        table to get by size limitations for organization
--                        lists and decodes. (Issue 11698 and 10843)
--   21-Jan-04 H Schmed   Updated the n_temp_lookups table definition and added
--                        the create statement for n_temp_lookups_header.
--                        (Sphinx Issue 11839)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   22-Mar-04 H Schmed   Added the creation of the n_help_codes and
--                        n_help_code_roles tables. (Sphinx Issue 11827)
--   12-Apr-04 D Glancy   Updated the n_application_owner_globals table definition.
--                        Added the creation of the n_xop_mappings table.
--                        (Issue 11982)
--   15-Apr-04 D Glancy   Add the n_fnd_descr_flex_temp table that is used in
--                        attrp.  This new table helps performance a bit.
--                        (Issue 11517)
--   21-Apr-04 D Glancy   Fixed problem with the n_fnd_descr_flex_temp table definition.
--                        (Issue 11517)
--   10-Jun-04 H Schmed   Removed the creation of the n_help_codes and
--                        n_help_code_roles_tables. We decided to keep it
--                        within the help scripts. (Sphinx Issue 11827)
--   22-Jun-04 D Glancy   Use the n_get_server_version function instead of _O_RELEASE.
--                        This supports connecting to a 10g+ server.
--                        (Issue 12731)
--   30-Sep-04 M Pothuri  Added HR_EXTRA_INFO constraint on the special_process_code column
--                        in the n_view_templates table.
--                        This supports the dynamic generation of EITs in 11i+.
--                        (Issue 12337)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   04-Mar-05 D Glancy   The u1 index for n_column_name_changes was not totally unique.
--                        Changed the name and created a non unique index n_column_name_changes_n1
--                        instead.  This removed serveral warning because of the failure to insert
--                        unique rows for the specified columns.
--                        (Issue 13913)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Nov-05 D Glancy   1.  Update n_application_owners adding new columns.
--                        2.  Create new n_application_org_mappings table via call to ycrxmap.
--                        3.  Create new n_qu_org_unit_mappings table via call to ycrqmap.
--                        4.  Add new omit_flag column to n_roles.
--                        5.  Add user_enabled_flag to n_roles.
--                        (Issue 15240/11935)
--   08-Mar-06 D Glancy   Add profile option to the primary key constraint for n_view_columns.
--                        Add 'INLINE' to the n_view_column_c2 constraint.
--                        (Issue 15936)
--   03-Jul-06 H Schmed   Added tables for global seg processing:
--                        n_seg_id_flex_code_headers,
--                        n_seg_id_flex_code_view_sql and
--                        n_seg_id_flex_segments_reorder. (Issue 16499)
--   12-Jul-06 H Schmed   Updated the definition of n_seg_id_flex_code_headers
--                        to add the source owner and table name. (Issue 16499)
--   26-Jul-06 H Schmed   Added statement to create
--                        n_seg_key_flexfields. (Issue 16499)
--                        Added the n_view_table_key_views table.
--                        (Multnomah Issue 16592)
--   17-Aug-06 P Vemuru   Added gen_search_by_col_flag, lov_view_label, lov_view_name, lov_column_label
--                        to n_view_columns table definition (Multnomah: Issue 14251)
--   17-Sep-06 M Pothuri  Added Process_orgn_code, Process_orgn_name, 
--                        Process_orgn_id, Company_Code, and Company_name to 
--                        n_application_owners table definition
--                        (Multnomah: Issue 16235)
--   02-Nov-06 D Glancy   Removed references to n_noetix_lookup since it was used by the 
--                        forms only.
--                        Forms installation method is no longer supported.
--                        (Issue 16281)
--   16-Nov-06 D Glancy   Field sizes have changed recently and we don't want to incur an
--                        overflow.  Increased field size to support larger code sizes.
--                        (Issue 16808)
--   30-Jul-07 R Lowe     Add sort_layer to n_views.
--   22-Aug-07 R Lowe     Add call to create PeopleSoft tables.
--                        Add new column types ZDOLLAR, CUST and CUSTP.
--   14-Sep-06 D Glancy   Added an index to n_view_columns to help with processing of the 
--                        key flexfield drills.
--   26-Sep-07 H Schmed   Added the creation of the n_view_column_extensions
--                        table. Customization for Trinity (issue 17947).
--   12-Oct-07 H Schmed   Added the alias_length to the n_id_flex_code_headers 
--                        table. (Issue 18339)
--   17-Nov-07 D Glancy   ycrqmap.sql removed.  New functionality present in the security manager tables.
--                        ycrsecmgrtb.sql will now create the tables necessary for the security manager.
--                        xmap table still exists in the ycrxmap.sql script.
--                        (Issues 18563 and 15240)
--   07-Dec-07 P Vemuru   Added Source_Instance_ID column to n_application_owners table (Issue 5357)
--   07-Feb-08 D Glancy   Added check constraint for the sort_layer column.
--   02-Jun-08 D Glancy   Performance tuning update.
--                        (Issue 19953)
--   06-Jun-08 D Glancy   Update size of hint/essay columns.  Now we are going to support 3000 characters
--                        in the view editor and fix the truncation issue.    
--                        (Issue 19933)
--   13-Jun-08 D Glancy   Performance tuning update.  Trying to eliminate as many "select min(q.query_position) as possible.  Added
--                        first_active_query_position to n_views and it will be populated in omits.sql.  This should help eul generator as
--                        well as the views product.   NOTE:  I did make this a varchar2 as opposed to numeric as sql server seems to have 
--                        problems with oracle numeric columns in n_views. 
--                        (Issue 19953)
--   02-Jun-08 D Glancy   Define the new global temp tables n_tmp_all_%_columns.
--                        (Issue 19953 and 19806)
--   01-Aug-08 S Ssyed    Added special process code of QA_PLAN.
--                        (Issue 20398)
--   23-Sep-08 D Glancy   Create the n_tmp_all_indexes table for use by autojoip and jointop.
--                        (Issue 14534)
--   13-Oct-08 D Glancy   Add BUDLVL security code.
--                        (Issue 20911)
--   22-Oct-08 D Glancy   Based on heidi's comments, always validate that the indexes exist on the n_tmp% tables.
--                        (Issue 14534, 19953, and 19806)
--   13-Feb-09 R Raghudev Added a column to n_view_columns for Global SEG. Also added the new column properties table and
--                        join relationships table. 
--                        I will have to update the issue number later.
--   16-Mar-09 R Raghudev Changed the column column_property_id to t_column_property_id and added new PK column_property_id
--                        using a sequence for the table n_view_column_properties.
--                        (Issue 21741)
--   07-Apr-09 S Syed     Add QA_RESULTS special_process_code.
--                        (Issue 21873)
--   11-May-09 D Glancy   Create new global temp table n_tmp_all_tables_and_views.
--                        (Issue 21857)
--   14-May-09 C Kranthi  Modifications to n_view_join_relationships table script.
--                        (Issue 21650)
--   22-May-09 S Vital    Modifications to n_view_join_relationships table script.
--                        (Issue 21650)
--   29-May-09 G Sriram   Modifications to the index in the n_view_join_relationships table script.
--                        (Issue 21650)
--   15-Jun-09 G Sriram   Added the qualifier FA_COST_CTR to the n_view_columns_c8 constraint. (Issue 21650)
--   26-Jun-09 G Sriram   Modified n_view_col_properties to make t_column_property_id definition as NULL and included 
--                        column_name, query_position and column_property_type in the constraint n_view_col_properties_u1.(Issue 21680)
--   30-Jun-09 C Kranthi  Added new SEG related column types to the contraint of n_ans_columns table.
--                        (Issue 21680)
--   24-Jul-09 D Glancy   To properly support cascade deletes, I'm setting the key view label column
--                        to null instead of deleting the record when the source view is created.
--                        ycrsecmgrtb.sql now call ycrxmap.sql (due to the need for the n_application_org_mappings table
--                        in the security setup.  I've kept the call here to ycrxmap for non-views installs.
--                        (Issue 22156) (Issue 22154)
--   29-Aug-09 D Glancy   Add performance improvements.
--                        Now use the APPEND hint to INSERT data, PL/SQL table technique, and added some indexes on the
--                        profile_option columns in the n_view_% tables.
--                        (Issue 22586)
--   22-Sep-09 G Sriram   Added the column Process_Type to the n_installation_messages table and increased the character length 
--                        of the column script_name from 30 to 100.
--   14-Oct-09 S Vital    Added key view helper view creation code (Issue 22811).
--   20-Oct-09 C Kranthi  Added function based index on n_view_columns.column_name using UPPER function.
--   05-Jan-10 C Kranthi  To streamline of the object creation.
--                        moved the datacache foundation table and sequence creation to this script file.
--                        earlier the objects used to get created in ycr_gseg_foundation_objects.sql
--                        (Issue 23190)
--   11-Jan-10 G Sriram   Included the Primary Key columns to the table N_f_kff_qualifiers.
--   27-Apr-10 D Glancy   Add new columns to n_application_owners.
--                        (Issue 23684)
--   10-may-10 R Vattikonda Added column dc_force_drop_flag to n_f_kff_flexfields 
--                          Added default values to install_incr_refresh_flag and enable_incr_refresh_flag
--                          Added columns cd_table_name, cde_table_name, cdeh_table_name and -
--                           cd_trigger_name to n_f_kff_flex_sources table.
--                          Restructured  n_f_kff_flex_source_pgms and created a table n_f_kff_program_runs.
--                          Created a sequence n_f_kff_program_runs_s as part of incremental refresh.
--                        (Issue 23770)
--   25-May-10 D Glancy   Revamped and turbo charged for the 11g database environment.
--                        (Issue 24220)
--   27-Sep-10 R Vattikonda Modified constraint n_views_c2 for table N_VIEWS to include 'SR_TYPE'
--                        (Issue 25135)
--   17-Nov-10 D Glancy   Added T_COLUMN_ID to N_view_column_templates.  Data from n_view_col_property_templates has moved
--                        to n_view_property_templates.  T_COLUMN_ID/column_id used in answers table will be called 
--                        T_ANS_COLUMN_ID/ANS_COLUMN_ID.
--                        (ISSUE 25640)
--   01-Mar-11 v krishna  Added Legal_Entity column to n_application_owners. (Issue #20034)
--   15-Mar-11 D Glancy   Update triggers for n_view_columns and add trigger for the n_view_properties tables.
--                        (Issue 25640)
--   25-Mar-11 V krishna  Modified the Legal_Entity column as Legal_Entity_Name.
--                        (Issue #20034)
--   29-Mar-11 S Vital    Added n_f_kff_blocked_structures table creation code (Issue 25741).
--   03-May-11 Srinivas   Added the special process code 'ACCT_HIER' and 'ACCT_DIM' to the n_views as part of the Parent Child Hierarchy Processing.
--                        (Issue 25330)
--   10-May-11 J Stein    Generators team needs some indexes to help performance with the api views.
--                        (Issue 26798).
--   02-Jun-11 D Glancy   Add n_view_join_relationships_bri trigger.
--                        (Issue 26330)
--   22-Jun-11 D Glancy   Helper view should ignore XXHIE as well as XXKFF.
--   23-Jun-11 D Glancy   Add user_omit_flag column.
--                        (Issue 27099)
--   11-Nov-11 P Upendra  Created the table N_TMP_BOM_EXPLOSION table that is used in NOETIX_BOM_EXPLOSION_PKG.
--                        (Issue 18791)
--   25-Aug-11 R Vattikonda Added column 'Zero_Latency' to N_F_KFF_Flex_Sources table with default value 'N'.
--                        (Issue 27565)
--   14-Feb-12 D Glancy    ycrsecmgrtb.sql was renamed to ycr_sec_manager_tb.sql.
--                        ( Issue 28432 )
--   13-Mar-12 D Glancy    n_view_column_extensions needs to have the t_column_id "not null" constraint removed.  Add a check constraint
--                         to ensure either the column_id or t_column_id is populated.
--                        ( Issue 29105 )
--   30-Jul-12 D Glancy   Add n_join_keys and n_join_key_columns tables.
--                        (Issue 28846)
--   15-Nov-12 D Glancy   Update the constraint on the oracle_install_status and install_status columns allowing 'N' as well as the other values.
--                        (Issue 28711)
--   09-Mar-13 D Glancy   n_hr_work_freq_conv table is no longer dropped or truncated as part of the installation.  The seed values are re-populated if
--                        they do not exist.  This keeps the noetix_hr2_pkg valid during installations.
--                        (Issue 31973)
--   22-May-13 D Glancy   Join key model has changed to support cardinality.
--                        (Issue 32031)
--   22-May-13 D Glancy   Add n_pl_folder_templates/n_pl_folders metadata table support.
--                        This will be the source of the presentation layer folder structures that was in the API.
--                        (Issue 25293)
--   08-Jun-13 Srinivas   Added the command for creating the sequence for  n_sme_exp_imp_pgm_runs_s.
--                        (Issue 32533)
--   19-Jul-13 D Glancy   Added 2 new columns to the n_pl_folders table.  Need to store MO and COA at the same time.
--                        (Issue 25293)
--   31-Jul-13 D Glancy   Added 2 new columns to the n_pl_folders table.  Need to determine how we generate parent folders based on two criteria.
--                        1.  If a parent folder contains only non-required modules, then suppress that parent folder.  (role_required_in_parent_code)
--                        2.  If a role exists in multiple parent folders, but the other parent folders would not generate otherwise,  then suppress the parent folder.
--                        (role_required_in_parent_code = "D")
--                        (Issue 33131)
--   16-Oct-13 D Glancy   EBS 12.2 Support.
--                        (Issue 33617)
--   05-Jan-14 D Glancy   n_temp_lookup_headers needs the metadata_table_name column.
--                        (Issue 33617)
--   08-Jan-14  D Glancy  Updated how we look for index columns.  Need to translate the metadata column name to the column name in the 
--                        physical index.  Removed n_searchby_temp as we will use n_tmp_all_ind_columns instead.
--                        (Issue 33617)
--   28-Jan-14 D Glancy   Add the new global temp table N_TMP_VIEWS_SQF used for SQF processing.
--                        (Issue 34059).
--   04-Feb-14 D Glancy   Update the N_TMP_JK_VIEW_COLUMNS table to support performance enhancements.
--                        Added new temp table as well.
--                        (Issue 34107)
--   11-Mar-14 D Glancy   Multiple records are being inserted into n_hr_work_freq_conv for the "Yearly" work frequency.
--                        Correct the code to prevent the duplicates from appearing.  Remove any duplicates if detected.
--   31-Mar-15 Madhu V    modified the code to process the installation for NVA as well as IR process. 
--   31-Mar-15 Madhu V    Created table n_to_do_views_incr.
--   31-Mar-15 Arvind     Created table n_ir_view_gen_history that holds customized views. 
--   22-Apr-15 Arvind     Created table n_customizations_gtemp using in verflag.sql for stage 4 and IR as well.
--	 14-Oct-15 Kmaddireddy n_f_kff_program_runs_s sequence creation has been modified to support RAC evnironments.
--						   (Issue NV-335)
---



--Issue NV-335
column n_kff_prgm_runs_s_nocache new_value l_n_kff_prgm_runs_s_nocache noprint ;

SELECT (CASE VALUE
           WHEN 'FALSE' THEN
            'CACHE 20'
           ELSE
            'NOCACHE'
       END) n_kff_prgm_runs_s_nocache
  FROM V$PARAMETER
 WHERE UPPER(NAME) = UPPER('CLUSTER_DATABASE');
--Issue NV-335

@utlprmpt "Creating Noetix System Administration User Objects"

define created_by='Noetix &N_SCRIPTS_VERSION'

--    Drop old versions first
@ydroptb

-- Determine if we need to re-build the db objects package.
start utlif "ycrdbobjectspkg" -
  "n_compare_function_version( 'N_DB_OBJECTS_PKG.get_version', '&N_SCRIPTS_VERSION' ) < 0"

@utlspon ycrtable

define max_buffer=4000

whenever sqlerror exit 8

--
-- SCK 02-AUG-98 Increased size of ORGANIZATION_NAME by 7 chars to include
--               ORGANIZATION_CODE + ' -- ' as a delimiter
--
--
-- cross-org
--      add global_ columns
--
prompt table n_application_owners
create table n_application_owners(
        application_label           varchar2(10)            not null,
        application_id              number                  not null,
        base_application            varchar2(1)             not null
                constraint n_application_owners_c1
                        check(base_application in ('Y','S','N')),
        oracle_install_status       varchar2(1)             not null
                constraint n_application_owners_c4
                        check(oracle_install_status in ('I','S','N','L')),
        install_status              varchar2(1)             not null
                constraint n_application_owners_c3
                        check(install_status in ('I','S','N')),
        application_instance        varchar2(4)             not null,
        owner_name                  varchar2(30)            not null,
        oracle_id                   number                  not null,
        legal_entity_name           varchar2(&MAX_BUFFER),  --Issue #20034
        set_of_books_id             number,
        set_of_books_name           varchar2(&MAX_BUFFER),
        organization_id             number,
        organization_name           varchar2(&MAX_BUFFER),
        master_organization_id      number,
        master_organization_name    varchar2(240),
        business_group_id           number,
        business_group_name         varchar2(240),
        legislative_code            varchar2(240),
        cost_organization_id        number,
        cost_organization_name      varchar2(240),
        org_id                      number,
        org_name                    varchar2(&MAX_BUFFER),
        chart_of_accounts_id        number,
        chart_of_accounts_name      varchar2(240),
        role_prefix                 varchar2(5),
        currency_code               varchar2(15),
        global_multi_currency       varchar2(1)  default 'N',  -- xorg
        period_set_name             varchar2(15),
        global_multi_calendar       varchar2(1)  default 'N',  -- xorg
        global_set_of_books         varchar2(&MAX_BUFFER),  -- xorg
        global_organizations        varchar2(&MAX_BUFFER),  -- xorg
        global_cost_organizations   varchar2(&MAX_BUFFER),  -- xorg
        global_orgs                 varchar2(&MAX_BUFFER),  -- xorg
        global_currency_codes       varchar2(&MAX_BUFFER),  -- xorg
        global_ou2sob               varchar2(&MAX_BUFFER),  -- xorg (ou = operating unit)
        global_ou2org               varchar2(&MAX_BUFFER),  -- xorg (org = inv/mfg organziation)
        global_org2sob              varchar2(&MAX_BUFFER),  -- xorg (sob = set of books)
        global_org2costorg          varchar2(&MAX_BUFFER),  -- xorg (costorg = cost organization)
        global_sob2curr             varchar2(&MAX_BUFFER),  -- xorg (curr = currency code)
        xop_instance                varchar2(4),            -- xop
        global_instance             varchar2(4),            -- global
        use_org_in_xop_flag         varchar2(1),            -- Y = Include; N = Don't or not used (Single only)
        use_org_in_global_flag      varchar2(1),            -- Y = Include; N = Don't or not used (Single only)
        install_status_history      varchar2(&MAX_BUFFER),
        process_orgn_id             number,       ---- Issue 16235 start
        process_orgn_code           varchar2(5),
        process_orgn_name           varchar2(240),
        company_code                varchar2(5),
        company_name                varchar2(240), ---- Issue 16235 end
        source_instance_id          number,        -- Issue 5357 (New module: MSC)
        role_enabled_flag           VARCHAR2(1)
                constraint n_application_owners_c5
                        check(role_enabled_flag in ('Y','N')), 
        constraint n_application_owners_pk
                primary key(application_label,application_instance)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_application_owners_u1
                unique(role_prefix)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_application_owners_c2
                check(to_number(ltrim(application_instance,'GX'))
                between 0 and 1000)
        ) &TABLES_TABLESPACE
        storage (initial 10K next 10K pctincrease 0);
--      foreign key (set_of_books_id)
--              references(gl.gl_set_of_books)
--              constraint n_application_owners_fk2,
--      foreign key (organization_id)
--              references(inv.org_organization_definitions)
--              constraint n_application_owners_fk3.
--      foreign key (owner_name)
--              references(all_users)
--              constraint n_application_owners_fk4)
comment on table n_application_owners is
   'This table relates the Applications to the actual RDBMS database
   accounts that own tables. An example might be that the application
   AP has two instances with tables owned by say AP and AP_USA.' ;
comment on column n_application_owners.application_instance is
   'This number distinguishes distinct instances of the same application.
   These distinct instances might have different sets of books or different
   organizations, or both.  For example, AP and AP_USA might have
   application_instances numbers of 0 and 1. Numbering starts at zero.';
comment on column n_application_owners.application_id is
  'This application_id references applsys.fnd_application. It is populated
   by copying from n_application_owner_templates.';
comment on column n_application_owners.oracle_id is
  'This oracle_id references applsys.fnd_oracle_userid. It is populated
   by joining n_application_owner_templates with
   fnd_product_installations.';
comment on column n_application_owners.install_status is
   'I = Installed, S = Shared';
comment on column n_application_owners.role_prefix is
   'These characters uniquely identify a role. They are the beginning of
   the role name and the begining of the view_name for each view owned by
   the role.';
comment on column n_application_owners.currency_code is
   'Currency code is used in GL';

        
prompt table n_application_owner_globals
create table n_application_owner_globals(
        application_label         varchar2(10)            not null,
        application_instance      varchar2(4)             not null,
        column_name               varchar2(30)            not null,
        sequence                  number                  not null,
        value                     varchar2(&MAX_BUFFER),
        constraint n_application_owner_globals_pk
                primary key(application_label,application_instance,column_name,sequence)
                using index storage (initial 10K next 10K pctincrease 0)
        ) &TABLES_TABLESPACE
        storage (initial 50K next 50K pctincrease 0);

comment on table n_application_owner_globals is
   'This table allows for the dynamic extension of the string fields.  Strings that can''t
   fit in the n_application_owners table are added into this table.' ;

prompt table n_application_xref
create table n_application_xref (
        application_label       varchar2(10)    not null,
        application_instance    varchar2(4)     not null,
        ref_application_label   varchar2(10)    not null,
        ref_application_instance varchar2(4)    not null,
        constraint n_application_xref_pk
                primary key (application_label,
                        application_instance,ref_application_label)
                using index storage (initial 20K next 20K pctincrease 50)
        ) &TABLES_TABLESPACE
        storage (initial 20K next 20K pctincrease 50)
;
comment on table n_application_xref is
'Cross reference the applications. This shows, for example, that PO1
corresponds to AP1';

prompt table n_app_to_app
create table n_app_to_app(
        application_label       varchar2(10)    not null,
        application_instance    varchar2(4)     not null,
        owner_name              varchar2(30)    not null,
        ref_application_label   varchar2(10)    not null,
        ref_application_instance varchar2(4)    not null,
        ref_owner_name          varchar2(30)    not null,
        dependency_direction    varchar2(20)    not null,
        constraint n_app_to_app_pk
                primary key(application_label,owner_name,
                        ref_application_label,ref_owner_name)
                using index storage (initial 10K next 10K pctincrease 50),
        constraint n_app_to_app_u1
                unique (application_label, application_instance,
                        ref_application_label,ref_application_instance)
                using index storage (initial 10K next 10K pctincrease 50),
        constraint n_app_to_app_c1
                check( dependency_direction in ('APP REQUIRES REF',
                                                'REF REQUIRES APP',
                                                'APP REQ X REQ REF',
                                                'REF REQ X REQ APP'
                                                ))
        ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);
--
-- This table is used to maintain the suppressed flexfield structure information in global seg
Prompt Creating table n_f_kff_blocked_structures

CREATE TABLE n_f_kff_blocked_structures
    (
     Data_Table_Key            INTEGER ,
     ID_Flex_Num               INTEGER        NOT NULL,
     Application_ID            INTEGER        NOT NULL,
     ID_Flex_Code              VARCHAR2(4)        NOT NULL
     --   CONSTRAINT n_f_kff_blocked_structures_uk
     --           UNIQUE(Data_Table_Key,ID_Flex_Num,Application_ID,ID_Flex_Code)
     --           USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

--
comment  on table n_app_to_app is
  'Cross reference applications to applications by looking up product
  dependencies (using owner_name). This table is more primitive than
  n_application_xref since that table knows about organizations and
  sets of books.';

prompt table n_roles
create table n_roles(
        role_label              varchar2(24)            not null,
        application_label       varchar2(10)            not null,
        application_instance    varchar2(4)             not null,
        application_id          number                  not null,
        owner_name              varchar2(30)            not null,
        oracle_id               number                  not null,
        role_name               varchar2(30)            not null,
        responsibility_name     varchar2(30),
        responsibility_id       number,
        description             varchar2(&MAX_BUFFER),
        set_of_books_name       varchar2(&MAX_BUFFER),
        organization_name       varchar2(&MAX_BUFFER),
        omit_flag               varchar2(1)             DEFAULT 'N',
                constraint n_roles_c1
                        check (omit_flag in ('Y','N')),
        user_omit_flag          varchar2(1)             DEFAULT 'N',
                constraint n_roles_c3
                        check (user_omit_flag in ('Y','N')),
        user_enabled_flag       varchar2(1)             DEFAULT 'N',
                constraint n_roles_c2
                        check (user_enabled_flag in ('Y','N')),
        constraint n_roles_pk
                primary key (role_name)
                using index storage (initial 10K next 10K pctincrease 50)
--      foreign key (responsibility_id)
--              references applsys.fnd_responsibilities
--              constraint n_roles_fk3
        ) &TABLES_TABLESPACE
        storage (initial 10K next 10K pctincrease 50);


prompt table n_profile_options
create table n_profile_options(
        profile_option                  varchar2(30)            not null,
        application_instance            varchar2(4)             not null,
        application_label               varchar2(10)            not null,
        table_application_label         varchar2(10)            not null,
        table_owner_name                varchar2(30),
        table_name                      varchar2(30)            not null,
        metadata_table_name             varchar2(30),
        omit_flag                       varchar2(1),
                constraint n_profile_options_c1
                        check (omit_flag in ('Y','N')),
        user_omit_flag          varchar2(1),
                constraint n_profile_options_c2
                        check (user_omit_flag in ('Y','N')),
        profile_select                  varchar2(2000),
        constraint n_profile_options_pk
                primary key (profile_option, application_instance)
                using index storage (initial 20K next 20K pctincrease 50)
        ) &TABLES_TABLESPACE
        storage (initial 40K next 40K pctincrease 50);
comment on column n_profile_options.table_owner_name is
'Oracle username of the owner of the table called out in table_name';

prompt table n_grant_tables
create table n_grant_tables(
        application_label               varchar2(10)            not null,
        application_instance            varchar2(4)             not null,
        owner_name                      varchar2(30),
        table_name                      varchar2(30)            not null,
        metadata_table_name             varchar2(30),
        constraint n_grant_tables_pk
               primary key (application_label, application_instance, table_name)
                using index storage (initial 10K next 10K pctincrease 0)
        ) &TABLES_TABLESPACE
        storage (initial 10K next 10K pctincrease 0);

prompt table n_buffer
create table n_buffer(
        session_id                      number                  not null,
        line_number                     number                  not null,
        text                            varchar2(&MAX_BUFFER)
        ) &TABLES_TABLESPACE
        storage (initial 512K next 1M pctincrease 0);

prompt sequence n_buffer_s
create sequence n_buffer_s;

prompt table n_views
create table n_views(
        view_name               varchar2(30)            not null,
        view_label              varchar2(30)            not null,
        application_label       varchar2(10)            not null,
        application_instance    varchar2(4)             not null,
        description             varchar2(80),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        essay                   varchar2(&MAX_BUFFER),
        xref_list               varchar2(2000),
        security_code           varchar2(10)            default 'NONE',
        special_process_code    varchar2(30)            default 'NONE',
        sort_layer              number,
        -- Use a character field here because generators have a problem using numeric fields
        first_active_query_position      varchar2(10),
        --
        constraint n_views_pk
                primary key(view_name)
                using index storage (initial 40K next 40K pctincrease 50),
        constraint n_views_c1
                check(omit_flag in ('Y','N')),
        constraint n_views_c2
                check(security_code in ('ACCOUNT','BUDLVL','HR','NONE','SR_TYPE')),
        constraint n_views_c3
                check(special_process_code in (
                        'ROLLUP_ACCOUNT','STAT','FORCE','CATEGORY',
                        'HR_SPECIAL_INFO', 'XOPORG',
                        'QUERYOBJECT', 'PA_CATEGORY_CLASS', 'BASEVIEW', 'NONE','ACCT_HIER','ACCT_DIM',
                        'LOV', 'ANSWERVIEW', 'HR_EXTRA_INFO','QA_PLAN','QA_RESULT','BASEVIEW_EXPOSED')
                      or special_process_code like 'CATEGORY-%'
                      or special_process_code like 'FLEX_NUM-%'
                      or special_process_code like 'QA_PLAN%'
                      or special_process_code like 'QA_RESULT-%'),
        constraint n_views_c5
                check(sort_layer between 0 and 900),
        constraint n_views_c6
                check(user_omit_flag in ('Y','N'))
        ) &TABLES_TABLESPACE
        storage (initial 500K next 100K pctincrease 50);

comment on column n_views.xref_list is
'Denormalized list of cross references. Used by wcomhlp to get list of forms
in a manner easy to print out.';

prompt table n_role_views
create table n_role_views(
        role_label              varchar2(24)            not null,
        view_label              varchar2(30)            not null,
        role_name               varchar2(30)            not null,
        view_name               varchar2(30)            not null,
        constraint n_role_views_pk
                primary key (role_name, view_name)
                using index storage (initial 50K next 50K pctincrease 50)
        ) &TABLES_TABLESPACE
        storage (initial 70K next 50K pctincrease 50);

prompt table n_view_queries
create table n_view_queries(
        view_name               varchar2(30)            not null,
        view_label              varchar2(30)            not null,
        query_position          number                  not null,
        union_minus_intersection varchar2(12),
        group_by_flag           varchar2(1),
        profile_option          varchar2(30),
        application_instance    varchar2(4),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        view_comment            varchar2(80),
        constraint n_view_queries_pk
                primary key (view_name, query_position)
                using index storage (initial 30K next 30K pctincrease 50),
        constraint n_view_queries_c1
                check(union_minus_intersection in
                        ('UNION','UNION ALL','MINUS','INTERSECT')),
        constraint n_view_queries_c2
                check(omit_flag in ('Y','N')),
        constraint n_view_queries_c3
                check(query_position between 1 and 20),
        constraint n_view_queries_c4
                check(group_by_flag in ('Y','N')),
        constraint n_view_queries_c5
                check(user_omit_flag in ('Y','N'))
        ) &TABLES_TABLESPACE
        storage (initial 60K next 60K pctincrease 50);

prompt table n_view_wheres
create table n_view_wheres(
        view_name               varchar2(30)            not null,
        view_label              varchar2(30)            not null,
        query_position          number                  not null,
        where_clause_position   number                  not null,
        where_clause            varchar2(&MAX_BUFFER)   not null,
        profile_option          varchar2(30),
        application_instance    varchar2(4),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        generated_flag          varchar2(1),
        constraint n_view_wheres_pk
                primary key (view_name, query_position, where_clause_position)
                using index storage (initial 300K next 100K pctincrease 50),
--      constraint n_view_wheres_fk3
--              foreign key (view_label, query_position, where_clause_position)
--              references n_view_where_templates,
        constraint n_view_wheres_c1
                check(where_clause_position between 1 and 2200),
        constraint n_view_wheres_c2
                check(omit_flag in ('Y','N')),
        constraint n_view_wheres_c3
                check(generated_flag in ('Y','N')),
        constraint n_view_wheres_c4
                check(user_omit_flag in ('Y','N'))
        ) &TABLES_TABLESPACE
        storage (initial 1M next 200K pctincrease 50);
comment on column n_view_wheres.where_clause_position is
'The position of rows entered in the template is less than 1000. Clauses
added to do joins are between 1000 and 2000. Clauses added to do group by
are over 2000.';
comment on column n_view_wheres.generated_flag is
'generated_flag = Y for those where clauses that the generator adds.';


prompt table n_view_tables
create table n_view_tables(
        view_name               varchar2(30)            not null,
        view_label              varchar2(30)            not null,
        query_position          number                  not null,
        table_alias             varchar2(30)            not null,
        from_clause_position    number                  not null,
        application_label       varchar2(10)            not null,
        owner_name              varchar2(30),
        table_name              varchar2(30)            not null,
        metadata_table_name     varchar2(30),
        application_instance    varchar2(4),
        profile_option          varchar2(30),
        base_table_flag         varchar2(1)             not null,
--- NOTE: Keeping key view columns as ruth may need them to make the API work smoothely.
---       Will delete later if she uses the dynamic view creation process.
        key_view_name           varchar2(30)            ,
        key_view_label          varchar2(30)            ,
---
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        generated_flag          varchar2(1),
        subquery_flag           varchar2(1)             not null,
        gen_search_by_col_flag  varchar2(1) DEFAULT 'N' not null,
        constraint n_view_tables_pk
                primary key(view_name, query_position, table_alias)
                using index storage (initial 250K next 100K pctincrease 50),
        constraint n_view_tables_c1
                check(omit_flag in ('Y','N')),
        constraint n_view_tables_c2
                check(base_table_flag in ('Y','N')),
        constraint n_view_tables_c3
                check(from_clause_position between 1 and 200),
        constraint n_view_tables_c4
                check(generated_flag in ('Y','N')),
        constraint n_view_tables_c5
                check(subquery_flag in ('Y','N')),
        constraint n_view_tables_c6
                check(user_omit_flag in ('Y','N')),
--- NOTE: Added these constraints to enforce the fact that we don't want customers or devs inserting KV info into this table.
--        Columns remain to help generator API resolve issues, but should always be null.
        constraint n_view_tables_c7
                check(key_view_name  IS NULL),
        constraint n_view_tables_c8
                check(key_view_label IS NULL)
---
        ) &TABLES_TABLESPACE
        storage (initial 500K next 100K pctincrease 50);
-- owner_name references all_users
comment on column n_view_tables.generated_flag is
'generated_flag = Y for those table from clauses that the generator adds.';
comment on column n_view_tables.application_label is
'This is the application of the table, not of the view.';
comment on column n_view_tables.application_instance is
'This is the application instance of the view, not the table. It is
intended to be used with profile_option, but it is not intended
to be used with application_label.';
--- NOTE: Keeping key view columns as ruth may need them to make the API work smoothely.
---       Will delete later if she uses the dynamic view creation process.
comment on column n_view_tables.key_view_name is
'COLUMN DEPRECATED AND SHOULD ALWAYS BE NULL!!!  Column exists only here to make life easier for the generator API.';
comment on column n_view_tables.key_view_label is
'COLUMN DEPRECATED AND SHOULD ALWAYS BE NULL!!!  Column exists only here to make life easier for the generator API.';
---
comment on column n_view_tables.subquery_flag is
'"Y" means that table is referenced in a subquery in the "where" clause. The
table is not meant to be included in the "From" clause.';

---------------------------------------------------------------------------------------------------
--
--  N_VIEW_COLUMNS
--
---------------------------------------------------------------------------------------------------
--
--  N_VIEW_COLUMNS - Specifies the columns that are associated with a given view per application instance
--        COLUMN_ID                 - PK of the n_view_columns table.
--        T_COLUMN_ID               - PK of the n_view_column_templates table.
--        VIEW_LABEL                - Label associated with the view column record.
--        QUERY_POSITION            - Query position associated with the view column record.
--        COLUMN_LABEL              - Label assigned to the column.
--        TABLE_ALIAS               - Table alias associated with the current record.  Ignored in certain cases (EXPR for example.)
--        COLUMN_EXPRESSION         - Expression associated with the column.
--        COLUMN_POSITION           - Position of the column in the list.
--        COLUMN_TYPE               - Type of the column.
--        DESCRIPTION               - Description of the column.
--        REF_APPLICATION_LABEL     - Referenced application_label.
--        REF_TABLE_NAME            - Name of the table that is referenced.
--        METADATA_REF_TABLE_NAME   - Original ref_table_name defined in templates.
--        KEY_VIEW_LABEL            - A rowid jointo column will be generated with the name of the view specified in this column.
--        REF_LOOKUP_COLUMN_NAME    - Name of the lookup column referenced.
--        REF_LOOKUP_TYPE           - Lookup type of the reference.
--        ID_FLEX_APPLICATION_ID    - Application_ID associated with the key flexfield structure.
--        ID_FLEX_CODE              - Flex Code associated with the key flexfield structure.
--        SEGMENT_QUALIFIER         - Segment qualifier.
--        FLEX_VALUE_SET_ID         - Flex_value_set_id
--        ID_FLEX_NUM               - id_flex_num
--        GROUP_BY_FLAG             - Indicates if the column should be grouped.
--        FORMAT_MASK               - Format mask.
--        FORMAT_CLASS              - Format class.
--        GENERATED_FLAG            - GENERATED_FLAG = ''Y'' for those columns that the generator adds.
--        SOURCE_COLUMN_ID          - If the column was generated from another column, this column provides the source (parent) column_id.
--        GEN_SEARCH_BY_COL_FLAG    - If gen_search_by_col_flag = ''Y'', forces the creation of an "A$" column in the view.  ''N'' means the "A$" column is only generated if the column is indexed and the corresponding table has the gen_search_by_col_flag set in n_view_table_templates.
--        LOV_VIEW_LABEL            - LOV view label.
--        LOV_COLUMN_LABEL          - LOV column label.
--        PROFILE_OPTION            - Profile option used by the installer to determine if the record will be omitted or not.
--        PRODUCT_VERSION           - The product_version is part of the primary key so that if a column is different in release 9 and release 10, that both can be included.
--        OMIT_FLAG                 - Indicates if the column corrsponding to the record will be generated in genview.  Value is normally based on the profile_option column.
--        USER_OMIT_FLAG            - If OMIT_FLAG is "N", then we use USER_OMIT_FLAG to determine if the user wants this column suppressed.
--        CREATED_BY                - Who information indicates the person that created the current record.
--        CREATION_DATE             - Date the record was created.
--        LAST_UPDATED_BY           - Date the record was created.
--        LAST_UPDATE_DATE          - Date the record was last updated.
--
prompt table n_view_columns
create table n_view_columns(
        column_id               INTEGER                 not null,
        t_column_id             INTEGER                 null,
        view_name               varchar2(30)            not null,
        view_label              varchar2(30)            not null,
        query_position          number                  not null,
        column_name             varchar2(30)            not null,
        column_label            varchar2(30)            not null,
        table_alias             varchar2(30),
        column_expression       varchar2(&MAX_BUFFER)   not null,
        column_position         number                  not null,
        column_type             varchar2(20)            not null,
        description             varchar2(2000),
        ref_application_label   varchar2(10),
        ref_owner               varchar2(30),
        ref_table_name          varchar2(30),
        metadata_ref_table_name varchar2(30),
        key_view_name           varchar2(30),
        key_view_label          varchar2(30),
        ref_lookup_column_name  varchar2(30),
        ref_description_column_name     varchar2(40),
        ref_lookup_type         varchar2(30),
        profile_option          varchar2(30),
        group_by_flag           varchar2(1),
        application_instance    varchar2(4),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        format_mask             varchar2(40),
        format_class            varchar2(20),
        gen_search_by_col_flag  varchar2(1)  default 'N'  not null,
        lov_view_label          varchar2(30),
        lov_column_label        varchar2(30),
        lov_view_name           varchar2(30),
        lov_column_name         varchar2(30),
        source_column_id        INTEGER                   null,
        generated_flag          varchar2(1),
        segment_qualifier       varchar2(30),
        flex_value_set_id       number,
        id_flex_application_id  integer,
        id_flex_code            varchar2(10),
        id_flex_num             number,
        constraint n_view_columns_PK
                primary key ( column_id )
                using index storage (initial 1M next 512K pctincrease 0),
        constraint n_view_columns_u1
                unique ( view_name, query_position, column_name, profile_option )
                using index storage (initial 1M next 512K pctincrease 0),
        constraint n_view_columns_c2
        check (
                (       column_type                 =        'LOOK'
                    and ref_table_name              like     '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_lookup_type             is not   null
                )
           or
                (       column_type                 =        'LOOK'
                    and ref_table_name              not like '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_description_column_name is not   null
                    and ref_lookup_column_name      is not   null
                )
           or
                (       column_type                 =        'LOOKDESC'
                    and ref_table_name              like     '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_lookup_type             is not   null
                )
           or
                (       column_type                 =        'LOOKDESC'
                    and ref_table_name              not like '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_description_column_name is not   null
                    and ref_lookup_column_name      is not   null
                )
           or
                (       column_type                 =        'ALOOK'
                    and ref_table_name              like     '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_lookup_type             is not   null
                )
           or
                (       column_type                 =        'ALOOK'
                    and ref_table_name              not like '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_description_column_name is not   null
                    and ref_lookup_column_name      is not   null
                )
           or
                (       column_type                 =        'AUTOJOIN'
                    and ref_table_name              like     '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_description_column_name is not   null
                    and ref_lookup_column_name      is not   null
                    and ref_lookup_type             is not   null
                )
           or
                (       column_type                 =        'AUTOJOIN'
                    and ref_table_name              not like '%LOOKUP%'
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_description_column_name is not   null
                    and ref_lookup_column_name      is not   null
                )
           or
                (       column_type                 in ('QUERYOBJECT',
                                                        'SEGSTRUCT',
                                                        'ATTRSTRUCT')
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                )
           or
                (       column_type                 in ('SEGSTRUCT')
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    AND id_flex_application_id      is not null
                    AND id_flex_code                is not null
                )                            
           or
                (       column_type                 in ('KEY','KEYD','KEYCAT')
                    and ref_application_label       is not   null
                    and ref_table_name              is not   null
                    and ref_lookup_column_name      is not   null
                    AND id_flex_application_id      is not null
                    AND id_flex_code                is not null
                )
           or
                (       column_type                 in  ('SEG','SEGD','SEGCAT',
                                                         'SEGP')
                    and ref_lookup_column_name      is not   null
                    AND id_flex_application_id      is not null
                    AND id_flex_code                is not null
                )
           or
                (       column_type                 in ('SEGEXPR','ATTREXPR')
                    and column_expression           is not null
                )
           or
                (       column_type                 in ('COL',
                                                        'WHO','BASECOL')
                    and column_expression           not like '%(%'
                )
           or
                (       column_type                 in  ('ROWID')
                    and key_view_label              is not   null
                )
           or
                (       column_type                 = 'HINT'
                    and column_expression           like '/*+ % */'
                )
           or
                (       column_type                 in ('ID', 'EXPR', 'INLINE',
                                                        'NOSHOW','CONST', 'GENEXPR',
                                                        'GEN', 'ATTR', 'ATTRD', 
                                                        'CUST', 'CUSTP', 'ZDOLLAR'))
           ),
        constraint n_view_columns_c3
                check (column_position between 0 and 2000),
        constraint n_view_columns_c4
                check (omit_flag in ('Y', 'N')),
        constraint n_view_columns_c5
                check (group_by_flag in ('Y','N')),
        constraint n_view_columns_c6
                check (generated_flag in ('Y','N')),
        constraint n_view_columns_c7
                check (
                        column_type in
                          ('EXPR','INLINE','GENEXPR','CONST','SEGEXPR','ATTREXPR','HINT')
                     or table_alias is not null
                ),
        constraint n_view_columns_c8
                check ( segment_qualifier in ('GL_ACCOUNT','GL_BALANCING','GL_INTERCOMPANY','GL_SECONDARY_TRACKING',
                        'GL_GLOBAL','FA_COST_CTR','NONE')),
        constraint n_view_columns_c9
                check (gen_search_by_col_flag  in ('Y','N')),
        constraint n_view_columns_c10
                check(user_omit_flag in ('Y','N'))
        ) &TABLES_TABLESPACE
        storage (initial 4M next 2M pctincrease 0);


comment on table n_view_columns is
  'Specifies the columns that are associated with a given view.';

comment on column n_view_columns.column_id is
    'PK of the n_view_columns table.';
comment on column n_view_columns.t_column_id is
    'PK of the n_view_column_templates table.';
comment on column n_view_columns.view_label is
    'Label associated with the view column record.';
comment on column n_view_columns.query_position is
    'Query position associated with the view column record.';
comment on column n_view_columns.column_label is
    'Label assigned to the column.';
comment on column n_view_columns.table_alias is
    'Table alias associated with the current record.  Ignored in certain cases (EXPR for example.)';
comment on column n_view_columns.column_expression is
    'Expression associated with the column.';
comment on column n_view_columns.column_position is
    'Position of the column in the list.';
comment on column n_view_columns.column_type is
    'Type of the column.';
comment on column n_view_columns.description is
    'Description of the column.';
comment on column n_view_columns.ref_application_label is
    'Referenced application_label.';
comment on column n_view_columns.ref_table_name is
    'Name of the table that is referenced.';
comment on column n_view_columns.key_view_label is
    'A rowid jointo column will be generated based on the view_label specified in this column.';
comment on column n_view_columns.key_view_name is
    'A rowid jointo column will be generated with the name of the view specified in this column.';
comment on column n_view_columns.ref_lookup_column_name is
    'Name of the lookup column referenced.';
comment on column n_view_columns.ref_lookup_type is
    'Lookup type of the reference.';

comment on column n_view_columns.id_flex_application_id is
    'Application_ID associated with the key flexfield structure.';
comment on column n_view_columns.id_flex_code is
    'Flex Code associated with the key flexfield structure.';
comment on column n_view_columns.segment_qualifier is
    'Segment qualifier.';
comment on column n_view_columns.flex_value_set_id is
    'Flex_value_set_id';
comment on column n_view_columns.id_flex_num is
    'id_flex_num';

comment on column n_view_columns.group_by_flag is
    'Indicates if the column should be grouped.';
comment on column n_view_columns.format_mask is
    'Format mask.';
comment on column n_view_columns.format_class is
    'Format class.';

comment on column n_view_columns.source_column_id is
    'If the column was generated from another column, this column provides the source (parent) column_id.';
comment on column n_view_columns.generated_flag is
    'GENERATED_FLAG = ''Y'' for those columns that the generator adds.';
comment on column n_view_columns.gen_search_by_col_flag is
    'If gen_search_by_col_flag = ''Y'', forces the creation of an "A$" column in the view.  ''N'' means the "A$" column is only generated if the column is indexed and the corresponding table has the gen_search_by_col_flag set in n_view_table_templates.';

comment on column n_view_columns.lov_view_label is
    'LOV view label.';
comment on column n_view_columns.lov_view_name is
    'LOV view name.';
comment on column n_view_columns.lov_column_label is
    'LOV column label.';
comment on column n_view_columns.lov_column_name is
    'Name of the LOV column referenced.';

comment on column n_view_columns.profile_option is
    'Profile option used by the installer to determine if the record will be omitted or not.';
comment on column n_view_columns.omit_flag is
    'Indicates if the column corrsponding to the record will be generated in genview.  Value is normally based on the profile_option column.';
comment on column n_view_columns.user_omit_flag is
    'If OMIT_FLAG is "N", then we use USER_OMIT_FLAG to determine if the user wants this column suppressed.';

---------------------------------------------------------------------------------------------------
--
--  N_VIEW_COLUMN_EXTENSIONS
--
---------------------------------------------------------------------------------------------------
--

-- NOTE:  Table is supposed to be used for column extensions for non-templates only, but apparently gseg is using it to store
--        templates extensions records.  Otherwise, column_id would have a not null constraint.
prompt table n_view_column_extensions
create table n_view_column_extensions(
        column_id               INTEGER,
        t_column_id             INTEGER,
        view_name               varchar2(30)            not null,
        view_label              varchar2(30)            not null,
        query_position          number                  not null,
        column_name             varchar2(30)            not null,
        column_label            varchar2(30)            not null,
        expression_sequence     integer                 not null,
        column_expression       varchar2(&MAX_BUFFER)   not null,
        constraint n_view_column_extensions_c1
                check ( column_id is not null or t_column_id is not null ),
        constraint n_view_column_extensions_u1
                unique ( column_id, t_column_id, expression_sequence )
                using index storage (initial 1M next 512K pctincrease 0)
        )&TABLES_TABLESPACE
        storage (initial 1M next 200K pctincrease 0);

prompt table n_to_do_profile_options
create table n_to_do_profile_options(
        profile_option  varchar2(30)            not null,
        constraint n_to_do_profile_options_pk
                primary key (profile_option)
                using index storage (initial 20K next 20K pctincrease 50)
        ) &TABLES_TABLESPACE
        storage (initial 40K next 40K pctincrease 0);

prompt table n_to_do_views
create table n_to_do_views (
        view_name       varchar2(30)            not null,
        session_id      number                  not null,
        creation_date    date default sysdate   not null,
        last_update_date date default sysdate   not null,
        constraint n_to_do_views_pk
                primary key (view_name,session_id)
                using index storage (initial 20K next 20K pctincrease 50)
        ) &TABLES_TABLESPACE
        storage (initial 40K next 40K pctincrease 0);
comment on table n_to_do_views is
'This is a list of views that need to be generated.
At generation time this table gets updated from n_to_do_view_templates.
It is not cleaned out at generation time if only selected views are
generated. This allows changing views and keeping list to generate comments
and see when views were generated.';

comment on column n_to_do_views.view_name is
'This is a view that needs to be generated/regenerated.';

comment on column n_to_do_views.session_id is
'This column is set to the session_id at the beginning of a generation
session. All views marked with this session_id will be generated. If
a trigger or alert adds more views to the list while the generation is
going on, they will not be processed until the next time generation is run.';

prompt create table n_custom_objects
create table n_custom_objects
(  role_name                varchar2(50),
   user_name                varchar2(50),
   view_name                varchar2(50),
   create_optimizing_views  varchar2(1),
   create_synonyms          varchar2(1)
) &TABLES_TABLESPACE
  storage (initial 50K next 50K pctincrease 0)
;
comment on table n_custom_objects is
'This table is filled by SQL*Loader with object names
 must be created or not dropped during the Noetix install process.';
--
--
-- ******************** N_TEMP_LOOKUP_HEADERS ********************
--
prompt table n_temp_lookup_headers
create table n_temp_lookup_headers (
        lookup_id                   integer         not null,
        ref_table_name              varchar2(50)    not null,
        metadata_ref_table_name     varchar2(50)    not null,
        ref_lookup_type             varchar2(100),
        ref_lookup_column_name      varchar2(50),
        ref_description_column_name varchar2(50),
        ref_owner                   varchar2(50),
        lookup_count                integer,
        meaning_count               integer,
        lookup_bytes                integer,
        lookup_bytes_no_match       integer,
        language_or_security_group  varchar2(10),
        look_count                  integer,
        alook_count                 integer,
        lookdesc_count              integer,
        decode_body                 varchar2(2000),
        help_code_and_meaning       varchar2(2000),
        help_meaning_only           varchar2(2000),
        session_id                  number            not null,
        constraint n_temp_lookup_headers_pk
                primary key (lookup_id, session_id)
                using index storage (initial 1M
                                     next 512K
                                     pctincrease 0)
        ) &TABLES_TABLESPACE
        storage (initial 4M next 2M pctincrease 0);
        
CREATE INDEX n_temp_lookup_headers_n1
    ON n_temp_lookup_headers(ref_table_name, ref_owner, session_id);

comment on table n_temp_lookup_headers is
'Temporary table used by look.sql and lookp.sql. The script look.sql populates n_temp_lookup_headers with summary information about a lookup source. This data, along with n_temp_lookups, is used by the lookp.sql procedures in processing ALOOK, LOOK and LOOKDESC column types.';

comment on column n_temp_lookup_headers.lookup_id is
'This unique integer is used to link lookup source information to the lookup values found in n_temp_lookups.';

comment on column n_temp_lookup_headers.ref_table_name is
'One of the "REF" fields used to identify the source of the lookup. The data is taken from n_view_columns.ref_table_name. This field displays the source table for the lookup.';
--
--
-- ************************ N_TEMP_LOOKUPS ************************
--
prompt table n_temp_lookups
create table n_temp_lookups (
        lookup_id       integer                 not null,
        lookup_code     varchar2(71)            not null,
        meaning         varchar2(71)                    ,
        session_id      number                  not null,
        constraint n_temp_lookups_pk
                primary key (lookup_id,lookup_code, session_id)
                using index storage (initial 1M next 512K pctincrease 0),
        constraint n_temp_lookups_fk
                foreign key (lookup_id, session_id)
                references n_temp_lookup_headers
        ) &TABLES_TABLESPACE
        storage (initial 4M next 2M pctincrease 0);
comment on table n_temp_lookups is
'Temporary table used by look.sql. look.sql copies lookup values from
the tables they are stored in into n_temp_lookups as a step in building
decode statements to lookup these values. Usually, values will be copied
from tables like FND_LOOKUPS and MFG_LOOKUPS. This table may also be used
in the yet-to-be-done routine that builds comments for lookup codes.';

comment on column n_temp_lookups.lookup_code is
'This is the value of the column referred to by the column listed in
n_view_columns.ref_lookup_column. This value will be matched against
the foreign key to look up the value in the "meaning" column. In tables
like FND_LOOKUPS, this will be the value of the LOOKUP_CODE. But other
possibilities occur: for example, AP_TERMS may be looked up, in which
case this column is the value of TERM_ID.';

comment on column n_temp_lookups.meaning is
'This is the value that the user sees for a lookup column. This value
comes from the column listed in n_view_columns.ref_description_columns.
In tables like FND_LOOKUPS, this value will be copied from the MEANING
column. In AP_TERMS the value comes from NAME.';
--
--
prompt table n_gorg_temp
create table n_gorg_temp (
        column_type     varchar2(60)            not null,
        value           varchar2(100)           not null,
        constraint n_gorg_temp_pk
                primary key (column_type,value)
                using index storage (initial 100K next 100K pctincrease 0)
        ) &TABLES_TABLESPACE
        storage (initial 50K next 50K pctincrease 0)
;
comment on table n_gorg_temp is
'Temporary table used by gorg.sql. Since we''re expanding the size of the
string values in n_application_owners, we need an alternate method for determining
if a string already exists in the list.  This table provides the ability to
determine if duplicate values exist.';


prompt create table n_fnd_descr_flex_temp
create table n_fnd_descr_flex_temp
(
    title                          varchar2(60),
    application_id                 number               not null,
    table_application_id           number               not null,
    application_table_name         varchar2(30)         not null,
    context_column_name            varchar2(30)         not null,
    descriptive_flex_context_code  varchar2(30)         not null,
    global_flag                    varchar2(1)          not null,
    end_user_column_name           varchar2(30)         not null,
    application_column_name        varchar2(30)         not null,
    description                    varchar2(240),
    column_seq_num                 number               not null,
    protected_flag                 varchar2(1)          not null,
    flex_value_set_id              number,
    flex_value_set_application_id  number
        ) &TABLES_TABLESPACE
        storage (initial 50K next 50K pctincrease 0)
;

comment on table n_fnd_descr_flex_temp is
'Temporary table used by attrp.sql. This speeds up the attrp process.';

create index n_fnd_descr_flex_temp_n1 on n_fnd_descr_flex_temp
(
    table_application_id,
    application_table_name,
    title,
    application_column_name,
    descriptive_flex_context_code
)
&TABLES_TABLESPACE
storage(
            initial          50k
            next             50k
            pctincrease      0
        )
;

PROMPT CREATE TABLE n_column_drill
CREATE TABLE n_column_drill
            (drill_name                 VARCHAR2(100)   NOT NULL,
             view_name                  VARCHAR2(30)    NOT NULL,
             column_name                VARCHAR2(30)    NOT NULL,
             sequence                   NUMBER          NOT NULL,
             join_column                VARCHAR2(30),
             description                VARCHAR2(240),
             parent                     VARCHAR2(01)
                CONSTRAINT n_column_drill_c1
                           CHECK(parent IN ('Y','N')),
             child                      VARCHAR2(01)
                CONSTRAINT n_column_drill_c2
                           CHECK(child IN ('Y','N')),
             creation_date              DATE,
             CONSTRAINT n_column_drill_pk
             PRIMARY KEY (drill_name, view_name, column_name, sequence)
             USING INDEX STORAGE (INITIAL 10K NEXT 10K PCTINCREASE 0)
        ) &TABLES_TABLESPACE
STORAGE (INITIAL 10K NEXT 10K PCTINCREASE 0);

--
-- This table is currently only used by HR and is populated by worghr.sql
--
PROMPT CREATE TABLE n_application_config_parms

create table n_application_config_parms
(application_label      varchar2(10)            not null,
 application_instance   varchar2(4)             not null,
 parameter_name         varchar2(30)            not null,
 substitution_value     varchar2(2000)                  ,
           CONSTRAINT n_application_config_parms_pk
           PRIMARY KEY (application_label, application_instance, parameter_name)
           USING INDEX STORAGE (INITIAL 10K NEXT 10K PCTINCREASE 0)
        ) &TABLES_TABLESPACE
STORAGE (INITIAL 10K NEXT 10K PCTINCREASE 0);

--
-- This table is HR specific and will be populated
-- by ycrhrp.sql and used by the packaged procedures created there
--
PROMPT CREATE TABLE n_hr_work_freq_conv as necessary
begin 
    N_DB_OBJECTS_PKG.CREATE_TABLE( 'N_HR_WORK_FREQ_CONV',
'create table n_hr_work_freq_conv
      ( business_group_id_like          VARCHAR2(30),
        frequency                       VARCHAR2(30),
        frequency_description           VARCHAR2(30),
        occurrences_per_year            NUMBER,
        occurrences_per_month           NUMBER,
        full_time_hours_per_occurrence  NUMBER
      ) &TABLES_TABLESPACE
        STORAGE (INITIAL 10K NEXT 10K PCTINCREASE 0)' );
END;
/

--
-- Populate the frequence conversion table with US defaults
--
INSERT INTO n_hr_work_freq_conv
SELECT '%', 'D', 'Daily',   52*5, 52*5/12, 8
  FROM DUAL
 WHERE NOT EXISTS
     ( SELECT 'Record Found'
         FROM n_hr_work_freq_conv
        WHERE business_group_id_like          = '%'
          AND frequency                       = 'D'
          AND frequency_description           = 'Daily'
          AND occurrences_per_year            = 52*5
          AND occurrences_per_month           = 52*5/12
          AND full_time_hours_per_occurrence  = 8 );
--
INSERT INTO n_hr_work_freq_conv
SELECT '%', 'W', 'Weekly',  52,   52/12,   40 
  FROM DUAL
 WHERE NOT EXISTS
     ( SELECT 'Record Found'
         FROM n_hr_work_freq_conv
        WHERE business_group_id_like          = '%'
          AND frequency                       = 'W'
          AND frequency_description           = 'Weekly'
          AND occurrences_per_year            = 52
          AND occurrences_per_month           = 52/12
          AND full_time_hours_per_occurrence  = 40 );
--
INSERT INTO n_hr_work_freq_conv
SELECT '%', 'M', 'Monthly', 12,   1,       2080/12
  FROM DUAL
 WHERE NOT EXISTS
     ( SELECT 'Record Found'
         FROM n_hr_work_freq_conv
        WHERE business_group_id_like          = '%'
          AND frequency                       = 'M'
          AND frequency_description           = 'Monthly'
          AND occurrences_per_year            = 12
          AND occurrences_per_month           = 1
          AND full_time_hours_per_occurrence  = 2080/12 );
--
INSERT INTO n_hr_work_freq_conv
SELECT '%', 'Y', 'Yearly', 1,   1/12,       2080
  FROM DUAL
 WHERE NOT EXISTS
     ( SELECT 'Record Found'
         FROM n_hr_work_freq_conv
        WHERE business_group_id_like          = '%'
          AND frequency                       = 'Y'
          AND frequency_description           = 'Yearly'
          AND occurrences_per_year            = 1
          AND occurrences_per_month           = 1/12
          AND full_time_hours_per_occurrence  = 2080 );

-- Remove any duplicate entries for yearly that were previously generated in error.
-- The original not exists clause for Yearly was acctually mixed up with monthly.
DELETE from n_hr_work_freq_conv fc
 WHERE fc.business_group_id_like          = '%'
   AND fc.frequency                       = 'Y'
   AND fc.frequency_description           = 'Yearly'
   AND fc.occurrences_per_year            = 1
   AND fc.occurrences_per_month           = 1/12
   AND fc.full_time_hours_per_occurrence  = 2080
   AND rowid not in 
     ( SELECT MAX(rowid)
         FROM n_hr_work_freq_conv fc2
        WHERE fc2.business_group_id_like          = '%'
          AND fc2.frequency                       = 'Y'
          AND fc2.frequency_description           = 'Yearly'
          AND fc2.occurrences_per_year            = 1
          AND fc2.occurrences_per_month           = 1/12
          AND fc2.full_time_hours_per_occurrence  = 2080 );

--
COMMIT;
       
--
-- this table is created as a means of speeding up the install,
-- it will contain all of the tables in the user's system that have the
-- a column named SET_OF_BOOKS_ID, ORG_ID or ORGANIZATION_ID
--
create table n_noetix_column_lookup (
    table_name      varchar2(30) not null,
    column_name     varchar2(30) not null,
    constraint n_noetix_column_lookup_pk
        primary key (table_name,column_name)
        using index storage ( initial 10K next 10K pctincrease 0 )
    )
    storage ( initial 10K next 10K pctincrease 0 )
/

--
-- when the user turns on the global views, this is filled up with the
-- table alias per view and query that should be used when mapping to
-- the columns specified
--
create table n_cross_org_map_alias (
    application_label   varchar2(10)    not null,
    view_label          varchar2(30)    not null,
    view_name           varchar2(30)    not null,
    query_position      number          not null,
    map_type            varchar2(30)    not null,
        constraint n_cross_org_map_alias_c1
            check(map_type in ('SET_OF_BOOKS_ID','ORG_ID','ORGANIZATION_ID')),
    table_alias         varchar2(30)    not null,
    owner_name          varchar2(30)    not null,
    table_name          varchar2(30)    not null,
    base_table_flag     varchar2(1)     not null,
    sob_column_name     varchar2(30),
        constraint n_cross_org_map_alias_c2
            check(base_table_flag in ('Y','N')),
    constraint n_cross_org_map_alias_pk
        primary key (application_label,view_label,view_name,query_position,map_type)
        using index storage (initial 10K next 10K pctincrease 0)
    ) storage (initial 10K next 10K pctincrease 0)
/

--
-- this table stores views that need special processing by genview
--
create table n_xorg_to_do_views (
        application_label       varchar2(10) ,
        application_instance    varchar2(4)  ,
        view_name               varchar2(30) not null,
        view_label              varchar2(30) ,
        query_position          number not null,
        constraint n_xorg_to_do_views_pk
            primary key (view_name,query_position)
            using index storage ( initial 10K next 10K pctincrease 0 )
        )
        storage ( initial 10K next 10K pctincrease 0 )
/
--
-- this table stores views which have outer join problem
--
create table n_xorg_prob_views (
        view_name               varchar2(30) not null,
        query_position          number not null
)
 storage ( initial 10K next 10K pctincrease 0 )
/


--this table stores the global views and their component views
--

create table n_xorg_global_comp_views
 (
 APPLICATION_LABEL                VARCHAR2(10) NOT NULL
  , GLOBAL_INSTANCE                  VARCHAR2(4)  NOT NULL
  , COMP_INSTANCE                    VARCHAR2(4)  NOT NULL
  , GLOBAL_VIEW                      VARCHAR2(30) NOT NUll
  , COMPONENT_VIEW                   VARCHAR2(30) NOT NULL
  )
  storage ( initial 10K next 10K pctincrease 0 )
/

--
-- Comments on noetix objects created during installation scripts
--

comment on table  n_view_parameters                             is
'n_view_parameters stores the installation information about a noetix views
installation.  For each noetix system administration user there will
be one record.';

comment on column n_view_parameters.noetix_sys_user             is
        'Name of the &DAT_APPLICATION System Administration Account Database User';

--
-- Add constraints to tables
--
alter table n_application_owners add (
        constraint n_application_owners_fk1
                foreign key(application_label)
                references n_application_owner_templates);
alter table n_application_xref  add (
        constraint n_application_xref_fk1
                foreign key (application_label,application_instance)
                references n_application_owners,
        constraint n_application_xref_fk2
                foreign key (ref_application_label,ref_application_instance)
                references n_application_owners);
alter table n_app_to_app add (
        constraint n_app_to_app_fk1
                foreign key (application_label, application_instance)
                references n_application_owners,
        constraint n_app_to_app_fk2
                foreign key (ref_application_label, ref_application_instance)
                references n_application_owners);
alter table n_roles add (
        constraint n_roles_fk1
                foreign key (role_label)
                references n_role_templates,
        constraint n_roles_fk2
                foreign key(application_label,application_instance)
                references n_application_owners);
alter table n_profile_options add (
        constraint n_profile_options_fk1
                foreign key (application_label,application_instance)
                references n_application_owners,
        constraint n_profile_options_fk2
                foreign key (profile_option)
                references n_profile_option_templates,
        constraint n_profile_options_fk3
                foreign key (table_application_label)
                references n_application_owner_templates);
alter table n_grant_tables add (
        constraint n_grant_tables_fk1
                foreign key (application_label, application_instance)
                references n_application_owners,
        constraint n_grant_tables_fk2
                foreign key (application_label, table_name)
                references n_grant_table_templates);
alter table n_views add (
        constraint n_views_fk1
                foreign key(application_label,application_instance)
                references n_application_owners,
        constraint n_views_fk2
                foreign key(profile_option, application_instance)
                references n_profile_options,
        constraint n_views_fk3
                foreign key (view_label)
                references n_view_templates);
alter table n_role_views add (
        constraint n_role_views_fk2
                foreign key (role_name)
                references n_roles,
        constraint n_role_views_fk3
                foreign key (view_name)
                references n_views);
alter table n_view_queries add (
        constraint n_view_queries_fk1
                foreign key (view_name)
                references n_views,
        constraint n_view_queries_fk2
                foreign key (profile_option, application_instance)
                references n_profile_options,
        constraint n_view_queries_fk3
                foreign key (view_label, query_position)
                references n_view_query_templates);
alter table n_view_wheres add (
        constraint n_view_wheres_fk1
                foreign key (view_name, query_position)
                references n_view_queries,
        constraint n_view_wheres_fk2
                foreign key (profile_option, application_instance)
                references n_profile_options);
alter table n_view_tables add (
        constraint n_view_tables_fk1
                foreign key (view_name, query_position)
                references n_view_queries,
        constraint n_view_tables_fk2
                foreign key (application_label)
                references n_application_owner_templates,
        constraint n_view_tables_fk3
                foreign key (profile_option, application_instance)
                references n_profile_options );
--
----                ,
----        constraint n_view_tables_fk4
----                foreign key (key_view_name)
----                references n_views,
----        constraint n_view_tables_fk5
----                foreign key (key_view_label)
----                references n_view_templates);
--
alter table n_view_columns add (
        constraint n_view_columns_fk1
                foreign key (view_name, query_position)
                references n_view_queries,
        constraint n_view_columns_fk2
                foreign key (profile_option, application_instance)
                references n_profile_options,
        constraint n_view_columns_fk3
                foreign key (ref_application_label)
                references n_application_owner_templates,
        constraint n_view_columns_fk4
                foreign key (key_view_name)
                references n_views,
        constraint n_view_columns_fk5
                foreign key (key_view_label)
                references n_view_templates,
        constraint n_view_columns_fk6
                foreign key (t_column_id)
                references n_view_column_templates,
        constraint n_view_columns_fk7
                foreign key (source_column_id)
                references n_view_columns);
--
alter table n_to_do_profile_options add (
        constraint n_to_do_profile_options_fk1
                foreign key (profile_option)
                references n_profile_option_templates);
alter table n_to_do_views  add (
        constraint n_to_do_views_fk1
                foreign key (view_name)
                references n_views);
alter table n_application_config_parms  add (
        constraint n_application_config_parms_fk1
                foreign key(application_label,application_instance)
                references n_application_owners);

-- Now create the Query Environment Enhancing Views
@queryenv

-- Reset the error message since queryenv changes the error code
whenever sqlerror exit 8

--prompt index n_roles_n1 (Helps generator API)
create index n_roles_N1
    on n_roles( application_label, application_instance, owner_name )
&TABLES_TABLESPACE
storage (initial 70K next 35k pctincrease 50);

--
-- dglancy 15-sep-98
-- create index on view_label in the n_views
-- and the n_to_do_views tables
-- Help to increase performance.
--
prompt index n_views_n1
create index n_views_n1
on      n_views(view_label)
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);

--prompt index n_views_N2
create index n_views_N2
    on n_views(upper(view_name))
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);

--prompt index n_views_N3
create index n_views_N3
    on n_views( upper(view_label) )
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);

--prompt index n_views_N4 (helps generator api)
create index n_views_N4
    on n_views( application_label, application_instance, view_name )
&TABLES_TABLESPACE
storage (initial 120K next 60k pctincrease 50);

prompt index n_view_columns_n2
create index n_view_columns_n2
on      n_view_columns(flex_value_set_id, id_flex_code, id_flex_num)
&TABLES_TABLESPACE
storage (initial 500K next 250k );

prompt index n_view_columns_n3
create index n_view_columns_n3
on      n_view_columns(profile_option)
&TABLES_TABLESPACE
storage (initial 500K next 250k );

prompt index n_view_columns_n4
create index n_view_columns_n4
on      n_view_columns(UPPER(column_name))
&TABLES_TABLESPACE
storage (initial 500K next 250k );

prompt index n_view_columns_n5
create index n_view_columns_n5
on      n_view_columns(t_column_id)
&TABLES_TABLESPACE
storage (initial 500K next 250k );

prompt index n_view_columns_n6
create index n_view_columns_n6
on      n_view_columns(source_column_id)
&TABLES_TABLESPACE
storage (initial 500K next 250k );

prompt index n_view_tables_n3
create index n_view_tables_n3
on      n_view_tables(profile_option)
&TABLES_TABLESPACE
storage (initial 100K next 200k );

prompt index n_view_wheres_n1
create index n_view_wheres_n1
on      n_view_wheres(profile_option)
&TABLES_TABLESPACE
storage (initial 300K next 250K );

prompt index n_to_do_views_n1
create index n_to_do_views_n1
on  n_to_do_views(session_id)
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);

-- Create the answer tables
create table n_help_questions (
        question_id             number          not null,
        t_question_id           number          not null,
        view_name               varchar2(30)    not null,
        view_label              varchar2(30)    not null,
        application_label       varchar2(10)    not null,
        application_instance    varchar2(4)     not null,
        question                varchar2(240)   not null,
        question_position       number          not null,
        business_value          number,
        hint                    varchar2(&MAX_BUFFER),
        keywords                varchar2(200),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_help_questions_pk
                primary key (question_id)
                using index storage (initial 20K next 20K pctincrease 0),
        constraint n_help_questions_c1
                check(omit_flag in ('Y','N')),
        constraint n_help_questions_c2
                check(user_omit_flag in ('Y','N'))
        ) &TABLES_TABLESPACE
        storage (initial 512K next 100K pctincrease 0);

create table n_answers (
        answer_id               number          not null,
        question_id             number          not null,
        t_answer_id             number          not null,
        answer_position         number          not null,
        answer_description      varchar2(240),
        html_link               varchar2(2000),
        answer_type             varchar2(20),
        report_title            varchar2(240),
        report_sub_title        varchar2(240),
        parameter_prompt_title  varchar2(240),
        generator_view          varchar2(256),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_answers_pk
                primary key (answer_id)
                using index storage (initial 20K next 20K pctincrease 0),
        constraint n_answers_u1
                unique (question_id, answer_position)
                using index storage (initial 20K next 20K pctincrease 0),
        constraint n_answers_c1
                check(omit_flag in ('Y','N')),
        constraint n_answers_c2
                check(user_omit_flag in ('Y','N')),
        constraint n_answers_fk1
                foreign key (question_id)
                   references n_help_questions
                   on delete cascade,
        constraint n_answers_fk2
                foreign key (t_answer_id)
                   references n_answer_templates
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_queries(
        answer_id                   number          not null,
        query_position              number          not null,
        question_id                 number          not null,
        union_minus_intersection    varchar2(12),
        description                 varchar2(80),
        distinct_flag               varchar2(1),
        profile_option              varchar2(30),
        omit_flag                   varchar2(1),
        user_omit_flag              varchar2(1),
        created_by                  varchar2(30)  default '&CREATED_BY' not null,
        creation_date               date          default sysdate       not null,
        constraint n_ans_queries_pk
                primary key (answer_id, query_position)
                using index storage (initial 20K next 20K pctincrease 0),
        constraint n_ans_queries_c1
                check(union_minus_intersection in
                        ('UNION','UNION ALL','MINUS','INTERSECT')),
        constraint n_ans_queries_c2
                check(query_position between 1 and 20),
        constraint n_ans_queries_c3
                check(omit_flag in ('Y','N')),
        constraint n_ans_queries_c4
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_queries_fk1
                foreign key (answer_id)
                   references n_answers
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_tables(
        answer_id               number                  not null,
        query_position          number                  not null,
        table_alias             varchar2(5)             not null,
        question_id             number                  not null,
        from_clause_position    number                  not null,
        application_label       varchar2(10)            not null,
        table_name              varchar2(30),
        view_application_label  varchar2(10),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_ans_tables_pk
                primary key(answer_id, query_position, table_alias)
                using index storage (initial 40K next 40K pctincrease 0),
        constraint n_ans_tables_c1
                check(from_clause_position between 1 and 50),
        constraint n_ans_tables_c2
                check(omit_flag in ('Y','N')),
        constraint n_ans_tables_c3
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_tables_fk1
                foreign key (answer_id,query_position)
                   references n_ans_queries
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_wheres(
        answer_id               number                  not null,
        query_position          number                  not null,
        where_clause_position   number                  not null,
        question_id             number                  not null,
        where_clause            varchar2(&MAX_BUFFER)   not null,
        variable_exists_flag    varchar2(1),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_ans_wheres_pk
                primary key (answer_id, query_position, where_clause_position)
                using index storage (initial 20K next 20K pctincrease 0),
        constraint n_ans_wheres_c1
                check(where_clause_position between 1 and 1000),
        constraint n_ans_wheres_c2
                check(omit_flag in ('Y','N')),
        constraint n_ans_wheres_c3
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_wheres_fk1
                foreign key (answer_id,query_position)
                   references n_ans_queries
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_columns(
        ans_column_id           INTEGER                 not null,
        question_id             INTEGER                 not null,
        answer_id               INTEGER                 not null,
        query_position          number                  not null,
        t_ans_column_id         INTEGER,
        column_label            varchar2(30)            not null,
        column_title            varchar2(240),
        table_alias             varchar2(5),
        column_expression       varchar2(&MAX_BUFFER),
        column_position         number                  not null,
        column_type             varchar2(20)            not null,
        column_sub_type         varchar2(2),
        description             varchar2(240),
        order_by_position       number,
        ascending_flag          varchar2(1),
        format_mask             varchar2(40),
        format_class            varchar2(20),
        group_sort_flag         varchar2(1),
        display_width           number,
        horizontal_alignment    varchar2(6),
        aggregation_type        varchar2(20),
        aggregation_distinct_flag varchar2(1),
        page_item_flag          varchar2(1),
        page_item_position      number,
        display_flag            varchar2(1),
        lov_view_label          varchar2(30),
        lov_view_name           varchar2(30),
        lov_disp_column_label   varchar2(30),
        lov_parent_column_label varchar2(30),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        mandatory_flag          varchar2(1),
        match_answer_column_string varchar2(255),
        constraint n_ans_columns_pk
                primary key (ans_column_id)
                using index storage (initial 500K next 100K pctincrease 50),
        constraint n_ans_columns_fk1
                foreign key (answer_id,query_position)
                   references n_ans_queries
                   on delete cascade,
        constraint n_ans_columns_fk2
                foreign key (answer_id,query_position,table_alias)
                   references n_ans_tables
                   on delete cascade,
        constraint n_ans_columns_c1
        check (
                (  column_type in  ('COL','EXPR','SEG','SEGP','SEGCAT','SEGI',
                                    'SEG_JOIN','SEGCAT_JOIN','SEGI_JOIN','SEGD_JOIN',
                                    'SEG_JOIN_ADD_INDIV','SEGI_JOIN_ADD_INDIV','SEGD_JOIN_ADD_INDIV',
                                    'SEGD','CONST','GEN','GENEXPR','ATTR','CUST')
                )
              ),
        constraint n_ans_columns_c4
                check (
                        column_type in
                        ('EXPR','CONST')
                     or table_alias is not null
                ),
        constraint n_ans_columns_c5
                check(omit_flag in ('Y','N')),
        constraint n_ans_columns_c6
                check(user_omit_flag in ('Y','N'))
        ) &TABLES_TABLESPACE
        storage (initial 1M next 100K pctincrease 50);

create table n_ans_params(
        param_id                INTEGER                  not null,
        question_id             INTEGER                  not null,
        answer_id               INTEGER                  not null,
        query_position          number                   not null,
        param_position          number                   not null,
        ans_column_id           INTEGER                  not null,
        t_param_id              INTEGER                  not null,
        parameter_prompt        varchar2(80),
        operator                varchar2(20),
        having_flag             varchar2(1),
        and_or                  varchar2(10),
        mandatory_flag          varchar2(1),
        param_filter_type       varchar2(10)             not null,
        processing_code         varchar2(1),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag               varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_ans_params_pk
                primary key (param_id)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_ans_params_u1
                unique (answer_id, query_position, param_position)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_ans_params_c1
                check(omit_flag in ('Y','N')),
        constraint n_ans_params_c2
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_params_fk1
                foreign key (answer_id,query_position)
                   references n_ans_queries
                   on delete cascade,
        constraint n_ans_params_fk2
                foreign key (ans_column_id)
                   references n_ans_columns
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_param_values(
        param_value_id          number                   not null,
        question_id             number                   not null,
        answer_id               number                   not null,
        query_position          number                   not null,
        t_param_value_id        number                   not null,
        param_id                number                   not null,
        param_value_position    number                   not null,
        param_value             varchar2(2000)           not null,
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_ans_param_values_pk
                primary key (param_value_id)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_ans_param_values_c1
                check(omit_flag in ('Y','N')),
        constraint n_ans_param_values_c2
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_param_values_fk1
                foreign key (param_id)
                   references n_ans_params
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_column_totals(
        total_id                INTEGER                  not null,
        question_id             INTEGER                  not null,
        answer_id               INTEGER                  not null,
        query_position          number                   not null,
        t_total_id              INTEGER                  not null,
        ans_column_id           INTEGER                  not null,
        t_ans_column_id         INTEGER                  not null,
        total_function          varchar2(10)             not null,
        total_label             varchar2(240),
        total_type              varchar2(10)             not null,
        break_ans_column_id     INTEGER,
        break_t_ans_column_id   INTEGER,
        break_on_group_sort_flag varchar2(1),
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_ans_column_totals_pk
                primary key (total_id)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_ans_column_totals_c1
                check(omit_flag in ('Y','N')),
        constraint n_ans_column_totals_c2
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_column_totals_fk1
                foreign key (ans_column_id)
                   references n_ans_columns
                   on delete cascade,
        constraint n_ans_column_totals_fk2
                foreign key (break_ans_column_id)
                   references n_ans_columns
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 100K next 100K pctincrease 0);

create table n_ans_audiences(
        answer_id               number                   not null,
        question_id             number                   not null,
        audience_code           varchar2(30)             not null,
        profile_option          varchar2(30),
        omit_flag               varchar2(1),
        user_omit_flag          varchar2(1),
        created_by              varchar2(30)  default '&CREATED_BY' not null,
        creation_date           date          default sysdate       not null,
        constraint n_ans_audiences_pk
                primary key (answer_id,audience_code)
                using index storage (initial 10K next 10K pctincrease 0),
        constraint n_ans_audiences_c1
                check(omit_flag in ('Y','N')),
        constraint n_ans_audiences_c2
                check(user_omit_flag in ('Y','N')),
        constraint n_ans_audiences_fk1
                foreign key (answer_id)
                   references n_answers
                   on delete cascade
        ) &TABLES_TABLESPACE
        storage (initial 10K next 10K pctincrease 0);

create table n_temp_install_status(
        err_message             varchar2(240),
        err_type                varchar2(30)
        ) &TABLES_TABLESPACE
        storage (initial 10k next 10k pctincrease 0);
--
-- Create the n_installation_messages table to store installation
-- error and warning details.
prompt table n_installation_messages
create table n_installation_messages (
        script_name    varchar2(100),
        location       varchar2(200)   not null,
        message_seq    number          not null,
        message_type   varchar2(10)    not null,
                constraint n_installation_messages_c1
                       check (message_type in ('WARNING','ERROR','INFO','DEBUG')),
        message        varchar2(2000)  not null,
        creation_date  date            not null,
        process_type   varchar2(30) 
        ) &TABLES_TABLESPACE
        storage (initial 20K next 20K pctincrease 50)
;
comment on table n_installation_messages is
'Stores messages generated during installation';
--
--
-- For performance reasons, we're going to create a temp table of all
-- the base views.  It will be populated in popview.sql and
-- used by popview.sql, autojoip.sql and xviewck.sql. It is dropped
-- in xviewck.sql.
--
create table n_popbase_temp (
        view_name               varchar2(30) not null,
        view_name_upper         varchar2(30) not null,
        view_label              varchar2(30) not null,
        application_label       varchar2(10) not null,
        application_instance    varchar2(4) not null,
        constraint n_popbase_temp_pk
            primary key ( view_name,
                          view_label,
                          application_label,
                          application_instance  )
            using index storage ( initial 10K next 10K pctincrease 0 )
                )
        storage ( initial 100K next 50K pctincrease 0 );

create index n_popbase_temp_n1
    on n_popbase_temp( view_name_upper,
                       application_label,
                       application_instance )
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 0);

create index n_popbase_temp_n2
    on n_popbase_temp( view_label,
                       application_label,
                       application_instance )
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 0);

--
--
-- Tracks of View Name changes.
--
create table n_view_name_changes (
        orig_view_name_hex      varchar2(500) not null,
        target_view_name        varchar2(30),
        generated_view_name     varchar2(30)  not null,
        view_label              varchar2(30)  not null,
        application_label       varchar2(10),
        application_instance    varchar2(4),
        special_process_code    varchar2(30),
        use_generated_flag      varchar2(1)   DEFAULT 'N' NOT NULL
                     constraint n_view_name_changes_c1
                          check(use_generated_flag in ('Y','N')),
        constraint n_view_name_changes_pk
            primary key ( orig_view_name_hex )
            using index storage ( initial 10K next 10K pctincrease 0 )
                )
        storage ( initial 10K next 10K pctincrease 0 );
--
prompt index n_view_name_changes_u1
create UNIQUE index n_view_name_changes_u1
on      n_view_name_changes(generated_view_name)
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);
--
-- Tracks of View Column Name changes.
--
create table n_column_name_changes (
        orig_view_name          varchar2(500)  not null,
        orig_column_name_hex    varchar2(500)  not null,
        target_column_name      varchar2(30),
        generated_column_name   varchar2(30)   not null,
        view_label              varchar2(30)   not null,
        application_instance    varchar2(4),
        use_generated_flag      varchar2(1)    DEFAULT 'N' NOT NULL
                     constraint n_column_name_changes_c1
                          check(use_generated_flag in ('Y','N')),
        constraint n_column_name_changes_pk
            primary key ( orig_view_name, orig_column_name_hex )
            using index storage ( initial 10K next 10K pctincrease 0 )
                )
        storage ( initial 10K next 10K pctincrease 0 );
--
prompt index n_column_name_changes_n1
create index n_column_name_changes_n1
on      n_column_name_changes(orig_view_name, target_column_name)
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);
--
prompt index n_column_name_changes_u2
create UNIQUE index n_column_name_changes_u2
on      n_column_name_changes(orig_view_name,generated_column_name)
&TABLES_TABLESPACE
storage (initial 100K next 50k pctincrease 50);
--
CREATE TABLE N_VALID_CHARACTERS (
  LETTER       VARCHAR2 (12)  NOT NULL,
  ALT_LETTER   VARCHAR2 (12)  NOT NULL,
  ASCII_VALUE  NUMBER         NOT NULL,
  constraint n_valid_characters_pk
     primary key (letter)
       using index storage ( initial 10K next 10K pctincrease 0 )
              )
  storage ( initial 10K next 10K pctincrease 0 );

--
-- Create the a the N_LONG_DUAL table.  This table has only one column
-- that is a long and should contain a null.  It is strictly used in the following case:
--    UNION ALL between a column of datatype LONG and a NULL column is
--    erroring out saying datatype does'nt match.  We have created
--    a table with a LONG column. A single row will be inserted with a
--    NULL value. In the metadata, when we need to do a UNION ALL between
--    a LONG column and NULL, NULL will be pulled from this table.
DEFINE LONG_COLUMN_TYPE=LONG
COLUMN s_long_column_type NEW_VALUE LONG_COLUMN_TYPE NOPRINT
SELECT 'CLOB' s_long_column_type
  FROM dual
 WHERE to_number('&PRODUCT_VERSION')  >= 12.2;

prompt table N_LONG_DUAL
CREATE TABLE N_LONG_DUAL
     ( DUMMY       &LONG_COLUMN_TYPE,
       DUMMY_CLOB  CLOB               )
       &TABLES_TABLESPACE
       storage (initial 1K next 1K pctincrease 0);
-- Create the column
comment on table N_LONG_DUAL is
'Used to rectify UNION ALL joins that specify a long value in one query and a null value from another.  DUMMY column is LONG.  DUMMY_CLOB is CLOB column.'
;
-- Insert the null column into this table.
INSERT INTO N_LONG_DUAL VALUES (NULL, NULL)
;
COLUMN s_long_column_type CLEAR
UNDEFINE LONG_COLUMN_TYPE


--
-- The following three tables are used for global key flexfield
-- processing
--
-- Once an id_flex_code view has been identified and created, the information
-- on the view is stored in this table. Then, the next time the global seg
-- processing comes across this id_flex_code we can save ourselves some trouble
-- by checking this table first to see if the record will need to be handled
-- using the view option.
prompt Table N_SEG_ID_FLEX_CODE_HEADERS
create table N_Seg_Id_Flex_Code_Headers
(id_flex_code      VARCHAR2(30)   NOT NULL,
 id_flex_name      VARCHAR2(30)   NOT NULL,
 application_label VARCHAR2(30)   NOT NULL,
 structure_list    VARCHAR2(2000) NOT NULL,
 view_name         VARCHAR2(30)   NOT NULL,
 max_positions     NUMBER         NOT NULL,
 alias_length      INTEGER        NOT NULL,
 source_owner_name VARCHAR2(30)   NOT NULL,
 source_table_name VARCHAR2(30)   NOT NULL)
 storage ( initial 10K next 10K pctincrease 0 )
/
--
prompt Table N_SEG_ID_FLEX_SEGMENTS_REORDER
create table n_seg_id_flex_segments_reorder
(id_flex_code             VARCHAR2(30)   NOT NULL,
 id_flex_num              NUMBER(15)     NOT NULL,
 application_column_name  VARCHAR2(30),
 segment_name             VARCHAR2(30)   NOT NULL,
 segment_num              NUMBER         NOT NULL,
 position                 NUMBER         NOT NULL)
storage ( initial 10K next 10K pctincrease 0 )
/
--
-- This table temporarily stores the SQL used to make the id flex
-- code views created in n_seg_global_proc1.
prompt Table N_SEG_ID_FLEX_CODE_VIEW_SQL
create table n_seg_id_flex_code_view_sql
(view_name     VARCHAR2(30)   NOT NULL,
 position      INTEGER        NOT NULL,
 text          VARCHAR2(2000))
storage ( initial 10K next 10K pctincrease 0 )
/
--
-- This table is used to track the individual segment flexfield view
-- name associated with each key flexfield.
prompt table N_SEG_KEY_FLEXFIELDS
create table n_seg_key_flexfields(
        flexfield_application_label  varchar2(30)                not null,
        id_flex_code                 varchar2(30)                not null,
        structure_application_label  varchar2(30) default 'NONE' not null,
        individual_view_label        varchar2(30),
        individual_view_name         varchar2(30),
        required_flag                varchar2(1),
        constraint n_seg_key_flexfields_pk
                primary key (flexfield_application_label,
                             id_flex_code,
                             structure_application_label)
                using index storage (initial 10K next 10K
                                     pctincrease 50)
        ) &TABLES_TABLESPACE
        storage (initial 10K next 10K pctincrease 50);
    
-- Creating the INCR table for IR Process


 
Create Table n_to_do_views_incr 
 (view_label varchar2(200),
 session_id number,
 creation_date date,
 last_update_date date);
 
--IR specific table
start wdrop table    &NOETIX_USER n_ir_view_gen_history
prompt table n_ir_view_gen_history
create table n_ir_view_gen_history(
        view_label varchar2(30), 
        view_name varchar2(30), 
        cust_action varchar2(30),
        created_by varchar2(30), 
        creation_date date, 
        last_updated_by varchar2(30), 
        last_update_date date);
-- Creating  table to use it in verflag.sql in Stage 4 and IR also
start wdrop table &NOETIX_USER n_customizations_gtemp
CREATE TABLE n_customizations_gtemp (
  Cust_RowId varchar2(200), view_label varchar2(200), Cust_Location varchar2(200), Cust_Action varchar2(200),creation_date date
) ;  
	--
-- This table is used to track the individual column properties for each
-- column.
-- prompt table N_VIEW_COL_PROPERTIES
-- create table n_view_col_properties
-- (column_property_id   INTEGER                            NOT NULL,
--  application_instance VARCHAR2(4),
--  view_name            VARCHAR2(30)                       NOT NULL,
--  view_label           VARCHAR2(30)                       NOT NULL,
--  query_position       NUMBER                             NOT NULL,
--  column_name          VARCHAR2(30)                       NOT NULL,
--  column_label         VARCHAR2(30)                       NOT NULL,
--  t_column_property_id INTEGER,
--  profile_option       VARCHAR2(30),
--  column_property_type VARCHAR2(30)                       NOT NULL,
--  value1               VARCHAR2(4000),
--  value2               VARCHAR2(4000),
--  value3               VARCHAR2(4000),
--  value4               VARCHAR2(4000),
--  value5               VARCHAR2(4000),
--  col_property_profile_option  VARCHAR2(30),
--  omit_flag            VARCHAR2(1),
--  constraint n_view_col_properties_pk
--             primary key (column_property_id)
--             using index storage (initial 10 k next 10 k pctincrease 50),
--  constraint n_view_col_properties_u1
--             unique (view_name,
--                     query_position, 
--                     column_name,
--             column_property_type,
--                     t_column_property_id,
--                     col_property_profile_option)
--             using index storage (initial 10 k next 10 k pctincrease 50)
-- ) &TABLES_TABLESPACE
-- storage (initial 10K next 10K pctincrease 50);   
-- --
-- prompt index n_view_col_properties_n1
-- create index n_view_col_properties_n1
-- on      n_view_col_properties(view_name, query_position, column_name, profile_option)
-- &TABLES_TABLESPACE
-- storage (initial 500K next 250k );
-- 
--
-- This table is used to track the individual column properties for each
-- column.

---------------------------------------------------------------------------------------------------
--
--  N_VIEW_PROPERTIES
--
---------------------------------------------------------------------------------------------------
--
-- Create new table N_VIEW_PROPERTIES.
-- N_VIEW_PROPERTIES : This table contains property information for views.
--      VIEW_PROPERTY_ID :          PK record for the N_VIEW_PROPERTIES table.
--      T_VIEW_PROPERTY_ID :        PK record for the N_VIEW_PROPERTY_TEMPLATES table.
--      VIEW_LABEL :                View label associated with the property.
--      VIEW_NAME :                 View name associated with the property.
--      QUERY_POSITION :            Query position.
--      PROPERTY_TYPE_ID :          Indicates the type of a given property.
--      T_SOURCE_PK_ID :            Record PK ID from the source table.  For example, if the source table is n_view_column_templates, then this would contain the T_COLUMN_ID id number.
--      SOURCE_PK_ID :              Record PK ID from the source non-templates table.  For example, if the source table is n_view_columns, then this would contain the COLUMN_ID id number.
--      VALUE1 :                    First property value.
--      VALUE2 :                    Second property value.
--      VALUE3 :                    Third property value.
--      VALUE4 :                    Fourth property value.
--      VALUE5 :                    Fifth property value.
--      PROFILE_OPTION :            Profile option associates with the current record.
--      CREATED_BY :                Who information indicates the person that created the current record.
--      CREATION_DATE :             Date the record was created.
--      LAST_UPDATED_BY :           Who information indicates the person that last updated the current record.
--      LAST_UPDATE_DATE :          Date the record was last updated.
prompt table N_VIEW_PROPERTIES
create table n_view_properties
     ( view_property_id     INTEGER                            NOT NULL,
       t_view_property_id   INTEGER                            NULL,
       view_label           VARCHAR2(30)                       NOT NULL,
       view_name            VARCHAR2(30)                       NOT NULL,
       query_position       NUMBER                             NULL,
       property_type_id     INTEGER                            NOT NULL,
       t_source_pk_id       INTEGER                            NULL,
       source_pk_id         INTEGER                            NOT NULL,
       value1               VARCHAR2(4000)                     NULL,
       value2               VARCHAR2(4000)                     NULL,
       value3               VARCHAR2(4000)                     NULL,
       value4               VARCHAR2(4000)                     NULL,
       value5               VARCHAR2(4000)                     NULL,
       profile_option       VARCHAR2(30)                       NULL,
       omit_flag            VARCHAR2(1)                        NULL,
       user_omit_flag       VARCHAR2(1)                        NULL,
       created_by           VARCHAR2(30) DEFAULT '&CREATED_BY' NOT NULL,
       creation_date        DATE         DEFAULT SYSDATE       NOT NULL,
       last_updated_by      VARCHAR2(30) DEFAULT '&CREATED_BY' NOT NULL,
       last_update_date     DATE         DEFAULT SYSDATE       NOT NULL,
       VERSION_ID           INTEGER                            NULL,
         constraint n_view_properties_pk
           primary key  ( view_property_id )
           using index storage (initial 50 k next 50 k pctincrease 50),
         constraint n_view_properties_c1
              check(omit_flag in ('Y','N')),
         constraint n_view_properties_c2
              check(user_omit_flag in ('Y','N')),
         constraint n_view_properties_fk1 
           foreign key  ( view_name, query_position ) 
           references n_view_queries
           on delete cascade,
         constraint n_view_properties_fk2
           foreign key (profile_option)
           references n_profile_option_templates,
         constraint n_view_properties_fk3 
           foreign key  ( property_type_id) 
           references n_property_type_templates
     ) &TABLES_TABLESPACE
     storage (initial 200K next 200K pctincrease 50);   

comment on table n_view_properties is
    'Defines the property types used for a given column.';

comment on column n_view_properties.view_property_id is
    'PK of the N_VIEW_PROPERTIES table.';
comment on column n_view_properties.t_view_property_id is
    'PK of the N_VIEW_PROPERTY_TEMPLATES table.';
comment on column n_view_properties.view_label is
    'View label associated with the property.';
comment on column n_view_properties.view_name is
    'View name associated with the property.';
comment on column n_view_properties.query_position is
    'Query position.';
comment on column n_view_properties.property_type_id is
    'Indicates the type of a given property.';
comment on column n_view_properties.t_source_pk_id is
    'Record PK ID from the source table.  For example, if the source table is n_view_column_templates, then this would contain the T_COLUMN_ID id number.';
comment on column n_view_properties.source_pk_id is
    'Record PK ID from the source non templates table.  For example, if the source table is n_view_columns, then this would contain the COLUMN_ID id number.';
comment on column n_view_properties.value1 is
    'First value.';
comment on column n_view_properties.value2 is
    'Second value.';
comment on column n_view_properties.value3 is
    'Third value.';
comment on column n_view_properties.value4 is
    'Fourth value.';
comment on column n_view_properties.value5 is
    'Fifth value.';

comment on column n_view_properties.profile_option is
    'Profile option associates with the current record.';
comment on column n_view_properties.omit_flag is
    'Value is set by evaluating the profile_option column.';
comment on column n_view_properties.user_omit_flag is
    'If OMIT_FLAG is "N", then use this column to determine if the user wants to suppress the given column.';
comment on column n_view_properties.created_by is
    'Who information indicates the person that created the current record.';
comment on column n_view_properties.creation_date is
    'Date the record was created.';
comment on column n_view_properties.last_updated_by is
    'Indicates who last updated the given record.';
comment on column n_view_properties.last_update_date is
    'Date the record was last updated.';
comment on column n_view_properties.version_id is
    'Version id that is associated with this record.';

prompt index n_view_properties_n1
create index n_view_properties_n1
   on n_view_properties (profile_option)
&TABLES_TABLESPACE   
storage (initial 50K next 50k ); 

prompt index n_view_properties_n2
create index n_view_properties_n2
   on n_view_properties (view_name, query_position)
&TABLES_TABLESPACE   
storage (initial 50K next 50k ); 

prompt index n_view_properties_n3
create index n_view_properties_n3
   on n_view_properties ( value1 )
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

prompt index n_view_properties_n4
create index n_view_properties_n4
   on n_view_properties ( value2 )
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

prompt index n_view_properties_n5
create index n_view_properties_n5
   on n_view_properties ( t_source_pk_id )
&TABLES_TABLESPACE   
storage (initial 50K next 50k ); 

prompt index n_view_properties_n6
create index n_view_properties_n6
   on n_view_properties ( property_type_id )
&TABLES_TABLESPACE   
storage (initial 50K next 50k ); 

prompt index n_view_properties_n7
create index n_view_properties_n7
   on n_view_properties ( source_pk_id )
&TABLES_TABLESPACE   
storage (initial 50K next 50k ); 


prompt view n_view_properties_v
CREATE or replace view n_view_properties_v as
SELECT vp.view_property_id,
       vp.t_view_property_id,
       vp.view_label,
       vp.query_position,
       vp.t_source_pk_id,
       vp.source_pk_id,
       vp.property_type_id,
       ptype.property_type,
       ptype.metadata_table_id,
       ptype.templates_table_name       templates_table_name,
       ptype.nontemplates_table_name    nontemplates_table_name,
       vp.value1,
       vp.value2,
       vp.value3,
       vp.value4,
       vp.value5,
       vp.profile_option,
       vp.omit_flag,
       vp.user_omit_flag,
       vp.created_by,
       vp.creation_date,
       vp.last_updated_by,
       vp.last_update_date,
       vp.version_id
  FROM n_view_properties              vp,
       n_property_type_templates      ptype
 WHERE ptype.property_type_id        = vp.property_type_id
;

---------------------------------------------------------------------------------------------------
--
--  N_JOIN_KEYS
--
---------------------------------------------------------------------------------------------------
--
-- N_JOIN_KEYS : This non-template table is used to maintain the joins between views.
--      JOIN_KEY_ID :               PK record for the N_JOIN_KEYS table.
--      T_JOIN_KEY_ID :             Templates join_key record.
--      VIEW_LABEL :                View label associated with the join.
------      APPLICATION_LABEL :         Application_Label of the view
------      APPLICATION_INSTANCE :      Application_Instance of the view
--      VIEW_NAME :                 View Name associated with the join.
--      KEY_NAME :                  Part of the unique key for the join.  Provides a name to give the join.
--      DESCRIPTION :               Description of the join record.
--      JOIN_KEY_CONTEXT_CODE :     Special processing code for defining joins.  Can be Null/NONE, KFF, DIM, or HIER.
--      KEY_TYPE_CODE :             Key type of the join.  Can be either PK or FK.
--      COLUMN_TYPE_CODE :          Column type of the join.  Can be either ROWID or COL.
--      OUTERJOIN_FLAG :            Indicates if the join is outer or not.  Can only be used for FK type joins.  NULL if PK.
--      OUTERJOIN_DIRECTION_CODE :  If OUTERJOIN_FLAG is Y, indicates the direction of the outerjoin (either on the PK or FK side).  NULL if OUTERJOIN FLAG is not Y.
--      KEY_RANK :                  If there are multiple keys, indicates which one should be displayed first.
--      PL_REF_PK_VIEW_NAME_MODIFIER:For FK records only.  Used in cases where there are multiple keys pointing to the same view label.  May not be the same key names on the target view.
--      PL_ROWID_COL_NAME_MODIFIER :For ROWID records only.  If specified used for creating the Z$ column.
--      KEY_CARDINALITY_CODE :      Specifies the cardinality of the key.  If "1" then that means the key is unique.  If "N" (Many) it indicates the key is not unique.
--      REFERENCED_PK_JOIN_KEY_ID : The referenced non-templates join key record.  For FK type records only. Indicates the PK join key to join to.
--      REFERENCED_PK_T_JOIN_KEY_ID:The referenced templates join key record.  For FK type records only. Indicates the PK join key to join to.
--      PROFILE_OPTION :            Profile option associates with the current record.
--      OMIT_FLAG                   Indicates if the record will be included in the non-templates version of the table.  Value is normally based on the product_version column.
--      USER_OMIT_FLAG              If set to 'Y', will be used to exclude a column that otherwise would have been included.  Ignored if OMIT_FLAG is 'Y' or NULL.
--      GENERATED_FLAG              Indicates if the record was generated by metabuild.
--
prompt table n_join_keys
CREATE TABLE n_join_keys
(   JOIN_KEY_ID                     INTEGER                       NOT NULL,
    T_JOIN_KEY_ID                   INTEGER                           NULL,
    VIEW_LABEL                      VARCHAR2(30)                      NULL,
    VIEW_NAME                       VARCHAR2(30)                  NOT NULL,
-----    APPLICATION_LABEL               VARCHAR2(10)                  NOT NULL,
-----    APPLICATION_INSTANCE            VARCHAR2(4)                   NOT NULL,
    KEY_NAME                        VARCHAR2(50)                  NOT NULL,
    DESCRIPTION                     VARCHAR2(4000)                    NULL,
    JOIN_KEY_CONTEXT_CODE           VARCHAR2(5)                       NULL
       CONSTRAINT n_join_keys_C1
            CHECK(JOIN_KEY_CONTEXT_CODE in ('NONE','KFF','DIM','HIER')),
    KEY_TYPE_CODE                   VARCHAR2(5)                   NOT NULL
       CONSTRAINT n_join_keys_C2
           CHECK(KEY_TYPE_CODE in ('FK','PK')),
    COLUMN_TYPE_CODE                VARCHAR2(5)                   NOT NULL
       CONSTRAINT n_join_keys_C3
            CHECK(COLUMN_TYPE_CODE in ('COL','ROWID')),
    OUTERJOIN_FLAG                  VARCHAR2(1)                       NULL,
    OUTERJOIN_DIRECTION_CODE        VARCHAR2(5)                       NULL,
    KEY_RANK                        INTEGER      DEFAULT 1        NOT NULL,
    PL_REF_PK_VIEW_NAME_MODIFIER    VARCHAR2(50)                      NULL,
    PL_ROWID_COL_NAME_MODIFIER      VARCHAR2(20)                      NULL,
    KEY_CARDINALITY_CODE            VARCHAR2(1)                       NULL,
    REFERENCED_PK_JOIN_KEY_ID       INTEGER                           NULL,
    REFERENCED_PK_T_JOIN_KEY_ID     INTEGER                           NULL,
    PROFILE_OPTION                  VARCHAR2(30)                      NULL,
    OMIT_FLAG                       VARCHAR2(1)                       NULL,
    USER_OMIT_FLAG                  VARCHAR2(1)                       NULL,
    generated_flag                  varchar2(1)                       NULL,
    constraint n_join_keys_PK
               primary key (JOIN_KEY_ID)
               using index storage (initial 200K next 200K pctincrease 0),
    constraint n_join_keys_U1
               unique (VIEW_NAME, KEY_NAME)
               using index storage (initial 200K next 200K pctincrease 0),
    constraint n_join_keys_FK1
               FOREIGN KEY (VIEW_NAME)
               REFERENCES N_VIEWS(VIEW_NAME)
               ON DELETE CASCADE,
    constraint n_join_keys_FK2
               FOREIGN KEY (REFERENCED_PK_JOIN_KEY_ID)
               REFERENCES n_join_keys(JOIN_KEY_ID)
               ON DELETE CASCADE,
    constraint n_join_keys_FK3
               FOREIGN KEY (PROFILE_OPTION)
               REFERENCES N_PROFILE_OPTION_TEMPLATES(PROFILE_OPTION),
    constraint n_join_keys_C4
               CHECK(    (     KEY_TYPE_CODE   = 'PK'
                           AND OUTERJOIN_FLAG  IS NULL
                           AND OUTERJOIN_DIRECTION_CODE IS NULL )
                      OR (     KEY_TYPE_CODE   = 'FK'
                           AND OUTERJOIN_FLAG  = 'Y'
                           AND OUTERJOIN_DIRECTION_CODE in ('PK','FK') )
                      OR (     KEY_TYPE_CODE   = 'FK'
                           AND OUTERJOIN_FLAG  = 'N'
                           AND OUTERJOIN_DIRECTION_CODE IS NULL )  ),
    constraint n_join_keys_C5
               CHECK( KEY_CARDINALITY_CODE IN ( '1','N' ) ),
    constraint n_join_keys_C6
               CHECK(     (     COLUMN_TYPE_CODE   = 'COL'
                            AND PL_ROWID_COL_NAME_MODIFIER IS NULL )
                      OR COLUMN_TYPE_CODE          = 'ROWID' ),
    constraint n_join_keys_C7
               CHECK(    (     KEY_TYPE_CODE      = 'PK'
                           AND PL_REF_PK_VIEW_NAME_MODIFIER IS NULL   )
                      OR (     KEY_TYPE_CODE      = 'FK'  ) ),
    constraint n_join_keys_C8
               CHECK(    (     KEY_TYPE_CODE      = 'PK'
                           AND REFERENCED_PK_JOIN_KEY_ID IS NULL   )
                      OR (     KEY_TYPE_CODE      = 'FK'
                           AND REFERENCED_PK_JOIN_KEY_ID IS NOT NULL ) )
     ) &TABLES_TABLESPACE 
     storage (initial 200K next 100K pctincrease 0);

prompt index n_join_keys_n1
create index n_join_keys_n1
   on n_join_keys(key_name)
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

prompt index n_join_keys_n2
create index n_join_keys_n2
   on n_join_keys(T_JOIN_KEY_ID)
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

prompt index n_join_keys_n3
create index n_join_keys_n3
   on n_join_keys(REFERENCED_PK_JOIN_KEY_ID)
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

prompt index n_join_keys_n4
create index n_join_keys_n4
   on n_join_keys(REFERENCED_PK_T_JOIN_KEY_ID)
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

prompt index n_join_keys_n9
create index n_join_keys_n9
   on n_join_keys(PROFILE_OPTION)
&TABLES_TABLESPACE   
storage (initial 100K next 100k ); 

comment on table n_join_keys is
    'This non-template table is used to maintain the joins between views.';

comment on column n_join_keys.JOIN_KEY_ID is
    'PK record for the N_JOIN_KEYS table.';
comment on column n_join_keys.T_JOIN_KEY_ID is
    'Templates join_key record.';
comment on column n_join_keys.VIEW_LABEL is
    'View label associated with the join.';
comment on column n_join_keys.VIEW_NAME is
    'View name associated with the join.';
-----comment on column n_join_keys.APPLICATION_LABEL is
-----    'Application label associated with the view used in the join.';
-----comment on column n_join_keys.APPLICATION_INSTANCE is
-----    'Application instance associated with the view used in the join.';
comment on column n_join_keys.KEY_NAME is
    'Part of the unique key for the join.  Provides a name to give the join.';
comment on column n_join_keys.DESCRIPTION is
    'Description of the join record.';
comment on column n_join_keys.JOIN_KEY_CONTEXT_CODE is
    'Special processing code for defining joins.  Can be Null/NONE, KFF, DIM, or HIER.';
comment on column n_join_keys.KEY_TYPE_CODE is
    'Key type of the join.  Can be either PK or FK.';
comment on column n_join_keys.COLUMN_TYPE_CODE is
    'Column type of the join.  Can be either ROWID or COL.';
comment on column n_join_keys.OUTERJOIN_FLAG is
    'Indicates if the join is outer or not.  Can only be used for FK type joins.  NULL if PK.';
comment on column n_join_keys.OUTERJOIN_DIRECTION_CODE is
    'If OUTERJOIN_FLAG is Y, indicates the direction of the outerjoin (either on the PK or FK side).  NULL if OUTERJOIN FLAG is not Y.';
comment on column n_join_keys.KEY_RANK is
    'If there are multiple keys, indicates which one should be displayed first.';
comment on column n_join_keys.PL_REF_PK_VIEW_NAME_MODIFIER is
    'For FK records only.  Used in cases where there are multiple keys pointing to the same view label.  May not be the same key names on the target view.';
comment on column n_join_keys.PL_ROWID_COL_NAME_MODIFIER is
    'For ROWID records only.  If specified used for creating the Z$ column.';
comment on column n_join_keys.KEY_CARDINALITY_CODE is
    'Indicates the cardinality of the key.  If "1", indicates the key is unique.  If "N" (Many), indicates the key is not unique.';
comment on column n_join_keys.REFERENCED_PK_JOIN_KEY_ID is
    'The Referenced join key record for non-templates.  For FK type records only. Indicates the PK join key to join to.';
comment on column n_join_keys.REFERENCED_PK_T_JOIN_KEY_ID is
    'The Referenced join key record for templates.  For FK type records only. Indicates the PK join key to join to.';

comment on column n_join_keys.omit_flag is
    'Indicates if the record will be included in the non-templates version of the table.  Value is normally based on the profile_option column.';
comment on column n_join_keys.user_omit_flag is
    'If set to "Y", will be used to exclude a column that otherwise would have been included.  Ignored if OMIT_FLAG is "N" or NULL.';


---------------------------------------------------------------------------------------------------
--
--  N_JOIN_KEY_COLUMNS
--
---------------------------------------------------------------------------------------------------
--
-- N_JOIN_KEY_COLUMNS : Defines the join columns for a given join key.
--      JOIN_KEY_COLUMN_ID :        PK record for the N_JOIN_KEY_COLUMNS table.
--      T_JOIN_KEY_COLUMN_ID :      Templates join key field.
--      JOIN_KEY_ID :               Defines the Join key that this column is directly related to for non-templates.
--      T_JOIN_KEY_ID :             Defines the Join key that this column is directly related to for templates.
--      COLUMN_POSITION :           Column position for the column.  Must be unique per JOIN_KEY_ID.
--      COLUMN_NAME :               Column_name for the given column record.
--      COLUMN_LABEL :              Column_label associated with the join key record.
--
prompt table n_join_key_columns
CREATE TABLE n_join_key_columns
(   JOIN_KEY_COLUMN_ID              INTEGER                       NOT NULL,
    T_JOIN_KEY_COLUMN_ID            INTEGER                           NULL,
    JOIN_KEY_ID                     INTEGER                       NOT NULL,
    T_JOIN_KEY_ID                   INTEGER                           NULL,
    COLUMN_POSITION                 INTEGER                       NOT NULL,
    COLUMN_NAME                     VARCHAR2(30)                  NOT NULL,
    COLUMN_LABEL                    VARCHAR2(30)                      NULL,
    constraint n_join_key_columns_PK
               primary key (JOIN_KEY_COLUMN_ID)
               using index storage (initial 100K next 100K pctincrease 0),
    constraint n_join_key_columns_U1
               unique (JOIN_KEY_ID,COLUMN_NAME)
               using index storage (initial 100K next 100K pctincrease 0),
    constraint n_join_key_columns_U2
               unique (JOIN_KEY_ID,COLUMN_POSITION)
               using index storage (initial 100K next 100K pctincrease 0),
    constraint n_join_key_columns_FK1
               FOREIGN KEY (JOIN_KEY_ID)
               REFERENCES N_JOIN_KEYS(JOIN_KEY_ID)
               ON DELETE CASCADE
     ) &TABLES_TABLESPACE 
     storage (initial 200K next 100K pctincrease 0);

-- Create the indexes for the Generator API views
create index n_join_key_columns_n1 
    on n_join_key_columns( column_label )
 &TABLES_TABLESPACE
storage (initial 100k  next 100k  pctincrease 0);


comment on table n_join_key_columns is
    'Defines the join columns for a given join key non-templates record.';

comment on column n_join_key_columns.JOIN_KEY_COLUMN_ID is
    'PK record for the N_JOIN_KEY_COLUMNS table.';
comment on column n_join_key_columns.T_JOIN_KEY_COLUMN_ID is
    'Templates join key field.';
comment on column n_join_key_columns.JOIN_KEY_ID is
    'Defines the Join key that this column is directly related to for non-templates.';
comment on column n_join_key_columns.T_JOIN_KEY_ID is
    'Defines the Join key that this column is directly related to for templates.';
comment on column n_join_key_columns.COLUMN_POSITION is
    'Column position for the column.  Must be unique per JOIN_KEY_ID.';
comment on column n_join_key_columns.COLUMN_NAME is
    'Column_name for the given join key column record.';
comment on column n_join_key_columns.COLUMN_NAME is
    'Column_label for the given join key column record.';

create or replace view n_join_key_columns_v AS
SELECT jc.join_key_column_id,
       jc.t_join_key_column_id,
       jc.join_key_id,
       jc.t_join_key_id,
       jc.column_position,
       jc.column_name,
       jc.column_label,
       j.view_label,
       j.view_name,
       j.key_name,
       j.description,
       j.join_key_context_code,
       j.key_type_code,
       j.column_type_code,
       j.outerjoin_flag,
       j.outerjoin_direction_code,
       j.key_rank,
       j.pl_ref_pk_view_name_modifier,
       j.pl_rowid_col_name_modifier,
       j.key_cardinality_code,
       j.referenced_pk_join_key_id,
       j.referenced_pk_t_join_key_id,
       pk.view_name           referenced_pk_view_name,
       pk.view_label          referenced_pk_view_label,
       pk.key_name            referenced_pk_key_name,
       pk.key_cardinality_code ref_pk_key_cardinality_code,
       j.profile_option,
       j.omit_flag,
       j.user_omit_flag,
       j.generated_flag
  FROM n_join_key_columns jc,
       n_join_keys        j,
       n_join_keys        pk
 WHERE jc.join_key_id       = j.join_key_id
   AND pk.join_key_id (+)   = j.referenced_pk_join_key_id;

--
---------------------------------------------------------------------------------------------------
-- Create new table N_PL_FOLDERS.
-- N_PL_FOLDER_TEMPLATES : Table of N_PL_FOLDERS
--  FOLDER_ID               : PK of the table
--  T_FOLDER_ID             : References the PK in the N_PL_FOLDER_TEMPLATES table.
--  APPLICATION_LABEL       : Application label associated with the role.
--  APPLICATION_INSTANCE    : Application instance associated with the role.
--  ROLE_LABEL              : Role associated with this Folder entry.  FOLDER_TYPE_CODE must be ROLE for this to be populated.
--  FOLDER_NAME             : Presentation layer folder name.  May contain special ampersand variables like COA_NAMECOA_NAME which will be expanded in pop_folders.
--  FOLDER_DESCRIPTION      : Description of the folder.  May contain special ampersand variables like COA_NAMECOA_NAME, which will be expanded in pop_folders.
--  PARENT_FOLDER_ID        : Parent folder that contains this folder record.  Can only be null if the FOLDER_TYPE_CODE = FSET.
--  PARENT_T_FOLDER_ID      : Parent folder (templates) that contains this folder record.  Can only be null if the FOLDER_TYPE_CODE = FSET.
--  SORT_ORDER              : Sort order of the folder within a given level.  Folders are sorted Alphabetically by folder name if the sort order number is the same within a level.
--  SEARCH_FOLDER_NAME      : Name used by Search.  May contain special ampersand variables like COA_NAME, which will be expanded in pop_folders.
--  INSTANCE_TYPE_CODE      : Specified the noetix instance type associated with this record.  Can be S, X, G, A (All or any instances).
--  KFF_ID_FLEX_CODE        : KFF Code.  Only DIM Columns can have this value set.
--  KFF_ID_FLEX_APPLICATION_ID : KFF application ID.  Only DIM columns can have this value set.
--  HIERARCHY_NAME          : Name of the hierarchy you are referencing.  Currently only Acct is supported.  ONLY DIM columns can have this value set.
--  STRUCTURE_ID            : Structure_ID associated with the record. Valid for DIM type objects.
--  STRUCTURE_NAME          : Structure_Name associated with the record.  Valid for DIM type object.
--  FOLDER_USAGE_CODE       : How the folder is used.  (ALL, ANS, VIEWS)
--  FOLDER_TYPE_CODE        : This indicates the type of the folder.  FG - Folder Group; FSET - Folder set; ROLE - ROLE; DIM - (Dimension either KFF or Hierarchy)  FSET is always the top level.  FG can contain ROLE, DIM, or FG records.  ROLE and DIM can't have subfolders.
--  ORG_TYPE_CODE           : Org level folder.  Specifies BG, COA, MORG, OU, INV, etc
--  DIM_TYPE_CODE           : Only Valid for DIM type columns.  Valid valids are HIER (Hierarchy Dimension), KFF_AS (KFF all Structure views), KFF_SS_ONE (Include only one KFF Single Structure),  or KFF_SS_ALL (include all single structures for the KFF in this folder)
--  DISPLAY_VIEWS_IN_PARENT_FLAG : Y OR N  If Y then the views in the role are merged into the parent folder.  Otherwise the folder is created and the views will be displayed in this folder.  Default should be N.  
--  ROLE_REQUIRED_IN_PARENT_CODE : Y, N, OR D  (GLOBAL ONLY) If Y then the role is required for the given parent.  If N, then the role is not required.  If D, then it is only required if the role is not used in any other global folder.
--  OMIT_FLAG               : Determine if the record is omitted.
--  USER_OMIT_FLAG          : Set by the user to omit the record.  
create table N_PL_FOLDERS 
    ( FOLDER_ID                     INTEGER                         not null,
      T_FOLDER_ID                   INTEGER                         null,
      APPLICATION_LABEL             VARCHAR2(10)                    null,
      APPLICATION_INSTANCE          VARCHAR2(4)                     null,
      ROLE_LABEL                    VARCHAR2(30)                    null,
      ROLE_NAME                     VARCHAR2(30)                    null,
      FOLDER_NAME                   VARCHAR2(255)                   not null,
      FOLDER_DESCRIPTION            VARCHAR2(255)                   null,
      PARENT_FOLDER_ID              INTEGER                         null,
      PARENT_T_FOLDER_ID            INTEGER                         null,
      SORT_ORDER                    NUMBER      default 1           not null,
      SEARCH_FOLDER_NAME            VARCHAR2(255)                   null,
      INSTANCE_TYPE_CODE            VARCHAR2(1)                     not null
        constraint N_PL_FOLDERS_CHK1 
        CHECK( INSTANCE_TYPE_CODE IN ( 'S', 'X', 'G', 'A' ) ), 
      KFF_ID_FLEX_CODE              VARCHAR2(4)                     null,
      KFF_ID_FLEX_APPLICATION_ID    INTEGER                         null,
      HIERARCHY_NAME                VARCHAR2(50)                    null,
      STRUCTURE_ID                  INTEGER                         null,
      STRUCTURE_NAME                VARCHAR2(100)                   null,
      STRUCTURE_ID2                 INTEGER                         null,
      STRUCTURE_NAME2               VARCHAR2(100)                   null,
      FOLDER_USAGE_CODE             VARCHAR2(10)                    not null
        constraint N_PL_FOLDERS_CHK2 
        check ( FOLDER_USAGE_CODE IN ('ALL', 'ANS', 'VIEWS') ),
      FOLDER_TYPE_CODE              VARCHAR2(10)                    not null
        constraint N_PL_FOLDERS_CHK3 
        check ( FOLDER_TYPE_CODE IN ('FSET','FG','ROLE','DIM')  ),
      ORG_TYPE_CODE                 VARCHAR(10)                     null
        constraint N_PL_FOLDERS_CHK4 
        check ( ORG_TYPE_CODE IN ('COA','SOB','OU','INV','MO','BG','LEG','OPM', 'STRUCT')  ),
      DIM_TYPE_CODE                 VARCHAR2(20)                    null
        constraint N_PL_FOLDERS_CHK10 
        check ( DIM_TYPE_CODE IN ('KFF_AS','KFF_SS_ONE','KFF_SS_ALL','HIER') ),
      DISPLAY_VIEWS_IN_PARENT_FLAG  VARCHAR2(1) default 'N'         not null
        constraint N_PL_FOLDERS_CHK5 
        check ( DISPLAY_VIEWS_IN_PARENT_FLAG IN ('Y','N') ),
      ROLE_REQUIRED_IN_PARENT_CODE  VARCHAR2(1)                     null
        constraint N_PL_FOLDERS_CHK17 
        check ( ROLE_REQUIRED_IN_PARENT_CODE IN ('Y','N','D') ),
      OMIT_FLAG                     VARCHAR2(1)                     null
        constraint N_PL_FOLDERS_CHK15 
        check ( OMIT_FLAG IN ('Y','N') ),
      USER_OMIT_FLAG                VARCHAR2(1)                     null
        constraint N_PL_FOLDERS_CHK16 
          check ( USER_OMIT_FLAG IN ('Y','N') ),
        constraint N_PL_FOLDERS_PK primary key (FOLDER_ID),
        constraint N_PL_FOLDERS_U1 unique (parent_folder_id, folder_name, role_name, instance_type_code, structure_id, structure_id2, kff_id_flex_code, kff_id_flex_application_id, hierarchy_name),
        constraint N_PL_FOLDERS_CHK6 
          check ( ( FOLDER_TYPE_CODE = 'FSET' AND PARENT_FOLDER_ID IS NULL ) OR (PARENT_FOLDER_ID IS NOT NULL) ),
        constraint N_PL_FOLDERS_CHK11 
          check ( (   (    FOLDER_TYPE_CODE = 'DIM'
                       AND (     (     DIM_TYPE_CODE    LIKE 'KFF%'
                                   AND KFF_ID_FLEX_CODE IS NOT NULL
                                   AND KFF_ID_FLEX_APPLICATION_ID IS NOT NULL )
                              OR (     DIM_TYPE_CODE    LIKE 'HIER'
                                   AND HIERARCHY_NAME   IS NOT NULL ) ) 
                       AND ROLE_NAME IS NULL              )
                   OR (     FOLDER_TYPE_CODE = 'ROLE'
                        AND ROLE_NAME        IS NOT NULL
                        AND KFF_ID_FLEX_CODE IS NULL
                        AND KFF_ID_FLEX_APPLICATION_ID IS NULL
                        AND HIERARCHY_NAME   IS NULL
                        AND DIM_TYPE_CODE    IS NULL     ) 
                   OR (     FOLDER_TYPE_CODE IN ( 'FG', 'FSET')
                        AND ROLE_NAME        IS NULL
                        AND KFF_ID_FLEX_CODE IS NULL
                        AND KFF_ID_FLEX_APPLICATION_ID IS NULL
                        AND HIERARCHY_NAME   IS NULL
                        AND DIM_TYPE_CODE    IS NULL     )  ) ),
        constraint N_PL_FOLDERS_CHK12 
          check (   (     FOLDER_TYPE_CODE in ( 'DIM','ROLE' )
                      AND DISPLAY_VIEWS_IN_PARENT_FLAG  IN ( 'Y', 'N' ) )
                  OR      DISPLAY_VIEWS_IN_PARENT_FLAG  = 'N'  ),
        constraint N_PL_FOLDERS_CHK18 
          check (   (     FOLDER_TYPE_CODE               = 'ROLE'
                      AND INSTANCE_TYPE_CODE             = 'G'
                      AND ROLE_REQUIRED_IN_PARENT_CODE  IN ( 'Y', 'N', 'D' ) )
                  OR      ROLE_REQUIRED_IN_PARENT_CODE  IS NULL  ),
        constraint N_PL_FOLDERS_FK1 foreign key ( PARENT_FOLDER_ID )
          references N_PL_FOLDERS(FOLDER_ID),
        constraint N_PL_FOLDERS_FK2 foreign key ( PARENT_T_FOLDER_ID )
          references N_PL_FOLDER_TEMPLATES(T_FOLDER_ID),
        constraint N_PL_FOLDERS_FK3 foreign key ( role_name )
          references N_ROLES(role_name),
        constraint N_PL_FOLDERS_FK4 foreign key ( role_label )
          references N_ROLE_TEMPLATES(role_label) )
    &TABLES_TABLESPACE  storage (initial 100K next 100K pctincrease 0);

comment on table N_PL_FOLDERS is
    'Defines the presentation layer folders.';

comment on column N_PL_FOLDERS.FOLDER_ID is
    'Folder PK record identifier.';
comment on column N_PL_FOLDERS.T_FOLDER_ID is
    'the PK in the N_PL_FOLDER_TEMPLATES table.';
comment on column N_PL_FOLDERS.APPLICATION_LABEL is
    'Application label associated with the role.';
comment on column N_PL_FOLDERS.APPLICATION_LABEL is
    'Application instance associated with the role.';
comment on column N_PL_FOLDERS.ROLE_LABEL is
    'Role associated with this Folder entry.  FOLDER_TYPE_CODE must be ROLE for this to be populated.';
comment on column N_PL_FOLDERS.FOLDER_NAME is
    'Presentation layer folder name.  May contain special ampersand variables like COA_NAME which will be expanded in pop_folders.';
comment on column N_PL_FOLDERS.FOLDER_DESCRIPTION is
    'Description of the folder.  May contain special ampersand variables like COA_NAME, which will be expanded in pop_folders.';
comment on column N_PL_FOLDERS.PARENT_FOLDER_ID is
    'Parent folder that contains this folder record.  Can only be null if the FOLDER_TYPE_CODE = FSET.';
comment on column N_PL_FOLDERS.PARENT_T_FOLDER_ID is
    'Parent folder (templates) that contains this folder record.  Can only be null if the FOLDER_TYPE_CODE = FSET.';
comment on column N_PL_FOLDERS.SORT_ORDER is
    'Sort order of the folder within a given level.  Folders are sorted Alphabetically by folder name if the sort order number is the same within a level.';
comment on column N_PL_FOLDERS.SEARCH_FOLDER_NAME is
    'Name used by Search.  May contain special ampersand variables like COA_NAME, which will be expanded in pop_folders.';
comment on column N_PL_FOLDERS.INSTANCE_TYPE_CODE is
    'Specified the noetix instance type associated with this record.  Can be S, X, G, A (All or any instances).';
comment on column N_PL_FOLDERS.KFF_ID_FLEX_CODE is
    'KFF Code.  Only DIM Columns can have this value set.';
comment on column N_PL_FOLDERS.KFF_ID_FLEX_APPLICATION_ID is
    'KFF application ID.  Only DIM columns can have this value set.';
comment on column N_PL_FOLDERS.HIERARCHY_NAME is
    'Name of the hierarchy you are referencing.  Currently only Acct is supported.  ONLY DIM columns can have this value set.';
comment on column N_PL_FOLDERS.STRUCTURE_ID is
    'Structure_ID associated with the record. Valid for DIM type objects.';
comment on column N_PL_FOLDERS.STRUCTURE_NAME is
    'Structure_Name associated with the record.  Valid for DIM type object.';
comment on column N_PL_FOLDERS.FOLDER_USAGE_CODE is
    'How the folder is used.  (ALL, ANS, VIEWS).';
comment on column N_PL_FOLDERS.FOLDER_TYPE_CODE is
    'This indicates the type of the folder.  FG - Folder Group; FSET - Folder set; ROLE - ROLE; DIM - (Dimension either KFF or Hierarchy)  FSET is always the top level.  FG can contain ROLE, DIM, or FG records.  ROLE and DIM can not have subfolders.';
comment on column N_PL_FOLDERS.ORG_TYPE_CODE is
    'Org level folder.  Specifies BG, COA, MORG, OU, INV, etc';
comment on column N_PL_FOLDERS.DIM_TYPE_CODE is
    'Only Valid for DIM type columns.  Valid valids are HIER (Hierarchy Dimension), KFF_AS (KFF all Structure views), KFF_SS_ONE (Include only one KFF Single Structure),  or KFF_SS_ALL (include all single structures for the KFF in this folder).';
comment on column N_PL_FOLDERS.DISPLAY_VIEWS_IN_PARENT_FLAG is
    'Y OR N  If Y then the views in the role are merged into the parent folder.  Otherwise the folder is created and the views will be displayed in this folder.  Default should be N.';
comment on column N_PL_FOLDERS.ROLE_REQUIRED_IN_PARENT_CODE  is
    'Y, N, or D.  Only valid for Global ROLE folder types.  If Y then the role is required to be in the parent folder if the role is generated.  If N, the parent folder will not be created if no required roles exist.  If D, the role is not require for this parent, but if no other folders with this role are detected, it will treat this as required.';
comment on column N_PL_FOLDERS.OMIT_FLAG is
    'Determine if the record is omitted.';
comment on column N_PL_FOLDERS.USER_OMIT_FLAG is
    'Set by the user to omit the record.';

-- Add the remaining keys, constraints and indexes for the table N_PL_FOLDERS.

create index N_PL_FOLDERS_N1 
          on N_PL_FOLDERS (T_FOLDER_ID ASC) 
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N2 
          on N_PL_FOLDERS (PARENT_FOLDER_ID ASC) 
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N3 
          on N_PL_FOLDERS (PARENT_T_FOLDER_ID ASC) 
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N4 
          on N_PL_FOLDERS (ROLE_NAME ASC) 
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N5 
          on N_PL_FOLDERS (ROLE_LABEL ASC) 
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N6 
          on N_PL_FOLDERS (APPLICATION_LABEL, APPLICATION_INSTANCE ASC)
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N7 
          on N_PL_FOLDERS (FOLDER_NAME ASC)
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 


create index N_PL_FOLDERS_N8 
          on N_PL_FOLDERS (HIERARCHY_NAME ASC)
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 


create index N_PL_FOLDERS_N9 
          on N_PL_FOLDERS (KFF_ID_FLEX_APPLICATION_ID ASC, KFF_ID_FLEX_CODE ASC)
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 

create index N_PL_FOLDERS_N10
          on N_PL_FOLDERS (STRUCTURE_ID ASC)
    &TABLES_TABLESPACE
  storage (initial 10K next 10K pctincrease 0); 


-- Create a view layer on top of the table
create or replace view n_pl_folders_v as
SELECT t.folder_id,
       t.t_folder_id,
       t.application_label,
       t.application_instance,
       t.role_name,
       t.role_label,
       t.folder_name,
       t.folder_description,
       t.parent_folder_id,
       t.parent_t_folder_id,
       p.application_label        parent_application_label,
       p.application_instance     parent_application_instance,
       p.role_name                parent_role_name,
       p.role_label               parent_role_label,
       p.folder_name              parent_folder_name,
       p.folder_description       parent_folder_description,
       p.parent_t_folder_id       parent_parent_t_folder_id,
       p.sort_order               parent_sort_order,
       p.search_folder_name       parent_search_folder_name,
       p.instance_type_code       parent_instance_type_code,
       p.kff_id_flex_code         parent_kff_id_flex_code,
       p.kff_id_flex_application_id  parent_kff_id_flex_appl_id,
       p.hierarchy_name           parent_hierarhcy_name,
       p.structure_id             parent_structure_id,
       p.structure_name           parent_structure_name,
       p.folder_usage_code        parent_folder_usage_code,
       p.folder_type_code         parent_folder_type_code,
       p.org_type_code            parent_org_type_code,
       p.dim_type_code            parent_dim_type_code,
       p.display_views_in_parent_flag  parent_disp_views_in_par_flag,
       t.sort_order,
       t.search_folder_name,
       t.instance_type_code,
       t.kff_id_flex_code,
       t.kff_id_flex_application_id,
       t.hierarchy_name,
       t.structure_id,
       t.structure_name,
       t.folder_usage_code,
       t.folder_type_code,
       t.org_type_code,
       t.dim_type_code,
       t.display_views_in_parent_flag,
       t.role_required_in_parent_code,
       t.omit_flag,
       t.user_omit_flag
  FROM n_pl_folders t,
       n_pl_folders p
 WHERE t.parent_folder_id = p.folder_id (+);

--
--
-- Create global seg tables
--
-- This table is used to maintain the flexfield information in global seg
Prompt Creating table N_F_KFF_Flexfields
CREATE TABLE N_F_KFF_Flexfields
    (
     ID_Flex_Application_ID       INTEGER  NOT NULL ,
     ID_Flex_Code                 VARCHAR2 (4)  NOT NULL ,
     Flexfield_Name               VARCHAR2 (30) ,
     Definition_Application_ID    INTEGER ,
     DC_Force_Drop_Flag           VARCHAR2(1) default 'Y' ,
     Definition_Appl_Table_Name   VARCHAR2(30) ,
     Install_Incr_Refresh_Flag    VARCHAR2(1) DEFAULT 'Y'  ,
     Enable_Incr_Refresh_Flag     VARCHAR2(1) DEFAULT 'N' ,
     KFF_Cols_In_Global_View_Flag VARCHAR2(1),
          CONSTRAINT n_f_kff_flexfields_pk
                PRIMARY KEY(ID_Flex_Application_ID,ID_Flex_Code)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

-- This table is used to maintain the flexfield source table information in global seg
prompt Creating table N_F_KFF_Flex_Sources
CREATE TABLE N_F_KFF_Flex_Sources
    (
     Data_Table_Key                 INTEGER      NOT NULL,
     ID_Flex_Application_ID         INTEGER      NOT NULL,
     ID_Flex_Code                   VARCHAR2(4)  NOT NULL,
     Source_Type                    VARCHAR2(10) NOT NULL,
     Pattern_Key                    VARCHAR2(30) ,
     Data_Application_ID            INTEGER      NOT NULL,
     Data_Application_Table_Name    VARCHAR2(30) NOT NULL,
     Data_Application_Table_Name_ev VARCHAR2(30),
     Target_Value_Object_Name       VARCHAR2(30),
     Target_Desc_Object_Name        VARCHAR2(30),
     Parents_Required_Flag          VARCHAR2(1),
     Descriptions_Required_Flag     VARCHAR2(1),
     KFF_View_Description           VARCHAR2(80),
     KFF_View_Essay                 VARCHAR2(4000),
     KFF_View_Keywords              VARCHAR2(200),
     CD_TABLE_NAME                  VARCHAR2(30),
     CDE_TABLE_NAME                 VARCHAR2(30),
     CDEH_TABLE_NAME                VARCHAR2(30),
     CD_TRIGGER_NAME                VARCHAR2(30),
     Zero_Latency                   VARCHAR2(1)     DEFAULT 'N',
     CONSTRAINT N_F_KFF_Flex_Src_PK
                PRIMARY KEY(Data_Table_Key)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50
                                                                        ),
     CONSTRAINT N_F_KFF_Flex_Src_U1
                UNIQUE(ID_Flex_Application_ID,ID_Flex_Code,Data_Application_ID,Data_Application_Table_Name,Pattern_Key)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50
                                                                        )
    ) &TABLES_TABLESPACE
        storage (initial 10K next 10K pctincrease 0);

-- This table is used to maintain the flexfield structure information in global seg
Prompt Creating table n_f_kff_structures
CREATE TABLE n_f_kff_structures
    (
     Data_Table_Key            INTEGER NOT NULL,
     ID_Flex_Num                    INTEGER        NOT NULL ,
     Structure_Name                 VARCHAR2 (30) ,
     Concatenated_Segment_Delimiter VARCHAR2 (10) ,
     Chart_of_Accounts_ID           INTEGER ,
     Master_Organization_ID         INTEGER,
          CONSTRAINT n_f_kff_structures_pk
                PRIMARY KEY(Data_Table_Key,id_flex_num)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

-- This table is used to maintain the flexfield segment information in global seg
Prompt Creating table n_f_kff_segments
CREATE TABLE n_f_kff_segments
    (
     Segment_ID             INTEGER         NOT NULL,
     Data_Table_Key            INTEGER NOT NULL,
     ID_Flex_Num             INTEGER         NOT NULL,
     Segment_Name         VARCHAR2 (30) ,
     Target_Column_Name         VARCHAR2 (30) ,
     Target_Desc_Column_Name     VARCHAR2 (30) ,
     Target_Column_Indexed_Flag     VARCHAR2 (1) ,
     Application_Column_Name     VARCHAR2 (4000) ,
     Segment_Order         INTEGER ,
     Flex_Value_Set_ID         INTEGER,
     Description_Source_Code     VARCHAR2 (20),
     User_Alternate_SQL_Flag     VARCHAR2 (1),
     Formatted_Segment_Name     VARCHAR2 (30),
          CONSTRAINT n_f_kff_segments_pk
                PRIMARY KEY(segment_id)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

-- This table is used to maintain the concatenated segment information for flexfield structures in global seg
Prompt Creating table n_f_kff_concatenations
CREATE TABLE n_f_kff_concatenations
    (
     Data_Table_Key            INTEGER NOT NULL,
     ID_Flex_Num                 INTEGER  NOT NULL ,
     Concatenation_Type         VARCHAR2 (30)  NOT NULL ,
     Target_Column_Name             VARCHAR2 (30) ,
     Formatted_Column_Name         VARCHAR2 (30) ,
     Source_Expression             VARCHAR2 (4000),
     Source_Table_Type             VARCHAR2 (30) ,
          CONSTRAINT n_f_kff_concat_pk
                PRIMARY KEY ( Data_Table_Key, id_flex_num, concatenation_type )
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
 ) &TABLES_TABLESPACE 
        storage (initial 10k  next 10k  pctincrease 0);

-- This table is used to maintain the datacache table program and job information in global seg
Prompt Creating table n_f_kff_flex_source_pgms
CREATE TABLE n_f_kff_flex_source_pgms
     ( program_id                   INTEGER      NOT NULL,
       data_table_key               INTEGER      NOT NULL,
       table_name                   VARCHAR2(30) NOT NULL,
       program_type                 VARCHAR2(20),
       program_name                 VARCHAR2(240),
       program_short_name           VARCHAR2(30),
       program_executable           VARCHAR2(61),
       request_set_short_name       VARCHAR2(100),
       last_refresh_date            DATE,
       --Remove below columns
       Scheduled_request_id         NUMBER,
       job                          VARCHAR2(30), -- can used for dbms job or dbms schedule
       data_app_table_record_count  NUMBER, -- Record count from data application table 
       dc_table_record_count        NUMBER, -- Record count from data cache table
CONSTRAINT N_F_KFF_Flex_Src_pgm_PK
                PRIMARY KEY(program_id)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50),
CONSTRAINT N_F_KFF_Flex_Src_pgm_U1
                UNIQUE(data_table_key,table_name,program_type)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50
                                                                        )                 
)  &TABLES_TABLESPACE 
        storage (initial 10k  next 10k  pctincrease 0);
--

CREATE TABLE n_f_kff_program_runs
     ( run_id                       INTEGER      NOT NULL,
       program_id                   INTEGER      NOT NULL,
       request_id                   NUMBER,
       refresh_from_date            DATE,
       refresh_to_date              DATE,
       source_table_count           NUMBER,  --this could be data application table count or CDE/CDEH table count
       records_processed            NUMBER,
       Refresh_Mode                 VARCHAR2(30),
       Status                       VARCHAR2(30)  NOT NULL, --Success, Error, Running
       Message                      VARCHAR2(2000),
       creation_date                DATE,
       last_update_date             DATE,
CONSTRAINT n_f_kff_program_runs_pk1
                PRIMARY KEY(run_id)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50),
  CONSTRAINT n_f_kff_program_runs_fk1
    FOREIGN KEY (program_id)
    REFERENCES  n_f_kff_flex_source_pgms (program_id)                
)  &TABLES_TABLESPACE 
        storage (initial 10k  next 10k  pctincrease 0);

--
-- Add constraints to tables
--
Prompt Altering table n_f_kff_flex_sources
ALTER TABLE n_f_kff_flex_sources
    ADD CONSTRAINT n_f_kff_flex_src_fk1 FOREIGN KEY
    (
     id_flex_application_id,
     id_flex_code
    )
    REFERENCES n_f_kff_flexfields
    (
     id_flex_application_id,
     id_flex_code
    )
    NOT DEFERRABLE;

Prompt Altering table n_f_kff_structures
ALTER TABLE n_f_kff_structures
    ADD CONSTRAINT n_f_kff_flex_struct_fk1 FOREIGN KEY
    (
    Data_Table_Key
    )
    REFERENCES n_f_kff_flex_sources
    (
    Data_Table_Key
    )
    NOT DEFERRABLE;

Prompt Altering table n_f_kff_segments
ALTER TABLE n_f_kff_segments
    ADD CONSTRAINT n_f_kff_seg_fk1 FOREIGN KEY
    (
    Data_Table_Key,
    ID_Flex_Num
    )
    REFERENCES n_f_kff_structures
    (
    Data_Table_Key,
    ID_Flex_Num
    )
    NOT DEFERRABLE;

-- This table is used to maintain the flexfield qualifer information in global seg
Prompt Creating table n_f_kff_qualifiers
CREATE TABLE n_f_kff_qualifiers
    (
     segment_id             INTEGER ,
     segment_attribute_type VARCHAR2 (30),
     segment_prompt         VARCHAR2 (30),
     CONSTRAINT n_f_kff_qualifiers_PK
                PRIMARY KEY(segment_id,
                    segment_attribute_type)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

Prompt Altering table n_f_kff_qualifiers
ALTER TABLE n_f_kff_qualifiers
    ADD CONSTRAINT n_f_kff_segment_qual_fk1 FOREIGN KEY
    (
     segment_id
    )
    REFERENCES n_f_kff_segments
    (
     segment_id
    )
    NOT DEFERRABLE;

-- This table is used to maintain the flexfield qualifer information in global seg
Prompt Creating table n_f_kff_structure_groups
CREATE TABLE n_f_kff_structure_groups
    (
     structure_group_id     INTEGER,
     data_table_key         INTEGER ,
     group_type             VARCHAR2(10),
     value_view_name         VARCHAR2 (30) ,
     description_view_name     VARCHAR2 (30) ,
          CONSTRAINT n_f_kff_structgrp_pk
                PRIMARY KEY (structure_group_id)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

Prompt Altering table n_f_kff_structure_groups
ALTER TABLE n_f_kff_structure_groups
    ADD CONSTRAINT n_f_kff_structure_groups_fk1 FOREIGN KEY
    (
     data_table_key
    )
    REFERENCES n_f_kff_flex_sources
    (
     data_table_key
    )
    NOT DEFERRABLE;

Prompt Creating table n_f_kff_unions
CREATE TABLE n_f_kff_unions
    (
     union_id     INTEGER NOT NULL,
     value_view_name         VARCHAR2 (30) ,
     description_view_name     VARCHAR2 (30) ,
          CONSTRAINT n_f_kff_union_pk
                PRIMARY KEY (union_id)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

Prompt Creating table n_f_kff_union_struct_groups
CREATE TABLE n_f_kff_union_struct_groups
    (
     union_struct_group_id     INTEGER NOT NULL,
     union_id             INTEGER NOT NULL,
     structure_group_id     INTEGER NOT NULL,
          CONSTRAINT n_f_kff_union_strgrp_U1
                UNIQUE (union_id,structure_group_id)
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

Prompt Altering table n_f_kff_union_struct_groups
ALTER TABLE n_f_kff_union_struct_groups
    ADD CONSTRAINT n_f_kff_union_strgrp_fk1 FOREIGN KEY
    (
    structure_group_id
    )
    REFERENCES n_f_kff_structure_groups
    (
    structure_group_id
    )
    NOT DEFERRABLE;

Prompt Altering table n_f_kff_union_struct_groups
ALTER TABLE n_f_kff_union_struct_groups
    ADD CONSTRAINT n_f_kff_union_strgrp_fk2 FOREIGN KEY
    (
    union_id
    )
    REFERENCES n_f_kff_unions
    (
    union_id
    )
    NOT DEFERRABLE;


Prompt creating table n_f_kff_struct_grp_flex_nums
CREATE TABLE n_f_kff_struct_grp_flex_nums
    (
     structure_group_id INTEGER,
     data_table_key     INTEGER ,
     id_flex_num         INTEGER  NOT NULL,
          CONSTRAINT n_f_kff_structgrpflexnums_pk
                PRIMARY KEY ( structure_group_id, data_table_key, id_flex_num )
                USING INDEX STORAGE (INITIAL 10 k NEXT 10 k PCTINCREASE 50)
    ) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

Prompt Altering table n_f_kff_struct_grp_flex_nums
ALTER TABLE n_f_kff_struct_grp_flex_nums
    ADD CONSTRAINT n_f_kff_structgrpflexnums_fk1 FOREIGN KEY
    (
    structure_group_id
    )
    REFERENCES n_f_kff_structure_groups
    (
    structure_group_id
    )
    NOT DEFERRABLE;

Prompt Altering table n_f_kff_struct_grp_flex_nums
ALTER TABLE n_f_kff_struct_grp_flex_nums
    ADD CONSTRAINT n_f_kff_structgrpflexnums_fk2 FOREIGN KEY
     (
     data_table_key,
    id_flex_num
    )
    REFERENCES n_f_kff_structures
    (
     data_table_key,
    id_flex_num
    )
    NOT DEFERRABLE;

Prompt Creating table N_KFF_Struct_Iden_Templates
CREATE TABLE N_KFF_Struct_Iden_Templates
(
  STRUCTURE_IDENFICIATION_ID      INTEGER       NOT NULL,
  ID_FLEX_APPLICATION_ID          INTEGER       NOT NULL,
  ID_FLEX_CODE                    VARCHAR2(4 BYTE) NOT NULL,
  DATA_APPLICATION_ID             INTEGER       NOT NULL,
  DATA_APPLICATION_TABLE_NAME     VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENTIFIER_APP_LABEL     VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENTIFIER_VIEW_LABEL    VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENTIFIER_COLUMN_LABEL  VARCHAR2(30 BYTE) NOT NULL,
  PRODUCT_VERSION                 VARCHAR2(15 BYTE),
  INCLUDE_FLAG                    VARCHAR2(1 BYTE),
  PROFILE_OPTION                  VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL1  VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENT_VIEW_COL_LABEL1    VARCHAR2(30 BYTE) NOT NULL,    
  DATA_APPLICATION_COLUMN_LABEL2  VARCHAR2(30 BYTE), 
  STRUCT_IDENT_VIEW_COL_LABEL2    VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL3  VARCHAR2(30 BYTE),     
  STRUCT_IDENT_VIEW_COL_LABEL3    VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL4  VARCHAR2(30 BYTE),     
  STRUCT_IDENT_VIEW_COL_LABEL4    VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL5  VARCHAR2(30 BYTE),     
  STRUCT_IDENT_VIEW_COL_LABEL5    VARCHAR2(30 BYTE),    
  CONSTRAINT n_kff_struct_iden_temp_pk
                PRIMARY KEY(STRUCTURE_IDENFICIATION_ID)  
) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);


Prompt Creating table N_KFF_Struct_Identifier  
CREATE TABLE N_KFF_Struct_Identifier
(
  STRUCTURE_IDENFICIATION_ID      INTEGER       NOT NULL,
  ID_FLEX_APPLICATION_ID          INTEGER       NOT NULL,
  ID_FLEX_CODE                    VARCHAR2(4 BYTE) NOT NULL,
  DATA_APPLICATION_ID             INTEGER       NOT NULL,
  DATA_APPLICATION_TABLE_NAME     VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENTIFIER_APP_LABEL     VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENTIFIER_VIEW_LABEL    VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENTIFIER_COLUMN_LABEL  VARCHAR2(30 BYTE) NOT NULL,
  PRODUCT_VERSION                 VARCHAR2(15 BYTE),
  INCLUDE_FLAG                    VARCHAR2(1 BYTE),
  PROFILE_OPTION                  VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL1  VARCHAR2(30 BYTE) NOT NULL,
  STRUCT_IDENT_VIEW_COL_LABEL1    VARCHAR2(30 BYTE) NOT NULL,    
  DATA_APPLICATION_COLUMN_LABEL2  VARCHAR2(30 BYTE), 
  STRUCT_IDENT_VIEW_COL_LABEL2    VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL3  VARCHAR2(30 BYTE),     
  STRUCT_IDENT_VIEW_COL_LABEL3    VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL4  VARCHAR2(30 BYTE),     
  STRUCT_IDENT_VIEW_COL_LABEL4    VARCHAR2(30 BYTE),
  DATA_APPLICATION_COLUMN_LABEL5  VARCHAR2(30 BYTE),     
  STRUCT_IDENT_VIEW_COL_LABEL5    VARCHAR2(30 BYTE),
    CONSTRAINT n_kff_struct_identifier_pk
                PRIMARY KEY(STRUCTURE_IDENFICIATION_ID)  
) &TABLES_TABLESPACE
        storage (initial 10k  next 10k  pctincrease 0);

--
-- Creating Temp Table for Noetix BOM Explosion Package
--
DECLARE
    cursor c_check_for_table( p_owner       varchar2,
                              p_table_name  varchar2 ) is
    select ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )       exists_flag
      from dual
     where p_owner            = user
       and exists
         ( select /*+ RULE */ 'Table Exists'
             from all_tables
            where owner       = p_owner
              and table_name  = p_table_name );
BEGIN

    for r1 in c_check_for_table( user,
                                 'N_TMP_BOM_EXPLOSION' ) LOOP
        if ( r1.exists_flag = 'N' ) THEN
            -- Create the table
            execute immediate
'CREATE GLOBAL TEMPORARY TABLE N_TMP_BOM_EXPLOSION
(
  TOP_BILL_SEQUENCE_ID           NUMBER         NOT NULL,
  BILL_SEQUENCE_ID               NUMBER         NOT NULL,
  ORGANIZATION_ID                NUMBER         NOT NULL,
  COMPONENT_SEQUENCE_ID          NUMBER,
  COMPONENT_ITEM_ID              NUMBER,
  PLAN_LEVEL                     NUMBER         NOT NULL,
  EXTENDED_QUANTITY              NUMBER         NOT NULL,
  SORT_ORDER                     VARCHAR2(2000 BYTE),
  REQUEST_ID                     NUMBER,
  PROGRAM_APPLICATION_ID         NUMBER,
  PROGRAM_ID                     NUMBER,
  PROGRAM_UPDATE_DATE            DATE,
  GROUP_ID                       NUMBER,
  SESSION_ID                     NUMBER,
  SELECT_FLAG                    VARCHAR2(1 BYTE),
  SELECT_QUANTITY                NUMBER,
  EXTEND_COST_FLAG               NUMBER,
  TOP_ALTERNATE_DESIGNATOR       VARCHAR2(10 BYTE),
  TOP_ITEM_ID                    NUMBER,
  CONTEXT                        VARCHAR2(30 BYTE),
  ATTRIBUTE1                     VARCHAR2(150 BYTE),
  ATTRIBUTE2                     VARCHAR2(150 BYTE),
  ATTRIBUTE3                     VARCHAR2(150 BYTE),
  ATTRIBUTE4                     VARCHAR2(150 BYTE),
  ATTRIBUTE5                     VARCHAR2(150 BYTE),
  ATTRIBUTE6                     VARCHAR2(150 BYTE),
  ATTRIBUTE7                     VARCHAR2(150 BYTE),
  ATTRIBUTE8                     VARCHAR2(150 BYTE),
  ATTRIBUTE9                     VARCHAR2(150 BYTE),
  ATTRIBUTE10                    VARCHAR2(150 BYTE),
  ATTRIBUTE11                    VARCHAR2(150 BYTE),
  ATTRIBUTE12                    VARCHAR2(150 BYTE),
  ATTRIBUTE13                    VARCHAR2(150 BYTE),
  ATTRIBUTE14                    VARCHAR2(150 BYTE),
  ATTRIBUTE15                    VARCHAR2(150 BYTE),
  HEADER_ID                      NUMBER,
  LINE_ID                        NUMBER,
  LIST_PRICE                     NUMBER,
  SELLING_PRICE                  NUMBER,
  COMPONENT_YIELD_FACTOR         NUMBER,
  ITEM_COST                      NUMBER,
  INCLUDE_IN_ROLLUP_FLAG         NUMBER,
  BASED_ON_ROLLUP_FLAG           NUMBER,
  ACTUAL_COST_TYPE_ID            NUMBER,
  COMPONENT_QUANTITY             NUMBER,
  SHRINKAGE_RATE                 NUMBER,
  SO_BASIS                       NUMBER,
  OPTIONAL                       NUMBER,
  MUTUALLY_EXCLUSIVE_OPTIONS     NUMBER,
  CHECK_ATP                      NUMBER,
  SHIPPING_ALLOWED               NUMBER,
  REQUIRED_TO_SHIP               NUMBER,
  REQUIRED_FOR_REVENUE           NUMBER,
  INCLUDE_ON_SHIP_DOCS           NUMBER,
  INCLUDE_ON_BILL_DOCS           NUMBER,
  LOW_QUANTITY                   NUMBER,
  HIGH_QUANTITY                  NUMBER,
  PICK_COMPONENTS                NUMBER,
  PRIMARY_UOM_CODE               VARCHAR2(3 BYTE),
  PRIMARY_UNIT_OF_MEASURE        VARCHAR2(25 BYTE),
  BASE_ITEM_ID                   NUMBER,
  ATP_COMPONENTS_FLAG            VARCHAR2(1 BYTE),
  ATP_FLAG                       VARCHAR2(1 BYTE),
  BOM_ITEM_TYPE                  NUMBER,
  PICK_COMPONENTS_FLAG           VARCHAR2(1 BYTE),
  REPLENISH_TO_ORDER_FLAG        VARCHAR2(1 BYTE),
  SHIPPABLE_ITEM_FLAG            VARCHAR2(1 BYTE),
  CUSTOMER_ORDER_FLAG            VARCHAR2(1 BYTE),
  INTERNAL_ORDER_FLAG            VARCHAR2(1 BYTE),
  CUSTOMER_ORDER_ENABLED_FLAG    VARCHAR2(1 BYTE),
  INTERNAL_ORDER_ENABLED_FLAG    VARCHAR2(1 BYTE),
  SO_TRANSACTIONS_FLAG           VARCHAR2(1 BYTE),
  MTL_TRANSACTIONS_ENABLED_FLAG  VARCHAR2(1 BYTE),
  STOCK_ENABLED_FLAG             VARCHAR2(1 BYTE),
  DESCRIPTION                    VARCHAR2(240 BYTE),
  ASSEMBLY_ITEM_ID               NUMBER,
  CONFIGURATOR_FLAG              VARCHAR2(1 BYTE),
  PRICE_LIST_ID                  NUMBER,
  ROUNDING_FACTOR                NUMBER,
  PRICING_CONTEXT                VARCHAR2(30 BYTE),
  PRICING_ATTRIBUTE1             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE2             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE3             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE4             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE5             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE6             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE7             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE8             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE9             VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE10            VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE11            VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE12            VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE13            VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE14            VARCHAR2(150 BYTE),
  PRICING_ATTRIBUTE15            VARCHAR2(150 BYTE),
  COMPONENT_CODE                 VARCHAR2(4000 BYTE),
  LOOP_FLAG                      NUMBER,
  INVENTORY_ASSET_FLAG           NUMBER,
  PLANNING_FACTOR                NUMBER,
  OPERATION_SEQ_NUM              NUMBER,
  PARENT_BOM_ITEM_TYPE           NUMBER,
  WIP_SUPPLY_TYPE                NUMBER,
  ITEM_NUM                       NUMBER,
  EFFECTIVITY_DATE               DATE,
  DISABLE_DATE                   DATE,
  IMPLEMENTATION_DATE            DATE,
  SUPPLY_SUBINVENTORY            VARCHAR2(10 BYTE),
  SUPPLY_LOCATOR_ID              NUMBER,
  COMPONENT_REMARKS              VARCHAR2(240 BYTE),
  CHANGE_NOTICE                  VARCHAR2(10 BYTE),
  OPERATION_LEAD_TIME_PERCENT    NUMBER,
  REXPLODE_FLAG                  NUMBER,
  COMMON_BILL_SEQUENCE_ID        NUMBER,
  OPERATION_OFFSET               NUMBER,
  CURRENT_REVISION               VARCHAR2(3 BYTE),
  LOCATOR                        VARCHAR2(40 BYTE),
  FROM_END_ITEM_UNIT_NUMBER      VARCHAR2(30 BYTE),
  TO_END_ITEM_UNIT_NUMBER        VARCHAR2(30 BYTE),
  BASIS_TYPE                     NUMBER
)
NOCACHE
';
        ELSE
            -- Do nothing for now.  IF we need to alter the table,
            -- that code would go here.
            null;
        END IF;
    END LOOP;

END;
/

--
-- Creating Temp Table for ACL xmap Tables that are candidates for SQF
--
DECLARE
    cursor c_check_for_table( p_owner       varchar2,
                              p_table_name  varchar2 ) is
    select ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )       exists_flag
      from dual
     where p_owner            = user
       and exists
         ( select /*+ RULE */ 'Table Exists'
             from all_tables
            where owner       = p_owner
              and table_name  = p_table_name );
BEGIN

    for r1 in c_check_for_table( user,
                                 'N_TMP_VIEWS_SQF' ) LOOP
        if ( r1.exists_flag = 'N' ) THEN
            -- Create the table
            execute immediate
'CREATE GLOBAL TEMPORARY TABLE N_TMP_VIEWS_SQF
(
  VIEW_NAME                      VARCHAR2(30)   NOT NULL,
  TABLE_NAME                     VARCHAR2(30)   NOT NULL,
  SQF_ALIAS                      VARCHAR2(30)   NOT NULL,
  FILTER                         VARCHAR2(4000),
  MATERIALIZE_HINT_FLAG          VARCHAR2(1)
)
ON COMMIT PRESERVE ROWS';
            execute immediate
'CREATE INDEX N_TMP_VIEWS_SQF_N1 ON N_TMP_VIEWS_SQF( view_name )';
            execute immediate
'CREATE INDEX N_TMP_VIEWS_SQF_N2 ON N_TMP_VIEWS_SQF( table_name )';

        ELSE
            -- Do nothing for now.  IF we need to alter the table,
            -- that code would go here.
            null;
        END IF;
    END LOOP;

END;
/

-- Create the indexes for the Generator API views
create index n_f_kff_flex_sources_n1 
    on n_f_kff_flex_sources( data_table_key, id_flex_code, id_flex_application_id )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_structure_groups_n1 
    on n_f_kff_structure_groups( structure_group_id, data_table_key )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_structure_groups_n2 
    on n_f_kff_structure_groups( description_view_name, data_table_key )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_structure_groups_n3 
    on n_f_kff_structure_groups( value_view_name, data_table_key )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_unions_n1 
    on n_f_kff_unions( union_id, value_view_name, description_view_name )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_unions_n2 
    on n_f_kff_unions( union_id, description_view_name )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_segments_n1 
    on n_f_kff_segments( data_table_key, id_flex_num )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

create index n_f_kff_structures_n1 
    on n_f_kff_structures( data_table_key )
 &TABLES_TABLESPACE
storage (initial 10k  next 10k  pctincrease 0);

--
-- Create all the necessary sequences
--
create sequence n_help_question_seq
start with 10000 increment by 1;

create sequence n_answer_seq
start with 10000 increment by 1;

create sequence n_ans_column_seq
start with 10000 increment by 1;

create sequence n_ans_param_seq
start with 10000 increment by 1;

create sequence n_ans_param_value_seq
start with 10000 increment by 1;

create sequence n_ans_column_total_seq
start with 10000 increment by 1;

create sequence n_installation_messages_seq
start with 1 increment by 1;

create sequence n_join_keys_seq
start with 1 increment by 1;

create sequence n_join_key_columns_seq
start with 1 increment by 1;

create sequence n_pl_folders_seq
start with 1 increment by 1;

create sequence n_view_columns_seq
start with 1 increment by 1;

create sequence n_view_properties_seq
start with 1 increment by 1;

Prompt Creating sequence n_sme_exp_imp_pgm_runs_s
CREATE SEQUENCE n_sme_exp_imp_pgm_runs_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20;

Prompt Creating sequence n_f_kff_flex_sources_s
CREATE SEQUENCE n_f_kff_flex_sources_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20;
        
        
Prompt Creating sequence n_f_kff_segments_s
CREATE SEQUENCE n_f_kff_segments_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20;        
  

Prompt Creating sequence n_f_kff_structure_group_s
CREATE SEQUENCE n_f_kff_structure_group_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20;

Prompt Creating sequence n_f_kff_union_s
CREATE SEQUENCE n_f_kff_union_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20;
  
Prompt Creating sequence n_f_kff_union_strgrp_s
CREATE SEQUENCE n_f_kff_union_strgrp_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  CACHE 20;
  

Prompt Creating sequence n_kff_struct_iden_templates_s
CREATE SEQUENCE n_kff_struct_iden_templates_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 99999
  NOCYCLE
  NOORDER
  CACHE 20;

--NV-335  
Prompt Creating sequence n_f_kff_program_runs_s
CREATE SEQUENCE n_f_kff_program_runs_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  NOORDER
  &l_n_kff_prgm_runs_s_nocache ; 

--- Create Triggers
create or replace trigger n_view_columns_bri 
before insert or update
on n_view_columns
for each row
begin
  IF ( :new.column_id is null ) then
    select n_view_columns_seq.NEXTVAL
      into :new.column_id 
      from dual;
  END IF;
end n_view_columns_bri;
/

create or replace trigger n_view_properties_bri 
before insert or update
on n_view_properties
for each row
begin
  IF ( :new.view_property_id is null ) then
    select n_view_properties_seq.NEXTVAL
      into :new.view_property_id 
      from dual;
  END IF;
end n_view_properties_bri;
/

create or replace trigger n_join_keys_bri 
before insert or update
on n_join_keys
for each row
begin
  IF ( :new.join_key_id is null ) then
    select n_join_keys_seq.NEXTVAL
      into :new.join_key_id 
      from dual;
  END IF;
end n_join_keys_bri;
/

create or replace trigger n_join_key_columns_bri 
before insert or update
on n_join_key_columns
for each row
begin
  IF ( :new.join_key_column_id is null ) then
    select n_join_key_columns_seq.NEXTVAL
      into :new.join_key_column_id 
      from dual;
  END IF;
end n_join_key_columns_bri;
/

create or replace trigger n_pl_folders_bri 
before insert or update
on n_pl_folders
for each row
begin
  IF ( :new.folder_id is null ) then
    select n_pl_folders_seq.NEXTVAL
      into :new.folder_id 
      from dual;
  END IF;
end n_pl_folders_bri;
/

-- Create temp tables for the installer
set serveroutput on size 1000000
declare
    cursor c_tab_exists ( p_table_name VARCHAR2 )is
    select p_table_name           table_name,
           ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )                exists_flag
      from all_tables at
     where at.owner      = user
       and at.table_name = upper(p_table_name)
       and rownum        = 1;

    cursor c_ind_exists ( p_index_name VARCHAR2 )is
    select p_index_name           index_name,
           ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )                exists_flag
      from all_indexes at
     where at.owner      = user
       and at.index_name = upper(p_index_name)
       and rownum        = 1;

    CURSOR c_check_for_column( p_owner       varchar2,
                               p_table_name  varchar2,
                               p_column_name varchar2,
                               p_data_length NUMBER  DEFAULT NULL ) is
    SELECT ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )       exists_flag
      FROM dual
     WHERE p_owner            = user
       AND EXISTS
         ( SELECT /*+ RULE */ 'Table Column Exists'
             FROM all_tab_columns atc
            WHERE atc.owner       = p_owner
              AND atc.table_name  = p_table_name
              AND atc.column_name = p_column_name
              AND 
                (    atc.data_length IS NULL
                  OR p_data_length   IS NULL
                  OR p_data_length    = atc.data_length )  );

begin

    for r_tab_exists in  c_tab_exists( 'N_TMP_ALL_TABLES_AND_VIEWS' ) LOOP
        if ( r_tab_exists.exists_flag = 'N' ) then 
            dbms_output.put_line( 'Creating temporary table N_TMP_ALL_TABLES_AND_VIEWS.' );
            execute immediate 'create global temporary table N_TMP_ALL_TABLES_AND_VIEWS '||
                                   '( owner       varchar2(30), '||
                                   '  object_name varchar2(30), '||
                                   '  object_type varchar2(30) ) '||
                                   'ON COMMIT PRESERVE ROWS ';
        end if;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_TABLES_AND_VIEWS' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create unique index N_TMP_ALL_TABLES_AND_VIEWS_U1 '||
                                          'on N_TMP_ALL_TABLES_AND_VIEWS( owner, object_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
    end loop;

    for r_tab_exists in  c_tab_exists( 'N_TMP_ALL_TAB_COLUMNS' ) LOOP
        if ( r_tab_exists.exists_flag = 'N' ) then 
            dbms_output.put_line( 'Creating temporary table N_TMP_ALL_TAB_COLUMNS.' );
            execute immediate 'create global temporary table N_TMP_ALL_TAB_COLUMNS '||
                                   '( owner       varchar2(30), '||
                                   '  table_name  varchar2(30), '||
                                   '  column_name varchar2(30), '||
                                   '  data_type   varchar2(200), '||
                                   '  nullable    varchar2(1), '||
                                   '  column_id   number, '||
                                   '  data_length number ) '||
                                   'ON COMMIT PRESERVE ROWS ';
        end if;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_TAB_COLUMNS_U1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create unique index N_TMP_ALL_TAB_COLUMNS_U1 '||
                                          'on N_TMP_ALL_TAB_COLUMNS( owner, table_name, column_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
    end loop;

    for r_tab_exists in  c_tab_exists( 'N_TMP_ALL_IND_COLUMNS' ) LOOP
        if ( r_tab_exists.exists_flag = 'N' ) then 
            dbms_output.put_line( 'Creating temporary table N_TMP_ALL_IND_COLUMNS.' );
            execute immediate 'create global temporary table N_TMP_ALL_IND_COLUMNS '||
                                   '( table_owner           varchar2(30), '||
                                   '  table_name            varchar2(30), '||
                                   '  column_name           varchar2(4000), '||
                                   '  column_position       varchar2(30), '||
                                   '  index_name            varchar2(30), '||
                                   '  index_owner           varchar2(30), '||
                                   '  view_table_name       varchar2(30), '||
                                   '  view_column_name      varchar2(4000)  ) '||
                                   'ON COMMIT PRESERVE ROWS ';
        ELSE
            FOR r_column_exists in c_check_for_column( USER,
                                                       'N_TMP_ALL_IND_COLUMNS',
                                                       'VIEW_TABLE_NAME' ) LOOP
                IF ( r_column_exists.exists_flag = 'N' ) THEN
                    dbms_output.put_line( 'Creating temporary table N_TMP_ALL_IND_COLUMNS.' );
                    execute immediate 'ALTER TABLE N_TMP_ALL_IND_COLUMNS '||
                                           ' ADD ( view_table_name     varchar2(30), '||
                                           '       view_column_name    varchar2(4000) ) ';
                END IF;
            END LOOP;
        end if;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_IND_COLUMNS_N1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_IND_COLUMNS_N1 '||
                                          'on N_TMP_ALL_IND_COLUMNS( table_owner, table_name, column_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_IND_COLUMNS_N2' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_IND_COLUMNS_N2 '||
                                          'on N_TMP_ALL_IND_COLUMNS( index_owner, index_name, column_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_IND_COLUMNS_N3' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_IND_COLUMNS_N3 '||
                                          'on N_TMP_ALL_IND_COLUMNS( table_owner, view_table_name, view_column_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
    end loop;

    for r_tab_exists in  c_tab_exists( 'N_TMP_ALL_INDEXES' ) LOOP
        if ( r_tab_exists.exists_flag = 'N' ) then 
            dbms_output.put_line( 'Creating temporary table N_TMP_ALL_INDEXES.' );
            execute immediate 'create global temporary table N_TMP_ALL_INDEXES '||
                                   '( table_owner     varchar2(30), '||
                                   '  table_name      varchar2(30), '||
                                   '  status          varchar2(30), '||
                                   '  uniqueness      varchar2(30), '||
                                   '  index_name      varchar2(30), '||
                                   '  owner           varchar2(30) ) '||
                                   'ON COMMIT PRESERVE ROWS ';
        end if;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_INDEXES_U1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create unique index N_TMP_ALL_INDEXES_U1 '||
                                          'on N_TMP_ALL_INDEXES( owner, index_name, uniqueness )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_INDEXES_N1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_INDEXES_N1 '||
                                          'on N_TMP_ALL_INDEXES( table_owner, table_name, uniqueness )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
    end loop;

    FOR r_tab_exists IN  c_tab_exists( 'N_TMP_TABLE_GRANTS' ) LOOP
        IF ( r_tab_exists.exists_flag = 'N' ) THEN 
            dbms_output.put_line( 'Creating temporary table N_TMP_TABLE_GRANTS.' );
            execute immediate 'create table N_TMP_TABLE_GRANTS '||
                                   '( session_id      NUMBER,       '||
                                   '  connect_owner   VARCHAR2(30), '||
                                   '  object_owner    VARCHAR2(30), '||
                                   '  object_name     VARCHAR2(30), '||
                                   '  ed_view_name    VARCHAR2(30), '||
                                   '  grant_command   VARCHAR2(30) ) ';
        ELSE
          -- TRUNCATE the table if it exists
          BEGIN
            execute immediate 'truncate table n_tmp_table_grants';
          EXCEPTION
            WHEN OTHERS THEN
                NULL;
          END; 
        END IF;
        FOR r_ind_exists IN  c_ind_exists( 'N_TMP_TABLE_GRANTS_N1' ) LOOP
            IF ( r_ind_exists.exists_flag = 'N' ) THEN
                begin
                    execute immediate 'create unique index N_TMP_TABLE_GRANTS_N1 '||
                                          'on N_TMP_ALL_INDEXES( object_owner, object_name )';
                EXCEPTION
                    WHEN OTHERS THEN
                        null;
                END;
            END IF;
        END LOOP;
        FOR r_ind_exists IN  c_ind_exists( 'N_TMP_TABLE_GRANTS_N2' ) LOOP
            IF ( r_ind_exists.exists_flag = 'N' ) THEN
                BEGIN
                    execute immediate 'create index N_TMP_TABLE_GRANTS_N2 '||
                                          'on N_TMP_ALL_INDEXES( table_owner, table_name, uniqueness )';
                EXCEPTION
                    when others then
                        null;
                END;
            END IF;
        END LOOP;
    END LOOP;

    for r_tab_exists in  c_tab_exists( 'N_TMP_ALL_EDITIONING_VIEWS' ) LOOP
        if ( r_tab_exists.exists_flag = 'N' ) then 
            dbms_output.put_line( 'Creating temporary table N_TMP_ALL_EDITIONING_VIEWS.' );
            execute immediate 'create global temporary table N_TMP_ALL_EDITIONING_VIEWS '||
                                   '( owner       varchar2(30), '||
                                   '  table_name  varchar2(30), '||
                                   '  view_name   varchar2(30) ) '||
                                   'ON COMMIT PRESERVE ROWS ';
        end if;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_EDITIONING_VIEWS_U1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create unique index N_TMP_ALL_EDITIONING_VIEWS_U1 '||
                                          'on N_TMP_ALL_EDITIONING_VIEWS( table_name, owner )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_EDITIONING_VIEWS_N1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_EDITIONING_VIEWS_N1 '||
                                          'on N_TMP_ALL_EDITIONING_VIEWS( view_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_EDITIONING_VIEWS_N2' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_EDITIONING_VIEWS_N2 '||
                                          'on N_TMP_ALL_EDITIONING_VIEWS( owner )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
    END LOOP;

    for r_tab_exists in  c_tab_exists( 'N_TMP_ALL_EDITIONING_VIEW_COLS' ) LOOP
        if ( r_tab_exists.exists_flag = 'N' ) then 
            dbms_output.put_line( 'Creating temporary table N_TMP_ALL_EDITIONING_VIEW_COLS.' );
            execute immediate 'create global temporary table N_TMP_ALL_EDITIONING_VIEW_COLS '||
                                   '( owner             varchar2(30), ' ||
                                   '  view_name         varchar2(30), ' ||
                                   '  view_column_id    NUMBER, '       ||
                                   '  view_column_name  varchar2(30), ' ||
                                   '  table_column_id   NUMBER, '       ||
                                   '  table_column_name varchar2(30) ) '||
                                   'ON COMMIT PRESERVE ROWS ';
        end if;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_ED_VIEW_COLS_U1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create unique index N_TMP_ALL_ED_VIEW_COLS_U1 '||
                                          'on N_TMP_ALL_EDITIONING_VIEW_COLS( view_name, view_column_name, owner )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_ED_VIEW_COLS_N1' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_ED_VIEW_COLS_N1 '||
                                          'on N_TMP_ALL_EDITIONING_VIEW_COLS( view_column_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_ED_VIEW_COLS_N2' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_ED_VIEW_COLS_N2 '||
                                          'on N_TMP_ALL_EDITIONING_VIEW_COLS( table_column_name )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
        for r_ind_exists in  c_ind_exists( 'N_TMP_ALL_ED_VIEW_COLS_N3' ) LOOP
            if ( r_ind_exists.exists_flag = 'N' ) then
                begin
                    execute immediate 'create index N_TMP_ALL_ED_VIEW_COLS_N3 '||
                                          'on N_TMP_ALL_EDITIONING_VIEW_COLS( owner )';
                exception
                    when others then
                        null;
                end;
            end if;
        END LOOP;
    END LOOP;

END;
/

--
-- Creating Temp Table for the Noetix jointo processing Package
--
DECLARE
    cursor c_check_for_table( p_owner       varchar2,
                              p_table_name  varchar2 ) is
    select ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )       exists_flag
      from dual
     where p_owner            = user
       and exists
         ( select /*+ RULE */ 'Table Exists'
             from all_tables
            where owner       = p_owner
              and table_name  = p_table_name );

    cursor c_ind_exists ( p_index_name VARCHAR2 )is
    select p_index_name           index_name,
           ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )                exists_flag
      from all_indexes at
     where at.owner      = user
       and at.index_name = upper(p_index_name)
       and rownum        = 1;

    CURSOR c_check_for_column( p_owner       varchar2,
                               p_table_name  varchar2,
                               p_column_name varchar2,
                               p_data_length NUMBER  DEFAULT NULL ) is
    SELECT ( case count(*)
               when 0 then 'N'
               else        'Y'
             end )       exists_flag
      FROM dual
     WHERE p_owner            = user
       AND EXISTS
         ( SELECT /*+ RULE */ 'Table Column Exists'
             FROM all_tab_columns atc
            WHERE atc.owner       = p_owner
              AND atc.table_name  = p_table_name
              AND atc.column_name = p_column_name
              AND 
                (    atc.data_length IS NULL
                  OR p_data_length   IS NULL
                  OR p_data_length    = atc.data_length )  );

BEGIN

    for r1 in c_check_for_table( user,
                                 'N_TMP_JK_BASEVIEW_TABLE' ) LOOP
        if ( r1.exists_flag = 'N' ) THEN
            -- Create the table
            execute immediate
'CREATE GLOBAL TEMPORARY TABLE N_TMP_JK_BASEVIEW_TABLE
( VIEW_NAME                      VARCHAR2(30),
  KEY_VIEW_NAME                  VARCHAR2(30),
  COLUMN_NAME                    VARCHAR2(30),
  OWNER_NAME                     VARCHAR2(30),
  TABLE_NAME                     VARCHAR2(30) )
ON COMMIT PRESERVE ROWS ';

        ELSE
            -- Do nothing for now.  IF we need to alter the table,
            -- that code would go here.
            null;
        END IF;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_BASEVIEW_TABLE_N1' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create index N_TMP_JK_BASEVIEW_TABLE_N1 '||
                                        'on N_TMP_JK_BASEVIEW_TABLE( view_name )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_BASEVIEW_TABLE_N2' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create index N_TMP_JK_BASEVIEW_TABLE_N2 '||
                                        'on N_TMP_JK_BASEVIEW_TABLE( key_view_name )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r1 in c_check_for_table( user,
                                 'N_TMP_JK_VIEW_COLUMNS' ) LOOP
        if ( r1.exists_flag = 'N' ) THEN
            -- Create the table
            execute immediate
'CREATE GLOBAL TEMPORARY TABLE N_TMP_JK_VIEW_COLUMNS
( VIEW_NAME                      VARCHAR2(30),
  VIEW_LABEL                     VARCHAR2(30),
  QUERY_POSITION                 NUMBER,
  COLUMN_NAME                    VARCHAR2(30),
  COLUMN_LABEL                   VARCHAR2(30),
  COLUMN_EXPRESSION              VARCHAR2(4000),
  TABLE_ALIAS                    VARCHAR2(30),
  COLUMN_ID                      INTEGER,
  T_COLUMN_ID                    INTEGER,
  COLUMN_TYPE                    VARCHAR2(20),
  KEY_VIEW_NAME                  VARCHAR2(30),
  KEY_VIEW_LABEL                 VARCHAR2(30),
  TABLE_APPLICATION_LABEL        VARCHAR2(30),
  OWNER_NAME                     VARCHAR2(30),
  TABLE_NAME                     VARCHAR2(30),
  SPECIAL_PROCESS_CODE           VARCHAR2(30),
  FIRST_ACTIVE_QUERY_POSITION    NUMBER,
  SORT_LAYER                     NUMBER,
  QUERY_GROUP_BY_FLAG            VARCHAR2(30)
   )
ON COMMIT PRESERVE ROWS ';

        ELSE
            -- TRUNCATE the table if it exists
            BEGIN
              EXECUTE IMMEDIATE 'truncate table n_tmp_jk_view_columns';
            EXCEPTION
              WHEN OTHERS THEN
                  NULL;
            END; 
            -- Remove the omit_flag column
            FOR r_column_exists in c_check_for_column( USER,
                                                       'N_TMP_JK_VIEW_COLUMNS',
                                                       'OMIT_FLAG' ) LOOP
                IF ( r_column_exists.exists_flag = 'Y' ) THEN
                    dbms_output.put_line( 'Removing the omit_flag column from the temporary table N_TMP_JK_VIEW_COLUMNS.' );
                    execute immediate 
'ALTER TABLE N_TMP_JK_VIEW_COLUMNS '||
' DROP ( OMIT_FLAG ) ';
                END IF;
            END LOOP;
            -- Add the new columns
            FOR r_column_exists in c_check_for_column( USER,
                                                       'N_TMP_JK_VIEW_COLUMNS',
                                                       'TABLE_APPLICATION_LABEL' ) LOOP
                IF ( r_column_exists.exists_flag = 'N' ) THEN
                    dbms_output.put_line( 'Updating temporary table N_TMP_JK_VIEW_COLUMNS.' );
                    execute immediate 
'ALTER TABLE N_TMP_JK_VIEW_COLUMNS '||
' ADD ( TABLE_APPLICATION_LABEL        VARCHAR2(30),
        OWNER_NAME                     VARCHAR2(30),
        TABLE_NAME                     VARCHAR2(30),
        SPECIAL_PROCESS_CODE           VARCHAR2(30),
        FIRST_ACTIVE_QUERY_POSITION    NUMBER,
        SORT_LAYER                     NUMBER,
        QUERY_GROUP_BY_FLAG            VARCHAR2(1) ) ';
                END IF;
            END LOOP;

        END IF;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_VIEW_COLUMNS_N1' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create index N_TMP_JK_VIEW_COLUMNS_N1 '||
                                        'on N_TMP_JK_VIEW_COLUMNS( view_name, query_position, column_name )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_VIEW_COLUMNS_N2' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create index N_TMP_JK_VIEW_COLUMNS_N2 '||
                                        'on N_TMP_JK_VIEW_COLUMNS( key_view_name )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_VIEW_COLUMNS_N3' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create index N_TMP_JK_VIEW_COLUMNS_N3 '||
                                        'on N_TMP_JK_VIEW_COLUMNS( column_id )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_VIEW_COLUMNS_N4' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create index N_TMP_JK_VIEW_COLUMNS_N4 '||
                                        'on N_TMP_JK_VIEW_COLUMNS( table_name )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r1 in c_check_for_table( user,
                                 'N_TMP_JK_BASEVIEW_GEN_COLS' ) LOOP
        if ( r1.exists_flag = 'N' ) THEN
            -- Create the table
            execute immediate
'CREATE GLOBAL TEMPORARY TABLE N_TMP_JK_BASEVIEW_GEN_COLS
( COLUMN_ID                      NUMBER,
  VIEW_NAME                      VARCHAR2(30),
  KEY_VIEW_NAME                  VARCHAR2(30),
  ROWID_COLUMN_NAME              VARCHAR2(30),
  GEN_COLUMN_NAME                VARCHAR2(30)  )
ON COMMIT PRESERVE ROWS ';

        ELSE
            -- Do Nothing
            NULL;
        END IF;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_BASEVIEW_GEN_COLS_U1' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create unique index N_TMP_JK_BASEVIEW_GEN_COLS_U1 '||
                                        'on N_TMP_JK_BASEVIEW_GEN_COLS( column_id )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

    for r_ind_exists in  c_ind_exists( 'N_TMP_JK_BASEVIEW_GEN_COLS_N1' ) LOOP
        if ( r_ind_exists.exists_flag = 'N' ) then
            begin
                execute immediate 'create unique index N_TMP_JK_BASEVIEW_GEN_COLS_N1 '||
                                        'on N_TMP_JK_BASEVIEW_GEN_COLS( view_name, key_view_name, rowid_column_name )';
            exception
                when others then
                    null;
            end;
        end if;
    END LOOP;

END;
/


--
-- End spooling of ycrtable.lst
@utlspoff
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--
-- Create the Security Manager Tables
start utlif ycr_sec_manager_tb -
    "'&DAT_TYPE' = 'Views'"
--
-- Create and populate the table containing the application org mappings table.
-- This is already part of the views ycr_sec_manager_tb.sql script so don't run this version
start utlif ycrxmap "'&DAT_TYPE' <> 'Views'"
-- Create the PeopleSoft tables.
start utlif ycrpst  "'&DAT_TYPE' = 'PS'"

-- Create the n_user_%_config tables if they don't already exist
start ycrucnfg

--
-- Create and populate the table containing the interface error messages
@ycrinter
--
-- Create and populate the noetix_calendar table
-- This table is only necessary for payroll (11.5+).  Since we don't know yet
-- if Payroll is loaded, then we'll create/load it regardless.
start ycrcal "&PRODUCT_VERSION >= 11.5"
--
-- Call the script to generate views that denormalized answer metadata's
-- non-template tables.
@ycravw

undefine created_by
undefine max_buffer

-- end ycrtable.sql
