-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_table

Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'CHDR', 3.1, 'OKC', 'OKC_K_HEADERS_B', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 05:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/29/2008 23:50:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'CHDRL', 3.2, 'OKC', 'OKC_K_HEADERS_TL', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 05:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'N');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'CLINB', 4, 'OKC', 'OKC_K_LINES_B', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/29/2008 23:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'CLINL', 5, 'OKC', 'OKC_K_LINES_TL', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 04:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'N');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'FALCT', 1, 'OKE', 'OKE_K_FUND_ALLOCATIONS', '%', 'Y', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:34:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/01/2008 21:47:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, KEY_VIEW_LABEL, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'FUNDS', 2, 'OKE', 'OKE_K_FUNDING_SOURCES', '%', 'Y', 'OKE_Prj_Contr_Fund_Sources', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:35:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, KEY_VIEW_LABEL, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'PHDR', 3.3, 'OKE', 'OKE_K_HEADERS', '%', 'Y', 'OKE_Project_Contracts', 'N', 'Rvattikonda', TO_DATE('06/27/2008 05:50:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/01/2008 21:46:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'PORGL', 9, 'HR', 'HR_ALL_ORGANIZATION_UNITS_TL', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:39:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 03:24:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'PROJ', 7, 'PA', 'PA_PROJECTS_ALL', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 03:24:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'PRTY', 3, 'AR', 'HZ_PARTIES', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:35:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/29/2008 23:51:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'PTYP', 3.4, 'OKE', 'OKE_K_TYPES_B', '%', 'N', 'N', 'kkondaveeti', TO_DATE('06/29/2008 21:54:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/29/2008 21:54:00', 'MM/DD/YYYY HH24:MI:SS'), 'N');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'PTYPL', 3.5, 'OKE', 'OKE_K_TYPES_TL', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 05:51:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/29/2008 21:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'N');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'TASK', 8, 'PA', 'PA_TASKS', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:38:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 03:24:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'VERN', 6, 'OKC', 'OKC_K_VERS_NUMBERS', '%', 'N', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 04:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'N');
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PRODUCT_VERSION, BASE_TABLE_FLAG, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'XMAP', 1.1, 'NOETIX', 'OKE_OU_ACL_MAP_BASE', '%', 'N', 'N', 'kkondaveeti', TO_DATE('06/27/2008 06:43:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/27/2008 06:43:00', 'MM/DD/YYYY HH24:MI:SS'), 'N');

COMMIT;

@utlspoff