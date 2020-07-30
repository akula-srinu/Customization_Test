-- Title
--   dropvw.sql
-- Function
--   Drop all the generated views from the noetix account.
-- Description
--   Create a script to drop all the views (except the views to FND tables)
--   then execute that script
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   21-Jul-94 D Cowles
--   04-Jan-94 D Cowles  - do not drop the views if they will be recreated
--   14-Apr-96 D Cowles  - do not drop Discoverer Views in case EUL is in
--                         noetix_sys
--   06-Jun-97 D West    - Add a subquery to prevent dropping views
--                         that are in N_CUSTOM_OBJECTS.
--   23-Dec-97 D Cowles  - do not drop the views used by the procedures
--   01-OCt-98 D Glancy  - do not drop the NOETIX_FND_APPLICATION_VL,
--                         NOETIX_FND_CURRENCIES_VL, and
--                         NOETIX_FND_TERRITORIES_VL views.
--   07-OCt-98 D Glancy  - Do not drop the NOETIX_FND_FLEX_VALUES_VL view.
--                         Drop the views created specifically for
--                         release 11.
--   04 Nov 98 D Glancy  - 1. Remove the following views from the drop statement:
--                         fnd_descriptive_flexs
--                         fnd_descr_flex_column_usages
--                         fnd_descr_flex_contexts
--                         fnd_id_flex_segments
--                         fnd_id_flex_structures
--                         FND_FLEX_VALUE_RULES
--                         2. Move the following names to the drop synonym
--                         statement:
--                         FND_CURRENCIES, FND_TERRITORIES, FND_RESPONSIBILITY
--                         3. Add the following views to the list of views
--                         that should NOT be dropped from the noetix_sys
--                         environment. (Must persist for other processes)
--                         N_FND_RESPONSIBILITY_VL,
--                         N_FND_DESCRIPTIVE_FLEXS_VL,
--                         N_FND_DESCR_FLEX_COL_USAGE_VL,
--                         N_FND_DESCR_FLEX_CONTEXTS_VL,
--                         N_FND_ID_FLEX_SEGMENTS_VL,
--                         N_FND_ID_FLEX_STRUCTURES_VL
--   04 Feb 99 D Glancy  - Added the following views from the drop statement:
--                         DIS_ALL_DOCS,
--                         DIS_DOCS,
--                         DIS_GRANTS
--   05 Feb 99 D Glancy  - Added the following views from the drop statement:
--                         EUL%,
--   13-Sep-99 R Lowe    Update copyright info.
--   29-Oct-99 R Lowe    Add the following views to the list of views that should
--                       NOT be dropped from the noetix_sys environment.
--                       N_FND_APPLICATION_VL      N_FND_CONCURRENT_PROGRAMS_VL
--                       N_FND_CURRENCIES_VL       N_FND_EXECUTABLES_VL
--                       N_FND_FLEX_HIERARCHIES_VL N_FND_FLEX_VALUE_RULES_VL
--                       N_FND_FLEX_VALUES_VL      N_FND_FLEX_VDATION_RULES_VL
--                       N_FND_FORM_FUNCTIONS_VL   N_FND_FORM_VL
--                       N_FND_MENU_ENTRIES_VL     N_FND_MENUS_VL
--                       N_FND_PRINTER_STYLES_VL   N_FND_PRINTER_VL
--                       N_FND_PROFILE_OPTIONS_VL  N_FND_TERRITORIES_VL
--                       N_FND_DOCUMENTS_VL        N_FND_VAL_ATTRIBUTE_TYPES_VL
--    5-Nov-99 R Lowe    Add N_FND_LANGUAGES_VL to the list of views that should
--                       NOT be dropped.
--    4-Feb-00 R Lowe    Add N_WF_LOOKUPS_VL and N_WF_MESSAGES_VL to the list of
--                       views that should NOT be dropped.
--   14-Feb-00 H Sumanam Update copyright info.
--   04-Apr-00 D Glancy  Added n_apps_security_info_vl view to the do NOT drop list.
--   19-Jul-00 R Lowe    Add the following views to the DO NOT DROP list.
--                       N_AP_LOOKUPS_VL              N_AR_LOOKUPS_VL
--                       N_FA_LOOKUPS_VL              N_GL_LOOKUPS_VL
--                       N_MFG_LOOKUPS_VL             N_PA_LOOKUPS_VL
--                       N_PO_LOOKUPS_VL              N_SO_LOOKUPS_VL
--                       N_FND_LOOKUPS_VL             N_FND_COMMON_LOOKUPS_VL
--                       N_FND_COMMON_LOOKUP_TYPES_VL
--   21-Jul-00 R Lowe    Add the following views to the DO NOT DROP list.
--                       N_AP_LOOKUP_TYPES_VL         N_AR_LOOKUP_TYPES_VL
--                       N_FA_LOOKUP_TYPES_VL         N_GL_LOOKUP_TYPES_VL
--                       N_MFG_LOOKUP_TYPES_VL        N_PA_LOOKUP_TYPES_VL
--                       N_PO_LOOKUP_TYPES_VL         N_SO_LOOKUP_TYPES_VL
--                       N_OE_LOOKUPS_VL              N_OE_LOOKUP_TYPES_VL
--                       N_FND_LOOKUP_TYPES_VL        N_WF_LOOKUP_TYPES_VL
--   25-Jul-00 D Glancy  Add commas after some of the listed new N_%_VL views that
--                       should not be dropped.
--   25-Jul-00 R Lowe    Add the following views to the DO NOT DROP list.
--                       N_HR_LOOKUPS_VL              N_HR_LOOKUP_TYPES_VL
--   31-Jul-00 D Glancy  Add the following views to the DO NOT DROP list.
--                       N_FND_USER_RESPONSIBILITY_VL, N_FND_SECURITY_GROUPS_VL
--   11-Dec-00 D Glancy  Update copyright info.
--   14-Mar-01 R Lowe    Add the following views to the DO NOT DROP list.
--                       N_QP_LOOKUPS_VL              N_QP_LOOKUP_TYPES_VL
--                       N_WSH_LOOKUPS_VL             N_WSH_LOOKUP_TYPES_VL
--   27-jul-01 M Potluri Add the N_GL_AVERAGE_BALANCES_VL view to the
--                       DO NOT DROP list.
--   08-Aug-01 D Glancy  Remove the FND_LOOKUP_TYPES synonym from the drop list.
--                       This is referenced from oracle's hr_security package which
--                       we call in this security routine.  This is necessary as of 11.5+.
--                       (Bug 4017)
--   13-Aug-01 H Schmed  Added a missing comma after FND_LOOKUP_TYPES.
--   12-Nov-01 D Glancy  Update copyright info. (Issue #5285)
--   10-Apr-02 H Schmed  Exclude the N_ANS% views from deletion. (Issue 5795)
--                       These are the views of the answer metadata.
--   14-May-02 G Liu     Added a deletion to function RTF_CHAR if it exists.
--                       RTF_CHAR has been replaced with N_RTF_CHAR.
--   27-Jun-02 D Glancy  Added 'NV_NQS_RESPONSIBILITY_LIST' and 'NV_NQS_APPLICATION_LOGIN_IDS'
--                       the list of views that should not be deleted. (Issue 6757)
--   31-Oct-02 D Glancy  Update copyright info. (Issue #8615)
--   30-Jan-03 D Glancy  1.  Because the fnd_profile_options table must exist after the install
--                       due to the addition of the fnd_profile package, removed the drop view
--                       statement.  (Issue #9090)
--                       2.  Drop the NOETIX_HINT_PKG because it is no longer used.
--                       (Issue #9090)
--   23-Jul-03 D Glancy  Do not remove the synonym for fnd_lookup_types.
--                       It's needed by the apps security package.
--                       (Issue 11022)
--   19-Feb-04 H Schmed  Moved the dropping of the RTF_CHAR function and the
--                       NOETIX_HINT_PKG to ydropobj.sql. (Sphinx Issue 11887)
--                       Update copyright information (Sphinx Issue 11590)
--   14-Apr-04 D Glancy  Add N_BEN_LOOKUPS_VL / N_BEN_LOOKUP_TYPES_VL views for benefits
--                       to the do not drop list.
--                       (Issue 12232)
--   03-Nov-04 D Glancy  Update Copyright Info. (Issue 13498)
--   05-Jan-05 D Glancy  Add N_FND_USER_RESP_GROUPS_VL view to the do not drop list.
--                       (Issue 13713)
--   22-Sep-05 D Glancy  Update copyright info. (Issue 15175)
--   06-Oct-05 H Schmed  Updated the list of views to keep with the view
--                       N_GMS_LOOKUPS_VL and N_GMS_LOOKUP_TYPES_VL.
--                       (Golkonda 15354)
--   15-Nov-05 D Glancy  Added N_QU_OU_MAPPINGS_V, N_QU_SOB_MAPPINGS_V,
--                       N_QU_BG_MAPPINGS_V, N_QU_INV_MAPPINGS_V', and
--                       N_QU_CST_MAPPINGS_V to the list of views not to drop.  These
--                       are used as part of the new Global instance upgrade.
--                       (Issue 15240)
--   27-Dec-05 S Krishna Added N_GMD_LOOKUPS_VL, N_GMD_LOOKUP_TYPES_VL, N_GME_LOOKUPS_VL,
--                       N_GME_LOOKUP_TYPES_VL, N_GMF_LOOKUPS_VL, N_GMF_LOOKUP_TYPES_VL,
--                       N_GMI_LOOKUPS_VL, and N_GMI_LOOKUP_TYPES_VL.
--                       (Issue 15665)
--   29-Dec-05 S Krishna Added N_GMP_LOOKUPS_VL and N_GMP_LOOKUP_TYPES_VL.
--                       (Issue 15665)
--   03-Jul-06 H Schmed  Excluded views found in n_seg_id_flex_code_headers
--                       from being dropped. (Issue 16499)
--   17-Aug-06 P Vemuru  NOETIX_FORCED_SEARCHBY_CANDS has been added to list of views which 
--                       should not be dropped (14251)
--   16-Oct-06 D Glancy  Added N_QU_OPM_MAPPINGS_V and N_QU_COA_MAPPINGS_V views for OPM and GL global
--                       role support.
--                       (Issue 16810 and 15240)
--   14-Nov-06 D Glancy  Decided NOETIX_FORCED_SEARCHBY_CANDS will not be used and have
--                       removed it from the list of list of views which should not be dropped 
--                       (Issue 14251)
--   14-Mar-07 D Glancy  Add the N_CS_LOOKUPS_VL and N_CS_LOOKUP_TYPES_VL views for
--                       TeleServices to the list of views not to drop.
--                       (Issue 16803)
--   26-Apr-07 Swathi    Added N_CSI_LOOKUPS_VL, N_CSI_LOOKUP_TYPES_VL.
--                       (Issue 17582)
--   04-Sep-07 MNalam    Added N_OKE_LOOKUPS_VL, N_OKE_LOOKUP_TYPES_VL for Project Manufacturing.
--                       (Issue 18001)       
--   05-Oct-07 J Bhatta  Added lookups related to XLA and CE modules for r12.
--   16-Nov-07 D Glancy  Added a list of views not to drop that support the new security manager feature.
--                       (Issue 18563 and 15240)
--   30-Nov-07 R Lowe    Add NoetixViews for PeopleSoft support.
--   07-Dec-07 P Vemuru  Added N_QU_SINST_MAPPINGS_V view to the list of views to be dropped (Issue 5357)
--   31-Jan-08 Rohini    Added N_IEX_LOOKUPS_VL, N_IEX_LOOKUP_TYPES_VL.
--                       (Issue 18926)
--   01-Aug-08 S Syed    Added N_QA_LOOKUPS_VL for QA module.
--                       (Issue 20398)
--   26-Aug-08 D Glancy  Add support for QA and FV.
--                       (Issue 20395 and 20564)
--   21-Oct-08 D Glancy  Add security manager related views to support sob and budget level security.
--                       (Issue 20911)
--   23-Oct-08 D Glancy  Wrong name was specified for the n_sm_blvl_cur_user_access_v view.  Corrected.
--                       (Issue 20911)
--   14-Nov-08 D Glancy  Add N_RESPONSIBILITY_FORMS_V to the no drop list.
--                       (Issue 20917)
--   19-Feb-09 S Vital   Add global SEG helper views to the no drop list.
--                       (Issue 21542) 
--   26-Feb-09 D Glancy  Add more security related views that should not get dropped.
--                       (Issue 21378)
--   13-Mar-09 D Glancy  Add N_NOETIX_DFLT_APPL_NAMES_VL to the no drop list.
--                       (Issue 21731)
--   23-Mar-09 S Vital   Added n_f_kff_strgrp_helper_view (global SEG view) to the no drop list.
--                       (Issue 21542) 
--   09-Apr-09 Hatakesh  Add N_HXC_MISSING_PERIODS_V to the no drop list.
--                       (Issue 21941)
--   20-Apr-09 S Vital   Added n_f_kff_segstruct_helper_<N> (global SEG view) to the no drop list.
--                       (Issue 21665) 
--   28-Apr-09 S Vital   Added n_f_kff_flxfld_helper_<N> (global SEG view) to the no drop list.
--                       (Issue 21665) 
--   15-Jun-09 D Glancy  Add N_MTL_PARAMETERS_V to the no drop list.
--                       (Issue 22275 and 22277)
--   30-Jul-09 D Glancy  Add N_VIEW_PARAMETERS_CURRENT_V and N_VIEW_PARAM_EXT_CURRENT_V
--                       (Issue 22403)
--   06-Aug-09 D Glancy  Add the metabuilder API views to the list.
--                       (Issue 21960)
--   12-Aug-09 D Glancy  Add some missing security manager views to the do not drop list.
--                       (Issue 22275 and 22277)
--   14-Oct-09 S Vital   Add key view helper view to the no drop list.
--                       (Issue 22811)
--   21-Oct-09 D Glancy  Add the n_sm_related_properties_v view to the do not drop list.
--                       (Issue 22725)
--   16-Nov-09 G Sriram  Added N_VIEW_JOIN_RELN_HELPER_<N> (global SEG view) to the no drop list. 
--   17-Nov-09 C Kranthi Added N_F_KFF_STRGRP_SUBSET_VIEW (global SEG view) to the no drop list. 
--   18-Jan-10 D Glancy  Added new API views to the do not drop list.
--   25-Feb-10 D Glancy  Add N_SM_USER_CONNECTIONS_V, N_SM_USER_CONNECTIONS_BASE_V,
--                       N_SM_SERVER_CONNECTIONS_V, and N_SM_APPS_USER_RESP_SG_V to the no drop list.
--   09-Mar-10 D Glancy  Add 'N_API_STRUCTURE_BY_BUSGRP_V' to the no drop list.
--                       (Issue 23487)
--   10-Mar-10 D Glancy  Remove 'NOETIX_SEARCHBY_CANDIDATES' from the no drop list.
--                       (Issue 23487)
--   17-Mar-10 R Lowe    Add 'N_API_STD_VIEWS_V' to the no drop list.
--   13-Apr-10 V Gang    Add n_xla_tb_defn_details_v  to the no drop list.  
--                       (Issue 23039)
--   17-Jul-10 R Vattikonda Add service security views to the do not drop list.
--                       (Issue 25135)
--   31-Aug-10 D Glancy  Add n_cs_system_options_v view to the do not drop list.
--                       (Issue 25135)
--   06-Dec-10 R Vattikonda  Add n_csi_i_org_assignments_v, n_hz_parties_v, n_csi_item_instances_v to the do not drop list.
--                       (Issue 25739)
--   05-Jan-11 R Vattikonda Add N_SOB_STRUCTURE_RULES_V view to the do not drop list.
--   19-Jan-11 R Vattikonda Add N_SM_KFF_CURRENT_USER_ACCESS_V view to the do not drop list.
--   17-Mar-11 D Glancy     Add N_SM_KFF_ROLLUP_USER_ACCESS_V view to the do not drop list.
--                          Removed the n_sm_GLKFF% views as we are not using them.
--   30-Mar-11 R Vattikonda Add N_SM_KFF_UNROLLUP_USR_ACCESS_V view to the do not drop list.
--   15-Apr-11 R Vattikonda Add N_SM_KFF_SOB_ROLLUP_ACCESS_V,N_SM_KFF_OU_ROLLUP_ACCESS_V and N_SM_KFF_INV_ROLLUP_ACCESS_V
--                          views to the do not drop list. 
--   20-Jun-11 R Lowe       Add N_API_MD_HIERARCHIES_V and N_API_MD_HIERARCHY_LEVELS_V for
--                          parent-child hierarchy support in metabuilder api.
--   01-Jul-11 D Glancy     Add N_SM_ALL_EFF_USER_AUTHS_V.
--   15-Jul-11 R Lowe       Add N_API_ALL_APPL_OWNER_ROLES_V, N_ALL_API_ROLES_V, N_API_ALL_ROLE_VIEWS_V.
--   12-Aug-11 D Glancy     Add N_PROPERTY_TYPE_TEMPLATES_V,  N_VIEW_COL_TYPE_PROP_T_TMPL_V, N_VIEW_PROPERTY_TEMPLATES_V,
--                          N_METADATA_TABLES_V, N_METADATA_COLUMNS_V.
--   15-Sep-11 D Glancy     Removed N_CSI_ITEM_INSTANCES_V.
--                          (Issue 25739)
--   25-Oct-11 M Suleman    Add N_PJI_LOOKUPS_VL, N_PJI_LOOKUP_TYPES_VL view to the do not drop list.
--                          (Issue 27921)
--   11-Nov-11 P Upendra    Added N_BOM_EXPLOSION_BASE_V to not to drop list.
--                          (Issue 18791)
--   25-Aug-11 R Vattikonda Add a subquery to prevent dropping views
--                          that are in n_f_kff_flex_source with zero_latency_flag as 'Y'.
--                          (Issue 27565)
--   11-Sep-12 R Lowe       Add N_API_JOIN_KEYS_V.  (Issue 30762)
--   09-Oct-12 D Glancy     Add n_join_key_% views to the do not drop list.
--                          (Issue 28846)
--   06-Dec-12 R Lowe       More metabuilder api views.
--   08-Mar-13 D Glancy     Added the n_msd_scenarios_v view to eliminate the sqlplus comment variables in ycrascpp.sql.
--                          (Issue 31973)
--   13-Mar-13 D Glancy     Add the N_FUN_LOOKUPS_VL and N_FUN_LOOKUP_TYPES_VL views for
--                          Financials Common Modules Account (FUN) to the do not drop list. 
--                          (Issue 30252)
--   11-Apr-13 D Glancy     Add N_SM_GRANTED_USER_ROLES_V to the do not drop list.
--                          (Issue 31869).
--   24-Apr-13 D Glancy     Added n_hierarchies (formerly a table) to the do not drop list.  This helps to support a new model
--                          for hierarchies where we only populate one flex value set hierarchy that can be attached to multiple hierarchies.
--                          Helps with performance and the supports the 20 level approach.
--                          (Issue 31108 and 30900)
--   28-May-13 A Gunda      Add N_JOIN_KEY_HELPER_1, N_JOIN_KEY_HELPER_2 to the do not drop list.
--   05-Aug-13 D Glancy     Change hints associated with user_synonyms and all_synonyms.
--   20-Jan-14 D Glancy     The fnd_currencies and fnd_territories synonyms are already dropped as part of stage 3 so I removed that check.
--   06-May-15 R Lowe       Add n_api_copy_views_v to the do not drop list.
--
--
@utlspsql 132 tmpdropv

whenever sqlerror exit 60
SELECT 'drop view '||view_name||';'
  FROM user_views
 WHERE view_name not like 'FND%'
   AND view_name not in
     ( 'N_VIEW_ACCESSIBLE_COLUMNS',     'N_VIEW_ACCESSIBLE_TABLES',
       'N_VIEW_ALL_CATALOG',            'N_VIEW_ALL_OBJECTS',
       'N_VIEW_ALL_SYNONYMS',           'N_VIEW_ALL_TABLES',
       'HELP_NOETIX_COLUMNS',           'HELP_NOETIX_VIEWS',
       'NOETIX_CURRENT_PERIOD',         'NOETIX_PERIOD_OFFSETS',
       'NOETIX_CATEGORY_SETS',
       'HR_LOOKUPS',
       'NOETIX_FND_APPLICATION_VL',     'NOETIX_FND_CURRENCIES_VL',
       'NOETIX_FND_TERRITORIES_VL',     'NOETIX_FND_FLEX_VALUES_VL',
       'N_FND_RESPONSIBILITY_VL',
       'N_FND_DESCRIPTIVE_FLEXS_VL',    'N_FND_DESCR_FLEX_COL_USAGE_VL',
       'N_FND_DESCR_FLEX_CONTEXTS_VL',  'N_FND_ID_FLEX_SEGMENTS_VL',
       'N_FND_ID_FLEX_STRUCTURES_VL',
       'N_FND_APPLICATION_VL',          'N_FND_CONCURRENT_PROGRAMS_VL',
       'N_FND_CURRENCIES_VL',           'N_FND_EXECUTABLES_VL',
       'N_FND_FLEX_HIERARCHIES_VL',     'N_FND_FLEX_VALUE_RULES_VL',
       'N_FND_FLEX_VALUES_VL',          'N_FND_FLEX_VDATION_RULES_VL',
       'N_FND_FORM_FUNCTIONS_VL',       'N_FND_FORM_VL',
       'N_FND_MENU_ENTRIES_VL',         'N_FND_MENUS_VL',
       'N_FND_PRINTER_STYLES_VL',       'N_FND_PRINTER_VL',
       'N_FND_PROFILE_OPTIONS_VL',      'N_FND_TERRITORIES_VL',
       'N_FND_DOCUMENTS_VL',            'N_FND_VAL_ATTRIBUTE_TYPES_VL',
       'N_FND_LANGUAGES_VL',            'N_APPS_SECURITY_INFO_VL',
       'N_AP_LOOKUPS_VL',               'N_AP_LOOKUP_TYPES_VL',
       'N_AR_LOOKUPS_VL',               'N_AR_LOOKUP_TYPES_VL',
       'N_BEN_LOOKUPS_VL',              'N_BEN_LOOKUP_TYPES_VL',
       'N_CE_LOOKUPS_VL',               'N_CE_LOOKUP_TYPES_VL',
       'N_CS_LOOKUPS_VL',               'N_CS_LOOKUP_TYPES_VL',
       'N_CSI_LOOKUPS_VL',              'N_CSI_LOOKUP_TYPES_VL',
       'N_FA_LOOKUPS_VL',               'N_FA_LOOKUP_TYPES_VL',
       'N_FND_COMMON_LOOKUPS_VL',       'N_FND_COMMON_LOOKUP_TYPES_VL',
       'N_FND_LOOKUPS_VL',              'N_FND_LOOKUP_TYPES_VL',
       'N_FUN_LOOKUPS_VL',              'N_FUN_LOOKUP_TYPES_VL',
       'N_FV_LOOKUPS_VL',               'N_FV_LOOKUP_TYPES_VL',
       'N_GL_LOOKUPS_VL',               'N_GL_LOOKUP_TYPES_VL',
       'N_GMD_LOOKUPS_VL',              'N_GMD_LOOKUP_TYPES_VL',
       'N_GME_LOOKUPS_VL',              'N_GME_LOOKUP_TYPES_VL',
       'N_GMF_LOOKUPS_VL',              'N_GMF_LOOKUP_TYPES_VL',
       'N_GMI_LOOKUPS_VL',              'N_GMI_LOOKUP_TYPES_VL',
       'N_GMP_LOOKUPS_VL',              'N_GMP_LOOKUP_TYPES_VL',
       'N_GMS_LOOKUPS_VL',              'N_GMS_LOOKUP_TYPES_VL',
       'N_HR_LOOKUPS_VL',               'N_HR_LOOKUP_TYPES_VL',
       'N_IEX_LOOKUPS_VL',              'N_IEX_LOOKUP_TYPES_VL',
       'N_MFG_LOOKUPS_VL',              'N_MFG_LOOKUP_TYPES_VL',
       'N_OKE_LOOKUPS_VL',              'N_OKE_LOOKUP_TYPES_VL',
       'N_PA_LOOKUPS_VL',               'N_PA_LOOKUP_TYPES_VL',
       'N_PJI_LOOKUPS_VL',              'N_PJI_LOOKUP_TYPES_VL',
       'N_PO_LOOKUPS_VL',               'N_PO_LOOKUP_TYPES_VL',
       'N_QA_LOOKUPS_VL',               'N_QA_LOOKUP_TYPES_VL',
       'N_QP_LOOKUPS_VL',               'N_QP_LOOKUP_TYPES_VL',
       'N_SO_LOOKUPS_VL',               'N_SO_LOOKUP_TYPES_VL',
       'N_OE_LOOKUPS_VL',               'N_OE_LOOKUP_TYPES_VL',
       'N_WF_LOOKUPS_VL',               'N_WF_LOOKUP_TYPES_VL',
       'N_WSH_LOOKUPS_VL',              'N_WSH_LOOKUP_TYPES_VL',
       'N_XLA_LOOKUPS_VL',              'N_XLA_LOOKUP_TYPES_VL',
       'N_WF_MESSAGES_VL',
       'N_FND_USER_RESPONSIBILITY_VL',  'N_FND_USER_RESP_GROUPS_VL',
       'N_FND_SECURITY_GROUPS_VL',
       'DIS_ALL_DOCS',   'DIS_DOCS',    'DIS_GRANTS',
       'N_GL_AVERAGE_BALANCES_VL',
       'NV_NQS_RESPONSIBILITY_LIST',    'NV_NQS_APPLICATION_LOGIN_IDS',
       'N_PROPERTY_TYPE_TEMPLATES_V',   'N_VIEW_COL_TYPE_PROP_T_TMPL_V',
       'N_VIEW_PROPERTY_TEMPLATES_V',
       'N_METADATA_TABLES_V',           'N_METADATA_COLUMNS_V',
       'N_JOIN_KEY_COLUMNS_V',          'N_JOIN_KEY_COL_TEMPLATES_V',
       ------------------------- Metabuilder API Views --------------------------------
       'N_API_ALL_FOLDER_GROUPS_V',     'N_API_ALL_FOLDERS_V',
       'N_API_ANSWERS_V',               'N_API_ANS_QUERIES_V',
       'N_API_ANS_TABLES_V',            'N_API_ANS_WHERES_V',
       'N_API_ANS_COLUMNS_V',           'N_API_LOV_COLUMNS_V',
       'N_API_ANS_COLUMN_TOTALS_V',     'N_API_ANS_PARAMS_V',
       'N_API_ANS_PARAM_VALUES_V',      
       'N_API_APPLICATION_OWNERS_V',    'N_API_APPL_OWNER_ROLES_V',      
       'N_API_APPL_MODULE_NAMES_V',
       'N_API_DATASOURCES_V',
       'N_API_DIMENSIONS_V',            'N_API_DIMENSION_COLUMNS_V',
       'N_API_FOLDER_STRUCT_GLOBAL_V',  'N_API_FOLDER_STRUCT_PROJECTS_V',
       'N_API_FOLDER_STRUCT_XOP_V',     'N_API_FOLDER_STRUCT_V',         
       'N_API_FS_ORPHANS_V',            
       'N_API_HELP_QUESTIONS_V',        'N_API_HELP_SEE_OTHERS_V',
       'N_API_INSTALL_TYPES_V',         'N_API_KFF_COLUMNS_V',
       'N_API_MODULE_NAMES_V',          'N_API_ORACLE_USERS_V',          
       'N_API_PRES_VIEWS_V',            'N_API_PRES_VIEW_COLUMNS_V',
       'N_API_QK_VIEWS_V',
       'N_API_QUERY_USERS_V',           'N_API_QUERY_USER_ROLES_V',      
       'N_API_ROLES_V',                 'N_API_ROLE_VIEWS_V',            
       'N_API_STRUCTURE_BY_BUSGRP_V',   'N_API_COPY_VIEWS_V',
       'N_API_VIEW_TEMPLATES_V',        'N_API_VIEW_COLUMN_TEMPLATES_V',
       'N_API_VIEW_TABLE_TEMPLATES_V',  'N_API_VIEW_TABCOL_TEMPLATES_V',
       'N_API_VIEW_ALL_QUERIES_V',      'N_API_VIEW_ALL_COLUMNS_V',      
       'N_API_VIEW_ALL_TABLES_V',       'N_API_VIEW_ALL_TABLE_COLUMNS_V',
       'N_API_VIEWS_V',                 'N_API_VIEW_QUERIES_V',
       'N_API_VIEW_TABLES_V',           'N_API_VIEW_TABLE_COLUMNS_V',
       'N_API_VIEW_COLUMNS_V',          'N_API_VIEW_KEY_COLUMNS_V',
       'N_API_VIEWS_W_COL_LABELS_V',    'N_API_JOIN_KEYS_V',
       'N_API_GBL_VIEW_COLUMNS_V',      'N_API_STD_VIEW_COLUMNS_V',
       'N_API_STD_VIEWS_V',             'N_API_VIEW_PARAMETERS_V',
       'N_API_MD_HIERARCHIES_V',        'N_API_MD_HIERARCHY_LEVELS_V',
       'N_API_ALL_APPL_OWNER_ROLES_V',  'N_ALL_API_ROLES_V',
       'N_API_ALL_ROLE_VIEWS_V',        'N_API_PRES_COLUMN_DESCR_V',
       'N_API_SECURITY_COLUMNS_V',      'N_API_ROW_LEVEL_ACCESS_V',
       ------------------------- View Parameters -------------------------------------
       'N_VIEW_PARAMETERS_CURRENT_V',   'N_VIEW_PARAM_EXT_CURRENT_V',
       ------------------------ PEOPLESOFT VIEWS -------------------------------------
       'N_PS_LOOKUPS_V',
            ------------------------ GLOBAL SEG VIEWS -------------------------------------
       'N_F_KFF_SEG_QUAL_VIEW',          'N_FND_ID_FLEX_STRUCTURES_VIEW',
       'N_FND_FLEX_VALUES_VIEW',         'N_F_KFF_SEG_QUAL_HELPER_VIEW',
       'N_F_KFF_STRGRP_HELPER_VIEW',     'N_F_KFF_SEGSTRUCT_HELPER_1',
       'N_F_KFF_SEGSTRUCT_HELPER_2',     'N_F_KFF_SEGSTRUCT_HELPER_3',
       'N_F_KFF_SEGSTRUCT_HELPER_4',     'N_F_KFF_FLX_HELPER_1',
       'N_F_KFF_FLX_HELPER_2',           'N_F_KFF_FLX_HELPER_3',
       'N_KEYVIEW_HELPER_V', 'N_VIEW_JOIN_RELN_HELPER_1', 'N_VIEW_JOIN_RELN_HELPER_2', 
       'N_F_KFF_STRGRP_SUBSET_VIEW',
       ------------------------- Parent Child Views --------------------------------
       'N_HIERARCHIES',
       ------------------------- Join Key Views --------------------------------
       'N_JOIN_KEY_HELPER_1', 'N_JOIN_KEY_HELPER_2',
       --------------------- SECURITY MANAGER VIEWS ----------------------------------
       'N_QU_OU_MAPPINGS_V',             'N_QU_SOB_MAPPINGS_V',
       'N_QU_BG_MAPPINGS_V',             'N_QU_INV_MAPPINGS_V',
       'N_QU_CST_MAPPINGS_V',            'N_QU_OPM_MAPPINGS_V',
       'N_QU_COA_MAPPINGS_V',            'N_QU_SINST_MAPPINGS_V',
       'N_SM_OU_MAPPINGS_V',            
       'N_SM_SOB_MAPPINGS_V',            'N_SM_SOB_FV_MAPPINGS_V',
       'N_SM_BG_MAPPINGS_V',             'N_SM_INV_MAPPINGS_V',
       'N_SM_CST_MAPPINGS_V',            'N_SM_OPM_MAPPINGS_V',
       'N_SM_COA_MAPPINGS_V',            'N_SM_SINST_MAPPINGS_V',
       'N_SM_ATTRIBUTE_MODULES_V',       'N_SM_PROPERTIES_V',
       'N_SM_RELATED_PROPERTIES_V',
       'N_SM_GROUPS_V',                  'N_SM_GRANTED_USER_AUTHS_V',
       'N_SM_EFF_GROUP_AUTHS_V',         'N_SM_EFF_USER_AUTHS_V',
       'N_SM_ALL_EFF_USER_AUTHS_V',
       'N_SM_EFF_USER_GEN_AUTHS_V',      'N_SM_EFF_GRP_GEN_AUTHS_V',
       'N_SM_GROUP_HIERARCHY_V',         'N_SM_FULL_GROUP_HIERARCHY_V',
       'N_SM_BG_ALL_ACCESS_V',           'N_SM_BG_APPS_ACCESS_V',
       'N_SM_BG_CURRENT_USER_ACCESS_V', 
       'N_SM_SOB_ALL_ACCESS_V',          'N_SM_SOB_APPS_ACCESS_V',
       'N_SM_SOB_CURRENT_USER_ACCESS_V', 
       'N_SM_OU_ALL_ACCESS_V',           'N_SM_OU_APPS_ACCESS_V',
       'N_SM_OU_CURRENT_USER_ACCESS_V', 
       'N_SM_INV_ALL_ACCESS_V',          'N_SM_INV_APPS_ACCESS_V',
       'N_SM_INV_CURRENT_USER_ACCESS_V', 
       'N_SM_SR_CURRENT_USER_ACCESS_V',  'N_SM_SR_APPS_ACCESS_V',
       'N_SM_SR_ALL_ACCESS_V',
       'N_SM_BLVL_ALL_ACCESS_V',         'N_SM_BLVL_APPS_ACCESS_V',
       'N_SM_BLVL_CUR_USER_ACCESS_V', 
       'N_SM_KFF_CURRENT_USER_ACCESS_V', 
       'N_SM_KFF_ROLLUP_USER_ACCESS_V',  'N_SM_KFF_SOB_ROLLUP_ACCESS_V',
       'N_SM_KFF_INV_ROLLUP_ACCESS_V',   'N_SM_KFF_OU_ROLLUP_ACCESS_V',
       'N_SM_KFF_UNROLLUP_USR_ACCESS_V',
       'N_SM_RC_ALL_ROLE_CLASSES_V',     'N_SM_ALL_ROLES_V',
       'N_SM_ROLE_CUR_USER_ACCESS_V',    'N_SM_GRANTED_USER_ROLES_V',
       'N_SM_ORG_ROLES_V',               'N_SM_ROLE_ORG_LIST_V',
       'N_SOB_SECURITY_V',               'N_GL_SETS_OF_BOOKS_V',
       'N_FV_SECURITY_V',                'N_FV_BUDGET_LEVELS_V',
       'N_HR_OPERATING_UNITS_VL',        'N_SECURITY_PROFILE_OU_LIST_VL',
       'N_ORG_ORGANIZATIONS_VL',         'N_INVENTORY_ORG_SECURITY_V',
       'N_MTL_PARAMETERS_V',
       'N_OPM_SECURITY_V',               'N_OPM_ORGN_V',
       'N_CS_INCIDENT_TYPES_VL',         'N_CS_SR_TYPE_MAPPING_V',
       'N_CS_SYSTEM_OPTIONS_V',
       'N_RESPONSIBILITY_FORMS_V',       
       'N_ACL_ACCESS_ENABLED_V',         'N_ACL_MODULES_GENERATED_V',
       'N_NOETIX_DFLT_APPL_NAMES_VL',
       'N_SM_USER_CONNECTIONS_V',        'N_SM_USER_CONNECTIONS_BASE_V',
       'N_SM_SERVER_CONNECTIONS_V',      'N_SM_APPS_USER_RESP_SG_V',
       'N_CSI_USERS_V',                  'N_CSI_USER_PERMISSION_V',
       'N_CSI_I_ORG_ASSIGNMENTS_V',      'N_HZ_PARTIES_V',
       'N_CSI_ITEM_INSTANCES_DUP_V', 
       'N_SOB_STRUCTURE_RULES_V',
       ---------------------- HXC VIEW  ----------------------------------
       'N_HXC_MISSING_PERIODS_V',
       ---------------------- BOM VIEW  ----------------------------------
       'N_BOM_EXPLOSION_BASE_V',
       ---------------------- AP VIEW   -----------------------------------
       'N_XLA_TB_DEFN_DETAILS_V',
       ---------------------- ASCP VIEW -----------------------------------
       'N_MSD_SCENARIOS_V',
       ---------------------- CUSTOM VIEWS --------------------------------
       'N_BEN_OPEN_ENROLLMENTS', 'N_BEN_MONTHLY_MEDICAL_VSAT',
       'PA_USER_PROJECTS_VSAT','N_IB_INTENDED_BOM_VSAT', 'N_CST_CG_COST_HISTORY_VSAT', 'N_PO_PRICE_LIST_VSAT',
       'N_PROJ_UB_UE_RECON', 'N_PO_VENDOR_SITES_VSAT','N_SOX_EAC_CHANGES_VSAT'
     )
   and view_name not like 'DISCOV%'
   and view_name not like 'DQ4V%'
   and view_name not like 'EUL%'
   and view_name not like 'N_ANS%'
   and not exists
     ( select f.target_value_object_name||'_V' 
         from n_f_kff_flex_sources f
        where f.zero_latency         = 'Y' )
   and not exists
      ( select 'Dont drop views that will be recreated'
          from n_view_columns c, n_view_queries q, n_views v
         where upper(v.view_name) = upper(user_views.view_name)
           and nvl(v.omit_flag,'N') = 'N'
           and q.view_name = v.view_name
           and c.view_name = q.view_name
           and c.query_position = q.query_position
           and c.column_type in ('COL','EXPR','GEN','GENEXPR','ALOOK','CONST')
           and nvl(c.omit_flag,'N') = 'N'  )
   and not exists
       ( select 'This view name is in N_CUSTOM_OBJECTS.'
           from n_custom_objects k
          where upper(k.view_name) = upper(user_views.view_name)
       )
   and not exists
       ( select 'Used for key flexfields in global views'
         from n_seg_id_flex_code_headers seg
         where upper(seg.view_name) = upper(user_views.view_name)
       )
/
--
-- dglancy 07-Oct-98
-- Drop the views created for release 11
--
-- dglancy 04-Oct-98
-- Remove views from list that no longer exist.
-- fnd_descriptive_flexs, fnd_descr_flex_column_usuages,
-- fnd_descr_flex_contexts, fnd_flex_value_rules,
-- fnd_id_flex_segments, fnd_id_flex_structures
-- In release 11, the following are local synonyms pointing to
-- a noetix_%_vl views:
-- FND_APPLICATION, fnd_currencies, fnd_territories, fnd_responsibility,
-- and fnd_flex_values
--
SELECT 'drop view '||view_name||';'
  FROM user_views
 WHERE view_name    IN ( 'FND_FORM' )
/
spool off

whenever sqlerror exit 60
@utlstart tmpdropv continue

-- end dropvw.sql
