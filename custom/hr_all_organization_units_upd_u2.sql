@utlspon HR_ALL_ORGANIZATION_UNITS_upd


update N_VIEW_TABLE_TEMPLATES
set  application_label ='HR'
WHERE VIEW_LABEL LIKE '%Vsat%'
and table_name ='HR_ALL_ORGANIZATION_UNITS';

commit;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'INSTALL_BASE',
      'OE_RMA_Line_Details_Vsat',
      '%',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'SERVICE_CONTRACTS',
      'OE_RMA_Line_Details_Vsat',
      '%',
      null,
      null,
      'nemuser',
      'nemuser'
   );

update n_view_column_templates 
set column_label = 'Ship_From_Org_Name'
where view_label like 'OE_Delivery_Depart_D_Vsat'
and column_label = 'Delivery_Organization';


update n_view_column_templates 
set column_label = 'Vehicle_Departure_Organization'
where view_label like 'OE_Delivery_Depart_D_Vsat'
and column_label = 'Departure_Organization';

update n_view_column_templates
set column_expression =  replace(upper(column_expression), 'NOETIX_VIEWS.','') 
where column_expression like '%NOETIX_VIEWS.NOETIX_VSAT%';

commit;

@utlspoff