## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_stage" "deploy_to_instances" {
    defined_tags                       =  { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_artifact_ids                = []
    deploy_environment_id_a            = oci_devops_deploy_environment.blue_deploy_environment.id
    deploy_environment_id_b            = oci_devops_deploy_environment.green_deploy_environment.id
    deploy_pipeline_id                 = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                  = "COMPUTE_INSTANCE_GROUP_BLUE_GREEN_DEPLOYMENT"
    deployment_spec_deploy_artifact_id = oci_devops_deploy_artifact.test_deploy_artifact.id
    description                        = var.bluegreen_deploy_stage_description
    display_name                       = var.bluegreen_deploy_stage_name
    freeform_tags                      = {}
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
        }
    }

    production_load_balancer_config {
        backend_port     = var.loadbalancer_backendset_port
        listener_name    = var.loadbalancer_listner_name
        load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    }

    rollout_policy {
        batch_count            = 0
        batch_delay_in_seconds = var.batch_delay_in_seconds
        batch_percentage       = 1
        policy_type            = "COMPUTE_INSTANCE_GROUP_LINEAR_ROLLOUT_POLICY_BY_PERCENTAGE"
        ramp_limit_percent     = 0
    }
}

resource "oci_devops_deploy_stage" "approval_stage" {
    defined_tags       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type  = "MANUAL_APPROVAL"
    description        = var.approval_stage_description
    display_name       = var.approval_display_name
    freeform_tags      = {}
    
    approval_policy {
        approval_policy_type         = "COUNT_BASED_APPROVAL"
        number_of_approvals_required = var.approval_count
    }

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.deploy_to_instances.id
        }
    }
}

  
resource "oci_devops_deploy_stage" "blue_green_switch" {
    compute_instance_group_blue_green_deployment_deploy_stage_id = oci_devops_deploy_stage.deploy_to_instances.id
    defined_tags                                                 = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id                                           = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                                            = "COMPUTE_INSTANCE_GROUP_BLUE_GREEN_TRAFFIC_SHIFT"
    description                                                  = var.blue_green_stage_shift_description
    display_name                                                 = var.blue_green_stage_shift_name
    freeform_tags                                                = {}
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.approval_stage.id
        }
    }

}