Puppet::Functions.create_function(:'nginx_vhosts_undef') do
    dispatch :nginx_vhosts_undef do
        param 'Hash', :arg1
        param 'String', :arg2
        return_type 'Hash'
    end

    def nginx_vhosts_undef(arg1, arg2)
        a = {}
        arg1.each do |key, val|
            if val == nil
                val = { arg2 => key}
            end
            a[key] = val
        end
        a
    end
end