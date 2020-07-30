@utlspon pa_budget_versions_pa_projects_u2

UPDATE n_join_key_templates fv
   SET fv.outerjoin_flag = 'Y', OUTERJOIN_DIRECTION_CODE= 'PK'
 WHERE t_join_key_id IN
          (SELECT fkv.t_join_key_id
             FROM n_join_key_templates pkv, n_join_key_templates fkv
            WHERE     fkv.referenced_pk_t_join_key_id = pkv.t_join_key_id
                  AND fkv.view_label LIKE 'PA_Budget_Versions'
                  AND fkv.column_type_code = 'ROWID'
                  AND pkv.view_label LIKE 'PA_Projects'
                  AND fkv.column_type_code = 'ROWID');

commit;     

@utlspoff