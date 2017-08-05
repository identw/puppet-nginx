class nginx::vhosts (
    $vhosts = {},
) inherits nginx {
    include ::nginx
    
    # For emptry hash values in vhosts
    # Example: $vhosts = { site1 => undef, site2 => undef }
    # Then $transform_vhosts = { site1 => { domain => site1}, site2 => { domain => site2 } }
    $transform_vhosts = nginx_vhosts_undef($vhosts, 'domain')

    create_resources('::nginx::vhost', $transform_vhosts)
}