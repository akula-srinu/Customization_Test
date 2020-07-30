-- Title
--    org.sql
--    %W% %E% %U%
-- Function
--    @(#) Add the organizations and sets of books to n_application_owners
-- Description
--    Put the Organization_id, set_of_books_id,chart_of_accounts_id
--    into the n_application_owners table.
--    Create new application instances for extra sets of books (GL)
--    or organizations (INV,BOM,CST,WIP,MRP,CRP)
--    Populate the n_application_xref table with the dependencies between
--      the applications. 
--    For each AP user,
--      use worgap.sql to look in the financials_system_parameters table
--      for the organization id and set_of_books_Id
--      Do this by creating a script from a query on n_application_owners
--      and n_app_to_App. 
--      This script is a series of calls to worgapp.sql.
--    For each PO user,
--      look to the corresponding AP user to find the org id, set of books id
--      This assumes that the AP user exists. This means, at least, that the
--      table n_application_owners has an AP entry, that the
--      AP owner owns the financials_system_parameters table, and that
--      fnd_product_dependencies links PO and AP.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--       Aug-94 M Turner
--    06-Dec-94 M Turner     added population of the n_application_xref table
--    13-Mar-94 M Turner     broke the setting of organization and set_of_books
--                           names into two separate scripts org_ap and orgsobap
--                           so that it will get set of books even if no org.
--    07-Apr-95 D Cowles     add support for GL - call wsobgl for each GL instance
--    09-Apr-95 D Cowles     add support for MFG applications
--    11-Apr-95 D Cowles     add support for RA in Release 10
--    11-May-95 D Cowles     add xref for RA and AR in Release 10
--    11-May-95 D Cowles     Insert relationships between INV (child orgs) 
--                           and other apps linked to a master org)
--    20-May-95 D Cowles     fix child apps to only happen when Release 10
--    31-May-95 D Cowles     only look inv and mfg orgs when module installed 
--    06-Jun-95 D Cowles     only get app stuff when app is noetix base or shared
--    14-Jul-95 D Cowles     fix problem with dup rows in xref insert during
--                           insert for reciprocal xrefs
--    21-Aug-95 D Cowles     worgap will only run if AP Y or INV S or Y
--    04-Oct-95 M Turner     relaxed need for ORG and SOB to match to make
--                           n_application_xref, except for INV and GL
--                           BEWARE: This might not work when new apps added.
--    13-Oct-95 D Cowles     make BOM and WIP conform to above change as well
--    15-Oct-95 D Cowles     make ENG and MRP conform to above change as well
--    23-Mar-96 M Turner     fix call to worgmfg to work for BOM, WIP, MRP
--                           as well as INV.
--                           reorganize. Change how child orgs treated.
--    13-May-96 M Turner     centralized dependency on org_organization_definitions
--                           into the worgsob.sql program.
--    2?-Jun-96 R Bull       add wsobfa for Fixed Assets.
--    03-Jul-96 M Turner     fix wsobfa to only work when fa is installed
--    31-Jul-96 M Turner     do not xref to inv cross-org application instance
--    30-Aug-96 D Cowles     add multi-org stuff
--    18-Sep-96 M Turner     fill out cross-org stuff
--    01-Oct-96 M Turner     do not do cross-org for rel9
--    18-Nov-96 M Turner     call worgmfg with mfg_parameters_owner to fix CST orgs
--    18-Dec-96 M Turner     call wsobpa to set up Oracle Projects (PA,PB,PC)
--    06-Feb-97 T Norbra     limit cross-org questions to when INV as base app
--    06-Mar-97 M Kaminer    added confirmation of entries at prompt for x-org.
--    14-May-97 D Cowles, R Kompella, Waiyee make compatible with 10.7
--                           and multi_org_flag instead of ak_partitioned_tables
--    17-May-97 D Cowles     fix confirmation of entries at prompt for x-org.
--    18-May-97 D Cowles     make multi_org_flag checking simpler
--    24-May-97 W Bonneau    make worgapx and worgarx for v10.7+ version where
--                           MULTI_ORG_FLAG = 'N'
--    14-Jun-97 M Turner     Do CRP owner. Do it just like MRP.
--    15-Jul-97 H Schmedding creaed worgpa7.sql and worgpam for v10.7+
--    01-Dec-97 H Schmedding Changed the call to worgap (in the AR section)
--                           to worgar.
--    01-Dec-97 H Schmedding Added the code...
--                           dependency_direction = 'APP REQUIRES REF' 
--                           to the worgmfg call for a2a and a2amrp.
--    01-Dec-97 H Schmedding Fixed the OE section to call worgoe7.sql for
--                           multi-org installations that are 10.6 (with patch)
--                           or higher.  The worgoe7 script uses the ORG_ID
--                           profile option that is not available in earlier
--                           releases.
--    01-Dec-97 H Schmedding Fixed the PA select statement so it doesn't   
--                           return records for pre 10.6 versions.
--    03-Dec-97 H Schmedding (1.26) Really fixed the PA select statement 
--                           this time!
--    25-Apr-98 D Cowles     Add HR xref
--    04-May-98 D Cowles     fix worgap was missing @ for release 9
--    07-Jul-98 R Padilla    Using new variable to determine which worghr
--                           script to call.
--    11-Aug-98 R Padilla    Added support for Rel 11 in multiple queries.
--                           See RHP. Adding '11%' to criteria.
--    02-AUG-98 S Kuhn       Added reference to HR_ALL_ORGANIZATION_UNITS
--                           (R11) used in calling worgup*. Added reference
--                           to an R11 version of worgupd1 called worgup11
--    25-Aug-98 C Lee        Added support for global views.  Now calls xorg.sql
--                           to create global application instances
--    07-Apr-99 D Glancy     Merge X-Op code with the release 11 baseline.
--    15-Apr-99 D Glancy     Updated the if clause.  Added base application 
--                           check.
--    16-Apr-99 D Glancy     Moved the call to xorg.  Application was hanging at
--                           the point it existed.
--    26-Apr-99 H Schmedding Modified the call to xorg so it now includes both
--                           10.7% and 11.% versions.  
--    27-Apr-99 H Schmedding Modified the xorg section. Changed it from a call
--                           to utlif to spool to mkxorg.sql and then run it.
--                           (This was necessary because we had reached the
--                           character limit on parameters to utlif.)
--    27-Apr-99 H Schmedding Moved the entire Cross-Org/Cross-Op section down
--                           so that it runs after mksobupd.sql.  This was 
--                           necessary because xorg was requiring sob to be
--                           populated...and it had not yet been populated 
--                           because mksobupd.sql had not yet executed.
--    27-Apr-99 H Schmedding Modified the mfg xref section.  The xop code had
--                           eliminated all G% instances from this query.  I
--                           modified it to allow Global INV instances to be
--                           the ap reference and not the refap reference.
--    14-Jun-99 D Glancy     Change XOP instance indicator from GX to X.
--    28-Jun-99 M Potluri    Moved the entire Cross-Op section down so that it 
--                           runs after n_application_xref populated, we use    
--                           this table in XOP section. 
--    01-Jul-99 R Kompella   Added AP to the list, while inserting into xref 
--                           for the relationships between apps with child orgs.
--    21-Jul-99 H Schmedding Expanded the SQL which calls worgupd, worgupd1
--                           and worgup11 to make the call for records where
--                           the org_id is not null and the org_name is null.
--                           We were forgetting to populate org_name for the
--                           PA, PB, PC modules.
--    10-Aug-99 D Glancy     Save the user selected flags for global inventories 
--                           in the n_view_parameters table.  Also, print out 
--                           the selections in the org.lst file.
--    16-Aug-99 D Glancy     Move the XOP prompts prior to the Inventory
--                           prompts.
--    30-Aug-99 H Schmedding At the very end of the file, we were spooling to
--                           mkxorg.sql and then executing the file. This was
--                           bug left behind by the 8/10 changes. I removed the
--                           spooling command and the command to execute mkxorg.
--    20-Sep-99 R Lowe       Update copyright info.
--    17-Nov-99 H Schmedding Removed "and nvl('&MULTIORG_FLAG','N') = 'Y'" from
--                           the SQL that decides whether or not we prompt for
--                           XOP.  This was a bug since customers might use our
--                           Mfg XOP views even if they are not multi-org.
--    15-Feb-00 H Sumanam    Update Copyright info.
--    21-Jul-00 D Glancy     Now use the PRODUCT_VERSION and FND_VERSION
--                           variables created in tconnect.sql instead of 
--                           redefining it in org.sql.
--    27-Jul-00 R Kompella   fix wsobgl to only work when gl is installed.
--    11-Dec-00 D Glancy     Update copyright info.
--    25-Jul-01 H Schmedding Updated the XREF inserts to link global INV to 
--                           itself instead of the master org instance.
--                           Also, updated comments and replaced XORG with 
--                           XOP and XIORG with Global INV.
--    12-Nov-01 D Glancy     Update copyright info. (Issue #5285)
--    06-May-02 D Glancy     1. Convert substr to substrb.
--                           (Issue #5447)
--    03-Sep-02 H Schmed     Fixed the statements that were updating the 
--                           n_view_parameters table with the answer to the 
--                           INV indiv, INV global and XOP questions. The old
--                           code was not updating correctly. (Issue 7865)
--                           Skip uisxop and uisinv calls if install is
--                           EBSO or running in an automated method and
--                           only update n_view_parameters if the fields
--                           in the table are NULL. (Issue 7992)
--    07-Nov-02 D Glancy     1.  Merge the worghr11.sql and worghr.sql scripts.
--                           Only run this once even if both payroll and HR are present.
--                           2.  Merge the worgupd1.sql and worgup11.sql scripts.
--                           3.  Ensure that Payroll and HR are treated equally.
--    15-Apr-02 R Raghudev   Added a new hook script call for wnoetxur before the call
--                           to xorg.
--    17-Jul-03 D Glancy     Added undefine statements to clean up environment. (Issue #8561)
--    23-Feb-04 D Glancy     Update Copyright Info. (Issue 11982)
--    15-Apr-04 D Glancy     Add support for Benefits Module.  (Issue 4500)
--    27-May-04 D Glancy     1.  Ensure that Benefits and HR cross references 
--                           are treated the same.
--    03-Nov-04 D Glancy     Update Copyright Info. (Issue 13498)
--    15-Mar-05 D Glancy     1.  Add the prompt for the Projects Multi-currency columns.
--                           2.  Add code to determine what the default value for the MC prompt
--                           should be.
--                           (Issue 14065)
--    03-May-05 D Glancy     Prevent the projects multi-currency prompt if the only views 
--                           detected are queryobjects or LOVs.  This method should probably
--                           be replaced in the future when we support multiple special_process_codes.
--                           (Issue 14278)
--    30-Jun-05  D Glancy    Added PA to the check when determining if the Multi-Currency Prompt
--                           is to be displayed.
--                           (Issue 14965)
--    22-Sep-05  D Glancy    Update copyright info. (Issue 15175)
--    10-Oct-05  M Pothuri   Add routines to detect org configuration for IGW and GMS.
--                           (Issue 15417)
--    15-Nov-05 D Glancy     Add support for the new global instance.
--                           (Issue 15240)
--    23-Jan-06 D Glancy     Inventory and XOP prompts are now defaulted to the user's last selection.
--                           (Issue 14069)
--                           NOTE:  TEMP change included to handle the lack of metadata for new global
--                           columns in n_application_owner_templates.  Once metadata and dumptodo changes
--                           are implemented, then we need to remove the temp changes.
--                           (Issue 15240)
--    07-Feb-06 D Glancy     Disable Global for everything but inventory.
--                           (Issue 15240)
--    08-Mar-06 D Glancy     Remove temp code since the view editor is now populating this information.
--                           When inserting the reciprocal relationships, do it for Global also.
--                           (Issue 15240)
--   22-Mar-06 D Glancy      Added some temporary code to allow XREF to be populated as it is in the 5.5 
--                           release for for Global INV.
--                           Once Heidi has completed the gseg code, this temp update can be removed, but 
--                           we may need to revisit this logic.
--                           Need this to ensure the same organizational information is present for
--                           seg and autojoin.  
--                           (Issue 15240)
--   03-Jul-06 H Schmedding  Updated the xref insert statement section to
--                           generate the appropriate global xref records.
--                           Added a section to generate dummy global records
--                           in n_application_owners for apps that are global
--                           allowed but not purchased. (Issue 16475)
--   03-Jul-06 H Schmedding  Removed the code to insert the dummy global records
--                           in n_application_owners - it is handled in orgp.sql
--                           instead. (Issue 16475)
--   09-Oct-06 M Pothuri     Add call to worgopm.sql.
--                           (Issue 16235)
--   10-Oct-06 D Glancy      Add xref records for Opm.
--                           (Issue 16235)
--   12-Oct-06 M Kaku        Added Australia (AU)legislation in Suppress PAY instances associated.(Issue 17005)
--   08-Jan-07 M Kaku        Added UK (UK)legislation in Suppress PAY instances associated.(Issue 17005)
--   22-Jan-07 P Vemuru      Added routines to detect org configuration for Teleservices (CS).
--   02-Jul-07 D Glancy      Add support for 'EAM' module.
--                           (Issue 17727)
--   04-Sep-07 M Nalam       Modified the code to pop up multi currency screen when having 
--                           Project Manufacturing as part of installation 
--                           (Issue 18001)
--   28-Sep-07 D Glancy      Add Support for the fact that LEDGER_NAME/_ID has 
--                           replaced SET_OF_BOOKS_NAME/_ID.
--                           (Issue 18282)
--   17-Oct-07 Dwarak        Added call to worgpjm.sql 
--                           (Issue 18001).
--   18-Oct-07 D Glancy      worgpam.sql is obsolete and no longer necessary.  Deleted.
--   23-Oct-07 D Glancy      Add support for 'PJM' and 'MSC'.
--                           (Issue 18001)
--   19-Nov-07 P Vemuru      Added 'worgmsc' script call if application label is 'MSC' (Issue 5357)
--   01-Feb-08 D Glancy      Allow for the xop and INV prompts to work in an EBSO environment.
--                           (Issue 14077)
--   27-Feb-08 P Vemuru      Call worgmsc script only if record is available in MSC_Parameters table 
--                           (Issue - 19087)
--   04-Jun-08 D Glancy      Remove the "select distinct" in favor with "Group By".  Think this may help
--                           with the problems we have with seg as not all columns are being inserted correctly.
--                           (Issue - 19418)
--   14-jul-08 Haripriya     Add support for QA module.
--                           (Issue - 20398)
--   01-Aug-08  Kranthi      Added the FV SOB script call for Federal
--                           Modified the n_application_xref single instance insert by adding FV
--                           Add support for Quality Module.
--                           (Issue 20564 and 20395)
--   22-Jan-08 D Glancy      Add support for HXC (OTL).
--                           (Issue 21430)
--   28-Jan-08 D Glancy      Deprecating worgupd.sql as this script is never called now.  Caught 
--                           This as part of the changes for the specified issue.
--                           (Issue 21236)
--   09-Feb-09 D Glancy      Change in design for global security.  We are now going to reference metadata
--                           generated views out of xxnao (XXNAO_ACL_<APPL>_<ORG>_MAP_BASE.
--                           (Issue 21378)
--   17-Mar-09 J Makkapati   Script changes handle opm organization related changes for R12
--                           (Issue 21104)
--   28-Jan-09 D Glancy      Move the definition of n_hr_operating_units_vl and n_org_organizations_vl to ycrhrorgv.sql  This aids in the 
--                           validation that the OU is defined in the hr tables.
--                           (Issue 21326)
--   29-Aug-09 H Potnuru     In a MOAC environment, the org lookups for AR and OE (and PJM for that matter) will not work.
--                           Updated these routines to support MOAC only environments and brought them upd to date.
--                           Rolled up worgoe.sql, worgoe7.sql, and worgoem.sql into worgoe.sql.
--                           Rolled up worgar.sql and worgar7.sql into worgar.sql.
--                           (Issue 22506)
--   02-Dec-09 D Glancy      Added extra flag to worgoe.sql, worgap.sql, and worgar.sql.  This informs these scripts if they are performed from
--                           preupd.sql or not.
--                           (Issue 23042)
--   15-Jan-10 D Glancy      Prevent xref from getting inserted (global -> standard module xref) if there is more than one
--                           standard instance for the target modules.  This should prevent any future problems with this insert
--                           statement.
--                           (Issue 23230)
--   21-Apr-10 D Glancy      Add the new INSTALL_GLOBAL and INSTALL_STANDARD options.
--                           (Issue 23684)
--   05-Ap2011 kkondaveeti  Add support for OKE.
--   04-Aug-10 D Glancy      Added the new project multi-currency question to the gui stage 4 initial wizard.
--                           (Issue 24384)
--   19-Oct-10 R Vattikonda  Invoking worgoks to support advance security for OKS.
--                           (Issue 25418)
--   19-Nov-10 R Vattikonda  Invoking worgcsi to support advance security for CSI.
--                           (Issue 25739)
--   01-Mar-11 V Krishna     Added the update statement to populate the legal_entity into n_application_owners.
--                           (Issue 20034)
--   22-Jun-11 D Glancy      Treat XXHIE as global like XXKFF.
--   02-Mar-12 P Vemuru      Modified  N_APPLICATION_XREF insert statement for OPM modules as part of 26595 bug
--   19-Nov-12 Srinivas      add support for XLA
--   25-Apr-13 D Glancy      Added the ability to set dbms_output.enable to unlimited for 10.2+ databases.  
--   29-Oct-13 D Glancy      EBS 12.2 support.
--                           (Issue 33617)
--   21-Nov-13 D Glancy      Use the %_parameters_s synonym instead of the tables for worgmsc and worgmfg.
--                           
--
whenever sqlerror continue
set feedback off
set echo     off
set verify   off
--
define MSC_USERID='MSC'
column c_msc_userid new_value msc_userid noprint
select mfg.owner_name    c_msc_userid
  from n_application_owners mfg
 where mfg.application_label = 'MSC'
   and rownum                = 1
;

define MSC_PARAMETERS_POPLULATED='N'
column c_msc_parameters_poplulated new_value msc_parameters_poplulated noprint
select 'Y'    c_msc_parameters_poplulated
  from dual
 where exists
     ( SELECT 'Table is Populated and exists' 
         FROM MSC_PARAMETERS_S 
        WHERE rownum = 1 )
;

column multi_org_flag new_value MULTIORG_FLAG noprint
select multi_org_flag multi_org_flag
  from fnd_product_groups_v  fpg
 where fpg.release_name = 
           ( select max(release_name)
               from fnd_product_groups_v fpg2
              where fpg2.product_group_id = 1 )
   and fpg.product_group_id = 1
;

--
column org_id_profile new_value ORG_ID_PROFILE 
select case count(*)
         when 0 then 'N'
         else        'Y'
       end              org_id_profile
  from fnd_profile_options_s
 where profile_option_name = 'ORG_ID'
;
--

whenever sqlerror exit 92

@utlspsql 132 mkorg
prompt prompt &AUTOMATION_METHOD
prompt prompt &NOETIX_SYS_PROPERTY
prompt prompt --;
prompt prompt Create the N_ORG_ORGANIZATIONS_VL and N_HR_OPERATION_UNIT_VL views.
prompt start ycrhrorgv
--
prompt prompt Determine &GL_ORG_NAMING_PLURAL belonging to GL Instances
--
select '@wsobgl ' || gl.owner_name
  from n_application_owners   gl
 where gl.application_label = 'GL'
   and gl.install_status   in ('I','S')
   and gl.base_application in ('Y','S')
;

--
prompt prompt Determine &GL_ORG_NAMING_PLURAL belonging to FA Instances
--
select distinct '@wsobfa ' || fa.owner_name
  from n_application_owners   fa
 where fa.application_label = 'FA'
   and fa.install_status   in ('I','S')
   and fa.base_application in ('Y','S')
   and exists 
       ( select 'defining application exists and owns the defining table'
           from all_objects tab
          where tab.object_name = 'FA_BOOK_CONTROLS'
            and tab.owner       = fa.owner_name)
;

--
prompt prompt Determine &GL_ORG_NAMING_PLURAL belonging to FV Instances
--
select distinct '@wsobfv ' || fv.owner_name
  from n_application_owners   fv
 where fv.application_label = 'FV'
   and fv.install_status   in ('I','S')
   and fv.base_application in ('Y','S')
   and exists 
       ( select 'defining application exists and owns the defining table'
           from all_objects tab
          where tab.object_name = 'FV_OPERATING_UNITS_ALL'
            and tab.owner       = fv.owner_name)
;
--
prompt prompt Determine Operating Units and &GL_ORG_NAMING_PLURAL belonging to CS Instances
--
select distinct 
       '@worgcs '||
       cs.owner_name||' '||
       cs2hr.owner_name
  from n_application_owners cs,
       n_app_to_app         cs2hr
 where cs.base_application        in ('Y','S')
   and cs.application_label        = 'CS'
   and cs2hr.ref_application_label = cs.application_label
   and cs2hr.ref_owner_name        = cs.owner_name
   and cs2hr.application_label     = 'HR'
   and &PRODUCT_VERSION            >= 11.5
;

--
--
prompt prompt Determine &GL_ORG_NAMING_PLURAL belonging to GMS Instances
--
select distinct 
       '@worggms '||
       gms.owner_name||' '||
       gms2hr.owner_name
  from n_application_owners gms,
       n_app_to_app         gms2hr
 where gms.base_application        in ('Y','S')
   and gms.application_label        = 'GMS'
   and gms2hr.ref_application_label = gms.application_label
   and gms2hr.ref_owner_name        = gms.owner_name 
   and gms2hr.application_label     = 'HR'
   and &PRODUCT_VERSION            >= 11.5
;
--
--
prompt prompt Determine &GL_ORG_NAMING_PLURAL and Business Groups belonging to IGW Instances
--
select distinct 
       '@worgigw '||
       igw.owner_name||' '||
       igw2hr.owner_name
  from n_application_owners igw,
       n_app_to_app         igw2hr
 where igw.base_application        in ('Y','S')
   and igw.application_label        = 'IGW'
   and igw2hr.ref_application_label = igw.application_label
   and igw2hr.ref_owner_name        = igw.owner_name 
   and igw2hr.application_label     = 'HR'
   and &PRODUCT_VERSION            >= 11.5
;

--
-- (Multnomah issue 16235)
prompt prompt Determine OPM organizations
--
select distinct '@worgopm '
  from n_application_owners gma
 where gma.application_label  = 'GMA'
   and gma.base_application  in ('Y','S')
   and rownum                 = 1
   and &PRODUCT_VERSION      >= 11.5
;

--
--
prompt prompt Determine Set of Books and Operating Units belonging to PJM Instances
--
select distinct '@worgpjm '||
       pjm.owner_name||' '||
       pjm2pa.owner_name||' '||
       pjm2hr.owner_name
  from n_application_owners pjm,
       n_app_to_app         pjm2pa,
       n_app_to_app         pjm2hr
 where pjm.base_application        in ('Y','S')
   and pjm.application_label        = 'PJM'
   and pjm2pa.ref_application_label = pjm.application_label
   and pjm2pa.ref_owner_name        = pjm.owner_name 
   and pjm2pa.application_label     = 'PA'
   and pjm2hr.ref_application_label = pjm.application_label
   and pjm2hr.ref_owner_name        = pjm.owner_name 
   and pjm2hr.application_label     = 'HR'
   and &PRODUCT_VERSION            >= 11.5
;

prompt prompt Determine Organization_id and Set of Books ID belonging to OKE Instances
--
select decode( '&FND_VERSION',
               '9', NULL,
               decode( &PRODUCT_VERSION,
                       10.6, '@worgokem ',
                       '@worgoke7 ')       ||pa2oke.owner_name||' '||pa.owner_name) 
  from n_application_owners      pa,
       n_application_owners      oke,
       n_app_to_app              pa2oke
 where pa.base_application in ('Y','S')
   and pa.application_label = 'PA'
   and pa2oke.ref_application_label      = pa.application_label
   and pa2oke.ref_owner_name             = pa.owner_name
   and pa2oke.dependency_direction        ='APP REQUIRES REF'
   and pa2oke.application_label           = 'OKE'
   and pa2oke.ref_application_label       = oke.application_label
   and pa2oke.ref_owner_name              = oke.owner_name
   and &PRODUCT_VERSION                 >= 10.6
/

--
prompt prompt Determine Organizations belonging to INV, BOM, CST, WIP, MRP, CRP, EAM, QA Instances
--
--## Exclude MSC application from this list as it is not truely Inventory related.
select distinct '@worgmfg '|| 
       mfg.owner_name||' '||
       mfg.application_label||' '|| 
       ( case 
           when mfg.application_label in ( 'CST', 'EAM', 'INV', 'QA' ) then
               'MTL_PARAMETERS_S'
           when mfg.application_label in ( 'CRP', 'MRP' ) then
               'MRP_PARAMETERS_S'
           when mfg.application_label  = 'WIP' then
               'WIP_PARAMETERS_S'
           when mfg.application_label  = 'BOM' then
               'BOM_PARAMETERS_S'
         end )                                       a
  from n_app_to_app         a2a,
       n_app_to_app         a2amrp,
       n_application_owners mfg
 where mfg.application_label       in ( 'BOM', 'CRP', 'CST', 'EAM', 'INV', 'MRP', 'QA', 'WIP' )
   and a2a.application_label       (+) = mfg.application_label
   and a2a.application_instance    (+) = mfg.application_instance
   and a2a.dependency_direction    (+) = 'APP REQUIRES REF'
   and a2a.ref_application_label   (+) = 'INV'
   and a2amrp.application_label    (+) = mfg.application_label
   and a2amrp.application_instance (+) = mfg.application_instance
   and a2amrp.dependency_direction (+) = 'APP REQUIRES REF'
   and a2amrp.ref_application_label(+) = 'MRP'
   and exists 
       ( select 'defining table exists and owns the defining table'
           from all_objects tab
          where tab.object_name = 
                           ( case 
                               when mfg.application_label in ( 'CST', 'EAM', 'INV', 'QA' ) then
                                   'MTL_PARAMETERS'
                               when mfg.application_label in ( 'CRP', 'MRP' ) then
                                   'MRP_PARAMETERS'
                               when mfg.application_label  = 'WIP' then
                                   'WIP_PARAMETERS'
                               when mfg.application_label  = 'BOM' then
                                   'BOM_PARAMETERS'
                             end )                    
            and tab.owner = 
                           ( case 
                               when mfg.application_label in ( 'BOM', 'INV', 'MRP', 'WIP' ) then
                                   mfg.owner_name
                               when mfg.application_label in ( 'CST', 'EAM', 'QA' ) then
                                   a2a.ref_owner_name
                               when mfg.application_label  = 'CRP' then
                                   a2amrp.ref_owner_name
                               else
                                   mfg.owner_name
                             end ) )
   and mfg.install_status      in ('I','S')
   and mfg.base_application    in ('Y','S')
;
--
prompt prompt Change install status as S if no record in MSC_PARAMETERS table
--
update n_application_owners mfg
   set install_status   = 'S'
 where mfg.application_label        = 'MSC'
   and '&MSC_PARAMETERS_POPLULATED' = 'N'
;
--
prompt prompt Determine Organizations belonging to MSC Source Instances
--
select distinct '@worgmsc '||
       mfg.owner_name||' '||
       mfg.application_label||' '||
       'MSC_PARAMETERS_S'       a
  from n_application_owners mfg
 where mfg.application_label        = 'MSC'
   and '&MSC_PARAMETERS_POPLULATED' = 'Y'
   and mfg.install_status          in ('I','S')
   and mfg.base_application        in ('Y','S')
   and &PRODUCT_VERSION            >= 11.5
   and rownum                       = 1
;
--
prompt prompt Determine Organization_ID and &GL_ORG_NAMING_COLUMN._ID belonging to AP Instances
--
select '@worgap '||
       ap.owner_name||' '||
       po.owner_name||
       ' N'
  from n_application_owners      po,
       n_app_to_app              a2apo,
       n_application_owners      ap
 where ap.base_application in ('Y','S')
   and ap.application_label = 'AP'
   and a2apo.ref_application_label       = ap.application_label
   and a2apo.ref_owner_name              = ap.owner_name
   and a2apo.dependency_direction        ='APP REQUIRES REF'
   and a2apo.application_label           = 'PO'
   and a2apo.application_label           = po.application_label
   and a2apo.owner_name                  = po.owner_name
   and &PRODUCT_VERSION                 >= 10.7
;
--
prompt prompt Determine Organization_ID and &GL_ORG_NAMING_COLUMN._ID belonging to PA Instances
--
select '@worgpa '||pa.owner_name 
  from n_application_owners      pa,
       n_app_to_app              pa2pb,
       n_application_owners      pb,
       n_app_to_app              pa2pc,
       n_application_owners      pc
 where pa.base_application in ('Y','S')
   and pa.application_label = 'PA'
   and pa2pb.ref_application_label       = pa.application_label
   and pa2pb.ref_owner_name              = pa.owner_name
   and pa2pb.dependency_direction        ='APP REQUIRES REF'
   and pa2pb.application_label           = 'PB'
   and pa2pb.application_label           = pb.application_label
   and pa2pb.owner_name                  = pb.owner_name
   and pa2pc.ref_application_label       = pa.application_label
   and pa2pc.ref_owner_name              = pa.owner_name
   and pa2pc.dependency_direction        ='APP REQUIRES REF'
   and pa2pc.application_label           = 'PC'
   and pa2pc.application_label           = pc.application_label
   and pa2pc.owner_name                  = pc.owner_name
   and &PRODUCT_VERSION                 >= 10.7
;
--
prompt prompt Now update organization_id and name for applications that use the
prompt prompt profile option 'SO_ORGANIZATION_ID' (like OE, RA, AR, OKS, CSI)
--
select distinct
       '@worgoe '                   ||
       oe.application_label         ||' '||
       oe.application_instance      ||' '||
       oe.application_id            ||' '||
       oe.owner_name                ||' '||
       oe2hr.ref_owner_name         ||' N '
  from n_app_to_app              oe2hr,
       n_application_owners      oe
 where oe.application_label          = 'OE'
   and oe.base_application          in ('Y','S')
   and oe2hr.owner_name              = oe.owner_name
   and oe2hr.application_label       = oe.application_label
   and oe2hr.dependency_direction    = 'APP REQUIRES REF'
   and oe2hr.ref_application_label  IN  ( 'HR', 'PAY' )
;
--
select distinct
       '@worgoks '               ||
       ar.application_label      ||' '||
       ar.application_instance   ||' '||
       ar.application_id         ||' '||
       ar.owner_name             ||' '||
       ar2hr.ref_owner_name      ||' N '
  from n_app_to_app              ar2hr,
       n_application_owners      ar
 where ar.application_label         in ('OKS')
   and ar.base_application          in ('Y','S')
   and ar2hr.owner_name              = ar.owner_name
   and ar2hr.application_label       = ar.application_label
   and ar2hr.dependency_direction    = 'APP REQUIRES REF'
   and ar2hr.ref_application_label  IN ('HR','PAY');
--
select distinct
       '@worgar '               ||
       ar.application_label     ||' '||
       ar.application_instance  ||' '||
       ar.application_id        ||' '||
       ar.owner_name            ||' '||
       ar2hr.ref_owner_name     ||' N '
  from n_app_to_app              ar2hr,
       n_application_owners      ar
 where ar.application_label         in ('RA','AR')
   and ar.base_application          in ('Y','S')
   and ar2hr.owner_name              = ar.owner_name
   and ar2hr.application_label       = ar.application_label
   and ar2hr.dependency_direction    = 'APP REQUIRES REF'
   and ar2hr.ref_application_label  IN ('HR','PAY')
;
--
select distinct
       '@worgcsi '               ||
       ar.application_label      ||' '||
       ar.application_instance   ||' '||
       ar.application_id         ||' '||
       ar.owner_name             ||' '||
       ar2hr.ref_owner_name      ||' N '
  from n_app_to_app              ar2hr,
       n_application_owners      ar
 where ar.application_label         in ('CSI')
   and ar.base_application          in ('Y','S')
   and ar2hr.owner_name              = ar.owner_name
   and ar2hr.application_label       = ar.application_label
   and ar2hr.dependency_direction    = 'APP REQUIRES REF'
   and ar2hr.ref_application_label  IN ('HR','PAY');
--
spool off
@utlstart mkorg continue
--
prompt PO user, get organization_id and set_of_books_id from AP
--
update  n_application_owners po
   set ( organization_id,
         organization_name,
         set_of_books_id,
         set_of_books_name,
         chart_of_accounts_id ) = 
       ( select organization_id,
                organization_name,
                set_of_books_id,
                set_of_books_name,
                chart_of_accounts_id
           from n_application_owners ap,
                n_app_to_app         a2a
          where a2a.application_label    = po.application_label
            and a2a.owner_name           = po.owner_name
            and a2a.ref_application_label='AP'
            and a2a.dependency_direction ='APP REQUIRES REF'
            and ap.application_label     = a2a.ref_application_label
            and ap.owner_name            = a2a.ref_owner_name
        )
 where application_label          = 'PO'
   and nvl('&MULTIORG_FLAG','N')  = 'N'
;

-- ##########################################################################
-- Allow for Site specific tweaks to organization_id or owners
--
@wnoetxu7
--
--  Now update organization name and org name for application instances 
--      missing it may also update set_of_books_id

@utlspsql 132 mkorgupd 

--
-- For Release 10+ with multi-orgs, the ORG_ORGANIZATION_DEFINITIONS view
-- may not be owned by the INV application.  In that case, use the HR tables
-- that underlie this view. Since this only calls worgupd1 when the 
-- organization_name was not filled in by the call to worgupd above, there
-- will be no conflict. This call sets Organization_Name, Org_Name and 
-- SET_OF_BOOKS_ID if they were not previously populated..
--
select distinct 
       '@worgupd1 '||
       app.application_label||' '||
       app.application_instance||' '|| 
       a2a.ref_owner_name
  from n_app_to_app            a2a, 
       n_application_owners    app
 where ((    app.organization_id         is not null
   and       app.organization_name       is null)
         or (app.org_id                  is not null
   and       app.org_name                is null))
   and app.application_label not in ('MSC')  --Issue 5357 - Not applicable for MSC
   and a2a.owner_name                = app.owner_name
   and a2a.application_label         = app.application_label
   and a2a.dependency_direction      = 'APP REQUIRES REF'
   and a2a.ref_application_label    IN ( 'HR', 'PAY' )
   and exists 
     ( select 'HR application is installed'
         from n_application_owners  inv
        where inv.owner_name           = a2a.ref_owner_name
          and inv.application_label    = a2a.ref_application_label
          and inv.base_application    in ('Y','S') )
   and exists 
     ( select 'HR owns HR_ORGANIZATION_UNITS/HR_ALL_ORGANIZATION_UNITS'
         from all_objects tab1
        where tab1.object_name IN
              ('HR_ORGANIZATION_UNITS', 'HR_ALL_ORGANIZATION_UNITS')
          and tab1.owner               = a2a.ref_owner_name)
;
--
-- Add instances for each HR Business Group
--
-- NOTE:  We only want this to run once.  However, it might be possible
--        that a PAYROLL only install would not include this update.
--        For that reason, we look for both Payroll and HR, but only 
--        use one of them.  To run it individually for PAYROLL
--
select '@worghr ' || app.owner_name 
  from n_application_owners    app
 where app.application_label  = 'HR'
   and app.base_application  in ( 'Y','S' )
   and &PRODUCT_VERSION       > 10.4
   and rownum = 1
 union
select '@worghr ' || app.owner_name 
  from n_application_owners    app
 where app.application_label   = 'HR'
   and &PRODUCT_VERSION       >= 11.5
   and exists
     ( select 'Benefits/PAY exists ' 
         from n_application_owners    app1
        where app.application_label  in ( 'BEN', 'HXC', 'PAY' )
           and app.base_application  in ( 'Y','S' )
           and &PRODUCT_VERSION      >= 11.5
           and rownum = 1                         )
   and rownum = 1
 order by 1
;

-- look up the master_organization_id and cost_organization_id if they exist
--
select '@worgmast '||app.application_label||' '||app.application_instance
        ||' '|| a2a.ref_owner_name
  from n_app_to_app            a2a, 
       n_application_owners    app
 where app.organization_id      is not null
   and app.master_organization_id   is null
   and app.application_label not in ('MSC')      --Issue 5357 - Not applicable for MSC
   and a2a.owner_name                = app.owner_name
   and a2a.application_label         = app.application_label
   and a2a.ref_application_label     = 'INV'
   and a2a.dependency_direction      ='APP REQUIRES REF'
   and exists 
       ( select 'Inventory application is installed'
           from n_application_owners  inv
          where inv.owner_name        = a2a.ref_owner_name
            and inv.application_label = a2a.ref_application_label
            and inv.base_application in ('Y','S') )
   and exists 
       ( select 'inventory user defines master org, cost org'
           from all_tab_columns tab1
          where tab1.table_name       = 'MTL_PARAMETERS'
            and tab1.column_name      = 'MASTER_ORGANIZATION_ID'
            and tab1.owner            = a2a.ref_owner_name)
;
spool off
--
@utlstart mkorgupd continue

--
-- Allow for Site specific tweaks to owners or Sets of Books/Ledger
--
@wnoetxu8
--
--  Now update set of books name for application instances missing it
--
@utlspsql 132 mksobupd
--
select '@wsobupd '||app.application_label||' '||app.application_instance
       ||' '|| a2a.ref_owner_name
  from n_app_to_app            a2a, 
       n_application_owners    app
 where app.set_of_books_id        is not null
   and app.set_of_books_name          is null
   and a2a.owner_name                  = app.owner_name
   and a2a.application_label           = app.application_label
   and app.application_instance not like 'X%'   -- Exclude XOP
   and a2a.ref_application_label       = 'GL'
   and a2a.dependency_direction        = 'APP REQUIRES REF'
   and exists 
     ( select 'GL application is installed'
         from n_application_owners   gl
        where gl.application_label = a2a.ref_application_label
          and gl.owner_name        = a2a.ref_owner_name
          and gl.base_application in ('Y','S'))
;

spool off
--
@utlstart mksobupd continue
commit;

--
-- ##########################################################################
-- Do Global Inventory and Cross Operation Extension processing.
--
-- At this point we prompt the user for all of the options.
-- Cross Operation process (If Selected, is processed at the end of org (xorg.sql)
--
-- defaults 
--
-- Global Inventory Defaults
define cross_org_flag               = "N"
-- Global Flag Defaults
define global_instance_enabled      = "N"
define XO_ROLE_PRESENT              = "N"
-- Cross Install View Type Defaults
define create_global_views_flag     = "Y"
define create_cross_op_views_flag   = "Y"
define create_standard_views_flag   = "Y"
define create_all_inv_orgs_flag     = "Y"
-- Projects Multi-Currency Columns Support
define create_projects_mc_cols_flag = "N"
define projects_mc_available        = "N"

column I_XO_ROLE_PRESENT new_value XO_ROLE_PRESENT NOPRINT
select 'Y' I_XO_ROLE_PRESENT
  from dual 
 where exists
     ( select 'XO detected'
         from n_application_owner_templates ap 
        where ap.base_application                = 'Y'
          and NVL(ap.xop_instances_allowed,'N')  = 'Y'
          and NVL(ap.xop_instances_enabled,'N')  = 'Y'
          and &PRODUCT_VERSION                  >= 10.7 );

column I_GLOBAL_INSTANCE_ENABLED new_value GLOBAL_INSTANCE_ENABLED NOPRINT
select 'Y' I_GLOBAL_INSTANCE_ENABLED
  from dual 
 where exists
     ( select 'Global detected'
         from n_application_owner_templates ap 
        where ap.base_application                  = 'Y'
          and NVL(ap.global_instance_allowed,'N')  = 'Y'
          and NVL(ap.global_instance_enabled,'N')  = 'Y'
          and &PRODUCT_VERSION                    >= 10.7 );

-- Get the PA owner
column pa_owner new_value PA_USERID noprint
select distinct owner_name pa_owner
  from n_application_owners
 where application_label = 'PA';
 
 -- Determine if Projects Multi-Currency is available
COLUMN I_PROJECTS_MC_AVAILABLE NEW_VALUE PROJECTS_MC_AVAILABLE NOPRINT
select /*+ RULE */ 'Y' I_PROJECTS_MC_AVAILABLE
  from dual
 where &PRODUCT_VERSION >= 11.5
   -- Project functional currency column exists.  This is our clue that Multi-Currency is installed.
   and exists
     ( SELECT 'Column Exists'
         FROM SYS.ALL_TAB_COLUMNS
        WHERE OWNER       = '&PA_USERID'
          AND TABLE_NAME  = 'PA_PROJECTS_ALL'
          AND COLUMN_NAME = 'PROJFUNC_CURRENCY_CODE'     )
   -- Application exists and installable.
   and exists
     ( select 'Have Projects Application'
         from n_application_owners app
        where app.application_label  in ( 'PA', 'PB', 'PC', 'PJM', 'OKE' )
          and app.base_application   in ( 'Y','S' )
          and app.install_status     in ( 'I','S' )
          and rownum                  = 1     )
   -- PA/PB/PC views present?
   and exists
     ( select 'Will instantiate a projects view'
         from n_view_templates      v,
              n_role_view_templates rv,
              n_role_templates      r
        where rv.role_label            = r.role_label
          and 
            (    rv.VIEW_LABEL LIKE 'PA\\_%' escape '\\'
              OR rv.VIEW_LABEL LIKE 'PB\\_%' escape '\\'
              OR rv.VIEW_LABEL LIKE 'PC\\_%' escape '\\'
              OR rv.VIEW_LABEL LIKE 'PJM\\_%' ESCAPE '\\'
	      OR rv.VIEW_LABEL LIKE 'OKE\\_%' ESCAPE '\\'
            )
          and v.view_label             = rv.view_label
          and NVL(v.include_flag,'N')  = 'Y'
          and NVL(v.special_process_code,
                  'NONE')         NOT IN ('LOV','QUERYOBJECT')
          and rownum                   = 1                         )
;

COLUMN S_CREATE_GLOBAL_VIEWS_FLAG     NEW_VALUE CREATE_GLOBAL_VIEWS_FLAG     NOPRINT
COLUMN S_CREATE_CROSS_OP_VIEWS_FLAG   NEW_VALUE CREATE_CROSS_OP_VIEWS_FLAG   NOPRINT
COLUMN S_CREATE_STANDARD_VIEWS_FLAG   NEW_VALUE CREATE_STANDARD_VIEWS_FLAG   NOPRINT
COLUMN S_CREATE_ALL_INV_ORGS_FLAG     NEW_VALUE CREATE_ALL_INV_ORGS_FLAG     NOPRINT
COLUMN S_CREATE_PROJECTS_MC_COLS_FLAG NEW_VALUE CREATE_PROJECTS_MC_COLS_FLAG NOPRINT
select nvl( create_all_inv_orgs_flag,
            '&CREATE_ALL_INV_ORGS_FLAG' )       S_CREATE_ALL_INV_ORGS_FLAG,
       nvl( create_global_views_flag,
            '&CREATE_GLOBAL_VIEWS_FLAG' )       S_CREATE_GLOBAL_VIEWS_FLAG,
       nvl( create_cross_op_views_flag,
            '&CREATE_CROSS_OP_VIEWS_FLAG' )     S_CREATE_CROSS_OP_VIEWS_FLAG,
       nvl( create_standard_views_flag,
            '&CREATE_STANDARD_VIEWS_FLAG' )     S_CREATE_STANDARD_VIEWS_FLAG,
       nvl( create_projects_mc_cols_flag,
            '&CREATE_PROJECTS_MC_COLS_FLAG' )   S_CREATE_PROJECTS_MC_COLS_FLAG
  from n_view_parameters
 where creation_date = 
     ( select max(creation_date)
         from n_view_parameters
        where install_stage = 4 )
  and install_stage = 4;

whenever sqlerror continue

-- If the CREATE_PROJECTS_MC_COLS_FLAG option was not populated, then get the default from
-- the pa_implemenations_all table.if it wasn't already specified
select 'Y'          S_CREATE_PROJECTS_MC_COLS_FLAG
  from dual
 where '&CREATE_PROJECTS_MC_COLS_FLAG' is null
   and exists
     ( select 'Multi-Currency Flag set to Y'
         from &PA_USERID..pa_implementations_all impl
        where impl.multi_currency_billing_flag = 'Y'
          and rownum                           = 1 )
 union
select 'N'          S_CREATE_PROJECTS_MC_COLS_FLAG
  from dual
 where '&CREATE_PROJECTS_MC_COLS_FLAG' is null
   and not exists
     ( select 'Multi-Currency Flag set to Y'
         from &PA_USERID..pa_implementations_all impl
        where impl.multi_currency_billing_flag = 'Y'
          and rownum                           = 1 )
;

whenever sqlerror exit 92
--
-- Prompt the user for how they want projects multi-currency installed.
-- Only appears if the multi-currency columns exist (11.5.8+) and projects views are going to be installed
start utlif 'uispmc' -
    "('&UI' = 'SQLPLUS' or '&UI' = 'FORMS') and '&PROJECTS_MC_AVAILABLE' = 'Y' and '&AUTOMATION_METHOD' = 'NONE'" 
start utlif 'uigpmc' -
    "'&UI' = 'WINDOWS' and '&PROJECTS_MC_AVAILABLE' = 'Y' and '&AUTOMATION_METHOD' = 'NONE'" 

-- Spool the contents of the org script.

@utlspon org

-- Save the user selected flags for Projects Multi-currency in the n_view_parameters table.
-- If Multi-currency is not available, then set the option to null.  This overwrites
-- any automation requests for these columns if they are not present.
-- NULL will mean that the option is not available.  Should translate to 'N'.
-- Y    means the user wants the columns and the option is available
-- N    means the user did not want multi-cur and the option is available
update n_view_parameters vp
   set vp.create_projects_mc_cols_flag  = ( case '&PROJECTS_MC_AVAILABLE'
                                              when 'Y' then NVL('&CREATE_PROJECTS_MC_COLS_FLAG','N')
                                              else          null 
                                            end )
 where vp.creation_date = 
     ( select max(vp_4.creation_date)
         from n_view_parameters vp_4
        where vp_4.install_stage = 4 )
   and vp.install_stage = 4;

commit;

-- Get the values we stored.
column i_cross_org_flag             new_value cross_org_flag             noprint
column i_create_all_inv_orgs_flag   new_value create_all_inv_orgs_flag   noprint
column i_create_cross_op_views_flag new_value create_cross_op_views_flag noprint
select cross_org_flag               i_cross_org_flag,
       create_all_inv_orgs_flag     i_create_all_inv_orgs_flag,
       create_cross_op_views_flag   i_create_cross_op_views_flag,
       create_projects_mc_cols_flag i_create_projects_mc_cols_flag
  from n_view_parameters
 where creation_date = 
     ( select max(creation_date)
         from n_view_parameters
        where install_stage = 4 )
   and install_stage = 4;

-- Special processing for payroll
-- Suppress PAY instances associated that are not US, Canada and Australia.
update n_application_owners
   set install_status         = 'S',
       install_status_history = install_status_history||'org.sql-1(OLD:I/NEW:S)#'
 where install_status                       = 'I'
   and application_label                    = 'PAY'
   and application_instance          not like 'G%'  -- Exclude Global INV
   and application_instance          not like 'X%'  -- Exclude XOP
   and legislative_code                not in ( 'US', 'CA', 'AU', 'GB' )
;
--
--
set termout &LEVEL1
--
-- Execute procedure found in orgp.sql
--
execute n_org_proc1;
--
-- If we don't want to create roles for each individual INV organization
-- then set these application_instances to shared instead of installed.
--
-- Note the where clause with "not like 'G%'": since both the global inventory
-- organization views (GORG) and the cross operation views (XOP) application
-- instances could have been created at this time, we need to make sure that
-- non-global processing skips these application instance types.  The GORG 
-- application instances start with G%, whereas the XOP application instances
-- start with X%.  So, the possibilities are:
--
-- 1. None of the global instances:             ...not like 'G%'
--                                              ...not like 'X%'
-- 2. Only the global instances (both types):   ...like 'G%' and like 'X%'
-- 3. Only the GORG instances:                  ...like 'G%' not like 'X%'
-- 4. Only the XOP instances:                   ...like 'X%'
--
-- This logic is used through the rest of this script and in other areas of the
-- installer (autojoip,genrpdat,gorg,orgid,popview,etc.)
--
update n_application_owners
   set install_status         = 'S',
       install_status_history = install_status_history||'org.sql-2(OLD:I/NEW:S)#'
 where install_status                       = 'I'
   and application_label                    = 'INV'
   and application_instance          not like 'G%'  -- Exclude Global INV
   and application_instance          not like 'X%'  -- Exclude XOP
   and substrb(upper(nvl('&CREATE_ALL_INV_ORGS_FLAG','Y')),1,1) = 'N'
;
-- 
-- ##########################################################################
--
-- Store the dependencies of the applications
--
--
-- 
-- Show what the user selected if they had to option to generate
-- the global inventory organization.
--
prompt .
prompt User Selections For Inventory Role Configuration: 
prompt .    Create separate role for each inventory org? - &CREATE_ALL_INV_ORGS_FLAG'
prompt .

-- Insert the global/global xref's first, then combo global/single and 
-- finally single/single xrefs. 

-- First, insert global to global xref records. We are not going to require 
-- any dependency records for global xrefs. We are simply joining every 
-- global instance to every other global instance.
insert into n_application_xref (
       application_label,
       application_instance,
       ref_application_label,
       ref_application_instance)
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners     ap,
       n_application_owners     refap 
 where ap.application_instance        like 'G%'
   and refap.application_instance     like 'G%'
   and not exists 
     ( select 'Xref already exists'
         from n_application_xref x
        where x.application_label        = ap.application_label
          and x.application_instance     = ap.application_instance
          and x.ref_application_label    = refap.application_label   )
;
-- Insert the xref relationship between global roles and non-global-able 
-- single roles.

insert into n_application_xref (
       application_label,
       application_instance,
       ref_application_label,
       ref_application_instance)
select ap.application_label,
       ap.application_instance, 
       refap.application_label,
       refap.application_instance
  from n_application_owner_templates refapt,
       n_application_owners     ap,
       n_application_owners     refap 
 where ap.application_instance               like 'G%'
   and refap.application_instance        not like 'G%'
   and refap.application_instance        not like 'X%'
   and refap.application_label                  = refapt.application_label
   and NVL(refapt.global_instance_allowed, 'N') = 'N'
   and 1 = 
     ( select count(*) 
         from n_application_owners ao
        where ao.application_label                     = refap.application_label
          and substr(ao.application_instance,1,1) not in ( 'G','X' )  );

-- Now insert xref for the single instance to other single instances
insert into n_application_xref (
       application_label,
       application_instance,
       ref_application_label,
       ref_application_instance)
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners     ap,
       n_application_owners     refap,
       n_app_to_app             a2a
 where ap.application_label              = a2a.application_label
   and ap.owner_name                     = a2a.owner_name
   and refap.application_label           = a2a.ref_application_label
   and refap.owner_name                  = a2a.ref_owner_name
   and ap.application_instance    not like 'G%' -- Exclude Global
   and refap.application_instance not like 'G%' -- Exclude global
   and refap.application_instance not like 'X%' -- Exclude XOP
   and ap.application_instance    not like 'X%' -- Exclude XOP 
   and a2a.dependency_direction          = 'APP REQUIRES REF'
   and 
     (     nvl(ap.set_of_books_id,-9)   =
                nvl(refap.set_of_books_id,nvl(ap.set_of_books_id,-9))
       or (     ap.application_label    not in ( 'FA', 'FV', 'GL', 'XLA','PA', 'PB', 'PC', 'PJM', 'OKE' )
            and refap.application_label not in ( 'FA', 'FV', 'GL', 'XLA','PA', 'PB', 'PC', 'PJM', 'OKE' )  )
     )
   and 
--## Exclude MSC application from this list as it is not truely Inventory related.
     (    nvl(ap.organization_id,-9)   =
                nvl(refap.organization_id,nvl(ap.organization_id,-9))
       or (     ap.application_label not in 
                        ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP'
                          /*'GMA', 'GMD', 'GME', 'GMF', 'GMI', 'GML', 'GMP'*/ )  /* Commented by PVemuru 26595 */
            and refap.application_label not in 
                        ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP'
                          /*'GMA', 'GMD', 'GME', 'GMF', 'GMI', 'GML', 'GMP'*/ )) /* Commented by PVemuru 26595 */
     )
     --------R12 specific OPM organizations
   and  (  (  nvl(ap.organization_id,-9)   =
                nvl(refap.organization_id,nvl(ap.organization_id,-9))  and &PRODUCT_VERSION >=12 ) 
       or (     ap.application_label not in 
                        ( 'GMA', 'GMD', 'GME', 'GMF', 'GMI', 'GML', 'GMP' )
            and refap.application_label not in 
                        ( 'GMA', 'GMD', 'GME', 'GMF', 'GMI', 'GML', 'GMP' ))
     )
--## Handle MSC application here.
   and
     (    (     nvl(ap.organization_id,-9)      =
                    nvl(refap.organization_id,nvl(ap.organization_id,-9)) 
            and nvl(ap.source_instance_id,-9)   =
                    nvl(refap.source_instance_id,nvl(ap.source_instance_id,-9)) )
       or (     ap.application_label    <> 'MSC'
            and refap.application_label <> 'MSC' )
     )
   and nvl(ap.org_id,-9)    =
                nvl(refap.org_id,nvl(ap.org_id,-9))
   and 
     (     nvl(ap.process_orgn_code,'NOT_SET')   =
                nvl(refap.process_orgn_code,nvl(ap.process_orgn_code,'NOT_SET'))
       or (     ap.application_label    not in ( 'GMA', 'GMD', 'GME', 'GMF', 'GMI','GML', 'GMP' )
            and refap.application_label not in ( 'GMA', 'GMD', 'GME', 'GMF', 'GMI','GML', 'GMP' )  )
     )
   and refap.application_label   not in ('OKS', 'CSI')   
   and not exists 
     ( select 'Xref already exists'
         from n_application_xref x
        where x.application_label        = ap.application_label
          and x.application_instance     = ap.application_instance
          and x.ref_application_label    = refap.application_label   )
;
-- The following sections insert the relationships between modules that
-- are not available in app2app. Since all relationships for global were
-- created earlier, global instance can be excluded.
--
-- Insert relationships between AR and RA for Release 10
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners refap,
       n_application_owners ap
       -- RHP 08/11/1998
       -- Added support for Rel 11
 where to_number('&FND_VERSION')        >= 10
   and 
     (    (     ap.application_label     = 'AR'
            and refap.application_label  = 'RA')
       or (     ap.application_label     = 'RA'
            and refap.application_label  = 'AR')    )
   and ap.owner_name                     = refap.owner_name
   and nvl(ap.set_of_books_id,-9)        = 
                    nvl(refap.set_of_books_id,nvl(ap.set_of_books_id,-9))
   and nvl(ap.organization_id,-9)        = 
                    nvl(refap.organization_id,nvl(ap.organization_id,-9))
   and ap.application_instance    not like 'G%' -- Exclude Global
   and refap.application_instance not like 'G%' -- Exclude global
   and ap.application_instance    not like 'X%' -- Exclude XOP
   and refap.application_instance not like 'X%' -- Exclude XOP
   and not exists 
     ( select 'Xref already exists'
         from n_application_xref x
        where x.application_label        = ap.application_label
          and x.application_instance     = ap.application_instance
          and x.ref_application_label    = refap.application_label   )
 group by ap.application_label,
          ap.application_instance,
          refap.application_label,
          refap.application_instance
;
--        and x.ref_application_instance = refap.application_instance);
--
-- Insert relationships between PA, PB, PC, OKE
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners refap,
       n_application_owners ap
       -- RHP 08/11/1998
       -- Added support for Rel 11
 where to_number('&FND_VERSION')        >= 10
   and
     (    (     ap.application_label     = 'PA'
            and refap.application_label IN ( 'PB', 'PC', 'OKE' ) )
       or (     ap.application_label     = 'PB'
            and refap.application_label IN ( 'PA', 'PC', 'OKE' ) )
       or (     ap.application_label     = 'PC'
            and refap.application_label IN ( 'PA', 'PB', 'OKE' ) )
       or (     ap.application_label     = 'OKE'
            and refap.application_label IN ( 'PA', 'PB', 'PC' ) )
     )
   and ap.owner_name                     = refap.owner_name
   and ap.set_of_books_id                = refap.set_of_books_id
   and ap.application_instance    not like 'G%' -- Exclude Global
   and refap.application_instance not like 'G%' -- Exclude global
   and ap.application_instance    not like 'X%'    -- exclude XOP
   and refap.application_instance not like 'X%'    -- exclude XOP
   and not exists 
     ( select 'Xref already exists'
         from n_application_xref x
        where x.application_label     = ap.application_label
          and x.application_instance  = ap.application_instance
          and x.ref_application_label = refap.application_label )
 group by ap.application_label,
          ap.application_instance,
          refap.application_label,
          refap.application_instance
;
--
-- Insert relationships between apps and HR/PAY/BEN
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  from n_application_owners refap,
       n_application_owners ap
 where to_number('&FND_VERSION')        >= 10
   and ap.application_label             != refap.application_label
   and refap.application_label          in ( 'BEN', 'HR', 'HXC', 'PAY' )
   and ap.application_instance    not like 'G%'     -- exclude GLOBAL
   and refap.application_instance not like 'G%'     -- exclude GLOBAL
   and ap.application_instance    not like 'X%'     -- exclude XOP
   and refap.application_instance not like 'X%'     -- exclude XOP
   and not exists 
     ( select 'Xref already exists'
         from n_application_xref x
        where x.application_label     = ap.application_label
          and x.application_instance  = ap.application_instance
          and x.ref_application_label = refap.application_label  )
group by ap.application_label,
         ap.application_instance,
         refap.application_label;

--
-- Make sure the dependencies are reciprocal
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance)
select x.ref_application_label,
       x.ref_application_instance,
       x.application_label,
       min(x.application_instance)
  from n_application_xref x
 where not exists 
     ( select null
         from n_application_xref x2
        where x2.ref_application_label      = x.application_label
       --   and x2.ref_application_instance = x.application_instance
          and x2.application_label          = x.ref_application_label
          and x2.application_instance       = x.ref_application_instance )
   and x.application_instance      not like 'X%' -- Exclude XOP
   and x.application_instance      not like 'G%' -- Exclude Global
 group by x.ref_application_label,
          x.ref_application_instance,
          x.application_label
;

--
commit;

-- Insert relationships between apps with child orgs (like INV) and apps 
-- linked only to master org (like PO, OE, AR, etc...)
-- 
--   This routine creates cross references to all INV and other mfg child 
--   orgs to the app linked to the mfg master organization.       
--   When entering this routine the app is only xref'ed to  
--   the INV master org. If INV unable to link to subledger directly, link
--   the INV instance to master org. subledger instance.
--
insert into n_application_xref
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select child.application_label,                -- BOM, CST, CRP, INV, MRP, QA, WIP
       child.application_instance,
       xref.application_label,                 -- AP, AR, PJM, PO, OE, RA 
       min(xref.application_instance)   
  from n_application_owners    child,
       n_application_owners    mfgapp,
       n_application_xref      xref
       -- RHP 08/11/1998
       -- Added support for Rel 11
 where to_number('&FND_VERSION')    >= 10
   and xref.application_label       in ( 'AR', 'AP', 'PJM', 'PO', 'OE', 'RA' )
   and xref.ref_application_label    = mfgapp.application_label
   and xref.application_instance     not like 'G%'    -- Exclude Global
   and xref.ref_application_instance not like 'G%'    -- Exclude global
   and xref.application_instance     not like 'X%'    -- Exclude XOP
   and xref.ref_application_instance not like 'X%'    -- Exclude XOP
   and xref.ref_application_instance = mfgapp.application_instance
--## Exclude MSC application from this list as it is not truely Inventory related.
   and xref.ref_application_label   in ( 'BOM', 'CRP', 'CST', 'EAM', 'INV', 'MRP', 'QA',  'WIP' )
   and mfgapp.base_application      in ('Y','S')
   and child.application_label       = mfgapp.application_label
   and child.master_organization_id  = mfgapp.organization_id
   and child.master_organization_id != child.organization_id
   and not exists                                            
       (select null from n_application_xref x                        
         where x.ref_application_label    = xref.application_label    
       /*  and x.ref_application_instance = xref.application_instance  */
           and x.application_label        = child.application_label 
           and x.application_instance     = child.application_instance) 
 group by child.application_label,                -- BOM, CST, CRP, INV, MRP, QA, WIP
          child.application_instance,
          xref.application_label
;

commit;

@utlspoff

-- Allow for Site specific tweaks to cross-op
@wnoetxur

--  

--
-- The below XOP script populates n_application_owners and
-- n_application_xref tables for XOP. The script only runs for
-- XOP installations.
 --
-- 15-Apr-99 dglancy
-- Updated the if clause.  Added base application check.
start utlif 'xorg' -
    "'&XO_ROLE_PRESENT' = 'Y' and '&CREATE_CROSS_OP_VIEWS_FLAG' = 'Y'" 

@utlspon org2

set serveroutput on size &MAX_SERVEROUTPUT_SIZE
--
-- Ensure that Single Instances are disabled if their corresponding single_instances_enabled flag is 'N'
-- The reason we put this here is that we need the install_status set to I until XOP and Global processing has
-- completed.
update n_application_owners nao
   set install_status         = 'S',
       install_status_history = install_status_history||'org.sql-3(OLD:I/NEW:S)#'
 where nao.application_label     in
     ( select naot.application_label
         from n_role_templates  r,
              n_application_owner_templates naot
        where nvl(naot.single_instances_enabled,'N') = 'N'
          and r.application_label                    = naot.application_label
        union
       select v.application_label
         from n_application_owner_templates naot,
              n_view_templates              v,
              n_role_view_templates         rv,
              n_role_templates              r
        where rv.role_label                           = r.role_label
          and v.view_label                            = rv.view_label
          and v.application_label                    != r.application_label
          and naot.application_label                  = r.application_label 
          and nvl(naot.single_instances_enabled,'N')  = 'N'
          and not exists
            ( select 'role application exits'
                from n_role_templates  r2
               where r2.application_label = v.application_label
                 and rownum               = 1  )
        group by v.application_label 
     )
   and substrb(nao.application_instance,1,1) 
                             not in ( 'G', 'X' )
   and nao.install_status         = 'I'
;

-- Using the create_global_views_flag, create_cross_op_views_flag,
-- and create_standard_views_flag variables, set the status of the role_enabled_flag and install_status
declare
    
    CURSOR c_nao is 
    -- Legacy global
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_instance      like 'G%'
       and nao.base_application             = 'Y'
       and nao.install_status              != 'N'
       and naot.application_label           = nao.application_label
       and naot.single_instances_allowed    = 'N'
       and naot.single_instances_enabled    = 'N'
       and naot.global_instance_allowed     = 'Y'
       and naot.global_instance_enabled     = 'Y'
     UNION
     -- Standard that can't be global
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_instance  not like 'G%'
       and nao.application_instance  not like 'X%'
       and nao.application_label       NOT IN ( 'XXKFF', 'XXHIE' )
       and nao.base_application             = 'Y'
       and nao.install_status              != 'N'
       and naot.application_label           = nao.application_label
       and naot.single_instances_allowed    = 'Y'
       and naot.single_instances_enabled    = 'Y'
       and naot.global_instance_allowed     = 'N'
       and naot.global_instance_enabled     = 'N'
     UNION
    -- Global and XXKFF/XXHIE
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_label           in ( 'XXKFF', 'XXHIE' )
       and nao.base_application             = 'Y'
       and nao.install_status              != 'N'
       and naot.application_label           = nao.application_label
       and naot.single_instances_allowed    = 'Y'
       and naot.single_instances_enabled    = 'Y'
       and naot.global_instance_allowed     = 'N'
       and naot.global_instance_enabled     = 'N'
       and '&CREATE_GLOBAL_VIEWS_FLAG'      = 'Y'
     UNION
    -- Global
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_instance      like 'G%'
       and nao.base_application             = 'Y'
       and nao.install_status              != 'N'
       and naot.application_label           = nao.application_label
       and naot.single_instances_allowed    = 'Y'
       and naot.single_instances_enabled    = 'Y'
       and naot.global_instance_allowed     = 'Y'
       and naot.global_instance_enabled     = 'Y'
       and '&CREATE_GLOBAL_VIEWS_FLAG'      = 'Y'
     UNION
    -- XOP
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_instance      like 'X%'
       and nao.base_application             = 'Y'
       and nao.install_status              != 'N'
       and naot.application_label           = nao.application_label
       and naot.xop_instances_allowed       = 'Y'
       and naot.xop_instances_enabled       = 'Y'
       and '&CREATE_CROSS_OP_VIEWS_FLAG'    = 'Y'
     UNION
     -- Standard instances not part of an xop
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_instance  not like 'G%'
       and nao.application_instance  not like 'X%'
       and nao.base_application             = 'Y'
       and nao.install_status              != 'N'
       and nao.xop_instance                is NULL
       and naot.application_label           = nao.application_label
       and naot.single_instances_allowed    = 'Y'
       and naot.single_instances_enabled    = 'Y'
       and naot.xop_instances_allowed       = 'Y'
       and naot.xop_instances_enabled       = 'Y'
       and '&CREATE_CROSS_OP_VIEWS_FLAG'    = 'Y'
     UNION 
    select nao.application_label,
           nao.application_instance
      from n_application_owner_templates naot,
           n_application_owners          nao
     where nao.application_instance  not like 'G%'
       and nao.application_instance  not like 'X%'
       and nao.application_label       NOT IN  ( 'XXKFF', 'XXHIE' )
       and nao.install_status              != 'N'
       and nao.base_application             = 'Y'
       and naot.application_label           = nao.application_label
       and naot.single_instances_allowed    = 'Y'
       and naot.single_instances_enabled    = 'Y'
       and '&CREATE_STANDARD_VIEWS_FLAG'    = 'Y'
     order by 1;

    TYPE typ_application_label    IS TABLE of n_application_owners.application_label%TYPE       INDEX BY BINARY_INTEGER;
    TYPE typ_application_instance IS TABLE of n_application_owners.application_instance%TYPE    INDEX BY BINARY_INTEGER;

    lt_application_label    typ_application_label;
    lt_application_instance typ_application_instance;

begin

    IF ( c_nao%ISOPEN ) THEN
        CLOSE c_nao ;
    END IF;
    
     OPEN c_nao;
    FETCH c_nao BULK COLLECT
     INTO lt_application_label,
          lt_application_instance;
    CLOSE c_nao ;

    dbms_output.put_line( 'Determine which role applications will be enabled.' );
    -- Update the role_enabled flag for all that we want to enable.
    IF ( lt_application_label.COUNT  > 0 ) THEN
        FORALL i in 1 .. lt_application_label.COUNT
        UPDATE n_application_owners nao
           SET nao.role_enabled_flag    = 'Y'
         WHERE nao.application_label    = lt_application_label(i)
           AND nao.application_instance = lt_application_instance(i)
           AND nao.base_application     = 'Y'
           AND nao.install_status       = 'I'
           AND nao.role_enabled_flag   is NULL;
        dbms_output.put_line( SQL%ROWCOUNT||' rows updated in n_application_owners for role_enabled_flag.' );
    ELSE
        dbms_output.put_line( '0 rows updated in n_application_owners for role_enabled_flag.' );
    END IF;

    dbms_output.put_line( 'Determine which role applications will be suppressed.' );
    -- Turn off roles that are not to be used.
    UPDATE n_application_owners nao
       SET nao.role_enabled_flag      = 'N',
           nao.install_status         = ( CASE nao.base_application
                                            WHEN 'Y' THEN ( CASE nao.install_status
                                                              WHEN 'I' THEN 'S'
                                                              ELSE nao.install_status
                                                            END )
                                            ELSE nao.install_status
                                          END ),
           nao.install_status_history = ( CASE nao.base_application
                                            WHEN 'Y' THEN ( CASE nao.install_status
                                                              WHEN 'I' THEN nao.install_status_history||'org.sql-4(OLD:I/NEW:S)#'
                                                              ELSE nao.install_status_history
                                                            END )
                                            ELSE nao.install_status_history
                                          END )
     WHERE nao.role_enabled_flag   is NULL;
    dbms_output.put_line( SQL%ROWCOUNT||' rows updated in n_application_owners for role_enabled_flag, install_status, and install_status_history.' );
    
end;
/
-- Update n_application_owners to populate legal_entity_name values.  (#20034)
--

define AP_USERID='AP'
column c_ap_userid new_value ap_userid noprint
select ao.owner_name    c_ap_userid
  from n_application_owners ao
 where ao.application_label  = 'AP'
   and rownum                = 1
;

set serveroutput on size &MAX_SERVEROUTPUT_SIZE
DECLARE
    ls_select_12plus   VARCHAR2(4000) := 
     '( SELECT otl.NAME 
          FROM hr_all_organization_units_s o, 
               hr_all_organization_units_tl_s otl
         WHERE o.organization_id = otl.organization_id(+)
           AND o.organization_id = 
             ( CASE 
                 WHEN application_label IN 
                         (''BOM'',''CRP'',''CST'',''EAM'',''GMA'',''GMD'',''GME'',''GMF'',''GMI'',''GML'',
                          ''GMP'',''INV'',''MRP'',''MSC'',''MSD'',''WIP'')       THEN n.ORGANIZATION_ID
                 WHEN application_label IN 
                         (''AP'',''AR'',''BEN'',''CS'',''GMS'',''HR'',''HXC'',''IGW'',''PA'',''PAY'',
                          ''PB'',''PC'',''PJM'',''RA'',''PO'',''OE'',''ONT'')      THEN n.org_id 
               END ) 
           AND EXISTS 
             ( SELECT 1 
                 FROM hr_organization_information_s o2
                WHERE o2.organization_id         = o.organization_id
                  AND o2.org_information_context = ''CLASS''
                  AND o2.org_information1       IN 
                        (''HR_LEGAL'', ''PAR_ENT'', ''FR_SOCIETE'', ''HR_LEGAL_EMPLOYER'')
                  AND o2.org_information2        = ''Y'' )
           AND otl.LANGUAGE               = USERENV (''LANG'') )';

    ls_select_11_5  VARCHAR2(4000) := 
     '( SELECT otl.NAME 
          FROM hr_all_organization_units_s    o, 
               hr_all_organization_units_tl_s otl,
               hr_organization_information_s  o3
         WHERE o.organization_id                 = o3.organization_id(+)
           AND o.organization_id                 = 
             ( CASE 
                 WHEN application_label         IN 
                         (''BOM'',''CRP'',''CST'',''EAM'',''GMA'',''GMD'',''GME'',''GMF'',''GMI'',''GML'',
                          ''GMP'',''INV'',''MRP'',''MSC'',''MSD'',''WIP'')       THEN n.ORGANIZATION_ID
                 WHEN application_label IN 
                         (''AP'',''AR'',''BEN'',''CS'',''GMS'',''HR'',''HXC'',''IGW'',''PA'',''PAY'',
                          ''PB'',''PC'',''PJM'',''RA'',''PO'',''OE'',''ONT'')      THEN n.org_id 
               END ) 
           AND o3.org_information_context(+)     = ''Legal Entity Accounting''
           AND EXISTS 
             ( SELECT 1 
                 FROM hr_organization_information_s o2
                WHERE o2.organization_id         = o.organization_id
                  AND o2.org_information_context = ''CLASS''
                  AND o2.org_information1        = ''HR_LEGAL''
                  AND o2.org_information2        = ''Y''        )
           AND o.organization_id                 = otl.organization_id
           AND otl.LANGUAGE                      = USERENV (''LANG'') )';
    ls_12plus_version VARCHAR2(1);
