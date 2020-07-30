-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon po_table_change

DECLARE
   
   cnt            NUMBER := 0;
   
BEGIN

   SELECT   COUNT(*)
   INTO     cnt
   FROM     n_view_table_changes_templates
   WHERE    table_name = 'PO_VENDOR_SITES_ALL';

   IF cnt = 0
   THEN
   
      INSERT INTO n_view_table_changes_templates
                  (
                  table_name, 
                  new_table_name, 
                  product_version,
                  created_by,
                  creation_date,
                  last_updated_by,
                  last_update_date,
                  application_label, 
                  new_application_label
                  )
           VALUES   (
                    'PO_VENDOR_SITES_ALL', 
                    'AP_SUPPLIER_SITES_ALL', 
                    '12+',
                    'DGlancy',
                    TO_DATE ('10/02/2007 09:58:00', 'MM/DD/YYYY HH24:MI:SS'),
                    'DEVTEMPLATES1',
                    TO_DATE ('10/30/2007 06:57:26', 'MM/DD/YYYY HH24:MI:SS'),
                    'PO', 
                    'AP'
                  );

      COMMIT;
      
   END IF;
   
END;
/

@utlspoff