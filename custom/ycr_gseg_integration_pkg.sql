-- Title  
--  ycr_gseg_integration_pkg.sql  
-- Function  
--   SEG package for global view integration 
--
-- Description  
--   SEG package for global view integration 
--           - All Global view integration
--           - Segexpr/segstruct integration
--           - Anomaly view integration
--           - Flexsource Direct view integration
--           - Answer integration
--   
--   Input parameters:
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved 
--
-- History  
--   28-Jul-09  Kranthi   Created.(Package Consolidation)
--   14-Oct-09  D Glancy  Add the show errors command.
--   16-Oct-09  C Kranthi Added keyview name check at column level for table replacement logic.
--   09-Nov-09  C Kranthi Segment formatting changes included. 
--   09-Nov-09  G Sriram  Removed the Source_Type filter in C5 Cursor to allow 'DC' and 'VIEW'. 
--   16-Nov-09  G Sriram  Minor changes to drive rendering of columns based on column properties. 
--   18-Nov-09  Sharas    Minor changes to the cursor c6 to handle single structure/single segment cases.
--   18-Nov-09  C Kranthi 1. Modifications to handle structure groups with overlapping structures.
--                           a.The C1_2 cursor is modified to address this issue.
--                           b.The segstruct_view procedure is modified to support the structure groups.
--                        2. In table replacement logic, Added nvl function on security_code column
--                           to verify for 'NONE' value too.
--  01-Dec-09   C Kranthi Initialize the l_column_position variable in dc_main_view procedure.
--  14-Dec-09   C Kranthi Exclude the KFF processing if its not available in flexsources
  --  18-Dec-09   C Kranthi Modified the anomaly_view procedure to retain original column for only anomaly column of the view.
--  05-Jan-10   C Kranthi Modified answer_int procedure to exclude the processing for legacy seg columns.
--  06-Jan-10   C Kranthi Added additional logic to process EXCLUDE_GLOBAL_HELPER_COLUMNS column property.
--                        excluding PRIMARY_KEY Columns, SEGMENT_NAME_LIST, STRUCTURE_NAME and Z$ columns
--                        (Issue 23076)
--  08-Jan-10   C Kranthi For source_type DIRECT, the seg column information should be shown only for respecitve structures.
--                        (Issue 23202)
--  25-Jan-10   C Kranthi Standardize on kff long name for flexfeilds.the CV column suffix should appear based on kff_long_name.
--                        The CV column suffix will be consistent accross the global views.
--                        (Issue 23280)
--   28-Jan-10  C Kranthi Modified anomaly processing to use column property check for legacy columns instead of id_flex_code.
--                        (Issue 23104)
--  09-Feb-10 H Schmedding Added the cur_apply_orig_column_name2 cursor and 
--                         processing to handle cases where the initial query
--                         does not return the kff columns. Modified as part of conversion change
--                         (Issue 23301)
--  11-Feb-10 C Kranthi    1. Insert column properties for single structure single segment,
--                         the INCLUDE_INDIV_SEGMENT_VALUES INCLUDE_INDIV_SEGMENT_DESC property is inserted selectively
--                         2. Added logic to remove Z$ column when segment value columns are available.
--                         (Issue 23101)
--  15-Feb-10 C Kranthi    The column name prefix derivation logic is modified.
--                         (Issue 23435)
--  16-Feb-10 G Sriram     logic to address duplicate column name issue is removed, 
--                         the duplicate column scenario might not exist during seg processing. 
--                         (Issue 23435)
--  19-Feb-10   Sharas     Z$ columns are not shown for SINGLE structure flexfields though the sv columns are not shown
--                         (Issue 23101)
--  22-Feb-10   Sharas     The pk column names of the ID_Flex_Code's POS and COST are reduced so that the generated column name should not exceed 30 characters.
--                         (Issue: 23432) 
--  24-Feb-10 C Kranthi    Added FA_Adjustments_SLA_GL_Je view for anomaly processing.
--                         (Issue 23361)
--  04-Mar-10 G Sriram     Individual segments are enabled for a flexfield using hook script(wnoetx_gseg_flex_kff_cols.sql) the z$ columns are rendered in 
--                         the global view.
--  16-Jun-10   Sharas     23101 fallout fixed.
--                         (Issue 24471) 
--  23-Sep-10   Kranthi    Anomaly processing fixed.
--                         (Issue 25260)
--  09-Feb-10   P Upendra  Added INV_Item_Demand_Seg_Base view for anomaly processing. 
--                         (Issue 25505) 
--  22-Feb-11   V Krishna  Added OE_Non_Ord_Category_Base view for anomaly processing. 
--                         (Issue 25561) 
--  31-Mar-11   D Glancy   Initialize Global Variables.
--  20-May-11   D Glancy   Wrong table specified in type declaration.
--  10-Jun-11   V Krishna  Removed the anomaly process for OE_Non_Ord_Category_Base view. 
--  10-Jun-11   Srini      Modifed the view label from EAM_WO_Actual_Cost_Dtls to EAM_WO_Actual_Cost_Details in the anamoly processing.
--  08-Nov-11   D Glancy   Use more consistent method of defining package version.  Make it easier to find the replacement version.
--  22-Jul-11   P Upendra  Added Anomaly code for BOM_Current_Structured_Bills
--  11-Nov-11   K Kondaveeti  Updated the  Anomaly code for BOM_Current_Structured_Bills
--                         (Issue 18791)
--  14-Aug-12   D Glancy   Add support for new n_join_key% structures.
--                         (Issue 28846)
--  14-Sep-12   S korrapati Added GL_SLA_Pa_Revenue_Dist, PA_SLA_Rev_Distributions views for anomaly processing.
--                          (Issues : 30463, 30446 )
--  25-Apr-13   D Glancy    Added the ability to set dbms_output.enable to unlimited for 10.2+ databases.  
--  21-Aug-13   D Glancy   When BOM_CURRENT_STRUCTURE_BILLS is included and the system_item kff segment name is changed
--                         to include special characters, the view fails to compile.  That is because we are not using the
--                         target segment name field to lookup the proper column name.  
--                         (Issue 33224)
--  29-Oct-13 D Glancy     EBS 12.2 support.
--                         (Issue 33617)
--  05-Jan-14  D Glancy    EBS 12.2. support.  Added metadata_table_name and metadata_ref_table_name to the gseg scripts.
--                         (Issue 33617)
--  07-Jan-14  D Glancy    EBS 12.2. support.  Anomoly process was not working.  Needed to revert some changes where we used metadata_table_name 
--                         in place of table_name as the metadata_table_name references the original EBS table, but we wanted to reference the
--                         target table_name in Noetix_sys instead.  Also did a little more cleanup for readability and standards.
--                         Added the Z$$ column if necessary.
--                         (Issue 33617)
--  02-Apr-14 D Glancy     Metadata_table_name should be the same as the table_name column in n_View_tables if the table_name is an "XXK%" table/view.
--                         (Issue 34330)
--  01-nov-14 Kmaddireddy  Added support to BOM_CURRENT_STRUCT_BASE view as like BOM_CURRENT_STRUCTURE_BILLS.
--                     (Issue 34627/NV-143)
--  19-Feb-15 Usha         Modified dc_main_view procedure to populate lov related metadata.
--                        (Issue NV-192)     
--   31-Mar-15 Madhu V    Added code for IR processing.
--                        
--  17-Mar-15 K Kandrakula  Modified segstruct_view procedure to populate SEGMENT%FROM KFF related metadata for FV_SLA_Budget_RPR_Trans View and 	--   						XLA_FV_Budget_RPR_Trans View.
--                     (Issue NV-560)
--  16-Jun-15 KKandrkaula  Modified anomaly_view procedure to populate LOV metadata.
--						   (Issue NV-1077)
--  26-Jun-15 Vchilukuri  Modified Update statement to isolate OE_Non_Orderable_Items view for item_category column.
--						   (Issue NV-1086)
--  18-Feb-17 Srinivas Akula Added WIP_Routings_Hydra_QCP_Vsat view for anomaly processing. 				
--
CREATE OR REPLACE PACKAGE n_gseg_integration_pkg AUTHID DEFINER IS
   
   FUNCTION get_version
      RETURN VARCHAR2;

   ---
   ---
   -- Turns Off Debug Mode
   PROCEDURE debug_off;

   ---
   FUNCTION debug_off
      RETURN INTEGER;

   ---
   -- Turns On Debug Mode
   PROCEDURE debug_on;

   ---
   FUNCTION debug_on
      RETURN INTEGER;

   ---
   -- Prints the message out for the debug mode.
   -- i_message      - The message
   -- i_output_type
   --      'ALL'  - All output types.  Basically both dbms_output and SM_Messages.
   --      'TEXT' - Output to dbms_output.
   --      'DB'   - Store the message in the messages table.
   -- i_location     - Additional location information.
   PROCEDURE DEBUG (
      i_message       IN   VARCHAR2,
      i_output_type   IN   VARCHAR2 DEFAULT 'DB',
      i_location      IN   VARCHAR2 DEFAULT 'DEBUG'
   );

   --
   PROCEDURE add_debug_message (
      i_script_name     n_installation_messages.script_name%TYPE,
      i_location        n_installation_messages.LOCATION%TYPE,
      i_message         n_installation_messages.MESSAGE%TYPE,
      i_creation_date   n_installation_messages.creation_date%TYPE DEFAULT SYSDATE   );

   PROCEDURE dc_main_view;

   PROCEDURE segstruct_view;

   PROCEDURE anomaly_view;

   PROCEDURE flexsource_direct;

   PROCEDURE answer_int;
   
END n_gseg_integration_pkg;
/

SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY n_gseg_integration_pkg IS
   --
   gc_pkg_version   CONSTANT    VARCHAR2(30)                        := '6.5.1.1565';
   --
   gc_script        CONSTANT    VARCHAR2(200)                       := 'n_gseg_integration_pkg';
   gc_process_type  CONSTANT    VARCHAR2(100)                       := 'GSEG';
   gc_user          CONSTANT    VARCHAR2(30)                        := user;
   --
   g_debug_flag                 BOOLEAN                             := FALSE;
   g_location                   VARCHAR2(200)                       := NULL;
   g_error_text                 VARCHAR2(200)                       := NULL;
   g_segment_name               n_f_kff_segments.segment_name%TYPE  := NULL;
   g_sv_column_flag             BOOLEAN                             := FALSE;

----------------------------------------------------------
--Cursor Delaration for usage across procedures
----------------------------------------------------------
   CURSOR detect_multi_seg ( p_data_table_key    VARCHAR2,
                             p_value_view_name   VARCHAR2,
                             p_desc_view_name    VARCHAR2   )   IS
   SELECT data_table_key,
          ( CASE
              WHEN seg_cnt = 1
                 THEN 'N'
              ELSE 'Y'
            END )           multi_seg_detected
     FROM ( SELECT seg.data_table_key,
                   COUNT (*)            seg_cnt
              FROM n_f_kff_segments             seg,
                   n_f_kff_structure_groups     str,
                   n_f_kff_struct_grp_flex_nums nums
             WHERE seg.data_table_key           = p_data_table_key
               AND
                 (    str.value_view_name       = p_value_view_name
                   OR str.description_view_name = p_desc_view_name        )
               AND str.structure_group_id       = nums.structure_group_id(+)
               AND str.data_table_key           = seg.data_table_key
               AND NVL( nums.id_flex_num, seg.id_flex_num)
                                                = seg.id_flex_num
             GROUP BY seg.data_table_key);

    rec_multi_seg        detect_multi_seg%ROWTYPE;

    --derive additional for data_table_key
    CURSOR c2 ( p_flex_code         VARCHAR2,
                p_flex_appl_id      VARCHAR2,
                p_data_appl_table   VARCHAR2,
                p_str_grp           VARCHAR2 DEFAULT 'ALL',
                p_data_table_key    NUMBER   DEFAULT NULL    ) IS
    SELECT fs.id_flex_code,
           fs.id_flex_application_id,
           fs.data_application_table_name,
           fs.data_application_table_name_ev,
           kff_structure_iden_source_col structure_id_col,
           fst.table_replacement_allowed_flag,
           fs.data_table_key,
           fs.source_type,
           str.group_type,
           str.value_view_name seg_view,
           fst.kff_table_pk1,
           str.description_view_name segd_view,
           LTRIM( RTRIM( n_gseg_utility_pkg.format_kff_segment( ff.flexfield_name ),
                         '_' ),
                  '_'     )                 flexfield_name,
           ff.kff_cols_in_global_view_flag,
           TRIM( REPLACE( ff.flexfield_name, 'Flexfield' ) ) kff_name
      FROM n_kff_flex_source_templates fst,
           n_f_kff_flex_sources fs,
           n_f_kff_structure_groups str,
           n_f_kff_flexfields ff
     WHERE fst.id_flex_code                 = NVL( p_flex_code, fst.id_flex_code )
       AND fst.id_flex_application_id       = NVL( p_flex_appl_id, fst.id_flex_application_id )
       AND fst.data_application_table_name  = NVL( p_data_appl_table,
                                                   fst.data_application_table_name )
       AND fst.id_flex_application_id       = fs.id_flex_application_id
       AND fst.id_flex_code                 = fs.id_flex_code
       AND fst.id_flex_application_id       = ff.id_flex_application_id
       AND fst.id_flex_code                 = ff.id_flex_code
       AND fst.data_application_id          = fs.data_application_id
       AND fst.data_application_table_name  = fs.data_application_table_name
       AND fs.data_table_key                = NVL( p_data_table_key, fs.data_table_key )
       AND str.data_table_key(+)            = fs.data_table_key
       AND str.group_type(+)                = p_str_grp;

    r2                   c2%ROWTYPE;

    CURSOR c3 (p_app_label VARCHAR2) IS
    SELECT *
      FROM n_application_owners
     WHERE application_label = p_app_label;

    r3                   c3%ROWTYPE;

    CURSOR c3_1 (p_flex_code VARCHAR2, p_flex_appl_id VARCHAR2) IS
    SELECT kff_short_name, kff_processing_type
      FROM n_kff_processing_templates pt
     WHERE pt.id_flex_application_id = p_flex_appl_id
       AND pt.id_flex_code      = p_flex_code;

    r3_1                 c3_1%ROWTYPE;

    --retrieve column properites
    CURSOR col_prop_cur ( p_view_name    VARCHAR2,
                          p_column_label VARCHAR2,
                          p_qry_pos      NUMBER         ) IS
    SELECT colp.view_name,
           colp.query_position,
           col.column_name,
           col.column_label,
           col.column_id,
           col.t_column_id,
           COUNT( CASE
                    WHEN (    (    (     ptype.property_type  = 'INCLUDE_STRUCTURE'
                                     AND colp.value1               IS NULL
                                     AND colp.value2               IS NULL        )
                                OR (     ptype.property_type = 'INCLUDE_STRUCTURE'
                                     AND colp.value1 LIKE '%&%'                            )  )
                           OR NOT EXISTS
                            ( SELECT 'X'
                                FROM n_view_properties         colp1,
                                     n_property_type_templates ptype1
                               WHERE colp1.source_pk_id           = colp.source_pk_id
                                 AND ptype1.property_type_id      = colp1.property_type_id
                                 AND ptype1.templates_table_name  = 'N_VIEW_COLUMN_TEMPLATES'
                                 AND ptype1.property_type         = 'INCLUDE_STRUCTURE' ) )
                         THEN NULL
                    WHEN (     ptype.property_type = 'INCLUDE_STRUCTURE'
                           AND (          colp.value1 NOT LIKE '%&%'
                                 OR (     colp.value1 IS NULL
                                      AND colp.value2 IS NOT NULL   ) ) )
                         THEN 1
                    ELSE NULL
                  END         )                 include_structure_count,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_CONCAT_SEGMENT_DESC' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_desc,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_CONCAT_SEGMENT_VALUES' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_val,
               COUNT( CASE ptype.property_type
                        WHEN 'INCL_CONCAT_PARENT_SEG_DESC' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_pdesc,
               COUNT( CASE ptype.property_type
                        WHEN 'INCL_CONCAT_PARENT_SEG_VALUES' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_pval,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_INDIV_SEGMENT_DESC' THEN 1
                        ELSE NULL
                      END     )                 include_indiv_seg_desc,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_INDIV_SEGMENT_VALUES' THEN 1
                        ELSE NULL
                      END     )                 include_indiv_seg_val,
               COUNT( CASE ptype.property_type
                        WHEN 'EXCLUDE_GLOBAL_HELPER_COLUMNS' THEN 1
                        ELSE NULL
                      END     )                 exclude_helper_columns,
               COUNT( CASE
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1            = 'PRIMARY_KEY'
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_primary_key_col,
               COUNT( CASE
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1            = 'STRUCTURE_NAME'
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_structure_name_col,
               COUNT( CASE
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1            = 'SEGMENT_NAME_LIST'
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_segment_name_list_col,
               COUNT( CASE
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1         LIKE 'Z$%'
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_z$_col,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_QUALIFIER' THEN 1
                        ELSE NULL
                      END     )                 include_qualifier_count,
               COUNT( CASE
                        WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                               AND value2                    = 'Y'  )    THEN 1
                        ELSE NULL
                      END     )                 include_qualifier_val,
               COUNT( CASE
                        WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                               AND value3                    = 'Y'  )    THEN 1
                        ELSE NULL
                      END     )                 include_qualifier_desc
          FROM n_view_properties         colp,
               n_property_type_templates ptype,
               n_view_columns            col
         WHERE col.view_name                = p_view_name
           AND col.query_position           = p_qry_pos
           AND col.column_label             = p_column_label
           AND col.column_type           LIKE 'SEG%'
           AND colp.view_name               = p_view_name
           AND colp.query_position          = p_qry_pos
           AND colp.view_name               = col.view_name
           AND colp.query_position          = col.query_position
           AND colp.source_pk_id            = col.column_id
           AND ptype.property_type_id       = colp.property_type_id
           AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
      GROUP BY colp.view_name,
               colp.query_position,
               col.column_id,
               col.t_column_id,
               col.column_name,
               col.column_label;



    col_prop_rec         col_prop_cur%ROWTYPE;

    --given the data table key, this cursor gets the concatenated source expressions for the segment list
    CURSOR c4 ( p_data_table_key              VARCHAR2,
                p_col_type                    VARCHAR2,
                p_processing_type             VARCHAR2,
                p_md_struct_constraint_type   VARCHAR2,
                p_multi_seg_detected          VARCHAR2,
                p_exclude_helper_columns      NUMBER,
                p_include_concat_seg_val      NUMBER,
                p_include_concat_seg_pval     NUMBER,
                p_include_concat_seg_desc     NUMBER,
                p_include_concat_seg_pdesc    NUMBER   ) IS
    SELECT DISTINCT
           kcat.concatenation_type,
           kcat.target_column_name,
           kcat.formatted_column_name,
           ( CASE
               WHEN ( kcat.concatenation_type = 'LIST'  ) THEN 1
               WHEN ( kcat.concatenation_type = 'VAL'   ) THEN 2
               WHEN ( kcat.concatenation_type = 'PVAL'  ) THEN 3
               WHEN ( kcat.concatenation_type = 'DESC'  ) THEN 4
               WHEN ( kcat.concatenation_type = 'PDESC' ) THEN 5
               ELSE NULL
             END                             ) l
      FROM n_f_kff_concatenations kcat
     WHERE kcat.data_table_key = p_data_table_key
---Do not bring in the segment list column, if EXLCUDE_GLOBAL_HELPER_COLUMNS mentioned for the column property
       AND ( CASE
               WHEN (         kcat.concatenation_type           = 'LIST'
                      AND (     p_processing_type          = 'SOURCED'
                            AND p_md_struct_constraint_type    != 'SINGLE'
                            AND p_exclude_helper_columns        = 0  ) )  THEN 1
---Bring in the concatenated value column, if corresponding property (INCLUDE_CONCAT_SEGMENT_VALUES)exists
               WHEN (      kcat.concatenation_type = 'VAL'
                       AND p_include_concat_seg_val > 0
                       AND
                         (    (     p_processing_type = 'SINGLE'
                                AND p_multi_seg_detected = 'Y' )
                           OR (     p_processing_type = 'SOURCED'
                                AND p_multi_seg_detected = 'Y'
                                AND p_md_struct_constraint_type = 'SINGLE' )
                           OR (     p_processing_type = 'SOURCED'
                                AND p_md_struct_constraint_type <> 'SINGLE' ) ) ) THEN 2
---Bring in the concatenated parent value column, if corresponding property (INCL_CONCAT_PARENT_SEG_VALUES)exists
               WHEN (     kcat.concatenation_type   = 'PVAL'
                      AND p_include_concat_seg_pval > 0 )                         THEN 3
---Bring in the concatenated description column, if corresponding property (INCLUDE_CONCAT_SEGMENT_DESC)exists
               WHEN (     kcat.concatenation_type = 'DESC'
                      AND p_include_concat_seg_desc > 0
                      AND (    (     p_processing_type    = 'SINGLE'
                                 AND p_multi_seg_detected = 'Y'  )
                            OR (     p_processing_type           = 'SOURCED'
                                 AND p_multi_seg_detected        = 'Y'
                                 AND p_md_struct_constraint_type = 'SINGLE')
                            OR (     p_processing_type = 'SOURCED'
                                 AND p_md_struct_constraint_type <> 'SINGLE' ) ) ) THEN 4
---Bring in the concatenated description column, if corresponding property (INCL_CONCAT_PARENT_SEG_DESC)exists
               WHEN (     kcat.concatenation_type    = 'PDESC'
                      AND p_include_concat_seg_pdesc > 0   )                       THEN 5
             END  ) IS NOT NULL
     ORDER BY l;

    --Deriving Structure
    CURSOR c4_1( p_processing_type             VARCHAR2,
                 p_md_struct_constraint_type   VARCHAR2,
                 p_exclude_helper_columns      NUMBER               ) IS
    WITH DATA AS
       ( SELECT LEVEL lvl
           FROM DUAL
        CONNECT BY LEVEL < 2 )
    SELECT ( CASE
               WHEN ROWNUM = 2
                  THEN 'Structure_ID'
               WHEN ROWNUM = 1
                  THEN 'Structure_Name'
            END
           ) struct_column
      FROM DATA
     WHERE ( CASE
               WHEN (     p_processing_type            = 'SOURCED'
                      AND p_md_struct_constraint_type != 'SINGLE'
                      AND p_exclude_helper_columns     = 0 ) THEN 1
               ELSE NULL
             END           ) = 1;

    --Deriving Qualifier columns
    CURSOR c4_2( p_data_table_key   VARCHAR2,
                 p_view_name        VARCHAR2,
                 p_column_ID        INTEGER,
                 p_qry_pos          NUMBER   ) IS
    WITH DATA AS
       ( SELECT LEVEL lvl
           FROM DUAL
        CONNECT BY LEVEL <= 2 )
    SELECT DISTINCT
           segment_prompt,
           ( CASE
               WHEN (     lvl         = 1
                      AND colp.value2 = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_val_pfx ||
                                                   '$' || REPLACE( REPLACE( segment_prompt,
                                                                            ' Segment' ),
                                                                   ' ', '_' )
               WHEN (     lvl         = 2
                      AND colp.value3 = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_desc_pfx ||
                                                   '$' || REPLACE( REPLACE( segment_prompt,
                                                                            ' Segment' ),
                                                                   ' ', '_' )
             END )          qual_col_name,
           segment_attribute_type
      FROM n_f_kff_seg_qual_helper_view hv,
           DATA,
           n_property_type_templates ptype,
           n_view_properties         colp
      WHERE data_table_key              = p_data_table_key
        AND colp.view_name              = p_view_name
        AND colp.source_pk_id           = p_column_id
        AND colp.query_position         = p_qry_pos
        AND ptype.property_type_id      = colp.property_type_id
        AND ptype.templates_table_name  = 'N_VIEW_COLUMN_TEMPLATES'
        AND ( CASE
                WHEN ( ptype.property_type = 'INCLUDE_QUALIFIER'     ) THEN colp.value1
                WHEN ( ptype.property_type = 'INCLUDE_ALL_QUALIFIER' ) THEN segment_attribute_type
                ELSE NULL
              END  ) = segment_attribute_type
        AND ( CASE
                WHEN (     lvl         = 1
                       AND colp.value2 = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_val_pfx ||
                                                    '$' || REPLACE( REPLACE( segment_prompt,
                                                                             ' Segment' ),
                                                                    ' ', '_' )
                WHEN (     lvl          = 2
                       AND colp.value3  = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_desc_pfx ||
                                                     '$' || REPLACE( REPLACE( segment_prompt,
                                                                              ' Segment' ),
                                                                     ' ', '_' )
                ELSE NULL
             END  )                 IS NOT NULL
      ORDER BY segment_prompt;

--given the data key, this cursor retrieves the primary key(s) for the data application table
    CURSOR c5( p_data_table_key           VARCHAR2,
               p_process_type_code        VARCHAR2,
               p_exclude_helper_columns   NUMBER    ) IS
    WITH DATA AS
       ( SELECT LEVEL lvl
           FROM DUAL
        CONNECT BY LEVEL <= 3 )
    SELECT data_table_key,
           lvl                  col_seq,
           ( CASE
               WHEN ( lvl = 1 ) THEN kff_table_pk1
               WHEN ( lvl = 2 ) THEN kff_table_pk2
               WHEN ( lvl = 3 ) THEN kff_table_pk3
               ELSE NULL
             END        )       kff_pk,
           fs.id_flex_code
      FROM DATA,
           n_kff_flex_source_templates  pt,
           n_f_kff_flex_sources         fs
     WHERE ( CASE
               WHEN ( lvl = 1 ) THEN kff_table_pk1
               WHEN ( lvl = 2 ) THEN kff_table_pk2
               WHEN ( lvl = 3 ) THEN kff_table_pk3
               ELSE NULL
             END ) IS NOT NULL
       AND fs.data_table_key                = p_data_table_key
       AND pt.id_flex_application_id        = fs.id_flex_application_id
       AND pt.id_flex_code                  = fs.id_flex_code
       AND pt.data_application_id           = fs.data_application_id
       AND pt.data_application_table_name   = fs.data_application_table_name
       --AND fs.source_type = 'DC'
       AND (    p_exclude_helper_columns    = 0
             OR p_process_type_code         = 'WHERE'  )
    ORDER BY data_table_key;

---------------------------------------------------------------------------------------
 -- Define the procedures and functions
 ---------------------------------------------------------------------------------------
    FUNCTION get_version
      RETURN VARCHAR2 IS
    BEGIN
        return gc_pkg_version;
    END get_version;

--
-------------------------------------
--
-- Turns On Debug Mode
    PROCEDURE debug_on IS
    BEGIN
        IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN
            dbms_output.enable(NULL);
        ELSE
            dbms_output.enable(1000000);
        END IF;
        g_debug_flag := TRUE;
    END;

-------------------------------------
--
-- Turns On Debug Mode
    FUNCTION debug_on
      RETURN INTEGER IS
    BEGIN
        IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN
            dbms_output.enable(NULL);
        ELSE
            dbms_output.enable(1000000);
        END IF;
        g_debug_flag := TRUE;
        RETURN 1;
    END;

    --
    -- Turns Off Debug Mode
    PROCEDURE debug_off IS
    BEGIN
        DBMS_OUTPUT.DISABLE;
        g_debug_flag := FALSE;
    END;

    --
    -- Turns Off Debug Mode
    FUNCTION debug_off
      RETURN INTEGER IS
    BEGIN
        DBMS_OUTPUT.DISABLE;
        g_debug_flag := FALSE;
        RETURN 0;
    END;

    --
    -- Prints the message out for the debug mode.
    -- i_message      - The message
    -- i_output_type
    --      'ALL'  - All output types.  Basically both dbms_output and SM_Messages.
    --      'TEXT' - Output to dbms_output.
    --      'DB'   - Store the message in the messages table.
    -- i_location     - Additional location information.
    PROCEDURE DEBUG ( i_message       IN   VARCHAR2,
                      i_output_type   IN   VARCHAR2 DEFAULT 'DB',
                      i_location      IN   VARCHAR2 DEFAULT 'DEBUG'    )   IS
    BEGIN
        IF( g_debug_flag ) THEN
            IF ( i_output_type IN ('ALL', 'TEXT') )  THEN
                IF ( LENGTHB( i_message ) > 255 ) THEN
                    DBMS_OUTPUT.put_line( 'The following message was truncated:' );
                END IF;
                DBMS_OUTPUT.put_line( SUBSTRB(i_message, 1, 255) );
            END IF;

            IF ( i_output_type IN ('ALL', 'DB') ) THEN
                n_sec_manager_api_pkg.add_sm_message( i_script_name       => gc_script || '.' || g_location,
                                                      i_location          => NVL( i_location,
                                                                                  g_location ),
                                                      i_message_type      => 'DEBUG',
                                                      i_message           => i_message  );
            END IF;
        END IF;
    END;

    PROCEDURE add_debug_message( i_script_name     n_installation_messages.script_name%TYPE,
                                 i_location        n_installation_messages.LOCATION%TYPE,
                                 i_message         n_installation_messages.MESSAGE%TYPE,
                                 i_creation_date   n_installation_messages.creation_date%TYPE DEFAULT SYSDATE  ) IS
    BEGIN
        IF (g_debug_flag) THEN
            noetix_utility_pkg.add_installation_message( i_script_name,
                                                         i_location,
                                                         'DEBUG',
                                                         i_message,
                                                         i_creation_date,
                                                         gc_process_type );
        END IF;
    END add_debug_message;

   FUNCTION identify_join_operator( i_view_name      VARCHAR2,
                                    i_query_position NUMBER,
                                    i_table_alias    VARCHAR2,
                                    i_kff_pk1        VARCHAR2 )
     RETURN NUMBER IS

       l_lhs_where        VARCHAR2 (500);
       l_rhs_where        VARCHAR2 (500);
       l_outer_join_ctr   NUMBER;

       CURSOR cur_view_kff_joins IS
       SELECT where_clause
         FROM n_view_wheres
        WHERE view_name = i_view_name
          AND query_position = i_query_position
          AND INSTR (where_clause, '(+)') > 0
          AND (    ( UPPER( where_clause ) LIKE
                            '%'
                         || UPPER( i_table_alias )
                         || '.'
                         || UPPER( i_kff_pk1 )
                         || '%=%'
                     )
                OR ( UPPER( where_clause ) LIKE
                            '%=%'
                         || UPPER( i_table_alias )
                         || '.'
                         || UPPER( i_kff_pk1 )
                         || '%'
                     )
                 );

    BEGIN
      l_outer_join_ctr := 0;

      FOR rec_c IN cur_view_kff_joins LOOP
         l_lhs_where      := SUBSTRB( rec_c.where_clause, 1, INSTRB(rec_c.where_clause, '=' ) - 1);

         l_rhs_where      := SUBSTRB( rec_c.where_clause, INSTRB(rec_c.where_clause, '=' ) + 1, LENGTHB(rec_c.where_clause));
         l_outer_join_ctr := l_outer_join_ctr +
                             ( CASE
                                 WHEN (     (     UPPER( l_lhs_where ) LIKE
                                                       '%'||UPPER(i_table_alias) || '.' || UPPER(i_kff_pk1)||'%'
                                              AND INSTR( l_lhs_where, '(+)' ) > 0 )
                                        OR  (     UPPER( l_rhs_where ) LIKE
                                                       '%'||UPPER(i_table_alias) || '.' || UPPER(i_kff_pk1)||'%'
                                              AND INSTR( l_rhs_where, '(+)') > 0 ) )
                                        THEN 1
                                 ELSE 0
                               END );
      END LOOP;

      RETURN l_outer_join_ctr;
    END identify_join_operator;
---------------------------------------------------------------------
--
-- Procedure Name: dc_main_view
--
-- Description
--   For all the SEG related views, populates the data cache views metadata into non-template tables.
--   The procedure populates the seg related metdata into non-template table like columns, tables etc.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE dc_main_view
   IS
      l_replace_table               BOOLEAN;
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_error_code                  NUMBER                            := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                     := 'SUCCESS';
      l_error_status                VARCHAR2 (1000)                   := 'ERROR';
      l_in_process_status           VARCHAR2 (30)                     := 'IN-PROCESS';
      l_error_number                NUMBER                            := NULL;
      l_tab_alias_ctr               BINARY_INTEGER                    := 0;
      l_column_position             NUMBER                            := 0;
      l_where_position              NUMBER                            := 0;
      l_tab_alias                   VARCHAR2 (20)                     := NULL;
      l_stat_tab_alias              VARCHAR2 (10)                     := NULL;
      l_stat_tab_name               VARCHAR2 (30)                     := NULL;
      l_stat_acct_col_name          VARCHAR2 (30)                     := NULL;
      l_table_name                  VARCHAR2 (30)                     := NULL;
      l_column_name                 VARCHAR2 (30)                     := NULL;
      l_column_expr                 VARCHAR2 (1000)                   := NULL;
      l_where_clause                VARCHAR2 (500)                    := NULL;
      l_dff_col_ctr                 BINARY_INTEGER                    := 0;
      l_other_col_ctr               BINARY_INTEGER                    := 0;
      l_other_col_where_ctr         BINARY_INTEGER                    := 0;
      l_keyview_ctr                 BINARY_INTEGER                    := 0;
      l_outerjoin                   VARCHAR2 (10);
      l_column_exists               BINARY_INTEGER;
      l_column_name_prefix          VARCHAR2 (30)                     := NULL;
      l_md_struct_constraint_type   VARCHAR2 (20);
      l_col_description             n_view_columns.description%TYPE   := NULL;
      l_id_flex_num                 n_f_kff_segments.id_flex_num%TYPE;
      l_source_value                NUMBER;
      l_dup_column_exists           BINARY_INTEGER                    := 0;
      l_column_property_type        VARCHAR2 (200);
      l_property_type_id            n_view_properties.property_type_id%TYPE;
      l_t_view_property_id          n_view_properties.t_view_property_id%TYPE;
      l_view_property_id            n_view_properties.view_property_id%TYPE;
      l_column_id                   n_view_columns.column_id%TYPE;
      l_t_column_id                 n_view_columns.t_column_id%TYPE;


---Determine the column first
      CURSOR c1  IS
      SELECT  c.column_ID,
              c.t_column_id,
              c.view_name,
              c.query_position,
              c.column_label,
              c.table_alias,
              c.column_name,
              t.from_clause_position,
              c.column_position,
              t.table_name,
              t.metadata_table_name,
              c.id_flex_code,
              ( CASE
                  WHEN (     c.id_flex_application_id = 800
                         AND c.id_flex_code           = 'COST' ) THEN 801
                  WHEN (     c.id_flex_application_id = 800
                         AND c.id_flex_code           = 'BANK' ) THEN 801
                  WHEN (     c.id_flex_application_id = 800
                         AND c.id_flex_code           = 'GRP'  ) THEN 801
                  ELSE c.id_flex_application_id
                END     )                                           id_flex_application_id,
               c.column_type,
               v.special_process_code,
               v.security_code,
               v.view_label,
               v.application_instance,
         c.lov_view_label, --added NV-192
               c.lov_view_name,--added NV-192
               c.lov_column_label,--added NV-192
               c.group_by_flag,
               c.key_view_name,
               c.key_view_label,
               c.profile_option,
               ( SELECT ct.description
                   FROM n_view_column_templates ct
                  WHERE ct.view_label                          = c.view_label
                    AND ct.query_position                      = c.query_position
                    AND ct.column_label                        = c.column_label
                    AND REPLACE(ct.column_type, 'KEY', 'SEG')  = c.column_type
                    AND NVL(ct.profile_option, 'XX')           = NVL(c.profile_option, 'XX')
                    AND ROWNUM                                 = 1   ) description
          FROM n_view_columns    c,
               n_view_tables     t,
               n_views           v
         WHERE c.column_type         LIKE 'SEG%'
           AND c.column_type       NOT IN ('SEGP', 'SEGEXPR', 'SEGSTRUCT')
           AND c.application_instance   = 'G0'
           --AND c.generated_flag = 'N'
           AND c.view_name              = t.view_name
           AND c.query_position         = t.query_position
           AND c.table_alias            = t.table_alias
           AND c.view_name              = v.view_name
           AND t.view_name              = v.view_name
           AND NVL (c.omit_flag, 'N')   = 'N'
           AND NVL (t.omit_flag, 'N')   = 'N'
           AND NVL (v.omit_flag, 'N')   = 'N'
           AND NVL (v.omit_flag, 'N')   = NVL (t.omit_flag, 'N')
           AND NVL (v.omit_flag, 'N')   = NVL (c.omit_flag, 'N')
           AND NVL (c.omit_flag, 'N')   = NVL (t.omit_flag, 'N')
           -- AND v.application_label IN ('GL', 'HXC')
           --AND v.view_name = 'HRG0_Applicant_Hist'
           AND EXISTS
             ( SELECT 1
                 FROM n_f_kff_flex_sources fs
                WHERE fs.id_flex_code = c.id_flex_code )
           AND NOT EXISTS
             ( SELECT 'x'
                 FROM n_view_columns subc
                WHERE v.view_name                = subc.view_name
                  AND NVL (subc.omit_flag, 'N')  = 'N'
                  AND c.query_position          != subc.query_position
                  AND subc.column_type           = 'SEGSTRUCT')
           AND NOT EXISTS
             ( SELECT 1
                 FROM n_f_kff_flex_sources fs
                WHERE fs.id_flex_code                = c.id_flex_code
                  AND fs.data_application_table_name = t.metadata_table_name
                  AND fs.source_type                 = 'DIRECT'
                  AND fs.id_flex_application_id      =
                    ( CASE
                        WHEN (     c.id_flex_application_id = 800
                               AND c.id_flex_code IN ('COST', 'BANK', 'GRP') ) THEN 801
                        ELSE c.id_flex_application_id
                      END   ))
      ORDER BY c.column_type, c.view_name, c.query_position, c.column_label;

      CURSOR c1_2( p_data_table_key   NUMBER,
                   p_view_name        VARCHAR2,
                   p_column_NAME      VARCHAR2,
                   p_qry_pos          NUMBER      )    IS
      SELECT data_table_key,
             group_type,
             subset_type,
             value_view_name seg_view,
             description_view_name segd_view
        FROM n_f_kff_strgrp_view_xref   hlp,
             n_view_properties          colp,
             n_view_columns             col,
             n_property_type_templates  ptype
       WHERE COL.column_name                         = p_column_name
         AND col.view_name                           = p_view_name
         AND col.query_position                      = p_qry_pos
         AND hlp.data_table_key                      = p_data_table_key
         AND colp.view_name                          = p_view_name
         AND colp.query_position                     = p_qry_pos
         AND colp.view_name                          = col.view_name
         AND colp.query_position                     = col.query_position
         and colp.source_pk_id                       = col.column_id
         AND NVL(hlp.column_label,col.column_label)  = col.column_label
         AND NVL(hlp.view_name,col.view_name)        = col.view_name
         AND ptype.property_type_id                  = colp.property_type_id
         AND ptype.templates_table_name              = 'N_VIEW_COLUMN_TEMPLATES'
         AND group_type =
                   ( CASE
                       WHEN (     PTYPE.property_type     = 'INCLUDE_STRUCTURE'
                              AND colp.value1              IS NOT NULL
                              AND colp.value1            NOT LIKE '%&%'         )               THEN 'SUBSET'
                       WHEN (     PTYPE.property_type     = 'INCLUDE_STRUCTURE'
                              AND colp.value2              IS NOT NULL
                              AND colp.value1                  IS NULL )                        THEN 'SUBSET'
                       WHEN (    (   (     PTYPE.property_type  = 'INCLUDE_STRUCTURE'
                                      AND colp.value1               IS NULL
                                      AND colp.value2               IS NULL    )
                                  OR (     PTYPE.property_type  = 'INCLUDE_STRUCTURE'
                                       AND colp.value1             LIKE '%&%'   )  )
                              OR NOT EXISTS
                               ( SELECT 'X'
                                   FROM n_view_properties         colp1,
                                        n_property_type_templates ptype1
                                  WHERE colp1.view_name             = colp.view_name
                                    AND colp1.SOURCE_PK_ID          = colp.SOURCE_PK_ID
                                    AND colp1.query_position        = colp.query_position
                                    AND ptype1.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES'
                                    AND ptype1.property_type_id     = colp1.property_type_id
                                    AND ptype1.property_type        = 'INCLUDE_STRUCTURE' ) )   THEN 'ALL'
                       ELSE TO_CHAR( NULL )
                     END        )
         AND ROWNUM                     = 1;


      r1_2                          c1_2%ROWTYPE;

      CURSOR c1_3( p_view_name VARCHAR2,
                   p_col_name  VARCHAR2,
                   p_qry_pos   NUMBER ) IS
         SELECT 'Y' val_desc_both_reqd
           FROM DUAL
          WHERE EXISTS
              ( SELECT 'X'
                  FROM n_view_properties         colp,
                       n_property_type_templates ptype,
                       n_view_columns            col
                 WHERE col.view_name                = p_view_name
                   AND col.query_position           = p_qry_pos
                   AND col.column_name              = p_col_name
                   AND colp.view_name               = col.view_name
                   AND colp.query_position          = col.query_position
                   AND colp.source_pk_id            = col.column_id
                   AND ptype.property_type_id       = colp.property_type_id
                   AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                   AND ptype.property_type         IN
                             ( 'INCLUDE_CONCAT_SEGMENT_DESC',
                               'INCLUDE_INDIV_SEGMENT_DESC',
                               'INCLUDE_CONCAT_SEGMENT_VALUES',
                               'INCLUDE_INDIV_SEGMENT_VALUES' ) );

      r1_3                          c1_3%ROWTYPE;

      CURSOR c1_4 (p_view_name VARCHAR2, p_col_name VARCHAR2, p_qry_pos NUMBER)
      IS
         SELECT 'Y' val_only_reqd
           FROM DUAL
          WHERE EXISTS
              ( SELECT 'X'
                  FROM n_view_properties            colp,
                       n_view_columns               col,
                       n_property_type_templates    ptype
                 WHERE col.view_name                = p_view_name
                   AND col.query_position           = p_qry_pos
                   AND col.column_name              = p_col_name
                   AND colp.view_name               = col.view_name
                   AND colp.query_position          = col.query_position
                   AND colp.source_pk_id            = col.column_id
                   AND ptype.property_type_id       = colp.property_type_id
                   AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                   AND ptype.property_type         IN
                             ( 'INCLUDE_CONCAT_SEGMENT_VALUES',
                               'INCLUDE_INDIV_SEGMENT_VALUES' ))
            AND NOT EXISTS
              ( SELECT 'X'
                  FROM n_view_properties colp,
                       n_view_columns  col,
                       n_property_type_templates ptype
                 WHERE col.view_name                = p_view_name
                   AND col.query_position           = p_qry_pos
                   AND col.column_name              = p_col_name
                   AND colp.view_name               = col.view_name
                   AND colp.query_position          = col.query_position
                   AND colp.source_pk_id            = col.column_id
                   AND ptype.property_type_id       = colp.property_type_id
                   AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                   AND ptype.property_type         IN
                             ('INCLUDE_CONCAT_SEGMENT_DESC',
                              'INCLUDE_INDIV_SEGMENT_DESC'));

      r1_4                          c1_4%ROWTYPE;

      CURSOR col_prop_cur( p_view_name   VARCHAR2,
                           p_col_name    VARCHAR2,
                           p_qry_pos     NUMBER     )      IS
      SELECT colp.view_name,
             colp.query_position,
             col.column_name,
             col.column_label,
             col.t_column_id,
             col.column_id,
             COUNT( CASE
                      WHEN (    (     ptype.property_type = 'INCLUDE_STRUCTURE'
                                  AND colp.value1              IS NULL
                                  AND colp.value2              IS NULL )
                             OR (     ptype.property_type = 'INCLUDE_STRUCTURE'
                                  AND colp.value1            LIKE '%&%' )
                             OR NOT EXISTS
                              ( SELECT 'X'
                                  FROM n_view_properties         colp1,
                                       n_property_type_templates ptype1
                                 WHERE colp1.source_pk_id               = colp.source_pk_id
                                   AND colp1.property_type_id           = ptype1.property_type_id
                                   AND ptype1.templates_table_name      = 'N_VIEW_COLUMN_TEMPLATES'
                                   AND ptype1.property_type             = 'INCLUDE_STRUCTURE'   ) )  THEN NULL
                      WHEN (     ptype.property_type                    = 'INCLUDE_STRUCTURE'
                             AND (    colp.value1           NOT LIKE '%&%'
                                   OR (     colp.value1                 IS NULL
                                        AND colp.value2                 IS NOT NULL ) ) )       THEN 1
                      ELSE NULL
                    END )                  include_structure_count,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_CONCAT_SEGMENT_DESC' THEN 1
                      ELSE NULL
                    END )                  include_concat_seg_desc,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_CONCAT_SEGMENT_VALUES' THEN 1
                      ELSE NULL
                    END      )             include_concat_seg_val,
             COUNT( CASE ptype.property_type
                      WHEN 'INCL_CONCAT_PARENT_SEG_DESC' THEN 1
                      ELSE NULL
                    END      )             include_concat_seg_pdesc,
             COUNT( CASE ptype.property_type
                      WHEN 'INCL_CONCAT_PARENT_SEG_VALUES'  THEN 1
                      ELSE NULL
                    END      )             include_concat_seg_pval,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_INDIV_SEGMENT_DESC'     THEN 1
                      ELSE NULL
                    END      )             include_indiv_seg_desc,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_INDIV_SEGMENT_VALUES'   THEN 1
                      ELSE NULL
                    END      )             include_indiv_seg_val,
             COUNT( CASE ptype.property_type
                      WHEN 'EXCLUDE_GLOBAL_HELPER_COLUMNS'  THEN 1
                      ELSE NULL
                    END      )             exclude_helper_columns,
             COUNT( CASE
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1              = 'PRIMARY_KEY'
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                      ELSE NULL
                    END     )              exclude_primary_key_col,
             COUNT( CASE
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1              = 'STRUCTURE_NAME'
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                      ELSE NULL
                    END     )              exclude_structure_name_col,
             COUNT( CASE
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1              = 'SEGMENT_NAME_LIST'
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                   ELSE NULL
                 END     )                 exclude_segment_name_list_col,
             COUNT( CASE
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1           LIKE 'Z$%'
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                   ELSE NULL
                 END     )                 exclude_z$_col,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_QUALIFIER'     THEN 1
                      ELSE NULL
                    END    )               include_qualifier_count,
             COUNT( CASE
                      WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                             AND colp.value2               = 'Y' )                 THEN 1
                      ELSE NULL
                    END    )               include_qualifier_val,
             COUNT( CASE
                      WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                             AND colp.value3               = 'Y' )                 THEN 1
                      ELSE NULL
                    END    )               include_qualifier_desc
        FROM n_view_properties          colp,
             n_view_columns             col,
             n_property_type_templates  ptype
       WHERE col.view_name              = p_view_name
         AND col.column_name            = p_col_name
         AND col.query_position         = p_qry_pos
         AND col.column_id              = colp.source_pk_id
         and ptype.property_type_id     = colp.property_type_id
         and ptype.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES'
    GROUP BY colp.view_name,
             colp.query_position,
             col.column_name,
             col.column_label,
             col.t_column_id,
             col.column_id;

      col_prop_rec                  col_prop_cur%ROWTYPE;

--KFF biz rule----
      CURSOR c6 (
         p_data_table_key           VARCHAR2,
         p_cust_prompt              VARCHAR2,
         p_include_indiv_seg_val    VARCHAR2,
         p_include_indiv_seg_desc   VARCHAR2,
         p_include_concat_seg_val   VARCHAR2,
         p_include_concat_seg_desc  VARCHAR2,
         p_multi_seg_detected       VARCHAR2,
         p_processing_type          VARCHAR2,
         p_constraint_type          VARCHAR2,
         p_value_view_name          VARCHAR2,
         p_desc_view_name           VARCHAR2,
         p_view_spl_process_code    VARCHAR2,
         p_column_name_prefix       VARCHAR2
      )
      IS
       SELECT formatted_target_column_name, target_column_name,
              COUNT(1) over(partition by formatted_target_column_name) dup_col_cnt,
              ROW_NUMBER() over(partition by formatted_target_column_name order by formatted_target_column_name, target_column_name) sub_script
         FROM
         (SELECT n_gseg_utility_pkg.FORMAT_KFF_SEGMENT(p_column_name_prefix||'$'||target_column_name,30) formatted_target_column_name,
            target_column_name
          FROM
         (
         WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL <= 2)
         SELECT DISTINCT (CASE
                             WHEN lvl = 1
                                THEN target_column_name
                             WHEN lvl = 2
                                THEN target_desc_column_name
                          END
                         ) target_column_name
                    FROM DATA,
                         n_f_kff_segments seg,
                         n_f_kff_structure_groups str,
                         n_f_kff_struct_grp_flex_nums nums
                   WHERE seg.data_table_key = p_data_table_key
                     AND (   str.value_view_name = p_value_view_name
                          OR str.description_view_name = p_desc_view_name
                         )
                     AND str.structure_group_id = nums.structure_group_id(+)
                     AND str.data_table_key = seg.data_table_key
                     AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num
                     AND (   (    p_view_spl_process_code = 'LOV'
                              AND (   (lvl = 1 AND p_include_indiv_seg_val = 1
                                      )
                                   OR (lvl = 2 AND p_include_indiv_seg_desc = 1
                                      )
                                  )
                             )
                          OR ((CASE
                                 WHEN (    lvl = 1
                                       AND (   p_include_indiv_seg_val = 0
                                            OR (    p_cust_prompt = 'N'
                                                AND p_processing_type =
                                                                     'SOURCED'
                                                AND p_constraint_type IN
                                                         ('NONE', 'MULTIPLE')
                                               )
                                           )
                                      )
                                    THEN 1
                                 WHEN (    lvl = 2
                                       AND (   p_include_indiv_seg_desc = 0
                                            OR (    p_cust_prompt = 'N'
                                                AND p_processing_type =
                                                                     'SOURCED'
                                                AND p_constraint_type IN
                                                         ('NONE', 'MULTIPLE')
                                               )
                                           )
                                      )
                                    THEN 2
                              END  ) IS NULL )
                          OR ((CASE
                                 WHEN (     lvl                       = 1
                                        AND p_include_indiv_seg_val   = 0
                                        AND p_include_concat_seg_val  > 0
                                        AND p_multi_seg_detected      = 'N'
                                        AND p_processing_type         = 'SOURCED'
                                        AND p_constraint_type         = 'SINGLE'    )  THEN 1
                                 WHEN (     lvl                       = 2
                                        AND p_include_indiv_seg_desc  = 0
                                        AND p_include_concat_seg_desc > 0
                                        AND p_multi_seg_detected      = 'N'
                                        AND p_processing_type         = 'SOURCED'
                                        AND p_constraint_type         = 'SINGLE'    )  THEN 1
                              END ) = 1 )
                         )
                       ));
   BEGIN
      l_error_location := 'start processing';

      OPEN c3 (n_gseg_utility_pkg.g_kff_app_label);

      FETCH c3
       INTO r3;

      CLOSE c3;

--Primary cursor to get the view columns where the data cache metadata needs to be brought int
      FOR r1 IN c1 LOOP                                                             --{ c1
         r2                 := NULL;
         l_table_name       := NULL;
         l_column_position  := r1.column_position;
         g_sv_column_flag   := FALSE;

         --The cursor c2 to derive the data table key and some additional information
         OPEN c2( r1.id_flex_code,
                  r1.id_flex_application_id,
                  r1.metadata_table_name,
                  'ALL'  );                                                         --{c2

         FETCH c2
          INTO r2;

         CLOSE c2;

--Derive the structure group based on the column properties. Based on this, appropriate data cache
--view will be selected and incorporated
         OPEN c1_2 (r2.data_table_key,
                    r1.view_name,
                    --r1.column_label,
                    r1.column_name,
                    r1.query_position
                   );

         FETCH c1_2
          INTO r1_2;

         CLOSE c1_2;

--Based on column properties, decide if the description and values are requested
         OPEN c1_3 (r1.view_name, r1.column_name, r1.query_position);

         FETCH c1_3
          INTO r1_3;

         CLOSE c1_3;

--Based on column properties, decide if the values are requested
         OPEN c1_4 (r1.view_name, r1.column_name, r1.query_position);

         FETCH c1_4
          INTO r1_4;

         CLOSE c1_4;

         --derive column name prefix
         l_column_name_prefix   := ( CASE
                                       WHEN (     LENGTHB(r1.column_label)     > 8
                                              AND INSTRB(r1.column_label, '_') > 0 )
                                            THEN ( CASE
                                                     WHEN ( INSTRB(SUBSTRB(r1.column_label,1,8), '_') > 0 )
                                                         THEN SUBSTRB(r1.column_label, 1, 8)
                                                     ELSE SUBSTRB(r1.column_label, 1, 7) ||
                                                          SUBSTRB(r1.column_label, INSTRB(r1.column_label, '_') + 1,1 )
                                                   END )
                                       WHEN (     LENGTHB( r1.column_label )   > 8
                                              AND INSTRB(r1.column_label, '_') = 0 )
                                            THEN SUBSTRB( r1.column_label, 1, 8 )
                                       ELSE r1.column_label
                                     END  );

          l_column_name_prefix := RTRIM( l_column_name_prefix,'_' );

      --KFF biz rule----
--Derive the multi seg struct property
         OPEN detect_multi_seg (r2.data_table_key,
                                r1_2.seg_view,
                                r1_2.segd_view
                               );

         FETCH detect_multi_seg
          INTO rec_multi_seg;

         CLOSE detect_multi_seg;

         --Add column property INCLUDE_INDIV_SEGMENT_VALUES or INCLUDE_INDIV_SEGMENT_DESC
         --for single structure and single segment
         IF rec_multi_seg.multi_seg_detected = 'N' THEN

            OPEN col_prop_cur (r1.view_name, r1.column_name, r1.query_position);

            FETCH col_prop_cur
             INTO col_prop_rec;

            CLOSE col_prop_cur;

            IF ( col_prop_rec.include_indiv_seg_val = 0 ) THEN

                n_gseg_utility_pkg.insert_view_col_prop
                           ( i_view_name                        => r1.view_name,
                             i_view_label                       => r1.view_label,
                             i_query_position                   => r1.query_position,
                             i_source_pk_id                     => r1.column_id,
                             i_t_source_pk_id                   => r1.t_column_id,
                             i_profile_option                   => r1.profile_option,
                             i_property_type                    => 'INCLUDE_INDIV_SEGMENT_VALUES',
                             o_view_property_id                 => l_view_property_id
                           );

             END IF;

             IF (     col_prop_rec.include_concat_seg_desc > 0
                  AND col_prop_rec.include_indiv_seg_desc  = 0 ) THEN

                n_gseg_utility_pkg.insert_view_col_prop
                           ( i_view_name                        => r1.view_name,
                             i_view_label                       => r1.view_label,
                             i_query_position                   => r1.query_position,
                             i_source_pk_id                     => r1.column_id,
                             i_t_source_pk_id                   => r1.t_column_id,
                             i_profile_option                   => r1.profile_option,
                             i_property_type                    => 'INCLUDE_INDIV_SEGMENT_DESC',
                             o_view_property_id                 => l_view_property_id          );

            END IF;

            --COMMIT;

            col_prop_rec := NULL;
         END IF;


--Manifestation of column properties metadata
         OPEN col_prop_cur (r1.view_name, r1.column_name, r1.query_position);

         FETCH col_prop_cur
          INTO col_prop_rec;

         CLOSE col_prop_cur;

         IF col_prop_rec.include_structure_count = 0
         THEN
            l_md_struct_constraint_type := 'NONE';
         ELSIF col_prop_rec.include_structure_count = 1
         THEN
            l_md_struct_constraint_type := 'SINGLE';
         ELSE
            l_md_struct_constraint_type := 'MULTIPLE';
         END IF;

         OPEN c3_1 (r1.id_flex_code, r1.id_flex_application_id);       --{c3_1

         FETCH c3_1
          INTO r3_1;

         CLOSE c3_1;                                                   --}c3_1

-- additional logic for the table replacement logic
         l_error_location := 'table replacement validation';

--check dff columns
         SELECT COUNT (*)
           INTO l_dff_col_ctr
           FROM n_view_columns  c
          WHERE c.view_name         = r1.view_name
            AND c.query_position    = r1.query_position
            AND c.table_alias       = r1.table_alias
            AND c.column_type       = 'ATTR';

--check columns other than primary key colums in n_view_columns
         SELECT COUNT (*)
           INTO l_other_col_ctr
           FROM n_view_columns              c,
                n_kff_flex_source_templates pt,
                n_f_kff_flex_sources        fs
          WHERE c.view_name                     = r1.view_name
            AND c.query_position                = r1.query_position
            AND c.table_alias                   = r1.table_alias
            AND
              (    UPPER (c.column_expression) NOT LIKE '%' || pt.kff_table_pk1 || '%'
                OR UPPER (c.column_expression) NOT LIKE '%' || pt.kff_table_pk2 || '%'
                OR UPPER (c.column_expression) NOT LIKE '%' || pt.kff_table_pk3 || '%' )
            AND fs.data_table_key               = r2.data_table_key
            AND pt.id_flex_application_id       = fs.id_flex_application_id
            AND pt.id_flex_code                 = fs.id_flex_code
            AND pt.data_application_id          = fs.data_application_id
            AND pt.data_application_table_name  = fs.data_application_table_name
            AND fs.source_type                  = 'DC';

--check columns other than primary key colums in n_view_wheres
         SELECT COUNT (*)
           INTO l_other_col_where_ctr
           FROM n_kff_flex_source_templates pt,
                n_f_kff_flex_sources        fs,
                n_view_wheres               w
          WHERE fs.data_table_key               = r2.data_table_key
            AND pt.id_flex_application_id       = fs.id_flex_application_id
            AND pt.id_flex_code                 = fs.id_flex_code
            AND pt.data_application_id          = fs.data_application_id
            AND pt.data_application_table_name  = fs.data_application_table_name
            AND fs.source_type                  = 'DC'
            AND w.view_name                     = r1.view_name
            AND UPPER (w.where_clause)       LIKE '%' || UPPER(r1.table_alias) || '.%'
            AND w.query_position                = r1.query_position
            AND
              (    UPPER (w.where_clause) NOT LIKE '%.' || pt.kff_table_pk1 || '%'
                OR UPPER (w.where_clause) NOT LIKE '%.' || pt.kff_table_pk2 || '%'
                OR UPPER (w.where_clause) NOT LIKE '%.' || pt.kff_table_pk3 || '%'  );

         l_keyview_ctr := 0;
         SELECT COUNT (*)
           INTO l_keyview_ctr
           FROM n_view_columns     c,
                n_join_key_columns jc,
                n_join_keys        j
          WHERE c.view_name          = r1.view_name
            AND c.query_position     = r1.query_position
            AND c.table_alias        = r1.table_alias
            AND j.view_name          = c.view_name
            AND j.column_type_code   = 'ROWID'
            AND jc.join_key_id       = j.join_key_id
            AND jc.column_name       = c.column_name;

--Column level key view name existence is also verified
--security_code = 'ACCOUNT'  table_replacement_allowed_flag='Y' => table_replacement_flag='N'
         IF (     r2.table_replacement_allowed_flag = 'Y'
              AND NVL(r1.security_code,'NONE')      = 'NONE'
              AND l_dff_col_ctr                     = 0
              AND l_other_col_ctr                   = 0
              AND l_other_col_where_ctr             = 0
              AND l_keyview_ctr                     = 0
              AND r1.key_view_name                 IS NULL   )   THEN
            l_replace_table := TRUE;
         ELSE
            l_replace_table := FALSE;
         END IF;

         l_error_location := 'Insert into n_view_tables';

---tables
         BEGIN
            l_table_name :=
               (CASE
                  WHEN (   col_prop_rec.include_concat_seg_desc > 0
                         OR col_prop_rec.include_indiv_seg_desc > 0
                         OR col_prop_rec.include_qualifier_desc > 0
                        )
                      THEN r1_2.segd_view
                   WHEN (   (    col_prop_rec.include_concat_seg_val > 0
                             AND col_prop_rec.include_concat_seg_desc = 0
                            )
                         OR (    col_prop_rec.include_indiv_seg_val > 0
                             AND col_prop_rec.include_indiv_seg_desc = 0
                            )
                         OR (    col_prop_rec.include_qualifier_val > 0
                             AND col_prop_rec.include_qualifier_desc = 0
                            )
                        )
                      THEN r1_2.seg_view
                  ELSE NULL
                END
               );

            IF NOT l_replace_table
            THEN
               SELECT COUNT (*)
                 INTO l_tab_alias_ctr
                 FROM n_view_tables
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position
                  AND RTRIM (TRANSLATE (UPPER (table_alias),
                                        '1234567890',
                                        '      '
                                       )
                            ) = UPPER (r1.id_flex_code);

               l_tab_alias_ctr := l_tab_alias_ctr + 1;
               l_tab_alias := UPPER (r1.id_flex_code);
               l_tab_alias := l_tab_alias || l_tab_alias_ctr;

               INSERT INTO n_view_tables
                    ( view_name,
                      view_label,
                      query_position,
                      table_alias,
                      from_clause_position,
                      application_label,
                      owner_name,
                      table_name,
                      metadata_table_name,
                      application_instance,
                      base_table_flag,
                      generated_flag,
                      subquery_flag,
                      gen_search_by_col_flag  )
               VALUES
                    ( r1.view_name,
                      r1.view_label,
                      r1.query_position,
                      l_tab_alias,
                      r1.from_clause_position + 0.1,
                      r3.application_label,
                      gc_user,
                      l_table_name,
                      l_table_name,
                      r1.application_instance,
                      'N',
                      'Y',
                      'N',
                      'Y'  );
            ELSE
               l_tab_alias := r1.table_alias;

               UPDATE n_view_tables t
                  SET t.table_name          = l_table_name,
                      t.metadata_table_name = ( CASE
                                                  WHEN ( l_table_name LIKE 'XXK%' ) THEN l_table_name
                                                  ELSE t.metadata_table_name
                                                END ),
                      t.owner_name          = gc_user,
                      t.generated_flag      = 'Y',
                      t.application_label   = n_gseg_utility_pkg.g_kff_app_label
                WHERE t.view_name       = r1.view_name
                  AND t.query_position  = r1.query_position
                  AND t.table_alias     = r1.table_alias;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     r1.view_name
                  || '~'
                  || r1.query_position
                  || '~'
                  || l_tab_alias
                  || '~'
                  || l_table_name
                  || '~'
                  || r2.data_table_key
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

---columns
         l_error_location := 'Insert into n_view_columns';

---Source primary key columns
         FOR r5 IN c5( r2.data_table_key,
                       'COLUMN',
                       col_prop_rec.exclude_primary_key_col  )
         LOOP                                                          --{c5#1
            BEGIN
               l_error_location     := 'view columns metadata - source PK columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := n_gseg_utility_pkg.g_kff_coldesc_pk_sfx;
               l_col_description    := r1.description || ' ' || REPLACE(l_col_description, '<flexfield>', r2.kff_name);
               l_column_name        := ( CASE
                                           WHEN ( r5.kff_pk = 'COST_ALLOCATION_KEYFLEX_ID' ) THEN 'COST_ALLOC_KEYFLEX_ID'
                                           WHEN ( r5.kff_pk = 'POSITION_DEFINITION_ID'     ) THEN 'POSITION_DEFN_ID'
                                           ELSE r5.kff_pk
                                         END );
               l_column_name        := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB( l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
               l_column_name        := RTRIM (l_column_name, '_');
               l_column_name        := INITCAP (l_column_name);

               l_column_name        := l_column_name_prefix || '$' || l_column_name;

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => r5.kff_pk,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => null,--added NV-192 (Lov association is not required for Primary Key columns)
                        i_lov_view_name               => null,--added NV-192
                        i_lov_column_label            => null,--added NV-192
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_property_type                    => 'PRIMARY_KEY',
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_value1                           => r5.col_seq,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id            );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                     --}c5#1

---Structure columns
--KFF biz rule----
         FOR r4_1 IN c4_1( r3_1.kff_processing_type,
                           l_md_struct_constraint_type,
                           col_prop_rec.exclude_structure_name_col   )
--KFF biz rule----
         LOOP                                                          --{c4_1
            BEGIN
               l_error_location  := 'view columns metadata - structure columns ';
               l_column_position := l_column_position + 0.1;
               l_col_description := n_gseg_utility_pkg.g_kff_coldesc_structname_sfx;
               l_col_description := r1.description || ' ' || REPLACE (l_col_description, '<flexfield>', r2.kff_name);
               l_column_name     := r4_1.struct_column;
               l_column_name     := ( CASE
                                        WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB( l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                        ELSE l_column_name
                                      END  );
               l_column_name     := RTRIM( l_column_name, '_' );

               l_column_name     := l_column_name_prefix || '$' || l_column_name;

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => r4_1.struct_column,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => r1.lov_view_label,--added NV-192
                        i_lov_view_name               => r1.lov_view_name,--added NV-192
                        i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id
                       );

               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_property_type                    => 'STRUCTURE_NAME',
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,

                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id
                           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                     --}c4_1

---Qualifier columns
         FOR r4_2 IN c4_2 (r2.data_table_key,
                           r1.view_name,
                           r1.column_id,
                           r1.query_position
                          )
         LOOP                                                          --{c4_2
            BEGIN
               l_error_location  := 'view columns metadata - qualifier columns ';
               l_column_position := l_column_position + 0.1;
               l_col_description := ( CASE
                                        WHEN ( SUBSTRB(r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_qv_sfx
                                        ELSE n_gseg_utility_pkg.g_kff_coldesc_qd_sfx
                                      END );
               l_col_description := r1.description || ' ' || REPLACE( REPLACE( l_col_description,
                                                                               '<segment>',
                                                                               REPLACE( r4_2.segment_prompt,
                                                                                        ' Segment' ) ),
                                                                      '<flexfield>', r2.kff_name );
               l_column_expr     := r4_2.qual_col_name;
               l_column_name     := r4_2.qual_col_name;
               l_column_name     := ( CASE
                                        WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                 THEN SUBSTRB(l_column_name, 1,(29 - LENGTHB(l_column_name_prefix))  )
                                        ELSE l_column_name
                                      END );
               l_column_name          := RTRIM (l_column_name, '_');
               l_column_property_type := ( CASE
                                             WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                    THEN 'QUALIFIER_VALUE'
                                             ELSE 'QUALIFIER_DESCRIPTION'
                                           END );

               l_column_name          := l_column_name_prefix || '$' || l_column_name;


               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => r1.lov_view_label,--added NV-192
                        i_lov_view_name               => r1.lov_view_name,--added NV-192
                        i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                        i_generated_flag              => 'Y',
                        i_segment_qualifier           => r4_2.segment_attribute_type,
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_property_type                    => l_column_property_type,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_value1                           => NULL,
                            i_value2                           => r4_2.segment_attribute_type,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                     --}c4_2

---Concatenated columns
--KFF biz rule----
         FOR r4 IN c4 (r2.data_table_key,
                       r1.column_type,
                       r3_1.kff_processing_type,
                       l_md_struct_constraint_type,
                       rec_multi_seg.multi_seg_detected,
                       col_prop_rec.exclude_segment_name_list_col,
                       col_prop_rec.include_concat_seg_val,
                       col_prop_rec.include_concat_seg_pval,
                       col_prop_rec.include_concat_seg_desc,
                       col_prop_rec.include_concat_seg_pdesc
                      )
--KFF biz rule----
         LOOP                                                            --{c4
            BEGIN
               l_error_location :=
                              'view columns metadata - concatenated columns ';
               l_column_position := l_column_position + 0.1;

               --sharas 02/19
               -- we donot want the Z$ for this lot
               IF (    (     r3_1.kff_processing_type         = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected = 'Y' )
                    OR (     r3_1.kff_processing_type         = 'SOURCED'
                         AND l_md_struct_constraint_type      = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected = 'Y'  ) )  THEN
                    g_sv_column_flag := TRUE;
               END IF;
               --sharas 02/19

               --Column descriptions logic
               IF     r4.concatenation_type = 'VAL'
                  AND (   (    r3_1.kff_processing_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                       OR (    r3_1.kff_processing_type = 'SOURCED'
                           AND l_md_struct_constraint_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                      )
               THEN
                  BEGIN
                     SELECT seg.id_flex_num
                       INTO l_id_flex_num
                       FROM n_f_kff_structures seg,
                            n_f_kff_structure_groups str,
                            n_f_kff_struct_grp_flex_nums nums
                      WHERE seg.data_table_key = r2.data_table_key
                        AND (   str.value_view_name = r1_2.seg_view
                             OR str.description_view_name = r1_2.segd_view
                            )
                        AND str.structure_group_id = nums.structure_group_id(+)
                        AND str.data_table_key = seg.data_table_key
                        AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;

                  BEGIN
                     SELECT    'List of segment names for '
                            || str.structure_name
                            || ' structure is "'
                            || ccat.source_expression
                            || '".'
                       INTO l_col_description
                       FROM n_f_kff_concatenations ccat,
                            n_f_kff_structures str
                      WHERE ccat.data_table_key = r2.data_table_key
                        AND str.data_table_key = ccat.data_table_key
                        AND str.id_flex_num = l_id_flex_num
                        AND ccat.id_flex_num = str.id_flex_num
                        AND ccat.concatenation_type = 'LIST';
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;
               ELSE
                  l_col_description :=
                     (CASE
                         WHEN r4.concatenation_type = 'LIST'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_segnl_sfx
                         WHEN r4.concatenation_type = 'VAL'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cv_sfx
                         WHEN r4.concatenation_type = 'DESC'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cd_sfx
                      END
                     );
                  l_col_description :=
                        r1.description
                     || ' '
                     || REPLACE (l_col_description, '<flexfield>',
                                 r2.kff_name);
               END IF;

               l_column_name := r4.target_column_name;

               l_column_property_type :=
                  (CASE
                      WHEN r4.concatenation_type = 'VAL'
                         THEN 'CONCATENATED_VALUES'
                      WHEN r4.concatenation_type = 'DESC'
                         THEN 'CONCATENATED_DESCRIPTIONS'
                      WHEN r4.concatenation_type = 'LIST'
                         THEN 'SEGMENT_NAME_LIST'
                   END
                  );

               l_column_name := l_column_name_prefix || '$' || l_column_name;

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => r4.target_column_name,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => r1.lov_view_label,--added NV-192
                        i_lov_view_name               => r1.lov_view_name,--added NV-192
                        i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);
               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c4

---Individual segment columns
--KFF biz rule----
         FOR r6 IN c6 (r2.data_table_key,
                       r2.kff_cols_in_global_view_flag,
                       col_prop_rec.include_indiv_seg_val,
                       col_prop_rec.include_indiv_seg_desc,
                       col_prop_rec.include_concat_seg_val,
                       col_prop_rec.include_concat_seg_desc,
                       rec_multi_seg.multi_seg_detected,
                       r3_1.kff_processing_type,
                       l_md_struct_constraint_type,
                       r1_2.seg_view,
                       r1_2.segd_view,
                       r1.special_process_code,
                       l_column_name_prefix
                      )
--KFF biz rule----
         LOOP                                                            --{c6
            BEGIN
               IF (     r2.kff_cols_in_global_view_flag = 'Y'
                    AND r3_1.kff_processing_type        = 'SOURCED' )  THEN
                  g_sv_column_flag := FALSE;
               ELSE
                  g_sv_column_flag := TRUE;
               END IF;
               g_segment_name       := NULL;
               l_dup_column_exists  := 0;
               l_error_location     := 'view columns metadata - individual columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := ( CASE
                                           WHEN ( SUBSTR( r6.target_column_name, 1, 2 ) =  n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_sv_sfx
                                           ELSE n_gseg_utility_pkg.g_kff_coldesc_sd_sfx
                                         END );

                  --Derive the segment name to add it into column description
                  BEGIN



                  select seg.segment_name
                    INTO g_segment_name
                    from ( SELECT s.segment_name
                             FROM n_f_kff_segments s
                            WHERE s.data_table_key     = r2.data_table_key
                              AND s.target_column_name = r6.target_column_name
                            order by s.segment_name ) seg
                   where rownum = 1;






                  EXCEPTION
                     WHEN OTHERS THEN
                        g_segment_name := NULL;
                  END;
               l_col_description :=
                     r1.description
                  || ' '
                  || REPLACE (REPLACE (l_col_description,
                                       '<segment>',
                                       g_segment_name
                                      ),
                              '<flexfield>',
                              r2.kff_name
                             );

                  l_column_name := r6.formatted_target_column_name;

                IF r6.dup_col_cnt > 1 THEN
                    IF r6.sub_script > 1 THEN
                        l_column_name := n_gseg_utility_pkg.format_kff_segment(l_column_name||r6.sub_script,30);
                    END IF;

                  SELECT COUNT (*)
                    INTO l_dup_column_exists
                    FROM n_view_columns
                   WHERE view_name = r1.view_name
                     AND column_name = l_column_name
                     AND UPPER (column_expression) =
                                                 UPPER (r6.target_column_name)
                     AND query_position = r1.query_position;

               END IF;

               l_column_property_type :=
                  (CASE
                      WHEN SUBSTR (r6.target_column_name, 1, 2) =
                                                       n_gseg_utility_pkg.g_kff_dc_seg_val_pfx
                         THEN 'SEGMENT_VALUE'
                      ELSE 'SEGMENT_DESCRIPTION'
                   END
                  );

               IF ( l_dup_column_exists = 0 ) THEN

                  n_gseg_utility_pkg.insert_view_column
                      (i_t_column_id                 => r1.t_column_id,
                       i_view_name                   => r1.view_name,
                       i_view_label                  => r1.view_label,
                       i_query_position              => r1.query_position,
                       i_column_name                 => l_column_name,
                       i_column_label                => r1.column_label,
                       i_table_alias                 => l_tab_alias,
                       i_column_expression           => r6.target_column_name,
                       i_column_position             => l_column_position,
                       i_column_type                 => 'GEN',
                       i_description                 => l_col_description,
                       i_ref_lookup_column_name      => NULL,
                       i_group_by_flag               => r1.group_by_flag,
                       i_application_instance        => r1.application_instance,
                       i_gen_search_by_col_flag      => 'N',
             i_lov_view_label              => r1.lov_view_label,--added NV-192
                       i_lov_view_name               => r1.lov_view_name,--added NV-192
                       i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                       i_generated_flag              => 'Y',
                       i_id_flex_application_id      => r1.id_flex_application_id,
                       i_id_flex_code                => r1.id_flex_code,
                       o_column_id                   => l_column_id,
                       i_source_column_id            => r1.column_id);
                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => g_segment_name,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id        );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c6

---Z$ columns
--KFF biz rule----
         IF (     NVL (r1.special_process_code, 'NOT APPLICABLE') NOT IN ( 'ROLLUP_ACCOUNT', 'LOV' )
              AND g_sv_column_flag                                     = FALSE
              AND col_prop_rec.exclude_z$_col                          = 0            )     THEN
--KFF biz rule----
            --Insert the Z$$ line column
            BEGIN
               l_error_location := 'view columns metadata - Z$ line ';
               l_col_description :=
                     'Columns following this are table rowids '
                  || 'with values having meaning only '
                  || 'internal to Oracle. Use them only to join '
                  || 'to the view specified by the column name. ';

               --verify Z$$ line column exists
               SELECT COUNT (1)
                 INTO l_column_exists
                 FROM n_view_columns nvc
                WHERE nvc.view_name = r1.view_name
                  AND nvc.query_position = r1.query_position
                  AND nvc.column_name LIKE 'Z$$%'
                  AND nvc.column_label = 'NONE'
                  AND nvc.column_type = 'CONST';

               IF ( l_column_exists = 0 ) THEN

                  n_gseg_utility_pkg.insert_view_column
                      (i_t_column_id               => r1.t_column_id,
                       i_view_name                 => r1.view_name,
                       i_view_label                => r1.view_label,
                       i_query_position            => r1.query_position,
                       i_column_name               => 'Z$$_________________________',
                       i_column_label              => 'NONE',
                       i_table_alias               => 'NONE',
                       i_column_expression         => 'Z$$_________________________',
                       i_column_position           => 1500,
                       i_column_type               => 'CONST',
                       i_description               => l_col_description,
                       i_group_by_flag             => 'N',
                       i_application_instance      => r1.application_instance,
                       i_generated_flag            => 'Y',
                       o_column_id                 => l_column_id                      );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || 'Z$$'
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;

            BEGIN
               l_error_location     := 'view columns metadata - Z$ columns ';
               l_column_position    := l_column_position + 0.1;
               l_column_name        := l_table_name;
               l_column_name        := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (27 - LENGTHB (l_column_name_prefix)) )
                                                  THEN SUBSTRB(l_column_name, 1, (27 - LENGTHB (l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
               l_column_name        := RTRIM( l_column_name, '_' );

               l_column_name        := 'Z$' || l_column_name_prefix || '$' || l_column_name;
               l_column_expr        := 'Z$' || l_table_name;
               l_col_description    := 'Join to Column -- use it only to join to the view ' ||
                                       l_table_name ||
                                       '. Be sure to join to the ' ||
                                       l_column_expr ||
                                       ' column.';

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);

               IF (   col_prop_rec.include_concat_seg_desc > 0
                   OR col_prop_rec.include_indiv_seg_desc > 0
                   OR col_prop_rec.include_qualifier_desc > 0
                  )
               THEN
                  l_error_location  := 'view columns metadata - Z$ columns - value view Z$ column ';
                  l_column_name     := r1_2.seg_view;
                  l_column_name     := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (27 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB(l_column_name, 1, (27 - LENGTHB(l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
                  l_column_name     := RTRIM( l_column_name, '_' );

                  l_column_name     := 'Z$' || l_column_name_prefix || '$' || l_column_name;
                  l_column_expr     := 'Z$' || r1_2.seg_view;
                  l_col_description := 'Join to Column -- use it only to join to the view '
                                    || r1_2.seg_view
                                    || '. Be sure to join to the '
                                    || l_column_expr
                                    || ' column.';

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);
               END IF;
   EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END IF;

---wheres
--determine if the where has the outerjoin on the primary key
         l_error_location :=
              'Check if the where clause has the outerjoin on the primary key';

         BEGIN
            /*SELECT MAX (CASE
                           WHEN INSTR (where_clause, '(+)') > 0
                              THEN '(+)'
                           ELSE NULL
                        END
                       )
              INTO l_outerjoin
              FROM n_view_wheres
             WHERE view_name = r1.view_name
               AND query_position = r1.query_position
               AND (   (UPPER (where_clause) LIKE
                              '%'
                           || UPPER (r1.table_alias)
                           || '.'
                           || UPPER (r2.kff_table_pk1)
                           || '%=%'
                       )
                    OR (UPPER (where_clause) LIKE
                              '%=%'
                           || UPPER (r1.table_alias)
                           || '.'
                           || UPPER (r2.kff_table_pk1)
                           || '%'
                       )
                   );*/

             IF ( identify_join_operator( r1.view_name,
                                          r1.query_position,
                                          r1.table_alias,
                                          r2.kff_table_pk1 ) > 0 ) THEN
                 l_outerjoin := '(+)';
             ELSE
                 l_outerjoin := NULL;
             END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     r1.view_name
                  || '~'
                  || r1.query_position
                  || '~'
                  || r1.table_alias
                  || '~'
                  || r2.kff_table_pk1
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

         FOR r5 IN c5( r2.data_table_key,
                       'WHERE',
                       col_prop_rec.exclude_primary_key_col )
         LOOP                                                            --{c5
            BEGIN
               l_error_location := 'view wheres metadata';

               SELECT MAX (where_clause_position)
                 INTO l_where_position
                 FROM n_view_wheres
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position;

               l_where_position := NVL (l_where_position, 100) + 0.1;
               l_where_clause :=
                     'AND '
                  || r1.table_alias
                  || '.'
                  || r5.kff_pk
                  || ' = '
                  || l_tab_alias
                  || '.'
                  || r5.kff_pk
                  || ' '
                  || l_outerjoin;

               IF NOT l_replace_table
               THEN
                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (r1.view_name, r1.view_label,
                               r1.query_position, l_where_position,
                               l_where_clause, r1.application_instance,
                               'Y'
                              );
               -- applies to PK1,PK2
               ELSE
                  NULL;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_where_position
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c5

         BEGIN
            l_error_location := 'view wheres metadata-for STAT';

            IF r1.special_process_code = 'STAT'
            THEN
               SELECT MAX (where_clause_position)
                 INTO l_where_position
                 FROM n_view_wheres
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position;

               --get the table alias of GL_STAT_ACCOUNT_UOM
               l_stat_tab_name      := 'GL_STAT_ACCOUNT_UOM';
               l_stat_acct_col_name := 'ACCOUNT_SEGMENT_VALUE';

               SELECT t.table_alias
                 INTO l_stat_tab_alias
                 FROM n_view_tables t
                WHERE t.view_name           = r1.view_name
                  AND t.query_position      = r1.query_position
                  AND t.metadata_table_name = l_stat_tab_name;

               l_where_position := NVL (l_where_position, 100) + 0.1;
               l_where_clause :=
                     'AND '
                  || l_stat_tab_alias
                  || '.'
                  || r2.structure_id_col
                  || ' (+)'
                  || ' = '
                  || l_tab_alias
                  || '.'
                  || 'structure_id';

               BEGIN
                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (r1.view_name, r1.view_label,
                               r1.query_position, l_where_position,
                               l_where_clause, r1.application_instance,
                               'Y'
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_where_position
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;

               FOR r4_2 IN c4_2 (r2.data_table_key,
                                 r1.view_name,
                                 r1.column_id,
                                 r1.query_position
                                )
               LOOP                                                    --{c4#2
                  IF     r4_2.segment_prompt = 'Natural Account Segment'
                     AND r4_2.qual_col_name LIKE n_gseg_utility_pkg.g_kff_dc_qual_val_pfx||'$%'
                  THEN
                     l_column_name := r4_2.qual_col_name;
                  END IF;
               END LOOP;                                               --}c4#2

               l_where_position := NVL (l_where_position, 100) + 0.1;
               l_where_clause :=
                     'AND '
                  || l_stat_tab_alias
                  || '.'
                  || l_stat_acct_col_name
                  || ' (+)'
                  || ' = '
                  || l_tab_alias
                  || '.'
                  || l_column_name;

               BEGIN
                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (r1.view_name, r1.view_label,
                               r1.query_position, l_where_position,
                               l_where_clause, r1.application_instance,
                               'Y'
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_where_position
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            ELSE
               NULL;
            END IF;
         END;
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'dc_main_view',
                                                      l_error_location,
                                                      'ERROR',
                                                      l_error_msg,
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
--} c1
   END dc_main_view;
--
---------------------------------------------------------------------
--
-- Procedure Name: segstruct_view
--
-- Description
--   For all the SEGSTRUCT/SEGEXPR related views, populates the data cache views metadata into non-template tables.
--   The procedure populates the seg related metdata into non-template table like columns, tables etc.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE segstruct_view
   IS
      l_replace_table               BOOLEAN;
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_error_code                  NUMBER                            := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                     := 'SUCCESS';
      l_error_status                VARCHAR2 (30)                     := 'ERROR';
      l_in_process_status           VARCHAR2 (30)                     := 'IN-PROCESS';
      l_error_number                NUMBER                            := NULL;
      l_tab_alias_ctr               BINARY_INTEGER                    := 0;
      l_column_position             NUMBER                            := 0;
      l_where_position              NUMBER                            := 0;
      l_table_alias                 VARCHAR2 (20)                     := NULL;
      l_table_name                  VARCHAR2 (30)                     := NULL;
      l_column_name                 VARCHAR2 (30)                     := NULL;
      l_column_expr                 VARCHAR2 (1000)                   := NULL;
      l_where_clause                VARCHAR2 (500)                    := NULL;
      l_dff_col_ctr                 BINARY_INTEGER                    := 0;
      l_other_col_ctr               BINARY_INTEGER                    := 0;
      l_other_col_where_ctr         BINARY_INTEGER                    := 0;
      l_keyview_ctr                 BINARY_INTEGER                    := 0;
      l_outerjoin                   VARCHAR2 (10);
      l_column_exists               BINARY_INTEGER;
      l_column_name_prefix          n_view_column_templates.column_label%TYPE;
      l_from_position               n_view_table_templates.from_clause_position%TYPE
                                                                         := 0;
      l_kff_app_name                VARCHAR2 (30);
      l_tab_position                n_view_tables.from_clause_position%TYPE;
      l_view_label                  n_view_tables.view_label%TYPE;
      l_application_instance        n_view_tables.application_instance%TYPE;
      l_data_app_tab_alias          n_view_tables.table_alias%TYPE;
      l_md_struct_constraint_type   VARCHAR2 (20);
      l_col_description             n_view_columns.description%TYPE   := NULL;
      l_id_flex_num                 n_f_kff_segments.id_flex_num%TYPE;
      l_column_property_type        VARCHAR2 (200);
      l_property_type_id            n_view_properties.property_type_id%TYPE;
      l_view_property_id            n_view_properties.view_property_id%TYPE;
      l_t_view_property_id          n_view_properties.t_view_property_id%TYPE;
      l_column_id                   n_view_columns.column_id%TYPE;
      l_t_column_id                 n_view_columns.t_column_id%TYPE;
      i_data_table_key              NUMBER;
    l_from_data_tab_key          NUMBER;
      l_temp_col_exprs              n_view_columns.column_expression%type;
---Determine the views and queries
      CURSOR get_view_dtls IS
      SELECT DISTINCT
             h4.view_name,
             h4.query_position,
             h4.data_table_key,
             h4.source_type,
             h4.dc_view_name dc_view_name,
             h4.id_flex_code,
             h4.data_application_table_name,
             h4.pattern_key,
             h4.group_type,
             --NVL(h5.value_view_name,h2.target_value_object_name) value_view_name,
             h4.value_view_name,
             h4.qry_cnt,
             'dco' table_alias,
             REPLACE( nv.security_code,
                      'NONE', NULL    )     security_code
        FROM n_f_kff_segstruct_helper_4 h4,
             n_views                    nv
       WHERE h4.view_name             = nv.view_name
         AND (    h4.pattern_key IS NOT NULL
               OR h4.qry_cnt          > 1  )
       ORDER BY 1, 2;

--KFF biz rule----
      CURSOR detect_multi_seg( p_data_table_key    VARCHAR2,
                               p_value_view_name   VARCHAR2,
                               p_desc_view_name    VARCHAR2 ) IS
      SELECT data_table_key,
             ( CASE
                 WHEN ( seg_cnt = 1 ) THEN 'N'
                 ELSE 'Y'
               END ) multi_seg_detected
        FROM ( SELECT seg.data_table_key,
                      COUNT (*)         seg_cnt
                 FROM n_f_kff_segments              seg,
                      n_f_kff_structure_groups      str,
                      n_f_kff_struct_grp_flex_nums  nums
                WHERE seg.data_table_key                        = p_data_table_key
                  AND (    str.value_view_name                  = p_value_view_name
                        OR str.description_view_name            = p_desc_view_name )
                  AND str.structure_group_id                    = nums.structure_group_id(+)
                  AND str.data_table_key                        = seg.data_table_key
                  AND NVL( nums.id_flex_num, seg.id_flex_num )  = seg.id_flex_num
                GROUP BY seg.data_table_key);

      rec_multi_seg                 detect_multi_seg%ROWTYPE;

--KFF biz rule----
      CURSOR get_col_prty( p_view_name         VARCHAR2,
                           p_data_table_name   VARCHAR2,
                           p_query_position    NUMBER,
                           p_pattern           VARCHAR2    ) IS
       SELECT DISTINCT
             t_column_id,
             column_id,
             column_label,
             id_flex_code,
             id_flex_application_id,
             ( SELECT c.lov_view_label
                 FROM n_view_column_templates c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND ROWNUM = 1) Lov_view_label, --Added NV-192
                  ( SELECT c.lov_view_name
                 FROM n_view_columns c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND c.lov_view_name like '%G0%'
                  AND ROWNUM = 1) Lov_view_name,--Added NV-192
                  ( SELECT c.lov_column_label
                 FROM n_view_column_templates c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND ROWNUM = 1) Lov_column_label,--Added NV-192
             ( SELECT c.description
                 FROM n_view_column_templates c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND ROWNUM = 1) description
        FROM n_f_kff_segstruct_helper_1 h
       WHERE view_name                  = p_view_name
         AND NVL(data_table_name, 'XX') = NVL (p_data_table_name, 'XX')
         AND query_position             = p_query_position
         AND NVL(pattern, 'XX')         = NVL(p_pattern, 'XX')
         AND ROWNUM                     = 1;

      colp                          get_col_prty%ROWTYPE;

--retreive segment values SV$ columns
      CURSOR c6 (
         p_data_table_key           VARCHAR2,
         p_cust_prompt              VARCHAR2,
         p_include_indiv_seg_val    VARCHAR2,
         p_include_indiv_seg_desc   VARCHAR2,
         p_include_concat_seg_val   VARCHAR2,
         p_include_concat_seg_desc  VARCHAR2,
         p_multi_seg_detected       VARCHAR2,
         p_processing_type          VARCHAR2,
         p_constraint_type          VARCHAR2,
         p_value_view_name          VARCHAR2,
         p_column_name_prefix       VARCHAR2
      --p_desc_view_name          VARCHAR2
      )
      IS
       SELECT formatted_target_column_name, target_column_name,
              COUNT(1) over(partition by formatted_target_column_name) dup_col_cnt,
              ROW_NUMBER() over(partition by formatted_target_column_name order by formatted_target_column_name, target_column_name) sub_script
         FROM
         (SELECT n_gseg_utility_pkg.FORMAT_KFF_SEGMENT(p_column_name_prefix||'$'||target_column_name,30) formatted_target_column_name,
            target_column_name
          FROM
         (
         WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL <= 1)
         SELECT DISTINCT target_column_name
                    FROM DATA,
                         n_f_kff_segments seg,
                         n_f_kff_structure_groups str,
                         n_f_kff_struct_grp_flex_nums nums
                   WHERE seg.data_table_key = p_data_table_key
                     AND (str.value_view_name = p_value_view_name
                                                                 --OR str.description_view_name = p_desc_view_name
                         )
                     AND str.structure_group_id = nums.structure_group_id(+)
                     AND str.data_table_key = seg.data_table_key
                     AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num
                     AND ( (CASE
                             WHEN (    lvl = 1
                                   AND (   p_include_indiv_seg_val = 0
                                        OR (    p_cust_prompt = 'N'
                                            AND p_processing_type = 'SOURCED'
                                            AND p_constraint_type IN
                                                         ('NONE', 'MULTIPLE')
                                           )
                                       )
                                  )
                                THEN 1
                          /*  WHEN (    lvl = 2
                                  AND (   p_include_indiv_seg_desc = 0
                                       OR (    p_cust_prompt = 'N'
                                           AND p_processing_type = 'SOURCED'
                                           AND p_constraint_type IN
                                                           ('NONE', 'MULTIPLE')
                                          )
                                      )
                                 )
                               THEN 2 */
                          END
                         ) IS NULL
                          OR (CASE
                                 WHEN (    lvl = 1
                                       AND p_include_indiv_seg_val = 0
                                       AND p_include_concat_seg_val > 0
                                       AND p_multi_seg_detected = 'N'
                                       AND p_processing_type = 'SOURCED'
                                       AND p_constraint_type = 'SINGLE'
                                      )
                                    THEN 1
                              END
                             ) = 1
                            )
                      ));
   BEGIN
      l_error_location := 'start processing';
-- Issue:NV-560 --
    BEGIN
    SELECT data_table_key
    INTO l_from_data_tab_key
    FROM n_f_kff_flex_sources
    where Data_application_table_name = 'FV_BE_RPR_TRANSACTIONS'
    AND pattern_key LIKE '%FROM%';
    EXCEPTION
    WHEN no_data_found THEN
    l_from_data_tab_key := 0;
    END;
    
      OPEN c3 (n_gseg_utility_pkg.g_kff_app_label);

      FETCH c3
       INTO r3;

      CLOSE c3;

--Primary cursor to get the view columns where the data cache metadata needs to be brought int
      FOR rec_c IN get_view_dtls
      LOOP
                                                          --{ c1
         i_data_table_key := rec_c.data_table_key;
         l_table_name := NULL;
         g_sv_column_flag := FALSE;
         l_error_location := 'select table metadata ';

         BEGIN
            SELECT t.from_clause_position,
                   t.view_label,
                   t.application_instance,
                   table_alias
              INTO l_tab_position,
                   l_view_label,
                   l_application_instance,
                   l_data_app_tab_alias
              FROM n_view_tables t
             WHERE t.view_name                 = rec_c.view_name
               AND t.query_position            = rec_c.query_position
               AND t.metadata_table_name       = rec_c.data_application_table_name;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_c.view_name
                  || '~'
                  || rec_c.query_position
                  || '~'
                  || rec_c.dc_view_name
                  || '~'
                  || rec_c.data_table_key
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

-- additional logic for the table replacement logic
         l_error_location := 'table replacement validation';

--check dff columns
         SELECT COUNT (*)
           INTO l_dff_col_ctr
           FROM n_view_columns c
          WHERE c.view_name       = rec_c.view_name
            AND c.query_position  = rec_c.query_position
            AND c.table_alias     = l_data_app_tab_alias
            AND c.column_type     = 'ATTR';

--check columns other than primary key colums in n_view_columns
         SELECT COUNT (*)
           INTO l_other_col_ctr
           FROM n_view_columns              c,
                n_kff_flex_source_templates pt,
                n_f_kff_flex_sources        fs
          WHERE c.view_name                          = rec_c.view_name
            AND c.query_position                     = rec_c.query_position
            AND c.table_alias                        = l_data_app_tab_alias
            AND
              (    UPPER (column_expression) NOT LIKE '%' || pt.kff_table_pk1 || '%'
                OR UPPER (column_expression) NOT LIKE '%' || pt.kff_table_pk2 || '%'
                OR UPPER (column_expression) NOT LIKE '%' || pt.kff_table_pk3 || '%'   )
            AND fs.data_table_key                    = rec_c.data_table_key
            AND pt.id_flex_application_id            = fs.id_flex_application_id
            AND pt.id_flex_code                      = fs.id_flex_code
            AND pt.data_application_id               = fs.data_application_id
            AND pt.data_application_table_name       = fs.data_application_table_name;

--check columns other than primary key colums in n_view_wheres
         SELECT COUNT (*)
           INTO l_other_col_where_ctr
           FROM n_kff_flex_source_templates pt,
                n_f_kff_flex_sources fs,
                n_view_wheres w
          WHERE fs.data_table_key               = rec_c.data_table_key
            AND pt.id_flex_application_id       = fs.id_flex_application_id
            AND pt.id_flex_code                 = fs.id_flex_code
            AND pt.data_application_id          = fs.data_application_id
            AND pt.data_application_table_name  = fs.data_application_table_name
            AND w.view_name                     = rec_c.view_name
            AND UPPER (w.where_clause)       LIKE '%' || UPPER(l_data_app_tab_alias) || '.%'
            AND w.query_position                = rec_c.query_position
            AND
              (    UPPER(w.where_clause) NOT LIKE '%.' || pt.kff_table_pk1 || '%'
                OR UPPER(w.where_clause) NOT LIKE '%.' || pt.kff_table_pk2 || '%'
                OR UPPER(w.where_clause) NOT LIKE '%.' || pt.kff_table_pk3 || '%'  );

         l_keyview_ctr := 0;
         SELECT COUNT (*)
           INTO l_keyview_ctr
           FROM n_view_columns     c,
                n_join_key_columns jc,
                n_join_keys        j
          WHERE c.view_name          = rec_c.view_name
            AND c.query_position     = rec_c.query_position
            AND c.table_alias        = l_data_app_tab_alias
            AND j.view_name          = c.view_name
            AND j.column_type_code   = 'ROWID'
            AND jc.join_key_id       = j.join_key_id
            AND jc.column_name       = c.column_name;

         IF (     r2.table_replacement_allowed_flag = 'Y'
              AND NVL(rec_c.security_code,'NONE')   = 'NONE'
              AND l_dff_col_ctr                     = 0
              AND l_other_col_ctr                   = 0
              AND l_other_col_where_ctr             = 0
              AND l_keyview_ctr                     = 0      )   THEN
            l_replace_table := TRUE;
         ELSE
            l_replace_table := FALSE;
         END IF;

---table processing
         BEGIN
            IF NOT l_replace_table
            THEN
               l_error_location := 'insert table metadata';

               SELECT COUNT (*)
                 INTO l_tab_alias_ctr
                 FROM n_view_tables
                WHERE view_name = rec_c.view_name
                  AND query_position = rec_c.query_position
                  AND RTRIM (TRANSLATE (UPPER (table_alias),
                                        '1234567890',
                                        '      '
                                       )
                            ) = UPPER (rec_c.id_flex_code);

--          l_table_alias := rec_c.table_alias || l_tab_alias_ctr;
               l_table_alias := UPPER (rec_c.id_flex_code);
               l_tab_alias_ctr := l_tab_alias_ctr + 1;
               l_table_alias := l_table_alias || l_tab_alias_ctr;

               INSERT INTO n_view_tables
                         ( view_name,
                           view_label,
                           query_position,
                           table_alias,
                           from_clause_position,
                           application_label,
                           owner_name,
                           table_name,
                           metadata_table_name,
                           application_instance,
                           base_table_flag,
                           generated_flag,
                           subquery_flag,
                           gen_search_by_col_flag        )
                    VALUES
                         ( rec_c.view_name,
                           l_view_label,
                           rec_c.query_position,
                           l_table_alias,
                           l_tab_position + 0.1,
                           r3.application_label,
                           gc_user,
                           rec_c.dc_view_name,
                           rec_c.dc_view_name,
                           l_application_instance,
                           'N',
                           'Y',
                           'N',
                           'Y'                );
            ELSE
               l_error_location := 'update table metadata ';
               l_table_alias := l_data_app_tab_alias;

               UPDATE n_view_tables t
                  SET t.table_name          = rec_c.dc_view_name,
                      t.metadata_table_name = rec_c.dc_view_name,
                      t.owner_name          = gc_user,
                      t.generated_flag      = 'Y',
                      t.application_label   = n_gseg_utility_pkg.g_kff_app_label
                WHERE t.view_name           = rec_c.view_name
                  AND t.query_position      = rec_c.query_position
                  AND t.table_alias         = l_data_app_tab_alias;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_c.view_name
                  || '~'
                  || rec_c.query_position
                  || '~'
                  || rec_c.dc_view_name
                  || '~'
                  || rec_c.data_table_key
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

--Processing Columns
         l_error_location := 'view columns metadata ';

         --get column related info
         OPEN get_col_prty (rec_c.view_name,
                            (CASE
                                WHEN rec_c.source_type = 'DC'
                                   THEN NULL
                                ELSE rec_c.data_application_table_name
                             END
                            ),
                            rec_c.query_position,
                            rec_c.pattern_key
                           );

         FETCH get_col_prty
          INTO colp;

         CLOSE get_col_prty;

         --get kff short name
         OPEN c3_1 (colp.id_flex_code, colp.id_flex_application_id);

         FETCH c3_1
          INTO r3_1;

         CLOSE c3_1;

--KFF biz rule----
--Derive the multi seg struct property
         OPEN detect_multi_seg (rec_c.data_table_key,
                                rec_c.value_view_name,
                                NULL
                               );

         FETCH detect_multi_seg
          INTO rec_multi_seg;

         CLOSE detect_multi_seg;

--Manifestation of column properties metadata
         OPEN col_prop_cur (rec_c.view_name,
                            colp.column_label,
                            rec_c.query_position
                           );

         FETCH col_prop_cur
          INTO col_prop_rec;

         CLOSE col_prop_cur;

         IF col_prop_rec.include_structure_count = 0
         THEN
            l_md_struct_constraint_type := 'NONE';
         ELSIF col_prop_rec.include_structure_count = 1
         THEN
            l_md_struct_constraint_type := 'SINGLE';
         ELSE
            l_md_struct_constraint_type := 'MULTIPLE';
         END IF;

--KFF biz rule----

         --The cursor c2 is only for getting the additional information about the data table key
         OPEN c2 (NULL, NULL, NULL, 'ALL', rec_c.data_table_key);

         FETCH c2
          INTO r2;

         CLOSE c2;

         --derive column prefix
         l_column_name_prefix   :=( CASE
                                      WHEN (     LENGTHB(colp.column_label)     > 8
                                             AND INSTRB(colp.column_label, '_') > 0 )
                                           THEN ( CASE
                                                    WHEN ( INSTRB(SUBSTRB(colp.column_label,1,8), '_') > 0 )
                                                         THEN SUBSTRB(colp.column_label, 1, 8)
                                                    ELSE SUBSTRB(colp.column_label, 1, 7) ||
                                                         SUBSTRB(colp.column_label, INSTRB(colp.column_label, '_') + 1,1)
                                                  END )
                                      WHEN (     LENGTHB(colp.column_label)     > 8
                                             AND INSTRB(colp.column_label, '_') = 0 )
                                           THEN SUBSTRB(colp.column_label, 1, 8)
                                      ELSE colp.column_label
                                    END );

          l_column_name_prefix  := RTRIM( l_column_name_prefix,'_' );

         BEGIN
            SELECT MAX (column_position)
              INTO l_column_position
              FROM n_view_columns
             WHERE view_name = rec_c.view_name
               AND query_position = rec_c.query_position;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               NULL;
         END;

---Structure columns
--KFF biz rule----
         FOR r4_1 IN c4_1( r3_1.kff_processing_type,
                           l_md_struct_constraint_type,
                           col_prop_rec.exclude_structure_name_col              )
--KFF biz rule----
         LOOP
            BEGIN
               l_error_location     := 'view columns metadata - structure columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := n_gseg_utility_pkg.g_kff_coldesc_structname_sfx;
               l_col_description    := colp.description || ' ' ||
                                           REPLACE (l_col_description, '<flexfield>', r2.kff_name);
               l_column_name        := r4_1.struct_column;
               l_column_name        :=( CASE
                                          WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB( l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                          ELSE l_column_name
                                        END  );
               l_column_name        := RTRIM (l_column_name, '_');

               l_column_name        := l_column_name_prefix || '$' || l_column_name;
         l_temp_col_exprs := r4_1.struct_column;
--Issue NV-560
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
      l_temp_col_exprs := r4_1.struct_column||'_FROM';
  ELSE
    NULL;
  END CASE;         
            n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => l_temp_col_exprs,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id,
                      i_source_column_id            => col_prop_rec.column_id);
               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => 'STRUCTURE_NAME',
                             i_value1                           => NULL,
                             i_value2                           => NULL,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id        );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;

---Qualifier columns
         FOR r4_2 IN c4_2 (rec_c.data_table_key,
                           rec_c.view_name,
                           col_prop_rec.column_id,
                           rec_c.query_position
                          )
         LOOP
            BEGIN
               l_error_location     := 'view columns metadata - qualifier columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := ( CASE
                                           WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_qv_sfx
                                           ELSE n_gseg_utility_pkg.g_kff_coldesc_qd_sfx
                                         END );
               l_col_description    := colp.description
                                    || ' '
                                    || REPLACE (REPLACE (l_col_description,
                                                         '<segment>',
                                                         REPLACE (r4_2.segment_prompt,
                                                                  ' Segment'
                                                                 )
                                                        ),
                                                '<flexfield>',
                                                r2.kff_name );
               l_column_expr        := r4_2.qual_col_name;
               l_column_name        := r4_2.qual_col_name;
               l_column_name        := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB(l_column_name, 1,(29 - LENGTHB (l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
               l_column_name        := RTRIM (l_column_name, '_');
               l_column_property_type   := ( CASE
                                               WHEN ( SUBSTRB(r4_2.qual_col_name, 1, 2 ) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                     THEN 'QUALIFIER_VALUE'
                                               ELSE 'QUALIFIER_DESCRIPTION'
                                             END );

               l_column_name := l_column_name_prefix || '$' || l_column_name;
  
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
    l_column_expr := l_column_expr||'_FROM';
  ELSE
    NULL;
  END CASE;         

              n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => l_column_expr,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_segment_qualifier           => r4_2.segment_attribute_type,
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id  ,
                      i_source_column_id            => col_prop_rec.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => l_column_property_type,
                             i_value1                           => NULL,
                             i_value2                           => r4_2.segment_attribute_type,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id                            );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;

---Concatenated columns
--KFF biz rule----
         FOR r4 IN
            c4
               (rec_c.data_table_key,
                'SEGSTRUCT',
-- This is a dummy value passed to get through the last condition of the cursor
                r3_1.kff_processing_type,
                l_md_struct_constraint_type,
                rec_multi_seg.multi_seg_detected,
                col_prop_rec.exclude_segment_name_list_col,
                col_prop_rec.include_concat_seg_val,
                col_prop_rec.include_concat_seg_pval,
                col_prop_rec.include_concat_seg_desc,
                col_prop_rec.include_concat_seg_pdesc
               )
--KFF biz rule----
         LOOP
            BEGIN
               l_error_location :=
                              'view columns metadata - concatenated columns ';
               l_column_position := l_column_position + 0.1;

               --sharas 02/19
               -- we donot want the Z$ for this lot
               IF (    (     r3_1.kff_processing_type           = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected   = 'Y' )
                    OR (     r3_1.kff_processing_type           = 'SOURCED'
                         AND l_md_struct_constraint_type        = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected   = 'Y' ) ) THEN
                   g_sv_column_flag := TRUE;
               END IF;
               --sharas 02/19

               --Column descriptions logic
               IF     r4.concatenation_type = 'VAL'
                  AND (   (    r3_1.kff_processing_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                       OR (    r3_1.kff_processing_type = 'SOURCED'
                           AND l_md_struct_constraint_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                      )
               THEN
                  BEGIN
                     SELECT seg.id_flex_num
                       INTO l_id_flex_num
                       FROM n_f_kff_structures seg,
                            n_f_kff_structure_groups str,
                            n_f_kff_struct_grp_flex_nums nums
                      WHERE seg.data_table_key = rec_c.data_table_key
                        AND str.value_view_name = rec_c.value_view_name
                        AND str.structure_group_id = nums.structure_group_id(+)
                        AND str.data_table_key = seg.data_table_key
                        AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;

                  BEGIN
                     SELECT    'List of segment names for '
                            || str.structure_name
                            || ' structure is "'
                            || ccat.source_expression
                            || '".'
                       INTO l_col_description
                       FROM n_f_kff_concatenations ccat,
                            n_f_kff_structures str
                      WHERE ccat.data_table_key = rec_c.data_table_key
                        AND str.data_table_key = ccat.data_table_key
                        AND str.id_flex_num = l_id_flex_num
                        AND ccat.id_flex_num = str.id_flex_num
                        AND ccat.concatenation_type = 'LIST';
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;
               ELSE
                  l_col_description :=
                     (CASE
                         WHEN r4.concatenation_type = 'LIST'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_segnl_sfx
                         WHEN r4.concatenation_type = 'VAL'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cv_sfx
                         WHEN r4.concatenation_type = 'DESC'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cd_sfx
                      END
                     );
                  l_col_description :=
                        colp.description
                     || ' '
                     || REPLACE (l_col_description, '<flexfield>',
                                 r2.kff_name);
               END IF;

               l_column_name := r4.target_column_name;
               l_column_property_type :=
                  (CASE
                      WHEN r4.concatenation_type = 'VAL'
                         THEN 'CONCATENATED_VALUES'
                      WHEN r4.concatenation_type = 'DESC'
                         THEN 'CONCATENATED_DESCRIPTIONS'
                      WHEN r4.concatenation_type = 'LIST'
                         THEN 'SEGMENT_NAME_LIST'
                   END
                  );

               l_column_name := l_column_name_prefix || '$' || l_column_name;
-- Issue:NV-560
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
    r4.target_column_name := r4.target_column_name||'_FROM';
  ELSE
    NULL;
  END CASE;

          n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => r4.target_column_name,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id,
                      i_source_column_id            => col_prop_rec.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => l_column_property_type,
                             i_value1                           => NULL,
                             i_value2                           => NULL,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id                      );
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c4

---Individual segment columns
--KFF biz rule----
         FOR r6 IN c6 (rec_c.data_table_key,
                       r2.kff_cols_in_global_view_flag,
                       col_prop_rec.include_indiv_seg_val,
                       col_prop_rec.include_indiv_seg_desc,
                       col_prop_rec.include_concat_seg_val,
                       col_prop_rec.include_concat_seg_desc,
                       rec_multi_seg.multi_seg_detected,
                       r3_1.kff_processing_type,
                       l_md_struct_constraint_type,
                       rec_c.value_view_name,
                       l_column_name_prefix
                      )
--KFF biz rule----
         LOOP                                                            --{c6
            BEGIN
               l_error_location := 'view columns metadata - individual columns ';
               IF (     r2.kff_cols_in_global_view_flag = 'Y'
                    AND r3_1.kff_processing_type        = 'SOURCED' )  THEN
                  g_sv_column_flag := FALSE;
               ELSE
                  g_sv_column_flag := TRUE;
               END IF;
               g_segment_name    := NULL;
               l_column_position := l_column_position + 0.1;
               l_col_description := n_gseg_utility_pkg.g_kff_coldesc_sv_sfx;

                  --Derive the segment name to add it into column description
                  BEGIN


                  select seg.segment_name
                    INTO g_segment_name
                    from ( SELECT s.segment_name
                             FROM n_f_kff_segments s
                            WHERE s.data_table_key     = rec_c.data_table_key
                              AND s.target_column_name = r6.target_column_name
                            order by s.segment_name ) seg
                   where rownum = 1;



                  EXCEPTION
                     WHEN OTHERS THEN
                        g_segment_name := NULL;
                  END;

               l_col_description :=
                     colp.description
                  || ' '
                  || REPLACE (REPLACE (l_col_description,
                                       '<segment>',
                                       g_segment_name
                                      ),
                              '<flexfield>',
                              r2.kff_name
                             );
                  l_column_exists := 0;
                  l_column_name := r6.formatted_target_column_name;

            IF ( r6.dup_col_cnt > 1 ) THEN
                IF ( r6.sub_script > 1 ) THEN
                    l_column_name := n_gseg_utility_pkg.format_kff_segment(l_column_name||r6.sub_script,30);
                END IF;

               SELECT COUNT (*)
                 INTO l_column_exists
                 FROM n_view_columns
                WHERE view_name      = rec_c.view_name
                  AND column_name    = l_column_name
                  AND query_position = rec_c.query_position;

            END IF;
            l_column_property_type := ( CASE
                                          WHEN ( SUBSTRB(r6.target_column_name, 1, 2) =  n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                               THEN 'SEGMENT_VALUE'
                                          ELSE 'SEGMENT_DESCRIPTION'
                                       END );

            IF ( l_column_exists = 0 ) THEN
-- Issue:NV-560 
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
    r6.target_column_name := r6.target_column_name||'_FROM';
  ELSE
    NULL;
  END CASE;
              n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => r6.target_column_name,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id,
                      i_source_column_id            => col_prop_rec.column_id);
               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => l_column_property_type,
                             i_value1                           => g_segment_name,
                             i_value2                           => NULL,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id                           );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;

---Z$ columns
--KFF biz rule----
         IF (     g_sv_column_flag            = FALSE
              AND col_prop_rec.exclude_z$_col = 0     ) THEN
--KFF biz rule----
            --Insert the Z$$ line column
            BEGIN
               l_error_location := 'view columns metadata - Z$ line ';
               l_col_description :=
                     'Columns following this are table rowids '
                  || 'with values having meaning only '
                  || 'internal to Oracle. Use them only to join '
                  || 'to the view specified by the column name.';

               --verify Z$$ line column exists
               SELECT COUNT (1)
                 INTO l_column_exists
                 FROM n_view_columns nvc
                WHERE nvc.view_name         = rec_c.view_name
                  AND nvc.query_position    = rec_c.query_position
                  AND nvc.column_name    LIKE 'Z$$%'
                  AND nvc.column_label      = 'NONE'
                  AND nvc.column_type       = 'CONST';

               IF ( l_column_exists = 0 )  THEN

                  n_gseg_utility_pkg.insert_view_column
                     (i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => 'Z$$_________________________',
                      i_column_label                => 'NONE',
                      i_table_alias                 => 'NONE',
                      i_column_expression           => 'Z$$_________________________',
                      i_column_position             => 1500,
                      i_column_type                 => 'CONST',
                      i_description                 => l_col_description,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id                 );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || 'Z$$'
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;

            --Insert the actual Z$ column which would show the table rowid values
            BEGIN
               l_error_location := 'view columns metadata - Z$ columns ';
               l_column_position := l_column_position + 0.1;
               l_column_name := rec_c.dc_view_name;
               l_column_name := RTRIM (l_column_name, '_');

               l_column_name :=
                          'Z$' || l_column_name_prefix || '$' || l_column_name;

               l_column_expr := 'Z$' || rec_c.dc_view_name;
               l_col_description :=
                     'Join to Column -- use it only to join to the view '
                  || rec_c.dc_view_name
                  || '. Be sure to join to the '
                  || l_column_expr
                  || ' column.';

               n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => l_column_expr,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id  ,
                      i_source_column_id            => col_prop_rec.column_id);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END IF;

---wheres
--determine if the where has the outerjoin on the primary key
         l_error_location :=
                 'Determine if the where has the outerjoin on the primary key';

         BEGIN
            SELECT ( CASE
                       WHEN ( INSTR(where_clause, '(+)') > 0 ) THEN '(+)'
                       ELSE NULL
                     END )
              INTO l_outerjoin
              FROM n_view_wheres
             WHERE view_name               = rec_c.view_name
               AND query_position          = rec_c.query_position
               AND UPPER (where_clause) LIKE
                         '%'
                      || UPPER(l_data_app_tab_alias)
                      || '.'
                      || ( CASE
                             WHEN ( rec_c.source_type = 'DC' ) THEN UPPER (r2.kff_table_pk1)
                             ELSE NULL
                           END )
                      || '%'
               AND ROWNUM                  = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                          l_error_location || '-' || SQLERRM (l_error_number);
               RAISE;
         END;

         --if table replacement not allowed then add the where condition for the pk join
         IF NOT l_replace_table
         THEN
            --using the global cursor c5
            FOR rec_pk IN c5 (rec_c.data_table_key, 'WHERE', 0)
            LOOP
               BEGIN
                  l_error_location := 'view wheres metadata';

                  SELECT MAX (where_clause_position)
                    INTO l_where_position
                    FROM n_view_wheres
                   WHERE view_name = rec_c.view_name
                     AND query_position = rec_c.query_position;

                  l_where_position := NVL (l_where_position, 100) + 0.1;

                  IF rec_c.source_type = 'DC'
                  THEN
                     l_where_clause :=
                           'AND '
                        || l_data_app_tab_alias
                        || '.'
                        || rec_pk.kff_pk
                        || ' = '
                        || l_table_alias
                        || '.'
                        || rec_pk.kff_pk
                        || ' '
                        || l_outerjoin;
                  ELSE
                     l_where_clause :=
                           'AND '
                        || l_data_app_tab_alias
                        || '.'
                        || rec_pk.kff_pk
                        || ' = '
                        || l_table_alias
                        || '.'
                        || 'Z$'
                        || rec_c.dc_view_name
                        || ' '
                        || l_outerjoin;
                  END IF;

                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (rec_c.view_name, l_view_label,
                               rec_c.query_position, l_where_position,
                               l_where_clause, l_application_instance,
                               'Y'
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_c.view_name
                        || '~'
                        || rec_c.query_position
                        || '~'
                        || l_where_position
                        || '~'
                        || l_where_clause
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;
         END IF;
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'segstruct_view',
                                                      l_error_location,
                                                      l_status,
                                                      l_error_msg,
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
   END segstruct_view;

---------------------------------------------------------------------
--
-- Procedure Name: anomaly_view
--
-- Description
--   For all the views having anomalies for same column with different column types in different queries
--   Populates the data cache views metadata into non-template tables.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
    PROCEDURE anomaly_view IS
      l_error_msg                    VARCHAR2 (2000)                  := NULL;
      l_status                       VARCHAR2 (30)                    := NULL;
      l_error_location               VARCHAR2 (200)                   := NULL;
      l_success_status               VARCHAR2 (30)               := 'SUCCESS';
      l_error_status                 VARCHAR2 (1000)               := 'ERROR';
      l_error_number                 NUMBER                           := NULL;
      l_column_exists                NUMBER;
      l_script_name                  VARCHAR2 (100)
                                          := 'n_gseg_integration_pkg';
      l_col_expression               n_view_columns.column_expression%TYPE
                                                                      := NULL;
      l_column_name_prefix           n_view_columns.column_label%TYPE := NULL;
      --The original columns will be retained only for INV_Reservations view,
      --as the view shows some information in the original columns so we are not suppressing those columns
      l_retain_orig_columns_4_view1  n_views.view_label%TYPE          := 'INV_Reservations';
      l_retain_orig_columns_4_view2  n_views.view_label%TYPE          := 'INV_Item_Demand_Seg_Base';

      l_column_property_type         VARCHAR2 (200);
      l_property_type_id             n_view_properties.property_type_id%TYPE;
      l_t_view_property_id           n_view_properties.t_view_property_id%TYPE;
      l_view_property_id             n_view_properties.view_property_id%TYPE;
      l_t_column_id                  n_view_columns.t_column_id%TYPE;
      l_column_id                    n_view_columns.column_id%TYPE;
      ls_table_alias                 VARCHAR2(100);
      ls_segment_name                VARCHAR2(100);
      li_bom_view_exists             BINARY_INTEGER := 0;

--Cursor Declarations---

      --Cursor to retrieve only the anomaly view columns having the column_type as SEG% or KEY%
      CURSOR cur_get_view_dtls IS
      SELECT view_name,
             view_label,
             column_id,
             t_column_id,
             column_name,
             column_label,
             column_type,
             query_position,
             id_flex_code,
             id_flex_application_id,
             profile_option,
             application_instance,
             column_position,
             group_by_flag
        FROM ( SELECT c.view_name,
                      c.view_label,
                      c.column_id,
                      c.t_column_id,
                      c.column_name,
                      c.column_label,
                      q.query_position,
                      c.id_flex_code,
                      c.id_flex_application_id,
                      COUNT (*) OVER (PARTITION BY c.view_name,
                                                   c.column_label)      qry_cnt,
                      COUNT (*) OVER (PARTITION BY c.view_name,
                                                   c.column_label,
                                                   c.column_type)       col_type_cnt,
                      COUNT (*) OVER (PARTITION BY c.view_name,
                                                   c.column_label,
                                                   c.column_type,
                                                   c.id_flex_code)      col_kff_cnt,
                      column_type,
                      c.profile_option,
                      c.application_instance,
                      c.column_position,
                      c.group_by_flag
                 FROM n_view_columns    c,
                      n_views           v,
                      n_view_queries    q
                WHERE (    v.view_label IN
                              ( 'AR_SLA_Transaction_Dist',
                                'ASO_Quote_Sales_Credits',
                                'BOM_Routing_Comparisons',
                                'CSF_Debrief_Expense_Lines',
                                'CSF_Debrief_Labor_Lines',
                                'CSF_Debrief_Material_Lines',
                                'EAM_Asset_Downtime',
                                'EAM_WO_Actual_Cost_Details',
                                'EAM_WO_Cost_Details',
                                'EAM_WO_Matrl_Requirements',
                                'FA_Adjustments_SLA_GL_Je',
                                'OKS_Sales_Credits',
                                'PA_SLA_Revenue_Dist',
                                'XLA_PA_Revenue_Dist',
				'WIP_Routings_Hydra_QCP_Vsat',
                                'WIP_Routings'                  )
                        OR (     v.view_label   = 'INV_Reservations'
                             AND c.column_label = 'Demand_Source' )
                        OR (     v.view_label   = 'INV_Item_Demand_Seg_Base'
                             AND c.column_label = 'Source_Name' )         )
                  AND v.application_instance    = 'G0'
                  AND NVL(v.omit_flag, 'N')     = 'N'
                  AND q.view_name               = v.view_name
                  AND NVL(q.omit_flag, 'N')     = 'N'
                  AND c.view_name               = v.view_name
                  AND c.query_position          = q.query_position
                  AND NVL(c.omit_flag, 'N')     = 'N'
                  AND EXISTS
                    ( SELECT 'X'
                        FROM n_view_columns subc
                       WHERE c.column_label             = subc.column_label
                         AND NVL(subc.omit_flag, 'N')   = 'N'
                         AND (    subc.column_type   LIKE 'SEG%'
                               OR subc.column_type   LIKE 'KEY%' )
                         AND (    subc.column_type     <> 'SEGSTRUCT'
                               OR subc.column_type     <> 'SEGEXPR' )
                         AND c.view_name                = subc.view_name   ) ) mainq
       WHERE mainq.qry_cnt <> mainq.col_type_cnt
         AND id_flex_code  IS NOT NULL
       ORDER BY view_name,
                column_label,
                query_position;

--Cursor to retreive all the columns for a view and column label across queries
      CURSOR cur_get_all_dtls( p_view_name    VARCHAR2,
                               p_column_label VARCHAR2 ) IS
      SELECT view_name,
             view_label,
             column_name,
             column_label,
             t_column_id,
             column_id,
             column_type,
             query_position,
             id_flex_code,
             id_flex_application_id,
             profile_option,
             application_instance,
             column_position,
             group_by_flag,
             source_column_id
        FROM n_view_columns c
       WHERE c.view_name           = p_view_name
         AND c.column_label        = p_column_label
         AND c.column_type  NOT LIKE 'ATTR'
       ORDER BY c.view_name,
                c.column_label,
                c.query_position;

--Retreive the global seg columns added by intergration scripts
      CURSOR cur_gseg_qry_cols( p_view_name        VARCHAR2,
                                p_column_prefix    VARCHAR2,
                                p_query_position   NUMBER    ) IS
      SELECT c.t_column_id, c.column_id,    c.source_column_id,
             c.column_name, c.column_label, c.column_expression,
             c.column_type, c.description,  c.table_alias,
             c.id_flex_application_id,      c.id_flex_code,
             lov_view_label, --NV-1077
             lov_view_name, --NV-1077
             lov_column_label --NV-1077
        FROM n_view_columns c,
             n_view_tables t
       WHERE
           (    c.column_name LIKE p_column_prefix || '$%'
             OR c.column_name LIKE 'Z$' || p_column_prefix || '$%'         )
         AND c.view_name         = p_view_name
         AND c.query_position    = p_query_position
         AND c.id_flex_code     IS NOT NULL
         AND t.view_name         = c.view_name
         AND t.query_position    = c.query_position
         AND t.table_alias       = c.table_alias
         -- NOTE:  This needs to be the table_name rather than metadata_table_name.  We're expecting this to be like 'XXK%'
         --        The metadata_table_name may have the original oracle EBS table_name (eg GL_CODE_COMBINATIONS).
         AND t.table_name     LIKE n_gseg_utility_pkg.g_kff_dc_view_pfx || '%';

--Retreive the orginal column for the seg columns
      CURSOR cur_orig_col( p_view_name        VARCHAR2,
                           p_column_prefix    VARCHAR2,
                           p_query_position   NUMBER,
                           p_col_type         VARCHAR2 )  IS
      SELECT c.t_column_id,       c.column_id,   c.source_column_id,
             c.column_expression, c.column_name, c.column_label,
             c.table_alias, c.column_type
        FROM n_view_columns c,
             n_view_tables t
       WHERE c.column_name          LIKE p_column_prefix || '$' || p_col_type || '$%'
         AND c.view_name               = p_view_name
         AND c.query_position          = p_query_position
         AND c.id_flex_code           IS NOT NULL
         AND t.view_name               = c.view_name
         AND t.query_position          = c.query_position
         AND t.table_alias             = c.table_alias
         -- NOTE:  This needs to be the table_name rather than metadata_table_name.  We're expecting this to be like 'XXK%'
         --        The metadata_table_name may have the original oracle EBS table_name (eg GL_CODE_COMBINATIONS).
         AND t.table_name           LIKE n_gseg_utility_pkg.g_kff_dc_view_pfx || '%'
         AND ROWNUM                    = 1;

      rec_orig_col                   cur_orig_col%ROWTYPE;

--Following cursor to compensate band-aid seg and global seg processing
--cursor to retrieve the anomaly view columns
--***Please remove the below condition if Band-aid processing is obsolete and removed from the installs***
      CURSOR cur_apply_orig_column_name  IS
      SELECT mainq.view_name,
             mainq.view_label,
             mainq.column_id,
             mainq.t_column_id,
             mainq.column_name,
             mainq.column_label,
             mainq.column_type,
             mainq.query_position,
             mainq.id_flex_code,
             mainq.id_flex_application_id,
             mainq.application_instance
        FROM ( SELECT c.view_name,
                      c.view_label,
                      c.column_id,
                      c.t_column_id,
                      c.column_name,
                      c.column_label,
                      q.query_position,
                      c.id_flex_code,
                      c.id_flex_application_id,
                      COUNT (*) OVER ( PARTITION BY c.view_name,
                                                    c.column_label   )   qry_cnt,
                      COUNT (*) OVER ( PARTITION BY c.view_name,
                                                    c.column_label,
                                                    c.column_type    )   col_type_cnt,
                      column_type,
                      c.application_instance,
                      v.application_label,
                      v.first_active_query_position
                 FROM n_view_columns c,
                      n_views        v,
                      n_view_queries q
                WHERE (    c.column_type         IN ('GEN', 'EXPR')
                        OR (     v.view_label     = 'EAM_WO_Matrl_Requirements'
                             AND c.column_label  IN ('PO_Cat', 'Locator', 'Purch_Cat')
                             AND c.column_type LIKE 'GEN%'        )  )
                  AND v.view_label               IN ( 'CSF_Debrief_Expense_Lines',
                                                      'CSF_Debrief_Labor_Lines',
                                                      'CSF_Debrief_Material_Lines',
                                                      'EAM_Asset_Downtime',
                                                      'EAM_WO_Cost_Details',
                                                      'EAM_WO_Matrl_Requirements',
                                                      'INV_Reservations',
                                                      'INV_Item_Demand_Seg_Base',
                                                      'OKS_Sales_Credits',
                                                      'PJM_Req_PO_Invoices'   )
                  AND v.application_instance  = 'G0'
                  AND NVL (v.omit_flag, 'N')  = 'N'
                  AND q.view_name             = v.view_name
                  AND NVL (q.omit_flag, 'N')  = 'N'
                  AND c.view_name             = v.view_name
                  AND c.query_position        = q.query_position
                  AND NVL (c.omit_flag, 'N')  = 'N'
                  AND EXISTS
                    ( SELECT 'X'
                        FROM n_view_columns subc
                       WHERE c.column_label               = subc.column_label
                         AND NVL (subc.omit_flag, 'N')    = 'N'
                         AND (    subc.column_type     LIKE 'SEG%'
                                 OR subc.column_type     LIKE 'KEY%' )
                         AND (    subc.column_type       <> 'SEGSTRUCT'
                               OR subc.column_type       <> 'SEGEXPR' )
                         AND c.view_name                  = subc.view_name     )  ) mainq
       WHERE mainq.qry_cnt <> mainq.col_type_cnt
         AND EXISTS
           ( SELECT 1
               FROM n_view_properties         cp,
                    n_property_type_templates pt
              WHERE cp.view_name               = mainq.view_name
                AND cp.query_position          = mainq.query_position
                AND cp.source_pk_id            = mainq.column_id
                AND cp.value5                  = 'LEGACY'
                AND pt.property_type_id        = cp.property_type_id
                AND pt.templates_table_name    = 'N_VIEW_COLUMN_TEMPLATES' )
         AND mainq.first_active_query_position = mainq.query_position
         AND EXISTS
           ( SELECT 1
               FROM n_view_parameter_extensions pext
              WHERE pext.parameter_name        = 'GEN_' || mainq.application_label || '_KFF_COLS'
                AND pext.install_stage         = 4
                AND pext.value                 = 'Y'
                AND pext.install_creation_date =
                  ( SELECT MAX (nvp.creation_date)
                      FROM n_view_parameters nvp
                     WHERE nvp.install_stage = 4 ) );
--
-- This cursor highlights the views where the kff column is not in the
-- first query. For legacy processing, we need to make sure that column
-- in the first query is simply the legacy name.
      CURSOR cur_apply_orig_column_name2  IS
      SELECT mainq.view_name,
             mainq.view_label,
             mainq.column_id,
             mainq.t_column_id,
             mainq.column_name,
             mainq.column_label,
             mainq.column_type,
             mainq.id_flex_code,
             mainq.id_flex_application_id,
             mainq.application_instance,
             min(mainq.query_position) min_kff_query_position
        FROM ( SELECT c.view_name,
                      c.view_label,
                      c.column_id,
                      c.t_column_id,
                      c.column_name,
                      c.column_label,
                      q.query_position,
                      c.id_flex_code,
                      c.id_flex_application_id,
                      COUNT (*) OVER ( PARTITION BY c.view_name,
                                                    c.column_label   )   qry_cnt,
                      COUNT (*) OVER ( PARTITION BY c.view_name,
                                                    c.column_label,
                                                    c.column_type    )   col_type_cnt,
                      column_type,
                      c.application_instance,
                      v.application_label,
                      v.first_active_query_position
                 FROM n_view_columns c,
                      n_views v,
                      n_view_queries q
                WHERE (    c.column_type         IN ('GEN', 'EXPR')
                        OR (     v.view_label     = 'EAM_WO_Matrl_Requirements'
                             AND c.column_label  IN ('PO_Cat', 'Locator', 'Purch_Cat')
                             AND c.column_type LIKE 'GEN%'        )  )
                  AND v.view_label               IN ( 'CSF_Debrief_Expense_Lines',
                                                      'CSF_Debrief_Labor_Lines',
                                                      'CSF_Debrief_Material_Lines',
                                                      'EAM_Asset_Downtime',
                                                      'EAM_WO_Cost_Details',
                                                      'EAM_WO_Matrl_Requirements',
                                                      'INV_Reservations',
                                                      'OKS_Sales_Credits',
                                                      'PJM_Req_PO_Invoices'   )
                  AND v.application_instance  = 'G0'
                  AND NVL (v.omit_flag, 'N')  = 'N'
                  AND q.view_name             = v.view_name
                  AND NVL (q.omit_flag, 'N')  = 'N'
                  AND c.view_name             = v.view_name
                  AND c.query_position        = q.query_position
                  AND NVL (c.omit_flag, 'N')  = 'N'
                  AND EXISTS
                    ( SELECT 'X'
                        FROM n_view_columns subc
                       WHERE c.column_label               = subc.column_label
                         AND NVL (subc.omit_flag, 'N')    = 'N'
                         AND (    subc.column_type     LIKE 'SEG%'
                                 OR subc.column_type     LIKE 'KEY%' )
                         AND (    subc.column_type       <> 'SEGSTRUCT'
                               OR subc.column_type       <> 'SEGEXPR' )
                         AND c.view_name                  = subc.view_name     )  ) mainq
       WHERE mainq.qry_cnt <> mainq.col_type_cnt
         AND EXISTS
           ( SELECT 1
               FROM n_view_properties         cp,
                    n_property_type_templates pt
              WHERE cp.view_name               = mainq.view_name
                AND cp.query_position          = mainq.query_position
                AND cp.source_pk_id            = mainq.column_id
                AND cp.value5                  = 'LEGACY'
                AND pt.property_type_id        = cp.property_type_id
                AND pt.templates_table_name    = 'N_VIEW_COLUMN_TEMPLATES' )
       AND mainq.first_active_query_position <> mainq.query_position
         AND EXISTS
           ( SELECT 1
               FROM n_view_parameter_extensions pext
              WHERE pext.parameter_name        = 'GEN_' || mainq.application_label || '_KFF_COLS'
                AND pext.install_stage         = 4
                AND pext.value                 = 'Y'
                AND pext.install_creation_date =
                  ( SELECT MAX (nvp.creation_date)
                      FROM n_view_parameters nvp
                     WHERE nvp.install_stage = 4 ) )
      group by mainq.view_name,
             mainq.view_label,
             mainq.column_id,
             mainq.t_column_id,
             mainq.column_name,
             mainq.column_label,
             mainq.column_type,
             mainq.id_flex_code,
             mainq.id_flex_application_id,
             mainq.application_instance
      ;
--
---BEGIN Processing---
   BEGIN
      l_error_location := l_script_name || '-start anomaly processing';

      FOR rec_c IN cur_get_view_dtls  LOOP
         l_column_name_prefix := ( CASE
                                     WHEN (     LENGTHB(rec_c.column_label)     > 8
                                            AND INSTRB(rec_c.column_label, '_') > 0 )
                                          THEN ( CASE
                                                   WHEN ( INSTRB(SUBSTRB(rec_c.column_label,1,8), '_') > 0 )
                                                        THEN SUBSTRB(rec_c.column_label, 1, 8)
                                                   ELSE SUBSTRB(rec_c.column_label, 1, 7) ||
                                                        SUBSTRB(rec_c.column_label, INSTRB(rec_c.column_label, '_') + 1,1)
                                                 END )
                                     WHEN (     LENGTHB(rec_c.column_label)     > 8
                                            AND INSTRB(rec_c.column_label, '_') = 0 )
                                          THEN SUBSTRB(rec_c.column_label, 1, 8)
                                     ELSE rec_c.column_label
                                   END  );

          l_column_name_prefix := RTRIM(l_column_name_prefix,'_');

         ---Below logic to insert the original column
         BEGIN
            SELECT COUNT (*)
              INTO l_column_exists
              FROM n_view_columns c
             WHERE c.view_name      = rec_c.view_name
               AND c.column_name    = rec_c.column_label
               AND c.query_position = rec_c.query_position;

            IF (     l_column_exists    = 0
                 AND (rec_c.view_label in ( l_retain_orig_columns_4_view1,
                                            l_retain_orig_columns_4_view2 ) ) ) THEN
               l_error_location := 'inserting the original column into n_view_columns';
               l_col_expression := NULL;

               OPEN cur_orig_col( rec_c.view_name,
                                  l_column_name_prefix,
                                  rec_c.query_position,
                                  n_gseg_utility_pkg.g_kff_dc_concat_val_pfx  );

               FETCH cur_orig_col
                INTO rec_orig_col;

               IF ( cur_orig_col%FOUND ) THEN
                  l_col_expression := rec_orig_col.column_expression;
               END IF;

               CLOSE cur_orig_col;

               IF ( l_col_expression IS NULL ) THEN
                  OPEN cur_orig_col( rec_c.view_name,
                                     l_column_name_prefix,
                                     rec_c.query_position,
                                     n_gseg_utility_pkg.g_kff_dc_seg_val_pfx   );

                  FETCH cur_orig_col
                   INTO rec_orig_col;

                  IF ( cur_orig_col%FOUND ) THEN
                     l_col_expression := rec_orig_col.column_expression;
                  END IF;

                  CLOSE cur_orig_col;
               END IF;

               IF ( l_col_expression IS NULL ) THEN

                  n_gseg_utility_pkg.insert_view_column
                    (i_t_column_id                 => rec_c.t_column_id,
                     i_view_name                   => rec_c.view_name,
                     i_view_label                  => rec_c.view_label,
                     i_query_position              => rec_c.query_position,
                     i_column_name                 => rec_c.column_label,
                     i_column_label                => rec_c.column_label,
                     i_table_alias                 => NULL,
                     i_column_expression           => 'TO_CHAR(NULL)',
                     i_column_position             => rec_c.column_position,
                     i_column_type                 => 'GENEXPR',
                     i_description                 => NULL,
                     i_ref_lookup_column_name      => NULL,
                     i_group_by_flag               => rec_c.group_by_flag,
                     i_application_instance        => rec_c.application_instance,
                     i_gen_search_by_col_flag      => 'N',
                     i_generated_flag              => 'Y',
                     i_id_flex_application_id      => NULL,
                     i_id_flex_code                => NULL,
                     o_column_id                   => l_column_id );
               ELSE
                  n_gseg_utility_pkg.insert_view_column
                    (i_t_column_id                 => rec_c.t_column_id,
                     i_view_name                   => rec_c.view_name,
                     i_view_label                  => rec_c.view_label,
                     i_query_position              => rec_c.query_position,
                     i_column_name                 => rec_c.column_label,
                     i_column_label                => rec_c.column_label,
                     i_table_alias                 => rec_orig_col.table_alias,
                     i_column_expression           => l_col_expression,
                     i_column_position             => rec_c.column_position,
                     i_column_type                 => 'GEN',
                     i_description                 => NULL,
                     i_ref_lookup_column_name      => NULL,
                     i_group_by_flag               => rec_c.group_by_flag,
                     i_application_instance        => rec_c.application_instance,
                     i_gen_search_by_col_flag      => 'N',
                     i_generated_flag              => 'Y',
                     i_id_flex_application_id      => rec_c.id_flex_application_id,
                     i_id_flex_code                => rec_c.id_flex_code,
                     o_column_id                   => l_column_id                   );
               END IF;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_c.view_name
                  || '~'
                  || rec_c.query_position
                  || '~'
                  || rec_c.column_name
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

         FOR rec_segcol IN cur_gseg_qry_cols( rec_c.view_name,
                                              l_column_name_prefix,
                                              rec_c.query_position  ) LOOP
            l_error_location := 'derving column expression for the seg column';

            --Verify if the column is PK column and change the column expression to NUMBER
            IF ( SUBSTRB(rec_segcol.column_name, 1, 2) = 'Z$' ) THEN
               l_col_expression := 'CHARTOROWID(NULL)';
            ELSE
               BEGIN
                  SELECT 'TO_NUMBER(NULL)'
                    INTO l_col_expression
                    FROM n_kff_flex_source_templates
                   WHERE
                       (    UPPER (kff_table_pk1) = UPPER (rec_segcol.column_expression)
                         OR UPPER (kff_table_pk2) = UPPER (rec_segcol.column_expression)   )
                     AND id_flex_application_id   = rec_segcol.id_flex_application_id
                     AND id_flex_code             = rec_segcol.id_flex_code
                     AND ROWNUM                   = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND   THEN
                     l_col_expression := 'TO_CHAR(NULL)';
                  WHEN OTHERS          THEN
                     l_col_expression := 'TO_CHAR(NULL)';
               END;
            END IF;

            FOR rec_colqry IN cur_get_all_dtls( rec_c.view_name,
                                                rec_c.column_label ) LOOP
               IF ( rec_c.query_position <> rec_colqry.query_position ) THEN
                  SELECT COUNT (*)
                    INTO l_column_exists
                    FROM n_view_columns c
                   WHERE c.view_name        = rec_colqry.view_name
                     AND c.column_name      = rec_segcol.column_name
                     AND c.query_position   = rec_colqry.query_position;

                  BEGIN
                     IF ( l_column_exists = 0 ) THEN
                        l_error_location := 'inserting into n_view_columns';

                        n_gseg_utility_pkg.insert_view_column
                           (i_t_column_id                 => rec_colqry.t_column_id,
                            i_view_name                   => rec_colqry.view_name,
                            i_view_label                  => rec_colqry.view_label,
                            i_query_position              => rec_colqry.query_position,
                            i_column_name                 => rec_segcol.column_name,
                            i_column_label                => rec_c.column_label,
                            i_table_alias                 => NULL,
                            i_column_expression           => l_col_expression,
                            i_column_position             => rec_colqry.column_position,
                            i_column_type                 => 'GENEXPR',
                            i_description                 => rec_segcol.description,
                            i_ref_lookup_column_name      => NULL,
                            i_group_by_flag               => rec_colqry.group_by_flag,
                            i_application_instance        => rec_colqry.application_instance,
                            i_gen_search_by_col_flag      => 'N',
							i_lov_view_label              => rec_segcol.lov_view_label, --NV-1077
                            i_lov_view_name               => rec_segcol.lov_view_name, --NV-1077
                            i_lov_column_label            => rec_segcol.lov_column_label, --NV-1077
                            i_generated_flag              => 'Y',
                            i_id_flex_application_id      => rec_colqry.id_flex_application_id,
                            i_id_flex_code                => rec_colqry.id_flex_code,
                            o_column_id                   => l_column_id           );

                        l_column_property_type :=
                           (CASE
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_seg_val_pfx
                                      || '$%'
                                  THEN 'SEGMENT_VALUE'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_seg_desc_pfx
                                      || '$%'
                                  THEN 'SEGMENT_DESCRIPTION'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_concat_val_pfx
                                      || '$%'
                                  THEN 'CONCATENATED_VALUES'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_concat_desc_pfx
                                      || '$%'
                                  THEN 'CONCATENATED_DESCRIPTIONS'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_qual_val_pfx
                                      || '$%'
                                  THEN 'QUALIFIER_VALUE'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_qual_desc_pfx
                                      || '$%'
                                  THEN 'QUALIFIER_DESCRIPTION'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || 'Segment_Name_List'
                                      || '$%'
                                  THEN 'SEGMENT_NAME_LIST'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || 'Structure_Name'
                                      || '$%'
                                  THEN 'STRUCTURE_NAME'
                               ELSE 'PRIMARY_KEY'
                            END
                           );

                        n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => rec_colqry.view_name,
                            i_view_label                       => rec_colqry.view_label,
                            i_query_position                   => rec_colqry.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => rec_colqry.t_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id      );

                        -- Special processing for Z$ columns
                        IF ( rec_segcol.column_name LIKE 'Z$%' ) THEN
                             -- Determine if the Z$$ column exists
                             SELECT COUNT (*)
                               INTO l_column_exists
                               FROM n_view_columns c
                              WHERE c.view_name        = rec_colqry.view_name
                                AND c.column_name   LIKE 'Z$$%'
                                AND c.query_position   = rec_colqry.query_position;

                             -- If the Z$$ does not exist, then add to the query.
                             IF ( l_column_exists = 0 ) THEN
                                n_gseg_utility_pkg.insert_view_column
                                   (i_t_column_id                 => rec_colqry.t_column_id,
                                    i_view_name                   => rec_colqry.view_name,
                                    i_view_label                  => rec_colqry.view_label,
                                    i_query_position              => rec_colqry.query_position,
                                    i_column_name                 => 'Z$$_________________________',
                                    i_column_label                => 'NONE',
                                    i_table_alias                 => 'NONE',
                                    i_column_expression           => 'Z$$_________________________',
                                    i_column_position             => 1500,
                                    i_column_type                 => 'CONST',
                                    i_description                 => 'Columns following this are table rowids with values having meaning only internal to Oracle. Use them only to join to the view specified by the column name. ',
                                    i_ref_lookup_column_name      => NULL,
                                    i_group_by_flag               => rec_colqry.group_by_flag,
                                    i_application_instance        => rec_colqry.application_instance,
                                    i_gen_search_by_col_flag      => 'N',
                                    i_generated_flag              => 'Y',
                                    i_id_flex_application_id      => NULL,
                                    i_id_flex_code                => NULL,
                                    o_column_id                   => l_column_id           );
                             END IF;
                        END IF;

                     END IF;

                     l_error_location := 'updating n_view_columns omiting the columns';

                     --omit the orginal column if its not required
                     UPDATE n_view_columns c
                        SET omit_flag            = 'Y'
                      WHERE c.view_name          = rec_colqry.view_name
                        AND c.view_label    NOT IN ( l_retain_orig_columns_4_view1,
                                                     l_retain_orig_columns_4_view2 )
                        AND c.query_position       = rec_colqry.query_position
                        AND c.column_name          = rec_c.column_label
                        AND c.column_position      = rec_colqry.column_position
                        AND c.application_instance = 'G0'
                        AND c.column_type   NOT LIKE 'SEG%'
                        AND NVL(c.omit_flag, 'N')  = 'N'
                        --Below condition is added to verfiy if the band-aid seg columns are installed or not.
                        --The original columns will be omitted if the band-aid seg columns are not installed.
                        --The verification is done based on module parameter and its value in param extention table
                        --***Please remove the below condition if Band-aid processing is obsolete and removed from the installs***
                        AND NOT EXISTS
                          ( SELECT 1
                              FROM n_views                     v,
                                   n_view_parameter_extensions pext
                             WHERE v.view_name                = c.view_name
                               AND pext.parameter_name        = 'GEN_'|| v.application_label || '_KFF_COLS'
                               AND pext.install_stage         = 4
                               AND VALUE                      = 'Y'
                               AND pext.install_creation_date =
                                 ( SELECT MAX (nvp.creation_date)
                                     FROM n_view_parameters nvp
                                    WHERE nvp.install_stage = 4));
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_colqry.view_name
                           || '~'
                           || rec_colqry.query_position
                           || '~'
                           || rec_segcol.column_name
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;
               END IF;
            END LOOP;        -- end of cursor cur_get_all_dtls for ALL columns
         END LOOP;      -- end of cursor cur_gseg_qry_cols
      END LOOP;     -- end of cursor cur_get_view_dtls to retrieve only SEGCOL

      COMMIT;
      --Following code to compensate band-aid seg and global seg processing
      --In the below code we are updating the first active query column_name with subsequent queries related column in the view
      --This column name update is done to maintain the ordering of the column across queries
      --The columns in other queires may be as-is column from metadata or generated column with some suffix
      --this might change the ordering of the columns in multiple queries and lead to issue in view creation
      --***Please remove the below condition if Band-aid processing is obsolete and removed from the installs***
      l_error_location := 'updating n_view_columns to column name for sequencing ordering of the columns';

      FOR rec_coln IN cur_apply_orig_column_name LOOP
         BEGIN
            UPDATE n_view_columns c
               SET column_name = rec_coln.column_name
             WHERE view_name = rec_coln.view_name
               AND c.query_position <> rec_coln.query_position
               AND c.column_label = rec_coln.column_label
               AND c.column_type IN ('GEN', 'EXPR')
               AND id_flex_code IS NULL;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_coln.view_name
                  || '~'
                  || rec_coln.query_position
                  || '~'
                  || rec_coln.column_label
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;
      END LOOP;
      --
      -- Now handle the records where the kff column isn't in the first query.
      FOR rec_coln2 IN cur_apply_orig_column_name2
      LOOP
         BEGIN
            UPDATE n_view_columns c
               SET c.column_name            = SUBSTRB(rec_coln2.column_name, 1, INSTRB(rec_coln2.column_name, '$')-1)
             WHERE c.view_name              = rec_coln2.view_name
               AND c.query_position        <> rec_coln2.min_kff_query_position
               AND c.column_label           = rec_coln2.column_label
               AND c.column_type           IN ('GEN', 'EXPR')
               AND rec_coln2.column_name LIKE '%$%'
               AND id_flex_code            IS NULL;
         EXCEPTION
            WHEN OTHERS  THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_coln2.view_name
                  || '~'
                  || rec_coln2.column_label
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;
      END LOOP;

      COMMIT;

      BEGIN

        SELECT COUNT(*)
          INTO li_bom_view_exists
          FROM n_views v
         WHERE UPPER(v.view_label)    LIKE 'BOM_CURRENT_STRUCTURED_BILLS'
           AND v.application_instance LIKE 'G0';

        IF ( li_bom_view_exists > 0 ) THEN

            SELECT s.target_column_name
              INTO ls_segment_name
              FROM n_f_kff_flex_sources fs,
                   n_f_kff_segments     s
             WHERE fs.id_flex_code        = 'MSTK'
               AND fs.source_type         = 'DC'
               AND fs.data_application_id = 401
               AND s.data_table_key       = fs.data_table_key
               AND ROWNUM = 1
             ORDER BY s.segment_order;

             SELECT tab.table_alias
               INTO ls_table_alias
               FROM ( SELECT *
                        FROM n_view_tables a
                       WHERE a.application_instance = 'G0'
                         AND a.view_label           = 'BOM_Current_Structured_Bills'
                         AND a.from_clause_position >
                           ( SELECT b.from_clause_position
                               FROM n_view_tables b
                              WHERE b.table_alias          = 'TASSY'
                                AND b.application_instance = 'G0'
                                AND b.view_label           = 'BOM_Current_Structured_Bills'  )
                       ORDER BY a.from_clause_position ) tab
               WHERE rownum=1;

              DELETE n_view_wheres s
               WHERE s.application_instance = 'G0'
                 AND UPPER(s.view_label)    = 'BOM_CURRENT_STRUCTURED_BILLS'
                 AND s.where_clause      LIKE '%'||ls_table_alias||'%'
                 AND s.query_position       = 8;

              DELETE n_view_tables T
               WHERE t.application_instance = 'G0'
                 AND UPPER(t.view_label)    = 'BOM_CURRENT_STRUCTURED_BILLS'
                 AND t.table_alias       LIKE 'TASSY'
                 AND t.query_position       = 8;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = 'AND HIER.TOP_ASSY_ITEM = '||ls_table_alias||'.'||ls_segment_name||''
               WHERE upd.view_label           = 'BOM_Current_Structured_Bills'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause      LIKE ' AND HIER.TOP_ASSY_ITEM = TASSY%' ;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'TASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Structured_Bills'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ITEM_ID = TASSY.INVENTORY_ITEM_ID';

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'TASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Structured_Bills'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ORGANIZATION_ID = TASSY.ORGANIZATION_ID';

              COMMIT;
        END IF;
      END;

-- Issue:NV-143 --start--
   -- Handling BOM_Current_Struct_Base view
BEGIN

        SELECT COUNT(*)
          INTO li_bom_view_exists
          FROM n_views v
         WHERE UPPER(v.view_label)    LIKE 'BOM_CURRENT_STRUCT_BASE'
           AND v.application_instance LIKE 'G0';

        IF ( li_bom_view_exists > 0 ) THEN

            SELECT s.target_column_name
              INTO ls_segment_name
              FROM n_f_kff_flex_sources fs,
                   n_f_kff_segments     s
             WHERE fs.id_flex_code        = 'MSTK'
               AND fs.source_type         = 'DC'
               AND fs.data_application_id = 401
               AND s.data_table_key       = fs.data_table_key
               AND ROWNUM = 1
             ORDER BY s.segment_order;

             SELECT tab.table_alias
               INTO ls_table_alias
               FROM ( SELECT *
                        FROM n_view_tables a
                       WHERE a.application_instance = 'G0'
                         AND a.view_label           = 'BOM_Current_Struct_Base'
                         AND a.from_clause_position >
                           ( SELECT b.from_clause_position
                               FROM n_view_tables b
                              WHERE b.table_alias          = 'ASSY'
                                AND b.application_instance = 'G0'
                                AND b.view_label           = 'BOM_Current_Struct_Base'
                                AND B.query_position       = 8                )
                       ORDER BY a.from_clause_position ) tab
               WHERE rownum=1;

              DELETE n_view_wheres s
               WHERE s.application_instance = 'G0'
                 AND UPPER(s.view_label)    = 'BOM_CURRENT_STRUCT_BASE'
                 AND s.where_clause      LIKE '%'||ls_table_alias||'%'
                 AND s.query_position       = 8;

              DELETE n_view_tables T
               WHERE t.application_instance = 'G0'
                 AND UPPER(t.view_label)    = 'BOM_CURRENT_STRUCT_BASE'
                 AND t.table_alias       LIKE 'ASSY'
                 AND t.query_position       = 8;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = 'AND HIER.TOP_ASSY_ITEM = '||ls_table_alias||'.'||ls_segment_name||''
               WHERE upd.view_label           = 'BOM_Current_Struct_Base'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause      LIKE 'AND HIER.TOP_ASSY_ITEM = ASSY%' ;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'ASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Struct_Base'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ITEM_ID = ASSY.INVENTORY_ITEM_ID';

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'ASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Struct_Base'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ORGANIZATION_ID = ASSY.ORGANIZATION_ID';

         COMMIT;
        END IF;
      END;
-- Issue:NV-143 --end--
   EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'anomaly_view',
                                                      l_error_location,
                                                      l_error_status,
                                                      NVL (l_error_msg,
                                                           SQLERRM
                                                          ),
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
   END anomaly_view;

--
---------------------------------------------------------------------
--
-- Procedure Name: flexsource_direct
--
-- Description
--   For all the views with source_type as DIRECT, populates the flexfield column metadata into non-template tables.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE flexsource_direct IS
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_error_code                  NUMBER                            := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                     := 'SUCCESS';
      l_error_status                VARCHAR2 (1000)                   := 'ERROR';
      l_in_process_status           VARCHAR2 (30)                     := 'IN-PROCESS';
      l_error_number                NUMBER                            := NULL;
      l_column_position             NUMBER                               := 0;
      l_column_name                 VARCHAR2 (30)                     := NULL;
      l_column_expr                 VARCHAR2 (1000)                   := NULL;
      l_column_exists               NUMBER;
      l_column_name_prefix          VARCHAR2 (30)                     := NULL;
      l_md_struct_constraint_type   VARCHAR2 (20);
      l_col_description             n_view_columns.description%TYPE   := NULL;
      l_column_type                 n_view_columns.column_type%TYPE;
      l_column_property_type        n_property_type_templates.property_type%TYPE;
      l_view_property_id            n_view_properties.view_property_id%TYPE;
      l_t_view_property_id          n_view_properties.t_view_property_id%TYPE;
      l_column_id                   n_view_columns.column_id%TYPE;
      l_t_column_id                 n_view_columns.t_column_id%TYPE;

---Determine the column first
      CURSOR c1 IS
      SELECT c.view_name,
             c.query_position,
             c.column_label,
             c.t_column_id,
             c.column_id,
             c.table_alias,
             t.from_clause_position,
             c.column_position,
             t.table_name,
             t.metadata_table_name,
             c.id_flex_code,
             ( CASE
                 WHEN (     c.id_flex_application_id = 800
                        AND c.id_flex_code IN ('COST', 'BANK', 'GRP') )  THEN 801
                 ELSE c.id_flex_application_id
               END      )                                   id_flex_application_id,
             ( CASE
                 WHEN ( c.column_type = 'SEGCAT' ) THEN 'SEG'
                 ELSE c.column_type
               END      )                                   column_type,
             v.special_process_code,
             v.security_code,
             v.view_label,
             v.application_instance,
             c.group_by_flag,
             fs.data_table_key,
             ( SELECT ct.description
                 FROM n_view_column_templates ct
                WHERE ct.view_label                          = c.view_label
                  AND ct.query_position                      = c.query_position
                  AND ct.column_label                        = c.column_label
                  AND REPLACE( ct.column_type, 'KEY', 'SEG') = c.column_type
                  AND NVL( ct.profile_option, 'XX' )         = NVL( c.profile_option, 'XX' )
                  AND ROWNUM = 1 )                          description,
             COUNT( c.view_name )
              OVER ( PARTITION BY fs.data_table_key,
                                  c.view_name,
                                  c.query_position )        no_of_str
        FROM n_view_columns c,
             n_view_tables t,
             n_views v,
             n_f_kff_flex_sources fs
       WHERE fs.id_flex_application_id      = ( CASE
                                                  WHEN (     c.id_flex_application_id  = 800
                                                         AND c.id_flex_code           IN ('COST', 'BANK', 'GRP') ) THEN 801
                                                  ELSE c.id_flex_application_id
                                                END )
         AND fs.id_flex_code                = c.id_flex_code
         AND fs.data_application_table_name = t.metadata_table_name
         AND fs.source_type                 = 'DIRECT'
         AND c.column_type               LIKE 'SEG%'
         AND c.column_type             NOT IN ('SEGP', 'SEGEXPR', 'SEGSTRUCT')
         AND c.application_instance         = 'G0'
         --AND c.generated_flag               = 'N'
         AND c.view_name                    = t.view_name
         AND c.query_position               = t.query_position
         AND c.table_alias                  = t.table_alias
         AND NVL( c.omit_flag, 'N' )        = 'N'
         AND c.view_name                    = v.view_name
         AND NVL( v.omit_flag, 'N' )        = 'N'
       ORDER BY column_type,
                view_name,
                query_position;

      CURSOR kff_struct_cur ( p_view_name        VARCHAR2,
                              p_column_id        INTEGER,
                              p_qry_pos          NUMBER,
                              p_data_table_key   VARCHAR2    ) IS
         SELECT NVL( colp.value2, str.id_flex_num ) structure_id,
                colp.value1,
                colp.value2,
                str.id_flex_num,
                str.structure_name
           FROM n_view_properties         colp,
                n_property_type_templates pt,
                n_f_kff_structures        str
          WHERE colp.view_name          = p_view_name
            AND colp.query_position     = p_qry_pos
            AND colp.source_pk_id       = p_column_id
            AND pt.property_type_id     = colp.property_type_id
            AND pt.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES'
            AND pt.property_type        = 'INCLUDE_STRUCTURE'
            AND str.data_table_key(+)   = p_data_table_key
            AND str.structure_name(+)   = colp.value1;

      CURSOR detect_multi_seg_direct( p_data_table_key   VARCHAR2,
                                      p_id_flex_num      NUMBER   ) IS
         SELECT id_flex_num,
                (CASE
                    WHEN seg_cnt = 1
                       THEN 'N'
                    ELSE 'Y'
                 END) multi_seg_detected
           FROM (SELECT   seg.id_flex_num, COUNT (*) seg_cnt
                     FROM n_f_kff_segments seg, n_f_kff_structures str
                    WHERE seg.data_table_key = p_data_table_key
                      AND str.data_table_key = seg.data_table_key
                      AND str.id_flex_num = p_id_flex_num
                 GROUP BY seg.id_flex_num)
          WHERE id_flex_num = p_id_flex_num;

      rec_multi_seg_direct          detect_multi_seg_direct%ROWTYPE;

      --given the data table key, this cursor gets the concatenated source expressions for the segment list
      CURSOR cur_concat_col (
         p_data_table_key              VARCHAR2,
         p_id_flex_num                 NUMBER,
         p_col_type                    VARCHAR2,
         p_md_struct_constraint_type   VARCHAR2,
         p_multi_seg_detected          VARCHAR2,
         p_exclude_helper_columns      NUMBER,
         p_include_concat_seg_val      NUMBER,
         p_include_concat_seg_pval     NUMBER,
         p_include_concat_seg_desc     NUMBER,
         p_include_concat_seg_pdesc    NUMBER
      )
      IS
         SELECT DISTINCT kcat.concatenation_type, kcat.target_column_name,
                         kcat.formatted_column_name,
                         (CASE
                             WHEN kcat.concatenation_type = 'LIST'
                                THEN 1
                             WHEN kcat.concatenation_type = 'VAL'
                                THEN 2
                             WHEN kcat.concatenation_type = 'PVAL'
                                THEN 3
                             WHEN kcat.concatenation_type = 'DESC'
                                THEN 4
                             WHEN kcat.concatenation_type = 'PDESC'
                                THEN 5
                          END
                         ) l,
                         kcat.source_expression
                    FROM n_f_kff_concatenations kcat
                   WHERE kcat.data_table_key = p_data_table_key
                     AND kcat.id_flex_num = p_id_flex_num
---Do not bring in the segment list column, if EXLCUDE_GLOBAL_HELPER_COLUMNS mentioned for the column property
                     AND (CASE
                             WHEN kcat.concatenation_type = 'LIST'
                             AND p_exclude_helper_columns = 0
                             AND p_include_concat_seg_val > 0
                             AND p_md_struct_constraint_type != 'SINGLE'
                             AND p_multi_seg_detected = 'Y'
                                THEN 1
---Bring in the concatenated value column, if corresponding property (INCLUDE_CONCAT_SEGMENT_VALUES)exists
                          WHEN kcat.concatenation_type = 'VAL'
                          AND p_include_concat_seg_val > 0
                          AND p_multi_seg_detected = 'Y'
                                THEN 2
                          END
                         ) IS NOT NULL
                ORDER BY l;

      CURSOR c4_1 ( p_data_table_key              NUMBER,
                    p_id_flex_num                 NUMBER,
                    p_md_struct_constraint_type   VARCHAR2,
                    p_exclude_helper_columns      NUMBER      ) IS
         WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL < 2)
         SELECT (CASE
                    WHEN ROWNUM = 2
                       THEN 'Structure_ID'
                    WHEN ROWNUM = 1
                       THEN 'Structure_Name'
                 END
                ) struct_column,
                struct.structure_name
           FROM DATA,
                n_f_kff_structures struct
          WHERE (CASE
                    WHEN p_exclude_helper_columns = 0
                    AND p_md_struct_constraint_type = 'MULTIPLE'
                       THEN 1
                    ELSE NULL
                 END
                ) = 1
            AND struct.data_table_key = p_data_table_key
            AND struct.id_flex_num = p_id_flex_num;

--for individual segment values
      CURSOR c6 (
         p_data_table_key           VARCHAR2,
         p_id_flex_num              NUMBER,
         p_include_indiv_seg_val    VARCHAR2,
         p_include_indiv_seg_desc   VARCHAR2,
         p_include_concat_seg_val   VARCHAR2,
         p_include_concat_seg_desc  VARCHAR2,
         p_multi_seg_detected       VARCHAR2,
         p_constraint_type          VARCHAR2,
         p_column_name_prefix       VARCHAR2
      )
      IS
select formatted_target_column_name, target_column_name, application_column_name,segment_name,
       count(1) over(partition by formatted_target_column_name) dup_col_cnt,
       ROW_NUMBER() over(partition by formatted_target_column_name order by formatted_target_column_name, target_column_name,segment_name ) sub_script
  from
(select n_gseg_utility_pkg.FORMAT_KFF_SEGMENT(p_column_name_prefix||'$'||target_column_name,30) formatted_target_column_name,
       target_column_name,application_column_name,segment_name
       from
  (WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL <= 1)
         SELECT data_table_key,
                (CASE
                    WHEN lvl = 1
                       THEN target_column_name
                    WHEN lvl = 2
                       THEN target_desc_column_name
                 END
                ) target_column_name,
                seg.application_column_name, seg.segment_name
           FROM DATA,
                n_f_kff_segments seg
          WHERE seg.data_table_key = p_data_table_key
            AND seg.id_flex_num = p_id_flex_num
            AND (CASE
                    WHEN (lvl = 1 AND (p_include_indiv_seg_val > 0) OR (p_include_indiv_seg_val = 0 AND p_include_concat_seg_val > 0 AND p_multi_seg_detected ='N'))
                       THEN 1
                    WHEN (lvl = 2 AND (p_include_indiv_seg_desc > 0) OR (p_include_indiv_seg_desc = 0 AND p_include_concat_seg_desc > 0 AND p_multi_seg_detected ='N'))
                       THEN 2
                 END
                ) IS NOT NULL));
   BEGIN
      l_error_location := 'n_glb_direct_segcol_integration-start';

      OPEN c3 (n_gseg_utility_pkg.g_kff_app_label);

      FETCH c3
       INTO r3;

      CLOSE c3;

--Primary cursor to get the view columns where the data cache metadata needs to be brought int
      FOR r1 IN c1
      LOOP                                                             --{ c1
         --The cursor c2 is only for getting the additional information about the data table key
         OPEN c2 (r1.id_flex_code, r1.id_flex_application_id, r1.metadata_table_name);

         --{c2
         FETCH c2
          INTO r2;

         CLOSE c2;

--Manifestation of column properties metadata
         OPEN col_prop_cur( r1.view_name, r1.column_label, r1.query_position);

         FETCH col_prop_cur
          INTO col_prop_rec;

         CLOSE col_prop_cur;

         --loop for each key flexfield structure of the view properties
         FOR rec_kff_struct IN kff_struct_cur (r1.view_name,
                                               col_prop_rec.column_id,
                                               r1.query_position,
                                               r1.data_table_key
                                              )
         LOOP
            --Derive the multi seg struct property
            OPEN detect_multi_seg_direct (r1.data_table_key,
                                          rec_kff_struct.structure_id
                                         );

            FETCH detect_multi_seg_direct
             INTO rec_multi_seg_direct;

            CLOSE detect_multi_seg_direct;

            IF col_prop_rec.include_structure_count = 0
            THEN
               l_md_struct_constraint_type := 'NONE';
            ELSIF col_prop_rec.include_structure_count = 1
            THEN
               l_md_struct_constraint_type := 'SINGLE';
            ELSE
               l_md_struct_constraint_type := 'MULTIPLE';
            END IF;

            --derive column name prefix
            l_column_name_prefix    := ( CASE
                                           WHEN (     LENGTHB(r1.column_label)     > 8
                                                  AND INSTRB(r1.column_label, '_') > 0 )
                                                THEN ( CASE
                                                         WHEN ( INSTRB(SUBSTRB(r1.column_label,1,8), '_') > 0 )
                                                              THEN SUBSTRB(r1.column_label, 1, 8)
                                                         ELSE SUBSTRB(r1.column_label, 1, 7) ||
                                                              SUBSTRB(r1.column_label, INSTRB (r1.column_label, '_') + 1,1)
                                                       END )
                                           WHEN (     LENGTHB(r1.column_label)     > 8
                                                  AND INSTRB(r1.column_label, '_') = 0 )
                                                THEN SUBSTRB(r1.column_label, 1, 8)
                                           ELSE r1.column_label
                                         END );

            l_column_name_prefix    := RTRIM( l_column_name_prefix, '_' );

            --l_column_name_prefix  := INITCAP( l_column_name_prefix );
            BEGIN
               SELECT MAX (column_position)
                 INTO l_column_position
                 FROM n_view_columns
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  NULL;
            END;

            OPEN c3_1 (r1.id_flex_code, r1.id_flex_application_id);    --{c3_1

            FETCH c3_1
             INTO r3_1;

            CLOSE c3_1;                                                --}c3_1

            l_error_location := 'Insert into n_view_columns';

---Structure columns
            FOR r4_1 IN c4_1( r1.data_table_key,
                              rec_kff_struct.structure_id,
                              l_md_struct_constraint_type,
                              col_prop_rec.exclude_structure_name_col  )
            LOOP                                                       --{c4_1
               BEGIN
                  l_error_location  := 'view columns metadata - structure columns ';
                  l_column_position := l_column_position + 0.1;
                  l_column_name     := r4_1.struct_column;
                  l_col_description := n_gseg_utility_pkg.g_kff_coldesc_structname_sfx;
                  l_col_description := r1.description
                                    || ' '
                                    || REPLACE( l_col_description, '<flexfield>',
                                                r2.kff_name );
                  l_column_name     :=( CASE
                                          WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                             THEN SUBSTRB(l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                          ELSE l_column_name
                                        END );
                  l_column_name     := RTRIM( l_column_name, '_' );

                  l_column_name     := l_column_name_prefix || '$' || l_column_name;

                  IF ( r1.no_of_str > 1 ) THEN
                      l_column_type := 'GENEXPR';
                      l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                          ||' THEN '''||r4_1.structure_name||''' ELSE NULL END';
                  ELSE
                     l_column_type := 'CONST';
                     l_column_expr := r4_1.structure_name;
                  END IF;

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => l_column_type,
                        i_description                 =>  l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id   );

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_property_type                    => 'STRUCTURE_NAME',
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id             );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                                  --}c4_1

---Qualifier columns
            FOR r4_2 IN c4_2 (r1.data_table_key,
                              r1.view_name,
                              col_prop_rec.column_id,
                              r1.query_position
                             )
            LOOP                                                       --{c4_2
               BEGIN
                  l_error_location  := 'view columns metadata - qualifier columns ';
                  l_column_position := l_column_position + 0.1;
                  l_column_expr     := r4_2.qual_col_name;
                  l_column_name     := r4_2.qual_col_name;
                  l_col_description := ( CASE
                                           WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_qv_sfx
                                           ELSE n_gseg_utility_pkg.g_kff_coldesc_qd_sfx
                                         END );
                  l_col_description := r1.description
                                    || ' '
                                    || REPLACE( REPLACE( l_col_description,
                                                         '<segment>',
                                                         REPLACE( r4_2.segment_prompt,
                                                                  ' Segment' ) ),
                                                '<flexfield>',
                                                r2.kff_name );
                  l_column_name     := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB(l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
                  l_column_name     := RTRIM (l_column_name, '_');

                  l_column_name     := l_column_name_prefix || '$' || l_column_name;

                  l_column_property_type := ( CASE
                                                WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                    THEN 'QUALIFIER_VALUE'
                                                ELSE 'QUALIFIER_DESCRIPTION'
                                              END );

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_segment_qualifier           => r4_2.segment_attribute_type,
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id    );

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => r4_2.segment_attribute_type,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                   );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                                  --}c4_2

---Concatenated columns
            FOR r4 IN cur_concat_col (r1.data_table_key,
                                      rec_kff_struct.structure_id,
                                      r1.column_type,
                                      l_md_struct_constraint_type,
                                      rec_multi_seg_direct.multi_seg_detected,
                                      col_prop_rec.exclude_segment_name_list_col,
                                      col_prop_rec.include_concat_seg_val,
                                      col_prop_rec.include_concat_seg_pval,
                                      col_prop_rec.include_concat_seg_desc,
                                      col_prop_rec.include_concat_seg_pdesc
                                     )
            LOOP                                                         --{c4
               BEGIN
                  l_error_location :=
                              'view columns metadata - concatenated columns ';
                  l_column_position := l_column_position + 0.1;
                  l_column_expr :=
                     (CASE
                         WHEN r4.concatenation_type = 'VAL'
                            THEN REPLACE (r4.source_expression,
                                          '~',
                                          r1.table_alias
                                         )
                         ELSE r4.source_expression
                      END
                     );

                  --Column descriptions logic
                  IF     r4.concatenation_type = 'VAL'
                     AND (   (    r3_1.kff_processing_type = 'SINGLE'
                              AND rec_multi_seg_direct.multi_seg_detected =
                                                                           'Y'
                             )
                          OR (    r3_1.kff_processing_type = 'SOURCED'
                              AND l_md_struct_constraint_type = 'SINGLE'
                              AND rec_multi_seg_direct.multi_seg_detected =
                                                                           'Y'
                             )
                         )
                  THEN
                     BEGIN
                        SELECT    'List of segment names for '
                               || str.structure_name
                               || ' structure is "'
                               || ccat.source_expression
                               || '".'
                          INTO l_col_description
                          FROM n_f_kff_concatenations ccat,
                               n_f_kff_structures str
                         WHERE ccat.data_table_key = r1.data_table_key
                           AND str.data_table_key = ccat.data_table_key
                           AND ccat.concatenation_type = 'LIST'
                           AND str.id_flex_num = rec_kff_struct.structure_id
                           AND ccat.id_flex_num = str.id_flex_num;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           NULL;
                     END;
                  ELSE
                     l_col_description :=
                        (CASE
                            WHEN r4.concatenation_type = 'LIST'
                               THEN n_gseg_utility_pkg.g_kff_coldesc_segnl_sfx
                            WHEN r4.concatenation_type = 'VAL'
                               THEN n_gseg_utility_pkg.g_kff_coldesc_cv_sfx
                            WHEN r4.concatenation_type = 'DESC'
                               THEN n_gseg_utility_pkg.g_kff_coldesc_cd_sfx
                         END
                        );
                     l_col_description :=
                           r1.description
                        || ' '
                        || REPLACE (l_col_description,
                                    '<flexfield>',
                                    r2.kff_name
                                   );
                  END IF;

                  l_column_name := r4.target_column_name;

                  l_column_name :=
                                  l_column_name_prefix || '$' || l_column_name;

                  l_column_type :=
                     (CASE
                         WHEN r4.concatenation_type = 'VAL'
                            THEN 'GENEXPR'
                         ELSE 'CONST'
                      END
                     );
                  l_column_property_type :=
                     (CASE
                         WHEN r4.concatenation_type = 'VAL'
                            THEN 'CONCATENATED_VALUES'
                         WHEN r4.concatenation_type = 'DESC'
                            THEN 'CONCATENATED_DESCRIPTIONS'
                         WHEN r4.concatenation_type = 'LIST'
                            THEN 'SEGMENT_NAME_LIST'
                      END
                     );

                  IF ( r1.no_of_str > 1 ) THEN
                    IF ( r4.concatenation_type = 'VAL' ) THEN
                      l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                        ||' THEN '||l_column_expr ||' ELSE NULL END';
                    ELSE
                      l_column_type := 'GENEXPR';
                      l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                          ||' THEN '''||r4.source_expression||''' ELSE NULL END';
                    END IF;
                  END IF;

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => l_column_type,
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id);

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                     );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                                    --}c4

---Individual segment columns
            FOR r6 IN c6 (r1.data_table_key,
                          rec_kff_struct.structure_id,
                          col_prop_rec.include_indiv_seg_val,
                          col_prop_rec.include_indiv_seg_desc,
                          col_prop_rec.include_concat_seg_val,
                          col_prop_rec.include_concat_seg_desc,
                          rec_multi_seg_direct.multi_seg_detected,
                          l_md_struct_constraint_type,
                          l_column_name_prefix
                         )
            LOOP                                                         --{c6
               BEGIN
                  l_error_location  := 'view columns metadata - individual columns ';
                  l_column_position := l_column_position + 0.1;
                  g_segment_name    := NULL;
                  l_col_description :=( CASE
                                          WHEN ( SUBSTRB(r6.target_column_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                               THEN n_gseg_utility_pkg.g_kff_coldesc_sv_sfx
                                          ELSE n_gseg_utility_pkg.g_kff_coldesc_sd_sfx
                                        END );

                  --Derive the segment name to add it into column description
                  BEGIN


                  select seg.segment_name
                    INTO g_segment_name
                    from ( SELECT s.segment_name
                             FROM n_f_kff_segments s
                            WHERE s.data_table_key     = r1.data_table_key
                              AND s.target_column_name = r6.target_column_name
                            order by s.segment_name ) seg
                   where rownum = 1;


                  EXCEPTION
                     WHEN OTHERS THEN
                        g_segment_name := NULL;
                  END;


                  l_col_description :=
                        r1.description
                     || ' '
                     || REPLACE (REPLACE (l_col_description,
                                          '<segment>',
                                          g_segment_name
                                         ),
                                 '<flexfield>',
                                 r2.kff_name
                                );

          l_column_exists := 0;
                  l_column_name := r6.formatted_target_column_name;

          IF r6.dup_col_cnt > 1 THEN
               IF r6.sub_script > 1 THEN
                   l_column_name := n_gseg_utility_pkg.format_kff_segment(l_column_name||r6.sub_script,30);
               END IF;

                  SELECT COUNT (*)
                    INTO l_column_exists
                    FROM n_view_columns
                   WHERE view_name = r1.view_name
                     AND column_name = l_column_name
                     AND query_position = r1.query_position;

          END IF;

                  l_column_property_type    := ( CASE
                                                   WHEN ( SUBSTRB(r6.target_column_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                                        THEN 'SEGMENT_VALUE'
                                                   ELSE 'SEGMENT_DESCRIPTION'
                                                 END );

          IF ( r1.no_of_str > 1 ) THEN
             l_column_type := 'GENEXPR';
             l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                          ||' THEN '||r1.table_alias||'.'||r6.application_column_name||' ELSE NULL END';

          ELSE
             l_column_type := 'GEN';
             l_column_expr := r6.application_column_name;
          END IF;

          IF ( l_column_exists = 0 ) THEN
                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => l_column_type,
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id);

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => g_segment_name,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                    );
                 END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                        -- end of c6 loop
         END LOOP;                               -- end of kff_struct_cur loop
      END LOOP;                                               --end of c1 loop

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'flexsource_direct',
                                                      l_error_location,
                                                      l_status,
                                                      l_error_msg,
                                                      sysdate,
                                                     gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
   END flexsource_direct;

--
---------------------------------------------------------------------
--
-- Procedure Name: answer_int
--
-- Description
--   For all the global view answers having seg related columns will be processed through this script
--   Populates the Global seg related metadata into non-template tables of answers.
--   The procedure will process parameters related to seg columns.
--   The procedure will also handle SEG%JOIN% answer columns.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE answer_int
   IS
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                := 'SUCCESS';
      l_error_status                VARCHAR2 (1000)                := 'ERROR';
      l_error_number                NUMBER                            := NULL;
      l_column_exists               NUMBER;
      l_script_name                 VARCHAR2 (100)
                                                := 'n_gseg_integration_pkg';
      l_ans_col_desc                n_ans_columns.description%TYPE;
      l_counter                     NUMBER                               := 0;
      l_param_counter               NUMBER                               := 0;
      l_column_title                n_ans_columns.column_title%TYPE      := NULL;
      l_ans_column_id               n_ans_columns.ans_column_id%TYPE     := NULL;
      l_parameter_prompt            n_ans_params.parameter_prompt%TYPE
                                                                         := NULL;
      l_max_from_clause_position    NUMBER;
      l_max_where_clause_position   NUMBER;
      l_ans_tab_alias_ctr           INTEGER                              := 0;
      l_ans_tab_alias               n_ans_tables.table_alias%TYPE        := NULL;
      l_lov_column_name             n_view_columns.column_name%TYPE      := NULL;

      --initializing the operator and mandatory to default values of "contains" and "Y"
      l_operator                    n_ans_param_templates.OPERATOR%TYPE := 'contains';
      l_mandatory_flag              n_ans_param_templates.mandatory_flag%TYPE := 'Y';

      l_outer_join_flag             VARCHAR2(10) := NULL;

--Cursor to retrieve only the answer columns having the column_type as SEG%
      CURSOR cur_ans_seg_cols IS
      SELECT ac.view_label,     ac.view_name,         at.table_name view_name_actual,
             ac.column_label,   ac.column_title,      ac.column_type,
             ac.ans_column_id,  ac.t_ans_column_id,   ac.description ans_column_desc,
             ac.answer_id,      ac.t_answer_id,       ac.question_id,
             ac.query_position, ac.table_alias,       ac.lov_view_label,
             v1.view_name       lov_view_name
        FROM n_ans_columns_view  ac,
             n_views             v,
             n_views             v1,
             n_ans_tables_view   at
       WHERE ac.column_type          LIKE 'SEG%'
         AND ac.view_name               = v.view_name
         AND at.view_name               = v.view_name
         AND ac.answer_id               = at.answer_id
         AND ac.query_position          = at.query_position
         AND ac.table_alias             = at.table_alias
         AND v.application_instance     = 'G0'
         AND NVL(ac.omit_flag, 'N')     = 'N'
         AND ac.lov_view_label          = v1.view_label(+)
         AND v1.application_instance(+) = 'G0'
         AND NVL(v1.omit_flag(+), 'N')  = 'N';

      --Cursor to retrieve the global seg generated columns from column properties table
      --this cursor will get the counts of the
      CURSOR cur_col_properties( p_view_name    VARCHAR2,
                                 p_column_label VARCHAR2 ) IS
      SELECT COUNT( CASE pt.property_type
                      WHEN 'CONCATENATED_DESCRIPTIONS'  THEN 1
                      ELSE NULL
                    END )                                       vc_includes_concat_seg_desc,
             COUNT( CASE pt.property_type
                      WHEN 'CONCATENATED_VALUES'        THEN 1
                      ELSE NULL
                    END )                                       vc_includes_concat_seg_val,
             COUNT( CASE pt.property_type
                      WHEN 'SEGMENT_DESCRIPTION'        THEN 1
                      ELSE NULL
                    END )                                       vc_includes_indiv_seg_desc,
             COUNT( CASE pt.property_type
                      WHEN 'SEGMENT_VALUE'              THEN 1
                      ELSE NULL
                    END )                                       vc_includes_indiv_seg_val,
             COUNT( CASE pt.property_type
                      WHEN 'STRUCTURE_NAME'             THEN 1
                      ELSE NULL
                    END )                                       vc_includes_structure_name,
             COUNT( CASE pt.property_type
                      WHEN 'SEGMENT_NAME_LIST'          THEN 1
                      ELSE NULL
                    END )                                       vc_includes_seg_name_list,
             COUNT( CASE pt.property_type
                      WHEN 'QUALIFIER_VALUE'            THEN 1
                      ELSE NULL
                    END )                                       vc_includes_qualifier_val,
             COUNT( CASE pt.property_type
                      WHEN 'QUALIFIER_DESCRIPTION'      THEN 1
                      ELSE NULL
                    END )                                       vc_includes_qualifier_desc,
             COUNT( CASE pt.property_type
                      WHEN 'PRIMARY_KEY'                THEN 1
                      ELSE NULL
                    END )                                       vc_includes_primary_key
        FROM n_view_columns            c,
             n_view_properties         colp,
             n_property_type_templates pt
       WHERE c.application_instance      = 'G0'
         AND c.view_name                 = p_view_name
         AND c.column_label              = p_column_label
         AND colp.view_name              = p_view_name
         AND colp.source_pk_id           = c.column_id
         AND colp.view_name              = c.view_name
         AND colp.query_position         = c.query_position
         AND pt.property_type_id         = colp.property_type_id
         AND pt.templates_table_name     = 'N_VIEW_COLUMN_TEMPLATES'
         AND NVL(colp.value5,'XXX')     != 'LEGACY'
         AND NVL(colp.omit_flag, 'N')    = 'N'
         AND c.query_position            =
           (                              -- Only do 1st query in view
             SELECT TO_NUMBER (v.first_active_query_position)
               FROM n_views v
              WHERE v.view_name           = colp.view_name
                AND NVL(v.omit_flag, 'N') = 'N');

      rec_col_prop                  cur_col_properties%ROWTYPE;

      --Retreive the generated global seg columns
      CURSOR cur_view_gseg_cols ( p_view_name                     VARCHAR2,
                                  p_ans_column_label              VARCHAR2,
                                  p_ans_column_type               VARCHAR2,
                                  p_vc_includes_indiv_seg_val     NUMBER,
                                  p_vc_includes_qualifier_val     NUMBER,
                                  p_vc_includes_structure_name    NUMBER,
                                  p_vc_includes_seg_name_list     NUMBER,
                                  p_vc_includes_concat_seg_val    NUMBER,
                                  p_vc_includes_concat_seg_desc   NUMBER,
                                  p_vc_includes_indiv_seg_desc    NUMBER,
                                  p_vc_includes_qualifier_desc    NUMBER      )      IS
      SELECT col.t_column_id        view_t_column_id,
             col.column_id          view_column_id,
             col.column_name        view_column_name,
             col.column_label       view_column_label,
             col.column_type        view_column_type,
             col.column_expression  view_column_expr,
             col.description        view_column_desc,
             col.description        view_tmpl_col_desc,
             vt.table_name          view_table_name,
             vt.metadata_table_name view_metadata_table_name,
             col.id_flex_code
        FROM n_view_properties          colp,
             n_view_columns             col,
             n_view_tables              vt,
             n_property_type_templates  pt
       WHERE colp.view_name             = col.view_name
         AND colp.query_position        = col.query_position
         AND colp.source_pk_id          = col.column_id
         AND pt.property_type_id        = colp.property_type_id
         AND pt.templates_table_name    = 'N_VIEW_COLUMN_TEMPLATES'
         AND NVL(colp.value5,'XXX')    != 'LEGACY'
         AND vt.view_name               = col.view_name
         AND vt.query_position          = col.query_position
         AND vt.table_alias             = col.table_alias
         AND col.column_type         LIKE 'GEN%'
         AND col.column_label           = p_ans_column_label
         AND col.view_name              = p_view_name
         AND col.query_position         =
           (                              -- Only do 1st query in view
             SELECT TO_NUMBER (v.first_active_query_position)
               FROM n_views v
              WHERE v.view_name           = colp.view_name
                AND NVL(v.omit_flag, 'N') = 'N' )
         AND ( CASE
                 WHEN (     p_vc_includes_structure_name = 0
                        AND pt.property_type             = 'STRUCTURE_NAME' )       THEN NULL
                 WHEN (     p_vc_includes_seg_name_list  = 0
                        AND pt.property_type             = 'SEGMENT_NAME_LIST' )    THEN NULL
                 WHEN ( pt.property_type                 = 'PRIMARY_KEY' )          THEN NULL
                 WHEN (    (     p_vc_includes_concat_seg_val  > 0
                             AND p_vc_includes_concat_seg_desc = 0 )
                        OR (     p_vc_includes_indiv_seg_val   > 0
                             AND p_vc_includes_indiv_seg_desc  = 0 )
                        OR (     p_vc_includes_qualifier_val   > 0
                             AND p_vc_includes_qualifier_desc  = 0 ) )              THEN
                                ( CASE
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND pt.property_type            = 'QUALIFIER_VALUE' )    THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND p_vc_includes_indiv_seg_val > 1
                                           AND pt.property_type            = 'SEGMENT_VALUE' )      THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                     'SEGI_JOIN_ADD_INDIV')
                                           AND p_vc_includes_indiv_seg_val = 0
                                           AND pt.property_type            = 'CONCATENATED_VALUE' ) THEN NULL
                                    ELSE 1
                                  END )
                 WHEN (    p_vc_includes_concat_seg_desc > 0
                        OR p_vc_includes_indiv_seg_desc  > 0
                        OR p_vc_includes_qualifier_desc  > 0  )                 THEN
                                ( CASE
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND pt.property_type          = 'QUALIFIER_VALUE' )          THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND pt.property_type          = 'QUALIFIER_DESCRIPTION' )    THEN NULL
                                    WHEN (     (    p_ans_column_type NOT IN ('SEGD', 'SEGD_JOIN',
                                                                              'SEGD_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                                 OR p_ans_column_type IN ('SEG', 'SEG_JOIN',
                                                                          'SEG_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                          'SEGI_JOIN_ADD_INDIV') )
                                           AND pt.property_type          = 'QUALIFIER_DESCRIPTION' )    THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND p_vc_includes_indiv_seg_val > 1
                                           AND pt.property_type          = 'SEGMENT_VALUE' )            THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                     'SEGI_JOIN_ADD_INDIV')
                                           AND p_vc_includes_indiv_seg_val > 0
                                           AND pt.property_type            = 'CONCATENATED_VALUE' )     THEN NULL
                                    WHEN (     (    p_ans_column_type NOT IN ('SEGD', 'SEGD_JOIN',
                                                                              'SEGD_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                                 OR p_ans_column_type IN ('SEG', 'SEG_JOIN',
                                                                          'SEG_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                          'SEGI_JOIN_ADD_INDIV') )
                                           AND pt.property_type = 'CONCATENATED_DESCRIPTIONS' )         THEN NULL
                                    WHEN (     (    p_ans_column_type NOT IN ('SEGD', 'SEGD_JOIN',
                                                                              'SEGD_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                                 OR p_ans_column_type IN ('SEG', 'SEG_JOIN',
                                                                          'SEG_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                          'SEGI_JOIN_ADD_INDIV') )
                                           AND p_vc_includes_indiv_seg_desc > 0
                                           AND pt.property_type             = 'SEGMENT_DESCRIPTION' )   THEN NULL
                                    ELSE 1
                                  END )
                 END )      = 1;

--Retreive the answer parameters for seg columns
      CURSOR cur_answer_paramters ( p_view_name                    VARCHAR2,
                                    p_answer_id                    NUMBER,
                                    p_query_position               NUMBER,
                                    p_ans_column_label             VARCHAR2,
                                    p_t_ans_column_id              INTEGER,
                                    p_vc_includes_indiv_seg_val    NUMBER,
                                    p_vc_includes_qualifier_val    NUMBER,
                                    p_vc_includes_structure_name   NUMBER,
                                    p_vc_includes_concat_seg_val   NUMBER   ) IS
         SELECT pt.t_param_id,
                q.question_id,
                q.answer_id,
                q.query_position,
                ptyp.property_type,
                COUNT (*) OVER ( PARTITION BY pt.t_param_id,    q.question_id,
                                              q.answer_id,      q.query_position ) gen_col_count,
                pt.param_position,
                c.ans_column_id,
                c.column_title,
                pt.operator,
                pt.having_flag,
                NVL(pt.and_or, 'AND')                                               and_or,       -- and_or
                pt.mandatory_flag,
                pt.param_filter_type,
                pt.processing_code,
                pt.profile_option,
                col.column_id                                                       view_column_id,
                col.t_column_id                                                     view_t_column_id,
                col.column_name                                                     view_column_name,
                col.column_label                                                    view_column_label,
                col.column_type                                                     view_column_type,
                col.column_expression                                               view_column_expr,
                col.description                                                     view_column_desc,
                col.description                                                     view_tmpl_col_desc,
                vt.table_name                                                       view_table_name,
                vt.metadata_table_name                                              view_metadata_table_name
           FROM n_answers                   a,
                n_ans_queries               q,
                n_ans_param_templates       pt,
                n_view_properties           colp,
                n_property_type_templates   ptyp,
                n_ans_columns_view          c,
                n_view_columns              col,
                n_view_tables               vt
          WHERE a.t_answer_id               = pt.t_answer_id
            AND a.answer_id                 = q.answer_id
            AND pt.t_ans_column_id          = p_t_ans_column_id
            AND q.query_position            = pt.query_position
            AND a.answer_id                 = p_answer_id
            AND NVL(pt.include_flag, 'Y')   = 'Y'
            AND NVL(a.omit_flag, 'N')       = 'N'
            AND NVL(q.omit_flag, 'N')       = 'N'
            AND colp.view_name              = col.view_name
            AND colp.query_position         = col.query_position
            AND colp.source_pk_id           = col.column_id
            AND ptyp.property_type_id       = colp.property_type_id
            AND ptyp.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
            AND NVL(colp.value5,'XXX')     != 'LEGACY'
            AND vt.view_name                = col.view_name
            AND vt.query_position           = col.query_position
            AND vt.table_alias              = col.table_alias
            AND col.column_type          LIKE 'GEN%'
            AND c.view_name(+)              = col.view_name
            AND c.t_ans_column_id(+)        = p_t_ans_column_id
            AND c.query_position(+)         = p_query_position
            AND c.column_label(+)           = col.column_label
            AND c.answer_id(+)              = p_answer_id
            AND c.column_expression(+)      = col.column_name
            AND col.view_name               = p_view_name
            AND colp.view_name              = p_view_name
            AND col.column_label            = p_ans_column_label
            AND colp.query_position         =
              (                              -- Only do 1st query in view
                SELECT TO_NUMBER (v.first_active_query_position)
                  FROM n_views v
                 WHERE v.view_name            = colp.view_name
                   AND NVL (v.omit_flag, 'N') = 'N')
            AND (    (     processing_code = 'I'
                       AND ( CASE
                               WHEN (     p_vc_includes_indiv_seg_val = 0
                                      AND ptyp.property_type          = 'CONCATENATED_VALUES' )      THEN 1
                               WHEN (     p_vc_includes_indiv_seg_val > 0
                                      AND ptyp.property_type          = 'SEGMENT_VALUE' )            THEN 1
                               WHEN (     p_vc_includes_qualifier_val > 0
                                      AND ptyp.property_type          = 'QUALIFIER_VALUE' )          THEN 1
                               WHEN (     p_vc_includes_structure_name > 0
                                      AND ptyp.property_type          = 'STRUCTURE_NAME'  )          THEN 1
                               ELSE NULL
                             END )        = 1 )
                  OR (     processing_code = 'C'
                       AND ( CASE
                               WHEN (     p_vc_includes_concat_seg_val  > 0
                                      AND ptyp.property_type            = 'CONCATENATED_VALUES' )    THEN 1
                               WHEN (     p_vc_includes_indiv_seg_val   = 1
                                      AND p_vc_includes_concat_seg_val  = 0
                                      AND ptyp.property_type            = 'SEGMENT_VALUE')           THEN 1
                               WHEN (     p_vc_includes_qualifier_val   > 0
                                      AND ptyp.property_type            = 'QUALIFIER_VALUE' )        THEN 1
                               WHEN (     p_vc_includes_structure_name  > 0
                                      AND ptyp.property_type            = 'STRUCTURE_NAME' )         THEN 1
                               ELSE NULL
                             END  )        = 1 ) );

      --Identify the kff view and related join conditions from n_join_keys table based on the view and column label
      CURSOR cur_xxk_table_joins ( p_view_name           VARCHAR2,
                                   p_view_column_label   VARCHAR2,
                                   p_column_type         VARCHAR2 ) IS
      SELECT DISTINCT
             v.view_name,
             k.view_name            xxk_view_name,
             vc.column_name         glb_view_join_col,
             kc.column_name         xxk_view_join_col,
             k_v.application_label  xxk_app_label,
             'dcv'                  table_alias,
             v.outerjoin_flag
        FROM n_join_keys        v,
             n_join_key_columns vc,
             n_join_keys        k,
             n_views            k_v,
             n_join_key_columns kc
       WHERE v.column_type_code             = 'ROWID'
         AND v.referenced_pk_join_key_id    = k.join_key_id
         AND k_v.view_name                  = k.view_name
         AND vc.join_key_id                 = v.join_key_id
         AND vc.column_position             = 1
         AND kc.join_key_id                 = k.join_key_id
         AND kc.column_position             = 1
         AND v.view_name                    = p_view_name
         AND vc.column_name              LIKE '%' || k.view_label
         -- NOTE:  This should be the same column label used by the seg column
         AND vc.column_label                = p_view_column_label
         AND p_column_type               LIKE 'SEG%JOIN%';
   BEGIN
      l_error_location := l_script_name || '-start processing';

      FOR rec_ac IN cur_ans_seg_cols LOOP
         l_counter := 0;

         --column properties data
         OPEN cur_col_properties( rec_ac.view_name_actual,
                                  rec_ac.column_label   );

         FETCH cur_col_properties
          INTO rec_col_prop;

         CLOSE cur_col_properties;

         FOR rec_vc IN
            cur_view_gseg_cols( rec_ac.view_name_actual,
                                rec_ac.column_label,
                                rec_ac.column_type,
                                rec_col_prop.vc_includes_indiv_seg_val,
                                rec_col_prop.vc_includes_qualifier_val,
                                rec_col_prop.vc_includes_structure_name,
                                rec_col_prop.vc_includes_seg_name_list,
                                rec_col_prop.vc_includes_concat_seg_val,
                                rec_col_prop.vc_includes_concat_seg_desc,
                                rec_col_prop.vc_includes_indiv_seg_desc,
                                rec_col_prop.vc_includes_qualifier_desc  ) LOOP
            l_counter := l_counter + 1;
            -- Create the description
            l_ans_col_desc := SUBSTRB (rec_vc.view_column_desc, 1, 240);

            BEGIN
               SELECT c1.column_name
                 INTO l_lov_column_name
                 FROM n_view_columns            c1,
                      n_view_properties         colp,
                      n_property_type_templates pt
                WHERE c1.view_name              = rec_ac.lov_view_name
                  AND c1.view_name              = colp.view_name
                  AND c1.query_position         = colp.query_position
                  AND c1.column_id              = colp.source_pk_id
                  AND pt.property_type_id       = colp.property_type_id
                  AND pt.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                  AND (CASE
                          WHEN (     pt.property_type = ('CONCATENATED_VALUES')
                                 AND rec_vc.view_column_name LIKE
                                         '%$' || n_gseg_utility_pkg.g_kff_dc_concat_val_pfx || '$%' ) THEN 1
                          WHEN (     pt.property_type = ('CONCATENATED_DESCRIPTIONS')
                                 AND rec_vc.view_column_name LIKE
                                         '%$' || n_gseg_utility_pkg.g_kff_dc_concat_desc_pfx || '$%' ) THEN 1
                          WHEN ( SUBSTRB (SUBSTRB (c1.column_name,
                                                   INSTR (c1.column_name,
                                                          '$',
                                                          1,
                                                          1
                                                         )
                                                 + 1
                                                ),
                                        1,
                                        LEAST (  30
                                               - INSTR (c1.column_name,
                                                        '$',
                                                        1,
                                                        1
                                                       ),
                                                 30
                                               - INSTR
                                                     (rec_vc.view_column_name,
                                                      '$',
                                                      1,
                                                      1
                                                     )
                                              )
                                       ) =
                                 SUBSTRB
                                    (SUBSTRB (rec_vc.view_column_name,
                                                INSTR
                                                     (rec_vc.view_column_name,
                                                      '$',
                                                      1,
                                                      1
                                                     )
                                              + 1
                                             ),
                                     1,
                                     LEAST (  30
                                            - INSTR (c1.column_name, '$', 1,
                                                     1),
                                              30
                                            - INSTR (rec_vc.view_column_name,
                                                     '$',
                                                     1,
                                                     1
                                                    )
                                           )
                                    ) )                              THEN 1
                          ELSE 0
                       END                      ) = 1
                  AND c1.query_position =
                    (                        -- Only do 1st query in view
                      SELECT TO_NUMBER (v.first_active_query_position)
                        FROM n_views v
                       WHERE v.view_name            = c1.view_name
                         AND NVL(v.omit_flag, 'N')  = 'N');
            EXCEPTION
               WHEN OTHERS THEN
                  l_lov_column_name := NULL;
            END;

            IF (l_counter = 1)  THEN      -- {
               l_ans_tab_alias_ctr := 0;

               FOR rec_tabjoin IN cur_xxk_table_joins( rec_ac.view_name_actual,
                                                       rec_ac.column_label,
                                                       rec_ac.column_type )    LOOP
                  BEGIN
                     l_error_location := 'Inserting KFF view into n_ans_tables';

                     SELECT MAX (from_clause_position)
                       INTO l_max_from_clause_position
                       FROM n_ans_tables
                      WHERE answer_id = rec_ac.answer_id
                        AND query_position = rec_ac.query_position;

                     SELECT COUNT (*)
                       INTO l_ans_tab_alias_ctr
                       FROM n_ans_tables
                      WHERE answer_id = rec_ac.answer_id
                        AND query_position = rec_ac.query_position
                        AND RTRIM (TRANSLATE (UPPER (table_alias),
                                        '1234567890',
                                        '      '
                                      )) = UPPER (rec_vc.id_flex_code);

                     l_ans_tab_alias_ctr := l_ans_tab_alias_ctr + 1;
                     l_ans_tab_alias := rec_vc.id_flex_code || l_ans_tab_alias_ctr;

                     INSERT INTO n_ans_tables
                          ( answer_id,
                            query_position,
                            table_alias,
                            question_id,
                            from_clause_position,
                            application_label,
                            table_name,
                            view_application_label,
                            profile_option,
                            omit_flag,
                            created_by,
                            creation_date )
                     VALUES
                          ( rec_ac.answer_id,
                            rec_ac.query_position,
                            l_ans_tab_alias,
                            rec_ac.question_id,
                            l_max_from_clause_position + 1,       -- from_clause_position
                            'NOETIX',                             -- application_label
                            rec_tabjoin.xxk_view_name,            -- table name
                            rec_tabjoin.xxk_app_label,            -- view app label
                            NULL,                                 -- profile option
                            NULL,                                 -- omit_flag
                            'NOETIX',                             -- created_by
                            SYSDATE );                            -- creation_date

                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_ac.view_name
                           || '~'
                           || rec_ac.t_answer_id
                           || '~'
                           || rec_tabjoin.xxk_view_name
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;

                  BEGIN
                     l_error_location := 'Adding a new join condtion for kff view into n_ans_wheres';

                      l_outer_join_flag := (CASE WHEN rec_tabjoin.outerjoin_flag = 'Y' THEN '(+)' ELSE NULL END);

                     SELECT NVL (MAX (where_clause_position), 10)
                       INTO l_max_where_clause_position
                       FROM n_ans_wheres
                      WHERE answer_id = rec_ac.answer_id
                        AND query_position = rec_ac.query_position;

                     INSERT INTO n_ans_wheres
                                 (answer_id, query_position,
                                  where_clause_position,
                                  question_id,
                                  where_clause,
                                  variable_exists_flag, profile_option,
                                  omit_flag, created_by, creation_date
                                 )
                          VALUES (rec_ac.answer_id, rec_ac.query_position,
                                  l_max_where_clause_position + 1,
                                  rec_ac.question_id,
                                     'AND '
                                  || rec_ac.table_alias
                                  || '.'
                                  || rec_tabjoin.glb_view_join_col
                                  || ' = '
                                  || l_ans_tab_alias
                                  || '.'
                                  || rec_tabjoin.xxk_view_join_col
                  || l_outer_join_flag,
                                  'N', NULL,                 -- profile option
                                  NULL,                            --omit_flag
                                       'NOETIX',                 -- created_by
                                                SYSDATE       -- creation_date
                                 );
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_ac.view_name
                           || '~'
                           || rec_ac.t_answer_id
                           || '~'
                           || rec_tabjoin.xxk_view_name
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;

                  BEGIN
                     l_error_location :=
                        'Adding answer columns from kkf view to the Global view';

                     INSERT INTO n_ans_columns
                                 (ans_column_id, answer_id, question_id,
                                  query_position, t_ans_column_id, column_label,
                                  column_title, table_alias,
                                  column_expression, column_position,
                                  column_type, column_sub_type, description,
                                  order_by_position, format_mask,
                                  format_class, group_sort_flag,
                                  display_width, horizontal_alignment,
                                  aggregation_type,
                                  aggregation_distinct_flag, page_item_flag,
                                  page_item_position, display_flag,
                                  lov_view_label, lov_view_name,
                                  lov_disp_column_label,
                                  lov_parent_column_label, profile_option,
                                  omit_flag, created_by, creation_date,
                                  mandatory_flag, match_answer_column_string)
                        SELECT n_ans_column_seq.NEXTVAL,         -- ans_column_id
                                                        c.answer_id,
                               c.question_id, c.query_position,
                               c.t_ans_column_id, c.column_label,
                               TRANSLATE (REPLACE (   rec_ac.column_label
                                                   || ' '
                                                   || c1.column_name,
                                                   '$$',
                                                   '$'
                                                  ),
                                          '$_',
                                          '  '
                                         ),                    -- column_title
                               l_ans_tab_alias, c1.column_name,

                               -- column_expression
                               c.column_position + (ROWNUM * .01), 'GEN',

                               -- column_type
                               NULL,
                                    -- column_sub_type
                                    c1.description,             -- description
                                                   NULL,  -- order_by_position
                                                        c.format_mask,
                               c.format_class, c.group_sort_flag,
                               c.display_width, c.horizontal_alignment,
                               c.aggregation_type,
                               c.aggregation_distinct_flag, c.page_item_flag,
                               c.page_item_position, 'Y',       --display flag
                               rec_tabjoin.xxk_view_name,
                               rec_tabjoin.xxk_view_name, c1.column_name,
                               NULL,
                                    --lov_parent_column_label,
                                    c.profile_option, NULL,       -- omit flag
                                                           'NOETIX',
                                                                 -- created_by
                                                                    SYSDATE,

                               -- creation_date
                               c.mandatory_flag, c.match_answer_column_string
                          FROM n_ans_columns c, n_view_columns c1
                         WHERE c.ans_column_id = rec_ac.ans_column_id
                           AND c1.view_name = rec_tabjoin.xxk_view_name
                           AND c1.query_position =
                                  (               -- Only do 1st query in view
                                   SELECT TO_NUMBER
                                                (v.first_active_query_position)
                                     FROM n_views v
                                    WHERE v.view_name = c1.view_name
                                      AND NVL (v.omit_flag, 'N') = 'N')
                           AND (   (    c1.column_name LIKE
                                               n_gseg_utility_pkg.g_kff_dc_seg_val_pfx || '$%'
                                    AND rec_ac.column_type IN
                                           ('SEG_JOIN_ADD_INDIV',
                                            'SEGI_JOIN_ADD_INDIV')
                                   )
                                OR (    c1.column_name LIKE
                                              n_gseg_utility_pkg.g_kff_dc_seg_desc_pfx || '$%'
                                    AND rec_ac.column_type =
                                                         'SEGD_JOIN_ADD_INDIV'
                                   )
                               );

                     l_counter := l_counter + SQL%ROWCOUNT;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_ac.view_name
                           || '~'
                           || rec_ac.t_answer_id
                           || '~'
                           || rec_ac.ans_column_id
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;
               END LOOP;

               -- One column of this set already exists(original seg column)
               -- in n_ans_columns, so all we need to do is update it.
               BEGIN
                  l_error_location :=
                     'update first answer columns from kkf view to the global view';

                  UPDATE n_ans_columns
                     SET column_title =
                            TRANSLATE (REPLACE (rec_vc.view_column_name,
                                                '$$',
                                                '$'
                                               ),
                                       '$_',
                                       '  '
                                      ),
                         column_expression = rec_vc.view_column_name,
                         description = l_ans_col_desc,
                         column_type = 'GEN',
                         lov_view_label = rec_ac.lov_view_label,
                         lov_view_name = rec_ac.lov_view_name,
                         lov_disp_column_label = l_lov_column_name,
                         display_flag = 'Y'
                   WHERE ans_column_id = rec_ac.ans_column_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_ac.view_name
                        || '~'
                        || rec_ac.t_answer_id
                        || '~'
                        || rec_ac.ans_column_id
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            ELSE
               BEGIN
                  l_error_location :=
                     'Insert answer columns from the global view seg columns';

                  INSERT INTO n_ans_columns
                              (ans_column_id, answer_id, question_id,
                               query_position, t_ans_column_id, column_label,
                               column_title, table_alias, column_expression,
                               column_position, column_type, column_sub_type,
                               description, order_by_position, format_mask,
                               format_class, group_sort_flag, display_width,
                               horizontal_alignment, aggregation_type,
                               aggregation_distinct_flag, page_item_flag,
                               page_item_position, display_flag,
                               lov_view_label, lov_view_name,
                               lov_disp_column_label,
                               lov_parent_column_label, profile_option,
                               omit_flag, created_by, creation_date,
                               mandatory_flag, match_answer_column_string)
                     SELECT n_ans_column_seq.NEXTVAL,            -- ans_column_id
                                                     c.answer_id,
                            c.question_id, c.query_position, c.t_ans_column_id,
                            c.column_label,
                            TRANSLATE (REPLACE (rec_vc.view_column_name,
                                                '$$',
                                                '$'
                                               ),
                                       '$_',
                                       '  '
                                      ),                       -- column_title
                            c.table_alias, rec_vc.view_column_name,

                            -- column_expression
                            c.column_position + (l_counter * .01), 'GEN',

                            -- column_type
                            NULL,
                                 -- column_sub_type
                                 l_ans_col_desc,                -- description
                                                NULL,     -- order_by_position
                                                     c.format_mask,
                            c.format_class, c.group_sort_flag,
                            c.display_width, c.horizontal_alignment,
                            c.aggregation_type, c.aggregation_distinct_flag,
                            c.page_item_flag, c.page_item_position, 'Y',
                                                                --display flag
                            rec_ac.lov_view_label, rec_ac.lov_view_name,
                            l_lov_column_name, NULL,
                                                    --lov_parent_column_label,
                                                    c.profile_option, NULL,
                                                                  -- omit flag
                            'NOETIX',                            -- created_by
                                     SYSDATE,
                                             -- creation_date
                                             c.mandatory_flag,
                            c.match_answer_column_string
                       FROM n_ans_columns c
                      WHERE c.ans_column_id = rec_ac.ans_column_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_ac.view_name
                        || '~'
                        || rec_ac.t_answer_id
                        || '~'
                        || rec_vc.view_column_name
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END IF;                               -- } end of the if statement
         END LOOP;                               --  end of cur_view_gseg_cols

         --Insert into answer parameters
         l_param_counter := 0;
         l_ans_col_desc := NULL;

         FOR rec_ans_col IN
            cur_answer_paramters (rec_ac.view_name_actual,
                                  rec_ac.answer_id,
                                  rec_ac.query_position,
                                  rec_ac.column_label,
                                  rec_ac.t_ans_column_id,
                                  rec_col_prop.vc_includes_indiv_seg_val,
                                  rec_col_prop.vc_includes_qualifier_val,
                                  rec_col_prop.vc_includes_structure_name,
                                  rec_col_prop.vc_includes_concat_seg_val
                                 )
         LOOP
            l_counter := l_counter + 1;
            l_param_counter := l_param_counter + 1;
            l_column_title := rec_ans_col.column_title;

            IF rec_ans_col.ans_column_id IS NULL
            THEN
               BEGIN
                  l_error_location :=
                     'Insert required columns in parameters into n_ans_columns which are not available earlier';

                  SELECT n_ans_column_seq.NEXTVAL
                    INTO l_ans_column_id
                    FROM DUAL;

                  l_column_title :=
                     TRANSLATE (REPLACE (rec_ans_col.view_column_name,
                                         '$$',
                                         '$'
                                        ),
                                '$_',
                                '  '
                               );                              -- column_title
                  l_ans_col_desc :=
                                SUBSTRB (rec_ans_col.view_column_desc, 1, 240);

                  BEGIN
                     SELECT column_name
                       INTO l_lov_column_name
                       FROM n_view_columns c1
                      WHERE c1.view_name = rec_ac.lov_view_name
                        AND SUBSTRB
                                  (SUBSTRB (c1.column_name,
                                              INSTR (c1.column_name, '$', 1,
                                                     1)
                                            + 1
                                           ),
                                   1,
                                   LEAST (  30
                                          - INSTR (c1.column_name, '$', 1, 1),
                                            30
                                          - INSTR
                                                (rec_ans_col.view_column_name,
                                                 '$',
                                                 1,
                                                 1
                                                )
                                         )
                                  ) =
                               SUBSTRB
                                  (SUBSTRB
                                        (rec_ans_col.view_column_name,
                                           INSTR
                                                (rec_ans_col.view_column_name,
                                                 '$',
                                                 1,
                                                 1
                                                )
                                         + 1
                                        ),
                                   1,
                                   LEAST (  30
                                          - INSTR (c1.column_name, '$', 1, 1),
                                            30
                                          - INSTR
                                                (rec_ans_col.view_column_name,
                                                 '$',
                                                 1,
                                                 1
                                                )
                                         )
                                  )
                        AND c1.query_position =
                          (                  -- Only do 1st query in view
                            SELECT TO_NUMBER(v.first_active_query_position)
                              FROM n_views v
                             WHERE v.view_name           = c1.view_name
                               AND NVL(v.omit_flag, 'N') = 'N')
                        AND EXISTS
                          ( SELECT 1
                              FROM n_view_properties            colp,
                                   n_property_type_templates    pt
                             WHERE c1.view_name            = colp.view_name
                               AND c1.query_position       = colp.query_position
                               AND c1.column_id            = colp.source_pk_id
                               AND pt.property_type_id     = colp.property_type_id
                               AND pt.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES' );
                  EXCEPTION
                     WHEN OTHERS THEN
                        l_lov_column_name := NULL;
                  END;

                  --Display will be off for the columns
                  INSERT INTO n_ans_columns
                              (ans_column_id, answer_id, question_id,
                               query_position, t_ans_column_id, column_label,
                               column_title, table_alias, column_expression,
                               column_position, column_type, column_sub_type,
                               description, order_by_position, format_mask,
                               format_class, group_sort_flag, display_width,
                               horizontal_alignment, aggregation_type,
                               aggregation_distinct_flag, page_item_flag,
                               page_item_position, display_flag,
                               lov_view_label, lov_view_name,
                               lov_disp_column_label, lov_parent_column_label,
                               profile_option, omit_flag, created_by,
                               creation_date, mandatory_flag,
                               match_answer_column_string)
                     SELECT l_ans_column_id,                          -- ans_column_id
                                        c.answer_id, c.question_id,
                            c.query_position, c.t_ans_column_id, c.column_label,
                            l_column_title, c.table_alias,
                            rec_ans_col.view_column_name, -- column_expression
                            c.column_position + (l_counter * .01), 'GEN',

                            -- column_type
                            NULL,
                                 -- column_sub_type
                                 l_ans_col_desc,                -- description
                                                NULL,     -- order_by_position
                                                     c.format_mask,
                            c.format_class, c.group_sort_flag,
                            c.display_width, c.horizontal_alignment,
                            c.aggregation_type, c.aggregation_distinct_flag,
                            c.page_item_flag, c.page_item_position, 'N',
                                                                --display flag
                            rec_ac.lov_view_label, rec_ac.lov_view_name,
                            l_lov_column_name, NULL,
                                                    --lov_parent_column_label,
                                                    c.profile_option, NULL,
                                                                  -- omit flag
                            'NOETIX',                            -- created_by
                                     SYSDATE,                 -- creation_date
                                             c.mandatory_flag,
                            c.match_answer_column_string
                       FROM n_ans_columns c
                      WHERE c.ans_column_id = rec_ac.ans_column_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_ac.view_name
                        || '~'
                        || rec_ac.t_answer_id
                        || '~'
                        || rec_ans_col.view_column_name
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END IF;

            BEGIN
               l_error_location :=
                           'Insert answer parameters for seg related columns';
               l_parameter_prompt :=
                  SUBSTRB (   'Enter '
                           || l_column_title
                           || (CASE rec_ans_col.OPERATOR
                                  WHEN 'contains'
                                     THEN ' (use % for all)'
                                  ELSE NULL
                               END
                              ),
                           1,
                           80
                          );


               INSERT INTO n_ans_params
                           (param_id, t_param_id,
                            question_id, answer_id,
                            query_position,
                            param_position,
                            ans_column_id,
                            parameter_prompt, OPERATOR,
                            having_flag, and_or,
                            mandatory_flag, param_filter_type,
                            processing_code,
                            profile_option, omit_flag, created_by,
                            creation_date
                           )
                    VALUES (n_ans_param_seq.NEXTVAL,               -- param_id
                            rec_ans_col.t_param_id,
                            rec_ans_col.question_id, rec_ans_col.answer_id,
                            rec_ans_col.query_position,
                            rec_ans_col.param_position + (l_counter * .01),
                            NVL (rec_ans_col.ans_column_id, l_ans_column_id),
                            l_parameter_prompt, l_operator,
                            rec_ans_col.having_flag, rec_ans_col.and_or,
                            l_mandatory_flag, rec_ans_col.param_filter_type,
                            rec_ans_col.processing_code,
                            rec_ans_col.profile_option, NULL,     -- omit flag
                            'NOETIX',
                            -- created_by
                            SYSDATE                           -- creation_date
                           );

             --Inserting to parameters default value
                 INSERT INTO n_ans_param_values
                    (param_value_id, question_id,
                     answer_id, query_position,
                     t_param_value_id, param_id, param_value_position,
                     param_value, profile_option, omit_flag, created_by, creation_date
                    )
                  VALUES (n_ans_param_value_seq.NEXTVAL, rec_ans_col.question_id,
                     rec_ans_col.answer_id, rec_ans_col.query_position,
                     -1 , n_ans_param_seq.CURRVAL,
                     10, '%', NULL, NULL, 'NOETIX',
                     SYSDATE
    
                   );

            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_ac.view_name
                     || '~'
                     || rec_ac.t_answer_id
                     || '~'
                     || rec_ac.t_ans_column_id
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                     -- cur_answer_paramters
      END LOOP;                                        -- cur_ans_seg_cols
--NV-1077: Modified below update statments.
	  --To suppress unwanted lov association for columns.
	BEGIN
        ----added nv-192
        --To suppress unnecessary lov association in the non-templates tables
        UPDATE n_view_columns c
        SET    lov_view_label    = NULL,
               lov_view_name     = NULL,
               lov_column_label  = NULL
        where c.column_type not in ('GEN', 'GENEXPR')
		and c.view_name in (select view_name from n_views v where v.application_instance = 'G0')
		and (c.lov_view_label like '%Lov%Flex%'
		and exists (select 'Y' from n_view_tables v
						where v.table_name like 'XXK%'
						and v.view_label = c.lov_view_label) )
		and (c.view_label != 'OE_Non_Orderable_Items' and c.query_position != '1' and c.column_label != 'Item_Category' );  --NV-1086

        --added nv-192
        --To suppress lov association for lov views
        UPDATE n_view_columns
        SET    lov_view_label   = NULL,
               lov_view_name    = NULL,
               lov_column_label = NULL
        WHERE  view_label    LIKE '%Lov%Flex%'
		AND VIEW_NAME IN (SELECT VIEW_NAME FROM N_VIEWS V WHERE V.APPLICATION_INSTANCE = 'G0');

        --added nv-192
        --To suppress unnecessary lov association in the non-templates tables
        UPDATE n_view_columns
        SET    lov_column_label     = NULL
        WHERE  column_type          = 'GEN'
        AND    lov_view_label IS NULL
		AND VIEW_NAME IN (SELECT VIEW_NAME FROM N_VIEWS V WHERE V.APPLICATION_INSTANCE = 'G0');

	EXCEPTION
	WHEN OTHERS THEN
        NULL;
	END;
	
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'answer_int',
                                                      l_error_location,
                                                      l_error_status,
                                                      NVL (l_error_msg,
                                                           SQLERRM
                                                          )
                                                      ,
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, NVL (l_error_msg, SQLERRM));
   END answer_int;
END n_gseg_integration_pkg;
/

show errors;

-- END ycr_gseg_integration_pkg
--Procedure for IR
CREATE OR REPLACE PACKAGE n_gseg_integration_incr_pkg AUTHID DEFINER IS
   
   FUNCTION get_version
      RETURN VARCHAR2;

   ---
   ---
   -- Turns Off Debug Mode
   PROCEDURE debug_off;

   ---
   FUNCTION debug_off
      RETURN INTEGER;

   ---
   -- Turns On Debug Mode
   PROCEDURE debug_on;

   ---
   FUNCTION debug_on
      RETURN INTEGER;

   ---
   -- Prints the message out for the debug mode.
   -- i_message      - The message
   -- i_output_type
   --      'ALL'  - All output types.  Basically both dbms_output and SM_Messages.
   --      'TEXT' - Output to dbms_output.
   --      'DB'   - Store the message in the messages table.
   -- i_location     - Additional location information.
   PROCEDURE DEBUG (
      i_message       IN   VARCHAR2,
      i_output_type   IN   VARCHAR2 DEFAULT 'DB',
      i_location      IN   VARCHAR2 DEFAULT 'DEBUG'
   );

   --
   PROCEDURE add_debug_message (
      i_script_name     n_installation_messages.script_name%TYPE,
      i_location        n_installation_messages.LOCATION%TYPE,
      i_message         n_installation_messages.MESSAGE%TYPE,
      i_creation_date   n_installation_messages.creation_date%TYPE DEFAULT SYSDATE   );

   PROCEDURE dc_main_view;

   PROCEDURE segstruct_view;

   PROCEDURE anomaly_view;

   PROCEDURE flexsource_direct;

   PROCEDURE answer_int;
   
END n_gseg_integration_incr_pkg;
/

SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY n_gseg_integration_incr_pkg IS
   --
   gc_pkg_version   CONSTANT    VARCHAR2(30)                        := '6.5.1.1565';
   --
   gc_script        CONSTANT    VARCHAR2(200)                       := 'n_gseg_integration_incr_pkg';
   gc_process_type  CONSTANT    VARCHAR2(100)                       := 'GSEG'; 
   gc_user          CONSTANT    VARCHAR2(30)                        := user;
   --
   g_debug_flag                 BOOLEAN                             := FALSE;
   g_location                   VARCHAR2(200)                       := NULL;
   g_error_text                 VARCHAR2(200)                       := NULL;
   g_segment_name               n_f_kff_segments.segment_name%TYPE  := NULL;
   g_sv_column_flag             BOOLEAN                             := FALSE;

----------------------------------------------------------
--Cursor Delaration for usage across procedures
----------------------------------------------------------
   CURSOR detect_multi_seg ( p_data_table_key    VARCHAR2,
                             p_value_view_name   VARCHAR2,
                             p_desc_view_name    VARCHAR2   )   IS
   SELECT data_table_key,
          ( CASE
              WHEN seg_cnt = 1
                 THEN 'N'
              ELSE 'Y'
            END )           multi_seg_detected
     FROM ( SELECT seg.data_table_key, 
                   COUNT (*)            seg_cnt
              FROM n_f_kff_segments             seg,
                   n_f_kff_structure_groups     str,
                   n_f_kff_struct_grp_flex_nums nums
             WHERE seg.data_table_key           = p_data_table_key
               AND 

                 (    str.value_view_name       = p_value_view_name
                   OR str.description_view_name = p_desc_view_name        )
               AND str.structure_group_id       = nums.structure_group_id(+)
               AND str.data_table_key           = seg.data_table_key
               AND NVL( nums.id_flex_num, seg.id_flex_num) 
                                                = seg.id_flex_num
             GROUP BY seg.data_table_key);

    rec_multi_seg        detect_multi_seg%ROWTYPE;

    --derive additional for data_table_key
    CURSOR c2 ( p_flex_code         VARCHAR2,
                p_flex_appl_id      VARCHAR2,
                p_data_appl_table   VARCHAR2,
                p_str_grp           VARCHAR2 DEFAULT 'ALL',
                p_data_table_key    NUMBER   DEFAULT NULL    ) IS
    SELECT fs.id_flex_code, 
           fs.id_flex_application_id,
           fs.data_application_table_name,
           fs.data_application_table_name_ev,
           kff_structure_iden_source_col structure_id_col,
           fst.table_replacement_allowed_flag, 
           fs.data_table_key,
           fs.source_type, 
           str.group_type, 
           str.value_view_name seg_view,
           fst.kff_table_pk1, 
           str.description_view_name segd_view,
           LTRIM( RTRIM( n_gseg_utility_pkg.format_kff_segment( ff.flexfield_name ),
                         '_' ),
                  '_'     )                 flexfield_name,
           ff.kff_cols_in_global_view_flag,
           TRIM( REPLACE( ff.flexfield_name, 'Flexfield' ) ) kff_name
      FROM n_kff_flex_source_templates fst,
           n_f_kff_flex_sources fs,
           n_f_kff_structure_groups str,
           n_f_kff_flexfields ff
     WHERE fst.id_flex_code                 = NVL( p_flex_code, fst.id_flex_code )
       AND fst.id_flex_application_id       = NVL( p_flex_appl_id, fst.id_flex_application_id )
       AND fst.data_application_table_name  = NVL( p_data_appl_table,
                                                   fst.data_application_table_name )
       AND fst.id_flex_application_id       = fs.id_flex_application_id
       AND fst.id_flex_code                 = fs.id_flex_code
       AND fst.id_flex_application_id       = ff.id_flex_application_id
       AND fst.id_flex_code                 = ff.id_flex_code
       AND fst.data_application_id          = fs.data_application_id
       AND fst.data_application_table_name  = fs.data_application_table_name
       AND fs.data_table_key                = NVL( p_data_table_key, fs.data_table_key )
       AND str.data_table_key(+)            = fs.data_table_key
       AND str.group_type(+)                = p_str_grp;

    r2                   c2%ROWTYPE;

    CURSOR c3 (p_app_label VARCHAR2) IS
    SELECT *
      FROM n_application_owners
     WHERE application_label = p_app_label;

    r3                   c3%ROWTYPE;

    CURSOR c3_1 (p_flex_code VARCHAR2, p_flex_appl_id VARCHAR2) IS
    SELECT kff_short_name, kff_processing_type
      FROM n_kff_processing_templates pt
     WHERE pt.id_flex_application_id = p_flex_appl_id
       AND pt.id_flex_code      = p_flex_code;

    r3_1                 c3_1%ROWTYPE;

    --retrieve column properites
    CURSOR col_prop_cur ( p_view_name    VARCHAR2,
                          p_column_label VARCHAR2,
                          p_qry_pos      NUMBER         ) IS
    SELECT colp.view_name, 
           colp.query_position, 
           col.column_name,
           col.column_label, 
           col.column_id,
           col.t_column_id,
           COUNT( CASE
                    WHEN (    (    (     ptype.property_type  = 'INCLUDE_STRUCTURE'
                                     AND colp.value1               IS NULL
                                     AND colp.value2               IS NULL        )
                                OR (     ptype.property_type = 'INCLUDE_STRUCTURE'
                                     AND colp.value1 LIKE '%&%'                            )  )
                           OR NOT EXISTS 

                            ( SELECT 'X'
                                FROM n_view_properties         colp1,
                                     n_property_type_templates ptype1
                               WHERE colp1.source_pk_id           = colp.source_pk_id
                                 AND ptype1.property_type_id      = colp1.property_type_id
                                 AND ptype1.templates_table_name  = 'N_VIEW_COLUMN_TEMPLATES'
                                 AND ptype1.property_type         = 'INCLUDE_STRUCTURE' ) )
                         THEN NULL
                    WHEN (     ptype.property_type = 'INCLUDE_STRUCTURE'
                           AND (          colp.value1 NOT LIKE '%&%'
                                 OR (     colp.value1 IS NULL
                                      AND colp.value2 IS NOT NULL   ) ) )
                         THEN 1
                    ELSE NULL
                  END         )                 include_structure_count,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_CONCAT_SEGMENT_DESC' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_desc,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_CONCAT_SEGMENT_VALUES' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_val,
               COUNT( CASE ptype.property_type
                        WHEN 'INCL_CONCAT_PARENT_SEG_DESC' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_pdesc,
               COUNT( CASE ptype.property_type
                        WHEN 'INCL_CONCAT_PARENT_SEG_VALUES' THEN 1
                        ELSE NULL
                      END     )                 include_concat_seg_pval,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_INDIV_SEGMENT_DESC' THEN 1
                        ELSE NULL
                      END     )                 include_indiv_seg_desc,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_INDIV_SEGMENT_VALUES' THEN 1
                        ELSE NULL
                      END     )                 include_indiv_seg_val,
               COUNT( CASE ptype.property_type
                        WHEN 'EXCLUDE_GLOBAL_HELPER_COLUMNS' THEN 1
                        ELSE NULL
                      END     )                 exclude_helper_columns,
               COUNT( CASE 
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1            = 'PRIMARY_KEY' 
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_primary_key_col,
               COUNT( CASE 
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1            = 'STRUCTURE_NAME' 
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_structure_name_col,
               COUNT( CASE 
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1            = 'SEGMENT_NAME_LIST' 
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_segment_name_list_col,
               COUNT( CASE 
                        WHEN (     ptype.property_type   = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                               AND (    colp.value1         LIKE 'Z$%' 
                                     OR NVL(colp.value1,'ALL') = 'ALL'      ) )            THEN 1
                        ELSE NULL
                      END     )                 exclude_z$_col,
               COUNT( CASE ptype.property_type
                        WHEN 'INCLUDE_QUALIFIER' THEN 1
                        ELSE NULL
                      END     )                 include_qualifier_count,
               COUNT( CASE 
                        WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                               AND value2                    = 'Y'  )    THEN 1
                        ELSE NULL
                      END     )                 include_qualifier_val,
               COUNT( CASE
                        WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                               AND value3                    = 'Y'  )    THEN 1
                        ELSE NULL
                      END     )                 include_qualifier_desc
          FROM n_view_properties         colp, 
               n_property_type_templates ptype,
               n_view_columns            col
         WHERE col.view_name                = p_view_name
           AND col.query_position           = p_qry_pos
           AND col.column_label             = p_column_label
           AND col.column_type           LIKE 'SEG%'
           AND colp.view_name               = p_view_name
		   AND col.application_instance='G0'
		   AND exists (select 1 from n_to_do_views_incr where view_label=col.view_label)
           AND colp.query_position          = p_qry_pos
           AND colp.view_name               = col.view_name
           AND colp.query_position          = col.query_position
           AND colp.source_pk_id            = col.column_id
           AND ptype.property_type_id       = colp.property_type_id
           AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
      GROUP BY colp.view_name,
               colp.query_position,
               col.column_id,
               col.t_column_id,
               col.column_name,
               col.column_label;



    col_prop_rec         col_prop_cur%ROWTYPE;

    --given the data table key, this cursor gets the concatenated source expressions for the segment list
    CURSOR c4 ( p_data_table_key              VARCHAR2,
                p_col_type                    VARCHAR2,
                p_processing_type             VARCHAR2,
                p_md_struct_constraint_type   VARCHAR2,
                p_multi_seg_detected          VARCHAR2,
                p_exclude_helper_columns      NUMBER,
                p_include_concat_seg_val      NUMBER,
                p_include_concat_seg_pval     NUMBER,
                p_include_concat_seg_desc     NUMBER,
                p_include_concat_seg_pdesc    NUMBER   ) IS
    SELECT DISTINCT 
           kcat.concatenation_type, 
           kcat.target_column_name,
           kcat.formatted_column_name,
           ( CASE
               WHEN ( kcat.concatenation_type = 'LIST'  ) THEN 1
               WHEN ( kcat.concatenation_type = 'VAL'   ) THEN 2
               WHEN ( kcat.concatenation_type = 'PVAL'  ) THEN 3
               WHEN ( kcat.concatenation_type = 'DESC'  ) THEN 4
               WHEN ( kcat.concatenation_type = 'PDESC' ) THEN 5
               ELSE NULL
             END                             ) l
      FROM n_f_kff_concatenations kcat
     WHERE kcat.data_table_key = p_data_table_key
---Do not bring in the segment list column, if EXLCUDE_GLOBAL_HELPER_COLUMNS mentioned for the column property
       AND ( CASE
               WHEN (         kcat.concatenation_type           = 'LIST'
                      AND (     p_processing_type          = 'SOURCED'
                            AND p_md_struct_constraint_type    != 'SINGLE'
                            AND p_exclude_helper_columns        = 0  ) )  THEN 1
---Bring in the concatenated value column, if corresponding property (INCLUDE_CONCAT_SEGMENT_VALUES)exists
               WHEN (      kcat.concatenation_type = 'VAL'
                       AND p_include_concat_seg_val > 0
                       AND 

                         (    (     p_processing_type = 'SINGLE'
                                AND p_multi_seg_detected = 'Y' )
                           OR (     p_processing_type = 'SOURCED'
                                AND p_multi_seg_detected = 'Y'
                                AND p_md_struct_constraint_type = 'SINGLE' )
                           OR (     p_processing_type = 'SOURCED'
                                AND p_md_struct_constraint_type <> 'SINGLE' ) ) ) THEN 2
---Bring in the concatenated parent value column, if corresponding property (INCL_CONCAT_PARENT_SEG_VALUES)exists
               WHEN (     kcat.concatenation_type   = 'PVAL'
                      AND p_include_concat_seg_pval > 0 )                         THEN 3
---Bring in the concatenated description column, if corresponding property (INCLUDE_CONCAT_SEGMENT_DESC)exists
               WHEN (     kcat.concatenation_type = 'DESC'
                      AND p_include_concat_seg_desc > 0
                      AND (    (     p_processing_type    = 'SINGLE'
                                 AND p_multi_seg_detected = 'Y'  )
                            OR (     p_processing_type           = 'SOURCED'
                                 AND p_multi_seg_detected        = 'Y'
                                 AND p_md_struct_constraint_type = 'SINGLE')
                            OR (     p_processing_type = 'SOURCED'
                                 AND p_md_struct_constraint_type <> 'SINGLE' ) ) ) THEN 4
---Bring in the concatenated description column, if corresponding property (INCL_CONCAT_PARENT_SEG_DESC)exists
               WHEN (     kcat.concatenation_type    = 'PDESC'
                      AND p_include_concat_seg_pdesc > 0   )                       THEN 5
             END  ) IS NOT NULL
     ORDER BY l;

    --Deriving Structure
    CURSOR c4_1( p_processing_type             VARCHAR2,
                 p_md_struct_constraint_type   VARCHAR2,
                 p_exclude_helper_columns      NUMBER               ) IS
    WITH DATA AS
       ( SELECT LEVEL lvl
           FROM DUAL
        CONNECT BY LEVEL < 2 )
    SELECT ( CASE
               WHEN ROWNUM = 2
                  THEN 'Structure_ID'
               WHEN ROWNUM = 1
                  THEN 'Structure_Name'
            END
           ) struct_column
      FROM DATA
     WHERE ( CASE
               WHEN (     p_processing_type            = 'SOURCED'
                      AND p_md_struct_constraint_type != 'SINGLE'
                      AND p_exclude_helper_columns     = 0 ) THEN 1
               ELSE NULL
             END           ) = 1;

    --Deriving Qualifier columns
    CURSOR c4_2( p_data_table_key   VARCHAR2,
                 p_view_name        VARCHAR2,
                 p_column_ID        INTEGER,
                 p_qry_pos          NUMBER   ) IS
    WITH DATA AS
       ( SELECT LEVEL lvl
           FROM DUAL
        CONNECT BY LEVEL <= 2 )
    SELECT DISTINCT 
           segment_prompt,
           ( CASE
               WHEN (     lvl         = 1 

                      AND colp.value2 = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_val_pfx ||
                                                   '$' || REPLACE( REPLACE( segment_prompt,
                                                                            ' Segment' ),
                                                                   ' ', '_' )
               WHEN (     lvl         = 2 

                      AND colp.value3 = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_desc_pfx ||
                                                   '$' || REPLACE( REPLACE( segment_prompt,
                                                                            ' Segment' ),
                                                                   ' ', '_' )
             END )          qual_col_name,
           segment_attribute_type
      FROM n_f_kff_seg_qual_helper_view hv,
           DATA,
           n_property_type_templates ptype,
           n_view_properties         colp
      WHERE data_table_key              = p_data_table_key
        AND colp.view_name              = p_view_name
        AND colp.source_pk_id           = p_column_id
        AND colp.query_position         = p_qry_pos
        AND ptype.property_type_id      = colp.property_type_id
        AND ptype.templates_table_name  = 'N_VIEW_COLUMN_TEMPLATES'
        AND ( CASE
                WHEN ( ptype.property_type = 'INCLUDE_QUALIFIER'     ) THEN colp.value1
                WHEN ( ptype.property_type = 'INCLUDE_ALL_QUALIFIER' ) THEN segment_attribute_type
                ELSE NULL
              END  ) = segment_attribute_type
        AND ( CASE
                WHEN (     lvl         = 1 

                       AND colp.value2 = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_val_pfx ||
                                                    '$' || REPLACE( REPLACE( segment_prompt,
                                                                             ' Segment' ),
                                                                    ' ', '_' )
                WHEN (     lvl          = 2 

                       AND colp.value3  = 'Y' ) THEN n_gseg_utility_pkg.g_kff_dc_qual_desc_pfx || 
                                                     '$' || REPLACE( REPLACE( segment_prompt,
                                                                              ' Segment' ),
                                                                     ' ', '_' )
                ELSE NULL
             END  )                 IS NOT NULL
      ORDER BY segment_prompt;

--given the data key, this cursor retrieves the primary key(s) for the data application table
    CURSOR c5( p_data_table_key           VARCHAR2,
               p_process_type_code        VARCHAR2,
               p_exclude_helper_columns   NUMBER    ) IS
    WITH DATA AS
       ( SELECT LEVEL lvl
           FROM DUAL
        CONNECT BY LEVEL <= 3 )
    SELECT data_table_key, 
           lvl                  col_seq,
           ( CASE
               WHEN ( lvl = 1 ) THEN kff_table_pk1
               WHEN ( lvl = 2 ) THEN kff_table_pk2
               WHEN ( lvl = 3 ) THEN kff_table_pk3
               ELSE NULL
             END        )       kff_pk,
           fs.id_flex_code
      FROM DATA, 
           n_kff_flex_source_templates  pt, 
           n_f_kff_flex_sources         fs
     WHERE ( CASE
               WHEN ( lvl = 1 ) THEN kff_table_pk1
               WHEN ( lvl = 2 ) THEN kff_table_pk2
               WHEN ( lvl = 3 ) THEN kff_table_pk3
               ELSE NULL
             END ) IS NOT NULL
       AND fs.data_table_key                = p_data_table_key
       AND pt.id_flex_application_id        = fs.id_flex_application_id
       AND pt.id_flex_code                  = fs.id_flex_code
       AND pt.data_application_id           = fs.data_application_id
       AND pt.data_application_table_name   = fs.data_application_table_name
       --AND fs.source_type = 'DC'
       AND (    p_exclude_helper_columns    = 0 
             OR p_process_type_code         = 'WHERE'  )
    ORDER BY data_table_key;

---------------------------------------------------------------------------------------
 -- Define the procedures and functions
 ---------------------------------------------------------------------------------------
    FUNCTION get_version
      RETURN VARCHAR2 IS
    BEGIN
        return gc_pkg_version;
    END get_version;

--
-------------------------------------
--
-- Turns On Debug Mode
    PROCEDURE debug_on IS
    BEGIN
        IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN 
            dbms_output.enable(NULL);
        ELSE
            dbms_output.enable(1000000);
        END IF;
        g_debug_flag := TRUE;
    END;

-------------------------------------
--
-- Turns On Debug Mode
    FUNCTION debug_on
      RETURN INTEGER IS
    BEGIN
        IF ( n_compare_version( N_GET_SERVER_VERSION, 10.2 ) >= 0 ) THEN 
            dbms_output.enable(NULL);
        ELSE
            dbms_output.enable(1000000);
        END IF;
        g_debug_flag := TRUE;
        RETURN 1;
    END;

    --
    -- Turns Off Debug Mode
    PROCEDURE debug_off IS
    BEGIN
        DBMS_OUTPUT.DISABLE;
        g_debug_flag := FALSE;
    END;

    --
    -- Turns Off Debug Mode
    FUNCTION debug_off
      RETURN INTEGER IS
    BEGIN
        DBMS_OUTPUT.DISABLE;
        g_debug_flag := FALSE;
        RETURN 0;
    END;

    --
    -- Prints the message out for the debug mode.
    -- i_message      - The message
    -- i_output_type
    --      'ALL'  - All output types.  Basically both dbms_output and SM_Messages.
    --      'TEXT' - Output to dbms_output.
    --      'DB'   - Store the message in the messages table.
    -- i_location     - Additional location information.
    PROCEDURE DEBUG ( i_message       IN   VARCHAR2,
                      i_output_type   IN   VARCHAR2 DEFAULT 'DB',
                      i_location      IN   VARCHAR2 DEFAULT 'DEBUG'    )   IS
    BEGIN
        IF( g_debug_flag ) THEN
            IF ( i_output_type IN ('ALL', 'TEXT') )  THEN
                IF ( LENGTHB( i_message ) > 255 ) THEN
                    DBMS_OUTPUT.put_line( 'The following message was truncated:' );
                END IF;
                DBMS_OUTPUT.put_line( SUBSTRB(i_message, 1, 255) );
            END IF;

            IF ( i_output_type IN ('ALL', 'DB') ) THEN
                n_sec_manager_api_pkg.add_sm_message( i_script_name       => gc_script || '.' || g_location,
                                                      i_location          => NVL( i_location,
                                                                                  g_location ),
                                                      i_message_type      => 'DEBUG',
                                                      i_message           => i_message  );
            END IF;
        END IF;
    END;

    PROCEDURE add_debug_message( i_script_name     n_installation_messages.script_name%TYPE,
                                 i_location        n_installation_messages.LOCATION%TYPE,
                                 i_message         n_installation_messages.MESSAGE%TYPE,
                                 i_creation_date   n_installation_messages.creation_date%TYPE DEFAULT SYSDATE  ) IS
    BEGIN
        IF (g_debug_flag) THEN
            noetix_utility_pkg.add_installation_message( i_script_name,
                                                         i_location,
                                                         'DEBUG',
                                                         i_message,
                                                         i_creation_date,
                                                         gc_process_type );
        END IF;
    END add_debug_message;

   FUNCTION identify_join_operator( i_view_name      VARCHAR2,
                                    i_query_position NUMBER,
                                    i_table_alias    VARCHAR2,
                                    i_kff_pk1        VARCHAR2 )
     RETURN NUMBER IS
    

       l_lhs_where        VARCHAR2 (500);
       l_rhs_where        VARCHAR2 (500);
       l_outer_join_ctr   NUMBER;
       

       CURSOR cur_view_kff_joins IS
       SELECT where_clause
         FROM n_view_wheres
        WHERE view_name = i_view_name
          AND query_position = i_query_position
          AND INSTR (where_clause, '(+)') > 0
          AND (    ( UPPER( where_clause ) LIKE
                            '%'
                         || UPPER( i_table_alias )
                         || '.'
                         || UPPER( i_kff_pk1 )
                         || '%=%'
                     )
                OR ( UPPER( where_clause ) LIKE
                            '%=%'
                         || UPPER( i_table_alias )
                         || '.'
                         || UPPER( i_kff_pk1 )
                         || '%'
                     )
                 );

    BEGIN
      l_outer_join_ctr := 0;

      FOR rec_c IN cur_view_kff_joins LOOP
         l_lhs_where      := SUBSTRB( rec_c.where_clause, 1, INSTRB(rec_c.where_clause, '=' ) - 1);
                  

         l_rhs_where      := SUBSTRB( rec_c.where_clause, INSTRB(rec_c.where_clause, '=' ) + 1, LENGTHB(rec_c.where_clause));
         l_outer_join_ctr := l_outer_join_ctr + 
                             ( CASE
                                 WHEN (     (     UPPER( l_lhs_where ) LIKE
                                                       '%'||UPPER(i_table_alias) || '.' || UPPER(i_kff_pk1)||'%'
                                              AND INSTR( l_lhs_where, '(+)' ) > 0 )
                                        OR  (     UPPER( l_rhs_where ) LIKE
                                                       '%'||UPPER(i_table_alias) || '.' || UPPER(i_kff_pk1)||'%'
                                              AND INSTR( l_rhs_where, '(+)') > 0 ) ) 
                                        THEN 1
                                 ELSE 0
                               END );
      END LOOP;

      RETURN l_outer_join_ctr;
    END identify_join_operator;
---------------------------------------------------------------------
--
-- Procedure Name: dc_main_view
--
-- Description 
--   For all the SEG related views, populates the data cache views metadata into non-template tables.
--   The procedure populates the seg related metdata into non-template table like columns, tables etc.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE dc_main_view
   IS
      l_replace_table               BOOLEAN;
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_error_code                  NUMBER                            := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                     := 'SUCCESS';
      l_error_status                VARCHAR2 (1000)                   := 'ERROR';
      l_in_process_status           VARCHAR2 (30)                     := 'IN-PROCESS';
      l_error_number                NUMBER                            := NULL;
      l_tab_alias_ctr               BINARY_INTEGER                    := 0;
      l_column_position             NUMBER                            := 0;
      l_where_position              NUMBER                            := 0;
      l_tab_alias                   VARCHAR2 (20)                     := NULL;
      l_stat_tab_alias              VARCHAR2 (10)                     := NULL;
      l_stat_tab_name               VARCHAR2 (30)                     := NULL;
      l_stat_acct_col_name          VARCHAR2 (30)                     := NULL;
      l_table_name                  VARCHAR2 (30)                     := NULL;
      l_column_name                 VARCHAR2 (30)                     := NULL;
      l_column_expr                 VARCHAR2 (1000)                   := NULL;
      l_where_clause                VARCHAR2 (500)                    := NULL;
      l_dff_col_ctr                 BINARY_INTEGER                    := 0;
      l_other_col_ctr               BINARY_INTEGER                    := 0;
      l_other_col_where_ctr         BINARY_INTEGER                    := 0;
      l_keyview_ctr                 BINARY_INTEGER                    := 0;
      l_outerjoin                   VARCHAR2 (10);
      l_column_exists               BINARY_INTEGER;
      l_column_name_prefix          VARCHAR2 (30)                     := NULL;
      l_md_struct_constraint_type   VARCHAR2 (20);
      l_col_description             n_view_columns.description%TYPE   := NULL;
      l_id_flex_num                 n_f_kff_segments.id_flex_num%TYPE;
      l_source_value                NUMBER;
      l_dup_column_exists           BINARY_INTEGER                    := 0;
      l_column_property_type        VARCHAR2 (200);
      l_property_type_id            n_view_properties.property_type_id%TYPE;
      l_t_view_property_id          n_view_properties.t_view_property_id%TYPE; 
      l_view_property_id            n_view_properties.view_property_id%TYPE; 
      l_column_id                   n_view_columns.column_id%TYPE;
      l_t_column_id                 n_view_columns.t_column_id%TYPE;


---Determine the column first
      CURSOR c1  IS
      SELECT  c.column_ID,
              c.t_column_id,
              c.view_name,
              c.query_position,
              c.column_label,
              c.table_alias,
              c.column_name,
              t.from_clause_position,
              c.column_position,
              t.table_name,
              t.metadata_table_name,
              c.id_flex_code,
              ( CASE
                  WHEN (     c.id_flex_application_id = 800
                         AND c.id_flex_code           = 'COST' ) THEN 801
                  WHEN (     c.id_flex_application_id = 800
                         AND c.id_flex_code           = 'BANK' ) THEN 801
                  WHEN (     c.id_flex_application_id = 800
                         AND c.id_flex_code           = 'GRP'  ) THEN 801
                  ELSE c.id_flex_application_id
                END     )                                           id_flex_application_id,
               c.column_type,
               v.special_process_code,
               v.security_code,
               v.view_label,
               v.application_instance,
         c.lov_view_label, --added NV-192
               c.lov_view_name,--added NV-192
               c.lov_column_label,--added NV-192
               c.group_by_flag,
               c.key_view_name,
               c.key_view_label,
               c.profile_option,
               ( SELECT ct.description
                   FROM n_view_column_templates ct
                  WHERE ct.view_label                          = c.view_label
                    AND ct.query_position                      = c.query_position
                    AND ct.column_label                        = c.column_label
                    AND REPLACE(ct.column_type, 'KEY', 'SEG')  = c.column_type
                    AND NVL(ct.profile_option, 'XX')           = NVL(c.profile_option, 'XX')
                    AND ROWNUM                                 = 1   ) description
          FROM n_view_columns    c,
               n_view_tables     t, 
               n_views           v
         WHERE c.column_type         LIKE 'SEG%'
           AND c.column_type       NOT IN ('SEGP', 'SEGEXPR', 'SEGSTRUCT')
           AND c.application_instance   = 'G0'
           --AND c.generated_flag = 'N'
           AND c.view_name              = t.view_name
   		   AND exists (select 1 from n_to_do_views_incr where view_label=v.view_label)
           AND c.query_position         = t.query_position
           AND c.table_alias            = t.table_alias
           AND c.view_name              = v.view_name
           AND t.view_name              = v.view_name
           AND NVL (c.omit_flag, 'N')   = 'N'
           AND NVL (t.omit_flag, 'N')   = 'N'
           AND NVL (v.omit_flag, 'N')   = 'N'
           AND NVL (v.omit_flag, 'N')   = NVL (t.omit_flag, 'N')
           AND NVL (v.omit_flag, 'N')   = NVL (c.omit_flag, 'N')
           AND NVL (c.omit_flag, 'N')   = NVL (t.omit_flag, 'N')
           -- AND v.application_label IN ('GL', 'HXC')
           --AND v.view_name = 'HRG0_Applicant_Hist'
           AND EXISTS
             ( SELECT 1 

                 FROM n_f_kff_flex_sources fs
                WHERE fs.id_flex_code = c.id_flex_code )
           AND NOT EXISTS 
             ( SELECT 'x'
                 FROM n_view_columns subc
                WHERE v.view_name                = subc.view_name
                  AND NVL (subc.omit_flag, 'N')  = 'N'
                  AND c.query_position          != subc.query_position
                  AND subc.column_type           = 'SEGSTRUCT')
           AND NOT EXISTS 
             ( SELECT 1
                 FROM n_f_kff_flex_sources fs
                WHERE fs.id_flex_code                = c.id_flex_code
                  AND fs.data_application_table_name = t.metadata_table_name
                  AND fs.source_type                 = 'DIRECT'
                  AND fs.id_flex_application_id      =
                    ( CASE
                        WHEN (     c.id_flex_application_id = 800
                               AND c.id_flex_code IN ('COST', 'BANK', 'GRP') ) THEN 801
                        ELSE c.id_flex_application_id
                      END   ))
      ORDER BY c.column_type, c.view_name, c.query_position, c.column_label;

      CURSOR c1_2( p_data_table_key   NUMBER,
                   p_view_name        VARCHAR2,
                   p_column_NAME      VARCHAR2,
                   p_qry_pos          NUMBER      )    IS
      SELECT data_table_key, 
             group_type, 
             subset_type, 
             value_view_name seg_view,
             description_view_name segd_view
        FROM n_f_kff_strgrp_view_xref   hlp, 
             n_view_properties          colp,
             n_view_columns             col,
             n_property_type_templates  ptype
       WHERE COL.column_name                         = p_column_name
         AND col.view_name                           = p_view_name
         AND col.query_position                      = p_qry_pos
         AND hlp.data_table_key                      = p_data_table_key
         AND colp.view_name                          = p_view_name
         AND colp.query_position                     = p_qry_pos
         AND colp.view_name                          = col.view_name
         AND colp.query_position                     = col.query_position
         and colp.source_pk_id                       = col.column_id
         AND NVL(hlp.column_label,col.column_label)  = col.column_label
         AND NVL(hlp.view_name,col.view_name)        = col.view_name
         AND ptype.property_type_id                  = colp.property_type_id
         AND ptype.templates_table_name              = 'N_VIEW_COLUMN_TEMPLATES'
         AND group_type =
                   ( CASE
                       WHEN (     PTYPE.property_type     = 'INCLUDE_STRUCTURE'
                              AND colp.value1              IS NOT NULL 

                              AND colp.value1            NOT LIKE '%&%'         )               THEN 'SUBSET'
                       WHEN (     PTYPE.property_type     = 'INCLUDE_STRUCTURE'
                              AND colp.value2              IS NOT NULL 

                              AND colp.value1                  IS NULL )                        THEN 'SUBSET'
                       WHEN (    (   (     PTYPE.property_type  = 'INCLUDE_STRUCTURE'
                                      AND colp.value1               IS NULL
                                      AND colp.value2               IS NULL    )
                                  OR (     PTYPE.property_type  = 'INCLUDE_STRUCTURE'
                                       AND colp.value1             LIKE '%&%'   )  )
                              OR NOT EXISTS 

                               ( SELECT 'X'
                                   FROM n_view_properties         colp1,
                                        n_property_type_templates ptype1
                                  WHERE colp1.view_name             = colp.view_name
                                    AND colp1.SOURCE_PK_ID          = colp.SOURCE_PK_ID
                                    AND colp1.query_position        = colp.query_position
                                    AND ptype1.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES'
                                    AND ptype1.property_type_id     = colp1.property_type_id
                                    AND ptype1.property_type        = 'INCLUDE_STRUCTURE' ) )   THEN 'ALL'
                       ELSE TO_CHAR( NULL )
                     END        )
         AND ROWNUM                     = 1;


      r1_2                          c1_2%ROWTYPE;

      CURSOR c1_3( p_view_name VARCHAR2, 
                   p_col_name  VARCHAR2, 
                   p_qry_pos   NUMBER ) IS
         SELECT 'Y' val_desc_both_reqd
           FROM DUAL
          WHERE EXISTS 
              ( SELECT 'X'
                  FROM n_view_properties         colp,
                       n_property_type_templates ptype,
                       n_view_columns            col
                 WHERE col.view_name                = p_view_name
                   AND col.query_position           = p_qry_pos
                   AND col.column_name              = p_col_name
                   AND colp.view_name               = col.view_name
                   AND colp.query_position          = col.query_position
                   AND colp.source_pk_id            = col.column_id
                   AND ptype.property_type_id       = colp.property_type_id
                   AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                   AND ptype.property_type         IN
                             ( 'INCLUDE_CONCAT_SEGMENT_DESC',
                               'INCLUDE_INDIV_SEGMENT_DESC',
                               'INCLUDE_CONCAT_SEGMENT_VALUES',
                               'INCLUDE_INDIV_SEGMENT_VALUES' ) );

      r1_3                          c1_3%ROWTYPE;

      CURSOR c1_4 (p_view_name VARCHAR2, p_col_name VARCHAR2, p_qry_pos NUMBER)
      IS
         SELECT 'Y' val_only_reqd
           FROM DUAL
          WHERE EXISTS 
              ( SELECT 'X'
                  FROM n_view_properties            colp,
                       n_view_columns               col,
                       n_property_type_templates    ptype
                 WHERE col.view_name                = p_view_name
                   AND col.query_position           = p_qry_pos
                   AND col.column_name              = p_col_name
                   AND colp.view_name               = col.view_name
                   AND colp.query_position          = col.query_position
                   AND colp.source_pk_id            = col.column_id
                   AND ptype.property_type_id       = colp.property_type_id
                   AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                   AND ptype.property_type         IN
                             ( 'INCLUDE_CONCAT_SEGMENT_VALUES',
                               'INCLUDE_INDIV_SEGMENT_VALUES' ))
            AND NOT EXISTS 
              ( SELECT 'X'
                  FROM n_view_properties colp,
                       n_view_columns  col,
                       n_property_type_templates ptype
                 WHERE col.view_name                = p_view_name
                   AND col.query_position           = p_qry_pos
                   AND col.column_name              = p_col_name
                   AND colp.view_name               = col.view_name
                   AND colp.query_position          = col.query_position
                   AND colp.source_pk_id            = col.column_id
                   AND ptype.property_type_id       = colp.property_type_id
                   AND ptype.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                   AND ptype.property_type         IN
                             ('INCLUDE_CONCAT_SEGMENT_DESC',
                              'INCLUDE_INDIV_SEGMENT_DESC'));

      r1_4                          c1_4%ROWTYPE;

      CURSOR col_prop_cur( p_view_name   VARCHAR2,
                           p_col_name    VARCHAR2,
                           p_qry_pos     NUMBER     )      IS
      SELECT colp.view_name, 
             colp.query_position, 
             col.column_name,
             col.column_label,
             col.t_column_id,
             col.column_id, 
             COUNT( CASE
                      WHEN (    (     ptype.property_type = 'INCLUDE_STRUCTURE'
                                  AND colp.value1              IS NULL
                                  AND colp.value2              IS NULL )
                             OR (     ptype.property_type = 'INCLUDE_STRUCTURE'
                                  AND colp.value1            LIKE '%&%' ) 
                             OR NOT EXISTS 


                              ( SELECT 'X'
                                  FROM n_view_properties         colp1,
                                       n_property_type_templates ptype1
                                 WHERE colp1.source_pk_id               = colp.source_pk_id
                                   AND colp1.property_type_id           = ptype1.property_type_id
                                   AND ptype1.templates_table_name      = 'N_VIEW_COLUMN_TEMPLATES' 
                                   AND ptype1.property_type             = 'INCLUDE_STRUCTURE'   ) )  THEN NULL
                      WHEN (     ptype.property_type                    = 'INCLUDE_STRUCTURE'
                             AND (    colp.value1           NOT LIKE '%&%'
                                   OR (     colp.value1                 IS NULL
                                        AND colp.value2                 IS NOT NULL ) ) )       THEN 1
                      ELSE NULL
                    END )                  include_structure_count,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_CONCAT_SEGMENT_DESC' THEN 1
                      ELSE NULL
                    END )                  include_concat_seg_desc,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_CONCAT_SEGMENT_VALUES' THEN 1
                      ELSE NULL
                    END      )             include_concat_seg_val,
             COUNT( CASE ptype.property_type
                      WHEN 'INCL_CONCAT_PARENT_SEG_DESC' THEN 1
                      ELSE NULL
                    END      )             include_concat_seg_pdesc,
             COUNT( CASE ptype.property_type
                      WHEN 'INCL_CONCAT_PARENT_SEG_VALUES'  THEN 1
                      ELSE NULL
                    END      )             include_concat_seg_pval,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_INDIV_SEGMENT_DESC'     THEN 1
                      ELSE NULL
                    END      )             include_indiv_seg_desc,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_INDIV_SEGMENT_VALUES'   THEN 1
                      ELSE NULL
                    END      )             include_indiv_seg_val,
             COUNT( CASE ptype.property_type
                      WHEN 'EXCLUDE_GLOBAL_HELPER_COLUMNS'  THEN 1
                      ELSE NULL
                    END      )             exclude_helper_columns,
             COUNT( CASE 
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1              = 'PRIMARY_KEY' 
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                      ELSE NULL
                    END     )              exclude_primary_key_col,
             COUNT( CASE 
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1              = 'STRUCTURE_NAME' 
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                      ELSE NULL
                    END     )              exclude_structure_name_col,
             COUNT( CASE 
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1              = 'SEGMENT_NAME_LIST' 
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                   ELSE NULL
                 END     )                 exclude_segment_name_list_col,
             COUNT( CASE 
                      WHEN (     ptype.property_type     = 'EXCLUDE_GLOBAL_HELPER_COLUMNS'
                             AND (    colp.value1           LIKE 'Z$%' 
                                   OR NVL(colp.value1,'ALL')   = 'ALL'     ) )     THEN 1
                   ELSE NULL
                 END     )                 exclude_z$_col,
             COUNT( CASE ptype.property_type
                      WHEN 'INCLUDE_QUALIFIER'     THEN 1
                      ELSE NULL
                    END    )               include_qualifier_count,
             COUNT( CASE
                      WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                             AND colp.value2               = 'Y' )                 THEN 1
                      ELSE NULL
                    END    )               include_qualifier_val,
             COUNT( CASE
                      WHEN (     ptype.property_type = 'INCLUDE_QUALIFIER'
                             AND colp.value3               = 'Y' )                 THEN 1
                      ELSE NULL
                    END    )               include_qualifier_desc
        FROM n_view_properties          colp,
             n_view_columns             col,
             n_property_type_templates  ptype
       WHERE col.view_name              = p_view_name
         AND col.column_name            = p_col_name
         AND col.query_position         = p_qry_pos
         AND col.column_id              = colp.source_pk_id
         and ptype.property_type_id     = colp.property_type_id
		   AND exists (select 1 from n_to_do_views_incr where view_label=col.view_label)
		   and col.application_instance='G0'
         and ptype.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES'
    GROUP BY colp.view_name, 
             colp.query_position, 
             col.column_name,
             col.column_label, 
             col.t_column_id,
             col.column_id;

      col_prop_rec                  col_prop_cur%ROWTYPE;

--KFF biz rule----
      CURSOR c6 (
         p_data_table_key           VARCHAR2,
         p_cust_prompt              VARCHAR2,
         p_include_indiv_seg_val    VARCHAR2,
         p_include_indiv_seg_desc   VARCHAR2,
         p_include_concat_seg_val   VARCHAR2,
         p_include_concat_seg_desc  VARCHAR2,
         p_multi_seg_detected       VARCHAR2,
         p_processing_type          VARCHAR2,
         p_constraint_type          VARCHAR2,
         p_value_view_name          VARCHAR2,
         p_desc_view_name           VARCHAR2,
         p_view_spl_process_code    VARCHAR2,
         p_column_name_prefix       VARCHAR2
      )
      IS
       SELECT formatted_target_column_name, target_column_name,
              COUNT(1) over(partition by formatted_target_column_name) dup_col_cnt,
              ROW_NUMBER() over(partition by formatted_target_column_name order by formatted_target_column_name, target_column_name) sub_script
         FROM   

         (SELECT n_gseg_utility_pkg.FORMAT_KFF_SEGMENT(p_column_name_prefix||'$'||target_column_name,30) formatted_target_column_name,
            target_column_name
          FROM 
         (      


         WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL <= 2)
         SELECT DISTINCT (CASE
                             WHEN lvl = 1
                                THEN target_column_name
                             WHEN lvl = 2
                                THEN target_desc_column_name
                          END
                         ) target_column_name
                    FROM DATA,
                         n_f_kff_segments seg,
                         n_f_kff_structure_groups str,
                         n_f_kff_struct_grp_flex_nums nums
                   WHERE seg.data_table_key = p_data_table_key
                     AND (   str.value_view_name = p_value_view_name
                          OR str.description_view_name = p_desc_view_name
                         )
                     AND str.structure_group_id = nums.structure_group_id(+)
                     AND str.data_table_key = seg.data_table_key
                     AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num
                     AND (   (    p_view_spl_process_code = 'LOV'
                              AND (   (lvl = 1 AND p_include_indiv_seg_val = 1
                                      )
                                   OR (lvl = 2 AND p_include_indiv_seg_desc = 1
                                      )
                                  )
                             )
                          OR ((CASE
                                 WHEN (    lvl = 1
                                       AND (   p_include_indiv_seg_val = 0
                                            OR (    p_cust_prompt = 'N'
                                                AND p_processing_type =
                                                                     'SOURCED'
                                                AND p_constraint_type IN
                                                         ('NONE', 'MULTIPLE')
                                               )
                                           )
                                      )
                                    THEN 1
                                 WHEN (    lvl = 2
                                       AND (   p_include_indiv_seg_desc = 0
                                            OR (    p_cust_prompt = 'N'
                                                AND p_processing_type =
                                                                     'SOURCED'
                                                AND p_constraint_type IN
                                                         ('NONE', 'MULTIPLE')
                                               )
                                           )
                                      )
                                    THEN 2
                              END  ) IS NULL )
                          OR ((CASE
                                 WHEN (     lvl                       = 1
                                        AND p_include_indiv_seg_val   = 0
                                        AND p_include_concat_seg_val  > 0
                                        AND p_multi_seg_detected      = 'N'
                                        AND p_processing_type         = 'SOURCED'
                                        AND p_constraint_type         = 'SINGLE'    )  THEN 1
                                 WHEN (     lvl                       = 2
                                        AND p_include_indiv_seg_desc  = 0
                                        AND p_include_concat_seg_desc > 0
                                        AND p_multi_seg_detected      = 'N'
                                        AND p_processing_type         = 'SOURCED'
                                        AND p_constraint_type         = 'SINGLE'    )  THEN 1
                              END ) = 1 )
                         )
                       ));
   BEGIN
      l_error_location := 'start processing';

      OPEN c3 (n_gseg_utility_pkg.g_kff_app_label);

      FETCH c3
       INTO r3;

      CLOSE c3;

--Primary cursor to get the view columns where the data cache metadata needs to be brought int
      FOR r1 IN c1 LOOP                                                             --{ c1
         r2                 := NULL;
         l_table_name       := NULL;
         l_column_position  := r1.column_position;
         g_sv_column_flag   := FALSE;

         --The cursor c2 to derive the data table key and some additional information
         OPEN c2( r1.id_flex_code,
                  r1.id_flex_application_id,
                  r1.metadata_table_name,
                  'ALL'  );                                                         --{c2

         FETCH c2
          INTO r2;

         CLOSE c2;

--Derive the structure group based on the column properties. Based on this, appropriate data cache
--view will be selected and incorporated
         OPEN c1_2 (r2.data_table_key,
                    r1.view_name,
                    --r1.column_label,
                    r1.column_name,
                    r1.query_position
                   );

         FETCH c1_2
          INTO r1_2;

         CLOSE c1_2;

--Based on column properties, decide if the description and values are requested
         OPEN c1_3 (r1.view_name, r1.column_name, r1.query_position);

         FETCH c1_3
          INTO r1_3;

         CLOSE c1_3;

--Based on column properties, decide if the values are requested
         OPEN c1_4 (r1.view_name, r1.column_name, r1.query_position);

         FETCH c1_4
          INTO r1_4;

         CLOSE c1_4;

         --derive column name prefix
         l_column_name_prefix   := ( CASE
                                       WHEN (     LENGTHB(r1.column_label)     > 8
                                              AND INSTRB(r1.column_label, '_') > 0 )
                                            THEN ( CASE 

                                                     WHEN ( INSTRB(SUBSTRB(r1.column_label,1,8), '_') > 0 ) 
                                                         THEN SUBSTRB(r1.column_label, 1, 8)
                                                     ELSE SUBSTRB(r1.column_label, 1, 7) || 
                                                          SUBSTRB(r1.column_label, INSTRB(r1.column_label, '_') + 1,1 )
                                                   END )
                                       WHEN (     LENGTHB( r1.column_label )   > 8
                                              AND INSTRB(r1.column_label, '_') = 0 ) 
                                            THEN SUBSTRB( r1.column_label, 1, 8 )
                                       ELSE r1.column_label
                                     END  );

          l_column_name_prefix := RTRIM( l_column_name_prefix,'_' );

      --KFF biz rule----
--Derive the multi seg struct property
         OPEN detect_multi_seg (r2.data_table_key,
                                r1_2.seg_view,
                                r1_2.segd_view
                               );

         FETCH detect_multi_seg
          INTO rec_multi_seg;

         CLOSE detect_multi_seg;

         --Add column property INCLUDE_INDIV_SEGMENT_VALUES or INCLUDE_INDIV_SEGMENT_DESC
         --for single structure and single segment
         IF rec_multi_seg.multi_seg_detected = 'N' THEN

            OPEN col_prop_cur (r1.view_name, r1.column_name, r1.query_position);

            FETCH col_prop_cur
             INTO col_prop_rec;

            CLOSE col_prop_cur;
            

            IF ( col_prop_rec.include_indiv_seg_val = 0 ) THEN

                n_gseg_utility_pkg.insert_view_col_prop
                           ( i_view_name                        => r1.view_name,
                             i_view_label                       => r1.view_label,
                             i_query_position                   => r1.query_position,
                             i_source_pk_id                     => r1.column_id,
                             i_t_source_pk_id                   => r1.t_column_id,
                             i_profile_option                   => r1.profile_option,
                             i_property_type                    => 'INCLUDE_INDIV_SEGMENT_VALUES',
                             o_view_property_id                 => l_view_property_id
                           );

             END IF;
             

             IF (     col_prop_rec.include_concat_seg_desc > 0 
                  AND col_prop_rec.include_indiv_seg_desc  = 0 ) THEN

                n_gseg_utility_pkg.insert_view_col_prop
                           ( i_view_name                        => r1.view_name,
                             i_view_label                       => r1.view_label,
                             i_query_position                   => r1.query_position,
                             i_source_pk_id                     => r1.column_id,
                             i_t_source_pk_id                   => r1.t_column_id,
                             i_profile_option                   => r1.profile_option,
                             i_property_type                    => 'INCLUDE_INDIV_SEGMENT_DESC',
                             o_view_property_id                 => l_view_property_id          );

            END IF;
            

            --COMMIT;  
            

            col_prop_rec := NULL;
         END IF;


--Manifestation of column properties metadata
         OPEN col_prop_cur (r1.view_name, r1.column_name, r1.query_position);

         FETCH col_prop_cur
          INTO col_prop_rec;

         CLOSE col_prop_cur;

         IF col_prop_rec.include_structure_count = 0
         THEN
            l_md_struct_constraint_type := 'NONE';
         ELSIF col_prop_rec.include_structure_count = 1
         THEN
            l_md_struct_constraint_type := 'SINGLE';
         ELSE
            l_md_struct_constraint_type := 'MULTIPLE';
         END IF;

         OPEN c3_1 (r1.id_flex_code, r1.id_flex_application_id);       --{c3_1

         FETCH c3_1
          INTO r3_1;

         CLOSE c3_1;                                                   --}c3_1

-- additional logic for the table replacement logic
         l_error_location := 'table replacement validation';

--check dff columns
         SELECT COUNT (*)
           INTO l_dff_col_ctr
           FROM n_view_columns  c
          WHERE c.view_name         = r1.view_name
            AND c.query_position    = r1.query_position
            AND c.table_alias       = r1.table_alias
			and c.application_instance='G0'
		   AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
            AND c.column_type       = 'ATTR';

--check columns other than primary key colums in n_view_columns
         SELECT COUNT (*)
           INTO l_other_col_ctr
           FROM n_view_columns              c,
                n_kff_flex_source_templates pt,
                n_f_kff_flex_sources        fs
          WHERE c.view_name                     = r1.view_name
            AND c.query_position                = r1.query_position
			and c.application_instance='G0'
		   AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
            AND c.table_alias                   = r1.table_alias
            AND 

              (    UPPER (c.column_expression) NOT LIKE '%' || pt.kff_table_pk1 || '%'
                OR UPPER (c.column_expression) NOT LIKE '%' || pt.kff_table_pk2 || '%'
                OR UPPER (c.column_expression) NOT LIKE '%' || pt.kff_table_pk3 || '%' )
            AND fs.data_table_key               = r2.data_table_key
            AND pt.id_flex_application_id       = fs.id_flex_application_id
            AND pt.id_flex_code                 = fs.id_flex_code
            AND pt.data_application_id          = fs.data_application_id
            AND pt.data_application_table_name  = fs.data_application_table_name
            AND fs.source_type                  = 'DC';

--check columns other than primary key colums in n_view_wheres
         SELECT COUNT (*)
           INTO l_other_col_where_ctr
           FROM n_kff_flex_source_templates pt,
                n_f_kff_flex_sources        fs,
                n_view_wheres               w
          WHERE fs.data_table_key               = r2.data_table_key
            AND pt.id_flex_application_id       = fs.id_flex_application_id
            AND pt.id_flex_code                 = fs.id_flex_code
            AND pt.data_application_id          = fs.data_application_id
			and w.application_instance='G0'
				   AND exists (select 1 from n_to_do_views_incr where view_label=w.view_label)
            AND pt.data_application_table_name  = fs.data_application_table_name
            AND fs.source_type                  = 'DC'
            AND w.view_name                     = r1.view_name
            AND UPPER (w.where_clause)       LIKE '%' || UPPER(r1.table_alias) || '.%'
            AND w.query_position                = r1.query_position
            AND 

              (    UPPER (w.where_clause) NOT LIKE '%.' || pt.kff_table_pk1 || '%'
                OR UPPER (w.where_clause) NOT LIKE '%.' || pt.kff_table_pk2 || '%'
                OR UPPER (w.where_clause) NOT LIKE '%.' || pt.kff_table_pk3 || '%'  );

         l_keyview_ctr := 0;
         SELECT COUNT (*)
           INTO l_keyview_ctr
           FROM n_view_columns     c,
                n_join_key_columns jc,
                n_join_keys        j
          WHERE c.view_name          = r1.view_name
            AND c.query_position     = r1.query_position
            AND c.table_alias        = r1.table_alias
            AND j.view_name          = c.view_name
            AND j.column_type_code   = 'ROWID'
            AND jc.join_key_id       = j.join_key_id
			and c.application_instance='G0'
				   AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
            AND jc.column_name       = c.column_name;

--Column level key view name existence is also verified
--security_code = 'ACCOUNT'  table_replacement_allowed_flag='Y' => table_replacement_flag='N'
         IF (     r2.table_replacement_allowed_flag = 'Y'
              AND NVL(r1.security_code,'NONE')      = 'NONE'
              AND l_dff_col_ctr                     = 0
              AND l_other_col_ctr                   = 0
              AND l_other_col_where_ctr             = 0
              AND l_keyview_ctr                     = 0
              AND r1.key_view_name                 IS NULL   )   THEN
            l_replace_table := TRUE;
         ELSE
            l_replace_table := FALSE;
         END IF;

         l_error_location := 'Insert into n_view_tables';

---tables
         BEGIN
            l_table_name :=
               (CASE
                  WHEN (   col_prop_rec.include_concat_seg_desc > 0
                         OR col_prop_rec.include_indiv_seg_desc > 0
                         OR col_prop_rec.include_qualifier_desc > 0
                        )
                      THEN r1_2.segd_view
                   WHEN (   (    col_prop_rec.include_concat_seg_val > 0
                             AND col_prop_rec.include_concat_seg_desc = 0
                            )
                         OR (    col_prop_rec.include_indiv_seg_val > 0
                             AND col_prop_rec.include_indiv_seg_desc = 0
                            )
                         OR (    col_prop_rec.include_qualifier_val > 0
                             AND col_prop_rec.include_qualifier_desc = 0
                            )
                        )
                      THEN r1_2.seg_view
                  ELSE NULL
                END
               );

            IF NOT l_replace_table
            THEN
               SELECT COUNT (*)
                 INTO l_tab_alias_ctr
                 FROM n_view_tables
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position
                  AND RTRIM (TRANSLATE (UPPER (table_alias),
                                        '1234567890',
                                        '      '
                                       )
                            ) = UPPER (r1.id_flex_code);

               l_tab_alias_ctr := l_tab_alias_ctr + 1;
               l_tab_alias := UPPER (r1.id_flex_code);
               l_tab_alias := l_tab_alias || l_tab_alias_ctr;

               INSERT INTO n_view_tables
                    ( view_name, 
                      view_label, 


                      query_position,
                      table_alias, 
                      from_clause_position,
                      application_label, 
                      owner_name, 

                      table_name,
                      metadata_table_name,
                      application_instance, 
                      base_table_flag,
                      generated_flag,
                      subquery_flag, 
                      gen_search_by_col_flag  )
               VALUES 

                    ( r1.view_name, 
                      r1.view_label, 
                      r1.query_position,
                      l_tab_alias, 
                      r1.from_clause_position + 0.1,
                      r3.application_label, 
                      gc_user, 

                      l_table_name,
                      l_table_name,
                      r1.application_instance, 
                      'N',
                      'Y',
                      'N', 

                      'Y'  );
            ELSE
               l_tab_alias := r1.table_alias;

               UPDATE n_view_tables t
                  SET t.table_name          = l_table_name,
                      t.metadata_table_name = ( CASE 
                                                  WHEN ( l_table_name LIKE 'XXK%' ) THEN l_table_name
                                                  ELSE t.metadata_table_name
                                                END ),
                      t.owner_name          = gc_user,
                      t.generated_flag      = 'Y',
                      t.application_label   = n_gseg_utility_pkg.g_kff_app_label
                WHERE t.view_name       = r1.view_name
                  AND t.query_position  = r1.query_position
                  AND t.table_alias     = r1.table_alias;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     r1.view_name
                  || '~'
                  || r1.query_position
                  || '~'
                  || l_tab_alias
                  || '~'
                  || l_table_name
                  || '~'
                  || r2.data_table_key
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

---columns
         l_error_location := 'Insert into n_view_columns';

---Source primary key columns
         FOR r5 IN c5( r2.data_table_key,
                       'COLUMN',
                       col_prop_rec.exclude_primary_key_col  )
         LOOP                                                          --{c5#1
            BEGIN
               l_error_location     := 'view columns metadata - source PK columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := n_gseg_utility_pkg.g_kff_coldesc_pk_sfx;
               l_col_description    := r1.description || ' ' || REPLACE(l_col_description, '<flexfield>', r2.kff_name);
               l_column_name        := ( CASE 
                                           WHEN ( r5.kff_pk = 'COST_ALLOCATION_KEYFLEX_ID' ) THEN 'COST_ALLOC_KEYFLEX_ID'
                                           WHEN ( r5.kff_pk = 'POSITION_DEFINITION_ID'     ) THEN 'POSITION_DEFN_ID'
                                           ELSE r5.kff_pk 

                                         END );
               l_column_name        := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) ) 
                                                THEN SUBSTRB( l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
               l_column_name        := RTRIM (l_column_name, '_');
               l_column_name        := INITCAP (l_column_name);

               l_column_name        := l_column_name_prefix || '$' || l_column_name;

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => r5.kff_pk,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => null,--added NV-192 (Lov association is not required for Primary Key columns)
                        i_lov_view_name               => null,--added NV-192
                        i_lov_column_label            => null,--added NV-192
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_property_type                    => 'PRIMARY_KEY',
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_value1                           => r5.col_seq,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id            );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                     --}c5#1

---Structure columns
--KFF biz rule----
         FOR r4_1 IN c4_1( r3_1.kff_processing_type,
                           l_md_struct_constraint_type,
                           col_prop_rec.exclude_structure_name_col   )
--KFF biz rule----
         LOOP                                                          --{c4_1
            BEGIN
               l_error_location  := 'view columns metadata - structure columns ';
               l_column_position := l_column_position + 0.1;
               l_col_description := n_gseg_utility_pkg.g_kff_coldesc_structname_sfx;
               l_col_description := r1.description || ' ' || REPLACE (l_col_description, '<flexfield>', r2.kff_name);
               l_column_name     := r4_1.struct_column;
               l_column_name     := ( CASE
                                        WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB( l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                        ELSE l_column_name
                                      END  );
               l_column_name     := RTRIM( l_column_name, '_' );

               l_column_name     := l_column_name_prefix || '$' || l_column_name;

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => r4_1.struct_column,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => r1.lov_view_label,--added NV-192
                        i_lov_view_name               => r1.lov_view_name,--added NV-192
                        i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id
                       );

               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_property_type                    => 'STRUCTURE_NAME',
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,

                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id
                           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                     --}c4_1

---Qualifier columns
         FOR r4_2 IN c4_2 (r2.data_table_key,
                           r1.view_name,
                           r1.column_id,
                           r1.query_position
                          )
         LOOP                                                          --{c4_2
            BEGIN
               l_error_location  := 'view columns metadata - qualifier columns ';
               l_column_position := l_column_position + 0.1;
               l_col_description := ( CASE
                                        WHEN ( SUBSTRB(r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_qv_sfx
                                        ELSE n_gseg_utility_pkg.g_kff_coldesc_qd_sfx
                                      END );
               l_col_description := r1.description || ' ' || REPLACE( REPLACE( l_col_description, 
                                                                               '<segment>',
                                                                               REPLACE( r4_2.segment_prompt, 

                                                                                        ' Segment' ) ),
                                                                      '<flexfield>', r2.kff_name );
               l_column_expr     := r4_2.qual_col_name;
               l_column_name     := r4_2.qual_col_name;
               l_column_name     := ( CASE
                                        WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                 THEN SUBSTRB(l_column_name, 1,(29 - LENGTHB(l_column_name_prefix))  )
                                        ELSE l_column_name
                                      END );
               l_column_name          := RTRIM (l_column_name, '_');
               l_column_property_type := ( CASE
                                             WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                    THEN 'QUALIFIER_VALUE'
                                             ELSE 'QUALIFIER_DESCRIPTION'
                                           END );

               l_column_name          := l_column_name_prefix || '$' || l_column_name;


               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => r1.lov_view_label,--added NV-192
                        i_lov_view_name               => r1.lov_view_name,--added NV-192
                        i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                        i_generated_flag              => 'Y',
                        i_segment_qualifier           => r4_2.segment_attribute_type,
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_property_type                    => l_column_property_type,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_value1                           => NULL,
                            i_value2                           => r4_2.segment_attribute_type,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                 );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                     --}c4_2

---Concatenated columns
--KFF biz rule----
         FOR r4 IN c4 (r2.data_table_key,
                       r1.column_type,
                       r3_1.kff_processing_type,
                       l_md_struct_constraint_type,
                       rec_multi_seg.multi_seg_detected,
                       col_prop_rec.exclude_segment_name_list_col,
                       col_prop_rec.include_concat_seg_val,
                       col_prop_rec.include_concat_seg_pval,
                       col_prop_rec.include_concat_seg_desc,
                       col_prop_rec.include_concat_seg_pdesc
                      )
--KFF biz rule----
         LOOP                                                            --{c4
            BEGIN
               l_error_location :=
                              'view columns metadata - concatenated columns ';
               l_column_position := l_column_position + 0.1;

               --sharas 02/19
               -- we donot want the Z$ for this lot
               IF (    (     r3_1.kff_processing_type         = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected = 'Y' )
                    OR (     r3_1.kff_processing_type         = 'SOURCED'
                         AND l_md_struct_constraint_type      = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected = 'Y'  ) )  THEN
                    g_sv_column_flag := TRUE; 
               END IF;
               --sharas 02/19

               --Column descriptions logic
               IF     r4.concatenation_type = 'VAL'
                  AND (   (    r3_1.kff_processing_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                       OR (    r3_1.kff_processing_type = 'SOURCED'
                           AND l_md_struct_constraint_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                      )
               THEN
                  BEGIN
                     SELECT seg.id_flex_num
                       INTO l_id_flex_num
                       FROM n_f_kff_structures seg,
                            n_f_kff_structure_groups str,
                            n_f_kff_struct_grp_flex_nums nums
                      WHERE seg.data_table_key = r2.data_table_key
                        AND (   str.value_view_name = r1_2.seg_view
                             OR str.description_view_name = r1_2.segd_view
                            )
                        AND str.structure_group_id = nums.structure_group_id(+)
                        AND str.data_table_key = seg.data_table_key
                        AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;

                  BEGIN
                     SELECT    'List of segment names for '
                            || str.structure_name
                            || ' structure is "'
                            || ccat.source_expression
                            || '".'
                       INTO l_col_description
                       FROM n_f_kff_concatenations ccat,
                            n_f_kff_structures str
                      WHERE ccat.data_table_key = r2.data_table_key
                        AND str.data_table_key = ccat.data_table_key
                        AND str.id_flex_num = l_id_flex_num
                        AND ccat.id_flex_num = str.id_flex_num
                        AND ccat.concatenation_type = 'LIST';
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;
               ELSE
                  l_col_description :=
                     (CASE
                         WHEN r4.concatenation_type = 'LIST'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_segnl_sfx
                         WHEN r4.concatenation_type = 'VAL'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cv_sfx
                         WHEN r4.concatenation_type = 'DESC'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cd_sfx
                      END
                     );
                  l_col_description :=
                        r1.description
                     || ' '
                     || REPLACE (l_col_description, '<flexfield>',
                                 r2.kff_name);
               END IF;

               l_column_name := r4.target_column_name;
               

               l_column_property_type :=
                  (CASE
                      WHEN r4.concatenation_type = 'VAL'
                         THEN 'CONCATENATED_VALUES'
                      WHEN r4.concatenation_type = 'DESC'
                         THEN 'CONCATENATED_DESCRIPTIONS'
                      WHEN r4.concatenation_type = 'LIST'
                         THEN 'SEGMENT_NAME_LIST'
                   END
                  );

               l_column_name := l_column_name_prefix || '$' || l_column_name;

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => r4.target_column_name,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
            i_lov_view_label              => r1.lov_view_label,--added NV-192
                        i_lov_view_name               => r1.lov_view_name,--added NV-192
                        i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);
               n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c4

---Individual segment columns
--KFF biz rule----
         FOR r6 IN c6 (r2.data_table_key,
                       r2.kff_cols_in_global_view_flag,
                       col_prop_rec.include_indiv_seg_val,
                       col_prop_rec.include_indiv_seg_desc,
                       col_prop_rec.include_concat_seg_val,
                       col_prop_rec.include_concat_seg_desc,
                       rec_multi_seg.multi_seg_detected,
                       r3_1.kff_processing_type,
                       l_md_struct_constraint_type,
                       r1_2.seg_view,
                       r1_2.segd_view,
                       r1.special_process_code,
                       l_column_name_prefix
                      )
--KFF biz rule----
         LOOP                                                            --{c6
            BEGIN
               IF (     r2.kff_cols_in_global_view_flag = 'Y'
                    AND r3_1.kff_processing_type        = 'SOURCED' )  THEN
                  g_sv_column_flag := FALSE;
               ELSE
                  g_sv_column_flag := TRUE;
               END IF;
               g_segment_name       := NULL;
               l_dup_column_exists  := 0;
               l_error_location     := 'view columns metadata - individual columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := ( CASE
                                           WHEN ( SUBSTR( r6.target_column_name, 1, 2 ) =  n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_sv_sfx
                                           ELSE n_gseg_utility_pkg.g_kff_coldesc_sd_sfx
                                         END );
                  

                  --Derive the segment name to add it into column description
                  BEGIN 




                  select seg.segment_name 
                    INTO g_segment_name 
                    from ( SELECT s.segment_name
                             FROM n_f_kff_segments s
                            WHERE s.data_table_key     = r2.data_table_key
                              AND s.target_column_name = r6.target_column_name
                            order by s.segment_name ) seg
                   where rownum = 1; 






                  EXCEPTION
                     WHEN OTHERS THEN
                        g_segment_name := NULL;
                  END;
               l_col_description :=
                     r1.description
                  || ' '
                  || REPLACE (REPLACE (l_col_description,
                                       '<segment>',
                                       g_segment_name
                                      ),
                              '<flexfield>',
                              r2.kff_name
                             );

                  l_column_name := r6.formatted_target_column_name;

                IF r6.dup_col_cnt > 1 THEN
                    IF r6.sub_script > 1 THEN
                        l_column_name := n_gseg_utility_pkg.format_kff_segment(l_column_name||r6.sub_script,30);
                    END IF;

                  SELECT COUNT (*)
                    INTO l_dup_column_exists
                    FROM n_view_columns
                   WHERE view_name = r1.view_name
                     AND column_name = l_column_name
                     AND UPPER (column_expression) =
                                                 UPPER (r6.target_column_name)
                     AND query_position = r1.query_position;

               END IF;

               l_column_property_type :=
                  (CASE
                      WHEN SUBSTR (r6.target_column_name, 1, 2) =
                                                       n_gseg_utility_pkg.g_kff_dc_seg_val_pfx
                         THEN 'SEGMENT_VALUE'
                      ELSE 'SEGMENT_DESCRIPTION'
                   END
                  );

               IF ( l_dup_column_exists = 0 ) THEN

                  n_gseg_utility_pkg.insert_view_column
                      (i_t_column_id                 => r1.t_column_id,
                       i_view_name                   => r1.view_name,
                       i_view_label                  => r1.view_label,
                       i_query_position              => r1.query_position,
                       i_column_name                 => l_column_name,
                       i_column_label                => r1.column_label,
                       i_table_alias                 => l_tab_alias,
                       i_column_expression           => r6.target_column_name,
                       i_column_position             => l_column_position,
                       i_column_type                 => 'GEN',
                       i_description                 => l_col_description,
                       i_ref_lookup_column_name      => NULL,
                       i_group_by_flag               => r1.group_by_flag,
                       i_application_instance        => r1.application_instance,
                       i_gen_search_by_col_flag      => 'N',
             i_lov_view_label              => r1.lov_view_label,--added NV-192
                       i_lov_view_name               => r1.lov_view_name,--added NV-192
                       i_lov_column_label            => r1.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                       i_generated_flag              => 'Y',
                       i_id_flex_application_id      => r1.id_flex_application_id,
                       i_id_flex_code                => r1.id_flex_code,
                       o_column_id                   => l_column_id,
                       i_source_column_id            => r1.column_id);
                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_source_PK_ID                     => l_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => g_segment_name,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id        );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c6

---Z$ columns
--KFF biz rule----
         IF (     NVL (r1.special_process_code, 'NOT APPLICABLE') NOT IN ( 'ROLLUP_ACCOUNT', 'LOV' )
              AND g_sv_column_flag                                     = FALSE
              AND col_prop_rec.exclude_z$_col                          = 0            )     THEN
--KFF biz rule----
            --Insert the Z$$ line column
            BEGIN
               l_error_location := 'view columns metadata - Z$ line ';
               l_col_description :=
                     'Columns following this are table rowids '
                  || 'with values having meaning only '
                  || 'internal to Oracle. Use them only to join '
                  || 'to the view specified by the column name. ';

               --verify Z$$ line column exists
               SELECT COUNT (1)
                 INTO l_column_exists
                 FROM n_view_columns nvc
                WHERE nvc.view_name = r1.view_name
                  AND nvc.query_position = r1.query_position
                  AND nvc.column_name LIKE 'Z$$%'
                  AND nvc.column_label = 'NONE'
                  AND nvc.column_type = 'CONST';

               IF ( l_column_exists = 0 ) THEN

                  n_gseg_utility_pkg.insert_view_column
                      (i_t_column_id               => r1.t_column_id,
                       i_view_name                 => r1.view_name,
                       i_view_label                => r1.view_label,
                       i_query_position            => r1.query_position,
                       i_column_name               => 'Z$$_________________________',
                       i_column_label              => 'NONE',
                       i_table_alias               => 'NONE',
                       i_column_expression         => 'Z$$_________________________',
                       i_column_position           => 1500,
                       i_column_type               => 'CONST',
                       i_description               => l_col_description,
                       i_group_by_flag             => 'N',
                       i_application_instance      => r1.application_instance,
                       i_generated_flag            => 'Y',
                       o_column_id                 => l_column_id                      );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || 'Z$$'
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;

            BEGIN
               l_error_location     := 'view columns metadata - Z$ columns ';
               l_column_position    := l_column_position + 0.1;
               l_column_name        := l_table_name;
               l_column_name        := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (27 - LENGTHB (l_column_name_prefix)) )
                                                  THEN SUBSTRB(l_column_name, 1, (27 - LENGTHB (l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
               l_column_name        := RTRIM( l_column_name, '_' );

               l_column_name        := 'Z$' || l_column_name_prefix || '$' || l_column_name;
               l_column_expr        := 'Z$' || l_table_name;
               l_col_description    := 'Join to Column -- use it only to join to the view ' || 
                                       l_table_name || 
                                       '. Be sure to join to the ' || 
                                       l_column_expr || 



                                       ' column.';

               n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);

               IF (   col_prop_rec.include_concat_seg_desc > 0
                   OR col_prop_rec.include_indiv_seg_desc > 0
                   OR col_prop_rec.include_qualifier_desc > 0
                  )
               THEN
                  l_error_location  := 'view columns metadata - Z$ columns - value view Z$ column ';
                  l_column_name     := r1_2.seg_view;
                  l_column_name     := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (27 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB(l_column_name, 1, (27 - LENGTHB(l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
                  l_column_name     := RTRIM( l_column_name, '_' );

                  l_column_name     := 'Z$' || l_column_name_prefix || '$' || l_column_name;
                  l_column_expr     := 'Z$' || r1_2.seg_view;
                  l_col_description := 'Join to Column -- use it only to join to the view '
                                    || r1_2.seg_view
                                    || '. Be sure to join to the '
                                    || l_column_expr
                                    || ' column.';

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => l_tab_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id,
                        i_source_column_id            => r1.column_id);
               END IF;
			   /*--added nv-192
--To suppress unnecessary metadata in the non-templates tables
update n_view_columns
   set lov_view_label = null, lov_view_name = null, lov_column_label = null
 where column_type != 'GEN'
   and lov_view_label like '%Lov%Flex%';

--added nv-192
--To suppress lov association for lov views
update n_view_columns
   set lov_view_label = null, lov_view_name = null, lov_column_label = null
 where view_label like '%Lov%Flex%';

--added nv-192
--To suppress unnecessary metadata in the non-templates tables
update n_view_columns
   set lov_column_label = null
 where column_type = 'GEN'
   and lov_view_label is null;*/
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || r2.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END IF;

---wheres
--determine if the where has the outerjoin on the primary key
         l_error_location :=
              'Check if the where clause has the outerjoin on the primary key';

         BEGIN
            /*SELECT MAX (CASE
                           WHEN INSTR (where_clause, '(+)') > 0
                              THEN '(+)'
                           ELSE NULL
                        END
                       )
              INTO l_outerjoin
              FROM n_view_wheres
             WHERE view_name = r1.view_name
               AND query_position = r1.query_position
               AND (   (UPPER (where_clause) LIKE
                              '%'
                           || UPPER (r1.table_alias)
                           || '.'
                           || UPPER (r2.kff_table_pk1)
                           || '%=%'
                       )
                    OR (UPPER (where_clause) LIKE
                              '%=%'
                           || UPPER (r1.table_alias)
                           || '.'
                           || UPPER (r2.kff_table_pk1)
                           || '%'
                       )
                   );*/
                   

             IF ( identify_join_operator( r1.view_name,
                                          r1.query_position,
                                          r1.table_alias,
                                          r2.kff_table_pk1 ) > 0 ) THEN
                 l_outerjoin := '(+)';
             ELSE 

                 l_outerjoin := NULL;
             END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     r1.view_name
                  || '~'
                  || r1.query_position
                  || '~'
                  || r1.table_alias
                  || '~'
                  || r2.kff_table_pk1
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

         FOR r5 IN c5( r2.data_table_key,
                       'WHERE',
                       col_prop_rec.exclude_primary_key_col )
         LOOP                                                            --{c5
            BEGIN
               l_error_location := 'view wheres metadata';

               SELECT MAX (where_clause_position)
                 INTO l_where_position
                 FROM n_view_wheres
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position;

               l_where_position := NVL (l_where_position, 100) + 0.1;
               l_where_clause :=
                     'AND '
                  || r1.table_alias
                  || '.'
                  || r5.kff_pk
                  || ' = '
                  || l_tab_alias
                  || '.'
                  || r5.kff_pk
                  || ' '
                  || l_outerjoin;

               IF NOT l_replace_table
               THEN
                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (r1.view_name, r1.view_label,
                               r1.query_position, l_where_position,
                               l_where_clause, r1.application_instance,
                               'Y'
                              );
               -- applies to PK1,PK2
               ELSE
                  NULL;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        r1.view_name
                     || '~'
                     || r1.query_position
                     || '~'
                     || l_where_position
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c5

         BEGIN
            l_error_location := 'view wheres metadata-for STAT';

            IF r1.special_process_code = 'STAT'
            THEN
               SELECT MAX (where_clause_position)
                 INTO l_where_position
                 FROM n_view_wheres
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position;

               --get the table alias of GL_STAT_ACCOUNT_UOM
               l_stat_tab_name      := 'GL_STAT_ACCOUNT_UOM';
               l_stat_acct_col_name := 'ACCOUNT_SEGMENT_VALUE';

               SELECT t.table_alias
                 INTO l_stat_tab_alias
                 FROM n_view_tables t
                WHERE t.view_name           = r1.view_name
                  AND t.query_position      = r1.query_position
                  AND t.metadata_table_name = l_stat_tab_name;

               l_where_position := NVL (l_where_position, 100) + 0.1;
               l_where_clause :=
                     'AND '
                  || l_stat_tab_alias
                  || '.'
                  || r2.structure_id_col
                  || ' (+)'
                  || ' = '
                  || l_tab_alias
                  || '.'
                  || 'structure_id';

               BEGIN
                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (r1.view_name, r1.view_label,
                               r1.query_position, l_where_position,
                               l_where_clause, r1.application_instance,
                               'Y'
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_where_position
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;

               FOR r4_2 IN c4_2 (r2.data_table_key,
                                 r1.view_name,
                                 r1.column_id,
                                 r1.query_position
                                )
               LOOP                                                    --{c4#2
                  IF     r4_2.segment_prompt = 'Natural Account Segment'
                     AND r4_2.qual_col_name LIKE n_gseg_utility_pkg.g_kff_dc_qual_val_pfx||'$%'
                  THEN
                     l_column_name := r4_2.qual_col_name;
                  END IF;
               END LOOP;                                               --}c4#2

               l_where_position := NVL (l_where_position, 100) + 0.1;
               l_where_clause :=
                     'AND '
                  || l_stat_tab_alias
                  || '.'
                  || l_stat_acct_col_name
                  || ' (+)'
                  || ' = '
                  || l_tab_alias
                  || '.'
                  || l_column_name;

               BEGIN
                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (r1.view_name, r1.view_label,
                               r1.query_position, l_where_position,
                               l_where_clause, r1.application_instance,
                               'Y'
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_where_position
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            ELSE
               NULL;
            END IF;
         END;
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'dc_main_view',
                                                      l_error_location,
                                                      'ERROR',
                                                      l_error_msg,
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
--} c1
   END dc_main_view;
--
---------------------------------------------------------------------
--
-- Procedure Name: segstruct_view
--
-- Description 
--   For all the SEGSTRUCT/SEGEXPR related views, populates the data cache views metadata into non-template tables.
--   The procedure populates the seg related metdata into non-template table like columns, tables etc.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE segstruct_view
   IS
      l_replace_table               BOOLEAN;
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_error_code                  NUMBER                            := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                     := 'SUCCESS';
      l_error_status                VARCHAR2 (30)                     := 'ERROR';
      l_in_process_status           VARCHAR2 (30)                     := 'IN-PROCESS';
      l_error_number                NUMBER                            := NULL;
      l_tab_alias_ctr               BINARY_INTEGER                    := 0;
      l_column_position             NUMBER                            := 0;
      l_where_position              NUMBER                            := 0;
      l_table_alias                 VARCHAR2 (20)                     := NULL;
      l_table_name                  VARCHAR2 (30)                     := NULL;
      l_column_name                 VARCHAR2 (30)                     := NULL;
      l_column_expr                 VARCHAR2 (1000)                   := NULL;
      l_where_clause                VARCHAR2 (500)                    := NULL;
      l_dff_col_ctr                 BINARY_INTEGER                    := 0;
      l_other_col_ctr               BINARY_INTEGER                    := 0;
      l_other_col_where_ctr         BINARY_INTEGER                    := 0;
      l_keyview_ctr                 BINARY_INTEGER                    := 0;
      l_outerjoin                   VARCHAR2 (10);
      l_column_exists               BINARY_INTEGER;
      l_column_name_prefix          n_view_column_templates.column_label%TYPE;
      l_from_position               n_view_table_templates.from_clause_position%TYPE
                                                                         := 0;
      l_kff_app_name                VARCHAR2 (30);
      l_tab_position                n_view_tables.from_clause_position%TYPE;
      l_view_label                  n_view_tables.view_label%TYPE;
      l_application_instance        n_view_tables.application_instance%TYPE;
      l_data_app_tab_alias          n_view_tables.table_alias%TYPE;
      l_md_struct_constraint_type   VARCHAR2 (20);
      l_col_description             n_view_columns.description%TYPE   := NULL;
      l_id_flex_num                 n_f_kff_segments.id_flex_num%TYPE; 
      l_column_property_type        VARCHAR2 (200);
      l_property_type_id            n_view_properties.property_type_id%TYPE;
      l_view_property_id            n_view_properties.view_property_id%TYPE; 
      l_t_view_property_id          n_view_properties.t_view_property_id%TYPE; 
      l_column_id                   n_view_columns.column_id%TYPE;
      l_t_column_id                 n_view_columns.t_column_id%TYPE;
	   l_from_data_tab_key          NUMBER;
i_data_table_key              NUMBER;
l_temp_col_exprs              n_view_columns.column_expression%type;
---Determine the views and queries
      CURSOR get_view_dtls IS
      SELECT DISTINCT 
             h4.view_name, 
             h4.query_position, 
             h4.data_table_key,
             h4.source_type, 
             h4.dc_view_name dc_view_name, 
             h4.id_flex_code,
             h4.data_application_table_name, 
             h4.pattern_key, 
             h4.group_type, 
             --NVL(h5.value_view_name,h2.target_value_object_name) value_view_name,
             h4.value_view_name,
             h4.qry_cnt, 
             'dco' table_alias,
             REPLACE( nv.security_code,
                      'NONE', NULL    )     security_code
        FROM n_f_kff_segstruct_helper_4 h4,
             n_views                    nv
       WHERE h4.view_name             = nv.view_name
	   and nv.application_instance='G0'
   		   AND exists (select 1 from n_to_do_views_incr where view_label=nv.view_label)
         AND (    h4.pattern_key IS NOT NULL 
               OR h4.qry_cnt          > 1  )
       ORDER BY 1, 2;

--KFF biz rule----
      CURSOR detect_multi_seg( p_data_table_key    VARCHAR2,
                               p_value_view_name   VARCHAR2,
                               p_desc_view_name    VARCHAR2 ) IS
      SELECT data_table_key,
             ( CASE
                 WHEN ( seg_cnt = 1 ) THEN 'N'
                 ELSE 'Y'
               END ) multi_seg_detected
        FROM ( SELECT seg.data_table_key, 
                      COUNT (*)         seg_cnt
                 FROM n_f_kff_segments              seg,
                      n_f_kff_structure_groups      str,
                      n_f_kff_struct_grp_flex_nums  nums
                WHERE seg.data_table_key                        = p_data_table_key
                  AND (    str.value_view_name                  = p_value_view_name
                        OR str.description_view_name            = p_desc_view_name )
                  AND str.structure_group_id                    = nums.structure_group_id(+)
                  AND str.data_table_key                        = seg.data_table_key
                  AND NVL( nums.id_flex_num, seg.id_flex_num )  = seg.id_flex_num
                GROUP BY seg.data_table_key);

      rec_multi_seg                 detect_multi_seg%ROWTYPE;

--KFF biz rule----
      CURSOR get_col_prty( p_view_name         VARCHAR2,
                           p_data_table_name   VARCHAR2,
                           p_query_position    NUMBER,
                           p_pattern           VARCHAR2    ) IS
       SELECT DISTINCT
             t_column_id,
             column_id,
             column_label,
             id_flex_code,
             id_flex_application_id,
             ( SELECT c.lov_view_label
                 FROM n_view_column_templates c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND ROWNUM = 1) Lov_view_label, --Added NV-192
                  ( SELECT c.lov_view_name
                 FROM n_view_columns c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND c.lov_view_name like '%G0%'
                  AND ROWNUM = 1) Lov_view_name,--Added NV-192
                  ( SELECT c.lov_column_label
                 FROM n_view_column_templates c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND ROWNUM = 1) Lov_column_label,--Added NV-192
             ( SELECT c.description
                 FROM n_view_column_templates c,
                      n_views v
                WHERE c.column_label = h.column_label
                  AND v.view_name = h.view_name
                  AND v.view_label = c.view_label
                  AND c.query_position = h.query_position
                  AND ROWNUM = 1) description
        FROM n_f_kff_segstruct_helper_1 h
       WHERE view_name                  = p_view_name
         AND NVL(data_table_name, 'XX') = NVL (p_data_table_name, 'XX')
         AND query_position             = p_query_position
         AND NVL(pattern, 'XX')         = NVL(p_pattern, 'XX')
         AND ROWNUM                     = 1;

      colp                          get_col_prty%ROWTYPE;

--retreive segment values SV$ columns
      CURSOR c6 (
         p_data_table_key           VARCHAR2,
         p_cust_prompt              VARCHAR2,
         p_include_indiv_seg_val    VARCHAR2,
         p_include_indiv_seg_desc   VARCHAR2,
         p_include_concat_seg_val   VARCHAR2,
         p_include_concat_seg_desc  VARCHAR2,
         p_multi_seg_detected       VARCHAR2,
         p_processing_type          VARCHAR2,
         p_constraint_type          VARCHAR2,
         p_value_view_name          VARCHAR2,
         p_column_name_prefix       VARCHAR2
      --p_desc_view_name          VARCHAR2
      )
      IS
       SELECT formatted_target_column_name, target_column_name,
              COUNT(1) over(partition by formatted_target_column_name) dup_col_cnt,
              ROW_NUMBER() over(partition by formatted_target_column_name order by formatted_target_column_name, target_column_name) sub_script
         FROM   

         (SELECT n_gseg_utility_pkg.FORMAT_KFF_SEGMENT(p_column_name_prefix||'$'||target_column_name,30) formatted_target_column_name,
            target_column_name
          FROM 

         (
         WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL <= 1)
         SELECT DISTINCT target_column_name
                    FROM DATA,
                         n_f_kff_segments seg,
                         n_f_kff_structure_groups str,
                         n_f_kff_struct_grp_flex_nums nums
                   WHERE seg.data_table_key = p_data_table_key
                     AND (str.value_view_name = p_value_view_name
                                                                 --OR str.description_view_name = p_desc_view_name
                         )
                     AND str.structure_group_id = nums.structure_group_id(+)
                     AND str.data_table_key = seg.data_table_key
                     AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num
                     AND ( (CASE
                             WHEN (    lvl = 1
                                   AND (   p_include_indiv_seg_val = 0
                                        OR (    p_cust_prompt = 'N'
                                            AND p_processing_type = 'SOURCED'
                                            AND p_constraint_type IN
                                                         ('NONE', 'MULTIPLE')
                                           )
                                       )
                                  )
                                THEN 1
                          /*  WHEN (    lvl = 2
                                  AND (   p_include_indiv_seg_desc = 0
                                       OR (    p_cust_prompt = 'N'
                                           AND p_processing_type = 'SOURCED'
                                           AND p_constraint_type IN
                                                           ('NONE', 'MULTIPLE')
                                          )
                                      )
                                 )
                               THEN 2 */
                          END
                         ) IS NULL
                          OR (CASE
                                 WHEN (    lvl = 1
                                       AND p_include_indiv_seg_val = 0
                                       AND p_include_concat_seg_val > 0
                                       AND p_multi_seg_detected = 'N'
                                       AND p_processing_type = 'SOURCED'
                                       AND p_constraint_type = 'SINGLE'
                                      )
                                    THEN 1
                              END
                             ) = 1
                            )
                      ));
   BEGIN
      l_error_location := 'start processing';
	  -- Issue:NV-560 --
    BEGIN
    SELECT data_table_key
    INTO l_from_data_tab_key
    FROM n_f_kff_flex_sources
    where Data_application_table_name = 'FV_BE_RPR_TRANSACTIONS'
    AND pattern_key LIKE '%FROM%';
    EXCEPTION
    WHEN no_data_found THEN
    l_from_data_tab_key := 0;
    END;


      OPEN c3 (n_gseg_utility_pkg.g_kff_app_label);

      FETCH c3
       INTO r3;

      CLOSE c3;

--Primary cursor to get the view columns where the data cache metadata needs to be brought int
      FOR rec_c IN get_view_dtls
      LOOP                                                             --{ c1



         l_table_name := NULL;
         g_sv_column_flag := FALSE;
         l_error_location := 'select table metadata ';

         BEGIN
            SELECT t.from_clause_position, 
                   t.view_label, 
                   t.application_instance,
                   table_alias
              INTO l_tab_position, 
                   l_view_label, 
                   l_application_instance,
                   l_data_app_tab_alias
              FROM n_view_tables t
             WHERE t.view_name                 = rec_c.view_name
               AND t.query_position            = rec_c.query_position
               AND t.metadata_table_name       = rec_c.data_application_table_name;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_c.view_name
                  || '~'
                  || rec_c.query_position
                  || '~'
                  || rec_c.dc_view_name
                  || '~'
                  || rec_c.data_table_key
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

-- additional logic for the table replacement logic
         l_error_location := 'table replacement validation';

--check dff columns
         SELECT COUNT (*)
           INTO l_dff_col_ctr
           FROM n_view_columns c
          WHERE c.view_name       = rec_c.view_name
            AND c.query_position  = rec_c.query_position
            AND c.table_alias     = l_data_app_tab_alias
            AND c.column_type     = 'ATTR';

--check columns other than primary key colums in n_view_columns
         SELECT COUNT (*)
           INTO l_other_col_ctr
           FROM n_view_columns              c,
                n_kff_flex_source_templates pt,
                n_f_kff_flex_sources        fs
          WHERE c.view_name                          = rec_c.view_name
            AND c.query_position                     = rec_c.query_position
            AND c.table_alias                        = l_data_app_tab_alias
            AND 

              (    UPPER (column_expression) NOT LIKE '%' || pt.kff_table_pk1 || '%'
                OR UPPER (column_expression) NOT LIKE '%' || pt.kff_table_pk2 || '%'
                OR UPPER (column_expression) NOT LIKE '%' || pt.kff_table_pk3 || '%'   )
            AND fs.data_table_key                    = rec_c.data_table_key
            AND pt.id_flex_application_id            = fs.id_flex_application_id
            AND pt.id_flex_code                      = fs.id_flex_code
            AND pt.data_application_id               = fs.data_application_id
            AND pt.data_application_table_name       = fs.data_application_table_name;

--check columns other than primary key colums in n_view_wheres
         SELECT COUNT (*)
           INTO l_other_col_where_ctr
           FROM n_kff_flex_source_templates pt,
                n_f_kff_flex_sources fs,
                n_view_wheres w
          WHERE fs.data_table_key               = rec_c.data_table_key
            AND pt.id_flex_application_id       = fs.id_flex_application_id
            AND pt.id_flex_code                 = fs.id_flex_code
            AND pt.data_application_id          = fs.data_application_id
            AND pt.data_application_table_name  = fs.data_application_table_name
            AND w.view_name                     = rec_c.view_name
            AND UPPER (w.where_clause)       LIKE '%' || UPPER(l_data_app_tab_alias) || '.%'
            AND w.query_position                = rec_c.query_position
            AND 

              (    UPPER(w.where_clause) NOT LIKE '%.' || pt.kff_table_pk1 || '%'
                OR UPPER(w.where_clause) NOT LIKE '%.' || pt.kff_table_pk2 || '%'
                OR UPPER(w.where_clause) NOT LIKE '%.' || pt.kff_table_pk3 || '%'  );

         l_keyview_ctr := 0;
         SELECT COUNT (*)
           INTO l_keyview_ctr
           FROM n_view_columns     c,
                n_join_key_columns jc,
                n_join_keys        j
          WHERE c.view_name          = rec_c.view_name
            AND c.query_position     = rec_c.query_position
            AND c.table_alias        = l_data_app_tab_alias
            AND j.view_name          = c.view_name
            AND j.column_type_code   = 'ROWID'
            AND jc.join_key_id       = j.join_key_id
            AND jc.column_name       = c.column_name;

         IF (     r2.table_replacement_allowed_flag = 'Y'
              AND NVL(rec_c.security_code,'NONE')   = 'NONE'
              AND l_dff_col_ctr                     = 0
              AND l_other_col_ctr                   = 0
              AND l_other_col_where_ctr             = 0
              AND l_keyview_ctr                     = 0      )   THEN
            l_replace_table := TRUE;
         ELSE
            l_replace_table := FALSE;
         END IF;

---table processing
         BEGIN
            IF NOT l_replace_table
            THEN
               l_error_location := 'insert table metadata';

               SELECT COUNT (*)
                 INTO l_tab_alias_ctr
                 FROM n_view_tables
                WHERE view_name = rec_c.view_name
                  AND query_position = rec_c.query_position
                  AND RTRIM (TRANSLATE (UPPER (table_alias),
                                        '1234567890',
                                        '      '
                                       )
                            ) = UPPER (rec_c.id_flex_code);

--          l_table_alias := rec_c.table_alias || l_tab_alias_ctr;
               l_table_alias := UPPER (rec_c.id_flex_code);
               l_tab_alias_ctr := l_tab_alias_ctr + 1;
               l_table_alias := l_table_alias || l_tab_alias_ctr;

               INSERT INTO n_view_tables
                         ( view_name, 

                           view_label,
                           query_position, 
                           table_alias,
                           from_clause_position, 
                           application_label,
                           owner_name, 
                           table_name, 


                           metadata_table_name,
                           application_instance,
                           base_table_flag, 
                           generated_flag, 
                           subquery_flag,
                           gen_search_by_col_flag        )
                    VALUES 

                         ( rec_c.view_name, 
                           l_view_label,
                           rec_c.query_position, 
                           l_table_alias,
                           l_tab_position + 0.1, 
                           r3.application_label,
                           gc_user, 

                           rec_c.dc_view_name, 
                           rec_c.dc_view_name, 
                           l_application_instance,
                           'N', 
                           'Y', 


                           'N',
                           'Y'                );
            ELSE
               l_error_location := 'update table metadata ';
               l_table_alias := l_data_app_tab_alias;

               UPDATE n_view_tables t
                  SET t.table_name          = rec_c.dc_view_name,
                      t.metadata_table_name = rec_c.dc_view_name,
                      t.owner_name          = gc_user,
                      t.generated_flag      = 'Y',
                      t.application_label   = n_gseg_utility_pkg.g_kff_app_label
                WHERE t.view_name           = rec_c.view_name
                  AND t.query_position      = rec_c.query_position
                  AND t.table_alias         = l_data_app_tab_alias;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_c.view_name
                  || '~'
                  || rec_c.query_position
                  || '~'
                  || rec_c.dc_view_name
                  || '~'
                  || rec_c.data_table_key
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

--Processing Columns
         l_error_location := 'view columns metadata ';

         --get column related info
         OPEN get_col_prty (rec_c.view_name,
                            (CASE
                                WHEN rec_c.source_type = 'DC'
                                   THEN NULL
                                ELSE rec_c.data_application_table_name
                             END
                            ),
                            rec_c.query_position,
                            rec_c.pattern_key
                           );

         FETCH get_col_prty
          INTO colp;

         CLOSE get_col_prty;

         --get kff short name
         OPEN c3_1 (colp.id_flex_code, colp.id_flex_application_id);

         FETCH c3_1
          INTO r3_1;

         CLOSE c3_1;

--KFF biz rule----
--Derive the multi seg struct property
         OPEN detect_multi_seg (rec_c.data_table_key,
                                rec_c.value_view_name,
                                NULL
                               );

         FETCH detect_multi_seg
          INTO rec_multi_seg;

         CLOSE detect_multi_seg;

--Manifestation of column properties metadata
         OPEN col_prop_cur (rec_c.view_name,
                            colp.column_label,
                            rec_c.query_position
                           );

         FETCH col_prop_cur
          INTO col_prop_rec;

         CLOSE col_prop_cur;

         IF col_prop_rec.include_structure_count = 0
         THEN
            l_md_struct_constraint_type := 'NONE';
         ELSIF col_prop_rec.include_structure_count = 1
         THEN
            l_md_struct_constraint_type := 'SINGLE';
         ELSE
            l_md_struct_constraint_type := 'MULTIPLE';
         END IF;

--KFF biz rule----

         --The cursor c2 is only for getting the additional information about the data table key
         OPEN c2 (NULL, NULL, NULL, 'ALL', rec_c.data_table_key);

         FETCH c2
          INTO r2;

         CLOSE c2;

         --derive column prefix
         l_column_name_prefix   :=( CASE
                                      WHEN (     LENGTHB(colp.column_label)     > 8
                                             AND INSTRB(colp.column_label, '_') > 0 )
                                           THEN ( CASE 

                                                    WHEN ( INSTRB(SUBSTRB(colp.column_label,1,8), '_') > 0 )
                                                         THEN SUBSTRB(colp.column_label, 1, 8)
                                                    ELSE SUBSTRB(colp.column_label, 1, 7) || 
                                                         SUBSTRB(colp.column_label, INSTRB(colp.column_label, '_') + 1,1)
                                                  END )
                                      WHEN (     LENGTHB(colp.column_label)     > 8
                                             AND INSTRB(colp.column_label, '_') = 0 )
                                           THEN SUBSTRB(colp.column_label, 1, 8)
                                      ELSE colp.column_label
                                    END );

          l_column_name_prefix  := RTRIM( l_column_name_prefix,'_' );

         BEGIN
            SELECT MAX (column_position)
              INTO l_column_position
              FROM n_view_columns
             WHERE view_name = rec_c.view_name
               AND query_position = rec_c.query_position;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               NULL;
         END;

---Structure columns
--KFF biz rule----
         FOR r4_1 IN c4_1( r3_1.kff_processing_type,
                           l_md_struct_constraint_type,
                           col_prop_rec.exclude_structure_name_col              )
--KFF biz rule----
         LOOP
            BEGIN
               l_error_location     := 'view columns metadata - structure columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := n_gseg_utility_pkg.g_kff_coldesc_structname_sfx;
               l_col_description    := colp.description || ' ' || 
                                           REPLACE (l_col_description, '<flexfield>', r2.kff_name);
               l_column_name        := r4_1.struct_column;
               l_column_name        :=( CASE
                                          WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB( l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                          ELSE l_column_name
                                        END  );
               l_column_name        := RTRIM (l_column_name, '_');

              l_column_name        := l_column_name_prefix || '$' || l_column_name;
         l_temp_col_exprs := r4_1.struct_column;
--Issue NV-560
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
      l_temp_col_exprs := r4_1.struct_column||'_FROM';
  ELSE
    NULL;
  END CASE;         
            n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => l_temp_col_exprs,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id,
                      i_source_column_id            => col_prop_rec.column_id);
               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => 'STRUCTURE_NAME',
                             i_value1                           => NULL,
                             i_value2                           => NULL,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id        );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;

---Qualifier columns
         FOR r4_2 IN c4_2 (rec_c.data_table_key,
                           rec_c.view_name,
                           col_prop_rec.column_id,
                           rec_c.query_position
                          )
         LOOP
            BEGIN
               l_error_location     := 'view columns metadata - qualifier columns ';
               l_column_position    := l_column_position + 0.1;
               l_col_description    := ( CASE
                                           WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_qv_sfx
                                           ELSE n_gseg_utility_pkg.g_kff_coldesc_qd_sfx
                                         END );
               l_col_description    := colp.description
                                    || ' '
                                    || REPLACE (REPLACE (l_col_description,
                                                         '<segment>',
                                                         REPLACE (r4_2.segment_prompt,
                                                                  ' Segment'
                                                                 )
                                                        ),
                                                '<flexfield>',
                                                r2.kff_name );
               l_column_expr        := r4_2.qual_col_name;
               l_column_name        := r4_2.qual_col_name;
               l_column_name        := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB(l_column_name, 1,(29 - LENGTHB (l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
               l_column_name        := RTRIM (l_column_name, '_');
               l_column_property_type   := ( CASE
                                               WHEN ( SUBSTRB(r4_2.qual_col_name, 1, 2 ) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                     THEN 'QUALIFIER_VALUE'
                                               ELSE 'QUALIFIER_DESCRIPTION'
                                             END );

               l_column_name := l_column_name_prefix || '$' || l_column_name;


  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
    l_column_expr := l_column_expr||'_FROM';
  ELSE
    NULL;
  END CASE;         

              n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => l_column_expr,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_segment_qualifier           => r4_2.segment_attribute_type,
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id  ,
                      i_source_column_id            => col_prop_rec.column_id);
					  

               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => l_column_property_type,
                             i_value1                           => NULL,
                             i_value2                           => r4_2.segment_attribute_type,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id                            );
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;

---Concatenated columns
--KFF biz rule----
         FOR r4 IN
            c4
               (rec_c.data_table_key,
                'SEGSTRUCT',
-- This is a dummy value passed to get through the last condition of the cursor
                r3_1.kff_processing_type,
                l_md_struct_constraint_type,
                rec_multi_seg.multi_seg_detected,
                col_prop_rec.exclude_segment_name_list_col,
                col_prop_rec.include_concat_seg_val,
                col_prop_rec.include_concat_seg_pval,
                col_prop_rec.include_concat_seg_desc,
                col_prop_rec.include_concat_seg_pdesc
               )
--KFF biz rule----
         LOOP
            BEGIN
               l_error_location :=
                              'view columns metadata - concatenated columns ';
               l_column_position := l_column_position + 0.1;

               --sharas 02/19
               -- we donot want the Z$ for this lot
               IF (    (     r3_1.kff_processing_type           = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected   = 'Y' )
                    OR (     r3_1.kff_processing_type           = 'SOURCED'
                         AND l_md_struct_constraint_type        = 'SINGLE'
                         AND rec_multi_seg.multi_seg_detected   = 'Y' ) ) THEN
                   g_sv_column_flag := TRUE; 
               END IF;
               --sharas 02/19

               --Column descriptions logic
               IF     r4.concatenation_type = 'VAL'
                  AND (   (    r3_1.kff_processing_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                       OR (    r3_1.kff_processing_type = 'SOURCED'
                           AND l_md_struct_constraint_type = 'SINGLE'
                           AND rec_multi_seg.multi_seg_detected = 'Y'
                          )
                      )
               THEN
                  BEGIN
                     SELECT seg.id_flex_num
                       INTO l_id_flex_num
                       FROM n_f_kff_structures seg,
                            n_f_kff_structure_groups str,
                            n_f_kff_struct_grp_flex_nums nums
                      WHERE seg.data_table_key = rec_c.data_table_key
                        AND str.value_view_name = rec_c.value_view_name
                        AND str.structure_group_id = nums.structure_group_id(+)
                        AND str.data_table_key = seg.data_table_key
                        AND NVL (nums.id_flex_num, seg.id_flex_num) =
                                                               seg.id_flex_num;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;

                  BEGIN
                     SELECT    'List of segment names for '
                            || str.structure_name
                            || ' structure is "'
                            || ccat.source_expression
                            || '".'
                       INTO l_col_description
                       FROM n_f_kff_concatenations ccat,
                            n_f_kff_structures str
                      WHERE ccat.data_table_key = rec_c.data_table_key
                        AND str.data_table_key = ccat.data_table_key
                        AND str.id_flex_num = l_id_flex_num
                        AND ccat.id_flex_num = str.id_flex_num
                        AND ccat.concatenation_type = 'LIST';
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;
               ELSE
                  l_col_description :=
                     (CASE
                         WHEN r4.concatenation_type = 'LIST'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_segnl_sfx
                         WHEN r4.concatenation_type = 'VAL'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cv_sfx
                         WHEN r4.concatenation_type = 'DESC'
                            THEN n_gseg_utility_pkg.g_kff_coldesc_cd_sfx
                      END
                     );
                  l_col_description :=
                        colp.description
                     || ' '
                     || REPLACE (l_col_description, '<flexfield>',
                                 r2.kff_name);
               END IF;

               l_column_name := r4.target_column_name;
               l_column_property_type :=
                  (CASE
                      WHEN r4.concatenation_type = 'VAL'
                         THEN 'CONCATENATED_VALUES'
                      WHEN r4.concatenation_type = 'DESC'
                         THEN 'CONCATENATED_DESCRIPTIONS'
                      WHEN r4.concatenation_type = 'LIST'
                         THEN 'SEGMENT_NAME_LIST'
                   END
                  );

               l_column_name := l_column_name_prefix || '$' || l_column_name;
-- Issue:NV-560
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
    r4.target_column_name := r4.target_column_name||'_FROM';
  ELSE
    NULL;
  END CASE;

          n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => r4.target_column_name,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id,
                      i_source_column_id            => col_prop_rec.column_id);

               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => l_column_property_type,
                             i_value1                           => NULL,
                             i_value2                           => NULL,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id                      );
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                                       --}c4

---Individual segment columns
--KFF biz rule----
         FOR r6 IN c6 (rec_c.data_table_key,
                       r2.kff_cols_in_global_view_flag,
                       col_prop_rec.include_indiv_seg_val,
                       col_prop_rec.include_indiv_seg_desc,
                       col_prop_rec.include_concat_seg_val,
                       col_prop_rec.include_concat_seg_desc,
                       rec_multi_seg.multi_seg_detected,
                       r3_1.kff_processing_type,
                       l_md_struct_constraint_type,
                       rec_c.value_view_name,
                       l_column_name_prefix
                      )
--KFF biz rule----
         LOOP                                                            --{c6
            BEGIN
               l_error_location := 'view columns metadata - individual columns ';
               IF (     r2.kff_cols_in_global_view_flag = 'Y'
                    AND r3_1.kff_processing_type        = 'SOURCED' )  THEN
                  g_sv_column_flag := FALSE;
               ELSE
                  g_sv_column_flag := TRUE;
               END IF;
               g_segment_name    := NULL;
               l_column_position := l_column_position + 0.1;
               l_col_description := n_gseg_utility_pkg.g_kff_coldesc_sv_sfx;

                  --Derive the segment name to add it into column description
                  BEGIN 



                  select seg.segment_name 
                    INTO g_segment_name 
                    from ( SELECT s.segment_name
                             FROM n_f_kff_segments s
                            WHERE s.data_table_key     = rec_c.data_table_key
                              AND s.target_column_name = r6.target_column_name
                            order by s.segment_name ) seg
                   where rownum = 1; 



                  EXCEPTION
                     WHEN OTHERS THEN
                        g_segment_name := NULL;
                  END;
                  

               l_col_description :=
                     colp.description
                  || ' '
                  || REPLACE (REPLACE (l_col_description,
                                       '<segment>',
                                       g_segment_name
                                      ),
                              '<flexfield>',
                              r2.kff_name
                             );
                  l_column_exists := 0;
                  l_column_name := r6.formatted_target_column_name;

            IF ( r6.dup_col_cnt > 1 ) THEN
                IF ( r6.sub_script > 1 ) THEN
                    l_column_name := n_gseg_utility_pkg.format_kff_segment(l_column_name||r6.sub_script,30);
                END IF;

               SELECT COUNT (*)
                 INTO l_column_exists
                 FROM n_view_columns
                WHERE view_name      = rec_c.view_name
                  AND column_name    = l_column_name
                  AND query_position = rec_c.query_position;

            END IF;
            l_column_property_type := ( CASE
                                          WHEN ( SUBSTRB(r6.target_column_name, 1, 2) =  n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                               THEN 'SEGMENT_VALUE'
                                          ELSE 'SEGMENT_DESCRIPTION'
                                       END );

            IF ( l_column_exists = 0 ) THEN
-- Issue:NV-560 
  CASE WHEN i_data_table_key = l_from_data_tab_key THEN
    r6.target_column_name := r6.target_column_name||'_FROM';
  ELSE
    NULL;
  END CASE;
              n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => r6.target_column_name,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_lov_view_label              => colp.lov_view_label,--added NV-192
                      i_lov_view_name               => colp.lov_view_name,--added NV-192
                      i_lov_column_label            => colp.lov_column_label || rtrim(substr(l_column_name,(instr(l_column_name,'$',1,1)))),--added NV-192
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id,
                      i_source_column_id            => col_prop_rec.column_id);
               n_gseg_utility_pkg.insert_view_col_prop
                            (i_view_name                        => rec_c.view_name,
                             i_view_label                       => l_view_label,
                             i_query_position                   => rec_c.query_position,
                             i_t_source_pk_id                   => colp.t_column_id,
                             i_source_PK_ID                     => l_column_id,
                             i_property_type                    => l_column_property_type,
                             i_value1                           => g_segment_name,
                             i_value2                           => NULL,
                             i_value3                           => NULL,
                             i_value4                           => NULL,
                             i_value5                           => NULL,
                             i_profile_option                   => NULL,
                             i_omit_flag                        => NULL,
                             o_view_property_id                 => l_view_property_id                           );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;

---Z$ columns
--KFF biz rule----
         IF (     g_sv_column_flag            = FALSE
              AND col_prop_rec.exclude_z$_col = 0     ) THEN
--KFF biz rule----
            --Insert the Z$$ line column
            BEGIN
               l_error_location := 'view columns metadata - Z$ line ';
               l_col_description :=
                     'Columns following this are table rowids '
                  || 'with values having meaning only '
                  || 'internal to Oracle. Use them only to join '
                  || 'to the view specified by the column name.';

               --verify Z$$ line column exists
               SELECT COUNT (1)
                 INTO l_column_exists
                 FROM n_view_columns nvc
                WHERE nvc.view_name         = rec_c.view_name
                  AND nvc.query_position    = rec_c.query_position
                  AND nvc.column_name    LIKE 'Z$$%'
                  AND nvc.column_label      = 'NONE'
                  AND nvc.column_type       = 'CONST';

               IF ( l_column_exists = 0 )  THEN

                  n_gseg_utility_pkg.insert_view_column
                     (i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => 'Z$$_________________________',
                      i_column_label                => 'NONE',
                      i_table_alias                 => 'NONE',
                      i_column_expression           => 'Z$$_________________________',
                      i_column_position             => 1500,
                      i_column_type                 => 'CONST',
                      i_description                 => l_col_description,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id                 );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || 'Z$$'
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;

            --Insert the actual Z$ column which would show the table rowid values
            BEGIN
               l_error_location := 'view columns metadata - Z$ columns ';
               l_column_position := l_column_position + 0.1;
               l_column_name := rec_c.dc_view_name;
               l_column_name := RTRIM (l_column_name, '_');

               l_column_name :=
                          'Z$' || l_column_name_prefix || '$' || l_column_name;
               

               l_column_expr := 'Z$' || rec_c.dc_view_name;
               l_col_description :=
                     'Join to Column -- use it only to join to the view '
                  || rec_c.dc_view_name
                  || '. Be sure to join to the '
                  || l_column_expr
                  || ' column.';

               n_gseg_utility_pkg.insert_view_column
                     (i_t_column_id                 => colp.t_column_id,
                      i_view_name                   => rec_c.view_name,
                      i_view_label                  => l_view_label,
                      i_query_position              => rec_c.query_position,
                      i_column_name                 => l_column_name,
                      i_column_label                => colp.column_label,
                      i_table_alias                 => l_table_alias,
                      i_column_expression           => l_column_expr,
                      i_column_position             => l_column_position,
                      i_column_type                 => 'GEN',
                      i_description                 => l_col_description,
                      i_ref_lookup_column_name      => NULL,
                      i_group_by_flag               => 'N',
                      i_application_instance        => l_application_instance,
                      i_gen_search_by_col_flag      => 'N',
                      i_generated_flag              => 'Y',
                      i_id_flex_application_id      => colp.id_flex_application_id,
                      i_id_flex_code                => colp.id_flex_code,
                      o_column_id                   => l_column_id  ,
                      i_source_column_id            => col_prop_rec.column_id);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_c.view_name
                     || '~'
                     || rec_c.query_position
                     || '~'
                     || l_column_name
                     || '~'
                     || rec_c.data_table_key
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END IF;

---wheres
--determine if the where has the outerjoin on the primary key
         l_error_location :=
                 'Determine if the where has the outerjoin on the primary key';

         BEGIN
            SELECT ( CASE
                       WHEN ( INSTR(where_clause, '(+)') > 0 ) THEN '(+)'
                       ELSE NULL
                     END )
              INTO l_outerjoin
              FROM n_view_wheres
             WHERE view_name               = rec_c.view_name
               AND query_position          = rec_c.query_position
               AND UPPER (where_clause) LIKE
                         '%'
                      || UPPER(l_data_app_tab_alias)
                      || '.'
                      || ( CASE
                             WHEN ( rec_c.source_type = 'DC' ) THEN UPPER (r2.kff_table_pk1)
                             ELSE NULL
                           END )
                      || '%'
               AND ROWNUM                  = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                          l_error_location || '-' || SQLERRM (l_error_number);
               RAISE;
         END;

         --if table replacement not allowed then add the where condition for the pk join
         IF NOT l_replace_table
         THEN
            --using the global cursor c5
            FOR rec_pk IN c5 (rec_c.data_table_key, 'WHERE', 0)
            LOOP
               BEGIN
                  l_error_location := 'view wheres metadata';

                  SELECT MAX (where_clause_position)
                    INTO l_where_position
                    FROM n_view_wheres
                   WHERE view_name = rec_c.view_name
                     AND query_position = rec_c.query_position;

                  l_where_position := NVL (l_where_position, 100) + 0.1;

                  IF rec_c.source_type = 'DC'
                  THEN
                     l_where_clause :=
                           'AND '
                        || l_data_app_tab_alias
                        || '.'
                        || rec_pk.kff_pk
                        || ' = '
                        || l_table_alias
                        || '.'
                        || rec_pk.kff_pk
                        || ' '
                        || l_outerjoin;
                  ELSE
                     l_where_clause :=
                           'AND '
                        || l_data_app_tab_alias
                        || '.'
                        || rec_pk.kff_pk
                        || ' = '
                        || l_table_alias
                        || '.'
                        || 'Z$'
                        || rec_c.dc_view_name
                        || ' '
                        || l_outerjoin;
                  END IF;

                  INSERT INTO n_view_wheres
                              (view_name, view_label,
                               query_position, where_clause_position,
                               where_clause, application_instance,
                               generated_flag
                              )
                       VALUES (rec_c.view_name, l_view_label,
                               rec_c.query_position, l_where_position,
                               l_where_clause, l_application_instance,
                               'Y'
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_c.view_name
                        || '~'
                        || rec_c.query_position
                        || '~'
                        || l_where_position
                        || '~'
                        || l_where_clause
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;
         END IF;
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'segstruct_view',
                                                      l_error_location,
                                                      l_status,
                                                      l_error_msg,
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
   END segstruct_view;

---------------------------------------------------------------------
--
-- Procedure Name: anomaly_view
--
-- Description 
--   For all the views having anomalies for same column with different column types in different queries
--   Populates the data cache views metadata into non-template tables.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
    PROCEDURE anomaly_view IS
      l_error_msg                    VARCHAR2 (2000)                  := NULL;
      l_status                       VARCHAR2 (30)                    := NULL;
      l_error_location               VARCHAR2 (200)                   := NULL;
      l_success_status               VARCHAR2 (30)               := 'SUCCESS';
      l_error_status                 VARCHAR2 (1000)               := 'ERROR';
      l_error_number                 NUMBER                           := NULL;
      l_column_exists                NUMBER;
      l_script_name                  VARCHAR2 (100)
                                          := 'n_gseg_integration_incr_pkg';
      l_col_expression               n_view_columns.column_expression%TYPE
                                                                      := NULL;
      l_column_name_prefix           n_view_columns.column_label%TYPE := NULL;
      --The original columns will be retained only for INV_Reservations view,
      --as the view shows some information in the original columns so we are not suppressing those columns
      l_retain_orig_columns_4_view1  n_views.view_label%TYPE          := 'INV_Reservations';
      l_retain_orig_columns_4_view2  n_views.view_label%TYPE          := 'INV_Item_Demand_Seg_Base';

      l_column_property_type         VARCHAR2 (200);
      l_property_type_id             n_view_properties.property_type_id%TYPE;
      l_t_view_property_id           n_view_properties.t_view_property_id%TYPE; 
      l_view_property_id             n_view_properties.view_property_id%TYPE; 
      l_t_column_id                  n_view_columns.t_column_id%TYPE;
      l_column_id                    n_view_columns.column_id%TYPE;
      ls_table_alias                 VARCHAR2(100); 
      ls_segment_name                VARCHAR2(100);
      li_bom_view_exists             BINARY_INTEGER := 0;

--Cursor Declarations---

      --Cursor to retrieve only the anomaly view columns having the column_type as SEG% or KEY%
      CURSOR cur_get_view_dtls IS
      SELECT view_name, 
             view_label, 
             column_id,
             t_column_id,
             column_name, 
             column_label,
             column_type, 
             query_position, 
             id_flex_code,
             id_flex_application_id, 
             profile_option,
             application_instance, 
             column_position, 
             group_by_flag
        FROM ( SELECT c.view_name, 
                      c.view_label, 
                      c.column_id,
                      c.t_column_id,
                      c.column_name,
                      c.column_label, 
                      q.query_position, 
                      c.id_flex_code,
                      c.id_flex_application_id,
                      COUNT (*) OVER (PARTITION BY c.view_name, 
                                                   c.column_label)      qry_cnt,
                      COUNT (*) OVER (PARTITION BY c.view_name, 
                                                   c.column_label, 

                                                   c.column_type)       col_type_cnt,
                      COUNT (*) OVER (PARTITION BY c.view_name, 
                                                   c.column_label, 
                                                   c.column_type, 


                                                   c.id_flex_code)      col_kff_cnt,
                      column_type, 
                      c.profile_option,
                      c.application_instance, 
                      c.column_position,
                      c.group_by_flag
                 FROM n_view_columns    c, 
                      n_views           v, 

                      n_view_queries    q
                WHERE (    v.view_label IN
                              ( 'AR_SLA_Transaction_Dist',
                                'ASO_Quote_Sales_Credits',
                                'BOM_Routing_Comparisons',
                                'CSF_Debrief_Expense_Lines',
                                'CSF_Debrief_Labor_Lines',
                                'CSF_Debrief_Material_Lines',
                                'EAM_Asset_Downtime', 
                                'EAM_WO_Actual_Cost_Details',
                                'EAM_WO_Cost_Details',
                                'EAM_WO_Matrl_Requirements',
                                'FA_Adjustments_SLA_GL_Je',
                                'OKS_Sales_Credits', 
                                'PA_SLA_Revenue_Dist',
                                'XLA_PA_Revenue_Dist',
				'WIP_Routings_Hydra_QCP_Vsat',
                                'WIP_Routings'                  )
                        OR (     v.view_label   = 'INV_Reservations' 
                             AND c.column_label = 'Demand_Source' ) 
                        OR (     v.view_label   = 'INV_Item_Demand_Seg_Base'   
                             AND c.column_label = 'Source_Name' )         )
                  AND v.application_instance    = 'G0'
                  AND NVL(v.omit_flag, 'N')     = 'N'
                  AND q.view_name               = v.view_name
                  AND NVL(q.omit_flag, 'N')     = 'N'
                  AND c.view_name               = v.view_name
				  and c.application_instance='G0'
    		   AND exists (select 1 from n_to_do_views_incr where view_label=v.view_label)
                  AND c.query_position          = q.query_position
                  AND NVL(c.omit_flag, 'N')     = 'N'
                  AND EXISTS 

                    ( SELECT 'X'
                        FROM n_view_columns subc
                       WHERE c.column_label             = subc.column_label
                         AND NVL(subc.omit_flag, 'N')   = 'N'
                         AND (    subc.column_type   LIKE 'SEG%'
                               OR subc.column_type   LIKE 'KEY%' )
                         AND (    subc.column_type     <> 'SEGSTRUCT'
                               OR subc.column_type     <> 'SEGEXPR' )
                         AND c.view_name                = subc.view_name   ) ) mainq
       WHERE mainq.qry_cnt <> mainq.col_type_cnt
         AND id_flex_code  IS NOT NULL
       ORDER BY view_name, 
                column_label, 
                query_position;

--Cursor to retreive all the columns for a view and column label across queries
      CURSOR cur_get_all_dtls( p_view_name    VARCHAR2, 
                               p_column_label VARCHAR2 ) IS
      SELECT view_name,
             view_label, 
             column_name, 
             column_label,
             t_column_id,
             column_id,
             column_type, 
             query_position,
             id_flex_code,
             id_flex_application_id, 
             profile_option,
             application_instance, 
             column_position, 
             group_by_flag,
             source_column_id
        FROM n_view_columns c
       WHERE c.view_name           = p_view_name
         AND c.column_label        = p_column_label
		 and c.application_instance='G0'
	  AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
         AND c.column_type  NOT LIKE 'ATTR'
       ORDER BY c.view_name, 
                c.column_label, 
                c.query_position;

--Retreive the global seg columns added by intergration scripts
      CURSOR cur_gseg_qry_cols( p_view_name        VARCHAR2,
                                p_column_prefix    VARCHAR2,
                                p_query_position   NUMBER    ) IS
      SELECT c.t_column_id, c.column_id,    c.source_column_id,
             c.column_name, c.column_label, c.column_expression,
             c.column_type, c.description,  c.table_alias,
             c.id_flex_application_id,      c.id_flex_code,
             lov_view_label, --NV-1077
             lov_view_name, --NV-1077
             lov_column_label --NV-1077
        FROM n_view_columns c, 
             n_view_tables t
       WHERE
           (    c.column_name LIKE p_column_prefix || '$%'
             OR c.column_name LIKE 'Z$' || p_column_prefix || '$%'         )
         AND c.view_name         = p_view_name
         AND c.query_position    = p_query_position
         AND c.id_flex_code     IS NOT NULL
         AND t.view_name         = c.view_name
		 and c.application_instance='G0'
    	  AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
         AND t.query_position    = c.query_position
         AND t.table_alias       = c.table_alias
         -- NOTE:  This needs to be the table_name rather than metadata_table_name.  We're expecting this to be like 'XXK%'  
         --        The metadata_table_name may have the original oracle EBS table_name (eg GL_CODE_COMBINATIONS).
         AND t.table_name     LIKE n_gseg_utility_pkg.g_kff_dc_view_pfx || '%';

--Retreive the orginal column for the seg columns
      CURSOR cur_orig_col( p_view_name        VARCHAR2,
                           p_column_prefix    VARCHAR2,
                           p_query_position   NUMBER,
                           p_col_type         VARCHAR2 )  IS
      SELECT c.t_column_id,       c.column_id,   c.source_column_id,
             c.column_expression, c.column_name, c.column_label,
             c.table_alias, c.column_type
        FROM n_view_columns c, 
             n_view_tables t
       WHERE c.column_name          LIKE p_column_prefix || '$' || p_col_type || '$%'
         AND c.view_name               = p_view_name
         AND c.query_position          = p_query_position
         AND c.id_flex_code           IS NOT NULL
         AND t.view_name               = c.view_name
         AND t.query_position          = c.query_position
         AND t.table_alias             = c.table_alias
		 and c.application_instance='G0'
		  AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
         -- NOTE:  This needs to be the table_name rather than metadata_table_name.  We're expecting this to be like 'XXK%'  
         --        The metadata_table_name may have the original oracle EBS table_name (eg GL_CODE_COMBINATIONS).
         AND t.table_name           LIKE n_gseg_utility_pkg.g_kff_dc_view_pfx || '%'
         AND ROWNUM                    = 1;

      rec_orig_col                   cur_orig_col%ROWTYPE;

--Following cursor to compensate band-aid seg and global seg processing
--cursor to retrieve the anomaly view columns
--***Please remove the below condition if Band-aid processing is obsolete and removed from the installs***
      CURSOR cur_apply_orig_column_name  IS
      SELECT mainq.view_name, 
             mainq.view_label, 
             mainq.column_id, 
             mainq.t_column_id, 
             mainq.column_name, 
             mainq.column_label, 
             mainq.column_type,
             mainq.query_position, 
             mainq.id_flex_code, 
             mainq.id_flex_application_id,
             mainq.application_instance
        FROM ( SELECT c.view_name, 
                      c.view_label,
                      c.column_id,
                      c.t_column_id, 
                      c.column_name,
                      c.column_label, 
                      q.query_position, 
                      c.id_flex_code,
                      c.id_flex_application_id,
                      COUNT (*) OVER ( PARTITION BY c.view_name, 
                                                    c.column_label   )   qry_cnt,
                      COUNT (*) OVER ( PARTITION BY c.view_name, 
                                                    c.column_label, 

                                                    c.column_type    )   col_type_cnt,
                      column_type, 
                      c.application_instance,
                      v.application_label, 
                      v.first_active_query_position
                 FROM n_view_columns c, 
                      n_views        v, 

                      n_view_queries q
                WHERE (    c.column_type         IN ('GEN', 'EXPR')
                        OR (     v.view_label     = 'EAM_WO_Matrl_Requirements'
                             AND c.column_label  IN ('PO_Cat', 'Locator', 'Purch_Cat')
                             AND c.column_type LIKE 'GEN%'        )  )
                  AND v.view_label               IN ( 'CSF_Debrief_Expense_Lines',
                                                      'CSF_Debrief_Labor_Lines', 

                                                      'CSF_Debrief_Material_Lines',
                                                      'EAM_Asset_Downtime',      

                                                      'EAM_WO_Cost_Details',
                                                      'EAM_WO_Matrl_Requirements',
                                                      'INV_Reservations',        

                                                      'INV_Item_Demand_Seg_Base',
                                                      'OKS_Sales_Credits', 

                                                      'PJM_Req_PO_Invoices'   )
                  AND v.application_instance  = 'G0'
                  AND NVL (v.omit_flag, 'N')  = 'N'
                  AND q.view_name             = v.view_name
                  AND NVL (q.omit_flag, 'N')  = 'N'
                  AND c.view_name             = v.view_name
                  AND c.query_position        = q.query_position
				  and v.application_instance='G0'
			   AND exists (select 1 from n_to_do_views_incr where view_label=v.view_label)
                  AND NVL (c.omit_flag, 'N')  = 'N'
                  AND EXISTS 

                    ( SELECT 'X'
                        FROM n_view_columns subc
                       WHERE c.column_label               = subc.column_label
                         AND NVL (subc.omit_flag, 'N')    = 'N'
                         AND (    subc.column_type     LIKE 'SEG%'
                                 OR subc.column_type     LIKE 'KEY%' )
                         AND (    subc.column_type       <> 'SEGSTRUCT'
                               OR subc.column_type       <> 'SEGEXPR' )
                         AND c.view_name                  = subc.view_name     )  ) mainq
       WHERE mainq.qry_cnt <> mainq.col_type_cnt
         AND EXISTS 
           ( SELECT 1 
               FROM n_view_properties         cp,
                    n_property_type_templates pt
              WHERE cp.view_name               = mainq.view_name
                AND cp.query_position          = mainq.query_position
                AND cp.source_pk_id            = mainq.column_id
                AND cp.value5                  = 'LEGACY'
                AND pt.property_type_id        = cp.property_type_id
                AND pt.templates_table_name    = 'N_VIEW_COLUMN_TEMPLATES' )
         AND mainq.first_active_query_position = mainq.query_position
         AND EXISTS 
           ( SELECT 1
               FROM n_view_parameter_extensions pext
              WHERE pext.parameter_name        = 'GEN_' || mainq.application_label || '_KFF_COLS'
                AND pext.install_stage         = 4
                AND pext.value                 = 'Y'
                AND pext.install_creation_date =
                  ( SELECT MAX (nvp.creation_date)
                      FROM n_view_parameters nvp
                     WHERE nvp.install_stage = 4 ) );
--
-- This cursor highlights the views where the kff column is not in the
-- first query. For legacy processing, we need to make sure that column
-- in the first query is simply the legacy name.
      CURSOR cur_apply_orig_column_name2  IS
      SELECT mainq.view_name, 
             mainq.view_label, 
             mainq.column_id, 
             mainq.t_column_id, 
             mainq.column_name, 
             mainq.column_label, 
             mainq.column_type,
             mainq.id_flex_code, 
             mainq.id_flex_application_id,
             mainq.application_instance,
             min(mainq.query_position) min_kff_query_position
        FROM ( SELECT c.view_name, 
                      c.view_label, 
                      c.column_id,
                      c.t_column_id, 
                      c.column_name,
                      c.column_label, 
                      q.query_position, 
                      c.id_flex_code,
                      c.id_flex_application_id,
                      COUNT (*) OVER ( PARTITION BY c.view_name, 
                                                    c.column_label   )   qry_cnt,
                      COUNT (*) OVER ( PARTITION BY c.view_name, 
                                                    c.column_label, 

                                                    c.column_type    )   col_type_cnt,
                      column_type, 
                      c.application_instance,
                      v.application_label, 
                      v.first_active_query_position
                 FROM n_view_columns c, 
                      n_views v, 

                      n_view_queries q
                WHERE (    c.column_type         IN ('GEN', 'EXPR')
                        OR (     v.view_label     = 'EAM_WO_Matrl_Requirements'
                             AND c.column_label  IN ('PO_Cat', 'Locator', 'Purch_Cat')
                             AND c.column_type LIKE 'GEN%'        )  )
                  AND v.view_label               IN ( 'CSF_Debrief_Expense_Lines',
                                                      'CSF_Debrief_Labor_Lines', 
                                                      'CSF_Debrief_Material_Lines',     
                                                      'EAM_Asset_Downtime',      



                                                      'EAM_WO_Cost_Details',
                                                      'EAM_WO_Matrl_Requirements',
                                                      'INV_Reservations',        

                                                      'OKS_Sales_Credits',
                                                      'PJM_Req_PO_Invoices'   )
                  AND v.application_instance  = 'G0'
                  AND NVL (v.omit_flag, 'N')  = 'N'
                  AND q.view_name             = v.view_name
                  AND NVL (q.omit_flag, 'N')  = 'N'
                  AND c.view_name             = v.view_name
                  AND c.query_position        = q.query_position
				  and v.application_instance='G0'
			   AND exists (select 1 from n_to_do_views_incr where view_label=v.view_label)
                  AND NVL (c.omit_flag, 'N')  = 'N'
                  AND EXISTS 

                    ( SELECT 'X'
                        FROM n_view_columns subc
                       WHERE c.column_label               = subc.column_label
                         AND NVL (subc.omit_flag, 'N')    = 'N'
                         AND (    subc.column_type     LIKE 'SEG%'
                                 OR subc.column_type     LIKE 'KEY%' )
                         AND (    subc.column_type       <> 'SEGSTRUCT'
                               OR subc.column_type       <> 'SEGEXPR' )
                         AND c.view_name                  = subc.view_name     )  ) mainq
       WHERE mainq.qry_cnt <> mainq.col_type_cnt      
         AND EXISTS 
           ( SELECT 1 
               FROM n_view_properties         cp,
                    n_property_type_templates pt
              WHERE cp.view_name               = mainq.view_name
                AND cp.query_position          = mainq.query_position
                AND cp.source_pk_id            = mainq.column_id
                AND cp.value5                  = 'LEGACY'
                AND pt.property_type_id        = cp.property_type_id
                AND pt.templates_table_name    = 'N_VIEW_COLUMN_TEMPLATES' )                
       AND mainq.first_active_query_position <> mainq.query_position       
         AND EXISTS 
           ( SELECT 1
               FROM n_view_parameter_extensions pext
              WHERE pext.parameter_name        = 'GEN_' || mainq.application_label || '_KFF_COLS'
                AND pext.install_stage         = 4
                AND pext.value                 = 'Y'
                AND pext.install_creation_date =
                  ( SELECT MAX (nvp.creation_date)
                      FROM n_view_parameters nvp
                     WHERE nvp.install_stage = 4 ) )
      group by mainq.view_name, 
             mainq.view_label,
             mainq.column_id,
             mainq.t_column_id, 
             mainq.column_name, 
             mainq.column_label, 
             mainq.column_type,
             mainq.id_flex_code, 
             mainq.id_flex_application_id,
             mainq.application_instance
      ;
--
---BEGIN Processing---
   BEGIN
      l_error_location := l_script_name || '-start anomaly processing';

      FOR rec_c IN cur_get_view_dtls  LOOP
         l_column_name_prefix := ( CASE
                                     WHEN (     LENGTHB(rec_c.column_label)     > 8
                                            AND INSTRB(rec_c.column_label, '_') > 0 )
                                          THEN ( CASE 

                                                   WHEN ( INSTRB(SUBSTRB(rec_c.column_label,1,8), '_') > 0 )
                                                        THEN SUBSTRB(rec_c.column_label, 1, 8)
                                                   ELSE SUBSTRB(rec_c.column_label, 1, 7) || 
                                                        SUBSTRB(rec_c.column_label, INSTRB(rec_c.column_label, '_') + 1,1)
                                                 END )
                                     WHEN (     LENGTHB(rec_c.column_label)     > 8
                                            AND INSTRB(rec_c.column_label, '_') = 0 )
                                          THEN SUBSTRB(rec_c.column_label, 1, 8)
                                     ELSE rec_c.column_label
                                   END  );

          l_column_name_prefix := RTRIM(l_column_name_prefix,'_');

         ---Below logic to insert the original column
         BEGIN
            SELECT COUNT (*)
              INTO l_column_exists
              FROM n_view_columns c
             WHERE c.view_name      = rec_c.view_name
               AND c.column_name    = rec_c.column_label
               AND c.query_position = rec_c.query_position;

            IF (     l_column_exists    = 0
                 AND (rec_c.view_label in ( l_retain_orig_columns_4_view1, 
                                            l_retain_orig_columns_4_view2 ) ) ) THEN
               l_error_location := 'inserting the original column into n_view_columns';
               l_col_expression := NULL;

               OPEN cur_orig_col( rec_c.view_name,
                                  l_column_name_prefix,
                                  rec_c.query_position,
                                  n_gseg_utility_pkg.g_kff_dc_concat_val_pfx  );

               FETCH cur_orig_col
                INTO rec_orig_col;

               IF ( cur_orig_col%FOUND ) THEN
                  l_col_expression := rec_orig_col.column_expression;
               END IF;

               CLOSE cur_orig_col;

               IF ( l_col_expression IS NULL ) THEN
                  OPEN cur_orig_col( rec_c.view_name,
                                     l_column_name_prefix,
                                     rec_c.query_position,
                                     n_gseg_utility_pkg.g_kff_dc_seg_val_pfx   );

                  FETCH cur_orig_col
                   INTO rec_orig_col;

                  IF ( cur_orig_col%FOUND ) THEN
                     l_col_expression := rec_orig_col.column_expression;
                  END IF;

                  CLOSE cur_orig_col;
               END IF;
               

               IF ( l_col_expression IS NULL ) THEN

                  n_gseg_utility_pkg.insert_view_column
                    (i_t_column_id                 => rec_c.t_column_id,
                     i_view_name                   => rec_c.view_name,
                     i_view_label                  => rec_c.view_label,
                     i_query_position              => rec_c.query_position,
                     i_column_name                 => rec_c.column_label,
                     i_column_label                => rec_c.column_label,
                     i_table_alias                 => NULL,
                     i_column_expression           => 'TO_CHAR(NULL)',
                     i_column_position             => rec_c.column_position,
                     i_column_type                 => 'GENEXPR',
                     i_description                 => NULL,
                     i_ref_lookup_column_name      => NULL,
                     i_group_by_flag               => rec_c.group_by_flag,
                     i_application_instance        => rec_c.application_instance,
                     i_gen_search_by_col_flag      => 'N',
                     i_generated_flag              => 'Y',
                     i_id_flex_application_id      => NULL,
                     i_id_flex_code                => NULL,
                     o_column_id                   => l_column_id );
               ELSE
                  n_gseg_utility_pkg.insert_view_column
                    (i_t_column_id                 => rec_c.t_column_id,
                     i_view_name                   => rec_c.view_name,
                     i_view_label                  => rec_c.view_label,
                     i_query_position              => rec_c.query_position,
                     i_column_name                 => rec_c.column_label,
                     i_column_label                => rec_c.column_label,
                     i_table_alias                 => rec_orig_col.table_alias,
                     i_column_expression           => l_col_expression,
                     i_column_position             => rec_c.column_position,
                     i_column_type                 => 'GEN',
                     i_description                 => NULL,
                     i_ref_lookup_column_name      => NULL,
                     i_group_by_flag               => rec_c.group_by_flag,
                     i_application_instance        => rec_c.application_instance,
                     i_gen_search_by_col_flag      => 'N',
                     i_generated_flag              => 'Y',
                     i_id_flex_application_id      => rec_c.id_flex_application_id,
                     i_id_flex_code                => rec_c.id_flex_code,
                     o_column_id                   => l_column_id                   );
               END IF;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_c.view_name
                  || '~'
                  || rec_c.query_position
                  || '~'
                  || rec_c.column_name
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;

         FOR rec_segcol IN cur_gseg_qry_cols( rec_c.view_name,
                                              l_column_name_prefix,
                                              rec_c.query_position  ) LOOP
            l_error_location := 'derving column expression for the seg column';

            --Verify if the column is PK column and change the column expression to NUMBER
            IF ( SUBSTRB(rec_segcol.column_name, 1, 2) = 'Z$' ) THEN
               l_col_expression := 'CHARTOROWID(NULL)';
            ELSE
               BEGIN
                  SELECT 'TO_NUMBER(NULL)'
                    INTO l_col_expression
                    FROM n_kff_flex_source_templates
                   WHERE 

                       (    UPPER (kff_table_pk1) = UPPER (rec_segcol.column_expression)
                         OR UPPER (kff_table_pk2) = UPPER (rec_segcol.column_expression)   )
                     AND id_flex_application_id   = rec_segcol.id_flex_application_id
                     AND id_flex_code             = rec_segcol.id_flex_code
                     AND ROWNUM                   = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND   THEN
                     l_col_expression := 'TO_CHAR(NULL)';
                  WHEN OTHERS          THEN
                     l_col_expression := 'TO_CHAR(NULL)';
               END;
            END IF;

            FOR rec_colqry IN cur_get_all_dtls( rec_c.view_name,
                                                rec_c.column_label ) LOOP
               IF ( rec_c.query_position <> rec_colqry.query_position ) THEN
                  SELECT COUNT (*)
                    INTO l_column_exists
                    FROM n_view_columns c
                   WHERE c.view_name        = rec_colqry.view_name
                     AND c.column_name      = rec_segcol.column_name
                     AND c.query_position   = rec_colqry.query_position;

                  BEGIN
                     IF ( l_column_exists = 0 ) THEN
                        l_error_location := 'inserting into n_view_columns';

                        n_gseg_utility_pkg.insert_view_column
                           (i_t_column_id                 => rec_colqry.t_column_id,
                            i_view_name                   => rec_colqry.view_name,
                            i_view_label                  => rec_colqry.view_label,
                            i_query_position              => rec_colqry.query_position,
                            i_column_name                 => rec_segcol.column_name,
                            i_column_label                => rec_c.column_label,
                            i_table_alias                 => NULL,
                            i_column_expression           => l_col_expression,
                            i_column_position             => rec_colqry.column_position,
                            i_column_type                 => 'GENEXPR',
                            i_description                 => rec_segcol.description,
                            i_ref_lookup_column_name      => NULL,
                            i_group_by_flag               => rec_colqry.group_by_flag,
                            i_application_instance        => rec_colqry.application_instance,
                            i_gen_search_by_col_flag      => 'N',
							i_lov_view_label              => rec_segcol.lov_view_label, --NV-1077
                            i_lov_view_name               => rec_segcol.lov_view_name, --NV-1077
                            i_lov_column_label            => rec_segcol.lov_column_label, --NV-1077
                            i_generated_flag              => 'Y',
                            i_id_flex_application_id      => rec_colqry.id_flex_application_id,
                            i_id_flex_code                => rec_colqry.id_flex_code,
                            o_column_id                   => l_column_id           );

                        l_column_property_type :=
                           (CASE
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_seg_val_pfx
                                      || '$%'
                                  THEN 'SEGMENT_VALUE'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_seg_desc_pfx
                                      || '$%'
                                  THEN 'SEGMENT_DESCRIPTION'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_concat_val_pfx
                                      || '$%'
                                  THEN 'CONCATENATED_VALUES'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_concat_desc_pfx
                                      || '$%'
                                  THEN 'CONCATENATED_DESCRIPTIONS'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_qual_val_pfx
                                      || '$%'
                                  THEN 'QUALIFIER_VALUE'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || n_gseg_utility_pkg.g_kff_dc_qual_desc_pfx
                                      || '$%'
                                  THEN 'QUALIFIER_DESCRIPTION'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || 'Segment_Name_List'
                                      || '$%'
                                  THEN 'SEGMENT_NAME_LIST'
                               WHEN rec_segcol.column_name LIKE
                                         l_column_name_prefix
                                      || '$'
                                      || 'Structure_Name'
                                      || '$%'
                                  THEN 'STRUCTURE_NAME'
                               ELSE 'PRIMARY_KEY'
                            END
                           );

                        n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => rec_colqry.view_name,
                            i_view_label                       => rec_colqry.view_label,
                            i_query_position                   => rec_colqry.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => rec_colqry.t_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id      );

                        -- Special processing for Z$ columns
                        IF ( rec_segcol.column_name LIKE 'Z$%' ) THEN
                             -- Determine if the Z$$ column exists
                             SELECT COUNT (*)
                               INTO l_column_exists
                               FROM n_view_columns c
                              WHERE c.view_name        = rec_colqry.view_name
                                AND c.column_name   LIKE 'Z$$%'
                                AND c.query_position   = rec_colqry.query_position;

                             -- If the Z$$ does not exist, then add to the query.
                             IF ( l_column_exists = 0 ) THEN
                                n_gseg_utility_pkg.insert_view_column
                                   (i_t_column_id                 => rec_colqry.t_column_id,
                                    i_view_name                   => rec_colqry.view_name,
                                    i_view_label                  => rec_colqry.view_label,
                                    i_query_position              => rec_colqry.query_position,
                                    i_column_name                 => 'Z$$_________________________',
                                    i_column_label                => 'NONE',
                                    i_table_alias                 => 'NONE',
                                    i_column_expression           => 'Z$$_________________________',
                                    i_column_position             => 1500,
                                    i_column_type                 => 'CONST',
                                    i_description                 => 'Columns following this are table rowids with values having meaning only internal to Oracle. Use them only to join to the view specified by the column name. ',
                                    i_ref_lookup_column_name      => NULL,
                                    i_group_by_flag               => rec_colqry.group_by_flag,
                                    i_application_instance        => rec_colqry.application_instance,
                                    i_gen_search_by_col_flag      => 'N',
                                    i_generated_flag              => 'Y',
                                    i_id_flex_application_id      => NULL,
                                    i_id_flex_code                => NULL,
                                    o_column_id                   => l_column_id           );
                             END IF;
                        END IF;

                     END IF;

                     l_error_location := 'updating n_view_columns omiting the columns';

                     --omit the orginal column if its not required
                     UPDATE n_view_columns c
                        SET omit_flag            = 'Y'
                      WHERE c.view_name          = rec_colqry.view_name
                        AND c.view_label    NOT IN ( l_retain_orig_columns_4_view1,
                                                     l_retain_orig_columns_4_view2 )
                        AND c.query_position       = rec_colqry.query_position
                        AND c.column_name          = rec_c.column_label
                        AND c.column_position      = rec_colqry.column_position
                        AND c.application_instance = 'G0'
                        AND c.column_type   NOT LIKE 'SEG%'
                        AND NVL(c.omit_flag, 'N')  = 'N'
                        --Below condition is added to verfiy if the band-aid seg columns are installed or not.
                        --The original columns will be omitted if the band-aid seg columns are not installed.
                        --The verification is done based on module parameter and its value in param extention table
                        --***Please remove the below condition if Band-aid processing is obsolete and removed from the installs***
                        AND NOT EXISTS 

                          ( SELECT 1
                              FROM n_views                     v,
                                   n_view_parameter_extensions pext
                             WHERE v.view_name                = c.view_name
                               AND pext.parameter_name        = 'GEN_'|| v.application_label || '_KFF_COLS'
                               AND pext.install_stage         = 4
                               AND VALUE                      = 'Y'
                               AND pext.install_creation_date =
                                 ( SELECT MAX (nvp.creation_date)
                                     FROM n_view_parameters nvp
                                    WHERE nvp.install_stage = 4));
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_colqry.view_name
                           || '~'
                           || rec_colqry.query_position
                           || '~'
                           || rec_segcol.column_name
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;
               END IF;
            END LOOP;        -- end of cursor cur_get_all_dtls for ALL columns
         END LOOP;      -- end of cursor cur_gseg_qry_cols
      END LOOP;     -- end of cursor cur_get_view_dtls to retrieve only SEGCOL

      COMMIT;
      --Following code to compensate band-aid seg and global seg processing
      --In the below code we are updating the first active query column_name with subsequent queries related column in the view
      --This column name update is done to maintain the ordering of the column across queries
      --The columns in other queires may be as-is column from metadata or generated column with some suffix
      --this might change the ordering of the columns in multiple queries and lead to issue in view creation
      --***Please remove the below condition if Band-aid processing is obsolete and removed from the installs***
      l_error_location := 'updating n_view_columns to column name for sequencing ordering of the columns';

      FOR rec_coln IN cur_apply_orig_column_name LOOP
         BEGIN
            UPDATE n_view_columns c
               SET column_name = rec_coln.column_name
             WHERE view_name = rec_coln.view_name
               AND c.query_position <> rec_coln.query_position
               AND c.column_label = rec_coln.column_label
               AND c.column_type IN ('GEN', 'EXPR')
               AND id_flex_code IS NULL;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_coln.view_name
                  || '~'
                  || rec_coln.query_position
                  || '~'
                  || rec_coln.column_label
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;
      END LOOP;
      --
      -- Now handle the records where the kff column isn't in the first query.
      FOR rec_coln2 IN cur_apply_orig_column_name2
      LOOP
         BEGIN
            UPDATE n_view_columns c
               SET c.column_name            = SUBSTRB(rec_coln2.column_name, 1, INSTRB(rec_coln2.column_name, '$')-1)
             WHERE c.view_name              = rec_coln2.view_name
               AND c.query_position        <> rec_coln2.min_kff_query_position
               AND c.column_label           = rec_coln2.column_label
               AND c.column_type           IN ('GEN', 'EXPR')
               AND rec_coln2.column_name LIKE '%$%'
               AND id_flex_code            IS NULL;
         EXCEPTION
            WHEN OTHERS  THEN
               l_status := l_error_status;
               l_error_number := SQLCODE;
               l_error_msg :=
                     rec_coln2.view_name
                  || '~'
                  || rec_coln2.column_label
                  || '~'
                  || SQLERRM (l_error_number);
               RAISE;
         END;
      END LOOP;

      COMMIT;

/*      BEGIN

        SELECT COUNT(*)
          INTO li_bom_view_exists
          FROM n_views v
         WHERE UPPER(v.view_label)    LIKE 'BOM_CURRENT_STRUCTURED_BILLS'
           AND v.application_instance LIKE 'G0';

        IF ( li_bom_view_exists > 0 ) THEN

            SELECT s.target_column_name
              INTO ls_segment_name 
              FROM n_f_kff_flex_sources fs,
                   n_f_kff_segments     s
             WHERE fs.id_flex_code        = 'MSTK'
               AND fs.source_type         = 'DC'
               AND fs.data_application_id = 401
               AND s.data_table_key       = fs.data_table_key
               AND ROWNUM = 1 
             ORDER BY s.segment_order;

             SELECT tab.table_alias
               INTO ls_table_alias 
               FROM ( SELECT *
                        FROM n_view_tables a
                       WHERE a.application_instance = 'G0'
                         AND a.view_label           = 'BOM_Current_Structured_Bills'
                         AND a.from_clause_position > 
                           ( SELECT b.from_clause_position 
                               FROM n_view_tables b
                              WHERE b.table_alias          = 'TASSY'
                                AND b.application_instance = 'G0'
                                AND b.view_label           = 'BOM_Current_Structured_Bills'  )
                       ORDER BY a.from_clause_position ) tab
               WHERE rownum=1;

              DELETE n_view_wheres s
               WHERE s.application_instance = 'G0'
                 AND UPPER(s.view_label)    = 'BOM_CURRENT_STRUCTURED_BILLS'
                 AND s.where_clause      LIKE '%'||ls_table_alias||'%'
                 AND s.query_position       = 8;

              DELETE n_view_tables T
               WHERE t.application_instance = 'G0'
                 AND UPPER(t.view_label)    = 'BOM_CURRENT_STRUCTURED_BILLS'
                 AND t.table_alias       LIKE 'TASSY'
                 AND t.query_position       = 8;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = 'AND HIER.TOP_ASSY_ITEM = '||ls_table_alias||'.'||ls_segment_name||'' 
               WHERE upd.view_label           = 'BOM_Current_Structured_Bills'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause      LIKE ' AND HIER.TOP_ASSY_ITEM = TASSY%' ;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'TASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Structured_Bills'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ITEM_ID = TASSY.INVENTORY_ITEM_ID';

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'TASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Structured_Bills'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ORGANIZATION_ID = TASSY.ORGANIZATION_ID';

              COMMIT;
        END IF;
      END;*/

-- Issue:NV-143 --start--
   -- Handling BOM_Current_Struct_Base view
BEGIN

        SELECT COUNT(*)
          INTO li_bom_view_exists
          FROM n_views v
         WHERE UPPER(v.view_label)    LIKE 'BOM_CURRENT_STRUCT_BASE'
           AND v.application_instance LIKE 'G0'
       and exists (select 1 from n_to_do_views_incr where view_label =v.view_label);

        IF ( li_bom_view_exists > 0 ) THEN

            SELECT s.target_column_name
              INTO ls_segment_name
              FROM n_f_kff_flex_sources fs,
                   n_f_kff_segments     s
             WHERE fs.id_flex_code        = 'MSTK'
               AND fs.source_type         = 'DC'
               AND fs.data_application_id = 401
               AND s.data_table_key       = fs.data_table_key
               AND ROWNUM = 1
             ORDER BY s.segment_order;

             SELECT tab.table_alias
               INTO ls_table_alias
               FROM ( SELECT *
                        FROM n_view_tables a
                       WHERE a.application_instance = 'G0'
                         AND a.view_label           = 'BOM_Current_Struct_Base'
                         AND a.from_clause_position >
                           ( SELECT b.from_clause_position
                               FROM n_view_tables b
                              WHERE b.table_alias          = 'ASSY'
                                AND b.application_instance = 'G0'
                                AND b.view_label           = 'BOM_Current_Struct_Base'
                                AND B.query_position       = 8                )
                       ORDER BY a.from_clause_position ) tab
               WHERE rownum=1;

              DELETE n_view_wheres s
               WHERE s.application_instance = 'G0'
                 AND UPPER(s.view_label)    = 'BOM_CURRENT_STRUCT_BASE'
                 AND s.where_clause      LIKE '%'||ls_table_alias||'%'
                 AND s.query_position       = 8;

              DELETE n_view_tables T
               WHERE t.application_instance = 'G0'
                 AND UPPER(t.view_label)    = 'BOM_CURRENT_STRUCT_BASE'
                 AND t.table_alias       LIKE 'ASSY'
                 AND t.query_position       = 8;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = 'AND HIER.TOP_ASSY_ITEM = '||ls_table_alias||'.'||ls_segment_name||''
               WHERE upd.view_label           = 'BOM_Current_Struct_Base'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause      LIKE 'AND HIER.TOP_ASSY_ITEM = ASSY%' ;

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'ASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Struct_Base'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ITEM_ID = ASSY.INVENTORY_ITEM_ID';

              UPDATE n_view_wheres upd
                 SET upd.where_clause         = REPLACE(WHERE_CLAUSE,'ASSY',ls_table_alias)
               WHERE upd.view_label           = 'BOM_Current_Struct_Base'
                 AND upd.application_instance = 'G0'
                 AND upd.query_position       = 8
                 AND upd.where_clause         = 'AND HIER.TOP_ASSEMBLY_ORGANIZATION_ID = ASSY.ORGANIZATION_ID';

         COMMIT;
        END IF;
      END;
-- Issue:NV-143 --end--

   EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'anomaly_view',
                                                      l_error_location,
                                                      l_error_status,
                                                      NVL (l_error_msg,
                                                           SQLERRM
                                                          ),
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
   END anomaly_view;

--
---------------------------------------------------------------------
--
-- Procedure Name: flexsource_direct
--
-- Description 
--   For all the views with source_type as DIRECT, populates the flexfield column metadata into non-template tables.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE flexsource_direct IS
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_error_code                  NUMBER                            := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                     := 'SUCCESS';
      l_error_status                VARCHAR2 (1000)                   := 'ERROR';
      l_in_process_status           VARCHAR2 (30)                     := 'IN-PROCESS';
      l_error_number                NUMBER                            := NULL;
      l_column_position             NUMBER                               := 0;
      l_column_name                 VARCHAR2 (30)                     := NULL;
      l_column_expr                 VARCHAR2 (1000)                   := NULL;
      l_column_exists               NUMBER;
      l_column_name_prefix          VARCHAR2 (30)                     := NULL;
      l_md_struct_constraint_type   VARCHAR2 (20);
      l_col_description             n_view_columns.description%TYPE   := NULL;
      l_column_type                 n_view_columns.column_type%TYPE;
      l_column_property_type        n_property_type_templates.property_type%TYPE;
      l_view_property_id            n_view_properties.view_property_id%TYPE;
      l_t_view_property_id          n_view_properties.t_view_property_id%TYPE;
      l_column_id                   n_view_columns.column_id%TYPE;
      l_t_column_id                 n_view_columns.t_column_id%TYPE;

---Determine the column first
      CURSOR c1 IS
      SELECT c.view_name, 
             c.query_position, 
             c.column_label,
             c.t_column_id,
             c.column_id,
             c.table_alias, 
             t.from_clause_position, 
             c.column_position,
             t.table_name, 
             t.metadata_table_name,
             c.id_flex_code,
             ( CASE
                 WHEN (     c.id_flex_application_id = 800
                        AND c.id_flex_code IN ('COST', 'BANK', 'GRP') )  THEN 801
                 ELSE c.id_flex_application_id
               END      )                                   id_flex_application_id,
             ( CASE
                 WHEN ( c.column_type = 'SEGCAT' ) THEN 'SEG'
                 ELSE c.column_type
               END      )                                   column_type,
             v.special_process_code, 
             v.security_code, 
             v.view_label,
             v.application_instance, 
             c.group_by_flag, 
             fs.data_table_key,
             ( SELECT ct.description
                 FROM n_view_column_templates ct
                WHERE ct.view_label                          = c.view_label
                  AND ct.query_position                      = c.query_position
                  AND ct.column_label                        = c.column_label
                  AND REPLACE( ct.column_type, 'KEY', 'SEG') = c.column_type
                  AND NVL( ct.profile_option, 'XX' )         = NVL( c.profile_option, 'XX' )
                  AND ROWNUM = 1 )                          description,
             COUNT( c.view_name ) 
              OVER ( PARTITION BY fs.data_table_key, 
                                  c.view_name, 

                                  c.query_position )        no_of_str
        FROM n_view_columns c,
             n_view_tables t,
             n_views v,
             n_f_kff_flex_sources fs
       WHERE fs.id_flex_application_id      = ( CASE
                                                  WHEN (     c.id_flex_application_id  = 800
                                                         AND c.id_flex_code           IN ('COST', 'BANK', 'GRP') ) THEN 801
                                                  ELSE c.id_flex_application_id
                                                END )
         AND fs.id_flex_code                = c.id_flex_code
         AND fs.data_application_table_name = t.metadata_table_name
		 and v.application_instance='G0'
 		   AND exists (select 1 from n_to_do_views_incr where view_label=v.view_label)
         AND fs.source_type                 = 'DIRECT'
         AND c.column_type               LIKE 'SEG%'
         AND c.column_type             NOT IN ('SEGP', 'SEGEXPR', 'SEGSTRUCT')
         AND c.application_instance         = 'G0'
         --AND c.generated_flag               = 'N'
         AND c.view_name                    = t.view_name
         AND c.query_position               = t.query_position
         AND c.table_alias                  = t.table_alias
         AND NVL( c.omit_flag, 'N' )        = 'N'
         AND c.view_name                    = v.view_name
         AND NVL( v.omit_flag, 'N' )        = 'N'
       ORDER BY column_type, 
                view_name, 
                query_position;

      CURSOR kff_struct_cur ( p_view_name        VARCHAR2,
                              p_column_id        INTEGER,
                              p_qry_pos          NUMBER,
                              p_data_table_key   VARCHAR2    ) IS
         SELECT NVL( colp.value2, str.id_flex_num ) structure_id, 
                colp.value1,
                colp.value2, 
                str.id_flex_num, 
                str.structure_name
           FROM n_view_properties         colp,
                n_property_type_templates pt, 
                n_f_kff_structures        str
          WHERE colp.view_name          = p_view_name
            AND colp.query_position     = p_qry_pos
            AND colp.source_pk_id       = p_column_id
            AND pt.property_type_id     = colp.property_type_id
            AND pt.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES'
            AND pt.property_type        = 'INCLUDE_STRUCTURE'
            AND str.data_table_key(+)   = p_data_table_key
            AND str.structure_name(+)   = colp.value1;

      CURSOR detect_multi_seg_direct( p_data_table_key   VARCHAR2,
                                      p_id_flex_num      NUMBER   ) IS
         SELECT id_flex_num,
                (CASE
                    WHEN seg_cnt = 1
                       THEN 'N'
                    ELSE 'Y'
                 END) multi_seg_detected
           FROM (SELECT   seg.id_flex_num, COUNT (*) seg_cnt
                     FROM n_f_kff_segments seg, n_f_kff_structures str
                    WHERE seg.data_table_key = p_data_table_key
                      AND str.data_table_key = seg.data_table_key
                      AND str.id_flex_num = p_id_flex_num
                 GROUP BY seg.id_flex_num)
          WHERE id_flex_num = p_id_flex_num;

      rec_multi_seg_direct          detect_multi_seg_direct%ROWTYPE;

      --given the data table key, this cursor gets the concatenated source expressions for the segment list
      CURSOR cur_concat_col (
         p_data_table_key              VARCHAR2,
         p_id_flex_num                 NUMBER,
         p_col_type                    VARCHAR2,
         p_md_struct_constraint_type   VARCHAR2,
         p_multi_seg_detected          VARCHAR2,
         p_exclude_helper_columns      NUMBER,
         p_include_concat_seg_val      NUMBER,
         p_include_concat_seg_pval     NUMBER,
         p_include_concat_seg_desc     NUMBER,
         p_include_concat_seg_pdesc    NUMBER
      )
      IS
         SELECT DISTINCT kcat.concatenation_type, kcat.target_column_name,
                         kcat.formatted_column_name,
                         (CASE
                             WHEN kcat.concatenation_type = 'LIST'
                                THEN 1
                             WHEN kcat.concatenation_type = 'VAL'
                                THEN 2
                             WHEN kcat.concatenation_type = 'PVAL'
                                THEN 3
                             WHEN kcat.concatenation_type = 'DESC'
                                THEN 4
                             WHEN kcat.concatenation_type = 'PDESC'
                                THEN 5
                          END
                         ) l,
                         kcat.source_expression
                    FROM n_f_kff_concatenations kcat
                   WHERE kcat.data_table_key = p_data_table_key
                     AND kcat.id_flex_num = p_id_flex_num
---Do not bring in the segment list column, if EXLCUDE_GLOBAL_HELPER_COLUMNS mentioned for the column property
                     AND (CASE
                             WHEN kcat.concatenation_type = 'LIST'
                             AND p_exclude_helper_columns = 0
                             AND p_include_concat_seg_val > 0
                             AND p_md_struct_constraint_type != 'SINGLE'
                             AND p_multi_seg_detected = 'Y'
                                THEN 1
---Bring in the concatenated value column, if corresponding property (INCLUDE_CONCAT_SEGMENT_VALUES)exists
                          WHEN kcat.concatenation_type = 'VAL'
                          AND p_include_concat_seg_val > 0
                          AND p_multi_seg_detected = 'Y'
                                THEN 2
                          END
                         ) IS NOT NULL
                ORDER BY l;

      CURSOR c4_1 ( p_data_table_key              NUMBER,
                    p_id_flex_num                 NUMBER,
                    p_md_struct_constraint_type   VARCHAR2,
                    p_exclude_helper_columns      NUMBER      ) IS
         WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL < 2)
         SELECT (CASE
                    WHEN ROWNUM = 2
                       THEN 'Structure_ID'
                    WHEN ROWNUM = 1
                       THEN 'Structure_Name'
                 END
                ) struct_column,
                struct.structure_name
           FROM DATA, 
                n_f_kff_structures struct
          WHERE (CASE
                    WHEN p_exclude_helper_columns = 0
                    AND p_md_struct_constraint_type = 'MULTIPLE'
                       THEN 1
                    ELSE NULL
                 END
                ) = 1
            AND struct.data_table_key = p_data_table_key
            AND struct.id_flex_num = p_id_flex_num;

--for individual segment values
      CURSOR c6 (
         p_data_table_key           VARCHAR2,
         p_id_flex_num              NUMBER,
         p_include_indiv_seg_val    VARCHAR2,
         p_include_indiv_seg_desc   VARCHAR2,
         p_include_concat_seg_val   VARCHAR2,
         p_include_concat_seg_desc  VARCHAR2,
         p_multi_seg_detected       VARCHAR2,
         p_constraint_type          VARCHAR2,
         p_column_name_prefix       VARCHAR2
      )
      IS
select formatted_target_column_name, target_column_name, application_column_name,segment_name,
       count(1) over(partition by formatted_target_column_name) dup_col_cnt,
       ROW_NUMBER() over(partition by formatted_target_column_name order by formatted_target_column_name, target_column_name,segment_name ) sub_script
  from   
(select n_gseg_utility_pkg.FORMAT_KFF_SEGMENT(p_column_name_prefix||'$'||target_column_name,30) formatted_target_column_name,
       target_column_name,application_column_name,segment_name
       from 

  (WITH DATA AS
              (SELECT     LEVEL lvl
                     FROM DUAL
               CONNECT BY LEVEL <= 1)
         SELECT data_table_key,
                (CASE
                    WHEN lvl = 1
                       THEN target_column_name
                    WHEN lvl = 2
                       THEN target_desc_column_name
                 END
                ) target_column_name,
                seg.application_column_name, seg.segment_name
           FROM DATA, 
                n_f_kff_segments seg
          WHERE seg.data_table_key = p_data_table_key
            AND seg.id_flex_num = p_id_flex_num
            AND (CASE
                    WHEN (lvl = 1 AND (p_include_indiv_seg_val > 0) OR (p_include_indiv_seg_val = 0 AND p_include_concat_seg_val > 0 AND p_multi_seg_detected ='N'))
                       THEN 1
                    WHEN (lvl = 2 AND (p_include_indiv_seg_desc > 0) OR (p_include_indiv_seg_desc = 0 AND p_include_concat_seg_desc > 0 AND p_multi_seg_detected ='N'))
                       THEN 2
                 END
                ) IS NOT NULL));
   BEGIN
      l_error_location := 'n_glb_direct_segcol_integration-start';

      OPEN c3 (n_gseg_utility_pkg.g_kff_app_label);

      FETCH c3
       INTO r3;

      CLOSE c3;

--Primary cursor to get the view columns where the data cache metadata needs to be brought int
      FOR r1 IN c1
      LOOP                                                             --{ c1
         --The cursor c2 is only for getting the additional information about the data table key
         OPEN c2 (r1.id_flex_code, r1.id_flex_application_id, r1.metadata_table_name);

         --{c2
         FETCH c2
          INTO r2;

         CLOSE c2;

--Manifestation of column properties metadata
         OPEN col_prop_cur( r1.view_name, r1.column_label, r1.query_position);

         FETCH col_prop_cur
          INTO col_prop_rec;

         CLOSE col_prop_cur;

         --loop for each key flexfield structure of the view properties
         FOR rec_kff_struct IN kff_struct_cur (r1.view_name,
                                               col_prop_rec.column_id,
                                               r1.query_position,
                                               r1.data_table_key
                                              )
         LOOP
            --Derive the multi seg struct property
            OPEN detect_multi_seg_direct (r1.data_table_key,
                                          rec_kff_struct.structure_id
                                         );

            FETCH detect_multi_seg_direct
             INTO rec_multi_seg_direct;

            CLOSE detect_multi_seg_direct;

            IF col_prop_rec.include_structure_count = 0
            THEN
               l_md_struct_constraint_type := 'NONE';
            ELSIF col_prop_rec.include_structure_count = 1
            THEN
               l_md_struct_constraint_type := 'SINGLE';
            ELSE
               l_md_struct_constraint_type := 'MULTIPLE';
            END IF;

            --derive column name prefix
            l_column_name_prefix    := ( CASE
                                           WHEN (     LENGTHB(r1.column_label)     > 8
                                                  AND INSTRB(r1.column_label, '_') > 0 )
                                                THEN ( CASE 

                                                         WHEN ( INSTRB(SUBSTRB(r1.column_label,1,8), '_') > 0 )
                                                              THEN SUBSTRB(r1.column_label, 1, 8)
                                                         ELSE SUBSTRB(r1.column_label, 1, 7) ||
                                                              SUBSTRB(r1.column_label, INSTRB (r1.column_label, '_') + 1,1)
                                                       END )
                                           WHEN (     LENGTHB(r1.column_label)     > 8
                                                  AND INSTRB(r1.column_label, '_') = 0 )
                                                THEN SUBSTRB(r1.column_label, 1, 8)
                                           ELSE r1.column_label
                                         END );

            l_column_name_prefix    := RTRIM( l_column_name_prefix, '_' );

            --l_column_name_prefix  := INITCAP( l_column_name_prefix );
            BEGIN
               SELECT MAX (column_position)
                 INTO l_column_position
                 FROM n_view_columns
                WHERE view_name = r1.view_name
                  AND query_position = r1.query_position;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  NULL;
            END;

            OPEN c3_1 (r1.id_flex_code, r1.id_flex_application_id);    --{c3_1

            FETCH c3_1
             INTO r3_1;

            CLOSE c3_1;                                                --}c3_1

            l_error_location := 'Insert into n_view_columns';

---Structure columns
            FOR r4_1 IN c4_1( r1.data_table_key,
                              rec_kff_struct.structure_id,
                              l_md_struct_constraint_type,
                              col_prop_rec.exclude_structure_name_col  )
            LOOP                                                       --{c4_1
               BEGIN
                  l_error_location  := 'view columns metadata - structure columns ';
                  l_column_position := l_column_position + 0.1;
                  l_column_name     := r4_1.struct_column;
                  l_col_description := n_gseg_utility_pkg.g_kff_coldesc_structname_sfx;
                  l_col_description := r1.description
                                    || ' '
                                    || REPLACE( l_col_description, '<flexfield>',
                                                r2.kff_name );
                  l_column_name     :=( CASE
                                          WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                             THEN SUBSTRB(l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                          ELSE l_column_name
                                        END );
                  l_column_name     := RTRIM( l_column_name, '_' );

                  l_column_name     := l_column_name_prefix || '$' || l_column_name;

                  IF ( r1.no_of_str > 1 ) THEN
                      l_column_type := 'GENEXPR';
                      l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                          ||' THEN '''||r4_1.structure_name||''' ELSE NULL END';
                  ELSE
                     l_column_type := 'CONST';
                     l_column_expr := r4_1.structure_name;
                  END IF;

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => l_column_type,
                        i_description                 =>  l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id   );

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_property_type                    => 'STRUCTURE_NAME',
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id             );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                                  --}c4_1

---Qualifier columns
            FOR r4_2 IN c4_2 (r1.data_table_key,
                              r1.view_name,
                              col_prop_rec.column_id,
                              r1.query_position
                             )
            LOOP                                                       --{c4_2
               BEGIN
                  l_error_location  := 'view columns metadata - qualifier columns ';
                  l_column_position := l_column_position + 0.1;
                  l_column_expr     := r4_2.qual_col_name;
                  l_column_name     := r4_2.qual_col_name;
                  l_col_description := ( CASE
                                           WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                THEN n_gseg_utility_pkg.g_kff_coldesc_qv_sfx
                                           ELSE n_gseg_utility_pkg.g_kff_coldesc_qd_sfx
                                         END );
                  l_col_description := r1.description
                                    || ' '
                                    || REPLACE( REPLACE( l_col_description,
                                                         '<segment>',
                                                         REPLACE( r4_2.segment_prompt,
                                                                  ' Segment' ) ),
                                                '<flexfield>',
                                                r2.kff_name );
                  l_column_name     := ( CASE
                                           WHEN ( LENGTHB(l_column_name) > (29 - LENGTHB(l_column_name_prefix)) )
                                                THEN SUBSTRB(l_column_name, 1, (29 - LENGTHB(l_column_name_prefix)) )
                                           ELSE l_column_name
                                         END );
                  l_column_name     := RTRIM (l_column_name, '_');

                  l_column_name     := l_column_name_prefix || '$' || l_column_name;
                  

                  l_column_property_type := ( CASE
                                                WHEN ( SUBSTRB( r4_2.qual_col_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_qual_val_pfx )
                                                    THEN 'QUALIFIER_VALUE'
                                                ELSE 'QUALIFIER_DESCRIPTION'
                                              END );

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => 'GEN',
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_segment_qualifier           => r4_2.segment_attribute_type,
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id    );

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => r4_2.segment_attribute_type,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                   );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                                  --}c4_2

---Concatenated columns
            FOR r4 IN cur_concat_col (r1.data_table_key,
                                      rec_kff_struct.structure_id,
                                      r1.column_type,
                                      l_md_struct_constraint_type,
                                      rec_multi_seg_direct.multi_seg_detected,
                                      col_prop_rec.exclude_segment_name_list_col,
                                      col_prop_rec.include_concat_seg_val,
                                      col_prop_rec.include_concat_seg_pval,
                                      col_prop_rec.include_concat_seg_desc,
                                      col_prop_rec.include_concat_seg_pdesc
                                     )
            LOOP                                                         --{c4
               BEGIN
                  l_error_location :=
                              'view columns metadata - concatenated columns ';
                  l_column_position := l_column_position + 0.1;
                  l_column_expr :=
                     (CASE
                         WHEN r4.concatenation_type = 'VAL'
                            THEN REPLACE (r4.source_expression,
                                          '~',
                                          r1.table_alias
                                         )
                         ELSE r4.source_expression
                      END
                     );

                  --Column descriptions logic
                  IF     r4.concatenation_type = 'VAL'
                     AND (   (    r3_1.kff_processing_type = 'SINGLE'
                              AND rec_multi_seg_direct.multi_seg_detected =
                                                                           'Y'
                             )
                          OR (    r3_1.kff_processing_type = 'SOURCED'
                              AND l_md_struct_constraint_type = 'SINGLE'
                              AND rec_multi_seg_direct.multi_seg_detected =
                                                                           'Y'
                             )
                         )
                  THEN
                     BEGIN
                        SELECT    'List of segment names for '
                               || str.structure_name
                               || ' structure is "'
                               || ccat.source_expression
                               || '".'
                          INTO l_col_description
                          FROM n_f_kff_concatenations ccat,
                               n_f_kff_structures str
                         WHERE ccat.data_table_key = r1.data_table_key
                           AND str.data_table_key = ccat.data_table_key
                           AND ccat.concatenation_type = 'LIST'
                           AND str.id_flex_num = rec_kff_struct.structure_id
                           AND ccat.id_flex_num = str.id_flex_num;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           NULL;
                     END;
                  ELSE
                     l_col_description :=
                        (CASE
                            WHEN r4.concatenation_type = 'LIST'
                               THEN n_gseg_utility_pkg.g_kff_coldesc_segnl_sfx
                            WHEN r4.concatenation_type = 'VAL'
                               THEN n_gseg_utility_pkg.g_kff_coldesc_cv_sfx
                            WHEN r4.concatenation_type = 'DESC'
                               THEN n_gseg_utility_pkg.g_kff_coldesc_cd_sfx
                         END
                        );
                     l_col_description :=
                           r1.description
                        || ' '
                        || REPLACE (l_col_description,
                                    '<flexfield>',
                                    r2.kff_name
                                   );
                  END IF;

                  l_column_name := r4.target_column_name;

                  l_column_name :=
                                  l_column_name_prefix || '$' || l_column_name;

                  l_column_type :=
                     (CASE
                         WHEN r4.concatenation_type = 'VAL'
                            THEN 'GENEXPR'
                         ELSE 'CONST'
                      END
                     );
                  l_column_property_type :=
                     (CASE
                         WHEN r4.concatenation_type = 'VAL'
                            THEN 'CONCATENATED_VALUES'
                         WHEN r4.concatenation_type = 'DESC'
                            THEN 'CONCATENATED_DESCRIPTIONS'
                         WHEN r4.concatenation_type = 'LIST'
                            THEN 'SEGMENT_NAME_LIST'
                      END
                     );

                  IF ( r1.no_of_str > 1 ) THEN
                    IF ( r4.concatenation_type = 'VAL' ) THEN
                      l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                        ||' THEN '||l_column_expr ||' ELSE NULL END';
                    ELSE
                      l_column_type := 'GENEXPR';
                      l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                          ||' THEN '''||r4.source_expression||''' ELSE NULL END';
                    END IF;
                  END IF;
                  

                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => l_column_type,
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id);

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.t_column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => NULL,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                     );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                                    --}c4

---Individual segment columns
            FOR r6 IN c6 (r1.data_table_key,
                          rec_kff_struct.structure_id,
                          col_prop_rec.include_indiv_seg_val,
                          col_prop_rec.include_indiv_seg_desc,
                          col_prop_rec.include_concat_seg_val,
                          col_prop_rec.include_concat_seg_desc,
                          rec_multi_seg_direct.multi_seg_detected, 
                          l_md_struct_constraint_type,
                          l_column_name_prefix
                         )
            LOOP                                                         --{c6
               BEGIN
                  l_error_location  := 'view columns metadata - individual columns ';
                  l_column_position := l_column_position + 0.1;
                  g_segment_name    := NULL;
                  l_col_description :=( CASE
                                          WHEN ( SUBSTRB(r6.target_column_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                               THEN n_gseg_utility_pkg.g_kff_coldesc_sv_sfx
                                          ELSE n_gseg_utility_pkg.g_kff_coldesc_sd_sfx
                                        END );
                     

                  --Derive the segment name to add it into column description
                  BEGIN 



                  select seg.segment_name 
                    INTO g_segment_name 
                    from ( SELECT s.segment_name
                             FROM n_f_kff_segments s
                            WHERE s.data_table_key     = r1.data_table_key
                              AND s.target_column_name = r6.target_column_name
                            order by s.segment_name ) seg
                   where rownum = 1; 


                  EXCEPTION
                     WHEN OTHERS THEN
                        g_segment_name := NULL;
                  END;
                  
                  


                  l_col_description :=
                        r1.description
                     || ' '
                     || REPLACE (REPLACE (l_col_description,
                                          '<segment>',
                                          g_segment_name
                                         ),
                                 '<flexfield>',
                                 r2.kff_name
                                );

          l_column_exists := 0;
                  l_column_name := r6.formatted_target_column_name;

          IF r6.dup_col_cnt > 1 THEN
               IF r6.sub_script > 1 THEN
                   l_column_name := n_gseg_utility_pkg.format_kff_segment(l_column_name||r6.sub_script,30);
               END IF;

                  SELECT COUNT (*)
                    INTO l_column_exists
                    FROM n_view_columns
                   WHERE view_name = r1.view_name
                     AND column_name = l_column_name
                     AND query_position = r1.query_position;

          END IF;

                  l_column_property_type    := ( CASE
                                                   WHEN ( SUBSTRB(r6.target_column_name, 1, 2) = n_gseg_utility_pkg.g_kff_dc_seg_val_pfx )
                                                        THEN 'SEGMENT_VALUE'
                                                   ELSE 'SEGMENT_DESCRIPTION'
                                                 END );

          IF ( r1.no_of_str > 1 ) THEN
             l_column_type := 'GENEXPR';
             l_column_expr := 'CASE WHEN '||r1.table_alias||'.id_flex_num = '|| rec_kff_struct.structure_id
                                          ||' THEN '||r1.table_alias||'.'||r6.application_column_name||' ELSE NULL END';

          ELSE
             l_column_type := 'GEN';
             l_column_expr := r6.application_column_name;
          END IF;

          IF ( l_column_exists = 0 ) THEN
                  n_gseg_utility_pkg.insert_view_column
                       (i_t_column_id                 => r1.t_column_id,
                        i_view_name                   => r1.view_name,
                        i_view_label                  => r1.view_label,
                        i_query_position              => r1.query_position,
                        i_column_name                 => l_column_name,
                        i_column_label                => r1.column_label,
                        i_table_alias                 => r1.table_alias,
                        i_column_expression           => l_column_expr,
                        i_column_position             => l_column_position,
                        i_column_type                 => l_column_type,
                        i_description                 => l_col_description,
                        i_ref_lookup_column_name      => NULL,
                        i_group_by_flag               => r1.group_by_flag,
                        i_application_instance        => r1.application_instance,
                        i_gen_search_by_col_flag      => 'N',
                        i_generated_flag              => 'Y',
                        i_id_flex_application_id      => r1.id_flex_application_id,
                        i_id_flex_code                => r1.id_flex_code,
                        o_column_id                   => l_column_id);

                  n_gseg_utility_pkg.insert_view_col_prop
                           (i_view_name                        => r1.view_name,
                            i_view_label                       => r1.view_label,
                            i_query_position                   => r1.query_position,
                            i_source_pk_id                     => l_column_id,
                            i_t_source_pk_id                   => r1.column_id,
                            i_property_type                    => l_column_property_type,
                            i_value1                           => g_segment_name,
                            i_value2                           => NULL,
                            i_value3                           => NULL,
                            i_value4                           => NULL,
                            i_value5                           => NULL,
                            i_profile_option                   => NULL,
                            i_omit_flag                        => NULL,
                            o_view_property_id                 => l_view_property_id                    );
                 END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           r1.view_name
                        || '~'
                        || r1.query_position
                        || '~'
                        || l_column_name
                        || '~'
                        || r1.data_table_key
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END LOOP;                                        -- end of c6 loop
         END LOOP;                               -- end of kff_struct_cur loop
      END LOOP;                                               --end of c1 loop

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'flexsource_direct',
                                                      l_error_location,
                                                      l_status,
                                                      l_error_msg,
                                                      sysdate,
                                                     gc_process_type
                                                     );
         raise_application_error (-20001, l_error_msg);
   END flexsource_direct;

--
---------------------------------------------------------------------
--
-- Procedure Name: answer_int
--
-- Description 
--   For all the global view answers having seg related columns will be processed through this script
--   Populates the Global seg related metadata into non-template tables of answers.
--   The procedure will process parameters related to seg columns.
--   The procedure will also handle SEG%JOIN% answer columns.
--
--   Input parameters:
--      None
--
---------------------------------------------------------------------
   PROCEDURE answer_int
   IS
      l_error_msg                   VARCHAR2 (2000)                   := NULL;
      l_status                      VARCHAR2 (30)                     := NULL;
      l_error_location              VARCHAR2 (200)                    := NULL;
      l_success_status              VARCHAR2 (30)                := 'SUCCESS';
      l_error_status                VARCHAR2 (1000)                := 'ERROR';
      l_error_number                NUMBER                            := NULL;
      l_column_exists               NUMBER;
      l_script_name                 VARCHAR2 (100)
                                                := 'n_gseg_integration_incr_pkg';

      l_ans_col_desc                n_ans_columns.description%TYPE;
      l_counter                     NUMBER                               := 0;
      l_param_counter               NUMBER                               := 0;
      l_column_title                n_ans_columns.column_title%TYPE      := NULL;
      l_ans_column_id               n_ans_columns.ans_column_id%TYPE     := NULL;
      l_parameter_prompt            n_ans_params.parameter_prompt%TYPE
                                                                         := NULL;
      l_max_from_clause_position    NUMBER;
      l_max_where_clause_position   NUMBER;
      l_ans_tab_alias_ctr           INTEGER                              := 0;
      l_ans_tab_alias               n_ans_tables.table_alias%TYPE        := NULL;
      l_lov_column_name             n_view_columns.column_name%TYPE      := NULL;
      

      --initializing the operator and mandatory to default values of "contains" and "Y"
      l_operator                    n_ans_param_templates.OPERATOR%TYPE := 'contains';
      l_mandatory_flag              n_ans_param_templates.mandatory_flag%TYPE := 'Y';
      

      l_outer_join_flag             VARCHAR2(10) := NULL;

--Cursor to retrieve only the answer columns having the column_type as SEG%
      CURSOR cur_ans_seg_cols IS
      SELECT ac.view_label,     ac.view_name,         at.table_name view_name_actual,
             ac.column_label,   ac.column_title,      ac.column_type,
             ac.ans_column_id,  ac.t_ans_column_id,   ac.description ans_column_desc,
             ac.answer_id,      ac.t_answer_id,       ac.question_id,
             ac.query_position, ac.table_alias,       ac.lov_view_label,
             v1.view_name       lov_view_name
        FROM n_ans_columns_view  ac,
             n_views             v,
             n_views             v1,
             n_ans_tables_view   at
       WHERE ac.column_type          LIKE 'SEG%'
         AND ac.view_name               = v.view_name
         AND at.view_name               = v.view_name
         AND ac.answer_id               = at.answer_id
         AND ac.query_position          = at.query_position
         AND ac.table_alias             = at.table_alias
         AND v.application_instance     = 'G0'
         AND NVL(ac.omit_flag, 'N')     = 'N'
         AND ac.lov_view_label          = v1.view_label(+)
         AND v1.application_instance(+) = 'G0'
		   AND exists (select 1 from n_to_do_views_incr where view_label=v.view_label)
         AND NVL(v1.omit_flag(+), 'N')  = 'N';

      --Cursor to retrieve the global seg generated columns from column properties table
      --this cursor will get the counts of the
      CURSOR cur_col_properties( p_view_name    VARCHAR2, 
                                 p_column_label VARCHAR2 ) IS
      SELECT COUNT( CASE pt.property_type
                      WHEN 'CONCATENATED_DESCRIPTIONS'  THEN 1
                      ELSE NULL
                    END )                                       vc_includes_concat_seg_desc,
             COUNT( CASE pt.property_type
                      WHEN 'CONCATENATED_VALUES'        THEN 1
                      ELSE NULL
                    END )                                       vc_includes_concat_seg_val,
             COUNT( CASE pt.property_type
                      WHEN 'SEGMENT_DESCRIPTION'        THEN 1
                      ELSE NULL 

                    END )                                       vc_includes_indiv_seg_desc,
             COUNT( CASE pt.property_type
                      WHEN 'SEGMENT_VALUE'              THEN 1
                      ELSE NULL
                    END )                                       vc_includes_indiv_seg_val,
             COUNT( CASE pt.property_type
                      WHEN 'STRUCTURE_NAME'             THEN 1
                      ELSE NULL
                    END )                                       vc_includes_structure_name,
             COUNT( CASE pt.property_type
                      WHEN 'SEGMENT_NAME_LIST'          THEN 1
                      ELSE NULL
                    END )                                       vc_includes_seg_name_list,
             COUNT( CASE pt.property_type
                      WHEN 'QUALIFIER_VALUE'            THEN 1
                      ELSE NULL
                    END )                                       vc_includes_qualifier_val,
             COUNT( CASE pt.property_type
                      WHEN 'QUALIFIER_DESCRIPTION'      THEN 1
                      ELSE NULL
                    END )                                       vc_includes_qualifier_desc,
             COUNT( CASE pt.property_type
                      WHEN 'PRIMARY_KEY'                THEN 1
                      ELSE NULL
                    END )                                       vc_includes_primary_key
        FROM n_view_columns            c,
             n_view_properties         colp,
             n_property_type_templates pt
       WHERE c.application_instance      = 'G0'
         AND c.view_name                 = p_view_name
         AND c.column_label              = p_column_label
         AND colp.view_name              = p_view_name
         AND colp.source_pk_id           = c.column_id
         AND colp.view_name              = c.view_name
		 and c.application_instance='G0'
	   AND exists (select 1 from n_to_do_views_incr where view_label=c.view_label)
         AND colp.query_position         = c.query_position
         AND pt.property_type_id         = colp.property_type_id
         AND pt.templates_table_name     = 'N_VIEW_COLUMN_TEMPLATES'
         AND NVL(colp.value5,'XXX')     != 'LEGACY'
         AND NVL(colp.omit_flag, 'N')    = 'N'
         AND c.query_position            =
           (                              -- Only do 1st query in view
             SELECT TO_NUMBER (v.first_active_query_position)
               FROM n_views v
              WHERE v.view_name           = colp.view_name
                AND NVL(v.omit_flag, 'N') = 'N');

      rec_col_prop                  cur_col_properties%ROWTYPE;

      --Retreive the generated global seg columns
      CURSOR cur_view_gseg_cols ( p_view_name                     VARCHAR2,
                                  p_ans_column_label              VARCHAR2,
                                  p_ans_column_type               VARCHAR2,
                                  p_vc_includes_indiv_seg_val     NUMBER,
                                  p_vc_includes_qualifier_val     NUMBER,
                                  p_vc_includes_structure_name    NUMBER,
                                  p_vc_includes_seg_name_list     NUMBER,
                                  p_vc_includes_concat_seg_val    NUMBER,
                                  p_vc_includes_concat_seg_desc   NUMBER,
                                  p_vc_includes_indiv_seg_desc    NUMBER,
                                  p_vc_includes_qualifier_desc    NUMBER      )      IS
      SELECT col.t_column_id        view_t_column_id,
             col.column_id          view_column_id,
             col.column_name        view_column_name,
             col.column_label       view_column_label,
             col.column_type        view_column_type,
             col.column_expression  view_column_expr,
             col.description        view_column_desc,
             col.description        view_tmpl_col_desc,
             vt.table_name          view_table_name,
             vt.metadata_table_name view_metadata_table_name,
             col.id_flex_code
        FROM n_view_properties          colp,
             n_view_columns             col,
             n_view_tables              vt,
             n_property_type_templates  pt
       WHERE colp.view_name             = col.view_name
         AND colp.query_position        = col.query_position
         AND colp.source_pk_id          = col.column_id
         AND pt.property_type_id        = colp.property_type_id
         AND pt.templates_table_name    = 'N_VIEW_COLUMN_TEMPLATES'
         AND NVL(colp.value5,'XXX')    != 'LEGACY'
         AND vt.view_name               = col.view_name
         AND vt.query_position          = col.query_position
         AND vt.table_alias             = col.table_alias
         AND col.column_type         LIKE 'GEN%'
         AND col.column_label           = p_ans_column_label
         AND col.view_name              = p_view_name
         AND col.query_position         =
           (                              -- Only do 1st query in view
             SELECT TO_NUMBER (v.first_active_query_position)
               FROM n_views v
              WHERE v.view_name           = colp.view_name
                AND NVL(v.omit_flag, 'N') = 'N' )
         AND ( CASE
                 WHEN (     p_vc_includes_structure_name = 0
                        AND pt.property_type             = 'STRUCTURE_NAME' )       THEN NULL
                 WHEN (     p_vc_includes_seg_name_list  = 0
                        AND pt.property_type             = 'SEGMENT_NAME_LIST' )    THEN NULL
                 WHEN ( pt.property_type                 = 'PRIMARY_KEY' )          THEN NULL
                 WHEN (    (     p_vc_includes_concat_seg_val  > 0
                             AND p_vc_includes_concat_seg_desc = 0 )
                        OR (     p_vc_includes_indiv_seg_val   > 0
                             AND p_vc_includes_indiv_seg_desc  = 0 )
                        OR (     p_vc_includes_qualifier_val   > 0
                             AND p_vc_includes_qualifier_desc  = 0 ) )              THEN 
                                ( CASE
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND pt.property_type            = 'QUALIFIER_VALUE' )    THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND p_vc_includes_indiv_seg_val > 1
                                           AND pt.property_type            = 'SEGMENT_VALUE' )      THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                     'SEGI_JOIN_ADD_INDIV')
                                           AND p_vc_includes_indiv_seg_val = 0
                                           AND pt.property_type            = 'CONCATENATED_VALUE' ) THEN NULL
                                    ELSE 1
                                  END )
                 WHEN (    p_vc_includes_concat_seg_desc > 0
                        OR p_vc_includes_indiv_seg_desc  > 0
                        OR p_vc_includes_qualifier_desc  > 0  )                 THEN 
                                ( CASE
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND pt.property_type          = 'QUALIFIER_VALUE' )          THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND pt.property_type          = 'QUALIFIER_DESCRIPTION' )    THEN NULL
                                    WHEN (     (    p_ans_column_type NOT IN ('SEGD', 'SEGD_JOIN',
                                                                              'SEGD_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                                 OR p_ans_column_type IN ('SEG', 'SEG_JOIN',
                                                                          'SEG_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                          'SEGI_JOIN_ADD_INDIV') )
                                           AND pt.property_type          = 'QUALIFIER_DESCRIPTION' )    THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                           AND p_vc_includes_indiv_seg_val > 1
                                           AND pt.property_type          = 'SEGMENT_VALUE' )            THEN NULL
                                    WHEN (     p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                     'SEGI_JOIN_ADD_INDIV')
                                           AND p_vc_includes_indiv_seg_val > 0
                                           AND pt.property_type            = 'CONCATENATED_VALUE' )     THEN NULL
                                    WHEN (     (    p_ans_column_type NOT IN ('SEGD', 'SEGD_JOIN',
                                                                              'SEGD_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                                 OR p_ans_column_type IN ('SEG', 'SEG_JOIN',
                                                                          'SEG_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                          'SEGI_JOIN_ADD_INDIV') )
                                           AND pt.property_type = 'CONCATENATED_DESCRIPTIONS' )         THEN NULL
                                    WHEN (     (    p_ans_column_type NOT IN ('SEGD', 'SEGD_JOIN',
                                                                              'SEGD_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGCAT', 'SEGCAT_JOIN')
                                                 OR p_ans_column_type IN ('SEG', 'SEG_JOIN',
                                                                          'SEG_JOIN_ADD_INDIV')
                                                 OR p_ans_column_type IN ('SEGI', 'SEGI_JOIN',
                                                                          'SEGI_JOIN_ADD_INDIV') )
                                           AND p_vc_includes_indiv_seg_desc > 0
                                           AND pt.property_type             = 'SEGMENT_DESCRIPTION' )   THEN NULL
                                    ELSE 1
                                  END )
                 END )      = 1;

--Retreive the answer parameters for seg columns
      CURSOR cur_answer_paramters ( p_view_name                    VARCHAR2,
                                    p_answer_id                    NUMBER,
                                    p_query_position               NUMBER,
                                    p_ans_column_label             VARCHAR2,
                                    p_t_ans_column_id              INTEGER,
                                    p_vc_includes_indiv_seg_val    NUMBER,
                                    p_vc_includes_qualifier_val    NUMBER,
                                    p_vc_includes_structure_name   NUMBER,
                                    p_vc_includes_concat_seg_val   NUMBER   ) IS
         SELECT pt.t_param_id, 
                q.question_id, 
                q.answer_id, 
                q.query_position,
                ptyp.property_type,
                COUNT (*) OVER ( PARTITION BY pt.t_param_id,    q.question_id, 
                                              q.answer_id,      q.query_position ) gen_col_count,
                pt.param_position, 
                c.ans_column_id, 
                c.column_title, 
                pt.operator,
                pt.having_flag, 
                NVL(pt.and_or, 'AND')                                               and_or,       -- and_or
                pt.mandatory_flag, 
                pt.param_filter_type, 
                pt.processing_code,
                pt.profile_option, 
                col.column_id                                                       view_column_id,
                col.t_column_id                                                     view_t_column_id,
                col.column_name                                                     view_column_name,
                col.column_label                                                    view_column_label,
                col.column_type                                                     view_column_type,
                col.column_expression                                               view_column_expr,
                col.description                                                     view_column_desc,
                col.description                                                     view_tmpl_col_desc,
                vt.table_name                                                       view_table_name,
                vt.metadata_table_name                                              view_metadata_table_name
           FROM n_answers                   a,
                n_ans_queries               q,
                n_ans_param_templates       pt,
                n_view_properties           colp,
                n_property_type_templates   ptyp,
                n_ans_columns_view          c,
                n_view_columns              col,
                n_view_tables               vt
          WHERE a.t_answer_id               = pt.t_answer_id
            AND a.answer_id                 = q.answer_id
            AND pt.t_ans_column_id          = p_t_ans_column_id
            AND q.query_position            = pt.query_position
            AND a.answer_id                 = p_answer_id
            AND NVL(pt.include_flag, 'Y')   = 'Y'
            AND NVL(a.omit_flag, 'N')       = 'N'
            AND NVL(q.omit_flag, 'N')       = 'N'
            AND colp.view_name              = col.view_name
            AND colp.query_position         = col.query_position
            AND colp.source_pk_id           = col.column_id
            AND ptyp.property_type_id       = colp.property_type_id
            AND ptyp.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
            AND NVL(colp.value5,'XXX')     != 'LEGACY'
            AND vt.view_name                = col.view_name
            AND vt.query_position           = col.query_position
            AND vt.table_alias              = col.table_alias
            AND col.column_type          LIKE 'GEN%'
            AND c.view_name(+)              = col.view_name
            AND c.t_ans_column_id(+)        = p_t_ans_column_id
            AND c.query_position(+)         = p_query_position
            AND c.column_label(+)           = col.column_label
            AND c.answer_id(+)              = p_answer_id
            AND c.column_expression(+)      = col.column_name
            AND col.view_name               = p_view_name
            AND colp.view_name              = p_view_name
            AND col.column_label            = p_ans_column_label
            AND colp.query_position         =
              (                              -- Only do 1st query in view
                SELECT TO_NUMBER (v.first_active_query_position)
                  FROM n_views v
                 WHERE v.view_name            = colp.view_name
                   AND NVL (v.omit_flag, 'N') = 'N')
            AND (    (     processing_code = 'I'
                       AND ( CASE
                               WHEN (     p_vc_includes_indiv_seg_val = 0
                                      AND ptyp.property_type          = 'CONCATENATED_VALUES' )      THEN 1
                               WHEN (     p_vc_includes_indiv_seg_val > 0
                                      AND ptyp.property_type          = 'SEGMENT_VALUE' )            THEN 1
                               WHEN (     p_vc_includes_qualifier_val > 0
                                      AND ptyp.property_type          = 'QUALIFIER_VALUE' )          THEN 1
                               WHEN (     p_vc_includes_structure_name > 0
                                      AND ptyp.property_type          = 'STRUCTURE_NAME'  )          THEN 1
                               ELSE NULL
                             END )        = 1 )
                  OR (     processing_code = 'C'
                       AND ( CASE
                               WHEN (     p_vc_includes_concat_seg_val  > 0
                                      AND ptyp.property_type            = 'CONCATENATED_VALUES' )    THEN 1
                               WHEN (     p_vc_includes_indiv_seg_val   = 1
                                      AND p_vc_includes_concat_seg_val  = 0
                                      AND ptyp.property_type            = 'SEGMENT_VALUE')           THEN 1
                               WHEN (     p_vc_includes_qualifier_val   > 0
                                      AND ptyp.property_type            = 'QUALIFIER_VALUE' )        THEN 1
                               WHEN (     p_vc_includes_structure_name  > 0
                                      AND ptyp.property_type            = 'STRUCTURE_NAME' )         THEN 1
                               ELSE NULL
                             END  )        = 1 ) );

      --Identify the kff view and related join conditions from n_join_keys table based on the view and column label
      CURSOR cur_xxk_table_joins ( p_view_name           VARCHAR2,
                                   p_view_column_label   VARCHAR2,
                                   p_column_type         VARCHAR2 ) IS
      SELECT DISTINCT 
             v.view_name, 
             k.view_name            xxk_view_name,
             vc.column_name         glb_view_join_col,
             kc.column_name         xxk_view_join_col,
             k_v.application_label  xxk_app_label, 
             'dcv'                  table_alias,
             v.outerjoin_flag
        FROM n_join_keys        v,
             n_join_key_columns vc,
             n_join_keys        k,
             n_views            k_v,
             n_join_key_columns kc
       WHERE v.column_type_code             = 'ROWID'
         AND v.referenced_pk_join_key_id    = k.join_key_id
         AND k_v.view_name                  = k.view_name
         AND vc.join_key_id                 = v.join_key_id
         AND vc.column_position             = 1
         AND kc.join_key_id                 = k.join_key_id
         AND kc.column_position             = 1
         AND v.view_name                    = p_view_name
         AND vc.column_name              LIKE '%' || k.view_label
         -- NOTE:  This should be the same column label used by the seg column
         AND vc.column_label                = p_view_column_label
         AND p_column_type               LIKE 'SEG%JOIN%';
   BEGIN
      l_error_location := l_script_name || '-start processing';

      FOR rec_ac IN cur_ans_seg_cols LOOP
         l_counter := 0;

         --column properties data
         OPEN cur_col_properties( rec_ac.view_name_actual,
                                  rec_ac.column_label   );

         FETCH cur_col_properties
          INTO rec_col_prop;

         CLOSE cur_col_properties;

         FOR rec_vc IN
            cur_view_gseg_cols( rec_ac.view_name_actual,
                                rec_ac.column_label,
                                rec_ac.column_type,
                                rec_col_prop.vc_includes_indiv_seg_val,
                                rec_col_prop.vc_includes_qualifier_val,
                                rec_col_prop.vc_includes_structure_name,
                                rec_col_prop.vc_includes_seg_name_list,
                                rec_col_prop.vc_includes_concat_seg_val,
                                rec_col_prop.vc_includes_concat_seg_desc,
                                rec_col_prop.vc_includes_indiv_seg_desc,
                                rec_col_prop.vc_includes_qualifier_desc  ) LOOP
            l_counter := l_counter + 1;
            -- Create the description
            l_ans_col_desc := SUBSTRB (rec_vc.view_column_desc, 1, 240);

            BEGIN
               SELECT c1.column_name
                 INTO l_lov_column_name
                 FROM n_view_columns            c1, 
                      n_view_properties         colp,
                      n_property_type_templates pt
                WHERE c1.view_name              = rec_ac.lov_view_name
                  AND c1.view_name              = colp.view_name
                  AND c1.query_position         = colp.query_position
                  AND c1.column_id              = colp.source_pk_id
                  AND pt.property_type_id       = colp.property_type_id
                  AND pt.templates_table_name   = 'N_VIEW_COLUMN_TEMPLATES'
                  AND (CASE
                          WHEN (     pt.property_type = ('CONCATENATED_VALUES')
                                 AND rec_vc.view_column_name LIKE
                                         '%$' || n_gseg_utility_pkg.g_kff_dc_concat_val_pfx || '$%' ) THEN 1
                          WHEN (     pt.property_type = ('CONCATENATED_DESCRIPTIONS')
                                 AND rec_vc.view_column_name LIKE
                                         '%$' || n_gseg_utility_pkg.g_kff_dc_concat_desc_pfx || '$%' ) THEN 1
                          WHEN ( SUBSTRB (SUBSTRB (c1.column_name,
                                                   INSTR (c1.column_name,
                                                          '$',
                                                          1,
                                                          1
                                                         )
                                                 + 1
                                                ),
                                        1,
                                        LEAST (  30
                                               - INSTR (c1.column_name,
                                                        '$',
                                                        1,
                                                        1
                                                       ),
                                                 30
                                               - INSTR
                                                     (rec_vc.view_column_name,
                                                      '$',
                                                      1,
                                                      1
                                                     )
                                              )
                                       ) =
                                 SUBSTRB
                                    (SUBSTRB (rec_vc.view_column_name,
                                                INSTR
                                                     (rec_vc.view_column_name,
                                                      '$',
                                                      1,
                                                      1
                                                     )
                                              + 1
                                             ),
                                     1,
                                     LEAST (  30
                                            - INSTR (c1.column_name, '$', 1,
                                                     1),
                                              30
                                            - INSTR (rec_vc.view_column_name,
                                                     '$',
                                                     1,
                                                     1
                                                    )
                                           )
                                    ) )                              THEN 1
                          ELSE 0
                       END                      ) = 1
                  AND c1.query_position =
                    (                        -- Only do 1st query in view
                      SELECT TO_NUMBER (v.first_active_query_position)
                        FROM n_views v
                       WHERE v.view_name            = c1.view_name
                         AND NVL(v.omit_flag, 'N')  = 'N');
            EXCEPTION
               WHEN OTHERS THEN
                  l_lov_column_name := NULL;
            END;

            IF (l_counter = 1)  THEN      -- {
               l_ans_tab_alias_ctr := 0;

               FOR rec_tabjoin IN cur_xxk_table_joins( rec_ac.view_name_actual,
                                                       rec_ac.column_label,
                                                       rec_ac.column_type )    LOOP
                  BEGIN
                     l_error_location := 'Inserting KFF view into n_ans_tables';

                     SELECT MAX (from_clause_position)
                       INTO l_max_from_clause_position
                       FROM n_ans_tables
                      WHERE answer_id = rec_ac.answer_id
                        AND query_position = rec_ac.query_position;

                     SELECT COUNT (*)
                       INTO l_ans_tab_alias_ctr
                       FROM n_ans_tables
                      WHERE answer_id = rec_ac.answer_id
                        AND query_position = rec_ac.query_position
                        AND RTRIM (TRANSLATE (UPPER (table_alias),
                                        '1234567890',
                                        '      '
                                      )) = UPPER (rec_vc.id_flex_code);
                        

                     l_ans_tab_alias_ctr := l_ans_tab_alias_ctr + 1;
                     l_ans_tab_alias := rec_vc.id_flex_code || l_ans_tab_alias_ctr;

                     INSERT INTO n_ans_tables
                          ( answer_id, 

                            query_position,
                            table_alias, 

                            question_id,
                            from_clause_position, 
                            application_label,
                            table_name,
                            view_application_label, 
                            profile_option,
                            omit_flag, 
                            created_by, 


                            creation_date )
                     VALUES 

                          ( rec_ac.answer_id, 
                            rec_ac.query_position,
                            l_ans_tab_alias, 
                            rec_ac.question_id,
                            l_max_from_clause_position + 1,       -- from_clause_position
                            'NOETIX',                             -- application_label
                            rec_tabjoin.xxk_view_name,            -- table name
                            rec_tabjoin.xxk_app_label,            -- view app label
                            NULL,                                 -- profile option
                            NULL,                                 -- omit_flag
                            'NOETIX',                             -- created_by
                            SYSDATE );                            -- creation_date

                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_ac.view_name
                           || '~'
                           || rec_ac.t_answer_id
                           || '~'
                           || rec_tabjoin.xxk_view_name
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;

                  BEGIN
                     l_error_location := 'Adding a new join condtion for kff view into n_ans_wheres';

                      l_outer_join_flag := (CASE WHEN rec_tabjoin.outerjoin_flag = 'Y' THEN '(+)' ELSE NULL END);

                     SELECT NVL (MAX (where_clause_position), 10)
                       INTO l_max_where_clause_position
                       FROM n_ans_wheres
                      WHERE answer_id = rec_ac.answer_id
                        AND query_position = rec_ac.query_position;

                     INSERT INTO n_ans_wheres
                                 (answer_id, query_position,
                                  where_clause_position,
                                  question_id,
                                  where_clause,
                                  variable_exists_flag, profile_option,
                                  omit_flag, created_by, creation_date
                                 )
                          VALUES (rec_ac.answer_id, rec_ac.query_position,
                                  l_max_where_clause_position + 1,
                                  rec_ac.question_id,
                                     'AND '
                                  || rec_ac.table_alias
                                  || '.'
                                  || rec_tabjoin.glb_view_join_col
                                  || ' = '
                                  || l_ans_tab_alias
                                  || '.'
                                  || rec_tabjoin.xxk_view_join_col
                  || l_outer_join_flag,
                                  'N', NULL,                 -- profile option
                                  NULL,                            --omit_flag
                                       'NOETIX',                 -- created_by
                                                SYSDATE       -- creation_date
                                 );
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_ac.view_name
                           || '~'
                           || rec_ac.t_answer_id
                           || '~'
                           || rec_tabjoin.xxk_view_name
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;

                  BEGIN
                     l_error_location :=
                        'Adding answer columns from kkf view to the Global view';

                     INSERT INTO n_ans_columns
                                 (ans_column_id, answer_id, question_id,
                                  query_position, t_ans_column_id, column_label,
                                  column_title, table_alias,
                                  column_expression, column_position,
                                  column_type, column_sub_type, description,
                                  order_by_position, format_mask,
                                  format_class, group_sort_flag,
                                  display_width, horizontal_alignment,
                                  aggregation_type,
                                  aggregation_distinct_flag, page_item_flag,
                                  page_item_position, display_flag,
                                  lov_view_label, lov_view_name,
                                  lov_disp_column_label,
                                  lov_parent_column_label, profile_option,
                                  omit_flag, created_by, creation_date,
                                  mandatory_flag, match_answer_column_string)
                        SELECT n_ans_column_seq.NEXTVAL,         -- ans_column_id
                                                        c.answer_id,
                               c.question_id, c.query_position,
                               c.t_ans_column_id, c.column_label,
                               TRANSLATE (REPLACE (   rec_ac.column_label
                                                   || ' '
                                                   || c1.column_name,
                                                   '$$',
                                                   '$'
                                                  ),
                                          '$_',
                                          '  '
                                         ),                    -- column_title
                               l_ans_tab_alias, c1.column_name,
                               

                               -- column_expression
                               c.column_position + (ROWNUM * .01), 'GEN',
                               

                               -- column_type
                               NULL,
                                    -- column_sub_type
                                    c1.description,             -- description
                                                   NULL,  -- order_by_position
                                                        c.format_mask,
                               c.format_class, c.group_sort_flag,
                               c.display_width, c.horizontal_alignment,
                               c.aggregation_type,
                               c.aggregation_distinct_flag, c.page_item_flag,
                               c.page_item_position, 'Y',       --display flag
                               rec_tabjoin.xxk_view_name,
                               rec_tabjoin.xxk_view_name, c1.column_name,
                               NULL,
                                    --lov_parent_column_label,
                                    c.profile_option, NULL,       -- omit flag
                                                           'NOETIX',
                                                                 -- created_by
                                                                    SYSDATE,
                               

                               -- creation_date
                               c.mandatory_flag, c.match_answer_column_string
                          FROM n_ans_columns c, n_view_columns c1
                         WHERE c.ans_column_id = rec_ac.ans_column_id
					 		   AND exists (select 1 from n_to_do_views_incr where view_label=c1.view_label)
							   and c1.application_instance='G0'
                           AND c1.view_name = rec_tabjoin.xxk_view_name
                           AND c1.query_position =
                                  (               -- Only do 1st query in view
                                   SELECT TO_NUMBER
                                                (v.first_active_query_position)
                                     FROM n_views v
                                    WHERE v.view_name = c1.view_name
                                      AND NVL (v.omit_flag, 'N') = 'N')
                           AND (   (    c1.column_name LIKE
                                               n_gseg_utility_pkg.g_kff_dc_seg_val_pfx || '$%'
                                    AND rec_ac.column_type IN
                                           ('SEG_JOIN_ADD_INDIV',
                                            'SEGI_JOIN_ADD_INDIV')
                                   )
                                OR (    c1.column_name LIKE
                                              n_gseg_utility_pkg.g_kff_dc_seg_desc_pfx || '$%'
                                    AND rec_ac.column_type =
                                                         'SEGD_JOIN_ADD_INDIV'
                                   )
                               );

                     l_counter := l_counter + SQL%ROWCOUNT;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        l_status := l_error_status;
                        l_error_number := SQLCODE;
                        l_error_msg :=
                              rec_ac.view_name
                           || '~'
                           || rec_ac.t_answer_id
                           || '~'
                           || rec_ac.ans_column_id
                           || '~'
                           || SQLERRM (l_error_number);
                        RAISE;
                  END;
               END LOOP;

               -- One column of this set already exists(original seg column)
               -- in n_ans_columns, so all we need to do is update it.
               BEGIN
                  l_error_location :=
                     'update first answer columns from kkf view to the global view';

                  UPDATE n_ans_columns
                     SET column_title =
                            TRANSLATE (REPLACE (rec_vc.view_column_name,
                                                '$$',
                                                '$'
                                               ),
                                       '$_',
                                       '  '
                                      ),
                         column_expression = rec_vc.view_column_name,
                         description = l_ans_col_desc,
                         column_type = 'GEN',
                         lov_view_label = rec_ac.lov_view_label,
                         lov_view_name = rec_ac.lov_view_name,
                         lov_disp_column_label = l_lov_column_name,
                         display_flag = 'Y'
                   WHERE ans_column_id = rec_ac.ans_column_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_ac.view_name
                        || '~'
                        || rec_ac.t_answer_id
                        || '~'
                        || rec_ac.ans_column_id
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            ELSE
               BEGIN
                  l_error_location :=
                     'Insert answer columns from the global view seg columns';

                  INSERT INTO n_ans_columns
                              (ans_column_id, answer_id, question_id,
                               query_position, t_ans_column_id, column_label,
                               column_title, table_alias, column_expression,
                               column_position, column_type, column_sub_type,
                               description, order_by_position, format_mask,
                               format_class, group_sort_flag, display_width,
                               horizontal_alignment, aggregation_type,
                               aggregation_distinct_flag, page_item_flag,
                               page_item_position, display_flag,
                               lov_view_label, lov_view_name,
                               lov_disp_column_label,
                               lov_parent_column_label, profile_option,
                               omit_flag, created_by, creation_date,
                               mandatory_flag, match_answer_column_string)
                     SELECT n_ans_column_seq.NEXTVAL,            -- ans_column_id
                                                     c.answer_id,
                            c.question_id, c.query_position, c.t_ans_column_id,
                            c.column_label,
                            TRANSLATE (REPLACE (rec_vc.view_column_name,
                                                '$$',
                                                '$'
                                               ),
                                       '$_',
                                       '  '
                                      ),                       -- column_title
                            c.table_alias, rec_vc.view_column_name,
                            

                            -- column_expression
                            c.column_position + (l_counter * .01), 'GEN',
                            

                            -- column_type
                            NULL,
                                 -- column_sub_type
                                 l_ans_col_desc,                -- description
                                                NULL,     -- order_by_position
                                                     c.format_mask,
                            c.format_class, c.group_sort_flag,
                            c.display_width, c.horizontal_alignment,
                            c.aggregation_type, c.aggregation_distinct_flag,
                            c.page_item_flag, c.page_item_position, 'Y',
                                                                --display flag
                            rec_ac.lov_view_label, rec_ac.lov_view_name,
                            l_lov_column_name, NULL,
                                                    --lov_parent_column_label,
                                                    c.profile_option, NULL,
                                                                  -- omit flag
                            'NOETIX',                            -- created_by
                                     SYSDATE,
                                             -- creation_date
                                             c.mandatory_flag,
                            c.match_answer_column_string
                       FROM n_ans_columns c
                      WHERE c.ans_column_id = rec_ac.ans_column_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_ac.view_name
                        || '~'
                        || rec_ac.t_answer_id
                        || '~'
                        || rec_vc.view_column_name
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END IF;                               -- } end of the if statement
         END LOOP;                               --  end of cur_view_gseg_cols

         --Insert into answer parameters
         l_param_counter := 0;
         l_ans_col_desc := NULL;

         FOR rec_ans_col IN
            cur_answer_paramters (rec_ac.view_name_actual,
                                  rec_ac.answer_id,
                                  rec_ac.query_position,
                                  rec_ac.column_label,
                                  rec_ac.t_ans_column_id,
                                  rec_col_prop.vc_includes_indiv_seg_val,
                                  rec_col_prop.vc_includes_qualifier_val,
                                  rec_col_prop.vc_includes_structure_name,
                                  rec_col_prop.vc_includes_concat_seg_val
                                 )
         LOOP
            l_counter := l_counter + 1;
            l_param_counter := l_param_counter + 1;
            l_column_title := rec_ans_col.column_title;

            IF rec_ans_col.ans_column_id IS NULL
            THEN
               BEGIN
                  l_error_location :=
                     'Insert required columns in parameters into n_ans_columns which are not available earlier';

                  SELECT n_ans_column_seq.NEXTVAL
                    INTO l_ans_column_id
                    FROM DUAL;

                  l_column_title :=
                     TRANSLATE (REPLACE (rec_ans_col.view_column_name,
                                         '$$',
                                         '$'
                                        ),
                                '$_',
                                '  '
                               );                              -- column_title
                  l_ans_col_desc :=
                                SUBSTRB (rec_ans_col.view_column_desc, 1, 240);

                  BEGIN
                     SELECT column_name
                       INTO l_lov_column_name
                       FROM n_view_columns c1
                      WHERE c1.view_name = rec_ac.lov_view_name
                        AND SUBSTRB
                                  (SUBSTRB (c1.column_name,
                                              INSTR (c1.column_name, '$', 1,
                                                     1)
                                            + 1
                                           ),
                                   1,
                                   LEAST (  30
                                          - INSTR (c1.column_name, '$', 1, 1),
                                            30
                                          - INSTR
                                                (rec_ans_col.view_column_name,
                                                 '$',
                                                 1,
                                                 1
                                                )
                                         )
                                  ) =
                               SUBSTRB
                                  (SUBSTRB
                                        (rec_ans_col.view_column_name,
                                           INSTR
                                                (rec_ans_col.view_column_name,
                                                 '$',
                                                 1,
                                                 1
                                                )
                                         + 1
                                        ),
                                   1,
                                   LEAST (  30
                                          - INSTR (c1.column_name, '$', 1, 1),
                                            30
                                          - INSTR
                                                (rec_ans_col.view_column_name,
                                                 '$',
                                                 1,
                                                 1
                                                )
                                         )
                                  )
                        AND c1.query_position =
                          (                  -- Only do 1st query in view
                            SELECT TO_NUMBER(v.first_active_query_position)
                              FROM n_views v
                             WHERE v.view_name           = c1.view_name
                               AND NVL(v.omit_flag, 'N') = 'N')
                        AND EXISTS 

                          ( SELECT 1
                              FROM n_view_properties            colp,
                                   n_property_type_templates    pt
                             WHERE c1.view_name            = colp.view_name
                               AND c1.query_position       = colp.query_position
                               AND c1.column_id            = colp.source_pk_id
                               AND pt.property_type_id     = colp.property_type_id
                               AND pt.templates_table_name = 'N_VIEW_COLUMN_TEMPLATES' );
                  EXCEPTION
                     WHEN OTHERS THEN
                        l_lov_column_name := NULL;
                  END;

                  --Display will be off for the columns
                  INSERT INTO n_ans_columns
                              (ans_column_id, answer_id, question_id,
                               query_position, t_ans_column_id, column_label,
                               column_title, table_alias, column_expression,
                               column_position, column_type, column_sub_type,
                               description, order_by_position, format_mask,
                               format_class, group_sort_flag, display_width,
                               horizontal_alignment, aggregation_type,
                               aggregation_distinct_flag, page_item_flag,
                               page_item_position, display_flag,
                               lov_view_label, lov_view_name,
                               lov_disp_column_label, lov_parent_column_label,
                               profile_option, omit_flag, created_by,
                               creation_date, mandatory_flag,
                               match_answer_column_string)
                     SELECT l_ans_column_id,                          -- ans_column_id
                                        c.answer_id, c.question_id,
                            c.query_position, c.t_ans_column_id, c.column_label,
                            l_column_title, c.table_alias,
                            rec_ans_col.view_column_name, -- column_expression
                            c.column_position + (l_counter * .01), 'GEN',
                            

                            -- column_type
                            NULL,
                                 -- column_sub_type
                                 l_ans_col_desc,                -- description
                                                NULL,     -- order_by_position
                                                     c.format_mask,
                            c.format_class, c.group_sort_flag,
                            c.display_width, c.horizontal_alignment,
                            c.aggregation_type, c.aggregation_distinct_flag,
                            c.page_item_flag, c.page_item_position, 'N',
                                                                --display flag
                            rec_ac.lov_view_label, rec_ac.lov_view_name,
                            l_lov_column_name, NULL,
                                                    --lov_parent_column_label,
                                                    c.profile_option, NULL,
                                                                  -- omit flag
                            'NOETIX',                            -- created_by
                                     SYSDATE,                 -- creation_date
                                             c.mandatory_flag,
                            c.match_answer_column_string
                       FROM n_ans_columns c
                      WHERE c.ans_column_id = rec_ac.ans_column_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_status := l_error_status;
                     l_error_number := SQLCODE;
                     l_error_msg :=
                           rec_ac.view_name
                        || '~'
                        || rec_ac.t_answer_id
                        || '~'
                        || rec_ans_col.view_column_name
                        || '~'
                        || SQLERRM (l_error_number);
                     RAISE;
               END;
            END IF;

            BEGIN
               l_error_location :=
                           'Insert answer parameters for seg related columns';
               l_parameter_prompt :=
                  SUBSTRB (   'Enter '
                           || l_column_title
                           || (CASE rec_ans_col.OPERATOR
                                  WHEN 'contains'
                                     THEN ' (use % for all)'
                                  ELSE NULL
                               END
                              ),
                           1,
                           80
                          );
               


               INSERT INTO n_ans_params
                           (param_id, t_param_id,
                            question_id, answer_id,
                            query_position,
                            param_position,
                            ans_column_id,
                            parameter_prompt, OPERATOR,
                            having_flag, and_or,
                            mandatory_flag, param_filter_type,
                            processing_code,
                            profile_option, omit_flag, created_by,
                            creation_date
                           )
                    VALUES (n_ans_param_seq.NEXTVAL,               -- param_id
                            rec_ans_col.t_param_id,
                            rec_ans_col.question_id, rec_ans_col.answer_id,
                            rec_ans_col.query_position,
                            rec_ans_col.param_position + (l_counter * .01),
                            NVL (rec_ans_col.ans_column_id, l_ans_column_id),
                            l_parameter_prompt, l_operator,
                            rec_ans_col.having_flag, rec_ans_col.and_or,
                            l_mandatory_flag, rec_ans_col.param_filter_type,
                            rec_ans_col.processing_code,
                            rec_ans_col.profile_option, NULL,     -- omit flag
                            'NOETIX',
                            -- created_by
                            SYSDATE                           -- creation_date
                           );
                           

             --Inserting to parameters default value
                 INSERT INTO n_ans_param_values
                    (param_value_id, question_id,
                     answer_id, query_position,
                     t_param_value_id, param_id, param_value_position,
                     param_value, profile_option, omit_flag, created_by, creation_date
                    )
                  VALUES (n_ans_param_value_seq.NEXTVAL, rec_ans_col.question_id,
                     rec_ans_col.answer_id, rec_ans_col.query_position,
                     -1 , n_ans_param_seq.CURRVAL,
                     10, '%', NULL, NULL, 'NOETIX',
                     SYSDATE
                    );   
 




 
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_status := l_error_status;
                  l_error_number := SQLCODE;
                  l_error_msg :=
                        rec_ac.view_name
                     || '~'
                     || rec_ac.t_answer_id
                     || '~'
                     || rec_ac.t_ans_column_id
                     || '~'
                     || SQLERRM (l_error_number);
                  RAISE;
            END;
         END LOOP;                                     -- cur_answer_paramters
      END LOOP;                                        -- cur_ans_seg_cols


      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         noetix_utility_pkg.add_installation_message (gc_script||'.'||'answer_int',
                                                      l_error_location,
                                                      l_error_status,
                                                      NVL (l_error_msg,
                                                           SQLERRM
                                                          )
                                                      ,
                                                      sysdate,
                                                      gc_process_type
                                                     );
         raise_application_error (-20001, NVL (l_error_msg, SQLERRM));
   END answer_int;
END n_gseg_integration_incr_pkg;
/

show errors;

-- END ycr_gseg_integration_incr_pkg