BEGIN
    
    BEGIN
        SELECT 'Y'
          INTO ls_12plus_version
          FROM DUAL
         WHERE EXISTS 
             ( SELECT table_name
                 FROM SYS.all_tables
                WHERE owner      = '&AP_USERID'
                  AND table_name = 'AP_SUPPLIERS' );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ls_12plus_version := 'N';
    END;
    
    if ( ls_12plus_version = 'Y' ) THEN
        DBMS_OUTPUT.PUT_LINE( 'Update n_application_owners with the Legal Entity information.' );
        DBMS_OUTPUT.PUT_LINE( '' );
        -- Execute the 12+ version of the update for legal entity
        execute immediate 
            'UPDATE n_application_owners n
                SET n.legal_entity_name = '||ls_select_12plus;
    else
        -- execute the 11i version of the update for legal entity
        execute immediate 
            'UPDATE n_application_owners n
                SET n.legal_entity_name = '||ls_select_11_5;
    end if;
    dbms_output.put_line( SQL%ROWCOUNT||' rows updated' );

    commit;

END;
/

set serveroutput off

@utlspoff

undefine AP_USERID
undefine HR_USERID
undefine MSC_USERID
undefine MSC_PARAMETERS_POPLULATED
undefine CREATE_ALL_INV_ORGS_FLAG
undefine CROSS_ORG_FLAG
undefine CREATE_CROSS_OP_VIEWS_FLAG
undefine XO_ROLE_PRESENT
undefine MULTIORG_FLAG
undefine ORG_ID_PROFILE
undefine PA_USERID
undefine PROJECTS_MC_AVAILABLE
-- end org.sql
