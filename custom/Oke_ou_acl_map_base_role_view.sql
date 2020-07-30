-- 07-Apr-2011 HChodavarapu Added for new XMAP creation.

@utlspon OKE_OU_ACL_Map_Base_role_view
SET SCAN OFF
insert into n_role_view_templates (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
values ('PROJECT_CONTRACTS', 'OKE_OU_ACL_Map_Base', '11.5+', 'hchodavarapu', to_date('07-04-2011 06:30:00', 'dd-mm-yyyy hh24:mi:ss'), 
'hchodavarapu', to_date('07-04-2011 00:18:00', 'dd-mm-yyyy hh24:mi:ss'));
commit;
SET SCAN ON
@utlspoff
