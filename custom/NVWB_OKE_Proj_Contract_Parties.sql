-- *******************************************************************************
-- FileName:             NVWB_OKE_Proj_Contract_Parties.sql
--
-- Date Created:         2019/Aug/28 06:12:39
-- Created By:           nemuser
--
-- Source:
-- - Package:            Package_2018_P11_B1_DEV_NEW
-- - Environment:        EBSPJD1
-- - NoetixViews Schema: NOETIX_VIEWS
--
-- Versions:
-- - Oracle EBS:   12.1.3
-- - Oracle DB:    11.2.0
-- - NoetixViews:  6.5.1
--
-- *******************************************************************************
-- output to NVWB_OKE_Proj_Contract_Parties.lst file

@utlspon NVWB_OKE_Proj_Contract_Parties

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1048;

INSERT INTO n_view_column_templates(
      view_label,
      query_position,
      column_label,
      table_alias,
      column_expression,
      column_position,
      column_type,
      description,
      ref_application_label,
      ref_table_name,
      key_view_label,
      ref_lookup_column_name,
      ref_description_column_name,
      ref_lookup_type,
      id_flex_application_id,
      id_flex_code,
      group_by_flag,
      format_mask,
      format_class,
      gen_search_by_col_flag,
      lov_view_label,
      lov_column_label,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'OKE_Proj_Contract_Parties',
      1.0,
      'Project_Contract_Customer_Name',
      null,
      '(SELECT prty.party_name   FROM ar.hz_parties prty,        ar.hz_cust_accounts acct,        ar.hz_cust_acct_sites_all asite,        ar.hz_cust_site_uses_all suse         WHERE     1 = 1        AND suse.site_use_id = prtyb.object1_id1        AND asite.cust_acct_site_id = suse.cust_acct_site_id        AND acct.cust_account_id = asite.cust_account_id        AND prty.party_id = acct.party_id    ) ',
      10.1,
      'EXPR',
      'Customer (Party) name of the project contract. Custom Field added by Zensar.',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      'N',
      null,
      'STRING',
      'N',
      null,
      null,
      null,
      '*',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );




INSERT INTO n_view_column_templates(
      view_label,
      query_position,
      column_label,
      table_alias,
      column_expression,
      column_position,
      column_type,
      description,
      ref_application_label,
      ref_table_name,
      key_view_label,
      ref_lookup_column_name,
      ref_description_column_name,
      ref_lookup_type,
      id_flex_application_id,
      id_flex_code,
      group_by_flag,
      format_mask,
      format_class,
      gen_search_by_col_flag,
      lov_view_label,
      lov_column_label,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'OKE_Proj_Contract_Parties',
      2.0,
      'Project_Contract_Customer_Name',
      null,
      '(SELECT prty.party_name   FROM ar.hz_parties prty,        ar.hz_cust_accounts acct,        ar.hz_cust_acct_sites_all asite,        ar.hz_cust_site_uses_all suse         WHERE     1 = 1        AND suse.site_use_id = prtyb.object1_id1        AND asite.cust_acct_site_id = suse.cust_acct_site_id        AND acct.cust_account_id = asite.cust_account_id        AND prty.party_id = acct.party_id    ) ',
      10.1,
      'EXPR',
      'Customer (Party) name of the project contract. Custom Field added by Zensar.',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      'N',
      null,
      'STRING',
      'N',
      null,
      null,
      null,
      '*',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff