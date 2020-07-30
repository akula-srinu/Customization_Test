-- Title
--    app2app.sql
-- Function
--    Populate n_app_to_app with application cross reference and oracle users
-- Description
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--    22-Mar-96 M Turner
--    30-May-96 M Turner  make sure RA xref to AR; CST xref to BOM
--    05-Aug-96 D Cowles  cross ref HR to all apps in all owners
--    22-Apr-97 T Norbra  remove call to tconnect.sql
--    13-Sep-99 R Lowe    Update copyright info.
--    14-Feb-00 H Sumanam Update copyright info.
--    11-Dec-00 D Glancy  Update copyright info.
--    12-Nov-01 D Glancy  Update copyright info. (Issue #5285)
--    31-Oct-02 D Glancy  Update copyright info. (Issue #8615)
--    07-Nov-02 D Glancy  1. XRef Payroll with all other applications.
--                        2. Setup Payroll product dependencies to mimic HR.
--    19-May-03 D Glancy  Add 'APP REQUIRES APP' reference between OE and
--                        JTP, QP, and WSH.  This allows us to treat these apps as part of
--                        OE.
--                        NOTE:  If we ever add the JTF, QP, and WSH as 'REAL' applications,
--                        we may need to rethink this design.  The above assumes that JTF,
--                        QP, and WSH are the equivalent to OE and can be shared with OE
--                        instances.
--                        (Issue 10563,9617)
--    23-Feb-04 D Glancy  Update Copyright Info. (Issue 11982)
--    27-May-04 D Glancy  1. Setup Benefits product dependencies to mimic HR.
--    03-Nov-04 D Glancy  Update Copyright Info. (Issue 13498)
--    22-Sep-05 D Glancy  Update copyright info. (Issue 15175)
--    13-Oct-05 D Glancy  Forced cross reference between GMF and WSH (NOT USED:  GL, INV, ONT, QP, JTF).
--                        No way to force this xref in metadata currently.
--                        (Issue 15417)
--    02-Mar-07 P Vemuru  Forced cross reference between CSD and WSH, CSI modules by inserting record into n_app_to_app table
--    07-May-07 D Glancy  Force cross reference CSF and OZF,PN, CSI by inserting record into n_app_to_app table
--                        (Issue 17582)
--    09-May-07 P Vemuru  Forced cross reference between CSI and CSD modules
--    28-May-07 D Glancy  Build cross reference statement between all the Oracle Service Modules (CS, CSD, CSF, CSI)
--                        Remove duplicate Cross references that we applied earlier.
--    02-Jul-07 D Glancy  Add support for 'EAM' module.
--                        (Issue 17727)
--    20-Sep-07 U Pisupati Force cross reference between PJM and JTF,OKE,OKC modules by inserting record into n_app_to_app table
--                        (Issue 18001)
--    19-Oct-07 S Vital   Add support for 'IBY' module.
--                        (Issue 18439)
--    20-Nov-07 M Pothuri Force cross reference between AR(235) and ZX(235) modules by inserting record into n_app_to_app table
--                        (Issue 18555)
--    04-Dec-07 M Pothuri XREF for AR/ZX should only be for 12i+.
--                        (Issue 18555)
--    04-dec-07 S Vital   Force cross reference between PO(201) and IBY(673) modules by inserting record into n_app_to_app table
--                        (Issue 18628)
--    30-Jan-08 Kranthi   Force cross reference between AR(222) and XDO(603) modules by inserting record into n_app_to_app table
--                        (Issue 18926)
--    09-Jun-08 Hatakesh  Force cross reference between ONT(660) and ZX(235) modules by inserting record into n_app_to_app table
--                        Converted to use "select ... group by" instead of "select distinct".
--                        Removed decode in favor of case statement.
--                        (Issue 19822)
--    21-Aug-08 Haripriya Force cross reference between QA(250) and OKE,PJM,GME,GMP,GMD(777,712,553,554,552) modules by inserting record into n_app_to_app table
--                        (Issue 20398)
--    28-Sep-08 Haripriya Add support for OKS.
--                        (Issue 20767)
--    06-Oct-08 R Bhamidipati Force cross reference between FV and AP,AR,PO modules by inserting record into n_app_to_app table
--                        (Issue 20469)
--    06-Oct-08 R Vattikonda Force cross reference between OKS and XDO modules by inserting record into n_app_to_app table
--                        (Issue 20869)
--    09-Feb-09 D Glancy  Ensure that the XXNAO application xrefs with all other applications/application_instances.
--                        We're doing this so that we can include the XXNAO_ACL_<APPL>_<ORG TYPE>_MAP_BASE views
--                        in modules other than XXNAO.
--                        (Issue 21378)
--    13-Feb-09 R Raghudev Ensure that the XXKFF application xrefs with all other applications global instances.
--                        (Issue 21542)
--    17-Feb-09 K Kondaveeti Force cross reference between HXC(809) and HXT(808) modules by inserting record into n_app_to_app table.
--                        (Issue 21430)                      
--    13-Jul-09 R Vattikonda For Project Management, 'EGO' application needs to be cross-referenced with PA.
--                        (Issue 22346)
--    11-Sep-09 H Yaddanapudi Add AR to IBY xref.
--                        (Issue 22496)
--    07-Apr-11 HCHodavarapu Force cross reference between OKE and GL AND WSH modules by inserting record into n_app_to_app tab
--    20-Oct-08 D Glancy  Add XREF between OKS and GL.
--                        (Issue 25418)
--    11-Nov-10 R Vattikonda Add XREF between CSI and GL.
--                          (Issue 25739)
--    08-Feb-11 V Gangrade Force cross reference between AR(222) and FUN(435) modules by inserting record into n_app_to_app table
--                        (Issue 25454)
--    08-Feb-11 V Gangrade Force cross reference between AP(222) and ZX(235)/FUN(435) modules by inserting record into n_app_to_app table
--                        (Issue 25454)
--    21-Jun-11 D Glancy   Ensure that the XXHIE application xrefs with all other applications global instances.
--    14-Mar-12 D Glancy   Ensure CE has a reference to IBY and XTR.
--                         (Issue 29202)
--    24-May-12 Srinivas   Forced cross reference between GL(101) /FUN(435), IBY (673)  XLE(204).
--    16-Jul-13 Kishore    Forced cross reference between XLA(602) /IBY (673).
--                         (Issue 27472)
--    09-Aug-13 D Glancy   Forced cross reference between XLA(602) /FUN (435).
--                         Support single installs of SLA only with out GL role.
--

whenever sqlerror exit 82
--
@utlspon app2app
--
-- cross reference each application to those it requires
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction
     )
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id  = b.application_id
   and a.owner_name      = b.owner_name
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction
     )
