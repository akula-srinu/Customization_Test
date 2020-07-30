-- *******************************************************************************
-- FileName:             wnoetxu2.sql
--
-- Date Created:         2018/Jul/30 03:47:28
-- Created By:           nemuser
--
-- Source:
-- - Package:            Package_2018_P3_B1_DEV_NEW
-- - Environment:        EBSPJD1
-- - NoetixViews Schema: NOETIX_VIEWS
--
-- Versions:
-- - Oracle EBS:   12.1.3
-- - Oracle DB:    11.2.0
-- - NoetixViews:  6.5.1
--
-- *******************************************************************************

WHENEVER OSERROR EXIT 901;

WHENEVER SQLERROR EXIT 901;

@wnoetxu2_prerequisite.sql

WHENEVER SQLERROR EXIT 901;

@wnoetxu2_legacy.sql

WHENEVER OSERROR EXIT 901;

@NVWB_AP_Inv_Dist_Essentials.sql
@NVWB_AP_Inv_Dist_SLA_GL_Je.sql
@NVWB_AP_Invoice_Checks.sql
@NVWB_AP_Invoice_Distributions.sql
@NVWB_AP_Invoice_Line_Details.sql
@NVWB_AP_Invoices.sql
@NVWB_AR_Customer_Addresses.sql
@NVWB_AR_Invoice_Activities.sql
@NVWB_AR_Loc_Assignments_Vsat.sql
@NVWB_AR_Revenue_Distributions.sql
@NVWB_BEN_Assignments_Vsat.sql
@NVWB_BEN_BEN_Costs01_Vsat.sql
@NVWB_BEN_BEN_Costs02_Vsat.sql
@NVWB_BEN_Ben_Costs_Vsat.sql
@NVWB_BEN_Ben_Person_Vsat.sql
@NVWB_BEN_Dropped_Dependents_Vsat.sql
@NVWB_BEN_Enrollment_Vsat_Base.sql
@NVWB_BEN_Open_Enroll_1_Vsat_Base.sql
@NVWB_BEN_Open_Enroll_2_Vsat_Base.sql
@NVWB_BEN_Open_Enrollments_Vsat.sql
@NVWB_BEN_Payroll_Ben_Costs.sql
@NVWB_BEN_Ptpnt_Benefit_Costs.sql
@NVWB_BOM_Assemblies.sql
@NVWB_BOM_Current_Structured_Bills.sql
@NVWB_BOM_Routings.sql
@NVWB_CSD_Customer_Loc_Vsat_Base.sql
@NVWB_CSD_Fracas_Details_Vsat.sql
@NVWB_CSD_Lov_Business_Area_Vsat.sql
@NVWB_CSD_Lov_Repair_Statuses_Vsat.sql
@NVWB_CSD_OE_Repair_RMA_Orders.sql
@NVWB_CSD_OE_Repair_RMA_Orders_Vsat.sql
@NVWB_CSD_OE_Repair_Returns_Vsat.sql
@NVWB_CSD_OE_Repair_Shipments.sql
@NVWB_CSD_PO_Repair_Req_Orders.sql
@NVWB_CSD_Repair_Distributions_Vsat.sql
@NVWB_CSD_Repair_History_Vsat.sql
@NVWB_CSD_Repair_Nmr_Details_Vsat.sql
@NVWB_CSD_Repair_Notes.sql
@NVWB_CSD_Repair_Order_Notes_Vsat.sql
@NVWB_CSD_Repair_Order_Services.sql
@NVWB_CSD_Repair_Order_Vsat.sql
@NVWB_CSD_Repair_Orders.sql
@NVWB_CSD_Repair_RMA_Line_Numb_Base.sql
@NVWB_CSD_Repair_SCont_Sublines_Vsat.sql
@NVWB_CSD_Repair_Ship_Vsat_Base.sql
@NVWB_CSD_Repair_Warranty_Date_Vsat.sql
@NVWB_CSD_Rtv_Kff_Vsat.sql
@NVWB_CSD_SContract_SL_Vsat_Base.sql
@NVWB_CSD_Serv_Diag_Code_Vsat.sql
@NVWB_CSD_Supp_Cust_Warranty_Vsat.sql
@NVWB_CSD_WIP_Repair_Jobs.sql
@NVWB_CSI_All_Install_Base_Tran_Vsat.sql
@NVWB_CSI_IB_Child_Detls_Vsat_Base.sql
@NVWB_CSI_IB_Curr_Loc_Vsat_Base.sql
@NVWB_CSI_Ins_Tran_Link_Vsat_Base.sql
@NVWB_CSI_Instance_Relationships.sql
@NVWB_CSI_Instance_Repair_Orders.sql
@NVWB_CSI_Instance_Security_Base.sql
@NVWB_CSI_Instance_Trans_Vsat_Base.sql
@NVWB_CSI_Instances.sql
@NVWB_CSI_Item_Instances_Base.sql
@NVWB_CSI_Ser_Instl_Bse_Info_Vsat.sql
@NVWB_FA_Asset_Effective_Date_Vsat.sql
@NVWB_FA_Assets.sql
@NVWB_FA_Non_Depr_Item_Vsat.sql
@NVWB_FA_Trial_Balance_Vsat.sql
@NVWB_GL_All_Je_Lines.sql
@NVWB_GL_Balances.sql
@NVWB_GL_Balances_Vsat.sql
@NVWB_GL_Corporate_Details_Vsat.sql
@NVWB_GL_Inv_Turns_12_Months_Vsat.sql
@NVWB_GL_Je_Lines_Vsat.sql
@NVWB_GL_Je_SLA_AP_Inv_Dist.sql
@NVWB_GL_Lov_Division_Vsat.sql
@NVWB_GL_Status_Of_Periods.sql
@NVWB_HR_Contingent_Worker_Vsat.sql
@NVWB_HR_EI_Asg_Ben_Derived.sql
@NVWB_HR_EI_US_Eth_Orign_Hist_Vsat.sql
@NVWB_HR_Emp_Asg_Details.sql
@NVWB_HR_Emp_Assign_Hist.sql
@NVWB_HR_Emp_Info.sql
@NVWB_HR_Emp_Sal_Analysis.sql
@NVWB_HR_Emp_Sal_Pro_Current.sql
@NVWB_HR_Emp_Sal_Pro_Hist.sql
@NVWB_HR_Emp_Terms_Hist.sql
@NVWB_HR_New_Hire_Hist_Vsat.sql
@NVWB_HR_New_Hire_Vsat.sql
@NVWB_HR_Person_Analys_VSat_Base.sql
@NVWB_HR_Person_Hist.sql
@NVWB_HR_Pst_Proj_Res_Schedules_Vsat.sql
@NVWB_HR_Pst_Projects_Vsat_Base.sql
@NVWB_HR_Pst_Res_Schd_Vsat_Base.sql
@NVWB_HR_Pst_Resources_Vsat_Base.sql
@NVWB_HR_Rep_Cost_Centers_Vsat_Base.sql
@NVWB_HR_Rep_Focal_Months_Vsat_Base.sql
@NVWB_HR_Rep_Locations_Vsat_Base.sql
@NVWB_HR_Reports_Cost_Centers_Vsat.sql
@NVWB_HR_Reports_Focal_Months_Vsat.sql
@NVWB_HR_Reports_Locations_Vsat.sql
@NVWB_HR_SI_Typ_Vsat_Edu_Hist_Vsat.sql
@NVWB_HR_SI_Type.sql
@NVWB_HR_Valid_Grades.sql
@NVWB_INV_Account_Transactions.sql
@NVWB_INV_Alias_Transactions.sql
@NVWB_INV_By_Serial_Vsat.sql
@NVWB_INV_Category_Vsat_Base.sql
@NVWB_INV_Cost_Det_Vsat_Base.sql
@NVWB_INV_Costing_Transactions.sql
@NVWB_INV_Cycle_Count_Apprv_Vsat.sql
@NVWB_INV_Cycle_Count_Trans_Vsat.sql
@NVWB_INV_Cycle_Count_Transactions.sql
@NVWB_INV_Forecasts.sql
@NVWB_INV_Item_Cost_Groups_Vsat.sql
@NVWB_INV_Item_Costs.sql
@NVWB_INV_Item_Notes.sql
@NVWB_INV_Item_Planning_Attributes.sql
@NVWB_INV_Items.sql
@NVWB_INV_Items_Cost_Vsat_Base.sql
@NVWB_INV_Items_Vsat.sql
@NVWB_INV_Lot_Details.sql
@NVWB_INV_Lot_Transactions.sql
@NVWB_INV_Lov_Orgn_Codes_Vsat.sql
@NVWB_INV_Mtl_Cat_Sets_Vsat_Base.sql
@NVWB_INV_Mtl_Oh_Po_Vsat.sql
@NVWB_INV_Mtl_Param_Vsat_Base.sql
@NVWB_INV_Mtl_Uom_Conv_Vsat_Base.sql
@NVWB_INV_OH_SS_MRP_Attributes_Vsat.sql
@NVWB_INV_Onhand_Last_Used_Vsat.sql
@NVWB_INV_Onhand_Locator_Vsat_Base.sql
@NVWB_INV_Onhand_Orders_Vsat.sql
@NVWB_INV_Onhand_Qnty_Cost_Vsat_Base.sql
@NVWB_INV_Onhand_Quantities.sql
@NVWB_INV_Onhand_Quantities_Vsat.sql
@NVWB_INV_Onhand_Quantity_Vsat_Base.sql
@NVWB_INV_Onhand_Serials_Vsat.sql
@NVWB_INV_PO_Transactions.sql
@NVWB_INV_Physical_Inv_Transactions.sql
@NVWB_INV_Proj_Loc_Onhand_Vsat_Base.sql
@NVWB_INV_REQ_By_Prod_Line_Vsat.sql
@NVWB_INV_Safety_Stk_Vsat_Base.sql
@NVWB_INV_Safety_Stock_Vsat_Base.sql
@NVWB_INV_Sales_Order_Transactions.sql
@NVWB_INV_Ser_Vsat_Base.sql
@NVWB_INV_Serial_Number_Trans.sql
@NVWB_INV_Serial_Numbers_Vsat.sql
@NVWB_INV_Ship_Quantity_Vsat_Base.sql
@NVWB_INV_Time_To_Failure_Vsat.sql
@NVWB_INV_Transaction_Details.sql
@NVWB_INV_Transaction_Distributions.sql
@NVWB_INV_Transactions.sql
@NVWB_INV_WIP_Age_Sr_Txn_Vsat_Base.sql
@NVWB_INV_WIP_Age_Vsat.sql
@NVWB_INV_WIP_Transactions.sql
@NVWB_INV_Wsh_Dlv_Vsat_Base.sql
@NVWB_MRP_Exception_Orders.sql
@NVWB_MRP_Gross_Requirements.sql
@NVWB_MRP_Item_Forecast_Cost_Vsat.sql
@NVWB_MRP_MRP_Sch_Dates_Vsat_Base.sql
@NVWB_MRP_MRP_Workbench_Vsat.sql
@NVWB_MRP_MRP_Workbench_Vsat_Base.sql
@NVWB_MRP_Mat_Requirements_Vsat.sql
@NVWB_MRP_Onhand_Qty_Vsat.sql
@NVWB_MRP_Orders_Sc_Vsat_Base.sql
@NVWB_MRP_Schedule_Dates_Vsat_Base.sql
@NVWB_MRP_Schedules.sql
@NVWB_MRP_Total_Demand_Summary_Vsat.sql
@NVWB_OE_Delivery_Depart_D_Vsat.sql
@NVWB_OE_Delivery_Dtls_Vsat_Base.sql
@NVWB_OE_Dlv_Dtls_Lvl1_Vsat_Base.sql
@NVWB_OE_Dlv_Dtls_Lvl2_Vsat_Base.sql
@NVWB_OE_Holds.sql
@NVWB_OE_Line_Details.sql
@NVWB_OE_Lines.sql
@NVWB_OE_Mtl_Cat_Vsat_Base.sql
@NVWB_OE_OKE_Pc_Order_Info_Vsat.sql
@NVWB_OE_OKE_Pc_Orders_Vsat_Base.sql
@NVWB_OE_OM_Order_Info_Vsat.sql
@NVWB_OE_OM_Orders_Vsat_Base.sql
@NVWB_OE_OM_PC_Shipment_Dtl_Vsat.sql
@NVWB_OE_OM_Pc_Order_Info_Vsat.sql
@NVWB_OE_OM_Pc_Orders_Vsat_Base.sql
@NVWB_OE_OM_Pc_Shipments_Vsat.sql
@NVWB_OE_Order_Shipment_Vsat.sql
@NVWB_OE_Order_To_Be_Shipped_Vsat.sql
@NVWB_OE_Orders.sql
@NVWB_OE_Project_Vsat_Base.sql
@NVWB_OE_RL_UPS_RMA_Errors_Vsat.sql
@NVWB_OE_RL_UPS_Screening_Vsat.sql
@NVWB_OE_RMA_Line_Details_Vsat.sql
@NVWB_OE_Serial_Trans_Vsat_Base.sql
@NVWB_OE_Shipments_By_Mo_Vsat.sql
@NVWB_OE_Workflow_Statuses_Base.sql
@NVWB_OKE_Prj_Contr_Deliverables.sql
@NVWB_OKE_Proj_Contr_User_Attrs.sql
@NVWB_OKE_Proj_Contract_Parties.sql
@NVWB_OKE_Project_Contract_Lines.sql
@NVWB_OKE_Project_Contracts.sql
@NVWB_OKS_Ent_Bill_Rates_Vsat_Base.sql
@NVWB_OKS_Parties_Self_Vsat_Base.sql
@NVWB_OKS_SContract_Sublines.sql
@NVWB_OKS_SContract_Sublines_Base.sql
@NVWB_OKS_SContract_Summary.sql
@NVWB_OKS_Scs_Base_Data_Vsat.sql
@NVWB_OKS_Scs_Chrg_Dtls_Vsat_Base.sql
@NVWB_OKS_Scs_Data_Vsat.sql
@NVWB_PA_All_Expenditure_Items.sql
@NVWB_PA_All_Expenditure_Items_Vsat.sql
@NVWB_PA_Budget_Details_Base.sql
@NVWB_PA_Budget_Versions.sql
@NVWB_PA_Class_Categories_Vsat.sql
@NVWB_PA_Cost_Distribution_Lines.sql
@NVWB_PA_Exp_by_GLC_Vsat.sql
@NVWB_PA_Lov_Cost_Center_Vsat.sql
@NVWB_PA_Lov_Division_Vsat.sql
@NVWB_PA_Lov_Item_Desc_Vsat.sql
@NVWB_PA_Org_Labor_Expenditures.sql
@NVWB_PA_Prj_Class_Code_Vsat_Base.sql
@NVWB_PA_Proj_UBUE_Vsat.sql
@NVWB_PA_Project_Billings_Vsat.sql
@NVWB_PA_Project_Classes.sql
@NVWB_PA_Project_Parameters_Vsat.sql
@NVWB_PA_Projects.sql
@NVWB_PA_Rma_Class_Categories_Vsat.sql
@NVWB_PA_SLA_Cost_Dist.sql
@NVWB_PA_Tasks.sql
@NVWB_PA_UBUE_Recon_Vsat_Base.sql
@NVWB_PA_User_Projects_Vsat_Base.sql
@NVWB_PB_Invoice_Events.sql
@NVWB_PB_Revenue_Budgets.sql
@NVWB_PC_Project_Cost_Budgets.sql
@NVWB_PO_All_Distribution_Vsat.sql
@NVWB_PO_All_Lines_Vsat.sql
@NVWB_PO_All_Orders_Vsat.sql
@NVWB_PO_All_Shipments.sql
@NVWB_PO_Approved_Suppliers.sql
@NVWB_PO_Blanket_PO_Lines.sql
@NVWB_PO_Blanket_POs.sql
@NVWB_PO_Blanket_Releases.sql
@NVWB_PO_CM_Contract_Detail_Vsat.sql
@NVWB_PO_CM_Parties_Vsat.sql
@NVWB_PO_CM_Party_Contacts_Vsat.sql
@NVWB_PO_CM_Relationships_Vsat.sql
@NVWB_PO_Distn_All_Vsat_Base.sql
@NVWB_PO_End_To_End_Vsat.sql
@NVWB_PO_Expected_Receipts_Vsat.sql
@NVWB_PO_GT_Vendor_Sites_Vsat.sql
@NVWB_PO_ISupplier_Users_Vsat.sql
@NVWB_PO_Invoice_Hold_Details.sql
@NVWB_PO_Invoice_Payments.sql
@NVWB_PO_Invoices.sql
@NVWB_PO_LOV_Requestors_Vsat.sql
@NVWB_PO_Line_Notes.sql
@NVWB_PO_Line_Shipment_Vsat.sql
@NVWB_PO_MAC_Address_Vsat.sql
@NVWB_PO_Notes.sql
@NVWB_PO_On_Hold_Invoices.sql
@NVWB_PO_PO_Distributions.sql
@NVWB_PO_PO_Item_Lines.sql
@NVWB_PO_PO_Lines.sql
@NVWB_PO_PO_Shipments.sql
@NVWB_PO_Purch_Contracts_Vsat.sql
@NVWB_PO_Purchase_Orders.sql
@NVWB_PO_RSL_Not_Received_Vsat_Base.sql
@NVWB_PO_RTO_Receipts_Vsat.sql
@NVWB_PO_Rcv_Transactions_Vsat_Base.sql
@NVWB_PO_Receipts.sql
@NVWB_PO_Receipts_Vsat.sql
@NVWB_PO_Receiving_Inspection_Vsat.sql
@NVWB_PO_Release_Distributions.sql
@NVWB_PO_Release_Shipments.sql
@NVWB_PO_Releases.sql
@NVWB_PO_Req_Dist_POs_Vsat.sql
@NVWB_PO_Req_Distributions.sql
@NVWB_PO_Requisition_Line_Pos.sql
@NVWB_PO_Shipments_By_MO_Vsat_Base.sql
@NVWB_PO_Sup_Bus_Class_Vsat_Base.sql
@NVWB_PO_Uninvoiced_Receipts_Vsat.sql
@NVWB_PO_Vendor_Site_Banks.sql
@NVWB_PO_Vendor_Sites.sql
@NVWB_PO_Vendors.sql
@NVWB_PO_WO_Open_POs_Vsat.sql
@NVWB_QA_Audit_Details_Vsat.sql
@NVWB_QA_Audit_Details_Vsat_Base.sql
@NVWB_QA_Buyer_Alt_Approv_Vsat.sql
@NVWB_QA_CAR_DETAIL_VSAT_Base.sql
@NVWB_QA_Car_Detail_Vsat.sql
@NVWB_QA_Child_Attachments_Vsat.sql
@NVWB_QA_Corp_Quality_Metrics_Vsat.sql
@NVWB_QA_Depot_Fr_Vsat.sql
@NVWB_QA_Flex_Lookup_Vsat.sql
@NVWB_QA_Legacy_QIR_Vsat.sql
@NVWB_QA_NMR_CAR_Detail_Vsat.sql
@NVWB_QA_NMR_DETAIL_VSAT_Base.sql
@NVWB_QA_NMR_Det_Dispo_Vsat.sql
@NVWB_QA_NMR_Detail_Vsat.sql
@NVWB_QA_NMR_Legacy_Vsat.sql
@NVWB_QA_QAPP_CC_Vsat.sql
@NVWB_QA_QAPP_PN_Vsat.sql
@NVWB_QA_QAPP_Project_Vsat.sql
@NVWB_QA_QAPP_Supplier_Vsat.sql
@NVWB_QA_QA_Attachments_Vsat.sql
@NVWB_QA_QA_FR_Results_Vsat.sql
@NVWB_QA_Qir_Detail_Vsat.sql
@NVWB_QA_Qmss_Metrics_Vsat.sql
@NVWB_QA_Req_Apprv_Overrides_Vsat.sql
@NVWB_QA_Vprm_Rtn_Vsat.sql
@NVWB_WIP_All_Jobs.sql
@NVWB_WIP_All_Matrl_Requirements.sql
@NVWB_WIP_All_Matrl_Shortages.sql
@NVWB_WIP_All_Move_Transactions.sql
@NVWB_WIP_Detail_Vsat_Base.sql
@NVWB_WIP_Distribution_Vsat_Base.sql
@NVWB_WIP_Jobs.sql
@NVWB_WIP_Lov_Departments_Vsat.sql
@NVWB_WIP_Proj_Class_Code_Vsat_Base.sql
@NVWB_WIP_Routing_Resources.sql
@NVWB_WIP_Routings.sql
@NVWB_WIP_Routings_Hydra_QCP_Vsat.sql
@NVWB_WIP_Standard_Details_Vsat.sql
@NVWB_WIP_Total_Oper_Vsat_Base.sql
@NVWB_WIP_WIP_Status_Vsat.sql
@NVWB_BOM_Assemblies_PK.sql
@NVWB_CSD_Repair_Order_Notes_Vsat_PK.sql
@NVWB_CSD_Repair_Orders_PK.sql
@NVWB_CSI_Instances_PK.sql
@NVWB_CSI_Ser_Instl_Bse_Info_Vsat_PK.sql
@NVWB_HR_Emp_Assign_Hist_PK.sql
@NVWB_OE_RMA_Line_Details_Vsat_PK.sql
@NVWB_PA_All_Expenditure_Items_Vsat_PK.sql
@NVWB_PA_Exp_by_GLC_Vsat_PK.sql
@NVWB_PO_All_Distribution_Vsat_PK.sql
@NVWB_PO_All_Orders_Vsat_PK.sql
@NVWB_PO_CM_Contract_Detail_Vsat_PK.sql
@NVWB_PO_CM_Parties_Vsat_PK.sql
@NVWB_PO_GT_Vendor_Sites_Vsat_PK.sql
@NVWB_PO_Req_Dist_POs_Vsat_PK.sql
@NVWB_QA_Audit_Details_Vsat_PK.sql
@NVWB_QA_Car_Detail_Vsat_PK.sql
@NVWB_QA_NMR_Det_Dispo_Vsat_PK.sql
@NVWB_QA_NMR_Detail_Vsat_PK.sql
@NVWB_QA_Qir_Detail_Vsat_PK.sql
@NVWB_RA_Customers_PK.sql
@NVWB_BEN_Assignments_Vsat_FK.sql
@NVWB_BEN_Ben_Person_Vsat_FK.sql
@NVWB_BOM_Routing_Resources_FK.sql
@NVWB_BOM_Routings_FK.sql
@NVWB_CSD_OE_Repair_RMA_Orders_FK.sql
@NVWB_CSD_OE_Repair_RMA_Orders_Vsat_FK.sql
@NVWB_CSD_OE_Repair_Returns_Vsat_FK.sql
@NVWB_CSD_OE_Repair_Shipments_FK.sql
@NVWB_CSD_PO_Repair_Req_Orders_FK.sql
@NVWB_CSD_Repair_History_Vsat_FK.sql
@NVWB_CSD_Repair_Nmr_Details_Vsat_FK.sql
@NVWB_CSD_Repair_Notes_FK.sql
@NVWB_CSD_Repair_Order_Notes_Vsat_FK.sql
@NVWB_CSD_Repair_Warranty_Date_Vsat_FK.sql
@NVWB_CSD_WIP_Repair_Jobs_FK.sql
@NVWB_CSI_Instances_FK.sql
@NVWB_GL_Balances_Vsat_FK.sql
@NVWB_GL_Je_Lines_Vsat_FK.sql
@NVWB_HR_EI_US_Eth_Orign_Hist_Vsat_FK.sql
@NVWB_HR_Emp_Sal_Pro_Current_FK.sql
@NVWB_HR_SI_Typ_Vsat_Edu_Hist_Vsat_FK.sql
@NVWB_HR_SI_Type_FK.sql
@NVWB_HR_Valid_Grades_FK.sql
@NVWB_INV_Cycle_Count_Apprv_Vsat_FK.sql
@NVWB_INV_Cycle_Count_Trans_Vsat_FK.sql
@NVWB_INV_Onhand_Last_Used_Vsat_FK.sql
@NVWB_INV_REQ_By_Prod_Line_Vsat_FK.sql
@NVWB_INV_Serial_Numbers_Vsat_FK.sql
@NVWB_OE_RMA_Line_Details_Vsat_FK.sql
@NVWB_OKS_SContract_Summary_FK.sql
@NVWB_OKS_Scs_Base_Data_Vsat_FK.sql
@NVWB_OKS_Scs_Data_Vsat_FK.sql
@NVWB_PA_All_Expenditure_Items_Vsat_FK.sql
@NVWB_PA_Class_Categories_Vsat_FK.sql
@NVWB_PA_Exp_by_GLC_Vsat_FK.sql
@NVWB_PA_Rma_Class_Categories_Vsat_FK.sql
@NVWB_PO_All_Distribution_Vsat_FK.sql
@NVWB_PO_Blanket_PO_Lines_FK.sql
@NVWB_PO_CM_Parties_Vsat_FK.sql
@NVWB_PO_CM_Party_Contacts_Vsat_FK.sql
@NVWB_PO_CM_Relationships_Vsat_FK.sql
@NVWB_PO_Expected_Receipts_Vsat_FK.sql
@NVWB_PO_GT_Vendor_Sites_Vsat_FK.sql
@NVWB_PO_ISupplier_Users_Vsat_FK.sql
@NVWB_PO_RTO_Receipts_Vsat_FK.sql
@NVWB_PO_Receipts_Vsat_FK.sql
@NVWB_PO_Req_Dist_POs_Vsat_FK.sql
@NVWB_PO_Vendor_Sites_FK.sql
@NVWB_PO_Vendors_FK.sql
@NVWB_QA_Child_Attachments_Vsat_FK.sql
@NVWB_QA_NMR_Detail_Vsat_FK.sql
@NVWB_QA_QA_Attachments_Vsat_FK.sql
@NVWB_WIP_Routings_FK.sql
@NVWB_WIP_Routings_Hydra_QCP_Vsat_FK.sql





