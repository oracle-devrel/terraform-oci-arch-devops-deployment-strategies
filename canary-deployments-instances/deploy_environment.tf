## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# This Terraform script provisions a compute instance required for OCI DevOps service

resource "oci_devops_deploy_environment" "prod_deploy_environment" {
    defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_environment_type = "COMPUTE_INSTANCE_GROUP"
    display_name            = var.devops_env_prod_displayname
    freeform_tags           = {}
    project_id              = oci_devops_project.test_project.id
  


    compute_instance_group_selectors {
        items {
            compute_instance_ids = [
                oci_core_instance.compute_instance_prod.id
            ]
            selector_type        = "INSTANCE_IDS"
        }
    }

}

resource "oci_devops_deploy_environment" "canary_deploy_environment" {
    defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_environment_type = "COMPUTE_INSTANCE_GROUP"
    display_name            = var.devops_env_canary_displayname
    freeform_tags           = {}
    project_id              = oci_devops_project.test_project.id
  


    compute_instance_group_selectors {
        items {
            compute_instance_ids = [
                oci_core_instance.compute_instance_canary.id
            ]
            selector_type        = "INSTANCE_IDS"
        }
    }

}