select a.application_label,     -- table owner depends on view owner
       a.application_instance,
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners       a,
       fnd_product_dependencies_s p,
       n_application_owners       b
 where p.application_id          = a.application_id
   and p.oracle_id               = a.oracle_id
   and p.required_application_id = b.application_id
   and p.required_oracle_id      = b.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 );

-- Use the same HR product dependencies for Payroll and Benefits.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction
     )
select a.application_label,     -- table owner depends on view owner
       a.application_instance,
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners       a,
       fnd_product_dependencies_s p,
       n_application_owners       b
 where a.application_label       in ( 'PAY', 'BEN' )
   and p.application_id          = ( case 
                                       when a.application_id in (801,805) then 800
                                       else a.application_id
                                     end )
   and p.oracle_id               = ( case a.oracle_id
                                       when 805 then 800
                                       else a.oracle_id
                                     end  )
   and p.required_application_id = b.application_id
   and p.required_oracle_id      = b.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 );


-- Ensure that XXNAO can be xref'd from any application.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction
     )
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where b.application_label  = 'XXNAO'
   and a.application_label != 'XXNAO'
   and a.application_id    >= 0
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1  )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Ensure that XXKFF can be xref'd from any application.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction
     )
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where b.application_label  = 'XXKFF'
   and a.application_label != 'XXKFF'
   and a.application_id    >= 0
--   and a.application_instance = 'G0'
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1  )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Ensure that XXHIE can be xref'd from any application.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction
     )
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where b.application_label  = 'XXHIE'
   and a.application_label != 'XXHIE'
   and a.application_id    >= 0
