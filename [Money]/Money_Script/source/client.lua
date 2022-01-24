------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

local cash = nil
local bank = nil
local started = true

-- Text on screen.
function text(text, x, y, scale)
    SetTextFont(7)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Notification above the map.
function notify(message)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(message)
	EndTextCommandThefeedPostTicker(0,1)
end

-- update players money.
RegisterNetEvent("returnMoney")
AddEventHandler("returnMoney", function(newCash, newBank)
    cash = newCash
    bank = newBank
end)

-- Check how much money player has when they join. And display it on screen.
Citizen.CreateThread(function()
    TriggerServerEvent("getMoney")
    while true do
        Citizen.Wait(0)
        if cash and bank then
            text("💵", 0.885, 0.028, 0.35)
            text("💳", 0.885, 0.068, 0.35)
            text("~g~$~w~".. cash, 0.91, 0.03, 0.55)
            text("~b~$~w~".. bank, 0.91, 0.07, 0.55)
            if IsPauseMenuActive() then
                BeginScaleformMovieMethodOnFrontendHeader("SET_HEADING_DETAILS")
                ScaleformMovieMethodAddParamPlayerNameString(GetPlayerName(PlayerId()))
                PushScaleformMovieFunctionParameterString("Cash: $" .. cash)
                PushScaleformMovieFunctionParameterString("Bank: $" .. bank)
                EndScaleformMovieMethod()
            end
        end
    end
end)

RegisterNetEvent("updateMoney")
AddEventHandler("updateMoney", function(amount, type)
    if type == "cash" then
        amount = "~r~- ~g~$~w~".. amount
    elseif type == "bank" then
        amount = "~r~- ~b~$~w~".. amount
    else
        amount = amount
    end

    local time = 0
    while time < 300 do
        Citizen.Wait(0)
        text(amount, 0.8971, 0.11, 0.55)
        time = time + 1
    end
    TriggerServerEvent("updateMoney")
end)

-- Notification when you recieve money.
RegisterNetEvent("receiveBank")
AddEventHandler("receiveBank", function(amount, playerSending, playerId)
    BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName("Received $" .. amount .. " from " .. playerSending .. " [".. playerId .."]")
	EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", true, 9,"FleecaBank", "")
    local time = 0
    while time < 300 do
        Citizen.Wait(0)
        text("~g~+ ~b~$~w~".. amount, 0.8971, 0.11, 0.55)
        time = time + 1
    end
    TriggerServerEvent("updateMoney")
end)

-- Notification when you receive cash.
RegisterNetEvent("receiveCash")
AddEventHandler("receiveCash", function(amount, playerSending, playerId)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(playerSending .. " gave you $" .. amount .. ".")
	EndTextCommandThefeedPostMessagetext("CHAR_DEFAULT", "CHAR_DEFAULT", true, 9, playerSending .. " [".. playerId .."]", "")
    local time = 0
    while time < 300 do
        Citizen.Wait(0)
        text("~g~+ $~w~".. amount, 0.8971, 0.11, 0.55)
        time = time + 1
    end
    TriggerServerEvent("updateMoney")
end)

-- Notification when receiving salary.
RegisterNetEvent("receiveSalary")
AddEventHandler("receiveSalary", function(amount)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("Daily Salary + $" .. config.salaryAmount)
    EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", true, 9,"FleecaBank", "")
    local time = 0
    while time < 300 do
        Citizen.Wait(0)
        text("~g~+ ~b~$~w~".. amount, 0.8971, 0.11, 0.55)
        time = time + 1
    end
    TriggerServerEvent("updateMoney")
end)

RegisterNetEvent("adminReceiveNotification")
AddEventHandler("adminReceiveNotification", function(amount, playerSending, playerId)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(playerSending .. " added $" .. amount .. " to your account.")
	EndTextCommandThefeedPostMessagetext("CHAR_DEFAULT", "CHAR_DEFAULT", true, 9, playerSending .. " [".. playerId .."]", "")
    local time = 0
    while time < 300 do
        Citizen.Wait(0)
        text("~g~+ ~b~$~w~".. amount, 0.8971, 0.11, 0.55)
        time = time + 1
    end
    TriggerServerEvent("updateMoney")
end)

TriggerEvent("chat:addSuggestion", "/" .. config.payCommand, "Transfer money to player", {{ name="id", help="Player server id" }, { name="amount", help="amount to pay" }})
TriggerEvent("chat:addSuggestion", "/" .. config.giveCommand, "Give money to closeby player", {{ name="amount", help="amount to give" }})
TriggerEvent("chat:addSuggestion", "/" .. config.adminAddCommand, "Add money to player", {{ name="id", help="Player server id" }, { name="amount", help="amount to add" }})