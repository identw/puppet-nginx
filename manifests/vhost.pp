define nginx::vhost (
    String  $ensure  = present,
    String  $domain  = $title,
    String  $domains = $domain,
    $root            = undef,
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
                    domain  => $domain,
                    domains => $domains,
                    root    => $vhost_root,
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
