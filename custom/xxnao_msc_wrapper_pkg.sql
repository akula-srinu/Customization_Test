-- 28-Jul-2015 Srinivas Akula Created.

define APPS_USERID    = APPS
define APPS_CONNECT   = NONE
define STAGE4_CONNECT = N
column C_APPS_USERID    new_value APPS_USERID    noprint
column C_APPS_CONNECT   new_value APPS_CONNECT   noprint
column C_STAGE4_CONNECT new_value STAGE4_CONNECT noprint
select distinct 
       ou.oracle_username           C_APPS_USERID,
       '\&PW_'||ou.oracle_username  C_APPS_CONNECT,
       decode( user,
               ou.oracle_username, 'N',
               'Y' )                C_STAGE4_CONNECT
  from fnd_oracle_userid  ou
 where read_only_flag = 'U';

@utlspon xxnao_msc_wrapper_pkg 

CREATE OR REPLACE PACKAGE XXNAO_MSC_WRAPPER_PKG
   AUTHID DEFINER
IS
   FUNCTION action (i_arg_source_table              IN VARCHAR2,
                    i_arg_bom_item_type             IN NUMBER DEFAULT NULL,
                    i_arg_base_item_id              IN NUMBER DEFAULT NULL,
                    i_arg_wip_supply_type           IN NUMBER DEFAULT NULL,
                    i_arg_order_type                IN NUMBER DEFAULT NULL,
                    i_arg_rescheduled_flag          IN NUMBER DEFAULT NULL,
                    i_arg_disposition_status_type   IN NUMBER DEFAULT NULL,
                    i_arg_new_due_date              IN DATE   DEFAULT NULL,
                    i_arg_old_due_date              IN DATE   DEFAULT NULL,
                    i_arg_implemented_quantity      IN NUMBER DEFAULT NULL,
                    i_arg_quantity_in_process       IN NUMBER DEFAULT NULL,
                    i_arg_quantity_rate             IN NUMBER DEFAULT NULL,
                    i_arg_release_time_fence_code   IN NUMBER DEFAULT NULL,
                    i_arg_reschedule_days           IN NUMBER DEFAULT NULL,
                    i_arg_firm_quantity             IN NUMBER DEFAULT NULL,
                    i_arg_plan_id                   IN NUMBER DEFAULT NULL,
                    i_arg_critical_component        IN NUMBER DEFAULT NULL,
                    i_arg_mrp_planning_code         IN NUMBER DEFAULT NULL,
                    i_arg_lots_exist                IN NUMBER DEFAULT NULL,
                    i_arg_part_condition            IN NUMBER DEFAULT NULL,
                    i_arg_trx_id                    IN NUMBER DEFAULT NULL)
      RETURN VARCHAR2;
END XXNAO_MSC_WRAPPER_PKG;
/

CREATE OR REPLACE PACKAGE BODY XXNAO_MSC_WRAPPER_PKG
IS
   FUNCTION action (i_arg_source_table              IN VARCHAR2,
                    i_arg_bom_item_type             IN NUMBER DEFAULT NULL,
                    i_arg_base_item_id              IN NUMBER DEFAULT NULL,
                    i_arg_wip_supply_type           IN NUMBER DEFAULT NULL,
                    i_arg_order_type                IN NUMBER DEFAULT NULL,
                    i_arg_rescheduled_flag          IN NUMBER DEFAULT NULL,
                    i_arg_disposition_status_type   IN NUMBER DEFAULT NULL,
                    i_arg_new_due_date              IN DATE   DEFAULT NULL,
                    i_arg_old_due_date              IN DATE   DEFAULT NULL,
                    i_arg_implemented_quantity      IN NUMBER DEFAULT NULL,
                    i_arg_quantity_in_process       IN NUMBER DEFAULT NULL,
                    i_arg_quantity_rate             IN NUMBER DEFAULT NULL,
                    i_arg_release_time_fence_code   IN NUMBER DEFAULT NULL,
                    i_arg_reschedule_days           IN NUMBER DEFAULT NULL,
                    i_arg_firm_quantity             IN NUMBER DEFAULT NULL,
                    i_arg_plan_id                   IN NUMBER DEFAULT NULL,
                    i_arg_critical_component        IN NUMBER DEFAULT NULL,
                    i_arg_mrp_planning_code         IN NUMBER DEFAULT NULL,
                    i_arg_lots_exist                IN NUMBER DEFAULT NULL,
                    i_arg_part_condition            IN NUMBER DEFAULT NULL,
                    i_arg_trx_id                    IN NUMBER DEFAULT NULL)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN &APPS_USERID..MSC_GET_NAME.ACTION (
                i_arg_source_table,
                i_arg_bom_item_type,
                i_arg_base_item_id,
                i_arg_wip_supply_type,
                i_arg_order_type,
                i_arg_rescheduled_flag,
                i_arg_disposition_status_type,
                i_arg_new_due_date,
                i_arg_old_due_date,
                i_arg_implemented_quantity,
                i_arg_quantity_in_process,
                i_arg_quantity_rate,
                i_arg_release_time_fence_code,
                i_arg_reschedule_days,
                i_arg_firm_quantity,
                i_arg_plan_id,
                i_arg_critical_component,
                i_arg_mrp_planning_code,
                i_arg_lots_exist,
                i_arg_part_condition,
                i_arg_trx_id);
   END action;
END XXNAO_MSC_WRAPPER_PKG;
/
@utlspoff
