@utlspon SOX_Consumer_Role_For_OBIEE

insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select 'SOX',        -- application_label
       -999,            -- application_id
       'N',             -- base_application
       'S',             -- install_status
       'S',             -- oracle_install_status
       '0',             -- application_instance
       -999,            -- oracle id
       '&NOETIX_USER',  -- oracle user name
       null,            -- set_of_books_id
       null,            -- set_of_books_name
       null,            -- organization_id
       null,            -- organization_name
       null,            -- chart_of_accounts_id
       'SOX'          -- role_prefix
  from dual
 where not exists 
       ( select null
           from n_application_owners
          where application_label = 'SOX' );


Insert into N_ROLE_TEMPLATES
   (ROLE_LABEL, APPLICATION_LABEL, META_DATA_TYPE, DESCRIPTION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('VSAT_SOX_CONSUMER_ROLE', 'SOX', 'Views', 'SOX Control Views (For SOX Users)', 
    'NOETIX', TO_DATE('05/01/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), '090102', TO_DATE('10/01/2002 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), '1.0.0', '6.3.0.1272');

COMMIT;

/*

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('VSAT_SOX_CONSUMER_ROLE', 'CSD_Repair_Orders', '*', 'Y', 
    'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'), 'nemuser', TO_DATE('12/22/2014 05:24:05', 'MM/DD/YYYY HH24:MI:SS'));

*/

@utlspoff
