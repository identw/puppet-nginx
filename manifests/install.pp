class nginx::install () inherits nginx {

    if $repository_url != "" {
        if $repository_key == "" {
            fail('Parameter $repository_url require $repository_key')
        }

        apt::source { 'ubuntu_nginx':
            location => $repository_url,
            release  => $facts['os']['distro']['codename'],
            repos    => 'nginx',
            key      => {
                'id'     => $repository_key,
                'server' => 'keyserver.ubuntu.com',
            },
            include  => {
                'src' => true,
                'deb' => true,
            }
        }
    }
    
    package { $package_name:
            ensure  => installed,
            require => Apt::Source['ubuntu_nginx'],
    }
}