------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

TriggerServerEvent("Andyyy:GetAmount")

RegisterNetEvent("Andyyy:SetAmount")
AddEventHandler('Andyyy:SetAmount', function(source, newbank, newcash)
	bank = newbank
	cash = newcash
	moneyChecked = true
end)

RegisterCommand(config.payCommand, function(source, args, raw)
	local MoneyID = tonumber(args[1])
	MoneySS = stringsplit(raw, " ")
	local SendingMoneyAmount = ""
	for i=1, #MoneySS do
		if i ~= 1 and i ~= 2 then
			SendingMoneyAmount = (SendingMoneyAmount .. "" .. tostring(MoneySS[i]))
		end
	end
	TransferMoney(tonumber(SendingMoneyAmount), MoneyID)
end)

RegisterCommand(config.giveCommand, function(source, args, raw)
	CashSS = stringsplit(raw, " ")
	local SendingCashAmount = ""
	for i=1, #CashSS do
		if i ~= 1 then
			SendingCashAmount = (SendingCashAmount .. "" .. tostring(CashSS[i]))
		end
	end
	GiveCash(tonumber(SendingCashAmount))
end)

-- Chat suggestions
TriggerEvent("chat:addSuggestion", "/" .. config.giveCommand, "Give money to closeby player", {
    { name="amount", help="amount to give" }
})

TriggerEvent("chat:addSuggestion", "/" .. config.payCommand, "Transfer money to player", {
    { name="id", help="Player server id" },
    { name="amount", help="amount to pay" }
})

-- Reciving Money
RegisterNetEvent("Andyyy:Reciving-Money")
AddEventHandler("Andyyy:Reciving-Money", function(source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("Recived $" .. SendingMoneyAmount .. " from " .. SendingMoneyPlayer .. " [".. SendingMoneyPlayerID .."]")
	SetNotificationMessage("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", true, 9,"FleecaBank", "")
	AddBank(SendingMoneyAmount)
end)

-- Reciving Cash
RegisterNetEvent("Andyyy:Reciving-Cash")
AddEventHandler('Andyyy:Reciving-Cash', function(source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(SendingCashPlayer .. " gave you $" .. SendingCashAmount .. ".")
	SetNotificationMessage("CHAR_DEFAULT", "CHAR_DEFAULT", true, 9, SendingCashPlayer .. " [".. SendingCashPlayerID .."]", "")
	AddCash(SendingCashAmount)
end)

-- Daily Pay
Citizen.CreateThread(function()
	time = config.salaryInterval * 60000
	while true do
		Citizen.Wait(time)
		AddBank(config.salaryAmount)
		TriggerEvent("chat:addMessage", {
			template = "<div style='background-color: rgba(44, 230, 41, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>+ ${0} - Daily Salary</b></div>",
			args = {config.salaryAmount}
		})
	end
end)


---------- HUD RELATED ----------------

-- Show HUD
Citizen.CreateThread(function()
    while true do
		if HUD then
			Text2("💵", 0.885, 0.028)
			Text2("💳", 0.885, 0.068)
			if moneyChecked then
				Text("~g~$~w~".. cash, 0.91, 0.03)
				Text("~b~$~w~".. bank, 0.91, 0.07)
			end
		end
		if moneyChecked and IsPauseMenuActive() then
			BeginScaleformMovieMethodOnFrontendHeader("SET_HEADING_DETAILS")
			--ScaleformMovieMethodAddParamPlayerNameString()
			PushScaleformMovieFunctionParameterString("Cash: $" .. cash)
			PushScaleformMovieFunctionParameterString("Bank: $" .. bank)
            EndScaleformMovieMethod()
		end
		Citizen.Wait(1)
    end
end)

-- Show HUD when a button is pressed
Citizen.CreateThread(function()
	while true do
		if config.hudAlways then 
			HUD = true
		elseif not config.hudAlways then
			if IsControlJustPressed(0, config.showHUD) then
				HUD = true
				if HUD == true then
					Wait(5000)
					HUD = false
				end
			end
		end
		Citizen.Wait(50)
	end
end)

-- Blue text when money is recived into the bank.
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)

		if BankAdded == true then
			Text("~b~+ $" .. bankAddedAmount, 0.8973, 0.11)
		end
	end
end)
-- Green text when reciving cash.
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)

		if CashAdded == true then
			Text("~g~+ $" .. cashAddedAmount, 0.8973, 0.11)
		end
	end
end)

-- Blue text when money is removed.
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)

		if BankRemoved == true then
			Text("~b~- $~r~" .. bankRemovedAmount, 0.8973, 0.11)
		end
	end
end)
-- Green text when cash is removed.
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)

		if CashRemoved == true then
			Text("~g~- $~r~" .. cashRemovedAmount, 0.8973, 0.11)
		end
	end
end)