@checkVersionCompatibility.sql '6.5.1'  '6.5.1'

ALTER TABLE n_view_column_templates DROP CONSTRAINT N_VIEW_COLUMN_TEMPLATES_C4;
ALTER TABLE n_view_column_templates ADD CONSTRAINT N_VIEW_COLUMN_TEMPLATES_C4 CHECK( 
                      (    (    column_type IN 
                                    ('EXPR','INLINE','GENEXPR','CONST','SEGEXPR','ATTREXPR','HINT')
                             OR (     column_type IN ( 'ALOOK','LOOKDESC','LOOK', 'AUTOJOIN' ) 
                                  AND (    column_expression LIKE '%''%' 
                                        OR column_expression LIKE '%(%' 
                                        OR column_expression LIKE '%.%' 
                                        OR TRIM(UPPER(column_expression)) = 'NULL' ) ) ) 
                        OR table_alias is not null ) );

ALTER TABLE n_view_columns DROP CONSTRAINT N_VIEW_COLUMNS_C7;
ALTER TABLE n_view_columns ADD CONSTRAINT N_VIEW_COLUMNS_C7 CHECK ( 
                      (    (    column_type IN 
                                    ('EXPR','INLINE','GENEXPR','CONST','SEGEXPR','ATTREXPR','HINT')
                             OR (     column_type IN ( 'ALOOK','LOOKDESC','LOOK', 'AUTOJOIN' ) 
                                  AND (    column_expression LIKE '%''%' 
                                        OR column_expression LIKE '%(%' 
                                        OR column_expression LIKE '%.%' 
                                        OR TRIM(UPPER(column_expression)) = 'NULL' ) ) ) 
                        OR table_alias is not null ) );


ALTER TABLE N_VIEW_COLUMNS DROP CONSTRAINT N_VIEW_COLUMNS_C8;
ALTER TABLE N_VIEW_COLUMNS ADD CONSTRAINT N_VIEW_COLUMNS_C8 CHECK (segment_qualifier in ('GL_ACCOUNT','GL_BALANCING','GL_INTERCOMPANY','GL_SECONDARY_TRACKING','GL_GLOBAL','FA_COST_CTR','NONE'));
