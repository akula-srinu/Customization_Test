@utlspon subject_area_folders_pa

Insert into N_ROLE_TEMPLATES
   (ROLE_LABEL, APPLICATION_LABEL, META_DATA_TYPE, DESCRIPTION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('SER_PA', 'PA', 'Views', 'Project Views (Service)', 
    'NOETIX', TO_DATE('05/01/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), '090102', TO_DATE('10/01/2002 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), '1.0.0', '6.3.0.1272');

COMMIT;

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_PA', 'PA_Projects', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_PA', 'PA_Tasks', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_PA', 'PA_All_Expenditure_Items_Vsat', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_PA', 'PA_Class_Categories_Vsat', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_PA', 'PA_Rma_Class_Categories_Vsat', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'SER_PA',
      'PA_Exp_by_GLC_Vsat',
      '10.7+',
      null,
      null,
      'nemuser',
      'nemuser'
   );


COMMIT;

delete from  n_role_view_templates 
where role_label in ('INSTALL_BASE', 'SERVICE_CONTRACTS')
and view_label like 'PA_Exp_by_GLC_Vsat';

delete from  n_role_view_templates 
where role_label in ('INSTALL_BASE', 'SERVICE_CONTRACTS')
and view_label like 'PA_Rma_Class_Categories_Vsat';

delete from  n_role_view_templates 
where role_label in ('INSTALL_BASE', 'SERVICE_CONTRACTS')
and view_label like 'PA_Class_Categories_Vsat';

delete from  n_role_view_templates 
where role_label in ('INSTALL_BASE', 'SERVICE_CONTRACTS')
and view_label like 'PA_All_Expenditure_Items_Vsat';

delete from  n_role_view_templates 
where role_label in ('SERVICE_CONTRACTS')
and view_label like 'PA_Projects';

delete from  n_role_view_templates 
where role_label in ('SERVICE_CONTRACTS')
and view_label like 'PA_Tasks';

commit;

Insert into N_PL_FOLDER_TEMPLATES
   (T_FOLDER_ID, APPLICATION_LABEL, ROLE_LABEL, FOLDER_NAME, FOLDER_DESCRIPTION, PARENT_T_FOLDER_ID, SORT_ORDER, SEARCH_FOLDER_NAME, INSTANCE_TYPE_CODE, FOLDER_USAGE_CODE, FOLDER_TYPE_CODE, DISPLAY_VIEWS_IN_PARENT_FLAG, ROLE_REQUIRED_IN_PARENT_CODE, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   (N_PL_FOLDER_TEMPLATES_SEQ.nextval, 'PA', 'SER_PA', 'Project Views', 'Project Views', 
    162, 1, 'Project', 'G', 
    'VIEWS', 'ROLE', 
    'N', 'D', '*', 'Y', 'NOETIX', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'NOETIX_SYS', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_PL_FOLDER_TEMPLATES
   (T_FOLDER_ID, APPLICATION_LABEL, ROLE_LABEL, FOLDER_NAME, FOLDER_DESCRIPTION, PARENT_T_FOLDER_ID, SORT_ORDER, SEARCH_FOLDER_NAME, INSTANCE_TYPE_CODE, FOLDER_USAGE_CODE, FOLDER_TYPE_CODE, DISPLAY_VIEWS_IN_PARENT_FLAG, ROLE_REQUIRED_IN_PARENT_CODE, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   (N_PL_FOLDER_TEMPLATES_SEQ.nextval, 'PA', 'SER_PA', 'Project Answers', 'Project Answers', 
    162, 1, 'Project', 'G', 
    'ANS', 'ROLE', 
    'N', 'D', '*', 'Y', 'NOETIX', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'NOETIX_SYS', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;

@utlspoff
