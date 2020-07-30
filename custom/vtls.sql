-- Title
--   vtls.sql
-- Function
--   Spool the execution plan details
--
-- Description
--
--   Spool the execution plan details
--
-- Inputs
--   sql_id of the query
--
-- Copyright Noetix Corporation 1992-2011  All Rights Reserved
--
-- History
--   26-Dec-10 Sharas     Created
--
--

Def v_sql_id=&SQL_ID
set pagesize 3000 linesize 300
spool &v_sql_id
SELECT  sorts,  disk_reads, buffer_gets,
       concurrency_wait_time conc_wait, application_wait_time app_wait,
       user_io_wait_time user_io_wait, cpu_time, elapsed_time,sharable_mem, persistent_mem, runtime_mem,parse_calls parses#,
       fetches, executions
  FROM v$sql
 WHERE sql_id = '&v_sql_id'
/

col cn format 99
col ratio format 99
col ratio1 format A6
break on sql_id on cn
col lio_rw format 999
col "operation" format a100
col a_rows for 999,999,999
col e_rows for 999,999,999
col elapsed for 999,999,999


prompt "LIOs per row analysis"


select
       -- sql_id,
       childn                                         cn,
       case when stime - nvl(ptime ,0) > 0 then
          stime - nvl(ptime ,0) 
        else 0 end as  elapsed,
       nvl(trunc((lio-nvl(plio,0))/nullif(a_rows,0)),0) lio_rw,
       ' '||case when ratio > 0 then
  rpad('-',ratio,'-') 
       else 
  rpad('+',ratio*-1 ,'+') 
       end as                                           ratio1,
       starts*cardinality                              e_rows,
                                                       a_rows,
                                                         "operation"
from (
  SELECT
      stats.LAST_ELAPSED_TIME                             stime,
      p.elapsed                                  ptime,
      stats.sql_id                                        sql_id
    , stats.HASH_VALUE                                    hv
    , stats.CHILD_NUMBER                                  childn
    , to_char(stats.id,'990')
      ||decode(stats.access_predicates,null,null,'A')
      ||decode(stats.filter_predicates,null,null,'F')     id
    , stats.parent_id
    , stats.CARDINALITY                                    cardinality
    , LPAD(' ',depth)||stats.OPERATION||' '||
      stats.OPTIONS||' '||
      stats.OBJECT_NAME||
      DECODE(stats.PARTITION_START,NULL,' ',':')||
      TRANSLATE(stats.PARTITION_START,'(NRUMBE','(NR')||
      DECODE(stats.PARTITION_STOP,NULL,' ','-')||
      TRANSLATE(stats.PARTITION_STOP,'(NRUMBE','(NR')      "operation",
      stats.last_starts                                     starts,
      stats.last_output_rows                                a_rows,
      (stats.last_cu_buffer_gets+stats.last_cr_buffer_gets) lio,
      p.lio                                                 plio,
      trunc(log(10,nullif
         (stats.last_starts*stats.cardinality/
          nullif(stats.last_output_rows,0),0)))             ratio
  FROM
       v$sql_plan_statistics_all stats
       , (select sum(last_cu_buffer_gets + last_cr_buffer_gets) lio,
                 sum(LAST_ELAPSED_TIME) elapsed,
         child_number, 
 parent_id,
                 sql_id   
         from v$sql_plan_statistics_all   
         group by child_number,sql_id, parent_id) p
  WHERE
    stats.sql_id='&v_sql_id'  and
    p.sql_id(+) = stats.sql_id and
    p.child_number(+) = stats.child_number and 
    p.parent_id(+)=stats.id
) 
order by sql_id, childn , id
/


clear breaks



SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&v_sql_id',NULL, 'advanced allstats last -outline -projection +predicate'));


spool off

cle scr