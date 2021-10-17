------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

-- Variables
local display = false

-- Show ui with a command
RegisterCommand("atm", function()
	SetDisplay(not display, "ui")
end, false)

-- Close if cb is main
RegisterNUICallback("main", function(data)
    SetDisplay(false, "ui")
	PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
end)

-- withdraw nui callback
RegisterNUICallback("withdraw", function(data)
	checkBank = exports.Money_Script:CheckBank()
	if tonumber(data.text) > checkBank then
		BankToDeposit = checkBank
	else
		BankToDeposit = tonumber(data.text)
	end
	TriggerEvent("chat:addMessage", {
		template = "<div style='background-color: rgba(44, 230, 41, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>You've successfully withdrawn ${0} from your account.</b></div>",
		args = {BankToDeposit}
	})
	SetDisplay(false)
	PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
	exports.Money_Script:ToWallet(BankToDeposit)
end)

-- deposit nui callback
RegisterNUICallback("deposit", function(data)
	checkWallet = exports.Money_Script:CheckWallet()
	if tonumber(data.text) > checkWallet then
		CashToDeposit = checkWallet
	else
		CashToDeposit = tonumber(data.text)
	end
	TriggerEvent("chat:addMessage", {
		template = "<div style='background-color: rgba(44, 230, 41, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>You've successfully deposited ${0} to your account.</b></div>",
		args = {CashToDeposit}
	})
	SetDisplay(false)
	PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
	exports.Money_Script:ToBank(CashToDeposit)
end)

-- withdraw error nui callback
RegisterNUICallback("withdrawError", function(data)
	TriggerEvent("chat:addMessage", {
		template = "<div style='background-color: rgba(250, 22, 10, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>ERROR: {0}.</b></div>",
		args = {data.error}
	})
	SetDisplay(false)
	PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
end)

-- deposit error nui callback
RegisterNUICallback("depositError", function(data)
	TriggerEvent("chat:addMessage", {
		template = "<div style='background-color: rgba(250, 22, 10, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>ERROR: {0}.</b></div>",
		args = {data.error}
	})
	SetDisplay(false)
	PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
end)

-- Alert thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsNearATM() and not display then
			alert("Press ~INPUT_CONTEXT~ to use the ATM")
			if IsControlJustPressed(0, 51) then
				SetDisplay(not display, "ui")
			end
		end
	end
end)

-- Functions
-- Hide/Show ui
function SetDisplay(bool, typeName)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = typeName,
        status = bool,
		playerName = GetPlayerName(PlayerId()), 
		bankAmount = "Account Balance $" .. exports.Money_Script:CheckBank() .. ".00"
    })
end

-- Alert on top left of screen
function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Check if player is near an atm
function IsNearATM()
	local playerCoords = GetEntityCoords(PlayerPedId(), 0)
	local ATM1 = GetCoordsAndRotationOfClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 0.7, -870868698, 0) -- older atms
	local ATM2 = GetCoordsAndRotationOfClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 0.7, -1126237515, 0) -- blue atm
	local ATM3 = GetCoordsAndRotationOfClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 0.7, -1364697528, 0) -- red atm
	local ATM4 = GetCoordsAndRotationOfClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 0.7, 506770882, 0) -- green atm

	if ATM1 == 1 or ATM2 == 1 or ATM3 == 1 or ATM4 == 1 then
		return true
	end
end