-- Title
--    wnoetxu2.sql
-- Function
--    Perform customer update sql processes  
--    will be custom for each update release
--
-- Description
--    Do nothing for this release
--
-- Copyright Noetix Corporation 1992-2007  All Rights Reserved
--
-- History
--   20-Nov-94 D Cowles
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   24-Jan-02 D Glancy   Added note for the consultants and support as to the use
--                        for this script. Issue #4320.
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- NOTE:  ALL Inserts/Updates to the templates tables should be put in this script
--        and this script alone.
--        DO NOT include any other sql statements in this script that are expected to
--        run on every install.  Otherwise, the code will be skipped if the meta_data_load
--        restart point is picked.
--
--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--

--
@application_label_oke.sql;
@Oke_adv_security_on.sql;
@project_contracts_role.sql;
@oke_11510_onwards_profile.sql;
@oke_1159_onwards_profile.sql;
@oke_xop_and_global_profile.sql;
--
@Oke_ou_acl_map_base_view.sql;
@Oke_ou_acl_map_base_query.sql;
@Oke_ou_acl_map_base_table.sql;
@Oke_ou_acl_map_base_where.sql;
@Oke_ou_acl_map_base_column.sql;
@Oke_ou_acl_map_base_role_view.sql;
--
@okc_table_change_r12.sql
@po_table_change_r12.sql
--
@oke_ap_invoices_base_view.sql;
@oke_ap_invoices_base_query.sql;
@oke_ap_invoices_base_table.sql;
@oke_ap_invoices_base_column.sql;
@oke_ap_invoices_base_where.sql;
@oke_ap_invoices_base_role.sql;
---
@oke_ar_payment_sched_base_view.sql;
@oke_ar_payment_sched_base_query.sql;
@oke_ar_payment_sched_base_table.sql;
@oke_ar_payment_sched_base_column.sql;
@oke_ar_payment_sched_base_role.sql;
---
@oke_project_contracts_view.sql;
@oke_project_contracts_query.sql;
@oke_project_contracts_table.sql;
@oke_project_contracts_where.sql;
@oke_project_contracts_column.sql;
@oke_project_contracts_question.sql;
@oke_project_contracts_role.sql;
---
@oke_project_contract_lines_view.sql;
@oke_project_contract_lines_query.sql;
@oke_project_contract_lines_table.sql;
@oke_project_contract_lines_where.sql;
@oke_project_contract_lines_column.sql;
@oke_project_contract_lines_question.sql;
@oke_project_contracts_lines_role.sql;
---
@oke_project_contract_roles_view.sql;
@oke_project_contract_roles_query.sql;
@oke_project_contract_roles_table.sql;
@oke_project_contract_roles_where.sql;
@oke_project_contract_roles_column.sql;
@oke_project_contract_roles_question.sql;
@oke_project_contracts_roles_role.sql;
---
-----------------------------------
@oke_prj_contr_fund_sources_view.sql
@oke_prj_contr_fund_sources_query.sql
@oke_prj_contr_fund_sources_table.sql
@oke_prj_contr_fund_sources_column.sql
@oke_prj_contr_fund_sources_where.sql
@oke_prj_contr_fund_sources_question.sql
@oke_prj_contr_fund_sources_roleview.sql

------------------
@oke_prj_contr_fund_alloctn_view.sql
@oke_prj_contr_fund_alloctn_query.sql
@oke_prj_contr_fund_alloctn_table.sql
@oke_prj_contr_fund_alloctn_column.sql
@oke_prj_contr_fund_alloctn_where.sql
@oke_prj_contr_fund_alloctn_question.sql
@oke_prj_contr_fund_alloctn_roleview.sql

-----------------
@oke_prj_contr_funding_hist_view.sql
@oke_prj_contr_funding_hist_query.sql
@oke_prj_contr_funding_hist_table.sql
@oke_prj_contr_funding_hist_column.sql
@oke_prj_contr_funding_hist_where.sql
@oke_prj_contr_funding_hist_question.sql
@oke_prj_contr_funding_hist_roleview.sql

@oke_prj_contr_deliverables_view.sql;
@oke_prj_contr_deliverables_query.sql;
@oke_prj_contr_deliverables_table.sql;
@oke_prj_contr_deliverables_column.sql;
@oke_prj_contr_deliverables_where.sql;
@oke_prj_contr_deliverables_question.sql;
@oke_prj_contr_deliverables_roleview.sql;
-----
@oke_deliverable_receivables_view.sql;
@oke_deliverable_receivables_query.sql;
@oke_deliverable_receivables_table.sql;
@oke_deliverable_receivables_column.sql;
@oke_deliverable_receivables_where.sql;
@oke_deliverable_receivables_help_que.sql;
@oke_deliverable_receivables_role.sql;

