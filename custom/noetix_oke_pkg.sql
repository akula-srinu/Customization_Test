-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon noetix_oke_pkg

CREATE OR REPLACE PACKAGE noetix_oke_pkg AUTHID DEFINER is
  --
FUNCTION get_party_name(x_role_id      number)
RETURN VARCHAR2;

FUNCTION get_change_request_name--OKE_CHG_REQ_UTILS.Get_Chg_Request
  ( p_k_header_ID IN NUMBER
  , p_major_version IN NUMBER
  ) RETURN VARCHAR2;

FUNCTION get_shipped_quantity (p_item_id IN NUMBER,
                               p_uom_code IN VARCHAR2 ,
                               p_k_header_id NUMBER,
                               p_deliverable_id NUMBER
                              ) RETURN NUMBER;

FUNCTION get_term_values(p_term_code VARCHAR2, 
                         p_term_value_pk1 VARCHAR2,
			 p_term_value_pk2 VARCHAR2,
			 p_call_option VARCHAR2 )
RETURN VARCHAR2;

end  NOETIX_OKE_PKG;
/

CREATE OR REPLACE PACKAGE BODY noetix_oke_pkg is

FUNCTION get_party_name(x_role_id      number)
RETURN VARCHAR2
IS

l_party_name VARCHAR2(500);

BEGIN

   return APPS.XXNAO_OKE_WRAPPER_PKG.get_PARTY_NAME
                                            ( x_role_id);

END get_party_name;

FUNCTION get_change_request_name( p_k_header_ID NUMBER,
                                  p_major_version IN NUMBER
                                ) RETURN VARCHAR2
IS

BEGIN

   return APPS.XXNAO_OKE_WRAPPER_PKG.get_change_request_name
                                            ( p_k_header_ID, p_major_version );

 END get_change_request_name;

FUNCTION get_shipped_quantity (p_item_id IN NUMBER,
                               p_uom_code IN VARCHAR2 ,
                               p_k_header_id NUMBER,
                               p_deliverable_id NUMBER
                              ) RETURN NUMBER
IS

BEGIN

   return APPS.XXNAO_OKE_WRAPPER_PKG.get_shipped_quantity(p_item_id,p_uom_code,p_k_header_id,p_deliverable_id);

 END get_shipped_quantity;

 FUNCTION get_term_values(p_term_code VARCHAR2, 
                         p_term_value_pk1 VARCHAR2,
			 p_term_value_pk2 VARCHAR2,
			 p_call_option VARCHAR2 )
RETURN VARCHAR2
IS

BEGIN

   return APPS.XXNAO_OKE_WRAPPER_PKG.get_term_values(p_term_code, p_term_value_pk1, p_term_value_pk2, p_call_option );

 END get_term_values;

end NOETIX_OKE_PKG;
/

@utlspoff
