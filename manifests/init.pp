
class nginx (
    $package_ensure = $::nginx::params::package_ensure,
    $service_manage = $::nginx::params::service_manage,
    String $repository_url = "",
    String $repository_key = "",

) inherits nginx::params {
    $package_name   = $::nginx::params::package_name
    contain nginx::install
}
