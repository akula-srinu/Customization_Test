@utlspon suppress_project_Security

 

update n_view_column_templates
set column_expression = 'NVL(EXPI.DENOM_BURDENED_COST,NULL)' 
where column_expression like '%%VIEW_COST%'
and view_label in ('PA_All_Expenditure_Items','PA_All_Expenditure_Items_Vsat','PA_Exp_by_GLC_Vsat'); 


commit;

update n_view_column_templates
set column_expression = 'NVL(CDIST.ACCT_BURDENED_COST,0)' 
where column_expression like '%%VIEW_COST%'
and view_label = 'PA_SLA_Cost_Dist';

commit;

update n_view_column_templates
set column_expression = 'NVL(CDIST.DENOM_BURDENED_COST,0)'
where column_expression like '%%VIEW_COST%'
and view_label = 'PA_Cost_Distribution_Lines';

commit;

update n_view_where_templates 
set product_version = 6
where where_clause like '%PAG0_USER%';

commit;

@utlspoff