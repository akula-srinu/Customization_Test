-- *******************************************************************************
-- FileName:  BNV1659.sql
--
--   History 
--   11-Jul-16 G Venkat   Added code for dropping and recreating the n_kff_gl_acct table. (Issue NV-1659)
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

drop table N_KFF_GL_ACCT1;

@utlspoff 