-- custom joins


@ENG_Role_And_Subject_Area_u2.sql;

@GT_Role_And_Subject_Area_u2.sql;
@hr_emp_asg_details_u2.sql;

@hr_si_type_u2.sql;

@hr_emp_sal_pro_current_u2.sql;

@OE_Project_Vsat_Base_upd.sql;

@ben_ben_person_vsat.sql;

@ben_assignments_vsat.sql;

@ben_ben_costs_vsat.sql;

@ben_ben_costs01_vsat.sql;

@oks_scs_data_vsat_u2.sql;

@pa_user_projects_vsat.sql

--@HR_Emp_Sal_Pro_Current_Vsat.sql;

@Ben_Ben_Costs_Vsat_New.sql;

@INV_OH_SS_MRP_Attributes_Vsat_u2.sql;

@hr_all_organization_units_upd_u2.sql;

@suppress_project_security_u2.sql

@MRP_Onhand_Quantity_Vsat_u2.sql;

@inv_lot_details_u2.sql;

@equi_to_outer_joins_upd_u2.sql;

@po_po_distributions_u2.sql;

@HR_EI_Asg_Ben_Derived_u2.sql;

@OE_Line_Details_Proj_u2.sql;

@OE_Lines_Proj_u2.sql;

@OE_Orders_Proj_u2.sql;

