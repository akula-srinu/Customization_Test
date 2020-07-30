-- Title 
--  w_jointo_kvl_upgrade.sql
-- Function 
--  Checks for Key_View_Labels at the table level.  If present, attempts to upgrade these to the new JOIN KEY format.
-- 
-- Description  
--  Checks for Key_View_Labels at the table level.  If present, attempts to upgrade these to the new JOIN KEY format.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History   
--  11-Sep-2012  D Glancy   Created.
--  22-May-13    D Glancy   Join key model has changed to support cardinality.
--                          (Issue 32031)
--  03-Jan-13    N Mohan    Correct issues with this script that were preventing proper operation or causing errors.
--                          (Issue 33961)
--

START utlspon w_jointo_kvl_upgrade

whenever sqlerror exit
whenever oserror  exit

set serveroutput on size 1000000
--These values need to be moved to the lookups
DECLARE
    --
    CURSOR c_views IS
      WITH kvl AS
         ( SELECT DISTINCT
                  t.view_label,
                  t.table_alias,
                  t.key_view_label,
                  COUNT(*) OVER( partition by t.view_label, t.table_alias, t.key_view_label )  table_alias_count
             FROM n_view_table_templates t
            WHERE t.key_view_label IS NOT NULL
              AND NVL(t.base_table_flag,'N') = 'Y'
              AND NVL(t.include_flag,'Y')    = 'Y' )
    SELECT v.view_label,
           v.special_process_code,
           v.profile_option,
           v.product_version,
           ( SELECT count(*)
               FROM n_view_query_templates q
              WHERE q.view_label            = v.view_label
                AND NVL(q.include_flag,'Y') = 'Y' )   query_count,
           t.table_alias,
           t.key_view_label,
           t.table_alias_count
      FROM n_view_templates v,
           kvl              t
     WHERE v.special_process_code NOT IN ('LOV')
       AND t.view_label                = v.view_label
       AND NVL(v.include_flag,'Y')     = 'Y'
      ORDER BY NVL( v.sort_layer, 999),
               ( CASE
                   WHEN ( v.special_process_code like 'BASE%' ) THEN 1
                   ELSE 2
                 END ),
               ( CASE
                   WHEN ( v.view_label = t.key_view_label ) THEN 1
                   ELSE 2
                 END ),                                     -- PK or FK?  sort
               v.view_label,
               t.table_alias;

    CURSOR c_tables( p_view_label     VARCHAR2,
                     p_table_alias    VARCHAR2,
                     p_key_view_label VARCHAR2 ) IS
    SELECT t.query_position,
           t.application_label,
           t.table_name,
           t.view_label       table_view_label,
           t.profile_option,
           t.product_version,
           q.group_by_flag,
           NVL( ( SELECT 'Y'
                    FROM n_view_column_templates c
                   WHERE c.view_label       = t.view_label
                     AND c.query_position   = t.query_position
                     AND c.table_alias      = t.table_alias
                     AND c.column_type      = 'ROWID'
                     AND c.key_view_label   = t.key_view_label
                     AND rownum             = 1                  ), 'N' )   rowid_column_exists_flag
      FROM n_view_table_templates t,
           n_view_query_templates q,
           n_view_templates key
     WHERE t.view_label                = p_view_label
       AND t.table_alias               = p_table_alias
       AND t.key_view_label            = p_key_view_label
       AND NVL(t.base_table_flag,'N')  = 'Y'
       AND q.view_label                = t.view_label
       AND q.query_position            = t.query_position
       AND NVL(t.include_flag,'Y')     = 'Y'
       AND NVL(q.include_flag,'Y')     = 'Y'
       AND NVL(t.include_flag,'Y')     = NVL(q.include_flag,'Y')
       AND UPPER(key.view_label)       = upper(t.key_view_label)
       AND NVL(key.include_flag,'Y')   = 'Y';

    CURSOR c_pk( p_key_view_label VARCHAR2 ) IS
    SELECT j.t_join_key_id
      FROM n_join_key_templates j
     WHERE j.view_label             = p_key_view_label
       AND j.key_type_code          = 'PK'
       AND j.column_type_code       = 'ROWID'
       AND j.join_key_context_code is null
     ORDER BY 1;

    ls_script                       VARCHAR2(100)      := 'w_jointo_kvl_upgrade';
    ls_location                     VARCHAR2(100)      := NULL;
    lb_ROWID_column_added_flag      BOOLEAN            := FALSE;
    lb_baseview_flag                BOOLEAN            := FALSE;
    lb_jk_error_flag                BOOLEAN            := FALSE;
    ls_table_name                   VARCHAR2(30);
    ls_saved_table_name             VARCHAR2(30);
    ls_column_expression            VARCHAR2(30);
    li_max_column_position          NUMBER;
    li_jk_sequence                  BINARY_INTEGER;
    li_jk_col_sequence              BINARY_INTEGER;
    li_view_key_counter             BINARY_INTEGER;
    ls_last_view_label              VARCHAR2(30);
    li_ref_pk_t_join_key_id         INTEGER;
    li_fk_view_ref_count            BINARY_INTEGER;
    --
    -----------------------------------------------------------------------------
    -- Function: get_rowid_table_name
    -- Return the table name associated given column_label
    --
    -----------------------------------------------------------------------------
    FUNCTION get_rowid_table_name( i_view_label      IN     VARCHAR2,
                                   i_table_alias     IN     VARCHAR2,
                                   i_key_view_label  IN     VARCHAR2      )
    RETURN VARCHAR2 AS

       CURSOR c_get_top_table_name ( p_view_label           VARCHAR2,
                                     p_table_alias          VARCHAR2,
                                     p_key_view_label       VARCHAR2 ) IS
       SELECT t.key_view_label,
              ( select distinct column_label
                  from n_view_column_templates c
                 where c.view_label     = vtab.view_label
                   and c.key_view_label = t.key_view_label
                   and c.column_type    = 'ROWID' 
                   and rownum           = 1            ) baseview_column_label,
              ( select distinct t.table_alias
                  from n_view_table_templates t
                 where t.view_label     = vtab.view_label
                   and t.key_view_label = t.key_view_label
                   and rownum           = 1            ) baseview_table_alias,
              t.table_alias,
              t.application_label,
              t.table_name,
              vtab.view_label       table_view_label
         FROM n_view_templates                vtab,
              n_view_table_templates          t,
              n_view_query_templates          q,
              n_view_templates                v
        WHERE t.view_label                = p_view_label
          AND t.table_alias               = p_table_alias
          AND t.key_view_label            = p_key_view_label
          AND NVL(t.base_table_flag,'N')  = 'Y'
          AND q.view_label                = t.view_label
          AND q.query_position            = t.query_position
          AND v.view_label                = t.view_label
          AND v.view_label                = q.view_label
          AND UPPER(vtab.view_label(+))   = UPPER(t.table_name)
          AND UPPER(vtab.special_process_code(+))  
                                          LIKE 'BASEVIEW%'
          AND NVL(vtab.include_flag(+),'Y')  = 'Y'
          AND NVL(v.include_flag,'Y')        = 'Y'
          AND NVL(q.include_flag,'Y')        = 'Y'
          AND NVL(t.include_flag,'Y')        = 'Y'
        ORDER BY q.query_position, 
                 t.table_name;

        --
        TYPE gtypi_application_label IS TABLE OF n_application_owner_templates.application_label%TYPE
             INDEX BY BINARY_INTEGER;
        TYPE gtypi_table_name        IS TABLE OF n_view_table_templates.table_name%TYPE
             INDEX BY BINARY_INTEGER;
        TYPE gtyps_application_label IS TABLE OF INTEGER
             INDEX BY VARCHAR2(30);
        TYPE gtyps_table_name        IS TABLE OF INTEGER
             INDEX BY VARCHAR2(30);
        gti_application_label_table                 gtypi_application_label;
        gti_table_name_table                        gtypi_table_name;

        gts_application_label_table                 gtyps_application_label;
        gts_table_name_table                        gtyps_table_name;

        --
        -- Declare the local variables
        ls_table_name            VARCHAR2(30);
        ls_application_label     VARCHAR2(30);
        li_table_count           BINARY_INTEGER := 0;
        li_loop_count            BINARY_INTEGER := 0;
        li_bad_table_count       BINARY_INTEGER := 0;
        li_table_check           BINARY_INTEGER := 0;
        li_index_count           BINARY_INTEGER := 1;
        ls_proc                  VARCHAR2(30)   := 'get_rowid_table_name';
       --
       --
    BEGIN

        gts_application_label_table.DELETE;
        gts_table_name_table.DELETE;

        for r1 in c_get_top_table_name ( i_view_label,
                                         i_table_alias,
                                         i_key_view_label  ) LOOP
          ls_table_name            := NULL;
          ls_application_label     := NULL;
          -- ROWID processing
          -- 
          -- The current table is another base view, need further processing.
          IF ( r1.table_view_label IS NOT NULL ) THEN
              ls_table_name := get_rowid_table_name( r1.table_view_label,
                                                     r1.baseview_table_alias,
                                                     r1.key_view_label );
          ELSE
              ls_table_name        := r1.table_name;
              ls_application_label := r1.application_label;
          END IF;

          IF ( NOT gts_table_name_table.exists( ls_table_name ) ) THEN 
              gti_table_name_table(li_index_count) := ls_table_name;
              gts_table_name_table(ls_table_name)  := li_index_count;
              li_index_count := li_index_count+1;
          END IF;
        END LOOP;

        ls_table_name := NULL;
        -- We should now have a list of tables to look at
        -- Process them if multiple
        li_table_count  := gti_table_name_table.COUNT;
        if ( li_table_count = 0 ) THEN
            ls_table_name := 'ERROR:  TABLE NOT FOUND';
        elsif ( li_table_count = 1 ) THEN
            ls_table_name := gti_table_name_table(1);
        else
            ls_table_name := 'ERROR: MULTIPLE TABLES FOUND';
        end if;

        return ls_table_name;
    END get_rowid_table_name;
    --
