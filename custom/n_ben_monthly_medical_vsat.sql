@utlspon N_BEN_MONTHLY_MEDICAL_VSAT

CREATE OR REPLACE FORCE VIEW N_BEN_MONTHLY_MEDICAL_VSAT
(
   EMP_NUMBER,
   EFFECTIVE_DATE_PARAMETER,
   FULL_NAME,
   DATE_OF_BIRTH,
   GENDER,
   EMP_CATEGORY,
   ADP_CODE,
   LOCATION,
   COMPANY_CODE,
   COVERAGE_START_DATE,
   COVERAGE_THROUGH_DATE,
   PLAN_NAME,
   MEDICAL_COVERAGE,
   EMPLOYEE_SMOKER_STATUS,
   SPOUSE_SMOKER_STATUS,
   EMPLOYEE_RATE,
   HIRE_DATE,
   STATE,
   ZIP_CODE,
   MEDICAL_GROUP_NUMBER
)
AS
   SELECT v1.employee_number Emp_Number,
          v1.effective_date effective_date_parameter,
          v1.full_name Full_Name,
          TO_CHAR (v1.date_of_birth, 'dd-Mon-yyyy') Date_Of_Birth,
          v1.sex Gender,
          v1.emp_category Emp_Category,
          v1.adp_code ADP_Code,
          v1.location_code Location,
          v1.company_code Company_Code,
          v1.enrt_cvg_strt_dt Coverage_Start_Date,
          v1.enrt_cvg_thru_dt Coverage_Through_Date,
          v1.new_plan_name Plan_Name,
          v1.new_option_name Medical_Coverage,
          v2.new_option_name Employee_Smoker_Status,
          v3.new_option_name Spouse_Smoker_Status,
          v1.rate Employee_Rate,
          TO_CHAR (v1.hire_date, 'dd-Mon-yyyy') Hire_Date,
          v1.state State,
          v1.zipcode Zip_Code,
          v1.medical_group_number Medical_Group_Number
     FROM (SELECT a.person_id,
                  cal.effective_date effective_date,
                  e.employee_number,
                  e.full_name,
                  e.date_of_birth,
                  e.sex,
                  i.meaning emp_category,
                  h.ass_attribute9 adp_code,
                  g.group_name company_code,
                  TO_CHAR (a.enrt_cvg_strt_dt, 'dd-Mon-yyyy')
                     enrt_cvg_strt_dt,
                  TO_CHAR (a.enrt_cvg_thru_dt, 'dd-Mon-yyyy')
                     enrt_cvg_thru_dt,
                  b.name new_plan_name,
                  c.name new_option_name,
                  NVL (f.cmcd_rt_val, 0) rate,
                  k.date_start hire_date,
                  j.postal_code zipcode,
                  j.region_2 state,
                  j.address_type,
                  a.pl_id,
                  location.location_code,
                  '1846M'
                  || DECODE (e.employee_number,
                             '5972', 'N',
                             '4811', 'N',
                             '6311', 'J',
                             '6406', 'G',
                             '3940', 'C',
                             '3741', 'C',
                             noetix_vsat_utility_pkg.get_medical_code (
                                b.pl_id,
                                a.enrt_cvg_strt_dt,
                                h.assignment_id,
                                a.prtt_enrt_rslt_id))
                     medical_group_number
             FROM ben.ben_prtt_enrt_rslt_f a,
                  ben.ben_pl_f b,
                  ben.ben_opt_f c,
                  ben.ben_oipl_f d,
                  per_people_f e,
                  ben.ben_prtt_rt_val f,
                  hr.pay_people_groups g,
                  per_assignments_f h,
                  hr_lookups i,
                  per_addresses j,
                  per_periods_of_service k,
                  noetix_calendar cal,
                  hr_locations_all location
            WHERE a.person_id IN
                     (SELECT emp.person_id
                        FROM per_people_f emp
                       WHERE SYSDATE BETWEEN emp.effective_start_date
                                         AND emp.effective_end_date
                             AND emp.current_employee_flag = 'Y')
                  AND a.pl_id = b.pl_id
                  AND a.oipl_id = d.oipl_id
                  AND c.opt_id = d.opt_id
                  AND a.effective_end_date = '31-DEC-4712'
                  AND cal.effective_date BETWEEN b.effective_start_date
                                             AND b.effective_end_date
                  AND cal.effective_date BETWEEN c.effective_start_date
                                             AND c.effective_end_date
                  AND cal.effective_date BETWEEN d.effective_start_date
                                             AND d.effective_end_date
                  AND cal.effective_date BETWEEN e.effective_start_date
                                             AND e.effective_end_date
                  AND cal.effective_date BETWEEN h.effective_start_date
                                             AND h.effective_end_date
                  AND cal.effective_date BETWEEN a.enrt_cvg_strt_dt
                                             AND a.enrt_cvg_thru_dt
                  AND cal.effective_date BETWEEN NVL (f.rt_strt_dt,
                                                      cal.effective_date - 1)
                                             AND NVL (f.rt_end_dt,
                                                      cal.effective_date)
                  AND a.person_id = e.person_id
                  AND e.current_employee_flag = 'Y'
                  AND b.pl_id IN (81)                            --medical PPO
                  AND a.prtt_enrt_rslt_stat_cd IS NULL
                  AND a.prtt_enrt_rslt_id = f.prtt_enrt_rslt_id(+)
                  AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
                  AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
                  AND g.people_group_id = h.people_group_id(+)
                  AND e.person_id = h.person_id
                  AND i.lookup_type = 'EMP_CAT'
                  AND i.lookup_code(+) = h.employment_category
                  AND e.person_id = j.person_id(+)
                  AND j.primary_flag = 'Y'
                  AND j.date_to IS NULL
                  AND c.name != 'No Coverage'
                  AND h.assignment_number IS NOT NULL
                  AND k.person_id = a.person_id
                  AND k.actual_termination_date IS NULL
                  AND h.location_id = location.location_id
           UNION
           SELECT a.person_id,
                  cal.effective_date effective_date,
                  e.employee_number,
                  e.full_name,
                  e.date_of_birth,
                  e.sex,
                  i.meaning emp_category,
                  h.ass_attribute9 adp_code,
                  g.group_name company_code,
                  TO_CHAR (a.enrt_cvg_strt_dt, 'dd-Mon-yyyy')
                     enrt_cvg_strt_dt,
                  TO_CHAR (a.enrt_cvg_thru_dt, 'dd-Mon-yyyy')
                     enrt_cvg_thru_dt,
                  b.name new_plan_name,
                  c.name new_option_name,
                  NVL (f.cmcd_rt_val, 0) rate,
                  k.date_start hire_date,
                  j.postal_code zipcode,
                  j.region_2 state,
                  j.address_type,
                  a.pl_id,
                  location.location_code,
                  '1846M'
                  || DECODE (e.employee_number,
                             '5972', 'N',
                             '4811', 'N',
                             '6311', 'J',
                             '6406', 'G',
                             '3940', 'C',
                             '3741', 'C',
                             noetix_vsat_utility_pkg.get_medical_code (
                                b.pl_id,
                                a.enrt_cvg_strt_dt,
                                h.assignment_id,
                                a.prtt_enrt_rslt_id))
                     medical_group_number
             FROM ben.ben_prtt_enrt_rslt_f a,
                  ben.ben_pl_f b,
                  ben.ben_opt_f c,
                  ben.ben_oipl_f d,
                  per_people_f e,
                  ben.ben_prtt_rt_val f,
                  hr.pay_people_groups g,
                  per_assignments_f h,
                  hr_lookups i,
                  per_addresses j,
                  noetix_calendar cal,
                  per_periods_of_service k,
                  hr_locations_all location
            WHERE a.person_id IN
                     (SELECT emp.person_id
                        FROM per_people_f emp
                       WHERE SYSDATE BETWEEN emp.effective_start_date
                                         AND emp.effective_end_date
                             AND emp.current_employee_flag = 'Y')
                  AND a.pl_id = b.pl_id
                  AND a.oipl_id = d.oipl_id
                  AND c.opt_id = d.opt_id
                  AND a.effective_end_date = '31-DEC-4712'
                  AND cal.effective_date BETWEEN b.effective_start_date
                                             AND b.effective_end_date
                  AND cal.effective_date BETWEEN c.effective_start_date
                                             AND c.effective_end_date
                  AND cal.effective_date BETWEEN d.effective_start_date
                                             AND d.effective_end_date
                  AND cal.effective_date BETWEEN e.effective_start_date
                                             AND e.effective_end_date
                  AND cal.effective_date BETWEEN h.effective_start_date
                                             AND h.effective_end_date
                  AND cal.effective_date BETWEEN a.enrt_cvg_strt_dt
                                             AND a.enrt_cvg_thru_dt
                  AND cal.effective_date BETWEEN NVL (f.rt_strt_dt,
                                                      cal.effective_date - 1)
                                             AND NVL (f.rt_end_dt,
                                                      cal.effective_date)
                  AND a.person_id = e.person_id
                  AND e.current_employee_flag = 'Y'
                  AND b.pl_id IN (82)                            --medical PPO
                  AND a.prtt_enrt_rslt_stat_cd IS NULL
                  AND a.prtt_enrt_rslt_id = f.prtt_enrt_rslt_id(+)
                  AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
                  AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
                  AND g.people_group_id = h.people_group_id(+)
                  AND e.person_id = h.person_id
                  AND i.lookup_type = 'EMP_CAT'
                  AND i.lookup_code(+) = h.employment_category
                  AND e.person_id = j.person_id(+)
                  AND j.primary_flag = 'Y'
                  AND j.date_to IS NULL
                  AND c.name != 'No Coverage'
                  AND h.assignment_number IS NOT NULL
                  AND k.person_id = a.person_id
                  AND k.actual_termination_date IS NULL
                  AND h.location_id = location.location_id) v1,
          (SELECT a.person_id,
                  cal.effective_date effective_date,
                  e.employee_number,
                  e.full_name,
                  e.date_of_birth,
                  e.sex,
                  i.meaning emp_category,
                  h.ass_attribute9 adp_code,
                  g.group_name company_code,
                  a.enrt_cvg_strt_dt,
                  a.enrt_cvg_thru_dt,
                  b.name new_plan_name,
                  c.name new_option_name,
                  NVL (f.cmcd_rt_val, 0) rate,
                  k.date_start hire_date,
                  j.region_2 state,
                  a.pl_id
             FROM ben.ben_prtt_enrt_rslt_f a,
                  ben.ben_pl_f b,
                  ben.ben_opt_f c,
                  ben.ben_oipl_f d,
                  per_people_f e,
                  ben.ben_prtt_rt_val f,
                  hr.pay_people_groups g,
                  per_assignments_f h,
                  hr_lookups i,
                  per_addresses j,
                  noetix_calendar cal,
                  per_periods_of_service k
            WHERE a.person_id IN
                     (SELECT emp.person_id
                        FROM per_people_f emp
                       WHERE SYSDATE BETWEEN emp.effective_start_date
                                         AND emp.effective_end_date
                             AND emp.current_employee_flag = 'Y')
                  AND a.pl_id = b.pl_id
                  AND a.oipl_id = d.oipl_id
                  AND c.opt_id = d.opt_id
                  AND a.effective_end_date = '31-DEC-4712'
                  AND cal.effective_date BETWEEN b.effective_start_date
                                             AND b.effective_end_date
                  AND cal.effective_date BETWEEN c.effective_start_date
                                             AND c.effective_end_date
                  AND cal.effective_date BETWEEN d.effective_start_date
                                             AND d.effective_end_date
                  AND cal.effective_date BETWEEN e.effective_start_date
                                             AND e.effective_end_date
                  AND cal.effective_date BETWEEN h.effective_start_date
                                             AND h.effective_end_date
                  AND cal.effective_date BETWEEN a.enrt_cvg_strt_dt
                                             AND a.enrt_cvg_thru_dt
                  AND cal.effective_date BETWEEN NVL (f.rt_strt_dt,
                                                      cal.effective_date - 1)
                                             AND NVL (f.rt_end_dt,
                                                      cal.effective_date)
                  AND a.person_id = e.person_id
                  AND e.current_employee_flag = 'Y'
                  AND b.pl_id IN (161)                      --Employee tobbaco
                  AND a.prtt_enrt_rslt_stat_cd IS NULL
                  AND a.prtt_enrt_rslt_id = f.prtt_enrt_rslt_id(+)
                  AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
                  AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
                  AND g.people_group_id = h.people_group_id(+)
                  AND e.person_id = h.person_id
                  AND i.lookup_type = 'EMP_CAT'
                  AND i.lookup_code(+) = h.employment_category
                  AND e.person_id = j.person_id(+)
                  AND j.primary_flag = 'Y'
                  AND j.date_to IS NULL
                  AND h.assignment_number IS NOT NULL
                  AND k.person_id = a.person_id
                  AND k.actual_termination_date IS NULL) v2,
          (SELECT a.person_id,
                  cal.effective_date effective_date,
                  e.employee_number,
                  e.full_name,
                  e.date_of_birth,
                  e.sex,
                  i.meaning emp_category,
                  h.ass_attribute9 adp_code,
                  g.group_name company_code,
                  a.enrt_cvg_strt_dt,
                  a.enrt_cvg_thru_dt,
                  b.name new_plan_name,
                  c.name new_option_name,
                  NVL (f.cmcd_rt_val, 0) rate,
                  k.date_start hire_date,
                  j.region_2 state,
                  a.pl_id
             FROM ben.ben_prtt_enrt_rslt_f a,
                  ben.ben_pl_f b,
                  ben.ben_opt_f c,
                  ben.ben_oipl_f d,
                  per_people_f e,
                  ben.ben_prtt_rt_val f,
                  hr.pay_people_groups g,
                  per_assignments_f h,
                  hr_lookups i,
                  noetix_calendar cal,
                  per_addresses j,
                  per_periods_of_service k
            WHERE a.person_id IN
                     (SELECT emp.person_id
                        FROM per_people_f emp
                       WHERE SYSDATE BETWEEN emp.effective_start_date
                                         AND emp.effective_end_date
                             AND emp.current_employee_flag = 'Y')
                  AND a.pl_id = b.pl_id
                  AND a.oipl_id = d.oipl_id
                  AND c.opt_id = d.opt_id
                  AND a.effective_end_date = '31-DEC-4712'
                  AND cal.effective_date BETWEEN b.effective_start_date
                                             AND b.effective_end_date
                  AND cal.effective_date BETWEEN c.effective_start_date
                                             AND c.effective_end_date
                  AND cal.effective_date BETWEEN d.effective_start_date
                                             AND d.effective_end_date
                  AND cal.effective_date BETWEEN e.effective_start_date
                                             AND e.effective_end_date
                  AND cal.effective_date BETWEEN h.effective_start_date
                                             AND h.effective_end_date
                  AND cal.effective_date BETWEEN a.enrt_cvg_strt_dt
                                             AND a.enrt_cvg_thru_dt
                  AND cal.effective_date BETWEEN NVL (f.rt_strt_dt,
                                                      cal.effective_date - 1)
                                             AND NVL (f.rt_end_dt,
                                                      cal.effective_date)
                  AND a.person_id = e.person_id
                  AND e.current_employee_flag = 'Y'
                  AND b.pl_id IN (162)                        --Spouse tobbaco
                  AND a.prtt_enrt_rslt_stat_cd IS NULL
                  AND a.prtt_enrt_rslt_id = f.prtt_enrt_rslt_id(+)
                  AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
                  AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
                  AND g.people_group_id = h.people_group_id(+)
                  AND e.person_id = h.person_id
                  AND i.lookup_type = 'EMP_CAT'
                  AND i.lookup_code(+) = h.employment_category
                  AND e.person_id = j.person_id(+)
                  AND j.primary_flag = 'Y'
                  AND j.date_to IS NULL
                  AND h.assignment_number IS NOT NULL
                  AND k.person_id = a.person_id
                  AND k.actual_termination_date IS NULL) v3
    WHERE     v1.person_id = v2.person_id
          AND v2.person_id = v3.person_id
          AND v2.pl_id = DECODE (v1.pl_id,  81, 161,  82, 161,  v1.pl_id)
          AND v3.pl_id = DECODE (v1.pl_id,  81, 162,  82, 162,  v1.pl_id)
          AND V1.effective_date = V2.effective_date
          AND v2.effective_date = v3.effective_date
   UNION
   SELECT e.employee_number AS "Emp_Number",
          cal.effective_date effective_date,
          e.full_name AS "Employee Full Name",
          TO_CHAR (e.date_of_birth, 'dd-Mon-yyyy')
             AS "Employee Date of Birth",
          e.sex gender,
          i.meaning AS "Emp Category",
          h.ass_attribute9 AS "ADP Code",
          location.location_code location,
          g.group_name AS "Company Code",
          TO_CHAR (f.rt_strt_dt, 'dd-Mon-yyyy') AS "Coverage Start Date",
          TO_CHAR (f.rt_end_dt, 'dd-Mon-yyyy') AS "Coverage Through Date",
          'ViaSat Healthcare Plan' AS "Plan Name",
          'No Coverage' AS "Medical Coverage",
          'Employee NOT enroll in ViaSat Benefits'
             AS "Employee Smoker Status",
          'Elected tier does not cover spouse' AS "Spouse Smoker Status",
          NVL (f.cmcd_rt_val, 0) AS "Employee Rate",
          TO_CHAR (k.date_start, 'dd-Mon-yyyy') AS "Hire Date",
          j.region_2 AS "State",
          j.postal_code AS "Zip Code",
          NULL medical_group_number
     FROM ben.ben_prtt_enrt_rslt_f a,
          ben.ben_pl_f b,
          ben.ben_opt_f c,
          ben.ben_oipl_f d,
          per_people_f e,
          ben.ben_prtt_rt_val f,
          hr.pay_people_groups g,
          per_assignments_f h,
          hr_lookups i,
          per_addresses j,
          noetix_calendar cal,
          per_periods_of_service k,
          hr_locations_all location
    WHERE a.person_id IN
             (SELECT emp.person_id
                FROM per_people_f emp
               WHERE SYSDATE BETWEEN emp.effective_start_date
                                 AND emp.effective_end_date
                     AND emp.current_employee_flag = 'Y')
          AND a.pl_id = b.pl_id
          AND a.oipl_id = d.oipl_id
          AND c.opt_id = d.opt_id
          AND a.effective_end_date = '31-DEC-4712'
          AND cal.effective_date BETWEEN b.effective_start_date
                                     AND b.effective_end_date
          AND cal.effective_date BETWEEN c.effective_start_date
                                     AND c.effective_end_date
          AND cal.effective_date BETWEEN d.effective_start_date
                                     AND d.effective_end_date
          AND cal.effective_date BETWEEN e.effective_start_date
                                     AND e.effective_end_date
          AND cal.effective_date BETWEEN h.effective_start_date
                                     AND h.effective_end_date
          AND cal.effective_date BETWEEN a.enrt_cvg_strt_dt
                                     AND a.enrt_cvg_thru_dt
          AND cal.effective_date BETWEEN NVL (f.rt_strt_dt,
                                              cal.effective_date - 1)
                                     AND NVL (f.rt_end_dt,
                                              cal.effective_date)
          AND a.person_id = e.person_id
          AND e.current_employee_flag = 'Y'
          AND b.pl_id IN (161)                              --Employee tobacco
          AND a.prtt_enrt_rslt_stat_cd IS NULL
          AND a.prtt_enrt_rslt_id = f.prtt_enrt_rslt_id(+)
          AND (f.tx_typ_cd = 'PRETAX' OR f.tx_typ_cd IS NULL)
          AND NVL (f.dsply_on_enrt_flag, 'Y') != 'N'
          AND g.people_group_id = h.people_group_id(+)
          AND e.person_id = h.person_id
          AND i.lookup_type = 'EMP_CAT'
          AND i.lookup_code(+) = h.employment_category
          AND e.person_id = j.person_id(+)
          AND j.primary_flag = 'Y'
          AND j.date_to IS NULL
          AND h.assignment_number IS NOT NULL
          AND k.person_id = a.person_id
          AND k.actual_termination_date IS NULL
          AND c.name = 'Employee NOT enroll in ViaSat Benefits'
          AND h.location_id = location.location_id
/

@utlspoff
