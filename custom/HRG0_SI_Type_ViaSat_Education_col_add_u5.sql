-- File Name: HRG0_SI_Type_ViaSat_Education_col_add_u5.sql
--
-- Date Created: 17-05-2017
--
-- Purpose: Addition of Columns to the HRG0_SI_Type_ViaSat_Education view .
--
-- Requested By: Viasat.
--
-- Versions:
-- - Oracle EBS:R12
-- - Oracle DB:
-- - NoetixViews:6.5.2
--
-- Change History:
-- ===============
-- Date         Who            Comments
-- -----------  -------------  ---------
-- 01-06-2018     Srinivas    Created. 

-- This file is called from wnoetxu5.sql

-- ****************************************************************************

-- output to .lst file

@utlspon HRG0_SI_TYPE_VIASAT_Education_col_add_u5

INSERT INTO N_VIEW_COLUMNS (COLUMN_ID,
                                         T_COLUMN_ID,
                                         VIEW_NAME,
                                         VIEW_LABEL,
                                         QUERY_POSITION,
                                         COLUMN_NAME,
                                         COLUMN_LABEL,
                                         COLUMN_EXPRESSION,
                                         COLUMN_POSITION,
                                         COLUMN_TYPE,
                                         GROUP_BY_FLAG,
                                         APPLICATION_INSTANCE,
                                         GEN_SEARCH_BY_COL_FLAG,
                                         SOURCE_COLUMN_ID,
                                         GENERATED_FLAG)
     VALUES (
               '',
               '',
               'HRG0_SI_Type_ViaSat_Education',
               'HR_SI_Type',
               1,
               'Employee_Education',
               'Employee_Education',
               'noetix_vsat_utility_pkg.get_employee_education (peo.employee_number)',
               99.9,
               'EXPR',
               'N',
               'G0',
               'N',
               '',
               'N');

commit;

@utlspoff