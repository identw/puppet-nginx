class nginx (
    $package_ensure           = $::nginx::params::package_ensure,
    $service_manage           = $::nginx::params::service_manage,
    $default_conf             = $::nginx::params::default_conf,
    $worker_processes         = $::nginx::params::worker_processes,
    $send_timeout             = $::nginx::params::send_timeout,
    String $repository_url    = "",
    String $repository_key_id = "",
    Boolean $repository_src   = false,

) inherits ::nginx::params {
    $package_name   = $::nginx::params::package_name
    $reload_nginx   = $::nginx::params::reload_nginx
    
    
    contain ::nginx::install
    contain ::nginx::config
    contain ::nginx::service
    
    Class['::nginx::install'] -> Class['::nginx::config'] ~> Class['::nginx::service']
}
