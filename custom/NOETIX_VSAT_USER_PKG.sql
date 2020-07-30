-- Purpose: NOETIX_VSAT_USER_PKG
--
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       ------------------------------------------
--
-- Venkat Pati			16-JUL-19   Initial Creation

@utlspon NOETIX_VSAT_USER_PKG

CREATE OR REPLACE PACKAGE NOETIX_VSAT_USER_PKG
AS

g_package_name             VARCHAR2(30) := 'noetix_user_pkg';
g_delimiter                VARCHAR2(1) := '.';  
g_proc_add_user_record     VARCHAR2(30) := 'add_new_user';
g_proc_add_user_connection VARCHAR2(30) := 'add_user_connection';
g_external_server_name     VARCHAR2(30) := 'OBIEE';
g_connection_name          VARCHAR2(30) := 'OBIEE';

PROCEDURE add_user(p_ebs_user_name IN VARCHAR2
                  ,p_ad_user_name IN VARCHAR2
			      ,p_responsibility_name IN VARCHAR2
				  ,p_end_date IN DATE
				  ,x_return_status OUT VARCHAR2
				  ,x_return_message OUT VARCHAR2);
							   					   
END NOETIX_VSAT_USER_PKG;
/

CREATE OR REPLACE PACKAGE BODY NOETIX_VSAT_USER_PKG
AS
PROCEDURE add_user(p_ebs_user_name IN VARCHAR2
                  ,p_ad_user_name IN VARCHAR2
			      ,p_responsibility_name IN VARCHAR2
				  ,p_end_date IN DATE
				  ,x_return_status OUT VARCHAR2
				  ,x_return_message OUT VARCHAR2) IS
	CURSOR c_fnd_user IS
		SELECT fu.user_id
			  ,fu.start_date
			  ,fu.end_date
			  ,fu.employee_id person_id
			  ,(SELECT papf.business_group_id
			    FROM apps.per_all_people_f papf
				WHERE 1 = 1
				AND papf.person_id = fu.employee_id
				AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date AND papf.effective_end_date) business_group_id
		FROM apps.fnd_user fu
		WHERE 1 = 1
		AND fu.user_name = p_ebs_user_name;
	l_fnd_user_rec c_fnd_user%ROWTYPE;				  
	l_user_name n_security_mgr_users.user_name%TYPE;
	-- cursor to get the user responsibility assignment with any HR responsibility containing security group other than 'Standard' coming up as top record
	-- The HR specific responsibility assignment to non-us bg employees will have a security group other than 'Standard'
	CURSOR c_user_role_assignment(p_business_group_id NUMBER) IS
		SELECT wura.user_name
			  ,wura.role_name
			  ,wura.start_date
			  ,wura.end_date
			  ,fa.application_id resp_application_id
			  ,fr.responsibility_id
			  ,fr.responsibility_name
			  ,fr.end_date resp_end_date
			  ,fsg.security_group_id
			  ,fsg.security_group_key
			  ,fsg.security_group_name
		FROM apps.wf_user_role_assignments wura
			,apps.wf_local_roles wlr
			,apps.fnd_application fa
			,apps.fnd_responsibility_vl fr
			,apps.fnd_security_groups_vl fsg
		WHERE 1 = 1
		AND wura.user_name = p_ebs_user_name
		AND wura.role_name = wlr.name
		AND wlr.orig_system = 'FND_RESP'
		AND wlr.owner_tag = fa.application_short_name
		AND fa.application_id = fr.application_id
		AND wlr.orig_system_id = fr.responsibility_id
		AND fr.responsibility_name = p_responsibility_name
		AND REGEXP_SUBSTR(wlr.name,'[^|]+',1,4) = fsg.security_group_key
		AND (fsg.security_group_key = 'STANDARD' OR fsg.security_group_key = p_business_group_id)
		ORDER BY DECODE(fsg.security_group_key,'STANDARD',0,1) DESC;
	l_user_role_assignment_rec c_user_role_assignment%ROWTYPE;
	l_script_name VARCHAR2(100);
	-- cursor to get error message
	CURSOR c_n_sm_message(p_script_name VARCHAR2) IS
		SELECT sm.message
		FROM n_sm_messages sm
		WHERE 1 = 1
		AND sm.script_name = p_script_name
		AND sm.sequence = (SELECT MAX(sm1.sequence)
						   FROM n_sm_messages sm1
						   WHERE 1 = 1
						   AND sm1.script_name = p_script_name);
	l_error_count NUMBER;
	l_error_text VARCHAR2(200);	
