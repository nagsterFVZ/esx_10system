
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


files {
}

server_script{
  'config.lua',
  'server.lua'
} 
client_script{
  'config.lua',
  'client.lua'
} 

server_scripts {

    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
  
  }