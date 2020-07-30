-- Script Name : n_temp_customizations.trg
-- Purpose     : Triggers to capture changes:
--  
-- Version     : 1.0

-- Copyright Noetix Corporation 2002-2016  All Rights Reserved

-- MODIFICATION HISTORY
-- Person       Date       Comments
-- ---------    ------     ------------------------------------------       
--  Srinivasa   31-Mar-15  Created Install version
--  Arvind      26-Jun-15  replace :new.view_label to :old.view_label for deletion(Issue: NV-1093)
--  Arvind      04-Aug-15  Modified trigger n_join_key_col_temp_incr_trg from Issue: NV-1156
--  Arvind      08-Oct-15  Added code for n_help% tables and n_application_owner_templates as non supported tables. (Issue: NV-1240)
--  Arvind      13-Oct-15  Added code to support deletes in WB customizations. (Issue: NV-1217)
--  Arvind      04-Feb-16  Modify triggers to handle deletes on joins. (Issue NV-1330)
--  Karunakar   04-Mar-16  Created one function 'Fun_Verflag' to get the INCLUDE_FLAG value on the basis of 
--                         product_version to support suppressions via update on n_join_key_col_templates. (Issue NV-1374)
--  Karunakar   04-Mar-16  Added call to Fun_Verflag function in trigger n_join_key_temp_incr_trg. (Issue NV-1374)
--	Arvind      17-Mar-16  Modfied the n_join_key_temp_incr_trg trigger to handle delete cascade option (Issue NV-1330).
--  Venkat      03-May-15  Modified the Fun_Verflag function to handle product_version with '%' value (Issue NV-1529)
--
start wdrop table    &NOETIX_USER n_customizations

CREATE TABLE n_customizations (Cust_RowId varchar2(200), view_label varchar2(200), Cust_Location varchar2(200), Cust_Action varchar2(200),creation_date date);


--Creating Fun_Verflag function to determine include_flag for a template table

CREATE OR REPLACE FUNCTION Fun_Verflag(rec_prod_version varchar2)
  RETURN VARCHAR2 IS
  --declare
  from_ver     VARCHAR2(15); -- will hold the lowest version
  to_ver       VARCHAR2(15); -- will hold the highest version
  temp         NUMBER; -- position of 2nd period in to_ver
  orig_version VARCHAR2(15); -- for debugging, only
  ora_ver      NUMBER; -- Oracle app version number
  V_FLAGE      CHAR(1) := 'N';

