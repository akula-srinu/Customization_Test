-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_funding_hist_where

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 1, 'AND FUNDH.FUNDING_SOURCE_ID = FUNDS.FUNDING_SOURCE_ID', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 2, 'AND CHDR.ID = FUNDS.OBJECT_ID', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 2.1, 'AND CHDR.AUTHORING_ORG_ID = XMAP.ORG_ID', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/30/2008 05:45:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 2.2, 'AND XMAP.APPLICATION_LABEL = ''OKE''', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/30/2008 05:45:00', 'MM/DD/YYYY HH24:MI:SS'));

SET SCAN OFF

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 2.3, 'AND XMAP.APPLICATION_INSTANCE = ''&APPLICATION_INSTANCE''', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/30/2008 05:45:00', 'MM/DD/YYYY HH24:MI:SS'));

SET SCAN ON

Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 3, 'AND VERS.CHR_ID = CHDR.ID', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 4, 'AND PRTY.PARTY_ID(+) = FUNDH.K_PARTY_ID', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 5, 'AND ORGL.ORGANIZATION_ID(+) = FUNDS.AGREEMENT_ORG_ID', '%', 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/30/2008 03:18:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 1, 6, 'AND ORGL.LANGUAGE (+) LIKE NOETIX_ENV_PKG.GET_LANGUAGE', '%', 'hpothuri', TO_DATE('07/18/2008 01:59:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/18/2008 01:59:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff