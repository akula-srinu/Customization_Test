-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_shipments_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Deliverable_Shipments', 'What are the shipment details of given project contract deliverable?', 'Select the Contract_Number, Contract_Line_Number, Deliverable_Number, Bill_Of_Lading_Number, Actual_Shipping_Date, Packing_Slip_Number, Requested_Quantity, Canceled_Quantity, Shipped_Quantity, Ship_From_Location, and Ship_To_Location columns from this view. Filter the records by the Contract_Number, and Deliverable_Number columns.', 'OKE_11510_ONWARDS', '11.5+', 'pvemuru', TO_DATE('07/20/2008 23:28:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/21/2008 01:50:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 3, 57441);

COMMIT;

@utlspoff