BEGIN
  /* Get the PRODUCT VERSION env var
    turn it into a decimal number.
    This function assumes there are at least two decimal points
    in the string, but only the characters to the left of the second
    decimal point are converted into a number.
  */
  temp := INSTRB('&PRODUCT_VERSION', '.', 1, 2) - 1;
  IF (temp > 1) THEN
    to_ver := SUBSTRB('&PRODUCT_VERSION', 1, temp);
  ELSE
    to_ver := '&PRODUCT_VERSION';
  END IF;
  ora_ver      := TO_NUMBER(REPLACE(TRANSLATE(UPPER(to_ver),
                                              'ABCDEFGHIJKLMNOPQRSTUVWXYZ ~!@#$%^&*()_+|-=\{}[]:;<>?,/',
                                              'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                                    'X'));
  to_ver       := ltrim(rtrim(rec_prod_version, ' '), ' ');
  orig_version := to_ver;
  IF (to_ver like '%+') THEN
    from_ver := substrb(to_ver, 1, lengthb(to_ver) - 1);
    temp     := INSTRB(from_ver, '.', 1, 2) - 1;
    IF (temp > 1) THEN
      from_ver := SUBSTRB(from_ver, 1, temp);
    END IF;
    to_ver := '999';
  ELSIF (to_ver like '%-%') THEN
    from_ver := substrb(to_ver, 1, instrb(to_ver, '-') - 1);
    temp     := INSTRB(from_ver, '.', 1, 2) - 1;
    IF (temp > 1) THEN
      from_ver := SUBSTRB(from_ver, 1, temp);
    END IF;
    to_ver := substrb(to_ver, instrb(to_ver, '-') + 1, lengthb(to_ver));
    temp   := INSTRB(to_ver, '.', 1, 2) - 1;
    IF (temp > 1) THEN
      to_ver := SUBSTRB(to_ver, 1, temp);
    END IF;
  ELSIF (to_ver IN (null, ' ', '*','%')) THEN
    from_ver := '0';
    to_ver   := '999';
  ELSE
    from_ver := to_ver;
    IF (instrb(to_ver, '.') = 0) THEN
      to_ver := to_ver || '.999999';
    ELSE
      temp := INSTRB(from_ver, '.', 1, 2) - 1;
      IF (temp > 1) THEN
        from_ver := SUBSTRB(from_ver, 1, temp);
      END IF;
      to_ver := from_ver;
    END IF;
  END IF;
  IF ora_ver between TO_NUMBER(from_ver) and TO_NUMBER(to_ver) THEN
    V_FLAGE := 'Y';
    RETURN V_FLAGE;
  Else
    RETURN V_FLAGE;
  end if;

END;
/

--End of Fun_Verflag function definition


CREATE OR REPLACE TRIGGER n_view_temp_incr_trg
BEFORE UPDATE OR DELETE ON n_view_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid, :new.view_label,'N_VIEW_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid, :old.view_label,'N_VIEW_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_view_temp_del_incr 
      (U_ID, VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION,
      INCLUDE_FLAG, USER_INCLUDE_FLAG, EXPORT_VIEW , SECURITY_CODE, SPECIAL_PROCESS_CODE, SORT_LAYER, FREEZE_FLAG,
      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
    values
      (:old.rowid, :old.view_label, :old.application_label, :old.description, :old.profile_option, :old.essay, :old.keywords, :old.product_version,
      :old.include_flag, :old.user_include_flag, :old.export_view, :old.security_code, :old.special_process_code, :old.sort_layer, :old.freeze_flag,
      :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date, :old.original_version, :old.current_version);
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_temp_incr_trg1
AFTER INSERT ON n_view_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_VIEW_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_query_temp_incr_trg
BEFORE UPDATE OR DELETE ON n_view_query_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_VIEW_QUERY_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid, :old.view_label,'N_VIEW_QUERY_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_view_query_temp_del_incr
      (U_ID, VIEW_LABEL, QUERY_POSITION, UNION_MINUS_INTERSECTION, GROUP_BY_FLAG, PROFILE_OPTION,
      PRODUCT_VERSION, INCLUDE_FLAG, USER_INCLUDE_FLAG, VIEW_COMMENT, CREATED_BY, CREATION_DATE,
      LAST_UPDATED_BY, LAST_UPDATE_DATE)
    values
      (:old.rowid, :old.view_label, :old.query_position, :old.union_minus_intersection, :old.group_by_flag, :old.profile_option, 
      :old.product_version, :old.include_flag, :old.user_include_flag, :old.view_comment, :old.created_by, :old.creation_date, 
      :old.last_updated_by, :old.last_update_date); 
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_query_temp_incr_trg1
AFTER INSERT ON n_view_query_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_VIEW_QUERY_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_tabtemp_incr_trg
BEFORE UPDATE OR DELETE ON n_view_table_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid, :new.view_label,'N_VIEW_TABLE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid, :old.view_label,'N_VIEW_TABLE_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_view_tabtemp_del_incr
      (U_ID, VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME,
      PROFILE_OPTION, PRODUCT_VERSION, INCLUDE_FLAG, USER_INCLUDE_FLAG, BASE_TABLE_FLAG, KEY_VIEW_LABEL, 
      SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
    values
      (:old.rowid, :old.view_label, :old.query_position, :old.table_alias, :old.from_clause_position, :old.application_label, :old.table_name,
      :old.profile_option, :old.product_version, :old.include_flag, :old.user_include_flag, :old.base_table_flag, :old.key_view_label,
      :old.subquery_flag, :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date, :old.gen_search_by_col_flag);
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_tabtemp_incr_trg1
AFTER INSERT ON n_view_table_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid, :new.view_label,'N_VIEW_TABLE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_coltemp_incr_trg
BEFORE UPDATE OR DELETE ON N_VIEW_COLUMN_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid, :new.view_label,'N_VIEW_COLUMN_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:old.view_label, 'N_VIEW_COLUMN_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_view_col_tmp_del_incr
      (U_ID, T_COLUMN_ID, VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION,
      COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_APPLICATION_LABEL, REF_TABLE_NAME, KEY_VIEW_LABEL,
      REF_LOOKUP_COLUMN_NAME, REF_DESCRIPTION_COLUMN_NAME, REF_LOOKUP_TYPE, ID_FLEX_APPLICATION_ID, ID_FLEX_CODE,
      GROUP_BY_FLAG, FORMAT_MASK, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG , LOV_VIEW_LABEL, LOV_COLUMN_LABEL,
      PROFILE_OPTION, PRODUCT_VERSION, INCLUDE_FLAG, USER_INCLUDE_FLAG, CREATED_BY, CREATION_DATE,
      LAST_UPDATED_BY, LAST_UPDATE_DATE)
    values
      (:old.rowid, :old.t_column_id, :old.view_label, :old.query_position, :old.column_label, :old.table_alias, :old.column_expression,
       :old.column_position, :old.column_type, :old.description, :old.ref_application_label, :old.ref_table_name, :old.key_view_label,
       :old.ref_lookup_column_name, :old.ref_description_column_name, :old.ref_lookup_type, :old.id_flex_application_id, :old.id_flex_code,
       :old.group_by_flag, :old.format_mask, :old.format_class, :old.gen_search_by_col_flag, :old.lov_view_label, :old.lov_column_label,
       :old.profile_option, :old.product_version, :old.include_flag, :old.user_include_flag, :old.created_by, :old.creation_date,
       :old.last_updated_by, :old.last_update_date);
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_coltemp_incr_trg1
AFTER INSERT ON N_VIEW_COLUMN_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid, :new.view_label,'N_VIEW_COLUMN_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_VIEW_WHERE_TEMP_incr_trg
BEFORE UPDATE OR DELETE ON N_VIEW_WHERE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid, :new.view_label,'N_VIEW_WHERE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:old.view_label, 'N_VIEW_WHERE_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_view_where_tmp_del_incr
      (U_ID, VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION,
      INCLUDE_FLAG, USER_INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    values
      (:old.rowid, :old.view_label, :old.query_position, :old.where_clause_position, :old.where_clause, :old.profile_option, :old.product_version, 
      :old.include_flag, :old.user_include_flag, :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date);
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_VIEW_WHERE_TEMP_incr_trg1
AFTER INSERT ON N_VIEW_WHERE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_VIEW_WHERE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/
-- NV-1330
CREATE OR REPLACE TRIGGER n_join_key_temp_incr_trg
BEFORE UPDATE OR DELETE ON n_join_key_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
  DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_JOIN_KEY_TEMPLATES','UPDATE',sysdate ) ;

  --ADDED TO FIX 1374
  if NVL(:new.user_include_flag,'Y')='N' or Fun_Verflag(NVL(:new.product_version,'*'))='N'  then
  
  update n_join_key_templates b
  set b.user_include_flag='N'
  WHERE B.referenced_pk_t_join_key_id=:OLD.t_join_key_id;
  end if;
  --ADDED TO FIX 1374
  END IF;

  if deleting then
    N_View_Parameters_API_PKG.init();
    N_View_Parameters_API_PKG.insert_date(:old.view_label,:old.t_join_key_id);
    
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:old.view_label, 'N_JOIN_KEY_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_join_key_temp_del_incr
      (U_ID, T_JOIN_KEY_ID, VIEW_LABEL, KEY_NAME, DESCRIPTION, JOIN_KEY_CONTEXT_CODE, KEY_TYPE_CODE,
      COLUMN_TYPE_CODE, OUTERJOIN_FLAG, OUTERJOIN_DIRECTION_CODE, KEY_RANK, PL_REF_PK_VIEW_NAME_MODIFIER,
      PL_ROWID_COL_NAME_MODIFIER, KEY_CARDINALITY_CODE, REFERENCED_PK_T_JOIN_KEY_ID, PRODUCT_VERSION, PROFILE_OPTION,
      INCLUDE_FLAG, USER_INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, VERSION_ID)
    values
      (:old.rowid, :old.t_join_key_id, :old.view_label, :old.key_name, :old.description, :old.join_key_context_code, :old.key_type_code,
      :old.column_type_code, :old.outerjoin_flag, :old.outerjoin_direction_code, :old.key_rank, :old.pl_ref_pk_view_name_modifier,
      :old.pl_rowid_col_name_modifier, :old.key_cardinality_code, :old.referenced_pk_t_join_key_id, :old.product_version, :old.profile_option,
      :old.include_flag, :old.user_include_flag, :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date, :old.version_id);
      -------------------------
      delete from n_join_key_templates nvct      where nvct.referenced_pk_t_join_key_id = :old.t_join_key_id ;
      delete from n_join_key_col_templates nvct  where nvct.T_JOIN_KEY_ID           = :old.t_join_key_id ;
      -------------------------
   end if;
   COMMIT;
End;
/


CREATE OR REPLACE TRIGGER n_join_key_temp_incr_trg1
AFTER INSERT ON n_join_key_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:new.view_label, 'N_JOIN_KEY_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

-- NV-1330
CREATE OR REPLACE TRIGGER n_join_key_col_temp_incr_trg
BEFORE UPDATE OR DELETE ON n_join_key_col_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Declare
l_view_label varchar2(200);
Begin
  if updating then
    select N_View_Parameters_API_PKG.view_return(:old.t_join_key_id) into l_view_label from dual;
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,l_view_label, 'N_JOIN_KEY_COL_TEMPLATES','UPDATE',sysdate ) ;
  end if;
  if deleting then
    select N_View_Parameters_API_PKG.view_return(:old.t_join_key_id) into l_view_label from dual;
    if l_view_label is null then
      select  distinct view_label into l_view_label from n_join_key_templates where t_join_key_id=:old.t_join_key_id and rownum=1; 
    end if;
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,l_view_label, 'N_JOIN_KEY_COL_TEMPLATES','DELETE',sysdate ) ;
	   --Added the following insert for NV-1217
    Insert into n_join_key_col_tmp_del_incr
      (U_ID, T_JOIN_KEY_COLUMN_ID, T_JOIN_KEY_ID, T_COLUMN_POSITION, COLUMN_LABEL, KFF_TABLE_PK_COLUMN_NAME,
      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, VERSION_ID)
    values
      (:old.rowid, :old.t_join_key_column_id, :old.t_join_key_id, :old.t_column_position, :old.column_label, :old.kff_table_pk_column_name, 
      :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date, :old.version_id);
   end if;
End;
/


CREATE OR REPLACE TRIGGER n_join_key_col_temp_incr_trg1
AFTER INSERT ON n_join_key_col_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Declare
l_view_label varchar2(200);
Begin
   select  distinct view_label into l_view_label from n_join_key_templates where t_join_key_id=:new.t_join_key_id and rownum=1;
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,l_view_label, 'N_JOIN_KEY_COL_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_role_view_temp_incr_trg
BEFORE UPDATE OR DELETE ON n_role_view_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:new.view_label, 'N_ROLE_VIEW_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:old.view_label, 'N_ROLE_VIEW_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_role_view_temp_del_incr
      (U_ID, ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, USER_INCLUDE_FLAG,
      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    values 
      (:old.rowid, :old.role_label, :old.view_label, :old.product_version, :old.include_flag, :old.user_include_flag,
      :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date);
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_role_view_temp_incr_trg1
AFTER INSERT ON n_role_view_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_ROLE_VIEW_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_proptemp_incr_trg
BEFORE  UPDATE OR DELETE ON n_view_property_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:new.view_label, 'N_VIEW_PROPERTY_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:old.view_label, 'N_VIEW_PROPERTY_TEMPLATES','DELETE',sysdate ) ;
    -- Added the following insert for NV-1217
    Insert into n_view_proptemp_del_incr
      (U_ID, T_VIEW_PROPERTY_ID , VIEW_LABEL, QUERY_POSITION, PROPERTY_TYPE_ID, T_SOURCE_PK_ID,
      VALUE1, VALUE2, VALUE3, VALUE4, VALUE5, PROFILE_OPTION, PRODUCT_VERSION, INCLUDE_FLAG,
      USER_INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, VERSION_ID)
    values
      (:old.rowid, :old.t_view_property_id, :old.view_label, :old.query_position, :old.property_type_id, :old.t_source_pk_id,
      :old.value1, :old.value2, :old.value3, :old.value4, :old.value5, :old.profile_option, :old.product_version, :old.include_flag, 
      :old.user_include_flag, :old.created_by, :old.creation_date, :old.last_updated_by, :old.last_update_date, :old.version_id);
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_view_proptemp_incr_trg1
AFTER INSERT ON n_view_property_templates
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_VIEW_PROPERTY_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

--Creating triggers for non-supported metadata tables
CREATE OR REPLACE TRIGGER n_role_temp_incr_trg
BEFORE  UPDATE OR DELETE ON N_ROLE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ROLE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ROLE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER n_role_temp_incr_trg1
AFTER INSERT ON N_ROLE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ROLE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_WHERE_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_WHERE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_WHERE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_WHERE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_WHERE_TEMP_incr_trg1
AFTER INSERT ON N_ANS_WHERE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_WHERE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/



CREATE OR REPLACE TRIGGER N_ANS_TABLE_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_TABLE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_TABLE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_TABLE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_TABLE_TEMP_incr_trg1
AFTER INSERT ON N_ANS_TABLE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_TABLE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_QUERY_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_QUERY_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_QUERY_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_QUERY_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_QUERY_TEMP_incr_trg1
AFTER INSERT ON N_ANS_QUERY_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_QUERY_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_PARAM_VALUE_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_PARAM_VALUE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_PARAM_VALUE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_PARAM_VALUE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_PARAM_VALUE_incr_trg1
AFTER INSERT ON N_ANS_PARAM_VALUE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_PARAM_VALUE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_PARAM_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_PARAM_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_PARAM_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_PARAM_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_PARAM_TEMP_incr_trg1
AFTER INSERT ON N_ANS_PARAM_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_PARAM_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_COLUMN_TOTAL_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_COLUMN_TOTAL_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_COLUMN_TOTAL_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_COLUMN_TOTAL_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_COLUMN_TOTAL_incr_trg1
AFTER INSERT ON N_ANS_COLUMN_TOTAL_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_COLUMN_TOTAL_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/


CREATE OR REPLACE TRIGGER N_ANS_COLUMN_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANS_COLUMN_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_COLUMN_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANS_COLUMN_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANS_COLUMN_TEMP_incr_trg1
AFTER INSERT ON N_ANS_COLUMN_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANS_COLUMN_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/


CREATE OR REPLACE TRIGGER N_ANSWER_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ANSWER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANSWER_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ANSWER_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ANSWER_TEMP_incr_trg1
AFTER INSERT ON N_ANSWER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ANSWER_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/


CREATE OR REPLACE TRIGGER N_GRANT_TABLE_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_GRANT_TABLE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_GRANT_TABLE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_GRANT_TABLE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_GRANT_TABLE_TEMP_incr_trg1
AFTER INSERT ON N_GRANT_TABLE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_GRANT_TABLE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_VIEW_TABLE_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_VIEW_TABLE_CHANGES_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_VIEW_TABLE_CHANGES_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_VIEW_TABLE_CHANGES_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_VIEW_TABLE_TEMP_incr_trg1
AFTER INSERT ON N_VIEW_TABLE_CHANGES_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_VIEW_TABLE_CHANGES_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_TO_DO_VIEW_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_TO_DO_VIEW_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:new.view_label, 'N_TO_DO_VIEW_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,:new.view_label, 'N_TO_DO_VIEW_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_TO_DO_VIEW_TEMP_incr_trg1
AFTER INSERT ON N_TO_DO_VIEW_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,:new.view_label, 'N_TO_DO_VIEW_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_SEG_KEY_FLEX_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_SEG_KEY_FLEXFIELD_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_SEG_KEY_FLEXFIELD_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_SEG_KEY_FLEXFIELD_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_SEG_KEY_FLEX_TEMP_incr_trg1
AFTER INSERT ON N_SEG_KEY_FLEXFIELD_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_SEG_KEY_FLEXFIELD_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ROLE_APPL_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_ROLE_APPL_XREF_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ROLE_APPL_XREF_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_ROLE_APPL_XREF_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_ROLE_APPL_TEMP_incr_trg1
AFTER INSERT ON N_ROLE_APPL_XREF_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_ROLE_APPL_XREF_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_PROPERTY_TYPE_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_PROPERTY_TYPE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_PROPERTY_TYPE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_PROPERTY_TYPE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_PROPERTY_TYPE_TEMP_incr_trg1
AFTER INSERT ON N_PROPERTY_TYPE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_PROPERTY_TYPE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_PROFILE_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_PROFILE_OPTION_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_PROFILE_OPTION_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_PROFILE_OPTION_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_PROFILE_TEMP_incr_trg1
AFTER INSERT ON N_PROFILE_OPTION_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_PROFILE_OPTION_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_PL_FOLDER_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_PL_FOLDER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_PL_FOLDER_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_PL_FOLDER_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_PL_FOLDER_TEMP_incr_trg1
AFTER INSERT ON N_PL_FOLDER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_PL_FOLDER_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_KFF_STRUCT_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_KFF_STRUCT_IDEN_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_KFF_STRUCT_IDEN_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_KFF_STRUCT_IDEN_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_KFF_STRUCT_TEMP_incr_trg1
AFTER INSERT ON N_KFF_STRUCT_IDEN_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_KFF_STRUCT_IDEN_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_KFF_PROC_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_KFF_PROCESSING_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_KFF_PROCESSING_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_KFF_PROCESSING_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_KFF_PROC_TEMP_incr_trg1
AFTER INSERT ON N_KFF_PROCESSING_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_KFF_PROCESSING_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_KFF_FLEX_TEMP_incr_trg
BEFORE  UPDATE OR DELETE ON N_KFF_FLEX_SOURCE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_KFF_FLEX_SOURCE_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_KFF_FLEX_SOURCE_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_KFF_FLEX_TEMP_incr_trg1
AFTER INSERT ON N_KFF_FLEX_SOURCE_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_KFF_FLEX_SOURCE_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/
--n_help_% triggers under issue nv-1240

CREATE OR REPLACE TRIGGER N_HELP_QUES_TEMP_INCR_TRG
BEFORE  UPDATE OR DELETE ON N_HELP_QUESTIONS_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_HELP_QUESTIONS_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_HELP_QUESTIONS_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_HELP_QUES_TEMP_INCR_TRG1
AFTER INSERT ON N_HELP_QUESTIONS_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_HELP_QUESTIONS_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/


CREATE OR REPLACE TRIGGER N_HELP_SEE_TEMP_INCR_TRG
BEFORE  UPDATE OR DELETE ON N_HELP_SEE_OTHER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_HELP_SEE_OTHER_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_HELP_SEE_OTHER_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_HELP_SEE_TEMP_INCR_TRG1
AFTER INSERT ON N_HELP_SEE_OTHER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_HELP_SEE_OTHER_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/


CREATE OR REPLACE TRIGGER N_HELP_PRG_XREF_TEMP_INCR_TRG
BEFORE  UPDATE OR DELETE ON N_HELP_PROGRAM_XREF_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_HELP_PROGRAM_XREF_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_HELP_PROGRAM_XREF_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_HELP_PRG_XREF_TEMP_INCR_TRG1
AFTER INSERT ON N_HELP_PROGRAM_XREF_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_HELP_PROGRAM_XREF_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_APPL_OWNER_TEMP_INCR_TRG
BEFORE  UPDATE OR DELETE ON N_APPLICATION_OWNER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  if updating then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_APPLICATION_OWNER_TEMPLATES','UPDATE',sysdate ) ;
  end if;

  if deleting then
    Insert into n_customizations ( Cust_RowId, view_label,Cust_Location,Cust_Action ,creation_date)  values ( :new.rowid,null, 'N_APPLICATION_OWNER_TEMPLATES','DELETE',sysdate ) ;
  end if;
End;
/

CREATE OR REPLACE TRIGGER N_APPL_OWNER_TEMP_INCR_TRG1
AFTER INSERT ON N_APPLICATION_OWNER_TEMPLATES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  If inserting then
    Insert into n_customizations ( Cust_RowId,view_label, Cust_Location,Cust_Action,creation_date )  values ( :new.rowid,null, 'N_APPLICATION_OWNER_TEMPLATES','INSERT',sysdate ) ;
  end if;
End;
/