@OE_RMA_Line_Details_Vsat_Proj_u2.sql;

@OE_Shipments_by_Mo_Vsat_Proj_u2.sql;

@QA_Depot_Fr_Vsat_Proj_u2.sql;

@QA_NMR_Detail_Vsat_Proj_u2.sql;

@QA_NMR_Legacy_Vsat_Proj_u2.sql;

@OE_Line_Details_Task_u2.sql;

@OE_Lines_Task_u2.sql;


@OE_Line_Details_Proj_Class_u2.sql;

@OE_Lines_Proj_Class_u2.sql;

@OE_Orders_Proj_Class_u2.sql;

@OE_RMA_Line_Details_Vsat_Proj_Class_u2.sql;

@OE_Shipments_by_Mo_Vsat_Proj_Class_u2.sql;

@QA_Depot_Fr_Vsat_Proj_Class_u2.sql;

@QA_NMR_Detail_Vsat_Proj_Class_u2.sql;

@QA_NMR_Legacy_Vsat_Proj_Class_u2.sql;

@oks_scs_data_vsat_proj_class_u2.sql;
@oks_scs_base_data_vsat_proj_class_u2.sql;

@GL_Je_SLA_AP_Inv_Dist_All_Je_Lines_u2.sql;

@OE_RMA_Line_Details_Vsat_QA_Nmr_u2.sql;


