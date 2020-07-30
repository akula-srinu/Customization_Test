-- 07-Apr-2011 HChodavarapu Added for new XMAP creation.

-- Insert into Template table for View: OKE_OU_ACL_Map_Base

@utlspon PJM_OU_ACL_Map_Base

INSERT INTO N_VIEW_TEMPLATES (
   VIEW_LABEL,
   APPLICATION_LABEL,
   DESCRIPTION,
   PROFILE_OPTION,
   ESSAY,
   KEYWORDS,
   PRODUCT_VERSION,
   EXPORT_VIEW,
   SECURITY_CODE,
   SPECIAL_PROCESS_CODE,
   SORT_LAYER, --EXCLUDE SORT_LAYER IN 5.7
   FREEZE_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   ORIGINAL_VERSION,
   CURRENT_VERSION
 ) VALUES (
   'OKE_OU_ACL_Map_Base',
   'OKE',
   null,
   null,
   null,
   null,
   '%',
   'Y',
   'NONE',
   'BASEVIEW',   
   0, --EXCLUDE SORT_LAYER IN 5.7
   'N',
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   null,
   null );

commit;

@utlspoff