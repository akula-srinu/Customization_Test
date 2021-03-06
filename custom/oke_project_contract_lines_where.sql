-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_lines_where
--
--
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 1, 'AND CHDR.ID = PHDR.K_HEADER_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:08:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:08:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 2, 'AND CHDRL.ID(+) = CHDR.ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:08:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:08:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 3, 'AND CHDRL.LANGUAGE  (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:09:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:09:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 4, 'AND PROJ.PROJECT_ID (+) = PHDR.PROJECT_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:09:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:09:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 5, 'AND CHDR.AUTHORING_ORG_ID = XMAP.ORG_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:10:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/27/2008 05:57:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 5.1, 'AND XMAP.APPLICATION_LABEL     = ''OKE''', NULL, 
    '%', 'hpothuri', TO_DATE('06/27/2008 05:55:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/27/2008 05:55:00', 'MM/DD/YYYY HH24:MI:SS'));
set scan off;
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 5.2, 'AND XMAP.APPLICATION_INSTANCE  = ''&APPLICATION_INSTANCE''', NULL, 
    '%', 'hpothuri', TO_DATE('06/27/2008 05:55:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/27/2008 05:55:00', 'MM/DD/YYYY HH24:MI:SS'));
set scan on;
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 6, 'AND CLNE.DNZ_CHR_ID = CHDR.ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:10:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:10:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 7, 'AND CLNEL.ID(+) = CLNE.ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:10:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:10:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 8, 'AND CLNEL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 9, 'AND PLNE.K_LINE_ID = CLNE.ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 10, 'AND TASK.TASK_ID(+) = PLNE.TASK_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 11, 'AND ITEM.INVENTORY_ITEM_ID(+) = PLNE.INVENTORY_ITEM_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:12:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:12:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 12, 'AND (ITEM.ORGANIZATION_ID = CHDR.INV_ORGANIZATION_ID  OR ITEM.ORGANIZATION_ID IS NULL)', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:12:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:12:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 13, 'AND PRJT.PROJECT_TYPE(+)  = PROJ.PROJECT_TYPE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:12:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:12:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 14, 'AND PRJT.ORG_ID(+) = PROJ.ORG_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 15, 'AND MCHDR.ID (+) =  PHDR.BOA_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 16, 'AND PRGM.PROGRAM_ID(+) = PHDR.PROGRAM_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 17, 'AND VERS.CHR_ID(+) = CHDR.ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:14:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:14:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 18, 'AND PRCL.PRIORITY_CODE(+) = PLNE.PRIORITY_CODE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:14:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:14:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 18.1, 'AND PRCL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'hpothuri', TO_DATE('06/23/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/23/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 19, 'AND LSTYL.ID(+) = CLNE.LSE_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:14:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:14:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 20, 'AND LSTYL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:15:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 20.1, 'AND HLD.K_HEADER_ID (+) = CLNE.DNZ_CHR_ID', NULL, 
    '%', 'hpothuri', TO_DATE('07/15/2008 02:56:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/15/2008 02:56:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 20.2, 'AND HLD.K_LINE_ID (+) = CLNE.ID', NULL, 
    '%', 'hpothuri', TO_DATE('07/15/2008 02:56:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/15/2008 02:56:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 20.3, 'AND HLD.DELIVERABLE_ID (+) IS NULL', NULL, 
    '%', 'hpothuri', TO_DATE('07/15/2008 02:56:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/15/2008 02:56:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 20.4, 'AND HLD.REMOVE_DATE(+) IS NULL', NULL, 
    '%', 'Rvattikonda', TO_DATE('07/21/2008 03:27:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/21/2008 03:27:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 21, 'AND CORGL.ORGANIZATION_ID(+) = PHDR.OWNING_ORGANIZATION_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:15:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 22, 'AND CORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 23, 'AND IORGL.ORGANIZATION_ID(+) = CHDR.INV_ORGANIZATION_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 24, 'AND IORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 25, 'AND OORGL.ORGANIZATION_ID(+) = CHDR.AUTHORING_ORG_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:16:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 26, 'AND OORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:17:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:17:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 27, 'AND PORGL.ORGANIZATION_ID(+) = PROJ.ORG_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:17:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:17:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 28, 'AND PORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'Rvattikonda', TO_DATE('06/18/2008 05:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:18:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 29, 'AND HSTSL.HOLD_STATUS_CODE (+) = HLD.HOLD_STATUS_CODE', NULL, 
    '%', 'hpothuri', TO_DATE('07/15/2008 03:10:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('07/21/2008 06:49:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 30, 'AND HSTSL.LANGUAGE (+) = NOETIX_ENV_PKG.GET_LANGUAGE', NULL, 
    '%', 'hpothuri', TO_DATE('07/15/2008 03:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('07/21/2008 06:49:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff ;
