class nginx::install () inherits nginx {
    
    apt::source { 'ubuntu_nginx':
        location => 'http://nginx.org/packages/ubuntu/',
        release  => $facts['os']['distro']['codename'],
        repos    => 'nginx',
        key      => {
            'id'     => $apt_nginx_key_id,
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
}