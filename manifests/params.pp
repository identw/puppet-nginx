class nginx::params {
    $package_ensure = present
    $service_manage = true
    $package_name = "nginx"
    
    $worker_processes = 8
    $default_conf = '/etc/nginx/sites-available/default.conf'
    
    # Logs settings
    $access_file_log = false
    $error_file_log = true
    $access_file_log_only_error = true
    $access_file_log_format = ''
    $access_syslog = false
    $access_syslog_only_error = true
    $access_syslog_server = '127.0.0.1'
    $access_syslog_log_format = ''
    $send_timeout = 2
    
    $error_syslog = false
    $error_syslog_tag = "nginx"
    $error_syslog_server = '127.0.0.1'
   
    # Lcations default
    $locations = {
        '/' => @(EOT)
        set $location "default";
        index index.html index.htm;
        | EOT
    }
    
    # Ssl
    $ssl_certificate = ''
    $ssl_certificate_key = ''
    
    # Upstream default
    $upstream = {}
    $upstream_name = ''

    # maps default
    $maps = {}

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