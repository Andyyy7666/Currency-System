------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

version "1.1."
description "Currecny system like GTA Online"
author "Andyyy#7666"

fx_version "cerulean"
game "gta5"

shared_script "config.lua"
client_scripts {
    "source/functions.lua",
    "source/client.lua",
}
server_scripts {
    "source/server.lua",
}

exports {
    "AddBank", -- AddBank(amount)
    "AddCash", -- AddCash(amount)
    "RemoveBank", -- RemoveBank(amount)
    "RemoveCash", -- RemoveCash(amount)
    "TransferMoney", -- TransferMoney(amount, playerId)
    "GiveCash", -- GiveCash(amount)
    "ToBank", -- ToBank(amount)
    "ToWallet", -- ToWallet(amount)
    "CheckBank", -- CheckBank()
    "CheckWallet", -- CheckWallet()
}

--[[ How to use an export example

This below will remove $25 when the player pressed E.

if IsControlJustPressed(0, 51) then
    exports.Money_Script:RemoveCash(25)
end

]]