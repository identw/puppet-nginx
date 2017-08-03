class nginx::params {
    $package_ensure = present
    $service_manage = true
    $package_name = "nginx"
 }