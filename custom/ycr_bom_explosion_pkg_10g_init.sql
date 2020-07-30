-- Title
--   noetix_bom_explosion_pkg.sql
-- Function
--   Create the package noetix_bom_explosion_pkg. 
--
-- Description
--   Create the package noetix_bom_explosion_pkg.
--
-- Copyright Noetix Corporation 1992-2014  All Rights Reserved
--
-- History
--   22-Aug-11 U Pisupati   created
--   05-Jan-12 P Upendra      standardized the pl/sql code.
--

@utlspon ycr_bom_explosion_pkg

CREATE OR REPLACE PACKAGE noetix_bom_explosion_pkg AUTHID DEFINER IS
    
    FUNCTION get_version
      RETURN VARCHAR2;

    FUNCTION exploder( i_org_id              IN   NUMBER,
                       i_cst_type_id         IN   NUMBER     DEFAULT 0,
                       i_item_id             IN   NUMBER,
                       i_alt_desg            IN   VARCHAR2   DEFAULT NULL,
                       i_assembly_revision   IN   VARCHAR2   DEFAULT NULL    )
      RETURN xxnao_bom_explosion_tbl PIPELINED;
END noetix_bom_explosion_pkg;
/
show errors

CREATE OR REPLACE PACKAGE BODY noetix_bom_explosion_pkg AS
    --
    gc_pkg_version   CONSTANT VARCHAR2(30)  := '6.4.1.1433';
    --
    gc_script        CONSTANT VARCHAR2(200)     := 'noetix_bom_explosion_pkg';
    gc_user          CONSTANT VARCHAR2(30)      := user;
    gc_language      CONSTANT VARCHAR2(30)      := NOETIX_ENV_PKG.GET_LANGUAGE;
    gc_sortwidth     CONSTANT BINARY_INTEGER    := 7;
    --
    gs_location      VARCHAR2(200)              := NULL;
    gs_error_text    VARCHAR2(200)              := NULL;
    gb_debug_flag    BOOLEAN                    := false;

   TYPE xxnao_bom_explosion_rec IS RECORD (
      top_bill_sequence_id          NUMBER,
      bill_sequence_id              NUMBER,
      organization_id               NUMBER,
      component_sequence_id         NUMBER,
      component_item_id             NUMBER,
      component_quantity            NUMBER,
      plan_level                    NUMBER,
      extended_quantity             NUMBER,
      sort_order                    VARCHAR2(2000 BYTE),
      top_alternate_designator      VARCHAR2(10 BYTE),
      component_yield_factor        NUMBER,
      top_item_id                   NUMBER,
      component_code                VARCHAR2(4000 BYTE),
      include_in_rollup_flag        NUMBER,
      loop_flag                     NUMBER,
      planning_factor               NUMBER,
      operation_seq_num             NUMBER,
      bom_item_type                 NUMBER,
      parent_bom_item_type          NUMBER,
      assembly_item_id              NUMBER,
      wip_supply_type               NUMBER,
      item_num                      NUMBER,
      effectivity_date              DATE,
      disable_date                  DATE,
      from_end_item_unit_number     VARCHAR2 (30 BYTE),
      to_end_item_unit_number       VARCHAR2 (30 BYTE),
      implementation_date           DATE,
      optional                      NUMBER,
      supply_subinventory           VARCHAR2 (10 BYTE),
      supply_locator_id             NUMBER,
      component_remarks             VARCHAR2 (240 BYTE),
      change_notice                 VARCHAR2 (10 BYTE),
      operation_lead_time_percent   NUMBER,
      mutually_exclusive_options    NUMBER,
      check_atp                     NUMBER,
      required_to_ship              NUMBER,
      required_for_revenue          NUMBER,
      include_on_ship_docs          NUMBER,
      low_quantity                  NUMBER,
      high_quantity                 NUMBER,
      so_basis                      NUMBER,
      operation_offset              NUMBER,
      current_revision              VARCHAR2 (3 BYTE),
      LOCATOR                       VARCHAR2 (40 BYTE),
      item_cost                     NUMBER,
      item_structure                VARCHAR2 (4000),
      actual_cost_type_id           NUMBER,
      extend_cost_flag              NUMBER
   );

   TYPE xxnao_bom_explosion_table IS TABLE OF xxnao_bom_explosion_rec
      INDEX BY BINARY_INTEGER;

   gtab_bom_explosion_table        xxnao_bom_explosion_table;

   TYPE ltyp_number_tab IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE ltyp_varchar_tab IS TABLE OF VARCHAR2 (4000)
      INDEX BY BINARY_INTEGER;

   TYPE ltyp_datetabtype IS TABLE OF DATE
      INDEX BY BINARY_INTEGER;

   ltab_cur_level                  ltyp_number_tab;
   ltab_tbsi                       ltyp_number_tab;
   ltab_bsi                        ltyp_number_tab;
   ltab_cbsi                       ltyp_number_tab;
   ltab_cid                        ltyp_number_tab;
   ltab_csi                        ltyp_number_tab;
   ltab_bt                         ltyp_number_tab;
   ltab_cq                         ltyp_number_tab;
   ltab_eq                         ltyp_number_tab;
   ltab_so                         ltyp_varchar_tab;
   ltab_tid                        ltyp_number_tab;
   ltab_tad                        ltyp_varchar_tab;
   ltab_cyf                        ltyp_number_tab;
   ltab_oi                         ltyp_number_tab;
   ltab_cc                         ltyp_varchar_tab;
   ltab_iicr                       ltyp_number_tab;
   ltab_lf                         ltyp_number_tab;
   ltab_pf                         ltyp_number_tab;
   ltab_osn                        ltyp_number_tab;
   ltab_bit                        ltyp_number_tab;
   ltab_pbit                       ltyp_number_tab;
   ltab_paid                       ltyp_number_tab;
   ltab_wst                        ltyp_number_tab;
   ltab_itn                        ltyp_number_tab;
   ltab_ed                         ltyp_datetabtype;
   ltab_dd                         ltyp_datetabtype;
   ltab_id                         ltyp_datetabtype;
   ltab_fun                        ltyp_varchar_tab;
   ltab_eun                        ltyp_varchar_tab;
   ltab_opt                        ltyp_number_tab;
   ltab_ss                         ltyp_varchar_tab;
   ltab_sli                        ltyp_number_tab;
   ltab_cr                         ltyp_varchar_tab;
   ltab_cn                         ltyp_varchar_tab;
   ltab_oltp                       ltyp_number_tab;
   ltab_meo                        ltyp_number_tab;
   ltab_catp                       ltyp_number_tab;
   ltab_rts                        ltyp_number_tab;
   ltab_rfr                        ltyp_number_tab;
   ltab_iosd                       ltyp_number_tab;
   ltab_lq                         ltyp_number_tab;
   ltab_hq                         ltyp_number_tab;
   ltab_sb                         ltyp_number_tab;
   ltab_cost                       ltyp_number_tab;
   ltab_operation_offset           ltyp_number_tab;
   ltab_current_revision           ltyp_varchar_tab;
   ltab_locator                    ltyp_varchar_tab;
   ltab_item_structure             ltyp_varchar_tab;
   ltab_alternate_bom_designator   ltyp_varchar_tab;
   ltab_cost_type_id               ltyp_varchar_tab;
   ltab_extend_cost_flag           ltyp_varchar_tab;


    FUNCTION get_version
      RETURN VARCHAR2 IS
    BEGIN
       RETURN gc_pkg_version;
    END get_version;

    FUNCTION exploder( i_org_id              IN   NUMBER,
                       i_cst_type_id         IN   NUMBER DEFAULT 0,
                       i_item_id             IN   NUMBER,
                       i_alt_desg            IN   VARCHAR2,
                       i_assembly_revision   IN   VARCHAR2  )
      RETURN xxnao_bom_explosion_tbl PIPELINED AS

        PRAGMA AUTONOMOUS_TRANSACTION;

        -- Declaring variables
        lc_group_id            CONSTANT     BINARY_INTEGER  := 1000;
        lc_levels_to_explode   CONSTANT     BINARY_INTEGER  := 10;
        lc_max_level           CONSTANT     BINARY_INTEGER  := 60;
        lc_explode_option      CONSTANT     BINARY_INTEGER  := 3;
        lc_show_rev            CONSTANT     BINARY_INTEGER  := 1;
        lc_lead_time           CONSTANT     BINARY_INTEGER  := 2;
        lc_std_comp_flag       CONSTANT     BINARY_INTEGER  := 2;
        lc_verify_flag         CONSTANT     BINARY_INTEGER  := 0;
        lb_loop_found                       BOOLEAN         := FALSE;
        lb_max_level_exceeded               BOOLEAN         := FALSE;
        ld_rev_date                         DATE            := SYSDATE;
        li_order_by            CONSTANT     BINARY_INTEGER  := 1;
        li_bom_or_eng          CONSTANT	    BINARY_INTEGER  := 1;
        li_impl_flag           CONSTANT     BINARY_INTEGER  := 1;
        li_plan_factor_flag    CONSTANT     BINARY_INTEGER  := 2;
        li_module                           BINARY_INTEGER  := 1;
        li_expl_qty            CONSTANT     BINARY_INTEGER  := 1;
        li_comp_code           CONSTANT     VARCHAR2 (1000) := NULL;
        li_stmt_num            CONSTANT     BINARY_INTEGER  := 1;
        li_sortwidth           CONSTANT     BINARY_INTEGER  := 7;
        li_cnt                              BINARY_INTEGER  := 0;
        li_t_conversion_rate                NUMBER;
        li_t_master_org_id                  NUMBER;
        li_max_level                        BINARY_INTEGER;
        li_levels_to_explode                BINARY_INTEGER;
        li_explode_option                   BINARY_INTEGER;
        li_incl_oc_flag                     BINARY_INTEGER;
        li_std_comp_flag                    BINARY_INTEGER;
        li_prev_top_bill_id                 NUMBER;
        li_cum_count                        NUMBER;
        li_total_rows                       NUMBER;
        li_start_pos                        BINARY_INTEGER;
        li_loop_count_val                   NUMBER          := 0;
        ls_unit_number_from                 VARCHAR2 (1000) := NULL;
        ls_unit_number_to                   VARCHAR2 (1000) := NULL;
        ls_is_cost_organization             VARCHAR2 (1);
        ls_t_child_uom                      VARCHAR (3);
        ls_t_master_uom                     VARCHAR (3);
        ls_prev_sort_order                  VARCHAR2(2000);
        ls_cat_sort                         VARCHAR2(7);
        ls_impl_eco                         VARCHAR2(20);
        ls_cur_component                    VARCHAR2(16);
        ls_cur_substr                       VARCHAR2(16);
        ls_cur_loopstr                      VARCHAR2(1000);

        no_revision_found      EXCEPTION;
        PRAGMA EXCEPTION_INIT (no_revision_found, -20001);

