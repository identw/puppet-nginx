define nginx::vhost (
    String  $ensure                     = present,
    String  $domain                     = $title,
    String  $domains                    = $domain,
    $root                               = undef,
    String $ssl_certificate             = $::nginx::params::ssl_certificate,
    String $ssl_certificate_key         = $::nginx::params::ssl_certificate_key,
    # String $proxy_cache_path            = $::nginx::params::proxy_cache_path,
    String $proxy_cache_path            = $::nginx::params::proxy_cache_path,
    Hash $upstream                      = $::nginx::params::upstream,
    String $upstream_name               = $::nginx::params::upstream_name,
    Hash $locations                     = $::nginx::params::locations,
    Hash $maps                          = $::nginx::params::maps,
    Boolean $access_file_log            = $::nginx::params::access_file_log,
    Boolean $access_file_log_only_error = $::nginx::params::access_file_log_only_error,
    String  $access_file_log_format     = $::nginx::params::access_file_log_format,
    Boolean $access_syslog              = $::nginx::params::access_syslog,
    Boolean $access_syslog_only_error   = $::nginx::params::access_syslog_only_error,
    String  $access_syslog_server       = $::nginx::params::access_syslog_server,
    String  $access_syslog_log_format   = $::nginx::params::access_syslog_log_format,
    Boolean $error_syslog               = $::nginx::params::error_syslog,
    String  $error_syslog_server        = $::nginx::params::error_syslog_server,
    String  $error_syslog_tag           = $::nginx::params::error_syslog_tag,
    Boolean $error_file_log             = $::nginx::params::error_file_log,

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
    
        file { "/etc/nginx/sites-available/${domain}.conf":
            owner   => 'root',
            group   => 'root',
            mode    => '0600',
            content => epp('nginx/vhost.conf.epp',
                {
                    domain                     => $domain,
                    domains                    => $domains,
                    root                       => $vhost_root,
                    ssl_certificate            => $ssl_certificate,
                    ssl_certificate_key        => $ssl_certificate_key,
                    proxy_cache_path           => $proxy_cache_path,
                    upstream                   => $upstream,
                    upstream_name              => $upstream_name,
                    locations                  => $locations,
                    maps                       => $maps,
                    access_file_log            => $access_file_log,
                    access_file_log_only_error => $access_file_log_only_error,
                    access_file_log_format     => $access_file_log_format,
                    access_syslog              => $access_syslog,
                    access_syslog_only_error   => $access_syslog_only_error,
                    access_syslog_server       => $access_syslog_server,
                    access_syslog_log_format   => $access_syslog_log_format,
                    error_file_log             => $error_file_log,
                    error_syslog               => $error_syslog,
                    error_syslog_server        => $error_syslog_server,
                    error_syslog_tag           => $error_syslog_tag,
                }
            ),
            notify  => Class['::nginx::service'],
        }
    
        file { "/etc/nginx/sites-enabled/${domain}.conf":
            ensure  => link,
            target  => "/etc/nginx/sites-available/${domain}.conf",
            require => File["/etc/nginx/sites-available/${domain}.conf"],
            notify  => Class['::nginx::service'],
        }
    } else {
        file { "/etc/nginx/sites-available/${domain}.conf":
            ensure  => absent,
            notify  => Class['::nginx::service'],
        }
    
        file { "/etc/nginx/sites-enabled/${domain}.conf":
            ensure  => absent,
            notify  => Class['::nginx::service'],
        }
    }
}
