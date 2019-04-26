class nginx::service () inherits nginx {
    
    if $nginx::service_manage == true {
        exec {'nginx_test_config':
            command     => 'nginx -t',
            path        => ['/usr/sbin'],
            refreshonly => true,
            notify      => Service['nginx'],
        }
        service { 'nginx':
            ensure     => running,
            enable     => true,
            restart    => $reload_nginx
        }
    }
}