--- Cursors 
      CURSOR c_org_check( p_group_id    NUMBER ) IS
      SELECT bet.organization_id            curoi, 
             bet.bill_sequence_id           curbsi,
             bet.component_sequence_id      curcsi,
             bet.component_item_id          curcii,
             bet.common_bill_sequence_id    curcbsi, 
             bet.group_id                   curgi,
             bet.primary_uom_code           curpuc
        FROM n_tmp_bom_explosion bet
       WHERE bet.bill_sequence_id <> bet.common_bill_sequence_id
         AND bet.group_id          = p_group_id;

      CURSOR c_conversion ( p_master_uom      VARCHAR2,
                            p_child_uom       VARCHAR2,
                            p_inv_id          NUMBER,
                            p_master_org_id   NUMBER   ) IS
      SELECT conv.conversion_rate conversion_rate
        FROM ( SELECT msi.inventory_item_id, 
                      msi.organization_id,
                      msi.primary_unit_of_measure, 
                      msi.primary_uom_code, 
                      uom.uom_class,
                      uom2.unit_of_measure, 
                      uom2.uom_code, 
                      conv2.uom_class,
                      ( ( CASE uom.uom_class
                            WHEN uom2.uom_class THEN 1
                            ELSE CLASS.conversion_rate
                          END ) * conv2.conversion_rate / 
                             ( CASE 
                                 WHEN ( conv1.inventory_item_id IS NULL ) THEN 
                                             ( CASE LEAST(NVL(conv1_2.disable_date, SYSDATE), SYSDATE )
                                                 WHEN SYSDATE THEN conv1_2.conversion_rate
                                                 ELSE NULL
                                               END )
                                 ELSE ( CASE LEAST(NVL (conv1.disable_date, SYSDATE), SYSDATE)
                                          WHEN SYSDATE THEN conv1.conversion_rate
                                          ELSE conv1_2.conversion_rate
                                        END  )
                               END ) )                                                         Conversion_Rate
                 FROM mtl_uom_conversions_s        conv1,
                      mtl_uom_conversions_s        conv2,
                      mtl_uom_conversions_s        conv1_2,
                      mtl_units_of_measure_tl_s    uom,
                      mtl_units_of_measure_tl_s    uom2,
                      mtl_uom_class_conversions_s  class,
                      mtl_system_items_b_s         msi
                WHERE uom.uom_code              = msi.primary_uom_code
                  AND uom.language (+)       LIKE gc_language
                  AND uom2.uom_class            = ( CASE uom.uom_class
                                                      WHEN uom2.uom_class THEN uom2.uom_class
                                                      ELSE class.to_uom_class
                                                     END  )
                  AND uom2.language (+)      LIKE gc_language
                  AND (    CLASS.to_uom_class  IS NULL
                        OR CLASS.to_uom_class   =
                         ( SELECT class2.to_uom_class
                             FROM mtl_uom_class_conversions_s class2
                            WHERE class2.inventory_item_id = msi.inventory_item_id
                              AND uom2.uom_class           = ( CASE uom.uom_class
                                                                 WHEN uom2.uom_class THEN uom2.uom_class
                                                                 ELSE class2.to_uom_class
                                                               END  )
                              AND uom.uom_class            = ( CASE uom.uom_class
                                                                 WHEN uom2.uom_class THEN uom.uom_class
                                                                 ELSE class2.from_uom_class
                                                               END )
                              AND ROWNUM                   = 1)
                      )
                  AND conv1.inventory_item_id (+)        = msi.inventory_item_id
                  AND conv1_2.inventory_item_id (+)      = 0
                  AND conv1.uom_code (+)                 = msi.primary_uom_code
                  AND conv1_2.uom_code (+)               = msi.primary_uom_code
                  AND ( CASE 
                          WHEN ( conv1.inventory_item_id IS NULL ) THEN
                                  ( CASE LEAST(NVL(conv1_2.disable_date, SYSDATE), SYSDATE )
                                      WHEN SYSDATE THEN conv1_2.conversion_rate
                                      ELSE NULL
                                    END )
                          ELSE ( CASE LEAST(NVL (conv1.disable_date, SYSDATE), SYSDATE)
                                   WHEN SYSDATE THEN conv1.conversion_rate
                                   ELSE conv1_2.conversion_rate
                                 END  )
                        END )                           IS NOT NULL
                  AND ( CASE uom.uom_class
                          WHEN uom2.uom_class THEN 1
                          ELSE ( CASE LEAST (NVL (CLASS.disable_date, SYSDATE), SYSDATE)
                                   WHEN SYSDATE THEN 1 
                                   ELSE NULL
                                 END  )
                        END  )                          IS NOT NULL
                  AND class.inventory_item_id (+)        = msi.inventory_item_id
                  AND uom.uom_class                      = ( CASE uom.uom_class
                                                               WHEN uom2.uom_class THEN uom.uom_class
                                                               ELSE class.from_uom_class
                                                             END  )
                  AND ( conv2.inventory_item_id, 
                        conv2.uom_code )                 =
                                  ( SELECT MAX(conv_sub2.inventory_item_id), 
                                           uom2.uom_code
                                      FROM mtl_uom_conversions_s   conv_sub2
                                     WHERE conv_sub2.uom_code            = uom2.uom_code
                                       AND conv_sub2.inventory_item_id  IN ( msi.inventory_item_id, 0 )
                                       AND NVL(class.inventory_item_id, 1) 
                                                                        IS NOT NULL
                                       AND NVL(conv_sub2.disable_date, SYSDATE + 1) 
                                                                         > SYSDATE ) ) Conv
       WHERE conv.primary_uom_code  = p_master_uom
         AND conv.uom_code          = p_child_uom
         AND conv.inventory_item_id = p_inv_id
         AND conv.organization_id   = p_master_org_id;

      CURSOR c_exploder( p_level              NUMBER,
                         p_grp_id             NUMBER,
                         p_org_id             NUMBER,
                         p_bom_or_eng         NUMBER,
                         p_rev_date           DATE,
                         p_impl_flag          NUMBER,
                         p_explode_option     NUMBER,
                         p_order_by           NUMBER,
                         p_verify_flag        NUMBER,
                         p_plan_factor_flag   NUMBER,
                         p_std_comp_flag      NUMBER,
                         p_incl_oc            NUMBER,
                         p_unit_number_from   VARCHAR2,
                         p_unit_number_to     VARCHAR2 ) IS
      SELECT bet.top_bill_sequence_id       tbsi, 
             bom.bill_sequence_id           bsi,
             bom.common_bill_sequence_id    cbsi, 
             bic.component_item_id          cid,
             bic.component_sequence_id      csi,
             --bic.basis_type               bt,
             bic.component_quantity         cq,
             (  bic.component_quantity * 
                bet.extended_quantity  * 
                ( CASE p_plan_factor_flag
                    WHEN 1 THEN (bic.planning_factor / 100 )
                    ELSE 1
                  END )                / 
                ( CASE bic.component_yield_factor
                    WHEN 0 THEN 1
                    ELSE bic.component_yield_factor
                  END )              )      eq,
             bet.sort_order                 so, 
             bet.top_item_id                tid,
             bet.top_alternate_designator   tad,
             bic.component_yield_factor     cyf, 
             bom.organization_id            oi,
             bet.component_code             cc, 
             bic.include_in_cost_rollup     iicr,
             bet.loop_flag                  lf, 
             bic.planning_factor            pf,
             bic.operation_seq_num          osn, 
             bic.bom_item_type              bit,
             bet.bom_item_type              pbit, 
             bet.component_item_id          paid,
             bic.wip_supply_type            wst, 
             bic.item_num                   itn,
             bic.effectivity_date           ed, 
             bic.disable_date               dd,
             bic.implementation_date        ID,
             bic.from_end_item_unit_number  fun,
             bic.to_end_item_unit_number    eun, 
             bic.optional                   opt,
             bic.supply_subinventory        ss, 
             bic.supply_locator_id          sli,
             bic.component_remarks          cr, 
             bic.change_notice              cn,
             bic.operation_lead_time_percent oltp,
             bic.mutually_exclusive_options meo, 
             bic.check_atp                  catp,
             bic.required_to_ship           rts, 
             bic.required_for_revenue       rfr,
             bic.include_on_ship_docs       iosd, 
             bic.low_quantity               lq,
             bic.high_quantity              hq, 
             bic.so_basis                   sb, 
             bet.operation_offset,
             bet.current_revision, 
             bet.locator,
             bom.alternate_bom_designator   -- for routing
        FROM n_tmp_bom_explosion  bet,
             bom_structures_b_s   bom,
             mtl_system_items_b_s si,
             bom_components_b_s   bic
       WHERE bet.plan_level                 = p_level - 1
         AND bet.group_id                   = p_grp_id
         AND bom.assembly_item_id           = si.inventory_item_id
         AND bom.organization_id            = si.organization_id
         AND bom.common_bill_sequence_id    = bic.bill_sequence_id
         AND bet.component_item_id          = bom.assembly_item_id
         AND bom.organization_id            = p_org_id
         AND NVL (bic.eco_for_production, 2) = 2
         AND (   (    p_std_comp_flag = 1          -- ONLY STD COMPONENTS
                  AND bic.bom_item_type = 4
                  AND bic.optional = 2
                 )
              OR (p_std_comp_flag = 2)
              OR (    p_std_comp_flag = 3
                  AND NVL (bet.bom_item_type, 1) IN (1, 2)
                  AND (   bic.bom_item_type IN (1, 2)
                       OR (bic.bom_item_type = 4 AND bic.optional = 1)
                      )
                 )
             )
         AND (   (    p_bom_or_eng      = 1 
                  AND bom.assembly_type = 1)
              OR (p_bom_or_eng = 2)
             )
         AND (   (    bet.top_alternate_designator IS NULL
                  AND bom.alternate_bom_designator IS NULL      )
              OR (    bet.top_alternate_designator IS NOT NULL
                  AND bom.alternate_bom_designator =
                                             bet.top_alternate_designator
                 )
              OR (    bet.top_alternate_designator IS NOT NULL
                  AND bom.alternate_bom_designator IS NULL
                  AND NOT EXISTS 
                    ( SELECT 'X'
                        FROM bom_structures_b_s bom2
                       WHERE bom2.organization_id           = p_org_id
                         AND bom2.assembly_item_id          = bet.component_item_id
                         AND bom2.alternate_bom_designator  = bet.top_alternate_designator
                         AND (   (    p_bom_or_eng = 1
                                  AND bom2.assembly_type = 1 )
                              OR p_bom_or_eng = 2
                             ))                            -- SUBQUERY
                 )
             )                                        -- END OF ALT LOGIC
