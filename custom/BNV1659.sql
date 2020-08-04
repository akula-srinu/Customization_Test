-- This line added by Srinivasa Rao Akula

-- *******************************************************************************
-- FileName:  BNV1659.sql
--
--   History 
--   11-Jul-16 G Venkat   Added code for dropping and recreating the n_kff_gl_acct table. (Issue NV-1659)
--   10-Oct-16 N Mohan    Added the default values population for columns.
--   15-Feb-17 Selwyn.D.  Added the Create index statement provided by Erick.G. to fix part the issue in Incident 00090519 which affect N_KFF_GL_ACCT-RSET(UID-409)
--   02-May-17 Selwyn.D.  Removed 'UNIQUE' option from the Create index statement provided by Erick.G. to fix 
--									part the issue in Incident 00090519 which affects request set N_KFF_GL_ACCT-RSET(UID-409)
--
--
-- *******************************************************************************
-- output to BNV1659.lst file

@utlspon BNV1659

create table N_KFF_GL_ACCT1 as 
select * from N_KFF_GL_ACCT;

drop table N_KFF_GL_ACCT;

create table N_KFF_GL_ACCT as 
select * from N_KFF_GL_ACCT1;

--ALTER TABLE N_KFF_GL_ACCT ADD CONSTRAINT N_KFF_GL_ACCT_PK PRIMARY KEY (CODE_COMBINATION_ID);

ALTER TABLE N_KFF_GL_ACCT MODIFY CREATED_BY DEFAULT USER; 
ALTER TABLE N_KFF_GL_ACCT MODIFY CREATION_DATE DEFAULT SYSDATE; 
ALTER TABLE N_KFF_GL_ACCT MODIFY LAST_UPDATED_BY DEFAULT USER; 
ALTER TABLE N_KFF_GL_ACCT MODIFY LAST_UPDATE_DATE DEFAULT SYSDATE; 

-- Added below for Incident 00090519
CREATE INDEX N_KFF_GL_ACCT_N1_VSAT ON N_KFF_GL_ACCT (CODE_COMBINATION_ID);	

drop table N_KFF_GL_ACCT1;

ALTER PACKAGE noetix_vsat_utility_pkg COMPILE BODY;

@utlspoff 
