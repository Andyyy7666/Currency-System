------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------
local display = false
local IsNearATM = false
local balance = "Account Balance: $00.00"

local atmModels = {
    "-870868698",  -- older atms
    "-1126237515",  -- blue atm
    "-1364697528",  -- red atm
    "506770882"  -- green atm
}

local days = {
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
}

-- Get the time
function getTime()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    if hours <= 9 then
        hours = "0" .. hours
    end
    if minutes <= 9 then
        minutes = "0" .. minutes
    end
    return hours .. ":" .. minutes
end

-- Alert on top left of screen
function alert(msg) 
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

RegisterNetEvent("returnBalanceATM")
AddEventHandler("returnBalanceATM", function(money)
    balance = money
    SetDisplay(true)
end)

-- Hide/Show ui
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        status = bool,
		playerName = GetPlayerName(PlayerId()),
		balance = "Account Balance: $" .. balance .. ".00",
        date = days[GetClockDayOfWeek() + 1],
        time = getTime()
    })
end

RegisterNUICallback("close", function(data)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
    SetDisplay(false)
end)

RegisterNUICallback("sound", function(data)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
end)

RegisterNUICallback("withdraw", function(data)
    TriggerServerEvent("withdraw", data.amount)
end)

RegisterNUICallback("deposit", function(data)
    TriggerServerEvent("deposit", data.amount)
end)

-- Check if player is near an atm
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if not display then
            local playerCoords = GetEntityCoords(PlayerPedId(), 0)
            for k, v in pairs(atmModels) do
                ATM = GetCoordsAndRotationOfClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 0.7, tonumber(v), 0)
                if ATM == 1 then
                    IsNearATM = true
                    break
                else
                    IsNearATM = false
                end
            end
        end
    end
end)

-- Alert thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not display and IsNearATM then
			alert("Press ~INPUT_CONTEXT~ to use the ATM")
			if IsControlJustPressed(0, 51) then
                TriggerServerEvent("getBalanceATM")
			end
            if display then
                TriggerScreenblurFadeIn(1000)
            else
                TriggerScreenblurFadeOut(1000)
            end
		end
	end
end)