function GetPlayerIdentifierFromType(type, source) -- Credits: xander1998, Post: https://forum.cfx.re/t/solved-is-there-a-better-way-to-get-lic-steam-and-ip-than-getplayeridentifiers/236243/2?u=andyyy7666
	local identifiers = {}
	local identifierCount = GetNumPlayerIdentifiers(source)

	for a = 0, identifierCount do
		table.insert(identifiers, GetPlayerIdentifier(source, a))
	end

	for b = 1, #identifiers do
		if string.find(identifiers[b], type, 1) then
			return identifiers[b]
		end
	end
	return nil
end

RegisterNetEvent("withdraw")
AddEventHandler("withdraw", function(amount)
    local player = source
    exports.oxmysql:query("UPDATE money SET bank = bank - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            exports.oxmysql:query("UPDATE money SET cash = cash + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
            TriggerClientEvent("updateMoney", player, "ATM")
        end
    end)
end)

RegisterNetEvent("deposit")
AddEventHandler("deposit", function(amount)
    local player = source
    exports.oxmysql:query("UPDATE money SET cash = cash - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            exports.oxmysql:query("UPDATE money SET bank = bank + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
            TriggerClientEvent("updateMoney", player, "ATM")
        end
    end)
end)

RegisterNetEvent("getBalanceATM")
AddEventHandler("getBalanceATM", function()
    local player = source
    exports.oxmysql:query("SELECT bank FROM money WHERE license = ?", {GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            TriggerClientEvent("returnBalanceATM", player, result[1].bank)
        end
    end)
end)