BEGIN
	OPEN c_fnd_user;
	FETCH c_fnd_user INTO l_fnd_user_rec;
	CLOSE c_fnd_user;
	IF l_fnd_user_rec.user_id IS NULL THEN
		x_return_status := 'E';
		x_return_message := 'EBS User Name '||p_ebs_user_name||' does not exists';
	ELSE
		IF NOT NVL(l_fnd_user_rec.end_date,TRUNC(SYSDATE)) >= TRUNC(SYSDATE) THEN
			x_return_status := 'E';
			x_return_message := 'EBS User Name '||p_ebs_user_name||' is end dated. End Date = '||TO_CHAR(l_fnd_user_rec.end_date,'MM/DD/YYYY');
		ELSIF l_fnd_user_rec.person_id IS NULL THEN
			x_return_status := 'E';
			x_return_message := 'EBS User Name '||p_ebs_user_name||' does not have any associated employee record';		
		END IF;
	END IF;
	IF NVL(x_return_status,'S') = 'E' THEN
		RETURN;
	END IF;
	
	l_user_name := '#'||l_fnd_user_rec.user_id;
	
	/* the procedures in noetix_user_pkg does not throw any exception if there is any error and instead increments error count global variable that can be retrieved using get_error_count function
	   after the api call. the package has a error_text variable, however there is neither a function nor it is global variable to retrieve the error message.
	   So the only option is pull the latest record in the n_sm_messages table for the given script name (i.e. package and procedure name combination)
	*/ 
	NOETIX_USER_PKG.reset_error_count;
	l_script_name := g_package_name||g_delimiter||g_proc_add_user_record;
	-- create query user i.e. user_type = A (Oracle E-Business Suite Authenticated User)
	NOETIX_USER_PKG.add_user_record(i_user_name               => l_user_name
	                               ,i_user_type               => 'A'
								   ,i_language_code           => NULL
								   ,i_create_optimizing_views => 'N'
								   ,i_create_synonyms         => 'Y'
								   ,i_delete_flag             => 'N'
								   ,i_gl_security_type_code   => 'A'
								   ,i_start_date              => l_fnd_user_rec.start_date
								   ,i_end_date                => l_fnd_user_rec.end_date
								   ,i_user_server_name        => NULL
								   ,i_effective_user_name     => NULL
								   ,i_self_registered_flag    => NULL
								   ,i_auth_code               => 'E'
								   ,i_security_rules          => NULL);
	l_error_count := NOETIX_USER_PKG.get_error_count;
	IF l_error_count > 0 THEN
		OPEN c_n_sm_message(p_script_name => l_script_name);
		FETCH c_n_sm_message INTO l_error_text;
		IF c_n_sm_message%NOTFOUND THEN
			l_error_text := 'Could not derive the error message while adding EBS query user';
		END IF;
		CLOSE c_n_sm_message;
		x_return_status := 'E';
		x_return_message := 'Error creating ebs query user. '||l_error_text;
		ROLLBACK;
		RETURN;
	END IF;
			
	-- reset the error count
	NOETIX_USER_PKG.reset_error_count;
	-- create query user i.e. user_type = M (Noetix External Mapping User)
	NOETIX_USER_PKG.add_user_record(i_user_name               => p_ad_user_name
								   ,i_user_type               => 'M'
								   ,i_language_code           => NULL
								   ,i_create_optimizing_views => 'N'
								   ,i_create_synonyms         => 'N'
								   ,i_delete_flag             => 'N'
								   ,i_gl_security_type_code   => 'N'
								   ,i_start_date              => l_fnd_user_rec.start_date
								   ,i_end_date                => p_end_date
								   ,i_user_server_name        => g_external_server_name
								   ,i_effective_user_name     => l_user_name
								   ,i_self_registered_flag    => NULL
								   ,i_auth_code               => 'E'
								   ,i_security_rules          => NULL);	
	l_error_count := NOETIX_USER_PKG.get_error_count;
	IF l_error_count > 0 THEN
		OPEN c_n_sm_message(p_script_name => l_script_name);
		FETCH c_n_sm_message INTO l_error_text;
		IF c_n_sm_message%NOTFOUND THEN
			l_error_text := 'Could not derive the error message while adding BI user';
		END IF;
		CLOSE c_n_sm_message;
		x_return_status := 'E';
		x_return_message := 'Error creating bi user. '||l_error_text;
		ROLLBACK;
		RETURN;
	END IF;		

	-- query user responsibility assignment to derive responsibility_id, security group name to create user connection
	OPEN c_user_role_assignment(p_business_group_id => l_fnd_user_rec.business_group_id);
	FETCH c_user_role_assignment INTO l_user_role_assignment_rec;
	CLOSE c_user_role_assignment;
	IF l_user_role_assignment_rec.role_name IS NULL THEN
		x_return_status := 'E';
		x_return_message := 'EBS User '||p_ebs_user_name||' does not have the responsibility '||p_responsibility_name||' assigned';
	ELSE
		IF NOT NVL(l_user_role_assignment_rec.end_date,TRUNC(SYSDATE)) >= TRUNC(SYSDATE) THEN 
			x_return_status := 'E';
			x_return_message := 'The responsibility assignment to the EBS User '||p_ebs_user_name||' is end dated. End Date = '||TO_CHAR(l_user_role_assignment_rec.end_date,'MM/DD/YYYY');
		ELSIF NOT NVL(l_user_role_assignment_rec.resp_end_date,TRUNC(SYSDATE)) >= TRUNC(SYSDATE) THEN 
			x_return_status := 'E';
			x_return_message := 'The responsibility '||p_responsibility_name||' is end dated. End Date = '||TO_CHAR(l_user_role_assignment_rec.resp_end_date,'MM/DD/YYYY');
		END IF;
	END IF;
	IF NVL(x_return_status,'S') = 'E' THEN
		RETURN;
	END IF;	

	-- reset error count
	NOETIX_USER_PKG.reset_error_count;
	l_script_name := g_package_name||g_delimiter||g_proc_add_user_connection;
	-- create user connection
	NOETIX_USER_PKG.add_user_connection(i_user_name            => p_ad_user_name
									   ,i_user_server_name     => g_external_server_name
									   ,i_user_connection_name => g_connection_name
									   ,i_effective_user_name  => l_user_name
									   ,i_responsibility_name  => p_responsibility_name
									   ,i_resp_application_id  => l_user_role_assignment_rec.resp_application_id
									   ,i_security_group_name  => l_user_role_assignment_rec.security_group_name);	
	l_error_count := NOETIX_USER_PKG.get_error_count;
	IF l_error_count > 0 THEN
		OPEN c_n_sm_message(p_script_name => l_script_name);
		FETCH c_n_sm_message INTO l_error_text;
		IF c_n_sm_message%NOTFOUND THEN
			l_error_text := 'Could not derive the error message while adding user connection';
		END IF;
		CLOSE c_n_sm_message;
		x_return_status := 'E';
		x_return_message := 'Error creating user connection. '||l_error_text;
		ROLLBACK;
		RETURN;
	END IF;
	
	COMMIT;
	x_return_status := 'S';
	x_return_message := NULL;
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		x_return_status := 'E';
		x_return_message := 'Error occurred while adding user. Error '||SUBSTR(SQLERRM,1,100);
END add_user;				  

END NOETIX_VSAT_USER_PKG;
/

@utlspoff

/