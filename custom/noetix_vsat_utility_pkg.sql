-- Purpose: noetix_vsat_utility_pkg
--
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       ------------------------------------------
-- Srini Akula 09-Sep-2014  Created.
-- Srini Akula 09-Sep-2014  Added few functions.
-- Srini Akula 16-Oct-2014  Added few functions.
-- Srini Akula 20-Oct-2014  Added few functions.
-- Srini Akula 22-Oct-2014  Added few functions.
-- Srini Akula 30-Oct-2014  Added few functions.
-- Srini Akula 05-Nov-2014  Added few functions.
-- Srini Akula 10-Nov-2014  Added few functions.
-- Srini Akula 13-Nov-2014  Added few functions.
-- Dilip Kumar 13-NOV-2014  Added Function PROJ_CONT_CONTNBR,GET_USER_NAME and PROJ_MANAGER
-- Dilip Kumar 24-NOV-2014  Added Functions GetPlanner, GETITEMNAME
-- Srini Akula 30-NOV-2014  Added VSAT_GET_CONTRACT_NBR function.
-- Srini Akula 04-Dec-2014  Added GetShipmentLineOnTimeLate function.
-- Srini Akula 05-Dec-2014  Added Get_Project_Id function.
-- Srini Akula 11-Dec-2014  Added get_max_period_counter function.
-- Srini Akula 17-Dec-2014  Modified the cursor login in getokeexportadminuser function.
-- Srini Akula 08-Jan-2015  Added the get_transaction_header_id_in function.
-- Srini Akula 11-Feb-2015  Added the following functions to the package (Jira-315)
--                    getitemprodline ()
--                getitemprodtype ()
--                getcontractandboafromproject ()
-- Srini Akula 12-Apr-2015  Added get_fiscal_period_info function (JIRA-420)
-- Srini Akula 15-Apr-2015  Added get_project_task_activity function (JIRA-419)
-- Srini Akula 22-Apr-2015  Updated the select statement of the cursor 'c_line_quantity' in
--                get_project_task_activity function (JIRA-419)
-- Srini Akula 04-May-2015  Added SQLCODE for tracking the error messages in the EXCEPTION section of the 
--                package function getfreightterm. (JIRA-327)
-- Srini Akula 01-Jun-2015  Added get_project_task_expenditures function (JIRA-453)
-- Srini Akula 06-Jun-2015  Updated the code of get_project_task_activity (JIRA-452)
-- Srini Akula 06-Jun-2015  Added the get_item_ams_category function (JIRA-478)
-- Srini Akula 30-Jun-2015  Added cf_projectformula function. (JIRA-504)
-- Srini Akula 06-Jul-2015  Modified the code of the function get_fiscal_period_info function (JIRA-506)
-- Srini Akula 13-Jul-2015  Added 'get_intangible_type' function (JIRA-516)
-- Srini Akula 13-Jul-2015  Removed the INTO clause in the cursor of cf_projectformula function. (JIRA-504)
-- Srini Akula 13-Jul-2015  Improved the error messages in getfreightterm function (JIRA-511)
-- Srini Akula 29-Jul-2015  Added get_project_category_info function (JIRA-525).
-- Srini Akula 29-Jul-2015  Added get_task_expenditures_by_date function (JIRA-508).
-- Srini Akula 30-Oct-2015  Added get_purchasing_category_info function (JIRA-562)
-- Srini Akula 01-Feb-2016  Added cf_projectformula2 function (JIRA-599)
-- Srini Akula 08-Feb-2016  Added below functions (JIRA-609)
--                get_cost_group_item_cost
--                get_cancelled_qty_from_okd
--                get_cost_group_from_proj
--                get_shipped_qty_from_okd
-- Srini Akula 28-Mar-2016  Added GetItemLeadTime function (JIRA-656)
-- Srini Akula 11-Apr-2016  Added Total_Blanket_Release_Amount (JIRA-664)
-- Srini Akula 12-Apr-2016  Logic for the 'get_total_requirements' modified (JIRA-660)
-- Srini Akula 22-Apr-2016  Added get_max_seq_num_w_qty and get_max_seq_num_w_qty_desc functions (JIRA-651)
-- Srini Akula 22-Apr-2016  Added job_final_qa_last_moved_date function (JIRA-679)
-- Srini Akula 22-Apr-2016  Added serial_time_in_location function (JIRA-661)
-- Srini Akula 27-Jun-2016  Corrected the where condition in get_max_seq_num_w_qty_desc function (JIRA-651)
-- Srini Akula 01-Jul-2016  Updated the return statement in the exception block of the function job_final_qa_last_moved_date.
-- Srini Akula 08-Aug-2016  Added Get_DRO_OPEN_Time, Get_DRO_HOLD_Time, Get_DRO_REPAIR_Time functions.
-- Srini Akula 09-Sep-2016  Added get_serials_wip_step and get_serials_wip_completed functions.
-- Srini Akula 10-Oct-2016  Added job_repair_loe, serial_num_ship_date functions  (JIRA-785).
-- Srini Akula 17-Oct-2016  Added last_3_notes function (JIRA-770).
-- Srini Akula 05-Dec-2016  Added get_nmr_values  function (JIRA-556).
-- Srini Akula 05-Jan-2017  Modified get_nmr_values  function (JIRA-556).
-- Srini Akula 01-Feb-2017  Modified the size of the variables in get_serials_wip_step function (JIRA-838).
-- Srini Akula 01-Feb-2017  Modified the size of the variables in get_serials_wip_completed function (JIRA-838).
-- Selwyn D.   10-Feb-2017  Modified Get_DRO_HOLD_Time and Get_DRO_REPAIR_Time functions. (JIRA-833).
-- Srini Akula 29-May-2017  Added few functions (JIRA-850).
-- Srini Akula 29-May-2017  Added om_hold_exists function (JIRA-898)
-- Srini Akula 29-Sep-2017  Added get_times_returned_info function (JIRA-911)
-- Srini Akula 29-Sep-2017  Added get_avg_addl_funds_info function (JIRA-912)
-- Srini Akula 31-Oct-2017  Modified the logic of the function serial_num_ship_date (JIRA-919)
-- Srini Akula 31-Oct-2017  Added get_mrp_req_details function (JIRA-889)
-- Srini Akula 31-Oct-2017  Added get_assembly_revision_info (JIRA-914)
-- Srini Akula 30-Jan-2018  Updated the logic in DRO Timings Packages (JIRA-947)
-- S.Dorairaj  12-Feb-2018  Updated procedure Get_DRO_HOLD_Time for JIRA-947
-- Srini Akula 27-Feb-2018  Added get_planning_group_qty (JIRA-965)
-- Srini Akula 27-Mar-2018  Added get_serials_wip_associated function (JIRA-950)
-- Srini Akula 27-Mar-2018  Added get_first_lot_txn_type, get_first_lot_txn_source functions (JIRA-961)
-- Srini Akula 30-Mar-2018  Added get_viasat_business_work_days function (JIRA-969)
-- Srini Akula 29-May-2018  Added item_first_purch_date function (JIRA-992)
-- Srini Akula 29-May-2018  Modified get_serials_wip_completed and  get_serials_wip_step functions (JIRA-1000)
-- Srini Akula 29-May-2018  Added get_first_serial_txn_type and get_first_serial_txn_source functions (JIRA-1009)
-- Srini Akula 29-May-2018  Added get_serials_op_seq function (JIRA-1010)
-- Srini Akula 04-Jun-2018  Added get_employee_education function (JIRA-1015)
-- Srini Akula 20-Jul-2018  Added get_orig_promised_date and get_prev_promised_date functions (JIRA-1044)
-- Srini Akula 05-Dec-2018  Added p_Delivery_detail_id parameter to cf_serial_numbersformula function (JIRA-1083)
-- Srini Akula 09-Dec-2018  Added serial number length exception to cf_serial_numbersformula function (JIRA-1095)
-- Srini Akula 14-Jan-2019  Removed Award_Class_Current_Contract function (JIRA-1107)
-- Srini Akula 15-May-2019  Added long_to_char and note_length functions (CDS-730)

CREATE OR REPLACE PACKAGE noetix_vsat_utility_pkg
IS
   

-- Test Comment

