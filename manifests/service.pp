class nginx::service () inherits nginx {
    
    if $nginx::service_manage == true {
        service { 'nginx':
            ensure     => running,
            enable     => true,
            restart    => $reload_nginx
        }
    }
}