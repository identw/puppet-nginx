class nginx::params {
    $package_ensure = 'installed'
    $service_manage = true
    $package_name = "nginx"
    
    $worker_processes = $facts['processorcount']
    $default_conf = '/etc/nginx/sites-available/default.conf'
    $purge_configs = true
    
    # Logs settings
    $access_file_log = false
    $error_file_log = true
    $access_file_log_only_error = true
    $access_file_log_format = ''
    $stream_access_file_log_format = to_json({
        'IP'                       => '$remote_addr',
        'TIME'                     => '$time_local',
        'SESSION_TIME'             => '$session_time',
        'UPSTREAM_ADDR'            => '$upstream_addr',
        'UPSTREAM_CONNECT_TIME'    => '$upstream_connect_time',
        'UPSTREAM_SESSION_TIME'    => '$upstream_session_time',
        'UPSTREAM_FIRST_BYTE_TIME' => '$upstream_first_byte_time',
        'UPSTREAM_BYTES_RECEIVED'  => '$upstream_bytes_received',
        'UPSTREAM_BYTES_SENT'      => '$upstream_bytes_sent',
        'STATUS'                   => '$status',
        'BYTES_SENT'               => '$bytes_sent',
        'BYTES_RECEIVED'           => '$bytes_received',
        'CONNECTION'               => '$connection',
        'PID'                      => '$pid'
    })
    $stream_access_file_log_format_params = 'escape=json'
    $access_file_log_format_params = ''
    $access_syslog = false
    $access_syslog_only_error = true
    $access_syslog_server = '127.0.0.1'
    $access_log_condition = 'if=$status_error'
    $access_syslog_log_format = ''
    $send_timeout = '2'
    $client_body_timeout = '10'
    $client_header_timeout = '10'
    $reset_timedout_connection = 'on'
    $resolver = false
    
    $error_syslog = false
    $error_syslog_tag = "nginx"
    $error_syslog_server = '127.0.0.1'

    $stream_listen = '80'
    # Lcations default
    $locations = {
        '/' => @(EOT)
        set $location "default";
        index index.html index.htm;
        | EOT
    }
    
    # proxy
    $proxy_cache_path = ''
    # Ssl
    $ssl_certificate = ''
    $ssl_certificate_key = ''
    $ssl_protocols = 'TLSv1 TLSv1.1 TLSv1.2 TLSv1.3'
    $ssl_ciphers = 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA'

    $ssl_shared_memory   = '20m'
    $ssl_session_timeout = '2h'

    
    # Upstream default
    $upstream = {}
    $upstream_name = ''

    # maps default
    $maps = {}
    
    $pre_custom_config = ''
    $custom_http_config = ''
    
    $log_formats = {}

    case $facts['os']['distro']['codename'] {
        'focal': {
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

    $stream = false
 }