gc_user_person_type_separator   CONSTANT VARCHAR2 (1) := '.';

   FUNCTION get_ship_date (p_incident_id     IN NUMBER,
                           p_serial_number   IN VARCHAR2)
      RETURN DATE;

   FUNCTION get_user_person_type (p_person_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_projects_list (p_resource_id     IN NUMBER,
                               p_resource_type   IN VARCHAR2,
                               p_period_name     IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION gettxncustomername (p_transaction_id          IN NUMBER,
                                p_transaction_source_id   IN NUMBER,
                                p_serial_number           IN VARCHAR2,
                                p_trans_source_type       IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_meaning (p_lookup_code IN VARCHAR2, p_tag IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION getfreightterm (pheaderid IN NUMBER, plineid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION GET_FILE_NAME (p_file_id IN NUMBER, p_type IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_username (p_user_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_business_work_days (p_start_date IN DATE, p_end_date IN DATE)
      RETURN NUMBER;

   FUNCTION get_advance_replacement (p_inventory_item_id   IN NUMBER,
                                     p_header_id           IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION inventorycategoryexists (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getitemcategory (p_inventory_item_id   IN NUMBER,
                             p_org_id              IN NUMBER,
                             p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2;


   FUNCTION getinvclass (p_inventory_item_id   IN NUMBER,
                         p_org_id              IN NUMBER,
                         p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION getproductline (p_inventory_item_id   IN NUMBER,
                            p_org_id              IN NUMBER,
                            p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION getproducttype (p_inventory_item_id   IN NUMBER,
                            p_org_id              IN NUMBER,
                            p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2;



   FUNCTION gettranssourceall (p_trans_source_type   IN VARCHAR2,
                               p_trans_source_id     IN NUMBER,
                               p_organization_id     IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION gettranssource (p_trans_source_type   IN VARCHAR2,
                            p_trans_source_id     IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_manufacturer_name (p_inventory_item_id   IN NUMBER,
                                   p_organization_id     IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_manufact_part_num (p_inventory_item_id   IN NUMBER,
                                   p_organization_id     IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION rma_number (x_id NUMBER)
      RETURN NUMBER;

   FUNCTION get_org_code (p_org_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_employee_full_name (p_person_id        IN NUMBER,
                                    p_effective_date   IN DATE)
      RETURN VARCHAR2;


   FUNCTION get_medical_code (p_pl_id               IN NUMBER,
                              p_date_earned         IN DATE,
                              p_assignment_id       IN NUMBER,
                              p_prtt_enrt_rslt_id   IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_instance_ship_date (p_instance_id IN NUMBER)
      RETURN DATE;

   FUNCTION get_nmr_4qir (p_qir IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_business_area_4pgm (p_pgm IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_qa_name_4userid (p_user_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_budget_rev (p_project_id IN NUMBER, p_period1_date IN DATE)
      RETURN NUMBER;



   FUNCTION get_burden_cost (p_project_id IN NUMBER, p_period1_date IN DATE)
      RETURN NUMBER;


   -- Add Function to package Spec noetix_vsat_utility_pkg

   FUNCTION getokeexportadminuser (pokekheaderid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getorderexportadmin (p_header_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION isnumeric (pvalue VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION isnumericexp (pvalue VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION getsncountinrange (psnfrom IN VARCHAR2, psnto IN VARCHAR2)
      RETURN NUMBER;


   FUNCTION getparentdetailid (pdeldetid IN NUMBER)
      RETURN NUMBER;

   FUNCTION proj_cont_contnbr (v_proj IN VARCHAR2)
      RETURN VARCHAR2;


   FUNCTION get_user_name (p_user_id IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION proj_manager (v_proj IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION avgitemcost (porgid       IN NUMBER,
                         pitemid      IN NUMBER,
                         pcostgroup   IN NUMBER)
      RETURN NUMBER;

   FUNCTION vsat_get_contract_nbr (p_trx_id NUMBER)
      RETURN VARCHAR2;



   FUNCTION cf_serial_numbersformula (p_item_id                IN NUMBER,
                                      p_source_header_number   IN VARCHAR2,
                                      p_source_line_id         IN NUMBER,
                                      p_delivery_id            IN NUMBER,
			 	      p_delivery_detail_id     IN NUMBER)
      RETURN VARCHAR2;


   FUNCTION get_ship_to_name (p_source IN VARCHAR2, p_ship_to_id IN NUMBER)
      RETURN VARCHAR2;


   FUNCTION dpas_rating (p_line_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_mrp_action (p_source_table              IN VARCHAR2,
                            p_item_type                 IN VARCHAR2,
                            p_item_id                   IN NUMBER,
                            p_wip_supply_type           IN NUMBER,
                            p_order_type                IN NUMBER,
                            p_rescheduled_flag          IN NUMBER,
                            p_disposition_status_type   IN NUMBER,
                            p_new_due_date              IN DATE,
                            p_old_due_date              IN DATE,
                            p_implemented_quantity      IN NUMBER,
                            p_quantity_in_process       IN NUMBER,
                            p_firm_quantity             IN NUMBER,
                            p_quantity_rate             IN NUMBER)
      RETURN VARCHAR2;


   FUNCTION get_total_consumption (p_org          IN NUMBER,
                                   p_item         IN NUMBER,
                                   p_date_start   IN DATE,
                                   p_date_end     IN DATE)
      RETURN NUMBER;

   FUNCTION get_total_requirements (p_org IN VARCHAR2, p_item IN NUMBER)
      RETURN NUMBER;

   FUNCTION get_req_last_new_date (p_org    IN NUMBER,
                                   p_item   IN NUMBER,
                                   p_date   IN DATE)
      RETURN DATE;

   FUNCTION getprojectmgrfromprojectid (x_project_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getpmnamefromlineid (plineid IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION getitemcost (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN NUMBER;

   FUNCTION getitemname (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getplanner (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getshipmentlineontimelate (pshipid        IN NUMBER,
                                       pordqty        IN NUMBER,
                                       ppromisedate   IN DATE,
                                       pasofdate      IN DATE,
                                       pallowance     IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_project_id (p_proj_num VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_max_period_counter (p_asset_id            IN NUMBER,
                                    p_book_type_code      IN VARCHAR2,
                                    p_period_close_date   IN DATE)
      RETURN NUMBER;

   FUNCTION get_transaction_header_id_in (p_asset_id   IN NUMBER,
                                          p_eff_date      DATE)
      RETURN NUMBER;

   FUNCTION getitemprodline (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getitemprodtype (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION getcontractandboafromproject (x_project IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_fiscal_period_info (p_date          IN VARCHAR2,
                                    p_return_item   IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_project_task_expenditures (p_project_number     IN VARCHAR2,
                                           p_task_number        IN VARCHAR2,
                                           p_period_name        IN VARCHAR2,
                                           p_expenditure_type   IN VARCHAR2)
      RETURN NUMBER; 
      
   FUNCTION get_project_task_activity (p_project_number   IN VARCHAR2,
                                       p_task_number      IN VARCHAR2,
                                       p_line_type        IN VARCHAR2,
                                       p_from_date        IN DATE,
                                       p_to_date          IN DATE)
      RETURN VARCHAR2;
      
   FUNCTION get_item_ams_category (p_item_number        IN VARCHAR2,
                                   p_organization_code  IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION cf_projectformula (p_rcv_transaction_id IN NUMBER) RETURN VARCHAR2;

   FUNCTION get_intangible_type (p_inventory_item_id   IN NUMBER,
                                 p_org_id              IN NUMBER,
                                 p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_task_expenditures_by_date ( p_project_number         IN VARCHAR2,
                                            p_task_number            IN VARCHAR2,
                                            p_period_start_date      IN DATE,
                                            p_period_end_date        IN DATE,
                                            p_expenditure_type1      IN VARCHAR2,
                                            p_expenditure_type2      IN VARCHAR2,
                                            p_expenditure_type3      IN VARCHAR2,
                                            p_expenditure_type4      IN VARCHAR2,
                                            p_expenditure_type5      IN VARCHAR2
                                          )
      RETURN VARCHAR2;

    FUNCTION get_project_category_info(p_proj_num    in varchar2, p_return_item in varchar2) RETURN VARCHAR2;

    FUNCTION get_purchasing_category_info(p_item_num in varchar2,p_org_code in varchar2)
                                                    RETURN VARCHAR2;

    FUNCTION cf_projectformula2 (p_line_location_id IN NUMBER) RETURN VARCHAR2; 

FUNCTION get_cost_group_item_cost (p_item_id in NUMBER, P_project_id in NUMBER, p_org_id IN NUMBER)
      RETURN NUMBER;

  FUNCTION get_cost_group_from_proj (P_project_id in NUMBER, p_org_id IN NUMBER)
      RETURN VARCHAR2;

FUNCTION get_shipped_qty_from_okd (P_deliverable_id in NUMBER)
      RETURN NUMBER;

FUNCTION get_cancelled_qty_from_okd (P_deliverable_id in NUMBER)
      RETURN NUMBER;  
  
Function GetItemLeadTime(pOrgID in number, pItemID in number) return number;

Function Total_Blanket_Release_Amount(p_po_header_id in number) return number;

function get_max_seq_num_w_qty(p_wip_entity_id In number) return number;

function get_max_seq_num_w_qty_desc(p_wip_entity_id In number) return varchar2;

Function job_final_qa_last_moved_date(p_wip_entity_id in number) return DATE;

FUNCTION serial_time_in_location (p_serial_number IN varchar2, p_transaction_id IN NUMBER, p_inventory_item_id IN NUMBER) 
      RETURN VARCHAR2;

FUNCTION any_to_number(n Varchar2) RETURN Number;


function Get_DRO_OPEN_Time(p_repair_line_id in number) return Number;

function Get_DRO_HOLD_Time(p_repair_line_id in number) return Number;

function Get_DRO_REPAIR_Time(p_repair_line_id in number) return Number;

FUNCTION get_serials_wip_step (p_wip_entity_id in number, p_opseq_num VARCHAR2, p_operation_step_type in number) RETURN VARCHAR2;

FUNCTION get_serials_wip_completed (p_wip_entity_id in number) RETURN VARCHAR2;

function job_repair_loe(p_wip_entity_id In number) return varchar2; 

function serial_num_ship_date(p_wip_entity_id In number, p_released_date in date) return date; 

FUNCTION last_3_notes (p_repair_number VARCHAR2) RETURN VARCHAR2;

function get_nmr_values ( pRMA_Header_id in number,pNmr_Rma_Line_No in number, pNMR_SN in varchar2,pTYPE in varchar2) return varchar2;

FUNCTION treasury_account_symbol (p_project_id IN NUMBER) RETURN VARCHAR2; 

FUNCTION last_receipt_date (p_line_location_id IN NUMBER) RETURN DATE;

FUNCTION Additional_Flowdowns (p_project_id IN NUMBER)   RETURN VARCHAR2;

FUNCTION Government_Trasnparency_Clause (p_project_id IN NUMBER) RETURN VARCHAR2;

FUNCTION NAICS_Code (p_project_id IN NUMBER) RETURN VARCHAR2;

FUNCTION om_hold_exists (p_header_id IN NUMBER, p_line_id IN NUMBER) return varchar2;

FUNCTION get_times_returned_info (p_customer_product_id IN NUMBER)
   RETURN NUMBER;

FUNCTION get_avg_addl_funds_info (p_header_id  IN   NUMBER,
                                  p_project_id  IN  NUMBER,
                                  p_task_id  IN     NUMBER)
   RETURN NUMBER;

FUNCTION get_mrp_req_details (p_line_id IN NUMBER, p_column_code IN VARCHAR2) return varchar2;

FUNCTION get_assembly_revision_info (
   p_top_assembly_item_id           IN NUMBER,
   p_top_assembly_organization_id   IN NUMBER,
   p_assembly_revision              IN VARCHAR2)
   RETURN CHAR;

FUNCTION get_planning_group_qty (p_item_id  IN NUMBER, p_org_id in NUMBER, p_plan_group in VARCHAR2) RETURN NUMBER;

FUNCTION get_serials_wip_associated (p_wip_entity_id in number, p_item_id in number) RETURN VARCHAR2;

FUNCTION get_first_lot_txn_type (p_lot_number IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2;

FUNCTION get_first_lot_txn_source (p_lot_number IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2; 

FUNCTION get_viasat_business_work_days (p_start_date IN DATE, p_end_date IN DATE) RETURN NUMBER;

FUNCTION item_first_purch_date (p_item_id IN NUMBER) RETURN DATE; -- 992

FUNCTION get_serials_op_seq (p_wip_entity_id in number, p_opseq_num VARCHAR2) RETURN VARCHAR2; -- 1010

FUNCTION get_first_serial_txn_type (p_serial IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2; -- 1009

FUNCTION get_first_serial_txn_source (p_serial IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2; -- 1009

FUNCTION get_employee_education (p_emp_number IN VARCHAR2) RETURN VARCHAR2;

FUNCTION getitemcategorydesc (p_inventory_item_id   IN NUMBER,
                             p_org_id              IN NUMBER,
                             p_mfg_lookup_code     IN VARCHAR2) RETURN VARCHAR2;

FUNCTION get_orig_promised_date (p_line_location_id IN NUMBER) RETURN VARCHAR2;

FUNCTION get_prev_promised_date (p_line_location_id IN NUMBER, p_current_rev_num IN NUMBER) RETURN VARCHAR2;

FUNCTION get_user_id (p_user_name IN VARCHAR) RETURN NUMBER;

FUNCTION long_to_char (p_media_id IN NUMBER)   RETURN VARCHAR;

FUNCTION note_length (p_media_id IN NUMBER)   RETURN NUMBER;

END noetix_vsat_utility_pkg;
/

CREATE OR REPLACE PACKAGE BODY noetix_vsat_utility_pkg
IS
   -- +=========================================================================+
   -- | Name        :  get_advance_replacement                                  |
   -- |                                                                         |
   -- | Description :  This function is used to check advance_replacement       |
   -- |                                                                         |
   -- +=========================================================================+

   -- Test Comment

   FUNCTION get_advance_replacement (p_inventory_item_id   IN NUMBER,
                                     p_header_id           IN NUMBER)
      RETURN VARCHAR2
   IS
      v_inv_item_id   NUMBER;
      v_adv_repl      VARCHAR2 (1) := 'N';
   BEGIN
      SELECT 'Y'
        INTO v_adv_repl
        FROM ont.oe_order_lines_all
       WHERE flow_status_code = 'CLOSED' AND line_category_code = 'ORDER'
             AND (inventory_item_id = p_inventory_item_id
                  OR (inventory_item_id IN (164586, 98259, 136779)
                      AND p_inventory_item_id IN (164586, 98259, 136779)))
             AND header_id = p_header_id;

      RETURN v_adv_repl;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
      WHEN OTHERS
      THEN
         RETURN 'N';
   END;



   -- +=========================================================================+
   -- | Name        :  InventoryCategoryExists                                  |
   -- |                                                                         |
   -- | Description :  This function is used to check if inventory category     |
   -- |            exists                                                       |
   -- +=========================================================================+
   FUNCTION inventorycategoryexists (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2
   IS
      x_category_exists   VARCHAR2 (1);
   BEGIN
      IF pitemid IS NOT NULL
      THEN
         BEGIN
            SELECT 'Y'
              INTO x_category_exists
              FROM inv.mtl_item_categories mic,
                   inv.mtl_categories_tl mct,
                   apps.mtl_categories_b_kfv mc,
                   applsys.fnd_id_flex_structures_tl t,
                   applsys.fnd_id_flex_structures b
             WHERE     mic.category_id = mct.category_id
                   AND t.id_flex_structure_name = 'Inventory Category'
                   AND mc.category_id = mct.category_id
                   AND mct.language = USERENV ('LANG')
                   AND b.application_id = t.application_id
                   AND b.id_flex_code = t.id_flex_code
                   AND b.id_flex_num = t.id_flex_num
                   AND t.language = USERENV ('LANG')
                   AND mc.structure_id = b.id_flex_num
                   AND b.application_id = 401
                   AND b.id_flex_code = 'MCAT'
                   AND organization_id = porgid
                   AND inventory_item_id = pitemid;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               x_category_exists := 'N';
         END;
      ELSE
         x_category_exists := 'N';
      END IF;

      RETURN x_category_exists;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN ('Error in noetix_vsat_utility_pkg.InventoryCategoryExists for org/item: '
                 || porgid
                 || '/'
                 || pitemid);
   END;

   -- +=========================================================================+
   -- | Name        :  gettxncustomername                                       |
   -- |                                                                         |
   -- | Description :  get customer same from transaction                       |                     
   -- +=========================================================================+

   FUNCTION gettxncustomername (p_transaction_id          IN NUMBER,
                                p_transaction_source_id   IN NUMBER,
                                p_serial_number           IN VARCHAR2,
                                p_trans_source_type       IN VARCHAR2)
      RETURN VARCHAR2
   IS
      r_name           VARCHAR2 (360);
      ln_txn_id        NUMBER DEFAULT 0;
      lc_source_code   VARCHAR2 (30) DEFAULT NULL;
      ln_project_id    NUMBER DEFAULT NULL;
   BEGIN
      --dbms_output.put_line('inside gettxncustomer');
      IF p_trans_source_type IN ('PROJECT CONTRACT', 'PURCHASE ORDER')
      THEN
         ln_txn_id := p_transaction_source_id;
      ELSIF p_trans_source_type IN ('RMA', 'SALES ORDER', 'INTERNAL ORDER')
      THEN                                       --Modified for the SR#1013922
         -- dbms_output.put_line('sales order type');
         BEGIN
            SELECT mmt.transaction_id, mmt.source_code, mmt.project_id
              INTO ln_txn_id, lc_source_code, ln_project_id
              FROM inv.mtl_material_transactions mmt
             WHERE mmt.transaction_id = p_transaction_id;
         --dbms_output.put_line('ln_txn_id: '||ln_txn_id);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               BEGIN
                  SELECT mmt.transaction_id, mmt.source_code, mmt.project_id
                    INTO ln_txn_id, lc_source_code, ln_project_id
                    FROM inv.mtl_unit_transactions mut,
                         inv.mtl_transaction_lot_numbers mtln,
                         inv.mtl_material_transactions mmt
                   WHERE     mut.transaction_id = p_transaction_id
                         AND mut.serial_number = p_serial_number
                         AND mut.organization_id = mtln.organization_id
                         AND mut.transaction_date = mtln.transaction_date
                         AND mut.transaction_id = mtln.serial_transaction_id
                         AND mtln.transaction_id = mmt.transaction_id
                         AND mtln.organization_id = mmt.organization_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     RETURN '';
               END;
            WHEN OTHERS
            THEN
               RETURN '';
         END;
      ELSE
         DBMS_OUTPUT.put_line ('else');
         RETURN '';
      END IF;

      IF p_trans_source_type IN ('SALES ORDER', 'INTERNAL ORDER')
      THEN
         SELECT SUBSTR (hp.party_name, 1, 360) party_name
           INTO r_name
           FROM inv.mtl_material_transactions mmt,
                wsh.wsh_delivery_details wdd,
                ar.hz_cust_accounts hca,
                ar.hz_parties hp
          WHERE mmt.transaction_id = ln_txn_id
                AND mmt.trx_source_line_id = wdd.source_line_id
                AND NVL (mmt.picking_line_id,
                         NVL (wdd.delivery_detail_id, 0)) =
                       NVL (wdd.delivery_detail_id, 0)
                AND NVL (mmt.project_id, NVL (wdd.project_id, 0)) =
                       NVL (wdd.project_id, 0)
                AND wdd.source_code = 'OE'
                AND wdd.customer_id = hca.cust_account_id
                AND hca.party_id = hp.party_id;
      ELSIF p_trans_source_type = 'PROJECT CONTRACT'
      THEN
         SELECT SUBSTR (party.party_name, 1, 360) customer_name
           INTO r_name
           FROM oke.oke_k_headers okh,
                pa.pa_project_customers opc,
                ar.hz_cust_accounts cacct,
                ar.hz_parties party
          WHERE     okh.k_header_id = ln_txn_id
                AND cacct.cust_account_id = opc.customer_id
                AND party.party_id = cacct.party_id
                AND okh.project_id = opc.project_id
                AND ROWNUM = 1;
      ELSIF p_trans_source_type = 'RMA'
      THEN
         SELECT DECODE (rt.vendor_id,
                        NULL, SUBSTR (hp.party_name, 1, 360),
                        SUBSTR (phv.vendor_name, 1, 360))
           INTO r_name
           FROM inv.mtl_material_transactions mmt,
                po.rcv_transactions rt,
                ar.hz_cust_accounts hca,
                ar.hz_parties hp,
                ap.ap_suppliers phv                      --apps.po_vendors phv
          WHERE     mmt.transaction_id = ln_txn_id
                AND mmt.source_code = 'RCV'
                AND mmt.source_line_id = rt.transaction_id
                AND mmt.source_code = rt.interface_source_code
                AND rt.customer_id = hca.cust_account_id(+)
                AND hca.party_id = hp.party_id(+)
                AND rt.vendor_id = phv.vendor_id(+);
      ELSIF p_trans_source_type = 'PURCHASE ORDER'
      THEN
         SELECT SUBSTR (pv.vendor_name, 1, 360)
           INTO r_name
           FROM po.po_headers_all ph, ap.ap_suppliers pv
          WHERE ph.po_header_id = ln_txn_id AND ph.vendor_id = pv.vendor_id;
      ELSE
         RETURN '';
      END IF;

      RETURN r_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '';
   END gettxncustomername;

   -- +=========================================================================+
   -- | Name        :  get_meaning                                              |
   -- |                                                                         |
   -- | Description :  This function is used to get the meaning for the various |
   -- |                UPS form lookup codes                                |                                   |
   -- +=========================================================================+
   FUNCTION get_meaning (p_lookup_code IN VARCHAR2, p_tag IN VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR csr_get_meaning
      IS
         SELECT meaning
           FROM applsys.fnd_lookup_values
          WHERE lookup_type = 'VSAT_UPS_FORM_CODES'
                AND SYSDATE BETWEEN NVL (start_date_active, SYSDATE - 1)
                                AND NVL (end_date_active, SYSDATE + 1)
                AND enabled_flag = 'Y'
                AND tag = p_tag
                AND lookup_code = p_lookup_code
                AND language = USERENV ('LANG');

      v_meaning   VARCHAR2 (100);
   BEGIN
      OPEN csr_get_meaning;

      FETCH csr_get_meaning INTO v_meaning;

      CLOSE csr_get_meaning;

      RETURN (v_meaning);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (NULL);
   END get_meaning;

   -- +=========================================================================+
   -- | Name        :  get_file_name                                            |
   -- |                                                                         |
   -- | Description :  This function is used to get filename for a  file id     |
   -- +=========================================================================+
   FUNCTION GET_FILE_NAME (p_file_id IN NUMBER, p_type IN VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR csr_get_file_name
      IS
         SELECT filename
           FROM vscon.vsat_revlog_system_file_status
          WHERE file_id = p_file_id AND NVL (TYPE, p_type) = p_type; --Added NVL condition for SR 1872

      v_file_name   VARCHAR2 (150);
   BEGIN
      OPEN csr_get_file_name;

      FETCH csr_get_file_name INTO v_file_name;

      CLOSE csr_get_file_name;

      RETURN (v_file_name);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (NULL);
   END GET_FILE_NAME;

   -- +=========================================================================+
   -- | Name        :  get_username                                             |
   -- |                                                                         |
   -- | Description :  This function is used to get username for a  user id     |
   -- +=========================================================================+

   FUNCTION get_username (p_user_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR csr_get_user_name
      IS
         SELECT user_name
           FROM applsys.fnd_user
          WHERE user_id = p_user_id;

      v_user_name   VARCHAR2 (150);
   BEGIN
      OPEN csr_get_user_name;

      FETCH csr_get_user_name INTO v_user_name;

      CLOSE csr_get_user_name;

      RETURN (v_user_name);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (NULL);
   END get_username;

   -- +=========================================================================+
   -- | Name        :  get_business_days                                        |
   -- |                                                                         |
   -- | Description :  This function is used to get working days beetween given |
   -- |            dates i.e. All days except saturday and sunday               |
   -- +=========================================================================+
   FUNCTION get_business_work_days (p_start_date IN DATE, p_end_date IN DATE)
      RETURN NUMBER
   IS
      v_curr_date      DATE := p_start_date;
      v_day            VARCHAR2 (10);
      v_business_cnt   NUMBER := 0;
   BEGIN
      IF p_end_date IS NULL OR p_start_date IS NULL
      THEN
         RETURN 0;
      END IF;

      IF p_end_date - p_start_date <= 0
      THEN
         RETURN 0;
      END IF;

      LOOP
         v_curr_date := TO_DATE (v_curr_date + 1);

         EXIT WHEN v_curr_date = p_end_date;

         SELECT TO_CHAR (v_curr_date, 'fmDay') INTO v_day FROM DUAL;

         IF v_day <> 'Saturday' AND v_day <> 'Sunday'
         THEN
            v_business_cnt := v_business_cnt + 1;
         END IF;
      END LOOP;

      RETURN v_business_cnt;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END;


   FUNCTION getitemcategory (p_inventory_item_id   IN NUMBER,
                             p_org_id              IN NUMBER,
                             p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_cat_name   VARCHAR2 (200);
   BEGIN
      SELECT mcat1.cv$item_category_kff
        INTO v_cat_name
        FROM inv.mtl_item_categories itcat,
             inv.mtl_categories_b cat,
             inv.mtl_default_category_sets dcat,
             n_mfg_lookups_vl mlok1,
             xxk_mtl_cat mcat1
       WHERE     cat.category_id = itcat.category_id
             AND dcat.category_set_id = itcat.category_set_id
             AND mlok1.lookup_code = p_mfg_lookup_code
             AND mlok1.lookup_type = 'MTL_FUNCTIONAL_AREAS'
             AND mlok1.lookup_code = dcat.functional_area_id
             AND mlok1.security_group_id =
                    noetix_apps_security_pkg.lookup_security_group (
                       mlok1.lookup_type,
                       mlok1.view_application_id)
             AND cat.category_id = mcat1.category_id
             AND itcat.organization_id = p_org_id
             AND itcat.inventory_item_id = p_inventory_item_id;

      RETURN v_cat_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   ------------------------------------------------
   FUNCTION getinvclass (p_inventory_item_id   IN NUMBER,
                         p_org_id              IN NUMBER,
                         p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_inv_class   VARCHAR2 (200);
   BEGIN
      SELECT mcat1.sv$inventory_class
        INTO v_inv_class
        FROM inv.mtl_item_categories itcat,
             inv.mtl_categories_b cat,
             inv.mtl_default_category_sets dcat,
             n_mfg_lookups_vl mlok1,
             xxk_mtl_cat mcat1
       WHERE     cat.category_id = itcat.category_id
             AND dcat.category_set_id = itcat.category_set_id
             AND mlok1.lookup_code = p_mfg_lookup_code
             AND mlok1.lookup_type = 'MTL_FUNCTIONAL_AREAS'
             AND mlok1.lookup_code = dcat.functional_area_id
             AND mlok1.security_group_id =
                    noetix_apps_security_pkg.lookup_security_group (
                       mlok1.lookup_type,
                       mlok1.view_application_id)
             AND cat.category_id = mcat1.category_id
             AND itcat.organization_id = p_org_id
             AND itcat.inventory_item_id = p_inventory_item_id;

      RETURN v_inv_class;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   ------------------------------------------------
   FUNCTION getproductline (p_inventory_item_id   IN NUMBER,
                            p_org_id              IN NUMBER,
                            p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_prod_line   VARCHAR2 (200);
   BEGIN
      SELECT mcat1.sv$product_line
        INTO v_prod_line
        FROM inv.mtl_item_categories itcat,
             inv.mtl_categories_b cat,
             inv.mtl_default_category_sets dcat,
             n_mfg_lookups_vl mlok1,
             xxk_mtl_cat mcat1
       WHERE     cat.category_id = itcat.category_id
             AND dcat.category_set_id = itcat.category_set_id
             AND mlok1.lookup_code = p_mfg_lookup_code
             AND mlok1.lookup_type = 'MTL_FUNCTIONAL_AREAS'
             AND mlok1.lookup_code = dcat.functional_area_id
             AND mlok1.security_group_id =
                    noetix_apps_security_pkg.lookup_security_group (
                       mlok1.lookup_type,
                       mlok1.view_application_id)
             AND cat.category_id = mcat1.category_id
             AND itcat.organization_id = p_org_id
             AND itcat.inventory_item_id = p_inventory_item_id;

      RETURN v_prod_line;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   ------------------------------------------------
   FUNCTION getproducttype (p_inventory_item_id   IN NUMBER,
                            p_org_id              IN NUMBER,
                            p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_prod_type   VARCHAR2 (200);
   BEGIN
      SELECT mcat1.sv$product_type
        INTO v_prod_type
        FROM inv.mtl_item_categories itcat,
             inv.mtl_categories_b cat,
             inv.mtl_default_category_sets dcat,
             n_mfg_lookups_vl mlok1,
             xxk_mtl_cat mcat1
       WHERE     cat.category_id = itcat.category_id
             AND dcat.category_set_id = itcat.category_set_id
             AND mlok1.lookup_code = p_mfg_lookup_code
             AND mlok1.lookup_type = 'MTL_FUNCTIONAL_AREAS'
             AND mlok1.lookup_code = dcat.functional_area_id
             AND mlok1.security_group_id =
                    noetix_apps_security_pkg.lookup_security_group (
                       mlok1.lookup_type,
                       mlok1.view_application_id)
             AND cat.category_id = mcat1.category_id
             AND itcat.organization_id = p_org_id
             AND itcat.inventory_item_id = p_inventory_item_id;

      RETURN v_prod_type;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;



   FUNCTION gettranssource (p_trans_source_type   IN VARCHAR2,
                            p_trans_source_id     IN NUMBER)
      RETURN VARCHAR2
   IS
      v_source_name   VARCHAR2 (100);
   BEGIN
      BEGIN
         apps.fnd_client_info.set_org_context ('47');
      END;

      IF p_trans_source_type = 'PURCHASE ORDER'
      THEN
         SELECT segment1
           INTO v_source_name
           FROM po.po_headers_all
          WHERE po_header_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'SALES ORDER'
      THEN
         SELECT segment1 || '.' || segment2 || '.' || segment3
           INTO v_source_name
           FROM inv.mtl_sales_orders
          WHERE sales_order_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'JOB OR SCHEDULE'
      THEN
         SELECT wip_entity_name
           INTO v_source_name
           FROM wip.wip_entities
          WHERE wip_entity_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'PROJECT CONTRACT'
      THEN
         SELECT k_number_disp
           INTO v_source_name
           FROM oke.oke_k_headers
          WHERE k_header_id = p_trans_source_id;
      ELSE
         NULL;
      END IF;

      RETURN v_source_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION get_manufacturer_name (p_inventory_item_id   IN NUMBER,
                                   p_organization_id     IN NUMBER)
      RETURN VARCHAR2
   IS
      v_manu_name   VARCHAR2 (200);
   BEGIN
      SELECT DISTINCT mfg.manufacturer_name
        INTO v_manu_name
        FROM inv.mtl_mfg_part_numbers mfgpt, inv.mtl_manufacturers mfg
       WHERE     mfgpt.manufacturer_id = mfg.manufacturer_id
             AND mfgpt.attribute2 = 'Active'
             AND mfgpt.inventory_item_id = p_inventory_item_id
             AND mfgpt.organization_id = p_organization_id;

      RETURN v_manu_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION get_manufact_part_num (p_inventory_item_id   IN NUMBER,
                                   p_organization_id     IN NUMBER)
      RETURN VARCHAR2
   IS
      v_manu_part_num   VARCHAR2 (200);
   BEGIN
      SELECT DISTINCT (mfgpt.mfg_part_num)
        INTO v_manu_part_num
        FROM inv.mtl_mfg_part_numbers mfgpt, inv.mtl_manufacturers mfg
       WHERE     mfgpt.manufacturer_id = mfg.manufacturer_id
             AND mfgpt.attribute2 = 'Active'
             AND mfgpt.inventory_item_id = p_inventory_item_id
             AND mfgpt.organization_id = p_organization_id;

      RETURN v_manu_part_num;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;


   FUNCTION gettranssourceall (p_trans_source_type   IN VARCHAR2,
                               p_trans_source_id     IN NUMBER,
                               p_organization_id     IN NUMBER)
      RETURN VARCHAR2
   IS
      v_source_name   VARCHAR2 (100);
      row_count       NUMBER := 0;
   BEGIN
      BEGIN
         apps.fnd_client_info.set_org_context ('47');
      END;

      IF p_trans_source_type = 'PURCHASE ORDER'
      THEN
         SELECT segment1
           INTO v_source_name
           FROM po.po_headers_all
          WHERE po_header_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'SALES ORDER'
      THEN
         SELECT segment1 || '.' || segment2 || '.' || segment3
           INTO v_source_name
           FROM inv.mtl_sales_orders
          WHERE sales_order_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'JOB OR SCHEDULE'
      THEN
         SELECT wip_entity_name
           INTO v_source_name
           FROM wip.wip_entities
          WHERE wip_entity_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'PROJECT CONTRACT'
      THEN
         SELECT k_number_disp
           INTO v_source_name
           FROM oke.oke_k_headers
          WHERE k_header_id = p_trans_source_id;
      ELSIF (p_trans_source_type = 'RMA'
             OR p_trans_source_type = 'INTERNAL ORDER')
      THEN
         SELECT SUBSTR (concatenated_segments, 1, 30)
           INTO v_source_name
           FROM apps.mtl_sales_orders_kfv
          WHERE sales_order_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'MOVE ORDER'
      THEN
         SELECT request_number
           INTO v_source_name
           FROM inv.mtl_txn_request_headers
          WHERE header_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'ACCOUNT ALIAS'
      THEN
         SELECT SUBSTR (concatenated_segments, 1, 30)
           INTO v_source_name
           FROM apps.mtl_generic_dispositions_kfv
          WHERE disposition_id = p_trans_source_id
                AND organization_id = p_organization_id;
      ELSIF p_trans_source_type = 'INTERNAL REQUISITION'
      THEN
         SELECT segment1
           INTO v_source_name
           FROM po.po_requisition_headers_all
          WHERE requisition_header_id = p_trans_source_id;
      ELSIF p_trans_source_type = 'CYCLE COUNT'
      THEN
         SELECT cycle_count_header_name
           INTO v_source_name
           FROM inv.mtl_cycle_count_headers
          WHERE cycle_count_header_id = p_trans_source_id
                AND organization_id = p_organization_id;
      ELSIF p_trans_source_type = 'PHYSICAL INVENTORY'
      THEN
         SELECT physical_inventory_name
           INTO v_source_name
           FROM inv.mtl_physical_inventories
          WHERE physical_inventory_id = p_trans_source_id
                AND organization_id = p_organization_id;
      ELSIF p_trans_source_type = 'STANDARD COST UPDATE'
      THEN
         SELECT description
           INTO v_source_name
           FROM bom.cst_cost_updates
          WHERE cost_update_id = p_trans_source_id
                AND organization_id = p_organization_id;
      ELSIF p_trans_source_type = 'INVENTORY'
      THEN
         SELECT COUNT (*)
           INTO row_count
           FROM inv.mtl_txn_request_lines mol
          WHERE txn_source_id = p_trans_source_id
                AND organization_id = p_organization_id
                AND EXISTS
                       (SELECT NULL
                          FROM inv.mtl_txn_request_headers
                         WHERE     header_id = mol.header_id
                               AND move_order_type = 5
                               AND mol.transaction_source_type_id = 13);

         IF row_count > 0
         THEN
            SELECT wip_entity_name
              INTO v_source_name
              FROM wip.wip_entities
             WHERE wip_entity_id = p_trans_source_id
                   AND organization_id = p_organization_id;
         END IF;
      ELSE
         NULL;
      END IF;

      RETURN v_source_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;


   FUNCTION rma_number (x_id NUMBER)
      RETURN NUMBER
   IS
      --
      -- Return rma_number given a sales order ID.
      -- Same comments as above.
      -- bso Sun Jul 25 12:48:25 PDT 1999
      --
      -- changed to query from oe_order_headers view in case interop_v
      -- is not supported.
      -- bso Fri Mar  3 15:56:03 PST 2000

      -- Changed the from clause in the below cursor from the view
      -- oe_order_headers to the base table oe_order_headers_all to
      -- enable RMA number collection element to honour all Operating
      -- Units. Refer bug for more details.
      -- Bug 3430888. suramasw

      x_sales_order   NUMBER := NULL;

      CURSOR c
      IS
         SELECT order_number
           FROM ont.oe_order_headers_all
          WHERE header_id = x_id;
   BEGIN
      IF x_id IS NULL
      THEN
         RETURN NULL;
      END IF;

      OPEN c;

      FETCH c INTO x_sales_order;

      CLOSE c;

      --
      -- x_sales_order will be null if not found.
      --
      RETURN x_sales_order;
   END rma_number;



      FUNCTION getfreightterm (pheaderid IN NUMBER, plineid IN NUMBER)
      RETURN VARCHAR2
   IS
      cursor cterms_from_line is 
         SELECT term_value
           FROM apps.oke_k_all_terms_v
          WHERE     term_code = 'OB_FREIGHT_TERMS'
                AND k_header_id = pheaderid
                AND k_line_id = plineid;
      cursor cterms_from_header is 
            SELECT term_value
              FROM apps.oke_k_all_terms_v
             WHERE     term_code = 'OB_FREIGHT_TERMS'
                   AND k_header_id = pheaderid
                   AND k_line_id IS NULL
                   AND end_date_active IS NULL;
      x_freightterms   VARCHAR2 (2000) := '';
   BEGIN
      BEGIN
            open cterms_from_line;
            fetch cterms_from_line into x_freightterms;
            close cterms_from_line;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN 'Loop 1 - getfreightterm: Error getting Freight Terms from line : '||
                            SQLCODE||' - '||SQLERRM()||' - '|| pheaderid||' - '|| plineid;
      END;

      IF x_freightterms IS NULL
      THEN
         BEGIN
            open cterms_from_header;
            fetch cterms_from_header into x_freightterms;
            if cterms_from_header%NOTFOUND then
                x_freightterms := 'Cannot determine freight term at header or line for '|| pheaderid||' - '|| plineid;
            end if;
            close cterms_from_header;
        EXCEPTION
            WHEN OTHERS    THEN
                RETURN 'Loop 1 - getfreightterm: Error getting Freight Terms from Header : '||
                            SQLCODE||' - '||SQLERRM()||' - '|| pheaderid;
         END;
      END IF;

      RETURN  x_freightterms;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Main - getfreightterm Others excepption: '||SQLCODE||'-'||SQLERRM||
                    ' Error getting Freight Terms for: '
                 || pheaderid
                 || ', '
                 || plineid);
   END;

   FUNCTION get_org_code (p_org_id IN NUMBER)
      RETURN VARCHAR2
   IS
      v_org_code   VARCHAR2 (3);
   BEGIN
      SELECT organization_code
        INTO v_org_code
        FROM inv.mtl_parameters
       WHERE organization_id = p_org_id;

      RETURN v_org_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN ('');
      WHEN OTHERS
      THEN
         RETURN (   'GET_ORG_CODE error getting Code for '
                 || p_org_id
                 || ' '
                 || SUBSTR (SQLERRM (), 1, 55));
   END;


   FUNCTION get_employee_full_name (p_person_id        IN NUMBER,
                                    p_effective_date   IN DATE)
      RETURN VARCHAR2
   IS
      v_person_name   VARCHAR2 (240);
   BEGIN
      SELECT full_name
        INTO v_person_name
        FROM hr.per_all_people_f
       WHERE person_id = p_person_id
             AND NVL (p_effective_date, SYSDATE) BETWEEN effective_start_date
                                                     AND NVL (
                                                            effective_end_date,
                                                            SYSDATE + 1)
             AND ROWNUM = 1;                          --to be on the safe side

      RETURN v_person_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN ('');
      WHEN OTHERS
      THEN
         RETURN ('VSAT_HR_UTILS.Get_Employee_Full_Name error getting name for '
                 || p_person_id
                 || ' '
                 || SUBSTR (SQLERRM (), 1, 55));
   END;


   FUNCTION get_medical_code (p_pl_id               IN NUMBER,
                              p_date_earned         IN DATE,
                              p_assignment_id       IN NUMBER,
                              p_prtt_enrt_rslt_id   IN NUMBER)
      RETURN VARCHAR2
   IS
      l_person_id        NUMBER;
      l_plan_name        VARCHAR2 (250);
      l_address_state    VARCHAR2 (15);
      l_output           VARCHAR2 (15);
      --l_people_group_id NUMBER;
      l_people_group     VARCHAR2 (15);
      l_exception_flag   VARCHAR2 (15);

      CURSOR c_get_emp_state
      IS
         SELECT paf.person_id,
                region_2 address_state,
                b.segment1,
                'N' exception_flag
           FROM hr.per_all_assignments_f paf,
                hr.per_addresses ad,
                hr.pay_people_groups b,
                applsys.fnd_id_flex_structures c
          WHERE paf.assignment_id = p_assignment_id
                AND TRUNC (p_date_earned) BETWEEN paf.effective_start_date
                                              AND paf.effective_end_date
                AND ad.date_to IS NULL
                AND ad.primary_flag = 'Y'
                AND c.id_flex_num = b.id_flex_num
                AND c.id_flex_code = 'GRP'
                AND paf.people_group_id = b.people_group_id
                AND b.enabled_flag = 'Y'
                AND paf.primary_flag = 'Y'
                AND paf.assignment_type IN ('C', 'E')
                AND paf.person_id = ad.person_id(+)
                AND paf.person_id NOT IN
                       (SELECT TO_NUMBER (lookup_code)
                          FROM hr_lookups
                         WHERE     lookup_type = 'VSAT_BEN_WB_EMP_EXCEPTION'
                               AND enabled_flag = 'Y'
                               AND end_date_active IS NULL)
         UNION
         SELECT paf.person_id,
                region_2 address_state,
                b.segment1,
                'Y' exception_flag
           FROM hr.per_all_assignments_f paf,
                hr.per_addresses ad,
                hr.pay_people_groups b,
                applsys.fnd_id_flex_structures c
          WHERE paf.assignment_id = p_assignment_id
                AND TRUNC (p_date_earned) BETWEEN paf.effective_start_date
                                              AND paf.effective_end_date
                AND ad.date_to IS NULL
                AND ad.primary_flag = 'Y'
                AND c.id_flex_num = b.id_flex_num
                AND c.id_flex_code = 'GRP'
                AND paf.people_group_id = b.people_group_id
                AND paf.primary_flag = 'Y'
                AND paf.assignment_type IN ('C', 'E')
                AND b.enabled_flag = 'Y'
                AND paf.person_id = ad.person_id(+)
                AND paf.person_id IN
                       (SELECT TO_NUMBER (lookup_code)
                          FROM hr_lookups
                         WHERE     lookup_type = 'VSAT_BEN_WB_EMP_EXCEPTION'
                               AND enabled_flag = 'Y'
                               AND end_date_active IS NULL);



      CURSOR c_get_emp_medical
      IS
         SELECT pl.name plan_name
           FROM ben.ben_prtt_enrt_rslt_f p,
                ben.ben_opt_f o,
                ben.ben_pl_f pl,
                ben.ben_oipl_f op
          WHERE     p.prtt_enrt_rslt_stat_cd IS NULL
                AND p.prtt_enrt_rslt_id = p_prtt_enrt_rslt_id
                AND op.oipl_id = p.oipl_id
                AND o.opt_id = op.opt_id
                AND pl.pl_id = op.pl_id
                AND p.pl_id = p_pl_id
                AND TRUNC (p_date_earned) BETWEEN p.effective_start_date
                                              AND p.effective_end_date
                AND TRUNC (p_date_earned) BETWEEN o.effective_start_date
                                              AND o.effective_end_date
                AND TRUNC (p_date_earned) BETWEEN pl.effective_start_date
                                              AND pl.effective_end_date
                AND TRUNC (p_date_earned) BETWEEN op.effective_start_date
                                              AND op.effective_end_date;
   BEGIN
      --hr_utility.set_location('p_pl_id:'||p_pl_id, 1);
      --hr_utility.set_location('p_date_earned:'||p_date_earned, 2);
      --hr_utility.set_location('p_assignment_id:'||p_assignment_id, 3);
      --hr_utility.set_location('p_prtt_enrt_rslt_id:'||p_prtt_enrt_rslt_id , 4);

      OPEN c_get_emp_state;

      FETCH c_get_emp_state
      INTO l_person_id, l_address_state, l_people_group, l_exception_flag;

      CLOSE c_get_emp_state;

      IF l_exception_flag = 'Y'
      THEN
         IF l_address_state IS NULL
         THEN
            l_output := 'A';
         ELSIF l_address_state IS NOT NULL
         THEN
            OPEN c_get_emp_medical;

            FETCH c_get_emp_medical INTO l_plan_name;

            CLOSE c_get_emp_medical;

            IF (l_plan_name = 'Healthcare Plan 1: PPO Bundle')
               AND (l_address_state = 'CA')
            THEN
               l_output := 'A';
            ELSIF (l_plan_name =
                      'Healthcare Plan 2: Consumer Directed (CDHP) Plan')
                  AND (l_address_state = 'CA')
            THEN
               l_output := 'E';
            ELSIF (l_plan_name = 'Healthcare Plan 1: PPO Bundle')
                  AND (l_address_state != 'CA')
            THEN
               l_output := 'C';
            ELSIF (l_plan_name =
                      'Healthcare Plan 2: Consumer Directed (CDHP) Plan')
                  AND (l_address_state != 'CA')
            THEN
               l_output := 'G';
            ELSE
               l_output := 'A';
            END IF;
         END IF;
      ELSIF l_exception_flag = 'N'
      THEN
         IF l_people_group = 'WB'
         THEN                                                       --WB Group
            OPEN c_get_emp_medical;

            FETCH c_get_emp_medical INTO l_plan_name;

            CLOSE c_get_emp_medical;

            IF (l_plan_name = 'Healthcare Plan 1: PPO Bundle')
            THEN
               l_output := 'J';
            ELSIF (l_plan_name =
                      'Healthcare Plan 2: Consumer Directed (CDHP) Plan')
            THEN
               l_output := 'N';
            ELSE
               l_output := 'J';
            END IF;
         ELSE
            IF l_address_state IS NULL
            THEN
               l_output := 'A';
            ELSIF l_address_state IS NOT NULL
            THEN
               OPEN c_get_emp_medical;

               FETCH c_get_emp_medical INTO l_plan_name;

               CLOSE c_get_emp_medical;

               IF (l_plan_name = 'Healthcare Plan 1: PPO Bundle')
                  AND (l_address_state = 'CA')
               THEN
                  l_output := 'A';
               ELSIF (l_plan_name =
                         'Healthcare Plan 2: Consumer Directed (CDHP) Plan')
                     AND (l_address_state = 'CA')
               THEN
                  l_output := 'E';
               ELSIF (l_plan_name = 'Healthcare Plan 1: PPO Bundle')
                     AND (l_address_state != 'CA')
               THEN
                  l_output := 'C';
               ELSIF (l_plan_name =
                         'Healthcare Plan 2: Consumer Directed (CDHP) Plan')
                     AND (l_address_state != 'CA')
               THEN
                  l_output := 'G';
               ELSE
                  l_output := 'A';
               END IF;
            END IF;
         END IF;
      END IF;

      RETURN l_output;
   END get_medical_code;


   FUNCTION get_user_person_type (p_person_id NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR csr_person_types (
         p_person_id NUMBER)
      IS
           SELECT ttl.user_person_type
             FROM per_person_types_tl ttl,
                  per_person_types typ,
                  per_person_type_usages_f ptu
            WHERE ttl.language = USERENV ('LANG')
                  AND ttl.person_type_id = typ.person_type_id
                  AND typ.system_person_type IN
                         ('APL',
                          'EMP',
                          'EX_APL',
                          'EX_EMP',
                          'CWK',
                          'EX_CWK',
                          'OTHER')
                  AND typ.person_type_id = ptu.person_type_id
                  AND TRUNC (SYSDATE) BETWEEN ptu.effective_start_date
                                          AND ptu.effective_end_date
                  AND ptu.person_id = p_person_id
         ORDER BY DECODE (typ.system_person_type,
                          'EMP', 1,
                          'CWK', 2,
                          'APL', 3,
                          'EX_EMP', 4,
                          'EX_CWK', 5,
                          'EX_APL', 6,
                          7);

      l_user_person_type   VARCHAR2 (2000);
      l_separator          VARCHAR2 (10);
   BEGIN
      l_separator := gc_user_person_type_separator;

      FOR l_person_type IN csr_person_types (p_person_id => p_person_id)
      LOOP
         IF (l_user_person_type IS NULL)
         THEN
            l_user_person_type := l_person_type.user_person_type;
         ELSE
            l_user_person_type :=
                  l_user_person_type
               || l_separator
               || l_person_type.user_person_type;
         END IF;
      END LOOP;

      RETURN l_user_person_type;
   END get_user_person_type;



   FUNCTION get_projects_list (p_resource_id     IN NUMBER,
                               p_resource_type   IN VARCHAR2,
                               p_period_name     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR c_projects
      IS
         SELECT pp.name
           FROM vscon.vsat_pst_project_resources ppr,
                vscon.vsat_pst_projects pp,
                vscon.vsat_pst_schedules ps
          WHERE (ppr.resource_id = p_resource_id
                 AND ppr.resource_type = p_resource_type)
                AND ppr.project_resource_id = ps.project_resource_id
                AND ps.period_name = p_period_name
                AND ppr.project_id = pp.project_id /* AND pp.line_of_business IN
                                                           (SELECT NVL (pa.line_of_business, pp.line_of_business)
                                                              FROM vscon.vsat_pst_access_v pa
                                                             WHERE pa.user_id = vscon.dsc_userid)
                                                    AND NVL (pp.business_area, 'NULL') IN
                                                           (SELECT NVL (pa.business_area,
                                                                   NVL (pp.business_area, 'NULL'))
                                                              FROM vscon.vsat_pst_access_v pa
                                                             WHERE pa.user_id = vscon.dsc_userid)*/
                                                  ;

      -- variable for projects list
      v_projects_list   VARCHAR2 (4000);
   BEGIN
      FOR c_project_rec IN c_projects
      LOOP
         v_projects_list := v_projects_list || ', ' || c_project_rec.name;
      END LOOP;

      IF v_projects_list IS NOT NULL
      THEN
         RETURN LTRIM (SUBSTR (v_projects_list, 2));
      ELSE
         RETURN v_projects_list;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_projects_list;

   FUNCTION get_instance_ship_date (p_instance_id IN NUMBER)
      RETURN DATE
   IS
      v_ship_date   DATE;
   BEGIN
      SELECT MAX (wnd.initial_pickup_date)
        INTO v_ship_date
        FROM (SELECT ciih.instance_id,
                     ciih.instance_history_id,
                     ct.source_header_ref_id,
                     ct.source_line_ref_id,
                     DECODE (ct.transaction_type_id,  51, 'OE',  326, 'OKE')
                        source_code,
                     MAX (ciih.instance_history_id)
                        OVER (PARTITION BY ciih.instance_id)
                        max_instance_history_id
                FROM csi.csi_item_instances_h ciih, csi.csi_transactions ct
               WHERE     1 = 1
                     AND ciih.transaction_id = ct.transaction_id
                     AND ct.transaction_type_id IN (51, 326)) ct_inner,
             wsh.wsh_delivery_details wdd,
             wsh.wsh_delivery_assignments wda,
             wsh.wsh_new_deliveries wnd
       WHERE ct_inner.instance_id = p_instance_id
             AND ct_inner.instance_history_id =
                    ct_inner.max_instance_history_id
             AND ct_inner.source_code = wdd.source_code
             AND ct_inner.source_header_ref_id = wdd.source_header_id
             AND ct_inner.source_line_ref_id = wdd.source_line_id
             AND wdd.delivery_detail_id = wda.delivery_detail_id
             AND wda.delivery_id = wnd.delivery_id;

      RETURN v_ship_date;
   END;

   FUNCTION get_ship_date (p_incident_id     IN NUMBER,
                           p_serial_number   IN VARCHAR2)
      RETURN DATE
   IS
      v_ship_date   DATE;
   BEGIN
      SELECT DISTINCT mut.transaction_date ship_date
        INTO v_ship_date
        FROM ont.oe_order_lines_all oel,
             inv.mtl_unit_transactions mut,
             inv.mtl_material_transactions mmt,
             cs.cs_estimate_details ced
       WHERE     ced.incident_id = p_incident_id
             AND ced.line_category_code = 'ORDER'
             AND ced.order_header_id = oel.header_id
             AND oel.line_category_code = 'ORDER'
             AND mut.transaction_id = mmt.transaction_id
             AND mmt.trx_source_line_id = oel.line_id
             AND mut.serial_number = p_serial_number;

      RETURN v_ship_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION get_business_area_4pgm (p_pgm IN VARCHAR2)
      RETURN VARCHAR2
   IS
      /*

            Created by Venky Bharathi Zensar Consultant  OCT-31-2014  Initial Version

     */
      l_description   qa.qa_char_value_lookups.description%TYPE := NULL;
   BEGIN
      BEGIN
         SELECT qcv.description
           INTO l_description
           FROM qa.qa_char_value_lookups qcv
          WHERE char_id = '860' AND short_code = p_pgm;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
         WHEN TOO_MANY_ROWS
         THEN
            SELECT description
              INTO l_description
              FROM qa.qa_char_value_lookups
             WHERE char_id = '860' AND short_code = p_pgm AND ROWNUM = 1;
         WHEN OTHERS
         THEN
            l_description := NULL;
      END;

      RETURN l_description;
   END;

   FUNCTION get_nmr_4qir (p_qir IN VARCHAR2)
      RETURN VARCHAR2
   IS
      /*

         Created by Venky Bharathi Zensar Consultant  OCT-31-2014  Initial Version
          This function will get the NMR for Given QIR if There is any relationship between QIR and NMR otherwise this

will

return null

         */

      l_nmr   qa.qa_results.sequence1%TYPE := NULL;
   BEGIN
      BEGIN
         SELECT sequence1
           INTO l_nmr
           FROM qa.qa_pc_results_relationship pcrr, qa.qa_results r
          WHERE     r.sequence2 = p_qir
                AND r.plan_id = pcrr.parent_plan_id
                AND r.collection_id = pcrr.parent_collection_id
                AND r.occurrence = pcrr.parent_occurrence;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_nmr := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            SELECT sequence1
              INTO l_nmr
              FROM qa.qa_pc_results_relationship pcrr, qa.qa_results r
             WHERE     r.sequence2 = p_qir
                   AND r.plan_id = pcrr.parent_plan_id
                   AND r.collection_id = pcrr.parent_collection_id
                   AND r.occurrence = pcrr.parent_occurrence
                   AND ROWNUM = 1;
         WHEN OTHERS
         THEN
            l_nmr := NULL;
      END;

      RETURN l_nmr;
   END;


   FUNCTION get_qa_name_4userid (p_user_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_qa_person_name   ar.hz_parties.party_name%TYPE := NULL;
   BEGIN
      BEGIN
         SELECT hp.person_first_name || ' ' || hp.person_last_name
           INTO l_qa_person_name
           FROM applsys.fnd_user fu,
                ar.hz_parties hp,
                ar.hz_parties hp1,
                ar.hz_relationships rel
          WHERE     rel.subject_table_name = 'HZ_PARTIES'
                AND rel.object_table_name = 'HZ_PARTIES'
                AND rel.directional_flag = 'F'
                AND hp.party_id = rel.subject_id
                AND rel.object_id = hp1.party_id
                AND hp.party_type = 'PERSON'
                AND hp.party_id = fu.person_party_id
                AND fu.user_id = p_user_id
                AND NVL (fu.start_date, SYSDATE - 1) <= SYSDATE
                AND NVL (fu.end_date, SYSDATE + 1) > SYSDATE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_qa_person_name := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            SELECT hp.person_first_name || ' ' || hp.person_last_name
              INTO l_qa_person_name
              FROM applsys.fnd_user fu,
                   ar.hz_parties hp,
                   ar.hz_parties hp1,
                   ar.hz_relationships rel
             WHERE     rel.subject_table_name = 'HZ_PARTIES'
                   AND rel.object_table_name = 'HZ_PARTIES'
                   AND rel.directional_flag = 'F'
                   AND hp.party_id = rel.subject_id
                   AND rel.object_id = hp1.party_id
                   AND hp.party_type = 'PERSON'
                   AND fu.user_id = p_user_id
                   AND hp.party_id = fu.person_party_id
                   AND NVL (fu.start_date, SYSDATE - 1) <= SYSDATE
                   AND NVL (fu.end_date, SYSDATE + 1) > SYSDATE
                   AND ROWNUM = 1;
         WHEN OTHERS
         THEN
            l_qa_person_name := NULL;
      END;

      RETURN l_qa_person_name;
   END get_qa_name_4userid;

   FUNCTION get_budget_rev (p_project_id IN NUMBER, p_period1_date IN DATE)
      RETURN NUMBER
   IS
      v_return         NUMBER;
      v_period1_date   DATE;
   BEGIN
      --v_period1_date :=  to_date(substr(p_period1_date, 1, 11),'dd-mon-yyyy');
      SELECT pbv2.revenue
        INTO v_return
        FROM pa.pa_budget_versions pbv2
       WHERE pbv2.budget_version_id =
                (SELECT MAX (pbv3.budget_version_id)
                   FROM pa.pa_budget_versions pbv3
                  WHERE pbv3.project_id = pbv2.project_id
                        AND pbv2.approved_rev_plan_type_flag =
                               pbv3.approved_rev_plan_type_flag
                        AND TRUNC (pbv3.baselined_date) <= p_period1_date)
             AND pbv2.project_id = p_project_id
             AND pbv2.approved_rev_plan_type_flag = 'Y';

      RETURN v_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_budget_rev;

   FUNCTION get_burden_cost (p_project_id IN NUMBER, p_period1_date IN DATE)
      RETURN NUMBER
   IS
      v_return         NUMBER;
      v_period1_date   DATE;
   BEGIN
      --v_period1_date :=  to_date(substr(p_period1_date, 1, 11),'dd-mon-yyyy');
      SELECT pbv4.burdened_cost
        INTO v_return
        FROM pa.pa_budget_versions pbv4
       WHERE pbv4.budget_version_id =
                (SELECT MAX (pbv5.budget_version_id)
                   FROM pa.pa_budget_versions pbv5
                  WHERE pbv5.project_id = pbv4.project_id
                        AND pbv5.approved_cost_plan_type_flag =
                               pbv4.approved_cost_plan_type_flag
                        AND TRUNC (pbv5.baselined_date) <= p_period1_date) --v_period1_date)
             AND pbv4.project_id = p_project_id
             AND pbv4.approved_cost_plan_type_flag = 'Y';

      RETURN v_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_burden_cost;



   FUNCTION getokeexportadminuser (pokekheaderid IN NUMBER)
      RETURN VARCHAR2
   IS
      x_export_admin   VARCHAR2 (240);

      CURSOR c_role (
         headerid IN NUMBER)
      IS
         SELECT a$employee_name
           FROM oke.oke_k_headers okh, okeg0_project_contract_roles okr
          WHERE     1 = 1
                AND okh.k_header_id = headerid
                AND okh.k_number_disp = okr.a$contract_number
                AND okr.employee_role_name = 'Export Administrator'
                AND SYSDATE BETWEEN okr.employee_role_start_date
                                AND NVL (okr.employee_role_end_date,
                                         SYSDATE + 1);
   BEGIN
      FOR users IN c_role (pokekheaderid)
      LOOP
         x_export_admin := SUBSTR (users.a$employee_name, 1, 240);

         IF x_export_admin IS NOT NULL
         THEN
            EXIT;
         END IF;
      END LOOP;

      IF x_export_admin IS NULL
      THEN
         RETURN '';
      ELSE
         RETURN x_export_admin;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN '';
      WHEN OTHERS
      THEN
         RETURN 'Export Administrator Error';
   END getokeexportadminuser;


   FUNCTION getorderexportadmin (p_header_id IN NUMBER)
      RETURN VARCHAR2
   IS
      x_export_admin   VARCHAR2 (240);
   BEGIN
      SELECT SUBSTR (p.full_name, 1, 240)
        INTO x_export_admin
        FROM ont.oe_order_headers_all ooh,
             hr.per_all_people_f p,
             hr.per_person_type_usages_f ptu,
             hr.per_person_types pt
       WHERE     ooh.header_id = p_header_id
             AND TO_NUMBER (NVL (ooh.attribute18, '0')) = p.person_id
             AND p.person_id = ptu.person_id
             AND ptu.person_type_id = pt.person_type_id
             AND pt.system_person_type IN ('EMP', 'CWK')
             AND SYSDATE BETWEEN p.effective_start_date
                             AND p.effective_end_date
             AND SYSDATE BETWEEN ptu.effective_start_date
                             AND ptu.effective_end_date;

      RETURN x_export_admin;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '';
   END;


   --   FUNCTION isnumeric (pvalue VARCHAR2)
   --      RETURN BOOLEAN
   --   IS
   --      numvar        NUMBER;
   --      not_numeric   EXCEPTION;
   --      PRAGMA EXCEPTION_INIT (not_numeric, -06502);
   --   BEGIN
   --      numvar := pvalue;
   --
   --      IF numvar < 0
   --      THEN
   --         RAISE not_numeric;
   --      ELSE
   --         RETURN TRUE;
   --      END IF;
   --   EXCEPTION
   --      WHEN not_numeric
   --      THEN
   --         RETURN FALSE;
   --   END;


   FUNCTION isnumericexp (pvalue VARCHAR2)
      RETURN BOOLEAN
   IS
      numvar       VARCHAR2 (100);
      firsthalf    NUMBER;
      secondhalf   NUMBER;
   BEGIN
      numvar := pvalue;

      IF INSTR (numvar, 'E') != 0
      THEN
         BEGIN
            SELECT TO_NUMBER (SUBSTR (numvar, 1, INSTR (numvar, 'E') - 1))
              INTO firsthalf
              FROM DUAL;
         EXCEPTION
            WHEN INVALID_NUMBER
            THEN
               RETURN FALSE;
         END;

         BEGIN
            SELECT TO_NUMBER (
                      SUBSTR (numvar,
                              INSTR (numvar, 'E') + 1,
                              LENGTH (numvar)))
              INTO secondhalf
              FROM DUAL;

            RETURN TRUE;
         EXCEPTION
            WHEN INVALID_NUMBER
            THEN
               RETURN FALSE;
         END;

         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   END;



   FUNCTION getsncountinrange (psnfrom IN VARCHAR2, psnto IN VARCHAR2)
      RETURN NUMBER
   IS
      hserial      VARCHAR2 (100);
      hserprefix   VARCHAR2 (100);
      rserial      VARCHAR2 (100);
      hlength      NUMBER;
      i            NUMBER := 1;
   BEGIN
      hserial := NULL;
      hserprefix := NULL;
      rserial := NULL;

      IF psnfrom IS NOT NULL
      THEN
         IF psnto IS NULL OR psnfrom = psnto
         THEN
            RETURN (1);
         END IF;
      ELSE
         RETURN (0);
      END IF;

      hserial := psnfrom;

      LOOP
         --            exit when isnumeric(hSerial); -- Commented by Vijaya Mikkilineni for SR #1370622
         -- Added by Vijaya Mikkilineni for SR #1370622
         IF (isnumeric (hserial) AND NOT isnumericexp (hserial))
         THEN
            EXIT;
         END IF;

         hserprefix := hserprefix || SUBSTR (hserial, 1, 1);
         hserial := SUBSTR (hserial, 2);
      END LOOP;

      hlength := LENGTH (hserial);

      LOOP
         EXIT WHEN rserial = RTRIM (LTRIM (psnto));
         hserial := LPAD (TO_CHAR (TO_NUMBER (hserial) + 1), hlength, '0');
         rserial := hserprefix || hserial;
         i := i + 1;
      END LOOP;

      RETURN i;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;


   FUNCTION getparentdetailid (pdeldetid IN NUMBER)
      RETURN NUMBER
   IS
      CURSOR d_curs
      IS
             SELECT delivery_detail_id
               FROM wsh.wsh_delivery_details
         CONNECT BY delivery_detail_id = PRIOR split_from_delivery_detail_id
         START WITH delivery_detail_id = pdeldetid;

      xid   NUMBER;
   BEGIN
      FOR d_rec IN d_curs
      LOOP
         xid := d_rec.delivery_detail_id;
      END LOOP;

      RETURN xid;
   END;

   -- +=========================================================================+
   -- | Name        :  PROJ_CONT_CONTNBR                                       |
   -- |                                                                         |
   -- | Description :  This function is used to fetch PRoject Cont contnumber |
   -- |                                                                         |
   -- +=========================================================================+

   FUNCTION proj_cont_contnbr (v_proj IN VARCHAR2)
      RETURN VARCHAR2
   IS
      x_contract   VARCHAR2 (2000);

      CURSOR c_cont (
         p_proj_id VARCHAR2)
      IS
           SELECT DISTINCT
                  DECODE (boa.contract_number,
                          '', ch.contract_number,
                          boa.contract_number || '-' || ch.contract_number)
                     k_number
             FROM oke.oke_k_headers eh,
                  okc.okc_k_headers_all_b ch,
                  okc.okc_k_headers_all_b boa,
                  okc.okc_k_lines_b cl,
                  oke.oke_k_lines el
            WHERE     ch.id = eh.k_header_id
                  AND boa.id(+) = eh.boa_id
                  AND eh.k_header_id = cl.dnz_chr_id
                  AND cl.id(+) = el.k_line_id
                  AND el.project_id = p_proj_id
         ORDER BY k_number;
   BEGIN
      -- DBMS_OUTPUT.PUT_LINE (SUBSTR ('VALUE OF V_PROJ=' || V_PROJ, 1, 255));
      FOR rec IN c_cont (v_proj)
      LOOP
         IF x_contract IS NULL
         THEN
            x_contract := rec.k_number;
         ELSE
            --         DBMS_OUTPUT.PUT_LINE (
            --            SUBSTR ('VALUE OF X_CONTRACT=' || X_CONTRACT, 1, 255));
            x_contract :=
               SUBSTR ( (x_contract || ',' || rec.k_number), 1, 100);
         END IF;
      END LOOP;

      RETURN x_contract;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (NULL);
      WHEN OTHERS
      THEN
         RETURN (SQLERRM);
   END;

   FUNCTION get_user_name (p_user_id IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_user_name   VARCHAR2 (1000) := '';
   BEGIN
      SELECT user_name
        INTO v_user_name
        FROM applsys.fnd_user
       WHERE user_id = p_user_id;

      RETURN (v_user_name);
   END;

   -- +=========================================================================+
   -- | Name        :  PROJ_MANAGER                                             |
   -- |                                                                         |
   -- | Description :  This function is used to fetch PRoject Manager full name |
   -- |                                                                         |
   -- +=========================================================================+

   FUNCTION proj_manager (v_proj IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_prgmmgr   VARCHAR2 (2000);

      CURSOR c_pm (
         pproject VARCHAR2)
      IS
         SELECT emp.full_name
           FROM pa.pa_project_parties pp,
                apps.pa_project_role_types pr,
                pa.pa_projects_all ppa,
                hr.per_all_people_f emp
          WHERE     pr.project_role_id = pp.project_role_id
                AND pp.resource_type_id = 101
                AND pp.project_id = ppa.project_id
                AND emp.person_id = pp.resource_source_id
                AND pp.start_date_active BETWEEN emp.effective_start_date
                                             AND emp.effective_end_date
                AND TRUNC (SYSDATE) BETWEEN pp.start_date_active
                                        AND NVL (pp.end_date_active,
                                                 TRUNC (SYSDATE) + 1)
                AND project_role_type = 'PROJECT MANAGER'
                AND ppa.segment1 = pproject;
   BEGIN
      FOR rec IN c_pm (v_proj)
      LOOP
         IF v_prgmmgr IS NULL
         THEN
            v_prgmmgr := rec.full_name;
         ELSE
            v_prgmmgr := v_prgmmgr || ',' || rec.full_name;
         END IF;
      END LOOP;

      RETURN v_prgmmgr;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (SQLERRM);
   END;

   FUNCTION avgitemcost (porgid       IN NUMBER,
                         pitemid      IN NUMBER,
                         pcostgroup   IN NUMBER)
      RETURN NUMBER
   IS
      v_item_cost   NUMBER;
   BEGIN
      SELECT AVG (
                NVL (
                   DECODE (cql.inventory_item_id,
                           NULL, cic.item_cost,
                           cql.item_cost),
                   0))
                item_cost
        INTO v_item_cost
        FROM bom.cst_quantity_layers cql,
             bom.cst_item_costs cic,
             inv.mtl_parameters mp
       WHERE     cql.inventory_item_id(+) = cic.inventory_item_id
             AND cql.organization_id(+) = cic.organization_id
             AND mp.cost_organization_id = cic.organization_id
             AND mp.primary_cost_method = cic.cost_type_id
             AND cic.inventory_item_id = pitemid                       --21598
             AND cic.organization_id = porgid                            --538
             AND cql.cost_group_id =
                    DECODE (mp.primary_cost_method,
                            1, 1,
                            NVL (pcostgroup, 1));

      RETURN NVL (v_item_cost, 0);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN OTHERS
      THEN
         RETURN 0;
   END avgitemcost;


   FUNCTION isnumeric (pvalue VARCHAR2)
      RETURN BOOLEAN
   IS
      numvar        NUMBER;
      not_numeric   EXCEPTION;
      PRAGMA EXCEPTION_INIT (not_numeric, -06502);
   BEGIN
      numvar := pvalue;

      IF numvar < 0
      THEN
         RAISE not_numeric;
      ELSE
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN not_numeric
      THEN
         RETURN FALSE;
   END;

   FUNCTION cf_serial_numbersformula (p_item_id                IN NUMBER,
                                      p_source_header_number   IN VARCHAR2,
                                      p_source_line_id         IN NUMBER,
                                      p_delivery_id            IN NUMBER,
				      p_delivery_detail_id     IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR sales_order_serials
      IS
           SELECT DISTINCT
                     wdd.serial_number
                  || wsn.fm_serial_number
                  || sn.fm_serial_number
                     serial_number,
                     wdd.to_serial_number
                  || sn.to_serial_number
                  || wsn.to_serial_number
                     to_serial_number -- CHANGED FROM SN.TO_SERIAL_NUMBER 3/1/02
             FROM wsh.wsh_delivery_assignments wda,
                  wsh.wsh_delivery_details wdd,
                  inv.mtl_serial_numbers_temp sn,
                  wsh.wsh_serial_numbers wsn
            WHERE     wdd.inventory_item_id = p_item_id
                  AND wdd.source_header_number = p_source_header_number
                  AND wdd.source_line_id = p_source_line_id
                  AND wda.delivery_detail_id = wdd.delivery_detail_id
                  AND wda.delivery_id = p_delivery_id
		  AND wdd.delivery_detail_id = p_delivery_detail_id
                  AND wsn.delivery_detail_id(+) = wdd.delivery_detail_id
                  AND sn.transaction_temp_id(+) = wdd.transaction_temp_id
                  AND (wdd.serial_number || wdd.transaction_temp_id)
                         IS NOT NULL
         ORDER BY 1;

      sos_rec           sales_order_serials%ROWTYPE;

      hserial           VARCHAR2 (100);
      hserprefix        VARCHAR2 (100);
      rserial           VARCHAR2 (100);
      hlength           NUMBER;
      v_serial_number   VARCHAR2 (32000) := ' ';
      length_error      EXCEPTION;
   BEGIN
      v_serial_number := NULL;
      hserial := NULL;
      hserprefix := NULL;
      rserial := NULL;

      -- if :source_code = 'OE' then
      OPEN sales_order_serials;

      LOOP
         FETCH sales_order_serials INTO sos_rec;

         EXIT WHEN sales_order_serials%NOTFOUND;

         IF RTRIM (LTRIM (sos_rec.to_serial_number)) IS NOT NULL
            AND RTRIM (LTRIM (sos_rec.to_serial_number)) <>
                   RTRIM (LTRIM (sos_rec.serial_number))
         THEN
            hserial := sos_rec.serial_number;
            hserprefix := '';

            IF v_serial_number IS NULL
            THEN
               v_serial_number := LTRIM (RTRIM (sos_rec.serial_number));
            ELSE
               v_serial_number :=
                     v_serial_number
                  || ', '
                  || LTRIM (RTRIM (sos_rec.serial_number));
            END IF;

            LOOP
               EXIT WHEN isnumeric (hserial);
               hserprefix := hserprefix || SUBSTR (hserial, 1, 1);
               hserial := SUBSTR (hserial, 2);
            END LOOP;

            hlength := LENGTH (hserial);

            LOOP
               EXIT WHEN rserial = RTRIM (LTRIM (sos_rec.to_serial_number));
               hserial :=
                  LPAD (TO_CHAR (TO_NUMBER (hserial) + 1), hlength, '0');
               rserial := hserprefix || hserial;
               v_serial_number := v_serial_number || ', ' || rserial;
            END LOOP;
         ELSE
            IF v_serial_number IS NULL
            THEN
               v_serial_number := LTRIM (RTRIM (sos_rec.serial_number));
            ELSE
               v_serial_number :=
                     v_serial_number
                  || ', '
                  || LTRIM (RTRIM (sos_rec.serial_number));
            END IF;
         END IF;
      END LOOP;

      CLOSE sales_order_serials;

     IF (LENGTH(v_serial_number) >=4000) THEN
          RAISE length_error;
      END IF;    

      --  end if;
      --dbms_output.put_line(v_serial_number);
      RETURN v_serial_number;
      
   EXCEPTION
      
      WHEN length_error
      THEN
         RETURN 'Serial number string exceeds 4000 character limit';
      
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;


   FUNCTION get_ship_to_name (p_source IN VARCHAR2, p_ship_to_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR c_om_ship_to
      IS
         SELECT rc.customer_name
           FROM apps.ar_customers rc,
                ar.hz_cust_acct_sites_all hcas,
                ar.hz_cust_site_uses_all hcsu
          WHERE     rc.customer_id = hcas.cust_account_id
                AND hcsu.cust_acct_site_id = hcas.cust_acct_site_id
                AND hcsu.site_use_id = p_ship_to_id;

      v_customer_name   VARCHAR2 (50) := '';
   BEGIN
      IF p_source = 'OE'
      THEN
         OPEN c_om_ship_to;

         FETCH c_om_ship_to INTO v_customer_name;

         CLOSE c_om_ship_to;
      ELSE
         --SP#115 : Modified for R12 CEMLI Remidiation
         SELECT SUBSTRB (hp.party_name, 1, 50)
           INTO v_customer_name
           FROM ar.hz_cust_accounts hca, ar.hz_parties hp
          WHERE hca.party_id = hp.party_id
                AND hca.cust_account_id = p_ship_to_id;
      END IF;

      RETURN v_customer_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN '';
   END;

   FUNCTION dpas_rating (p_line_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR dpas_rating
      IS
         SELECT attribute1
           FROM okc.okc_k_lines_b
          WHERE id = p_line_id;

      v_dpas_rating   VARCHAR2 (50);
   BEGIN
      OPEN dpas_rating;

      FETCH dpas_rating INTO v_dpas_rating;

      CLOSE dpas_rating;

      RETURN v_dpas_rating;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION get_mrp_action (p_source_table              IN VARCHAR2,
                            p_item_type                 IN VARCHAR2,
                            p_item_id                   IN NUMBER,
                            p_wip_supply_type           IN NUMBER,
                            p_order_type                IN NUMBER,
                            p_rescheduled_flag          IN NUMBER,
                            p_disposition_status_type   IN NUMBER,
                            p_new_due_date              IN DATE,
                            p_old_due_date              IN DATE,
                            p_implemented_quantity      IN NUMBER,
                            p_quantity_in_process       IN NUMBER,
                            p_firm_quantity             IN NUMBER,
                            p_quantity_rate             IN NUMBER)
      RETURN VARCHAR2
   IS
      myaction   VARCHAR2 (50);
   BEGIN
      IF p_source_table = 'MRP_RECOMMENDATIONS'
      THEN
         IF    p_item_type IN ('1', ' 2', '3', '5')
            OR (p_item_id IS NOT NULL)
            OR (p_wip_supply_type = 6)
            OR p_order_type IN (14, 15, 16, 17, 18, 19)
         THEN
            -- Model Option Class
            myaction := 'None';
         ELSE
            IF NVL (p_rescheduled_flag, 2) = 1
            THEN
               -- already took action
               myaction := 'None';
            ELSIF p_disposition_status_type = 2
            THEN
               -- Cancel orde
               myaction := 'Cancel';
            ELSIF p_new_due_date > p_old_due_date
            THEN
               myaction := 'Reschedule Out';
            ELSIF p_new_due_date < p_old_due_date
            THEN
               -- Reschedule in
               myaction := 'Reschedule In';
            ELSIF p_order_type = 5
            THEN
               IF NVL (p_implemented_quantity, 0)
                  + NVL (p_quantity_in_process, 0) >= p_quantity_rate
               THEN
                  -- Planned order has been released
                  -- set action to none
                  myaction := 'None';
               ELSE
                  -- Release
                  myaction := 'Release';
               END IF;
            ELSE
               -- Action is not required.
               myaction := 'None';
            END IF;
         END IF;
      ELSIF p_source_table = 'MRP_SUGG_REP_SCHEDULES'
      THEN
         IF p_item_type IN (1, 2, 3, 5)
         THEN
            -- Model option class
            myaction := 'None';
         ELSE
            -- Release
            myaction := 'Release';
         END IF;
      ELSE
         -- This record does note come from MRP_RECOMMENDATIONS
         myaction := 'Demand';
      END IF;

      RETURN myaction;
   END;



   FUNCTION get_total_consumption (p_org          IN NUMBER,
                                   p_item         IN NUMBER,
                                   p_date_start   IN DATE,
                                   p_date_end     IN DATE)
      RETURN NUMBER
   IS
      totreq   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (SUM (ABS (mmt.primary_quantity)), 0)
           INTO totreq
           FROM inv.mtl_material_transactions mmt,
                inv.mtl_transaction_types mtt
          WHERE mmt.transaction_type_id = mtt.transaction_type_id
                AND mmt.transaction_action_id NOT IN (24, 30)
                AND UPPER (mtt.transaction_type_name) IN
                       (SELECT UPPER (v.flex_value)
                          FROM applsys.fnd_flex_values v,
                               applsys.fnd_flex_value_sets s
                         WHERE s.flex_value_set_name LIKE
                                  'VSAT_MRP_TOTAL_CONSUMP_TRANSACTIONS'
                               AND s.flex_value_set_id = v.flex_value_set_id
                               AND v.enabled_flag = 'Y'
                               AND NVL (v.start_date_active,
                                        mmt.transaction_date) <=
                                      mmt.transaction_date
                               AND NVL (v.end_date_active,
                                        mmt.transaction_date) >=
                                      mmt.transaction_date)
                AND TO_DATE (mmt.transaction_date, 'dd-mon-yy') BETWEEN TO_DATE (
                                                                           p_date_start,
                                                                           'dd-mon-yy')
                                                                    AND TO_DATE (
                                                                           NVL (
                                                                              p_date_end,
                                                                              TO_DATE (
                                                                                 SYSDATE,
                                                                                 'dd-mon-yy')),
                                                                           'dd-mon-yy')
                AND (mmt.inventory_item_id = p_item)
                AND (mmt.organization_id = p_org);
      EXCEPTION
         WHEN OTHERS
         THEN
            totreq := -999;
      END;

      RETURN (totreq);
   END;



   FUNCTION get_total_requirements (p_org IN VARCHAR2, p_item IN NUMBER)
      RETURN NUMBER
   IS
      totreq   NUMBER;
   BEGIN
      BEGIN
         SELECT ABS (
                   SUM (
                      -NVL (mgr.daily_demand_rate,
                            mgr.using_requirements_quantity)))
           INTO totreq
           FROM mrp.mrp_gross_requirements mgr,
                MRPG0_Plans_Info_Base PBASE
          WHERE     1 = 1
                AND mgr.organization_id = p_org
                AND mgr.inventory_item_id = p_item
                AND mgr.ORGANIZATION_ID      =  PBASE.RELATED_ORGANIZATION
                AND mgr.COMPILE_DESIGNATOR   =  PBASE.PLAN_DESIGNATOR
                AND PBASE.current_plan_type = 'MRP';
      EXCEPTION
         WHEN OTHERS
         THEN
            totreq := -1;
      END;

      RETURN (totreq);
   END;


   FUNCTION get_req_last_new_date (p_org    IN NUMBER,
                                   p_item   IN NUMBER,
                                   p_date   IN DATE)
      RETURN DATE
   IS
      maxdate   DATE;
   BEGIN
      BEGIN
         SELECT MAX (mmt.transaction_date)
           INTO maxdate
           FROM inv.mtl_material_transactions mmt,
                inv.mtl_transaction_types mtt
          WHERE mmt.transaction_type_id = mtt.transaction_type_id
                AND mmt.transaction_action_id NOT IN (24, 30)
                AND UPPER (mtt.transaction_type_name) IN
                       (SELECT UPPER (v.flex_value)
                          FROM applsys.fnd_flex_values v,
                               applsys.fnd_flex_value_sets s
                         WHERE s.flex_value_set_name LIKE
                                  'VSAT_MRP_TOTAL_CONSUMP_TRANSACTIONS'
                               AND s.flex_value_set_id = v.flex_value_set_id
                               AND v.enabled_flag = 'Y'
                               AND NVL (v.start_date_active,
                                        mmt.transaction_date) <=
                                      mmt.transaction_date
                               AND NVL (v.end_date_active,
                                        mmt.transaction_date) >=
                                      mmt.transaction_date)
                AND mmt.organization_id = p_org
                AND mmt.inventory_item_id = p_item
                AND mmt.created_by NOT IN (22891, 50951, 50952, 17090, 17110) --SLEWIS added per SP 1211
                AND TO_DATE (mmt.transaction_date, 'dd-mon-yy') <=
                       TO_DATE (p_date, 'dd-mon-yy');
      EXCEPTION
         WHEN OTHERS
         THEN
            maxdate := NULL;
      END;

      RETURN (maxdate);
   END get_req_last_new_date;

   FUNCTION getprojectmgrfromprojectid (x_project_id IN NUMBER)
      RETURN VARCHAR2
   IS
      x_programmanagers   VARCHAR2 (2000);

      CURSOR c_pm (
         pproject NUMBER)
      IS
         SELECT emp.full_name
           FROM pa.pa_project_parties pp,
                apps.pa_project_role_types pr,
                pa.pa_projects_all ppa,
                hr.per_all_people_f emp
          WHERE     pr.project_role_id = pp.project_role_id
                AND pp.resource_type_id = 101
                AND pp.project_id = ppa.project_id
                AND emp.person_id = pp.resource_source_id
                AND pp.start_date_active BETWEEN emp.effective_start_date
                                             AND emp.effective_end_date
                AND TRUNC (SYSDATE) BETWEEN pp.start_date_active
                                        AND NVL (pp.end_date_active,
                                                 TRUNC (SYSDATE) + 1)
                AND project_role_type = 'PROJECT MANAGER'
                AND ppa.project_id = pproject;
   BEGIN
      FOR rec IN c_pm (x_project_id)
      LOOP
         IF x_programmanagers IS NULL
         THEN
            x_programmanagers := rec.full_name;
         ELSE
            x_programmanagers := x_programmanagers || ',' || rec.full_name;
         END IF;
      END LOOP;

      RETURN x_programmanagers;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (SQLERRM);
   END;

   FUNCTION getpmnamefromlineid (plineid IN VARCHAR2)
      RETURN VARCHAR2
   IS
      x_pgm_mgr   hr.per_all_people_f.full_name%TYPE;
   BEGIN
      SELECT pap.full_name
        INTO x_pgm_mgr
        FROM ont.oe_order_headers_all oeh,
             ont.oe_order_lines_all oel,
             hr.per_all_people_f pap
       WHERE oeh.header_id = oel.header_id
             AND pap.person_id = TO_NUMBER (oeh.attribute5)
             AND NVL (TRUNC (oeh.creation_date), SYSDATE) BETWEEN effective_start_date
                                                              AND NVL (
                                                                     effective_end_date,
                                                                     SYSDATE
                                                                     + 1)
             AND oel.line_id = plineid
             AND ROWNUM = 1;

      RETURN x_pgm_mgr;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN ('');
      WHEN OTHERS
      THEN
         RETURN ('Error getting Pgm Mgr');
   END;

   FUNCTION getitemcost (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN NUMBER
   IS
      x_item_cost   NUMBER;
      x_cost_type   NUMBER;
   BEGIN
      IF pitemid IS NOT NULL
      THEN
         BEGIN
            -- this select returns the average cost type id if it exists
            -- otherwise, it looks for pending
            -- else it returns the first cost type it finds.
            SELECT p.cost_type_id
              INTO x_cost_type
              FROM (  SELECT cost_type_id,
                             (CASE
                                 WHEN cost_type_id = 2 THEN 1   --average cost
                                 WHEN cost_type_id = 3 THEN 2       -- pending
                                 ELSE 3                           --all others
                              END)
                                sort_field
                        FROM bom.cst_item_costs
                       WHERE organization_id = porgid
                             AND inventory_item_id = pitemid
                    ORDER BY 2) p
             WHERE ROWNUM = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               x_cost_type := 0;
         END;

         IF x_cost_type <> 0
         THEN
            SELECT SUM (item_cost)
              INTO x_item_cost
              FROM bom.cst_item_costs
             WHERE     inventory_item_id = pitemid
                   AND organization_id = porgid
                   AND (cost_type_id = x_cost_type); -- or cost_type_id = 1000); -- 1000 only applies to 60,
         --may cause problems if other orgs use it
         END IF;
      ELSE
         x_item_cost := 0;
      END IF;

      RETURN NVL (x_item_cost, 0);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error in vsat_inv_utils.GetItemCost for org/item: '
                 || porgid
                 || '/'
                 || pitemid);
   END;

   FUNCTION getitemname (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2
   IS
      x_item_name   inv.mtl_system_items_b.segment1%TYPE;
   BEGIN
      IF pitemid IS NOT NULL
      THEN
         SELECT segment1
           INTO x_item_name
           FROM inv.mtl_system_items_b
          WHERE inventory_item_id = pitemid AND organization_id = porgid;
      ELSE
         x_item_name := NULL;
      END IF;

      RETURN x_item_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error in vsat_inv_utils.GetItemName for org/item: '
                 || porgid
                 || '/'
                 || pitemid);
   END;


   FUNCTION getplanner (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2
   IS
      v_planner   VARCHAR2 (50);
   BEGIN
      IF pitemid IS NOT NULL
      THEN
         SELECT mp.planner_code || ' (' || mp.description || ')'
           INTO v_planner
           FROM inv.mtl_planners mp, inv.mtl_system_items_b msi
          WHERE (msi.planner_code = mp.planner_code
                 AND msi.organization_id = mp.organization_id)
                AND msi.organization_id = porgid
                AND msi.inventory_item_id = pitemid;
      --and msi.planner_code is not null
      ELSE
         v_planner := NULL;
      END IF;

      RETURN v_planner;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN OTHERS
      THEN
         RETURN (   'Error in vsat_inv_utils.GetPlanner for orgID/itemID: '
                 || porgid
                 || '/'
                 || pitemid);
   END getplanner;


   FUNCTION vsat_get_contract_nbr (p_trx_id NUMBER)
      RETURN VARCHAR2
   IS
      v_contract   VARCHAR2 (250);
   BEGIN
      SELECT MIN (NVL (pe.reference2, pe.reference1)) contract_nbr
        INTO v_contract
        FROM apps.ra_customer_trx_lines_all rctl,
             apps.pa_draft_invoice_items pdii,
             apps.pa_events pe,
             apps.oke_k_headers_full_v okhfv,
             apps.oke_k_lines_full_v oklfv,
             apps.oke_k_billing_events_v okbev,
             apps.oke_k_deliverables_vl okdv
       WHERE TO_CHAR (pdii.draft_invoice_num) =
                rctl.interface_line_attribute2
             AND rctl.interface_line_attribute6 = pdii.line_num
             AND rctl.interface_line_attribute1 || '' = oklfv.project_number
             AND pdii.project_id = pe.project_id
             AND oklfv.project_id = pdii.project_id
             AND NVL (pe.reference2, pe.reference1) = okhfv.k_number
             AND pe.reference1 =
                    DECODE (pe.reference2,
                            '', pe.reference1,
                            okhfv.boa_number)
             AND oklfv.header_id = okhfv.k_header_id
             AND oklfv.line_number = pe.reference3
             AND okbev.pa_event_id = pe.event_id
             AND okbev.deliverable_id = okdv.deliverable_id
             AND NVL (pdii.event_task_id, 0) = NVL (pe.task_id, 0)
             AND pdii.event_num = pe.event_num
             AND rctl.interface_line_context = 'PROJECTS INVOICES'
             AND rctl.customer_trx_id = p_trx_id;

      RETURN (v_contract);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'Error Getting Contract';
   END;

   FUNCTION getshipmentlineontimelate (pshipid        IN NUMBER,
                                       pordqty        IN NUMBER,
                                       ppromisedate   IN DATE,
                                       pasofdate      IN DATE,
                                       pallowance     IN NUMBER)
      RETURN VARCHAR2
   IS
      x_rcv_date   DATE;
      x_rcv_qty    NUMBER;
   BEGIN
      BEGIN
         SELECT MAX (TRUNC (transaction_date))
           INTO x_rcv_date
           FROM po.rcv_transactions
          WHERE     transaction_date <= pasofdate
                AND po_line_location_id = pshipid
                AND transaction_type = 'RECEIVE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            x_rcv_date := pasofdate + 1; --move it out one so we can test for late
      END;

      IF (x_rcv_date - NVL (pallowance, 0)) > ppromisedate
      THEN                --if anything received after promise date, it's late
         RETURN ('L');                                                  --late
      ELSE
         SELECT NVL (SUM (quantity), 0)
           INTO x_rcv_qty
           FROM po.rcv_transactions
          WHERE     TRUNC (transaction_date) <= pasofdate
                AND po_line_location_id = pshipid
                AND transaction_type = 'RECEIVE';

         IF x_rcv_qty < pordqty AND ppromisedate < pasofdate
         THEN                       --if not all rcvd and promise date is past
            RETURN ('L');
         END IF;
      END IF;

      RETURN ('O');
   END;


   FUNCTION get_project_id (p_proj_num VARCHAR2)
      RETURN NUMBER
   IS
      v_proj_id   NUMBER;
   BEGIN
      SELECT project_id
        INTO v_proj_id
        FROM pa.pa_projects_all ppa
       WHERE ppa.segment1 = p_proj_num;

      RETURN v_proj_id;
   END;

   FUNCTION get_max_period_counter (p_asset_id            IN NUMBER,
                                    p_book_type_code      IN VARCHAR2,
                                    p_period_close_date   IN DATE)
      RETURN NUMBER
   IS
      v_period_counter   NUMBER;
   BEGIN
      SELECT MAX (fdss.period_counter)
        INTO v_period_counter
        FROM fa.fa_deprn_summary fdss, fa.fa_deprn_periods fdpp
       WHERE     fdss.asset_id = p_asset_id
             AND fdss.book_type_code = p_book_type_code
             AND fdpp.period_counter = fdss.period_counter
             AND fdss.deprn_source_code = 'DEPRN'
             AND fdpp.calendar_period_close_date <= p_period_close_date;

      RETURN v_period_counter;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN OTHERS
      THEN
         RETURN 0;
   END;

   FUNCTION get_transaction_header_id_in (p_asset_id   IN NUMBER,
                                          p_eff_date      DATE)
      RETURN NUMBER
   IS
      v_trans_header_in   NUMBER;
   BEGIN
      SELECT MAX (transaction_header_id_in)
        INTO v_trans_header_in
        FROM fa.fa_books fbo
       WHERE asset_id = p_asset_id AND date_effective <= p_eff_date;

      RETURN v_trans_header_in;
   END;

   FUNCTION getitemprodline (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2
   IS
      v_prod_line   apps.mtl_categories_b_kfv.segment6%TYPE;
   BEGIN
      SELECT mc.segment6 product_line
        INTO v_prod_line
        FROM apps.mtl_item_categories mic, apps.mtl_categories_b_kfv mc
       WHERE     mc.category_id = mic.category_id
             AND mic.category_set_id = 10                          --Inventory
             AND mic.organization_id = porgid
             AND mic.inventory_item_id = pitemid;

      RETURN v_prod_line;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'Error' || SQLERRM ();
   END;


   FUNCTION getitemprodtype (porgid IN NUMBER, pitemid IN NUMBER)
      RETURN VARCHAR2
   IS
      v_prod_type   apps.mtl_categories_b_kfv.segment6%TYPE;
   BEGIN
      SELECT mc.segment10 product_type
        INTO v_prod_type
        FROM apps.mtl_item_categories mic, apps.mtl_categories_b_kfv mc
       WHERE     mc.category_id = mic.category_id
             AND mic.category_set_id = 10                          --Inventory
             AND mic.organization_id = porgid
             AND mic.inventory_item_id = pitemid;

      RETURN v_prod_type;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'Error' || SQLERRM ();
   END getitemprodtype;


   FUNCTION getcontractandboafromproject (x_project IN VARCHAR2)
      RETURN VARCHAR2
   IS
      x_contract   VARCHAR2 (2000);

      CURSOR c_cont (
         pproject VARCHAR2)
      IS
           SELECT DISTINCT
                  DECODE (boa.contract_number,
                          '', ch.contract_number,
                          boa.contract_number || '-' || ch.contract_number)
                     k_number
             FROM apps.oke_k_headers eh,
                  apps.okc_k_headers_b ch,
                  apps.okc_k_headers_b boa,
                  apps.okc_k_lines_b cl,
                  apps.oke_k_lines el
            WHERE     ch.id = eh.k_header_id
                  AND boa.id = eh.boa_id
                  AND eh.k_header_id = cl.dnz_chr_id
                  AND cl.id = el.k_line_id
                  AND el.project_id = pproject
         ORDER BY k_number;
   BEGIN
      DBMS_OUTPUT.put_line (
         SUBSTR ('Value of x_Project=' || x_project, 1, 255));

      FOR rec IN c_cont (x_project)
      LOOP
         IF x_contract IS NULL
         THEN
            x_contract := rec.k_number;
         ELSE
            DBMS_OUTPUT.put_line (
               SUBSTR ('Value of x_contract=' || x_contract, 1, 255));
            x_contract :=
               SUBSTR ( (x_contract || ',' || rec.k_number), 1, 100);
         END IF;
      END LOOP;

      RETURN x_contract;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN ('');
      WHEN OTHERS
      THEN
         RETURN (SQLERRM);
   END;


      FUNCTION get_fiscal_period_info (p_date          IN VARCHAR2,
                                    p_return_item   IN VARCHAR2)
      RETURN VARCHAR2
   AS
      CURSOR cgl_period
      IS
         SELECT (CASE LOWER (p_return_item)
                    WHEN 'period_name'
                    THEN
                       glp.period_name
                    WHEN 'period_number'
                    THEN
                       TO_CHAR (glp.period_number)
                    WHEN 'period_year'
                    THEN
                       TO_CHAR (glp.period_year)
                    WHEN 'quarter_number'
                    THEN
                       TO_CHAR (glp.quarter_number)
                    WHEN 'period_start_date'
                    THEN
                       TO_CHAR (glp.period_start_date, 'MM/DD/YYYY')
                    WHEN 'period_end_date'
                    THEN
                       TO_CHAR (glp.period_end_date, 'MM/DD/YYYY')
                    WHEN 'quarter_start_date'
                    THEN
                       (SELECT TO_CHAR(MIN(gps.start_date), 'MM/DD/YYYY') 
                         FROM gl.gl_period_statuses gps
                        WHERE gps.application_id = 101 
                          AND gps.period_year = glp.period_year
                          AND gps.quarter_num = glp.quarter_number
                          AND gps.adjustment_period_flag = 'N')
                    WHEN 'quarter_end_date'
                    THEN
                       (SELECT TO_CHAR(MAX(gps.end_date), 'MM/DD/YYYY') 
                         FROM gl.gl_period_statuses gps
                        WHERE gps.application_id = 101 
                          AND gps.period_year = glp.period_year
                          AND gps.quarter_num = glp.quarter_number
                          AND gps.adjustment_period_flag = 'N')
                    WHEN 'year_start_date'
                    THEN
                       (SELECT TO_CHAR(MIN(gps.start_date), 'MM/DD/YYYY') 
                         FROM gl.gl_period_statuses gps
                        WHERE gps.application_id = 101 
                          AND gps.period_year = glp.period_year
                          AND gps.adjustment_period_flag = 'N')
                    WHEN 'year_end_date'
                    THEN
                       (SELECT TO_CHAR(MAX(gps.end_date), 'MM/DD/YYYY') 
                         FROM gl.gl_period_statuses gps
                        WHERE gps.application_id = 101 
                          AND gps.period_year = glp.period_year
                          AND gps.adjustment_period_flag = 'N')
                    ELSE
                       NULL
                 END)
           FROM glg0_status_of_periods glp
          WHERE TO_DATE (p_date, 'MM/DD/YYYY') BETWEEN period_start_date
                                                   AND period_end_date;

      v_ret_value   VARCHAR2 (200) DEFAULT NULL;
   BEGIN
      IF p_date IS NULL OR p_return_item IS NULL
      THEN
         RETURN NULL;
      END IF;

      OPEN cgl_period;

      FETCH cgl_period INTO v_ret_value;

      CLOSE cgl_period;

      RETURN v_ret_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF cgl_period%ISOPEN
         THEN
            CLOSE cgl_period;
         END IF;

         RETURN NULL;
   END;

   
   FUNCTION get_project_task_expenditures (p_project_number     IN VARCHAR2,
                                           p_task_number        IN VARCHAR2,
                                           p_period_name        IN VARCHAR2,
                                           p_expenditure_type   IN VARCHAR2)
      RETURN NUMBER
   AS
      TYPE cur_type IS REF CURSOR;

      c_burden_cost   cur_type;
      l_query_str     VARCHAR2 (10000);
      l_burden_cost   NUMBER;
   BEGIN
      l_query_str :=
            'SELECT SUM(NVL (expi.denom_burdened_cost, 0)) burden_cost '
         || 'FROM gl.gl_period_statuses glst,'
         || 'pa.pa_cost_distribution_lines_all cdl,'
         || 'pa.pa_expenditure_items_all expi,'
         || 'pa.pa_tasks task,'
         || 'pag0_ou_acl_map_base xmap,'
         || 'pa.pa_projects_all proj '
         || 'WHERE 1=1 '
         || 'AND NVL (proj.org_id, -9999) = xmap.operating_unit_id '
         || 'AND task.task_id = expi.task_id '
         || 'AND task.project_id = proj.project_id '
         || 'AND NVL (proj.template_flag, ''N'') = ''N'' '
         || 'AND cdl.expenditure_item_id(+) = expi.expenditure_item_id '
         || 'AND cdl.line_num(+) = 1 '
         || 'AND cdl.gl_date BETWEEN glst.start_date(+) and glst.end_date(+) '
         || 'AND glst.adjustment_period_flag(+) = ''N'' '
         || 'AND glst.set_of_books_id(+) = noetix_pa_pkg.get_org_set_of_books_id (cdl.org_id) '
         || 'AND glst.application_id(+) = 101 '
         || 'AND proj.segment1 = '
         || ''''
         || p_project_number
         || ''' '
         || 'AND task.task_number = NVL('
         || ''''
         || p_task_number
         || ''''
         || ',task.task_number)';

      IF p_period_name IS NOT NULL
      THEN
         l_query_str :=
               l_query_str
            || ' AND glst.period_name IN ('
            || ''''
            || p_period_name
            || ''''
            || ')';
      END IF;

      IF p_expenditure_type IS NOT NULL
      THEN
         l_query_str :=
               l_query_str
            || ' AND expi.expenditure_type NOT IN ('
            || ''''
            || p_expenditure_type
            || ''''
            || ')';
      END IF;

      DBMS_OUTPUT.put_line ('l_query_str : ' || l_query_str);

      IF p_project_number IS NULL
      THEN
         RETURN NULL;
      END IF;

      --
      OPEN c_burden_cost FOR l_query_str;

      FETCH c_burden_cost INTO l_burden_cost;

      CLOSE c_burden_cost;

      RETURN l_burden_cost;
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         IF c_burden_cost%ISOPEN
         THEN
            CLOSE c_burden_cost;
         END IF;

         RAISE;
   -- RETURN NULL;
   END;
   
      FUNCTION get_project_task_activity (p_project_number   IN VARCHAR2,
                                       p_task_number      IN VARCHAR2,
                                       p_line_type        IN VARCHAR2,
                                       p_from_date        IN DATE,
                                       p_to_date          IN DATE)
      RETURN VARCHAR2 AS
      CURSOR c_line_quantity IS
       SELECT SUM (ool.ordered_quantity)
         FROM ont.oe_order_lines_all ool,
              inv.mtl_system_items_b msi,
              pa.pa_tasks pt,
              pa.pa_projects_all pp
        WHERE ool.project_id = pt.project_id
          AND ool.task_id = pt.task_id
          AND pt.project_id = pp.project_id
          AND pp.segment1 = p_project_number
          AND pt.task_number = p_task_number
          AND ool.line_category_code = p_line_type
          AND ool.flow_status_code = 'CLOSED'
          AND ool.inventory_item_id = msi.inventory_item_id
          AND ool.ship_from_org_id = msi.organization_id
          AND msi.shippable_item_flag = 'Y'
          AND ool.fulfillment_date BETWEEN NVL(p_from_date,ool.fulfillment_date) AND NVL(p_to_date,ool.fulfillment_date);
      l_quantity   NUMBER;
   BEGIN
      IF    p_project_number IS NULL
         OR p_task_number IS NULL
         OR p_line_type IS NULL
      THEN
         RETURN NULL;
      END IF;
      OPEN c_line_quantity;
      FETCH c_line_quantity INTO l_quantity;
      CLOSE c_line_quantity;
      RETURN l_quantity;
   EXCEPTION
      WHEN OTHERS THEN
         IF c_line_quantity%ISOPEN THEN
            CLOSE c_line_quantity;
         END IF;
         RETURN ( 'Error Details' ||SQLCODE||' - '||SQLERRM ());
   END;


   FUNCTION get_item_ams_category (p_item_number        IN VARCHAR2,
                                   p_organization_code  IN VARCHAR2)
      RETURN VARCHAR2 AS
      CURSOR c_item_category IS
        SELECT mic.segment1 item_category
          FROM inv.mtl_system_items_b msi,
               apps.mtl_item_categories_v mic,
               inv.mtl_parameters mp
         WHERE 1=1
           AND msi.inventory_item_id = mic.inventory_item_id
           AND msi.organization_id = mic.organization_id
           AND msi.organization_id = mp.organization_id
           AND mic.category_set_name = 'AMS Category'
           AND mic.enabled_flag = 'Y'
           AND msi.segment1 = p_item_number
           AND mp.organization_code = p_organization_code;
      l_item_category   VARCHAR2(50);
   BEGIN
      IF    p_item_number IS NULL
         OR p_organization_code IS NULL THEN
         RETURN NULL;
      END IF;
      OPEN c_item_category;
      FETCH c_item_category INTO l_item_category;
      CLOSE c_item_category;
      RETURN l_item_category;
   EXCEPTION
      WHEN OTHERS THEN
         IF c_item_category%ISOPEN THEN
            CLOSE c_item_category;
         END IF;
         RETURN ( 'Error Details' ||SQLCODE||' - '||SQLERRM ());
   END;

FUNCTION cf_projectformula (p_rcv_transaction_id IN NUMBER) RETURN VARCHAR2 IS
 c_concat  CONSTANT VARCHAR2(2):= ', ';
 v_first_iteration BOOLEAN := TRUE;
 v_project VARCHAR2(250):= NULL;
 CURSOR proj_number_cur 
 IS 
 SELECT Decode(pt.task_number, null, ppa.segment1, ppa.segment1 || '.' || pt.task_number) project_number 
  FROM  po.rcv_transactions rt
      , po.rcv_shipment_lines rcsl
      , po.po_line_locations_all poll
      , po.po_distributions_all pod
      , pa.pa_projects_all ppa
      --
      ,pa.pa_tasks pt
  WHERE transaction_id = p_rcv_transaction_id
  AND rcsl.shipment_line_id = rt.shipment_line_id
  AND rcsl.po_line_location_id = poll.line_location_id
  AND pod.line_location_id = poll.line_location_id
  AND pod.project_id = ppa.project_id
  --
  and pod.task_id = pt.task_id (+);
BEGIN
  FOR proj_number_rec IN proj_number_cur
  LOOP
    IF (v_first_iteration) THEN
      v_project := proj_number_rec.project_number;
      v_first_iteration := FALSE;
    ELSE  
      v_project := v_project 
              || c_concat
              ||proj_number_rec.project_number;  
    END IF;          
  END LOOP;
  RETURN v_project;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: CF_PROJECTFormula for rcv_transaction_id ' || p_rcv_transaction_id || ' ' ||sqlcode || '-' || sqlerrm);
end;


   FUNCTION get_intangible_type (p_inventory_item_id   IN NUMBER,
                         p_org_id              IN NUMBER,
                         p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2
   IS
        v_int_type   VARCHAR2 (500) default null;
        cursor cint_type is SELECT mcat1.sv$intangible_type
            FROM inv.mtl_item_categories itcat,
                inv.mtl_categories_b cat,
                inv.mtl_default_category_sets dcat,
                n_mfg_lookups_vl mlok1,
                xxk_mtl_cat mcat1
            WHERE     cat.category_id = itcat.category_id
                AND dcat.category_set_id = itcat.category_set_id
                AND mlok1.lookup_code = p_mfg_lookup_code
                AND mlok1.lookup_type = 'MTL_FUNCTIONAL_AREAS'
                AND mlok1.lookup_code = dcat.functional_area_id
                AND mlok1.security_group_id =
                    noetix_apps_security_pkg.lookup_security_group (
                       mlok1.lookup_type,
                       mlok1.view_application_id)
                AND cat.category_id = mcat1.category_id
                AND itcat.organization_id = p_org_id
                AND itcat.inventory_item_id = p_inventory_item_id;
   BEGIN
        open cint_type;
        Fetch cint_type INTO v_int_type;
        close cint_type;
      RETURN v_int_type;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Function get_intangible_type raised excepption: Error code '||SQLCODE||
                    ' getting Intangible Type for: '||p_org_id||' - '||p_inventory_item_id||
                    ' - '||p_mfg_lookup_code|| ' E.Msg:'||SQLERRM);
   END;



   FUNCTION get_task_expenditures_by_date ( p_project_number         IN VARCHAR2,
                                            p_task_number            IN VARCHAR2,
                                            p_period_start_date      IN DATE,
                                            p_period_end_date        IN DATE,
                                            p_expenditure_type1      IN VARCHAR2,
                                            p_expenditure_type2      IN VARCHAR2,
                                            p_expenditure_type3      IN VARCHAR2,
                                            p_expenditure_type4      IN VARCHAR2,
                                            p_expenditure_type5      IN VARCHAR2
                                          )
      RETURN VARCHAR2 AS
      l_burden_cost   VARCHAR2(100);
      CURSOR c_burden_cost IS
        SELECT SUM(NVL (expi.denom_burdened_cost, 0)) burden_cost
          FROM gl.gl_period_statuses glst,
               pa.pa_cost_distribution_lines_all cdl,
               pa.pa_expenditure_items_all expi,
               pa.pa_tasks task,
               pag0_ou_acl_map_base xmap,
               pa.pa_projects_all proj
         WHERE 1=1
           AND NVL (proj.org_id, -9999) = xmap.operating_unit_id
           AND task.task_id = expi.task_id
           AND task.project_id = proj.project_id
           AND NVL (proj.template_flag, 'N') = 'N'
           AND cdl.expenditure_item_id(+) = expi.expenditure_item_id
           AND cdl.line_num(+) = 1
           AND cdl.gl_date BETWEEN glst.start_date(+) and glst.end_date(+)
           AND glst.application_id(+) = '101'
           AND glst.set_of_books_id(+) =
                 noetix_pa_pkg.get_org_set_of_books_id (cdl.org_id)
           AND glst.adjustment_period_flag(+) = 'N'
           AND proj.segment1 = p_project_number
           AND task.task_number = NVL(p_task_number,task.task_number)
           AND cdl.gl_date BETWEEN NVL(p_period_start_date,gl_date) AND NVL(p_period_end_date,gl_date)
           AND expi.expenditure_type NOT IN (NVL(p_expenditure_type1,'@#!%*'),NVL(p_expenditure_type2,'@#!%*'),NVL(p_expenditure_type3,'@#!%*'),NVL

(p_expenditure_type4,'@#!%*'),NVL(p_expenditure_type5,'@#!%*'));
   BEGIN
      --
      IF p_project_number IS NULL THEN
         RETURN NULL;
      END IF;
      --
      OPEN c_burden_cost;
      FETCH c_burden_cost INTO l_burden_cost;
      CLOSE c_burden_cost;                        
      RETURN l_burden_cost;
      --
   EXCEPTION
      WHEN OTHERS THEN
         IF c_burden_cost%ISOPEN THEN
            CLOSE c_burden_cost;
         END IF;
         RETURN ('Error: get_task_expenditures_by_date for p_project_number ' || p_project_number || ' ' ||SQLCODE || '-' || SQLERRM);
   END;


FUNCTION get_project_category_info(p_proj_num    in varchar2, p_return_item in varchar2) RETURN VARCHAR2 as
cursor cget_category is select 
                (Case upper(p_return_item)
                    when 'AFTER_MARKET_SERVICE' then rcc.AFTER_MARKET_SERVICE
                    when 'CLASSIFICATION' then  rcc.CLASSIFICATION
                    when 'CUSTOMER_GROUP' then rcc.CUSTOMER_GROUP
                    when 'DEPOT_PRODUCT_LINE' then rcc.DEPOT_PRODUCT_LINE
                    when 'PRODUCT_LINE' then rcc.PRODUCT_LINE
                    when 'PRODUCT_LINE_BUSINESS_AREA' then  rcc.PRODUCT_LINE_BUSINESS_AREA
                    when 'PRODUCT_SERVICE' then rcc.PRODUCT_SERVICE
                    when 'PROJECT_NAME' then rcc.PROJECT_NAME
                    when 'PROJECT_NUMBER' then rcc.PROJECT_NUMBER
                    when 'PROJECT_TYPE' then rcc.PROJECT_TYPE
                    when 'REVENUE_TYPE' then rcc.REVENUE_TYPE
                    when 'SEGMENT' then rcc.SEGMENT
                    when 'SUB_CATEGORY' then rcc.SUB_CATEGORY
                    Else null
                End) 
        from PAG0_RMA_CLASS_CATEGORIES_VSAT rcc
        where rcc.A$PROJECT_NUMBER=p_proj_num;
v_ret_value        varchar2(200) default null;
BEGIN
If p_proj_num is null or p_return_item is null then 
    RETURN NULL;
end if;
open cget_category;
fetch cget_category into v_ret_value;
close cget_category;
RETURN v_ret_value;
EXCEPTION
When others then
    if cget_category%isopen then
        close cget_category;
    end if;
    RETURN 'Error executing function get_project_category_info:'||SQLCODE||
            ' E.Msg:'||SQLERRM;
END;

FUNCTION get_purchasing_category_info(p_item_num in varchar2,p_org_code in varchar2)
                                                    RETURN VARCHAR2 as
cursor cget_category is SELECT MCB.segment6
    FROM
        apps.MTL_CATEGORY_SETS_TL CST,
        apps.MTL_ITEM_CATEGORIES MIC, 
        apps.MTL_CATEGORIES_B MCB,
        inv.mtl_parameters mp,
        inv.mtl_system_items_b msi 
    WHERE  MIC.CATEGORY_ID = MCB.CATEGORY_ID 
    AND MIC.CATEGORY_SET_ID = CST.CATEGORY_SET_ID 
    --AND MIC.ORGANIZATION_ID = 0 
    AND CST.CATEGORY_SET_NAME =  'Purchasing'
    and mic.organization_id=mp.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mp.organization_code=p_org_code
    and msi.segment1=p_item_num;
v_ret_value        varchar2(200) default null;
BEGIN
If p_item_num is null or p_org_code is null then 
    RETURN NULL;
end if;
open cget_category;
fetch cget_category into v_ret_value;
close cget_category;
RETURN v_ret_value;
EXCEPTION
When others then
    if cget_category%isopen then
        close cget_category;
    end if;
    RETURN 'Error executing function get_purchasing_category_info. CODE:'||SQLCODE||
            ' E.Msg:'||SQLERRM;
END;

FUNCTION cf_projectformula2 (p_line_location_id IN NUMBER) RETURN VARCHAR2 IS
 c_concat  CONSTANT VARCHAR2(2):= ', ';
 v_first_iteration BOOLEAN := TRUE;
 v_project VARCHAR2(250):= NULL;
 CURSOR proj_number_cur 
 IS 
 SELECT ppa.segment1 project_number, (pod.quantity_ordered - pod.quantity_delivered - pod.quantity_cancelled) Qty_Remaining
  FROM  po.po_line_locations_all poll
      , po.po_distributions_all pod
      , pa.pa_projects_all ppa
  WHERE p_line_location_id = poll.line_location_id
  AND pod.line_location_id = poll.line_location_id
  AND pod.project_id = ppa.project_id;
BEGIN
  FOR proj_number_rec IN proj_number_cur
  LOOP
    IF (v_first_iteration) THEN
      v_project := proj_number_rec.project_number || ' QTY: ' || proj_number_rec.Qty_Remaining;
      v_first_iteration := FALSE;
    ELSE  
      v_project := v_project 
              || c_concat
              ||proj_number_rec.project_number || ' QTY: ' || proj_number_rec.Qty_Remaining;  
    END IF;          
  END LOOP;
  RETURN v_project;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: CF_PROJECTFormula2 for line_location_id ' || p_line_location_id || ' ' ||sqlcode || '-' || sqlerrm);
end;

FUNCTION get_cost_group_item_cost (p_item_id in NUMBER, P_project_id in NUMBER, p_org_id IN NUMBER)
      RETURN NUMBER
   IS
      v_cost_group_cost NUMBER;
   BEGIN
      select CQL.item_cost item_cost
      into v_cost_group_cost
      from BOM.CST_QUANTITY_LAYERS CQL,
           PJM.PJM_PROJECT_PARAMETERS PJM
      where pjm.organization_id = cql.organization_id (+) and
            pjm.costing_group_id = cql.cost_group_id (+) and
            pjm.organization_id = p_org_id and
            cql.inventory_item_id = p_item_id and
            pjm.project_id = p_project_id;

      RETURN v_cost_group_cost;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN OTHERS
      THEN
         RETURN ('get_cost_group_item_cost error getting Code for: '
                 || 'ItemID: ' || p_item_id
                 || ' '
                 || 'ProjectID: ' ||p_project_id
                 || ' '
                 || 'OrgID: ' || p_org_id
                 || ' '
                 || SUBSTR (SQLERRM (), 1, 55));
   END;

FUNCTION get_cost_group_from_proj (P_project_id in NUMBER, p_org_id IN NUMBER)
      RETURN VARCHAR2
   IS
      v_om_cost_group VARCHAR2 (10);
   BEGIN

       select CCG.cost_group Cost_Group
       into v_om_cost_group
       from PJM.PJM_PROJECT_PARAMETERS PJM,
            BOM.CST_COST_GROUPS CCG
       where pjm.organization_id = ccg.organization_id (+) and
             pjm.costing_group_id = ccg.cost_group_id (+) and
             pjm.project_id = p_project_id and
             pjm.organization_id = p_org_id;
       IF v_om_cost_group is null
           THEN
                select CCG.cost_group Cost_Group
                into v_om_cost_group
                from PJM.PJM_PROJECT_PARAMETERS PJM,
                     BOM.CST_COST_GROUPS CCG
                where pjm.costing_group_id = ccg.cost_group_id (+) and
                      ccg.organization_id is null and
                      pjm.project_id = p_project_id;
           END IF;
      RETURN v_om_cost_group;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'No Data Found';
      WHEN OTHERS
      THEN
           RETURN ('get_cost_group_from_proj error getting Code for: '
                 || 'ProjectID: ' ||p_project_id
                 || ' '
                 || 'OrgID: ' || p_org_id
                 || ' '
                 || SUBSTR (SQLERRM (), 1, 55));
   END;

FUNCTION get_shipped_qty_from_okd (P_deliverable_id in NUMBER)
      RETURN NUMBER
   IS
      v_okd_shipped_quantity NUMBER default NULL;
   BEGIN
       select SUM(WDD.shipped_quantity) Shipped_Quantity
       into v_okd_shipped_quantity
       from WSH.WSH_DELIVERY_DETAILS WDD,
             WSH.WSH_DELIVERY_ASSIGNMENTS WDA,
             OKE.OKE_K_DELIVERABLES_B ED
       where ED.deliverable_id = WDD.source_line_id(+) and
              WDD.source_code = 'OKE' and
              WDD.delivery_detail_id = WDA.delivery_detail_id and
              P_deliverable_id = WDD.source_line_id
       GROUP BY ED.deliverable_id;
      RETURN v_okd_shipped_quantity;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN OTHERS
      THEN
           RETURN ('get_shipped_qty_from_okd error getting Code for: '
                  || 'DeliverableID: ' ||P_deliverable_id
                  || ' '
                  || SUBSTR (SQLERRM (), 1, 55));
   END;


FUNCTION get_cancelled_qty_from_okd (P_deliverable_id in NUMBER)
      RETURN NUMBER
   IS
      v_okd_cancelled_quantity NUMBER default NULL;
   BEGIN
       select SUM(WDD.cancelled_quantity) Cancelled_Quantity
       into v_okd_cancelled_quantity
       from WSH.WSH_DELIVERY_DETAILS WDD,
             WSH.WSH_DELIVERY_ASSIGNMENTS WDA,
             OKE.OKE_K_DELIVERABLES_B ED
       where ED.deliverable_id = WDD.source_line_id(+) and
             WDD.source_code = 'OKE' and
             WDD.delivery_detail_id = WDA.delivery_detail_id and
             P_deliverable_id = WDD.source_line_id
             GROUP BY ED.deliverable_id;
      RETURN v_okd_cancelled_quantity;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
      WHEN OTHERS
      THEN
           RETURN ('get_cancelled_qty_from_okd error getting Code for: '
                  || 'DeliverableID: ' ||P_deliverable_id
                  || ' '
                  || SUBSTR (SQLERRM (), 1, 55));
   END;

Function GetItemLeadTime(pOrgID in number, pItemID in number) return number is x_item_lt number;
   BEGIN
       if pItemID is not null then
          select full_lead_time
          into   x_item_lt
          from   inv.mtl_system_items_b msi
           WHERE msi.inventory_item_id = pItemID
             AND msi.organization_id=pOrgID;
       else
            x_item_lt := 0;
       end if;
        return x_item_lt;
   EXCEPTION
      WHEN others THEN
        RETURN ('Error: item_lead_time not found' || ' ' ||sqlcode || '-' || sqlerrm);
   END GetItemLeadTime;

Function Total_Blanket_Release_Amount(p_po_header_id in number) return number 
     is x_Total_Amt number;
     v_global_flag VARCHAR(1);
   BEGIN
            select NVL(poh.global_agreement_flag,'N')
            into v_global_flag
            from po.po_headers_all poh
            where poh.po_header_id = p_po_header_id;
            
            IF v_global_flag = 'Y' THEN
                   select SUM((NVL(PLL.quantity,0)-NVL(PLL.quantity_cancelled,0)) * PLL.price_override) 
                   into x_total_amt
                   from po.po_line_locations_all pll,
                        po.po_lines_all pol
                   where pol.po_line_id = pll.po_line_id (+)
                   AND pol.from_header_id = p_po_header_id;
            ELSE
                   select NVL(SUM(DECODE(POL.order_type_lookup_code,
                              'RATE',
                              PLL.amount - NVL(PLL.amount_cancelled, 0),
                              'FIXED PRICE',
                              PLL.amount - NVL(PLL.amount_cancelled, 0),
                              ((NVL(PLL.quantity, 0) -
                              NVL(PLL.quantity_cancelled, 0)) * PLL.price_override))),
                              0)
                   into x_total_amt
                   FROM po.po_line_locations_all pll,
                        po.po_headers_all        poh,
                        po.po_lines_all          POL
                   WHERE poh.po_header_id = POL.po_header_id 
                   AND POL.po_line_id = PLL.po_line_id(+)
                   AND pll.shipment_type(+) NOT IN ('PRICE BREAK')
                   and pll.po_header_id = p_po_header_id;
                   END IF;
            Return x_total_amt;
   EXCEPTION
      WHEN others THEN
        RETURN ('Error: Total_Blanket_Release_Amount not found' || ' ' ||sqlcode || '-' || sqlerrm);
   END Total_Blanket_Release_Amount;

function get_max_seq_num_w_qty(p_wip_entity_id In number) return number is
    seq_num number;

   BEGIN
      select max(operation_seq_num)
        into seq_num
      from wip.wip_operations
      where wip_entity_id = p_wip_entity_id
      and (quantity_in_queue>0 or quantity_running>0 or quantity_waiting_to_move>0 or quantity_rejected>0 or quantity_scrapped>0 or quantity_completed>0);

      return seq_num;
      
  exception
    when no_data_found then
        return 'N';
    when others then
        return 'E';
  END;

  function get_max_seq_num_w_qty_desc(p_wip_entity_id In number) return varchar2 is
    seq_num_desc varchar2(250);

  BEGIN
      select max(operation_seq_num||':'||description)
        into seq_num_desc
      from wip.wip_operations
      where wip_entity_id = p_wip_entity_id
      and operation_seq_num = NOETIX_VSAT_UTILITY_PKG.get_max_seq_num_w_qty(p_wip_entity_id)
      ;

      return seq_num_desc;
      
  exception
    when no_data_found then
        return 'N';
    when others then
        return 'E';
  END;
                   
Function job_final_qa_last_moved_date(p_wip_entity_id in number) return DATE is date_last_moved DATE;
    Cursor cwoper is select max(date_last_moved)
          from   wip.wip_operations
           WHERE (upper(description) = 'FINAL QA'
                 or upper(description) like 'FINAL%INS%'
                 or upper(description) like 'INS%FINAL%')      
             AND wip_entity_id = p_wip_entity_id;

   BEGIN
        Open cwoper;
        fetch cwoper into   date_last_moved;
        Close cwoper;
        return date_last_moved;
   EXCEPTION
      WHEN others THEN
        RETURN (NULL);
   END job_final_qa_last_moved_date;

FUNCTION serial_time_in_location (p_serial_number IN varchar2, p_transaction_id IN NUMBER, p_inventory_item_id IN NUMBER) RETURN VARCHAR2 IS
            v_next_transaction_date DATE := SYSDATE;
            v_transaction_date DATE;
            v_calc INT;
 BEGIN
 select mut.transaction_date Transaction_Date
 into v_transaction_date
 from  INV.MTL_UNIT_TRANSACTIONS MUT
 where MUT.TRANSACTION_ID = p_transaction_id and
       MUT.inventory_item_id = p_inventory_item_id and
       MUT.serial_number = p_serial_number;
       
 select NVL(MIN(mut.transaction_date), SYSDATE) Transaction_Date
 into v_next_transaction_date
 from  INV.MTL_UNIT_TRANSACTIONS MUT
 where MUT.TRANSACTION_ID > p_transaction_id and
       MUT.inventory_item_id = p_inventory_item_id and
       MUT.serial_number = p_serial_number;
       
 v_calc := v_next_transaction_date - v_transaction_date;

  RETURN v_calc;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: serial_time_in_location not found' || ' ' ||sqlcode || '-' || sqlerrm);
end;

FUNCTION any_to_number(n Varchar2) RETURN Number IS
number_canon_mask CONSTANT Varchar2(66) :=
        'FM99999999999999999999999999999999999999999999999999D999999999999';
BEGIN
    IF instr(n, ',') > 0 THEN
    RETURN to_number(n, number_canon_mask, 'nls_numeric_characters='',.''');
    ELSE
    RETURN to_number(n, number_canon_mask, 'nls_numeric_characters=''.,''');
    END IF;
END any_to_number;


function Get_DRO_OPEN_Time(p_repair_line_id in number) return Number is
cursor cdro_status is select csd.repair_line_id,csd.repair_number,p.event_date,
    csd.Creation_date,csd.date_closed,csd.status,paramc1 NEW_STATUS,p.paramc2 OLD_STATUS
    from  APPS.CSD_REPAIR_HISTORY P,csd.csd_repairs csd
    where P.repair_line_id(+)=csd.repair_line_id
    and P.event_code(+)='SC'
    and csd.status <>'D'
    and csd.repair_line_id=p_repair_line_id
    order by P.event_date;
Type DRO_Statustype is table of cDRO_STATUS%rowtype;
DRO_Status_list    DRO_Statustype;
total_time      number(20,5) default 0.0;
from_date        date default null;
Found_End_date    BOOLEAN default FALSE;
BEGIN
if nvl(p_repair_line_id,0) =0 then
    RETURN null;
End If;
open cDRO_STATUS;
fetch cDRO_STATUS bulk collect into DRO_Status_list;
Close cDRO_STATUS;
If DRO_Status_list.count=1 then
    if DRO_Status_list(1).status='O' then
        total_time := sysdate -  DRO_Status_list(1).event_date;
    elsif DRO_Status_list(1).status='C' then
        total_time :=  DRO_Status_list(1).date_closed - DRO_Status_list(1).event_date;
    end if;
elsIf  nvl(DRO_Status_list.count,0)=0 then
    RETURN NULL;
Else
    from_date :=DRO_Status_list(1).event_date;
    for i in 1..DRO_Status_list.count loop
        if from_date is null and DRO_Status_list(i).new_status='O' then
            from_date := DRO_Status_list(i).event_date;
        Elsif DRO_Status_list(i).new_status in ('H','C') and from_date is not null then
            total_time := total_time + (DRO_Status_list(i).event_date - from_date);
            from_date := null;
            Found_end_date := TRUE;
        end if;
    End loop;
    if not Found_End_date then
            total_time := total_time + (sysdate - from_date);
    End if;
End If;
RETURN round(total_time,2);
END;



function Get_DRO_HOLD_Time(p_repair_line_id in number) return Number is
cursor crec is select p.event_date from  APPS.CSD_REPAIR_HISTORY P
    where P.event_code ='RR'  and p.repair_line_id=p_repair_line_id
    order by P.event_date;
v_receipt_date        date;
cursor cdro_status is select csd.repair_line_id,csd.repair_number,p.event_date,
    csd.Creation_date,csd.date_closed,csd.status,paramc1 NEW_STATUS,p.paramc2 OLD_STATUS
    from  APPS.CSD_REPAIR_HISTORY P,csd.csd_repairs csd
    where P.repair_line_id(+)=csd.repair_line_id
    and P.event_code(+)='SC'
    and csd.status <>'D'
    and csd.repair_line_id=p_repair_line_id
    and p.event_date>v_receipt_date
    order by P.event_date;
Type DRO_Statustype is table of cDRO_STATUS%rowtype;
DRO_Status_list    DRO_Statustype;
total_time      number(20,5) default 0.0;
from_date        date default null;
Found_End_date    BOOLEAN default FALSE;
BEGIN
if nvl(p_repair_line_id,0) =0 then
    RETURN 0;
End If;
open crec;
fetch crec into v_receipt_date;
close crec;
if v_receipt_date is null then
    RETURN 0;
End if;
open cDRO_STATUS;
fetch cDRO_STATUS bulk collect into DRO_Status_list;
Close cDRO_STATUS;
If DRO_Status_list.count=1 then
    if DRO_Status_list(1).status='H' then
        total_time := sysdate -  DRO_Status_list(1).creation_date;
    end if;
elsIf  nvl(DRO_Status_list.count,0)=0 then
    RETURN 0;
Else
    for i in 1..DRO_Status_list.count loop
        if from_date is null and DRO_Status_list(i).new_status='H' then
            from_date := DRO_Status_list(i).event_date;
            Found_end_date := FALSE;    -- Added for JIRA 947
        Elsif DRO_Status_list(i).new_status in ('O','C') and from_date is not null then
            total_time := total_time + (DRO_Status_list(i).event_date - from_date);
            from_date := null;
            Found_end_date := TRUE;
        end if;
    End loop;
    if not Found_End_date then
            total_time := total_time + (sysdate - from_date);
    End if;
End If;
RETURN round(nvl(total_time,0),2);
END;

function Get_DRO_REPAIR_Time(p_repair_line_id in number) return Number is
cursor crep is select cd.status,cd.creation_date,cd.date_closed from csd.csd_repairs cd where cd.repair_line_id=p_repair_line_id;
rep_rec     crep%rowType;
cursor crec is select p.event_date from  APPS.CSD_REPAIR_HISTORY P
    where P.event_code ='RR'  and p.repair_line_id=p_repair_line_id
    order by P.event_date;
receipt_date        date;    
cursor cship is select p.event_date from  APPS.CSD_REPAIR_HISTORY P
    where P.event_code ='PS' and p.repair_line_id=p_repair_line_id
    order by P.event_date desc;
ship_date        date;    
total_time          number(20,5) default 0.0;
BEGIN
Open crep;
Fetch crep into rep_rec;
If crep%found and rep_rec.status<>'D' then
    if rep_rec.status='O' then
        open crec;
        fetch crec into receipt_date;
        if crec%notfound then 
            total_time := Null;
        else
            total_time := (sysdate - receipt_date)-  NOETIX_VSAT_UTILITY_PKG.Get_DRO_HOLD_Time(p_repair_line_id);
        End if;           
        close crec;
    Elsif rep_rec.status='H' then
        open crec;
        fetch crec into receipt_date;
        if crec%notfound then 
            total_time := Null;
        else
            total_time := (sysdate - receipt_date) -  NOETIX_VSAT_UTILITY_PKG.Get_DRO_HOLD_Time(p_repair_line_id);
        End if;           
        close crec;
    ElsIf rep_rec.status='C' then
        open crec;
        fetch crec into receipt_date;
        if crec%notfound then 
            total_time := Null;
        else
            close crec;
            open cship;
            fetch cship into ship_date;
            close cship;
            total_time := (nvl(ship_date,rep_rec.date_closed) - receipt_date) -  nvl(NOETIX_VSAT_UTILITY_PKG.Get_DRO_HOLD_Time(p_repair_line_id),0);
        End if;           
    End if;
End If;
if total_time<0 then
    RETURN 0;
Else    
    RETURN Round(total_time,2);
END If;
END;

FUNCTION get_serials_wip_step (p_wip_entity_id in number, p_opseq_num VARCHAR2, p_operation_step_type in number ) RETURN VARCHAR2 IS
 c_concat  CONSTANT VARCHAR2(2):= ', ';
 v_first_iteration BOOLEAN := TRUE;
 v_serial VARCHAR2(32000):= NULL;
 v_serial_min VARCHAR2(32000):= NULL;
 v_serial_final VARCHAR2(32000):= NULL;
 v_min_seq_num VARCHAR2(250):= NULL;
 
 CURSOR serial_numbers_assigned_cur
 IS
 SELECT msn.serial_number
  FROM  inv.mtl_serial_numbers msn
  WHERE msn.wip_entity_id = p_wip_entity_id
  and msn.operation_seq_num is null
  and msn.intraoperation_step_type is null
order by msn.serial_number;
 
 CURSOR serial_number_cur
 IS
 SELECT msn.serial_number
  FROM  inv.mtl_serial_numbers msn
  WHERE msn.wip_entity_id = p_wip_entity_id
  and msn.operation_seq_num = p_opseq_num
  and msn.intraoperation_step_type = p_operation_step_type
order by msn.serial_number;

BEGIN
 select min(operation_seq_num) 
 into v_min_seq_num
 from WIP.WIP_OPERATIONS
 where wip_entity_id = p_wip_entity_id;
  
  FOR serial_number_rec IN serial_number_cur
  LOOP
    IF (v_first_iteration) THEN
      v_serial := serial_number_rec.serial_number;
      v_first_iteration := FALSE;
    ELSE
      v_serial := v_serial
              || c_concat
              ||serial_number_rec.serial_number;
    END IF;
  END LOOP;
  
  FOR serial_number_rec IN serial_numbers_assigned_cur
  LOOP
    IF (v_first_iteration) THEN
      v_serial_min := serial_number_rec.serial_number;
      v_first_iteration := FALSE;
    ELSE
      v_serial_min := v_serial_min
              || c_concat
              ||serial_number_rec.serial_number;
    END IF;
  END LOOP;
  if p_opseq_num = v_min_seq_num and p_operation_step_type = 1
    then v_serial_final := v_serial_min;
  if v_serial is not null
    then v_serial_final:= v_serial_final ||', '|| v_serial;
    end if;
  else v_serial_final:= v_serial;
  end if;
  RETURN v_serial_final;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: get_serials_wip_step for wip_entity_id ' || p_wip_entity_id || ' ' ||sqlcode || '-' || sqlerrm);
end;

FUNCTION get_serials_wip_completed (p_wip_entity_id in number) RETURN VARCHAR2 IS
 c_concat  CONSTANT VARCHAR2(2):= ', ';
 v_first_iteration BOOLEAN := TRUE;
 v_serial VARCHAR2(32000):= NULL;
 CURSOR serial_number_cur
 IS
 select msn.serial_number
 from inv.mtl_serial_numbers msn,
      inv.mtl_object_genealogy mog
 where msn.gen_object_id = mog.parent_object_id
 and mog.object_id = p_wip_entity_id
 and mog.object_type = 5
 and mog.parent_object_type = 2
 and mog.end_date_active is null
 order by msn.serial_number;
BEGIN
  FOR serial_number_rec IN serial_number_cur
  LOOP
    IF (v_first_iteration) THEN
      v_serial := serial_number_rec.serial_number;
      v_first_iteration := FALSE;
    ELSE
      v_serial := v_serial
              || c_concat
              ||serial_number_rec.serial_number;
    END IF;
  END LOOP;
  RETURN v_serial;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: get_serials_wip_completed for wip_entity_id ' || p_wip_entity_id || ' ' ||sqlcode || '-' || sqlerrm);
end;

function job_repair_loe(p_wip_entity_id In number) return varchar2 is 
  v_max_txn_num number;
  v_loe varchar2(250);
  
  BEGIN
      select max(transaction_id)
        into v_max_txn_num
      from wip.wip_move_transactions
      where wip_entity_id = p_wip_entity_id
      and attribute1 is not null; 
  
      select attribute1
        into v_loe
      from wip.wip_move_transactions
      where wip_entity_id = p_wip_entity_id
      and transaction_id = v_max_txn_num
      and fm_intraoperation_step_type = 1;

      return v_loe;
      
  exception
    when no_data_found then
        return null;
    when others then
        return 'E';
  END job_repair_loe; 



function serial_num_ship_date(p_wip_entity_id In number, p_released_date in date) return date is 
  v_serial_num varchar2(250);
  v_ship_date date;
  
  BEGIN
      select DECODE (
          INSTR (wip_entity_name, '.'),
          0, SUBSTR (wip_entity_name, 2, 30),
          SUBSTR (
             wip_entity_name,
             2,
             INSTR (wip_entity_name, '.', INSTR (wip_entity_name, 'R') + 1) 
             - (INSTR (wip_entity_name, 'R') + 1))) into v_serial_num
      from wip.wip_entities
      where wip_entity_id = p_wip_entity_id;    
  
      select min(mut.transaction_date)
        into v_ship_date
      from inv.mtl_unit_transactions mut,
           inv.mtl_material_transactions mmt
      where mut.transaction_id = mmt.transaction_id
            and mut.serial_number = v_serial_num
            and mut.transaction_date > p_released_date
            and mut.organization_id = 1901
            and mmt.transaction_type_id = 33; --Sales order issue
      return v_ship_date;
  exception
    when no_data_found then
        return null;
    when others then
        return null;
  END serial_num_ship_date;

FUNCTION last_3_notes (p_repair_number VARCHAR2) RETURN VARCHAR2 IS

   all_notes   VARCHAR2 (7000);

   CURSOR c_all_notes
   IS
        SELECT listagg (Note_Entered_Date ||' - ' || Entered_by_Employee_Name ||'  - ' || Notes, CHR(42)) WITHIN GROUP (ORDER BY note_entered_date DESC) all_notes
          FROM csdg0_repair_notes
         WHERE repair_number = p_repair_number AND ROWNUM < 4
      GROUP BY repair_number;

BEGIN

   OPEN c_all_notes;
   FETCH c_all_notes INTO all_notes;
   CLOSE c_all_notes;

   RETURN all_notes;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN (NULL);

END last_3_notes;

function get_nmr_values ( pRMA_Header_id in number,pNmr_Rma_Line_No in number, pNMR_SN in varchar2,pTYPE in varchar2) return varchar2 is
cursor cnmr_action is select Distinct 
                (CASE WHEN pType in ('AS RECEIVED CONDITION','INCOMING VERIFICATION TEST','RTV')
                            Then n.NMR_DET_DESC_OF_DEF
                    When ptype in ('PREVENTATIVE','REPAIRS PERFORMED','UPGRADES')
                    then n.NMR_DET_ACTION_TAKEN
                    Else Null
                    END)
            from QAG0_NMR_DETAIL_VSAT_Base n
            where n.RMA_Header_id=pRMA_Header_id
                and n.Nmr_Rma_Line_No=pNmr_Rma_Line_No
                and n.NMR_SN=pNMR_SN
                and upper(n.NMR_DET_REPAIR_ACTION)=pType;
cursor cnmr is Select distinct DECODE(pTYPE,
            'NMR_DET_TEST_TYPE',n.nmr_det_test_type,
            'NMR_DET_RESP',n.NMR_DET_RESP,
            'NMR_DET_CHILD_NMR',n.NMR_DET_CHILD_NMR,
            'NMR_SUPPLIER',n.NMR_SUPPLIER,
            'NMR_DET_DISPO',n.NMR_DET_DISPO,
            'NMR_DET_SN',n.NMR_DET_SN,
            'NMR_PN_DESC',n.NMR_PN_DESC,
            'NMR_DET_FAILED_ITEM',n.NMR_DET_FAILED_ITEM,
            'NMR_NMR_DATE_CLOSED',n.NMR_NMR_DATE_CLOSED,
            'NMR_DET_MRB_COMMENTS',n.NMR_DET_MRB_COMMENTS,
            'NMR_DET_COMMENTS',n.NMR_DET_COMMENTS,
            'NMR_COMMENTS',n.NMR_COMMENTS,
            'NMR_PARENT_NMR',n.NMR_PARENT_NMR,
            'NMR_PARENT_SN',n.NMR_PARENT_SN,
            'NMR_PN_DESC',n.NMR_PN_DESC,
            'NMR_PN',n.NMR_PN,
            'NMR_RPT_SYMP',n.NMR_RPT_SYMP,
            'NMR_FLEX_LOV_NMR_3',n.NMR_FLEX_LOV_NMR_3,
            'NMR_SYMPTOM_CONFIRMED',n.NMR_SYMPTOM_CONFIRMED,
            'NMR_LOT_QTY',n.NMR_LOT_QTY,
            'NMR_PGM',n.NMR_PGM,
            null) nmr_val
            from QAG0_NMR_DETAIL_VSAT_Base n
            where n.RMA_Header_id=pRMA_Header_id
                and n.Nmr_Rma_Line_No=pNmr_Rma_Line_No
                and n.NMR_SN=pNMR_SN
                and DECODE(pTYPE,
                    'NMR_DET_TEST_TYPE',n.nmr_det_test_type,
                    'NMR_DET_RESP',n.NMR_DET_RESP,
                    'NMR_DET_CHILD_NMR',n.NMR_DET_CHILD_NMR,
                    'NMR_SUPPLIER',n.NMR_SUPPLIER,
                    'NMR_DET_DISPO',n.NMR_DET_DISPO,
                    'NMR_DET_SN',n.NMR_DET_SN,
                    'NMR_PN_DESC',n.NMR_PN_DESC,
                    'NMR_DET_FAILED_ITEM',n.NMR_DET_FAILED_ITEM,
                    'NMR_NMR_DATE_CLOSED',n.NMR_NMR_DATE_CLOSED,
                    'NMR_DET_MRB_COMMENTS',n.NMR_DET_MRB_COMMENTS,
                    'NMR_DET_COMMENTS',n.NMR_DET_COMMENTS,
                    'NMR_COMMENTS',n.NMR_COMMENTS,
                    'NMR_PARENT_NMR',n.NMR_PARENT_NMR,
                    'NMR_PARENT_SN',n.NMR_PARENT_SN,
                    'NMR_PN_DESC',n.NMR_PN_DESC,
                    'NMR_PN',n.NMR_PN,
                    'NMR_RPT_SYMP',n.NMR_RPT_SYMP,
                    'NMR_FLEX_LOV_NMR_3',n.NMR_FLEX_LOV_NMR_3,
                    'NMR_SYMPTOM_CONFIRMED',n.NMR_SYMPTOM_CONFIRMED,
                    'NMR_LOT_QTY',n.NMR_LOT_QTY,
                    'NMR_PGM',n.NMR_PGM,
                    null) is not null;
Type NMR_TabType is table of cnmr%rowtype;
nmr_rec        NMR_TabType;
ret_val        varchar2(30000);
BEGIN
-- RTV id used to get value for RTV_DESC
if ptype in ('AS RECEIVED CONDITION','INCOMING VERIFICATION TEST','RTV',
                'PREVENTATIVE','REPAIRS PERFORMED','UPGRADES') then
    open cnmr_action;
    fetch cnmr_action bulk collect into  nmr_rec;
    close cnmr_action;
else
    open cnmr;
    fetch cnmr bulk collect into  nmr_rec;
    close cnmr;
end if;
for i in 1..nmr_rec.count loop
    if i = 1 then
        ret_val := nmr_rec(1).nmr_val;
    else
        ret_val := ret_val ||' ; '||nmr_rec(i).nmr_val;
    End if;
End Loop;
RETURN ret_val;
END;


FUNCTION treasury_account_symbol (p_project_id IN NUMBER) RETURN VARCHAR2 IS
   v_user_attr   oke.oke_k_user_attributes.user_attribute11%TYPE;
BEGIN
   SELECT DISTINCT okua.user_attribute11
     INTO v_user_attr
     FROM oke.oke_k_headers okh,
          oke.oke_k_user_attributes okua,
          okc.okc_k_headers_all_b ch
    WHERE     okh.k_header_id = okua.k_header_id
          AND okh.k_header_id = ch.id
          AND (okua.user_attribute10 = 'Y' OR okua.user_attribute04 = 'Y')
          AND okh.project_id = p_project_id;

   RETURN v_user_attr;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;


FUNCTION last_receipt_date (p_line_location_id IN NUMBER) RETURN DATE IS
   v_rcpt_date   DATE;
BEGIN
   SELECT MAX (rcvt.transaction_date)
     INTO v_rcpt_date
     FROM po.rcv_transactions rcvt
    WHERE     rcvt.source_document_code = 'PO'
          AND rcvt.transaction_type = 'RECEIVE'
          AND rcvt.po_line_location_id = p_line_location_id;

   RETURN v_rcpt_date;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION Additional_Flowdowns (p_project_id IN NUMBER)   RETURN VARCHAR2 IS
   v_user_attr   VARCHAR2 (250);
BEGIN
   SELECT NVL (
                     MAX (
                        DECODE (SUBSTR (UPPER (attr.user_attribute30), 1, 2),
                                NULL, 'N',
                                'N', 'N',
                                'N/', 'N',
                                'NA', 'N',
                                'NO', 'N',
                                'Y')),
                     'N') into v_user_attr
             FROM (SELECT eh.k_header_id, ppa.project_id
                     FROM oke.oke_k_headers eh,
                          okc.okc_k_headers_all_b ch,
                          pa.pa_projects_all ppa
                    WHERE ch.id = eh.k_header_id
                          AND eh.project_id = ppa.project_id
                   UNION
                   SELECT eh.k_header_id, ppa.project_id
                     FROM oke.oke_k_headers eh,
                          okc.okc_k_headers_all_b ch,
                          oke.oke_k_lines el,
                          okc.okc_k_lines_b cl,
                          pa.pa_projects_all ppa
                    WHERE     ch.id = eh.k_header_id
                          AND cl.dnz_chr_id = eh.k_header_id
                          AND el.project_id = ppa.project_id
                          AND el.k_line_id = cl.id) contract,
                  apps.oke_k_user_attributes_v attr
            WHERE     contract.k_header_id = attr.k_header_id(+)
                  AND attr.k_line_id(+) IS NULL
                  AND contract.project_id = p_project_id
                  AND attr.user_attribute_context(+) =
                         'Contract Summary Information'
                  AND attr.user_attr_context_name(+) =
                         'Contract Authorization'
                  AND attr.user_attribute04 IS NOT NULL
                  AND attr.user_attribute04 <> 'Not a FAR Based Contract';

   RETURN v_user_attr;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;


FUNCTION Government_Trasnparency_Clause (p_project_id IN NUMBER) RETURN VARCHAR2 IS
   v_user_attr   oke.oke_k_user_attributes.user_attribute11%TYPE;
BEGIN
   SELECT DISTINCT okua.user_attribute10 INTO v_user_attr
             FROM oke.oke_k_headers okh,
                  oke.oke_k_user_attributes okua,
                  okc.okc_k_headers_all_b ch
            WHERE okh.k_header_id = okua.k_header_id
                  AND okh.k_header_id = ch.id
                  AND (okua.user_attribute10 = 'Y'
                       OR okua.user_attribute04 = 'Y')
                  AND okh.project_id = p_project_id;

   RETURN v_user_attr;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;


FUNCTION NAICS_Code (p_project_id IN NUMBER) RETURN VARCHAR2 IS
   v_user_attr   oke.oke_k_user_attributes.user_attribute11%TYPE;
BEGIN
   SELECT DISTINCT okua.user_attribute09 INTO v_user_attr
             FROM oke.oke_k_headers okh,
                  oke.oke_k_user_attributes okua,
                  okc.okc_k_headers_all_b ch
            WHERE okh.k_header_id = okua.k_header_id
                  AND okh.k_header_id = ch.id
                  AND (okua.user_attribute10 = 'Y'
                       OR okua.user_attribute04 = 'Y')
                  AND okh.project_id = p_project_id;

   RETURN v_user_attr;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION om_hold_exists (p_header_id IN NUMBER, p_line_id IN NUMBER)
      RETURN VARCHAR2
   IS
      hold VARCHAR2 (1) := 'N';
   BEGIN
       select DECODE(MIN(released_flag),'Y','N','N','Y','N') --Line_Hold_Exists
           into hold
          FROM ONT.oe_order_holds_all
          WHERE line_id = p_line_id;
     if hold='N' --if no line hold, check for header hold
       then
         select DECODE(MIN(released_flag),'Y','N','N','Y','N') --Header_Hold_Exists
           into hold
          FROM ONT.oe_order_holds_all
          WHERE line_id is null
          AND header_id = p_header_id;
     end if;
       return hold;
   EXCEPTION
      WHEN NO_DATA_FOUND
         THEN RETURN null;
      WHEN OTHERS
         THEN RETURN ('Error: om_hold_exists for Line_ID ' || p_line_id || ' ' ||sqlcode || '-' || sqlerrm);
   END om_hold_exists;

FUNCTION get_times_returned_info (p_customer_product_id IN NUMBER)
   RETURN NUMBER
IS
   v_times_returned   NUMBER;
BEGIN

     SELECT  COUNT (p.event_date)
       INTO v_times_returned
       FROM apps.csd_repair_history p, csd.csd_repairs rprs
      WHERE 1=1
      AND rprs.customer_product_id = p_customer_product_id 
      AND RPRS.REPAIR_LINE_ID = p.repair_line_id
      AND p.event_code = 'RR'
   GROUP BY customer_product_id;

   RETURN (v_times_returned);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '0';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: ' || SQLERRM;
END get_times_returned_info;

FUNCTION get_avg_addl_funds_info (p_header_id  IN   NUMBER,
                                          p_project_id  IN  NUMBER,
                                          p_task_id  IN     NUMBER)
   RETURN NUMBER
IS
   v_ordered_qty_nr   NUMBER;
   v_ordered_qty_dr   NUMBER;
BEGIN
   SELECT SUM (ool.unit_selling_price * ool.ordered_quantity)
     INTO v_ordered_qty_nr
     FROM ont.oe_order_lines_all ool, inv.mtl_system_items_b msi
    WHERE     ool.header_id = p_header_id
          AND ool.project_id = p_project_id
          AND NVL (ool.task_id, 9999999) = NVL (p_task_id, 9999999)
          AND ool.inventory_item_id = msi.inventory_item_id
          AND ool.ship_from_org_id = msi.organization_id
          AND msi.segment1 LIKE '%SRV%';

   SELECT DECODE (SUM (ool.ordered_quantity),
                  0, 1,
                  SUM (ool.ordered_quantity))
     INTO v_ordered_qty_dr
     FROM ont.oe_order_lines_all ool, inv.mtl_system_items_b msi
    WHERE     ool.header_id = p_header_id
          AND ool.project_id = p_project_id
          AND NVL (ool.task_id, 9999999) = NVL (p_task_id, 9999999)
          AND ool.inventory_item_id = msi.inventory_item_id
          AND ool.ship_from_org_id = msi.organization_id
          AND msi.segment1 NOT LIKE '%SRV%'
          AND ool.line_category_code = 'ORDER';

   RETURN (v_ordered_qty_nr / v_ordered_qty_dr);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '1';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: ' || SQLERRM;
END get_avg_addl_funds_info;

FUNCTION get_mrp_req_details (p_line_id IN NUMBER, p_column_code IN VARCHAR2) 
	return varchar2 IS
Cursor crequisition is Select ppx.full_name,prl.line_num,prh.requisition_header_id
		FROM po.po_requisition_headers_all       prh,
			po.po_requisition_lines_all         prl,
			apps.per_people_x                   ppx
		WHERE prl.requisition_header_id = prh.requisition_header_id
			and prl.requisition_line_id=p_line_id
			and prl.suggested_buyer_id = ppx.person_id(+);
req_rec		crequisition%rowtype;
cursor corder is Select oh.Order_number 
		FROM ont.oe_order_headers_all OH
		WHERE source_document_id=req_rec.requisition_header_id;
v_ret_value	varchar2(50) default null;
BEGIN
If p_line_id is not null then
	Open crequisition;
	Fetch crequisition into req_rec;
	If crequisition%found then
		If p_column_code='LINE_NUM' then
			v_ret_value := req_rec.line_num;
		Elsif p_column_code='BUYER' then
			v_ret_value := req_rec.full_name;
		Elsif p_column_code='ORDER_NUM' then
			Open corder;
			Fetch corder into v_ret_value;
			Close corder;
		ENd if;
	End If;
	Close crequisition;
End If;
RETURN v_ret_value;
END get_mrp_req_details;

FUNCTION get_assembly_revision_info (
   p_top_assembly_item_id           IN NUMBER,
   p_top_assembly_organization_id   IN NUMBER,
   p_assembly_revision              IN VARCHAR2)
   RETURN CHAR
IS
   v_assembly_revision_flag   CHAR (1);
BEGIN
   SELECT DECODE (rev2.revision, p_assembly_revision, 'Y', 'N')
     INTO v_assembly_revision_flag
     FROM inv.mtl_item_revisions_b rev2
    WHERE     1 = 1
          AND rev2.inventory_item_id(+) = p_top_assembly_item_id
          AND rev2.organization_id(+) = p_top_assembly_organization_id
          AND rev2.revision =
                 (SELECT MAX (rev4.revision)
                    FROM inv.mtl_item_revisions_b rev4
                   WHERE rev4.inventory_item_id(+) = p_top_assembly_item_id
                         AND rev4.organization_id(+) =
                                p_top_assembly_organization_id
                         AND rev4.implementation_date(+) IS NOT NULL
                         AND rev4.effectivity_date =
                                (SELECT MAX (rev3.effectivity_date)
                                   FROM inv.mtl_item_revisions_b rev3
                                  WHERE rev3.inventory_item_id(+) =
                                           p_top_assembly_item_id
                                        AND rev3.organization_id(+) =
                                               p_top_assembly_organization_id
                                        AND rev3.implementation_date(+)
                                               IS NOT NULL));

   RETURN (v_assembly_revision_flag);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      RETURN 'ERROR: ' || SQLERRM;
END get_assembly_revision_info;

FUNCTION get_planning_group_qty (p_item_id  IN NUMBER, p_org_id in NUMBER, p_plan_group in VARCHAR2) RETURN NUMBER IS
   pg_qty NUMBER;
BEGIN
    select sum(moqd.primary_transaction_quantity) pg_quantity
    into pg_qty
    from inv.mtl_onhand_quantities_detail moqd,
         inv.mtl_secondary_inventories msi,
         apps.mtl_material_statuses mms
    where moqd.subinventory_code = msi.secondary_inventory_name
    and msi.status_id = mms.status_id
    and mms.availability_type = 1
    and msi.organization_id = p_org_id
    and moqd.inventory_item_id = p_item_id
    and moqd.organization_id = p_org_id
    and moqd.project_id in (select project_id
                            from pjm.pjm_project_parameters
                            where organization_id = p_org_id
                            and planning_group = p_plan_group);
   RETURN pg_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_serials_wip_associated (p_wip_entity_id in number, p_item_id in number) RETURN VARCHAR2 IS
 c_concat  CONSTANT VARCHAR2(2):= ', ';
 v_first_iteration BOOLEAN := TRUE;
 v_serial VARCHAR2(32000):= NULL;
 CURSOR serial_number_cur
 IS
  select serial_number
  from inv.mtl_serial_numbers
  where wip_entity_id = p_wip_entity_id 
  and inventory_item_id = p_item_id
  union
  select serial_number
  from inv.mtl_serial_numbers
  where original_wip_entity_id = p_wip_entity_id 
  and inventory_item_id = p_item_id
  order by serial_number;
BEGIN
  FOR serial_number_rec IN serial_number_cur
  LOOP
    IF (v_first_iteration) THEN
      v_serial := serial_number_rec.serial_number;
      v_first_iteration := FALSE;
    ELSE
      v_serial := v_serial
              || c_concat
              ||serial_number_rec.serial_number;
    END IF;
  END LOOP;
  RETURN v_serial;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: get_serials_wip_associated for wip_entity_id/item_id ' || p_wip_entity_id || '/' || p_item_id || ' ' ||sqlcode || '-' || sqlerrm);
end;

FUNCTION get_first_lot_txn_type (p_lot_number IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2
  IS v_first_txn_id NUMBER;
     v_first_txn_type VARCHAR2 (80);
BEGIN
    select min(transaction_id)
    into v_first_txn_id
    from inv.mtl_transaction_lot_numbers
    where lot_number = p_lot_number
    and inventory_item_id = p_item_id
    and transaction_quantity > 0;
    
    select mtt.transaction_type_name
    into v_first_txn_type
    from inv.mtl_material_transactions mmt,
         inv.mtl_transaction_types mtt
    where mmt.transaction_type_id = mtt.transaction_type_id
    and mmt.transaction_id = v_first_txn_id;

   RETURN v_first_txn_type;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END; 

FUNCTION get_first_lot_txn_source (p_lot_number IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2
  IS v_first_txn_id NUMBER;
     v_first_txn_source VARCHAR2 (80);
BEGIN
    select min(transaction_id)
    into v_first_txn_id
    from inv.mtl_transaction_lot_numbers
    where lot_number = p_lot_number
    and inventory_item_id = p_item_id
    and transaction_quantity > 0;
    
    select DECODE(INSTR(NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),'.'),
            0,NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),
            SUBSTR(NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),1,
            INSTR(NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),'.') - 1))
    into v_first_txn_source
    from inv.mtl_material_transactions mmt,
         inv.mtl_txn_source_types mts
    where mmt.transaction_source_type_id = mts.transaction_source_type_id
    and mmt.transaction_id = v_first_txn_id;

   RETURN v_first_txn_source;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_viasat_business_work_days (
   p_start_date   IN DATE,
   p_end_date     IN DATE)
   RETURN NUMBER
IS
   v_curr_date      DATE := p_start_date;
   v_day            VARCHAR2 (10);
   v_business_cnt   NUMBER := 0;
BEGIN
   IF p_end_date IS NULL OR p_start_date IS NULL
   THEN
      RETURN 0;
   END IF;

   IF p_end_date - p_start_date <= 0
   THEN
      RETURN 0;
   END IF;

   SELECT COUNT (*)
     INTO v_business_cnt
     FROM apps.bom_calendar_dates
    WHERE     calendar_code = 'V-PROD'
          AND seq_num IS NOT NULL
          AND TRUNC (calendar_date) >= p_start_date
          AND TRUNC (calendar_date) <= p_end_date
          AND calendar_date NOT IN
                 (SELECT hhdvl.holiday_date
                    FROM apps.hxt_holiday_calendars hhc,
                         apps.hxt_holiday_days_vl hhdvl
                   WHERE hhdvl.hcl_id = hhc.id
                         AND hhc.name = 'VSAT Holiday Calendar');

   RETURN v_business_cnt;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 0;
END;

FUNCTION item_first_purch_date (p_item_id IN NUMBER) RETURN DATE
  IS v_date date;
BEGIN
    select pol2.creation_date
    into v_date
    from (select min(po_line_id) po_line_id
          from po.po_lines_all
          where item_id = p_item_id) pol,
         po.po_lines_all pol2
    where pol.po_line_id = pol2.po_line_id;

   RETURN v_date;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_serials_op_seq (p_wip_entity_id in number, p_opseq_num VARCHAR2) RETURN VARCHAR2 IS
 c_concat  CONSTANT VARCHAR2(2):= ', ';
 v_first_iteration BOOLEAN := TRUE;
 v_serial VARCHAR2(32000):= NULL;
 v_serial_min VARCHAR2(32000):= NULL;
 v_serial_final VARCHAR2(32000):= NULL;
 v_min_seq_num VARCHAR2(250):= NULL;

 CURSOR serial_numbers_assigned_cur
 IS
 SELECT msn.serial_number
  FROM  inv.mtl_serial_numbers msn
  WHERE msn.wip_entity_id = p_wip_entity_id
  and msn.operation_seq_num is null
  order by msn.serial_number;

 CURSOR serial_number_cur
 IS
 SELECT msn.serial_number
  FROM  inv.mtl_serial_numbers msn
  WHERE msn.wip_entity_id = p_wip_entity_id
  and msn.operation_seq_num = p_opseq_num
  order by msn.serial_number;

BEGIN
 select min(operation_seq_num)
 into v_min_seq_num
 from WIP.WIP_OPERATIONS
 where wip_entity_id = p_wip_entity_id;

  FOR serial_number_rec IN serial_number_cur
  LOOP
    IF (v_first_iteration) THEN
      v_serial := serial_number_rec.serial_number;
      v_first_iteration := FALSE;
    ELSE
      v_serial := v_serial
              || c_concat
              ||serial_number_rec.serial_number;
    END IF;
  END LOOP;

  FOR serial_number_rec IN serial_numbers_assigned_cur
  LOOP
    IF (v_first_iteration) THEN
      v_serial_min := serial_number_rec.serial_number;
      v_first_iteration := FALSE;
    ELSE
      v_serial_min := v_serial_min
              || c_concat
              ||serial_number_rec.serial_number;
    END IF;
  END LOOP;
  if p_opseq_num = v_min_seq_num
    then v_serial_final := v_serial_min;
  if v_serial is not null
    then v_serial_final:= v_serial_final ||', '|| v_serial;
    end if;
  else v_serial_final:= v_serial;
  end if;
  RETURN v_serial_final;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN NULL;
   WHEN OTHERS
   THEN
      RETURN ('Error: get_serials_op_seq for wip_entity_id ' || p_wip_entity_id || ' ' ||sqlcode || '-' || sqlerrm);
end;

FUNCTION get_first_serial_txn_type (p_serial IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2
  IS v_first_txn_id NUMBER;
     v_first_txn_type VARCHAR2 (80);
BEGIN
    select min(mut.transaction_id)
    into v_first_txn_id
    from inv.mtl_unit_transactions mut,
         inv.mtl_material_transactions mmt
    where mut.transaction_id = mmt.transaction_id
    and mut.serial_number = p_serial
    and mut.inventory_item_id = p_item_id
    and mmt.transaction_quantity > 0;

    select mtt.transaction_type_name
    into v_first_txn_type
    from inv.mtl_material_transactions mmt,
         inv.mtl_transaction_types mtt
    where mmt.transaction_type_id = mtt.transaction_type_id
    and mmt.transaction_id = v_first_txn_id;

   RETURN v_first_txn_type;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_first_serial_txn_source (p_serial IN VARCHAR2, p_item_id IN NUMBER) RETURN VARCHAR2
  IS v_first_txn_id NUMBER;
     v_first_txn_source VARCHAR2 (80);
BEGIN
    select min(mut.transaction_id)
    into v_first_txn_id
    from inv.mtl_unit_transactions mut,
         inv.mtl_material_transactions mmt
    where mut.transaction_id = mmt.transaction_id
    and mut.serial_number = p_serial
    and mut.inventory_item_id = p_item_id
    and mmt.transaction_quantity > 0;

    select DECODE(INSTR(NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),'.'),
            0,NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),
            SUBSTR(NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),1,
            INSTR(NOETIX_VSAT_UTILITY_PKG.GetTransSource(UPPER(MTS.TRANSACTION_SOURCE_TYPE_NAME),mmt.transaction_source_id),'.') - 1))
    into v_first_txn_source
    from inv.mtl_material_transactions mmt,
         inv.mtl_txn_source_types mts
    where mmt.transaction_source_type_id = mts.transaction_source_type_id
    and mmt.transaction_id = v_first_txn_id;

   RETURN v_first_txn_source;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_employee_education (p_emp_number IN VARCHAR2)
   RETURN VARCHAR2
IS
   v_emp_education_dtls   VARCHAR2 (500) := '';
BEGIN
     SELECT listagg (
               si.segment6 || '-' || si.segment7 || '-' || si.segment5 || '; ')
            WITHIN GROUP (ORDER BY pera.person_id, si.segment6)
       INTO v_emp_education_dtls
       FROM hr.per_person_analyses pera,
            applsys.fnd_id_flex_structures fs1,
            hr.per_analysis_criteria si
      WHERE     1 = 1
            AND pera.analysis_criteria_id = si.analysis_criteria_id
            AND si.id_flex_num = fs1.id_flex_num
            AND si.id_flex_num = 50189
            AND fs1.enabled_flag = 'Y'
            AND fs1.id_flex_code = 'PEA'
            AND fs1.application_id = 800
            AND pera.person_id IN
                   (SELECT papf.person_id
                      FROM hr.per_all_people_f papf
                     WHERE 1 = 1 AND papf.employee_number = p_emp_number)
   GROUP BY pera.person_id;

   RETURN REPLACE (REPLACE (v_emp_education_dtls, '-;', ';'), '--', '-');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'Data Not Available';
   WHEN OTHERS
   THEN
      RETURN 'Data Not Available';
END;

FUNCTION getitemcategorydesc (p_inventory_item_id   IN NUMBER,
                             p_org_id              IN NUMBER,
                             p_mfg_lookup_code     IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_cat_desc   VARCHAR2 (200);
   BEGIN
      SELECT mct.description
        INTO v_cat_desc
        FROM inv.mtl_item_categories itcat,
             inv.mtl_categories_b cat,
             inv.mtl_default_category_sets dcat,
             n_mfg_lookups_vl mlok1,
             xxk_mtl_cat mcat1,
             inv.mtl_categories_tl mct
       WHERE     cat.category_id = itcat.category_id
             AND dcat.category_set_id = itcat.category_set_id
             AND mlok1.lookup_code = p_mfg_lookup_code
             AND mlok1.lookup_type = 'MTL_FUNCTIONAL_AREAS'
             AND mlok1.lookup_code = dcat.functional_area_id
             AND mlok1.security_group_id =
                    noetix_apps_security_pkg.lookup_security_group (
                       mlok1.lookup_type,
                       mlok1.view_application_id)
             AND cat.category_id = mcat1.category_id
             and itcat.category_id = mct.category_id
             AND itcat.organization_id = p_org_id
             AND itcat.inventory_item_id = p_inventory_item_id;

      RETURN v_cat_desc;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

FUNCTION get_orig_promised_date (p_line_location_id IN NUMBER) RETURN VARCHAR2
  IS v_o_prom_date VARCHAR2 (23);
BEGIN
    select promised_date
    into v_o_prom_date
    from po.po_line_locations_archive_all
    where line_location_id = p_line_location_id
    and revision_num = 0;

   RETURN v_o_prom_date;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_prev_promised_date (p_line_location_id IN NUMBER, p_current_rev_num IN NUMBER) RETURN VARCHAR2
  IS v_p_prom_date VARCHAR2 (23);
BEGIN
    if p_current_rev_num = 0
      then v_p_prom_date := null;
    else select promised_date
         into v_p_prom_date
         from po.po_line_locations_archive_all
         where line_location_id = p_line_location_id
         and revision_num = p_current_rev_num-1;
    end if;

   RETURN v_p_prom_date;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN null;
   WHEN OTHERS
   THEN
      RETURN 'ERROR: '||SQLERRM;
END;

FUNCTION get_user_id (p_user_name IN VARCHAR)
      RETURN NUMBER
   IS
      CURSOR csr_get_user_id
      IS
         SELECT  peo.person_id
           FROM  hr.per_all_people_f peo
          WHERE 1=1
              AND ((peo.full_name = p_user_name) OR (peo.last_name ||', '||peo.first_name = p_user_name))
              and trunc(sysdate) between PEO.EFFECTIVE_START_DATE and nvl(peo.effective_end_date, sysdate+1);

      v_user_id  NUMBER;
   BEGIN
      OPEN csr_get_user_id;

      FETCH csr_get_user_id INTO v_user_id;

      CLOSE csr_get_user_id;

      RETURN (v_user_id);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (NULL);
   END get_user_id;

FUNCTION long_to_char (p_media_id IN NUMBER)
   RETURN VARCHAR
AS
   l_data    VARCHAR (32767);
   lc_data   CLOB;
   
BEGIN

  
      SELECT SUBSTR (cldata, 1, 3999) into l_data
        FROM temp_long_tab lc
       WHERE media_id = p_media_id;

  

   RETURN (l_data);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (NULL);
END;

FUNCTION note_length (p_media_id IN NUMBER)
   RETURN NUMBER
AS
   l_data    VARCHAR (32767);
   lc_data   CLOB;
   note_len NUMBER;
   
BEGIN

   SELECT LENGTH (cldata) into note_len
        FROM temp_long_tab lc
       WHERE media_id = p_media_id;

   RETURN (note_len);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (NULL);
END;

END noetix_vsat_utility_pkg;
/