--   and a.application_instance = 'G0'
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1  )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- cross reference HR, PAY, and BEN to all apps owned by all oracle_id's
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where (   (     b.application_id   = 800
             and a.application_id  != 800  )
        or (     b.application_id   = 801
             and a.application_id  != 801  )
        or (     b.application_id   = 805
             and a.application_id  != 805  )
       )
   and a.application_id   >  0
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1  )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name; 

-- Force cross reference JTF and WSH to OE for 11i+
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to correctly build JTF/WSH flex fields in
-- OE.
-- Forced cross reference between ONT(660) and ZX(235). (Issue (19822)) for 12+
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to properly reference the ZX tables
-- in AR views. 
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   = 660
   and 
     (     (     &PRODUCT_VERSION >= 11.5
             and b.application_id  in ( 661, 665, 690 ) )
       or  (     &PRODUCT_VERSION >= 12
             and b.application_id  in ( 235 ) ) )
   and not exists
       ( select 'Already have this dependency'
           from n_app_to_app a2a
          where a2a.application_label     = a.application_label
            and a2a.owner_name            = a.owner_name
            and a2a.ref_application_label = b.application_label
            and a2a.ref_owner_name        = b.owner_name 
            and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name ;

-- Forced cross reference between GMF and WSH (NOT USED:  GL, INV, ONT, QP, JTF).
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to properly reference the other tables
-- in GMI views.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   = 555
   and b.application_id  in ( 665 )
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name 
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Forced cross reference between AR(222) and ZX(235)/XDO(603). (Issue 18555(ZX)/18926(XDO))
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to properly reference the ZX/XDO tables
-- in AR views. All this is applicable only for 12+ versions.
-- Forced cross reference between AR(222) AND FUN(435). (Issuse 25454)
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   = 222
   and b.application_id  in ( 235, 603, 435)
   and &PRODUCT_VERSION  >= 12.0
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Forced cross reference between AP(200) and ZX(235)/FUN(435).(Issuse 25454)
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   = 200
   and b.application_id  in ( 235, 435 )
   and &PRODUCT_VERSION  >= 12.0
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Forced cross reference between Oracle Service Modules CS (170), CSD (512), CSF (513), CSI (542),
-- EAM (426), and OKS (515)
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id  IN ( 170, 512, 513, 542, 426, 515 )
   and b.application_id  IN ( 170, 512, 513, 542, 426, 515 )
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Forced cross reference between Oracle Service Modules OKS (515) and GL (101)
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id  IN ( 515 )
   and b.application_id  IN ( 101 )
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;
  
-- Forced cross reference between Oracle Service Modules CSI (542) and GL (101)
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id  IN ( 542 )
   and b.application_id  IN ( 101 )
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Forced cross reference between CSD and WSH
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to correctly build base view in CSF module
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   = 512
   and b.application_id  in ( 665 )
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Force cross reference CSF to OZF, PN
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to correctly build base view in CSF module
insert into n_app_to_app
      ( application_label,
        application_instance,
        owner_name,
        ref_application_label,
        ref_application_instance,
        ref_owner_name,
        dependency_direction)   
 select a.application_label,    -- cross reference each 
        a.application_instance, -- application to itself
        a.owner_name,
        b.application_label,
        b.application_instance,
        b.owner_name,
        'APP REQUIRES REF'
   from n_application_owners a,
        n_application_owners b
  where a.application_id   = 513
    and b.application_id  in (240,682)
    and not exists 
      ( select 'Already have this dependency'
          from n_app_to_app a2a
         where a2a.application_label     = a.application_label
           and a2a.owner_name            = a.owner_name
           and a2a.ref_application_label = b.application_label
           and a2a.ref_owner_name        = b.owner_name
           and rownum                    = 1  )
  group by a.application_label,    -- cross reference each 
           a.application_instance, -- application to itself
           a.owner_name,
           b.application_label,
           b.application_instance,
           b.owner_name;
--
--Application EGO is used in Project Management views, but does not have a reference to PA in fnd_product_dependencies
--
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,
       a.application_instance,
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id    = 275  -- PA
   and b.application_id    = 431 --EGO
   and not exists
    ( select 'Already have this dependency'
        from n_app_to_app a2a
       where a2a.application_label     = a.application_label
         and a2a.owner_name            = a.owner_name
         and a2a.ref_application_label = b.application_label
         and a2a.ref_owner_name        = b.owner_name 
         and rownum                   = 1)
 group by a.application_label,
          a.application_instance,
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;
--
-- Force cross reference FV to AP,AR AND PO
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to correctly build views which use AP,AR AND PO module tables.
--
insert into n_app_to_app
      ( application_label,
        application_instance,
        owner_name,
        ref_application_label,
        ref_application_instance,
        ref_owner_name,
        dependency_direction)   
 select a.application_label,    -- cross reference each 
        a.application_instance, -- application to itself
        a.owner_name,
        b.application_label,
        b.application_instance,
        b.owner_name,
        'APP REQUIRES REF'
   from n_application_owners a,
        n_application_owners b
  where a.application_id    in (200,222,201)
    and b.application_id     = 8901
    and not exists 
      ( select 'Already have this dependency'
          from n_app_to_app a2a
         where a2a.application_label     = a.application_label
           and a2a.owner_name            = a.owner_name
           and a2a.ref_application_label = b.application_label
           and a2a.ref_owner_name        = b.owner_name
           and rownum                    = 1 )
  group by a.application_label,    -- cross reference each 
           a.application_instance, -- application to itself
           a.owner_name,
           b.application_label,
           b.application_instance,
           b.owner_name;


-- Force cross reference between HXC (808) and HXT (809)

insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id  IN ( 808,809 )
   and b.application_id  IN ( 808,809 )
   and b.application_id  <> a.application_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

--
-- IBY was added for r12, but does not have a reference to AP in fnd_product_dependencies
--
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)   
select a.application_label,
       a.application_instance,
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   in ( 200, 201, 222, 260 ) -- AP, PO, AR, CE
   and b.application_id    = 673 --IBY
   and &PRODUCT_VERSION  >= 12.0
   and not exists
       ( select 'Already have this dependency'
           from n_app_to_app a2a
          where a2a.application_label     = a.application_label
            and a2a.owner_name            = a.owner_name
            and a2a.ref_application_label = b.application_label
            and a2a.ref_owner_name        = b.owner_name
            and rownum                    = 1  )
 group by a.application_label,
          a.application_instance,
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

