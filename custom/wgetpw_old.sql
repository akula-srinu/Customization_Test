-- Title
--   wgetpw.sql
-- Function
--   prompt for password for an oracle user and define a password variable
-- Description
--   define variable tmpok to call this routine recursively
--   prompt for password
--   connect to that account to see if it is valid
--   see if a select statement will work
--       if the connect worked, then select statement works and tmpok is nulled
--   if the connect didn't work, then select won't work and tmpok remains
--      what it was, that is a recursive call to this routine
--   start file defined by variable tmpok
--   if password was correct, then this does nothing.
--   if password was incorrect, then this calls this routine (wgetpw) again.
-- Usage
--   @wgetpw <oracle_user> <Include Connect_String Flag (Y or N)>
--          also assumes the following global variables are defined
--          CONNECT_STRING 
--          NOETIX_CONNECT 
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   03-Dec-95 M Turner   created
--   05-Nov-96 M Turner   use CONNECT_STRING to do connect, hid password
--   20-Sep-99 R Lowe     Update copyright info.
--   15-Feb-00 H Sumanam  Update the copyright info.
--   11-Dec-00 D Glancy   Update Copyright info.
--   02-Nov-01 D Glancy   Hide the system generated error messages in favor of the
--                        our user defined error messages.  It was felt that the 
--                        failure messages led the person to believe they were disconnected.
--                        The user was actually disconnected, but they were automatically 
--                        reconnected to the noetix_sys.  It was just as easy to create a 
--                        custom message as it would have been to explain that they were
--                        automatically reconnected. (ISSUE 5080)
--   12-Nov-01 D Glancy   1.  Update copyright info. (Issue #5285)
--                        2.  Override default error message behavior.  If the user types
--                        in an incorrect password, then flag this as an error manually
--                        instead of relying on oracles error messages.  If the user 
--                        succeeds in logging in, then say 'Connected'.  This is no 
--                        different from how the oracle messaging handles the connect 
--                        request.
--   21-Jun-02 D Glancy   Hitting a <CR> at the prompt causes the password to be accepted.
--                        (Issue 6757)
--   22-Jul-03 D Glancy   The connect string portion is now passed to the generated cpw.sql 
--                        file.  This supports using automation for CM - STANDARD installations.
--                        (Issue 4826,8310,8324,9454)
--   21-Sep-03 D Glancy   Modify the call to wgetpw.sql.  Added extra parameter 
--                        to indicate if the connect_string info should be appended to 
--                        the created PW_??? variable.
--                        (Issue 10189)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   06-Jul-05 D Glancy   The tmpokconnectstring variable is being undefined if you have to call 
--                        wgetpw more than once (as in the case of passing in the wrong password).  
--                        Redefined the tmpokconnectstring variable prior to the define of pw_???? 
--                        variable in wgetpw.
--                        (Issue 14355)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Apr-08 D Glancy   Make the password prompt consistent with other password prompts.
--                        (Issue 19533)
--   19-Apr-08 D Glancy   Fixed multiple issues with the parameter gathering system.
--                        (Issue 19587 and 19588)
--   21-Nov-08 D Glancy   The 11g version of sqlplus does not allow "start ''" anymore with generating an
--                        "SP2" error.  A sql script must now be specified.  In this case, utlnop.sql does
--                        the job.
--                        (Issue 21045)
--
set termout on
set verify off
set echo off
define tmpok="wgetpw &1 &2"
define tmpnotok="<<-ERROR->> Password entered for user &1 is not valid.  Please try again."
define tmpokconnectstring = &CONNECT_STRING
column stmpok               new_value tmpok     noprint
column stmpnotok            new_value tmpnotok  noprint
column spw                  new_value pw        noprint
column s_tmpokconnectstring new_value tmpokconnectstring noprint
-- Get the password from the user
ACCEPT tmppw CHAR PROMPT 'Enter Password for &1: ' HIDE
set termout off
-- Check to see if the password is null
select nvl('&TMPPW','""') spw
  from dual
;
-- Set the temp connect string depending on the connect_string flag
select decode(UPPER('&2'),
              'N', '',
              '&CONNECT_STRING') s_tmpokconnectstring
  from dual
;
-- Connect to see if valid
connect &1/&pw.&CONNECT_STRING
set termout off
--
select 'utlnop'                  stmpok,
       'Connected.'              stmpnotok
  from dual
;
-- Reconnect to noetix_sys
connect &NOETIX_CONNECT
--
set termout on
prompt &TMPNOTOK
set termout off
start &TMPOK
-- Set the temp connect string depending on the connect_string flag
-- Do this a second time because if tmpok is set to call wgetpw again, we
-- may inadvertantly undefine the value.
select decode(UPPER('&2'),
              'N', '',
              '&CONNECT_STRING') s_tmpokconnectstring
  from dual
;
define pw_&1.=&1./&PW.&TMPOKCONNECTSTRING
-- Clean up
undefine tmpok
undefine tmpnotok
undefine tmppw
undefine tmpokconnectstring

-- End wgetpw.sql
