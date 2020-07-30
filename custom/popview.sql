-- Title
--    popview.sql
-- Function
--    @(#) populate the view tables from the template tables.
-- Description
--    A view is generated from the tables by the genview.sql
--    program.  There are separate tables for the view,
--    view_query, view_tables, view_columns and view_wheres.
--
--    Each of these tables has a corresponding template.
--    The templates are generic. A particular installation
--    may have several copies of a particular application
--    running. For example, AP and AP_USA. For each template
--    there will be a separate view for each instance of the
--    application. To continue our example, the template
--    AP_INVOICES would have two views:
--              AP_INVOICES
--              AP1_INVOICES
--
--    Another reason there will be multiple views is if there
--    are multiple organizations in inventory. Each organization
--    will get their own set of the views.
--
--    This procedure populates the view tables by making as
--    as many copies of the view as there are rows in table
--    n_application_owners with the same application_label.
--
--    Columns may have a reference to another column. The template
--    tells the application label and this routine figures out which
--    oracle user owns the table of the referenced column.
--
--    In WHERE clauses and in the profile_select clauses, there can be
--    embedded subselects. The tables for these select statements are
--    identified by application like '&AP.' or '&PO.'.  This routine
--    substitutes in the owner of the table.
--    In addition, in the profile_select clauses, the string '$PROFILE$.'
--    identifies a profile option.  This program looks up profile options
--    and substitutes their values. It looks first at application level
--    profile options. If it doesn't find one, it then looks at
--    site level profile options.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   02-Jul-94 M Turner
--   12-Aug-94 M Turner   restricted queries with PRODUCT_VERSION
--                        modified procedure get_table_owner
--                        added substitution for application labels in
--                           WHERE clauses.
--                        use n...queries instead of n_views in SELECTS
--                        for n_..tables,columns and wheres
--   18-Aug-94 M Turner   added n_profile_options to routine and
--                        substitute for applications and profile options
--                        in them
--   06-Dec-94 D Cowles
--   10-Mar-95 M Turner   get prefix for roles + views from
--                        n_application_owners
--                        instead of creating it from application_instance.
--   13-Mar-95 M Turner   when populating views, do for all views which are in
--                        any role (instead of just those in base
--                        applications).
--   06-Apr-95 D Cowles   add whenever sqlerror commands before each sql stmt
--   10-May-95 D Cowles   replace fnd_product_dependencies with n_appl..._xref
--                        and add populate n_query_user_roles from tupdqryu.sql
--   23-Jun-95 M Turner   treat SEGP just like SEGD
--                        substitute for &CURRENCY_CODE, &CHART_OF_ACCOUNTS_ID
--                        copy special_process_code,security_code into n_views
--   10-Jul-95 M Turner   substitute for &CHART_OF_ACCOUNTS in profile_options
--   10-Jul-95 D Cowles   fix substitution of &CHART_OF_ACCOUNTS
--   15-Oct-95 D Cowles   allow for oserrors when executing tupdqryu
--   29-Nov-95 M Turner   when finding table owners, check role app also.
--   04-Jan-96 M Turner   populate the column n_view_tables.subquery_flag
--   18-Feb-96 D Cowles   add support for KEYD type of columns
--   27-Mar-96 M Turner   substitute for COST and MASTER ORG IDs
--                        do substitutes in columns as well as wheres
--   11-Apr-96 M Turner   fix bug. turn scanning back on.
--   26-Apr-96 R Bullin   Add QueryObject to list of coltypes to be "#"'ed.
--   31-Jul-96 M Turner   add to essay, role_views and update profile options
--                        for views with application_instance like "G%".
--                        (views of cross-inventory organizations).
--   18-Aug-96 D Cowles   add wnoetxug for customization of view names
--   10-Sep-96 D Cowles   make application instance a varchar2 in pl/sql
--   17-Sep-96 M Turner   modify pop of role_views, views for cross org
--   03-Oct-96 M Turner   install views whose application install status is 'S'
--   13-Dec-96 M Turner   morph table names if they are really base views.
--   16-Dec-96 M Turner   make views used as tables be owned by NOETIX_USER
--   03-Feb-97 M Turner   do not upper() views used as tables
--   17-Mar-97 D West     changed references from PRODUCT_VERSION to
--                        INCLUDE_FLAG
--   19-Mar-97 W Bonneau  fixed get_specific routine when $PROFILE option not
--                        found in FND table, default to null
--   01-Jul-97 W Bonneau  commented out update of key_view_name based on
--                        application instance
--   25-Aug-98 C Lee      changed many aspects of popview to handle the global
--                        views.  the main theme is that the existing code is
--                        changed to only deal with the non-global instances
--                        "not like 'GX%'" and then a second piece of code is
--                        added to process the globals
--   03-Sep-98 C Lee      changed how base view names are updated for
--                        performance reasons
--   15-Sep-98 D Glancy   Created new index to enhance performance.
--   01-Oct-98 D Glancy   Replace NOETIX_LANG meta-dat variable with the
--                        NOETIX_LANG SQLPLUS variable in the insert
--                        statement for n_view_wheres;
--   08-Apr-99 D Glancy   Merge X-Op code into baseline.
--   16-Apr-99 D Glancy   Fix missing parenthesis problem.
--   05-Jun-99 M potluri  modified to use the same Global Inv profile options
--                        for Cross-OP
--   14-Jun-99 D Glancy   Change XOP instance indicator from GX to X.
--   18-Jun-99 D Glancy   Added the &XOP_ORGID replace statement to
--                        the n_view_wheres.
--   09-Jul-99 H Schmed   Updated the section that adds extra text to xop
--                        views.  Removed the 'sort or display by ...'
--                        recommendation.  Fixed the update statements so
--                        that they don't run into the 2000 character limit.
--   18-Aug-99 S Varana   Updated the section that adds extra text to xop
--                        views.  Added a note for multiple calendars if
--                        detected.
--   30-Aug-99 R Kompella To support Custom role suppression scripts, roles
--                        are populated when install_status=I or xop_instance
--                        is not null.
--   20-Sep-99 R Lowe     Update copyright info.
--   21-Jan-00 H Schmed   To support the global inv views needing a sob
--                        configuration variable based on organization_id,
--                        added calls to popglinv.sql and a &GLOBAL_INV_SOB
--                        replace to the n_view_wheres insert statement.
--                        Updated the copyright year to 2000.
--   04-Apr-00 D Glancy   tupdqryu.sql has be split into two parts (tupdqu1.sql
--                        and tupdqu2.sql). tupdqu1.sql is called in
--                        xgenall.sql
--                        whereas tupdqu2.sql is called from popview.sql.
--                        tupdqu1.sql inserts the n_query_users records and
--                        tupdqu2.sql inserts the n_query_user_roles and
--                        n_user_security_roles records.
--   14-Apr-00 H Schmed   Updated the n_view_wheres insert statement to replace
--                        the &ORG_ID configuration variable. Also, added table
--                        aliases to the insert to help the formatting problem.
--   09-May-00 R Lowe     In the pl/sql routine at the end of this script, add
--                        a cursor for processing n_view_columns.  Process this
--                        similar to n_view_wheres, except make changes in
--                        column_expression instead of where_clause.  This will
--                        change &owner variables in column expressions.
--   13-Jun-00 R Lowe     Replace &LEGISLATIVE_CODE in insert statement for
--                        n_view_columns.ref_lookup_type.
--   14-Jun-00 R Lowe     When putting '!' in column_name in insert_statement
--                        for n_view_columns, use positions 1-29 of the
--                        column_label instead of positions 2-30.  Using 2-30
--                        caused duplicate column names.  This change was
--                        made to all column_types that used the '!' to be
--                        consistent.
--   19-Jun-00 R Lowe     Do not make column expression upper case in r3c loop.
--   20-Jul-00 R Kompella Removed the product_version variable declaration
--                        as it is not used anywhere in the code.
--   14-Nov-00 D Glancy   is_rule_based_hint package determines if the hint
--                        contains the text RULE but does not contain one of
--                        the other hints that would force COST base
--                        comparisons (CHOOSE, ALL_ROWS, FIRST_ROWS). Used
--                        mainly when replacing text in the n_view_wheres
--                        table.
--   08-Dec-00 R Lowe     In xop n_view_wheres insert, change join to be
--                        between v and q, not v and v for view_name.
--   11-Dec-00 D Glancy   Update Copyright info.
--   15-Dec-00 D Glancy   Is_rule_based_Hint function was not working correctly
--                        for versions prior to 11i.  Added code to always
--                        assume rule based for 9-11.4999.
--   30-Jan-01 R Lowe     Remove create, truncate and drop statements for
--                        n_popbase_temp.  The table will be used by popview
--                        and autojoip.sql, so it will be created before
--                        autojoip.sql runs, in ycrproc.sql, then it will be
--                        populated here in popview, and it will be dropped by
--                        autojoin.sql after autojoip.sql is finished with it.
--   28-Mar-01 R Lowe     Instantiate n_help_questions here.  When deleting
--                        unused profile options, also consider profile options
--                        used by the answer meta-data. Since answers are not
--                        yet instantiated, use the template versions of the
--                        answer tables when determining which profile options
--                        are used.
--   07-Apr-01 R Lowe     Fix columns in profile option query, change
--                        question_id to t_question_id from
--                        n_help_questions_templates; check
--                        views omit_flag when instantiating questions.
--   29-Jun-01 H Schmed   Updated comments regarding n_popbase_temp.
--   06-Jul-01 H Schmed   Made the inserts into n_role_views DISTINCT.
--                        This was necessary to handle the duplicate
--                        record issue created by IFIN.
--                        Modified the history so lines will not wrap.
--   06-Aug-01 H Schmed   Updated the n_role_views insert statement so
--                        that it no longer strips the 'G' from the
--                        application_instance for most cases. Since the
--                        global inventory role now xrefs to itself, we
--                        want the full instance number. Removed
--                        unnecessary code. (Issue 4439)
--                        Also, removed an outdated comment.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   03-Dec-01 H Schmed   Modified the base table section to enforce the
--                        "base view must be in same application" rule.
--                        If the rule is violated, the table name is
--                        populated with 'BASEVIEW ERROR%' and an error
--                        record is written to n_installation_messages.
--                        (Issue 4730)
--   15-Jan-02 D Glancy   The method used to implement Issue 4730 is not compatible
--                        with older versions of Oracle Server (7 and 8).  Altered
--                        statement by removing the NVL statement and modifying the
--                        select to return a value if the conditions are not met.
--                        This is done by adding a second select that returns the
--                        value formerly identified as the second parameter in the NVL.
--                        This value is only returned if a record is not returned in the
--                        first query.  (Issue 5560).
--   06-May-02 D Glancy   1. Convert length to lengthb.
--                        2. Convert substr to substrb.
--                        3. Convert instr  to instrb.
--                        4. Did not translate the substr to substrb in the case
--                        where we were replacing 1 character with possible
--                        multi-char.
--                             '#'||substr(column_name,2)
--                        (Issue #5447)
--   26-Aug-02 D Glancy   Added the gen_search_by_col_flag to the inserts into the
--                        n_view_tables table.  Support for new dumptodo.
--   24-Oct-02 H Schmed   Updated the first n_role_views insert statement to
--                        require the n_application_owners record have its
--                        role prefix populated. (Issue 8575)
--   25-Oct-02 D Glancy   Removed the second NOT NULL check implemented in the
--                        previous change.  Was not necessary. (Issue 8590)
--   05-Nov-02 D Glancy   Update the from clause in sub-queries, when a base
--                        view is used. Because the prefix is different, we
--                        must depend on the fact that the n_view_tables
--                        is populated with the proper base view name.
--   27-Nov-02 H Schmed   Updated the n_role insert statement so non-US
--                        legislative Payroll roles are not created.
--                        (Issue 8788)
--   30-Jan-03 D Glancy   1.  Remove the n_roles table from the join where we
--                        insert into n_views.  Was not necessary and was causing
--                        poor performance.
--                        2.  Dropped the fnd_profile_options views so I had to ensure
--                        that it was being handled by the synonym or directly accessing
--                        the real oracle table.
--                        3.  Add the call to the yconvqu.sql script.  This converts
--                        the user records in case they are from the older model.
--                        (Issue #9090,9225,7869,9254)
--   04-Feb-03 D Glancy   1.  Fixed some bugs in my changes from 30-Jan.
--                        (Issue #9090,9225,7869,9254)
--                        2.  Profile_options that were versioned properly
--                        are not handled correctly.  If a profile does not exist due
--                        to the version number, it should not be copied over to the
--                        non-templates table from the templates table.
--                        (Issue 9520).
--   28-Aug-03 D Glancy   1.  n_profile_options update will all happen together at the top
--                        of popview.sql.
--                        2.  Added code to handle duplicate view_label/query_position/table_alias
--                        records in n_view_table_templates.  Process profile on duplicates.
--                        If duplicates still exist after processing, then disable the table_alias via
--                        the include_flag and generate the error message.
--                        2.  Added code to handle duplicate view_label/query_position/column_label
--                        records in n_view_column_templates.  Process profile on duplicates.
--                        If duplicates still exist after processing, then disable the column_label via
--                        the include_flag and generate the error message.
--                        (Issue 11193).
--   08-Sep-03 D Glancy   1.  Removed the code that handles duplicate table alias names in
--                        n_view_table_templates.  The current n_view_table_templates structure does
--                        not support the possibility of duplicates.
--                        2.  Use the n_get_table_owner_popview procedure directly in the pl/sql blocks
--                        instead of calling it indirectly.
--                        (Issue 11193).
--   18-Sep-03 D Glancy   1.  Spooling to popview.lst was prematurely terminated because of the call to
--                        yconvqu.sql.  Restarted spooling to the popview2.lst file.
--                        2.  Moved yconvqu.sql
--                        (Issue 11193).
--   21-Oct-03 D Glancy   1.  Populate the new n_popbase_temp column view_name_upper column.
--                        2.  Reformated the insert statement into n_view_wheres.
--                        3.  Altered the foreign keys associated with n_profile_options prior to
--                        deleting records.  This greatly increases the performance of popview.
--                        (Issue 11513, 11514)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   25-Mar-04 D Glancy   Related fix to large installation support.
--                        Add support to use the new n_xop_mappings and n_application_owner_globals tables.
--                        If < 1000 orgs (by default), then use the n_application_owners/globals tables to
--                        generate the in-list.  If 1000 or greater, add a join to the n_xop_mappings table
--                        instead of using the in-list.  This affects n_profile_options, n_view_wheres, and
--                        n_view_columns.
--                        (Issue 10328,10843,11698)
--   10-Jun-04 D Glancy   Add support for new EIS functions used for
--                        Canadian Payroll. (Issue 12675)
--   08-Oct-04 D Glancy   The cursor that builds the XOP_ORGID variable information did not
--                        successfully create additional where clause lines.  It was failing because
--                        we were passing a null variable to the insert_view_where routine when it
--                        was expecting a where clause position from the first iteration of the inner loop.
--                        Specified the vn_where_clause_position variable which is correct.
--                        (Issue 13370)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   04-Nov-04 D Glancy   We are generating empty roles that should be suppressed.  The problems are:
--                        1.  When generating the non-templates role view list, we don't take into
--                        consideration the include_flag from the n_role_view_templates table.
--                        2.  If the role contains no views, then the corresponding role should not
--                        be included in n_roles.
--                        (Issue 13388 and 13373)
--   18-Feb-05 D Glancy   Relax the restriction in popview and autojoip to allow PA, PB, and PC to
--                        share base views.  Since the org detection is the same for all three, base views
--                        should be compatible.
--                        (Issue 13937)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   07-Dec-05 D Glancy   Add XOP support for GMS and IGW.
--                        (Issue 15417)
--   07-Dec-05 D Glancy   1.  Rename n_xop_mappings to be n_application_org_mappings.
--                        2.  Add steps for populating the G0 instances for each application that can
--                        use global.
--                        3.  Add the new application_instance variable for use in metadata.
--                        4.  NOTE:  TEMP change include to suppress seg columns for G0 instance.
--                        This is necessary due to lack of support in seg for global.
--                        (Issue 15240)
--   08-Mar-06 D Glancy   Remove the omit login for n_view_column_templates/
--                        n_view_columns. We're going to update the omit.sql
--                        routine to handle omitting the duplicate columns.
--                        (Issue 15936)
--   10-Jul-06 H Schmed   Updated the SQL that inserts the single role profile
--                        options into n_profile_options to exclude global.
--                        (Issue 16472)
--   26-Jul-06 H Schmed   Added an insert statement to populate n_seg_key_
--                        flexfields (used in global seg processing).
--                        Update n_view_templates by setting the include
--                        flag to 'N' if a SEGSTRUCT or SEGEXPR column is
--                        included. (Multnomah Issue 16499)
--                        Updated the key view label population to use the
--                        new n_view_table_key_views table. (Multnomah 16592)
--                        Added temporary code to handle &LEGISLATIVE_CODE and
--                        &BUSINESS_GROUP in the global profile options so
--                        they don't cause installation errors. This is not
--                        an accurate solution and needs to be updated.
--                        (Multnomah 16603)
--   17-Aug-06 P Vemuru   Added gen_search_by_col_flag,lov_view_label,lov_view_name,lov_column_label
--                        to the insert statements (Multnomah: Issue 14251)
--   10-Oct-06 D Glancy   Add support for the new opm organizations.
--                        (Issue 16810)
--   12-Oct-06 M Kaku     Populate the roles for AU legislation also
--   08-Jan-07 M Kaku     Populate the roles for UK legislation also (Issue 17005).
--   05-Jul-07 R Lowe     Add Support to handle NoetixViews for PeopleSoft.
--   24-Jan-07 D Glancy   Insert into n_roles was not properly validating if a standard view
--                        that was suppressed might be used in XOP for the UNION ALL method.
--                        This situation was causing the XOP views to generate improperly
--                        if the UNION ALL method required the suppressed standard view.
--                        (Issue 16949).
--   12-Mar-07 D Glancy   COA, Business_group_id, and Legislation_code translations were missing for 
--                        the profile options.  Updated so that we can use these variable properly.
--                        (Issue 16472)
--   14-Mar-07 D Glancy   Add support for 'CS' module.
--                        (Issue 16803)
--   13-Apr-07 D Glancy   Add support for 'CSD' module.
--                        (Issue 16803)
--   07-May-07 D Glancy   Add support for 'CSF' and 'CSI' module.
--                        (Issue 17582)
--   02-Jul-07 D Glancy   Add support for 'EAM' module.
--                        (Issue 17727)
--   28-Sep-07 D Glancy   Add Support for the fact that LEDGER_NAME/_ID has 
--                        replaced SET_OF_BOOKS_NAME/_ID.
--                        (Issue 18282)
--   23-Oct-07 D Glancy   Add support for 'PJM' and 'MSC'.
--                        (Issue 18001)
--   07-Dec-07 P Vemuru   Added source_instance_id as part of insert statement of table N_APPLICATION_ORG_MAPPINGS 
--                        (Issue 5357)
--   07-Feb-08 D Glancy   Add sort_layer to the insert into n_views.
--                        (Issue 17110)
--   02-Jun-08 D Glancy   Performance tuning update.
--                        (Issue 19953)
--   02-Jun-08 D Glancy   Populate n_tmp_all_%_columns tables.  Used for performance in later modules.
--                        (Issue 19953 and 19806)
--   18-Jul-08 D Glancy   Ensure that pay is limited to the legislations we support.
--                        (Issue 20358)
--   26-Aug-08 D Glancy   Add support for QA and FV.
--                        (Issue 20395, 20398, and 20564)
--   23-Sep-08 D Glancy   Ensure the n_tmp_all_indexes table is populated.
--                        (Issue 14534)
--   26-Sep-08 D Glancy   Use the omit_flag in the n_roles table to aid in suppression.
--                        Also take into account the value of the use_org_in_xop_flag flag.
--                        (Issue 20809)
--   01-Oct-08 M Pothuri  Add support for the qualifier columns used by FV.
--   01-Oct-08 D Glancy   Add legislation_name to the xmap view.
--   22-Oct-08 D Glancy   Per Heidi's suggestion, populate n_tmp_all_indexes table first.  Then populate
--                        n_tmp_all_ind_columns based on the n_tmp_all_indexes table.
--                        (Issue 14534)
--   09-Feb-09 D Glancy   When populating n_popbase_temp, ensure that the XXNAO application prefix does not change.
--                        (Issue 21378)
--   14-Feb-09 R Raghudev When populating n_popbase_temp, ensure that the XXKFF application prefix does not change.
--                        Added rows into n_view_col_properties from template table.
--                        (Issue 21542) 
--   23-Feb-09 D Glancy   Need to check for BASEVIEW% now as SEG will add another baseview type.
--                        (Issue 21542)
--   24-Feb-09 K Challaga Added anonymous block for substituting segment column variables 
--                        for FV global version views, modifications can be identified by 'FEDERAL_GLOBAL'
--                        (Issue 21444)
--   10-Mar-09 D Glancy   For fnd_segment_attribute_values table references, remove the APPLSYS_USERID prefix as it was 
--                        causing PLS errors.  The prefix was not necessary anyway as we already have a synonym defined
--                        for this table.
--   11-Mar-09 D Glancy   To fix problems where we suppress all standard roles, I've fixed the routine whereby we populate
--                        the standard routines into n_role_views.  The updated logic will bring in every view within a 
--                        query if the use_org_in_xop_flag associated with the role 'Y' if the role application label = the 
--                        view application label.  
--                        If the role application does not match the view application label (and the role use_org_in_xop_flag is 'Y'), 
--                        then the baseviews and query objects will always come in.  All other view types will be included only if the 
--                        use_org_in_xop_flag associated with the view application is 'Y'.
--                        (Issue 21684)
--   16-Mar-09 R Raghudev Added the t_column_property_id to the insert statement for n_view_column_properties table.
--                        (Issue 21741).
--   24-Apr-09 S Vital    Modified insert logic for n_view_col_properties to restrict for limited column_type (SEG, KEY related).
--                        (Issue 21831).
--   28-Apr-09 S Vital    Modified insert logic for n_view_columns to prefix the column names with ^ for ATTR,ATTRD column types .
--                        (Issue 21831).
--   11-May-09 D Glancy   When populating the n_tmp_all% tables, we need another helper table (n_tmp_all_tables_and_views)
--                        to speed this process up.  We will not popluate view related tables at this time
--                        because we don't need to reference them yet.
--                        (Issue 21857)
--   04-Jun-09 D Glancy   Added start to the wdrop command at the end of the script.
--                        (Issue 22094)
--   28-Jul-09 D Glancy   Run the populate_module_list routine to ensure the n_sm_modules is populated
--                        prior to profile option processing.
--                        (Issue 21378)
--   11-Aug-09 S Vital    Allow instantiation of column properties for all the column types.
--   29-Aug-09 D Glancy   Add performance improvements.
--                        Now use the APPEND hint to INSERT data, PL/SQL table technique, and added some indexes on the
--                        profile_option columns in the n_view_% tables.
--                        (Issue 22586)
--   22-Sep-09 G Sriram   Listed the columns in the n_installation_messages insert statement.
--   06-Oct-09 C Kranthi  Limited the n_view_col_properties instantiation to global role only.
--   20-Oct-09 D Glancy   The get_hash_value function call did not have a large enough set of values and
--                        was returning duplicates for the PN and WMS application.  Increasing the size of the
--                        cache fixes the issue.
--                        (Issue 22817)
--   23-Oct-09 D Glancy   Correct error in logic for bulk collect when used with limit.
--                        Loop exit condition was not valid and could cause some records not to be processed.
--                        (Issue 22842)
--   23-Oct-09 G Sriram   Modified the insert statement for n_view_columns so that the first character of KEY, KEYD, KEYCAT columns
--                        will not be replaced with '#' symbol. (Issue 22822)
--   28-Oct-09 G Sriram   Modified the insert statement for n_view_columns so that the first character of AUTOJOIN, QUERYOBJECT columns
--                        will not be replaced with '#' symbol. (Issue 22822)
--   10-Nov-09 D Glancy   Added the code for population of cost_organization_name 
--                        in n_application_owners.
--                        (Issue 22909)
--   02-Dec-09 C Kranthi  The column properties insert modified to include XOP records having AUTOJOIN_ASSITANT property type.
--                        (Issue 23115)
--   15-Jan-10 D Glancy   Prevent PB and PC from generating global roles even though the global allowed flag is set to Y for these modules.
--                        Paul does not want to support the global version of the roles associated with these prefixes.
--                        (Issue 23230)
--   02-Feb-10 D Glancy   Use uppercase for all pl/sql array functions as a standard.
--   21-Apr-10 D Glancy   Validate that the role_enabled_flag column in n_application_owners is set to Y
--                        before adding to n_roles.
--                        (Issue 23684)
--   13-Oct-10 D Glancy   Missing additional essay text for global roles indicating information is selected
--                        across multiple organizations and if necessary add the multi calendar/currency NOTE.
--                        (Issue 26419)
--   30-Jan-11 Hatakesh   Modification related to T_Column_ID implementations.
--                        (Issue 25640)
--   08-FEB-11 Hatakesh   Modification related to using N_VIEW_PROPERTIES instead od n_view_col_properties.
--                        (Issue 25640)
--   07-Apr-11 HChodavarapu  Add support for 'OKE'
--   01-Mar-11 V Krishna  Added the update statement to populate the legal_entity into n_application_org_mappings.
--                        (Issue 20034)
--   22-Mar-11 D Glancy   On insert into n_View_columns, add the templates info for format_class and format_mask.
--                        (Issue 26059)
--   25-Mar-11 V krishna  Modified the Legal_Entity column as Legal_Entity_Name in the update statement.
--                        (Issue #20034)
--    7-Apr-11 P Upendra  Added new condition to filter out unneccessary column property records during population of n_view_col_properties table.
--                        This change is actually not necessary with the column_id model, so it was not implemented.
--   22-Jun-11 D Glancy   Treat XXHIE as global like XXKFF.
--   14-Aug-12 D Glancy   Add support for the new n_join_key% tables.  
--                        This is the new join key model that replaces n_view_join_relationships.
--                        (Issue 28846)
--   07-Nov-12 D Glancy   Problem with routine that inserts into the new n_join_key% tables.  
--                        Was causing insert error where a null column was being insert incorrectly.
--                        (Issue 28846)
--   25-Feb-13 D Glancy   Use the dbms_stats.auto_sample_size option instead of a fixed 25 percent.
--   10-Apr-13 D Glancy   tupdqu2 is not obsolete as the security information is being retained as part of the regen.
--                        (Issue 31869).
--   22-May-13  D Glancy  Join key model has changed to support cardinality.
--                        (Issue 32031)
--   06-Sep-13  D Glancy  SUBLEDGER_ACCOUNTING role should not be installed for standard and XOP.
--                        (Issue 33326)
--   25-Sep-13  D Glancy  As a safety measure, enclose the security manager call with an exception block.
--                        (Issue 33421)
--   01-Oct-13 D Glancy   Problem with running yconvqu.sql.  Using correct variable now so that it runs if necessary.
--                        Add dbms_session.reset_package so that package state is reset.
--                        (Issue 29644)
--   27-Sep-13 D Glancy   EBS 12.2 Support.
--                        For insert into n_tmp_all_ind_columns, do not include any ZD_EDITION_NAME columns as it interfers with 
--                        autojoin.
--                        (Issue 33617)
--   18-Dec-13 D Glancy   EBS 12.2 Support.
--                        Addressed replacement variables for 12.2 and above.
--                        Fixed issue where yconvqu.sql was not running.
--   08-Jan-14  D Glancy  Updated how we look for index columns.  Need to translate the metadata column name to the column name in the 
--                        physical index.
--                        (Issue 33617)
--   17-Jan-14  D Glancy  Fixed problems with the new regular expression method for updating "&" variables.  Was getting in infinite loop on standard/xop.
--                        (Issue 33617)
--   28-Jan-14  D Glancy  New regular expression logic was not working for 12.1/11.5 ebs.  Fixed.
--                        (Issue 33617)
--   13-Mar-14  D Glancy  For join key tables, we were checking the user_include_flag column and not the include_flag column.  This was causing warning messages in the 
--                        join processing.
--                        (Issue 34171)
--   18-Nov-14 D Glancy   Found cases where the when others is actually a sqlcode 0 (normal completion) on bulk operations in certain database clients.
--                        Updated to bypass any errors like this.
--                        (NV-421)
--   26-Aug-15 S Lakshmi  Added group by clause while inserting into n_tmp_all_editioning_views to avoid unique constraint error in cases where 
--                        more than one schema grants select to the same object to Noetix Sys Schema
--                        (NV-314)
-- Ensure that we have a properly updated GL Security Model
--

set define   &

set termout  &LEVEL2
set feedback on
set echo     off
set verify   off

@utlprmpt "Gather statistics on the template tables."

set termout &LEVEL2
set serveroutput on size &MAX_SERVEROUTPUT_SIZE
set timing       on
whenever sqlerror continue
-- Spool to an output file
@utlspon popview1_stats
-- Gather the statistics for the templates objects
DECLARE
  CURSOR c1 IS
    SELECT table_name
      FROM user_tables
     WHERE 
         (    table_name like '%TEMPLATES' 
           or table_name like 'N_APPLICATION%'
           or table_name like 'N_USER_%_CONFIG'
           or table_name like 'NOETIX_CALENDAR' )
     ORDER BY 1;
BEGIN
  IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN 
      dbms_output.enable(NULL);
  ELSE
      dbms_output.enable(1000000);
  END IF;
  dbms_output.put_line( 'Gather Schema Stats for Templates Tables' );
  FOR r1 IN c1 LOOP
  BEGIN
    dbms_output.put_line( 'Gather Statistics for '||r1.table_name );
    dbms_stats.gather_table_stats( ownname                  => user,
                                   tabname                  => r1.table_name,
                                   estimate_percent         => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                   block_sample             => TRUE,
                                   no_invalidate            => TRUE,
                                   degree                   => DBMS_STATS.DEFAULT_DEGREE,
                                   cascade                  => TRUE   );
  EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( '*****Failed*****' );
  END;
  END LOOP;
END;
/
set timing off
@utlspoff

@utlprmpt "Initialize the setup tables based on the detected configuration"

@utlspon popview
set feedback on
set echo     off
set verify   off
set serveroutput on size &MAX_SERVEROUTPUT_SIZE

whenever sqlerror continue

whenever sqlerror exit 20
set timing on

define MAX_BUFFER=4000

CREATE OR REPLACE PACKAGE n_popview_pkg IS
    --
    -- Determine the owner name based on the application label passed in.
    --
    FUNCTION get_owner_name( i_application_label     IN   VARCHAR2  )
      RETURN VARCHAR2;
    --
END n_popview_pkg;
/

CREATE OR REPLACE PACKAGE BODY n_popview_pkg IS

    TYPE gtyp_appl_hash_table IS TABLE OF n_application_owners.owner_name%TYPE
         INDEX BY BINARY_INTEGER;
         
    gt_application_table     gtyp_appl_hash_table;
    
    gci_hash_base       CONSTANT BINARY_INTEGER := 0;
    gci_hash_size       CONSTANT BINARY_INTEGER := 131072;

    -- Determine if we have access to the given org.
    FUNCTION get_owner_name( i_application_label     IN   VARCHAR2  )
      RETURN VARCHAR2 AS
        cursor c_get_owner_name is 
        select ao.owner_name,
               ao.application_label
          from n_application_owners ao
         where ao.owner_name is not null
         group by ao.owner_name,
                  ao.application_label;

        li_appl_hash                BINARY_INTEGER := dbms_utility.get_hash_value( i_application_label,gci_hash_base,gci_hash_size );

    BEGIN

        if ( NOT gt_application_table.EXISTS(li_appl_hash) ) then
            BEGIN
                -- populate the buffer
                for r1 in c_get_owner_name  LOOP
                    gt_application_table(dbms_utility.get_hash_value( r1.application_label,gci_hash_base,gci_hash_size )) := r1.owner_name;
                end loop;
            EXCEPTION
                WHEN OTHERS THEN 
                    dbms_output.put_line( sqlerrm  );
                    return NULL;
            END;
        end if;

        if ( gt_application_table.EXISTS( li_appl_hash ) ) then 
            return gt_application_table( li_appl_hash );
        else 
            return NULL;
        end if;
       
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm  );
            RETURN NULL;
    END get_owner_name;
    --
END n_popview_pkg;
/

--                                              
-- Create a function to translate the table_name to the editioning view.
CREATE OR REPLACE FUNCTION get_target_table_name( i_owner_name   IN     VARCHAR2, 
                                                  i_table_name   IN     VARCHAR2 ) 
    RETURN VARCHAR2 IS
    ls_table_name   VARCHAR2(30) := UPPER(i_table_name);
    ls_owner_name   VARCHAR2(30) := UPPER(i_owner_name);
BEGIN

    -- Only need to run the select if product version >= 12.2 and this is not the noetix_sys user.
    IF (     &PRODUCT_VERSION >= 12.2
         --AND i_owner_name IS NOT NULL
         AND i_table_name                       IS NOT NULL
         AND NVL(i_owner_name,'$NULL_ARG$' )    <> '&NOETIX_USER' ) THEN
        SELECT NVL(ev.view_name,ls_table_name)
          INTO ls_table_name
          FROM n_tmp_all_editioning_views ev
         WHERE ev.table_name = UPPER(ls_table_name)
           AND ev.owner      = NVL(ls_owner_name,ev.owner)
           AND rownum        = 1;
    END IF;

    return ls_table_name;
EXCEPTION
    WHEN OTHERS THEN
        return ls_table_name;
END get_target_table_name;
/

BEGIN
    BEGIN
        execute immediate 'truncate table n_tmp_all_editioning_views';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    IF ( &PRODUCT_VERSION >= 12.2 ) THEN
        execute immediate
'INSERT /*+ APPEND */ INTO n_tmp_all_editioning_views
     ( owner,
       table_name,
       view_name )
SELECT p.owner,
       p.table_name,
       ev.view_name
  FROM all_editioning_views       ev,
       user_tab_privs             p
 WHERE p.owner        = ev.owner (+)
   AND p.table_name   = ev.table_name (+)
   AND p.privilege    = ''SELECT''
   AND p.grantable    = ''YES''
   AND SUBSTR(p.table_name,-1,1) <> ''#'' 
   group by p.owner, p.table_name, ev.view_name ';  --added the group by clause Issue NV-314
    ELSE
        INSERT /*+ APPEND */ INTO n_tmp_all_editioning_views
             ( owner,
               table_name,
               view_name )
        SELECT p.owner,
               p.table_name,
               TO_CHAR(NULL)     view_name
          FROM user_tab_privs             p
         WHERE p.privilege    = 'SELECT'
           AND p.grantable    = 'YES'
           AND SUBSTR(p.table_name,-1,1) <> '#'
         group by p.owner, p.table_name, TO_CHAR(NULL); --added the group by clause Issue NV-314
    END IF;
    COMMIT;

    BEGIN
      dbms_output.put_line( 'Gather Statistics for N_TMP_ALL_EDITIONING_VIEWS' );
      dbms_stats.gather_table_stats( ownname                  => user,
                                     tabname                  => 'N_TMP_ALL_EDITIONING_VIEWS',
                                     estimate_percent         => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                     block_sample             => TRUE,
                                     no_invalidate            => TRUE,
                                     degree                   => DBMS_STATS.DEFAULT_DEGREE,
                                     cascade                  => TRUE   );
    EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line( '*****Failed*****' );
    END;

    BEGIN
        execute immediate 'truncate table N_TMP_ALL_EDITIONING_VIEW_COLS';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    IF ( &PRODUCT_VERSION >= 12.2 ) THEN
        execute immediate
'INSERT /*+ APPEND */ INTO N_TMP_ALL_EDITIONING_VIEW_COLS
     ( owner,
       view_name,
       view_column_id,
       view_column_name,
       table_column_id,
       table_column_name )
SELECT evc.owner,
       evc.view_name,
       evc.view_column_id,
       evc.view_column_name,
       evc.table_column_id,
       evc.table_column_name
  FROM n_tmp_all_editioning_views       ev,
       all_editioning_view_cols         evc
 WHERE evc.owner      = ev.owner
   AND evc.view_name  = ev.view_name ';
    END IF;
    COMMIT;

    BEGIN
      dbms_output.put_line( 'Gather Statistics for N_TMP_ALL_EDITIONING_VIEW_COLS' );
      dbms_stats.gather_table_stats( ownname                  => user,
                                     tabname                  => 'N_TMP_ALL_EDITIONING_VIEW_COLS',
                                     estimate_percent         => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                     block_sample             => TRUE,
                                     no_invalidate            => TRUE,
                                     degree                   => DBMS_STATS.DEFAULT_DEGREE,
                                     cascade                  => TRUE   );
    EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line( '*****Failed*****' );
    END;

END;
/

prompt Truncate and repopulate the n_application_org_mappings table
truncate table n_application_org_mappings;

INSERT INTO N_APPLICATION_ORG_MAPPINGS
     ( application_label,
       application_instance,
       chart_of_accounts_id,
       chart_of_accounts_name,
       set_of_books_id,
       set_of_books_name,
       org_id,
       org_name,
       organization_id,
       organization_name,
       cost_organization_id,
       cost_organization_name,
       master_organization_id,
       master_organization_name,
       business_group_id,
       business_group_name,
       currency_code,
       legislative_code,
       legislation_name,
       company_code,
       company_name,
       process_orgn_code,
       process_orgn_name,
       source_instance_id   )-- Issue 5357
-- Single Instances
SELECT nao.application_label,
       nao.application_instance,
       nao.chart_of_accounts_id,
       nao.chart_of_accounts_name,
       nao.set_of_books_id,
       nao.set_of_books_name,
       nao.org_id,
       nao.org_name,
       nao.organization_id,
       nao.organization_name,
       nao.cost_organization_id,
       nao.cost_organization_name,
       nao.master_organization_id,
       nao.master_organization_name,
       nao.business_group_id,
       nao.business_group_name,
       nao.currency_code,
       nao.legislative_code,
       leg.territory_short_name,
       nao.company_code,
       nao.company_name,
       nao.process_orgn_code,
       nao.process_orgn_name,
       nao.source_instance_id  -- Issue 5357
  FROM n_fnd_territories_vl leg,
       n_application_owners nao
 WHERE nao.application_instance NOT LIKE 'X%'
   AND nao.application_instance NOT LIKE 'G%'
   AND nao.legislative_code     = leg.territory_code (+)
   -- PAYROLL is currently limited to 4 legislative codes right now. 
   -- Hardcode the for now.
   AND (      nao.application_label != 'PAY'
         OR (     nao.application_label  = 'PAY'
              and nao.legislative_code  IN ( 'US', 'CA','AU','GB' ) ) )
 UNION ALL
-- XOP Instances
SELECT nao.application_label,
       nao.xop_instance,
       nao.chart_of_accounts_id,
       nao.chart_of_accounts_name,
       nao.set_of_books_id,
       nao.set_of_books_name,
       nao.org_id,
       nao.org_name,
       nao.organization_id,
       nao.organization_name,
       nao.cost_organization_id,
       nao.cost_organization_name,
       nao.master_organization_id,
       nao.master_organization_name,
       nao.business_group_id,
       nao.business_group_name,
       nao.currency_code,
       nao.legislative_code,
       leg.territory_short_name,
       nao.company_code,
       nao.company_name,
       nao.process_orgn_code,
       nao.process_orgn_name,
       nao.source_instance_id                        -- Issue 5357
  FROM n_fnd_territories_vl leg,
       n_application_owners nao
 WHERE nao.xop_instance                IS NOT NULL
   AND NVL(nao.use_org_in_xop_flag,'N') = 'Y'
   AND nao.legislative_code             = leg.territory_code (+)
   -- PAYROLL is currently limited to 4 legislative codes right now. 
   -- Hardcode the for now.
   AND (      nao.application_label != 'PAY'
         OR (     nao.application_label  = 'PAY'
              and nao.legislative_code  IN ( 'US', 'CA','AU','GB' ) ) )
 UNION ALL
-- Global Instances
SELECT nao.application_label,
       nao.global_instance,
       nao.chart_of_accounts_id,
       nao.chart_of_accounts_name,
       nao.set_of_books_id,
       nao.set_of_books_name,
       nao.org_id,
       nao.org_name,
       nao.organization_id,
       nao.organization_name,
       nao.cost_organization_id,
       nao.cost_organization_name,
       nao.master_organization_id,
       nao.master_organization_name,
       nao.business_group_id,
       nao.business_group_name,
       nao.currency_code,
       nao.legislative_code,
       leg.territory_short_name,
       nao.company_code,
       nao.company_name,
       nao.process_orgn_code,
       nao.process_orgn_name,
       nao.source_instance_id                -- Issue 5357
  FROM n_fnd_territories_vl leg,
       n_application_owners nao
 WHERE nao.global_instance                IS NOT NULL
   AND NVL(nao.use_org_in_global_flag,'N') = 'Y'
   AND nao.legislative_code                = leg.territory_code (+)
   -- PAYROLL is currently limited to 4 legislative codes right now. 
   -- Hardcode the for now.
   AND (      nao.application_label     != 'PAY'
         OR (     nao.application_label  = 'PAY'
              and nao.legislative_code  IN ( 'US', 'CA','AU','GB' ) ) );

INSERT INTO N_APPLICATION_ORG_MAPPINGS
     ( APPLICATION_LABEL,
       APPLICATION_INSTANCE,
       CHART_OF_ACCOUNTS_ID,
       SET_OF_BOOKS_ID,
       ORG_ID,
       ORGANIZATION_ID,
       COST_ORGANIZATION_ID,
       MASTER_ORGANIZATION_ID,
       BUSINESS_GROUP_ID,
       LEGISLATIVE_CODE,
       COMPANY_CODE,
       PROCESS_ORGN_CODE,
       SOURCE_INSTANCE_ID     )    -- Issue 5357
SELECT xmap.application_label,
       xmap.application_instance,
       -9999,
       -9999,
       -9999,
       -9999,
       -9999,
       -9999,
       -9999,
       NULL,   ---  '-9999',
       '-9999',
       '-9999',
       -9999                  -- Issue 5357
  FROM N_APPLICATION_ORG_MAPPINGS xmap
 WHERE substrb(xmap.application_instance,1,1) in ('X','G')
 GROUP BY xmap.application_label,
          xmap.application_instance;

INSERT INTO N_APPLICATION_ORG_MAPPINGS
     ( APPLICATION_LABEL,
       APPLICATION_INSTANCE,
       CHART_OF_ACCOUNTS_ID,
       SET_OF_BOOKS_ID,
       ORG_ID,
       ORGANIZATION_ID,
       COST_ORGANIZATION_ID,
       MASTER_ORGANIZATION_ID,
       BUSINESS_GROUP_ID,
       LEGISLATIVE_CODE,
       COMPANY_CODE,
       PROCESS_ORGN_CODE,
       SOURCE_INSTANCE_ID     )      -- Issue 5357
SELECT xmap.application_label,
       xmap.application_instance,
       -9999,
       -9999,
       -9999,
       -9999,
       -9999,
       -9999,
       -9999,
       NULL,   ---  '-9999',
       '-9999',
       '-9999',
       -9999               -- Issue 5357
  FROM N_APPLICATION_ORG_MAPPINGS xmap
 WHERE substrb(xmap.application_instance,1,1) not in ('X','G');

commit;

set define :

prompt populate the profile options which will modify the views
insert /*+ APPEND */ into n_profile_options
     ( profile_option,
       application_instance,
       application_label,
       table_application_label,
       table_owner_name,
       table_name,
       metadata_table_name,
       omit_flag,
       profile_select
     )
select pot.profile_option,
       ao.application_instance,
       pot.application_label,
       pot.table_application_label,
       n_popview_pkg.get_owner_name( pot.table_application_label ),                                         -- table_owner_name
       get_target_table_name(n_popview_pkg.get_owner_name( pot.table_application_label ), pot.table_name ), -- Table_name
       pot.table_name,                                                                                      -- Metadata_table_name
       null,                                                                                                -- omit_flag
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
           replace(
               replace(
                   replace(
                       replace(
                           replace(
                               replace(
                               replace(
                                   replace( pot.profile_select,
                                   '&ORGANIZATION_ID', nvl(ao.organization_id,0)),
                               '&SET_OF_BOOKS_ID', nvl(ao.set_of_books_id,0)),
                               '&LEDGER_ID', nvl(ao.set_of_books_id,0)),
                           '&CURRENCY_CODE', nvl(ao.currency_code,'USD')),
                       '&CHART_OF_ACCOUNTS_ID', nvl(ao.chart_of_accounts_id,101)),
                   '&COST_ORGANIZATION_ID', nvl(ao.cost_organization_id,0)),
               '&MASTER_ORGANIZATION_ID', nvl(ao.master_organization_id,0)),
           '&BUSINESS_GROUP_ID', nvl(ao.business_group_id,0)),
       '&LEGISLATIVE_CODE', nvl(ao.legislative_code,'US')),
       '&NOETIX_LANG', ':NOETIX_LANG'),
       '&NOETIX.',     ':NOETIX_USER'||'.'),
       '&APPS.',       n_popview_pkg.get_owner_name('APPS')||'.' ),
       '&CONCAT_NULL', ':CONCAT_NULL'),
       '&PLUS_ZERO',   ':PLUS_ZERO'),
       '&APPLICATION_INSTANCE',   ao.application_instance ),
       '&APPLICATION_LABEL',      ao.application_label )
  from n_application_owners        ao,
       n_profile_option_templates  pot
 where pot.application_label           = ao.application_label
   and pot.include_flag                = 'Y'
   and ao.base_application            in ('Y','S')
   and ao.application_instance  not like 'X%'    -- not xorg
   and ao.application_instance  not like 'G%'    -- not global
   and ao.role_prefix             is not null
   and not exists
       ( select 'PROFILE OPTION already exists'
           from n_profile_options npo
          where npo.profile_option         = pot.profile_option
            and npo.application_instance   = ao.application_instance
       )
