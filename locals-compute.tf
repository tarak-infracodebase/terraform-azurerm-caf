# Compute Services local values
# Separated for performance optimization and better organization

locals {
  compute = {
    aks_clusters                           = try(var.compute.aks_clusters, {})
    aro_clusters                           = try(var.compute.aro_clusters, {})
    availability_sets                      = try(var.compute.availability_sets, {})
    azure_container_registries             = try(var.compute.azure_container_registries, {})
    bastion_hosts                          = try(var.compute.bastion_hosts, {})
    batch_accounts                         = try(var.compute.batch_accounts, {})
    batch_applications                     = try(var.compute.batch_applications, {})
    batch_certificates                     = try(var.compute.batch_certificates, {})
    batch_jobs                             = try(var.compute.batch_jobs, {})
    batch_pools                            = try(var.compute.batch_pools, {})
    container_apps                         = try(var.compute.container_apps, {})
    container_app_dapr_components          = try(var.compute.container_app_dapr_components, {})
    container_app_environments             = try(var.compute.container_app_environments, {})
    container_app_environment_certificates = try(var.compute.container_app_environment_certificates, {})
    container_app_environment_storages     = try(var.compute.container_app_environment_storages, {})
    container_groups                       = try(var.compute.container_groups, {})
    dedicated_hosts                        = try(var.compute.dedicated_hosts, {})
    dedicated_host_groups                  = try(var.compute.dedicated_host_groups, {})
    machine_learning_compute_instance      = try(var.compute.machine_learning_compute_instance, {})
    proximity_placement_groups             = try(var.compute.proximity_placement_groups, {})
    vmware_clusters                        = try(var.compute.vmware_clusters, {})
    vmware_private_clouds                  = try(var.compute.vmware_private_clouds, {})
    vmware_express_route_authorizations    = try(var.compute.vmware_express_route_authorizations, {})
    wvd_applications                       = try(var.compute.wvd_applications, {})
    wvd_application_groups                 = try(var.compute.wvd_application_groups, {})
    wvd_host_pools                         = try(var.compute.wvd_host_pools, {})
    wvd_workspaces                         = try(var.compute.wvd_workspaces, {})
    virtual_machines                       = try(var.compute.virtual_machines, {})
    virtual_machine_scale_sets             = try(var.compute.virtual_machine_scale_sets, {})
    runbooks                               = try(var.compute.runbooks, {})
  }
}