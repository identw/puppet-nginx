class nginx::config () inherits nginx {
    
    @file { '/var/www':
        ensure => directory
    }
    
    File <| title == "/var/www" |> {
        require => Package['nginx'],
    }
    
    file { '/etc/nginx/sites-available':
        ensure  => directory,
        purge   => true,
        recurse => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
    }
    
    file { '/etc/nginx/sites-enabled':
        ensure  => directory,
        purge   => true,
        recurse => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
    }
    
    file { '/etc/nginx/conf.d':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        recurse => true,
        purge   => true,
    }
    
    file { '/etc/nginx/conf.d/status.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        source  => 'puppet:///modules/nginx/status.conf',
    }
    
    
    file { '/etc/nginx/projects_custom_config':
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        require => File['/etc/nginx/conf.d'],
    }
    
    file { '/etc/nginx/nginx.conf':
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => epp('nginx/nginx.conf.epp', { worker_processes => $worker_processes} ),
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
    
    file { '/etc/nginx/sites-enabled/default.conf':
        ensure  => link,
        target  => $default_conf,
        require => File[$default_conf],
    }
    
}