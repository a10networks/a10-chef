resource_name :a10_cgnv6_ds_lite_alg_h323

property :a10_name, String, name_property: true
property :h323_enable, ['enable']
property :uuid, String

property :client, [Class, A10Client::ACOSClient]


action :create do
    client = new_resource.client
    a10_name = new_resource.a10_name
    post_url = "/axapi/v3/cgnv6/ds-lite/alg/"
    get_url = "/axapi/v3/cgnv6/ds-lite/alg/h323"
    h323_enable = new_resource.h323_enable
    uuid = new_resource.uuid

    params = { "h323": {"h323-enable": h323_enable,
        "uuid": uuid,} }

    params[:"h323"].each do |k, v|
        if not v 
            params[:"h323"].delete(k)
        end
    end

    get_url = get_url % {name: a10_name}

    begin
        client.get(get_url)
    rescue RuntimeError => e
        converge_by('Creating h323') do
            client.post(post_url, params: params)
        end
    end
end

action :update do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/ds-lite/alg/h323"
    h323_enable = new_resource.h323_enable
    uuid = new_resource.uuid

    params = { "h323": {"h323-enable": h323_enable,
        "uuid": uuid,} }

    params[:"h323"].each do |k, v|
        if not v
            params[:"h323"].delete(k)
        end
    end

    get_url = url % {name: a10_name}
    result = client.get(get_url)

    found_diff = false 
    result["h323"].each do |k, v|
        if v != params[:"h323"][k] 
            found_diff = true
        end
    end

    if found_diff
        converge_by('Updating h323') do
            client.put(url, params: params)
        end
    end
end

action :delete do
    client = new_resource.client
    a10_name = new_resource.a10_name
    url = "/axapi/v3/cgnv6/ds-lite/alg/h323"

    url = url % {name: a10_name} 

    result = client.get(url)
    if result
        converge_by('Deleting h323') do
            client.delete(url)
        end
    end
end