-- WHETHER TO INCLUDE OPTION CLASSES AND MODELS UNDER A STANDARD ITEM
-- SPECIAL LOGIC ADDED AT CST REQUEST
         AND (   (     p_incl_oc          = 1 )
              OR (     p_incl_oc          = 2
                   AND bet.bom_item_type  = 4 
                   AND bic.bom_item_type  = 4 )
              OR (     bet.bom_item_type <> 4 ) )
-- DO NOT EXPLODE IF IMMEDIATE PARENT IS STANDARD AND CURRENT
-- COMPONENT IS OPTION CLASS OR MODEL - SPECIAL LOGIC FOR CONFIG ITEMS
         AND NOT (    bet.parent_bom_item_type = 4
                  AND bet.bom_item_type IN (1, 2)  )
         AND (   (    NVL (si.effectivity_control, 1) = 2
                  AND (   (p_explode_option = 1)                  --  ALL
                       OR (    p_explode_option IN (2, 3)
                           AND bic.disable_date IS NULL ) )
                  AND p_unit_number_from <=
                         NVL (bic.to_end_item_unit_number,
                              p_unit_number_from
                             )
                  AND p_unit_number_to >= bic.from_end_item_unit_number
                  AND bic.from_end_item_unit_number <=
                         NVL (bet.to_end_item_unit_number,
                              bic.from_end_item_unit_number
                             )
                  AND NVL (bic.to_end_item_unit_number,
                           NVL (bet.from_end_item_unit_number,
                                bic.from_end_item_unit_number
                               )
                          ) >=
                         NVL (bet.from_end_item_unit_number,
                              bic.from_end_item_unit_number
                             )
                  AND (   (    p_impl_flag = 1
                           AND bic.implementation_date IS NOT NULL
                          )
                       OR p_impl_flag = 2
                      )
                 )
              OR (    NVL (si.effectivity_control, 1) = 1
                  AND (   (    p_explode_option = 1
                           AND (   p_level = 1
                                OR (    bic.effectivity_date <=
                                           NVL (bet.disable_date,
                                                bic.effectivity_date
                                               )
                                    AND NVL (bic.disable_date,
                                             bet.effectivity_date
                                            ) >= bet.effectivity_date
                                   )
                               )
                          )                                        -- ALL
                       OR (    p_explode_option = 2
                           AND                                 -- CURRENT
                               p_rev_date >= bic.effectivity_date
                           AND p_rev_date <
                                   NVL (bic.disable_date, p_rev_date + 1)
                          )                                    -- CURRENT
                       OR (    p_explode_option = 3 -- CURRENT AND FUTURE
                           AND NVL (bic.disable_date, p_rev_date + 1) >
                                                               p_rev_date
                          )                         -- CURRENT AND FUTURE
                      )
                  AND (   (    p_impl_flag = 2
                           AND (   p_explode_option = 1
                                OR (    p_explode_option = 2
                                    AND NOT EXISTS (
                                           SELECT NULL
                                             FROM bom_components_b_s cib
                                            WHERE cib.bill_sequence_id  = bic.bill_sequence_id
                                              AND cib.component_item_id = bic.component_item_id
                                              AND NVL( cib.eco_for_production, 2 ) = 2
                                              AND ( ( CASE 
                                                        WHEN ( cib.implementation_date IS NULL ) THEN cib.old_component_sequence_id
                                                        ELSE cib.component_sequence_id
                                                      END ) = ( CASE
                                                                  WHEN ( bic.implementation_date IS NULL ) THEN bic.old_component_sequence_id
                                                                  ELSE bic.component_sequence_id
                                                                END )
                                                   OR cib.operation_seq_num = bic.operation_seq_num
                                                  )             -- DECODE
                                              AND cib.effectivity_date <= p_rev_date
                                              AND bic.effectivity_date  < cib.effectivity_date)
                                                       -- END OF SUBQUERY
                                   )                           -- CURRENT
                                OR (     p_explode_option = 3
                                     AND NOT EXISTS 
                                       ( SELECT NULL
                                           FROM bom_components_b_s cib
                                          WHERE cib.bill_sequence_id  = bic.bill_sequence_id
                                            AND cib.component_item_id = bic.component_item_id
                                            AND NVL( cib.eco_for_production, 2 ) = 2
                                            AND (   ( CASE 
                                                        WHEN ( cib.implementation_date IS NULL ) THEN cib.old_component_sequence_id
                                                        ELSE cib.component_sequence_id
                                                      END ) = ( CASE 
                                                                  WHEN ( bic.implementation_date IS NULL ) THEN bic.old_component_sequence_id
                                                                  ELSE bic.component_sequence_id
                                                                END )
                                                  OR cib.operation_seq_num = bic.operation_seq_num )          -- DECODE
                                            AND cib.effectivity_date <= p_rev_date
                                            AND bic.effectivity_date  < cib.effectivity_date )
                                                       -- END OF SUBQUERY
                                    OR bic.effectivity_date > p_rev_date
                                   )                -- CURRENT AND FUTURE
                               )                        -- EXPLODE_OPTION
                          )                              -- IMPL_FLAG = 2
                       OR (    p_impl_flag              = 1
                           AND bic.implementation_date IS NOT NULL )
                      )                                 -- EXPLODE OPTION
                 )
             )
         AND bet.loop_flag = 2
       ORDER BY bet.top_bill_sequence_id,
                bet.sort_order,
                ( CASE p_order_by WHEN 1 THEN bic.operation_seq_num ELSE bic.item_num END ),
                ( CASE p_order_by WHEN 1 THEN bic.item_num          ELSE bic.operation_seq_num END );

      CURSOR c_get_oltp( p_assembly    NUMBER,
                         p_alternate   VARCHAR2,
                         p_operation   NUMBER,
                         p_rev_date    DATE     ) IS
         SELECT ROUND(bos.operation_lead_time_percent, 2) oltp
           FROM bom_operation_sequences_s  bos,
                bom_operational_routings_s bor
          WHERE bor.assembly_item_id        = p_assembly
            AND bor.organization_id         = i_org_id
            AND (   bor.alternate_routing_designator = p_alternate
                 OR (    bor.alternate_routing_designator IS NULL
                     AND NOT EXISTS 
                       ( SELECT NULL
                           FROM bom_operational_routings_s bor2
                          WHERE bor2.assembly_item_id               = p_assembly
                            AND bor2.organization_id                = i_org_id
                            AND bor2.alternate_routing_designator   = p_alternate ) )
                )
            AND bor.common_routing_sequence_id      = bos.routing_sequence_id
            AND bos.operation_seq_num               = p_operation
            AND bos.effectivity_date               <= TRUNC(p_rev_date)
            AND NVL(bos.disable_date, 
                    p_rev_date + 1)                >= TRUNC(p_rev_date);

      CURSOR c_calculate_offset( p_parentitem   NUMBER, 
                                 p_percent      NUMBER  ) IS
      SELECT p_percent / 100 * msi.full_lead_time offset
        FROM mtl_system_items_b_s msi
       WHERE msi.inventory_item_id   = p_parentitem
         AND msi.organization_id     = i_org_id;

      CURSOR c_final_data IS
      SELECT up1.top_bill_sequence_id, 
             up1.bill_sequence_id,
             up1.common_bill_sequence_id, 
             up1.organization_id,
             up1.component_sequence_id, 
             up1.component_item_id,
             --BASIS_TYPE    ,
             up1.component_quantity, 
             up1.plan_level, 
             up1.extended_quantity,
             up1.sort_order, 
             up1.top_alternate_designator,
             up1.component_yield_factor, 
             up1.top_item_id, 
             up1.component_code,
             up1.include_in_rollup_flag, 
             up1.loop_flag, 
             up1.planning_factor,
             up1.operation_seq_num, 
             up1.bom_item_type, 
             up1.parent_bom_item_type,
             up1.assembly_item_id, 
             up1.wip_supply_type, 
             up1.item_num,
             up1.effectivity_date, 
             up1.disable_date, 
             up1.from_end_item_unit_number,
             up1.to_end_item_unit_number, 
             up1.implementation_date, 
             up1.optional,
             up1.supply_subinventory, 
             up1.supply_locator_id, 
             up1.component_remarks,
             up1.change_notice, 
             up1.operation_lead_time_percent,
             up1.mutually_exclusive_options, 
             up1.check_atp, 
             up1.required_to_ship,
             up1.required_for_revenue, 
             up1.include_on_ship_docs, 
             up1.low_quantity,
             up1.high_quantity, 
             up1.so_basis, 
             up1.operation_offset,
             up1.current_revision, 
             up1.locator, 
             up1.item_cost,
