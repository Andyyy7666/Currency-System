-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

local cash = ""
local bank = ""

function getMoney()
    return {["cash"] = cash, ["bank"] = bank}
end

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


-- Trigger the server event "getMoney" when the resource starts.
AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
    	return
    end
    Citizen.Wait(1000)
    TriggerServerEvent("getMoney")
end)  

-- Trigger the server event "getMoney" when the player spawns.
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("getMoney")
end)

-- update the money on the client.
RegisterNetEvent("updateMoney")
AddEventHandler("updateMoney", function(updatedCash, updatedBank)
    cash, bank = updatedCash, updatedBank
end)

-- Check how much money player has when they join. And display it on screen.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
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
end)
