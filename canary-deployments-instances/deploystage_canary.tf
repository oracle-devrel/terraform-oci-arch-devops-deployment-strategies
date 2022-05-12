## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_stage" "deploy_to_instances" {
    compute_instance_group_deploy_environment_id = oci_devops_deploy_environment.canary_deploy_environment.id
    defined_tags                                 = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_artifact_ids                          = []
    deploy_pipeline_id                           = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                            = "COMPUTE_INSTANCE_GROUP_CANARY_DEPLOYMENT"
    deployment_spec_deploy_artifact_id           = oci_devops_deploy_artifact.test_deploy_artifact.id
    description                                  = var.canary_deploy_stage_description
    display_name                                 = var.canary_deploy_stage_name
    freeform_tags                                = {}
    
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
        }
    }

    production_load_balancer_config {
        backend_port     = var.loadbalancer_backendset_port
        listener_name    = oci_load_balancer_listener.test_listener.name
        load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    }

    rollout_policy {
        batch_count            = 0
        batch_delay_in_seconds = var.batch_delay_in_seconds
        batch_percentage       = 50
        policy_type            = "COMPUTE_INSTANCE_GROUP_LINEAR_ROLLOUT_POLICY_BY_PERCENTAGE"
        ramp_limit_percent     = 0
    }


}

resource "oci_devops_deploy_stage" "canary_traffic_shift" {
    compute_instance_group_canary_deploy_stage_id = oci_devops_deploy_stage.deploy_to_instances.id
    deploy_pipeline_id                            = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                             = "COMPUTE_INSTANCE_GROUP_CANARY_TRAFFIC_SHIFT"
    description                                   = var.canary_traffic_shift_description
    display_name                                  = var.canary_traffic_shift_name
    freeform_tags                                 = {}
   
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.deploy_to_instances.id
        }
    }

    rollout_policy {
        batch_count            = 1
        batch_delay_in_seconds = 60
        batch_percentage       = 0
        ramp_limit_percent     = var.canary_traffic_shift_ramp_limit
    }

}

resource "oci_devops_deploy_stage" "release_approval_stage" {
    compute_instance_group_canary_traffic_shift_deploy_stage_id = oci_devops_deploy_stage.canary_traffic_shift.id
    defined_tags                                                = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id                                          = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                                           = "COMPUTE_INSTANCE_GROUP_CANARY_APPROVAL"
    description                                                 = var.approval_stage_description
    display_name                                                = var.approval_display_name
    freeform_tags                                               = {}
   
    approval_policy {
        approval_policy_type         = "COUNT_BASED_APPROVAL"
        number_of_approvals_required = var.approval_count
    }

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.canary_traffic_shift.id
        }
    }

  
}
   
resource "oci_devops_deploy_stage" "production_release" {
    compute_instance_group_deploy_environment_id = oci_devops_deploy_environment.prod_deploy_environment.id
    defined_tags                                 = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_artifact_ids                          = []
    deploy_pipeline_id                           = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                            = "COMPUTE_INSTANCE_GROUP_ROLLING_DEPLOYMENT"
    deployment_spec_deploy_artifact_id           =  oci_devops_deploy_artifact.test_deploy_artifact.id
    description                                  = var.canary_production_description
    display_name                                 = var.canary_production_name
    
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.release_approval_stage.id
        }
    }

    load_balancer_config {
        backend_port     = var.loadbalancer_backendset_port
        listener_name    = oci_load_balancer_listener.test_listener.name
        load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    }

    rollback_policy {
        policy_type = "NO_STAGE_ROLLBACK_POLICY"
    }

    rollout_policy {
        batch_count            = 0
        batch_delay_in_seconds = 60
        batch_percentage       = 50
        policy_type            = "COMPUTE_INSTANCE_GROUP_LINEAR_ROLLOUT_POLICY_BY_PERCENTAGE"
        ramp_limit_percent     = 0
    }

    timeouts {}
}