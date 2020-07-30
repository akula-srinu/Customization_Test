-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_line_std_notes_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Line_Std_Notes', 1, 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 01:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 01:53:00', 'MM/DD/YYYY HH24:MI:SS'));
@utlspoff

COMMIT;
