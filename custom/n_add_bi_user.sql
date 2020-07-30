@utlspon n_add_bi_user

CREATE OR REPLACE PROCEDURE add_bi_user (p_ad_user_name   IN VARCHAR2,
                                         p_ebs_user_name         IN VARCHAR2,                                         
                                         p_end_date              IN DATE)
IS
   ebs_user              VARCHAR2 (100);
   query_user            VARCHAR2 (100) := '';
   reps_application_id   NUMBER;
   resp_sec_group_name   VARCHAR2 (100);
   reporting_tool        VARCHAR2 (10) := 'OBIEE';
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   SELECT '#' || user_id
     INTO ebs_user
     FROM fnd_user
    WHERE user_name = p_ebs_user_name;

   SELECT s.application_id, s.security_group_name
     INTO reps_application_id, resp_sec_group_name
     FROM n_sm_apps_user_resp_sg_v s
    WHERE s.responsibility_name = 'Preferences'
          AND s.user_name = p_ebs_user_name;

   noetix_user_pkg.add_user_record (p_ad_user_name,
                                    'M',
                                    NULL,
                                    'N',
                                    'N',
                                    'N',
                                    'N',
                                    SYSDATE,
                                    p_end_date,
                                    reporting_tool,
                                    ebs_user,
                                    NULL,
                                    'E',
                                    NULL);
   COMMIT;

   noetix_user_pkg.add_user_connection (p_ad_user_name,
                                        reporting_tool,
                                        reporting_tool,
                                        ebs_user,
                                        'Preferences',
                                        reps_application_id,
                                        resp_sec_group_name);

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20001,
         'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
END add_bi_user;
/

@utlspoff