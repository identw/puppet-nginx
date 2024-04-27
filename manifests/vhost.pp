define nginx::vhost (
    String  $ensure                     = present,
    String  $domain                        = $title,
    String  $conf_file                     = $domain,
    String  $domains                       = $domain,
    $root                                  = undef,
    String $ssl_certificate                = $::nginx::params::ssl_certificate,
    String $ssl_certificate_key            = $::nginx::params::ssl_certificate_key,
    Optional[String] $ssl_protocols        = $nginx::params::ssl_protocols,
    Optional[String] $ssl_ciphers          = $nginx::params::ssl_ciphers,
    # String $proxy_cache_path               = $::nginx::params::proxy_cache_path,
    String $proxy_cache_path               = $::nginx::params::proxy_cache_path,
    Hash $upstream                         = $::nginx::params::upstream,
    String $upstream_name                  = $::nginx::params::upstream_name,
    Hash $locations                        = $::nginx::params::locations,
    Hash $maps                             = $::nginx::params::maps,
    Boolean $access_file_log               = $::nginx::params::access_file_log,
    String $access_file_log_path           = "/var/log/nginx/${domain}_access.log",
    Boolean $access_file_log_only_error    = $::nginx::params::access_file_log_only_error,
    String  $access_file_log_format        = $::nginx::params::access_file_log_format,
    String  $access_file_log_format_params = $::nginx::params::access_file_log_format_params,
    String  $access_log_condition          = $::nginx::params::access_log_condition,
    Boolean $access_syslog                 = $::nginx::params::access_syslog,
    Boolean $access_syslog_only_error      = $::nginx::params::access_syslog_only_error,
    String  $access_syslog_server          = $::nginx::params::access_syslog_server,
    String  $access_syslog_log_format      = $::nginx::params::access_syslog_log_format,
    String $access_file_log_format_name    = "file_${domain}",
    Boolean $error_syslog                  = $::nginx::params::error_syslog,
    String  $error_syslog_server           = $::nginx::params::error_syslog_server,
    String  $error_syslog_tag              = $::nginx::params::error_syslog_tag,
    Boolean $error_file_log                = $::nginx::params::error_file_log,
    String $error_file_log_path            = "/var/log/nginx/${domain}_error.log",
    Boolean $log_enabled                   = true,
    String $pre_custom_config              = $::nginx::params::pre_custom_config,
    String $custom_http_config             = $::nginx::params::custom_http_config,
    Hash $log_formats                      = $::nginx::params::log_formats,
    Boolean $disable_80_port               = false,
    Numeric $tls_port                      = 443,
    String $tls_address_v4                 = '0.0.0.0',
    String $tls_address_v6                 = '[::]',
    Boolean $default_server                = false,

) {
    if ! defined(Class['nginx']) {
        fail('You must include the apache base class before using any nginx defined resources')
    }
    
    if length($error_syslog_tag) > 32 and $ensure == 'present' {
        fail('Parameter error_syslog_tag must less or equal than 32')
    }
    
    if $root {
        $vhost_root = $root
        
    } else {
        $vhost_root = "/var/www/${domain}"
    }
    
    if $ensure == present {
    
        file { "/etc/nginx/sites-available/${conf_file}.conf":
            owner   => 'root',
            group   => 'root',
            mode    => '0600',
            content => epp('nginx/vhost.conf.epp',
                {
                    domain                        => $domain,
                    domains                       => $domains,
                    root                          => $vhost_root,
                    ssl_certificate               => $ssl_certificate,
                    ssl_certificate_key           => $ssl_certificate_key,
                    ssl_protocols                 => $ssl_protocols,
                    ssl_ciphers                   => $ssl_ciphers,
                    proxy_cache_path              => $proxy_cache_path,
                    upstream                      => $upstream,
                    upstream_name                 => $upstream_name,
                    locations                     => $locations,
                    maps                          => $maps,
                    access_file_log               => $access_file_log,
                    access_file_log_path          => $access_file_log_path,
                    access_file_log_only_error    => $access_file_log_only_error,
                    access_file_log_format        => $access_file_log_format,
                    access_file_log_format_params => $access_file_log_format_params,
                    access_syslog                 => $access_syslog,
                    access_log_condition          => $access_log_condition,
                    access_syslog_only_error      => $access_syslog_only_error,
                    access_syslog_server          => $access_syslog_server,
                    access_syslog_log_format      => $access_syslog_log_format,
                    access_file_log_format_name   => $access_file_log_format_name,
                    error_file_log                => $error_file_log,
                    error_file_log_path           => $error_file_log_path,
                    error_syslog                  => $error_syslog,
                    error_syslog_server           => $error_syslog_server,
                    error_syslog_tag              => $error_syslog_tag,
                    log_enabled                   => $log_enabled,
                    pre_custom_config             => $pre_custom_config,
                    custom_http_config            => $custom_http_config,
                    log_formats                   => $log_formats,
                    disable_80_port               => $disable_80_port,
                    tls_port                      => $tls_port,
                    tls_address_v4                => $tls_address_v4,
                    tls_address_v6                => $tls_address_v6,
                    default_server                => $default_server,
                }
            ),
            notify  => Class['::nginx::service'],
        }
    
        file { "/etc/nginx/sites-enabled/${conf_file}.conf":
            ensure  => link,
            target  => "/etc/nginx/sites-available/${conf_file}.conf",
            require => File["/etc/nginx/sites-available/${conf_file}.conf"],
            notify  => Class['::nginx::service'],
        }
    } else {
        file { "/etc/nginx/sites-available/${conf_file}.conf":
            ensure  => absent,
            notify  => Class['::nginx::service'],
        }
    
        file { "/etc/nginx/sites-enabled/${conf_file}.conf":
            ensure  => absent,
            notify  => Class['::nginx::service'],
        }
    }
}
