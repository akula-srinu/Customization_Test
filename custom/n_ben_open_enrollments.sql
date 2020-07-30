

@utlspon N_BEN_OPEN_ENROLLMENTS


CREATE OR REPLACE FORCE VIEW N_BEN_OPEN_ENROLLMENTS
(
   EMPLOYEE_NUMBER,
   SSN,
   ADP_ID,
   FULL_NAME,
   EMAIL_ADDRESS,
   OLD_PLAN_NAME,
   OLD_PLAN_ID,
   OLD_OPTION_NAME,
   OLD_BNFT_AMT,
   OLD_RATE,
   ENAME,
   FNAME,
   EMAIL,
   NEW_PLAN_NAME,
   NEW_PLAN_ID,
   NEW_OPTION_NAME,
   NEW_BNFT_AMT,
   NEW_RATE,
   OPEN_ENROLLMENT_DATE
)
AS
     SELECT v1.employee_number,
            v1.national_identifier SSN,
            v1.attribute5 ADP_ID,
            v1.full_name,
            v1.email_address,
            v1.old_plan_name,
            v1.pl_id old_plan_id,
            v1.old_option_name,
            v1.old_bnft_amt,
            v1.old_rate,
            v2.employee_number en,
            v2.full_name fn,
            v2.email_address ea,
            v2.new_plan_name,
            v2.pl_id new_plan_id,
            v2.new_option_name,
            v2.new_bnft_amt,
            v2.new_rate,
            v1.lf_evt_ocrd_dt d2
       FROM (SELECT e.person_id,
                    e.employee_number,
                    e.full_name,
                    e.email_address,
                    e.national_identifier,
                    e.attribute5,
                    b.name old_plan_name,
                    c.name old_option_name,
                    b.pl_id,
                    a.bnft_amt old_bnft_amt,
                    NVL (f.cmcd_rt_val, 0) old_rate,
                    q.lf_evt_ocrd_dt
               FROM ben.BEN_PRTT_ENRT_RSLT_F a,
                    ben.ben_pl_f b,
                    ben.ben_opt_f c,
                    ben.ben_oipl_f d,
                    apps.per_people_f e,
                    (SELECT emp.person_id, b.lf_evt_ocrd_dt
                       FROM ben.BEN_PER_IN_LER b,
                            apps.per_people_f emp,
                            hr.per_person_type_usages_f ptu,
                            hr.per_person_types pt
                      WHERE emp.person_id = b.person_id
                            AND b.per_in_ler_stat_cd IN ('PROCD', 'STRTD') --'PROCD'
                            AND SYSDATE BETWEEN emp.effective_start_date
                                            AND emp.effective_end_date
                            AND emp.current_employee_flag = 'Y'
                            AND SYSDATE BETWEEN ptu.effective_start_date
                                            AND ptu.effective_end_date
                            AND ptu.person_type_id = pt.person_type_id
                            AND pt.system_person_type IN ('EMP')
                            AND emp.person_id = ptu.person_id
                            AND pt.user_person_type IN
                                   ('Employee', 'Temporary Employee')) q,
                    ben.BEN_PRTT_RT_VAL f
              WHERE     a.person_id = q.person_id
                    AND a.pl_id = b.pl_id
                    AND a.oipl_id = d.oipl_id
                    AND c.opt_id = d.opt_id
                    AND a.effective_end_date = '31-DEC-4712'
                    AND q.lf_evt_ocrd_dt - 1 BETWEEN b.effective_start_date
                                                 AND b.effective_end_date
                    AND q.lf_evt_ocrd_dt - 1 BETWEEN c.effective_start_date
                                                 AND c.effective_end_date
                    AND q.lf_evt_ocrd_dt - 1 BETWEEN d.effective_start_date
                                                 AND d.effective_end_date
                    AND q.lf_evt_ocrd_dt - 1 BETWEEN e.effective_start_date
                                                 AND e.effective_end_date
                    AND q.lf_evt_ocrd_dt - 1 BETWEEN a.enrt_cvg_strt_dt
                                                 AND a.enrt_cvg_thru_dt
                    AND q.lf_evt_ocrd_dt - 1 BETWEEN NVL (f.rt_strt_dt,
                                                          q.lf_evt_ocrd_dt - 2)
                                                 AND NVL (f.rt_end_dt,
                                                          q.lf_evt_ocrd_dt - 1)
                    AND a.PRTT_ENRT_RSLT_ID = f.PRTT_ENRT_RSLT_ID(+)
                    AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
                    AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
                    AND a.person_id = e.person_id
                    AND a.prtt_enrt_rslt_stat_cd IS NULL) v1,
            (SELECT e.person_id,
                    e.employee_number,
                    e.full_name,
                    e.email_address,
                    e.national_identifier,
                    e.attribute5,
                    b.name new_plan_name,
                    c.name new_option_name,
                    b.pl_id,
                    a.bnft_amt new_bnft_amt,
                    NVL (f.cmcd_rt_val, 0) new_rate,
                    q.lf_evt_ocrd_dt
               FROM ben.BEN_PRTT_ENRT_RSLT_F a,
                    ben.ben_pl_f b,
                    ben.ben_opt_f c,
                    ben.ben_oipl_f d,
                    apps.per_people_f e,
                    (SELECT emp.person_id, b.lf_evt_ocrd_dt
                       FROM ben.BEN_PER_IN_LER b,
                            apps.per_people_f emp,
                            hr.per_person_type_usages_f ptu,
                            hr.per_person_types pt
                      WHERE emp.person_id = b.person_id
                            AND b.per_in_ler_stat_cd IN ('PROCD', 'STRTD') --'PROCD'
                            AND SYSDATE BETWEEN emp.effective_start_date
                                            AND emp.effective_end_date
                            AND emp.current_employee_flag = 'Y'
                            AND SYSDATE BETWEEN ptu.effective_start_date
                                            AND ptu.effective_end_date
                            AND ptu.person_type_id = pt.person_type_id
                            AND pt.system_person_type IN ('EMP')
                            AND emp.person_id = ptu.person_id
                            AND pt.user_person_type IN
                                   ('Employee', 'Temporary Employee')) q,
                    ben.BEN_PRTT_RT_VAL f
              WHERE     a.person_id = q.person_id
                    AND a.pl_id = b.pl_id
                    AND a.oipl_id = d.oipl_id
                    AND c.opt_id = d.opt_id
                    AND a.effective_end_date = '31-DEC-4712'
                    AND q.lf_evt_ocrd_dt BETWEEN b.effective_start_date
                                             AND b.effective_end_date
                    AND q.lf_evt_ocrd_dt BETWEEN c.effective_start_date
                                             AND c.effective_end_date
                    AND q.lf_evt_ocrd_dt BETWEEN d.effective_start_date
                                             AND d.effective_end_date
                    AND q.lf_evt_ocrd_dt BETWEEN e.effective_start_date
                                             AND e.effective_end_date
                    AND q.lf_evt_ocrd_dt BETWEEN a.enrt_cvg_strt_dt
                                             AND a.enrt_cvg_thru_dt
                    AND q.lf_evt_ocrd_dt BETWEEN NVL (f.rt_strt_dt,
                                                      q.lf_evt_ocrd_dt - 1)
                                             AND NVL (rt_end_dt,
                                                      q.lf_evt_ocrd_dt)
                    AND (a.PRTT_ENRT_RSLT_ID = f.PRTT_ENRT_RSLT_ID(+))
                    AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
                    AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
                    AND a.person_id = e.person_id
                    AND A.Prtt_Enrt_Rslt_Stat_Cd IS NULL) V2
      WHERE     v1.pl_id = v2.pl_id(+)
            AND v1.person_id = v2.person_id(+)
            AND v1.lf_evt_ocrd_dt = v2.lf_evt_ocrd_dt(+)
/
 
@utlspoff