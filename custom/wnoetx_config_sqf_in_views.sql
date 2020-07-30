-- Title
--    wnoetx_config_sqf_in_views.sql
-- Function
--    Perform customer update sql processes
--    will be custom for each update release
--
-- Description
--    Do nothing for this release
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   28-Jan-14 D Glancy   New.
--                        (Issue 34059).-- 

whenever sqlerror continue
whenever oserror  continue
@utlspon wnoetx_config_sqf_in_views

DECLARE
BEGIN
    NULL;
    -- EXAMPLE -- Enable SQF for the AP_Bank_Accounts Views label.  The WITH statement for AP%_OU_ACL_Map_Base views will be included in the WITH clause line.
    --            This example will enable this option for all view instances (i_instance_type = SXG), with no filter and the materialize hint is not included.
    -- ENABLE_SQF_FOR_VIEW( i_view_label               => 'AP_Bank_Accounts', 
    --                      i_base_view_label          => 'AP_OU_ACL_Map_Base', 
    --                      i_sqf_alias                => 'xmap_sqf2',
    --                      i_instance_type            => 'SXG',
    --                      i_filter                   => '', 
    --                      i_materialize_hint_flag    => 'N' );

    -- EXAMPLE -- Disable SQF for the AP_Bank_Accounts Views label.  The WITH statement for AP%_OU_ACL_Map_Base views will NOT be included in the WITH clause line.
    -- DISABLE_SQF_FOR_VIEW( i_view_label              => 'AP_Bank_Accounts', 
    --                       i_base_view_label          => 'AP_OU_ACL_Map_Base', 
    --                       i_instance_type            => 'SXG' );

    -- <<<ADD NEW CODE HERE >>>

END;
/


spool off
whenever sqlerror continue
whenever oserror  continue

-- end wnoetx_config_sqf_in_views.sql

