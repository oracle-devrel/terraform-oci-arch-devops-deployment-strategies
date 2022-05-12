## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_devops_deploy_stage" "oke_depploy_stage" {
    defined_tags                            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id                      = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type                       = "OKE_BLUE_GREEN_DEPLOYMENT"
    description                             = var.bluegreen_deploy_stage_description
    display_name                            = var.bluegreen_deploy_stage_name
    freeform_tags                           = {}
    kubernetes_manifest_deploy_artifact_ids = [
       oci_devops_deploy_artifact.test_deploy_oke_artifact.id,
    ]
    oke_cluster_deploy_environment_id       = oci_devops_deploy_environment.test_environment.id
  
    blue_green_strategy {
        ingress_name  = var.deploy_stage_bluegreen_ingress_name
        namespace_a   = var.deploy_stage_green_namespace
        namespace_b   = var.deploy_stage_blue_namespace
        strategy_type = "NGINX_BLUE_GREEN_STRATEGY"
    }

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
        }
    }

}


resource "oci_devops_deploy_stage" "production_release_approval" {
    defined_tags       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type  = "MANUAL_APPROVAL"
    description        = var.approval_stage_description
    display_name       = var.approval_display_name
    freeform_tags      = {}
 
    
    approval_policy {
        approval_policy_type         = "COUNT_BASED_APPROVAL"
        number_of_approvals_required = var.bluegreen_prod_release_count_of_approval
    }

    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.oke_depploy_stage.id
        }
    }

}

resource "oci_devops_deploy_stage" "production_oke_traffic_shift" {
    defined_tags                   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_pipeline_id             = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    deploy_stage_type              = "OKE_BLUE_GREEN_TRAFFIC_SHIFT"
    description                    = var.blue_green_stage_shift_description
    display_name                   = var.blue_green_stage_shift_name
    freeform_tags                  = {}
    oke_blue_green_deploy_stage_id = oci_devops_deploy_stage.oke_depploy_stage.id
   
   
    deploy_stage_predecessor_collection {
        items {
            id = oci_devops_deploy_stage.production_release_approval.id
        }
    }


}