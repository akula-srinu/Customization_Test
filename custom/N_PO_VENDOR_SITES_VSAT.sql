@utlspon N_PO_VENDOR_SITES_VSAT

CREATE OR REPLACE VIEW N_PO_VENDOR_SITES_VSAT
AS
     SELECT c.vendor_name,
            c.segment1 vendor_number,
            b.vendor_site_code,
            b.address_line1,
            b.city,
            b.state,
            b.zip,
            TO_DATE(NULL) creation_date,
            d.user_name,
            TRUNC (a.audit_timestamp) audit_time_stamp,
            'Current' transaction_type
       FROM ap.ap_supplier_sites_all_a a,
            ap.ap_supplier_sites_all b,
            ap.ap_suppliers c,
            applsys.fnd_user d
      WHERE     a.vendor_site_id = b.vendor_site_id
            AND b.vendor_id = c.vendor_id
            AND b.last_updated_by = d.user_id
   GROUP BY c.vendor_name,
            c.segment1,
            b.vendor_site_code,
            b.address_line1,
            b.city,
            b.state,
            b.zip,
            b.last_update_date,
            d.user_name,
            a.audit_timestamp
   UNION ALL
   SELECT c.vendor_name,
          c.segment1 vendor_number,
          b.vendor_site_code,
          DECODE (a.audit_transaction_type,
                  'I', b.address_line1,
                  a.address_line1)
             address_line1,
          DECODE (a.audit_transaction_type, 'I', b.city, a.city) city,
          DECODE (a.audit_transaction_type, 'I', b.state, a.state) state,
          DECODE (a.audit_transaction_type, 'I', b.zip, a.zip) zip,
          a.audit_timestamp,
          a.audit_user_name,
          TRUNC (a.audit_timestamp) audit_time_stamp,
          DECODE (a.audit_transaction_type,
                  'I', 'Insert',
                  'U', 'Update',
                  'D', 'Delete',
                  NULL)
             transaction_type
     FROM ap.ap_supplier_sites_all_a a,
          ap.ap_supplier_sites_all b,
          ap.ap_suppliers c
    WHERE a.vendor_site_id = b.vendor_site_id AND b.vendor_id = c.vendor_id;
/

@utlspoff