@OE_RMA_Line_Details_Vsat_Scs_Base_u2.sql;

@OE_RMA_Line_Details_Vsat_Scs_Data_u2.sql;

@OE_RMA_Line_Details_Vsat_Ser_Instl_Base_u2.sql;

@OE_Shipments_By_Mo_Vsat_Scs_Base_u2.sql;

@OE_Shipments_By_Mo_Vsat_Scs_Data_u2

@OE_Shipments_By_Mo_Vsat_Ser_Instl_Base_u2.sql;


@OE_Line_Details_Proj_Class_Cat_u2.sql;

@OE_Lines_Proj_Class_Cat_u2.sql;

@OE_Orders_Proj_Class_Cat_u2.sql;

@OE_RMA_Line_Details_Vsat_Proj_Class_Cat_u2.sql;

@OE_Shipments_by_Mo_Vsat_Proj_Class_Cat_u2.sql;

@QA_Depot_Fr_Vsat_Proj_Class_Cat_u2.sql;

@QA_NMR_Detail_Vsat_Proj_Class_Cat_u2.sql;

@QA_NMR_Legacy_Vsat_Proj_Class_Cat_u2.sql;

@oks_scs_data_vsat_proj_class_Cat_u2.sql;

@oks_scs_base_data_vsat_proj_class_cat_u2.sql;

