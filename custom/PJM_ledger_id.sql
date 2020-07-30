-- Title
--    PJM_ledger_id.sql
-- Function
--    Perform customer update sql processes
--    will be custom for each update release
--
-- Description
--    Do nothing for this release
--
-- Copyright Noetix Corporation 1992-2007  All Rights Reserved
--
-- History
--   20-Nov-94 D Cowles
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   24-Jan-02 D Glancy   Added note for the consultants and support as to the use
--                        for this script. Issue #4320.
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   28-Apr-16 N Mohan    provided this bug fix as part of 6.5.1 upgrade.

@utlspon PJM_ledger_id

update n_view_where_templates ab
set where_clause = replace(ab.where_clause, 'SOB.SET_OF_BOOKS_ID', 'SOB.LEDGER_ID'),
last_update_Date = sysdate,
last_updated_By = 'NoetixSupport'
where view_label in ( 'PJM_PO_Blanket_Releases',
'PJM_Project_Commitments',
'PJM_RFQ_Quotation_Details', 
'PJM_Req_PO_Invoices'  )
and where_clause like '%SOB.SET_OF_BOOKS_ID%';

commit;



@utlspoff


