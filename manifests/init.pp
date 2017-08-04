
class nginx (
    $package_ensure = $::nginx::params::package_ensure,
    $service_manage = $::nginx::params::service_manage,
    String $repository_url = "",
    String $repository_key_id = "",

) inherits nginx::params {
    $package_name   = $::nginx::params::package_name
    contain nginx::install
}
