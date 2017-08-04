
class nginx (
    $package_ensure = $::nginx::params::package_ensure,
    $service_manage = $::nginx::params::service_manage,
) inherits nginx::params {
    $package_name   = $::nginx::params::package_name
}
