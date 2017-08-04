class nginx::install () inherits nginx {

    if $repository_url != "" {
        if $repository_key_id == "" {
            fail('Parameter $repository_url require $repository_key_id')
        }

        apt::source { 'ubuntu_nginx':
            location => $repository_url,
            release  => $facts['os']['distro']['codename'],
            repos    => 'nginx',
            key      => {
                'id'     => $repository_key_id,
                'server' => 'keyserver.ubuntu.com',
            },
            include  => {
                'src' => true,
                'deb' => true,
            }
        }

        package { $package_name:
            ensure  => installed,
            require => Apt::Source['ubuntu_nginx'],
        }
    } else {
        package { $package_name:
            ensure  => installed,
        }
    }
}