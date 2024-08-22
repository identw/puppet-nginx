class nginx (
    $package_ensure                                 = $nginx::params::package_ensure,
    $service_manage                                 = $nginx::params::service_manage,
    $default_conf                                   = $nginx::params::default_conf,
    $default_conf_enable                            = true,
    $worker_processes                               = $nginx::params::worker_processes,
    Variant[Boolean, String] $resolver              = $nginx::params::resolver,
    String $send_timeout                            = $nginx::params::send_timeout,
    String $client_body_timeout                     = $nginx::params::client_body_timeout,
    String $client_header_timeout                   = $nginx::params::client_header_timeout,
    String $reset_timedout_connection               = $nginx::params::reset_timedout_connection,
    Boolean $stream                                 = $nginx::params::stream,
    String $repository_url                          = "",
    String $repository_key_id                       = "",
    Boolean $repository_src                         = false,
    Boolean $purge_configs                          = $nginx::params::purge_configs,
    Optional[String] $server_names_hash_bucket_size = undef,
    Optional[String] $variables_hash_bucket_size    = undef,
    Boolean $ssl_ticket                             = false,
    String $ssl_shared_memory                       = $nginx::params::ssl_shared_memory,
    String $ssl_session_timeout                     = $nginx::params::ssl_session_timeout,
    Boolean $openssl_cnf                            = false,
    String $toplevel_config                         = '',
    Optional[Numeric] $map_hash_bucket_size         = undef,

) inherits ::nginx::params {
    $package_name   = $::nginx::params::package_name
    $reload_nginx   = $::nginx::params::reload_nginx
    
    
    contain ::nginx::install
    contain ::nginx::config
    contain ::nginx::service
    
    Class['::nginx::install'] -> Class['::nginx::config'] ~> Class['::nginx::service']
}
