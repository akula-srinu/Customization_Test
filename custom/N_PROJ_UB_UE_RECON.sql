@utlspon N_PROJ_UB_UE_RECON

CREATE OR REPLACE VIEW N_PROJ_UB_UE_RECON
AS
   SELECT project_number,
          project_type,
          transaction_type,
          event_type,
          event_num,
          pa_amount,
          rev_inv_num,
          line_num,
          event_description,
          gl_period,
          event_type_dff1,
          event_type_dff2,
          event_dff1,
          event_dff2,
          event_dff3,
          event_dff4,
          event_dff5,
          event_dff6,
          gl_date,
          project_id,
          gl_year,
          gl_period_num,
          gl_qrt_num,
          gl_12301,
          gl_24102,
          ledger_id
     FROM apps.via_proj_ub_ue_recon;
/

@utlspoff