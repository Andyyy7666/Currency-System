-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

author "Andyyy#7666"
description "Simple Standalone Currency System"
version "2.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

client_script "source/client.lua"
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "config_server.lua",
    "source/server.lua"
}

exports {
    "getMoney"
}

server_exports {
    "getServerObject"
}

dependency "oxmysql"
