@utlspon N_PO_PRICE_LIST_VSAT

CREATE OR REPLACE FORCE VIEW N_PO_PRICE_LIST_VSAT
(
   ITEM_NUMBER,
   ITEM_DESCRIPTION,
   INVENTORY_ITEM_ID,
   SUPPLIER_NAME,
   LEAD_TIME,
   MIN_ORDER_QTY,
   FIXED_LOT_MPLR,
   PRICE_LIST,
   PB_QTY_FROM,
   PB_QTY_TO,
   PRICE
)
AS   
   SELECT    
   msi.segment1 item_number,
          (SELECT MAX (description)
             FROM inv.mtl_system_items_tl iteml
            WHERE iteml.inventory_item_id = msi.inventory_item_id
                  AND iteml.language = 'US')
             item_description,
          msi.inventory_item_id,
          SUBSTR (qlh.name, -1 * LENGTH (qlh.name) + 15) supplier_name,
          msi.full_lead_time lead_time,
          msi.minimum_order_quantity min_order_qty,
          msi.fixed_lot_multiplier fixed_lot_mplr,
          qlh.name price_list,
          qpb.pricing_attr_value_from pb_qty_from,
          DECODE (qpb.pricing_attr_value_to,
                  999999999999999, NULL,
                  qpb.pricing_attr_value_to)
             pb_qty_to,
          qpb.operand price       
     FROM 
          apps.qp_secu_list_headers_v qlh,
          apps.qp_list_lines_v qll,
          apps.qp_price_breaks_v qpb,
          (  SELECT inventory_item_id,
                    segment1,
                    AVG (full_lead_time) full_lead_time,
                    AVG (minimum_order_quantity) minimum_order_quantity,
                    AVG (fixed_lot_multiplier) fixed_lot_multiplier
               FROM apps.mtl_system_items_b
              WHERE organization_id <> 48
           GROUP BY inventory_item_id, segment1) msi
    WHERE  1=1
          AND qlh.end_date_active IS NULL
	  AND qlh.name like 'PO PriceList%' 
          AND qlh.list_header_id = qll.list_header_id
          AND qll.list_line_id = qpb.parent_list_line_id (+)
          AND qll.end_date_active IS NULL
          AND qll.product_attribute_context = 'ITEM'
          AND (qll.product_attr_value) = to_char(msi.inventory_item_id);                                        



@utlspoff