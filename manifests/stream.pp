define nginx::stream (
    String  $ensure                        = present,
    Hash $upstream                         = $::nginx::params::upstream,
    String $upstream_name                  = $::nginx::params::upstream_name,
    Hash $maps                             = $::nginx::params::maps,
    Boolean $access_file_log               = $::nginx::params::access_file_log,
    Boolean $access_file_log_only_error    = $::nginx::params::access_file_log_only_error,
    String  $access_file_log_format        = $::nginx::params::stream_access_file_log_format,
    String  $access_file_log_format_params = $::nginx::params::stream_access_file_log_format_params,
    Boolean $error_file_log                = $::nginx::params::error_file_log,
    String $pre_custom_config              = $::nginx::params::pre_custom_config,
    String $custom_http_config             = $::nginx::params::custom_http_config,
    Hash $log_formats                      = $::nginx::params::log_formats,
    String $listen                         = $::nginx::params::stream_listen,

) {
    if ! defined(Class['nginx']) {
        fail('You must include the apache base class before using any nginx defined resources')
    }
    
    if $ensure == present {
    
        file { "/etc/nginx/streams-available/${title}.conf":
            owner   => 'root',
            group   => 'root',
            mode    => '0600',
            content => epp('nginx/stream.conf.epp',
                {
                    title                         => $title,
                    listen                        => $listen,
                    upstream                      => $upstream,
                    upstream_name                 => $upstream_name,
                    access_file_log               => $access_file_log,
                    access_file_log_only_error    => $access_file_log_only_error,
                    access_file_log_format        => $access_file_log_format,
                    access_file_log_format_params => $access_file_log_format_params,
                    error_file_log                => $error_file_log,
                    pre_custom_config             => $pre_custom_config,
                    custom_http_config            => $custom_http_config,
                    log_formats                   => $log_formats,
                }
            ),
            notify  => Class['::nginx::service'],
        }
    
        file { "/etc/nginx/streams-enabled/${title}.conf":
            ensure  => link,
            target  => "/etc/nginx/streams-available/${title}.conf",
            require => File["/etc/nginx/streams-available/${title}.conf"],
            notify  => Class['::nginx::service'],
        }
    } else {
        file { "/etc/nginx/streams-available/${title}.conf":
            ensure  => absent,
            notify  => Class['::nginx::service'],
        }
    
        file { "/etc/nginx/streams-enabled/${title}.conf":
            ensure  => absent,
            notify  => Class['::nginx::service'],
        }
    }
}
