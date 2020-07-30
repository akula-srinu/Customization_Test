@utlspon OE_Project_Vsat_Base


update N_VIEW_TABLE_TEMPLATES
set  application_label ='HR'
WHERE VIEW_LABEL LIKE 'OE_Project_Vsat_Base'
and table_name ='HR_ALL_ORGANIZATION_UNITS';

commit;

update n_view_column_templates
set group_by_flag='Y' where view_label like 'MRP_Total_Demand_Vsat' and column_label ='Fiscal_Date';

commit;

@utlspoff


