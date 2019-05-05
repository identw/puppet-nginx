class nginx::install (
    String $architecture = 'amd64'
) inherits nginx {

    if $nginx::package_ensure != 'installed' {

        exec {'apt_update_before_install_nginx':
            command     => 'apt-get update',
            path        => ['/usr/bin', '/bin'],
            unless      => "dpkg -s nginx | grep Version: ${nginx::package_ensure}",
            before      => Package[$package_name]
        }
    }

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
                'src' => $repository_src,
                'deb' => true,
            },
            architecture => $architecture,
        }

        package { $package_name:
            ensure  => $nginx::package_ensure,
            require => Apt::Source['ubuntu_nginx'],
        }
    } else {
        package { $package_name:
            ensure  => $nginx::package_ensure,
        }
    }
}