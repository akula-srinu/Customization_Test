-- Purpose: APPS.XXNAO_VSAT_WRAPPER_PKG
--
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       ------------------------------------------
-- Srini Akula 06-Aug-2015  Created.
-- Srini Akula 06-Aug-2015  Added get_award_classification function (JIRA-521)
-- Srini Akula 09-Nov-2015  Added get_mrp_action function (JIRA-520)
-- Srini Akula 30-Jan-2017  Added get_ro_warranty_date (JIRA-799)
-- Srini Akula 10-Apr-2017  Added get_DRO_Evenet_Details (JIRA-790)
-- Srini Akula 28-Aug-2017  Added get_po_total function (JIRA-825)

CREATE OR REPLACE PACKAGE XXNAO_VSAT_WRAPPER_PKG
IS
   FUNCTION get_award_classification (p_project_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_mrp_action ( 
                p_arg_source_table IN VARCHAR2
                ,p_arg_bom_item_type IN NUMBER DEFAULT NULL
                ,p_arg_base_item_id IN NUMBER DEFAULT NULL
                ,p_arg_wip_supply_type IN NUMBER DEFAULT NULL
                ,p_arg_order_type IN NUMBER DEFAULT NULL
                ,p_arg_disposition_status_type IN NUMBER DEFAULT NULL
                ,p_release_status in number
                ,p_status in number
                ,p_new_due_date        in date
                ,p_old_due_date        in date
                ,p_implemented_quantity        in number
                ,p_quantity_in_process        in number
                ,p_firm_quantity            in number
                ,p_quantity_rate            in number
                ,p_user_id                  in number
                ,p_arg_rescheduled_flag        in number
) RETURN VARCHAR;

FUNCTION get_ro_warranty_date(p_instance_id NUMBER) RETURN DATE;        -- Added for JIRA 799

FUNCTION get_DRO_Evenet_Details ( p_Repair_History_ID IN NUMBER) RETURN VARCHAR;    -- Added for JIRA 790

FUNCTION get_po_total ( p_object_type IN VARCHAR2, p_header_id in NUMBER) RETURN NUMBER;    -- Added for JIRA 825

END xxnao_vsat_wrapper_pkg;
/

CREATE OR REPLACE PACKAGE BODY XXNAO_VSAT_WRAPPER_PKG
IS
   FUNCTION get_award_classification (p_project_id NUMBER)
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_project_id IS NOT NULL
      THEN
         RETURN vsat_okc_utils.get_award_classification (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_Award_Classification Excepption: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;


FUNCTION get_mrp_action ( 
                p_arg_source_table IN VARCHAR2
                ,p_arg_bom_item_type IN NUMBER DEFAULT NULL
                ,p_arg_base_item_id IN NUMBER DEFAULT NULL
                ,p_arg_wip_supply_type IN NUMBER DEFAULT NULL
                ,p_arg_order_type IN NUMBER DEFAULT NULL
                ,p_arg_disposition_status_type IN NUMBER DEFAULT NULL
                ,p_release_status in number
                ,p_status in number
                ,p_new_due_date        in date
                ,p_old_due_date        in date
                ,p_implemented_quantity        in number
                ,p_quantity_in_process        in number
                ,p_firm_quantity            in number
                ,p_quantity_rate            in number
                ,p_user_id                  in number
                ,p_arg_rescheduled_flag        in number
) RETURN VARCHAR is
BEGIN
      IF p_arg_source_table IS NOT NULL
      THEN
         RETURN vsat_mrp_utils.get_mrp_action ( 
                p_arg_source_table
                ,p_arg_bom_item_type
                ,p_arg_base_item_id
                ,p_arg_wip_supply_type
                ,p_arg_order_type
                ,p_arg_disposition_status_type
                ,p_release_status
                ,p_status
                ,p_new_due_date
                ,p_old_due_date
                ,p_implemented_quantity
                ,p_quantity_in_process
                ,p_firm_quantity
                ,p_quantity_rate
                ,p_user_id
                ,p_arg_rescheduled_flag);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - VSAT_MRP_UTILS.get_MRP Action Excepption: '
                 || SQLCODE
                 || '-'
                 || SQLERRM);
END get_mrp_action;

FUNCTION get_ro_warranty_date(p_instance_id NUMBER) RETURN DATE        -- Added function for JIRA 788
   IS
   BEGIN
      IF p_instance_id IS NOT NULL
      THEN
         RETURN VSAT_SRVC_UTILS_PKG.get_warranty_date(p_instance_id) ;
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_ro_warranty_date: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Instance Id: '
                 || p_instance_id);
   END;


FUNCTION get_DRO_Evenet_Details ( 
                p_Repair_History_ID IN NUMBER) RETURN VARCHAR is
BEGIN
      IF p_Repair_History_ID IS NOT NULL
      THEN
         RETURN APPS.CSD_REPAIR_HISTORY_PVT.GET_HISTORY_DETAIL(p_Repair_History_ID);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_DRO_Evenet_Details Excepption: '
                 || SQLCODE
                 || '-'
                 || SQLERRM);
END get_DRO_Evenet_Details;

FUNCTION get_po_total ( p_object_type IN VARCHAR2, p_header_id in NUMBER) RETURN NUMBER is    -- Added for JIRA 825
BEGIN
      IF p_object_type IS NOT NULL and p_header_id is not null 
      THEN
         RETURN APPS.po_core_s.get_total(p_object_type,p_header_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_po_total Excepption: '
                 || SQLCODE
                 || '-'
                 || SQLERRM);
END get_po_total;

END xxnao_vsat_wrapper_pkg;
/