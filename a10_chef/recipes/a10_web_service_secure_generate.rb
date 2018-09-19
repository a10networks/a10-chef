a10_client = A10Client::client_factory(host, port, protocol, username, password)

a10_web_service_secure_generate 'exampleName' do

    client a10_client
    action :create
end

a10_web_service_secure_generate 'exampleName' do

    client a10_client
    action :update
end

a10_web_service_secure_generate 'exampleName' do

    client a10_client
    action :delete
end