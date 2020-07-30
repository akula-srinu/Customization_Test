-- Title
--   noetix_bom_explosion_pkg.sql
-- Function
--   Create the package noetix_bom_explosion_pkg. 
--
-- Description
--   Create the package noetix_bom_explosion_pkg.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   22-Aug-11 U Pisupati   created
--   05-Jan-12 P Upendra      standardized the pl/sql code.
--
--   05-JUN-2017	Selwyn Dorairaj   -- JIRA 873 -- Changed the seperator character to '~' for SYS_CONNECT_BY_PATH function

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


CREATE OR REPLACE PACKAGE BODY noetix_bom_explosion_pkg AS
    
    GC_PKG_VERSION   CONSTANT VARCHAR2(30)  := '6.5.1.1565';
    
    GC_SCRIPT        CONSTANT VARCHAR2(200)     := 'noetix_bom_explosion_pkg';
    GC_USER          CONSTANT VARCHAR2(30)      := USER;
    GC_LANGUAGE      CONSTANT VARCHAR2(30)      := NOETIX_ENV_PKG.GET_LANGUAGE;
    GC_SORTWIDTH     CONSTANT BINARY_INTEGER    := 7;
    
    GS_LOCATION      VARCHAR2(200)              := NULL;
    GS_ERROR_TEXT    VARCHAR2(200)              := NULL;
    GB_DEBUG_FLAG    BOOLEAN                    := FALSE;

   TYPE XXNAO_BOM_EXPLOSION_REC IS RECORD (
      TOP_BILL_SEQUENCE_ID          NUMBER,
      BILL_SEQUENCE_ID              NUMBER,
      ORGANIZATION_ID               NUMBER,
      COMPONENT_SEQUENCE_ID         NUMBER,
      COMPONENT_ITEM_ID             NUMBER,
      COMPONENT_QUANTITY            NUMBER,
      PLAN_LEVEL                    NUMBER,
      EXTENDED_QUANTITY             NUMBER,
      SORT_ORDER                    VARCHAR2(2000 BYTE),
      TOP_ALTERNATE_DESIGNATOR      VARCHAR2(10 BYTE),
      COMPONENT_YIELD_FACTOR        NUMBER,
      TOP_ITEM_ID                   NUMBER,
      COMPONENT_CODE                VARCHAR2(4000 BYTE),
      INCLUDE_IN_ROLLUP_FLAG        NUMBER,
      LOOP_FLAG                     NUMBER,
      PLANNING_FACTOR               NUMBER,
      OPERATION_SEQ_NUM             NUMBER,
      BOM_ITEM_TYPE                 NUMBER,
      PARENT_BOM_ITEM_TYPE          NUMBER,
      ASSEMBLY_ITEM_ID              NUMBER,
      WIP_SUPPLY_TYPE               NUMBER,
      ITEM_NUM                      NUMBER,
      EFFECTIVITY_DATE              DATE,
      DISABLE_DATE                  DATE,
      FROM_END_ITEM_UNIT_NUMBER     VARCHAR2 (30 BYTE),
      TO_END_ITEM_UNIT_NUMBER       VARCHAR2 (30 BYTE),
      IMPLEMENTATION_DATE           DATE,
      OPTIONAL                      NUMBER,
      SUPPLY_SUBINVENTORY           VARCHAR2 (10 BYTE),
      SUPPLY_LOCATOR_ID             NUMBER,
      COMPONENT_REMARKS             VARCHAR2 (240 BYTE),
      CHANGE_NOTICE                 VARCHAR2 (10 BYTE),
      OPERATION_LEAD_TIME_PERCENT   NUMBER,
      MUTUALLY_EXCLUSIVE_OPTIONS    NUMBER,
      CHECK_ATP                     NUMBER,
      REQUIRED_TO_SHIP              NUMBER,
      REQUIRED_FOR_REVENUE          NUMBER,
      INCLUDE_ON_SHIP_DOCS          NUMBER,
      LOW_QUANTITY                  NUMBER,
      HIGH_QUANTITY                 NUMBER,
      SO_BASIS                      NUMBER,
      OPERATION_OFFSET              NUMBER,
      CURRENT_REVISION              VARCHAR2 (3 BYTE),
      LOCATOR                       VARCHAR2 (40 BYTE),
      ITEM_COST                     NUMBER,
      ITEM_STRUCTURE                VARCHAR2 (4000),
      ACTUAL_COST_TYPE_ID           NUMBER,
      EXTEND_COST_FLAG              NUMBER
   );

   TYPE XXNAO_BOM_EXPLOSION_TABLE IS TABLE OF XXNAO_BOM_EXPLOSION_REC
      INDEX BY BINARY_INTEGER;

   GTAB_BOM_EXPLOSION_TABLE        XXNAO_BOM_EXPLOSION_TABLE;

   TYPE LTYP_NUMBER_TAB IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE LTYP_VARCHAR_TAB IS TABLE OF VARCHAR2 (4000)
      INDEX BY BINARY_INTEGER;

   TYPE LTYP_DATETABTYPE IS TABLE OF DATE
      INDEX BY BINARY_INTEGER;

   LTAB_CUR_LEVEL                  LTYP_NUMBER_TAB;
   LTAB_TBSI                       LTYP_NUMBER_TAB;
   LTAB_BSI                        LTYP_NUMBER_TAB;
   LTAB_CBSI                       LTYP_NUMBER_TAB;
   LTAB_CID                        LTYP_NUMBER_TAB;
   LTAB_CSI                        LTYP_NUMBER_TAB;
   LTAB_BT                         LTYP_NUMBER_TAB;
   LTAB_CQ                         LTYP_NUMBER_TAB;
   LTAB_EQ                         LTYP_NUMBER_TAB;
   LTAB_SO                         LTYP_VARCHAR_TAB;
   LTAB_TID                        LTYP_NUMBER_TAB;
   LTAB_TAD                        LTYP_VARCHAR_TAB;
   LTAB_CYF                        LTYP_NUMBER_TAB;
   LTAB_OI                         LTYP_NUMBER_TAB;
   LTAB_CC                         LTYP_VARCHAR_TAB;
   LTAB_IICR                       LTYP_NUMBER_TAB;
   LTAB_LF                         LTYP_NUMBER_TAB;
   LTAB_PF                         LTYP_NUMBER_TAB;
   LTAB_OSN                        LTYP_NUMBER_TAB;
   LTAB_BIT                        LTYP_NUMBER_TAB;
   LTAB_PBIT                       LTYP_NUMBER_TAB;
   LTAB_PAID                       LTYP_NUMBER_TAB;
   LTAB_WST                        LTYP_NUMBER_TAB;
   LTAB_ITN                        LTYP_NUMBER_TAB;
   LTAB_ED                         LTYP_DATETABTYPE;
   LTAB_DD                         LTYP_DATETABTYPE;
   LTAB_ID                         LTYP_DATETABTYPE;
   LTAB_FUN                        LTYP_VARCHAR_TAB;
   LTAB_EUN                        LTYP_VARCHAR_TAB;
   LTAB_OPT                        LTYP_NUMBER_TAB;
   LTAB_SS                         LTYP_VARCHAR_TAB;
   LTAB_SLI                        LTYP_NUMBER_TAB;
   LTAB_CR                         LTYP_VARCHAR_TAB;
   LTAB_CN                         LTYP_VARCHAR_TAB;
   LTAB_OLTP                       LTYP_NUMBER_TAB;
   LTAB_MEO                        LTYP_NUMBER_TAB;
   LTAB_CATP                       LTYP_NUMBER_TAB;
   LTAB_RTS                        LTYP_NUMBER_TAB;
   LTAB_RFR                        LTYP_NUMBER_TAB;
   LTAB_IOSD                       LTYP_NUMBER_TAB;
   LTAB_LQ                         LTYP_NUMBER_TAB;
   LTAB_HQ                         LTYP_NUMBER_TAB;
   LTAB_SB                         LTYP_NUMBER_TAB;
   LTAB_COST                       LTYP_NUMBER_TAB;
   LTAB_OPERATION_OFFSET           LTYP_NUMBER_TAB;
   LTAB_CURRENT_REVISION           LTYP_VARCHAR_TAB;
   LTAB_LOCATOR                    LTYP_VARCHAR_TAB;
   LTAB_ITEM_STRUCTURE             LTYP_VARCHAR_TAB;
   LTAB_ALTERNATE_BOM_DESIGNATOR   LTYP_VARCHAR_TAB;
   LTAB_COST_TYPE_ID               LTYP_VARCHAR_TAB;
   LTAB_EXTEND_COST_FLAG           LTYP_VARCHAR_TAB;


    FUNCTION GET_VERSION
      RETURN VARCHAR2 IS
    BEGIN
       RETURN GC_PKG_VERSION;
    END GET_VERSION;

    FUNCTION EXPLODER( I_ORG_ID              IN   NUMBER,
                       I_CST_TYPE_ID         IN   NUMBER DEFAULT 0,
                       I_ITEM_ID             IN   NUMBER,
                       I_ALT_DESG            IN   VARCHAR2,
                       I_ASSEMBLY_REVISION   IN   VARCHAR2  )
      RETURN XXNAO_BOM_EXPLOSION_TBL PIPELINED AS

        PRAGMA AUTONOMOUS_TRANSACTION;

        
        LC_GROUP_ID            CONSTANT     BINARY_INTEGER  := 1000;
        LC_LEVELS_TO_EXPLODE   CONSTANT     BINARY_INTEGER  := 10;
        LC_MAX_LEVEL           CONSTANT     BINARY_INTEGER  := 60;
        LC_EXPLODE_OPTION      CONSTANT     BINARY_INTEGER  := 3;
        LC_SHOW_REV            CONSTANT     BINARY_INTEGER  := 1;
        LC_LEAD_TIME           CONSTANT     BINARY_INTEGER  := 2;
        LC_STD_COMP_FLAG       CONSTANT     BINARY_INTEGER  := 2;
        LC_VERIFY_FLAG         CONSTANT     BINARY_INTEGER  := 0;
        LB_LOOP_FOUND                       BOOLEAN         := FALSE;
        LB_MAX_LEVEL_EXCEEDED               BOOLEAN         := FALSE;
        LD_REV_DATE                         DATE            := SYSDATE;
        LI_ORDER_BY            CONSTANT     BINARY_INTEGER  := 1;
        LI_BOM_OR_ENG          CONSTANT	    BINARY_INTEGER  := 1;
        LI_IMPL_FLAG           CONSTANT     BINARY_INTEGER  := 1;
        LI_PLAN_FACTOR_FLAG    CONSTANT     BINARY_INTEGER  := 2;
        LI_MODULE                           BINARY_INTEGER  := 1;
        LI_EXPL_QTY            CONSTANT     BINARY_INTEGER  := 1;
        LI_COMP_CODE           CONSTANT     VARCHAR2 (1000) := NULL;
        LI_STMT_NUM            CONSTANT     BINARY_INTEGER  := 1;
        LI_SORTWIDTH           CONSTANT     BINARY_INTEGER  := 7;
        LI_CNT                              BINARY_INTEGER  := 0;
        LI_T_CONVERSION_RATE                NUMBER;
        LI_T_MASTER_ORG_ID                  NUMBER;
        LI_MAX_LEVEL                        BINARY_INTEGER;
        LI_LEVELS_TO_EXPLODE                BINARY_INTEGER;
        LI_EXPLODE_OPTION                   BINARY_INTEGER;
        LI_INCL_OC_FLAG                     BINARY_INTEGER;
        LI_STD_COMP_FLAG                    BINARY_INTEGER;
        LI_PREV_TOP_BILL_ID                 NUMBER;
        LI_CUM_COUNT                        NUMBER;
        LI_TOTAL_ROWS                       NUMBER;
        LI_START_POS                        BINARY_INTEGER;
        LI_LOOP_COUNT_VAL                   NUMBER          := 0;
        LS_UNIT_NUMBER_FROM                 VARCHAR2 (1000) := NULL;
        LS_UNIT_NUMBER_TO                   VARCHAR2 (1000) := NULL;
        LS_IS_COST_ORGANIZATION             VARCHAR2 (1);
        LS_T_CHILD_UOM                      VARCHAR (3);
        LS_T_MASTER_UOM                     VARCHAR (3);
        LS_PREV_SORT_ORDER                  VARCHAR2(2000);
        LS_CAT_SORT                         VARCHAR2(7);
        LS_IMPL_ECO                         VARCHAR2(20);
        LS_CUR_COMPONENT                    VARCHAR2(16);
        LS_CUR_SUBSTR                       VARCHAR2(16);
        LS_CUR_LOOPSTR                      VARCHAR2(1000);

        NO_REVISION_FOUND      EXCEPTION;
        PRAGMA EXCEPTION_INIT (NO_REVISION_FOUND, -20001);


      CURSOR C_ORG_CHECK( P_GROUP_ID    NUMBER ) IS
      SELECT BET.ORGANIZATION_ID            CUROI, 
             BET.BILL_SEQUENCE_ID           CURBSI,
             BET.COMPONENT_SEQUENCE_ID      CURCSI,
             BET.COMPONENT_ITEM_ID          CURCII,
             BET.COMMON_BILL_SEQUENCE_ID    CURCBSI, 
             BET.GROUP_ID                   CURGI,
             BET.PRIMARY_UOM_CODE           CURPUC
        FROM N_TMP_BOM_EXPLOSION BET
       WHERE BET.BILL_SEQUENCE_ID <> BET.COMMON_BILL_SEQUENCE_ID
         AND BET.GROUP_ID          = P_GROUP_ID;

      CURSOR C_CONVERSION ( P_MASTER_UOM      VARCHAR2,
                            P_CHILD_UOM       VARCHAR2,
                            P_INV_ID          NUMBER,
                            P_MASTER_ORG_ID   NUMBER   ) IS
      SELECT CONV.CONVERSION_RATE CONVERSION_RATE
        FROM ( SELECT MSI.INVENTORY_ITEM_ID, 
                      MSI.ORGANIZATION_ID,
                      MSI.PRIMARY_UNIT_OF_MEASURE, 
                      MSI.PRIMARY_UOM_CODE, 
                      UOM.UOM_CLASS,
                      UOM2.UNIT_OF_MEASURE, 
                      UOM2.UOM_CODE, 
                      CONV2.UOM_CLASS,
                      ( ( CASE UOM.UOM_CLASS
                            WHEN UOM2.UOM_CLASS THEN 1
                            ELSE CLASS.CONVERSION_RATE
                          END ) * CONV2.CONVERSION_RATE / 
                             ( CASE 
                                 WHEN ( CONV1.INVENTORY_ITEM_ID IS NULL ) THEN 
                                             ( CASE LEAST(NVL(CONV1_2.DISABLE_DATE, SYSDATE), SYSDATE )
                                                 WHEN SYSDATE THEN CONV1_2.CONVERSION_RATE
                                                 ELSE NULL
                                               END )
                                 ELSE ( CASE LEAST(NVL (CONV1.DISABLE_DATE, SYSDATE), SYSDATE)
                                          WHEN SYSDATE THEN CONV1.CONVERSION_RATE
                                          ELSE CONV1_2.CONVERSION_RATE
                                        END  )
                               END ) )                                                         CONVERSION_RATE
                 FROM MTL_UOM_CONVERSIONS_S        CONV1,
                      MTL_UOM_CONVERSIONS_S        CONV2,
                      MTL_UOM_CONVERSIONS_S        CONV1_2,
                      MTL_UNITS_OF_MEASURE_TL_S    UOM,
                      MTL_UNITS_OF_MEASURE_TL_S    UOM2,
                      MTL_UOM_CLASS_CONVERSIONS_S  CLASS,
                      MTL_SYSTEM_ITEMS_B_S         MSI
                WHERE UOM.UOM_CODE              = MSI.PRIMARY_UOM_CODE
                  AND UOM.LANGUAGE (+)       LIKE GC_LANGUAGE
                  AND UOM2.UOM_CLASS            = ( CASE UOM.UOM_CLASS
                                                      WHEN UOM2.UOM_CLASS THEN UOM2.UOM_CLASS
                                                      ELSE CLASS.TO_UOM_CLASS
                                                     END  )
                  AND UOM2.LANGUAGE (+)      LIKE GC_LANGUAGE
                  AND (    CLASS.TO_UOM_CLASS  IS NULL
                        OR CLASS.TO_UOM_CLASS   =
                         ( SELECT CLASS2.TO_UOM_CLASS
                             FROM MTL_UOM_CLASS_CONVERSIONS_S CLASS2
                            WHERE CLASS2.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
                              AND UOM2.UOM_CLASS           = ( CASE UOM.UOM_CLASS
                                                                 WHEN UOM2.UOM_CLASS THEN UOM2.UOM_CLASS
                                                                 ELSE CLASS2.TO_UOM_CLASS
                                                               END  )
                              AND UOM.UOM_CLASS            = ( CASE UOM.UOM_CLASS
                                                                 WHEN UOM2.UOM_CLASS THEN UOM.UOM_CLASS
                                                                 ELSE CLASS2.FROM_UOM_CLASS
                                                               END )
                              AND ROWNUM                   = 1)
                      )
                  AND CONV1.INVENTORY_ITEM_ID (+)        = MSI.INVENTORY_ITEM_ID
                  AND CONV1_2.INVENTORY_ITEM_ID (+)      = 0
                  AND CONV1.UOM_CODE (+)                 = MSI.PRIMARY_UOM_CODE
                  AND CONV1_2.UOM_CODE (+)               = MSI.PRIMARY_UOM_CODE
                  AND ( CASE 
                          WHEN ( CONV1.INVENTORY_ITEM_ID IS NULL ) THEN
                                  ( CASE LEAST(NVL(CONV1_2.DISABLE_DATE, SYSDATE), SYSDATE )
                                      WHEN SYSDATE THEN CONV1_2.CONVERSION_RATE
                                      ELSE NULL
                                    END )
                          ELSE ( CASE LEAST(NVL (CONV1.DISABLE_DATE, SYSDATE), SYSDATE)
                                   WHEN SYSDATE THEN CONV1.CONVERSION_RATE
                                   ELSE CONV1_2.CONVERSION_RATE
                                 END  )
                        END )                           IS NOT NULL
                  AND ( CASE UOM.UOM_CLASS
                          WHEN UOM2.UOM_CLASS THEN 1
                          ELSE ( CASE LEAST (NVL (CLASS.DISABLE_DATE, SYSDATE), SYSDATE)
                                   WHEN SYSDATE THEN 1 
                                   ELSE NULL
                                 END  )
                        END  )                          IS NOT NULL
                  AND CLASS.INVENTORY_ITEM_ID (+)        = MSI.INVENTORY_ITEM_ID
                  AND UOM.UOM_CLASS                      = ( CASE UOM.UOM_CLASS
                                                               WHEN UOM2.UOM_CLASS THEN UOM.UOM_CLASS
                                                               ELSE CLASS.FROM_UOM_CLASS
                                                             END  )
                  AND ( CONV2.INVENTORY_ITEM_ID, 
                        CONV2.UOM_CODE )                 =
                                  ( SELECT MAX(CONV_SUB2.INVENTORY_ITEM_ID), 
                                           UOM2.UOM_CODE
                                      FROM MTL_UOM_CONVERSIONS_S   CONV_SUB2
                                     WHERE CONV_SUB2.UOM_CODE            = UOM2.UOM_CODE
                                       AND CONV_SUB2.INVENTORY_ITEM_ID  IN ( MSI.INVENTORY_ITEM_ID, 0 )
                                       AND NVL(CLASS.INVENTORY_ITEM_ID, 1) 
                                                                        IS NOT NULL
                                       AND NVL(CONV_SUB2.DISABLE_DATE, SYSDATE + 1) 
                                                                         > SYSDATE ) ) CONV
       WHERE CONV.PRIMARY_UOM_CODE  = P_MASTER_UOM
         AND CONV.UOM_CODE          = P_CHILD_UOM
         AND CONV.INVENTORY_ITEM_ID = P_INV_ID
         AND CONV.ORGANIZATION_ID   = P_MASTER_ORG_ID;

      CURSOR C_EXPLODER( P_LEVEL              NUMBER,
                         P_GRP_ID             NUMBER,
                         P_ORG_ID             NUMBER,
                         P_BOM_OR_ENG         NUMBER,
                         P_REV_DATE           DATE,
                         P_IMPL_FLAG          NUMBER,
                         P_EXPLODE_OPTION     NUMBER,
                         P_ORDER_BY           NUMBER,
                         P_VERIFY_FLAG        NUMBER,
                         P_PLAN_FACTOR_FLAG   NUMBER,
                         P_STD_COMP_FLAG      NUMBER,
                         P_INCL_OC            NUMBER,
                         P_UNIT_NUMBER_FROM   VARCHAR2,
                         P_UNIT_NUMBER_TO     VARCHAR2 ) IS
      SELECT BET.TOP_BILL_SEQUENCE_ID       TBSI, 
             BOM.BILL_SEQUENCE_ID           BSI,
             BOM.COMMON_BILL_SEQUENCE_ID    CBSI, 
             BIC.COMPONENT_ITEM_ID          CID,
             BIC.COMPONENT_SEQUENCE_ID      CSI,
             
             BIC.COMPONENT_QUANTITY         CQ,
             (  BIC.COMPONENT_QUANTITY * 
                BET.EXTENDED_QUANTITY  * 
                ( CASE P_PLAN_FACTOR_FLAG
                    WHEN 1 THEN (BIC.PLANNING_FACTOR / 100 )
                    ELSE 1
                  END )                / 
                ( CASE BIC.COMPONENT_YIELD_FACTOR
                    WHEN 0 THEN 1
                    ELSE BIC.COMPONENT_YIELD_FACTOR
                  END )              )      EQ,
             BET.SORT_ORDER                 SO, 
             BET.TOP_ITEM_ID                TID,
             BET.TOP_ALTERNATE_DESIGNATOR   TAD,
             BIC.COMPONENT_YIELD_FACTOR     CYF, 
             BOM.ORGANIZATION_ID            OI,
             BET.COMPONENT_CODE             CC, 
             BIC.INCLUDE_IN_COST_ROLLUP     IICR,
             BET.LOOP_FLAG                  LF, 
             BIC.PLANNING_FACTOR            PF,
             BIC.OPERATION_SEQ_NUM          OSN, 
             BIC.BOM_ITEM_TYPE              BIT,
             BET.BOM_ITEM_TYPE              PBIT, 
             BET.COMPONENT_ITEM_ID          PAID,
             BIC.WIP_SUPPLY_TYPE            WST, 
             BIC.ITEM_NUM                   ITN,
             BIC.EFFECTIVITY_DATE           ED, 
             BIC.DISABLE_DATE               DD,
             BIC.IMPLEMENTATION_DATE        ID,
             BIC.FROM_END_ITEM_UNIT_NUMBER  FUN,
             BIC.TO_END_ITEM_UNIT_NUMBER    EUN, 
             BIC.OPTIONAL                   OPT,
             BIC.SUPPLY_SUBINVENTORY        SS, 
             BIC.SUPPLY_LOCATOR_ID          SLI,
             BIC.COMPONENT_REMARKS          CR, 
             BIC.CHANGE_NOTICE              CN,
             BIC.OPERATION_LEAD_TIME_PERCENT OLTP,
             BIC.MUTUALLY_EXCLUSIVE_OPTIONS MEO, 
             BIC.CHECK_ATP                  CATP,
             BIC.REQUIRED_TO_SHIP           RTS, 
             BIC.REQUIRED_FOR_REVENUE       RFR,
             BIC.INCLUDE_ON_SHIP_DOCS       IOSD, 
             BIC.LOW_QUANTITY               LQ,
             BIC.HIGH_QUANTITY              HQ, 
             BIC.SO_BASIS                   SB, 
             BET.OPERATION_OFFSET,
             BET.CURRENT_REVISION, 
             BET.LOCATOR,
             BOM.ALTERNATE_BOM_DESIGNATOR   
        FROM N_TMP_BOM_EXPLOSION  BET,
             BOM_STRUCTURES_B_S   BOM,
             MTL_SYSTEM_ITEMS_B_S SI,
             BOM_COMPONENTS_B_S   BIC
       WHERE BET.PLAN_LEVEL                 = P_LEVEL - 1
         AND BET.GROUP_ID                   = P_GRP_ID
         AND BOM.ASSEMBLY_ITEM_ID           = SI.INVENTORY_ITEM_ID
         AND BOM.ORGANIZATION_ID            = SI.ORGANIZATION_ID
         AND BOM.COMMON_BILL_SEQUENCE_ID    = BIC.BILL_SEQUENCE_ID
         AND BET.COMPONENT_ITEM_ID          = BOM.ASSEMBLY_ITEM_ID
         AND BOM.ORGANIZATION_ID            = P_ORG_ID
         AND NVL (BIC.ECO_FOR_PRODUCTION, 2) = 2
         AND (   (    P_STD_COMP_FLAG = 1          
                  AND BIC.BOM_ITEM_TYPE = 4
                  AND BIC.OPTIONAL = 2
                 )
              OR (P_STD_COMP_FLAG = 2)
              OR (    P_STD_COMP_FLAG = 3
                  AND NVL (BET.BOM_ITEM_TYPE, 1) IN (1, 2)
                  AND (   BIC.BOM_ITEM_TYPE IN (1, 2)
                       OR (BIC.BOM_ITEM_TYPE = 4 AND BIC.OPTIONAL = 1)
                      )
                 )
             )
         AND (   (    P_BOM_OR_ENG      = 1 
                  AND BOM.ASSEMBLY_TYPE = 1)
              OR (P_BOM_OR_ENG = 2)
             )
         AND (   (    BET.TOP_ALTERNATE_DESIGNATOR IS NULL
                  AND BOM.ALTERNATE_BOM_DESIGNATOR IS NULL      )
              OR (    BET.TOP_ALTERNATE_DESIGNATOR IS NOT NULL
                  AND BOM.ALTERNATE_BOM_DESIGNATOR =
                                             BET.TOP_ALTERNATE_DESIGNATOR
                 )
              OR (    BET.TOP_ALTERNATE_DESIGNATOR IS NOT NULL
                  AND BOM.ALTERNATE_BOM_DESIGNATOR IS NULL
                  AND NOT EXISTS 
                    ( SELECT 'X'
                        FROM BOM_STRUCTURES_B_S BOM2
                       WHERE BOM2.ORGANIZATION_ID           = P_ORG_ID
                         AND BOM2.ASSEMBLY_ITEM_ID          = BET.COMPONENT_ITEM_ID
                         AND BOM2.ALTERNATE_BOM_DESIGNATOR  = BET.TOP_ALTERNATE_DESIGNATOR
                         AND (   (    P_BOM_OR_ENG = 1
                                  AND BOM2.ASSEMBLY_TYPE = 1 )
                              OR P_BOM_OR_ENG = 2
                             ))                            
                 )
             )                                        


         AND (   (     P_INCL_OC          = 1 )
              OR (     P_INCL_OC          = 2
                   AND BET.BOM_ITEM_TYPE  = 4 
                   AND BIC.BOM_ITEM_TYPE  = 4 )
              OR (     BET.BOM_ITEM_TYPE <> 4 ) )


         AND NOT (    BET.PARENT_BOM_ITEM_TYPE = 4
                  AND BET.BOM_ITEM_TYPE IN (1, 2)  )
         AND (   (    NVL (SI.EFFECTIVITY_CONTROL, 1) = 2
                  AND (   (P_EXPLODE_OPTION = 1)                  
                       OR (    P_EXPLODE_OPTION IN (2, 3)
                           AND BIC.DISABLE_DATE IS NULL ) )
                  AND P_UNIT_NUMBER_FROM <=
                         NVL (BIC.TO_END_ITEM_UNIT_NUMBER,
                              P_UNIT_NUMBER_FROM
                             )
                  AND P_UNIT_NUMBER_TO >= BIC.FROM_END_ITEM_UNIT_NUMBER
                  AND BIC.FROM_END_ITEM_UNIT_NUMBER <=
                         NVL (BET.TO_END_ITEM_UNIT_NUMBER,
                              BIC.FROM_END_ITEM_UNIT_NUMBER
                             )
                  AND NVL (BIC.TO_END_ITEM_UNIT_NUMBER,
                           NVL (BET.FROM_END_ITEM_UNIT_NUMBER,
                                BIC.FROM_END_ITEM_UNIT_NUMBER
                               )
                          ) >=
                         NVL (BET.FROM_END_ITEM_UNIT_NUMBER,
                              BIC.FROM_END_ITEM_UNIT_NUMBER
                             )
                  AND (   (    P_IMPL_FLAG = 1
                           AND BIC.IMPLEMENTATION_DATE IS NOT NULL
                          )
                       OR P_IMPL_FLAG = 2
                      )
                 )
              OR (    NVL (SI.EFFECTIVITY_CONTROL, 1) = 1
                  AND (   (    P_EXPLODE_OPTION = 1
                           AND (   P_LEVEL = 1
                                OR (    BIC.EFFECTIVITY_DATE <=
                                           NVL (BET.DISABLE_DATE,
                                                BIC.EFFECTIVITY_DATE
                                               )
                                    AND NVL (BIC.DISABLE_DATE,
                                             BET.EFFECTIVITY_DATE
                                            ) >= BET.EFFECTIVITY_DATE
                                   )
                               )
                          )                                        
                       OR (    P_EXPLODE_OPTION = 2
                           AND                                 
                               P_REV_DATE >= BIC.EFFECTIVITY_DATE
                           AND P_REV_DATE <
                                   NVL (BIC.DISABLE_DATE, P_REV_DATE + 1)
                          )                                    
                       OR (    P_EXPLODE_OPTION = 3 
                           AND NVL (BIC.DISABLE_DATE, P_REV_DATE + 1) >
                                                               P_REV_DATE
                          )                         
                      )
                  AND (   (    P_IMPL_FLAG = 2
                           AND (   P_EXPLODE_OPTION = 1
                                OR (    P_EXPLODE_OPTION = 2
                                    AND NOT EXISTS (
                                           SELECT NULL
                                             FROM BOM_COMPONENTS_B_S CIB
                                            WHERE CIB.BILL_SEQUENCE_ID  = BIC.BILL_SEQUENCE_ID
                                              AND CIB.COMPONENT_ITEM_ID = BIC.COMPONENT_ITEM_ID
                                              AND NVL( CIB.ECO_FOR_PRODUCTION, 2 ) = 2
                                              AND ( ( CASE 
                                                        WHEN ( CIB.IMPLEMENTATION_DATE IS NULL ) THEN CIB.OLD_COMPONENT_SEQUENCE_ID
                                                        ELSE CIB.COMPONENT_SEQUENCE_ID
                                                      END ) = ( CASE
                                                                  WHEN ( BIC.IMPLEMENTATION_DATE IS NULL ) THEN BIC.OLD_COMPONENT_SEQUENCE_ID
                                                                  ELSE BIC.COMPONENT_SEQUENCE_ID
                                                                END )
                                                   OR CIB.OPERATION_SEQ_NUM = BIC.OPERATION_SEQ_NUM
                                                  )             
                                              AND CIB.EFFECTIVITY_DATE <= P_REV_DATE
                                              AND BIC.EFFECTIVITY_DATE  < CIB.EFFECTIVITY_DATE)
                                                       
                                   )                           
                                OR (     P_EXPLODE_OPTION = 3
                                     AND NOT EXISTS 
                                       ( SELECT NULL
                                           FROM BOM_COMPONENTS_B_S CIB
                                          WHERE CIB.BILL_SEQUENCE_ID  = BIC.BILL_SEQUENCE_ID
                                            AND CIB.COMPONENT_ITEM_ID = BIC.COMPONENT_ITEM_ID
                                            AND NVL( CIB.ECO_FOR_PRODUCTION, 2 ) = 2
                                            AND (   ( CASE 
                                                        WHEN ( CIB.IMPLEMENTATION_DATE IS NULL ) THEN CIB.OLD_COMPONENT_SEQUENCE_ID
                                                        ELSE CIB.COMPONENT_SEQUENCE_ID
                                                      END ) = ( CASE 
                                                                  WHEN ( BIC.IMPLEMENTATION_DATE IS NULL ) THEN BIC.OLD_COMPONENT_SEQUENCE_ID
                                                                  ELSE BIC.COMPONENT_SEQUENCE_ID
                                                                END )
                                                  OR CIB.OPERATION_SEQ_NUM = BIC.OPERATION_SEQ_NUM )          
                                            AND CIB.EFFECTIVITY_DATE <= P_REV_DATE
                                            AND BIC.EFFECTIVITY_DATE  < CIB.EFFECTIVITY_DATE )
                                                       
                                    OR BIC.EFFECTIVITY_DATE > P_REV_DATE
                                   )                
                               )                        
                          )                              
                       OR (    P_IMPL_FLAG              = 1
                           AND BIC.IMPLEMENTATION_DATE IS NOT NULL )
                      )                                 
                 )
             )
         AND BET.LOOP_FLAG = 2
       ORDER BY BET.TOP_BILL_SEQUENCE_ID,
                BET.SORT_ORDER,
                ( CASE P_ORDER_BY WHEN 1 THEN BIC.OPERATION_SEQ_NUM ELSE BIC.ITEM_NUM END ),
                ( CASE P_ORDER_BY WHEN 1 THEN BIC.ITEM_NUM          ELSE BIC.OPERATION_SEQ_NUM END );

      CURSOR C_GET_OLTP( P_ASSEMBLY    NUMBER,
                         P_ALTERNATE   VARCHAR2,
                         P_OPERATION   NUMBER,
                         P_REV_DATE    DATE     ) IS
         SELECT ROUND(BOS.OPERATION_LEAD_TIME_PERCENT, 2) OLTP
           FROM BOM_OPERATION_SEQUENCES_S  BOS,
                BOM_OPERATIONAL_ROUTINGS_S BOR
          WHERE BOR.ASSEMBLY_ITEM_ID        = P_ASSEMBLY
            AND BOR.ORGANIZATION_ID         = I_ORG_ID
            AND (   BOR.ALTERNATE_ROUTING_DESIGNATOR = P_ALTERNATE
                 OR (    BOR.ALTERNATE_ROUTING_DESIGNATOR IS NULL
                     AND NOT EXISTS 
                       ( SELECT NULL
                           FROM BOM_OPERATIONAL_ROUTINGS_S BOR2
                          WHERE BOR2.ASSEMBLY_ITEM_ID               = P_ASSEMBLY
                            AND BOR2.ORGANIZATION_ID                = I_ORG_ID
                            AND BOR2.ALTERNATE_ROUTING_DESIGNATOR   = P_ALTERNATE ) )
                )
            AND BOR.COMMON_ROUTING_SEQUENCE_ID      = BOS.ROUTING_SEQUENCE_ID
            AND BOS.OPERATION_SEQ_NUM               = P_OPERATION
            AND BOS.EFFECTIVITY_DATE               <= TRUNC(P_REV_DATE)
            AND NVL(BOS.DISABLE_DATE, 
                    P_REV_DATE + 1)                >= TRUNC(P_REV_DATE);

      CURSOR C_CALCULATE_OFFSET( P_PARENTITEM   NUMBER, 
                                 P_PERCENT      NUMBER  ) IS
      SELECT P_PERCENT / 100 * MSI.FULL_LEAD_TIME OFFSET
        FROM MTL_SYSTEM_ITEMS_B_S MSI
       WHERE MSI.INVENTORY_ITEM_ID   = P_PARENTITEM
         AND MSI.ORGANIZATION_ID     = I_ORG_ID;

      CURSOR C_FINAL_DATA IS
      SELECT UP1.TOP_BILL_SEQUENCE_ID, 
             UP1.BILL_SEQUENCE_ID,
             UP1.COMMON_BILL_SEQUENCE_ID, 
             UP1.ORGANIZATION_ID,
             UP1.COMPONENT_SEQUENCE_ID, 
             UP1.COMPONENT_ITEM_ID,
             
             UP1.COMPONENT_QUANTITY, 
             UP1.PLAN_LEVEL, 
             UP1.EXTENDED_QUANTITY,
             UP1.SORT_ORDER, 
             UP1.TOP_ALTERNATE_DESIGNATOR,
             UP1.COMPONENT_YIELD_FACTOR, 
             UP1.TOP_ITEM_ID, 
             UP1.COMPONENT_CODE,
             UP1.INCLUDE_IN_ROLLUP_FLAG, 
             UP1.LOOP_FLAG, 
             UP1.PLANNING_FACTOR,
             UP1.OPERATION_SEQ_NUM, 
             UP1.BOM_ITEM_TYPE, 
             UP1.PARENT_BOM_ITEM_TYPE,
             UP1.ASSEMBLY_ITEM_ID, 
             UP1.WIP_SUPPLY_TYPE, 
             UP1.ITEM_NUM,
             UP1.EFFECTIVITY_DATE, 
             UP1.DISABLE_DATE, 
             UP1.FROM_END_ITEM_UNIT_NUMBER,
             UP1.TO_END_ITEM_UNIT_NUMBER, 
             UP1.IMPLEMENTATION_DATE, 
             UP1.OPTIONAL,
             UP1.SUPPLY_SUBINVENTORY, 
             UP1.SUPPLY_LOCATOR_ID, 
             UP1.COMPONENT_REMARKS,
             UP1.CHANGE_NOTICE, 
             UP1.OPERATION_LEAD_TIME_PERCENT,
             UP1.MUTUALLY_EXCLUSIVE_OPTIONS, 
             UP1.CHECK_ATP, 
             UP1.REQUIRED_TO_SHIP,
             UP1.REQUIRED_FOR_REVENUE, 
             UP1.INCLUDE_ON_SHIP_DOCS, 
             UP1.LOW_QUANTITY,
             UP1.HIGH_QUANTITY, 
             UP1.SO_BASIS, 
             UP1.OPERATION_OFFSET,
             UP1.CURRENT_REVISION, 
             UP1.LOCATOR, 
             UP1.ITEM_COST,
             LTRIM( SYS_CONNECT_BY_PATH (UP1.ITEM_NUM, '~'),
                    '~'  )                                      ITEM_STRUCTURE,	-- JIRA 873 Changed separator chanracter
             UP1.ACTUAL_COST_TYPE_ID, 
             UP1.EXTEND_COST_FLAG
        FROM N_TMP_BOM_EXPLOSION UP1
       START WITH UP1.ASSEMBLY_ITEM_ID = UP1.TOP_ITEM_ID
     CONNECT BY NOCYCLE PRIOR UP1.COMPONENT_ITEM_ID = UP1.ASSEMBLY_ITEM_ID
               AND NVL (PRIOR UP1.PLAN_LEVEL, -1)   = NVL( UP1.PLAN_LEVEL - 1, -1)
               AND PRIOR UP1.SORT_ORDER             = SUBSTR(UP1.SORT_ORDER,
                                                             1, LENGTH (UP1.SORT_ORDER) - GC_SORTWIDTH )
      ORDER BY SORT_ORDER;

      PROCEDURE DEL_TAB IS
      BEGIN
         DELETE FROM N_TMP_BOM_EXPLOSION;
      END;

   BEGIN
      DEL_TAB;

      IF ( I_CST_TYPE_ID <> 0 ) THEN
         LI_MODULE := 1;
      ELSE
         LI_MODULE := 0;
      END IF;


      INSERT INTO N_TMP_BOM_EXPLOSION
           ( GROUP_ID, 
             BILL_SEQUENCE_ID, 
             COMPONENT_SEQUENCE_ID,
             ORGANIZATION_ID, 
             TOP_ITEM_ID, 
             COMPONENT_ITEM_ID,
             PLAN_LEVEL, 
             EXTENDED_QUANTITY, 
             BASIS_TYPE,
             COMPONENT_QUANTITY, 
             SORT_ORDER, 
             PROGRAM_UPDATE_DATE,
             TOP_BILL_SEQUENCE_ID, 
             COMPONENT_CODE, 
             LOOP_FLAG,
             TOP_ALTERNATE_DESIGNATOR, 
             BOM_ITEM_TYPE,
             PARENT_BOM_ITEM_TYPE)
      SELECT LC_GROUP_ID, 
             BOM.BILL_SEQUENCE_ID, 
             NULL, 
             I_ORG_ID, 
             I_ITEM_ID,
             I_ITEM_ID, 
             0, 
             LI_EXPL_QTY, 
             1, 
             1, 
             LPAD('1', LI_SORTWIDTH, '0'),
             SYSDATE, 
             BOM.BILL_SEQUENCE_ID,
             NVL(LI_COMP_CODE, LPAD (I_ITEM_ID, 16, '0')),
             2, 
             I_ALT_DESG,
             MSI.BOM_ITEM_TYPE, 
             MSI.BOM_ITEM_TYPE
        FROM BOM_STRUCTURES_B_S BOM, 
             MTL_SYSTEM_ITEMS_B_S MSI
       WHERE BOM.ASSEMBLY_ITEM_ID                       = I_ITEM_ID
         AND BOM.ORGANIZATION_ID                        = I_ORG_ID
         AND NVL (BOM.ALTERNATE_BOM_DESIGNATOR, 'NONE') = NVL (I_ALT_DESG, 'NONE')
         AND MSI.ORGANIZATION_ID                        = I_ORG_ID
         AND MSI.INVENTORY_ITEM_ID                      = I_ITEM_ID;

      IF ( SQL%NOTFOUND ) THEN
         RAISE NO_DATA_FOUND;
      END IF;



        
      BEGIN
         LI_LEVELS_TO_EXPLODE := LC_LEVELS_TO_EXPLODE;
         LI_EXPLODE_OPTION    := LC_EXPLODE_OPTION;

         
         SELECT NVL (MIN (REV2.EFFECTIVITY_DATE - 1 / (60 * 60 * 24)),
                       GREATEST (SYSDATE, REV1.EFFECTIVITY_DATE)
                      )
           INTO LD_REV_DATE
           FROM MTL_ITEM_REVISIONS_B_S REV2,
                MTL_ITEM_REVISIONS_B_S REV1
          WHERE REV1.ORGANIZATION_ID        = REV2.ORGANIZATION_ID(+)
            AND REV1.INVENTORY_ITEM_ID      = REV2.INVENTORY_ITEM_ID(+)
            AND REV2.EFFECTIVITY_DATE (+)   > REV1.EFFECTIVITY_DATE
            AND REV1.INVENTORY_ITEM_ID      = I_ITEM_ID
            AND REV1.ORGANIZATION_ID        = I_ORG_ID
            AND REV1.REVISION               = I_ASSEMBLY_REVISION
       GROUP BY REV1.ORGANIZATION_ID,
                REV1.INVENTORY_ITEM_ID,
                REV1.REVISION_ID,
                REV1.REVISION,
                REV1.EFFECTIVITY_DATE,
                REV1.IMPLEMENTATION_DATE,
                REV1.CHANGE_NOTICE;

         




         SELECT MAX(MAXIMUM_BOM_LEVEL)
           INTO LI_MAX_LEVEL
           FROM BOM_PARAMETERS_S
          WHERE (I_ORG_ID = -1 OR (I_ORG_ID <> -1 AND ORGANIZATION_ID = I_ORG_ID));

         
         
         IF ( NVL(LI_MAX_LEVEL, LC_MAX_LEVEL) > (LC_MAX_LEVEL-1) ) THEN
            LI_MAX_LEVEL := (LC_MAX_LEVEL-1);
         END IF;

         


         IF (LI_LEVELS_TO_EXPLODE < 0) OR (LI_LEVELS_TO_EXPLODE > LI_MAX_LEVEL)
         THEN
            LI_LEVELS_TO_EXPLODE := LI_MAX_LEVEL;
         END IF;

         IF (    LI_MODULE = 1 
              OR LI_MODULE = 2 ) THEN                                
            LI_STD_COMP_FLAG := 2;                                   
         ELSE
            LI_STD_COMP_FLAG := LC_STD_COMP_FLAG;
         END IF;

         IF ( LI_MODULE = 1 )  THEN                  
            LI_INCL_OC_FLAG := 2;
         ELSE
            LI_INCL_OC_FLAG := 1;
         END IF;


       
         BEGIN
            
            FOR LTAB_CUR_LEVEL IN 1 .. LC_LEVELS_TO_EXPLODE LOOP
               LI_TOTAL_ROWS := 0;
               LI_CUM_COUNT := 0;
               

               
               LTAB_TBSI.DELETE;
               LTAB_BSI.DELETE;
               LTAB_CBSI.DELETE;
               LTAB_CID.DELETE;
               LTAB_CSI.DELETE;
               
               LTAB_CQ.DELETE;
               LTAB_EQ.DELETE;
               LTAB_SO.DELETE;
               LTAB_TID.DELETE;
               LTAB_TAD.DELETE;
               LTAB_CYF.DELETE;
               LTAB_OI.DELETE;
               LTAB_CC.DELETE;
               LTAB_IICR.DELETE;
               LTAB_LF.DELETE;
               LTAB_PF.DELETE;
               LTAB_OSN.DELETE;
               LTAB_BIT.DELETE;
               LTAB_PBIT.DELETE;
               LTAB_PAID.DELETE;
               LTAB_WST.DELETE;
               LTAB_ITN.DELETE;
               LTAB_ED.DELETE;
               LTAB_DD.DELETE;
               LTAB_ID.DELETE;
               LTAB_FUN.DELETE;
               LTAB_EUN.DELETE;
               LTAB_OPT.DELETE;
               LTAB_SS.DELETE;
               LTAB_SLI.DELETE;
               LTAB_CR.DELETE;
               LTAB_CN.DELETE;
               LTAB_OLTP.DELETE;
               LTAB_MEO.DELETE;
               LTAB_CATP.DELETE;
               LTAB_RTS.DELETE;
               LTAB_RFR.DELETE;
               LTAB_IOSD.DELETE;
               LTAB_LQ.DELETE;
               LTAB_HQ.DELETE;
               LTAB_SB.DELETE;
               LTAB_OPERATION_OFFSET.DELETE;
               LTAB_CURRENT_REVISION.DELETE;
               LTAB_LOCATOR.DELETE;
               LTAB_ALTERNATE_BOM_DESIGNATOR.DELETE;
               LTAB_ITEM_STRUCTURE.DELETE;

               IF ( NOT C_EXPLODER%ISOPEN ) THEN
                  OPEN C_EXPLODER( LTAB_CUR_LEVEL,
                                   LC_GROUP_ID,
                                   I_ORG_ID,
                                   LI_BOM_OR_ENG,
                                   LD_REV_DATE,
                                   LI_IMPL_FLAG,
                                   LI_EXPLODE_OPTION,
                                   LI_ORDER_BY,
                                   LC_VERIFY_FLAG,
                                   LI_PLAN_FACTOR_FLAG,
                                   LI_STD_COMP_FLAG,
                                   LI_INCL_OC_FLAG,
                                   LS_UNIT_NUMBER_FROM,
                                   LS_UNIT_NUMBER_TO      );
               END IF;

               FETCH C_EXPLODER BULK COLLECT 
                INTO LTAB_TBSI, 
                     LTAB_BSI, 
                     LTAB_CBSI, 
                     LTAB_CID, 
                     LTAB_CSI,
                     
                     LTAB_CQ,
                     LTAB_EQ, 
                     LTAB_SO, 
                     LTAB_TID, 
                     LTAB_TAD, 
                     LTAB_CYF, 
                     LTAB_OI, 
                     LTAB_CC, 
                     LTAB_IICR,
                     LTAB_LF, 
                     LTAB_PF, 
                     LTAB_OSN, 
                     LTAB_BIT, 
                     LTAB_PBIT, 
                     LTAB_PAID, 
                     LTAB_WST, 
                     LTAB_ITN,
                     LTAB_ED, 
                     LTAB_DD, 
                     LTAB_ID, 
                     LTAB_FUN, 
                     LTAB_EUN, 
                     LTAB_OPT, 
                     LTAB_SS, 
                     LTAB_SLI,
                     LTAB_CR, 
                     LTAB_CN, 
                     LTAB_OLTP, 
                     LTAB_MEO, 
                     LTAB_CATP, 
                     LTAB_RTS, 
                     LTAB_RFR, 
                     LTAB_IOSD,
                     LTAB_LQ, 
                     LTAB_HQ, 
                     LTAB_SB, 
                     LTAB_OPERATION_OFFSET,
                     LTAB_CURRENT_REVISION, 
                     LTAB_LOCATOR,
                     LTAB_ALTERNATE_BOM_DESIGNATOR;

               LI_LOOP_COUNT_VAL := C_EXPLODER%ROWCOUNT;

               CLOSE C_EXPLODER;

               IF ( LI_LOOP_COUNT_VAL > 0 ) THEN
                   FOR I IN 1 .. LI_LOOP_COUNT_VAL LOOP
                      IF ( LTAB_CUR_LEVEL > LI_LEVELS_TO_EXPLODE ) THEN
                         IF ( LTAB_CUR_LEVEL > LI_MAX_LEVEL ) THEN
                            LB_MAX_LEVEL_EXCEEDED := TRUE;
                         END IF;                               

                         EXIT;                        
                      END IF;                               

                      LI_TOTAL_ROWS := LI_TOTAL_ROWS + 1;

                      
                      
                      
                      IF (LI_CUM_COUNT = 0) THEN
                         LI_PREV_TOP_BILL_ID := LTAB_TBSI (I);
                         LS_PREV_SORT_ORDER  := LTAB_SO (I);
                      END IF;
                   
                      
                      
                      
                      
                      
                      IF (   LI_PREV_TOP_BILL_ID <> LTAB_TBSI (I)
                          OR (    LI_PREV_TOP_BILL_ID = LTAB_TBSI (I)
                              AND LS_PREV_SORT_ORDER <> LTAB_SO (I)   ) )  THEN
                         LI_CUM_COUNT          := 0;
                         LI_PREV_TOP_BILL_ID   := LTAB_TBSI (I);
                         LS_PREV_SORT_ORDER    := LTAB_SO (I);
                      END IF;
                   
                      LI_CUM_COUNT := LI_CUM_COUNT + 1;
                      
                      
                      
                      LS_CAT_SORT :=
                         LPAD (TO_CHAR (LI_CUM_COUNT),
                               NOETIX_BOM_EXPLOSION_PKG.GC_SORTWIDTH,
                               '0'
                              );
                      LTAB_SO (I)         := LTAB_SO (I) || LS_CAT_SORT;
                      LB_LOOP_FOUND       := FALSE;
                      LS_CUR_LOOPSTR      := LTAB_CC (I);
                      LS_CUR_COMPONENT    := LPAD (TO_CHAR (LTAB_CID (I)), 16, '0');
                   
                      
                      FOR I IN 1 .. LI_MAX_LEVEL LOOP
                         LI_START_POS := 1 + ((I - 1) * 16);
                         LS_CUR_SUBSTR := SUBSTR (LS_CUR_LOOPSTR, LI_START_POS, 16);
                   
                         IF (LS_CUR_COMPONENT = LS_CUR_SUBSTR) THEN
                            LB_LOOP_FOUND := TRUE;
                            EXIT;
                         END IF;
                      END LOOP;
                   
                      
                      LTAB_CC (I) := LTAB_CC (I) || LS_CUR_COMPONENT;
                   
                      IF ( LB_LOOP_FOUND ) THEN
                         LTAB_LF (I) := 1;
                      ELSE
                         LTAB_LF (I) := 2;
                      END IF;
                   
                      LTAB_CURRENT_REVISION (I) := NULL;
                   
                      IF ( LC_SHOW_REV = 1 ) THEN
                         BEGIN
                            IF ( LI_IMPL_FLAG = 1 ) THEN
                               LS_IMPL_ECO := 'IMPL_ONLY';
                            ELSE
                               LS_IMPL_ECO := 'ALL';
                            END IF;
                   

                            NOETIX_BOM_REVISIONS_PKG.GET_REVISION( I_TYPE              => 'PART',
                                                                   I_ECO_STATUS        => 'ALL',
                                                                   I_EXAMINE_TYPE      => LS_IMPL_ECO,
                                                                   I_ORG_ID            => LTAB_OI (I),
                                                                   I_ITEM_ID           => LTAB_CID (I),
                                                                   I_REV_DATE          => LD_REV_DATE,
                                                                   IO_ITEM_REV         => LTAB_CURRENT_REVISION(I)   );
                         EXCEPTION
                            WHEN NO_REVISION_FOUND THEN
                               NULL;
                         END;                                      
                      END IF;                        
                   
                      LTAB_LOCATOR (I) := NULL;
                      LTAB_OLTP (I) := NULL;
                   
                      FOR X_OPERATION IN C_GET_OLTP( P_ASSEMBLY       => LTAB_PAID (I),
                                                     P_ALTERNATE      => LTAB_ALTERNATE_BOM_DESIGNATOR(I),
                                                     P_OPERATION      => LTAB_OSN (I),
                                                     P_REV_DATE       => LD_REV_DATE  )  LOOP
                         LTAB_OLTP (I) := X_OPERATION.OLTP;
                      END LOOP;
                   
                      LTAB_OPERATION_OFFSET (I) := NULL;
                   
                      IF ( LC_LEAD_TIME = 1 ) THEN
                         FOR X_ITEM IN C_CALCULATE_OFFSET( P_PARENTITEM      => LTAB_PAID (I),
                                                           P_PERCENT         => LTAB_OLTP (I) )  LOOP
                            LTAB_OPERATION_OFFSET (I) := X_ITEM.OFFSET;
                         END LOOP;
                      END IF;                                  
                   END LOOP;                                  
               END IF;

               FORALL I IN 1 .. LI_LOOP_COUNT_VAL
               INSERT INTO N_TMP_BOM_EXPLOSION
                           (GROUP_ID, 
                            TOP_BILL_SEQUENCE_ID,
                            BILL_SEQUENCE_ID, 
                            COMMON_BILL_SEQUENCE_ID,
                            ORGANIZATION_ID, 
                            COMPONENT_SEQUENCE_ID,
                            COMPONENT_ITEM_ID,
                            
                            COMPONENT_QUANTITY,
                            PLAN_LEVEL, 
                            EXTENDED_QUANTITY, 
                            SORT_ORDER,
                            TOP_ALTERNATE_DESIGNATOR,
                            COMPONENT_YIELD_FACTOR, 
                            TOP_ITEM_ID,
                            COMPONENT_CODE, 
                            INCLUDE_IN_ROLLUP_FLAG,
                            LOOP_FLAG, 
                            PLANNING_FACTOR, 
                            OPERATION_SEQ_NUM,
                            BOM_ITEM_TYPE, 
                            PARENT_BOM_ITEM_TYPE,
                            ASSEMBLY_ITEM_ID, 
                            WIP_SUPPLY_TYPE, 
                            ITEM_NUM,
                            EFFECTIVITY_DATE, 
                            DISABLE_DATE,
                            FROM_END_ITEM_UNIT_NUMBER,
                            TO_END_ITEM_UNIT_NUMBER, 
                            IMPLEMENTATION_DATE,
                            OPTIONAL, 
                            SUPPLY_SUBINVENTORY,
                            SUPPLY_LOCATOR_ID, 
                            COMPONENT_REMARKS,
                            CHANGE_NOTICE, 
                            OPERATION_LEAD_TIME_PERCENT,
                            MUTUALLY_EXCLUSIVE_OPTIONS, 
                            CHECK_ATP,
                            REQUIRED_TO_SHIP, 
                            REQUIRED_FOR_REVENUE,
                            INCLUDE_ON_SHIP_DOCS, 
                            LOW_QUANTITY,
                            HIGH_QUANTITY, 
                            SO_BASIS, 
                            OPERATION_OFFSET,
                            CURRENT_REVISION, 
                            LOCATOR
                           )
                    VALUES (LC_GROUP_ID, 
                            LTAB_TBSI (I),
                            LTAB_BSI (I), 
                            LTAB_CBSI (I),
                            LTAB_OI (I), 
                            LTAB_CSI (I),
                            LTAB_CID (I),
                            
                            LTAB_CQ (I),
                            LTAB_CUR_LEVEL, 
                            LTAB_EQ (I), 
                            LTAB_SO (I),
                            LTAB_TAD (I),
                            LTAB_CYF (I), 
                            LTAB_TID (I),
                            LTAB_CC (I), 
                            LTAB_IICR (I),
                            LTAB_LF (I), 
                            LTAB_PF (I), 
                            LTAB_OSN (I),
                            LTAB_BIT (I), 
                            LTAB_PBIT (I),
                            LTAB_PAID (I), 
                            LTAB_WST (I), 
                            LTAB_ITN (I),
                            LTAB_ED (I), 
                            LTAB_DD (I),
                            LTAB_FUN (I),
                            LTAB_EUN (I), 
                            LTAB_ID (I),
                            LTAB_OPT (I), 
                            LTAB_SS (I),
                            LTAB_SLI (I), 
                            LTAB_CR (I),
                            LTAB_CN (I), 
                            LTAB_OLTP (I),
                            LTAB_MEO (I), 
                            LTAB_CATP (I),
                            LTAB_RTS (I), 
                            LTAB_RFR (I),
                            LTAB_IOSD (I), 
                            LTAB_LQ (I),
                            LTAB_HQ (I), 
                            LTAB_SB (I), 
                            LTAB_OPERATION_OFFSET (I),
                            LTAB_CURRENT_REVISION (I), 
                            LTAB_LOCATOR (I)
                           );
            END LOOP;

            
            BEGIN
               IF (LI_MODULE = 1) THEN
                  NOETIX_BOM_EXPL_COST_PKG.CST_EXPLODER( I_GRP_ID         => LC_GROUP_ID,
                                                         I_ORG_ID         => I_ORG_ID,
                                                         I_CST_TYPE_ID    => I_CST_TYPE_ID,
                                                         I_INQ_FLAG       => 1 );
               END IF;

               SELECT COUNT(*)
                 INTO LI_CNT
                 FROM MTL_PARAMETERS_S MTL
                WHERE MTL.ORGANIZATION_ID = MTL.COST_ORGANIZATION_ID
                  AND MTL.ORGANIZATION_ID = I_ORG_ID;

               IF (LI_CNT > 0) THEN
                  LS_IS_COST_ORGANIZATION := 'Y';
               ELSE
                  LS_IS_COST_ORGANIZATION := 'N';
               END IF;

               
               
               
               FOR CR IN C_ORG_CHECK( LC_GROUP_ID )  LOOP
                  SELECT MSI.PRIMARY_UOM_CODE, 
                         MSI.ORGANIZATION_ID
                    INTO LS_T_MASTER_UOM, 
                         LI_T_MASTER_ORG_ID
                    FROM MTL_SYSTEM_ITEMS_B_S MSI,
                         BOM_STRUCTURES_B_S   BBM
                   WHERE CR.CURCBSI             = BBM.BILL_SEQUENCE_ID
                     AND BBM.ORGANIZATION_ID    = MSI.ORGANIZATION_ID
                     AND MSI.INVENTORY_ITEM_ID  = CR.CURCII;

                  SELECT MSI.PRIMARY_UOM_CODE
                    INTO LS_T_CHILD_UOM
                    FROM MTL_SYSTEM_ITEMS_B_S MSI
                   WHERE MSI.INVENTORY_ITEM_ID = CR.CURCII
                     AND MSI.ORGANIZATION_ID   = CR.CUROI;

                  SELECT CONV.CONVERSION_RATE
                    INTO LI_T_CONVERSION_RATE
                    FROM ( 
                           SELECT MSI.INVENTORY_ITEM_ID, MSI.ORGANIZATION_ID,
                              MSI.PRIMARY_UNIT_OF_MEASURE, MSI.PRIMARY_UOM_CODE, UOM.UOM_CLASS,
                              UOM2.UNIT_OF_MEASURE, UOM2.UOM_CODE, CONV2.UOM_CLASS,
                              (  ( CASE UOM.UOM_CLASS WHEN UOM2.UOM_CLASS THEN 1 ELSE CLASS.CONVERSION_RATE END)
                               * CONV2.CONVERSION_RATE
                               / ( CASE 
                                     WHEN CONV1.INVENTORY_ITEM_ID IS NULL THEN
                                          ( CASE LEAST(NVL(CONV1_2.DISABLE_DATE, SYSDATE),SYSDATE)
                                              WHEN SYSDATE THEN CONV1_2.CONVERSION_RATE
                                              ELSE NULL
                                            END )
                                     ELSE ( CASE LEAST (NVL (CONV1.DISABLE_DATE, SYSDATE), SYSDATE)
                                              WHEN SYSDATE THEN CONV1.CONVERSION_RATE
                                              ELSE CONV1_2.CONVERSION_RATE
                                            END )
                                   END )
                              ) CONVERSION_RATE
                         FROM MTL_UOM_CONVERSIONS_S       CONV1,
                              MTL_UOM_CONVERSIONS_S       CONV2,
                              MTL_UOM_CONVERSIONS_S       CONV1_2,
                              MTL_UNITS_OF_MEASURE_TL_S   UOM,
                              MTL_UNITS_OF_MEASURE_TL_S   UOM2,
                              MTL_UOM_CLASS_CONVERSIONS_S CLASS,
                              MTL_SYSTEM_ITEMS_B_S        MSI
                        WHERE UOM.UOM_CODE = MSI.PRIMARY_UOM_CODE
                          AND UOM.LANGUAGE (+) LIKE GC_LANGUAGE
                          AND UOM2.UOM_CLASS =
                                 ( CASE UOM.UOM_CLASS
                                     WHEN UOM2.UOM_CLASS THEN UOM2.UOM_CLASS
                                     ELSE CLASS.TO_UOM_CLASS
                                   END )
                          AND UOM2.LANGUAGE (+) LIKE GC_LANGUAGE
                          AND (   CLASS.TO_UOM_CLASS IS NULL
                               OR CLASS.TO_UOM_CLASS =
                                     (SELECT CLASS2.TO_UOM_CLASS
                                        FROM MTL_UOM_CLASS_CONVERSIONS_S CLASS2
                                       WHERE CLASS2.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
                                         AND UOM2.UOM_CLASS =
                                                ( CASE UOM.UOM_CLASS
                                                    WHEN UOM2.UOM_CLASS THEN UOM2.UOM_CLASS
                                                    ELSE CLASS2.TO_UOM_CLASS
                                                  END   )
                                         AND UOM.UOM_CLASS  =
                                                ( CASE UOM.UOM_CLASS
                                                    WHEN UOM2.UOM_CLASS THEN UOM.UOM_CLASS
                                                    ELSE CLASS2.FROM_UOM_CLASS
                                                  END   )
                                         AND ROWNUM         = 1 )
                              )
                          AND CONV1.INVENTORY_ITEM_ID (+)   = MSI.INVENTORY_ITEM_ID
                          AND CONV1_2.INVENTORY_ITEM_ID (+) = 0
                          AND CONV1.UOM_CODE (+)            = MSI.PRIMARY_UOM_CODE
                          AND CONV1_2.UOM_CODE (+)          = MSI.PRIMARY_UOM_CODE
                          AND ( CASE 
                                  WHEN ( CONV1.INVENTORY_ITEM_ID IS NULL ) THEN
                                        ( CASE LEAST(NVL(CONV1_2.DISABLE_DATE, SYSDATE), SYSDATE )
                                            WHEN SYSDATE THEN CONV1_2.CONVERSION_RATE 
                                            ELSE NULL
                                           END )
                                  ELSE  ( CASE LEAST (NVL (CONV1.DISABLE_DATE, SYSDATE), SYSDATE)
                                            WHEN SYSDATE THEN CONV1.CONVERSION_RATE
                                            ELSE CONV1_2.CONVERSION_RATE
                                          END )
                                END                       ) IS NOT NULL
                          AND ( CASE UOM.UOM_CLASS
                                  WHEN UOM2.UOM_CLASS THEN 1
                                  ELSE ( CASE LEAST (NVL (CLASS.DISABLE_DATE, SYSDATE), SYSDATE)
                                           WHEN SYSDATE THEN 1
                                           ELSE NULL
                                         END  )
                                END                       ) IS NOT NULL
                          AND CLASS.INVENTORY_ITEM_ID(+) = MSI.INVENTORY_ITEM_ID
                          AND UOM.UOM_CLASS =
                                 ( CASE UOM.UOM_CLASS
                                     WHEN UOM2.UOM_CLASS THEN UOM.UOM_CLASS
                                     ELSE CLASS.FROM_UOM_CLASS
                                   END  )
                          AND (CONV2.INVENTORY_ITEM_ID, CONV2.UOM_CODE) =
                                 (SELECT MAX (CONV_SUB2.INVENTORY_ITEM_ID), UOM2.UOM_CODE
                                    FROM MTL_UOM_CONVERSIONS_S CONV_SUB2
                                   WHERE CONV_SUB2.UOM_CODE = UOM2.UOM_CODE
                                     AND CONV_SUB2.INVENTORY_ITEM_ID IN ( MSI.INVENTORY_ITEM_ID, 0 )
                                     AND NVL (CLASS.INVENTORY_ITEM_ID, 1) IS NOT NULL
                                     AND NVL (CONV_SUB2.DISABLE_DATE, SYSDATE + 1) > SYSDATE)) CONV
                   WHERE CONV.PRIMARY_UOM_CODE  = LS_T_MASTER_UOM
                     AND CONV.UOM_CODE          = LS_T_CHILD_UOM
                     AND CONV.INVENTORY_ITEM_ID = CR.CURCII
                     AND CONV.ORGANIZATION_ID   = LI_T_MASTER_ORG_ID;

                  OPEN C_CONVERSION( LS_T_MASTER_UOM,
                                     LS_T_CHILD_UOM,
                                     CR.CURCII,
                                     LI_T_MASTER_ORG_ID );

                  FETCH C_CONVERSION
                   INTO LI_T_CONVERSION_RATE;

                  CLOSE C_CONVERSION;

                  
                  
                  IF ( LS_IS_COST_ORGANIZATION <> 'Y' ) THEN
                     UPDATE N_TMP_BOM_EXPLOSION T
                        SET T.ITEM_COST = T.ITEM_COST * LI_T_CONVERSION_RATE
                      WHERE T.GROUP_ID                  = CR.CURGI
                        AND T.COMPONENT_SEQUENCE_ID     = CR.CURCSI
                        AND T.BILL_SEQUENCE_ID          = CR.CURBSI
                        AND T.COMMON_BILL_SEQUENCE_ID   = CR.CURCBSI;
                  END IF;

                  UPDATE N_TMP_BOM_EXPLOSION T
                     SET T.COMPONENT_QUANTITY      = T.COMPONENT_QUANTITY / LI_T_CONVERSION_RATE,
                         T.EXTENDED_QUANTITY       = T.EXTENDED_QUANTITY / LI_T_CONVERSION_RATE,
                         T.PRIMARY_UOM_CODE        = CR.CURPUC
                   WHERE T.GROUP_ID                = CR.CURGI
                     AND T.COMPONENT_SEQUENCE_ID   = CR.CURCSI
                     AND T.BILL_SEQUENCE_ID        = CR.CURBSI
                     AND T.COMMON_BILL_SEQUENCE_ID = CR.CURCBSI;
               END LOOP;

               
               UPDATE N_TMP_BOM_EXPLOSION T
                  SET T.ACTUAL_COST_TYPE_ID = I_CST_TYPE_ID;
            END;

            LI_LOOP_COUNT_VAL := 0;
            
            LTAB_TBSI.DELETE;
            LTAB_BSI.DELETE;
            LTAB_CBSI.DELETE;
            LTAB_CID.DELETE;
            LTAB_CSI.DELETE;
            
            LTAB_CQ.DELETE;
            LTAB_CUR_LEVEL.DELETE;
            LTAB_EQ.DELETE;
            LTAB_SO.DELETE;
            LTAB_TID.DELETE;
            LTAB_TAD.DELETE;
            LTAB_CYF.DELETE;
            LTAB_OI.DELETE;
            LTAB_CC.DELETE;
            LTAB_IICR.DELETE;
            LTAB_LF.DELETE;
            LTAB_PF.DELETE;
            LTAB_OSN.DELETE;
            LTAB_BIT.DELETE;
            LTAB_PBIT.DELETE;
            LTAB_PAID.DELETE;
            LTAB_WST.DELETE;
            LTAB_ITN.DELETE;
            LTAB_ED.DELETE;
            LTAB_DD.DELETE;
            LTAB_ID.DELETE;
            LTAB_FUN.DELETE;
            LTAB_EUN.DELETE;
            LTAB_OPT.DELETE;
            LTAB_SS.DELETE;
            LTAB_SLI.DELETE;
            LTAB_CR.DELETE;
            LTAB_CN.DELETE;
            LTAB_OLTP.DELETE;
            LTAB_MEO.DELETE;
            LTAB_CATP.DELETE;
            LTAB_RTS.DELETE;
            LTAB_RFR.DELETE;
            LTAB_IOSD.DELETE;
            LTAB_LQ.DELETE;
            LTAB_HQ.DELETE;
            LTAB_SB.DELETE;
            LTAB_OPERATION_OFFSET.DELETE;
            LTAB_CURRENT_REVISION.DELETE;
            LTAB_LOCATOR.DELETE;
            LTAB_ALTERNATE_BOM_DESIGNATOR.DELETE;
            LTAB_COST.DELETE;                                            
            LTAB_ITEM_STRUCTURE.DELETE;
            LTAB_COST_TYPE_ID.DELETE;
            LTAB_EXTEND_COST_FLAG.DELETE;

            IF ( NOT C_FINAL_DATA%ISOPEN ) THEN
               OPEN C_FINAL_DATA ();
            END IF;

            FETCH C_FINAL_DATA BULK COLLECT 
             INTO LTAB_TBSI, 
                  LTAB_BSI, 
                  LTAB_CBSI, 
                  LTAB_OI, 
                  LTAB_CSI,
                  LTAB_CID,
                  LTAB_CQ,   
                  LTAB_CUR_LEVEL, 
                  LTAB_EQ, 
                  LTAB_SO, 
                  LTAB_TAD, 
                  LTAB_CYF, 
                  LTAB_TID, 
                  LTAB_CC, 
                  LTAB_IICR,
                  LTAB_LF, 
                  LTAB_PF, 
                  LTAB_OSN, 
                  LTAB_BIT, 
                  LTAB_PBIT, 
                  LTAB_PAID, 
                  LTAB_WST, 
                  LTAB_ITN,
                  LTAB_ED, 
                  LTAB_DD, 
                  LTAB_FUN, 
                  LTAB_EUN, 
                  LTAB_ID, 
                  LTAB_OPT, 
                  LTAB_SS, 
                  LTAB_SLI, 
                  LTAB_CR,
                  LTAB_CN, 
                  LTAB_OLTP, 
                  LTAB_MEO, 
                  LTAB_CATP, 
                  LTAB_RTS, 
                  LTAB_RFR, 
                  LTAB_IOSD, 
                  LTAB_LQ,
                  LTAB_HQ, 
                  LTAB_SB, 
                  LTAB_OPERATION_OFFSET, 
                  LTAB_CURRENT_REVISION,
                  LTAB_LOCATOR, 
                  LTAB_COST, 
                  LTAB_ITEM_STRUCTURE, 
                  LTAB_COST_TYPE_ID,
                  LTAB_EXTEND_COST_FLAG;

            LI_LOOP_COUNT_VAL := C_FINAL_DATA%ROWCOUNT;

            CLOSE C_FINAL_DATA;

            COMMIT;

            FOR I IN 1 .. LI_LOOP_COUNT_VAL LOOP
               GTAB_BOM_EXPLOSION_TABLE (I).TOP_BILL_SEQUENCE_ID := LTAB_TBSI (I);
               GTAB_BOM_EXPLOSION_TABLE (I).BILL_SEQUENCE_ID := LTAB_BSI (I);
               GTAB_BOM_EXPLOSION_TABLE (I).ORGANIZATION_ID := LTAB_OI (I);
               GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_SEQUENCE_ID := LTAB_CSI (I);
               GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_ITEM_ID := LTAB_CID (I);
               GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_QUANTITY := LTAB_CQ (I);
               GTAB_BOM_EXPLOSION_TABLE (I).PLAN_LEVEL := LTAB_CUR_LEVEL (I);
               GTAB_BOM_EXPLOSION_TABLE (I).EXTENDED_QUANTITY := LTAB_EQ (I);
               GTAB_BOM_EXPLOSION_TABLE (I).SORT_ORDER := LTAB_SO (I);
               GTAB_BOM_EXPLOSION_TABLE (I).TOP_ALTERNATE_DESIGNATOR := LTAB_TAD (I);
               GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_YIELD_FACTOR := LTAB_CYF (I);
               GTAB_BOM_EXPLOSION_TABLE (I).TOP_ITEM_ID := LTAB_TID (I);
               GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_CODE := LTAB_CC (I);
               GTAB_BOM_EXPLOSION_TABLE (I).INCLUDE_IN_ROLLUP_FLAG := LTAB_IICR (I);
               GTAB_BOM_EXPLOSION_TABLE (I).LOOP_FLAG := LTAB_LF (I);
               GTAB_BOM_EXPLOSION_TABLE (I).PLANNING_FACTOR := LTAB_PF (I);
               GTAB_BOM_EXPLOSION_TABLE (I).OPERATION_SEQ_NUM := LTAB_OSN (I);
               GTAB_BOM_EXPLOSION_TABLE (I).BOM_ITEM_TYPE := LTAB_BIT (I);
               GTAB_BOM_EXPLOSION_TABLE (I).PARENT_BOM_ITEM_TYPE := LTAB_PBIT (I);
               GTAB_BOM_EXPLOSION_TABLE (I).ASSEMBLY_ITEM_ID := LTAB_PAID (I);
               GTAB_BOM_EXPLOSION_TABLE (I).WIP_SUPPLY_TYPE := LTAB_WST (I);
               GTAB_BOM_EXPLOSION_TABLE (I).ITEM_NUM := LTAB_ITN (I);
               GTAB_BOM_EXPLOSION_TABLE (I).EFFECTIVITY_DATE := LTAB_ED (I);
               GTAB_BOM_EXPLOSION_TABLE (I).DISABLE_DATE := LTAB_DD (I);
               GTAB_BOM_EXPLOSION_TABLE (I).FROM_END_ITEM_UNIT_NUMBER := LTAB_FUN (I);
               GTAB_BOM_EXPLOSION_TABLE (I).TO_END_ITEM_UNIT_NUMBER := LTAB_EUN (I);
               GTAB_BOM_EXPLOSION_TABLE (I).IMPLEMENTATION_DATE := LTAB_ID (I);
               GTAB_BOM_EXPLOSION_TABLE (I).OPTIONAL := LTAB_OPT (I);
               GTAB_BOM_EXPLOSION_TABLE (I).SUPPLY_SUBINVENTORY := LTAB_SS (I);
               GTAB_BOM_EXPLOSION_TABLE (I).SUPPLY_LOCATOR_ID := LTAB_SLI (I);
               GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_REMARKS := LTAB_CR (I);
               GTAB_BOM_EXPLOSION_TABLE (I).CHANGE_NOTICE := LTAB_CN (I);
               GTAB_BOM_EXPLOSION_TABLE (I).OPERATION_LEAD_TIME_PERCENT := LTAB_OLTP (I);
               GTAB_BOM_EXPLOSION_TABLE (I).MUTUALLY_EXCLUSIVE_OPTIONS := LTAB_MEO (I);
               GTAB_BOM_EXPLOSION_TABLE (I).CHECK_ATP := LTAB_CATP (I);
               GTAB_BOM_EXPLOSION_TABLE (I).REQUIRED_TO_SHIP := LTAB_RTS (I);
               GTAB_BOM_EXPLOSION_TABLE (I).REQUIRED_FOR_REVENUE := LTAB_RFR (I);
               GTAB_BOM_EXPLOSION_TABLE (I).INCLUDE_ON_SHIP_DOCS := LTAB_IOSD (I);
               GTAB_BOM_EXPLOSION_TABLE (I).LOW_QUANTITY := LTAB_LQ (I);
               GTAB_BOM_EXPLOSION_TABLE (I).HIGH_QUANTITY := LTAB_HQ (I);
               GTAB_BOM_EXPLOSION_TABLE (I).SO_BASIS := LTAB_SB (I);
               GTAB_BOM_EXPLOSION_TABLE (I).OPERATION_OFFSET := LTAB_OPERATION_OFFSET (I);
               GTAB_BOM_EXPLOSION_TABLE (I).CURRENT_REVISION := LTAB_CURRENT_REVISION (I);
               GTAB_BOM_EXPLOSION_TABLE (I).LOCATOR := LTAB_LOCATOR (I);
               GTAB_BOM_EXPLOSION_TABLE (I).ITEM_COST := LTAB_COST (I);
               GTAB_BOM_EXPLOSION_TABLE (I).ITEM_STRUCTURE := LTAB_ITEM_STRUCTURE (I);
               GTAB_BOM_EXPLOSION_TABLE (I).ACTUAL_COST_TYPE_ID := LTAB_COST_TYPE_ID (I);
               GTAB_BOM_EXPLOSION_TABLE (I).EXTEND_COST_FLAG := LTAB_EXTEND_COST_FLAG (I);
               
               PIPE ROW (XXNAO_BOM_EXPLOSION_OBJECT
                            (GTAB_BOM_EXPLOSION_TABLE (I).TOP_BILL_SEQUENCE_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).BILL_SEQUENCE_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).ORGANIZATION_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_SEQUENCE_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_ITEM_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_QUANTITY,
                             GTAB_BOM_EXPLOSION_TABLE (I).PLAN_LEVEL,
                             GTAB_BOM_EXPLOSION_TABLE (I).EXTENDED_QUANTITY,
                             GTAB_BOM_EXPLOSION_TABLE (I).SORT_ORDER,
                             
                             GTAB_BOM_EXPLOSION_TABLE (I).TOP_ALTERNATE_DESIGNATOR,
                             GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_YIELD_FACTOR,
                             GTAB_BOM_EXPLOSION_TABLE (I).TOP_ITEM_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_CODE,
                             GTAB_BOM_EXPLOSION_TABLE (I).INCLUDE_IN_ROLLUP_FLAG,
                             GTAB_BOM_EXPLOSION_TABLE (I).LOOP_FLAG,
                             GTAB_BOM_EXPLOSION_TABLE (I).PLANNING_FACTOR,
                             GTAB_BOM_EXPLOSION_TABLE (I).OPERATION_SEQ_NUM,
                             GTAB_BOM_EXPLOSION_TABLE (I).BOM_ITEM_TYPE,
                             GTAB_BOM_EXPLOSION_TABLE (I).PARENT_BOM_ITEM_TYPE,
                             GTAB_BOM_EXPLOSION_TABLE (I).ASSEMBLY_ITEM_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).WIP_SUPPLY_TYPE,
                             GTAB_BOM_EXPLOSION_TABLE (I).ITEM_NUM,
                             GTAB_BOM_EXPLOSION_TABLE (I).EFFECTIVITY_DATE,
                             GTAB_BOM_EXPLOSION_TABLE (I).DISABLE_DATE,
                             GTAB_BOM_EXPLOSION_TABLE (I).FROM_END_ITEM_UNIT_NUMBER,
                             GTAB_BOM_EXPLOSION_TABLE (I).TO_END_ITEM_UNIT_NUMBER,
                             GTAB_BOM_EXPLOSION_TABLE (I).IMPLEMENTATION_DATE,
                             GTAB_BOM_EXPLOSION_TABLE (I).OPTIONAL,
                             GTAB_BOM_EXPLOSION_TABLE (I).SUPPLY_SUBINVENTORY,
                             GTAB_BOM_EXPLOSION_TABLE (I).SUPPLY_LOCATOR_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).COMPONENT_REMARKS,
                             GTAB_BOM_EXPLOSION_TABLE (I).CHANGE_NOTICE,
                             GTAB_BOM_EXPLOSION_TABLE (I).OPERATION_LEAD_TIME_PERCENT,
                             GTAB_BOM_EXPLOSION_TABLE (I).MUTUALLY_EXCLUSIVE_OPTIONS,
                             GTAB_BOM_EXPLOSION_TABLE (I).CHECK_ATP,
                             GTAB_BOM_EXPLOSION_TABLE (I).REQUIRED_TO_SHIP,
                             GTAB_BOM_EXPLOSION_TABLE (I).REQUIRED_FOR_REVENUE,
                             GTAB_BOM_EXPLOSION_TABLE (I).INCLUDE_ON_SHIP_DOCS,
                             GTAB_BOM_EXPLOSION_TABLE (I).LOW_QUANTITY,
                             GTAB_BOM_EXPLOSION_TABLE (I).HIGH_QUANTITY,
                             GTAB_BOM_EXPLOSION_TABLE (I).SO_BASIS,
                             GTAB_BOM_EXPLOSION_TABLE (I).OPERATION_OFFSET,
                             GTAB_BOM_EXPLOSION_TABLE (I).CURRENT_REVISION,
                             GTAB_BOM_EXPLOSION_TABLE (I).LOCATOR,
                             GTAB_BOM_EXPLOSION_TABLE (I).ITEM_COST,
                             GTAB_BOM_EXPLOSION_TABLE (I).ITEM_STRUCTURE,
                             GTAB_BOM_EXPLOSION_TABLE (I).ACTUAL_COST_TYPE_ID,
                             GTAB_BOM_EXPLOSION_TABLE (I).EXTEND_COST_FLAG
                            ));
            END LOOP;
         END;
      END;

      RETURN;
   END;

END NOETIX_BOM_EXPLOSION_PKG ;

/
show errors
@utlspoff