define nginx::vhost (
    String  $ensure                     = present,
    String  $domain                     = $title,
    String  $domains                    = $domain,
    $root                               = undef,
    Hash $upstream                      = $::nginx::params::upstream,
    Hash $locations                     = $::nginx::params::locations,
    Boolean $access_file_log            = $::nginx::params::access_file_log,
    Boolean $access_file_log_only_error = $::nginx::params::access_file_log_only_error,
    String  $access_file_log_format     = $::nginx::params::access_file_log_format,
    Boolean $access_syslog              = $::nginx::params::access_syslog,
    Boolean $access_syslog_only_error   = $::nginx::params::access_syslog_only_error,
    String  $access_syslog_server       = $::nginx::params::access_syslog_server,
    String $access_syslog_log_format    = $::nginx::params::access_syslog_log_format,
    Boolean $error_file_log             = $::nginx::params::error_file_log,

) {
    if ! defined(Class['nginx']) {
        fail('You must include the apache base class before using any nginx defined resources')
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
                    upstream                   => $upstream,
                    locations                  => $locations,
                    access_file_log            => $access_file_log,
                    access_file_log_only_error => $access_file_log_only_error,
                    access_file_log_format     => $access_file_log_format,
                    access_syslog              => $access_syslog,
                    access_syslog_only_error   => $access_syslog_only_error,
                    access_syslog_server       => $access_syslog_server,
                    access_syslog_log_format   => $access_syslog_log_format,
                    error_file_log             => $error_file_log,
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
