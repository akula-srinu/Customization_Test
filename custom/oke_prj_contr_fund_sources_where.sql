-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_sources_where

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 1, 'AND CHDR.ID = FUNDS.OBJECT_ID', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 1.1, 'AND CHDR.AUTHORING_ORG_ID = XMAP.ORG_ID', '%', 'Rvattikonda', TO_DATE('06/05/2008 04:34:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 1.2, 'AND XMAP.APPLICATION_LABEL     = ''OKE''', '%', 'kkondaveeti', TO_DATE('06/20/2008 06:36:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));

SET SCAN OFF

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 1.3, 'AND XMAP.APPLICATION_INSTANCE  = ''&APPLICATION_INSTANCE''', '%', 'kkondaveeti', TO_DATE('06/20/2008 06:36:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));

SET SCAN ON

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 2, 'AND CHDR.ID = PHDR.K_HEADER_ID', '%', 'pvemuru', TO_DATE('07/01/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/01/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 2.1, 'AND VERS.CHR_ID = CHDR.ID', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/01/2008 05:54:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 3, 'AND PRTY.PARTY_ID(+) = FUNDS.K_PARTY_ID', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 4, 'AND PPRTY.POOL_PARTY_ID(+) = FUNDS.POOL_PARTY_ID', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 5, 'AND FPOOL.FUNDING_POOL_ID(+) = PPRTY.FUNDING_POOL_ID', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 6, 'AND ORGL.ORGANIZATION_ID(+) = FUNDS.AGREEMENT_ORG_ID', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:49:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:40:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 7, 'AND ORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', '%', 'pvemuru', TO_DATE('07/17/2008 23:34:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 23:34:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff
