## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "region" {}

variable "app_name" {
  default     = "DevOpsBlueGreenOKE"
  description = "Application name. Will be used as prefix to identify resources, such as OKE, VCN, DevOps, and others"
}

variable "oci_username" {}
variable "oci_user_authtoken" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.1"
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}

variable "project_description" {
  default = "DevOps CI/CD Sample Project for OKE BlueGreen Deployment"
}

variable "build_pipeline_description" {
  default = "build pipeline for python application with blue-green deployment strategies"
}

variable "build_pipeline_display_name" {
  default = "oci_devops_bluegreen_build_pipeline"
}

variable "repository_name" {
  default = "oci_devops_oke_bluegreen_sample"
}

variable "repository_default_branch" {
  default = "main"
}

variable "repository_description" {
  default = "OCI Devops blue green sample application"
}

variable "git_repo" {
  default = "https://github.com/oracle-devrel/python-oci-bluegreen-oke-app.git"
}

variable "git_repo_name" {
  default = "python-oci-bluegreen-oke-app"
}

variable "build_pipeline_stage_build_pipeline_stage_predecessor_collection_items_id" {
  default = "id"
}

variable "build_pipeline_stage_build_pipeline_stage_type" {
  default = "BUILD"
}

variable "build_pipeline_stage_deliver_artifact_stage_type" {
  default = "DELIVER_ARTIFACT"
}

variable "build_pipeline_stage_deploy_stage_type" {
  default = "TRIGGER_DEPLOYMENT_PIPELINE"
}

variable "build_pipeline_stage_build_source_collection_items_branch" {
  default = "main"
}

variable "build_pipeline_stage_build_source_collection_items_connection_type" {
  default = "DEVOPS_CODE_REPOSITORY"
}

variable "build_pipeline_stage_build_source_collection_items_name" {
  default = "deploy_bluegreen_oke"
}

variable "build_pipeline_stage_build_spec_file" {
  default = ""
}

variable "build_pipeline_stage_deliver_artifact_collection_items_artifact_name" {
  default = "oke_app_base"
}

variable "build_pipeline_stage_display_name" {
  default = "oci_devops_bluegreen_build_pipeline"
}

variable "deliver_artifact_stage_display_name" {
  default = "deliver_artifact"
}

variable "deploy_stage_display_name" {
  default = "deploy_to_oke"
}

variable "build_pipeline_stage_image" {
  default = "OL7_X86_64_STANDARD_10"
}

variable "build_pipeline_stage_wait_criteria_wait_duration" {
  default = "waitDuration"
}

variable "build_pipeline_stage_wait_criteria_wait_type" {
  default = "ABSOLUTE_WAIT"
}

variable "build_pipeline_stage_stage_execution_timeout_in_seconds" {
  default = 36000
}


variable "container_repository_is_public" {
  default = true
}

variable "deploy_artifact_argument_substitution_mode" {
  default = "SUBSTITUTE_PLACEHOLDERS"
}


locals {
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.current_region.regions[0], "key")), ".ocir.io"])
  #ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.home_region.regions[0], "key")), ".ocir.io"])
  #ocir_namespace = lookup(data.oci_identity_tenancy.oci_tenancy, "name" )
  ocir_namespace = lookup(data.oci_objectstorage_namespace.ns, "namespace")
}

#variable "ocir_region" {
# default = "iad"}

variable "deploy_artifact_deploy_artifact_source_deploy_artifact_source_type" {
  default = "OCIR"
}

variable "deploy_artifact_deploy_artifact_type" {
  default = "DOCKER_IMAGE"
}

variable "repository_repository_type" {
  default = "HOSTED"
}

variable "deploy_artifact_type" {
  default = "KUBERNETES_MANIFEST"
}

variable "deploy_pipeline_description" {
  default = "Devops CI/CD Pipleline demo for OKE with bluegreen"
}

variable "deploy_artifact_source_type" {
  default = "INLINE"
}

variable "deploy_pipeline_deploy_pipeline_parameters_items_default_value" {
  default = "example"
}

variable "deploy_pipeline_deploy_pipeline_parameters_items_description" {
  default = "exampleapp"
}

variable "deploy_pipeline_deploy_pipeline_parameters_items_name" {
  default = "namespace"
}

variable "deploy_stage_deploy_stage_type" {
  default = "OKE_DEPLOYMENT"
}

variable "deploy_stage_description" {
  default = "ci/cd deployment to OKE with bluegreen"
}

variable "execute_deployment" {
  default = true
}

variable "build_pipeline_stage_is_pass_all_parameters_enabled" {
  default = true
}

variable "approval_stage_description" {
  default = "Approval for production switch"
}

variable "approval_display_name" {
  default = "approval_for_production_switch"
}

variable "blue_green_stage_shift_description" {
  default = "switch the traffic between OKE environment"
}

variable "blue_green_stage_shift_name" {
  default = "blue_green_oke_traffic_shift"
}

variable "deploy_stage_bluegreen_ingress_name" {
  default = "sample-oke-bg-app-ing"
}

variable "deploy_stage_blue_namespace" {
  default = "nsblue"
}

variable "bluegreen_deploy_stage_description" {
  default = "Deploy to OKE"
}

variable "bluegreen_deploy_stage_name" {
  default = "deploy_to_oke"
}

variable "percentage_bluegreen_shift" {
  default = 25 
}

variable "bluegreen_prod_release_count_of_approval" {
  default = 1 
}

variable "deploy_stage_green_namespace" {
  default = "nsgreen"
}

variable "ingress_version" {
  default = "v1.1.2"
}