@OE_RMA_Line_Details_Vsat_Task_u2.sql;

@OE_Shipments_by_Mo_Vsat_Task_u2.sql;

@ben_ben_costs02_vsat.sql;


@po_receipts_blanket_pos_u2.sql;

@po_receipts_blanket_po_lines_u2.sql;

@po_receipts_release_distributions_u2.sql;

@po_receipts_releases_u2.sql;

@po_receipts_release_shipments_u2.sql;


@qa_qir_detail_vsat_nmr_u2.sql;

@qa_nmr_detail_vsat_car_u2.sql;


@oe_rma_line_detail_vsat_all_exp_u2.sql;

@oks_scs_base_data_vsat_repair_notes_u2.sql;

@oks_scs_data_vsat_repair_notes_u2.sql;

@n_ben_open_enrollments.sql;

@n_ben_monthly_medical_vsat.sql;


@pa_budget_versions_pa_projects_u2.sql;

@qa_audit_detail_vsat_car_u2.sql;


@po_blanket_pos_and_lines_u2.sql;

@po_blanket_po_lines_and_rel_shipments_u2.sql;

@po_blanket_po_lines_and_rel_distributions_u2.sql;

@po_releases_and_rel_distributions_u2.sql;

@po_releases_and_rel_shipments_u2.sql;