BEGIN
    --
    ls_location := 'Start';
    --
    -- Check for candidates for an upgade
    ls_last_view_label := 'XX_FIRST_VIEW_RECORD_XX';
    FOR r_views in c_views LOOP
        --
        ls_location := 'Look for candidate views to convert customer Key View Label info to Join Key format.';
        --
        SAVEPOINT add_join_key_record;
        --
        lb_jk_error_flag  := FALSE;
        IF ( ls_last_view_label <> r_views.view_label ) THEN
            li_view_key_counter := 1;
        ELSE
            li_view_key_counter := li_view_key_counter+1;
        END IF;
        --
        noetix_utility_pkg.Add_Installation_Message( p_script_name   => ls_script,
                                                     p_location      => ls_location,
                                                     p_message_type  => 'WARNING',
                                                     p_message       => 'Legacy Key_View_Label record detected in view '||r_views.view_label||
                                                                        ' for table_alias '||r_views.table_alias||
                                                                        '.  Recommend migrating this to the new N_JOIN_KEY_TEMPLATES tables.' );
        --
        IF ( r_views.query_count <> r_views.table_alias_count ) THEN
            ls_location  := 'See if the candidate view key view labels exists for every query.';
            noetix_utility_pkg.Add_Installation_Message( p_script_name   => ls_script,
                                                         p_location      => ls_location,
                                                         p_message_type  => 'WARNING',
                                                         p_message       => 'The legacy Key_View_Label record detected in view '||r_views.view_label||
                                                                            ' for table_alias '||r_views.table_alias||
                                                                            ' does not exist in every query.  This may result in the column not getting '||
                                                                            'instantiated depending on the profile_option or product_version configuration.' );
        END IF;
        --
        -- Determine if we are dealing with a baseview.
        if ( r_views.special_process_code like 'BASEVIEW%' ) THEN
            lb_baseview_flag := TRUE;
        ELSE
            lb_baseview_flag := FALSE;
        END IF;
        --
        lb_ROWID_column_added_flag := FALSE;
        ls_table_name              := NULL;
        ls_saved_table_name        := NULL;
        ls_column_expression       := NULL;
        FOR r_tables in c_tables( r_views.view_label,
                                  r_views.table_alias,
                                  r_views.key_view_label ) LOOP
            SELECT NVL(max(c.column_position),0)
              INTO li_max_column_position
              FROM n_view_column_templates c
             WHERE c.view_label       = r_views.view_label
               AND c.query_position   = r_tables.query_position;
            --
            -- If the table_name is a view, try to determine the actual table_name
            IF ( r_tables.table_view_label is not null ) THEN
                ls_table_name := get_rowid_table_name( r_views.view_label,
                                                       r_views.table_alias,
                                                       r_views.key_view_label );
                
            ELSE
                ls_table_name := r_tables.table_name;
            END IF;
            --
            IF ( ls_saved_table_name IS NULL ) THEN
                ls_saved_table_name := ls_table_name;
            ELSE
                IF ( ls_saved_table_name <> ls_table_name ) THEN
                    noetix_utility_pkg.Add_Installation_Message( p_script_name   => ls_script,
                                                                 p_location      => ls_location,
                                                                 p_message_type  => 'WARNING',
                                                                 p_message       => 'Unable to incorporate the legacy Key_View_Label detected in view '||r_views.view_label||
                                                                                    ' for table_alias '||r_views.table_alias||
                                                                                    ' due to multiple table names detected for the specified alias.  Skipping creation of the ROWID column.' );
                    rollback to add_join_key_record;
                    exit;
                END IF;
            END IF;
            --
            ls_location  := 'Check to see if ROWID column already exists';
            IF ( r_tables.rowid_column_exists_flag = 'Y' ) THEN
                noetix_utility_pkg.Add_Installation_Message( p_script_name   => ls_script,
                                                             p_location      => ls_location,
                                                             p_message_type  => 'INFO',
                                                             p_message       => 'The legacy Key_View_Label record detected in view '||r_views.view_label||
                                                                                ' for table_alias '||r_views.table_alias||
                                                                                ' already has a ROWID column for this table alias.  Skipping creation of the ROWID column.' );
            ELSE
                -- Insert the rowid column and flag that we did the insert.
                lb_ROWID_column_added_flag := TRUE;
                --
                INSERT INTO N_VIEW_COLUMN_TEMPLATES
                     ( T_COLUMN_ID, 
                       VIEW_LABEL, 
                       QUERY_POSITION, 
                       COLUMN_LABEL, 
                       TABLE_ALIAS, 
                       COLUMN_EXPRESSION, 
                       COLUMN_POSITION, 
                       COLUMN_TYPE, 
                       DESCRIPTION, 
                       REF_APPLICATION_LABEL, 
                       REF_TABLE_NAME, 
                       KEY_VIEW_LABEL, 
                       REF_LOOKUP_COLUMN_NAME, 
                       REF_DESCRIPTION_COLUMN_NAME, 
                       REF_LOOKUP_TYPE, 
                       ID_FLEX_APPLICATION_ID, 
                       ID_FLEX_CODE, 
                       GROUP_BY_FLAG, 
                       FORMAT_MASK, 
                       FORMAT_CLASS, 
                       GEN_SEARCH_BY_COL_FLAG, 
                       LOV_VIEW_LABEL, 
                       LOV_COLUMN_LABEL, 
                       PROFILE_OPTION, 
                       PRODUCT_VERSION, 
                       INCLUDE_FLAG, 
                       USER_INCLUDE_FLAG, 
                       CREATED_BY, 
                       CREATION_DATE, 
                       LAST_UPDATED_BY, 
                       LAST_UPDATE_DATE )     
                VALUES ( n_view_column_tmpl_seq.nextval     /* T_COLUMN_ID */,
                         r_views.view_label                 /* VIEW_LABEL */,
                         r_tables.query_position            /* QUERY_POSITION */,
                         substr(r_views.table_alias||'$'||r_views.key_view_label,1,30)   /* COLUMN_LABEL */,
                         r_views.table_alias                /* TABLE_ALIAS */,
                         'rowid'                            /* COLUMN_EXPRESSION */,
                         li_max_column_position+.01         /* COLUMN_POSITION */,
                         'ROWID'                            /* COLUMN_TYPE */,
                         'Customer generated ROWID column.' /* DESCRIPTION */,
                         TO_CHAR(NULL)                      /* REF_APPLICATION_LABEL */,
                         TO_CHAR(NULL)                      /* REF_TABLE_NAME */,
                         r_views.key_view_label             /* KEY_VIEW_LABEL */,
                         TO_CHAR(NULL)                      /* REF_LOOKUP_COLUMN_NAME */,
                         TO_CHAR(NULL)                      /* REF_DESCRIPTION_COLUMN_NAME */,
                         TO_CHAR(NULL)                      /* REF_LOOKUP_TYPE */,
                         TO_CHAR(NULL)                      /* ID_FLEX_APPLICATION_ID */,
                         TO_CHAR(NULL)                      /* ID_FLEX_CODE */,
                         r_tables.group_by_flag             /* GROUP_BY_FLAG */,
                         TO_CHAR(NULL)                      /* FORMAT_MASK */,
                         TO_CHAR(NULL)                      /* FORMAT_CLASS */,
                         'N'                                /* GEN_SEARCH_BY_COL_FLAG */,
                         TO_CHAR(NULL)                      /* LOV_VIEW_LABEL */,
                         TO_CHAR(NULL)                      /* LOV_COLUMN_LABEL */,
                         r_tables.profile_option            /* PROFILE_OPTION */,
                         r_tables.product_version           /* PRODUCT_VERSION */,
                         'Y'                                /* INCLUDE_FLAG */,
                         'Y'                                /* USER_INCLUDE_FLAG */,
                         'Customer KVL Conversion'          /* CREATED_BY */,
                         sysdate                            /* CREATION_DATE */,
                         'Customer KVL Conversion'          /* LAST_UPDATED_BY */,
                         sysdate                            /* LAST_UPDATE_DATE */ );
            END IF;
        END LOOP;  -- r_tables
        --
        -- Now generate a Join Key record if rowid's where added and it was not a baseview
        IF (     lb_ROWID_column_added_flag 
             AND NOT lb_baseview_flag         ) THEN
            
            SELECT n_join_key_templates_seq.nextval
              INTO li_jk_sequence
              FROM DUAL;

            li_ref_pk_t_join_key_id := NULL;
            li_fk_view_ref_count    := 0;
            IF ( r_views.view_label <> r_views.key_view_label ) THEN
                FOR r_pk in c_pk( r_views.key_view_label ) LOOP
                    li_ref_pk_t_join_key_id := r_pk.t_join_key_id;
                END LOOP;
            ELSE
                -- figure out how many times a referenced pk
                SELECT count(*)
                  INTO li_fk_view_ref_count
                  FROM n_join_key_templates fk,
                       n_join_key_templates pk
                 WHERE fk.view_label     = r_views.view_label
                   AND pk.t_join_key_id  = fk.referenced_pk_t_join_key_id
                   AND pk.view_label     = r_views.key_view_label;

            END IF;

            IF (     li_ref_pk_t_join_key_id is null
                 AND r_views.view_label      <> r_views.key_view_label ) THEN
                  noetix_utility_pkg.add_installation_message( ls_script,
                                                               ls_location,
                                                               'WARNING',
                                                               'Unable create a Join Key FK record for the view/key_view_label/column_label combination:  '||
                                                               r_views.view_label||'/'||r_views.key_view_label||'/'||substr(r_views.table_alias||'$'||r_views.key_view_label,1,30) );
                  rollback to add_join_key_record;
            ELSE
              BEGIN
                INSERT INTO n_join_key_templates
                     ( t_join_key_id,
                       view_label,
                       key_name,
                       description,
                       join_key_context_code,
                       key_type_code,
                       column_type_code,
                       outerjoin_flag,
                       outerjoin_direction_code,
                       key_rank,
                       pl_ref_pk_view_name_modifier,
                       pl_rowid_col_name_modifier,
                       key_cardinality_code,
                       referenced_pk_t_join_key_id,
                       product_version,
                       profile_option,
                       include_flag,
                       user_include_flag,
                       created_by,
                       creation_date,
                       last_updated_by,
                       last_update_date,
                       version_id             )
                VALUES 
                     ( li_jk_sequence,                   /* T_JOIN_KEY_ID */
                       r_views.view_label,               /* VIEW_LABEL */
                       ( CASE
                           WHEN (r_views.view_label = r_views.key_view_label ) THEN 'Custom ROWID_PK'
                           ELSE 'Custom ROWID_FK_'||r_views.table_alias||'_'||li_view_key_counter
                         END ),                          /* KEY_NAME */
                       ( CASE
                           WHEN (r_views.view_label = r_views.key_view_label ) THEN 'Custom ROWID_PK'
                           ELSE 'Custom ROWID_FK_'||r_views.table_alias||'_'||li_view_key_counter
                         END ),                          /* DESCRIPTION */
                       TO_CHAR(NULL),                    /* JOIN_KEY_CONTEXT_CODE */
                       ( CASE
                           WHEN ( r_views.view_label = r_views.key_view_label ) THEN 'PK'
                           ELSE 'FK'
                         END ),                          /* KEY_TYPE_CODE */
                       'ROWID',                          /* COLUMN_TYPE_CODE */
                       ( CASE
                           WHEN ( r_views.view_label = r_views.key_view_label ) THEN NULL
                           ELSE 'N'
                         END ),                              /* OUTERJOIN_FLAG */
                       TO_CHAR(NULL),                    /* OUTERJOIN_DIRECTION_CODE */
                       1,                                /* KEY_RANK */
                       ( CASE li_fk_view_ref_count
                           WHEN 0 THEN ''
                           ELSE r_views.table_alias
                         END ),                          /* PL_REF_PK_VIEW_NAME_MODIFIER */
                       ( CASE li_fk_view_ref_count
                           WHEN 0 THEN ''
                           ELSE r_views.table_alias
                         END ),                          /* PL_ROWID_COL_NAME_MODIFIER */
                       ( CASE
                           WHEN ( r_views.view_label = r_views.key_view_label ) THEN '1'
                           ELSE 'N'
                         END ),                          /* KEY_CARDINALITY_CODE */
                       li_ref_pk_t_join_key_id,          /* REFERENCED_PK_T_JOIN_KEY_ID */
                       TO_CHAR(NULL),                    /* PRODUCT_VERSION */
                       TO_CHAR(NULL),                    /* PROFILE_OPTION */
                       'Y',                              /* INCLUDE_FLAG */
                       'Y',                              /* USER_INCLUDE_FLAG */
                       'Legacy KVL Customization',       /* CREATED_BY */
                       sysdate,                          /* CREATION_DATE */
                       'Legacy KVL Customization',       /* LAST_UPDATED_BY */
                       sysdate,                          /* LAST_UPDATE_DATE */
                       TO_CHAR(NULL)                     /* VERSION_ID */ );
                
                -- Now add the column level record.
                INSERT INTO N_JOIN_KEY_COL_TEMPLATES 
                     ( T_JOIN_KEY_COLUMN_ID, 
                       T_JOIN_KEY_ID, 
                       T_COLUMN_POSITION, 
                       COLUMN_LABEL, 
                       KFF_TABLE_PK_COLUMN_NAME, 
                       CREATED_BY, 
                       CREATION_DATE, 
                       LAST_UPDATED_BY, 
                       LAST_UPDATE_DATE, 
                       VERSION_ID) 
                VALUES 
                     ( n_join_key_col_templates_seq.nextval,                            /* T_JOIN_KEY_COLUMN_ID */
                       li_jk_sequence,                                                  /* T_JOIN_KEY_ID */
                       1,                                                               /* T_COLUMN_POSITION */
                       substr(r_views.table_alias||'$'||r_views.key_view_label,1,30),   /* COLUMN_LABEL */
                       TO_CHAR(NULL),                                                   /* KFF_TABLE_PK_COLUMN_NAME */
                       'Legacy KVL Customization',                                      /* CREATED_BY */
                       sysdate,                                                         /* CREATION_DATE */
                       'Legacy KVL Customization',                                      /* LAST_UPDATED_BY */
                       sysdate,                                                         /* LAST_UPDATE_DATE */
                       TO_CHAR(NULL)                                                    /* VERSION_ID */ );
              EXCEPTION
                WHEN OTHERS THEN
                  noetix_utility_pkg.add_installation_message( ls_script,
                                                               ls_location,
                                                               'WARNING',
                                                               'Unable create a Join Key FK record for the view/key_view_label/column_label combination:  '||
                                                               r_views.view_label||'/'||r_views.key_view_label||'/'||substr(r_views.table_alias||'$'||r_views.key_view_label,1,30)||' ('||SQLERRM||' )' );
                  rollback to add_join_key_record;
              END;
            END IF;
        END IF;

    END LOOP;  -- r_views

    COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      noetix_utility_pkg.add_installation_message( ls_script,
                                                   ls_location,
                                                   'WARNING',
                                                   'Unable to convert key_view_labels.  ' || SQLERRM );
END;
/
update n_view_table_templates
set key_view_label =''
where view_label like 'OKE%' 
and key_view_label is not null;

commit;

SPOOL off

whenever sqlerror continue
whenever oserror  continue

-- END w_jointo_kvl_upgrade.sql
