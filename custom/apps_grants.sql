-- Title
--    apps_grants.sql
-- Function
--    Providing the grants access on EBS tables to  Noetix Schema.
-- Description
--    This script provides grants on EBS tables to the Noetix Schema during the 
--    views regeneration process. This is a custom script created for ViaSat while
--    working on the views regeneration automation process.
--
-- History
--     28-Jan-2019 Srinivas  created

@utlspon apps_grants

GRANT SELECT ON CSD_REPAIR_HISTORY TO NOETIX_VIEWS WITH GRANT OPTION;

grant execute on vsat_hr_utils to noetix_views with grant option;

grant execute on vsat_po_utils to noetix_views with grant option;

grant execute on vsat_ame_utils to noetix_views with grant option;

grant execute on vsat_oke_utils to noetix_views with grant option;

GRANT SELECT ON AP_SUPPLIER_SITES_ALL_A TO NOETIX_VIEWS WITH GRANT OPTION;

grant execute on vsat_inv_utils to noetix_views with grant option;

grant execute on vsat_inv_reports to noetix_views with grant option;

--grant select on VSCON.VSAT_RL_UPS_SHIP_ERRORS to NOETIX_VIEWS with grant option; 

--grant select on VSCON.VSAT_REVLOG_SYSTEM_FILE_STATUS to NOETIX_VIEWS with grant option; 

@utlspoff