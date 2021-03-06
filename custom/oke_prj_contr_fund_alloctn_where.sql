-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_where

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 1, 'AND FUNDS.FUNDING_SOURCE_ID = FALCT.FUNDING_SOURCE_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:46:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 1.1, 'AND CHDR.AUTHORING_ORG_ID = XMAP.ORG_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 06:41:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/27/2008 06:41:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 1.2, 'AND XMAP.APPLICATION_LABEL     = ''OKE''', '%', 'kkondaveeti', TO_DATE('06/27/2008 06:41:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/29/2008 21:54:00', 'MM/DD/YYYY HH24:MI:SS'));

SET SCAN OFF

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 1.3, 'AND XMAP.APPLICATION_INSTANCE  = ''&APPLICATION_INSTANCE''', '%', 'kkondaveeti', TO_DATE('06/27/2008 06:41:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/27/2008 06:46:00', 'MM/DD/YYYY HH24:MI:SS'));

SET SCAN ON

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2, 'AND PRTY.PARTY_ID(+) = FUNDS.K_PARTY_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:46:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.1, 'AND CHDR.ID = FUNDS.OBJECT_ID', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:52:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:52:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.2, 'AND CHDRL.ID(+) = CHDR.ID', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:52:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:52:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.3, 'AND CHDRL.LANGUAGE  (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:52:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:52:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.4, 'AND PHDR.K_HEADER_ID = CHDR.ID', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 03:24:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.5, 'AND PTYP.K_TYPE_CODE = PHDR.K_TYPE_CODE', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:53:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.6, 'AND PTYPL.K_TYPE_CODE(+) = PTYP.K_TYPE_CODE', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 2.7, 'AND PTYPL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', '%', 'Rvattikonda', TO_DATE('06/27/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 3, 'AND CLINB.ID(+) = FALCT.K_LINE_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 4, 'AND CLINL.ID(+) = CLINB.ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 5, 'AND CLINL.LANGUAGE  (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 6, 'AND VERN.CHR_ID = FALCT.OBJECT_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 7, 'AND PROJ.PROJECT_ID(+) = FALCT.PROJECT_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 8, 'AND TASK.TASK_ID(+) = FALCT.TASK_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 9, 'AND PORGL.ORGANIZATION_ID(+) = PROJ.ORG_ID', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 10, 'AND PORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', '%', 'kkondaveeti', TO_DATE('06/27/2008 04:57:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/27/2008 05:47:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff