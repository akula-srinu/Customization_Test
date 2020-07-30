-- 07-Apr-2011 HChodavarapu Added for 602 build.
@utlspon oke_n_view_col_property_templates

--OKE_Deliverable_PO_Pay_Dtl

--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12691, 'OKE_Deliverable_PO_Pay_Dtl', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--  TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_PO_Pay_Dtl'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' );

--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12692, 'OKE_Deliverable_PO_Pay_Dtl', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_PO_Pay_Dtl'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );   

--OKE_Deliverable_PO_Rcp_Dtl

--	Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--	   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--	   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--	   LAST_UPDATE_DATE)
--	 Values
--	   (12693, 'OKE_Deliverable_PO_Rcp_Dtl', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
--	   'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--	   TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

	INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_PO_Rcp_Dtl'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' );
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12694, 'OKE_Deliverable_PO_Rcp_Dtl', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_PO_Rcp_Dtl'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );   

-- OKE_Deliverable_Receivables

--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12695, 'OKE_Deliverable_Receivables', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_Receivables'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' );   
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12696, 'OKE_Deliverable_Receivables', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_Receivables'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );
   
   --OKE_Deliverable_Shipments

 --  Insert into N_VIEW_COL_PROPERTY_TEMPLATES
 --  (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
 --  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
 --  LAST_UPDATE_DATE)
 --Values
 --  (12697, 'OKE_Deliverable_Shipments', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
 --  'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
 --  TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_Shipments'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' ); 
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12698, 'OKE_Deliverable_Shipments', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Deliverable_Shipments'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' ); 

   --OKE_Prj_Contr_Deliverables
--query1

--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12699, 'OKE_Prj_Contr_Deliverables', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Prj_Contr_Deliverables'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' ); 
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12700, 'OKE_Prj_Contr_Deliverables', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Prj_Contr_Deliverables'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );    
   --query2

--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
 --  (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
 --  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
 --  (12701, 'OKE_Prj_Contr_Deliverables', 2, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
 --  'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
 --  TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Prj_Contr_Deliverables'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 2
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' ); 
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12702, 'OKE_Prj_Contr_Deliverables', 2, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Prj_Contr_Deliverables'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 2
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );    

   --OKE_Proj_Contract_Events

--   Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12703, 'OKE_Proj_Contract_Events', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Proj_Contract_Events'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' ); 
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12704, 'OKE_Proj_Contract_Events', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
--   TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Proj_Contract_Events'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );    

   --OKE_Project_Contract_Lines

 --  Insert into N_VIEW_COL_PROPERTY_TEMPLATES
 --  (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
 --  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
 --  LAST_UPDATE_DATE)
 --Values
 --  (12705, 'OKE_Project_Contract_Lines', 1, 'Item', '%', 'INCLUDE_INDIV_SEGMENT_VALUES', 
 --  'HChodavarapu', TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
  -- TO_DATE('06/04/2011 11:58:18', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Project_Contract_Lines'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_INDIV_SEGMENT_VALUES' ); 
   
--Insert into N_VIEW_COL_PROPERTY_TEMPLATES
--   (T_COLUMN_PROPERTY_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, PRODUCT_VERSION, COLUMN_PROPERTY_TYPE, 
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, 
--   LAST_UPDATE_DATE)
-- Values
--   (12706, 'OKE_Project_Contract_Lines', 1, 'Item', '%', 'INCLUDE_CONCAT_SEGMENT_VALUES', 
--   'HChodavarapu', TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'), 'HChodavarapu', 
 --  TO_DATE('06/04/2011 11:58:23', 'MM/DD/YYYY HH24:MI:SS'));

INSERT INTO N_VIEW_PROPERTY_TEMPLATES 
      (T_VIEW_PROPERTY_ID,
      view_label,
      query_position,
      PROPERTY_TYPE_ID,
      T_SOURCE_PK_ID,
      product_version,
      profile_option,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date)
select N_VIEW_PROPERTY_TMPL_SEQ.nextval                -- t_column_property_id
      ,col.view_label                                       -- view_label
      ,query_position                                      -- query_position
      ,pt.property_type_id
      ,col.t_column_id
      ,product_version                                     -- product_version
      ,profile_option                                      -- profile_option
      ,'KChallagali'                                          -- created_by
      ,SYSDATE                                             -- creation_date
      ,'KChallagali'                                          -- last_updated_by
      ,SYSDATE 
from n_view_column_templates col,
n_property_type_templates  pt      
where col.view_label = 'OKE_Project_Contract_Lines'
and column_label = 'Item'
and col.product_version ='%'
and col.query_position = 1
AND pt.property_type in ( 'INCLUDE_CONCAT_SEGMENT_VALUES' );    

   

COMMIT;

@utlspoff