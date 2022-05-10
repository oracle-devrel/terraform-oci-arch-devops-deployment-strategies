## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create Artifact Repository

resource "oci_artifacts_repository" "test_repository" {
  #Required
  compartment_id  = var.compartment_ocid
  is_immutable    = true
  display_name = "${var.app_name}_artifact_repo"
  repository_type = "GENERIC"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_devops_deploy_artifact" "test_deploy_artifact" {
    argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
    defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    deploy_artifact_type       = "DEPLOYMENT_SPEC"
    display_name               = var.devops_artifact_name
    freeform_tags              = {}
    project_id                 = oci_devops_project.test_project.id
    
    deploy_artifact_source {
        deploy_artifact_path        = "instace_deployment_manifest"
        deploy_artifact_source_type = "GENERIC_ARTIFACT"
        deploy_artifact_version     = var.deploy_artifact_version
        repository_id               = oci_artifacts_repository.test_repository.id
    }

}