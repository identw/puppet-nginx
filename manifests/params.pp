class nginx::params {
    $package_ensure = present
    $service_manage = true
    $package_name = "nginx"
    
    $worker_processes = 8
    $default_conf = '/etc/nginx/sites-available/default.conf'

    case $facts['os']['distro']['codename'] {
        'xenial': {
            $reload_nginx = "systemctl reload nginx.service"
            $start_nginx = "systemctl start nginx.service"
            $stop_nginx = "systemctl stop nginx.service"
            $status_nginx = "systemctl status nginx.service"
        }
        'trusty': {
            $reload_nginx = "service nginx reload"
            $start_nginx = "service nginx start"
            $stop_nginx = "service nginx stop"
            $status_nginx = "service nginx status"
        }
        default: {
            $reload_nginx = "systemctl reload nginx.service"
            $start_nginx = "systemctl start nginx.service"
            $stop_nginx = "systemctl stop nginx.service"
            $status_nginx = "systemctl status nginx.service"
        }
    }
 }