--
-- XTR does not have a reference to CE (260) in fnd_product_dependencies
--
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)   
select a.application_label,
       a.application_instance,
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id   in ( 260 ) -- CE
   and b.application_id    = 185 --XTR
   and not exists
       ( select 'Already have this dependency'
           from n_app_to_app a2a
          where a2a.application_label     = a.application_label
            and a2a.owner_name            = a.owner_name
            and a2a.ref_application_label = b.application_label
            and a2a.ref_owner_name        = b.owner_name
            and rownum                    = 1  )
 group by a.application_label,
          a.application_instance,
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

--
--
-- Force cross reference OKS (515) to CSI (542) and XDO (603)
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to correctly build views which use CSI
--
insert into n_app_to_app
      ( application_label,
        application_instance,
        owner_name,
        ref_application_label,
        ref_application_instance,
        ref_owner_name,
        dependency_direction)   
 select a.application_label,    -- cross reference each 
        a.application_instance, -- application to itself
        a.owner_name,
        b.application_label,
        b.application_instance,
        b.owner_name,
        'APP REQUIRES REF'
   from n_application_owners a,
        n_application_owners b
  where a.application_id     = 515
    and b.application_id    in ( 542, 603 )
    and not exists 
      ( select 'Already have this dependency'
          from n_app_to_app a2a
         where a2a.application_label     = a.application_label
           and a2a.owner_name            = a.owner_name
           and a2a.ref_application_label = b.application_label
           and a2a.ref_owner_name        = b.owner_name
           and rownum                    = 1 )
  group by a.application_label,    -- cross reference each 
           a.application_instance, -- application to itself
           a.owner_name,
           b.application_label,
           b.application_instance,
           b.owner_name;
--
--
-- Force cross reference PJM to JTF,OKE AND OKC
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  This allows us to correctly build views which use JTF,OKE AND OKC module tables.
--
insert into n_app_to_app
      ( application_label,
        application_instance,
        owner_name,
        ref_application_label,
        ref_application_instance,
        ref_owner_name,
        dependency_direction)   
 select a.application_label,    -- cross reference each 
        a.application_instance, -- application to itself
        a.owner_name,
        b.application_label,
        b.application_instance,
        b.owner_name,
        'APP REQUIRES REF'
   from n_application_owners a,
        n_application_owners b
  where a.application_id     = 712
    and b.application_id    in (690,510,777)
    and not exists 
      ( select 'Already have this dependency'
          from n_app_to_app a2a
         where a2a.application_label     = a.application_label
           and a2a.owner_name            = a.owner_name
           and a2a.ref_application_label = b.application_label
           and a2a.ref_owner_name        = b.owner_name
           and rownum                    = 1 )
  group by a.application_label,    -- cross reference each 
           a.application_instance, -- application to itself
           a.owner_name,
           b.application_label,
           b.application_instance,
           b.owner_name;
