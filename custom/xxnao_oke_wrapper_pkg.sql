-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon xxnao_oke_wrapper_pkg 

CREATE OR REPLACE PACKAGE XXNAO_OKE_WRAPPER_PKG authid definer is

FUNCTION get_party_name(x_role_id      number  )
RETURN VARCHAR2;

FUNCTION get_change_request_name
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

end  XXNAO_OKE_WRAPPER_PKG;
/

CREATE OR REPLACE PACKAGE BODY XXNAO_OKE_WRAPPER_PKG is

FUNCTION get_party_name (x_role_id      NUMBER )
RETURN varchar2
IS
   cursor c_num
   is
      SELECT object1_id1,
             object1_id2,
             jtot_object1_code,
             rle_code
      FROM   okc.okc_k_party_roles_b
      WHERE  id = x_role_id;

   cursor c_party_table(l_object varchar2)
   is
      select from_table,
             where_clause
      from   jtf.jtf_objects_b
      where  object_code = l_object;

   l_num            c_num%ROWTYPE;
   l_name              c_party_table%ROWTYPE;
   l_code              varchar2(50);
   i                   number := 0;
   l_str           varchar2(10000);
   l_cur_hd            number;
   l_id1           varchar2(40);
   l_id2           varchar2(200);
   l_row_processed     number;
   l_party_name        varchar2(360);
   l_party_desc        varchar2(360);
   x_party_name        varchar2(360);

BEGIN

BEGIN

    OPEN c_num;
    FETCH C_NUM INTO L_NUM;

        l_code := l_num.jtot_object1_code;
        l_id1  := l_num.object1_id1;

        if (l_num.object1_id2 <> '#') then
           l_id2  := l_num.object1_id2;
        end if;

    CLOSE C_NUM;

       open c_party_table(l_code);
       fetch c_party_table into l_name;
       close c_party_table;

    l_str := 'select name, description from ' || l_name.from_table
                || ' where id1 = :id1';

       if (l_id2 is not null) then
          l_str := l_str || ' and   id2 = :id2';
       end if;

       if (l_code in ('OKX_NOLOV','OKX_INVENTORY','OKX_OPERUNIT') and l_name.where_clause is not null) then
          l_str := l_str || ' and ' || l_name.where_clause;
       end if;

--DBMS_OUTPUT.PUT_LINE (L_STR);
       l_cur_hd := dbms_sql.open_cursor;

       dbms_sql.parse(l_cur_hd, l_str, dbms_sql.native);

       dbms_sql.bind_variable(l_cur_hd, 'id1', to_number(l_id1));

       if (l_id2 is not null) then
          dbms_sql.bind_variable(l_cur_hd, 'id2', to_number(l_id2));
       end if;

       dbms_sql.define_column(l_cur_hd, 1, l_party_name, 360);
       dbms_sql.define_column(l_cur_hd, 2, l_party_desc, 360);
       l_row_processed := dbms_sql.execute(l_cur_hd);

       loop
         if dbms_sql.fetch_rows(l_cur_hd) > 0 then
            dbms_sql.column_value(l_cur_hd, 1, l_party_name);
            dbms_sql.column_value(l_cur_hd, 2, l_party_desc);
         else
            exit;
         end if;

       end loop;

    x_party_name := l_party_name||'~'||l_party_desc;

       dbms_sql.close_cursor(l_cur_hd);

EXCEPTION
   when OTHERS then
        x_party_name := null;
END;

RETURN x_party_name;

end get_party_name;

FUNCTION get_change_request_name( p_k_header_ID NUMBER,
                                  p_major_version IN NUMBER
                                ) RETURN VARCHAR2
IS

l_chg_request_name VARCHAR2(1000);
l_chg_request_sts varchar2(1000);

BEGIN
    OKE_CHG_REQ_UTILS.Get_Chg_Request(p_k_header_ID, p_major_version,l_chg_request_name, l_chg_request_sts, 'Y');

    return l_chg_request_name;
 EXCEPTION
    WHEN OTHERS THEN return NULL;
 END get_change_request_name;

FUNCTION get_shipped_quantity (p_item_id IN NUMBER,
                               p_uom_code IN VARCHAR2 ,
                               p_k_header_id NUMBER,
                               p_deliverable_id NUMBER
                              ) RETURN NUMBER
IS

l_shipped_quantity NUMBER;

BEGIN

   if  p_item_id is null
   then
         SELECT SUM(dlv.SHIPPED_QUANTITY)
         into l_shipped_quantity
         FROM wsh.wsh_delivery_details dlv
         WHERE dlv.Source_Code = 'OKE'
         AND dlv.Source_Header_ID = p_k_header_id
         AND dlv.Source_Line_ID = p_deliverable_id;

   else
         SELECT SUM(ROUND(INV_CONVERT.Inv_Um_Convert(p_item_id
                    , 5
                    , NVL(dlv1.Shipped_Quantity, 0)
                    , Requested_Quantity_Uom
                    , p_uom_code
                    , NULL
                    , NULL), 5))
         INTO l_shipped_quantity
         FROM wsh.wsh_delivery_details dlv1
	    WHERE dlv1.Source_Code = 'OKE'
          AND dlv1.Source_Header_ID = p_k_header_id
          AND dlv1.Source_Line_ID = p_deliverable_id;

   end if;

   RETURN l_shipped_quantity;

EXCEPTION
        WHEN OTHERS THEN return NULL;

END get_shipped_quantity;

FUNCTION get_term_values(p_term_code VARCHAR2, 
                         p_term_value_pk1 VARCHAR2,
			 p_term_value_pk2 VARCHAR2,
			 p_call_option VARCHAR2 )
RETURN VARCHAR2
IS

l_term_value varchar2(240);

BEGIN

l_term_value := OKE_UTILS.GET_TERM_VALUES (p_term_code, 
					   p_term_value_pk1,
					   p_term_value_pk2,
					   p_call_option);

RETURN l_term_value;

END get_term_values;

END  XXNAO_OKE_WRAPPER_PKG;
/

@utlspoff
