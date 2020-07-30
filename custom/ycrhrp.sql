-- Title
--    ycrhrp.sql
-- Function
--    Generate functions required by HR Views
-- Description
--    Separate from ycrproc because these are functions and have dependencies
--    to the hr and payroll tables and need owner name
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   04-29-98  D Cowles   put header on the file created by Wai Yee and Radha
--   28-sep-98 dglancy    Use the noetix_sys synonym/view version of 
--                        fnd_territories instead of directory referencing 
--                        applsys.fnd_territories.
--   15-Oct-98 dglancy    Use the noetix_fnd_territories_vl view instead 
--                        of the noetix_sys fnd_territories view.
--   04-Nov-98 D glancy   Use fnd_id_flex_segments_view 
--                        instead of fnd_id_flex_segments.  Can not
--                        guarantee the existence of fnd_id_flex_segments.
--   18-Dec-98 D glancy   1.  Remove the DEFINE statement prior to the execution
--                        of the ycrhrp6.sql.
--                        2.  Create VAR_PER_PEOPLE_F, VAR_PER_ASG_F, 
--                        VAR_PER_ASG_F, VAR_PER_VAC, and VAR_HR_ORG_UNITS
--                        variables to store the release 10.x versus release 11
--                        table names.
--                        3.  Use the VAR_SECURE_WHERE variable to select the 
--                        appropriate where clause for release 11 or 10.x.
--   20-Sep-99 R Lowe     Update copyright info.
--   16-Feb-00 H Sumanam  Update copyright info.
--   14-Mar-00 D Glancy   1.  Removed extraneous comments from code.
--                        2.  Call the noetix_apps_security_pkg package functions to
--                        determine hr_security.
--   24-Jul-00 D Glancy   Removed the call to wappsver.  PRODUCT_VERSION is now
--                        pulled in from tconnect.
--   03-Aug-00 D Glancy   Use the default_arraysize variable to reset the arraysize.
--   15-Sep-00 D Glancy   1.  PER_ASSIGNMENT_BUDGET_VALUES table has been changed
--                        to PER_ASSIGNMENT_BUDGET_VALUES_F.
--                        2.  HR_LOCATIONS table has been changed to HR_LOCATIONS_ALL.  
--                        _TL Table exists but is not necessary for the joins used.
--   29-Sep-00 R Lowe     Change size of two variables to use %TYPE instead of
--                        hard-coding their size.
--   03-Oct-00 D Glancy   Inadvertantly used HR_LOCATIONS_ALL for all versions.
--                        Need to change so HR_LOCATIONS is used for versions prior to 11.5.
--   11-Dec-00 D Glancy   Update Copyright info.
--   15-Dec-00 D glancy   Updated get_actual_assignment_budget function to use the
--                        date passed against the effective date columns in
--                        PER_ASSIGNMENT_BUDGET_VALUES(_F).
--   21-Dec-00 R Lowe     Put budav effective date check into variable, because
--                        column doesn't exist prior to 11.0, but script is used
--                        for all versions.
--   10-Jul-01 D Glancy   Changed the pragmas for the functions.  The RNPS pragma
--                        is required to support remote selects.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   04-Jan-02 D Glancy   If 8.1 and above create the VAR_COMMENT Variable.
--                        This basically allows us to easily define the pragma for prior 
--                        Oracle Server versions, but ignore the pragma variable.
--                        This was added because 8.1 and above do not really require these 
--                        pragmas and we have a few sites that are having problems with 
--                        these pragmas only under 8.1.  (Issue #5500)
--   06-May-02 D Glancy   1.  In create_address_lines, changed the size of the varchar2 fields
--                        to use %TYPE as well as expand some of the temporary fields.  It was possible 
--                        to overflow some of the fields as it was setup.
--                        2.  Converted to use substrb and instrb instead of substr and instr.
--                        (Issue #5447)
--   27-Sep-02 Kumar      Added the function declaration and body for latest_hire_date 
--                        (Issue 5454)
--   12-Nov-02 D Glancy   Added the function declaration and body for get_noetix_hourly_salary.
--   12-Dec-02 D Glancy   Make get_noetix_hourly_salary valid only for 11+ installs.
--                        Changed the VAR_COMMENT variable to VAR_COMMENT_PRAGMA to make it
--                        clearer what the comment variable is used for.
--                        (Issue 8904).
--   06-Feb-03 D Glancy   Add the AUTHID DEFINER compiler directive on the package header.
--   06-Feb-03 D Glancy   Updated Create_Address_Lines to print out address lables correctly
--                        for England. (Issue #5311)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   22-Jun-04 D Glancy   Use the n_get_server_version function instead of _O_RELEASE.
--                        This supports connecting to a 10g+ server.
--                        (Issue 12731)
--   15-Jul-04 D Glancy   Updated several functions to prevent the PL/SQL value error.
--                        (Issue 12857)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   20-Jun-05 D Glancy   Updated security functions to interface with new wrapper packages
--                        in the apps schema.  These functions are defined in ycrhrsec.sql.
--                        (Issue 12120 and 13739)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   14-Mar-06 D Glancy   Fixed bug with the new implementation of the check_payroll function.
--                        (Issue 12120 and 13739)
--   28-May-07 D Glancy   Add Support for Release 12.
--                        (Issue 17537)
--   31-Aug-07 D Glancy   Modified the HR Security package to better support apps mode security.  
--                        The thought was to address issues in this bug by linking the Business Group
--                        with the security profile directly.  In the prior release, we didn't do this
--                        and it cause multiple issues.  
--                        Additionally, added support to allow for turing off security profile checking
--                        altogether.  Two options are in place.  One option would allow for turning off
--                        standard security profiles.  The second option would allow for turning off global
--                        security profiles or allowing global security profiles to be used in a cross business 
--                        group manner.
--                        (Issue 14839)
--   10-Sep-07 D Glancy   Fixed some issue that we found with unit testing this solution.
--                        Database users are now handled correctly.
--                        (Issue 14839)
--   17-Sep-07 D Glancy   Renamed function to address issues with incompatible older versions of the
--                        hr security wrapper package.
--                        (Issue 14839)
--   13-Mar-09 D Glancy   Add the capability of separating standard mode processing of security profiles from global role processing
--                        of the security profile configuration.  The default for standard mode is to default HRSSP and HRGSP to "ON".
--                        (Issue 21378)
--   18-Mar-09 Srinivas   Added the parameter 'i_application_instance' in the internal calls of the check% functions in the
--                        check_security function.
--   18-Mar-09 K Kumar    Added the function declaration and body for end_of_time.
--                        Added the function declaration and body for get_user_person_type.
--                        (Issue 21941)
--   25-Jun-09 D Glancy   Take into account the effective dates of the security query user.  Using the get_sm_user_id function
--                        to return the sm_user_Id if sysdate is between the start and end_date.  
--                        (Issue 22262)
--   27-Jul-09 D Glancy   Continue looking up the sm_user_id normally.  We'll do the effective date checking in the view itself.
--                        (Issue 22262)
--   04-Mar-13 D Glancy   Add Get_Version Function.
--                        Revamped package a bit to eliminate most of the sqlplus variable setting. Probably should use synonyms for the tables next, but will not bother
--                        for now.  Get_Version is supposed to allow this package to only be created if necessary, as to not lock the package during creation.
--                        (Issue 31973)
--   29-Oct-13 D Glancy   EBS 12.2 support.
--                        (Issue 33617)
--   16-Dec-13 Karunakar  Modified get_standard_hours,get_standard_frequency functions by adding the position_id parameter. Modified the determine_full_time_salary 
--                        function by adding p_annualization_factor, p_assignment_id parameters to get the correct full time annual salaray. And modified the determine_projected_salary 
--                        function by adding p_annualization_factor parameter to get the correct projected annual salaray.
--                        (Issue 23350 and 22758)
--
@utlspon ycrhrp

whenever sqlerror exit 118
--
DEFINE APPS_USERID = 'APPS'
COLUMN c_apps_userid    new_value APPS_USERID    noprint
SELECT distinct 
       ou.oracle_username           C_APPS_USERID
  FROM fnd_oracle_userid_s  ou
 WHERE read_only_flag = 'U';
COLUMN c_apps_userid CLEAR

-- Warn if using 11.5+ and the XXNAO_HRSEC_WRAPPER_PKG does not exist
define XXNAO_HRSEC_PRESENT  = 'N'
COLUMN c_xxnao_hrsec_present NEW_VALUE XXNAO_HRSEC_PRESENT NOPRINT
SELECT 'Y'  C_XXNAO_HRSEC_PRESENT
  FROM dual
 WHERE EXISTS
     ( SELECT /*+ RULE */ 
              'Object Exists'
         FROM all_objects ao
        WHERE ao.owner       = 'APPS'
          AND ao.object_name = 'XXNAO_HRSEC_WRAPPER_PKG'
          AND ao.object_type = 'PACKAGE'
          AND rownum         = 1            );
COLUMN c_xxnao_hrsec_present CLEAR

define sys_error         = utlnop
define sys_pause         = utlnop
column s_text1  format a80
column s_text2  format a80
column s_text3  format a80
column s_text4  format a80
column s_sys_error                  new_value sys_error                 noprint
column s_sys_pause                  new_value sys_pause                 noprint

set heading  off
set feedback off
set echo     off
set verify   off
set termout  on

select /*+ RULE */
       'ERROR:  The XXNAO_HRSEC_WRAPPER_PKG package has not been defined in the '       s_text1,
       '.       &APPS_USERID schema.  You may need to manually run the routine '        s_text2,
       '.       to fix this issue.  Log in as the &APPS_USERID and run the '            s_text3,
       '.       "iappspkg.sql" script. '                                                s_text4,
       ( case '&UI'
           when 'SQLPLUS' then ( case '&AUTOMATION_METHOD'
                                   when 'CM'   then 'utlnop'
                                   when 'CRON' then 'utlnop'
                                   else 'utlpause EXIT'
                                 end )
           else 'utlnop' 
         end )                                                                   s_sys_pause,
       'utlexit 403'                                                             s_sys_error
  from dual
 where '&XXNAO_HRSEC_PRESENT'  = 'N'
   and '&DAT_TYPE'             = 'Views';

start &SYS_PAUSE
start &SYS_ERROR

set termout off;
set echo   on                              
--
CREATE OR REPLACE PACKAGE noetix_hr_pkg AUTHID DEFINER is
  --
  FUNCTION get_version
  RETURN varchar2;

  -- determine dated headcount
  FUNCTION dated_headcount (p_date_wanted         DATE,
                            p_date_start          DATE,
                            p_date_end            DATE) 
  return integer;
  --
  -- get original_hire_date 
  FUNCTION get_original_hire_date (p_person_id         INTEGER) 
  return date;
  --
  -- get latest_hire_date 
  FUNCTION get_latest_hire_date (p_person_id         INTEGER) 
  return date;
  --
--
  -- get legislation code
  FUNCTION get_legislation_code (p_business_group_id INTEGER) 
  return varchar2;
  --
  -- get organization legal entity 
  FUNCTION get_legal_entities (p_soft_coding_keyflex_id NUMBER)
  return varchar2;
  --
  -- get person's total length of service in months
  FUNCTION get_length_of_service (p_person_id         INTEGER) 
  return number;
  --
  FUNCTION get_actual_assignment_budget (p_business_group_id INTEGER,
                                         p_budget_start_date DATE,
                                         p_grade_id          INTEGER,
                                         p_position_id       INTEGER,
                                         p_job_id            INTEGER,
                                         p_organization_id   INTEGER,
                                         p_budget_unit       VARCHAR2) 
  return number;
  
   -- Check to see how we want to process security profiles/business groups
   FUNCTION Check_Sec_Profile_Policy( i_business_group_id    IN INTEGER  DEFAULT NULL, 
                                      i_application_label    IN VARCHAR2 DEFAULT 'HR',
                                      i_application_instance IN VARCHAR2 DEFAULT '0'  ) 
     RETURN VARCHAR2;
   --
   -- check HRMS security
   FUNCTION check_security( i_organization_id      IN INTEGER,
                            i_assignment_id        IN INTEGER,
                            i_position_id          IN INTEGER,
                            i_person_id            IN INTEGER,
                            i_employee_num         IN VARCHAR2,
                            i_applicant_num        IN VARCHAR2,
                            i_person_type_id       IN NUMBER,
                            i_assignment_type      IN VARCHAR2 DEFAULT NULL,
                            i_assign_only_security IN VARCHAR2 DEFAULT 'Y',
                            i_business_group_id    IN INTEGER  DEFAULT NULL, 
                            i_application_label    IN VARCHAR2 DEFAULT 'HR',
                            i_application_instance IN VARCHAR2 DEFAULT '0'      )
     return integer;
  --
  -- check organization unit security
  FUNCTION check_organization( i_organization_id      IN INTEGER,
                               i_business_group_id    IN INTEGER  DEFAULT NULL, 
                               i_application_label    IN VARCHAR2 DEFAULT 'HR',
                               i_application_instance IN VARCHAR2 DEFAULT '0'  ) 
    RETURN INTEGER;
  --
  -- check assignment security
  FUNCTION check_assignment( i_assignment_id        IN INTEGER,
                             i_person_id            IN INTEGER,
                             i_assignment_type      IN VARCHAR2,
                             i_assign_only_security IN VARCHAR2 DEFAULT 'Y',
                             i_business_group_id    IN INTEGER  DEFAULT NULL, 
                             i_application_label    IN VARCHAR2 DEFAULT 'HR',
                             i_application_instance IN VARCHAR2 DEFAULT '0'  )
    RETURN INTEGER;
  --
  -- check person security
  FUNCTION check_person( i_person_id             IN INTEGER,
                         i_employee_num          IN VARCHAR2,
                         i_applicant_num         IN VARCHAR2,
                         i_person_type_id        IN INTEGER,
                         i_business_group_id     IN INTEGER  DEFAULT NULL, 
                         i_application_label     IN VARCHAR2 DEFAULT 'HR',
                         i_application_instance  IN VARCHAR2 DEFAULT '0'    )
    return integer;
  --
  -- check payroll security
  FUNCTION check_payroll( i_payroll_id           IN INTEGER,
                          i_business_group_id    IN INTEGER  DEFAULT NULL, 
                          i_application_label    IN VARCHAR2 DEFAULT 'HR',
                          i_application_instance IN VARCHAR2 DEFAULT '0'  )
  return integer;
  --
  -- check position security
  FUNCTION check_position( i_position_id          IN INTEGER,
                           i_business_group_id    IN INTEGER  DEFAULT NULL, 
                           i_application_label    IN VARCHAR2 DEFAULT 'HR',
                           i_application_instance IN VARCHAR2 DEFAULT '0'  )
  return integer;
  --
  -- check vacancy security
  FUNCTION check_vacancy( i_vacancy_id            IN INTEGER,
                          i_organization_id       IN INTEGER   DEFAULT NULL,
                          i_position_id           IN INTEGER   DEFAULT NULL,
                          i_manager_id            IN INTEGER   DEFAULT NULL,
                          i_security_method       IN VARCHAR2  DEFAULT NULL,
                          i_business_group_id     IN INTEGER   DEFAULT NULL, 
                          i_application_label     IN VARCHAR2  DEFAULT 'HR',
                          i_application_instance  IN VARCHAR2  DEFAULT '0'  ) 
    RETURN INTEGER;
  --
  -- create noetix address lines
  FUNCTION create_address_lines (p_address_id INTEGER,
                                 p_line_number INTEGER,
                                 p_legislative_code VARCHAR2)
  return varchar2;
  --
  -- create noetix location address lines
  FUNCTION create_loc_address_lines (p_location_id INTEGER,
                                     p_line_number INTEGER,
                                     p_legislative_code VARCHAR2)
  return varchar2;
  --
  PROCEDURE put_address_line (p_address_line    IN     VARCHAR2,
                              p_last_addr_line1 IN OUT VARCHAR2,
                              p_last_addr_line2 IN OUT VARCHAR2,
                              p_last_addr_line3 IN OUT VARCHAR2,
                              p_last_addr_line4 IN OUT VARCHAR2,
                              p_last_addr_line5 IN OUT VARCHAR2,
                              p_last_addr_line6 IN OUT VARCHAR2
  );
  --
  PROCEDURE put_loc_address_line ( p_loc_address_line    IN     VARCHAR2,
                                   p_last_loc_addr_line1 IN OUT VARCHAR2,
                                   p_last_loc_addr_line2 IN OUT VARCHAR2,
                                   p_last_loc_addr_line3 IN OUT VARCHAR2,
                                   p_last_loc_addr_line4 IN OUT VARCHAR2,
                                   p_last_loc_addr_line5 IN OUT VARCHAR2,
                                   p_last_loc_addr_line6 IN OUT VARCHAR2
  );
  --
  -- create concatenated SI criteria segment names
  FUNCTION determine_si_criteria_name (n_id_flex_code           VARCHAR2,
                                       n_id_flex_num            INTEGER,
                                       n_application_id         INTEGER,
                                       n_analysis_criteria_id   INTEGER)
  return varchar2;
  --
  -- create concatenated SI criteria segment value
  FUNCTION determine_si_criteria_value (v_id_flex_code          VARCHAR2,
                                        v_id_flex_num           INTEGER,
                                        v_application_id        INTEGER,
                                        v_analysis_criteria_id  INTEGER)
  return varchar2;
  --
  -- create concatenated personal analysis segment value
  FUNCTION determine_pera_criteria_value
                              (p_id_flex_code         VARCHAR2,
                               p_id_flex_num          INTEGER,
                               p_application_id       INTEGER,
                               p_analysis_criteria_id INTEGER,
                               p_person_id            INTEGER,
                               p_business_group_id    INTEGER)
  return varchar2;
  --
  --
  -- create ranking value of personal analysis segment value
  FUNCTION determine_pera_criteria_rank
                              (p_id_flex_code         VARCHAR2,
                               p_id_flex_num          INTEGER,
                               p_application_id       INTEGER,
                               p_analysis_criteria_id INTEGER,
                               p_person_id            INTEGER,
                               p_business_group_id    INTEGER)
  RETURN INTEGER;
  --
  -- concatenate person's name
  FUNCTION concat_name(p_title      VARCHAR2,
                       p_first_name VARCHAR2,
                       p_last_name  VARCHAR2,
                       P_suffix     VARCHAR2)
  RETURN VARCHAR2;

  -- check if a security profile is set-up for the person
  FUNCTION check_security_profile(p_user varchar2)
  RETURN INTEGER;
  --
  --  end of date
   FUNCTION end_of_time    return date;
  --
  -- get user person type
  FUNCTION get_user_person_type (p_effective_date  DATE,  p_person_id  NUMBER ) 
  return VARCHAR2;
  --
END noetix_hr_pkg;
/
show errors
--
CREATE OR REPLACE PACKAGE BODY noetix_hr_pkg IS
    --
    gc_pkg_version                 CONSTANT VARCHAR2(30)    := '6.5.1.1566';
    gc_end_of_time                 CONSTANT DATE            := to_date('31/12/4712','DD/MM/YYYY'); 
    gc_user_person_type_separator  CONSTANT VARCHAR2(1)     := '.';
    --
    FUNCTION get_version
      RETURN varchar2 IS
    BEGIN
        return gc_pkg_version;
    END get_version;
    --
   -------------------------------------------------------------------------
   -- ------  Determine head count based on a specific date
   -------------------------------------------------------------------------
   FUNCTION dated_headcount (p_date_wanted         DATE,
                             p_date_start          DATE,
                             p_date_end            DATE) 
   return INTEGER is
      head_count integer;
   BEGIN
      head_count := 0;
      --
      select 1
      into   head_count
      from   dual
      where  p_date_wanted
             between p_date_start and nvl(p_date_end, trunc(sysdate));
      --
      return head_count;
   EXCEPTION when others then
      return 0;
   END dated_headcount;

   -------------------------------------------------------------------------
   -- ------  GET_ORIGINAL_HIRE_DATE based on person's first period of service
   -- ------                         start date
   -------------------------------------------------------------------------
   FUNCTION get_original_hire_date (p_person_id INTEGER)
   RETURN DATE IS
     p_original_hire_date date;
   BEGIN
     SELECT min(date_start)
     into   p_original_hire_date
     from   per_periods_of_service_s serv
     where  person_id = p_person_id;
     --
     return(p_original_hire_date);
   END get_original_hire_date;

   -------------------------------------------------------------------------
   -- ------  GET_LATEST_HIRE_DATE - based on person's last 
   -- ------                         period of service start date
   -------------------------------------------------------------------------
   FUNCTION get_latest_hire_date (p_person_id INTEGER)
   RETURN DATE IS
        --
        p_latest_hire_date date;
        --
   BEGIN
        --
        SELECT MAX(date_start)
          INTO p_latest_hire_date
          FROM per_periods_of_service_s serv
         WHERE person_id = p_person_id;
        --
        return(p_latest_hire_date);
        --
   END get_latest_hire_date;

-- ---------------------------------------------------------------------------
-- ----------------- GET_LEGISLATION_CODE based on business unit -------------
-- ---------------------------------------------------------------------------
   FUNCTION get_legislation_code( p_business_group_id INTEGER ) 
     RETURN VARCHAR2 IS
      v_legislation_code hr_organization_information_s.org_information9%TYPE;
   BEGIN
      SELECT orgic.org_information9
        INTO v_legislation_code
        FROM hr_all_organization_units_s   org,
             hr_organization_information_s orgic
       WHERE org.organization_id            = p_business_group_id
         AND org.organization_id            = orgic.organization_id
         AND orgic.org_information_context  = 'Business Group Information';
      --
      return( v_legislation_code );
   EXCEPTION 
        WHEN OTHERS THEN
            return null;
   END get_legislation_code;

-- ---------------------------------------------------------------------------
-- ----------------- GET_LEGAL_ENTITIES based on assignment's soft coding 
-- -----------------                    keyflex
-- ---------------------------------------------------------------------------
   FUNCTION get_legal_entities( p_soft_coding_keyflex_id NUMBER ) 
     RETURN VARCHAR2 is
      gre_organization_name  hr_all_organization_units_s.name%TYPE;
   --
   BEGIN
      IF ( p_soft_coding_keyflex_id is not null ) THEN
         BEGIN
            SELECT org.name
              INTO gre_organization_name
              FROM hr_all_organization_units_s org,
                   hr_soft_coding_keyflex_s    softk
             WHERE softk.soft_coding_keyflex_id = p_soft_coding_keyflex_id
               AND to_number(softk.segment1)    = org.organization_id;
            --
            RETURN gre_organization_name;
            --
         EXCEPTION when others THEN
            return null;
         END;
      ELSE 
         return null;
      END IF;
      --
   END get_legal_entities; 

   -------------------------------------------------------------------------
   -- ------  GET_LENGTH_OF_SERVICE based on person's all periods of service
   -- ------                        in month unit
   -------------------------------------------------------------------------
   FUNCTION get_length_of_service( p_person_id         INTEGER ) 
     RETURN NUMBER IS
     p_length_of_service number;
   BEGIN
     SELECT trunc(sum(months_between(nvl(serv.actual_termination_date,
                                         trunc(sysdate)), 
                                     serv.date_start)))
       INTO p_length_of_service
       FROM per_periods_of_service_s serv
      WHERE serv.person_id = p_person_id
        AND EXISTS 
          ( SELECT 'Primary Assignments Only'
              FROM per_all_assignments_f_s asg
             WHERE asg.period_of_service_id = serv.period_of_service_id
               AND asg.person_id            = p_person_id
               AND asg.assignment_type      = 'E'
               AND asg.primary_flag         = 'Y');
     --
     return(p_length_of_service);
   END get_length_of_service;

   -------------------------------------------------------------------------
   -- ------ GET_ACTUAL_ASSIGNMENT_BUDGET returns the actual assignment budget
   -- ------                              value within the budget period for a
   -- ------                              specific job, position, grade, and/or
   -- ------                              organization
   -------------------------------------------------------------------------
   FUNCTION get_actual_assignment_budget (p_business_group_id INTEGER,
                                          p_budget_start_date DATE,
                                          p_grade_id          INTEGER,
                                          p_position_id       INTEGER,
                                          p_job_id            INTEGER,
                                          p_organization_id   INTEGER,
                                          p_budget_unit       VARCHAR2) 
     RETURN NUMBER IS
     p_actual_value     NUMBER;
   BEGIN
     IF ( p_position_id is not null ) THEN
        SELECT nvl(sum(nvl(budav.value,0)),0)
          INTO p_actual_value
          FROM per_all_assignments_f_s          asg,
               per_assignment_budget_values_s   budav
         WHERE asg.business_group_id+0      = p_business_group_id
           AND asg.assignment_type          = 'E'
           AND p_budget_start_date 
               BETWEEN asg.effective_start_date 
                   AND asg.effective_end_date 
           AND nvl(asg.grade_id,-1)         = nvl(p_grade_id,nvl(asg.grade_id,-1))
           AND nvl(asg.job_id,-1)           = nvl(p_job_id,nvl(asg.job_id,-1))
           AND asg.position_id              = p_position_id
           AND asg.organization_id          = nvl(p_organization_id,asg.organization_id)
           AND asg.assignment_id            = budav.assignment_id
           AND asg.business_group_id+0      = budav.business_group_id+0
           AND budav.unit                   = p_budget_unit
           AND trunc( p_budget_start_date )
               BETWEEN trunc(nvl(budav.effective_start_date,p_budget_start_date))
                   AND nvl(budav.effective_end_date, trunc(p_budget_start_date));

     ELSIF ( p_job_id is not null ) THEN
        SELECT nvl(sum(nvl(budav.value,0)),0)
          INTO p_actual_value
          FROM per_all_assignments_f_s          asg,
               per_assignment_budget_values_s   budav
         WHERE asg.business_group_id+0      = p_business_group_id
           AND asg.assignment_type          = 'E'
           AND p_budget_start_date 
               BETWEEN asg.effective_start_date 
                   AND asg.effective_end_date 
           AND nvl(asg.grade_id,-1)         = nvl(p_grade_id,nvl(asg.grade_id,-1))
           AND nvl(asg.position_id,-1)      = nvl(p_position_id,nvl(asg.position_id,-1))
           AND asg.job_id                   = p_job_id
           AND asg.organization_id          = nvl(p_organization_id, asg.organization_id)
           AND asg.assignment_id            = budav.assignment_id
           AND asg.business_group_id+0      = budav.business_group_id+0
           AND budav.unit                   = p_budget_unit
           AND trunc( p_budget_start_date )
               BETWEEN trunc(nvl(budav.effective_start_date,p_budget_start_date))
                   AND nvl(budav.effective_end_date, trunc(p_budget_start_date));

     ELSIF ( p_grade_id is not null ) THEN
        SELECT nvl(sum(nvl(budav.value,0)),0)
          INTO p_actual_value
          FROM per_all_assignments_f_s          asg,
               per_assignment_budget_values_s   budav
         WHERE asg.business_group_id+0      = p_business_group_id
           AND asg.assignment_type          = 'E'
           AND p_budget_start_date 
               BETWEEN asg.effective_start_date 
                   AND asg.effective_end_date 
           AND nvl(asg.job_id,-1)           = nvl(p_job_id,nvl(asg.job_id,-1))
           AND nvl(asg.position_id,-1)      = nvl(p_position_id,nvl(asg.position_id,-1))
           AND asg.grade_id                 = p_grade_id
           AND asg.organization_id          = nvl(p_organization_id,asg.organization_id)
           AND asg.assignment_id            = budav.assignment_id
           AND asg.business_group_id+0      = budav.business_group_id+0
           AND budav.unit                   = p_budget_unit
           AND trunc( p_budget_start_date )
               BETWEEN trunc(nvl(budav.effective_start_date,p_budget_start_date))
                   AND nvl(budav.effective_end_date, trunc(p_budget_start_date));

     ELSE
        SELECT nvl(sum(nvl(budav.value,0)),0)
          INTO p_actual_value
          FROM per_all_assignments_f_s          asg,
               per_assignment_budget_values_s   budav
         WHERE asg.business_group_id+0      = p_business_group_id
           AND asg.assignment_type          = 'E'
           AND p_budget_start_date 
               BETWEEN asg.effective_start_date 
                   AND asg.effective_end_date 
           AND nvl(asg.grade_id,-1)         = nvl(p_grade_id,nvl(asg.grade_id,-1))
           AND nvl(asg.job_id,-1)           = nvl(p_job_id,nvl(asg.job_id,-1))
           AND nvl(asg.position_id,-1)      = nvl(p_position_id,nvl(asg.position_id,-1))
           AND asg.organization_id          = nvl(p_organization_id,asg.organization_id)
           AND asg.assignment_id            = budav.assignment_id
           AND asg.business_group_id+0      = budav.business_group_id+0
           AND budav.unit                   = p_budget_unit
           AND trunc( p_budget_start_date )
               BETWEEN trunc(nvl(budav.effective_start_date,p_budget_start_date))
                   AND nvl(budav.effective_end_date, trunc(p_budget_start_date));
     END IF;
     --
     return(p_actual_value);
   END get_actual_assignment_budget;
   --
   -- -------------------------------------------------------------------------
   -- ----------------- CHECK SECURITY PROFILE FOR THE USER -------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_security_profile( p_user    varchar2 ) 
   RETURN INTEGER IS
     user_ok    INTEGER;
   BEGIN
      BEGIN
        SELECT 0 
          INTO user_ok
          FROM per_security_profiles_s psp
         WHERE psp.reporting_oracle_username = user;
        
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
           user_ok := 1;
        WHEN OTHERS THEN 
           user_ok := 0;
      END;
      --
      RETURN user_ok;
      --
   END check_security_profile;   
   --  
   -- -------------------------------------------------------------------------
   -- -----------------      Check_Sec_Profile_Policy       -------------------
   -- -------------------------------------------------------------------------
   FUNCTION Check_Sec_Profile_Policy( i_business_group_id    IN INTEGER  DEFAULT NULL, 
                                      i_application_label    IN VARCHAR2 DEFAULT 'HR',
                                      i_application_instance IN VARCHAR2 DEFAULT '0'  ) 
   RETURN VARCHAR2 IS
      ls_instance_type        VARCHAR2(1) := ( case 
                                                 when i_application_instance like 'G%' then 'G'
                                                 when i_application_instance like 'X%' then 'X'
                                                 else 'S'
                                               end );
      ls_sp_type              VARCHAR2(1) := &NOETIX_USER..noetix_apps_security_pkg.Get_Sec_Profile_Type;
      ls_ssp_processing_code  VARCHAR2(5) := &NOETIX_USER..noetix_apps_security_pkg.Get_Std_SP_Processing_Code( i_application_label,
                                                                                                                ls_instance_type );
      ls_gsp_processing_code  VARCHAR2(5) := &NOETIX_USER..noetix_apps_security_pkg.Get_Global_SP_Processing_Code( i_application_label,
                                                                                                                   ls_instance_type );
      li_bg_id                INTEGER     := &NOETIX_USER..noetix_apps_security_pkg.Get_Business_Group_ID;
      -- 
      -- The get_sm_user_id function will validate if the query user is enabled (current date is 
      -- between the effective dates in the user record.  Don't bother checking if the user is 
      -- enabled.  Since we are already checking at the BG level in the view,
      -- the row will not return in that case anyway if the user is disabled.  Manually setting
      -- the value to 'N'
      --
      li_sm_user_id           INTEGER     := &NOETIX_USER..noetix_apps_security_pkg.Get_sm_user_id( i_check_enabled_flag => 'N' );
      ls_return      VARCHAR2(5) := 'ON';
   BEGIN
      
      if ( NVL(li_sm_user_id,-1) < 0 ) then
        ls_return := 'FAIL';
      -- If the detected security profile is Standard and we have disabled Security Profile
      -- checking
      ELSIF ( ls_sp_type             = 'S'   AND
              ls_ssp_processing_code = 'OFF' ) THEN
         ls_return := 'OFF'; 
      -- If the detected security profile is Standard and we have disabled Security Profile
      -- checking
      ELSIF ( ls_sp_type             = 'G'   AND
              ls_gsp_processing_code = 'OFF' ) THEN
         ls_return := 'OFF';
      ELSIF ( i_business_group_id is null ) THEN
         ls_return := 'ON';
      -- If the detected security profile is Standard and we have disabled Security Profile
      -- checking, return
      ELSIF ( ls_sp_type             = 'G'   AND
              ls_gsp_processing_code = 'XBG' ) THEN
         -- The Cross Business Group check failed, If no failure we still want to process the
         -- security profile
         IF ( NOT ( &NOETIX_USER..noetix_apps_security_pkg.Is_Valid_Cross_Business_Group( i_business_group_id ) ) ) then
            ls_return := 'FAIL';
         END IF;
      ELSE
         -- The Business Group check failed, If no failure we still want to process the
         -- security profile
         -- Passed business group check, will process security profile next.
         -- Could not determine the business group, bypass the security profile check
         -- Database users will return full access with no security profile or security profile bg lookups.
         if ( noetix_apps_security_pkg.is_apps_mode_user or noetix_apps_security_pkg.is_hr_reporting_user ) then
             if ( li_bg_id                          = i_business_group_id OR
                  li_bg_id                          = -1                 
                  /*OR
                  li_bg_id                         IS NULL */            
                  ) THEN
                ls_return := 'ON';
             else
                -- The Business Group check failed, If no failure we still want to process the
                -- security profile
                ls_return := 'FAIL';
             end if;
         else
             -- This must be a database user
             ls_return := 'OFF';
         end if;
      END IF;
      
      return ls_return;
      --
   END Check_Sec_Profile_Policy;   --  
   --  
   -- -------------------------------------------------------------------------
   -- ----------------- CHECK ORGANIZATION UNIT SECURITY ----------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_security( i_organization_id      IN INTEGER,
                            i_assignment_id        IN INTEGER,
                            i_position_id          IN INTEGER,
                            i_person_id            IN INTEGER,
                            i_employee_num         IN VARCHAR2,
                            i_applicant_num        IN VARCHAR2,
                            i_person_type_id       IN NUMBER,
                            i_assignment_type      IN VARCHAR2  DEFAULT NULL,
                            i_assign_only_security IN VARCHAR2  DEFAULT 'Y',
                            i_business_group_id    IN INTEGER   DEFAULT NULL,
                            i_application_label    IN VARCHAR2  DEFAULT 'HR',
                            i_application_instance IN VARCHAR2  DEFAULT '0'   )
     RETURN INTEGER IS
       ls_sec_profile_policy VARCHAR2(5) := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                      i_application_label,
                                                                      i_application_instance );
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
      if (XXNAO_FND_WRAPPER_PKG_s.resp_appl_id not in (-1,800, 801, 805, 808, 809)) then
      ls_sec_profile_policy := 'FAIL';
    end if;
    
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;
      
      --
      IF ( i_person_id is not null ) then
         IF ( NOETIX_HR_PKG.check_person( i_person_id,
                                          i_employee_num,
                                          i_applicant_num,
                                          i_person_type_id,
                                          i_business_group_id,
                                          i_application_label,
                                          i_application_instance ) = 0 ) THEN
            return 0; 
         END IF; 
      END IF; 
      --
      IF ( i_organization_id is not null ) then
         IF ( NOETIX_HR_PKG.check_organization( i_organization_id,
                                                i_business_group_id,
                                                i_application_label,
                                                i_application_instance ) = 0 ) THEN
            return 0;
         END IF;
      END IF;
      --
      IF ( i_assignment_id is not null ) then
         IF ( NOETIX_HR_PKG.check_assignment( i_assignment_id,
                                              i_person_id,
                                              i_assignment_type,
                                              i_assign_only_security,
                                              i_business_group_id,
                                              i_application_label,
                                              i_application_instance ) = 0 ) THEN
            return 0;
         END IF;
      END IF;
      --
      IF ( i_position_id is not null ) then
         IF ( NOETIX_HR_PKG.check_position( i_position_id,
                                            i_business_group_id,
                                            i_application_label,
                                            i_application_instance ) = 0 ) THEN
            return 0;
         END IF;
      END IF;
      --
      return 1;
   END check_security; 
   --
   -- -------------------------------------------------------------------------
   -- ----------------- CHECK ORGANIZATION UNIT SECURITY ----------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_organization( i_organization_id      IN INTEGER,
                                i_business_group_id    IN INTEGER   DEFAULT NULL,
                                i_application_label    IN VARCHAR2  DEFAULT 'HR',
                                i_application_instance IN VARCHAR2  DEFAULT '0'  ) 
     RETURN INTEGER IS
       ls_sec_profile_policy VARCHAR2(5) := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                      i_application_label,
                                                                      i_application_instance );
       li_org_ok                  BINARY_INTEGER  := 0;
       li_security_profile_id     INTEGER;
       ls_security_ok             VARCHAR2(10);
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;
      
      -- If null, then no processing is necessary
      if ( i_organization_id is null ) then
          li_org_ok := 1;
      else
          ls_security_ok :=
             &APPS_USERID..XXNAO_HRSEC_WRAPPER_PKG.show_record( 
                                              p_table_name => 'HR_ALL_ORGANIZATION_UNITS',
                                              p_unique_id  => i_organization_id );
          if ( ls_security_ok = 'TRUE' ) then
              li_org_ok := 1;
          end if;
      end if;
      --
      return li_org_ok;
      --
   EXCEPTION 
      WHEN others THEN
         return 0;
   END check_organization; 
   --
   -- -------------------------------------------------------------------------
   -- ----------------- CHECK ASSIGNMENT SECURITY -----------------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_assignment( i_assignment_id        IN INTEGER,
                              i_person_id            IN INTEGER,
                              i_assignment_type      IN VARCHAR2,
                              i_assign_only_security IN VARCHAR2  DEFAULT 'Y', 
                              i_business_group_id    IN INTEGER   DEFAULT NULL,
                              i_application_label    IN VARCHAR2  DEFAULT 'HR',
                              i_application_instance IN VARCHAR2  DEFAULT '0'  )
     RETURN INTEGER IS
       ls_sec_profile_policy VARCHAR2(5) := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                      i_application_label,
                                                                      i_application_instance );
       li_asg_ok                  INTEGER     := 0;
       li_security_profile_id     INTEGER;
       ls_assign_only_security    VARCHAR2(1) := 'Y';
       ls_security_ok             VARCHAR2(10);
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;

      -- If null, then no processing is necessary
      if ( i_assignment_id is null ) then
         li_asg_ok     := 1;
      else

          if ( i_assign_only_security = 'N' ) then
             ls_assign_only_security := 'N';
          end if;

          ls_security_ok :=
                     &APPS_USERID..XXNAO_HRSEC_WRAPPER_PKG.show_record( 
                                                         p_table_name => 'PER_ALL_ASSIGNMENTS_F',
                                                         p_unique_id  => i_assignment_id,
                                                         p_val1       => i_person_id,
                                                         p_val2       => i_assignment_type,
                                                         p_val3       => ls_assign_only_security );
          if ( ls_security_ok = 'TRUE' ) then
              li_asg_ok := 1;
          end if;
      end if;
      --
      return li_asg_ok;
      --
   EXCEPTION 
      WHEN others THEN
         return 0;
   END check_assignment; 
   --
   -- -------------------------------------------------------------------------
   -- --------------------- CHECK PEOPLE SECURITY -----------------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_person( i_person_id            IN INTEGER,
                          i_employee_num         IN VARCHAR2,
                          i_applicant_num        IN VARCHAR2,
                          i_person_type_id       IN INTEGER, 
                          i_business_group_id    IN INTEGER   DEFAULT NULL,
                          i_application_label    IN VARCHAR2  DEFAULT 'HR',
                          i_application_instance IN VARCHAR2  DEFAULT '0'  ) 
     RETURN INTEGER is
       ls_sec_profile_policy VARCHAR2(5) := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                      i_application_label,
                                                                      i_application_instance );
       li_peo_ok                  BINARY_INTEGER     := 0;
       li_security_profile_id     INTEGER;
       ls_security_ok             VARCHAR2(10);
   --
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
       if (XXNAO_FND_WRAPPER_PKG_s.resp_appl_id not in (-1,800, 801, 805, 808, 809)) then
      ls_sec_profile_policy := 'FAIL';
      end if;
    
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;

      -- If null, then no processing is necessary
      if ( i_person_id is null ) then
         li_peo_ok     := 1;
      else
          ls_security_ok :=
                     &APPS_USERID..XXNAO_HRSEC_WRAPPER_PKG.show_record( 
                                                         p_table_name => 'PER_ALL_PEOPLE_F',
                                                         p_unique_id  => i_person_id,
                                                         p_val1       => i_person_type_id,
                                                         p_val2       => i_employee_num,
                                                         p_val3       => i_applicant_num );
          if ( ls_security_ok = 'TRUE' ) then
              li_peo_ok := 1;
          end if;
      end if;
      --
      return li_peo_ok;
      --
   EXCEPTION 
      WHEN others THEN
           return 0;
   END check_person; 
   --
   -- -------------------------------------------------------------------------
   -- --------------------- CHECK PAYROLL SECURITY ----------------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_payroll( i_payroll_id           IN INTEGER, 
                           i_business_group_id    IN INTEGER   DEFAULT NULL,
                           i_application_label    IN VARCHAR2  DEFAULT 'HR',
                           i_application_instance IN VARCHAR2  DEFAULT '0'  ) 
     RETURN INTEGER is 
       ls_sec_profile_policy VARCHAR2(5)      := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                          i_application_label,
                                                                          i_application_instance );
       li_pay_ok                  BINARY_INTEGER     := 0;
       li_security_profile_id     INTEGER;
       ls_security_ok             VARCHAR2(10);
   --
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;

      -- If null, then no processing is necessary
      if ( i_payroll_id ) is null then
         li_pay_ok  := 1;
      else
          ls_security_ok :=
                     &APPS_USERID..XXNAO_HRSEC_WRAPPER_PKG.show_record( 
                                                         p_table_name => 'PAY_ALL_PAYROLLS_F',
                                                         p_unique_id  => i_payroll_id );
          if ( ls_security_ok = 'TRUE' ) then
              li_pay_ok := 1;
          end if;
      end if;
      --
      return li_pay_ok;
      --
   EXCEPTION 
      WHEN others THEN
           return 0;
   END check_payroll; 
   --
   -- -------------------------------------------------------------------------
   -- --------------------- CHECK POSITION SECURITY ---------------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_position( i_position_id          IN INTEGER, 
                            i_business_group_id    IN INTEGER   DEFAULT NULL,
                            i_application_label    IN VARCHAR2  DEFAULT 'HR',
                            i_application_instance IN VARCHAR2  DEFAULT '0'  ) 
     RETURN INTEGER is
       ls_sec_profile_policy VARCHAR2(5) := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                      i_application_label,
                                                                      i_application_instance );
       li_pos_ok               BINARY_INTEGER   := 0;
       li_security_profile_id  INTEGER;
       ls_security_ok          VARCHAR2(10);
   --
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;

      -- 
      -- If null, then no processing is necessary
      if ( i_position_id is null ) then
         li_pos_ok  := 1;
      else
          ls_security_ok :=
                     &APPS_USERID..XXNAO_HRSEC_WRAPPER_PKG.show_record( 
                                                         p_table_name => 'PER_ALL_POSITIONS',
                                                         p_unique_id  => i_position_id );
          if ( ls_security_ok = 'TRUE' ) then
              li_pos_ok := 1;
          end if;
      end if;
      --
      return li_pos_ok;
      --
   EXCEPTION 
      WHEN others THEN
           return 0;
   END check_position; 
   --
   -- -------------------------------------------------------------------------
   -- --------------------- CHECK VACANCY SECURITY ----------------------------
   -- -------------------------------------------------------------------------
   FUNCTION check_vacancy( i_vacancy_id        IN INTEGER,
                           i_organization_id   IN INTEGER     DEFAULT NULL,
                           i_position_id       IN INTEGER     DEFAULT NULL,
                           i_manager_id        IN INTEGER     DEFAULT NULL,
                           i_security_method   IN VARCHAR2    DEFAULT NULL,
                           i_business_group_id IN INTEGER     DEFAULT NULL,
                           i_application_label IN VARCHAR2    DEFAULT 'HR',
                           i_application_instance IN VARCHAR2 DEFAULT '0'  ) 
     RETURN INTEGER is
       ls_sec_profile_policy VARCHAR2(5) := Check_Sec_Profile_Policy( i_business_group_id, 
                                                                      i_application_label,
                                                                      i_application_instance );
       li_vac_ok               BINARY_INTEGER   := 0;
       li_security_profile_id  INTEGER;
       ls_security_ok          VARCHAR2(10);
   --
   BEGIN

      -- Determine what the policy is for security profile processing
      -- If the return value is 
      --    'OFF'  - Do not process the security profile, return 1
      --    'FAIL' - Failed the business group check, return 0
      --    'ON'   - Process the security profile
      if ( ls_sec_profile_policy = 'OFF' ) then
          return 1;
      elsif ( ls_sec_profile_policy = 'FAIL' ) then
          return 0;
      end if;

      --
      -- If null, then no processing is necessary
      if ( i_vacancy_id is null ) then
         li_vac_ok  := 1;
      else
          ls_security_ok :=
                     &APPS_USERID..XXNAO_HRSEC_WRAPPER_PKG.show_record( 
                                                         p_table_name => 'PER_ALL_VACANCIES',
                                                         p_unique_id  => i_vacancy_id,
                                                         p_val1       => i_organization_id,
                                                         p_val2       => i_position_id,
                                                         p_val3       => i_manager_id,
                                                         p_val4       => i_security_method    );
          if ( ls_security_ok = 'TRUE' ) then
              li_vac_ok := 1;
          end if;
      end if;
      --
      return li_vac_ok;
      --
   EXCEPTION 
      WHEN others THEN
           return 0;
   END check_vacancy; 
   --
   -- -------------------------------------------------------------------------
   -- ----------------- CREATE SIX ADDRESS LINES ------------------------------
   -- -------------------------------------------------------------------------
   FUNCTION create_address_lines
     ( p_address_id INTEGER,
       p_line_number INTEGER,
       p_legislative_code VARCHAR2
     ) return VARCHAR2 
   is
     last_addr_line1    VARCHAR2(200);
     last_addr_line2    VARCHAR2(200);
     last_addr_line3    VARCHAR2(200);
     last_addr_line4    VARCHAR2(200);
     last_addr_line5    VARCHAR2(200);
     last_addr_line6    VARCHAR2(200);
     --
     addr_style         per_addresses_s.style%TYPE;          -- varchar2(30);
     addr_line1         per_addresses_s.address_line1%TYPE;  -- varchar2(60);
     addr_line2         per_addresses_s.address_line2%TYPE;  -- varchar2(60);
     addr_line3         per_addresses_s.address_line3%TYPE;  -- varchar2(60);
     addr_line4         varchar2(200);
     addr_line5         varchar2(200);
     addr_line6         varchar2(200);
     addr_town_or_city  per_addresses_s.town_or_city%TYPE;   -- varchar2(30);
     addr_region1       per_addresses_s.region_1%TYPE;       -- varchar2(70);
     addr_region2       per_addresses_s.region_2%TYPE;       -- varchar2(70);
     addr_region3       per_addresses_s.region_3%TYPE;       -- varchar2(70);
     addr_postal_code   per_addresses_s.postal_code%TYPE;    -- varchar2(30);
     addr_country       per_addresses_s.country%TYPE;        -- varchar2(60);
   BEGIN
      addr_line1 := null;
      addr_line2 := null;
      addr_line3 := null;
      addr_line4 := null;
      addr_line5 := null;
      addr_line6 := null;
      --
      IF p_address_id is null THEN
         return null;
      ELSE
         --
         -- get new address
         last_addr_line1 := null;
         last_addr_line2 := null;
         last_addr_line3 := null;
         last_addr_line4 := null;
         last_addr_line5 := null;
         last_addr_line6 := null;
         --
         BEGIN
            SELECT a.address_line1,   a.address_line2,    a.address_line3,
                   DECODE( a.style, 
                           'GB', l.meaning, a.region_1 )  region_1,
                                      a.region_2,         a.region_3, 
                   a.town_or_city,    decode(p_legislative_code,a.country,null,
                                             nvl(t.territory_short_name,a.country)), 
                   a.style,           a.postal_code
              INTO addr_line1,        addr_line2,         addr_line3,
                   addr_region1,      addr_region2,       addr_region3,
                   addr_town_or_city, addr_country,       
                   addr_style,        addr_postal_code
              FROM n_hr_lookups_vl           l, 
                   noetix_fnd_territories_vl t, 
                   per_addresses_s           a
             WHERE a.address_id         = p_address_id
               AND t.territory_code (+) = a.country
               AND a.region_1           = l.lookup_code (+)
               AND l.lookup_type (+)    = 'GB_COUNTY';    

            --
            IF addr_line1 is not null THEN
               NOETIX_HR_PKG.put_address_line(addr_line1, 
                                              last_addr_line1,  last_addr_line2,
                                              last_addr_line3,  last_addr_line4,
                                              last_addr_line5,  last_addr_line6);
            END IF;
            --
            IF addr_line2 is not null THEN
               NOETIX_HR_PKG.put_address_line(addr_line2, 
                                              last_addr_line1,  last_addr_line2,
                                              last_addr_line3,  last_addr_line4,
                                              last_addr_line5,  last_addr_line6);
            END IF;
            --
            IF addr_line3 is not null THEN
               NOETIX_HR_PKG.put_address_line(addr_line3, 
                                              last_addr_line1,  last_addr_line2,
                                              last_addr_line3,  last_addr_line4,
                                              last_addr_line5,  last_addr_line6);
            END IF;
            --
            IF addr_style = 'US' THEN
               addr_line4 := addr_town_or_city||', '||
                             addr_region2||'  '||
                             addr_postal_code; 
            ELSIF addr_style = 'CA' THEN
               addr_line4 := addr_town_or_city||', '||
                             addr_region1;
               addr_line5 := addr_postal_code;
            ELSE -- addr_style default same as 'GB' --
               addr_line4 := addr_town_or_city;  
               addr_line5 := addr_region1;  
               addr_line6 := addr_postal_code;  
            END IF;
            --
            IF addr_line4 is not null THEN
               NOETIX_HR_PKG.put_address_line(addr_line4, 
                                              last_addr_line1,  last_addr_line2,
                                              last_addr_line3,  last_addr_line4,
                                              last_addr_line5,  last_addr_line6);
            END IF;
            --
            IF addr_line5 is not null THEN
               NOETIX_HR_PKG.put_address_line(addr_line5, 
                                              last_addr_line1,  last_addr_line2,
                                              last_addr_line3,  last_addr_line4,
                                              last_addr_line5,  last_addr_line6);
            END IF;
            --
            IF addr_line6 is not null THEN
               NOETIX_HR_PKG.put_address_line(addr_line6, 
                                              last_addr_line1,  last_addr_line2,
                                              last_addr_line3,  last_addr_line4,
                                              last_addr_line5,  last_addr_line6);
            END IF;
            --
            NOETIX_HR_PKG.put_address_line(addr_country,  
                                           last_addr_line1,  last_addr_line2,
                                           last_addr_line3,  last_addr_line4,
                                           last_addr_line5,  last_addr_line6);
         EXCEPTION when others then 
            return null;
         END;
      END IF;
      --
      IF p_line_number = 1 THEN
         return last_addr_line1;
      ELSIF p_line_number = 2 THEN
         return last_addr_line2;
      ELSIF p_line_number = 3 THEN
         return last_addr_line3;
      ELSIF p_line_number = 4 THEN
         return last_addr_line4;
      ELSIF p_line_number = 5 THEN
         return last_addr_line5;
      ELSIF p_line_number = 6 THEN
         return last_addr_line6;
      ELSE
         return null;
      END IF;
   END create_address_lines; 
   --
   PROCEDURE put_address_line (p_address_line           VARCHAR2, 
                               p_last_addr_line1 IN OUT VARCHAR2,
                               p_last_addr_line2 IN OUT VARCHAR2,
                               p_last_addr_line3 IN OUT VARCHAR2,
                               p_last_addr_line4 IN OUT VARCHAR2,
                               p_last_addr_line5 IN OUT VARCHAR2,
                               p_last_addr_line6 IN OUT VARCHAR2
   ) 
   is
   BEGIN
      IF p_last_addr_line1 is not null THEN
         IF p_last_addr_line2 is not null THEN
            IF p_last_addr_line3 is not null THEN
               IF p_last_addr_line4 is not null THEN
                  IF p_last_addr_line5 is not null THEN
                     p_last_addr_line6 := p_address_line;
                  ELSE
                     p_last_addr_line5 := p_address_line;
                  END IF;
               ELSE
                  p_last_addr_line4 := p_address_line;
               END IF;
            ELSE
               p_last_addr_line3 := p_address_line;
            END IF;
         ELSE
            p_last_addr_line2 := p_address_line;
         END IF;
      ELSE
         p_last_addr_line1 := p_address_line;
      END IF;
   END put_address_line; 
   --
   -- -------------------------------------------------------------------------
   -- ----------------- CREATE SIX LOCATION ADDRESS LINES ---------------------
   -- -------------------------------------------------------------------------
   FUNCTION create_loc_address_lines( p_location_id        INTEGER,
                                      p_line_number        INTEGER,
                                      p_legislative_code   VARCHAR2 ) 
     return VARCHAR2 is
     last_loc_addr_line1    VARCHAR2(200);
     last_loc_addr_line2    VARCHAR2(200);
     last_loc_addr_line3    VARCHAR2(200);
     last_loc_addr_line4    VARCHAR2(200);
     last_loc_addr_line5    VARCHAR2(200);
     last_loc_addr_line6    VARCHAR2(200);
     --
     loc_addr_style         hr_locations_all_s.style%TYPE;           -- VARCHAR2(30);
     loc_addr_line1         hr_locations_all_s.address_line_1%TYPE;  -- VARCHAR2(60);
     loc_addr_line2         hr_locations_all_s.address_line_2%TYPE;  -- VARCHAR2(60);
     loc_addr_line3         hr_locations_all_s.address_line_3%TYPE;  -- VARCHAR2(60);
     loc_addr_line4         VARCHAR2(200);
     loc_addr_line5         VARCHAR2(200);
     loc_addr_line6         VARCHAR2(200);
     loc_addr_town_or_city  hr_locations_all_s.TOWN_OR_CITY%TYPE;    -- VARCHAR2(30);
     loc_addr_region1       hr_locations_all_s.REGION_1%TYPE;        -- VARCHAR2(30);
     loc_addr_region2       hr_locations_all_s.REGION_2%TYPE;        -- VARCHAR2(30);
     loc_addr_region3       hr_locations_all_s.REGION_3%TYPE;        -- VARCHAR2(30);
     loc_addr_postal_code   hr_locations_all_s.POSTAL_CODE%TYPE;     -- VARCHAR2(30);
     loc_addr_country       hr_locations_all_s.COUNTRY%TYPE;         -- VARCHAR2(80);
   BEGIN
      loc_addr_line1 := null;
      loc_addr_line2 := null;
      loc_addr_line3 := null;
      loc_addr_line4 := null;
      loc_addr_line5 := null;
      loc_addr_line6 := null;
      --
      IF p_location_id is null THEN
         return null;
      ELSE
         --
         -- get new location address
         last_loc_addr_line1 := null;
         last_loc_addr_line2 := null;
         last_loc_addr_line3 := null;
         last_loc_addr_line4 := null;
         last_loc_addr_line5 := null;
         last_loc_addr_line6 := null;
         --
         BEGIN
            SELECT a.address_line_1,      a.address_line_2,       a.address_line_3,
                   a.region_1,            a.region_2,             a.region_3, 
                   a.town_or_city,        decode(p_legislative_code,a.country,null,
                                                 nvl(t.territory_short_name,a.country)), 
                   a.style,               a.postal_code
              INTO loc_addr_line1,        loc_addr_line2,      loc_addr_line3,
                   loc_addr_region1,      loc_addr_region2,    loc_addr_region3,
                   loc_addr_town_or_city, loc_addr_country,    
                   loc_addr_style,        loc_addr_postal_code
              FROM noetix_fnd_territories_vl    t, 
                   hr_locations_all_s           a
             WHERE a.location_id = p_location_id
               AND t.territory_code (+) = a.country;
            --
            IF loc_addr_line1 is not null THEN
               NOETIX_HR_PKG.put_loc_address_line(loc_addr_line1,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
            END IF;
            --
            IF loc_addr_line2 is not null THEN
               NOETIX_HR_PKG.put_loc_address_line(loc_addr_line2,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
            END IF;
            --
            IF loc_addr_line3 is not null THEN
               NOETIX_HR_PKG.put_loc_address_line(loc_addr_line3,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
            END IF;
            --
            IF loc_addr_style = 'US' THEN
               loc_addr_line4 := loc_addr_town_or_city||', '||
                             loc_addr_region2||'  '||
                             loc_addr_postal_code; 
            ELSIF loc_addr_style = 'CA' THEN
               loc_addr_line4 := loc_addr_town_or_city||', '||
                             loc_addr_region1;
               loc_addr_line5 := loc_addr_postal_code;
            ELSE -- loc_addr_style default same as 'GB' --
               loc_addr_line4 := loc_addr_town_or_city;  
               loc_addr_line5 := loc_addr_region1;  
               loc_addr_line6 := loc_addr_postal_code;  
            END IF;
            --
            IF loc_addr_line4 is not null THEN
               NOETIX_HR_PKG.put_loc_address_line(loc_addr_line4,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
            END IF;
            --
            IF loc_addr_line5 is not null THEN
               NOETIX_HR_PKG.put_loc_address_line(loc_addr_line5,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
            END IF;
            --
            IF loc_addr_line6 is not null THEN
               NOETIX_HR_PKG.put_loc_address_line(loc_addr_line6,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
            END IF;
            --
            NOETIX_HR_PKG.put_loc_address_line(loc_addr_country,
                                                  last_loc_addr_line1, last_loc_addr_line2,
                                                  last_loc_addr_line3, last_loc_addr_line4,
                                                  last_loc_addr_line5, last_loc_addr_line6);
         EXCEPTION when others then 
            return null;
         END;
      END IF;
      --
      IF p_line_number = 1 THEN
         return last_loc_addr_line1;
      ELSIF p_line_number = 2 THEN
         return last_loc_addr_line2;
      ELSIF p_line_number = 3 THEN
         return last_loc_addr_line3;
      ELSIF p_line_number = 4 THEN
         return last_loc_addr_line4;
      ELSIF p_line_number = 5 THEN
         return last_loc_addr_line5;
      ELSIF p_line_number = 6 THEN
         return last_loc_addr_line6;
      ELSE
         return null;
      END IF;
   END create_loc_address_lines; 
   --
   PROCEDURE put_loc_address_line (p_loc_address_line    IN     VARCHAR2,
                                   p_last_loc_addr_line1 IN OUT VARCHAR2,
                                   p_last_loc_addr_line2 IN OUT VARCHAR2,
                                   p_last_loc_addr_line3 IN OUT VARCHAR2,
                                   p_last_loc_addr_line4 IN OUT VARCHAR2,
                                   p_last_loc_addr_line5 IN OUT VARCHAR2,
                                   p_last_loc_addr_line6 IN OUT VARCHAR2
   ) 
   is
   BEGIN
      IF p_last_loc_addr_line1 is not null THEN
         IF p_last_loc_addr_line2 is not null THEN
            IF p_last_loc_addr_line3 is not null THEN
               IF p_last_loc_addr_line4 is not null THEN
                  IF p_last_loc_addr_line5 is not null THEN
                     p_last_loc_addr_line6 := p_loc_address_line;
                  ELSE
                     p_last_loc_addr_line5 := p_loc_address_line;
                  END IF;
               ELSE
                  p_last_loc_addr_line4 := p_loc_address_line;
               END IF;
            ELSE
               p_last_loc_addr_line3 := p_loc_address_line;
            END IF;
         ELSE
            p_last_loc_addr_line2 := p_loc_address_line;
         END IF;
      ELSE
         p_last_loc_addr_line1 := p_loc_address_line;
      END IF;
   END put_loc_address_line; 
-- ---------------------------------------------------------------------------
-- -------------- CREATE REQUIREMENT SI CRITERIA SEGMENT NAME ----------------
-- ---------------------------------------------------------------------------
   FUNCTION determine_si_criteria_name (n_id_flex_code          VARCHAR2,
                                        n_id_flex_num           INTEGER,
                                        n_application_id        INTEGER,
                                        n_analysis_criteria_id  INTEGER)
     return VARCHAR2 is
      v_concat_segment_name varchar2(4000);
      v_segment_name        fnd_id_flex_segments_view.segment_name%TYPE;
      --
      cursor get_segment_name (i_id_flex_code         VARCHAR2, 
                               i_id_flex_num          INTEGER,
                               i_application_id       INTEGER,
                               i_analysis_criteria_id INTEGER)
      is
        select fseg.segment_name
        from   per_analysis_criteria_s   ac,
               fnd_id_flex_segments_view fseg
        where  fseg.id_flex_code    = i_id_flex_code
        and    fseg.id_flex_num     = i_id_flex_num
        and    fseg.application_id  = i_application_id
        and    fseg.id_flex_num     = ac.id_flex_num
        and    ac.analysis_criteria_id = i_analysis_criteria_id
        and  ((fseg.application_column_name = 'SEGMENT1' and
               ac.segment1 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT2' and
               ac.segment2 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT3' and
               ac.segment3 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT4' and
               ac.segment4 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT5' and
               ac.segment5 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT6' and
               ac.segment6 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT7' and
               ac.segment7 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT8' and
               ac.segment8 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT9' and
               ac.segment9 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT10' and
               ac.segment10 IS NOT NULL) or 
              (fseg.application_column_name = 'SEGMENT11' and
               ac.segment11 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT12' and
               ac.segment12 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT13' and
               ac.segment13 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT14' and
               ac.segment14 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT15' and
               ac.segment15 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT16' and
               ac.segment16 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT17' and
               ac.segment17 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT18' and
               ac.segment18 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT19' and
               ac.segment19 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT20' and
               ac.segment20 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT21' and
               ac.segment21 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT22' and
               ac.segment22 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT23' and
               ac.segment23 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT24' and
               ac.segment24 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT25' and
               ac.segment25 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT26' and
               ac.segment26 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT27' and
               ac.segment27 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT28' and
               ac.segment28 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT29' and
               ac.segment29 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT30' and
               ac.segment30 IS NOT NULL))
        order by fseg.segment_num;
   BEGIN
      --
      open get_segment_name(n_id_flex_code,
                            n_id_flex_num,
                            n_application_id,
                            n_analysis_criteria_id);
      loop
         fetch get_segment_name into v_segment_name;
         exit when get_segment_name%notfound;
         if ( lengthb( v_concat_segment_name ) >= 4000 ) then
            exit;
         end if;
         --
         if v_concat_segment_name is null then
            v_concat_segment_name := v_segment_name;
         else
            v_concat_segment_name := substrb(v_concat_segment_name||','||v_segment_name,1,4000);
         end if;
      end loop;
      --
      close get_segment_name;
      return v_concat_segment_name;
   END determine_si_criteria_name; 
   --
-- ---------------------------------------------------------------------------
-- -------------- CREATE REQUIREMENT SI CRITERIA SEGMENT VALUE ---------------
-- ---------------------------------------------------------------------------
   FUNCTION determine_si_criteria_value (v_id_flex_code         VARCHAR2,
                                         v_id_flex_num          INTEGER,
                                         v_application_id       INTEGER,
                                         v_analysis_criteria_id INTEGER)
      return VARCHAR2 
   is
      v_concat_segment_value varchar2(4000);
      v_segment_value        per_analysis_criteria_s.segment1%TYPE;
      --
      cursor get_segment_value ( vi_id_flex_code          VARCHAR2, 
                                 vi_id_flex_num           INTEGER,
                                 vi_application_id        INTEGER,
                                 vi_analysis_criteria_id  INTEGER ) is
        select decode(fseg.application_column_name,
               'SEGMENT1', ac.segment1, 'SEGMENT2', ac.segment2,
               'SEGMENT3', ac.segment3, 'SEGMENT4', ac.segment4,
               'SEGMENT5', ac.segment5, 'SEGMENT6', ac.segment6,
               'SEGMENT7', ac.segment7, 'SEGMENT8', ac.segment8,
               'SEGMENT9', ac.segment9, 'SEGMENT10',ac.segment10,
               'SEGMENT11',ac.segment11,'SEGMENT12',ac.segment12,
               'SEGMENT13',ac.segment13,'SEGMENT14',ac.segment14,
               'SEGMENT15',ac.segment15,'SEGMENT16',ac.segment16,
               'SEGMENT17',ac.segment17,'SEGMENT18',ac.segment18,
               'SEGMENT19',ac.segment19,'SEGMENT20',ac.segment20,
               'SEGMENT21',ac.segment21,'SEGMENT22',ac.segment22,
               'SEGMENT23',ac.segment23,'SEGMENT24',ac.segment24,
               'SEGMENT25',ac.segment25,'SEGMENT26',ac.segment26,
               'SEGMENT27',ac.segment27,'SEGMENT28',ac.segment28,
               'SEGMENT29',ac.segment29,'SEGMENT30',ac.segment30,null)
        from   per_analysis_criteria_s   ac,
               fnd_id_flex_segments_view fseg
        where  fseg.id_flex_code    = vi_id_flex_code
        and    fseg.id_flex_num     = vi_id_flex_num
        and    fseg.application_id  = vi_application_id
        and    fseg.id_flex_num     = ac.id_flex_num
        and    ac.analysis_criteria_id = vi_analysis_criteria_id
        and  ((fseg.application_column_name = 'SEGMENT1' and
               ac.segment1 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT2' and
               ac.segment2 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT3' and
               ac.segment3 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT4' and
               ac.segment4 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT5' and
               ac.segment5 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT6' and
               ac.segment6 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT7' and
               ac.segment7 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT8' and
               ac.segment8 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT9' and
               ac.segment9 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT10' and
               ac.segment10 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT11' and
               ac.segment11 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT12' and
               ac.segment12 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT13' and
               ac.segment13 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT14' and
               ac.segment14 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT15' and
               ac.segment15 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT16' and
               ac.segment16 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT17' and
               ac.segment17 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT18' and
               ac.segment18 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT19' and
               ac.segment19 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT20' and
               ac.segment20 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT21' and
               ac.segment21 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT22' and
               ac.segment22 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT23' and
               ac.segment23 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT24' and
               ac.segment24 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT25' and
               ac.segment25 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT26' and
               ac.segment26 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT27' and
               ac.segment27 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT28' and
               ac.segment28 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT29' and
               ac.segment29 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT30' and
               ac.segment30 IS NOT NULL))
        order by fseg.segment_num;
   BEGIN
      --
      open get_segment_value(v_id_flex_code,
                             v_id_flex_num,
                             v_application_id,
                             v_analysis_criteria_id);
      loop
         fetch get_segment_value into v_segment_value;
         exit when get_segment_value%notfound;
         if ( lengthb( v_concat_segment_value ) >= 4000 ) then
            exit;
         end if;
         --
         if v_concat_segment_value is null then
            v_concat_segment_value := v_segment_value;
         else
            v_concat_segment_value :=
              substrb(v_concat_segment_value||','||v_segment_value,1,4000);
         end if;
      end loop;
      --
      close get_segment_value;
      return v_concat_segment_value;
   END determine_si_criteria_value; 
   --
-- ---------------------------------------------------------------------------
-- -------------- CREATE PERSON'S COMPETENCY SEGMENT VALUE -------------------
-- ---------------------------------------------------------------------------
   FUNCTION determine_pera_criteria_value ( p_id_flex_code VARCHAR2,
                                            p_id_flex_num INTEGER,
                                            p_application_id INTEGER,
                                            p_analysis_criteria_id INTEGER,
                                            p_person_id INTEGER,
                                            p_business_group_id INTEGER )
      return VARCHAR2 is
      p_concat_ac_value           VARCHAR2(4000);
      p_concat_acp_value          VARCHAR2(4000);
      p_concat_all_acp_value      VARCHAR2(4000);
      p_pera_ana_criteria_id      INTEGER;
      p_old_pera_ana_criteria_id  INTEGER       := null;
      p_ac_value                  per_analysis_criteria_s.segment1%TYPE;
      p_acp_value                 per_analysis_criteria_s.segment1%TYPE;
      --
      cursor get_pera_segment_value (pi_id_flex_code         VARCHAR2, 
                                     pi_id_flex_num          INTEGER,
                                     pi_application_id       INTEGER,
                                     pi_analysis_criteria_id INTEGER,
                                     pi_person_id            INTEGER,
                                     pi_business_group_id    INTEGER) is
        select decode(fseg.application_column_name,
               'SEGMENT1', acp.segment1, 'SEGMENT2', acp.segment2,
               'SEGMENT3', acp.segment3, 'SEGMENT4', acp.segment4,
               'SEGMENT5', acp.segment5, 'SEGMENT6', acp.segment6,
               'SEGMENT7', acp.segment7, 'SEGMENT8', acp.segment8,
               'SEGMENT9', acp.segment9, 'SEGMENT10',acp.segment10,
               'SEGMENT11',acp.segment11,'SEGMENT12',acp.segment12,
               'SEGMENT13',acp.segment13,'SEGMENT14',acp.segment14,
               'SEGMENT15',acp.segment15,'SEGMENT16',acp.segment16,
               'SEGMENT17',acp.segment17,'SEGMENT18',acp.segment18,
               'SEGMENT19',acp.segment19,'SEGMENT20',acp.segment20,
               'SEGMENT21',acp.segment21,'SEGMENT22',acp.segment22,
               'SEGMENT23',acp.segment23,'SEGMENT24',acp.segment24,
               'SEGMENT25',acp.segment25,'SEGMENT26',acp.segment26,
               'SEGMENT27',acp.segment27,'SEGMENT28',acp.segment28,
               'SEGMENT29',acp.segment29,'SEGMENT30',acp.segment30,null)
                        competency,
               decode(fseg.application_column_name,
               'SEGMENT1', ac.segment1, 'SEGMENT2', ac.segment2,
               'SEGMENT3', ac.segment3, 'SEGMENT4', ac.segment4,
               'SEGMENT5', ac.segment5, 'SEGMENT6', ac.segment6,
               'SEGMENT7', ac.segment7, 'SEGMENT8', ac.segment8,
               'SEGMENT9', ac.segment9, 'SEGMENT10',ac.segment10,
               'SEGMENT11',ac.segment11,'SEGMENT12',ac.segment12,
               'SEGMENT13',ac.segment13,'SEGMENT14',ac.segment14,
               'SEGMENT15',ac.segment15,'SEGMENT16',ac.segment16,
               'SEGMENT17',ac.segment17,'SEGMENT18',ac.segment18,
               'SEGMENT19',ac.segment19,'SEGMENT20',ac.segment20,
               'SEGMENT21',ac.segment21,'SEGMENT22',ac.segment22,
               'SEGMENT23',ac.segment23,'SEGMENT24',ac.segment24,
               'SEGMENT25',ac.segment25,'SEGMENT26',ac.segment26,
               'SEGMENT27',ac.segment27,'SEGMENT28',ac.segment28,
               'SEGMENT29',ac.segment29,'SEGMENT30',ac.segment30,null)
                        requirement,
                pera.analysis_criteria_id
        from   per_analysis_criteria_s  acp,
               per_analysis_criteria_s  ac,
               per_person_analyses_s    pera,
               fnd_id_flex_segments_view fseg
        where  fseg.id_flex_code        = pi_id_flex_code
        and    fseg.id_flex_num         = pi_id_flex_num
        and    fseg.application_id      = pi_application_id
        and    fseg.id_flex_num         = ac.id_flex_num
        and    ac.analysis_criteria_id  = pi_analysis_criteria_id
        and    acp.analysis_criteria_id = pera.analysis_criteria_id
        and    trunc(sysdate)
               between nvl(pera.date_from, trunc(sysdate))
               and     nvl(pera.date_to, trunc(sysdate))
        and    pera.person_id           = pi_person_id
        and    pera.business_group_id   = pi_business_group_id
        and    fseg.id_flex_num         = acp.id_flex_num
        and  ((fseg.application_column_name = 'SEGMENT1' and
               ac.segment1 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT2' and
               ac.segment2 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT3' and
               ac.segment3 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT4' and
               ac.segment4 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT5' and
               ac.segment5 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT6' and
               ac.segment6 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT7' and
               ac.segment7 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT8' and
               ac.segment8 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT9' and
               ac.segment9 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT10' and
               ac.segment10 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT11' and
               ac.segment11 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT12' and
               ac.segment12 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT13' and
               ac.segment13 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT14' and
               ac.segment14 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT15' and
               ac.segment15 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT16' and
               ac.segment16 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT17' and
               ac.segment17 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT18' and
               ac.segment18 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT19' and
               ac.segment19 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT20' and
               ac.segment20 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT21' and
               ac.segment21 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT22' and
               ac.segment22 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT23' and
               ac.segment23 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT24' and
               ac.segment24 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT25' and
               ac.segment25 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT26' and
               ac.segment26 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT27' and
               ac.segment27 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT28' and
               ac.segment28 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT29' and
               ac.segment29 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT30' and
               ac.segment30 IS NOT NULL))
        order by pera.analysis_criteria_id,fseg.segment_num;
   BEGIN
      --
      open get_pera_segment_value(p_id_flex_code,
                            p_id_flex_num,
                            p_application_id,
                            p_analysis_criteria_id,
                            p_person_id,
                            p_business_group_id);
      loop
         fetch get_pera_segment_value into p_acp_value, p_ac_value,
                                p_pera_ana_criteria_id; 
         exit when get_pera_segment_value%notfound;
         --
         if p_pera_ana_criteria_id != p_old_pera_ana_criteria_id 
                and p_old_pera_ana_criteria_id is not null then
                --
                -- indicates there is an exact match
                if p_concat_acp_value = p_concat_ac_value then
                        p_concat_acp_value := '**'||p_concat_acp_value;
                end if;
                if p_concat_all_acp_value is null then
                  p_concat_all_acp_value := p_concat_acp_value;
                else
                  if ( substrb(p_concat_acp_value,
                             1,instrb(p_concat_acp_value,',',1)) = 
                            substrb(p_concat_ac_value,
                                    1,instrb(p_concat_ac_value,',',1)) OR
                       substrb(p_concat_acp_value,1,2) = '**'          )  THEN
                        p_concat_all_acp_value := 
                                substrb(p_concat_acp_value||';'||p_concat_all_acp_value,1,4000);
                  else
                        p_concat_all_acp_value := 
                                substrb(p_concat_all_acp_value||';'||p_concat_acp_value,1,4000);
                  end if;
                end if;
                p_concat_acp_value := null;
                p_concat_ac_value  := null;
         end if;

         p_old_pera_ana_criteria_id := p_pera_ana_criteria_id;
                
         if p_concat_acp_value is null then
            p_concat_acp_value := p_acp_value;
            p_concat_ac_value  := p_ac_value;
         else
            p_concat_acp_value :=
              substrb(p_concat_acp_value||','||p_acp_value,1,4000);
            p_concat_ac_value :=
              substrb(p_concat_ac_value||','||p_ac_value,1,4000);
         end if;

      end loop;
      --
      close get_pera_segment_value;
      --
      -- indicates there is an exact match
      if p_concat_acp_value = p_concat_ac_value then
          p_concat_acp_value := substrb('**'||p_concat_acp_value,1,4000);
      end if;
      if p_concat_all_acp_value is null then
          p_concat_all_acp_value := p_concat_acp_value;
      else
          if ( substrb(p_concat_acp_value,
                       1,instrb(p_concat_acp_value,',',1)) = 
                    substrb(p_concat_ac_value,
                            1,instrb(p_concat_ac_value,',',1)) OR
               substrb(p_concat_acp_value,1,2) = '**'          )  THEN
              p_concat_all_acp_value := 
                     substrb(p_concat_acp_value||';'||p_concat_all_acp_value,1,4000);
          else
              p_concat_all_acp_value := 
                     substrb(p_concat_all_acp_value||';'||p_concat_acp_value,1,4000);
          end if;
      end if;
      return p_concat_all_acp_value;
   END determine_pera_criteria_value; 
   --
-- ---------------------------------------------------------------------------
-- -------------- CREATE PERSON'S COMPETENCY SEGMENT VALUE -------------------
-- ---------------------------------------------------------------------------
   FUNCTION determine_pera_criteria_rank (p_id_flex_code         VARCHAR2,
                                          p_id_flex_num          INTEGER,
                                          p_application_id       INTEGER,
                                          p_analysis_criteria_id INTEGER,
                                          p_person_id            INTEGER,
                                          p_business_group_id    INTEGER)
     return INTEGER is
      p_concat_ac_value             VARCHAR2(4000);
      p_concat_acp_value            VARCHAR2(4000);
      p_concat_all_acp_value        VARCHAR2(4000);
      p_pera_ana_criteria_id        INTEGER;
      p_old_pera_ana_criteria_id    INTEGER := null;
      p_ac_value                    per_analysis_criteria_s.segment1%TYPE;
      p_acp_value                   per_analysis_criteria_s.segment1%TYPE;
      --
      cursor get_pera_segment_value( pi_id_flex_code         VARCHAR2, 
                                     pi_id_flex_num          INTEGER,
                                     pi_application_id       INTEGER,
                                     pi_analysis_criteria_id INTEGER,
                                     pi_person_id            INTEGER,
                                     pi_business_group_id    INTEGER )
      is
        select decode(fseg.application_column_name,
               'SEGMENT1', acp.segment1, 'SEGMENT2', acp.segment2,
               'SEGMENT3', acp.segment3, 'SEGMENT4', acp.segment4,
               'SEGMENT5', acp.segment5, 'SEGMENT6', acp.segment6,
               'SEGMENT7', acp.segment7, 'SEGMENT8', acp.segment8,
               'SEGMENT9', acp.segment9, 'SEGMENT10',acp.segment10,
               'SEGMENT11',acp.segment11,'SEGMENT12',acp.segment12,
               'SEGMENT13',acp.segment13,'SEGMENT14',acp.segment14,
               'SEGMENT15',acp.segment15,'SEGMENT16',acp.segment16,
               'SEGMENT17',acp.segment17,'SEGMENT18',acp.segment18,
               'SEGMENT19',acp.segment19,'SEGMENT20',acp.segment20,
               'SEGMENT21',acp.segment21,'SEGMENT22',acp.segment22,
               'SEGMENT23',acp.segment23,'SEGMENT24',acp.segment24,
               'SEGMENT25',acp.segment25,'SEGMENT26',acp.segment26,
               'SEGMENT27',acp.segment27,'SEGMENT28',acp.segment28,
               'SEGMENT29',acp.segment29,'SEGMENT30',acp.segment30,null)
                        competency,
               decode(fseg.application_column_name,
               'SEGMENT1', ac.segment1, 'SEGMENT2', ac.segment2,
               'SEGMENT3', ac.segment3, 'SEGMENT4', ac.segment4,
               'SEGMENT5', ac.segment5, 'SEGMENT6', ac.segment6,
               'SEGMENT7', ac.segment7, 'SEGMENT8', ac.segment8,
               'SEGMENT9', ac.segment9, 'SEGMENT10',ac.segment10,
               'SEGMENT11',ac.segment11,'SEGMENT12',ac.segment12,
               'SEGMENT13',ac.segment13,'SEGMENT14',ac.segment14,
               'SEGMENT15',ac.segment15,'SEGMENT16',ac.segment16,
               'SEGMENT17',ac.segment17,'SEGMENT18',ac.segment18,
               'SEGMENT19',ac.segment19,'SEGMENT20',ac.segment20,
               'SEGMENT21',ac.segment21,'SEGMENT22',ac.segment22,
               'SEGMENT23',ac.segment23,'SEGMENT24',ac.segment24,
               'SEGMENT25',ac.segment25,'SEGMENT26',ac.segment26,
               'SEGMENT27',ac.segment27,'SEGMENT28',ac.segment28,
               'SEGMENT29',ac.segment29,'SEGMENT30',ac.segment30,null)
                        requirement,
                pera.analysis_criteria_id
        from   per_analysis_criteria_s   acp,
               per_analysis_criteria_s   ac,
               per_person_analyses_s     pera,
               fnd_id_flex_segments_view    fseg
        where  fseg.id_flex_code         = pi_id_flex_code
        and    fseg.id_flex_num          = pi_id_flex_num
        and    fseg.application_id       = pi_application_id
        and    fseg.id_flex_num          = ac.id_flex_num
        and    ac.analysis_criteria_id   = pi_analysis_criteria_id
        and    acp.analysis_criteria_id  = pera.analysis_criteria_id
        and    trunc(sysdate)
               between nvl(pera.date_from, trunc(sysdate))
               and     nvl(pera.date_to, trunc(sysdate))
        and    pera.person_id            = pi_person_id
        and    pera.business_group_id    = pi_business_group_id
        and    fseg.id_flex_num          = acp.id_flex_num
        and  ((fseg.application_column_name = 'SEGMENT1' and
               ac.segment1 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT2' and
               ac.segment2 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT3' and
               ac.segment3 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT4' and
               ac.segment4 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT5' and
               ac.segment5 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT6' and
               ac.segment6 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT7' and
               ac.segment7 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT8' and
               ac.segment8 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT9' and
               ac.segment9 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT10' and
               ac.segment10 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT11' and
               ac.segment11 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT12' and
               ac.segment12 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT13' and
               ac.segment13 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT14' and
               ac.segment14 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT15' and
               ac.segment15 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT16' and
               ac.segment16 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT17' and
               ac.segment17 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT18' and
               ac.segment18 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT19' and
               ac.segment19 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT20' and
               ac.segment20 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT21' and
               ac.segment21 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT22' and
               ac.segment22 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT23' and
               ac.segment23 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT24' and
               ac.segment24 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT25' and
               ac.segment25 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT26' and
               ac.segment26 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT27' and
               ac.segment27 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT28' and
               ac.segment28 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT29' and
               ac.segment29 IS NOT NULL) or
              (fseg.application_column_name = 'SEGMENT30' and
               ac.segment30 IS NOT NULL))
        order by pera.analysis_criteria_id,fseg.segment_num;
   BEGIN
      --
      open get_pera_segment_value( p_id_flex_code,
                                   p_id_flex_num,
                                   p_application_id,
                                   p_analysis_criteria_id,
                                   p_person_id,
                                   p_business_group_id);
      loop
         fetch get_pera_segment_value 
          into p_acp_value, 
               p_ac_value,
               p_pera_ana_criteria_id; 
         exit when get_pera_segment_value%notfound;
         --
         if p_pera_ana_criteria_id != p_old_pera_ana_criteria_id and 
            p_old_pera_ana_criteria_id is not null               then
            --
            -- indicates there is an exact match
            if p_concat_acp_value = p_concat_ac_value then
               return 1;
            end if;
            p_concat_acp_value := null;
            p_concat_ac_value := null;
         end if;

         p_old_pera_ana_criteria_id := p_pera_ana_criteria_id;
                
         if p_concat_acp_value is null         then
            p_concat_acp_value := p_acp_value;
            p_concat_ac_value  := p_ac_value;
         else
            p_concat_acp_value := substrb(p_concat_acp_value||','||p_acp_value,1,4000);
            p_concat_ac_value  := substrb(p_concat_ac_value||','||p_ac_value,1,4000);
         end if;

      end loop;
      --
      close get_pera_segment_value;
      --
      -- indicates there is an exact match
      if p_concat_acp_value = p_concat_ac_value then
         return 1;
      end if;
      return 0;
   END determine_pera_criteria_rank; 
   --
-- ---------------------------------------------------------------------------
-- ---------------- CREATE CONCATENATED PERSON'S NAME ------------------------
-- ---------------------------------------------------------------------------
   FUNCTION concat_name(p_title VARCHAR2,
                        p_first_name VARCHAR2,
                        p_last_name  VARCHAR2,
                        P_suffix VARCHAR2)
      return VARCHAR2 
   is
      p_concat_name  varchar2(200);
   BEGIN
         select rtrim(decode(p_title,null,null,initcap(p_title)||' ')||
                      decode(p_first_name,null,null,p_first_name||' ')||
                      decode(p_last_name,null,null,p_last_name||' ')||p_suffix)
         into   p_concat_name 
         from dual;
      return p_concat_name;
   END concat_name; 
   --
-- ---------------------------------------------------------------------------
-- ---------------- END_OF_DATE ----------------------------------------------
-- ---------------------------------------------------------------------------
   FUNCTION end_of_time 
     RETURN DATE IS
   BEGIN
     return gc_end_of_time;
   END end_of_time;
    --
-- ---------------------------------------------------------------------------
-- ---------------- GET_USER_PERSON_TYPE -------------------------------------
-- ---------------------------------------------------------------------------
   FUNCTION get_user_person_type  (p_effective_date  DATE,
                                   p_person_id     NUMBER)
     RETURN VARCHAR2 is
    CURSOR csr_person_types(p_effective_date   DATE,
                            p_person_id      NUMBER)  is
    SELECT ttl.user_person_type
      FROM per_person_types_tl_s      ttl,
           per_person_types_s         typ,
           per_person_type_usages_f_s ptu
     WHERE ttl.language = userenv('LANG')
       AND ttl.person_type_id      = typ.person_type_id
       AND typ.system_person_type IN ('APL','EMP','EX_APL','EX_EMP','CWK','EX_CWK','OTHER')
       AND typ.person_type_id      = ptu.person_type_id
       AND p_effective_date 
           BETWEEN ptu.effective_start_date
               AND ptu.effective_end_date
       AND ptu.person_id           = p_person_id
     ORDER BY DECODE(typ.system_person_type
                 ,'EMP'   ,1
                 ,'CWK'   ,2
                 ,'APL'   ,3
                 ,'EX_EMP',4
                 ,'EX_CWK',5
                 ,'EX_APL',6
                          ,7
                 );
    l_user_person_type             VARCHAR2(2000);
    l_separator                    VARCHAR2(10);
    BEGIN
        l_separator := gc_user_person_type_separator;
        FOR l_person_type IN csr_person_types( p_effective_date     => p_effective_date,
                                               p_person_id          => p_person_id ) LOOP
            IF (l_user_person_type IS NULL) THEN
                l_user_person_type := l_person_type.user_person_type;
            ELSE
                l_user_person_type := l_user_person_type || l_separator || l_person_type.user_person_type;
            END IF;
        END LOOP;
    RETURN l_user_person_type;
END get_user_person_type;
   
END noetix_hr_pkg;
/
show errors

CREATE OR REPLACE PACKAGE noetix_hr2_pkg AUTHID DEFINER IS
  --
  FUNCTION get_version
  RETURN varchar2;
  --
  -- get standard hours
  FUNCTION get_standard_hours( p_organization_id    NUMBER,
                               p_business_group_id  NUMBER,
                               p_position_id        NUMBER    DEFAULT NULL )
    RETURN NUMBER;
  --
  -- get standard frequency 
  FUNCTION get_standard_frequency( p_organization_id   NUMBER,
                                   p_business_group_id NUMBER,
                                   p_position_id       NUMBER DEFAULT NULL)
    RETURN VARCHAR2;
  --
  -- get COBRA dependents count
  FUNCTION get_cobra_dependents_count (p_assignment_id         INTEGER,
                                       p_assignment_start_date DATE)
  return integer;
  --
  -- determine COBRA participant flag
  FUNCTION determine_cobra_participant (p_assignment_id         INTEGER,
                                        p_assignment_start_date DATE)
  return VARCHAR2;
  --
  -- determine whether the pay proposal is current
  FUNCTION check_current_proposal (p_pay_proposal_id INTEGER)
  return VARCHAR2;
  --
  -- determine_full_time_salary 
  FUNCTION determine_full_time_salary ( p_business_group_id      NUMBER,
                                        p_actual_rate            NUMBER,
                                        p_normal_hours           NUMBER,
                                        p_frequency              VARCHAR2,
                                        p_standard_hours         NUMBER,
                                        p_standard_frequency     VARCHAR2,
                                        p_pay_basis              VARCHAR2,
                                        p_rate_basis             VARCHAR2,
                                        p_number_per_fiscal_year NUMBER ,
                                        p_annualization_factor   NUMBER DEFAULT NULL,
                                        p_assignment_id          NUMBER DEFAULT NULL )
    RETURN NUMBER;
  --
  FUNCTION standard_hour_adjustment (p_actual_rate      NUMBER,
                                     p_normal_hours     NUMBER,
                                     p_standard_hours   NUMBER)
  return number;
  --
  FUNCTION determine_projected_salary( p_business_group_id       NUMBER,
                                       p_pay_basis               VARCHAR2,
                                       p_rate_basis              VARCHAR2,
                                       p_rate                    NUMBER, 
                                       p_normal_hours            NUMBER,
                                       p_frequency               VARCHAR2,
                                       p_number_per_fiscal_year  NUMBER,
                                       p_annualization_factor    NUMBER DEFAULT NULL )
  RETURN NUMBER;
  --
  FUNCTION comparatio (p_pay_basis              VARCHAR2,
                       p_rate_basis             VARCHAR2,
                       p_mid_value              NUMBER,
                       p_actual_rate            NUMBER, 
                       p_standard_hours         NUMBER,
                       p_normal_hours           NUMBER,
                       p_standard_frequency     VARCHAR2,
                       p_number_per_fiscal_year NUMBER)
  return number;
  --
  -- determine adjusted_service_date
  FUNCTION adjusted_service_date (p_person_id            INTEGER,
                                  p_period_of_service_id INTEGER,
                                  p_service_date_start   DATE) 
  return date;
  --
  -- Get_Noetix_Hourly_Salary is only valid for OA Version 11+
  FUNCTION get_noetix_hourly_salary ( p_assignment_id  IN NUMBER,
                                      p_effective_date IN DATE DEFAULT sysdate) 
  return number;
  --
END noetix_hr2_pkg;
/
show errors
--
CREATE OR REPLACE PACKAGE BODY noetix_hr2_pkg IS
    -- 
    gc_pkg_version        CONSTANT VARCHAR2(30)     := '6.5.1.1566';
    --
    FUNCTION get_version
      RETURN VARCHAR2 IS
    BEGIN
        return gc_pkg_version;
    END get_version;
   -------------------------------------------------------------------------
   -- ------  GET_WORKING_HOURS determine working hours based on position,
   -- ------                    organization or business group
   -------------------------------------------------------------------------
   FUNCTION get_standard_hours( p_organization_id   NUMBER,
                                p_business_group_id NUMBER,
                                p_position_id       NUMBER  DEFAULT NULL  /* from assignment   */ )
    RETURN NUMBER is
     v_working_hours number;
   BEGIN
     IF ( p_position_id IS NOT NULL ) THEN
       SELECT pos.working_hours working_hours
         INTO v_working_hours
         FROM hr_all_positions_f_s pos
        WHERE pos.position_id = p_position_id
          AND trunc(sysdate) 
              BETWEEN pos.effective_start_date
                  AND pos.effective_end_date;
     END IF ;
     --
     IF ( v_working_hours IS NULL) then
         SELECT nvl(orgi.org_information3, bgri.org_information3)
           INTO v_working_hours
           FROM hr_organization_information_s bgri,
                hr_organization_information_s orgi
          WHERE orgi.organization_id (+)         = p_organization_id
            AND orgi.org_information_context (+) = 'Work Day Information'
            AND bgri.organization_id (+)         = p_business_group_id
            AND bgri.org_information_context (+) = 'Work Day Information';
     END IF;
     --
     return(v_working_hours);
   EXCEPTION when others then
     return null;
   END get_standard_hours;
   --
   -------------------------------------------------------------------------
   -- ------  GET_STANDARD_FREQUENCY determine frequency of working hours 
   -- ------  based on organization or business group
   -------------------------------------------------------------------------
   FUNCTION get_standard_frequency( p_organization_id   NUMBER,
                                    p_business_group_id NUMBER,
                                    p_position_id       NUMBER  DEFAULT NULL  /* from assignment   */ )
    RETURN VARCHAR2 is
     v_frequency varchar2(10);
   BEGIN
     v_frequency := null;
     --
     IF ( p_position_id IS NOT NULL ) THEN
       SELECT pos.frequency 
         INTO v_frequency
         FROM hr_all_positions_f_s pos
        WHERE pos.position_id = p_position_id
          AND trunc(sysdate) 
              BETWEEN pos.effective_start_date
                  AND pos.effective_end_date;
     END IF;
     IF ( v_frequency IS NULL ) THEN
       SELECT nvl(orgi.org_information4, bgri.org_information4)
         into v_frequency
         from hr_organization_information_s bgri,
              hr_organization_information_s orgi
        where orgi.organization_id (+)         = p_organization_id
          and orgi.org_information_context (+) = 'Work Day Information'
          and bgri.organization_id (+)         = p_business_group_id
          and bgri.org_information_context (+) = 'Work Day Information';
     END IF;    
     return(v_frequency);
   EXCEPTION when others then
     return null;
   END get_standard_frequency;
   --
   -------------------------------------------------------------------------
   -- ------  GET_COBRA_DEPENDENTS_COUNT count number of dependents under
   -- ------                             COBRA coverage
   -------------------------------------------------------------------------
   FUNCTION get_cobra_dependents_count (p_assignment_id         INTEGER,
                                        p_assignment_start_date DATE)
   RETURN INTEGER IS
     p_cobra_dependents_count INTEGER;
   BEGIN
     SELECT count(cce.contact_relationship_id)
       INTO p_cobra_dependents_count
       FROM per_cobra_coverage_benefits__s ccb,
            per_cobra_cov_enrollments_s    cce
      WHERE p_assignment_start_date = 
            ( SELECT max(asg.effective_start_date)
                FROM per_all_assignments_f_s asg
               WHERE asg.assignment_id = p_assignment_id )
        AND p_assignment_id                  = cce.assignment_id
        AND cce.contact_relationship_id     IS NOT NULL
        AND cce.cobra_coverage_enrollment_id = ccb.cobra_coverage_enrollment_id
        AND ccb.accept_reject_flag           = 'ACC'
        AND trunc(sysdate)
            BETWEEN ccb.effective_start_date 
                AND ccb.effective_end_date
        AND trunc(sysdate)
            BETWEEN nvl(cce.coverage_start_date,trunc(sysdate))
                AND nvl(cce.coverage_end_date,trunc(sysdate));
     --
     RETURN(p_cobra_dependents_count);
   EXCEPTION 
        WHEN OTHERS THEN
            RETURN 0;
   END get_cobra_dependents_count;
   --
   -------------------------------------------------------------------------
   -- ------  DETERMINE_COBRA_PARTICIPANT return a flag indicates whethter the
   -- ------                              employee participate in COBRA 
   -------------------------------------------------------------------------
   FUNCTION determine_cobra_participant( p_assignment_id         INTEGER,
                                         p_assignment_start_date DATE )
     RETURN VARCHAR2 IS
     p_cobra_participant VARCHAR2(1);
   BEGIN
     SELECT 'Y'
       INTO p_cobra_participant
       FROM dual
      WHERE EXISTS
          ( SELECT 'Accepted Cobra Coverage'
              FROM per_cobra_coverage_benefits__s ccb,
                   per_cobra_cov_enrollments_s   cce
             WHERE p_assignment_start_date = 
                 ( SELECT max(asg.effective_start_date)
                     FROM per_all_assignments_f_s   asg
                    WHERE asg.assignment_id         = p_assignment_id )
               AND p_assignment_id                  = cce.assignment_id
               AND cce.cobra_coverage_enrollment_id = ccb.cobra_coverage_enrollment_id
               AND ccb.accept_reject_flag           = 'ACC'
               AND trunc(sysdate)
                   BETWEEN ccb.effective_start_date 
                       AND ccb.effective_end_date
               AND trunc(sysdate)
                   BETWEEN nvl(cce.coverage_start_date,trunc(sysdate))
                       AND nvl(cce.coverage_end_date,trunc(sysdate)));
            --
            RETURN(p_cobra_participant);
   EXCEPTION 
        WHEN OTHERS THEN
            RETURN 'N';
   END determine_cobra_participant;
   --
   -------------------------------------------------------------------------
   -- ------  CHECK_CURRENT_PROPOSAL determine whether the pay proposal is 
   -- ------                         the most current 
   -------------------------------------------------------------------------
   FUNCTION check_current_proposal (p_pay_proposal_id INTEGER)
   return VARCHAR2 is
     p_current_proposal VARCHAR2(1);
   BEGIN
     SELECT 'Y'
     into   p_current_proposal
     from   per_pay_proposals_s ppp
     where  ppp.pay_proposal_id = p_pay_proposal_id 
     and    ppp.change_date = 
           (select max(ppp1.change_date)
            from   per_pay_proposals_s ppp1
            where  ppp1.assignment_id = ppp.assignment_id);
     --
     return(p_current_proposal);
   EXCEPTION when others then
     return 'N';
   END check_current_proposal;
   --
   -------------------------------------------------------------------------
   -- ------  DETERMINE_FULL_TIME_SALARY determine actual salary/rate 
   -- ------  based on rate basis
   -- ------  Note: use get_standard_hours to determine p_standard_hours
   -- ------        use get_standard_frequency to determine p_standard_frequency
   -------------------------------------------------------------------------
   FUNCTION determine_full_time_salary ( p_business_group_id        NUMBER,
                                         p_actual_rate              NUMBER,   /* from pay proposal */
                                         p_normal_hours             NUMBER,   /* from assignment   */
                                         p_frequency                VARCHAR2, /* from assignment   */
                                         p_standard_hours           NUMBER,   /* from get_standard_hours */
                                         p_standard_frequency       VARCHAR2, /* from get_standard_frequency */
                                         p_pay_basis                VARCHAR2, /* from pay basis    */
                                         p_rate_basis               VARCHAR2, /* from pay basis    */
                                         p_number_per_fiscal_year   NUMBER,   /* from pay period type*/
                                         p_annualization_factor     NUMBER DEFAULT NULL, /* from pay basis    */
                                         p_assignment_id            NUMBER DEFAULT NULL    /* from assignment   */     )
    RETURN NUMBER IS
   --
   -- declare variables
   --
   v_standard_hours     NUMBER;
   v_standard_frequency VARCHAR2(10);
   v_normal_hours       NUMBER;
   v_frequency          VARCHAR2(10);
   v_adj_rate           NUMBER; /* adjusted salary/rate based on working hours */
   --
   d_occur_per_year     NUMBER;
   d_occur_per_month    NUMBER;
   m_occur_per_year     NUMBER;
   m_occur_per_month    NUMBER;
   w_occur_per_year     NUMBER;
   w_occur_per_month    NUMBER;
   y_occur_per_year     NUMBER;
   y_occur_per_month    NUMBER;
   ls_fte_profile_value VARCHAR2(240) := &APPS_USERID..xxnao_fnd_wrapper_pkg.VALUE('BEN_CWB_FTE_FACTOR');
   ln_fte_factor        NUMBER        := NULL;
   --
     
     CURSOR lc_csr_fte_bfte IS
     SELECT nvl(value, 1) val
       FROM per_assignment_budget_values_s
      WHERE assignment_id   = p_assignment_id
        AND unit = 'FTE'
        AND trunc(sysdate) BETWEEN effective_start_date AND effective_end_date;
     
     CURSOR lc_csr_fte_bpft IS
     SELECT nvl(value, 1) val
       FROM per_assignment_budget_values_s
      WHERE assignment_id    = p_assignment_id
        AND unit = 'PFT'
        AND trunc(sysdate) BETWEEN effective_start_date AND effective_end_date;  
     --
   BEGIN
     IF (p_rate_basis not in ('ANNUAL','MONTHLY')) or
        (p_frequency is null and p_standard_frequency is null) THEN
        return null;
     END IF;
     --
     IF (p_normal_hours is null) THEN
        v_normal_hours := p_standard_hours;
     ELSE
        v_normal_hours := p_normal_hours;
     END IF;
     --
     IF (p_frequency is null) THEN
        v_frequency := p_standard_frequency;
     ELSE
        v_frequency := p_frequency;
     END IF;

     /* 
     || If organization and business group frequency is null, use the 
     || assignment's frequency as standard frequency, use the full time 
     || hours default from n_hr_work_freq_conv based on assignment's
     || frequency
     */
     --
     IF (p_standard_frequency is not null) THEN
        v_standard_frequency := p_standard_frequency;
        v_standard_hours     := p_standard_hours;
     ELSE
        v_standard_frequency := p_frequency;
        --
        SELECT full_time_hours_per_occurrence
        INTO   v_standard_hours
        FROM   &noetix_user..n_hr_work_freq_conv
        WHERE  p_business_group_id like business_group_id_like
        AND    rownum              = 1
        AND    frequency           = v_standard_frequency;
     END IF;
     --
     BEGIN
         SELECT occurrences_per_year, occurrences_per_month
         INTO   d_occur_per_year, d_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum              = 1
         AND    frequency           = 'D';
         --
         SELECT occurrences_per_year, occurrences_per_month
         INTO   w_occur_per_year, w_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum              = 1
         AND    frequency           = 'W';
         --
         SELECT occurrences_per_year, occurrences_per_month
         INTO   m_occur_per_year, m_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum              = 1
         AND    frequency           = 'M';
         --
         SELECT occurrences_per_year, occurrences_per_month
         INTO   y_occur_per_year, y_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum              = 1
         AND    frequency           = 'Y';
     EXCEPTION 
        when others then 
            return null;
     END;
     --
     /*
     || convert assignment normal hours to correspond to standard frequency
     */
     -- Determine the FTE factor      

     IF (ls_fte_profile_value = 'BFTE') THEN

         OPEN lc_csr_fte_bfte;
        FETCH lc_csr_fte_bfte 
         INTO ln_fte_factor;
        CLOSE lc_csr_fte_bfte;

     ELSIF (ls_fte_profile_value = 'BPFT') THEN

         OPEN lc_csr_fte_bpft;
        FETCH lc_csr_fte_bpft 
         INTO ln_fte_factor;
        CLOSE lc_csr_fte_bpft;

     ELSIF (ls_fte_profile_value = 'NHBGWH') THEN
       IF (v_standard_frequency != v_frequency) THEN
         IF (v_standard_frequency = 'Y') THEN
           IF (v_frequency = 'M') THEN
              v_normal_hours := v_normal_hours * m_occur_per_year;
           ELSIF (v_frequency = 'W') THEN
              v_normal_hours := v_normal_hours * w_occur_per_year;
           ELSIF (v_frequency = 'D') THEN
              v_normal_hours := v_normal_hours * d_occur_per_year;
           END IF;
           --
           IF (v_normal_hours > v_standard_hours) THEN
              v_normal_hours := v_standard_hours;
           END IF;
         ELSIF (v_standard_frequency = 'M') THEN
           IF (v_frequency = 'Y') THEN
              v_normal_hours := v_normal_hours / m_occur_per_year;
           ELSIF (v_frequency = 'W') THEN
              v_normal_hours := v_normal_hours * w_occur_per_month;
           ELSIF (v_frequency = 'D') THEN
              v_normal_hours := v_normal_hours * d_occur_per_month;
           END IF;
           --
           IF (v_normal_hours > v_standard_hours) THEN
              v_normal_hours := v_standard_hours;
           END IF;
         ELSIF (v_standard_frequency = 'W') THEN
           IF (v_frequency = 'Y') THEN
              v_normal_hours := v_normal_hours / w_occur_per_year;
           ELSIF (v_frequency = 'M') THEN
              v_normal_hours := v_normal_hours / w_occur_per_month;
           ELSIF (v_frequency = 'D') THEN
              v_normal_hours := v_normal_hours * 
                                (d_occur_per_year/w_occur_per_year);
           END IF;
           --
           IF (v_normal_hours > v_standard_hours) THEN
              v_normal_hours := v_standard_hours;
           END IF;
         ELSIF (v_standard_frequency = 'D') THEN
           IF (v_frequency = 'Y') THEN
              v_normal_hours := v_normal_hours / d_occur_per_year;
           ELSIF (v_frequency = 'M') THEN
              v_normal_hours := v_normal_hours / d_occur_per_month;
           ELSIF (v_frequency = 'W') THEN
              v_normal_hours := v_normal_hours / 
                                (d_occur_per_year/w_occur_per_year);
           END IF;
           --
           IF (v_normal_hours > v_standard_hours) THEN
              v_normal_hours := v_standard_hours;
           END IF;
         END IF;
       END IF;
       IF (v_normal_hours = 0 or v_standard_hours = 0) THEN     
         ln_fte_factor := 1;       
       ELSE       
         ln_fte_factor := v_normal_hours / v_standard_hours ;       
       END IF;      
     ELSE
       ln_fte_factor := 1;
     END IF;   

     IF NVL(ln_fte_factor,0) = 0 THEN
       ln_fte_factor := 1;
     END IF;
     --
     IF (p_rate_basis = 'ANNUAL') THEN
        IF (p_pay_basis = 'MONTHLY') THEN
           v_adj_rate       := round( p_actual_rate * NVL(p_annualization_factor,1)   * ln_fte_factor, 2);
        ELSIF (p_pay_basis = 'PERIOD') then
           v_adj_rate       := round( p_actual_rate * NVL(p_number_per_fiscal_year,1) * ln_fte_factor, 2);
        ELSIF (p_pay_basis = 'HOURLY') then
           IF (v_standard_frequency = 'D') then
              v_adj_rate    := round( p_actual_rate * d_occur_per_year * v_standard_hours, 2); 
           ELSIF (v_standard_frequency = 'M') then
              v_adj_rate    := round( p_actual_rate * m_occur_per_year * v_standard_hours, 2);
           ELSIF (v_standard_frequency = 'W') then
              v_adj_rate    := round( p_actual_rate * w_occur_per_year * v_standard_hours, 2);
           ELSIF (v_standard_frequency = 'Y') then
              v_adj_rate    := round( p_actual_rate * y_occur_per_year * v_standard_hours, 2);
           END IF;
        ELSIF (p_pay_basis = 'ANNUAL') then
           v_adj_rate       := round(p_actual_rate * (v_standard_hours/v_normal_hours), 2);
        END IF;
     --
     ELSIF (p_rate_basis = 'MONTHLY') then
        IF (p_pay_basis = 'ANNUAL') then
           v_adj_rate   := round((p_actual_rate / m_occur_per_year) * ln_fte_factor, 2);
        ELSIF (p_pay_basis = 'PERIOD') then
           v_adj_rate   := round( p_actual_rate * (p_number_per_fiscal_year / m_occur_per_year) * ln_fte_factor, 2);
        ELSIF (p_pay_basis = 'HOURLY') then
           IF (v_standard_frequency = 'D') then
              v_adj_rate := round( p_actual_rate * d_occur_per_month * v_standard_hours, 2);
           ELSIF (v_standard_frequency = 'M') then
              v_adj_rate := round( p_actual_rate * m_occur_per_month * v_standard_hours, 2);
           ELSIF (v_standard_frequency = 'W') then
              v_adj_rate := round( p_actual_rate * w_occur_per_month * v_standard_hours, 2); 
           ELSIF (v_standard_frequency = 'Y') then
              v_adj_rate := round( p_actual_rate * y_occur_per_month * v_standard_hours, 2);
           END IF;
        ELSIF (p_pay_basis = 'MONTHLY') then
           v_adj_rate   := round( p_actual_rate * ln_fte_factor, 2);
        END IF;
     END IF;
     --
     RETURN v_adj_rate;
   EXCEPTION 
     when zero_divide then
        return null;
   END determine_full_time_salary;
   --
   -- STANDARD_HOUR_ADJUSTMENT this function pro-rates a non-hourly rate
   --                          based on the normal hours worked
   FUNCTION standard_hour_adjustment (p_actual_rate     NUMBER,
                                      p_normal_hours    NUMBER,
                                      p_standard_hours  NUMBER)
   return number
   is
      v_adj_factor      NUMBER(15,5);
      v_adj_value       NUMBER(15,5);
   BEGIN
      v_adj_factor := p_normal_hours/p_standard_hours;
      v_adj_value := p_actual_rate * v_adj_factor;
      --  
      return (v_adj_value);
   END standard_hour_adjustment;
   --
   -- DETERMINE_PROJECTED_SALARY this function calculate the period rate based
   -- on then period rate and rate basis of the value being passed
   --
   FUNCTION determine_projected_salary( p_business_group_id      NUMBER,
                                        p_pay_basis              VARCHAR2,
                                        p_rate_basis             VARCHAR2,
                                        p_rate                   NUMBER, 
                                        p_normal_hours           NUMBER,
                                        p_frequency              VARCHAR2,
                                        p_number_per_fiscal_year NUMBER,
                                        p_annualization_factor   NUMBER DEFAULT NULL /* from pay basis    */ )
    RETURN NUMBER IS
   -- 
   v_adj_rate   NUMBER;
   v_annual     NUMBER;
   v_monthly    NUMBER;
   v_hourly     NUMBER;
   v_period     NUMBER;
   --
   d_occur_per_year     NUMBER;
   d_occur_per_month    NUMBER;
   m_occur_per_year     NUMBER;
   m_occur_per_month    NUMBER;
   w_occur_per_year     NUMBER;
   w_occur_per_month    NUMBER;
   y_occur_per_year     NUMBER;
   y_occur_per_month    NUMBER;
   --
   BEGIN
      if ( p_pay_basis = p_rate_basis ) then
         return p_rate;
      end if;
      -- 
      BEGIN
         SELECT occurrences_per_year, occurrences_per_month
         INTO   d_occur_per_year, d_occur_per_month
         FROM   &NOETIX_USER..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum=1
         AND    frequency = 'D';
         --
         SELECT occurrences_per_year, occurrences_per_month
         INTO   w_occur_per_year, w_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum=1
         AND    frequency = 'W';
         --
         SELECT occurrences_per_year, occurrences_per_month
         INTO   m_occur_per_year, m_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum=1
         AND    frequency = 'M';
         --
         SELECT occurrences_per_year, occurrences_per_month
         INTO   y_occur_per_year, y_occur_per_month
         FROM   &noetix_user..n_hr_work_freq_conv
         WHERE  p_business_group_id like business_group_id_like
         AND    rownum=1
         AND    frequency = 'Y';
      EXCEPTION when others then return null;
      END;
      --
      if (p_rate_basis = 'ANNUAL') then
         if (p_pay_basis = 'MONTHLY') then
            v_annual := p_annualization_factor;
         elsif (p_pay_basis = 'PERIOD') then
            v_annual := p_number_per_fiscal_year;
         elsif (p_pay_basis = 'HOURLY') then
            if (p_frequency = 'D') then
               v_annual := d_occur_per_year * p_normal_hours; 
            elsif (p_frequency = 'M') then
               v_annual := m_occur_per_year * p_normal_hours;
            elsif (p_frequency = 'W') then
               v_annual := w_occur_per_year * p_normal_hours; 
            elsif (p_frequency = 'Y') then
               v_annual := y_occur_per_year * p_normal_hours;
            end if;
         end if;
         v_adj_rate := round(p_rate * v_annual, 2);
      --
      elsif (p_rate_basis = 'MONTHLY') then
         if (p_pay_basis = 'ANNUAL') then
            v_monthly := y_occur_per_month;
         elsif (p_pay_basis = 'PERIOD') then
            v_monthly := p_number_per_fiscal_year / m_occur_per_year;
         elsif (p_pay_basis = 'HOURLY') then
            if (p_frequency = 'D') then
               v_monthly := d_occur_per_month * p_normal_hours;
            elsif (p_frequency = 'M') then
               v_monthly := m_occur_per_month * p_normal_hours;
            elsif (p_frequency = 'W') then
               v_monthly := w_occur_per_month * p_normal_hours; 
            elsif (p_frequency = 'Y') then
               v_monthly := y_occur_per_month * p_normal_hours;
            end if;
         end if;
         v_adj_rate := round(p_rate * v_monthly, 2);
      --
      elsif (p_rate_basis = 'PERIOD') then
         if (p_pay_basis = 'ANNUAL') then
            v_period := y_occur_per_year / p_number_per_fiscal_year;
         elsif (p_pay_basis = 'MONTHLY') then
            v_period := (y_occur_per_year / p_number_per_fiscal_year) 
                       * m_occur_per_year;
         elsif (p_pay_basis = 'HOURLY') then
            if (p_frequency = 'D') then
               v_period := (d_occur_per_year / p_number_per_fiscal_year) 
                          * p_normal_hours;
            elsif (p_frequency = 'M') then
               v_period := (m_occur_per_year / p_number_per_fiscal_year)  
                          * p_normal_hours;
            elsif (p_frequency = 'W') then
               v_period := (w_occur_per_year / p_number_per_fiscal_year) 
                          * p_normal_hours; 
            elsif (p_frequency = 'Y') then
               v_period := (y_occur_per_year / p_number_per_fiscal_year) 
                          * p_normal_hours;
            end if;
         end if;
         v_adj_rate := round(p_rate * v_period, 2);
      --
      elsif (p_rate_basis = 'HOURLY') then
         if (p_pay_basis = 'MONTHLY') then
            if (p_frequency = 'D') then
               v_hourly := d_occur_per_month * p_normal_hours;
            elsif (p_frequency = 'M') then
               v_hourly := m_occur_per_month * p_normal_hours;
            elsif (p_frequency = 'W') then
               v_hourly := w_occur_per_month * p_normal_hours; 
            elsif (p_frequency = 'Y') then
               v_hourly := y_occur_per_month * p_normal_hours;
            end if;
         elsif (p_pay_basis = 'PERIOD') then
            if (p_frequency = 'D') then
               v_hourly := (d_occur_per_year / p_number_per_fiscal_year) 
                          * p_normal_hours;
            elsif (p_frequency = 'M') then
               v_hourly := (m_occur_per_year / p_number_per_fiscal_year) 
                          * p_normal_hours;
            elsif (p_frequency = 'W') then
               v_hourly := (w_occur_per_year / p_number_per_fiscal_year) 
                          * p_normal_hours; 
            elsif (p_frequency = 'Y') then
               v_hourly := (y_occur_per_year / p_number_per_fiscal_year ) 
                          * p_normal_hours;
            end if;
         elsif (p_pay_basis = 'ANNUAL') then
            if (p_frequency = 'D') then
               v_hourly := d_occur_per_year * p_normal_hours; 
            elsif (p_frequency = 'M') then
               v_hourly := m_occur_per_year * p_normal_hours;
            elsif (p_frequency = 'W') then
               v_hourly := w_occur_per_year * p_normal_hours; 
            elsif (p_frequency = 'Y') then
               v_hourly := y_occur_per_year * p_normal_hours;
            end if;
         end if;
         v_adj_rate := round(p_rate / v_hourly, 2);
      --
      end if;
      --
      return v_adj_rate;
   EXCEPTION 
      when zero_divide then
         return null;
   END determine_projected_salary;
   --
   -- COMPARATIO this function calculate the comparatio
   --
   FUNCTION comparatio (p_pay_basis              VARCHAR2,
                        p_rate_basis             VARCHAR2,
                        p_mid_value              NUMBER,
                        p_actual_rate            NUMBER, 
                        p_standard_hours         NUMBER,
                        p_normal_hours           NUMBER,
                        p_standard_frequency     VARCHAR2,
                        p_number_per_fiscal_year NUMBER)
   return NUMBER
   is
   v_adj_mid NUMBER;
   v_comparatio NUMBER;
   --
   BEGIN
      /*
      || pay rate mid range value is defined
      */
      IF (p_mid_value is not null) THEN 
         /*
         || organization standard hour is defined and 
         || assignment standard hour is also defined and
         || the rate is not based on HOURLY then
         || adjust the mid range value 
         */
         IF (p_standard_hours is not null and p_standard_hours != 0) and
            p_normal_hours is not null and
            p_pay_basis != 'HOURLY' and
            p_rate_basis != 'HOURLY' then
            v_adj_mid := standard_hour_adjustment (p_mid_value,
                                                   p_normal_hours,
                                                   p_standard_hours);
         ELSE
            v_adj_mid := p_mid_value;
         END IF;
      ELSE
         return null;
      END IF;
      --
      v_comparatio := round((p_actual_rate/v_adj_mid)*100,2);
      return v_comparatio;
   EXCEPTION 
      when zero_divide then
         return null;
   END comparatio;
   --
   -------------------------------------------------------------------------
   -- ------  ADJUSTED_SERVICE_DATE determine person's adjusted service
   -- ------                        date based on prior service periods
   -------------------------------------------------------------------------
   FUNCTION adjusted_service_date( p_person_id              INTEGER,
                                   p_period_of_service_id   INTEGER,
                                   p_service_date_start     DATE)
     RETURN DATE IS
     p_total_prior_los       NUMBER;
     p_adjusted_service_date DATE;
   BEGIN
     BEGIN
        SELECT nvl(trunc(sum(
               nvl(serv.actual_termination_date,trunc(sysdate)) - serv.date_start)),0)
          INTO p_total_prior_los
          FROM per_periods_of_service_s serv
         WHERE person_id = p_person_id
           AND serv.date_start <= trunc(sysdate)
           AND EXISTS 
             ( SELECT 'Primary Assignments Only'
                 FROM per_all_assignments_f_s asg
                WHERE asg.period_of_service_id  = serv.period_of_service_id
                  AND asg.person_id             = p_person_id
                  AND asg.effective_start_date <= trunc(sysdate)
                  AND asg.assignment_type       = 'E'
                  AND asg.primary_flag          = 'Y'    )
           AND serv.period_of_service_id != p_period_of_service_id;
     EXCEPTION 
        WHEN OTHERS THEN
            p_total_prior_los := 0;
     END;
     --
     p_adjusted_service_date := p_service_date_start - p_total_prior_los;
     RETURN( p_adjusted_service_date );
   END adjusted_service_date;
   --
   -- Get_Noetix_Hourly_Salary is only valid for OA Version 11+
   --
   FUNCTION get_noetix_hourly_salary ( p_assignment_id  IN NUMBER,
                                       p_effective_date IN DATE DEFAULT sysdate) 
     RETURN NUMBER IS
        l_salary number;
   BEGIN
        SELECT ( to_number (EEV.screen_entry_value) *
                       BASES.pay_annualization_factor ) / NHR.full_time_hours_per_occurrence  
          INTO l_salary
          FROM per_all_assignments_f_s        assign,
               per_pay_bases_s                bases,
               pay_element_entries_f_s        ee,
               pay_element_entry_values_f_s   eev,
               n_hr_work_freq_conv            nhr
         WHERE p_effective_date  
               BETWEEN ASSIGN.effective_start_date
                   AND ASSIGN.effective_end_date
           AND NVL(REPLACE(BUSINESS_GROUP_ID_LIKE, '%'),
                           ASSIGN.business_group_id ) = ASSIGN.business_group_id
           AND NHR.frequency                          = 'Y'
           AND ASSIGN.assignment_id                   = p_assignment_id
           AND BASES.pay_basis_id+0                   = ASSIGN.pay_basis_id
           AND EEV.input_value_id                     = BASES.input_value_id
           AND p_effective_date  
               BETWEEN EEV.effective_start_date
                   AND EEV.effective_end_date
           AND EE.entry_type                          = 'E'
           AND EE.assignment_id                       = ASSIGN.assignment_id
           AND p_effective_date  
               BETWEEN EE.effective_start_date
                   AND EE.effective_end_date
           AND EEV.element_entry_id                   = EE.element_entry_id
           AND ASSIGN.assignment_id                   = p_assignment_id ;

        RETURN l_salary ;
   EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
   END get_noetix_hourly_salary;
   --
END noetix_hr2_pkg;
/
show errors

CREATE OR REPLACE PACKAGE noetix_hr3_pkg AUTHID DEFINER is
    -- 
    FUNCTION get_version
      RETURN VARCHAR2;
    --
    -- get dependents count
    FUNCTION get_dependents_count( p_element_entry_id     INTEGER,
                                   p_element_start_date   DATE, 
                                   p_element_end_date     DATE ) 
    return integer;
  --
END noetix_hr3_pkg;
/
--
CREATE OR REPLACE PACKAGE BODY noetix_hr3_pkg IS
    -- 
    gc_pkg_version        CONSTANT VARCHAR2(30)     := '6.5.1.1566';
    --
    FUNCTION get_version
      RETURN VARCHAR2 IS
    BEGIN
        return gc_pkg_version;
    END get_version;
   -------------------------------------------------------------------------
   -------------------------------------------------------------------------
   -- ------  GET_DEPENDENTS_COUNT count number of dependents per person's 
   -- ------                       benefit plan  
   -------------------------------------------------------------------------
   FUNCTION get_dependents_count( p_element_entry_id    INTEGER,
                                  p_element_start_date  DATE,
                                  p_element_end_date    DATE)
     RETURN INTEGER IS
     p_dependents_count integer;
   BEGIN
     SELECT count(d.contact_relationship_id)
       INTO p_dependents_count
       FROM ben_covered_dependents_f_s d
      WHERE d.element_entry_id = p_element_entry_id
        AND d.effective_start_date
            BETWEEN p_element_start_date 
                AND p_element_end_date;
     --
     RETURN(p_dependents_count);
   EXCEPTION 
        WHEN OTHERS THEN
            RETURN 0;
   END get_dependents_count;
   --
END noetix_hr3_pkg;
/
show errors

undefine XXNAO_HRSEC_PRESENT

@utlspoff

-- end ycrhrp.sql
