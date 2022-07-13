local money = exports["Money_Script"]:getServerObject()

RegisterNetEvent("ND_ATM:withdraw")
AddEventHandler("ND_ATM:withdraw", function(amount)
    local player = source
    local update = money.functions.withdraw(amount, player)
    TriggerClientEvent("ND_ATM:update", player, update)
end)

RegisterNetEvent("ND_ATM:deposit")
AddEventHandler("ND_ATM:deposit", function(amount)
    local player = source
    local update = money.functions.deposit(amount, player, target)
    TriggerClientEvent("ND_ATM:update", player, update)
end)