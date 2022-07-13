local money = exports["Money_Script"]:getServerObject()

RegisterNetEvent("ND_Banks:withdraw")
AddEventHandler("ND_Banks:withdraw", function(amount)
    local player = source
    local update = money.functions.withdraw(amount, player)
    TriggerClientEvent("ND_Banks:update", player, update)
end)

RegisterNetEvent("ND_Banks:deposit")
AddEventHandler("ND_Banks:deposit", function(amount)
    local player = source
    local update = money.functions.deposit(amount, player)
    TriggerClientEvent("ND_Banks:update", player, update)
end)

RegisterNetEvent("ND_Banks:transfer")
AddEventHandler("ND_Banks:transfer", function(amount, target)
    local player = source
    local update = money.functions.transferBank(amount, player, target)
    TriggerClientEvent("ND_Banks:update", player, update)
end)