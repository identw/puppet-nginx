
class nginx (
    $package_ensure = $::nginx::params::package_ensure,
    $service_manage = $::nginx::params::service_manage,
    $package_name   = $::nginx::params::package_name,
) inherits nginx::params {

}