;
commit;
--
-- begin xorg
--    create profile options for xop instances
--
prompt Populate the profile options which will modify the views (XOP/Global)
insert /*+ APPEND */ into n_profile_options
     ( profile_option,
       application_instance,
       application_label,
       table_application_label,
       table_owner_name,
       table_name,
       metadata_table_name,
       omit_flag,
       profile_select
     )
select pot.profile_option,
       ao.application_instance,
       pot.application_label,
       pot.table_application_label,
       n_popview_pkg.get_owner_name( pot.table_application_label ),                                         -- table_owner_name
       get_target_table_name(n_popview_pkg.get_owner_name( pot.table_application_label ), pot.table_name ), -- Table_name
       pot.table_name,                                                                                      -- Metadata_table_name
       null,                                                                                                -- omit_flag
       decode(instrb(profile_select,'&APPLICATION_LABEL'),0,
       decode(instrb(profile_select,'&APPLICATION_INSTANCE'),0,
       decode(instrb(profile_select,'&PLUS_ZERO'),0,
       decode(instrb(profile_select,'&CONCAT_NULL'),0,
       decode(instrb(profile_select,'&NOETIX_LANG'),0,
       decode(instrb(profile_select,'&NOETIX_USER.'),0,
       decode(instrb(profile_select,'&APPS.'),0,
       decode(instrb(profile_select, '&LEGISLATIVE_CODE'), 0,
       decode(instrb(profile_select, '&BUSINESS_GROUP'), 0,
       decode(instrb(profile_select,'&ORGANIZATION_ID'),0,
          decode(instrb(profile_select,'&SET_OF_BOOKS_ID'),0,
             decode(instrb(profile_select,'&CURRENCY_CODE'),0,
                decode(instrb(profile_select,'&CHART_OF_ACCOUNTS_ID'),0,
                   decode(instrb(profile_select,'&COST_ORGANIZATION_ID'),0,
                      decode(instrb(profile_select,'&MASTER_ORGANIZATION_ID'),0,
                            profile_select,
                      replace(profile_select,'&MASTER_ORGANIZATION_ID',
                      nvl(ao.master_organization_id,0))),
                   replace(replace(profile_select,'=',' IN '),'&COST_ORGANIZATION_ID',
                   '( SELECT XM1.COST_ORGANIZATION_ID '||
                       'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                      'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                        'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
                replace(replace(profile_select,'=',' IN '),'&CHART_OF_ACCOUNTS_ID',
                '( SELECT distinct XM1.CHART_OF_ACCOUNTS_ID '||
                    'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                   'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                     'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
             replace(replace(profile_select,'=',' IN '),'''&CURRENCY_CODE''',
             '( SELECT XM1.CURRENCY_CODE '||
                 'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                  'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' '||
                'UNION ALL '||
                'SELECT ''USD'' '||
                  'FROM DUAL ) '       )),
          replace(replace(profile_select,'=',' IN '),'&SET_OF_BOOKS_ID',
          '( SELECT XM1.SET_OF_BOOKS_ID '||
              'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
             'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
               'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
       replace(replace(profile_select,'=',' IN '),'&ORGANIZATION_ID',
       '( SELECT XM1.ORGANIZATIONS_ID '||
           'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
          'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
            'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
       replace(replace(profile_select,'=',' IN '),'''&BUSINESS_GROUP''',
       '( SELECT XM1.BUSINESS_GROUP_ID '||
           'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
          'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
            'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' '||
          'UNION ALL '||
          'SELECT 0 '||
            'FROM DUAL ) '       )),
       replace(replace(profile_select,'=',' IN '),'''&LEGISLATIVE_CODE''',
       '( SELECT XM1.LEGISLATIVE_CODE '||
           'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
          'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
            'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' '||
          'UNION ALL '||
          'SELECT '''' '||
            'FROM DUAL ) '       )),
       replace(profile_select,'&APPS.',       n_popview_pkg.get_owner_name('APPS')||'.' )),
       replace(profile_select,'&NOETIX.',     ':NOETIX_USER'||'.')),
       replace(replace(profile_select,'=',' IN '),'&NOETIX_LANG',':NOETIX_LANG')),
       replace(profile_select,'&CONCAT_NULL',':CONCAT_NULL')),
       replace(profile_select,'&PLUS_ZERO',  ':PLUS_ZERO')),
       replace(profile_select,'&APPLICATION_INSTANCE',ao.application_instance)),
       replace(profile_select,'&APPLICATION_LABEL',ao.application_label))
  from n_application_owners       ao,
       n_profile_option_templates pot
 where pot.application_label      = ao.application_label
   and pot.include_flag           = 'Y'
   and ao.base_application       in ('Y','S')
   and substrb(ao.application_instance,1,1) in ('G','X')
   and ao.role_prefix            is not null
   and not exists
     ( select 'PROFILE OPTION already exists'
         from n_profile_options npo
        where npo.profile_option       = pot.profile_option
          and npo.application_instance = ao.application_instance )
;
-- end xorg
--
commit;
--
-- For cross-organization inventory views,  set several special profile options
--
PROMPT Set profile options used by cross-organization inventory views
--
UPDATE n_profile_options p
   SET p.profile_select              = '''Y'''
 WHERE p.profile_option              = 'GLOBALINV'
   AND p.application_instance     like 'G%'
   AND p.application_instance not like 'X%';

UPDATE n_profile_options p
   SET p.profile_select              = '''Y'''
 WHERE p.profile_option              = 'GLOBALMRP'
   AND p.application_instance     like 'G%'
   AND p.application_instance not like 'X%';

UPDATE n_profile_options p
   SET p.profile_select              = '''N'''
 WHERE p.profile_option              = 'NOTGLOBALINV'
   AND p.application_instance     like 'G%'
   AND p.application_instance not like 'X%';

-- Set escape off because of the use of escape characters in the regular expressions.
set escape off
prompt Determine the table_owner for the application label used in profile_options
--  and the application_instance of the view.
declare -- {
    -- For the calculating the profile options, the select statements
    -- have tables, look up their owners.  These owners are denoted in
    -- the template by their application labels (with an "&"), by
    -- something like
    -- "&PO." or "&AP."
    CURSOR c5 is
    SELECT '' view_name,
           po.table_application_label,
           po.application_label,
           po.application_instance,
           ao.application_id,
           po.profile_select,
           rowidtochar(po.rowid) option_rowid
      FROM n_application_owners ao,
           n_profile_options    po
     WHERE po.application_label    = ao.application_label
       AND po.application_instance = ao.application_instance
       AND 
         (    po.profile_select             LIKE '%&%'
           OR UPPER(po.profile_select)      LIKE '%$PROFILE$.%'
           OR UPPER(po.profile_select)      LIKE '%ALL_TAB_COLUMNS%' );
    --
    ls_owner_name             n_view_tables.owner_name%TYPE;
    ls_target_table_name      n_view_tables.table_name%TYPE;
    lb_profile_option_defined boolean;
    ls_profile_option_value   fnd_profile_option_values_s.profile_option_value%TYPE;
    ls_profile_select         n_profile_options.profile_select%TYPE;
    ls_profile_option_name    n_profile_options.profile_option%TYPE;
    li_application_id         n_application_owners.application_id%TYPE;

    ls_token                        VARCHAR2(4000);
    ls_token1                       VARCHAR2(4000);
    ls_token2                       VARCHAR2(4000);

    --
    -- Get a profile option value. This procedure has the same call
    -- interface as the Release 10 packaged procedure of the same
    -- name in the package FND_PROFILE. We don't use the
    -- arguments user_id or responsibility_id but merely include them
    -- for compatability.
    procedure get_specific(
            i_name            in  fnd_profile_options_s.profile_option_name%TYPE,
            i_user_id         in  fnd_user_s.user_id%TYPE,
            responsibility_id in  number,
                                  -- fnd_responsibility_s.responsibility_id%TYPE,
            i_application_id  in  fnd_application_s.application_id%TYPE,
            o_val            out  fnd_profile_option_values_s.profile_option_value%TYPE,
            o_defined        out boolean ) is
    begin   -- {
        o_defined := FALSE;
        begin
            -- Application level profile option
            SELECT pov.profile_option_value
              INTO o_val
              FROM fnd_profile_option_values_s  pov,
                   fnd_profile_options_s        po
             WHERE pov.profile_option_id              = po.profile_option_id
               AND nvl(po.start_date_active,sysdate) <= sysdate
               AND nvl(po.end_date_active,sysdate)   >= sysdate
               AND po.profile_option_name             = i_name
               AND pov.level_id                       = 10002
               AND pov.level_value                    = i_application_id;
            o_defined := TRUE;
        exception
            WHEN NO_DATA_FOUND THEN
                begin -- {
                    -- Site level profile option
                    SELECT pov.profile_option_value
                      INTO o_val
                      FROM fnd_profile_option_values_s pov,
                           fnd_profile_options_s       po
                     WHERE pov.profile_option_id              = po.profile_option_id
                       AND nvl(po.start_date_active,sysdate) <= sysdate
                       AND nvl(po.end_date_active,sysdate)   >= sysdate
                       AND po.profile_option_name             = i_name
                       AND pov.level_id                       = 10001;
                    o_defined := TRUE;
                exception
                    WHEN NO_DATA_FOUND THEN
                        o_defined := FALSE;
                end; -- }
        end;
    end get_specific; -- }
    --
    -- Parse the input character string for a profile option.
    -- Profile options are identified by $PROFILE$.profile_option
    procedure parse_profile( char_string     in      varchar2,
                             name            out     varchar2 ) is
        s    varchar2(2000);         -- string
        s1   varchar2(50);           -- string also
        len  number;                 -- length
    begin -- {
        s   := upper(char_string);
        len := instrb(s,'$PROFILE$.');
        if ( len = 0 ) then -- {
            name := null;
        else -- }{
            -- trim off everything before profile option
            s    := substrb(s,len+10,50);
            len  := lengthb(s);
            -- trim off the profile option
            s1   := ltrim(s,'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_$');
            -- see how long profile option was by measuring
            -- what is left.
            len  := len - lengthb(s1);
            name := substrb(s,1,len);
        end if; -- }
    end parse_profile; -- }
    --
begin -- }{
    for r5 in c5 loop -- {
        ls_profile_select := upper(r5.profile_select);
        IF ( :PRODUCT_VERSION >= 12.2 ) THEN
          IF ( ls_profile_select like '%'||'&'||'%' ) THEN
            -- Processing for 12.2 and above
            -- First handle the pattern  '&<APPLICATION_LABEL>.'.  replace &<APPLICATION_LABEL> with the ownername
            ls_token := NULL;
            LOOP
                -- Loop through the string and look for the first pattern
                ls_token := TRIM(translate(regexp_substr( ls_profile_select, '''&'||'([[:'||'alnum:]]+)\.''',1,1, 'i' ),'&'||'''.','   '));
                -- the token string should be null if we did not find if.  Exit in that case.
                IF ( ls_token is null ) THEN
                    exit;
                END IF;
                -- Update the application name variable with the owner name.
                ls_profile_select := regexp_replace( ls_profile_select, '''&'||ls_token||'\.''', ''''||n_popview_pkg.get_owner_name(ls_token)||'.''',1,1,'i' );
--                ls_profile_select := replace( ls_profile_select, '''&'||ls_token||'.''', ''''||n_popview_pkg.get_owner_name(ls_token)||'.''' );
            END LOOP;

            -- Handle the pattern  &<APPLICATION_LABEL>.<table_name>.  replace &<APPLICATION_LABEL> with the owner name and <table_name> with the table_name
            -- or the EBR view_name
            ls_token := NULL;
            LOOP
                -- Loop through the string and look for the first pattern
                ls_token := regexp_substr( ls_profile_select, '&'||'([[:'||'alnum:'||']]+)\.([[:'||'alnum:'||']#_]+)([[:'||'space:'||']\),]*)',1,1, 'i' );
                -- the token string should be null if we did not find if.  Exit in that case.
                IF ( ls_token is null ) THEN
                    exit;
                END IF;
                -- Figure out the owner_name
                ls_token1               := substr(ls_token,2,instr(ls_token,'.')-2);
                ls_owner_name           := n_popview_pkg.get_owner_name( ls_token1 );
                -- Figure out the table name and the editioning view if it exists.
                ls_token2               := regexp_replace(substr(ls_token,instr(ls_token,'.')+1),'([[:'||'alnum:'||']#_]+)([[:'||'space:'||']\),]*)','\1',1,1,'i');
                ls_target_table_name    := get_target_table_name(ls_owner_name, ls_token2);

                -- Update the application name variable with the owner name and the table_name
                ls_profile_select       := regexp_replace( ls_profile_select, '&'||ls_token1||'\.'||ls_token2||'([[:'||'space:'||']\),]*)', ls_owner_name||'.'||ls_target_table_name||'\1',1,1,'i');
            END LOOP;
          END IF;

          IF ( ls_profile_select like '%ALL_TAB_COLUMN%' )THEN
            -- Handle the pattern  &<APPLICATION_LABEL>.<table_name>.  replace &<APPLICATION_LABEL> with the owner name and <table_name> with the table_name
            -- or the EBR view_name
            ls_token             := NULL;
            ls_token2            := NULL;
            ls_target_table_name := NULL;
            LOOP
              -- Loop through the string and look for the first pattern
              ls_token := regexp_substr( ls_profile_select, '(all_tab_columns.*table_name[[:'||'space:'||']]*\=[[:'||'space:'||']]*'')([[:'||'alnum:'||']_]+)''',1,1, 'i' );
              -- the token string should be null if we did not find if.  Exit in that case.
              IF ( ls_token is null ) THEN
                  exit;
              END IF;
              -- Figure out the table name and the editioning view if it exists.
              ls_token1               := substr( ls_token, 1,instr(ls_token,'''',-1,2));
              ls_token2               := rtrim(substr( ls_token, instr(ls_token,'''',-1,2)+1),'''');
              ls_target_table_name    := get_target_table_name('', ls_token2);

              -- Update the application name variable with the owner name and the table_name
              ls_profile_select       := regexp_replace( ls_profile_select, '(all_tab_columns.*table_name[[:'||'space:'||']]*\=[[:'||'space:'||']]*'')([[:'||'alnum:'||']_]+)''', '\1'||ls_target_table_name||'''',1,1,'i');
              -- NOTE -- Adding exit.  Only will support one copy of all_tab_columns for now.
              exit;
            END LOOP;
          END IF;
        ELSE
            -- Prior to 12.2, we only have to convert the application_label ampersand variable to the application owner.
            -- First handle the pattern  &<APPLICATION_LABEL>.  replace &<APPLICATION_LABEL> with the ownername
            ls_token := NULL;
            LOOP
                ls_token := TRIM(translate(regexp_substr( ls_profile_select, '&'||'([[:'||'alnum:'||']_]+)\.',1,1, 'i' ),'&'||'.','  '));
                IF ( ls_token is null ) THEN
                    exit;
                END IF;
                -- Update the application name variable with the owner name.
                ls_profile_select := replace( ls_profile_select, '&'||ls_token||'.', n_popview_pkg.get_owner_name(UPPER(ls_token))||'.' );
            END LOOP;
        END IF;

        -- Now handle the $PROFILE$ string
        while ( ls_profile_select like '%$PROFILE$.%' ) loop -- {
            parse_profile( ls_profile_select,
                           ls_profile_option_name );
            begin -- {
                select ao.application_id
                  into li_application_id
                  from n_application_owners ao
                 where ao.application_label    = r5.application_label
                   and ao.application_instance = r5.application_instance
                ;
            exception -- }{
                WHEN NO_DATA_FOUND THEN
                    li_application_id := null;
            end; -- }
            --
            get_specific(
                        ls_profile_option_name,
                        null,              --user_id
                        null,              --responsibility_id
                        li_application_id,
                        ls_profile_option_value,
                        lb_profile_option_defined);
            --
            if lb_profile_option_defined then -- {
                ls_profile_select :=
                    replace(ls_profile_select,
                            '$PROFILE$.'||ls_profile_option_name,
                            ''''||ls_profile_option_value||'''');
            else -- }{
                ls_profile_select :=
                    replace(ls_profile_select,
                            '$PROFILE$.'||ls_profile_option_name,
                            '''''');
            end if; -- }
        end loop; -- } while ls_profile_select
        --
        update n_profile_options
           set profile_select   = ls_profile_select,
               table_owner_name = n_popview_pkg.get_owner_name( r5.table_application_label )
         where rowid = chartorowid(r5.option_rowid);
    end loop; -- } end cursor r5
end; -- } popview.sql
/
commit;

-- Turn the escape back on
set escape on

--
set define &
--
whenever sqlerror exit 21
--
prompt Populate the roles which will own the views
insert into n_roles
     ( role_name,
       role_label,
       application_instance,
       application_label,
       application_id,
       owner_name,
       oracle_id,
       responsibility_name,
       description,
       set_of_books_name,
       organization_name,
       omit_flag,
       user_enabled_flag
     )
select rtrim(substrb(ao.role_prefix || '_' || rt.role_label,1,30)) role_name,
       rt.role_label,
       ao.application_instance,
       rt.application_label,
       ao.application_id,
       ao.owner_name,
       ao.oracle_id,
       rt.responsibility_name,
       rt.description,
       ao.set_of_books_name,
       ao.organization_name,
       ( case ao.install_status
           when 'I' then
               ( CASE ao.role_enabled_flag
                   WHEN 'Y' THEN ( CASE rcnfg.user_enabled_flag
                                     WHEN 'Y' then 'N'
                                     WHEN 'N' then 'Y'
                                     ELSE          'Y'
                                   END          )
                   WHEN 'N' THEN 'Y'
                   ELSE 'Y'
                 END )
           else 'Y' 
         end  ),
       rcnfg.user_enabled_flag
  from n_user_role_config    rcnfg,
       n_application_owners  ao,
       n_role_templates      rt
 where rt.application_label      = ao.application_label
   -- NOTE:  Code should be the same used to populate n_user_role_config in prefix.sql
   and ao.base_application      in ('Y','S')
   and (       rt.role_label               NOT IN ( 'PAYROLL', 'SUBLEDGER_ACCOUNTING' )
         -- The following role(s) should not be installed for standard
         or (     rt.role_label              = 'SUBLEDGER_ACCOUNTING'
              AND ao.application_instance LIKE 'G%' )
         or (     rt.role_label                  = 'PAYROLL'
              and nvl(ao.legislative_code,'US') IN ( 'US', 'CA', 'AU','GB' )  ))
   and (    ao.install_status                        = 'I'
         or (     ao.xop_instance                   is not null
              and nvl(ao.use_org_in_xop_flag,'N')    = 'Y' )
--         or (     ao.global_instance                is not null
--              and nvl(ao.use_org_in_global_flag,'N') = 'Y' )
       )
   -- END NOTE
   and rcnfg.application_label                   = ao.application_label
   and rcnfg.application_instance                = ao.application_instance
   and rcnfg.role_label                          = rt.role_label
   and (    (     rcnfg.instance_type              = 'X'
              and nvl(rcnfg.user_enabled_flag,'N') = 'Y'
              -- The following role(s) should not be installed for XOP
              and rt.role_label         NOT IN ( 'SUBLEDGER_ACCOUNTING' )  )
         or (     rcnfg.instance_type              = 'G'
              and nvl(rcnfg.user_enabled_flag,'N') = 'Y'
              -- Even though the following modules are global capable, we don't want to generate the global roles associated with them
              -- The PB/PC global views will get generated in the Projects role anyway and that security
              -- is controlled by the PA application.
              and ao.application_label        not in ( 'PB', 'PC' ) )
         or (     rcnfg.instance_type  = 'S'
              and nvl(rcnfg.user_enabled_flag,'N') = 'Y'
              -- The following role(s) should not be installed for standard
              and rt.role_label         NOT IN ( 'SUBLEDGER_ACCOUNTING' ) )
         or (     rcnfg.instance_type  = 'S'
              -- The following role(s) should not be installed for standard
              and rt.role_label         NOT IN ( 'SUBLEDGER_ACCOUNTING' ) 
              and exists
                ( select 'Included in XOP'
                    from n_user_role_config    rcnfg2,
                         n_application_owners  ao2
                   where ao2.application_label              = ao.application_label
                     and ao2.application_instance           = ao.xop_instance
                     and rcnfg2.application_label           = ao2.application_label
                     and rcnfg2.application_instance        = ao2.application_instance
                     and ao2.base_application              in ('Y','S')
                     and (    rt.role_label               NOT IN ( 'PAYROLL', 'SUBLEDGER_ACCOUNTING' )
                           or (     rt.role_label              = 'SUBLEDGER_ACCOUNTING'
                                AND ao.application_instance LIKE 'G%' )
                           or (     rt.role_label                  = 'PAYROLL'
                                and nvl(ao.legislative_code,'US') IN ( 'US', 'CA','AU','GB' )  ))
                     and ao2.install_status                 = 'I'
                     and nvl(rcnfg2.user_enabled_flag,'N')  = 'Y' ) )
       )
;
commit;

-- disable error checking because roles available may have changed
whenever sqlerror continue
whenever oserror continue
set timing off

spool off

@utlprmpt "Populate the Non-Templates tables based on the detected configuration"

set echo off
-- Turn spooling back on since it is turned off in tupdqu2.sql
@utlspon popview2
set feedback on
set echo     off
set verify   off
set timing   on

alter table n_role_views disable constraint n_role_views_fk3;

whenever sqlerror exit 22
set timing on

prompt Populate the relationship between roles and their views
--
--     Create a link from role to its views.
--     Do special processing for global inventory views/roles
--     (but skip XOP views)
--
insert /*+ APPEND */ into n_role_views
     ( role_label,
       role_name,
       view_label,
       view_name
     )
select rvt.role_label, 
       r.role_name, 
       rvt.view_label, 
       rtrim(substrb(ao.role_prefix || 
               substrb( vt.view_label, 
                        instrb(vt.view_label, '_')), 
                        1, 30 - nvl(lengthb('&VIEW_NAME_SUFFIX'), 0))) || 
               '&VIEW_NAME_SUFFIX' 
  from n_application_owners          aorole,
       n_application_owners          ao,
       n_application_xref            xref, 
       n_view_templates              vt, 
       n_roles                       r, 
       n_role_view_templates         rvt 
 where r.application_label          = xref.application_label 
   and r.application_instance       = xref.application_instance 
   and r.application_label          = aorole.application_label
   and r.application_instance       = aorole.application_instance 
   and (    (     NVL(r.omit_flag,'N')                = 'N' )
         -- if we omit standard views, add them back in just in case we need them for xop.
         or (     NVL(r.omit_flag,'N')                = 'Y'
              and r.application_instance       not like 'G%'
              and nvl(aorole.use_org_in_xop_flag,'Y') = 'Y'
              and ( case 
                      when (     r.application_label      =  xref.ref_application_label
                             and r.application_instance   =  xref.application_instance ) then
                                    nvl(aorole.use_org_in_xop_flag,'Y')
                      else ( case
                               when (    vt.special_process_code  like 'BASEVIEW%'
                                      or vt.special_process_code     = 'QUERYOBJECT' ) then
                                    'Y'
                               else nvl(ao.use_org_in_xop_flag,'Y')
                             end )
                    end ) = 'Y'
            ) )
   and xref.ref_application_label   = vt.application_label 
   and NVL(vt.include_flag, 'Y')    = 'Y' 
   and ao.application_label         = xref.ref_application_label 
   and ao.install_status           in ('I', 'S') 
   and ao.base_application         in ('Y', 'S') 
   and ao.role_prefix          IS NOT NULL 
   and ao.application_instance not like 'X%' -- no XOP   
   and rvt.view_label               = vt.view_label 
   and rvt.role_label               = r.role_label 
   and NVL(rvt.include_flag, 'Y')   = 'Y' 
   and NVL(rvt.include_flag, 'Y')   = NVL(vt.include_flag, 'Y') 
   and ((   -- Add views to roles using xref (including global inv)   
            ao.application_instance = xref.ref_application_instance) 
         or (     -- Add global inventory views to OE and PO roles   
                  -- (use the master org xref record)   
                  r.application_label                   in ('OE', 'PO') 
              and ao.application_instance          like 'G%' 
              and ao.application_label                = 'INV' 
              and ltrim(ao.application_instance, 'G')    = xref.ref_application_instance)) 
 group by rvt.role_label,
          r.role_name,
          rvt.view_label,
       rtrim(substrb(ao.role_prefix || 
               substrb( vt.view_label, 
                        instrb(vt.view_label, '_')), 
                        1, 30 - nvl(lengthb('&VIEW_NAME_SUFFIX'), 0))) || 
               '&VIEW_NAME_SUFFIX'
;
--
commit;
--
-- begin xorg
--     Create a link from role to its views.
--
prompt Populate the relationship between roles and their views (xorg)
insert /*+ APPEND */ into n_role_views
     ( role_label,
       role_name,
       view_label,
       view_name
     )
select rvt.role_label,
       r.role_name,
       rvt.view_label,
       rtrim(substrb(ao.role_prefix ||
                     substrb(vt.view_label,
                             instrb(vt.view_label,'_')),
                             1,30-nvl(lengthb('&VIEW_NAME_SUFFIX'),0))) ||
             '&VIEW_NAME_SUFFIX'
  from n_application_owners  ao,
       n_application_xref    xref,
       n_view_templates      vt,
       n_roles               r,
       n_role_view_templates rvt
 where r.application_label        = xref.application_label
   and r.application_instance     = xref.application_instance
   and nvl(r.omit_flag,'N')       = 'N'
   and xref.ref_application_label = vt.application_label
   and NVL(vt.include_flag,'Y')   = 'Y'
   and ao.application_label       = xref.ref_application_label
   and ao.install_status         in ('I','S')
   and ao.base_application       in ('Y','S')
   and ao.application_instance like 'X%'
   and rvt.view_label             = vt.view_label
   and rvt.role_label             = r.role_label
   and NVL(rvt.include_flag,'Y')  = 'Y'
   and NVL(rvt.include_flag, 'Y') = NVL(vt.include_flag, 'Y') 
   and ao.application_instance    = xref.ref_application_instance
 group by rvt.role_label,
          r.role_name,
          rvt.view_label,
          rtrim(substrb(ao.role_prefix ||
                        substrb(vt.view_label,
                                instrb(vt.view_label,'_')),
                                1,30-nvl(lengthb('&VIEW_NAME_SUFFIX'),0))) ||
                '&VIEW_NAME_SUFFIX'
;
--
commit;
--
-- end xorg
--

--
-- Allow customization of view names before populating other tables
--
@wnoetxug
--

-- Remove any roles that did not have any views generated.
delete from n_roles r
 where not exists
     ( select 'Role Exists'
         from n_role_views rv
        where r.role_name = rv.role_name );
commit;


whenever sqlerror exit 23

prompt Populate the views
--    populate the views for every view assigned to a role.
--
insert /*+ APPEND */ into n_views
     ( view_name,
       view_label,
       application_label,
       application_instance,
       description,
       profile_option,
       security_code,
       special_process_code,
       essay,
       sort_layer
     )
select rv.view_name,
       vt.view_label,
       vt.application_label,
       ao.application_instance,
       vt.description,
       pot.profile_option,
       vt.security_code,
       vt.special_process_code,
       vt.essay,
       vt.sort_layer
  from n_application_owners ao,
       n_profile_option_templates pot,
       n_view_templates     vt,
       n_role_views         rv
 where rv.view_label           = vt.view_label
   and ao.role_prefix          =
               substrb(rv.view_name,
                       1,instrb(rv.view_name,
                                substrb(rv.view_label,
                                        instrb(rv.view_label,'_'),22))-1)
   and pot.profile_option (+)  = vt.profile_option
   and pot.include_flag (+)    = 'Y'
 group by rv.view_name,
          vt.view_label,
          vt.application_label,
          ao.application_instance,
          vt.description,
          pot.profile_option,
          vt.security_code,
          vt.special_process_code,
          vt.essay,
          vt.sort_layer
;
commit;
--
-- For global views, add to the essay a note saying
-- that the view includes all organizations.
--
prompt Update the view essays for the global views
UPDATE n_views v
   SET essay = substrb( v.essay || 
                  substrb( ' This view shows data across all '||
                           ( CASE
                               WHEN ( &PRODUCT_VERSION >= 12 ) THEN 'Ledgers.'
                               ELSE 'Sets of Books.'
                             END ), 
                           1, &MAX_BUFFER - lengthb(v.essay) ),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'G%'
   AND v.application_label in
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'SOB' )
;
commit;

--
UPDATE n_views v
   SET essay = substrb( v.essay || substrb( ' This view shows data across all Operating Units.', 
                                            1, &MAX_BUFFER - lengthb(v.essay)),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'G%'
   AND v.application_label in 
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'OU' )
;
commit;
--
--
UPDATE n_views v
   SET essay = substrb( v.essay || substrb( ' This view shows data across all Business Groups.', 
                                            1, &MAX_BUFFER - lengthb(v.essay)),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'G%'
   AND v.application_label in 
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'BG' )
;
commit;
--
UPDATE n_views v
   SET essay = substrb( v.essay || substrb( ' This view shows data across all Inventory Organizations.', 
                                            1, &MAX_BUFFER - lengthb(v.essay) ),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'G%'
   AND v.application_label in 
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'INV' )
;
commit;
--
UPDATE n_views v
   SET essay = substrb( v.essay || substrb( ' This view shows data across all Source Instance Organizations.', 
                                            1, &MAX_BUFFER - lengthb(v.essay) ),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'G%'
   AND v.application_label in 
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'SINST' )
;
commit;
--
UPDATE n_views v
   SET v.essay = substrb( v.essay || substrb( ' NOTE: This view shows data across multiple '||
                                              ( CASE
                                                  WHEN ( &PRODUCT_VERSION >= 12 ) THEN 'Ledgers'
                                                  ELSE 'Sets of Books'
                                                END ) || 
                                              ' that have different '||
                                              ( CASE ( SELECT nao1.global_multi_currency||nao1.global_multi_calendar
                                                         FROM n_application_owners   nao1
                                                        WHERE nao1.application_label       = v.application_label
                                                          AND nao1.application_instance    = v.application_instance
                                                          AND nao1.application_instance like 'G%'
                                                          AND (    nao1.global_multi_currency   = 'Y'
                                                                or nao1.global_multi_calendar   = 'Y' ) )
                                                  WHEN 'YY' THEN 'base currencies and calendars.'
                                                  WHEN 'YN' THEN 'base currencies.  '
                                                  WHEN 'NY' THEN 'calendars.  '
                                                  ELSE ''
                                                END ),
                                               1, &MAX_BUFFER - lengthb(v.essay) ), 
                          1, &MAX_BUFFER )
 WHERE v.application_instance like 'G%'
   AND EXISTS
     ( SELECT nao.global_multi_currency
         FROM n_application_owners   nao
        WHERE nao.application_label       = v.application_label
          AND nao.application_instance    = v.application_instance
          AND nao.application_instance like 'G%'
          AND (    nao.global_multi_currency   = 'Y'
                OR nao.global_multi_calendar   = 'Y'  ) )
;
commit;
-- end global essay update
--
-- begin xorg
--      For the Xop views, add some additional text to the view essay
--      that tells the user what type of organization the view spans.
--      Also, make a note if the view spans sets of books with different
--      base currencies
--
prompt Update the view essays for the XOP views
UPDATE n_views v
   SET essay = substrb( v.essay || 
                  substrb( ' This view shows data across multiple '||
                           ( CASE
                               WHEN ( &PRODUCT_VERSION >= 12 ) THEN 'Ledgers '
                               ELSE 'Sets of Books '
                             END ) ||
                           ' that share a common Chart of Accounts.', 
                           1, &MAX_BUFFER - lengthb(v.essay) ),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'X%'
   AND v.application_label in
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'SOB' )
;
commit;

--
UPDATE n_views v
   SET essay = substrb( v.essay || substrb( ' This view shows data across multiple Operating Units '||
                                            'that share a common Chart of Accounts and Master ' ||
                                            'Inventory Organization.', 
                                            1, &MAX_BUFFER - lengthb(v.essay)),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'X%'
   AND v.application_label in
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'OU' )
;
commit;
--
UPDATE n_views v
   SET essay = substrb( v.essay || substrb( ' This view shows data across multiple Inventory ' ||
                                            'Organizations that share a common Chart of Accounts ' ||
                                            'and Master Inventory Organization.', 
                                            1, &MAX_BUFFER - lengthb(v.essay) ),
                        1, &MAX_BUFFER )
 WHERE v.application_instance like 'X%'
   AND v.application_label in
     ( SELECT naot.application_label 
         FROM n_application_owner_templates naot
        WHERE naot.context_code = 'INV' )
;
commit;
--
UPDATE n_views v
   SET v.essay = substrb( v.essay || substrb( ' NOTE: This view shows data across multiple '||
                                              ( CASE
                                                  WHEN ( &PRODUCT_VERSION >= 12 ) THEN 'Ledgers'
                                                  ELSE 'Sets of Books'
                                                END ) || 
                                              ' that have different '||
                                              ( CASE ( select nao1.global_multi_currency||nao1.global_multi_calendar
                                                         from n_application_owners   nao1
                                                        where nao1.application_label       = v.application_label
                                                          and nao1.application_instance    = v.application_instance
                                                          and nao1.application_instance like 'X%'
                                                          and (    nao1.global_multi_currency   = 'Y'
                                                                or nao1.global_multi_calendar   = 'Y' ) )
                                                  WHEN 'YY' THEN 'base currencies and calendars.'
                                                  WHEN 'YN' THEN 'base currencies.  '
                                                  WHEN 'NY' THEN 'calendars.  '
                                                  ELSE ''
                                                END ),
                                               1, &MAX_BUFFER - lengthb(v.essay) ), 
                          1, &MAX_BUFFER )
 WHERE v.application_instance like 'X%'
   AND EXISTS
     ( SELECT nao.global_multi_currency
         FROM n_application_owners   nao
        WHERE nao.application_label       = v.application_label
          AND nao.application_instance    = v.application_instance
          AND nao.application_instance like 'X%'
          AND (    nao.global_multi_currency   = 'Y'
                OR nao.global_multi_calendar   = 'Y'  ) )
;
commit;
--
-- end XOP essay update
--
whenever sqlerror exit 24

alter table n_role_views enable constraint n_role_views_fk3;

whenever sqlerror exit 25

prompt For these views, populate their view_queries.
insert /*+ APPEND */ into n_view_queries
     ( view_name,
       view_label,
       query_position,
       union_minus_intersection,
       profile_option,
       application_instance,
       group_by_flag,
       view_comment
     )
select v.view_name,
       v.view_label,
       qt.query_position,
       qt.union_minus_intersection,
       pot.profile_option,
       v.application_instance,
       qt.group_by_flag,
       qt.view_comment
  from n_views                v,
       n_profile_option_templates pot,
       n_view_query_templates qt
 where v.view_label            = qt.view_label
   and qt.include_flag         = 'Y'
   and pot.profile_option (+)  = qt.profile_option
   and pot.include_flag (+)    = 'Y'
;
commit;
--
--
whenever sqlerror exit 26

--   Temporarily store the key_view_label and lookup key_view_name later
--
prompt For these views, populate their view_tables.
insert /*+ APPEND */ into n_view_tables
     ( view_name,
       view_label,
       query_position,
       table_alias,
       from_clause_position,
       application_label,
       owner_name,
       table_name,
       metadata_table_name,
       generated_flag,
       base_table_flag,
       application_instance,
       subquery_flag,
       profile_option,
       gen_search_by_col_flag
     )
SELECT q.view_name,
       q.view_label,
       tt.query_position,
       tt.table_alias,
       tt.from_clause_position,
       tt.application_label,
       NULL                 owner_name,
       tt.table_name,
       tt.table_name        metadata_table_name,
       'N'                  generated_flag,
       tt.base_table_flag,
       q.application_instance,
       tt.subquery_flag,
       pot.profile_option,
       tt.gen_search_by_col_flag
  FROM n_view_queries             q,
       n_profile_option_templates pot,
       n_view_table_templates     tt
 WHERE q.view_label            = tt.view_label
   AND q.query_position        = tt.query_position
   AND tt.include_flag         = 'Y'
   AND pot.profile_option (+)  = tt.profile_option
   AND pot.include_flag (+)    = 'Y'
;
commit;
--
-- ##########################################################################
--
-- For views based upon Noetix BASEVIEW views instead of tables,
-- substitute the view_name for the table_name.
--

prompt  Process baseview names

--
-- For performance reasons, we're going to load a temp table of all
-- the base views.  It was created in ycrtable.sql.  It will be used
-- by popview.sql, autojoip.sql and xviewck.sql. It will be dropped
-- in xviewck.sql.
--
-- Insert all base views into this temporary table
-- the view_label is uppered because it will be compared with the table name
-- in the update statement below
--
truncate table n_popbase_temp;

insert /*+ APPEND */ into n_popbase_temp
     ( view_name,
       view_name_upper,
       view_label,
       application_label,
       application_instance
     )
select v.view_name,
       upper(v.view_name),
       upper(v.view_label),
       v.application_label,
       v.application_instance
  from n_views v
 where v.special_process_code LIKE 'BASEVIEW%';

--
commit;

--
-- Now update the table records with the actual name of the base view for
-- the specific application instance, substituting it for the base view label.
-- If the application_label between the base and calling views don't match
-- the table name will be populated with the text BASEVIEW ERROR.
--
set serveroutput on size &MAX_SERVEROUTPUT_SIZE
declare 
    CURSOR c_tables IS
    select table_name,
           view_name,
           t.rowid              row_id
      from n_view_tables      t
     where exists
         ( select 'PB record exists'
             from n_popbase_temp pb
            where pb.view_label           = t.table_name );

    TYPE typ_table_name     IS TABLE of n_view_tables.table_name%TYPE       INDEX BY BINARY_INTEGER;
    TYPE typ_view_name      IS TABLE of n_view_tables.view_name%TYPE        INDEX BY BINARY_INTEGER;
    TYPE typ_row_id         IS TABLE of rowid                               INDEX BY BINARY_INTEGER;
    
    lt_table_name           typ_table_name;
    lt_view_name            typ_view_name;
    lt_row_id               typ_row_id;
    ls_owner_name           VARCHAR2(30) := '&NOETIX_USER';
    li_row_count            BINARY_INTEGER;
BEGIN
    IF ( c_tables%ISOPEN ) THEN
        CLOSE c_tables;
    END IF;
    
    OPEN c_tables;
    LOOP
        FETCH c_tables BULK COLLECT
         INTO lt_table_name,
              lt_view_name,
              lt_row_id
        LIMIT 1000;
        
        for i in 1..lt_table_name.COUNT LOOP
        begin
            select distinct
                 ( case
                     when ( v.application_label = pb.application_label ) then
                        pb.view_name
                     when (     v.application_label  IN ( 'AR', 'RA' ) 
                            AND pb.application_label IN ( 'AR', 'RA' ) ) THEN
                        pb.view_name
                     when (     v.application_label  IN ( 'PA', 'PB', 'PC'  ) 
                            AND pb.application_label IN ( 'PA', 'PB', 'PC'  ) ) THEN
                        pb.view_name
                     when (     v.application_label  IN ( 'MRP', 'WIP'  ) 
                            AND pb.application_label IN ( 'MRP', 'WIP'  ) ) THEN
                        pb.view_name
                     when (     pb.application_label IN ( 'XXNAO' , 'XXHIE', 'XXKFF' ) ) THEN
                        pb.view_name
                     else
                        rtrim(substrb('BASEVIEW ERROR'||'-'||lt_table_name(i), 1, 30))
                   end )
              INTO lt_table_name(i)
              from n_popbase_temp     pb,
                   n_application_xref x,
                   n_views            v
             where v.view_name             = lt_view_name(i)
               and lt_table_name(i)        = pb.view_label
               and v.application_label     = x.application_label
               and v.application_instance  = x.application_instance
               and pb.application_label    = x.ref_application_label
               and pb.application_instance = x.ref_application_instance;
        exception
            when NO_DATA_FOUND THEN
                lt_table_name(i) := rtrim(substrb('BASEVIEW ERROR'||'-'||lt_table_name(i), 1, 30));
        END;
        END LOOP;

        FORALL i in 1..lt_table_name.COUNT
            UPDATE n_view_tables
               SET owner_name          = ls_owner_name,
                   table_name          = lt_table_name(i),
                   metadata_table_name = lt_table_name(i)
             WHERE rowid        = lt_row_id(i);

        EXIT WHEN c_tables%NOTFOUND;

    END LOOP;
    DBMS_OUTPUT.put_LINE( c_tables%ROWCOUNT||' rows updated.' );
    CLOSE c_tables;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF ( c_tables%ISOPEN ) THEN
            CLOSE c_tables;
        END IF;
    RAISE;
END;
/

--
-- Write all of the base view rule violating records to the messages table.
DECLARE
    CURSOR c_popview_errors IS
    SELECT 'Base view applications do not match. '||
           'View: '||t.view_name||
           ' / Base Alias: '|| t.table_alias           message
      FROM n_view_tables t
     WHERE t.table_name like 'BASEVIEW ERROR%';

BEGIN

    FOR r1 in c_popview_errors LOOP
        -- NOTE:  Commit occurs in the procedure call
        noetix_utility_pkg.Add_Installation_Message( 
                p_script_name               => 'popview',
                p_location                  => 'populating base views',
                p_message_type              => 'ERROR',
                p_message                   => r1.message );
    END LOOP;
END;
/

--
-- ##########################################################################
--
--
whenever sqlerror exit 27

--
--
--
-- If the installation contains a global inventory role, then populate
-- the n_application_owners.global_org2sob column for global inventory
-- roles.
--
prompt Populate the n_application_owners.global_org2sob for global inv
--
start utlif popglinv -
"exists (select 'global inv' from n_application_owners where application_instance like 'G%')"
--
prompt done popglinv
--

set define :
prompt For these views, populate their view_wheres.
--    when we populate these tables we substitute in the values
whenever sqlerror exit 28
--
insert /*+ APPEND */ into n_view_wheres
     ( view_name,
       view_label,
       query_position,
       where_clause_position,
       where_clause,
       generated_flag,
       profile_option,
       application_instance
     )
select q.view_name,
       q.view_label,
       wt.query_position,
       wt.where_clause_position,
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
            replace(
               replace(
                  replace(
                     replace(
                        replace(
                           replace(
                             replace(
                                  replace(
                                     replace( wt.where_clause,
                                            '&ORGANIZATION_ID',
                                             nvl(nao.organization_id,0)),
                                         '&SET_OF_BOOKS_ID',
                                          nvl(nao.set_of_books_id,0)),
                                      '&CURRENCY_CODE',
                                       nvl(nao.currency_code,'USD')),
                                   '&CHART_OF_ACCOUNTS_ID',
                                    nvl(nao.CHART_OF_ACCOUNTS_ID,101)),
                                '&COST_ORGANIZATION_ID',
                                 nvl(nao.cost_organization_id,0)),
                             '&MASTER_ORGANIZATION_ID',
                              nvl(nao.master_organization_id,0)),
                           '&BUSINESS_GROUP_ID', nvl(nao.business_group_id,0)),
                        '&ORG_ID', nvl(nao.org_id, 0)),
                     '&LEGISLATIVE_CODE', nvl(nao.legislative_code,'US')),
                  '&NOETIX_LANG', ':NOETIX_LANG'),
               '&APPS.',       n_popview_pkg.get_owner_name('APPS')||'.' ),
               '&CONCAT_NULL', ( case noetix_hint_pkg.is_rule_based_hint(wt.view_label)
                                   when  'T' then '||'''''
                                   else           '/* ||'''' */' 
                                 end ) ),
               '&PLUS_ZERO',   ( case noetix_hint_pkg.is_rule_based_hint(wt.view_label)
                                   when 'T' then '+0'
                                   else          '/* +0 */' 
                                 end ) ),
               '&APPLICATION_INSTANCE', nao.application_instance ),
               '&APPLICATION_LABEL', nao.application_label ),
               '&BALANCING_SEGMENT_COLUMN', ( case substr(v.application_instance,1,1) 
                                                when 'G' then '^BALANCING_SEGMENT_COLUMN' 
                                                else ( SELECT sattr.application_column_name  -- FEDERAL_GLOBAL
                                                         FROM fnd_segment_attribute_values_s sattr
                                                        WHERE sattr.application_id         = 101
                                                          AND sattr.segment_attribute_type = 'GL_BALANCING'      
                                                          AND sattr.attribute_value        = 'Y'
                                                          AND sattr.id_flex_code           = 'GL#'
                                                          AND sattr.id_flex_num            = nao.chart_of_accounts_id)
                                               end ) ),
               '&ACCOUNT_SEGMENT_COLUMN',   ( case substr(v.application_instance,1,1)
                                                when 'G' then '^ACCOUNT_SEGMENT_COLUMN'
                                                else ( SELECT sattr.application_column_name -- FEDERAL_GLOBAL
                                                         FROM fnd_segment_attribute_values_s sattr
                                                        WHERE sattr.application_id           = 101
                                                          AND sattr.segment_attribute_type   = 'GL_ACCOUNT'      
                                                          AND sattr.attribute_value          = 'Y'
                                                          AND sattr.id_flex_code             = 'GL#'
                                                          AND sattr.id_flex_num              = nao.CHART_OF_ACCOUNTS_ID)
                                               end ) ),
       'N',    -- generated_flag
       pot.profile_option,
       q.application_instance
  from n_profile_option_templates pot,
       n_view_where_templates     wt,
       n_application_owners       nao,
       n_view_queries             q,
       n_views                    v
 where v.view_name              = q.view_name
   and v.application_instance not like 'X%'    -- Excludes XOP
   and nao.application_label    = v.application_label
   and nao.application_instance = q.application_instance
   and wt.view_label            = q.view_label
   and wt.query_position        = q.query_position
   and wt.include_flag          = 'Y'
   and pot.profile_option (+)   = wt.profile_option
   and pot.include_flag (+)     = 'Y'
;
commit;

---**** Start FEDERAL_GLOBAL Code***---
--For Standard and XOP version views the inline subquery in the above query will replace the appropriate segment column.
--For Global version view the below script will replace the ^ACCOUNT_SEGMENT_COLUMN and ^BALANCING_SEGMENT_COLUMN variable.
--This code will be update n_view_wheres by substituting the variable with DECODE stmt containing chart_of_accounts_id and corresponding segment column.
--This script supports FV application and can be enchanced for other applications

DECLARE
    vs_seg_type              fnd_segment_attribute_values_s.segment_attribute_type%TYPE;
    vs_decode_string         n_view_wheres.where_clause%TYPE;
    vs_table_alias           n_view_tables.table_alias%TYPE;
    vn_row_count             NUMBER := 0;
    
CURSOR cur_view_where IS
SELECT nv.application_label,
       nvw.view_name,
       nvw.query_position,
       nvw.where_clause_position,
       nvw.where_clause 
  FROM n_views nv,
       n_view_wheres nvw
 WHERE nvw.view_name              = nv.view_name
   AND
     (    nvw.where_clause     like '%^ACCOUNT_SEGMENT_COLUMN%' 
       OR nvw.where_clause     like '%^BALANCING_SEGMENT_COLUMN%' )
   AND nv.application_label      in ('FV')
   AND nv.application_instance LIKE 'G%'
   FOR UPDATE OF nvw.where_clause;

CURSOR cur_coa_app_column (p_seg_type VARCHAR2,p_app_label VARCHAR2) IS
SELECT nao.chart_of_accounts_id,sattr.application_column_name,sattr.segment_attribute_type
  FROM fnd_segment_attribute_values_s    sattr,
       ( select chart_of_accounts_id, application_label
          from n_application_owners nao
          where chart_of_accounts_id is not null
          group by chart_of_accounts_id, 
                   application_label)                   nao
 WHERE sattr.application_id           = 101
   AND sattr.segment_attribute_type   = p_seg_type --IN('GL_ACCOUNT','GL_BALANCING')      
   AND sattr.attribute_value          = 'Y'
   AND sattr.id_flex_code             = 'GL#'
   AND sattr.id_flex_num              = nao.CHART_OF_ACCOUNTS_ID
   AND nao.application_label          = p_app_label;

BEGIN
   
   FOR rec_where IN cur_view_where
   LOOP 
      vs_decode_string := 'DECODE(XMAP.CHART_OF_ACCOUNTS_ID';
      
      IF instr(rec_where.where_clause,'^ACCOUNT_SEGMENT_COLUMN') > 1 THEN
         vs_seg_type := 'GL_ACCOUNT';
      ELSE
         vs_seg_type := 'GL_BALANCING';
      END IF;
      
      vs_table_alias := substr(substr(rec_where.where_clause,instr(rec_where.where_clause,'.^')-6,6),
                               instr(substr(rec_where.where_clause,instr(rec_where.where_clause,'.^')-6,6),' ')+1);
       
      FOR rec_coa IN cur_coa_app_column(vs_seg_type,rec_where.application_label)
      LOOP 
         vs_decode_string:= vs_decode_string||','||rec_coa.chart_of_accounts_id||','||vs_table_alias||'.'||rec_coa.application_column_name;
      END LOOP;
      
      vs_decode_string := vs_decode_string ||')';
      
      UPDATE n_view_wheres
         SET where_clause = replace( 
                                replace( where_clause, vs_table_alias||'.^ACCOUNT_SEGMENT_COLUMN', vs_decode_string ),
                                         vs_table_alias||'.^BALANCING_SEGMENT_COLUMN', vs_decode_string )
       WHERE view_name             = rec_where.view_name
         AND query_position        = rec_where.query_position
         AND where_clause_position = rec_where.where_clause_position;
      
      vn_row_count := vn_row_count + SQL%ROWCOUNT;
         
   END LOOP;
   
   dbms_output.put_line('Federal Global - no of records updated: '||vn_row_count);
END;
/
commit;
---**** End of FEDERAL_GLOBAL Code***---

-- The GLOBAL_INV_SOB variable is based on the global_org2sob column.
-- Since the contents of this column may be overflowed to the
-- n_application_owner_globals table, we need to handle this
-- individually from the other variable replacements.
declare
    cursor c1 is
    select v.view_name,
           v.view_label,
           w.query_position,
           w.where_clause_position,
           w.where_clause,
           w.generated_flag,
           w.profile_option,
           v.application_instance,
           v.application_label
      from n_view_wheres              w,
           n_views                    v
     where v.view_name               = w.view_name
       and v.application_instance NOT LIKE 'X%'    -- Excludes XOP
       and w.where_clause         LIKE '%&GLOBAL_INV_SOB%'
       for update of w.where_clause
    ;

    cursor c2( p_application_label      varchar2,
               p_application_instance   varchar2,
               p_decode                 varchar2 ) is
    select replace(nvl(nao.global_org2sob,'0,0'),'^DECODE',p_decode)    where_clause,
           0                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select replace(naog.value,'^DECODE',p_decode)                       where_clause,
           naog.sequence                                                sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_ORG2SOB'
     order by 2
    ;

    vs_where_clause          N_VIEW_WHERES.WHERE_CLAUSE%TYPE;
    vs_decode_string         N_VIEW_WHERES.WHERE_CLAUSE%TYPE;
    vs_end_string            N_VIEW_WHERES.WHERE_CLAUSE%TYPE;
    vi_variable_position     INTEGER                          := 0;
    vn_where_clause_position NUMBER                           := 0;

BEGIN
    for r1 in c1 loop
        -- Initial the variable for this where_clause line
        vi_variable_position := instrb(r1.where_clause,'&GLOBAL_INV_SOB');
        vs_where_clause      := substrb(r1.where_clause,1,vi_variable_position-1);
        vs_end_string        := substrb(r1.where_clause,vi_variable_position+lengthb('&GLOBAL_INV_SOB'));
        vs_decode_string     := rtrim(substrb(vs_where_clause,
                                              instrb(vs_where_clause,'DECODE(',-1),
                                              instrb(vs_where_clause,',',-1))
                                      ,', ');
        vn_where_clause_position := r1.where_clause_position;

        FOR r2 in c2( r1.application_label,
                      r1.application_instance,
                      vs_decode_string )        LOOP
            IF ( r2.sequence = 0 ) THEN
                -- Update the current string
                update n_view_wheres
                   set where_clause = vs_where_clause||r2.where_clause
                 where current of c1
                 ;
            ELSE
                -- Add another where clause line for the decode
                noetix_xop_pkg.insert_view_where(
                            i_view_name               => r1.view_name,
                            i_view_label              => r1.view_label,
                            i_query_position          => r1.query_position,
                            i_application_instance    => r1.application_instance,
                            io_where_clause_position  => vn_where_clause_position,
                            i_where_clause            => r2.where_clause,
                            i_profile_option          => r1.profile_option          );
            END IF;
        END LOOP;
        -- Now add back in the ending paren/string
        update n_view_wheres
           set where_clause = where_clause||vs_end_string
         where view_name             = r1.view_name
           and query_position        = r1.query_position
           and where_clause_position = vn_where_clause_position
            ;
    end loop;
END;
/
commit;

--
-- ##################################################################################
--
-- begin xorg
--     first, we will insert the needed where clauses into the non-template
--     tables and substitute the single-value configuration variables.  second,
--     we will update the clauses, substituting the correct values for the
--     configuration variables that have multiple values -- this happens in
--     xorgpop.sql
--
-- dglancy 18-Jun-99
--    Add &XOP_ORGID to the list.
--
prompt For these views, populate their view_wheres (xorg)
insert /*+ APPEND */ into n_view_wheres
     ( view_name,
       view_label,
       query_position,
       where_clause_position,
       where_clause,
       generated_flag,
       profile_option,
       application_instance
     )
select q.view_name,
       q.view_label,
       wt.query_position,
       wt.where_clause_position,
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
       replace(
         replace(
            replace(
               replace(
                  replace(
                        replace(
                           replace( wt.where_clause,
                           '&ORG_ID','^ORG_ID'),
                        '&ORGANIZATION_ID','^ORGANIZATION_ID'),
                     '&SET_OF_BOOKS_ID','^SET_OF_BOOKS_ID'),
                  '&CURRENCY_CODE','^CURRENCY_CODE'),
               '&CHART_OF_ACCOUNTS_ID',nvl(ao.CHART_OF_ACCOUNTS_ID,101)),
            '&COST_ORGANIZATION_ID','^COST_ORGANIZATION_ID'),
         '&MASTER_ORGANIZATION_ID', nvl(ao.master_organization_id,0)),
       '&BUSINESS_GROUP_ID',        nvl(ao.business_group_id,0)),
       '&LEGISLATIVE_CODE',         nvl(ao.legislative_code,'US')),
       '&NOETIX_LANG',              ':NOETIX_LANG'),
       '&APPS.',       n_popview_pkg.get_owner_name('APPS')||'.' ),
       '&CONCAT_NULL',              ( case noetix_hint_pkg.is_rule_based_hint(wt.view_label)
                                        when 'T' then '||'''''
                                        else          '/* ||'''' */' 
                                      end ) ),
       '&PLUS_ZERO',                ( case noetix_hint_pkg.is_rule_based_hint(wt.view_label)
                                        when 'T' then '+0' 
                                        else          '/* +0 */'
                                      end ) ),
       '&APPLICATION_INSTANCE',     ao.application_instance ),
       '&APPLICATION_LABEL',        ao.application_label ),
       '&BALANCING_SEGMENT_COLUMN', ( SELECT sattr.application_column_name
                                        FROM fnd_segment_attribute_values_s sattr
                                       WHERE sattr.application_id         = 101
                                         AND sattr.segment_attribute_type = 'GL_BALANCING'      
                                         AND sattr.attribute_value        = 'Y'
                                         AND sattr.id_flex_code           = 'GL#'
                                         AND sattr.id_flex_num            = ao.chart_of_accounts_id) ),
       '&ACCOUNT_SEGMENT_COLUMN', ( SELECT sattr.application_column_name
                                      FROM fnd_segment_attribute_values_s sattr
                                     WHERE sattr.application_id         = 101
                                       AND sattr.segment_attribute_type = 'GL_ACCOUNT'      
                                       AND sattr.attribute_value        = 'Y'
                                       AND sattr.id_flex_code           = 'GL#'
                                       AND sattr.id_flex_num            = ao.chart_of_accounts_id) ),
       'N', -- generated_flag
       pot.profile_option,
       q.application_instance
  from n_profile_option_templates pot,
       n_view_where_templates     wt,
       n_application_owners       ao,
       n_view_queries             q,
       n_views                    v
 where v.view_name              = q.view_name
   and v.application_instance like 'X%'    -- XOP Only
   and ao.application_label     = v.application_label
   and ao.application_instance  = q.application_instance
   and wt.view_label            = q.view_label
   and wt.query_position        = q.query_position
   and wt.include_flag          = 'Y'
   and pot.profile_option (+)   = wt.profile_option
   and pot.include_flag (+)     = 'Y'
;
commit
/

-- The XOP_ORGID variable is based on the global_orgs column.
-- Since the contents of this column may be overflowed to the
-- n_application_owner_globals table, we need to handle this
-- individually from the other variable replacements.
declare
    cursor c1 is
    select v.view_name,
           v.view_label,
           w.query_position,
           w.where_clause_position,
           w.where_clause,
           w.generated_flag,
           w.profile_option,
           v.application_instance,
           v.application_label
      from n_view_wheres              w,
           n_views                    v
     where v.view_name               = w.view_name
       and v.application_instance LIKE 'X%'
       and NVL(v.special_process_code,'NONE') = 'XOPORG'
       and w.where_clause         LIKE '%&XOP_ORGID%'
       for update of w.where_clause
    ;

    cursor c2( p_application_label      varchar2,
               p_application_instance   varchar2 ) is
    select nvl(replace(nao.global_orgs,')',',-9999)'),'(-9999)')        value,
           0                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select replace(naog.value,')',',-9999)')                            value,
           naog.sequence                                                sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_ORGS'
     order by 2
    ;

    vs_where_clause          N_VIEW_WHERES.WHERE_CLAUSE%TYPE;
    vs_end_string            N_VIEW_WHERES.WHERE_CLAUSE%TYPE;
    vi_variable_position     INTEGER                          := 0;
    vn_where_clause_position NUMBER                           := 0;
    vn_null                  NUMBER                           := NULL;
    vi_xop_count             INTEGER;

BEGIN
    for r1 in c1 loop
        -- Initialize the variable for this where_clause line
        vi_variable_position := instrb(r1.where_clause,'&XOP_ORGID');
        vs_where_clause      := substrb(r1.where_clause,1,vi_variable_position-1);
        vs_end_string        := substrb(r1.where_clause,vi_variable_position+lengthb('&XOP_ORGID'));
        vn_where_clause_position := r1.where_clause_position;

        select count(distinct xmap.ORG_ID)
          into vi_xop_count
          from n_application_org_mappings xmap
         where xmap.application_label      = r1.application_label
           and xmap.application_instance   = r1.application_instance;

        if vi_xop_count <= :OU_MAPPING_THRESHOLD then
            FOR r2 in c2( r1.application_label,
                          r1.application_instance  )        LOOP
                IF ( r2.sequence = 0 ) THEN
                    -- Update the current string
                    update n_view_wheres
                       set where_clause = vs_where_clause||' IN '||r2.value
                     where current of c1;
                ELSE
                    -- Add another where clause line for the decode
                    noetix_xop_pkg.insert_view_where(
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                i_application_instance    => r1.application_instance,
                                io_where_clause_position  => vn_where_clause_position,
                                i_where_clause            => r2.value,
                                i_profile_option          => r1.profile_option          );
                END IF;
            END LOOP;
            -- Now add back in the ending paren/string
            update n_view_wheres
               set where_clause = where_clause||vs_end_string
             where view_name             = r1.view_name
               and query_position        = r1.query_position
               and where_clause_position = vn_where_clause_position
                ;
        else
            if ( instr(UPPER(r1.where_clause),' NOT ') = 0 ) then
                -- Add join to n_xop_mappings
                noetix_xop_pkg.add_mapping_table_join(
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the where clause.
                update n_view_wheres w
                   set w.where_clause = replace(UPPER(w.where_clause),
                                                '&XOP_ORGID',' = XOP_MAP.ORG_ID ')
                 where current of c1;
            else
                -- Update the where clause.
                update n_view_wheres w
                   set w.where_clause = replace(UPPER(w.where_clause),
                                                '&XOP_ORGID',
                        ' IN ( SELECT XM1.ORG_ID '||
                                'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                               'WHERE XM1.APPLICATION_LABEL = '''||r1.application_label||''' '||
                                 'AND XM1.APPLICATION_INSTANCE = '''||r1.application_instance||''' ) ')
                 where current of c1;
            end if;
        end if;
    end loop;
END;
/
commit;

--
-- end xorg

-- ###############################################################################
--
--
prompt For these views, populate their view_columns.
--   The column_name is the same as the column_label in the template
--   except for KEY KEYD and KEYCAT   columns where 1st char is replaced by '#'
--   and    for SEG,SEGCAT            columns where 1st char is replaced by '!'
--   and    for ATTR,ATTRD            columns where 1st char is replaced by '^'
--   and    for ID                    columns where 1st char is replaced by '*'
--   and    for LOOK                  columns where 1st char is replaced by '+'
--
--   Temporarily store the key_view_label and lookup key_view_name later.
--   We will fix this in the next statement.
--
whenever sqlerror exit 29

--
insert /*+ APPEND */ into n_view_columns
     ( column_id,
       t_column_id,
       view_name,
       view_label,
       query_position,
       column_name,
       column_label,
       table_alias,
       column_expression,
       column_position,
       column_type,
       group_by_flag,
       gen_search_by_col_flag,
       lov_view_label,
       lov_column_label,
       description,
       ref_application_label,
       ref_owner,
       ref_table_name,
       metadata_ref_table_name,
       key_view_label,
       ref_lookup_column_name,
       ref_description_column_name,
       ref_lookup_type,
       generated_flag,
       profile_option,
       application_instance,
       id_flex_application_id,
       id_flex_code,
       format_class,
       format_mask
     )
select n_view_columns_seq.NEXTVAL,
       ct.t_column_ID,
       v.view_name,
       v.view_label,
       ct.query_position,
       -- Issue 5447 (UNICODE).  Did not translate the substr to substrb in the case where
       -- we were replacing 1 character with possible multi-char.
       ( case 
           when ( ct.column_type in ( 'KEY', 'KEYD', 'KEYCAT', 'AUTOJOIN', 'QUERYOBJECT') ) then
               rtrim('#'||substrb(ct.column_label,1,29))
           when ( ct.column_type in ( 'SEG', 'SEGCAT', 'SEGD', 'SEGP' ) ) then
               rtrim('!'||substrb(ct.column_label,1,29))
           when ( ct.column_type in ( 'ATTR', 'ATTRD' ) ) then
               rtrim('^'||substrb(ct.column_label,1,29))
           when ( ct.column_type  = 'ID' ) then
               '*'||substr(ct.column_label,2)
           when ( ct.column_type  = 'LOOK' ) then
               '+'||substr(ct.column_label,2)
           else
               ct.column_label
         end ),   -- column_name
       ct.column_label,
       ct.table_alias,
       replace(ct.column_expression,
               '&LEGISLATIVE_CODE',ao.legislative_code),
       ct.column_position,
       ct.column_type,
       ct.group_by_flag,
       ct.gen_search_by_col_flag,
       ct.lov_view_label,
       ct.lov_column_label,
       null,                   -- description (join with template to get it)
       ct.ref_application_label,
       NULL,     -- ref_owner
       ct.ref_table_name,
       ct.ref_table_name     metadata_ref_table_name,
       ct.key_view_label,
       ct.ref_lookup_column_name,
       ct.ref_description_column_name,
       replace(ct.ref_lookup_type,
               '&LEGISLATIVE_CODE',ao.legislative_code),
       'N',                    -- Generated_flag
       pot.profile_option,
       q.application_instance,
       ct.id_flex_application_id,
       ct.id_flex_code,
       ct.format_class,
       ct.format_mask
  from n_profile_option_templates pot,
       n_view_column_templates    ct,
       n_application_owners       ao,
       n_view_queries             q,
       n_views                    v
 where v.view_name             = q.view_name
   and ao.application_label    = v.application_label
   and ao.application_instance = v.application_instance
   and ao.application_instance = q.application_instance
   and v.application_instance  = q.application_instance
--   and ct.view_label           = v.view_label
   and ct.view_label           = q.view_label
   and ct.query_position       = q.query_position
   and ct.include_flag         = 'Y'
   and pot.profile_option (+)  = ct.profile_option
   and pot.include_flag (+)    = 'Y'
;
commit;
--
--  Now set the (key/lov)_view_name columns to be the view_name 
--  associated with the corresponding (key/lov)_view_label 
--
whenever sqlerror exit 30

prompt For these columns populate their key_view_name and lov_view_name
update n_view_columns vcol
   set vcol.key_view_name = (
           select kv.view_name
             from n_application_xref x,
                  n_view_templates   vtmpl,
                  n_views            kv
            where kv.view_label              = vcol.key_view_label
              and vtmpl.view_label           = vcol.view_label
              and x.application_label        = vtmpl.application_label
              and x.application_instance     = vcol.application_instance
              and x.ref_application_label    = kv.application_label
              and x.ref_application_instance = kv.application_instance ),
       vcol.lov_view_name = (
           select lv.view_name
             from n_application_xref x,
                  n_view_templates   vtmpl,
                  n_views            lv
            where lv.view_label              = vcol.lov_view_label
              and vtmpl.view_label           = vcol.view_label
              and x.application_label        = vtmpl.application_label
              and x.application_instance     = vcol.application_instance
              and x.ref_application_label    = lv.application_label
              and x.ref_application_instance = lv.application_instance )
 where vcol.key_view_label is not null
    or vcol.lov_view_label is not null
;
commit;
--    when we populate these columns we substitute in the values
--    for any '&ORGANIZATON_ID'       and '&SET_OF_BOOKS_ID'
--        and '&CURRENCY_CODE'        and '&CHART_OF_ACCOUNTS_ID'
--        and '&COST_ORGANIZATION_ID' and '&MASTER_ORGANIZATION_ID'

prompt For these columns fill in configuration variables

update n_view_columns c
   set column_expression =
       ( select
           replace(
           replace(
           replace(
           replace(
           replace(
           replace(
           replace(
               replace(
                   replace(
                       replace(
                           replace(
                               replace(
                                   replace(
                                       replace( c.column_expression,
                                       '&ORGANIZATION_ID',nvl(ao.organization_id,0)),
                                   '&SET_OF_BOOKS_ID',nvl(ao.set_of_books_id,0)),
                                   '&LEDGER_ID',nvl(ao.set_of_books_id,0)),
                               '&CURRENCY_CODE',nvl(ao.currency_code,'USD')),
                           '&CHART_OF_ACCOUNTS_ID',nvl(ao.chart_of_accounts_id,101)),
                       '&COST_ORGANIZATION_ID',nvl(ao.cost_organization_id,0)),
                   '&MASTER_ORGANIZATION_ID',nvl(ao.master_organization_id,0)),
               '&BUSINESS_GROUP_ID',nvl(ao.business_group_id,0)),
           '&LEGISLATIVE_CODE',nvl(ao.legislative_code,'US')),
           '&NOETIX_LANG',            ':NOETIX_LANG'),
           '&APPS.',                  n_popview_pkg.get_owner_name('APPS')||'.' ),
           '&APPLICATION_INSTANCE',   ao.application_instance ),
           '&APPLICATION_LABEL',      ao.application_label ),
           '&ACCOUNT_SEGMENT_COLUMN', ( SELECT sattr.application_column_name
                                          FROM fnd_segment_attribute_values_s sattr
                                         WHERE sattr.application_id         = 101
                                           AND sattr.segment_attribute_type = 'GL_ACCOUNT'
                                           AND sattr.attribute_value        = 'Y'
                                           AND sattr.id_flex_code           = 'GL#'
                                           AND sattr.id_flex_num            = ao.chart_of_accounts_id) )
            from n_application_owners ao,
                 n_views              v
           where v.view_name             = c.view_name
             and ao.application_label    = v.application_label
             and ao.application_instance = c.application_instance )
 where column_expression like '%&%'
;
commit;
--
-- begin xorg
--    update column expressions to include a range of values if needed
--
set scan off
--    when we populate these columns we substitute in the values
--    for any '&ORGANIZATON_ID'       and '&SET_OF_BOOKS_ID'
--        and '&CURRENCY_CODE'        and '&CHART_OF_ACCOUNTS_ID'
--        and '&COST_ORGANIZATION_ID' and '&MASTER_ORGANIZATION_ID'
prompt For these columns fill in configuration variables (xorg)
update n_view_columns c
   set c.column_expression =
       ( select
           decode(instrb(c.column_expression,'&ACCOUNT_SEGMENT_COLUMN'),0,
           decode(instrb(c.column_expression,'&NOETIX_LANG'),0,
           decode(instrb(c.column_expression,'&ORGANIZATION_ID'),0,
           decode(instrb(c.column_expression,'&SET_OF_BOOKS_ID'),0,
               decode(instrb(c.column_expression,'&CURRENCY_CODE'),0,
                   decode(instrb(c.column_expression,'&CHART_OF_ACCOUNTS_ID'),0,
                       decode(instrb(c.column_expression,'&COST_ORGANIZATION_ID'),0,
                           decode(instrb(c.column_expression,'&MASTER_ORGANIZATION_ID'),0,
                                  c.column_expression,
                                  replace(c.column_expression,'&MASTER_ORGANIZATION_ID',
                                          nvl(ao.master_organization_id,0))),
                              replace(replace(c.column_expression,'=',' IN '),'&COST_ORGANIZATION_ID',
                                      '( SELECT XM1.COST_ORGANIZATION_ID '||
                                          'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                                         'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                                           'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
                          replace(c.column_expression,'&CHART_OF_ACCOUNTS_ID',
                                  nvl(ao.chart_of_accounts_id,101))),
                      replace(replace(c.column_expression,'=',' IN '),'''&CURRENCY_CODE''',
                              '( SELECT XM1.CURRENCY_CODE '||
                                  'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                                 'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                                   'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) '||
                                 'UNION ALL '||
                                 'SELECT ''USD'' '||
                                   'FROM DUAL ) '       )),
               replace(replace(c.column_expression,'=',' IN '),'&SET_OF_BOOKS_ID',
                       '( SELECT XM1.SET_OF_BOOKS_ID '||
                           'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                          'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                            'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
               replace(replace(c.column_expression,'=',' IN '),'&ORGANIZATION_ID',
                       '( SELECT XM1.ORGANIZATION_ID '||
                           'FROM N_APPLICATION_ORG_MAPPINGS XM1 '||
                          'WHERE XM1.APPLICATION_LABEL = '''||ao.application_label||''' '||
                            'AND XM1.APPLICATION_INSTANCE = '''||ao.application_instance||''' ) ')),
               replace(replace(C.COLUMN_EXPRESSION,'=',' IN '),
                       '&NOETIX_LANG',':NOETIX_LANG')),
               replace(c.column_expression,
                       '&ACCOUNT_SEGMENT_COLUMN',( SELECT sattr.application_column_name
                                                     FROM fnd_segment_attribute_values_s sattr
                                                    WHERE sattr.application_id         = 101
                                                      AND sattr.segment_attribute_type = 'GL_ACCOUNT'      
                                                      AND sattr.attribute_value        = 'Y'
                                                      AND sattr.id_flex_code           = 'GL#'
                                                      AND sattr.id_flex_num            = ao.CHART_OF_ACCOUNTS_ID)))
         from n_application_owners ao,
              n_views              v
        where v.view_name             = c.view_name
          and ao.application_label    = v.application_label
          and ao.application_instance = v.application_instance )
 where c.column_expression        like '%&%'
   and c.application_instance     like 'X%'
;

commit;

-- --------------------------------------------------------------------------
--                Populate Column Properties
-- --------------------------------------------------------------------------
--   The column label and column names are both got from n_view_columns.
--   The column names whose first character has been changed are used as 
--   part of the foreign key in the column properties.
--
prompt For these columns, populate their view_column_properties.
whenever sqlerror exit 31

insert into n_view_properties
     ( view_property_id,
       t_view_property_id,
       view_label,
       view_name,
       query_position,
       property_type_id,
       t_source_pk_id,
       source_pk_id,
       value1,
       value2,
       value3,
       value4,
       value5,
       profile_option,
       omit_flag)
select n_view_properties_seq.NEXTVAL,
       cpt.t_view_property_ID,
       q.view_label,
       q.view_name,      
       q.query_position,
       cpt.property_type_id,
       c.t_column_ID,
       c.column_id,
       cpt.value1,
       cpt.value2,
       cpt.value3,
       cpt.value4,
       cpt.value5,
       cpt.profile_option,
       'N'
  from n_views                    v,
       n_view_queries             q,
       n_application_owners       ao,
       n_view_property_templates  cpt,
       n_property_type_templates  ptype,
       n_view_columns             c
 where v.view_name                = q.view_name
   and v.application_label        = ao.application_label
   and v.application_instance     = ao.application_instance
   and (    substr(v.application_instance,1,1)          = 'G' 
         or (     substr(v.application_instance,1,1)    = 'X' 
              and ptype.property_type              = 'AUTOJOIN_ASSISTANT' )   )
   and NVL(v.omit_flag,'N')       = 'N'
   and q.application_instance     = v.application_instance
   and NVL(q.omit_flag,'N')       = 'N'
   and q.view_name                = c.view_name
   and q.query_position           = c.query_position
   and NVL(c.omit_flag,'N')       = 'N'
   and c.generated_flag           = 'N'
   and cpt.view_label             = c.view_label
   and cpt.query_position         = c.query_position
   and cpt.t_source_pk_id         = c.t_column_id
   and cpt.include_flag           = 'Y'
   and ptype.property_type_ID     = cpt.property_type_id
   and ptype.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES';


commit;

-- --------------------------------------------------------------------------
--                Populate Join Keys
-- --------------------------------------------------------------------------
--   There are now two parts to the join key records.  The first part is the header definition
--   and can be done at this point.  The n_join_key_col_templates information must be done later as
--   the columns have not been defined yet.
--   Also, only processing the joins where the join_key_context_Code  is null.
--   DIM, HIER, and KFF are going to be processed separately.
--
--   NOTE:  ROWID column type will be inserted for all instances.
--          COL column type join keys will only be inserted for global or site level applications.
--
-- Start with the PK records
insert /*+ APPEND */ into n_join_keys 
     ( join_key_id,
       t_join_key_id,
       view_label,
       view_name,
       key_name,
       description,
       join_key_context_code,
       key_type_code,
       column_type_code,
       outerjoin_flag,
       outerjoin_direction_code,
       key_rank,
       pl_ref_pk_view_name_modifier,
       pl_rowid_col_name_modifier,
       key_cardinality_code,
       referenced_pk_join_key_id,
       referenced_pk_t_join_key_id,
       profile_option,
       omit_flag,
       user_omit_flag )
SELECT n_join_keys_seq.nextval,                         -- JOIN_KEY_ID,
       join.t_join_key_id,
       join.view_label,
       join.view_name,
       join.key_name,
       join.description,
       join.join_key_context_code,
       join.key_type_code,
       join.column_type_code,
       join.outerjoin_flag,
       join.outerjoin_direction_code,
       join.key_rank,
       join.pl_ref_pk_view_name_modifier,
       join.pl_rowid_col_name_modifier,
       join.key_cardinality_code,
       join.referenced_pk_join_key_id,
       join.referenced_pk_t_join_key_id,
       join.profile_option,
       join.omit_flag,
       join.user_omit_flag
  FROM ( SELECT jk.t_join_key_id,                                -- T_JOIN_KEY_ID,
                v.view_label,                                    -- VIEW_LABEL,
                v.view_name,                                     -- VIEW_NAME,
                jk.key_name,                                     -- KEY_NAME,
                jk.description,                                  -- DESCRIPTION,
                jk.join_key_context_code,                        -- JOIN_KEY_CONTEXT_CODE,
                jk.key_type_code,                                -- KEY_TYPE_CODE,
                jk.column_type_code,                             -- COLUMN_TYPE_CODE,
                jk.outerjoin_flag,                               -- OUTERJOIN_FLAG,
                jk.outerjoin_direction_code,                     -- OUTERJOIN_DIRECTION_CODE,
                jk.key_rank,                                     -- KEY_RANK,
                jk.pl_ref_pk_view_name_modifier,                 -- PL_REF_PK_VIEW_NAME_MODIFIER,
                jk.pl_rowid_col_name_modifier,                   -- PL_ROWID_COL_NAME_MODIFIER,
                jk.key_cardinality_code,                         -- key_cardinality_code,
                to_char(null)                        referenced_pk_join_key_id,
                jk.referenced_pk_t_join_key_id,                  -- REFERENCED_PK_T_JOIN_KEY_ID,
                jk.profile_option,                               -- PROFILE_OPTION,
                to_char(null)                        omit_flag,
                to_char(null)                        user_omit_flag
           FROM n_join_key_templates jk,
                n_views              v
          WHERE jk.key_type_code              = 'PK'
            AND jk.column_type_code           = 'ROWID'
            AND NVL(jk.join_key_context_code,'NONE')
                                              = 'NONE'
            AND nvl(jk.include_flag,'Y')      = 'Y'
            AND v.view_label                  = jk.view_label
            AND exists
              ( SELECT 'Role View record exists'
                  FROM n_role_views rv
                 WHERE rv.view_name                  = v.view_name )
          UNION ALL
         SELECT jk.t_join_key_id,                                -- T_JOIN_KEY_ID,
                v.view_label,                                    -- VIEW_LABEL,
                v.view_name,                                     -- VIEW_NAME,
                jk.key_name,                                     -- KEY_NAME,
                jk.description,                                  -- DESCRIPTION,
                jk.join_key_context_code,                        -- JOIN_KEY_CONTEXT_CODE,
                jk.key_type_code,                                -- KEY_TYPE_CODE,
                jk.column_type_code,                             -- COLUMN_TYPE_CODE,
                jk.outerjoin_flag,                               -- OUTERJOIN_FLAG,
                jk.outerjoin_direction_code,                     -- OUTERJOIN_DIRECTION_CODE,
                jk.key_rank,                                     -- KEY_RANK,
                jk.pl_ref_pk_view_name_modifier,                 -- PL_REF_PK_VIEW_NAME_MODIFIER,
                jk.pl_rowid_col_name_modifier,                   -- PL_ROWID_COL_NAME_MODIFIER,
                jk.key_cardinality_code,                         -- KEY_CARDINALITY_CODE,
                to_char(null)                   referenced_pk_join_key_id,
                jk.referenced_pk_t_join_key_id,                  -- REFERENCED_PK_T_JOIN_KEY_ID,
                jk.profile_option,                               -- PROFILE_OPTION,
                to_char(null)                   omit_flag,
                to_char(null)                   user_omit_flag
           FROM n_join_key_templates             jk,
                n_views                          v,
                n_application_owner_templates    aot
          WHERE jk.key_type_code              = 'PK'
            AND jk.column_type_code           = 'COL'
            AND NVL(jk.join_key_context_code,'NONE')
                                              = 'NONE'
            AND nvl(jk.include_flag,'Y')      = 'Y'
            AND v.view_label                  = jk.view_label
            AND aot.application_label         = v.application_label
            AND 
              (    v.application_instance     like 'G0'
                OR aot.context_code             in ( 'SITE', 'NONE' ) ) 
            AND exists
              ( SELECT 'Role View record exists'
                  FROM n_role_views rv
                 WHERE rv.view_name                  = v.view_name )     ) join;

commit;

--set serveroutput off
--set serveroutput on size :MAX_SERVEROUTPUT_SIZE

-- Now do the FK records
DECLARE
    CURSOR c_fk_joins IS
    SELECT jk.t_join_key_id,                                -- T_JOIN_KEY_ID,
           v.view_label,                                    -- VIEW_LABEL,
           v.view_name,                                     -- VIEW_NAME,
           v.application_label,
           v.application_instance,
           jk.key_name,                                     -- KEY_NAME,
           jk.description,                                  -- DESCRIPTION,
           jk.join_key_context_code,                        -- JOIN_KEY_CONTEXT_CODE,
           jk.key_type_code,                                -- KEY_TYPE_CODE,
           jk.column_type_code,                             -- COLUMN_TYPE_CODE,
           jk.outerjoin_flag,                               -- OUTERJOIN_FLAG,
           jk.outerjoin_direction_code,                     -- OUTERJOIN_DIRECTION_CODE,
           jk.key_rank,                                     -- KEY_RANK,
           jk.pl_ref_pk_view_name_modifier,                 -- PL_REF_PK_VIEW_NAME_MODIFIER,
           jk.pl_rowid_col_name_modifier,                   -- PL_ROWID_COL_NAME_MODIFIER,
           jk.key_cardinality_code,                         -- KEY_CARDINALITY_CODE,
           jk.referenced_pk_t_join_key_id,                  -- REFERENCED_PK_T_JOIN_KEY_ID,
           jk.profile_option,                               -- PROFILE_OPTION,
           to_char(null)                         OMIT_FLAG,
           to_char(null)                         USER_OMIT_FLAG
      FROM n_join_key_templates jk,
           n_views              v
     WHERE jk.key_type_code                 = 'FK'
       AND jk.column_type_code              = 'ROWID'
       AND NVL(jk.join_key_context_code,'NONE')
                                            = 'NONE'
       AND nvl(jk.include_flag,'Y')         = 'Y'
       AND v.view_label                     = jk.view_label
       AND exists
         ( SELECT 'Role View record exists'
             FROM n_role_views rv
            WHERE rv.view_name                  = v.view_name )
     UNION ALL
    SELECT jk.t_join_key_id,                                -- T_JOIN_KEY_ID,
           v.view_label,                                    -- VIEW_LABEL,
           v.view_name,                                     -- VIEW_NAME,
           v.application_label,
           v.application_instance,
           jk.key_name,                                     -- KEY_NAME,
           jk.description,                                  -- DESCRIPTION,
           jk.join_key_context_code,                        -- JOIN_KEY_CONTEXT_CODE,
           jk.key_type_code,                                -- KEY_TYPE_CODE,
           jk.column_type_code,                             -- COLUMN_TYPE_CODE,
           jk.outerjoin_flag,                               -- OUTERJOIN_FLAG,
           jk.outerjoin_direction_code,                     -- OUTERJOIN_DIRECTION_CODE,
           jk.key_rank,                                     -- KEY_RANK,
           jk.pl_ref_pk_view_name_modifier,                 -- PL_REF_PK_VIEW_NAME_MODIFIER,
           jk.pl_rowid_col_name_modifier,                   -- PL_ROWID_COL_NAME_MODIFIER,
           jk.key_cardinality_code,                         -- KEY_CARDINALITY_CODE,
           jk.referenced_pk_t_join_key_id,                  -- REFERENCED_PK_T_JOIN_KEY_ID,
           jk.profile_option,                               -- PROFILE_OPTION,
           to_char(null)                      OMIT_FLAG,
           to_char(null)                      USER_OMIT_FLAG
      FROM n_join_key_templates             jk,
           n_views                          v,
           n_application_owner_templates    aot
     WHERE jk.key_type_code              = 'FK'
       AND jk.column_type_code           = 'COL'
       AND NVL(jk.join_key_context_code,'NONE')
                                         = 'NONE'
       AND nvl(jk.include_flag,'Y')      = 'Y'
       AND v.view_label                  = jk.view_label
       AND aot.application_label         = v.application_label
       AND 
         (    v.application_instance     like 'G0'
           OR aot.context_code             in ( 'SITE', 'NONE' ) )
       AND exists
         ( SELECT 'Role View record exists'
             FROM n_role_views rv
            WHERE rv.view_name                  = v.view_name )
     ORDER BY 3, 6;
    
    CURSOR c_ref_pk_join_key_id( p_ref_pk_t_join_key_id    INTEGER,
                                 p_application_label       VARCHAR2,
                                 p_application_instance    VARCHAR2  ) IS
    SELECT jpk.join_key_id
      FROM n_join_keys        jpk,
           n_views            v_pk,
           n_application_xref xref
     WHERE jpk.t_join_key_id               = p_ref_pk_t_join_key_id
       AND v_pk.view_name                  = jpk.view_name
       AND xref.application_label          = p_application_label
       AND xref.application_instance       = p_application_instance
       AND xref.ref_application_label      = v_pk.application_label
       AND xref.ref_application_instance   = v_pk.application_instance;

    TYPE ltyp_join_keys  IS TABLE of n_join_keys%ROWTYPE    INDEX BY BINARY_INTEGER;
    ltab_join_keys              ltyp_join_keys;

    li_join_key_id_count        BINARY_INTEGER;
    li_insert_count             BINARY_INTEGER;
    li_rec_processed            BINARY_INTEGER;

    li_ref_pk_join_key_id     INTEGER;

    PROCEDURE save_info IS
    BEGIN
        IF ( ltab_join_keys.COUNT > 0 ) THEN
            -- set the omit_flag on the view.
            FORALL j in 1 .. ltab_join_keys.COUNT SAVE EXCEPTIONS
            INSERT /*+ APPEND */ into n_join_keys
            VALUES ltab_join_keys(j);
            --
            li_insert_count := 1;
            ltab_join_keys.DELETE;
            li_rec_processed := li_rec_processed + SQL%ROWCOUNT ;
            commit;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            if ( SQL%BULK_EXCEPTIONS.count > 0 ) THEN
                FOR k in 1 .. SQL%BULK_EXCEPTIONS.count LOOP
                  IF ( SQL%BULK_EXCEPTIONS(k).error_code <> 0 ) THEN
                    --
                    noetix_utility_pkg.Add_Installation_Message(
                                p_script_name   => 'popview',
                                p_location      => 'Populating the FK records into n_join_keys.',
                                p_message_type  => 'ERROR',
                                p_message       =>
                                    sqlerrm(-SQL%BULK_EXCEPTIONS(k).error_code)||
                                    '  The FK record was not inserted.  '||
                                    't_join_key_id: '||ltab_join_keys(SQL%BULK_EXCEPTIONS(k).error_index).t_join_key_id||
                                    ' / View Name: '||ltab_join_keys(SQL%BULK_EXCEPTIONS(k).error_index).view_name||
                                    ' / Key Name: '||ltab_join_keys(SQL%BULK_EXCEPTIONS(k).error_index).key_name );
                    --
                  END IF;
                END LOOP;
            END IF;
    END save_info;

BEGIN
    li_rec_processed := 0;
    li_insert_count  := 1;
    ltab_join_keys.DELETE;

    FOR r1 in c_fk_joins LOOP
      BEGIN
        li_join_key_id_count := 0;
        FOR r2 in c_ref_pk_join_key_id( r1.referenced_pk_t_join_key_id,
                                        r1.application_label,
                                        r1.application_instance ) LOOP
            li_ref_pk_join_key_id      := r2.join_key_id;
            li_join_key_id_count       := li_join_key_id_count+1;
        END LOOP;
        --
        if ( li_join_key_id_count = 0  ) THEN
            -- Don't insert, but flag as a warning
            --
            noetix_utility_pkg.Add_Installation_Message(
                        p_script_name   => 'popview',
                        p_location      => 'Populating the FK records into n_join_keys.',
                        p_message_type  => 'WARNING',
                        p_message       =>
                            'Could not find the referenced_pk_join_key_id record (PK View is probably suppressed).  This FK record will not be inserted.  '||
                            't_join_key_id: '||r1.t_join_key_id||
                            ' / View Name: '||r1.view_name||
                            ' / Key Name: '||r1.key_name );
            --
        ELSIF ( li_join_key_id_count > 1  ) THEN
            -- Don't insert, but flag as a warning
            --
            noetix_utility_pkg.Add_Installation_Message(
                        p_script_name   => 'popview',
                        p_location      => 'Populating the FK records into n_join_keys.',
                        p_message_type  => 'WARNING',
                        p_message       =>
                            'There appears to be multiple table matches for this referenced_pk_join_key_id record.  The FK record will not be inserted.  '||
                            't_join_key_id: '||r1.t_join_key_id||
                            ' / View Name: '||r1.view_name||
                            ' / Key Name: '||r1.key_name );
            --
        ELSE
            -- Add to the insert list
            SELECT n_join_keys_seq.nextval
              INTO ltab_join_keys(li_insert_count).join_key_id
              FROM DUAL;
            --
            ltab_join_keys(li_insert_count).t_join_key_id                  := r1.t_join_key_id;
            ltab_join_keys(li_insert_count).view_label                     := r1.view_label;
            ltab_join_keys(li_insert_count).view_name                      := r1.view_name;
--            ltab_join_keys(li_insert_count).application_label              := r1.application_label;
--            ltab_join_keys(li_insert_count).application_instance           := r1.application_instance;
            ltab_join_keys(li_insert_count).key_name                       := r1.key_name;
            ltab_join_keys(li_insert_count).description                    := r1.description;
            ltab_join_keys(li_insert_count).join_key_context_code          := r1.join_key_context_code;
            ltab_join_keys(li_insert_count).key_type_code                  := r1.key_type_code;
            ltab_join_keys(li_insert_count).column_type_code               := r1.column_type_code;
            ltab_join_keys(li_insert_count).outerjoin_flag                 := r1.outerjoin_flag;
            ltab_join_keys(li_insert_count).outerjoin_direction_code       := r1.outerjoin_direction_code;
            ltab_join_keys(li_insert_count).key_rank                       := r1.key_rank;
            ltab_join_keys(li_insert_count).pl_ref_pk_view_name_modifier   := r1.pl_ref_pk_view_name_modifier;
            ltab_join_keys(li_insert_count).pl_rowid_col_name_modifier     := r1.pl_rowid_col_name_modifier;
            ltab_join_keys(li_insert_count).key_cardinality_code           := r1.key_cardinality_code;
            ltab_join_keys(li_insert_count).referenced_pk_join_key_id      := li_ref_pk_join_key_id;
            ltab_join_keys(li_insert_count).referenced_pk_t_join_key_id    := r1.referenced_pk_t_join_key_id;
            ltab_join_keys(li_insert_count).profile_option                 := r1.profile_option;
            ltab_join_keys(li_insert_count).omit_flag                      := r1.omit_flag;
            ltab_join_keys(li_insert_count).user_omit_flag                 := r1.user_omit_flag;
            --
            li_insert_count := li_insert_count+1;
        END IF;

        -- Insert what we've processed so far
        IF ( li_insert_count >= 1000 ) THEN
            save_info;
        END IF;

      EXCEPTION
        WHEN OTHERS THEN
            --
            noetix_utility_pkg.Add_Installation_Message(
                        p_script_name   => 'popview',
                        p_location      => 'Populating the FK records into n_join_keys.',
                        p_message_type  => 'ERROR',
                        p_message       => sqlerrm );
            --
      END;
    END LOOP;

    -- Insert what we've processed so far
    save_info;

    -- Show how much we processed.
    dbms_output.put_line( 'n_join_keys FK records - '||li_rec_processed||' rows inserted.' );
END;
/
commit;

-- Now insert the n_join_key_columns records.
-- For ROWID column types, the column_label and name will be the same.  
-- JoinTO will later update the column_name with the final column_name.
-- For COL column_types, we expect the column_label to be the same with the exception of the ones where the 
-- kff_table_pk_column_name is populated
INSERT INTO n_join_key_columns
     ( join_key_column_id,
       t_join_key_column_id,
       join_key_id,
       t_join_key_id,
       column_position,
       column_name,
       column_label )
SELECT n_join_key_columns_seq.nextval,
       jkc.t_join_key_column_id,
       jk.join_key_id,
       jkc.t_join_key_id,
       jkc.t_column_position,
       ( CASE 
           WHEN ( jkc.kff_table_pk_column_name is not null) THEN jkc.column_label||'$'||jkc.kff_table_pk_column_name
           ELSE jkc.column_label
         END ),
       jkc.column_label
  FROM n_join_key_col_templates    jkc,
       n_join_keys                 jk
 WHERE NVL(jk.join_key_context_code,'NONE') = 'NONE'
   AND jk.t_join_key_id                     = jkc.t_join_key_id;


-- ---------------------------------------------------------
--                 Populate Questions
-- ---------------------------------------------------------
--    Populate questions linked to views in n_views.
--
prompt  Populate the questions.
whenever sqlerror exit 32
--
insert /*+ APPEND */ into n_help_questions
     ( question_id,
       t_question_id,
       view_name,
       view_label,
       application_label,
       application_instance,
       question,
       question_position,
       business_value,
       hint,
       keywords,
       profile_option,
       omit_flag,
       created_by,
       creation_date
     )
select n_help_question_seq.nextval,
       hqt.t_question_id,
       v.view_name,
       hqt.view_label,
       v.application_label,
       v.application_instance,
       hqt.question,
       hqt.question_position,
       hqt.business_value,
       hqt.hint,
       hqt.keywords,
       hqt.profile_option,
       NULL,                                        -- omit_flag
       'NOETIX',                                    -- created_by
       SYSDATE                                      -- creation_date
  from n_views                    v,
       n_help_questions_templates hqt
 where v.view_label               = hqt.view_label
   and nvl(hqt.include_flag, 'Y') = 'Y'
   and nvl(v.omit_flag, 'N')      = 'N'
;
commit;

-- ---------------------------------------------------------
--            Populate N_Seg_Key_Flexfields
-- ---------------------------------------------------------
--  Populate individual key flexfield table used in global.
--
--
-- NOTE: Although this table is being used, Heidi and I think that it is no longer necessary 
--       As the usage in popview never populates the non-templates version of this table in the legacy
--       global seg processing.
-- TODO: Will delete later if we can figure out if it is never used.  REF. segglbp and segglip.sql.

prompt  Populate the individual key flexfield table.

insert /*+ APPEND */ into n_seg_key_flexfields
     ( flexfield_application_label,
       id_flex_code,
       structure_application_label,
       individual_view_label,
       individual_view_name,
       required_flag  )
select seg.flexfield_application_label,
       seg.id_flex_code,
       seg.structure_application_label,
       seg.individual_view_label,
       v.view_name, -- individual_view_name
       'N' -- required_flag
  from n_views                       v,
       n_seg_key_flexfield_templates seg
 where seg.individual_view_label    = v.view_label
   and v.application_instance    like 'G%'
   and nvl(v.omit_flag, 'N')        = 'N'
;
--
commit;

--
set scan on
--
-- ##########################################################################
--
whenever sqlerror exit 31


prompt Removing profile options unused by views,queries,where,tables or columns
-- disable the constraints temporarily.  This greatly improves performance of the delete.
alter table n_views          disable constraint n_views_fk2;
alter table n_view_queries   disable constraint n_view_queries_fk2;
alter table n_view_tables    disable constraint n_view_tables_fk2;
alter table n_view_columns   disable constraint n_view_columns_fk2;
alter table n_view_wheres    disable constraint n_view_wheres_fk2;

-- look at profile options used by answer template tables, since answer tables
-- have not been instantiated yet.  The application instance will be retrieved
-- from the instantiated help_questions table.
set serveroutput on size :MAX_SERVEROUTPUT_SIZE
declare 
    CURSOR c_profiles IS
    select po1.profile_option,
           po1.application_instance
      from n_profile_options po1
     minus
         ( select v.profile_option,
                  v.application_instance
             from n_views v
            where v.profile_option is not null
            union
           select q.profile_option,
                  q.application_instance
             from n_view_queries q
            where q.profile_option is not null
            union
           select w.profile_option,
                  w.application_instance
             from n_view_wheres w
            where w.profile_option is not null
            union
           select t.profile_option,
                  t.application_instance
             from n_view_tables t
            where t.profile_option is not null
            union
           select c.profile_option,
                  c.application_instance
             from n_view_columns c
            where c.profile_option is not null
            union 
           select cp.profile_option,
                  v.application_instance
             from n_views           v,
                  n_view_properties cp
            where cp.profile_option is not null 
              and v.view_name     = cp.view_name
            UNION
           select hq.profile_option,
                  hq.application_instance
             from n_help_questions   hq
            where hq.profile_option is not null    )
            minus
                ( select a.profile_option,
                         hq.application_instance
                    from n_help_questions   hq,
                         n_answer_templates a
                   where a.profile_option is not null
                     and a.t_question_id   = hq.t_question_id
                   union all
                  select aq.profile_option,
                         hq.application_instance
                    from n_help_questions      hq,
                         n_answer_templates    a,
                         n_ans_query_templates aq
                   where aq.profile_option is not null
                     and aq.t_answer_id     = a.t_answer_id
                     and a.t_question_id    = hq.t_question_id
                   union all
                  select att.profile_option,
                         hq.application_instance
                    from n_help_questions      hq,
                         n_answer_templates    a,
                         n_ans_table_templates att
                   where att.profile_option is not null
                     and att.t_answer_id     = a.t_answer_id
                     and a.t_question_id     = hq.t_question_id
                   union all
                  select aw.profile_option,
                         hq.application_instance
                    from n_help_questions      hq,
                         n_answer_templates    a,
                         n_ans_where_templates aw
                   where aw.profile_option is not null
                     and aw.t_answer_id     = a.t_answer_id
                     and a.t_question_id    = hq.t_question_id
                   union all
                  select ac.profile_option,
                         hq.application_instance
                    from n_help_questions       hq,
                         n_answer_templates     a,
                         n_ans_column_templates ac
                   where ac.profile_option is not null
                     and ac.t_answer_id     = a.t_answer_id
                     and a.t_question_id    = hq.t_question_id
                   union all
                  select ap.profile_option,
                         hq.application_instance
                    from n_help_questions      hq,
                         n_answer_templates    a,
                         n_ans_param_templates ap
                   where ap.profile_option is not null
                     and ap.t_answer_id     = a.t_answer_id
                     and a.t_question_id    = hq.t_question_id
                   union all
                  select apv.profile_option,
                         hq.application_instance
                    from n_help_questions   hq,
                         n_answer_templates a,
                         n_ans_param_value_templates apv
                   where apv.profile_option is not null
                     and apv.t_answer_id     = a.t_answer_id
                     and a.t_question_id     = hq.t_question_id
                   union all
                  select act.profile_option,
                         hq.application_instance
                    from n_help_questions   hq,
                         n_answer_templates a,
                         n_ans_column_total_templates act
                   where act.profile_option is not null
                     and act.t_answer_id     = a.t_answer_id
                     and a.t_question_id     = hq.t_question_id
           );
    TYPE typ_profile_array IS TABLE of n_profile_options.profile_option%TYPE       INDEX BY BINARY_INTEGER;
    TYPE typ_ai_array      IS TABLE of n_profile_options.application_instance%TYPE INDEX BY BINARY_INTEGER;
    
    lt_profile_option       typ_profile_array;
    lt_application_instance typ_ai_array;
    li_row_count            BINARY_INTEGER;
BEGIN
    IF ( c_profiles%ISOPEN ) THEN
        CLOSE c_profiles;
    END IF;
    
    OPEN c_profiles;
    LOOP
        FETCH c_profiles BULK COLLECT
         INTO lt_profile_option,
              lt_application_instance
        LIMIT 1000;
        
        FORALL i in 1..lt_profile_option.COUNT
            DELETE FROM n_profile_options
             WHERE profile_option       = lt_profile_option(i)
               AND application_instance = lt_application_instance(i);

        EXIT WHEN c_profiles%NOTFOUND;
    END LOOP;
    DBMS_OUTPUT.put_LINE( c_profiles%ROWCOUNT||' rows deleted.' );
    CLOSE c_profiles;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    IF ( c_profiles%ISOPEN ) THEN
        CLOSE c_profiles;
    END IF;
    RAISE;
END;
/
-- re-enable the constraints.
alter table n_views          enable constraint n_views_fk2;
alter table n_view_queries   enable constraint n_view_queries_fk2;
alter table n_view_tables    enable constraint n_view_tables_fk2;
alter table n_view_columns   enable constraint n_view_columns_fk2;
alter table n_view_wheres    enable constraint n_view_wheres_fk2;

whenever sqlerror exit 32
set serveroutput on size :MAX_SERVEROUTPUT_SIZE
-- Set escape off because of the use of escape characters in the regular expressions.
set escape off

PROMPT Figure out what the table_owner is based on the application label
PROMPT Update the table name in the case where an editioning view exists for the table.
--  and the application_instance of the view.
declare -- {
    -- we need to lookup the ref_owner
    CURSOR c1 IS
    SELECT n_popview_pkg.get_owner_name( vc.ref_application_label ) owner_name,
           NVL(ev.view_name, vc.ref_table_name)                     ref_table_name,
           vc.rowid                                                 col_rowid
      FROM n_view_columns             vc,
           n_tmp_all_editioning_views ev
     WHERE vc.ref_owner             is null
       AND vc.ref_application_label is not null
       AND ev.owner (+)              = n_popview_pkg.get_owner_name( vc.ref_application_label )
       AND ev.table_name (+)         = vc.ref_table_name;

    -- We now need to figure out what the table_owner is based on the
    -- application and the application_instance of the view.
    CURSOR c2 IS
    SELECT n_popview_pkg.get_owner_name( vt.application_label ) owner_name,
           nvl(ev.view_name, vt.table_name)                     table_name,
           vt.rowid   tab_rowid
      FROM n_view_tables              vt,
           n_tmp_all_editioning_views ev
     WHERE vt.owner_name is null
       AND ev.owner (+)              = n_popview_pkg.get_owner_name( vt.application_label )
       AND ev.table_name (+)         = vt.table_name;
    --
    -- We need to look at the "WHERE" clauses and see if there are any
    -- tables referred to in subqueries. If there are, we will need to
    -- look up their owners.  These owners are denoted in the template
    -- by their application labels (with an "&"), by something like
    -- "&"PO." or "&"AP."
    cursor c3 is
    select w.where_clause,
           w.rowid where_rowid
      from n_views       v,
           n_view_wheres w
     where w.view_name            = v.view_name
       and replace(replace(replace(replace(w.where_clause,
                                           '&'||'COL.','#'),
                                   '&'||'TABLE_ALIAS.','#'),
                           '&'||'COLUMN_EXPRESSION','#'),
                   '&'||'OUTER_JOIN', '#' )                 like '%&%.%';
    --
    -- We need to look at the "WHERE" clauses and see if there are any
    -- tables referred to in subqueries.  In this case, we are looking for
    -- NOETIX generated views.  Because the view name depends on the
    -- current instance of the view, we will need to properly update the
    -- prefix.
    -- If the appropriate table is not present in the build, then we
    -- will need to generate an error message.
    cursor c3a is
    select w.view_name,
           w.query_position,
           w.where_clause,
           tt.table_name           templates_table_name,
           t.table_name,
           v.application_label     where_application_label,
           vt.special_process_code,
           vt.application_label    table_application_label,
           w.rowid    where_rowid,
           t.rowid    table_rowid
      from n_view_templates        vt,
           n_view_tables           t,
           n_view_table_templates  tt,
           n_views                 v,
           n_view_wheres           w
     where v.view_name                 = w.view_name
       and w.where_clause           like '%&'||'NOETIX.%'
       and tt.view_label               = w.view_label
       and tt.query_position           = w.query_position
       and tt.application_label        = 'NOETIX'
       and nvl(tt.subquery_flag,'N')   = 'Y'
       and upper(w.where_clause) like '%&'||'NOETIX.'||tt.table_name||'%'
       and nvl(translate(
               substr(upper(w.where_clause||' '),
                      instr(upper(w.where_clause||' '),'&'||'NOETIX.'||tt.table_name,1,1)+
                      length('&'||'NOETIX.'||tt.table_name),1),
               'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_',
               '*************************************'),'*') != '*'
       and t.view_name                 = w.view_name
       and t.query_position            = tt.query_position
       and t.application_label         = 'NOETIX'
       and nvl(t.subquery_flag,'N')    = 'Y'
       and t.from_clause_position      = tt.from_clause_position
       and UPPER(vt.view_label)        = tt.table_name
     order by w.view_name,
              w.query_position,
              tt.table_name DESC
    ;
    --
    -- We need to look at the column expressions and see if there are any
    -- expressions containing owner variables. If there are, we will need
    -- to look up their owners.  These owners are denoted in the template
    -- by their application labels (with an "&"), by something like
    -- "&"PO." or "&"AP."
    CURSOR c3c is
    SELECT c.column_expression,
           c.rowid               column_rowid
      FROM n_views        v,
           n_view_columns c
     WHERE c.view_name            = v.view_name
       AND replace(replace(replace(replace(c.column_expression,
                                           '&'||'COL.','#'),
                                   '&'||'TABLE_ALIAS.','#'),
                           '&'||'COLUMN_EXPRESSION','#'),
                   '&'||'OUTER_JOIN', '#' )                 like '%&%.%';

    -- For the "WHERE" clause and column expression replacements, we need
    -- a list of all valid application labels
    -- (for example "PO", "AP", ...)
    cursor c4 is
    select application_label
      from n_application_owner_templates
     group by application_label
    ;

    TYPE typ_view_name      is table of n_views.view_name%TYPE                 index by binary_integer;
    TYPE typ_row_id         is table of rowid                                  index by binary_integer;
    TYPE typ_owner_name     is table of n_view_tables.owner_name%TYPE          index by binary_integer;
    TYPE typ_table_name     is table of n_view_tables.table_name%TYPE          index by binary_integer;
    TYPE typ_where_clause   is table of n_view_wheres.where_clause%TYPE        index by binary_integer;
    TYPE typ_col_expression is table of n_view_columns.column_expression%TYPE  index by binary_integer;
    --
    lt_view_name              typ_view_name;
    lt_owner_name             typ_owner_name;
    lt_table_name             typ_table_name;
    lt_where_clause           typ_where_clause;
    lt_column_expression      typ_col_expression;
    lt_tab_row_id             typ_row_id;
    lt_col_row_id             typ_row_id;
    lt_whr_row_id             typ_row_id;
    li_row_count              BINARY_INTEGER;
    ls_where_clause           n_view_wheres.where_clause%TYPE;
    ls_token                  VARCHAR2(8000);
    ls_token1                 VARCHAR2(8000);
    ls_token2                 VARCHAR2(8000);
    ls_owner_name             VARCHAR2(100);
    ls_target_table_name      VARCHAR2(100);
    li_position               BINARY_INTEGER := 1;
    li_occurrence             BINARY_INTEGER := 1;
    --
begin -- }{

    -- Update the ref_owner in the columns table first.
    if ( c1%ISOPEN ) THEN
        close c1;
    end if;

    DBMS_OUTPUT.put_LINE( 'START TIMESTAMP - '||to_char(sysdate,'DD-MON-YYYY HH24:'||'MI:'||'SS') );
    li_row_count  := 0;
    open c1;
    LOOP
       FETCH c1 BULK COLLECT
         INTO lt_owner_name,
              lt_table_name,
              lt_col_row_id
        LIMIT 5000;

        FORALL i in 1..lt_col_row_id.COUNT
            UPDATE n_view_columns
               SET ref_owner                = lt_owner_name(i),
                   ref_table_name           = lt_table_name(i)
             WHERE rowid          = lt_col_row_id(i);

        li_row_count := li_row_count+lt_col_row_id.COUNT;
        IF ( li_row_count >= 30000 ) THEN
            COMMIT;
            li_row_count := 0;
        END IF;

        EXIT WHEN c1%NOTFOUND;

    END LOOP; -- } end cursor c1

    DBMS_OUTPUT.put_LINE( 'n_view_columns.ref_owner - '||c1%ROWCOUNT||' rows updated.  ' );
    DBMS_OUTPUT.put_LINE( 'Cursor c1 complete - '||to_char(sysdate,'DD-MON-YYYY HH24:'||'MI:'||'SS') );
    commit;

    close c1; 
    lt_owner_name.DELETE;
    lt_table_name.DELETE;
    lt_col_row_id.DELETE;

    -- Update the owner_name in the view tables table first.
    if ( c2%ISOPEN ) THEN
        close c2;
    end if;
    
    li_row_count  := 0;
    open c2;
    LOOP
       FETCH c2 BULK COLLECT
         INTO lt_owner_name,
              lt_table_name,
              lt_tab_row_id
        LIMIT 5000;

       FORALL i in 1..lt_tab_row_id.COUNT
       UPDATE n_view_tables
          SET owner_name           = lt_owner_name(i),
              table_name           = lt_table_name(i)
        WHERE rowid        = lt_tab_row_id(i);

        li_row_count := li_row_count+lt_tab_row_id.COUNT;
        IF ( li_row_count >= 30000 ) THEN
            COMMIT;
            li_row_count := 0;
        END IF;

       EXIT WHEN c2%NOTFOUND;

    END LOOP; -- } end cursor c1

    DBMS_OUTPUT.put_LINE( 'n_view_tables.owner_name - '||c2%ROWCOUNT||' rows updated.' );
    DBMS_OUTPUT.put_LINE( 'Cursor c2 complete - '||to_char(sysdate,'DD-MON-YYYY HH24:'||'MI:'||'SS') );
    commit;

    close c2; 
    lt_owner_name.DELETE;
    lt_table_name.DELETE;
    lt_tab_row_id.DELETE;
    --
    -- Update the base view names in the sub-queries
    li_row_count := 0;
    for r3a in c3a loop -- {
        if ( NOT ( r3a.special_process_code    LIKE 'BASEVIEW%' ) ) THEN
            --
            noetix_utility_pkg.Add_Installation_Message(
                        p_script_name   => 'popview',
                        p_location      => 'Translating sub-query view names.',
                        p_message_type  => 'ERROR',
                        p_message       =>
                            'Subquery contains a non-base Noetix generated view.  '||
                            'View: '||r3a.view_name||
                            ' / Table Name: '||r3a.table_name||
                            ' / Where Clause: '||r3a.where_clause );
            --
            UPDATE n_view_wheres
               SET where_clause = r3a.where_clause||' -- SUBQUERY ERROR'
             WHERE rowid        = r3a.where_rowid;
            --
        elsif ( r3a.table_application_label != r3a.where_application_label ) THEN
            --
            noetix_utility_pkg.Add_Installation_Message(
                        p_script_name   => 'popview',
                        p_location      => 'Translating sub-query view names.',
                        p_message_type  => 'ERROR',
                        p_message       =>
                            'Subquery contains a base Noetix generated view that is not part of the same application.  '||
                            'View: '||r3a.view_name||
                            ' / Table Name: '||r3a.table_name||
                            ' / Where Clause: '||r3a.where_clause );
            --
            UPDATE n_view_wheres
               SET where_clause = r3a.where_clause||' -- SUBQUERY ERROR'
             WHERE rowid        = r3a.where_rowid;
            --
        else
            ls_where_clause := replace(upper(r3a.where_clause),
                                       upper('&'||'NOETIX.'||r3a.templates_table_name),
                                       upper(user||'.'||r3a.table_name));
            -- Update the where clause
            UPDATE n_view_wheres
               SET where_clause = ls_where_clause
             WHERE rowid = r3a.where_rowid;
            -- Update the table owner to the noetix_sys user name
            UPDATE n_view_tables
               SET owner_name = upper(user)
             WHERE rowid = r3a.table_rowid;
            --
        end if;
        li_row_count := li_row_count+1;
    end loop; -- } end cursor r3a

    DBMS_OUTPUT.put_LINE( 'n_view_wheres.where_clause 1 - '||li_row_count||' rows updated.' );
    DBMS_OUTPUT.put_LINE( 'Cursor c3a complete - '||to_char(sysdate,'DD-MON-YYYY HH24:'||'MI:'||'SS') );
    commit;

    --
    -- Update the owner_name in the where clauses
    if ( c3%ISOPEN ) THEN
        close c3;
    end if;
    
    li_row_count  := 0;
    open c3;
    LOOP
        FETCH c3 BULK COLLECT
         INTO lt_where_clause,
              lt_whr_row_id
        LIMIT 5000;

        FOR i in 1..lt_whr_row_id.COUNT LOOP
            -- Handle the pattern  &<APPLICATION_LABEL>.<table_name>.  replace &<APPLICATION_LABEL> with the owner name and <table_name> with the table_name
            -- or the EBR view_name
            ls_token      := NULL;
            li_occurrence := 1;
            IF ( :PRODUCT_VERSION >= 12.2 ) THEN
                LOOP
                  IF ( REPLACE(REPLACE( lt_where_clause(i), 
                                        '&'||'COL.', '##' ),
                               '&'||'TABLE_ALIAS.', '##' )      LIKE '%&%.%' ) THEN
                    -- Loop through the string and look for the first pattern
                    ls_token := regexp_substr( lt_where_clause(i), '&'||'([[:'||'alnum:'||']]+)\.([[:'||'alnum:]_#]+)([[:'||'space:]\),]*)',1,li_occurrence, 'i' );
                    -- the token string should be null if we did not find if.  Exit in that case.
                    IF ( ls_token is null ) THEN
                        exit;
                    END IF;
                    -- Figure out the owner_name
                    ls_token1               := substr(ls_token,2,instr(ls_token,'.')-2);
                    IF ( ls_token1 IN ( 'COL', 'TABLE_ALIAS' ) ) THEN
                        -- We do not want to replace the COL variable.  Skip this occurrence of the token on the next loop.
                        li_occurrence := li_occurrence+1;
                    ELSE
                        ls_owner_name           := n_popview_pkg.get_owner_name( ls_token1 );
                        -- Figure out the table name and the editioning view if it exists.
                        ls_token2               := regexp_replace(substr(ls_token,instr(ls_token,'.')+1),'([[:'||'alnum:]_#]+)([[:'||'space:]\),]*)','\1',1,1,'i');
                        ls_target_table_name    := get_target_table_name(ls_owner_name, ls_token2);

                        -- Update the application name variable with the owner name and the table_name
                        lt_where_clause(i)      := regexp_replace( lt_where_clause(i), '&'||ls_token1||'\.'||ls_token2||'([[:'||'space:]\),]*)', ls_owner_name||'.'||ls_target_table_name||'\1',1,1,'i');
                    END IF;
                  ELSE
                    EXIT;
                  END IF;
                END LOOP;
            ELSE
                -- Prior to 12.2, we only have to convert the application_label ampersand variable to the application owner.
                -- First handle the pattern  &<APPLICATION_LABEL>.  replace &<APPLICATION_LABEL> with the ownername
                ls_token := NULL;
                LOOP
                    IF ( REPLACE(REPLACE( lt_where_clause(i), 
                                        '&'||'COL.', '##' ),
                               '&'||'TABLE_ALIAS.', '##' )      LIKE '%&%.%' ) THEN
                        ls_token := TRIM(translate(regexp_substr( lt_where_clause(i), '&'||'([[:'||'alnum:'||']_]+)\.',1,li_occurrence, 'i' ),'&'||'.','  '));
                        IF ( ls_token is null ) THEN
                            exit;
                        END IF;
                        IF ( ls_token IN ( 'COL', 'TABLE_ALIAS' ) ) THEN
                            -- We do not want to replace the COL variable.  Skip this occurrence of the token on the next loop.
                            li_occurrence := li_occurrence+1;
                        ELSE
                            -- Update the application name variable with the owner name.
                            lt_where_clause(i) := replace( lt_where_clause(i), '&'||ls_token||'.', n_popview_pkg.get_owner_name(UPPER(ls_token))||'.' );
                        END IF;
                    ELSE 
                        EXIT;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        
        FORALL i in 1..lt_whr_row_id.COUNT
        UPDATE n_view_wheres
           SET where_clause       = lt_where_clause(i)
         WHERE rowid              = lt_whr_row_id(i);

        li_row_count := li_row_count+lt_whr_row_id.COUNT;
        IF ( li_row_count >= 30000 ) THEN
            COMMIT;
            li_row_count := 0;
        END IF;

        EXIT WHEN c3%NOTFOUND;

    END LOOP; -- } end cursor c3

    DBMS_OUTPUT.put_LINE( 'n_view_wheres.where_clause 2 - '||c3%ROWCOUNT||' rows updated.' );
    DBMS_OUTPUT.put_LINE( 'Cursor c3 complete - '||to_char(sysdate,'DD-MON-YYYY HH24:'||'MI:'||'SS') );
    commit;

    close c3; 
    lt_where_clause.DELETE;
    lt_whr_row_id.DELETE;

    --
    -- Update the owner_name in the column expressions
    if ( c3c%ISOPEN ) THEN
        close c3c;
    end if;
    
    li_row_count  := 0;
    open c3c;
    LOOP
        FETCH c3c BULK COLLECT
         INTO lt_column_expression,
              lt_col_row_id
        LIMIT 5000;

        FOR i in 1..lt_col_row_id.COUNT LOOP
            IF ( :PRODUCT_VERSION >= 12.2 ) THEN
                -- Handle the pattern  &<APPLICATION_LABEL>.<table_name>.  replace &<APPLICATION_LABEL> with the owner name and <table_name> with the table_name
                -- or the EBR view_name
                ls_token := NULL;
                li_occurrence := 1;
                LOOP
                  IF ( REPLACE(REPLACE( lt_column_expression(i), 
                                        '&'||'COL.', '##' ),
                               '&'||'TABLE_ALIAS.', '##' )      LIKE '%&%.%' ) THEN
                    -- Loop through the string and look for the first pattern
                    ls_token := regexp_substr( lt_column_expression(i), '&'||'([[:'||'alnum:]]+)\.([[:'||'alnum:]_#]+)([[:'||'space:]\),]*)',1,li_occurrence, 'i' );
                    -- the token string should be null if we did not find if.  Exit in that case.
                    IF ( ls_token is null ) THEN
                        exit;
                    END IF;
                    -- Figure out the owner_name
                    ls_token1               := substr(ls_token,2,instr(ls_token,'.')-2);
                    IF ( ls_token1 IN ( 'COL', 'TABLE_ALIAS' ) ) THEN
                        -- We do not want to replace the COL variable.  Skip this occurrence of the token on the next loop.
                        li_occurrence := li_occurrence+1;
                    ELSE
                        ls_owner_name           := n_popview_pkg.get_owner_name( ls_token1 );
                        -- Figure out the table name and the editioning view if it exists.
                        ls_token2               := regexp_replace(substr(ls_token,instr(ls_token,'.')+1),'([[:'||'alnum:]_#]+)([[:'||'space:]\),]*)','\1',1,1,'i');
                        ls_target_table_name    := get_target_table_name(ls_owner_name, ls_token2);

                        -- Update the application name variable with the owner name and the table_name
                        lt_column_expression(i) := regexp_replace( lt_column_expression(i), '&'||ls_token1||'\.'||ls_token2||'([[:'||'space:]\),]*)', ls_owner_name||'.'||ls_target_table_name||'\1',1,1,'i');
                    END IF;
                  ELSE
                    EXIT;
                  END IF;
                END LOOP;
                -- Handle cases where the owner name variable is in quotes
                ls_token      := NULL;
                li_occurrence := 1;
                LOOP
                    IF ( REPLACE(REPLACE( lt_column_expression(i), 
                                            '&'||'COL.', '##' ),
                                   '&'||'TABLE_ALIAS.', '##' )      LIKE '%''&%.''%' ) THEN
                        ls_token := TRIM(translate(regexp_substr( lt_column_expression(i), '''&'||'([[:'||'alnum:'||']_]+)\.''',1,li_occurrence, 'i' ),'&'||'''.','   '));
                        IF ( ls_token is null ) THEN
                            exit;
                        ELSIF ( ls_token IN ( 'COL', 'TABLE_ALIAS' ) ) THEN
                            -- We do not want to replace the COL variable.  Skip this occurrence of the token on the next loop.
                            li_occurrence := li_occurrence+1;
                        ELSE
                            -- Update the application name variable with the owner name.
                            lt_column_expression(i) := replace( lt_column_expression(i), '''&'||ls_token||'.''', ''''||n_popview_pkg.get_owner_name(UPPER(ls_token))||'.''' );
                        END IF;
                    ELSE
                        EXIT;
                    END IF;
                END LOOP;
            ELSE
                -- Prior to 12.2, we only have to convert the application_label ampersand variable to the application owner.
                -- First handle the pattern  &<APPLICATION_LABEL>.  replace &<APPLICATION_LABEL> with the ownername
                ls_token := NULL;
                LOOP
                    IF ( REPLACE(REPLACE( lt_column_expression(i), 
                                        '&'||'COL.', '##' ),
                               '&'||'TABLE_ALIAS.', '##' )      LIKE '%&%.%' ) THEN
                        ls_token := TRIM(translate(regexp_substr( lt_column_expression(i), '&'||'([[:'||'alnum:'||']_]+)\.',1,1, 'i' ),'&'||'.','  '));
                        IF ( ls_token is null ) THEN
                            exit;
                        ELSIF ( ls_token IN ( 'COL', 'TABLE_ALIAS' ) ) THEN
                            -- We do not want to replace the COL variable.  Skip this occurrence of the token on the next loop.
                            li_occurrence := li_occurrence+1;
                        ELSE
                            -- Update the application name variable with the owner name.
                            lt_column_expression(i) := replace( lt_column_expression(i), '&'||ls_token||'.', n_popview_pkg.get_owner_name(UPPER(ls_token))||'.' );
                        END IF;
                    ELSE
                        EXIT;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;

        FORALL i in 1..lt_col_row_id.COUNT
        UPDATE n_view_columns
           SET column_expression  = lt_column_expression(i)
         WHERE rowid              = lt_col_row_id(i);

        li_row_count := li_row_count+lt_col_row_id.COUNT;
        IF ( li_row_count >= 30000 ) THEN
            COMMIT;
            li_row_count := 0;
        END IF;

        EXIT WHEN c3c%NOTFOUND;

    END LOOP; -- } end cursor c3c

    DBMS_OUTPUT.put_LINE( 'n_view_columns.column_expression - '||c3c%ROWCOUNT||' rows updated.' );
    DBMS_OUTPUT.put_LINE( 'Cursor c3c complete - '||to_char(sysdate,'DD-MON-YYYY HH24:'||'MI:'||'SS') );
    commit;

    close c3c; 
    lt_column_expression.DELETE;
    lt_col_row_id.DELETE;
     
end; -- } popview.sql
/
commit;

-- Set escape back to on.
set escape on

--
-- The global role is currently not equipped to handle SEGEXPR or
-- SEGSTRUCT columns. Since these columns are critical to these views
-- we'll just omit the views in the global instance for now.
/*
update n_views
   set omit_flag = 'Y'
 where application_instance = 'G0'
   and view_label in
     ( select view_label
         from n_view_column_templates
        where column_type in ('SEGEXPR','SEGSTRUCT')
        group by view_label )
;
commit;
*/

set define &

drop package   n_popview_pkg;

-- Populate the temp tables
prompt populate the temp tables
insert /*+ APPEND */ into n_tmp_all_tables_and_views 
     ( owner, 
       object_name,
       object_type )
  WITH appl_owners as
     ( SELECT appl.owner_name
         FROM n_application_owners appl
        GROUP BY appl.owner_name ) 
(
SELECT at.owner,
       at.table_name object_name,
       'TABLE'       object_type
  FROM all_tables at,
       appl_owners 
 WHERE at.owner           = appl_owners.owner_name
   AND at.table_name      > ' '
 UNION ALL
SELECT av.owner,
       av.view_name object_name,
       'VIEW'       object_type
  FROM all_views av,
       appl_owners 
 WHERE av.owner           = appl_owners.owner_name 
   AND av.view_name       > ' ' 
)
 MINUS 
SELECT user                 owner,
       upper(v.view_name)   object_name,
       'VIEW'               object_type
  FROM n_views v;
commit;

insert /*+ APPEND */ into n_tmp_all_tab_columns
     ( owner, 
       table_name, 
       column_name, 
       data_type, 
       nullable, 
       column_id, 
       data_length )
select atc.owner, 
       atc.table_name, 
       atc.column_name,
       atc.data_type, 
       atc.nullable, 
       atc.column_id, 
       atc.data_length
  from all_tab_columns              atc,
       n_tmp_all_tables_and_views   atv
 where atc.owner        = atv.owner
   and atc.table_name   = atv.object_name;
commit;

BEGIN
    BEGIN
        execute immediate 'truncate table n_tmp_all_editioning_views';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    IF ( &PRODUCT_VERSION >= 12.2 ) THEN
        execute immediate
'INSERT /*+ APPEND */ INTO n_tmp_all_editioning_views
     ( owner,
       table_name,
       view_name )
SELECT aev.owner,
       aev.table_name,
       aev.view_name
  FROM n_tmp_all_tables_and_views at,
       all_editioning_views       aev
 WHERE aev.owner (+)        = at.owner
   AND aev.table_name (+)   = at.object_name
   AND at.object_type       = ''TABLE'' ';
    ELSE
        execute immediate
'INSERT /*+ APPEND */ INTO n_tmp_all_editioning_views
     ( owner,
       table_name,
       view_name )
SELECT at.owner,
       at.object_name  table_name,
       TO_CHAR(NULL)
  FROM n_tmp_all_tables_and_views at
 WHERE at.object_type   = ''TABLE'' ';
    END IF;
    COMMIT;

    BEGIN
        execute immediate 'truncate table N_TMP_ALL_EDITIONING_VIEW_COLS';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;

    IF ( &PRODUCT_VERSION >= 12.2 ) THEN
        execute immediate
'INSERT /*+ APPEND */ INTO N_TMP_ALL_EDITIONING_VIEW_COLS
     ( owner,
       view_name,
       view_column_id,
       view_column_name,
       table_column_id,
       table_column_name )
SELECT evc.owner,
       evc.view_name,
       evc.view_column_id,
       evc.view_column_name,
       evc.table_column_id,
       evc.table_column_name
  FROM n_tmp_all_editioning_views       ev,
       all_editioning_view_cols         evc
 WHERE evc.owner      = ev.owner
   AND evc.view_name  = ev.view_name ';
    END IF;
    COMMIT;

END;
/

insert /*+ APPEND */ into n_tmp_all_indexes
     ( table_owner, 
       table_name, 
       owner, 
       index_name, 
       status, 
       uniqueness )
select ai.table_owner, 
       ai.table_name, 
       ai.owner,
       ai.index_name, 
       ai.status,
       ai.uniqueness
  from all_indexes                ai,
       n_tmp_all_tables_and_views atv
 where ai.owner        = atv.owner
   and ai.table_owner  = atv.owner
   and ai.owner        = ai.table_owner
   and ai.table_name   = atv.object_name
   and atv.object_type = 'TABLE';
commit;

--TODO---- update n_tmp_all_indexes 
--TODO--  --SET TABLE_NAME=TABLE_NAME||'#'
--TODO--  --WHERE (TABLE_OWNER,TABLE_NAME) IN (SELECT owner,table_name 
--TODo-     --                                  FROM  SYS.DBA_EDITIONING_VIEWS  );
--TODO----COMMIT;

INSERT /*+ APPEND */ into n_tmp_all_ind_columns
     ( table_owner, 
       table_name, 
       column_name, 
       column_position, 
       index_name, 
       index_owner,
       view_table_name,
       view_column_name )
SELECT /*+ LEADING( ai, aic, evc ) */
       aic.table_owner, 
       aic.table_name, 
       aic.column_name,
       aic.column_position, 
       aic.index_name, 
       aic.index_owner,
       NVL(evc.view_name,aic.table_name)         view_table_name,
       nvl(evc.view_column_name,aic.column_name) view_column_name
  FROM all_ind_columns                aic,
       n_tmp_all_indexes              ai,
       ( SELECT ev1.owner,
                ev1.table_name,
                ev1.view_name,
                evc1.table_column_name,
                evc1.view_column_name
           FROM n_tmp_all_editioning_views     ev1,
                n_tmp_all_editioning_view_cols evc1
          WHERE evc1.owner           = ev1.owner
            AND evc1.view_name       = ev1.view_name ) evc
 WHERE aic.index_owner           = ai.owner
   AND aic.index_name            = ai.index_name
   AND aic.table_owner           = ai.table_owner
   AND aic.table_name            = ai.table_name
   AND aic.index_owner           = aic.table_owner
   AND aic.column_name          <> 'ZD_EDITION_NAME'
   AND evc.owner (+)             = aic.table_owner
   AND evc.table_name (+)        = aic.table_name
   AND evc.table_column_name (+) = aic.column_name;
commit;

define v_populate_sm_modules = 'n_sec_manager_dm_pkg.populate_module_list';
column cv_populate_sm_modules  new_value  v_populate_sm_modules noprint
SELECT 'null'  cv_populate_sm_modules
  FROM dual
 WHERE '&DAT_TYPE'  != 'Views';

-- Populate the module list early in the case we have changes to the module list or in the case
-- of a first time install.
-- This ensures the Get_ACL_Processing_Code and Is_Advanced_Security_Enabled functions work.
BEGIN
    &V_POPULATE_SM_MODULES ;
    commit;
EXCEPTION
    WHEN OTHERS THEN
        BEGIN
            &V_POPULATE_SM_MODULES ;
        EXCEPTION
            WHEN OTHERS THEN 
                NULL;
        END;
END;
/


-- Update n_application_org_mappings to populate legal_entity_name values.  (#20034)
--
define HR_USERID='HR'
column c_hr_userid new_value hr_userid noprint
select ao.owner_name    c_hr_userid
  from n_application_owners ao
 where ao.application_label  = 'HR'
   and rownum                = 1
;

define AP_USERID='AP'
column c_ap_userid new_value ap_userid noprint
select ao.owner_name    c_ap_userid
  from n_application_owners ao
 where ao.application_label  = 'AP'
   and rownum                = 1
;

set serveroutput on size &MAX_SERVEROUTPUT_SIZE
DECLARE
    ls_select_12plus   VARCHAR2(4000) := 
     '( SELECT otl.NAME 
          FROM hr_all_organization_units_s    o, 
               hr_all_organization_units_tl_s otl
         WHERE o.organization_id = otl.organization_id(+)
           AND o.organization_id = 
             ( CASE 
                 WHEN n.application_label IN 
                         (''BOM'',''CRP'',''CST'',''EAM'',''GMA'',''GMD'',''GME'',''GMF'',''GMI'',''GML'',
                          ''GMP'',''INV'',''MRP'',''MSC'',''MSD'',''WIP'')       THEN n.ORGANIZATION_ID
                 WHEN n.application_label IN 
                         (''AP'',''AR'',''BEN'',''CS'',''GMS'',''HR'',''HXC'',''IGW'',''PA'',''PAY'',
                          ''PB'',''PC'',''PJM'',''RA'',''PO'',''OE'',''ONT'')      THEN n.org_id 
               END ) 
           AND EXISTS 
             ( SELECT 1 
                 FROM hr_organization_information_s o2
                WHERE o2.organization_id         = o.organization_id
                  AND o2.org_information_context = ''CLASS''
                  AND o2.org_information1       IN 
                        (''HR_LEGAL'', ''PAR_ENT'', ''FR_SOCIETE'', ''HR_LEGAL_EMPLOYER'')
                  AND o2.org_information2        = ''Y'' )
           AND otl.LANGUAGE               = USERENV (''LANG'') )';

    ls_select_11_5  VARCHAR2(4000) := 
     '( SELECT otl.NAME 
          FROM hr_all_organization_units_s    o, 
               hr_all_organization_units_tl_s otl,
               hr_organization_information_s  o3
         WHERE o.organization_id                 = o3.organization_id(+)
           AND o.organization_id                 = 
             ( CASE 
                 WHEN n.application_label         IN 
                         (''BOM'',''CRP'',''CST'',''EAM'',''GMA'',''GMD'',''GME'',''GMF'',''GMI'',''GML'',
                          ''GMP'',''INV'',''MRP'',''MSC'',''MSD'',''WIP'')       THEN n.ORGANIZATION_ID
                 WHEN n.application_label IN 
                         (''AP'',''AR'',''BEN'',''CS'',''GMS'',''HR'',''HXC'',''IGW'',''PA'',''PAY'',
                          ''PB'',''PC'',''PJM'',''RA'',''PO'',''OE'',''ONT'')    THEN n.org_id 
               END ) 
           AND o3.org_information_context(+)     = ''Legal Entity Accounting''
           AND EXISTS 
             ( SELECT 1 
                 FROM hr_organization_information_s o2
                WHERE o2.organization_id         = o.organization_id
                  AND o2.org_information_context = ''CLASS''
                  AND o2.org_information1        = ''HR_LEGAL''
                  AND o2.org_information2        = ''Y''        )
           AND o.organization_id                 = otl.organization_id
           AND otl.LANGUAGE                      = USERENV (''LANG'') )';
    ls_12plus_version VARCHAR2(1);
BEGIN
    
    BEGIN
        SELECT 'Y'
          INTO ls_12plus_version
          FROM DUAL
         WHERE EXISTS 
             ( SELECT table_name
                 FROM SYS.all_tables
                WHERE owner      = '&AP_USERID'
                  AND table_name = 'AP_SUPPLIERS' );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ls_12plus_version := 'N';
    END;
    
    if ( ls_12plus_version = 'Y' ) THEN
        DBMS_OUTPUT.PUT_LINE( 'Update n_application_owners with the Legal Entity information.' );
        DBMS_OUTPUT.PUT_LINE( '' );
        -- Execute the 12+ version of the update for legal entity
        execute immediate 
            'UPDATE n_application_org_mappings n
                SET n.legal_entity_name = '||ls_select_12plus;
    else
        -- execute the 11i version of the update for legal entity
        execute immediate 
            'UPDATE n_application_org_mappings n
                SET n.legal_entity_name = '||ls_select_11_5;
    end if;
    dbms_output.put_line( SQL%ROWCOUNT||' rows updated' );

    commit;

END;
/

@utlspoff

@utlprmpt "Gather statistics on the non-template tables."

set termout &LEVEL2
set serveroutput on size &MAX_SERVEROUTPUT_SIZE
whenever sqlerror continue
-- Spool to an output file
@utlspon popview2_stats
-- Gather the statistics for the templates objects
DECLARE
  CURSOR c1 IS
    SELECT table_name
      FROM user_tables
     WHERE 
         (    table_name like 'N_VIEW%'
           or table_name like 'N_ROLE%'
           or table_name like 'N_HELP%'
           or table_name like 'N_PROFILE%'
           or table_name like 'N_APPLICATION%'
           or table_name like 'N_USER%'
           or table_name like 'N_TMP_ALL%' )
       and table_name not like '%TEMPLATES'
     ORDER BY 1;
BEGIN
  IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN 
      dbms_output.enable(NULL);
  ELSE
      dbms_output.enable(1000000);
  END IF;
  dbms_output.put_line( 'Gather Schema Stats for Non-Templates Tables' );
  FOR r1 IN c1 LOOP
  BEGIN
    dbms_output.put_line( 'Gather Statistics for '||r1.table_name );
    dbms_stats.gather_table_stats( ownname                  => user,
                                   tabname                  => r1.table_name,
                                   estimate_percent         => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                   block_sample             => TRUE,
                                   no_invalidate            => TRUE,
                                   degree                   => DBMS_STATS.DEFAULT_DEGREE,
                                   cascade                  => TRUE   );
  EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line( '*****Failed*****' );
  END;
  END LOOP;
END;
/

set timing off
@utlspoff

-- Determine if we need to run yconvqu.  
DEFINE run_yconvqu = 'N'
COLUMN c_run_yconvqu   new_value run_yconvqu noprint
SELECT 'Y'                           c_run_wsaveold
  FROM dual 
 WHERE EXISTS
     ( SELECT 'One of these tables exist'
         FROM USER_TABLES
        WHERE table_name in ( 'N_QUERY_USERS',
                              'N_QUERY_USER_ROLES',
                              'N_USER_SECURITY_RULES') );
-- Ensure that the security upgrade was performed.
start utlif "yconvqu ''Y''" -
"'&RUN_YCONVQU' = 'Y'"

@wdrop table &NOETIX_USER n_gorg_temp

undefine MAX_BUFFER
undefine V_POPULATE_SM_MODULES
undefine RUN_YCONVQU

-- end popview.sql