--
        --  Force cross reference OKE to GL
        -- We do this because there is no direct cross reference in the fnd_product_dependencies
        -- We may need to address this issue at a later time, but for now, let's ensure that
        -- we cross reference the apps.  This allows us to correctly build views which use OKE AND GL AND WSH module tables.

        insert into n_app_to_app
              ( application_label,
                application_instance,
                owner_name,
                ref_application_label,
                ref_application_instance,
                ref_owner_name,
                dependency_direction)   
          select distinct
                a.application_label,    -- cross reference each 
                a.application_instance, -- application to itself
                a.owner_name,
                b.application_label,
                b.application_instance,
                b.owner_name,
                'APP REQUIRES REF'
           from n_application_owners a,
                n_application_owners b
          where a.application_id     = 777
            and b.application_id     in (101, 712, 665)
            and not exists 
              ( select 'Already have this dependency'
                  from n_app_to_app a2a
                 where a2a.application_label     = a.application_label
                   and a2a.owner_name            = a.owner_name
                   and a2a.ref_application_label = b.application_label
                   and a2a.ref_owner_name        = b.owner_name );
--
-- Force cross reference QA and to OKE,GME,GMP,PJM,GMD for 11i+ (Issue 20398)
-- We do this because there is no direct cross reference in the fnd_product_dependencies
-- We may need to address this issue at a later time, but for now, let's ensure that
-- we cross reference the apps.  

insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id     = 250
    and b.application_id    in (777,712,553,554,552)
    and not exists 
      ( select 'Already have this dependency'
          from n_app_to_app a2a
         where a2a.application_label     = a.application_label
           and a2a.owner_name            = a.owner_name
           and a2a.ref_application_label = b.application_label
           and a2a.ref_owner_name        = b.owner_name
           and rownum                    = 1 )
  group by a.application_label,    -- cross reference each 
           a.application_instance, -- application to itself
           a.owner_name,
           b.application_label,
           b.application_instance,
           b.owner_name;

--
-- Begin other 'APP REQ %' columns
--
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,     -- table owner depends on view
       a.application_instance,  -- owner indirectly
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQ X REQ REF'
  from n_application_owners       b,
       fnd_product_dependencies_s p1,
       fnd_product_dependencies_s p2,
       n_application_owners       a
 where p1.application_id          = a.application_id
   and p1.oracle_id               = a.oracle_id
   and p2.application_id          = p1.required_application_id
   and p2.oracle_id               = p1.required_oracle_id
   and p2.required_application_id = b.application_id
   and p2.required_oracle_id      = b.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name )
 group by a.application_label,     -- table owner depends on view
          a.application_instance,  -- owner indirectly
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

