a10_client = A10Client::client_factory(host, port, protocol, username, password)

a10_interface_ethernet_trunk_group 'exampleName' do
    trunk_number 1

    client a10_client
    action :create
end

a10_interface_ethernet_trunk_group 'exampleName' do
    trunk_number 1

    client a10_client
    action :update
end

a10_interface_ethernet_trunk_group 'exampleName' do
    trunk_number 1

    client a10_client
    action :delete
end