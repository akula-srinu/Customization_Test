@utlspon subject_area_folders_cs


delete from  n_role_view_templates 
where role_label in ('DEPOT_REPAIR', 'INSTALL_BASE', 'SERVICE_CONTRACTS')
and view_label like 'CS_Customers';


delete from  n_role_view_templates 
where role_label in ('DEPOT_REPAIR', 'INSTALL_BASE', 'SERVICE_CONTRACTS')
and view_label like 'CS_Customer_Accounts';

commit;

@utlspoff
