-- Title
--   queryenv.sql
-- Function
--   set up views that enhance a users query environment
-- Description
--   To speed up some of the query tools which access the various
--   system tables in dumb ways, we are creating limited scope versions
--   of these system tables. The idea is that this will speed up the
--   process of getting these query tools to come up with a list of views.
--   The views get created in the NoetixViews SysAdmin user under a
--   different name.  Then access to the views is granted to a user
--   specifically by the wusrrole.sql program if the flag is set
--   in the n_query_users record for the user.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   11-Sep-94 M Turner
--   09-Aug-96 R Bull     fix SYNONYMS to SYNONYM
--   25-Feb-97 D Cowles   allow access to SYS objects in all these views
--   18-May-97 D Cowles   remove tconnect
--   12-Nov-98 D Glancy   Changed 'Noetix Views' to 'NoetixViews'.
--   20-Sep-99 R Lowe     Update copyright info.
--   15-Feb-00 H Sumanam  Update Copyright info.
--   11-Dec-00 D Glancy   Update Copyright info.
--   25-Jan-01 D Glancy   Added RULE hint to queries that used the all_%
--                        views.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   21-Nov-01 D Glancy   Modified definition of n_view_all_tables.  Access 2k was
--                        attempting to access the num_rows and blocks columns,
--                        which doesn't exist in our view. (Issue #4646)
--   21-Jun-02 D Glancy   Changed the --+ RULE to /*+ RULE */.  This was causing 
--                        problems at Yahoo.
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   05-Apr-04 D Glancy   Reset the error code a the end of the module.
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   11-May-06 D Glancy   Corrected n_view_all_tables view as it included a hardcoded
--                        reference to a development schema. (Issue 16269)
--   05-Aug-13 D Glancy   Change hints associated with user_synonyms and all_synonyms.
--   13-Aug-13 D Glancy   Fixed issue introduced by the 05-aug-13 change in some environments.
--                        (Issue 33187)
--   07-Aug-18 Srinivas   Commented the optimizer hint in the view script of n_view_all_synonyms
--			  for ViaSat (SR# 00132743)
--
WHENEVER SQLERROR EXIT 94

CREATE or replace view n_view_accessible_columns as
SELECT /*+ RULE */
       atc.*
  FROM sys.all_tab_columns atc
 WHERE atc.owner in ('SYS',user,upper('&NOETIX_USER') );

CREATE or replace view n_view_accessible_tables
    AS
SELECT /*+ RULE */
       user         owner,
       uo.object_name table_name,
       uo.object_type table_type
  FROM sys.user_objects uo
 WHERE uo.object_type IN ('VIEW','TABLE','SYNONYM')
 UNION
SELECT ao.owner,
       ao.object_name,
       ao.object_type
  FROM sys.all_objects ao
 WHERE ao.owner       = upper('&NOETIX_USER')
   AND ao.object_type = 'VIEW'
 UNION
SELECT ao.owner,
       ao.object_name,
       ao.object_type
  FROM sys.all_objects ao
 WHERE ao.owner       = 'SYS'
   AND ao.object_type in ('VIEW','TABLE','SYNONYM');

CREATE or replace view n_view_all_catalog as
SELECT /*+ RULE */
       user         owner,
       uo.object_name table_name,
       uo.object_type table_type
  FROM sys.user_objects uo
 WHERE uo.object_type in ('VIEW','TABLE','SYNONYM')
 UNION
SELECT ao.owner,
       ao.object_name,
       ao.object_type
  FROM sys.all_objects ao
 WHERE ao.owner       = upper('&NOETIX_USER')
   AND ao.object_type = 'VIEW'
 UNION
SELECT ao.owner,
       ao.object_name,
       ao.object_type
  FROM sys.all_objects ao
 WHERE ao.owner       = 'SYS'
   AND ao.object_type in ('VIEW','TABLE','SYNONYM');

CREATE or replace view n_view_all_objects AS
SELECT /*+ RULE */
       ao.*
  FROM sys.all_objects ao
 WHERE ao.owner          in ('SYS',user)
    OR (    ao.owner       = upper('&NOETIX_USER')
        and ao.object_type = 'VIEW' );

BEGIN
    IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN 
        dbms_output.enable(NULL);
    ELSE
        dbms_output.enable(1000000);
    END IF;

    execute immediate 
'CREATE OR REPLACE VIEW n_view_all_synonyms AS
 SELECT  /*  /*+ optimizer_features_enable(''9.2.0'') */  */
        s.*
   FROM sys.all_synonyms s
  WHERE s.owner          IN (''PUBLIC'', user)';
    dbms_output.put_line( '' );
    dbms_output.put_line( 'View Created.' );
    dbms_output.put_line( '' );
    commit;
EXCEPTION
   WHEN OTHERS THEN
      BEGIN
        execute immediate 
'CREATE OR REPLACE VIEW n_view_all_synonyms AS
 SELECT /*+ RULE */
        s.*
   FROM sys.all_synonyms s
  WHERE s.owner          in (''PUBLIC'', user)';
        dbms_output.put_line( '' );
        dbms_output.put_line( 'View Created.' );
        dbms_output.put_line( '' );
        commit;
      EXCEPTION
        WHEN OTHERS THEN
            RAISE;
      END;
END;
/

CREATE OR REPLACE VIEW n_view_all_tables AS 
SELECT /*+ RULE */
       user        owner,
       ut.table_name  table_name,
       ut.num_rows,
       ut.blocks
  FROM sys.user_tables ut
 UNION
SELECT /*+ RULE */
       user             owner,
       uo.object_name      table_name,
       to_number(null)  num_rows,
       to_number(null)  blocks
  FROM sys.user_objects uo
 WHERE uo.object_type = 'VIEW'
 UNION
SELECT /*+ RULE */
       ao.owner,
       ao.object_name      table_name,
       to_number(null)  num_rows,
       to_number(null)  blocks
  FROM sys.all_objects ao
 WHERE ao.owner       = upper('&NOETIX_USER')
   AND ao.object_type = 'VIEW'
 UNION
SELECT at.owner,
       at.table_name,
       at.num_rows,
       at.blocks
  FROM sys.all_tables at
 WHERE at.owner       = 'SYS'
 UNION
SELECT /*+ RULE */
       ao.owner,
       ao.object_name      table_name,
       to_number(null)  num_rows,
       to_number(null)  blocks
  FROM sys.all_objects ao
 WHERE ao.owner       = 'SYS'
   AND ao.object_type = 'VIEW';

CREATE or replace  view help_noetix_columns AS
SELECT /*+ RULE */
       acc.table_name noetix_view,
       acc.column_name,
       acc.comments help
  FROM sys.all_col_comments acc
 WHERE acc.owner = upper('&NOETIX_USER');

CREATE or replace view help_noetix_views AS
SELECT atc.table_name noetix_view,
       atc.comments   help
  FROM sys.all_tab_comments atc
 WHERE atc.owner = upper('&NOETIX_USER');

WHENEVER SQLERROR CONTINUE

-- End queryenv.sql
