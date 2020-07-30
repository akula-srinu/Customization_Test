@utlspon PA_USER_PROJECTS_VSAT

CREATE OR REPLACE FORCE VIEW PA_USER_PROJECTS_VSAT
(
   USER_TYPE,
   USER_ID,
   RESOURCE_SOURCE_ID,
   PROJECT_ID
)
AS
   SELECT 'K',
          users.user_id,
          ppp.resource_source_id,
          ppp.project_id
     FROM applsys.fnd_user users, pa.pa_project_parties ppp
    WHERE 1 = 1 AND users.employee_id = ppp.resource_source_id
   UNION
   SELECT 'P',
          b.user_id,
          b.employee_id,
          a.project_id
     FROM pa.pa_projects_all a,
          (SELECT user_id, employee_id
             FROM fnd_user
            WHERE user_name IN
                     (SELECT DISTINCT user_name
                        FROM (SELECT b.user_name,
                                     c.responsibility_name,
                                     a.start_date,
                                     a.end_date
                                FROM apps.fnd_user_resp_groups_direct a,
                                     applsys.fnd_user b,
                                     applsys.fnd_responsibility_tl c
                               WHERE a.user_id = b.user_id
                                     AND a.responsibility_id =
                                            c.responsibility_id
                                     AND UPPER (c.responsibility_name) LIKE
                                            '%VSAT%PROJ%') user_resp,
                             (SELECT SUBSTR (pro1.user_profile_option_name,
                                             1,
                                             35)
                                        profile,
                                     DECODE (pov.level_id,
                                             10001, 'Site',
                                             10002, 'Application',
                                             10003, 'Resp',
                                             10004, 'User')
                                        option_level,
                                     DECODE (
                                        pov.level_id,
                                        10001, 'Site',
                                        10002, appl.application_short_name,
                                        10003, resp.responsibility_name,
                                        10004, u.user_name)
                                        level_value,
                                     NVL (pov.profile_option_value,
                                          'Is Null')
                                        profile_option_value
                                FROM applsys.fnd_profile_option_values pov,
                                     applsys.fnd_responsibility_tl resp,
                                     applsys.fnd_application appl,
                                     applsys.fnd_user u,
                                     applsys.fnd_profile_options pro,
                                     applsys.fnd_profile_options_tl pro1
                               WHERE pro.profile_option_name =
                                        pro1.profile_option_name
                                     AND pro.profile_option_id =
                                            pov.profile_option_id
                                     AND UPPER (
                                            SUBSTR (
                                               pro1.user_profile_option_name,
                                               1,
                                               35)) LIKE
                                            '%CROSS PROJECT USER%'
                                     AND pov.level_id = 10003
                                     AND pov.level_value =
                                            resp.responsibility_id(+)
                                     AND pov.level_value =
                                            appl.application_id(+)
                                     AND pov.level_value = u.user_id(+)) prof_value
                       WHERE user_resp.responsibility_name =
                                prof_value.level_value
                             AND profile_option_value = 'Y')) b;

@utlspoff