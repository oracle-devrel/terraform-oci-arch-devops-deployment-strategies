## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "region" {}
variable "ssh_public_key" {
  default = ""
}

variable oci_username {
  default = ""
}

variable oci_user_authtoken {
  default = ""
}

variable "app_name" {
  default     = "DevOpsCanaryInstances"
  description = "Application name. Will be used as prefix to identify resources, such as OKE, VCN, DevOps, and others"
}


variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.1"
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}

variable "project_description" {
  default = "DevOps CI/CD Sample Project for Instance Canary Deployment"
}


variable "compute_instance_prod_name" {
  default = "prod-devops-instance"
}

variable "compute_instance_canary_name" {
  default = "canary-devops-instance"
}

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E4.Flex"
}

variable "instance_shape_ocpus" {
  default = 1
}

variable "instance_shape_memory_in_gbs" {
  default = 1
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "8"
}

variable "availability_domain_name" {
  default = ""
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "Subnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "repository_name" {
  default = "oci-devops-instances-with-canary-model"
}

variable "repository_default_branch" {
  default = "main"
}

variable "repository_description" {
  default = "OCI Devops canary instance sample application"
}

variable "repository_repository_type" {
  default = "HOSTED"
}

variable "git_repo" {
  default = "https://github.com/oracle-devrel/python-oci-canary-instance-app.git"
}

variable "git_repo_name" {
  default = "python-oci-canary-instance-app"
}


locals {
  ocir_namespace = lookup(data.oci_objectstorage_namespace.ns, "namespace")
}


variable "build_pipeline_description" {
  default = "build pipeline for python application with canary deployment strategies"
}

variable "build_pipeline_display_name" {
  default = "oci_devops_canary_build_pipeline_with_instances"
}

variable "devops_artifact_name"{
  default = "test_canary_artifact_instances"
}

variable "deploy_artifact_version"{
  default = "0.0"
}

variable "build_pipeline_stage_build_pipeline_stage_predecessor_collection_items_id" {
  default = "id"
}

variable "build_pipeline_stage_build_pipeline_stage_type" {
  default = "BUILD"
}

variable "build_pipeline_stage_build_source_collection_items_connection_type" {
  default = "DEVOPS_CODE_REPOSITORY"
}


variable "build_pipeline_stage_build_source_collection_items_branch" {
  default = "main"
}

variable "build_pipeline_stage_build_source_collection_items_name" {
  default = "deploy_canary_instances"
}

variable "build_pipeline_stage_build_spec_file" {
  default = ""
}

variable "build_pipeline_stage_display_name" {
  default = "python_app_build_stage"
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

variable "build_pipeline_stage_deliver_artifact_stage_type" {
  default = "DELIVER_ARTIFACT"
}

variable "build_pipeline_stage_deliver_artifact_collection_items_artifact_name" {
  default = "instace_deploy_manifest"
}


variable "deliver_artifact_stage_display_name" {
  default = "deliver_artifact"
}

variable "loadbalancer_display_name"{
  default = "lb_devops_instance_canary"
}

variable "loadbalancer_listner_name"{
  default = "devops_lb_listner"
}

variable "loadbalancer_shape" {
  default = "flexible"
}

variable "loadbalancer_maximum_bandwidth_in_mbps" {
  default = 10
}

variable "loadbalancer_minimum_bandwidth_in_mbps" {
  default = 10 
}

variable "loadbalancer_backend_set_name" {
  default = "lb_backendset_for_canary"
}

variable "loadbalancer_backendset_policy" {
  default = "ROUND_ROBIN"
}

variable "loadbalancer_backendset_port" {
  default = 80
}

variable "loadbalancer_backend_port" {
  default = 80
}

variable "loadbalancer_listener_port" {
  default = 80
}

variable "deploy_pipeline_description" {
  default = "Devops CI/CD Pipleline demo for Instances  with canary model"
}

variable "build_pipeline_stage_deploy_stage_type" {
  default = "TRIGGER_DEPLOYMENT_PIPELINE"
}



variable "deploy_stage_display_name" {
  default = "deploy_to_instances"
}

variable "build_pipeline_stage_is_pass_all_parameters_enabled" {
  default = true
}

variable "devops_env_canary_displayname"{
  default = "env_instance_canary"
}

variable "devops_env_prod_displayname"{
  default = "env_instance_prod"
}

variable "canary_deploy_stage_description"{
  default = "Deploy to instances "
}

variable "canary_deploy_stage_name"{
  default = "deploy_to_instances"
}

variable "batch_delay_in_seconds"{
  default = 5
}


variable "canary_traffic_shift_description"{
  default = "Canary traffic shift"
}

variable "canary_traffic_shift_name"{
  default = "canary_traffic_shift"
}

variable "canary_traffic_shift_ramp_limit"{
  default = 25 
}

variable "approval_stage_description" {
  default = "Approval for release"
}

variable "approval_display_name" {
  default = "approval_stage"
}

variable "approval_count"{
  default = 1
}

variable "canary_production_description"{
  default = "Production Release"
}

variable "canary_production_name"{
  default = "production_release"
}

locals {
  instance_shape = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]
  is_flexible_node_shape = contains(local.instance_shape, var.instance_shape)
  is_flexible_lb_shape   = var.loadbalancer_shape == "flexible" ? true : false
}
