-- 07-Apr-2011 HChodavarapu Created for 602 build R12 advance security.
@utlspon oke_adv_security_on

INSERT INTO n_profile_option_templates                                                                                                                                                                           
            (profile_option,                                                                                                                                                                                     
             profile_description, application_label, table_application_label,                                                                                                                                    
             table_name,                                                                                                                                                                                         
             profile_select,                                                                                                                                                                                     
             essay,                                                                                                                                                                                              
             product_version, created_by,                                                                                                                                                                        
             creation_date,                                                                                                                                                                                      
             last_updated_by,                                                                                                                                                                                    
             last_update_date                                                                                                                                                                                    
            )                                                                                                                                                                                                    
     VALUES ('OKE_OU_ADV_SECURITY_ON',                                                                                                                                                                            
             'Data Safeguard Manager is active for OKE OU', 'OKE', 'FND',                                                                                                                                          
             'FND_DUAL',                                                                                                                                                                                         
             'SELECT ''Y''  FROM DUAL                                                                                                                                                                                          
                  WHERE   ( CASE N_SEC_MANAGER_DM_PKG.IS_ADVANCED_SECURITY_ENABLED( N_PROFILE_OPTIONS.APPLICATION_LABEL ) 
                   WHEN 1 THEN   ( CASE  WHEN N_PROFILE_OPTIONS.APPLICATION_INSTANCE LIKE ''G%'' THEN 1   
                   ELSE ( CASE N_SEC_MANAGER_DM_PKG.GET_ACL_PROCESSING_CODE(  N_PROFILE_OPTIONS.APPLICATION_LABEL ) 
                   WHEN ''G'' THEN 0   ELSE   1  END ) END )   ELSE  0    END )  = 0',                                                                                                                                                                                 
             'Determine if the Data Safeguard Manager is active for Oracle Project Contarcts (OKE) Operating Units (OU).  If active, this activates the organization unit access conrol list feature.',      
             '11.5+', 'hchodavarapu',                                                                                                                                                                                 
             TO_DATE ('03/09/2009 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),                                                                                                                                           
             'hchodavarapu',                                                                                                                                                                                     
             TO_DATE ('05/08/2009 00:00:00', 'MM/DD/YYYY HH24:MI:SS')                                                                                                                                            
            );


COMMIT;

@utlspoff