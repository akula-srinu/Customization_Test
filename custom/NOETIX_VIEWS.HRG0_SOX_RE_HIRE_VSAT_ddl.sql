CREATE OR REPLACE FORCE VIEW NOETIX_VIEWS.HRG0_SOX_RE_HIRE_VSAT
(
   A$FULL_NAME,
   A$SSN,
   A$ZZ__________________________,
   ACTUAL_TERMINATION_DATE,
   ADP_EMP_NUMBER,
   EMPLOYEE_NUMBER,
   FULL_NAME,
   PERSON_TYPE,
   SSN,
   TERM_REASON,
   TERM_REASON_CODE
)
AS
   SELECT PAPF.full_name A$Full_Name,
          PAPF.national_identifier A$Ssn,
          'A$ZZ__________________________Copyright Noetix Corporation 1992-2016'
             A$ZZ__________________________,
          PPOS.actual_termination_date Actual_Termination_Date,
          TO_NUMBER (papf.attribute5) Adp_Emp_Number,
          TO_NUMBER (papf.employee_number) Employee_Number,
          PAPF.full_name Full_Name,
          PPT.user_person_type Person_Type,
          PAPF.national_identifier Ssn,
          HRLK.meaning Term_Reason,
          PPOS.leaving_reason Term_Reason_Code
     FROM NOETIX_VIEWS.HR_LOOKUPS HRLK,
          HR.PER_PERIODS_OF_SERVICE PPOS,
          HR.PER_PERSON_TYPES PPT,
          HR.PER_PERSON_TYPE_USAGES_F PPTU,
          HR.PER_ALL_PEOPLE_F PAPF
    WHERE 'Copyright Noetix Corporation 1992-2016' IS NOT NULL
          AND papf.person_id = pptu.person_id
          AND TRUNC (SYSDATE) BETWEEN papf.effective_start_date
                                  AND papf.effective_end_date
          AND TRUNC (SYSDATE) BETWEEN pptu.effective_start_date
                                  AND pptu.effective_end_date
          AND pptu.person_type_id = ppt.person_type_id
          AND ppt.user_person_type NOT LIKE ('%Ex-%')
          AND ppt.user_person_type NOT LIKE 'Participant'
          AND papf.person_id = ppos.person_id
          AND ppos.leaving_reason = hrlk.lookup_code
          AND hrlk.lookup_type = 'LEAV_REAS';
