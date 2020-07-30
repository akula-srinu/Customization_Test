@utlspon equi_to_outer_joins_upd_u2


update n_join_keys
set outerjoin_flag='Y'
where view_label like 'OKS_Scs_Data_Vsat'
and column_type_code='ROWID'
and key_type_code='FK';

commit;

@utlspoff


