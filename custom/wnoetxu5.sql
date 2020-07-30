-- *******************************************************************************
-- FileName:             wnoetxu5.sql
--
-- Date Created:         2019/Aug/28 06:12:40
-- Created By:           nemuser
--
-- Source:
-- - Package:            Package_2018_P11_B1_DEV_NEW
-- - Environment:        EBSPJD1
-- - NoetixViews Schema: NOETIX_VIEWS
--
-- Versions:
-- - Oracle EBS:   12.1.3
-- - Oracle DB:    11.2.0
-- - NoetixViews:  6.5.1
--
-- *******************************************************************************

WHENEVER OSERROR EXIT 902;

WHENEVER SQLERROR EXIT 902;

@wnoetxu5_prerequisite.sql

WHENEVER SQLERROR EXIT 902;

@wnoetxu5_legacy.sql

WHENEVER OSERROR EXIT 902;


WHENEVER OSERROR CONTINUE;

WHENEVER SQLERROR CONTINUE;

