resource_name :a10_ip_nat_translation_service_timeout

property :a10_name, String, name_property: true
property :timeout_val, Integer
property :uuid, String
property :service_type, ['tcp','udp'],required: true
property :timeout_type, ['age','fast']
property :port, Integer,required: true

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/ip/nat/translation/service-timeout/"
    get_url = "/axapi/v3/ip/nat/translation/service-timeout/%<service-type>s+%<port>s"
    timeout_val = new_resource.timeout_val
    uuid = new_resource.uuid
    service_type = new_resource.service_type
    timeout_type = new_resource.timeout_type
    port = new_resource.port

    params = { "service-timeout": {"timeout-val": timeout_val,
        "uuid": uuid,
        "service-type": service_type,
        "timeout-type": timeout_type,
        "port": port,} }

    params[:"service-timeout"].each do |k, v|
        if not v 
            params[:"service-timeout"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating service-timeout') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/ip/nat/translation/service-timeout/%<service-type>s+%<port>s"
    timeout_val = new_resource.timeout_val
    uuid = new_resource.uuid
    service_type = new_resource.service_type
    timeout_type = new_resource.timeout_type
    port = new_resource.port

    params = { "service-timeout": {"timeout-val": timeout_val,
        "uuid": uuid,
        "service-type": service_type,
        "timeout-type": timeout_type,
        "port": port,} }

    params[:"service-timeout"].each do |k, v|
        if not v
            params[:"service-timeout"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["service-timeout"].each do |k, v|
        if v != params[:"service-timeout"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating service-timeout') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/ip/nat/translation/service-timeout/%<service-type>s+%<port>s"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting service-timeout') do
            client.delete(url)
        end
    end
end