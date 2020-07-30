-- 07-Apr-2011 HChodavarapu Added for new XMAP creation.
-- Insert into query Template for View: OKE_OU_ACL_Map_Base

@utlspon OKE_OU_ACL_Map_Base_query

INSERT INTO N_VIEW_QUERY_TEMPLATES (
   VIEW_LABEL,
   QUERY_POSITION,
   UNION_MINUS_INTERSECTION,
   GROUP_BY_FLAG,
   PROFILE_OPTION,
   PRODUCT_VERSION,
   VIEW_COMMENT,
   CREATED_BY,
   CREATION_DATE,
   LAST_UPDATED_BY,
   LAST_UPDATE_DATE
 ) VALUES (
   'OKE_OU_ACL_Map_Base',
   1,
   null,
   'N',
   null,
   '%',
   null,
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS'),
   'hchodavarapu',
   TO_DATE('2011-04-07 12:39:35','YYYY-MM-DD HH24:MI:SS') );

commit;

@utlspoff