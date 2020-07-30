@utlspon N_SOX_EAC_CHANGES_VSAT

CREATE OR REPLACE VIEW NOETIX_VIEWS.N_SOX_EAC_CHANGES_VSAT
AS
   SELECT ppa.segment1 project,
          ppa.name,
          ppa.project_status_code,
          ppa.project_type,
          ppc.class_code product_line,
          ppc.description pl_desc,
          hou.name proj_org,
          ppc.attribute2 pl_business_unit,
          TRUNC (ppa.creation_date) creation_date,
          TRUNC (ppa.start_date) start_date,
          TRUNC (ppa.completion_date) completion_date,
          ppa.carrying_out_organization_id project_organization,
          prev_qtr.burdened_cost prev_qtr_eac,
          curr_qtr.burdened_cost curr_qtr_eac,
          ABS (prev_qtr.burdened_cost - curr_qtr.burdened_cost) difference
     FROM apps.pa_projects_all ppa,
          apps.pa_project_types_all pta,
          apps.pa_project_classes ppcl,
          apps.pa_class_codes ppc,
          apps.per_people_x ppx,
          apps.hr_organization_units hou,
          (SELECT pbv2.burdened_cost, pbv2.project_id
             FROM apps.pa_budget_versions pbv2
            WHERE pbv2.budget_version_id =
                     (SELECT MAX (pbv3.budget_version_id)
                        FROM apps.pa_budget_versions pbv3
                       WHERE pbv3.project_id = pbv2.project_id
                             AND pbv2.approved_cost_plan_type_flag =
                                    pbv3.approved_cost_plan_type_flag)
                  AND pbv2.approved_cost_plan_type_flag = 'Y') prev_qtr,
          (SELECT pbv2.burdened_cost, pbv2.project_id
             FROM apps.pa_budget_versions pbv2
            WHERE pbv2.budget_version_id =
                     (SELECT MAX (pbv3.budget_version_id)
                        FROM apps.pa_budget_versions pbv3
                       WHERE pbv3.project_id = pbv2.project_id
                             AND pbv2.approved_cost_plan_type_flag =
                                    pbv3.approved_cost_plan_type_flag)
                  AND pbv2.approved_cost_plan_type_flag = 'Y') curr_qtr
    WHERE     ppa.project_type = pta.project_type
          AND ppcl.class_category = ppc.class_category(+)
          AND ppcl.class_code = ppc.class_code(+)
          AND ppx.person_id(+) = ppc.attribute5
          AND ppa.project_id = ppcl.project_id(+)
          AND ppcl.class_category(+) = 'Product Line'
          AND ppa.carrying_out_organization_id = hou.organization_id
          AND ppa.template_flag <> 'Y'
          AND curr_qtr.project_id = ppa.project_id
          AND ppa.project_type <> 'CIP'
          AND prev_qtr.project_id(+) = ppa.project_id;
/

@utlspoff