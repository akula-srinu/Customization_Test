@utlspon N_IB_INTENDED_BOM_VSAT

CREATE OR REPLACE FORCE VIEW N_IB_INTENDED_BOM_VSAT
(
   INSTANCE_ID,
   PART_NUMBER,
   PART_REVISION,
   SERIAL_NUMBER,
   START_DATE,
   PARENT_INSTANCE_ID,
   LOT_NUMBER,
   INST_REL_END_DATE,
   BOM_LEVEL
)
AS
       SELECT cir.subject_id instance_id,
              msi.segment1 part_number,
              cii.inventory_revision part_revision,
              cii.serial_number,
              cir.active_start_date start_date,
              cir.object_id parent_instance_id,
              cii.lot_number lot_number,
              cir.active_end_date inst_rel_end_date,
              LEVEL BOM_Level
         FROM csi.csi_ii_relationships cir,
              csi.csi_item_instances cii,
              inv.mtl_system_items_b msi
        WHERE     1 = 1
              AND cii.inventory_item_id = msi.inventory_item_id
              AND cii.last_vld_organization_id = msi.organization_id
              AND cii.instance_id = cir.subject_id
              AND cir.relationship_type_code = 'COMPONENT-OF'
              AND cir.active_end_date IS NULL
   CONNECT BY PRIOR cir.subject_id = cir.object_id
   START WITH cir.object_id = 264982
