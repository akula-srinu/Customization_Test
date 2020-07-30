CREATE OR REPLACE FORCE VIEW NOETIX_VIEWS.N_CST_CG_COST_HISTORY_VSAT
(
   INVENTORY_ITEM_ID,
   TRANSACTION_ID,
   ORGANIZATION_ID,
   LAYER_ID,
   TRANSACTION_COSTED_DATE,
   TRANSACTION_DATE,
   PRIOR_COSTED_QUANTITY,
   PRIMARY_QUANTITY,
   NEW_QUANTITY,
   COST_GROUP_ID,
   TRANSACTION_TYPE,
   ACTUAL_COST,
   ACTUAL_MATERIAL,
   ACTUAL_MATERIAL_OVERHEAD,
   ACTUAL_RESOURCE,
   ACTUAL_OUTSIDE_PROCESSING,
   ACTUAL_OVERHEAD,
   PRIOR_COST,
   PRIOR_MATERIAL,
   PRIOR_MATERIAL_OVERHEAD,
   PRIOR_RESOURCE,
   PRIOR_OUTSIDE_PROCESSING,
   PRIOR_OVERHEAD,
   NEW_COST,
   NEW_MATERIAL,
   NEW_MATERIAL_OVERHEAD,
   NEW_RESOURCE,
   NEW_OUTSIDE_PROCESSING,
   NEW_OVERHEAD,
   CHANGE,
   CREATION_DATE
)
AS     
     SELECT MMT.INVENTORY_ITEM_ID INVENTORY_ITEM_ID,
            MCACD.TRANSACTION_ID TRANSACTION_ID,
            MCACD.ORGANIZATION_ID ORGANIZATION_ID,
            MCACD.LAYER_ID LAYER_ID,
            MCACD.TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE,                  /* PRIOR COSTED QUANTITY */
            DECODE (
               MMT.TRANSACTION_ACTION_ID,       /* INTRANSIT SHIP, FOB SHIP */
               21, DECODE (MCACD.ORGANIZATION_ID,     /* INTRANSIT SHIPMENT */
                           MMT.ORGANIZATION_ID, MMT.PRIOR_COSTED_QUANTITY, /* QUANTITY FOR SHIPPING ORG */
                           MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* QUANTITY FOR RECEIVING ORG */
                                             /* INTRANSIT RECEIPT, FOB SHIP */
               12, DECODE (
                      MSI.ASSET_INVENTORY,             /* INTRANSIT RECEIPT */
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY, /* FROM INTRANSIT */
                                 MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* TO INTRANSIT SUB */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* TO EXPENSE SUB, ONLY SHOW 'FROM INTRANSIT' */
      /* INVCONV umoogala: Added TxnAction 15 for Logical Intransit Receipt */
               15, DECODE (
                      MSI.ASSET_INVENTORY,             /* INTRANSIT RECEIPT */
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY, /* FROM INTRANSIT */
                                 MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* TO INTRANSIT SUB */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY) /* TO EXPENSE SUB, ONLY SHOW 'FROM INTRANSIT' */
                                                         )
               PRIOR_COSTED_QUANTITY,                   /* PRIMARY QUANTITY */
            DECODE (
               MMT.TRANSACTION_ACTION_ID,       /* INTRANSIT SHIP, FOB SHIP */
               21, DECODE (MCACD.ORGANIZATION_ID,     /* INTRANSIT SHIPMENT */
                           MMT.ORGANIZATION_ID, MMT.PRIMARY_QUANTITY, /* QUANTITY FOR SHIPPING ORG */
                           -1 * MMT.PRIMARY_QUANTITY), /* QUANTITY FOR RECEIVING ORG */
                                             /* INTRANSIT RECEIPT, FOB SHIP */
               12, DECODE (
                      MSI.ASSET_INVENTORY,             /* INTRANSIT RECEIPT */
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY, /* TO ASSET SUB */
                                 -1 * MMT.PRIMARY_QUANTITY), /* FROM INTRANSIT */
                      -1 * MMT.PRIMARY_QUANTITY), /* TO EXPENSE SUB, ONLY SHOW 'FROM INTRANSIT' */
      /* INVCONV umoogala: Added TxnAction 15 for Logical Intransit Receipt */
               15, DECODE (
                      MSI.ASSET_INVENTORY,             /* INTRANSIT RECEIPT */
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY, /* TO ASSET SUB */
                                 -1 * MMT.PRIMARY_QUANTITY), /* FROM INTRANSIT */
                      -1 * MMT.PRIMARY_QUANTITY) /* TO EXPENSE SUB, ONLY SHOW 'FROM INTRANSIT' */
                                                )
               PRIMARY_QUANTITY,                            /* NEW QUANTITY */
            DECODE (
               MMT.TRANSACTION_ACTION_ID,       /* INTRANSIT SHIP, FOB SHIP */
               21, DECODE (
                      MCACD.ORGANIZATION_ID,          /* INTRANSIT SHIPMENT */
                      MMT.ORGANIZATION_ID, MMT.PRIMARY_QUANTITY
                                           + MMT.PRIOR_COSTED_QUANTITY, /* QUANTITY FOR SHIPPING ORG */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY - MMT.PRIMARY_QUANTITY), /* QUANTITY FOR INTRANSIT IN REV. ORG */
                                             /* INTRANSIT RECEIPT, FOB SHIP */
               12, DECODE (
                      MSI.ASSET_INVENTORY,             /* INTRANSIT RECEIPT */
                      1, DECODE (
                            CQL.COST_GROUP_ID,                 /* ASSET SUB */
                            MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY
                                               + MMT.PRIOR_COSTED_QUANTITY, /* TO ASSET SUB */
                            MMT.TRANSFER_PRIOR_COSTED_QUANTITY
                            - MMT.PRIMARY_QUANTITY),      /* FROM INTRANSIT */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY - MMT.PRIMARY_QUANTITY), /* TO EXPENSE SUB, SHOW 'FROM INTRANSIT' */
      /* INVCONV umoogala: Added TxnAction 15 for Logical Intransit Receipt */
               15, DECODE (
                      MSI.ASSET_INVENTORY,             /* INTRANSIT RECEIPT */
                      1, DECODE (
                            CQL.COST_GROUP_ID,                 /* ASSET SUB */
                            MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY
                                               + MMT.PRIOR_COSTED_QUANTITY, /* TO ASSET SUB */
                            MMT.TRANSFER_PRIOR_COSTED_QUANTITY
                            - MMT.PRIMARY_QUANTITY),      /* FROM INTRANSIT */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY - MMT.PRIMARY_QUANTITY) /* TO EXPENSE SUB, SHOW 'FROM INTRANSIT' */
                                                                                )
               NEW_QUANTITY,                               /* COST GROUP ID */
            CQL.COST_GROUP_ID COST_GROUP_ID,
            MTT.TRANSACTION_TYPE_NAME TRANSACTION_TYPE,     /* ACTUAL COSTS */
            SUM (MCACD.ACTUAL_COST) ACTUAL_COST, /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL,       /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL_OVERHEAD,       /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.ACTUAL_COST, 0))
               ACTUAL_RESOURCE,      /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.ACTUAL_COST, 0))
               ACTUAL_OUTSIDE_PROCESSING,      /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.ACTUAL_COST, 0))
               ACTUAL_OVERHEAD,                              /* PRIOR COSTS */
            SUM (MCACD.PRIOR_COST) PRIOR_COST, /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL,        /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL_OVERHEAD,        /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.PRIOR_COST, 0))
               PRIOR_RESOURCE,       /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.PRIOR_COST, 0))
               PRIOR_OUTSIDE_PROCESSING,       /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.PRIOR_COST, 0))
               PRIOR_OVERHEAD,                                 /* NEW COSTS */
            SUM (MCACD.NEW_COST) NEW_COST,     /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.NEW_COST, 0))
               NEW_MATERIAL,          /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.NEW_COST, 0))
               NEW_MATERIAL_OVERHEAD,          /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.NEW_COST, 0))
               NEW_RESOURCE,         /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.NEW_COST, 0))
               NEW_OUTSIDE_PROCESSING,         /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.NEW_COST, 0))
               NEW_OVERHEAD, /* THE EXTRA COLUMN WHERE WE DECIDE IF THERE WAS AN ACTUAL COST CHANGE */
                                                 /* AT THE ELEMENTAL LEVEL. */
            DECODE (
               SUM (
                  DECODE (TRUNC (MCACD.NEW_COST, 5),
                          TRUNC (MCACD.PRIOR_COST, 5), 0,
                          1)),
               0, 'N',
               'Y')
               CHANGE,
            MMT.CREATION_DATE
       FROM INV.MTL_MATERIAL_TRANSACTIONS MMT,
            INV.MTL_CST_ACTUAL_COST_DETAILS MCACD,
            INV.MTL_TRANSACTION_TYPES MTT,
            INV.MTL_SECONDARY_INVENTORIES MSI,
            INV.MTL_SYSTEM_ITEMS_B MSITEM,
            BOM.CST_QUANTITY_LAYERS CQL,
           INV. MTL_PARAMETERS MP /* INVCONV umoogala: Also added first 2 conditions */
      WHERE MP.ORGANIZATION_ID = MMT.ORGANIZATION_ID
            AND MP.PROCESS_ENABLED_FLAG = 'N'
            AND /* INVCONV umoogala: Added TxnAction 15 for Logical Intransit Receipt */
                ( (   (MMT.TRANSACTION_ACTION_ID = 12)
                   OR (MMT.TRANSACTION_ACTION_ID = 21)
                   OR (MMT.TRANSACTION_ACTION_ID = 15))
                 AND NVL (MMT.SUBINVENTORY_CODE, 'x') =
                        MSI.SECONDARY_INVENTORY_NAME(+)
                 AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID(+))
            AND /* TRANSACTION SHOULD NOT BE DISPLAYED IF IT INVOLVES EXPENSE ITEM */
                (    MMT.INVENTORY_ITEM_ID = MSITEM.INVENTORY_ITEM_ID
                 AND MMT.ORGANIZATION_ID = MSITEM.ORGANIZATION_ID
                 AND MSITEM.INVENTORY_ASSET_FLAG = 'Y')
            AND (                               /* INTRANSIT SHIP, FOB SHIP */
                  (MMT.TRANSACTION_ACTION_ID = 21
                   AND                                   /* INTRANSHIP SHIP */
                      MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
                   AND EXISTS
                          (SELECT 'X'
                             FROM INV.MTL_INTERORG_PARAMETERS MIP
                            WHERE MIP.FROM_ORGANIZATION_ID = MMT.ORGANIZATION_ID /* MAKE SURE THIS IS FOB SHIP */
                                  AND MIP.TO_ORGANIZATION_ID =
                                         MMT.TRANSFER_ORGANIZATION_ID
                                  AND NVL (MMT.FOB_POINT, MIP.FOB_POINT) = 1 /* MAKE SURE FOB SHIP */
                                                                            )
                   AND ( (MMT.ORGANIZATION_ID = MCACD.ORGANIZATION_ID
                          AND MMT.COST_GROUP_ID = CQL.COST_GROUP_ID
                          AND MMT.SUBINVENTORY_CODE =
                                 MSI.SECONDARY_INVENTORY_NAME
                          AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                          AND MSI.ASSET_INVENTORY = 1) /* MAKE SURE THE SENDING ORG IS ASSET SUB */
                        OR (MMT.TRANSFER_ORGANIZATION_ID = MCACD.ORGANIZATION_ID
                            AND                               /* FROM ASSET */
                               MMT.TRANSFER_COST_GROUP_ID = CQL.COST_GROUP_ID) /* TO INTRANSIT */
                                                                              ))
                 OR                          /* INTRANSIT RECEIPT, FOB SHIP */
                    ( /* INVCONV umoogala: Added TxnAction 15 for Logical Intransit Receipt */
                     MMT.TRANSACTION_ACTION_ID IN (12, 15)
                     AND                               /* INTRANSIT RECEIPT */
                        MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
                     AND EXISTS
                            (SELECT 'X'
                               FROM INV.MTL_INTERORG_PARAMETERS MIP
                              WHERE MIP.FROM_ORGANIZATION_ID =
                                       MMT.TRANSFER_ORGANIZATION_ID /* MAKE SURE THIS IS FOB SHIP */
                                    AND MIP.TO_ORGANIZATION_ID =
                                           MMT.ORGANIZATION_ID
                                    AND NVL (MMT.fob_point, MIP.FOB_POINT) = 1)
                     AND ( (MMT.ORGANIZATION_ID = MCACD.ORGANIZATION_ID)
                          AND ( ( (MMT.COST_GROUP_ID = CQL.COST_GROUP_ID)
                                 AND (MMT.SUBINVENTORY_CODE =
                                         MSI.SECONDARY_INVENTORY_NAME
                                      AND MMT.ORGANIZATION_ID =
                                             MSI.ORGANIZATION_ID
                                      AND MSI.ASSET_INVENTORY = 2)) /* THE RECEIVING SUB IS EXPENSE SUB */
                               OR ( ( (MMT.TRANSFER_COST_GROUP_ID =
                                          CQL.COST_GROUP_ID)
                                     OR                   /* FROM INTRANSIT */
                                        (MMT.COST_GROUP_ID = CQL.COST_GROUP_ID)) /* TO RECEIVING SUBINVENTORY */
                                   AND ( ( (MMT.SUBINVENTORY_CODE IS NULL)
                                          OR (MMT.SUBINVENTORY_CODE =
                                                 MSI.SECONDARY_INVENTORY_NAME
                                              AND MMT.ORGANIZATION_ID =
                                                     MSI.ORGANIZATION_ID
                                              AND MSI.ASSET_INVENTORY = 1))
                                        AND /* MAKE SURE THE RECEIVING SUB IS ASSET SUB */
                                            (MMT.COST_GROUP_ID !=
                                                MMT.TRANSFER_COST_GROUP_ID)))))))
            AND MCACD.LAYER_ID = CQL.LAYER_ID
            AND MTT.TRANSACTION_TYPE_ID = MMT.TRANSACTION_TYPE_ID
   GROUP BY MMT.INVENTORY_ITEM_ID,
            MCACD.TRANSACTION_ID,
            MCACD.ORGANIZATION_ID,
            MCACD.LAYER_ID,
            MCACD.TRANSACTION_ACTION_ID,
            MMT.PRIOR_COSTED_QUANTITY,
            MMT.TRANSFER_PRIOR_COSTED_QUANTITY,
            MMT.PRIMARY_QUANTITY,
            MMT.QUANTITY_ADJUSTED,
            CQL.COST_GROUP_ID,
            MCACD.TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE,
            MTT.TRANSACTION_TYPE_NAME,
            MMT.TRANSACTION_ACTION_ID,
            MMT.TRANSACTION_SOURCE_TYPE_ID,
            MMT.TRANSFER_COST_GROUP_ID,
            MMT.ORGANIZATION_ID,
            MMT.TRANSFER_ORGANIZATION_ID,
            MSI.ASSET_INVENTORY,
            MMT.COST_GROUP_ID,
            MMT.CREATION_DATE
   UNION /* UNION IS REQUIRED HERE BECAUSE THE VIEW DOESN'T JOIN TO MTL_INTERORG_PARAMETERS */
 /* AND THERE IS NOT ENOUGH INFORMATION TO DISTINGUISH BETWEEN 'INTRANSIT SHIP, FOB SHIP'*/
     /* 'INTRANSIT RECEIPT, FOB SHIP', 'INTRANSIT SHIP, FOB RECEIPT' AND */
     /* 'INTRANSIT RECEIPT, FOB RECEIPT' */
     /* SO WE ARE USING SEPARATE THOSE FOUR CASES INTO 2 GROUPS AND USE UNION TO JOIN */
     /* THOSE 2 SET OF INFORMATION TOGETHER. */
     /* MAINLY THE FIRST SELECT PART DEAL WITH FOB POINT = SHIP */
     /* THE SECOND PART DEAL WITH FOB POINT = RECEIPT */
     SELECT MMT.INVENTORY_ITEM_ID INVENTORY_ITEM_ID,
            MCACD.TRANSACTION_ID TRANSACTION_ID,
            MCACD.ORGANIZATION_ID ORGANIZATION_ID,
            MCACD.LAYER_ID LAYER_ID,
            MCACD.TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE, /* DEPENDING ON WHETHER THE TRANSACTION IS WIP SCRAP ADJUSTMENT, COST */
   /* UPDATE OR COMMON ISSUE TO WIP, SHOW THE CORRECT PRIOR COSTED QUANTITY */
   /* REMEMBER THAT FOR A COMMON ISSUE TO WIP, THERE IS ONLY ONE ROW IN MMT */
                                                   /* PRIOR COSTED QUANTITY */
            DECODE (
               MMT.TRANSACTION_ACTION_ID,
               30, MMT.PRIOR_COSTED_QUANTITY,
               1, DECODE (
                     MMT.TRANSACTION_SOURCE_TYPE_ID,
                     5, DECODE (
                           CQL.COST_GROUP_ID,
                           MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY,
                           DECODE (
                              MCACD.TRANSACTION_ACTION_ID,
                              1, MMT.TRANSFER_PRIOR_COSTED_QUANTITY
                                 - MMT.PRIMARY_QUANTITY,
                              MMT.TRANSFER_PRIOR_COSTED_QUANTITY)),
                     MMT.PRIOR_COSTED_QUANTITY), /* INTRANSIT SHIP, FOB RECEIPT */
               21, DECODE (
                      MSI.ASSET_INVENTORY,
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY, /* FROM ASSET SUB */
                                 MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* TO INTRANSIT */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* EXPENSE SUB, SHOW TO INTRANSIT */
 /* OPM INVCONV umoogala: TxnAction 22 for Logical Intransit Shipment to process org */
               22, DECODE (
                      MSI.ASSET_INVENTORY,
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY, /* FROM ASSET SUB */
                                 MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* TO INTRANSIT */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* EXPENSE SUB, SHOW TO INTRANSIT */
                                          /* INTRANSIT RECEIPT, FOB RECEIPT */
               12, DECODE (MCACD.ORGANIZATION_ID,
                           MMT.ORGANIZATION_ID, MMT.PRIOR_COSTED_QUANTITY, /* TRANSFER ORG */
                           MMT.TRANSFER_PRIOR_COSTED_QUANTITY), /* FROM INTRANSIT */
               (MMT.PRIOR_COSTED_QUANTITY))
               PRIOR_COSTED_QUANTITY, /* THINGS THAT DON'T AFFECT QUANTITY HAVE THE SAME NEW QUANTITY AS PRIOR */
                                                /* WIP SCRAP ADJUSTMENTS 30 */
            /* SPECIAL CASE FOR COMMON ISSUE TO WIP, ACTION - 1, SOURCE - 5 */
                                                        /* PRIMARY QUANTITY */
            DECODE (
               MMT.TRANSACTION_ACTION_ID,
               30, TO_NUMBER (NULL),
               1, DECODE (
                     MMT.TRANSACTION_SOURCE_TYPE_ID,
                     5, DECODE (
                           CQL.COST_GROUP_ID,
                           MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY,
                           DECODE (MCACD.TRANSACTION_ACTION_ID,
                                   1, MMT.PRIMARY_QUANTITY,
                                   -1 * MMT.PRIMARY_QUANTITY)),
                     MMT.PRIMARY_QUANTITY),  /* INTRANSIT SHIP, FOB RECEIPT */
               21, DECODE (
                      MSI.ASSET_INVENTORY,
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY, /* FROM ASSET SUB */
                                 -1 * MMT.PRIMARY_QUANTITY), /* TO INTRANSIT */
                      -1 * MMT.PRIMARY_QUANTITY), /* EXPENSE SUB, SHOW TO INTRANSIT */
 /* OPM INVCONV umoogala: TxnAction 22 for Logical Intransit Shipment to process org */
               22, DECODE (
                      MSI.ASSET_INVENTORY,
                      1, DECODE (CQL.COST_GROUP_ID,            /* ASSET SUB */
                                 MMT.COST_GROUP_ID, MMT.PRIMARY_QUANTITY, /* FROM ASSET SUB */
                                 -1 * MMT.PRIMARY_QUANTITY), /* TO INTRANSIT */
                      -1 * MMT.PRIMARY_QUANTITY), /* EXPENSE SUB, SHOW TO INTRANSIT */
                                          /* INTRANSIT RECEIPT, FOB RECEIPT */
               12, DECODE (MCACD.ORGANIZATION_ID,
                           MMT.ORGANIZATION_ID, MMT.PRIMARY_QUANTITY, /* TO REV. ORG */
                           -1 * MMT.PRIMARY_QUANTITY),    /* FROM INTRANSIT */
               MMT.PRIMARY_QUANTITY)
               PRIMARY_QUANTITY, /* THINGS THAT DON'T AFFECT QUANTITY HAVE THE SAME NEW QUANTITY AS PRIOR */
                                                /* WIP SCRAP ADJUSTMENTS 30 */
            /* SPECIAL CASE FOR COMMON ISSUE TO WIP, ACTION - 1, SOURCE - 5 */
                                                            /* NEW QUANTITY */
            DECODE (
               MMT.TRANSACTION_ACTION_ID,
               30, MMT.PRIOR_COSTED_QUANTITY,
               1, DECODE (
                     MMT.TRANSACTION_SOURCE_TYPE_ID,
                     5, DECODE (
                           CQL.COST_GROUP_ID,
                           MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY
                                              + MMT.PRIMARY_QUANTITY,
                           DECODE (
                              MCACD.TRANSACTION_ACTION_ID,
                              1, MMT.TRANSFER_PRIOR_COSTED_QUANTITY,
                              MMT.TRANSFER_PRIOR_COSTED_QUANTITY
                              - MMT.PRIMARY_QUANTITY)),
                     (MMT.PRIMARY_QUANTITY + MMT.PRIOR_COSTED_QUANTITY)), /* INTRANSIT SHIP, FOB RECEIPT */
               21, DECODE (
                      MSI.ASSET_INVENTORY,
                      1, DECODE (
                            CQL.COST_GROUP_ID,                 /* ASSET SUB */
                            MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY
                                               + MMT.PRIMARY_QUANTITY, /* FROM ASSET SUB */
                            MMT.TRANSFER_PRIOR_COSTED_QUANTITY
                            - MMT.PRIMARY_QUANTITY),        /* TO INTRANSIT */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY - MMT.PRIMARY_QUANTITY), /* EXPENSE SUB, SHOW INTRANSIT */
 /* OPM INVCONV umoogala: TxnAction 22 for Logical Intransit Shipment to process org */
               22, DECODE (
                      MSI.ASSET_INVENTORY,
                      1, DECODE (
                            CQL.COST_GROUP_ID,                 /* ASSET SUB */
                            MMT.COST_GROUP_ID, MMT.PRIOR_COSTED_QUANTITY
                                               + MMT.PRIMARY_QUANTITY, /* FROM ASSET SUB */
                            MMT.TRANSFER_PRIOR_COSTED_QUANTITY
                            - MMT.PRIMARY_QUANTITY),        /* TO INTRANSIT */
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY - MMT.PRIMARY_QUANTITY), /* EXPENSE SUB, SHOW INTRANSIT */
                                          /* INTRANSIT RECEIPT, FOB RECEIPT */
               12, DECODE (
                      MCACD.ORGANIZATION_ID,
                      MMT.ORGANIZATION_ID, MMT.PRIMARY_QUANTITY
                                           + MMT.PRIOR_COSTED_QUANTITY, /* TO REV. ORG.*/
                      MMT.TRANSFER_PRIOR_COSTED_QUANTITY - MMT.PRIMARY_QUANTITY), /* FROM INTRANSIT */
               (MMT.PRIMARY_QUANTITY + MMT.PRIOR_COSTED_QUANTITY))
               NEW_QUANTITY,
            CQL.COST_GROUP_ID COST_GROUP_ID,
            MTT.TRANSACTION_TYPE_NAME TRANSACTION_TYPE,     /* ACTUAL COSTS */
            SUM (MCACD.ACTUAL_COST) ACTUAL_COST, /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL,       /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL_OVERHEAD,       /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.ACTUAL_COST, 0))
               ACTUAL_RESOURCE,      /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.ACTUAL_COST, 0))
               ACTUAL_OUTSIDE_PROCESSING,      /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.ACTUAL_COST, 0))
               ACTUAL_OVERHEAD,                              /* PRIOR COSTS */
            SUM (MCACD.PRIOR_COST) PRIOR_COST, /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL,        /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL_OVERHEAD,        /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.PRIOR_COST, 0))
               PRIOR_RESOURCE,       /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.PRIOR_COST, 0))
               PRIOR_OUTSIDE_PROCESSING,       /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.PRIOR_COST, 0))
               PRIOR_OVERHEAD,                                 /* NEW COSTS */
            SUM (MCACD.NEW_COST) NEW_COST,     /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.NEW_COST, 0))
               NEW_MATERIAL,          /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.NEW_COST, 0))
               NEW_MATERIAL_OVERHEAD,          /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.NEW_COST, 0))
               NEW_RESOURCE,         /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.NEW_COST, 0))
               NEW_OUTSIDE_PROCESSING,         /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.NEW_COST, 0))
               NEW_OVERHEAD, /* THE EXTRA COLUMN WHERE WE DECIDE IF THERE WAS AN ACTUAL COST CHANGE */
                                                  /* AT THE ELEMENTAL LEVEL.*/
            DECODE (
               SUM (
                  DECODE (TRUNC (MCACD.NEW_COST, 5),
                          TRUNC (MCACD.PRIOR_COST, 5), 0,
                          1)),
               0, 'N',
               'Y')
               CHANGE,
            MMT.CREATION_DATE
       FROM INV.MTL_MATERIAL_TRANSACTIONS MMT,
            INV.MTL_CST_ACTUAL_COST_DETAILS MCACD,
            INV.MTL_TRANSACTION_TYPES MTT,
            INV.MTL_SECONDARY_INVENTORIES MSI,
            INV.MTL_SYSTEM_ITEMS_B MSITEM,
            BOM.CST_QUANTITY_LAYERS CQL,
            INV.MTL_PARAMETERS MP /* INVCONV umoogala: Also added first 2 conditions */
      WHERE MP.ORGANIZATION_ID = MMT.ORGANIZATION_ID
            AND MP.PROCESS_ENABLED_FLAG = 'N'
            AND /* TRANSACTION SHOULD NOT BE DISPLAYED IF IT INVOLVES EXPENSE SUB */
             /* HOWEVER FOR SUBTRANSFER AND INTERORG TRANSFER WE SHOULD NOT */
                      /* RULE OUT ANY TRANSACTIONS THAT INVOLVE EXPENSE SUB */
                       /* E.G. WE CAN HAVE EXPENSE SUB TRANFER TO ASSET SUB */
                            /* BUT WE STILL NEED TO SHOW THAT TRANSACTIONS. */
                                                                         /* */
              /* USE THE FOLLOWING CONDITION ONLY IF THE TRANSACTION IS NOT */
           /* INTERORG TRANSACTION.--> MUST AND TRANSACTION_ACTION != 12,21 */
 /* OPM INVCONV umoogala: Added TxnAction 22 for Logical Intransit Shipment */
                                                          /* to process org */
             ( ( (    (MMT.TRANSACTION_ACTION_ID != 12)
                  AND (MMT.TRANSACTION_ACTION_ID != 21)
                  AND (MMT.TRANSACTION_ACTION_ID != 22))
                AND MMT.SUBINVENTORY_CODE = MSI.SECONDARY_INVENTORY_NAME
                AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                AND MSI.ASSET_INVENTORY = 1)
              OR ( (   (MMT.TRANSACTION_ACTION_ID = 12)
                    OR (MMT.TRANSACTION_ACTION_ID = 21)
                    OR (MMT.TRANSACTION_ACTION_ID = 22))
                  AND MMT.SUBINVENTORY_CODE = MSI.SECONDARY_INVENTORY_NAME
                  AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID))
            AND /* TRANSACTION SHOULD NOT BE DISPLAYED IF IT INVOLVES EXPENSE ITEM */
                (    MMT.INVENTORY_ITEM_ID = MSITEM.INVENTORY_ITEM_ID
                 AND MMT.ORGANIZATION_ID = MSITEM.ORGANIZATION_ID
                 AND MSITEM.INVENTORY_ASSET_FLAG = 'Y')
            AND /* BECAUSE SUBINVENTORY TRANSFERS ONLY HAVE TWO ROWS IN MMT. */
                        /* BUT ONLY THE SENDING SIDE IS JOINED TO THE MCACD */
             ( /* SUBINVENTORY TRANSFER SENDING SUB, BOTH SENDING SUB AND RECEIVING SUB ARE ASSET SUBS */
               (    MMT.TRANSACTION_ACTION_ID IN (2, 5, 28, 55)
                AND /* ONLY DISPLAY THE ITEM WHEN THE FROM COST GROUP IS DIFFERENT FROM THE TO COST GROUP */
                   MMT.PRIMARY_QUANTITY < 0
                AND MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
                AND ( /* FOR COST GROUP TRANSFER TRANSFER_SUBINVENTORY CONDITION WOULD BE NULL */
                     MMT.TRANSACTION_ACTION_ID = 55
                     OR (MMT.TRANSACTION_ACTION_ID IN (2, 5, 28)
                         AND /* ASSET SUB TO ASSET SUB, DIFFERENT COST GROUP */
                             ( (MMT.SUBINVENTORY_CODE =
                                   MSI.SECONDARY_INVENTORY_NAME
                                AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                                AND MSI.ASSET_INVENTORY = 1)
                              AND EXISTS
                                     (SELECT 'X'
                                        FROM INV.MTL_SECONDARY_INVENTORIES MSI1
                                       WHERE (MMT.TRANSFER_SUBINVENTORY =
                                                 MSI1.SECONDARY_INVENTORY_NAME
                                              AND MMT.ORGANIZATION_ID =
                                                     MSI1.ORGANIZATION_ID
                                              AND MSI1.ASSET_INVENTORY = 1)) /* EXISTS */
                              AND (MMT.COST_GROUP_ID !=
                                      MMT.TRANSFER_COST_GROUP_ID)) /* END ASSET SUB TO ASSET SUB */
                         OR                     /* ASSET SUB TO EXPENSE SUB */
                            ( (MMT.SUBINVENTORY_CODE =
                                  MSI.SECONDARY_INVENTORY_NAME
                               AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                               AND MSI.ASSET_INVENTORY = 1)
                             AND EXISTS
                                    (SELECT 'X'
                                       FROM INV.MTL_SECONDARY_INVENTORIES MSI2
                                      WHERE (MMT.TRANSFER_SUBINVENTORY =
                                                MSI2.SECONDARY_INVENTORY_NAME
                                             AND MMT.ORGANIZATION_ID =
                                                    MSI2.ORGANIZATION_ID
                                             AND MSI2.ASSET_INVENTORY = 2)) /* END EXISTS */
                                                                           ) /* END ASSET SUB TO EXPENSE SUB */
                                                                            ) /* END TRANSACTION_ID IN 2,5,28 */
                                                                             ) /* TRANSACTION_ACTION_ID = 55 */
                                                                              ) /* PRIMARY_QUANTITY < 0*/
              OR /* SUBINVENTORY TRANSFER RECEIVING SUB, BOTH SENDING SUB AND RECEIVING SUB ARE ASSET SUBS */
                 (    MMT.TRANSACTION_ACTION_ID IN (2, 5, 28, 55)
                  AND MMT.PRIMARY_QUANTITY > 0
                  AND MMT.TRANSFER_TRANSACTION_ID = MCACD.TRANSACTION_ID
                  AND ( /* FOR COST GROUP TRANSFER TRANSFER_SUBINVENTORY CONDITION WOULD BE NULL */
                       MMT.TRANSACTION_ACTION_ID = 55
                       OR (MMT.TRANSACTION_ACTION_ID IN (2, 5, 28)
                           AND /* WHEN BOTH FROM AND TO SUB ARE ASSET SUB, MAKE SURE THEY ARE NOT THE SAME COST GROUP */
                               ( (MMT.SUBINVENTORY_CODE =
                                     MSI.SECONDARY_INVENTORY_NAME
                                  AND MMT.ORGANIZATION_ID =
                                         MSI.ORGANIZATION_ID
                                  AND MSI.ASSET_INVENTORY = 1)
                                AND EXISTS
                                       (SELECT 'X'
                                          FROM INV.MTL_SECONDARY_INVENTORIES MSI3
                                         WHERE (MMT.TRANSFER_SUBINVENTORY =
                                                   MSI3.SECONDARY_INVENTORY_NAME
                                                AND MMT.ORGANIZATION_ID =
                                                       MSI3.ORGANIZATION_ID
                                                AND MSI3.ASSET_INVENTORY = 1)) /* END EXISTS */
                                AND (MMT.COST_GROUP_ID !=
                                        MMT.TRANSFER_COST_GROUP_ID))
                           OR /* SENDING SUB IS EXPENSE SUB, RECEIVING SUB IS ASSET SUB */
                              ( (MMT.SUBINVENTORY_CODE =
                                    MSI.SECONDARY_INVENTORY_NAME
                                 AND MMT.ORGANIZATION_ID =
                                        MSI.ORGANIZATION_ID
                                 AND MSI.ASSET_INVENTORY = 1)
                               AND EXISTS
                                      (SELECT 'X'
                                         FROM INV.MTL_SECONDARY_INVENTORIES MSI4
                                        WHERE (MMT.TRANSFER_SUBINVENTORY =
                                                  MSI4.SECONDARY_INVENTORY_NAME
                                               AND MMT.ORGANIZATION_ID =
                                                      MSI4.ORGANIZATION_ID
                                               AND MSI4.ASSET_INVENTORY = 2)) /* END EXISTS */
                                                                             ) /* END SENDING SUB IS EXPENSE SUB, RECEIVING SUB IS ASSET SUB */
                                                                              ) /* END TRANSACTION_ACTION_ID IN 2,5,28 */
                                                                               ) /* TRANSACTION_ACTION_ID = 55 */
                                                                                ) /* END SUBTRANSFER RECEIVING SUB, BOTH SENDING SUB AND RECEIVING SUB ARE ASSET SUBS */
              OR                             /* INTRANSIT SHIP, FOB RECEIPT */
                 ( /* OPM INVCONV umoogala: Added TxnAction 22 for Logical Intransit Shipment to Process Org */
                  MMT.TRANSACTION_ACTION_ID IN (21, 22)
                  AND                                     /* INTRANSIT SHIP */
                     MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
                  AND EXISTS
                         (SELECT 'X'
                            FROM INV.MTL_INTERORG_PARAMETERS MIP
                           WHERE MIP.FROM_ORGANIZATION_ID =
                                    MMT.ORGANIZATION_ID /* MAKE SURE THIS IS FOB RECEIPT */
                                 AND MIP.TO_ORGANIZATION_ID =
                                        MMT.TRANSFER_ORGANIZATION_ID
                                 AND NVL (MMT.FOB_POINT, MIP.FOB_POINT) = 2)
                  AND ( (MMT.ORGANIZATION_ID = MCACD.ORGANIZATION_ID)
                       AND ( ( ( (MMT.SUBINVENTORY_CODE =
                                     MSI.SECONDARY_INVENTORY_NAME
                                  AND MMT.ORGANIZATION_ID =
                                         MSI.ORGANIZATION_ID
                                  AND MSI.ASSET_INVENTORY = 1) /* MAKE SURE THE SENDING SUB IS ASSET SUB */
                                AND (MMT.COST_GROUP_ID !=
                                        MMT.TRANSFER_COST_GROUP_ID)) /* MAKE SURE THE FROM / TO COST GROUP ARE DIFFERENT */
                              AND ( (MMT.COST_GROUP_ID = CQL.COST_GROUP_ID)
                                   OR                         /* FROM GROUP */
                                      (MMT.TRANSFER_COST_GROUP_ID =
                                          CQL.COST_GROUP_ID)))  /* TO GROUP */
                            OR ( (MMT.TRANSFER_COST_GROUP_ID =
                                     CQL.COST_GROUP_ID)
                                AND        /* IF SENDING SUB IS EXPENSE SUB */
                                    (MMT.SUBINVENTORY_CODE =
                                        MSI.SECONDARY_INVENTORY_NAME
                                     AND /* ONLY NEED TO SHOW THE INTRANSIT */
                                        MMT.ORGANIZATION_ID =
                                            MSI.ORGANIZATION_ID
                                     AND MSI.ASSET_INVENTORY = 2)) /* MAKE SURE THE SENDING SUB IS EXPENSE SUB */
                                                                  )))
              OR                          /* INTRANSIT RECEIPT, FOB RECEIPT */
                 (MMT.TRANSACTION_ACTION_ID = 12
                  AND                                 /* INTRANSHIP RECEIPT */
                     MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
                  AND EXISTS
                         (SELECT 'X'
                            FROM INV.MTL_INTERORG_PARAMETERS MIP
                           WHERE MIP.FROM_ORGANIZATION_ID =
                                    MMT.TRANSFER_ORGANIZATION_ID /* MAKE SURE THIS IS FOB RECEIPT */
                                 AND MIP.TO_ORGANIZATION_ID =
                                        MMT.ORGANIZATION_ID
                                 AND NVL (MMT.FOB_POINT, MIP.FOB_POINT) = 2 /* MAKE SURE FOB RECEIPT */
                                                                           )
                  AND ( (MMT.ORGANIZATION_ID = MCACD.ORGANIZATION_ID
                         AND MMT.SUBINVENTORY_CODE =
                                MSI.SECONDARY_INVENTORY_NAME
                         AND MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                         AND MMT.COST_GROUP_ID = CQL.COST_GROUP_ID
                         AND MSI.ASSET_INVENTORY = 1) /* MAKE SURE THE RECEIVING ORG IS ASSET SUB */
                       OR (MMT.TRANSFER_ORGANIZATION_ID =
                              MCACD.ORGANIZATION_ID
                           AND                 /* THIS IS FOR THE INTRANSIT */
                              MMT.TRANSFER_COST_GROUP_ID =
                                  CQL.COST_GROUP_ID)))
              OR (MMT.TRANSACTION_ACTION_ID NOT IN (2, 5, 28, 55)
                  AND (MMT.TRANSACTION_ACTION_ID != 12
                       AND MMT.TRANSACTION_ACTION_ID != 21)
                  AND MMT.TRANSACTION_ACTION_ID != 24
                  AND   /* AVERAGE COST UPDATE WAS HANDLED BY ANOTHER UNION */
                     MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
                  AND MMT.ORGANIZATION_ID = MCACD.ORGANIZATION_ID))
            AND MCACD.LAYER_ID = CQL.LAYER_ID
            AND MTT.TRANSACTION_TYPE_ID = MMT.TRANSACTION_TYPE_ID
            AND /* FOR NOT WIP COMPONENT ISSUE, JOIN WITH COST_GROUP_ID AND CQL */
           /* BECAUSE IN SOME CASES MCACD HAS TWO DIFFERENT LAYER IDS WHICH */
        /* WILL RESULT IN MORE ROWS IF WE DON'T SELECT BY MMT.COST_GROUP_ID */
      /* FOR INTERORG SHIP, RECEIPT IT WAS HANDLED ON THE ABOVE, DON'T NEED */
                                          /* TO JOIN THE COST GROUP ID HERE */
 /* OPM INVCONV umoogala: TxnAction 22 for Logical Intransit Shipment to process org */
             ( ( ( ( (MMT.TRANSACTION_ACTION_ID != 1)
                    OR (MMT.TRANSACTION_SOURCE_TYPE_ID != 5))
                  AND (    (MMT.TRANSACTION_ACTION_ID != 12)
                       AND (MMT.TRANSACTION_ACTION_ID != 21)
                       AND (MMT.TRANSACTION_ACTION_ID != 22)))
                AND MMT.COST_GROUP_ID = CQL.COST_GROUP_ID)
              OR ( ( (MMT.TRANSACTION_ACTION_ID = 1)
                    AND (MMT.TRANSACTION_SOURCE_TYPE_ID = 5)))
              OR (   MMT.TRANSACTION_ACTION_ID = 12
                  OR MMT.TRANSACTION_ACTION_ID = 21
                  OR MMT.TRANSACTION_ACTION_ID = 22)) /* OPM INVCONV umoogala: TxnAction 22 for Logical Intransit Shipment to process org. Do not skip this logical txn */
            AND (NVL (MMT.LOGICAL_TRANSACTION, 0) <> 1
                 AND MMT.TRANSACTION_ACTION_ID <> 22) /* Ignore logical txns introduced for dropship project */
   GROUP BY MMT.INVENTORY_ITEM_ID,
            MCACD.TRANSACTION_ID,
            MCACD.ORGANIZATION_ID,
            MCACD.LAYER_ID,
            MCACD.TRANSACTION_ACTION_ID,
            MMT.PRIOR_COSTED_QUANTITY,
            MMT.TRANSFER_PRIOR_COSTED_QUANTITY,
            MMT.PRIMARY_QUANTITY,
            MMT.QUANTITY_ADJUSTED,
            CQL.COST_GROUP_ID,
            MCACD.TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE,
            MTT.TRANSACTION_TYPE_NAME,
            MMT.TRANSACTION_ACTION_ID,
            MMT.TRANSACTION_SOURCE_TYPE_ID,
            MMT.TRANSFER_COST_GROUP_ID,
            MMT.ORGANIZATION_ID,
            MMT.TRANSFER_ORGANIZATION_ID,
            MSI.ASSET_INVENTORY,
            MMT.COST_GROUP_ID,
            MMT.CREATION_DATE                            /* FOR COST UPDATE */
   UNION                 /* THE NEXT UNION IS TO HANDLE AVERAGE COST UPDATE */
     SELECT MMT.INVENTORY_ITEM_ID INVENTORY_ITEM_ID,
            MCACD.TRANSACTION_ID TRANSACTION_ID,
            MCACD.ORGANIZATION_ID ORGANIZATION_ID,
            MCACD.LAYER_ID LAYER_ID,
            MCACD.TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE,                  /* PRIOR COSTED QUANTITY */
            MMT.PRIOR_COSTED_QUANTITY PRIOR_COSTED_QUANTITY, /* PRIMARY QUANTITY */
            TO_NUMBER (NULL) PRIMARY_QUANTITY,              /* NEW QUANTITY */
            MMT.PRIOR_COSTED_QUANTITY NEW_QUANTITY,
            CQL.COST_GROUP_ID COST_GROUP_ID,
            MTT.TRANSACTION_TYPE_NAME TRANSACTION_TYPE,     /* ACTUAL COSTS */
            SUM (MCACD.ACTUAL_COST) ACTUAL_COST, /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL,       /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL_OVERHEAD,       /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.ACTUAL_COST, 0))
               ACTUAL_RESOURCE,      /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.ACTUAL_COST, 0))
               ACTUAL_OUTSIDE_PROCESSING,      /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.ACTUAL_COST, 0))
               ACTUAL_OVERHEAD,                              /* PRIOR COSTS */
            SUM (MCACD.PRIOR_COST) PRIOR_COST, /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL,        /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL_OVERHEAD,        /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.PRIOR_COST, 0))
               PRIOR_RESOURCE,       /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.PRIOR_COST, 0))
               PRIOR_OUTSIDE_PROCESSING,       /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.PRIOR_COST, 0))
               PRIOR_OVERHEAD,                                 /* NEW COSTS */
            SUM (MCACD.NEW_COST) NEW_COST,     /* FOR MATERIAL ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.NEW_COST, 0))
               NEW_MATERIAL,          /* FOR MATERIAL OVERHEAD ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.NEW_COST, 0))
               NEW_MATERIAL_OVERHEAD,          /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.NEW_COST, 0))
               NEW_RESOURCE,         /* FOR OUTSIDE PROCESSING ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.NEW_COST, 0))
               NEW_OUTSIDE_PROCESSING,         /* FOR RESOURCE ELEMENT COST */
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.NEW_COST, 0))
               NEW_OVERHEAD, /* THE EXTRA COLUMN WHERE WE DECIDE IF THERE WAS AN ACTUAL COST CHANGE */
                                                  /* AT THE ELEMENTAL LEVEL.*/
            DECODE (
               SUM (
                  DECODE (TRUNC (MCACD.NEW_COST, 5),
                          TRUNC (MCACD.PRIOR_COST, 5), 0,
                          1)),
               0, 'N',
               'Y')
               CHANGE,
            MMT.CREATION_DATE
       FROM INV.MTL_MATERIAL_TRANSACTIONS MMT,
            INV.MTL_CST_ACTUAL_COST_DETAILS MCACD,
            INV.MTL_TRANSACTION_TYPES MTT,
            BOM.CST_QUANTITY_LAYERS CQL
      WHERE (    MMT.TRANSACTION_ACTION_ID = 24
             AND MMT.TRANSACTION_ID = MCACD.TRANSACTION_ID
             AND MMT.ORGANIZATION_ID = MCACD.ORGANIZATION_ID)
            AND MCACD.LAYER_ID = CQL.LAYER_ID
            AND MTT.TRANSACTION_TYPE_ID = MMT.TRANSACTION_TYPE_ID
            AND MMT.COST_GROUP_ID = CQL.COST_GROUP_ID
   GROUP BY MMT.INVENTORY_ITEM_ID,
            MCACD.TRANSACTION_ID,
            MCACD.ORGANIZATION_ID,
            MCACD.LAYER_ID,
            MCACD.TRANSACTION_ACTION_ID,
            MMT.PRIOR_COSTED_QUANTITY,
            MMT.TRANSFER_PRIOR_COSTED_QUANTITY,
            MMT.PRIMARY_QUANTITY,
            MMT.QUANTITY_ADJUSTED,
            CQL.COST_GROUP_ID,
            MCACD.TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE,
            MTT.TRANSACTION_TYPE_NAME,
            MMT.TRANSACTION_ACTION_ID,
            MMT.TRANSACTION_SOURCE_TYPE_ID,
            MMT.TRANSFER_COST_GROUP_ID,
            MMT.ORGANIZATION_ID,
            MMT.TRANSFER_ORGANIZATION_ID,
            MMT.COST_GROUP_ID,
            MMT.CREATION_DATE /* This next union is for the dropshipment project. The other selects in this view will * not pick up sales order issue transactions that are part of a transaction flow for the * new drop ship accounting because there is no corresponding MCACD data. This * union will get the MCACD data from the corresponding logical intercompany sales * issue transaction in the same organization. */
   UNION
     SELECT MMT.INVENTORY_ITEM_ID INVENTORY_ITEM_ID,
            MMT.TRANSACTION_ID TRANSACTION_ID,
            MMT.ORGANIZATION_ID ORGANIZATION_ID,
            MCACD.LAYER_ID LAYER_ID,
            MMT.TRANSACTION_DATE TRANSACTION_COSTED_DATE,
            MMT.TRANSACTION_DATE,
            MMT.PRIOR_COSTED_QUANTITY PRIOR_COSTED_QUANTITY,
            MMT.PRIMARY_QUANTITY PRIMARY_QUANTITY,
            (MMT.PRIMARY_QUANTITY + MMT.PRIOR_COSTED_QUANTITY) NEW_QUANTITY,
            CQL.COST_GROUP_ID COST_GROUP_ID,
            MTT.TRANSACTION_TYPE_NAME TRANSACTION_TYPE,
            SUM (MCACD.ACTUAL_COST) ACTUAL_COST,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.ACTUAL_COST, 0))
               ACTUAL_MATERIAL_OVERHEAD,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.ACTUAL_COST, 0))
               ACTUAL_RESOURCE,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.ACTUAL_COST, 0))
               ACTUAL_OUTSIDE_PROCESSING,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.ACTUAL_COST, 0))
               ACTUAL_OVERHEAD,
            SUM (MCACD.PRIOR_COST) PRIOR_COST,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.PRIOR_COST, 0))
               PRIOR_MATERIAL_OVERHEAD,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.PRIOR_COST, 0))
               PRIOR_RESOURCE,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.PRIOR_COST, 0))
               PRIOR_OUTSIDE_PROCESSING,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.PRIOR_COST, 0))
               PRIOR_OVERHEAD,
            SUM (MCACD.NEW_COST) NEW_COST,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 1, MCACD.NEW_COST, 0))
               NEW_MATERIAL,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 2, MCACD.NEW_COST, 0))
               NEW_MATERIAL_OVERHEAD,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 3, MCACD.NEW_COST, 0))
               NEW_RESOURCE,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 4, MCACD.NEW_COST, 0))
               NEW_OUTSIDE_PROCESSING,
            SUM (DECODE (MCACD.COST_ELEMENT_ID, 5, MCACD.NEW_COST, 0))
               NEW_OVERHEAD,
            DECODE (TRUNC (MMT.NEW_COST, 5),
                    TRUNC (MMT.PRIOR_COST, 5), 'N',
                    'Y')
               CHANGE,
            MMT.CREATION_DATE
       FROM INV.MTL_MATERIAL_TRANSACTIONS MMT,
            INV.MTL_TRANSACTION_TYPES MTT,
            INV.MTL_CST_ACTUAL_COST_DETAILS MCACD,
            BOM.CST_QUANTITY_LAYERS CQL,
            INV.MTL_MATERIAL_TRANSACTIONS MMT2,
            INV.MTL_PARAMETERS MP /* INVCONV umoogala: Also added first 2 conditions */
      WHERE     MP.ORGANIZATION_ID = MMT.ORGANIZATION_ID
            AND MP.PROCESS_ENABLED_FLAG = 'N'
            AND MMT.TRANSACTION_SOURCE_TYPE_ID IN (2, 12)
            AND MMT.TRANSACTION_ACTION_ID IN (1, 27)
            AND MTT.TRANSACTION_TYPE_ID = MMT.TRANSACTION_TYPE_ID
            AND MMT.PARENT_TRANSACTION_ID = MMT.TRANSACTION_ID
            AND MMT2.ORGANIZATION_ID = MMT.ORGANIZATION_ID
            AND MMT2.TRANSACTION_TYPE_ID = 11
            AND MMT2.PARENT_TRANSACTION_ID = MMT.TRANSACTION_ID
            AND MCACD.TRANSACTION_ID = MMT2.TRANSACTION_ID
            AND MCACD.ORGANIZATION_ID = MMT.ORGANIZATION_ID
            AND MCACD.LAYER_ID = CQL.LAYER_ID
            AND MMT.COST_GROUP_ID = CQL.COST_GROUP_ID
            AND MMT.COSTED_FLAG IS NULL
   GROUP BY MMT.INVENTORY_ITEM_ID,
            MMT.TRANSACTION_ID,
            MMT.ORGANIZATION_ID,
            MCACD.LAYER_ID,
            MMT.TRANSACTION_DATE,
            MMT.PRIOR_COSTED_QUANTITY,
            MMT.PRIMARY_QUANTITY,
            CQL.COST_GROUP_ID,
            MTT.TRANSACTION_TYPE_NAME,
            MMT.NEW_COST,
            MMT.PRIOR_COST,
            MMT.CREATION_DATE;
