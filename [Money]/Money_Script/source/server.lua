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
	bank = GetResourceKvpInt("bank")
	cash = GetResourceKvpInt("cash")

	if bank == 0 then
		SetResourceKvpInt("bank", config.startingBank)
		bank = config.startingBank
	end
	if cash == 0 then
		SetResourceKvpInt("cash", config.startingWallet)
		cash = config.startingWallet
	end

	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Remove cash from the player.
RegisterServerEvent("Andyyy:RemoveCash")
AddEventHandler("Andyyy:RemoveCash", function(amount)
	oldCash = GetResourceKvpInt("cash") - amount

	SetResourceKvpInt("cash", oldCash)

	cash = GetResourceKvpInt("cash")
	bank = GetResourceKvpInt("bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Remove bank from the player.
RegisterServerEvent("Andyyy:RemoveBank")
AddEventHandler("Andyyy:RemoveBank", function(amount)
	oldBank = GetResourceKvpInt("bank") - amount

	SetResourceKvpInt("bank", oldBank)

	cash = GetResourceKvpInt("cash")
	bank = GetResourceKvpInt("bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Add cash to player.
RegisterServerEvent("Andyyy:AddCash")
AddEventHandler("Andyyy:AddCash", function(amount)
	oldCash = GetResourceKvpInt("cash") + amount

	SetResourceKvpInt("cash", oldCash)

	cash = GetResourceKvpInt("cash")
	bank = GetResourceKvpInt("bank")
	TriggerClientEvent("Andyyy:SetAmount", source, source, bank, cash)
end)

-- Remove bank from player.
RegisterServerEvent("Andyyy:AddBank")
AddEventHandler("Andyyy:AddBank", function(amount)
	oldBank = GetResourceKvpInt("bank") + amount

	SetResourceKvpInt("bank", oldBank)

	cash = GetResourceKvpInt("cash")
	bank = GetResourceKvpInt("bank")
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