--
-- Use the same HR product dependencies for Payroll and Benefits.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,     -- table owner depends on view
       a.application_instance,  -- owner indirectly
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQ X REQ REF'
  from n_application_owners       b,
       fnd_product_dependencies_s p1,
       fnd_product_dependencies_s p2,
       n_application_owners       a
 where a.application_label       in ( 'PAY', 'BEN' )
   and p1.application_id          = ( case
                                        when a.application_id in (801,805) then 800
                                        else                                    a.application_id
                                      end )
   and p1.oracle_id               = ( case a.oracle_id
                                        when 805 then 800
                                        else          a.oracle_id 
                                      end )
   and p2.application_id          = p1.required_application_id
   and p2.oracle_id               = p1.required_oracle_id
   and p2.required_application_id = b.application_id
   and p2.required_oracle_id      = b.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name 
          and rownum                    = 1 )
 group by a.application_label,     -- table owner depends on view
          a.application_instance,  -- owner indirectly
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,     -- view owner depends on table owner
       a.application_instance,
       a.owner_name,
       b.application_label     ref_application_label,
       b.application_instance  ref_application_instance,
       b.owner_name            ref_owner_name,
       'REF REQUIRES APP'      dependency_direction
  from n_application_owners       a,
       fnd_product_dependencies_s p,
       n_application_owners       b
 where p.application_id          = b.application_id
   and p.oracle_id               = b.oracle_id
   and p.required_application_id = a.application_id
   and p.required_oracle_id      = a.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,     -- view owner depends on table owner
          a.application_instance,
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;
--
-- Use the same HR product dependencies for Payroll and Benefits.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,     -- view owner depends on table owner
       a.application_instance,
       a.owner_name,
       b.application_label     ref_application_label,
       b.application_instance  ref_application_instance,
       b.owner_name            ref_owner_name,
       'REF REQUIRES APP'      dependency_direction
  from n_application_owners       a,
       fnd_product_dependencies_s p,
       n_application_owners       b
 where b.application_label       in ( 'PAY', 'BEN' )
   and p.application_id          = ( case
                                       when b.application_id in (801,805) then 800
                                       else                                    b.application_id
                                     end )
   and p.oracle_id               = ( case b.oracle_id
                                       when 805 then 800
                                       else          b.oracle_id
                                     end )
   and p.required_application_id = a.application_id
   and p.required_oracle_id      = a.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name 
          and rownum                    = 1 )
 group by a.application_label,     -- view owner depends on table owner
          a.application_instance,
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,     -- view owner depends on
       a.application_instance,  -- table owner indirectly
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'REF REQ X REQ APP'
  from n_application_owners       b,
       fnd_product_dependencies_s p1,
       fnd_product_dependencies_s p2,
       n_application_owners       a
 where p1.application_id          = b.application_id
   and p1.oracle_id               = b.oracle_id
   and p2.application_id          = p1.required_application_id
   and p2.oracle_id               = p1.required_oracle_id
   and p2.required_application_id = a.application_id
   and p2.required_oracle_id      = a.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,     -- view owner depends on
          a.application_instance,  -- table owner indirectly
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;
--
-- Use the same HR product dependencies for Payroll and Benefits.
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction )
select a.application_label,     -- view owner depends on
       a.application_instance,  -- table owner indirectly
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'REF REQ X REQ APP'
  from n_application_owners       b,
       fnd_product_dependencies_s p1,
       fnd_product_dependencies_s p2,
       n_application_owners       a
 where b.application_label       in ( 'PAY', 'BEN' )
   and p1.application_id          = ( case
                                        when b.application_id in (801,805) then 800
                                        else                                    b.application_id
                                      end )
   and p1.oracle_id               = ( case b.oracle_id
                                        when 805 then 800
                                        else          b.oracle_id
                                      end )
   and p2.application_id          = p1.required_application_id
   and p2.oracle_id               = p1.required_oracle_id
   and p2.required_application_id = a.application_id
   and p2.required_oracle_id      = a.oracle_id
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,     -- view owner depends on
          a.application_instance,  -- table owner indirectly
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

-- Forced cross reference between GL(101) /FUN(435), IBY (673)  XLE(204) 
insert into n_app_to_app
     ( application_label,
       application_instance,
       owner_name,
       ref_application_label,
       ref_application_instance,
       ref_owner_name,
       dependency_direction)
select a.application_label,    -- cross reference each
       a.application_instance, -- application to itself
       a.owner_name,
       b.application_label,
       b.application_instance,
       b.owner_name,
       'APP REQUIRES REF'
  from n_application_owners a,
       n_application_owners b
 where a.application_id  in ( 101, 602 )
   and b.application_id  in ( 435, 204, 673 )
   and &PRODUCT_VERSION  >= 12.0
   and not exists
     ( select 'Already have this dependency'
         from n_app_to_app a2a
        where a2a.application_label     = a.application_label
          and a2a.owner_name            = a.owner_name
          and a2a.ref_application_label = b.application_label
          and a2a.ref_owner_name        = b.owner_name
          and rownum                    = 1 )
 group by a.application_label,    -- cross reference each
          a.application_instance, -- application to itself
          a.owner_name,
          b.application_label,
          b.application_instance,
          b.owner_name;

COMMIT;

@utlspoff
-- undefine temporary variables
--
-- end of file app2app.sql
