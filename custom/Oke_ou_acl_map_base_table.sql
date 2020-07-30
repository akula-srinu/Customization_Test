-- 07-Apr-2011 HChodavarapu Added for new XMAP creation.

-- Insert SQL for Template View: OKE_OU_ACL_Map_Base

@utlspon OKE_OU_ACL_Map_Base_table


INSERT INTO N_VIEW_TABLE_TEMPLATES (
   VIEW_LABEL,
   QUERY_POSITION,
   TABLE_ALIAS,
   FROM_CLAUSE_POSITION,
   APPLICATION_LABEL,
   TABLE_NAME,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   BASE_TABLE_FLAG,
   KEY_VIEW_LABEL,
   SUBQUERY_FLAG,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE,
   GEN_SEARCH_BY_COL_FLAG
 ) VALUES (
   'OKE_OU_ACL_Map_Base',
   1,
   'NM',
   1,
   'NOETIX',
   'N_APPLICATION_ORG_MAPPINGS',
   null,
   '%',
   'N',
   null,
   'N',
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'N' );

commit;

@utlspoff