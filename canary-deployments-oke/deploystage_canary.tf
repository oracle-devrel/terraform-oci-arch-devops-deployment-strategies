## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_stage" "oke_depploy_stage" {
    defined_tags                            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id                      = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                       = "OKE_CANARY_DEPLOYMENT"
    description                             = "Stage to apply manifest to kubernetes"
    display_name                            = "Deploy to OKE"
    freeform_tags                           = {}
    kubernetes_manifest_deploy_artifact_ids = [
        oci_devops_deploy_artifact.test_deploy_oke_artifact.id,
    ]
    oke_cluster_deploy_environment_id       = oci_devops_deploy_environment.test_environment.id
          
    canary_strategy  {
        ingress_name  = var.deploy_stage_canary_ingress_name
        namespace     = var.deploy_stage_canary_namespace
        strategy_type = "NGINX_CANARY_STRATEGY"
    }

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
        }
    }

    timeouts {}
}

resource "oci_devops_deploy_stage" "canary_oke_traffic_shift" {
    defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id         = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type          = "OKE_CANARY_TRAFFIC_SHIFT"
    description                = var.canary_stage_shift_description
    display_name               = var.canary_stage_shift_name
    freeform_tags              = {}
    oke_canary_deploy_stage_id = oci_devops_deploy_stage.oke_depploy_stage.id
    

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.oke_depploy_stage.id
        }
    }

    rollout_policy {
        batch_count            = 1
        batch_delay_in_seconds = 60
        batch_percentage       = 0
        ramp_limit_percent     = var.percentage_canary_shift
    }

    timeouts {}
}


resource "oci_devops_deploy_stage" "production_release_approval" {
    defined_tags                             = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id                       = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                        = "OKE_CANARY_APPROVAL"
    description                              = var.approval_stage_description
    display_name                             = var.approval_display_name
    freeform_tags                            = {}
    oke_canary_traffic_shift_deploy_stage_id = oci_devops_deploy_stage.canary_oke_traffic_shift.id
        
    approval_policy {
        approval_policy_type         = "COUNT_BASED_APPROVAL"
        number_of_approvals_required = var.canary_prod_release_count_of_approval
    }

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.canary_oke_traffic_shift.id
        }
    }

    timeouts {}
}

resource "oci_devops_deploy_stage" "production_release" {
    defined_tags                            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id                      = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                       = "OKE_DEPLOYMENT"
    description                             = "Final version from production"
    display_name                            = "Production Release"
    freeform_tags                           = {}
    kubernetes_manifest_deploy_artifact_ids = [
        oci_devops_deploy_artifact.test_deploy_oke_artifact.id,
    ]
    namespace                               = var.deploy_stage_prd_namespace
    oke_cluster_deploy_environment_id       = oci_devops_deploy_environment.test_environment.id
       

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.production_release_approval.id
        }
    }

    rollback_policy {
        policy_type = var.deploy_rollback_policy
    }

    timeouts {}
}