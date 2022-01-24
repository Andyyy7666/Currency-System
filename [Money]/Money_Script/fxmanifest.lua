------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

version "1.2"
description "Currecny system like GTA Online"
author "Andyyy#7666"

fx_version "cerulean"
game "gta5"

shared_script "config_client.lua"
client_script "source/client.lua"
server_scripts {
    "config_server.lua",
    "source/server.lua"
}