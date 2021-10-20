------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

version "1.1"
description "Bank-Script with Andyyy#7666 Currency system."
author "Andyyy#7666"

fx_version "bodacious"
game "gta5"

ui_page "html/index.html"

files {
	"html/index.html",
	"html/js/jquery-3.6.0.min.js",
	"html/js/listener.js",
	"html/img/fleecabank.png",
	"html/style.css",
}

client_scripts {
	"client.lua",
	"config.lua",
}