---
@oke_deliverable_po_pay_dtl_view.sql;
@oke_deliverable_po_pay_dtl_query.sql;
@oke_deliverable_po_pay_dtl_table.sql;
@oke_deliverable_po_pay_dtl_where.sql;
@oke_deliverable_po_pay_dtl_column.sql;
@oke_deliverable_po_pay_dtl_help_que.sql;
@oke_deliverable_po_pay_dtl_role.sql;
---
@oke_deliverable_po_rcp_dtl_view.sql;
@oke_deliverable_po_rcp_dtl_query.sql;
@oke_deliverable_po_rcp_dtl_table.sql;
@oke_deliverable_po_rcp_dtl_column.sql;
@oke_deliverable_po_rcp_dtl_where.sql;
@oke_deliverable_po_rcp_dtl_help_que.sql;
@oke_deliverable_po_rcp_dtl_role.sql;
---
@oke_proj_contract_parties_view.sql;
@oke_proj_contract_parties_query.sql;
@oke_proj_contract_parties_table.sql;
@oke_proj_contract_parties_where.sql;
@oke_proj_contract_parties_column.sql;
@oke_proj_contract_parties_question.sql;
@oke_proj_contract_parties_role.sql;
---
@oke_proj_contr_user_attrs_view.sql;
@oke_proj_contr_user_attrs_query.sql;
@oke_proj_contr_user_attrs_table.sql;
@oke_proj_contr_user_attrs_column.sql;
@oke_proj_contr_user_attrs_where.sql;
@oke_proj_contr_user_attrs_question.sql;
@oke_proj_contr_user_attrs_role.sql;
----
@oke_proj_contract_events_view.sql;
@oke_proj_contracts_events_query.sql;
@oke_proj_contract_events_table.sql;
@oke_proj_contract_events_where.sql;
@oke_proj_contract_events_column.sql;
@oke_proj_contract_events_question.sql;
@oke_proj_contract_events_role.sql;
---
@oke_deliverable_shipments_view.sql
@oke_deliverable_shipments_query.sql
@oke_deliverable_shipments_table.sql
@oke_deliverable_shipments_column.sql
@oke_deliverable_shipments_where.sql
@oke_deliverable_shipments_question.sql
@oke_deliverable_shipments_roleview.sql
-------
@oke_deliverable_subcontrs_view.sql
@oke_deliverable_subcontrs_query.sql
@oke_deliverable_subcontrs_table.sql
@oke_deliverable_subcontrs_column.sql
@oke_deliverable_subcontrs_where.sql
@oke_deliverable_subcontrs_question.sql
@oke_deliverable_subcontrs_roleview.sql
-------------
@oke_proj_contr_std_notes_view.sql;
@oke_proj_contr_std_notes_query.sql;
@oke_proj_contr_std_notes_table.sql;
@oke_proj_contr_std_notes_column.sql;
@oke_proj_contr_std_notes_where.sql;
@oke_proj_contr_std_notes_question.sql;
@oke_proj_contr_std_notes_roleview.sql;
-------------
@oke_prj_contr_line_std_notes_view.sql;
@oke_prj_contr_line_std_notes_query.sql;
@oke_prj_contr_line_std_notes_table.sql;
@oke_prj_contr_line_std_notes_column.sql;
@oke_prj_contr_line_std_notes_where.sql;
@oke_prj_contr_line_std_notes_question.sql;
@oke_prj_contr_line_std_notes_roleview.sql;
-------------
@oke_deliverable_std_notes_view.sql;
@oke_deliverable_std_notes_query.sql;
@oke_deliverable_std_notes_table.sql;
@oke_deliverable_std_notes_column.sql;
@oke_deliverable_std_notes_where.sql;
@oke_deliverable_std_notes_question.sql;
@oke_deliverable_std_notes_roleview.sql;
-------------
@oke_project_contract_terms_view.sql;
@oke_project_contract_terms_query.sql;
@oke_project_contract_terms_table.sql;
@oke_project_contract_terms_column.sql;
@oke_project_contract_terms_where.sql;
@oke_project_contract_terms_question.sql;
@oke_project_contract_terms_roleview.sql;
------------
@oke_project_contracts_seeother.sql;
@oke_prj_contr_deliverables_seeother.sql;
@oke_project_contract_lines_seeother.sql;
@oke_prj_contr_funding_hist_seeother.sql
@oke_prj_contr_fund_alloctn_seeother.sql
@oke_prj_contr_fund_sources_seeother.sql
@oke_deliverable_subcontrs_seeother.sql
@oke_deliverable_shipments_seeother.sql
@oke_proj_contract_events_seeother.sql;
@oke_deliverable_po_rcp_dtl_see_other.sql;
@oke_deliverable_po_pay_dtl_see_other.sql;
@oke_deliverable_receivables_see_other.sql;
--
@oke_pa_pcontract_projects_view.sql;
@oke_pa_pcontract_projects_query.sql;
@oke_pa_pcontract_projects_table.sql;
@oke_pa_pcontract_projects_column.sql;
@oke_pa_pcontract_projects_where.sql;
@oke_pa_pcontract_projects_role.sql;
--
@oke_pcontract_print_forms_view.sql;
@oke_pcontract_print_forms_query.sql;
@oke_pcontract_print_forms_table.sql;
@oke_pcontract_print_forms_where.sql;
@oke_pcontract_print_forms_column.sql;
@oke_pcontract_print_forms_role.sql;
--
@oke_pcontract_articles_view.sql
@oke_pcontract_articles_query.sql
@oke_pcontract_articles_table.sql
@oke_pcontract_articles_column.sql
@oke_pcontract_articles_where.sql
@oke_pcontract_articles_role.sql
--
@oke_pcontract_print_forms_question.sql;
@oke_pcontract_articles_question.sql;
@oke_pa_pcontract_projects_question.sql;

@oke_proj_contr_std_notes_See_other.sql;
@oke_prj_contr_line_std_notes_See_other.sql;
@oke_pcontract_print_forms_See_other.sql;
@oke_deliverable_std_notes_See_other.sql;
@oke_pcontract_articles_see_other.sql;
--
@oke_n_view_col_property_templates.sql;

@POWITHCLM_Profile_Option.sql;



@SOX_Role_And_Subject_Area_u2.sql

@po_notes_long_tab.sql


-- end wnoetxu2.sql


