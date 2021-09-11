------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

-- Transfer money to player command
RegisterServerEvent("Andyyy:SendingMoney")
AddEventHandler("Andyyy:SendingMoney", function(MoneyID, source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	TriggerClientEvent("Andyyy:RecivingMoney", MoneyID, source, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
end)

-- Giving cash command
RegisterServerEvent("Andyyy:SendingCash")
AddEventHandler("Andyyy:SendingCash", function(CashID, source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
	TriggerClientEvent("Andyyy:RecivingCash", CashID, source, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
end)

-- Transfer money to player using exports
RegisterServerEvent("Andyyy:TransferMoney")
AddEventHandler("Andyyy:TransferMoney", function(MoneyID, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
	TriggerClientEvent("Andyyy:RecivingMoneyExport", MoneyID, MoneyID, SendingMoneyAmount, RecivingMoneyPlayer, SendingMoneyPlayer, SendingMoneyPlayerID)
end)