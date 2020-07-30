-- File: BNV1631.sql
--
-- To be called from wnoetixu2_legacy.sql or wnoetxu2.sql
--
-- To correct the ItemCat property templates in Inv_Items view
--
-- Reference support ticket # 79777
--
-- Created By: VYARRAMSETTY
--
-- Created Date: 01/June/2016


@utlspon BNV1631

update n_view_property_templates 
set value3 = '1' 
where 1=1 
and t_source_pk_id = (select T_COLUMN_ID from n_view_column_templates
where view_label='INV_Items'
and column_label ='ItemCat')
and property_type_id = 16 
and view_label ='INV_Items' 
; 

commit;

@utlspoff