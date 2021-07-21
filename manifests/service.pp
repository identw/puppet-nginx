class nginx::service () inherits nginx {
    
    if $nginx::service_manage == true {

        if $nginx::openssl_cnf {
            file { '/etc/systemd/system/nginx.service':
              ensure => file,
              source => "puppet:///modules/${module_name}/nginx.service"
            }

            file {'/etc/ssl/openssl_nginx.cnf':
              ensure => file,
              source => "puppet:///modules/${module_name}/openssl.cnf"
            }

            exec { "systemd_daemon_reload_nginx_service":
              command     => "systemctl daemon-reload",
              path        => ['/bin'],
              refreshonly => true,
              subscribe   => File['/etc/systemd/system/nginx.service']
            }
        }

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