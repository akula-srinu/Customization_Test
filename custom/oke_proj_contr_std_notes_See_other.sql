-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contr_std_notes_See_other
--
--SQL Statement which produced this data:
--  select * from n_help_see_other_templates t2 where t2.VIEW_LABEL = 'OKE_Proj_Contr_Std_Notes'
--
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Proj_Contr_Std_Notes', 'OKE_Project_Contracts', '[View Essay]', 'rvattikonda', TO_DATE('03/17/2009 04:13:00', 'MM/DD/YYYY HH24:MI:SS'), 'rvattikonda', TO_DATE('03/17/2009 04:13:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff