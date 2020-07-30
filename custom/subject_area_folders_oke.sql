@utlspon subject_area_folders_oke


Insert into N_ROLE_TEMPLATES
   (ROLE_LABEL, APPLICATION_LABEL, META_DATA_TYPE, DESCRIPTION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('SER_OKE', 'OKE', 'Views', 'Project Contract Views (Service)', 
    'NOETIX', TO_DATE('05/01/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), '090102', TO_DATE('10/01/2002 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), '1.0.0', '6.3.0.1272');

COMMIT;

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_OKE', 'OKE_Project_Contracts', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('SER_OKE', 'OKE_Proj_Contr_User_Attrs', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

commit;

Insert into N_PL_FOLDER_TEMPLATES
   (T_FOLDER_ID, APPLICATION_LABEL, ROLE_LABEL, FOLDER_NAME, FOLDER_DESCRIPTION, PARENT_T_FOLDER_ID, SORT_ORDER, SEARCH_FOLDER_NAME, INSTANCE_TYPE_CODE, FOLDER_USAGE_CODE, FOLDER_TYPE_CODE, DISPLAY_VIEWS_IN_PARENT_FLAG, ROLE_REQUIRED_IN_PARENT_CODE, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   (N_PL_FOLDER_TEMPLATES_SEQ.nextval, 'OKE', 'SER_OKE', 'Project Contract Views', 'Project Contract Views', 
    162, 1, 'Project Contracts', 'G', 
    'VIEWS', 'ROLE', 
    'N', 'D', '*', 'Y', 'NOETIX', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'NOETIX_SYS', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_PL_FOLDER_TEMPLATES
   (T_FOLDER_ID, APPLICATION_LABEL, ROLE_LABEL, FOLDER_NAME, FOLDER_DESCRIPTION, PARENT_T_FOLDER_ID, SORT_ORDER, SEARCH_FOLDER_NAME, INSTANCE_TYPE_CODE, FOLDER_USAGE_CODE, FOLDER_TYPE_CODE, DISPLAY_VIEWS_IN_PARENT_FLAG, ROLE_REQUIRED_IN_PARENT_CODE, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   (N_PL_FOLDER_TEMPLATES_SEQ.nextval, 'OKE', 'SER_OKE', 'Project Contract Answers', 'Project Contract Answers', 
    162, 1, 'Project Contracts', 'G', 
    'ANS', 'ROLE', 
    'N', 'D', '*', 'Y', 'NOETIX', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'NOETIX_SYS', TO_DATE('06/18/2013 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff
