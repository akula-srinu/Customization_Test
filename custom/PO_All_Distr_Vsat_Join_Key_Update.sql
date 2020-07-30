@utlspon PO_All_Distr_Vsat_Join_Key_Update

UPDATE n_join_key_templates
   SET referenced_pk_t_join_key_id =
          (SELECT t_join_key_id
             FROM n_join_key_templates
            WHERE     view_label LIKE 'PO_Purchase_Orders'
                  AND key_type_code = 'PK'
                  AND column_type_code = 'ROWID')
 WHERE view_label LIKE 'PO_All_Distribution_Vsat'
       AND pl_ref_pk_view_name_modifier = 'POHDR';
 
 
 
UPDATE n_join_key_col_templates
   SET column_label = 'POHDR$PO_Purchase_Orders'
 WHERE t_join_key_id =
          (SELECT t_join_key_id
             FROM n_join_key_templates
            WHERE     view_label LIKE 'PO_All_Distribution_Vsat'
                  AND key_type_code = 'FK'
                  AND pl_ref_pk_view_name_modifier = 'POHDR');

	commit;

@utlspoff
