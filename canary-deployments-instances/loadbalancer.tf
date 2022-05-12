## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_load_balancer_load_balancer" "test_load_balancer" {
    compartment_id = var.compartment_ocid
    defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
    display_name               = var.loadbalancer_display_name
    freeform_tags              = {}
    is_private                 = false
    network_security_group_ids = []
    shape                      = var.loadbalancer_shape
    subnet_ids                 = [
       oci_core_subnet.subnet.id
    ]
    
    dynamic "shape_details" {
      for_each = local.is_flexible_lb_shape ? [1] : []
      content {
        minimum_bandwidth_in_mbps = var.loadbalancer_minimum_bandwidth_in_mbps
        maximum_bandwidth_in_mbps = var.loadbalancer_maximum_bandwidth_in_mbps
      }
    }  
}


resource "oci_load_balancer_backend_set" "test_backend_set" {
    
    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    name             = var.loadbalancer_backend_set_name
    policy           = var.loadbalancer_backendset_policy 

    health_checker {
        interval_ms       = 10000
        port              = var.loadbalancer_backendset_port
        protocol          = "HTTP"
        retries           = 3
        return_code       = 200
        timeout_in_millis = 3000
        url_path          = "/"
    }

}

resource "oci_load_balancer_backend" "test_backend" {
    backendset_name  = oci_load_balancer_backend_set.test_backend_set.name
    backup           = false
    drain            = false
    ip_address       = oci_core_instance.compute_instance_prod.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    offline          = false
    port             = var.loadbalancer_backend_port
    weight           = 1

    timeouts {}
}

resource "oci_load_balancer_backend" "test_backend_2" {
    backendset_name  = oci_load_balancer_backend_set.test_backend_set.name
    backup           = false
    drain            = false
    ip_address       =  oci_core_instance.compute_instance_canary.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    offline          = false
    port             = var.loadbalancer_backend_port
    weight           = 1

    timeouts {}
}

resource "oci_load_balancer_listener" "test_listener" {
    default_backend_set_name = oci_load_balancer_backend_set.test_backend_set.name
    hostname_names           = []
    load_balancer_id         = oci_load_balancer_load_balancer.test_load_balancer.id
    name                     = var.loadbalancer_listner_name
    port                     = var.loadbalancer_listener_port
    protocol                 = "HTTP"
    rule_set_names           = []

    connection_configuration {
        backend_tcp_proxy_protocol_version = 0
        idle_timeout_in_seconds            = "60"
    }

}