@po_approved_suppliers_and_vendors_u2.sql;
@po_approved_suppliers_and_vendor_sites_u2.sql;
@AP_Invoices_And_Checks_Join_Upd_u2.sql;
@INV_Forecasts_Items_u2.sql;
@PO_All_Dist_WIP_Entities_u2.sql;
@PO_All_Distr_Vsat_Join_Key_Update.sql;
@AP_Suppliers_Dff_U2.sql;
@PO_All_Orders_Vsat_Vendors_u2
.sql;
@PO_All_Lines_Vsat_Vendors_u2.sql;
@B78207PO_Purchase_Orders.sql;
@PO_All_Orders_Vsat_u2.sql;

@PO_Order_Lines_u2.sql;
@PO_Order_Line_Locations_u2.sql;
@PO_Order_Distributions_u2.sql;
@PO_Order_Receipts_u2.sql;
@PO_Lines_Line_Locations_u2.sql;
@PO_Lines_Distributions_u2.sql;
@PO_Lines_Receipts_u2.sql;
@PO_Line_Locations_Receipts_u2.sql;
@PO_Distributions_Receipts_u2.sql;
@PO_Distributions_RTO_Receipts_u2;
@PO_Line_Locations_Distributions_u2.sql;

@CSD_OE_Repair_Shipment_Orders_u2.sql;
@CSD_Repair_Nmr_Details_Vsat_Orders_u2.sql;
@CSD_Repair_History_Vsat_Orders_u2.sql;
@CSD_Repair_Warranty_Date_Vsat_Orders_u2.sql;
@CSD_OE_Repair_RMA_Orders_Orders_u2.sql;
@CSD_OE_Repair_RMA_Orders_Vsat_Orders_u2.sql;
@CSD_PO_Repair_Req_Orders_Orders_u2.sql;
@CSD_Repair_Notes_Orders_u2.sql;
@CSD_WIP_Repair_Jobs_Orders_u2.sql;
@CSD_OE_Repair_Returns_Vsat_Orders_u2.sql;
@CSD_Repair_Order_Services_Orders_u2.sql;

@PJM_ledger_id.sql

@BNV1646.sql

@subject_area_folders_cs.sql
@subject_area_folders_gl.sql
@subject_area_folders_inv.sql
@subject_area_folders_oe.sql
@subject_area_folders_pa.sql
@subject_area_folders_qa.sql

@subject_area_folders_wip.sql
@subject_area_folders_po.sql
@subject_area_folders_oke.sql

@BNV1881.sql

@Finance_Role_For_Service.sql

WHENEVER OSERROR CONTINUE;

WHENEVER SQLERROR CONTINUE;

