------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

-- Variables
cash = config.startingWallet
bank = config.startingBank

-- Sets the amount of cash you will start with.
exports("setStartingWallet", function(amount)
	cash = amount
end)

-- Sets the amount of money in your bank you will start with.
exports("setStartingBank", function(amount)
	bank = amount
end)

-- Cecks how much money you have in your bank.
exports("CheckBank", function()
	return bank
end)

-- Checks how much cash you have in your wallet.
exports("CheckWallet", function()
	return cash
end)

-- Withdraws money from your bank account to your wallet.
exports("ToWallet", function(amount)
	RemoveBank(amount)
	AddCash(amount)
end)

-- Deposits money from your wallet to your bank account.
exports("ToBank", function(amount)
	RemoveCash(amount)
	AddBank(amount)
end)

exports("TransferMoney", function(amount, playerId)
	local MoneyID = playerId
	local SendingMoneyPlayerID = GetPlayerServerId(PlayerId(PlayerPedId(-1)))
	local RecivingMoneyPlayer = GetPlayerName(PlayerId(MoneyID))
	local SendingMoneyPlayer = GetPlayerName(PlayerId())
	local SendingMoneyAmount = tonumber(amount)
	if SendingMoneyAmount > bank then
		TriggerEvent("chat:addMessage", {
			template = "<div style='background-color: rgba(250, 22, 10, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>ERROR: {0}.</b></div>",
			args = {"You don't have enough money."}
		})
	else
		RemoveBank(SendingMoneyAmount)
		TriggerServerEvent("Andyyy:TransferMoney", MoneyID, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
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

RegisterCommand(config.payCommand, function(source, args, raw)
	MoneySS = stringsplit(raw, " ")
	local MoneyID = tonumber(args[1])
	local SendingMoneyPlayerID = GetPlayerServerId(PlayerId(PlayerPedId(-1)))
	local RecivingMoneyPlayer = GetPlayerName(PlayerId(MoneyID))
	local SendingMoneyPlayer = GetPlayerName(PlayerId())
	local SendingMoneyAmount = ""
	for i=1, #MoneySS do
		if i ~= 1 and i ~= 2 then
			SendingMoneyAmount = (SendingMoneyAmount .. "" .. tostring(MoneySS[i]))
		end
	end
	if (tonumber(SendingMoneyAmount)) > bank then
		TriggerEvent("chat:addMessage", {
			color = { 255, 50, 50},
			multiline = true,
			args = {"You don't have enough money."}
		})
	else
		RemoveBank(SendingMoneyAmount)
		TriggerServerEvent("Andyyy:SendingMoney", MoneyID, source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	end
end)

RegisterCommand(config.giveCommand, function(source, args, raw)
	CashSS = stringsplit(raw, " ")
	local CashID = tonumber(args[1])
	local SendingCashPlayerID = GetPlayerServerId(PlayerId(PlayerPedId(-1)))
	local RecivingCashPlayer = GetPlayerName(PlayerId(CashID))
	local SendingCashPlayer = GetPlayerName(PlayerId())
	local SendingCashAmount = ""
	for i=1, #CashSS do
		if i ~= 1 and i ~= 2 then
			SendingCashAmount = (SendingCashAmount .. "" .. tostring(CashSS[i]))
		end
	end
	if (tonumber(SendingCashAmount)) > cash then
		TriggerEvent("chat:addMessage", {
			color = { 255, 50, 50},
			multiline = true,
			args = {"You don't have enough cash."}
		})
	else
		RemoveCash(SendingCashAmount)
		TriggerServerEvent('Andyyy:SendingCash', CashID, source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
	end
end)

-- Chat suggestions
TriggerEvent("chat:addSuggestion", "/" .. config.giveCommand, "Give money to player", {
    { name="id", help="Player server id" },
    { name="amount", help="amount to give" }
})

TriggerEvent("chat:addSuggestion", "/" .. config.payCommand, "Transfer money to player", {
    { name="id", help="Player server id" },
    { name="amount", help="amount to pay" }
})

-- Show HUD when a button is pressed
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)

		if IsControlJustPressed(0, config.showHUD) then
			HUD = true
			if HUD == true then
				Wait(5000)
				HUD = false
			end
		end
	end
end)

-- Reciving Money
RegisterNetEvent("Andyyy:RecivingMoney")
AddEventHandler('Andyyy:RecivingMoney', function(source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("Recived $" .. SendingMoneyAmount .. " from " .. SendingMoneyPlayer .. " [".. SendingMoneyPlayerID .."]")
	SetNotificationMessage("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", true, 9,"FleecaBank", "")
	AddBank(SendingMoneyAmount)
end)

-- Reciving Cash
RegisterNetEvent("Andyyy:RecivingCash")
AddEventHandler('Andyyy:RecivingCash', function(source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(SendingCashPlayer .. " gave you $" .. SendingCashAmount .. ".")
	SetNotificationMessage("CHAR_DEFAULT", "CHAR_DEFAULT", true, 9, SendingCashPlayer .. " [".. SendingCashPlayerID .."]", "")
	AddCash(SendingCashAmount)
end)

-- Reciving Money
RegisterNetEvent("Andyyy:RecivingMoneyExport")
AddEventHandler('Andyyy:RecivingMoneyExport', function(source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("Recived $" .. SendingMoneyAmount .. " from " .. SendingMoneyPlayer .. " [".. SendingMoneyPlayerID .."]")
	SetNotificationMessage("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", true, 9,"FleecaBank", "")
	AddBank(SendingMoneyAmount)
	print("recived")
end)

-- Show HUD
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

		if config.hudAlways == true then 
			HUD = true
		end

		if HUD == true then
			Text2("💵", 0.885, 0.028)
			Text2("💳", 0.885, 0.068)
			Text("~g~$~w~".. cash, 0.91, 0.03)
			Text("~b~$~w~".. bank, 0.91, 0.07)
		end
    end
end)