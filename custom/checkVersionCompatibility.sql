-- Title
--   checkVersionCompatibility.sql
-- Function
--   Checks if NoetixViews Workbench scripts version is compatible with current version of NVO schema
--
-- Description
-- 
--
-- Inputs
--
-- Copyright Noetix Corporation 2015  All Rights Reserved
--
-- History
--   22-Jan-13 N Kapilla   Created.
--

set termout on
set serveroutput on

spool checkVersionCompatibility.lst;

prompt Check if NoetixViews Workbench script version is compatible with NVO schema version
prompt

DECLARE        
  v_tgt_schema_version VARCHAR2(11);
  v_tgt_major_minor_ver VARCHAR2(11);  
  v_src_min_version VARCHAR2(11) := '&1';
  v_src_max_version VARCHAR2(11) := '&2';
  v_src_low_min_version NUMBER;
  v_src_low_maj_version NUMBER; 
  v_src_low_revision NUMBER; 
  v_src_high_min_version NUMBER;
  v_src_high_maj_version NUMBER; 
  v_src_high_revision NUMBER; 
  v_tgt_major NUMBER;
  v_tgt_minor NUMBER;
  v_tgt_revision NUMBER;
  v_message VARCHAR(1000);
  incompatible_version EXCEPTION;     
  
BEGIN

    SELECT install_script_version into v_tgt_schema_version              
    FROM n_view_parameters nvp
    WHERE nvp.install_stage BETWEEN 2 AND 5
    AND nvp.creation_date = (SELECT MAX(nvp2.creation_date)
                FROM n_view_parameters nvp2
                WHERE nvp2.install_stage BETWEEN 2 AND 5);	  
	 
    v_tgt_major_minor_ver := SUBSTR( v_tgt_schema_version, 1 , INSTR ( v_tgt_schema_version, '.', 1, 3 ) - 1 );    
    v_tgt_major := SUBSTR( v_tgt_major_minor_ver, 1, INSTR ( v_tgt_major_minor_ver, '.', 1, 1 ) -1 );	
    v_tgt_minor := SUBSTR( v_tgt_major_minor_ver, INSTR( v_tgt_major_minor_ver, '.', 1, 1 ) + 1, INSTR( v_tgt_major_minor_ver, '.', -1, 1 ) -INSTR( v_tgt_major_minor_ver, '.', 1, 1 )- 1 );
	v_tgt_revision := SUBSTR( v_tgt_major_minor_ver, INSTR( v_tgt_major_minor_ver, '.', 1, 2 ) + 1);    
	 
	v_src_low_maj_version := SUBSTR( v_src_min_version, 1, INSTR ( v_src_min_version, '.', 1, 1 ) -1 );  
	v_src_low_min_version := SUBSTR( v_src_min_version, INSTR( v_src_min_version, '.', 1, 1 ) + 1, INSTR( v_src_min_version, '.', -1, 1 ) - INSTR( v_src_min_version, '.', 1, 1 )- 1 );   
	v_src_low_revision := SUBSTR( v_src_min_version, INSTR( v_src_min_version, '.', 1, 2 ) + 1); 
    
    v_src_high_maj_version := SUBSTR( v_src_max_version, 1, INSTR ( v_src_max_version, '.', 1, 1 ) -1 );          
	v_src_high_min_version := SUBSTR( v_src_max_version, INSTR( v_src_max_version, '.', 1, 1 ) + 1, INSTR( v_src_max_version, '.', -1, 1 ) -INSTR( v_src_max_version, '.', 1, 1 ) - 1 );  
	v_src_high_revision := SUBSTR( v_src_max_version, INSTR( v_src_max_version, '.', 1, 2 ) + 1);  
		
	IF ( ( v_tgt_major < v_src_low_maj_version) or 
	     ( v_tgt_major > v_src_high_maj_version) or
	     ( (v_tgt_major = v_src_low_maj_version) and (v_tgt_minor < v_src_low_min_version) ) or
		 ( (v_tgt_major = v_src_high_maj_version) and (v_tgt_minor > v_src_high_min_version)) or
		 ( (v_tgt_major = v_src_low_maj_version) and (v_tgt_minor = v_src_low_min_version) and (v_tgt_revision < v_src_low_revision)) or
		 ( (v_tgt_major = v_src_high_maj_version) and (v_tgt_minor = v_src_high_min_version) and (v_tgt_revision > v_src_high_revision)) 
		 ) 
	THEN
			v_message := 'checkVersionCompatibility: NoetixViews Workbench customizations cannot be applied because the NoetixViews version used to create the customizations does not match the version running.';
			RAISE incompatible_version;      
	END IF;
  
    EXCEPTION
        WHEN incompatible_version THEN          
           RAISE_APPLICATION_ERROR(-20001, v_message); 		
        WHEN OTHERS THEN	
		   RAISE;		

END;
/

show errors

spool off

