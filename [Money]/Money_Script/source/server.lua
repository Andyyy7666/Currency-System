------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

-- Find out how much money the player has.
RegisterServerEvent("Andyyy:GetAmount")
AddEventHandler("Andyyy:GetAmount", function()
	steam = GetPlayerIdentifier(source, 0)
	bank = GetResourceKvpInt(steam .. "bank")
	cash = GetResourceKvpInt(steam .. "cash")

	if bank == 0 then
		SetResourceKvpInt(steam .. "bank", config.startingBank)
		bank = config.startingBank
	end
	if cash == 0 then
		SetResourceKvpInt(steam .. "cash", config.startingWallet)
		cash = config.startingWallet
	end

	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Remove cash from the player.
RegisterServerEvent("Andyyy:RemoveCash")
AddEventHandler("Andyyy:RemoveCash", function(amount)
	steam = GetPlayerIdentifier(source, 0)
	oldCash = GetResourceKvpInt(steam .. "cash") - amount

	SetResourceKvpInt(steam .. "cash", oldCash)

	cash = GetResourceKvpInt(steam .. "cash")
	bank = GetResourceKvpInt(steam .. "bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Remove bank from the player.
RegisterServerEvent("Andyyy:RemoveBank")
AddEventHandler("Andyyy:RemoveBank", function(amount)
	steam = GetPlayerIdentifier(source, 0)
	oldBank = GetResourceKvpInt(steam .. "bank") - amount

	SetResourceKvpInt(steam .. "bank", oldBank)

	cash = GetResourceKvpInt(steam .. "cash")
	bank = GetResourceKvpInt(steam .. "bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Add cash to player.
RegisterServerEvent("Andyyy:AddCash")
AddEventHandler("Andyyy:AddCash", function(amount)
	steam = GetPlayerIdentifier(source, 0)
	oldCash = GetResourceKvpInt(steam .. "cash") + amount

	SetResourceKvpInt(steam .. "cash", oldCash)

	cash = GetResourceKvpInt(steam .. "cash")
	bank = GetResourceKvpInt(steam .. "bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Remove bank from player.
RegisterServerEvent("Andyyy:AddBank")
AddEventHandler("Andyyy:AddBank", function(amount)
	steam = GetPlayerIdentifier(source, 0)
	oldBank = GetResourceKvpInt(steam .. "bank") + amount

	SetResourceKvpInt(steam .. "bank", oldBank)

	cash = GetResourceKvpInt(steam .. "cash")
	bank = GetResourceKvpInt(steam .. "bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)


------------ Transfering money ----------------

-- Gives cash to closest player
RegisterServerEvent("Andyyy:GiveCash")
AddEventHandler("Andyyy:GiveCash", function(CashID, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
	TriggerClientEvent("Andyyy:Reciving-Cash", CashID, CashID, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
end)

-- Transfer money to player using exports
RegisterServerEvent("Andyyy:TransferMoney")
AddEventHandler("Andyyy:TransferMoney", function(MoneyID, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	TriggerClientEvent("Andyyy:Reciving-Money", MoneyID, MoneyID, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
end)


--[[

-- OLD Transfer money to player command
RegisterServerEvent("Andyyy:SendingMoney")
AddEventHandler("Andyyy:SendingMoney", function(MoneyID, source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	TriggerClientEvent("Andyyy:RecivingMoney", MoneyID, source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
end)

-- OLD Giving cash command
RegisterServerEvent("Andyyy:SendingCash")
AddEventHandler("Andyyy:SendingCash", function(CashID, source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
	TriggerClientEvent("Andyyy:RecivingCash", CashID, source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
end)

]]--