--             LTRIM( SYS_CONNECT_BY_PATH (up1.item_num, '.'),
--                    '.'  )                                      item_structure,
             LTRIM( SYS_CONNECT_BY_PATH (REPLACE(up1.item_num,'.', '_'), '~'), '~' ) item_structure,                    
             up1.actual_cost_type_id, 
             up1.extend_cost_flag
        FROM n_tmp_bom_explosion up1
       START WITH up1.assembly_item_id = up1.top_item_id
     CONNECT BY NOCYCLE PRIOR up1.component_item_id = up1.assembly_item_id
               AND NVL (PRIOR up1.plan_level, -1)   = NVL( up1.plan_level - 1, -1)
               AND PRIOR up1.sort_order             = SUBSTR(up1.sort_order,
                                                             1, LENGTH (up1.sort_order) - gc_sortwidth )
      ORDER BY sort_order;

      PROCEDURE del_tab IS
      BEGIN
         DELETE FROM n_tmp_bom_explosion;
      END;

   BEGIN
      del_tab;

      IF ( i_cst_type_id <> 0 ) THEN
         li_module := 1;
      ELSE
         li_module := 0;
      END IF;


      INSERT INTO n_tmp_bom_explosion
           ( group_id, 
             bill_sequence_id, 
             component_sequence_id,
             organization_id, 
             top_item_id, 
             component_item_id,
             plan_level, 
             extended_quantity, 
             basis_type,
             component_quantity, 
             sort_order, 
             program_update_date,
             top_bill_sequence_id, 
             component_code, 
             loop_flag,
             top_alternate_designator, 
             bom_item_type,
             parent_bom_item_type)
      SELECT lc_group_id, 
             bom.bill_sequence_id, 
             NULL, 
             i_org_id, 
             i_item_id,
             i_item_id, 
             0, 
             li_expl_qty, 
             1, 
             1, 
             LPAD('1', li_sortwidth, '0'),
             SYSDATE, 
             bom.bill_sequence_id,
             NVL(li_comp_code, LPAD (i_item_id, 16, '0')),
             2, 
             i_alt_desg,
             msi.bom_item_type, 
             msi.bom_item_type
        FROM bom_structures_b_s bom, 
             mtl_system_items_b_s msi
       WHERE bom.assembly_item_id                       = i_item_id
         AND bom.organization_id                        = i_org_id
         AND NVL (bom.alternate_bom_designator, 'NONE') = NVL (i_alt_desg, 'NONE')
         AND msi.organization_id                        = i_org_id
         AND msi.inventory_item_id                      = i_item_id;

      IF ( SQL%NOTFOUND ) THEN
         RAISE NO_DATA_FOUND;
      END IF;


