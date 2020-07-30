-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon application_label_oke

update n_application_owner_templates
set	BASE_APPLICATION = 'Y',
        CONTEXT_CODE = 'OU',
        SINGLE_INSTANCES_ALLOWED = 'Y',
        SINGLE_INSTANCES_ENABLED = 'Y',
	XOP_INSTANCES_ALLOWED = 'Y',
	XOP_INSTANCES_ENABLED = 'Y',
	GLOBAL_INSTANCE_ALLOWED = 'Y',
	GLOBAL_INSTANCE_ENABLED = 'Y'
where application_label = 'OKE';


COMMIT;

@utlspoff