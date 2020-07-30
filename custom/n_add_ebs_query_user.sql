@utlspon n_add_ebs_query_user

CREATE OR REPLACE PROCEDURE add_ebs_query_user (p_ebs_user_name    IN VARCHAR2)
IS
   ebs_user   VARCHAR2 (100);
   ebs_user_creation_date  DATE;
   query_user VARCHAR2(100) := '';
BEGIN

   SELECT '#' || user_id
     INTO ebs_user
     FROM fnd_user
    WHERE user_name = p_ebs_user_name;
    
    SELECT trunc(creation_date)
     INTO ebs_user_creation_date
     FROM fnd_user
    WHERE user_name = p_ebs_user_name;

    noetix_user_pkg.add_user_record(ebs_user,'A',NULL,'N','Y','N','A',ebs_user_creation_date,NULL,NULL,p_Ebs_user_name,NULL,'E',NULL);  
    COMMIT;
   
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20001,
         'An error was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
END add_ebs_query_user;
/

@utlspoff