----------------------------------------------
        -- procedure exploders code
      BEGIN
         li_levels_to_explode := lc_levels_to_explode;
         li_explode_option    := lc_explode_option;

         /* Calculate revision data from a given revision */
         SELECT NVL (MIN (rev2.effectivity_date - 1 / (60 * 60 * 24)),
                       GREATEST (SYSDATE, rev1.effectivity_date)
                      )
           INTO ld_rev_date
           FROM mtl_item_revisions_b_s rev2,
                mtl_item_revisions_b_s rev1
          WHERE rev1.organization_id        = rev2.organization_id(+)
            AND rev1.inventory_item_id      = rev2.inventory_item_id(+)
            AND rev2.effectivity_date (+)   > rev1.effectivity_date
            AND rev1.inventory_item_id      = i_item_id
            AND rev1.organization_id        = i_org_id
            AND rev1.revision               = i_assembly_revision
       GROUP BY rev1.organization_id,
                rev1.inventory_item_id,
                rev1.revision_id,
                rev1.revision,
                rev1.effectivity_date,
                rev1.implementation_date,
                rev1.change_notice;

         /*
             ** fetch the max permissible levels for explosion
             ** doing a max since if no row exist to prevent no_Data_found exception
             ** from being raised
         */
         SELECT MAX(maximum_bom_level)
           INTO li_max_level
           FROM BOM_PARAMETERS_S
          WHERE (i_org_id = -1 OR (i_org_id <> -1 AND organization_id = i_org_id));

         -- since sort width is increased to 4 and column width is only 240,
         -- maximum level must be at most 59 (levels 0 through 59).
         IF ( NVL(li_max_level, lc_max_level) > (lc_max_level-1) ) THEN
            li_max_level := (lc_max_level-1);
         END IF;

         /*
         ** if levels to explode > max levels or < 0, set it to max_levels
         */
         IF (li_levels_to_explode < 0) OR (li_levels_to_explode > li_max_level)
         THEN
            li_levels_to_explode := li_max_level;
         END IF;

         IF (    li_module = 1 
              OR li_module = 2 ) THEN                                /* cst or bom explosion */
            li_std_comp_flag := 2;                                   /* ALL */
         ELSE
            li_std_comp_flag := lc_std_comp_flag;
         END IF;

         IF ( li_module = 1 )  THEN                  /* CST */
            li_incl_oc_flag := 2;
         ELSE
            li_incl_oc_flag := 1;
         END IF;

-------------------------------------------------------------------------------------------------
       -- Procedure bom exploder code
         BEGIN
            --    for ltab_cur_level in 1..lc_levels_to_explode+1 loop
            FOR ltab_cur_level IN 1 .. lc_levels_to_explode LOOP
               li_total_rows := 0;
               li_cum_count := 0;
               --- Bulk Collect Functionality

               -- Delete Pl/Sql Table
               ltab_tbsi.DELETE;
               ltab_bsi.DELETE;
               ltab_cbsi.DELETE;
               ltab_cid.DELETE;
               ltab_csi.DELETE;
               --  ltab_BT.delete;
               ltab_cq.DELETE;
               ltab_eq.DELETE;
               ltab_so.DELETE;
               ltab_tid.DELETE;
               ltab_tad.DELETE;
               ltab_cyf.DELETE;
               ltab_oi.DELETE;
               ltab_cc.DELETE;
               ltab_iicr.DELETE;
               ltab_lf.DELETE;
               ltab_pf.DELETE;
               ltab_osn.DELETE;
               ltab_bit.DELETE;
               ltab_pbit.DELETE;
               ltab_paid.DELETE;
               ltab_wst.DELETE;
               ltab_itn.DELETE;
               ltab_ed.DELETE;
               ltab_dd.DELETE;
               ltab_id.DELETE;
               ltab_fun.DELETE;
               ltab_eun.DELETE;
               ltab_opt.DELETE;
               ltab_ss.DELETE;
               ltab_sli.DELETE;
               ltab_cr.DELETE;
               ltab_cn.DELETE;
               ltab_oltp.DELETE;
               ltab_meo.DELETE;
               ltab_catp.DELETE;
               ltab_rts.DELETE;
               ltab_rfr.DELETE;
               ltab_iosd.DELETE;
               ltab_lq.DELETE;
               ltab_hq.DELETE;
               ltab_sb.DELETE;
               ltab_operation_offset.DELETE;
               ltab_current_revision.DELETE;
               ltab_locator.DELETE;
               ltab_alternate_bom_designator.DELETE;
               ltab_item_structure.DELETE;

               IF ( NOT c_exploder%ISOPEN ) THEN
                  OPEN c_exploder( ltab_cur_level,
                                   lc_group_id,
                                   i_org_id,
                                   li_bom_or_eng,
                                   ld_rev_date,
                                   li_impl_flag,
                                   li_explode_option,
                                   li_order_by,
                                   lc_verify_flag,
                                   li_plan_factor_flag,
                                   li_std_comp_flag,
                                   li_incl_oc_flag,
                                   ls_unit_number_from,
                                   ls_unit_number_to      );
               END IF;

               FETCH c_exploder BULK COLLECT 
                INTO ltab_tbsi, 
                     ltab_bsi, 
                     ltab_cbsi, 
                     ltab_cid, 
                     ltab_csi,
                     --  ltab_BT,
                     ltab_cq,
                     ltab_eq, 
                     ltab_so, 
                     ltab_tid, 
                     ltab_tad, 
                     ltab_cyf, 
                     ltab_oi, 
                     ltab_cc, 
                     ltab_iicr,
                     ltab_lf, 
                     ltab_pf, 
                     ltab_osn, 
                     ltab_bit, 
                     ltab_pbit, 
                     ltab_paid, 
                     ltab_wst, 
                     ltab_itn,
                     ltab_ed, 
                     ltab_dd, 
                     ltab_id, 
                     ltab_fun, 
                     ltab_eun, 
                     ltab_opt, 
                     ltab_ss, 
                     ltab_sli,
                     ltab_cr, 
                     ltab_cn, 
                     ltab_oltp, 
                     ltab_meo, 
                     ltab_catp, 
                     ltab_rts, 
                     ltab_rfr, 
                     ltab_iosd,
                     ltab_lq, 
                     ltab_hq, 
                     ltab_sb, 
                     ltab_operation_offset,
                     ltab_current_revision, 
                     ltab_locator,
                     ltab_alternate_bom_designator;

               li_loop_count_val := c_exploder%ROWCOUNT;

               CLOSE c_exploder;

               if ( li_loop_count_val > 0 ) THEN
                   FOR i IN 1 .. li_loop_count_val LOOP
                      IF ( ltab_cur_level > li_levels_to_explode ) THEN
                         IF ( ltab_cur_level > li_max_level ) THEN
                            lb_max_level_exceeded := TRUE;
                         END IF;                               -- exceed max level

                         EXIT;                        -- do not insert extra level
                      END IF;                               -- exceed lowest level

                      li_total_rows := li_total_rows + 1;

                      --
                      -- for very first iteration of the loop, set prevbillid = bill_id
                      --
                      IF (li_cum_count = 0) THEN
                         li_prev_top_bill_id := ltab_tbsi (i);
                         ls_prev_sort_order  := ltab_so (i);
                      END IF;
                   
                      --
                      -- whenever a diff assy at a particular level is being exploded, reset
                      -- the li_cum_count so that the sort code always starts from 001 for each
                      -- assembly
                      --
                      IF (   li_prev_top_bill_id <> ltab_tbsi (i)
                          OR (    li_prev_top_bill_id = ltab_tbsi (i)
                              AND ls_prev_sort_order <> ltab_so (i)   ) )  THEN
                         li_cum_count          := 0;
                         li_prev_top_bill_id   := ltab_tbsi (i);
                         ls_prev_sort_order    := ltab_so (i);
                      END IF;
                   
                      li_cum_count := li_cum_count + 1;
                      --
                      -- lpad ls_cat_sort with 0s upto 7 characters
                      --
                      ls_cat_sort :=
                         LPAD (TO_CHAR (li_cum_count),
                               noetix_bom_explosion_pkg.gc_sortwidth,
                               '0'
                              );
                      ltab_so (i)         := ltab_so (i) || ls_cat_sort;
                      lb_loop_found       := FALSE;
                      ls_cur_loopstr      := ltab_cc (i);
                      ls_cur_component    := LPAD (TO_CHAR (ltab_cid (i)), 16, '0');
                   
                      -- search the current loop_string for current component
                      FOR i IN 1 .. li_max_level LOOP
                         li_start_pos := 1 + ((i - 1) * 16);
                         ls_cur_substr := SUBSTR (ls_cur_loopstr, li_start_pos, 16);
                   
                         IF (ls_cur_component = ls_cur_substr) THEN
                            lb_loop_found := TRUE;
                            EXIT;
                         END IF;
                      END LOOP;
                   
                      -- deal with the search results
                      ltab_cc (i) := ltab_cc (i) || ls_cur_component;
                   
                      IF ( lb_loop_found ) THEN
                         ltab_lf (i) := 1;
                      ELSE
                         ltab_lf (i) := 2;
                      END IF;
                   
                      ltab_current_revision (i) := NULL;
                   
                      IF ( lc_show_rev = 1 ) THEN
                         BEGIN
                            IF ( li_impl_flag = 1 ) THEN
                               ls_impl_eco := 'IMPL_ONLY';
                            ELSE
                               ls_impl_eco := 'ALL';
                            END IF;
                   
