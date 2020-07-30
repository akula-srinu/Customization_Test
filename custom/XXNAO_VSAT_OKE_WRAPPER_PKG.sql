-- Purpose: APPS.XXNAO_VSAT_OKE_WRAPPER_PKG
--
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       ------------------------------------------
-- Srini Akula 08-Apr-19    Created with functions required for buyer activity (CDS-562)
--

CREATE OR REPLACE PACKAGE XXNAO_VSAT_OKE_WRAPPER_PKG
IS
  
   FUNCTION get_Contract_Number (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_additional_flowdowns (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_FFATA (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_dd254 (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_specialty_metals (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_sb_plan_required (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_CAS (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_TINA (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_consent_to_sub (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_award_class (p_project_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

   function get_dpas_number(pProjectId in number, p_org_id NUMBER) return varchar2;

   FUNCTION get_employee_full_name (p_employee_id IN NUMBER, p_date IN DATE)
      RETURN VARCHAR2;

   FUNCTION get_it_reviewed (p_req_header_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;
      
   FUNCTION get_info_template_value (p_req_header_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2;

END XXNAO_VSAT_OKE_WRAPPER_PKG;
/

CREATE OR REPLACE PACKAGE BODY XXNAO_VSAT_OKE_WRAPPER_PKG
IS
   
 FUNCTION get_Contract_Number (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN

      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_Contract_Number (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_Contract_Number: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;


   FUNCTION get_additional_flowdowns (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_additional_flowdowns (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_additional_flowdowns: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;


   FUNCTION get_FFATA (p_project_id NUMBER,p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_FFATA (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_FFATA: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;


   FUNCTION get_dd254 (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_dd254 (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_dd254: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;

   FUNCTION get_specialty_metals (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_specialty_metals (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_specialty_metals: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;


   FUNCTION get_sb_plan_required (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_sb_plan_required (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_sb_plan_required: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;



   FUNCTION get_CAS (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_CAS (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_CAS: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;



   FUNCTION get_TINA (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_TINA (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_TINA: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;


   FUNCTION get_consent_to_sub (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_consent_to_sub (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_consent_to_sub: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;

   FUNCTION get_award_class (p_project_id NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_project_id IS NOT NULL
      THEN
         RETURN VSAT_OKE_UTILS.get_award_class (p_project_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_award_class: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Project Id: '
                 || p_project_id);
   END;

   FUNCTION get_employee_full_name (p_employee_id IN NUMBER, p_date IN DATE)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      IF p_employee_id IS NOT NULL
      THEN
         RETURN vsat_hr_utils.get_employee_full_name (p_employee_id, p_date);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_employee_full_name: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Employee Id: '
                 || p_employee_id);
   END;



   FUNCTION get_it_reviewed (p_req_header_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_req_header_id IS NOT NULL
      THEN
         RETURN vsat_ame_utils.is_reviewed_po_category (
                   p_req_header_id);
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_it_reviewed: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Requisition header id: '
                 || p_req_header_id);
   END;
   
     FUNCTION get_info_template_value (p_req_header_id IN NUMBER, p_org_id NUMBER)
      RETURN VARCHAR2                            -- Added function for CDS-562
   IS
   BEGIN
      apps.mo_global.set_policy_context('S',p_org_id);
      IF p_req_header_id IS NOT NULL
      THEN
         RETURN vsat_po_utils.get_info_template_value(p_req_header_id,  'Measurement  '||'&'||' Test Equipment');
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN (   'Error - get_it_reviewed: '
                 || SQLCODE
                 || '-'
                 || SQLERRM
                 || '  for Requisition header id: '
                 || p_req_header_id);
   END;     

function get_dpas_number(pProjectId in number, p_org_id NUMBER) return varchar2 is
        l_dpas_rating varchar2(50);

        begin
            apps.mo_global.set_policy_context('S',p_org_id);
            select nvl(max(dpas_rating), null)
            into l_dpas_rating
            from 
                  (
                    --contract headers (direct link)
                    select 
                           eh.priority_code dpas_rating
                    from 
                           apps.oke_k_headers eh,
                           apps.okc_k_headers_b ch,
                           apps.okc_k_headers_b boa
                    where
                           ch.id = eh.k_header_id and
                           eh.boa_id = boa.id(+) and
                           eh.project_id = pProjectId
                    union
                    --contract headers (linked at line)
                    select 
                           eh.priority_code dpas_rating
                    from 
                           apps.oke_k_headers_full_v eh,
                           apps.okc_k_headers_b ch,
                           apps.okc_k_headers_b boa,
                           apps.oke_k_lines el,
                           apps.okc_k_lines_b cl
                    where
                           ch.id = eh.k_header_id and
                           cl.dnz_chr_id = eh.k_header_id and
                           eh.boa_id = boa.id(+) and
                           el.k_line_id = cl.id and
                           el.project_id = pProjectId 
                  );

            return l_dpas_rating;

        exception
                 when no_data_found then return null;
                when others then                      
                      return null;

        end;  

 

END XXNAO_VSAT_OKE_WRAPPER_PKG;
/