--File bom_current_bills_u2
--


@bom_current_bills_u2

update n_view_query_templates
set profile_option = null,
last_updated_by = 'Custom',
last_update_Date = sysdate
where view_label = 'BOM_Current_Structured_Bills'
and profile_option = 'BOM_PRE_DB9I';

update n_view_query_templates
set product_version  = '9.0',
last_updated_by = 'Custom',
last_update_Date = sysdate 
where view_label = 'BOM_Current_Structured_Bills'
and query_position = 8;

COMMIT;

@utlspoff 