--                                  
                            noetix_bom_revisions_pkg.get_revision( i_TYPE              => 'PART',
                                                                   i_eco_status        => 'ALL',
                                                                   i_examine_type      => ls_impl_eco,
                                                                   i_org_id            => ltab_oi (i),
                                                                   i_item_id           => ltab_cid (i),
                                                                   i_rev_date          => ld_rev_date,
                                                                   io_item_rev         => ltab_current_revision(i)   );
                         EXCEPTION
                            WHEN no_revision_found THEN
                               NULL;
                         END;                                      -- nested block
                      END IF;                        -- current component revision
                   
                      ltab_locator (i) := NULL;
                      ltab_oltp (i) := NULL;
                   
                      FOR x_operation IN c_get_oltp( p_assembly       => ltab_paid (i),
                                                     p_alternate      => ltab_alternate_bom_designator(i),
                                                     p_operation      => ltab_osn (i),
                                                     p_rev_date       => ld_rev_date  )  LOOP
                         ltab_oltp (i) := x_operation.oltp;
                      END LOOP;
                   
                      ltab_operation_offset (i) := NULL;
                   
                      IF ( lc_lead_time = 1 ) THEN
                         FOR x_item IN c_calculate_offset( p_parentitem      => ltab_paid (i),
                                                           p_percent         => ltab_oltp (i) )  LOOP
                            ltab_operation_offset (i) := x_item.offset;
                         END LOOP;
                      END IF;                                  -- operation offset
                   END LOOP;                                  -- cursor fetch loop
               END IF;

               FORALL i IN 1 .. li_loop_count_val
               INSERT INTO n_tmp_bom_explosion
                           (group_id, 
                            top_bill_sequence_id,
                            bill_sequence_id, 
                            common_bill_sequence_id,
                            organization_id, 
                            component_sequence_id,
                            component_item_id,
                            --  BASIS_TYPE,
                            component_quantity,
                            plan_level, 
                            extended_quantity, 
                            sort_order,
                            top_alternate_designator,
                            component_yield_factor, 
                            top_item_id,
                            component_code, 
                            include_in_rollup_flag,
                            loop_flag, 
                            planning_factor, 
                            operation_seq_num,
                            bom_item_type, 
                            parent_bom_item_type,
                            assembly_item_id, 
                            wip_supply_type, 
                            item_num,
                            effectivity_date, 
                            disable_date,
                            from_end_item_unit_number,
                            to_end_item_unit_number, 
                            implementation_date,
                            optional, 
                            supply_subinventory,
                            supply_locator_id, 
                            component_remarks,
                            change_notice, 
                            operation_lead_time_percent,
                            mutually_exclusive_options, 
                            check_atp,
                            required_to_ship, 
                            required_for_revenue,
                            include_on_ship_docs, 
                            low_quantity,
                            high_quantity, 
                            so_basis, 
                            operation_offset,
                            current_revision, 
                            LOCATOR
                           )
                    VALUES (lc_group_id, 
                            ltab_tbsi (i),
                            ltab_bsi (i), 
                            ltab_cbsi (i),
                            ltab_oi (i), 
                            ltab_csi (i),
                            ltab_cid (i),
                            --  ltab_BT(i),
                            ltab_cq (i),
                            ltab_cur_level, 
                            ltab_eq (i), 
                            ltab_so (i),
                            ltab_tad (i),
                            ltab_cyf (i), 
                            ltab_tid (i),
                            ltab_cc (i), 
                            ltab_iicr (i),
                            ltab_lf (i), 
                            ltab_pf (i), 
                            ltab_osn (i),
                            ltab_bit (i), 
                            ltab_pbit (i),
                            ltab_paid (i), 
                            ltab_wst (i), 
                            ltab_itn (i),
                            ltab_ed (i), 
                            ltab_dd (i),
                            ltab_fun (i),
                            ltab_eun (i), 
                            ltab_id (i),
                            ltab_opt (i), 
                            ltab_ss (i),
                            ltab_sli (i), 
                            ltab_cr (i),
                            ltab_cn (i), 
                            ltab_oltp (i),
                            ltab_meo (i), 
                            ltab_catp (i),
                            ltab_rts (i), 
                            ltab_rfr (i),
                            ltab_iosd (i), 
                            ltab_lq (i),
                            ltab_hq (i), 
                            ltab_sb (i), 
                            ltab_operation_offset (i),
                            ltab_current_revision (i), 
                            ltab_locator (i)
                           );
            END LOOP;

            ---- Cost types, quantities calculations
            BEGIN
               IF (li_module = 1) THEN
                  noetix_bom_expl_cost_pkg.cst_exploder( i_grp_id         => lc_group_id,
                                                         i_org_id         => i_org_id,
                                                         i_cst_type_id    => i_cst_type_id,
                                                         i_inq_flag       => 1 );
               END IF;

               SELECT COUNT(*)
                 INTO li_cnt
                 FROM mtl_parameters_s mtl
                WHERE mtl.organization_id = mtl.cost_organization_id
                  AND mtl.organization_id = i_org_id;

               IF (li_cnt > 0) THEN
                  ls_is_cost_organization := 'Y';
               ELSE
                  ls_is_cost_organization := 'N';
               END IF;

               -- If the Intended Bill is referenced some other bill of different organization
               -- then the conversion rate, uom of the component in the child organization
               -- should be calculated.
               FOR cr IN c_org_check( lc_group_id )  LOOP
                  SELECT msi.primary_uom_code, 
                         msi.organization_id
                    INTO ls_t_master_uom, 
                         li_t_master_org_id
                    FROM mtl_system_items_b_s msi,
                         bom_structures_b_s   bbm
                   WHERE cr.curcbsi             = bbm.bill_sequence_id
                     AND bbm.organization_id    = msi.organization_id
                     AND msi.inventory_item_id  = cr.curcii;

                  SELECT msi.primary_uom_code
                    INTO ls_t_child_uom
                    FROM mtl_system_items_b_s msi
                   WHERE msi.inventory_item_id = cr.curcii
                     AND msi.organization_id   = cr.curoi;

                  SELECT conv.conversion_rate
                    INTO li_t_conversion_rate
                    FROM ( 
                           SELECT msi.inventory_item_id, msi.organization_id,
                              msi.primary_unit_of_measure, msi.primary_uom_code, uom.uom_class,
                              uom2.unit_of_measure, uom2.uom_code, conv2.uom_class,
                              (  ( CASE uom.uom_class WHEN uom2.uom_class THEN 1 ELSE CLASS.conversion_rate END)
                               * conv2.conversion_rate
                               / ( CASE 
                                     WHEN conv1.inventory_item_id IS NULL THEN
                                          ( CASE LEAST(NVL(conv1_2.disable_date, SYSDATE),SYSDATE)
                                              WHEN SYSDATE THEN conv1_2.conversion_rate
                                              ELSE NULL
                                            END )
                                     ELSE ( CASE LEAST (NVL (conv1.disable_date, SYSDATE), SYSDATE)
                                              WHEN SYSDATE THEN conv1.conversion_rate
                                              ELSE conv1_2.conversion_rate
                                            END )
                                   END )
                              ) Conversion_Rate
                         FROM mtl_uom_conversions_s       conv1,
                              mtl_uom_conversions_s       conv2,
                              mtl_uom_conversions_s       conv1_2,
                              mtl_units_of_measure_tl_s   uom,
                              mtl_units_of_measure_tl_s   uom2,
                              mtl_uom_class_conversions_s class,
                              mtl_system_items_b_s        msi
                        WHERE uom.uom_code = msi.primary_uom_code
                          and uom.LANGUAGE (+) LIKE gc_language
                          AND uom2.uom_class =
                                 ( CASE uom.uom_class
                                     WHEN uom2.uom_class THEN uom2.uom_class
                                     ELSE class.to_uom_class
                                   END )
                          and uom2.LANGUAGE (+) LIKE gc_language
                          AND (   class.to_uom_class IS NULL
                               OR class.to_uom_class =
                                     (SELECT class2.to_uom_class
                                        FROM mtl_uom_class_conversions_s class2
                                       WHERE class2.inventory_item_id = msi.inventory_item_id
                                         AND uom2.uom_class =
                                                ( CASE uom.uom_class
                                                    WHEN uom2.uom_class THEN uom2.uom_class
                                                    ELSE class2.to_uom_class
                                                  END   )
                                         AND uom.uom_class  =
                                                ( CASE uom.uom_class
                                                    WHEN uom2.uom_class THEN uom.uom_class
                                                    ELSE class2.from_uom_class
                                                  END   )
                                         AND ROWNUM         = 1 )
                              )
                          AND conv1.inventory_item_id (+)   = msi.inventory_item_id
                          AND conv1_2.inventory_item_id (+) = 0
                          AND conv1.uom_code (+)            = msi.primary_uom_code
                          AND conv1_2.uom_code (+)          = msi.primary_uom_code
                          AND ( CASE 
                                  WHEN ( conv1.inventory_item_id IS NULL ) THEN
                                        ( CASE LEAST(NVL(conv1_2.disable_date, SYSDATE), SYSDATE )
                                            WHEN SYSDATE THEN conv1_2.conversion_rate 
                                            ELSE NULL
                                           END )
                                  ELSE  ( CASE LEAST (NVL (conv1.disable_date, SYSDATE), SYSDATE)
                                            WHEN SYSDATE THEN conv1.conversion_rate
                                            ELSE conv1_2.conversion_rate
                                          END )
                                END                       ) IS NOT NULL
                          AND ( CASE uom.uom_class
                                  WHEN uom2.uom_class THEN 1
                                  ELSE ( CASE LEAST (NVL (CLASS.disable_date, SYSDATE), SYSDATE)
                                           WHEN SYSDATE THEN 1
                                           ELSE NULL
                                         END  )
                                END                       ) IS NOT NULL
                          AND class.inventory_item_id(+) = msi.inventory_item_id
                          AND uom.uom_class =
                                 ( CASE uom.uom_class
                                     WHEN uom2.uom_class THEN uom.uom_class
                                     ELSE class.from_uom_class
                                   END  )
                          AND (conv2.inventory_item_id, conv2.uom_code) =
                                 (SELECT MAX (conv_sub2.inventory_item_id), uom2.uom_code
                                    FROM mtl_uom_conversions_s conv_sub2
                                   WHERE conv_sub2.uom_code = uom2.uom_code
                                     AND conv_sub2.inventory_item_id IN ( msi.inventory_item_id, 0 )
                                     AND NVL (CLASS.inventory_item_id, 1) IS NOT NULL
                                     AND NVL (conv_sub2.disable_date, SYSDATE + 1) > SYSDATE)) conv
                   WHERE conv.primary_uom_code  = ls_t_master_uom
                     AND conv.uom_code          = ls_t_child_uom
                     AND conv.inventory_item_id = cr.curcii
                     AND conv.organization_id   = li_t_master_org_id;

                  OPEN c_conversion( ls_t_master_uom,
                                     ls_t_child_uom,
                                     cr.curcii,
                                     li_t_master_org_id );

                  FETCH c_conversion
                   INTO li_t_conversion_rate;

                  CLOSE c_conversion;

                  -- If cost_organization is Master organization then the item cost should be
                  -- calculated by multiplying the conversion_rate.
                  IF ( ls_is_cost_organization <> 'Y' ) THEN
                     UPDATE n_tmp_bom_explosion t
                        SET t.item_cost = t.item_cost * li_t_conversion_rate
                      WHERE t.group_id                  = cr.curgi
                        AND t.component_sequence_id     = cr.curcsi
                        AND t.bill_sequence_id          = cr.curbsi
                        AND t.common_bill_sequence_id   = cr.curcbsi;
                  END IF;

                  UPDATE n_tmp_bom_explosion t
                     SET t.component_quantity      = t.component_quantity / li_t_conversion_rate,
                         t.extended_quantity       = t.extended_quantity / li_t_conversion_rate,
                         t.primary_uom_code        = cr.curpuc
                   WHERE t.group_id                = cr.curgi
                     AND t.component_sequence_id   = cr.curcsi
                     AND t.bill_sequence_id        = cr.curbsi
                     AND t.common_bill_sequence_id = cr.curcbsi;
               END LOOP;

               --COMMIT; --sv
               UPDATE n_tmp_bom_explosion t
                  SET t.actual_cost_type_id = i_cst_type_id;
            END;

            li_loop_count_val := 0;
            -- Delete Pl/Sql Table
            ltab_tbsi.DELETE;
            ltab_bsi.DELETE;
            ltab_cbsi.DELETE;
            ltab_cid.DELETE;
            ltab_csi.DELETE;
            -- ltab_BT.delete;
            ltab_cq.DELETE;
            ltab_cur_level.DELETE;
            ltab_eq.DELETE;
            ltab_so.DELETE;
            ltab_tid.DELETE;
            ltab_tad.DELETE;
            ltab_cyf.DELETE;
            ltab_oi.DELETE;
            ltab_cc.DELETE;
            ltab_iicr.DELETE;
            ltab_lf.DELETE;
            ltab_pf.DELETE;
            ltab_osn.DELETE;
            ltab_bit.DELETE;
            ltab_pbit.DELETE;
            ltab_paid.DELETE;
            ltab_wst.DELETE;
            ltab_itn.DELETE;
            ltab_ed.DELETE;
            ltab_dd.DELETE;
            ltab_id.DELETE;
            ltab_fun.DELETE;
            ltab_eun.DELETE;
            ltab_opt.DELETE;
            ltab_ss.DELETE;
            ltab_sli.DELETE;
            ltab_cr.DELETE;
            ltab_cn.DELETE;
            ltab_oltp.DELETE;
            ltab_meo.DELETE;
            ltab_catp.DELETE;
            ltab_rts.DELETE;
            ltab_rfr.DELETE;
            ltab_iosd.DELETE;
            ltab_lq.DELETE;
            ltab_hq.DELETE;
            ltab_sb.DELETE;
            ltab_operation_offset.DELETE;
            ltab_current_revision.DELETE;
            ltab_locator.DELETE;
            ltab_alternate_bom_designator.DELETE;
            ltab_cost.DELETE;                                            -- ADDED
            ltab_item_structure.DELETE;
            ltab_cost_type_id.DELETE;
            ltab_extend_cost_flag.DELETE;

            IF ( NOT c_final_data%ISOPEN ) THEN
               OPEN c_final_data ();
            END IF;

            FETCH c_final_data BULK COLLECT 
             INTO ltab_tbsi, 
                  ltab_bsi, 
                  ltab_cbsi, 
                  ltab_oi, 
                  ltab_csi,
                  ltab_cid,
                  ltab_cq,   
                  ltab_cur_level, 
                  ltab_eq, 
                  ltab_so, 
                  ltab_tad, 
                  ltab_cyf, 
                  ltab_tid, 
                  ltab_cc, 
                  ltab_iicr,
                  ltab_lf, 
                  ltab_pf, 
                  ltab_osn, 
                  ltab_bit, 
                  ltab_pbit, 
                  ltab_paid, 
                  ltab_wst, 
                  ltab_itn,
                  ltab_ed, 
                  ltab_dd, 
                  ltab_fun, 
                  ltab_eun, 
                  ltab_id, 
                  ltab_opt, 
                  ltab_ss, 
                  ltab_sli, 
                  ltab_cr,
                  ltab_cn, 
                  ltab_oltp, 
                  ltab_meo, 
                  ltab_catp, 
                  ltab_rts, 
                  ltab_rfr, 
                  ltab_iosd, 
                  ltab_lq,
                  ltab_hq, 
                  ltab_sb, 
                  ltab_operation_offset, 
                  ltab_current_revision,
                  ltab_locator, 
                  ltab_cost, 
                  ltab_item_structure, 
                  ltab_cost_type_id,
                  ltab_extend_cost_flag;

            li_loop_count_val := c_final_data%ROWCOUNT;

            CLOSE c_final_data;

            COMMIT;

            FOR i IN 1 .. li_loop_count_val LOOP
               gtab_bom_explosion_table (i).top_bill_sequence_id := ltab_tbsi (i);
               gtab_bom_explosion_table (i).bill_sequence_id := ltab_bsi (i);
               gtab_bom_explosion_table (i).organization_id := ltab_oi (i);
               gtab_bom_explosion_table (i).component_sequence_id := ltab_csi (i);
               gtab_bom_explosion_table (i).component_item_id := ltab_cid (i);
               gtab_bom_explosion_table (i).component_quantity := ltab_cq (i);
               gtab_bom_explosion_table (i).plan_level := ltab_cur_level (i);
               gtab_bom_explosion_table (i).extended_quantity := ltab_eq (i);
               gtab_bom_explosion_table (i).sort_order := ltab_so (i);
               gtab_bom_explosion_table (i).top_alternate_designator := ltab_tad (i);
               gtab_bom_explosion_table (i).component_yield_factor := ltab_cyf (i);
               gtab_bom_explosion_table (i).top_item_id := ltab_tid (i);
               gtab_bom_explosion_table (i).component_code := ltab_cc (i);
               gtab_bom_explosion_table (i).include_in_rollup_flag := ltab_iicr (i);
               gtab_bom_explosion_table (i).loop_flag := ltab_lf (i);
               gtab_bom_explosion_table (i).planning_factor := ltab_pf (i);
               gtab_bom_explosion_table (i).operation_seq_num := ltab_osn (i);
               gtab_bom_explosion_table (i).bom_item_type := ltab_bit (i);
               gtab_bom_explosion_table (i).parent_bom_item_type := ltab_pbit (i);
               gtab_bom_explosion_table (i).assembly_item_id := ltab_paid (i);
               gtab_bom_explosion_table (i).wip_supply_type := ltab_wst (i);
               gtab_bom_explosion_table (i).item_num := ltab_itn (i);
               gtab_bom_explosion_table (i).effectivity_date := ltab_ed (i);
               gtab_bom_explosion_table (i).disable_date := ltab_dd (i);
               gtab_bom_explosion_table (i).from_end_item_unit_number := ltab_fun (i);
               gtab_bom_explosion_table (i).to_end_item_unit_number := ltab_eun (i);
               gtab_bom_explosion_table (i).implementation_date := ltab_id (i);
               gtab_bom_explosion_table (i).optional := ltab_opt (i);
               gtab_bom_explosion_table (i).supply_subinventory := ltab_ss (i);
               gtab_bom_explosion_table (i).supply_locator_id := ltab_sli (i);
               gtab_bom_explosion_table (i).component_remarks := ltab_cr (i);
               gtab_bom_explosion_table (i).change_notice := ltab_cn (i);
               gtab_bom_explosion_table (i).operation_lead_time_percent := ltab_oltp (i);
               gtab_bom_explosion_table (i).mutually_exclusive_options := ltab_meo (i);
               gtab_bom_explosion_table (i).check_atp := ltab_catp (i);
               gtab_bom_explosion_table (i).required_to_ship := ltab_rts (i);
               gtab_bom_explosion_table (i).required_for_revenue := ltab_rfr (i);
               gtab_bom_explosion_table (i).include_on_ship_docs := ltab_iosd (i);
               gtab_bom_explosion_table (i).low_quantity := ltab_lq (i);
               gtab_bom_explosion_table (i).high_quantity := ltab_hq (i);
               gtab_bom_explosion_table (i).so_basis := ltab_sb (i);
               gtab_bom_explosion_table (i).operation_offset := ltab_operation_offset (i);
               gtab_bom_explosion_table (i).current_revision := ltab_current_revision (i);
               gtab_bom_explosion_table (i).LOCATOR := ltab_locator (i);
               gtab_bom_explosion_table (i).item_cost := ltab_cost (i);
               gtab_bom_explosion_table (i).item_structure := ltab_item_structure (i);
               gtab_bom_explosion_table (i).actual_cost_type_id := ltab_cost_type_id (i);
               gtab_bom_explosion_table (i).extend_cost_flag := ltab_extend_cost_flag (i);
               -- Pipe the data
               PIPE ROW (xxnao_bom_explosion_object
                            (gtab_bom_explosion_table (i).top_bill_sequence_id,
                             gtab_bom_explosion_table (i).bill_sequence_id,
                             gtab_bom_explosion_table (i).organization_id,
                             gtab_bom_explosion_table (i).component_sequence_id,
                             gtab_bom_explosion_table (i).component_item_id,
                             gtab_bom_explosion_table (i).component_quantity,
                             gtab_bom_explosion_table (i).plan_level,
                             gtab_bom_explosion_table (i).extended_quantity,
                             gtab_bom_explosion_table (i).sort_order,
                             -- gtab_bom_explosion_table(i).group_id,
                             gtab_bom_explosion_table (i).top_alternate_designator,
                             gtab_bom_explosion_table (i).component_yield_factor,
                             gtab_bom_explosion_table (i).top_item_id,
                             gtab_bom_explosion_table (i).component_code,
                             gtab_bom_explosion_table (i).include_in_rollup_flag,
                             gtab_bom_explosion_table (i).loop_flag,
                             gtab_bom_explosion_table (i).planning_factor,
                             gtab_bom_explosion_table (i).operation_seq_num,
                             gtab_bom_explosion_table (i).bom_item_type,
                             gtab_bom_explosion_table (i).parent_bom_item_type,
                             gtab_bom_explosion_table (i).assembly_item_id,
                             gtab_bom_explosion_table (i).wip_supply_type,
                             gtab_bom_explosion_table (i).item_num,
                             gtab_bom_explosion_table (i).effectivity_date,
                             gtab_bom_explosion_table (i).disable_date,
                             gtab_bom_explosion_table (i).from_end_item_unit_number,
                             gtab_bom_explosion_table (i).to_end_item_unit_number,
                             gtab_bom_explosion_table (i).implementation_date,
                             gtab_bom_explosion_table (i).optional,
                             gtab_bom_explosion_table (i).supply_subinventory,
                             gtab_bom_explosion_table (i).supply_locator_id,
                             gtab_bom_explosion_table (i).component_remarks,
                             gtab_bom_explosion_table (i).change_notice,
                             gtab_bom_explosion_table (i).operation_lead_time_percent,
                             gtab_bom_explosion_table (i).mutually_exclusive_options,
                             gtab_bom_explosion_table (i).check_atp,
                             gtab_bom_explosion_table (i).required_to_ship,
                             gtab_bom_explosion_table (i).required_for_revenue,
                             gtab_bom_explosion_table (i).include_on_ship_docs,
                             gtab_bom_explosion_table (i).low_quantity,
                             gtab_bom_explosion_table (i).high_quantity,
                             gtab_bom_explosion_table (i).so_basis,
                             gtab_bom_explosion_table (i).operation_offset,
                             gtab_bom_explosion_table (i).current_revision,
                             gtab_bom_explosion_table (i).LOCATOR,
                             gtab_bom_explosion_table (i).item_cost,
                             gtab_bom_explosion_table (i).item_structure,
                             gtab_bom_explosion_table (i).actual_cost_type_id,
                             gtab_bom_explosion_table (i).extend_cost_flag
                            ));
            END LOOP;
         END;
      END;

      RETURN;
   END;
------------------------------------------------------------
END noetix_bom_explosion_pkg ;
/
show errors

@utlspoff
