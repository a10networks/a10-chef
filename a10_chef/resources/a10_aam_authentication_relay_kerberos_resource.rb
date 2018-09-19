resource_name :a10_aam_authentication_relay_kerberos

property :a10_name, String, name_property: true
property :sampling_enable, Array
property :uuid, String
property :instance_list, Array

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/aam/authentication/relay/"
    get_url = "/axapi/v3/aam/authentication/relay/kerberos"
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid
    instance_list = new_resource.instance_list

    params = { "kerberos": {"sampling-enable": sampling_enable,
        "uuid": uuid,
        "instance-list": instance_list,} }

    params[:"kerberos"].each do |k, v|
        if not v 
            params[:"kerberos"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating kerberos') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/aam/authentication/relay/kerberos"
    sampling_enable = new_resource.sampling_enable
    uuid = new_resource.uuid
    instance_list = new_resource.instance_list

    params = { "kerberos": {"sampling-enable": sampling_enable,
        "uuid": uuid,
        "instance-list": instance_list,} }

    params[:"kerberos"].each do |k, v|
        if not v
            params[:"kerberos"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["kerberos"].each do |k, v|
        if v != params[:"kerberos"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating kerberos') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/aam/authentication/relay/kerberos"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting kerberos') do
            client.delete(url)
        end
    end
end