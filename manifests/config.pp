class nginx::config () inherits nginx {
    
    # if defined(File['/var/www']) == false {
    #     file { '/var/www':
    #         ensure => directory
    #     }
    # }
    
    file { '/etc/nginx/sites-available':
        ensure  => directory,
        purge   => $purge_configs,
        recurse => $purge_configs,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
    }
    
    file { '/etc/nginx/sites-enabled':
        ensure  => directory,
        purge   => $purge_configs,
        recurse => $purge_configs,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
    }
    
    file { '/etc/nginx/conf.d':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        recurse => $purge_configs,
        purge   => $purge_configs,
    }
    
    file { '/etc/nginx/projects_custom_config':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        require => File['/etc/nginx/conf.d'],
    }

    if $ssl_ticket {
        $ssl_ticket_key = '/etc/nginx/ticket.key'

        ensure_packages(['openssl'], {ensure => installed})

        exec {'nginx_ssl_ticket_key':
            command => "openssl rand 80 > ${ssl_ticket_key}; chmod 600 ${ssl_ticket_key}",
            path    => ['/usr/bin', '/bin'],
            creates => $ssl_ticket_key,
            require => Package['openssl'],
            before  => File['/etc/nginx/nginx.conf'],
        }

        file {$ssl_ticket_key:
            ensure => file,
            owner  => root,
            mode   => '0600',
        }
    }

    file { '/etc/nginx/nginx.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => epp('nginx/nginx.conf.epp', {
            worker_processes              => $worker_processes,
            send_timeout                  => $send_timeout,
            client_body_timeout           => $client_body_timeout,
            client_header_timeout         => $client_header_timeout,
            reset_timedout_connection     => $reset_timedout_connection,
            server_names_hash_bucket_size => $server_names_hash_bucket_size,
            variables_hash_bucket_size    => $variables_hash_bucket_size,
            resolver                      => $resolver,
            stream                        => $stream,
            ssl_ticket                    => $ssl_ticket,
            
        }),
        require => [
            File['/etc/nginx/sites-available'],
            File['/etc/nginx/sites-enabled'],
            File['/etc/nginx/conf.d'],
        
        ],
    }
    
    file { $default_conf:
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => epp('nginx/default.conf.epp'),
        require => File['/etc/nginx/sites-available'],
    }

    if ! $stream {
        file { '/etc/nginx/sites-enabled/default.conf':
          ensure  => link,
          target  => $default_conf,
          require => File[$default_conf],
        }
    } else {
        file { '/etc/nginx/streams-available':
          ensure  => directory,
          purge   => true,
          recurse => true,
          owner   => 'root',
          group   => 'root',
          mode    => '0700',
        }

        file { '/etc/nginx/streams-enabled':
          ensure  => directory,
          purge   => true,
          recurse => true,
          owner   => 'root',
          group   => 'root',
          mode    => '0700',
        }

    }
}