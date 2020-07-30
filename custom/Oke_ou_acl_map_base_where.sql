-- 07-Apr-2011 HChodavarapu Added for new XMAP creation.

-- Insert SQL for Template View: OKE_OU_ACL_Map_Base

@utlspon OKE_OU_ACL_Map_Base_where

INSERT INTO N_VIEW_WHERE_TEMPLATES (
   VIEW_LABEL,
   QUERY_POSITION,
   WHERE_CLAUSE_POSITION,
   WHERE_CLAUSE,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE
 ) VALUES (
   'OKE_OU_ACL_Map_Base',
   1,
   1,
   'AND NM.APPLICATION_LABEL = ''OKE''',
   null,
   '%',
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS') );

   SET SCAN OFF;

INSERT INTO N_VIEW_WHERE_TEMPLATES (
   VIEW_LABEL,
   QUERY_POSITION,
   WHERE_CLAUSE_POSITION,
   WHERE_CLAUSE,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE
 ) VALUES (
   'OKE_OU_ACL_Map_Base',
   1,
   2,
   'AND NM.APPLICATION_INSTANCE = ''&APPLICATION_INSTANCE''',
   null,
   '%',
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS') );

   SET SCAN ON;

INSERT INTO N_VIEW_WHERE_TEMPLATES (
   VIEW_LABEL,
   QUERY_POSITION,
   WHERE_CLAUSE_POSITION,
   WHERE_CLAUSE,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE
 ) VALUES (
   'OKE_OU_ACL_Map_Base',
   1,
   3,
   'AND N_SEC_MANAGER_MDSEC_PKG.CHECK_ORG_UNIT_ACCESS(''OKE'',''OU'',NM.ORG_ID) = 1',
   'OKE_OU_ADV_SECURITY_ON',
   '%',
   'hchodavarapu',
   TO_DATE('2011-02-15 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'hchodavarapu',
   TO_DATE('2011-02-15 12:39:35','YYYY-MM-DD HH24:MI:SS') );

commit;

@utlspoff