------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

-- Get player identifier function (This will not change the identifier all the time)
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

function fromRGB(R, G, B)
    R = R * 65536
    G = G * 256
    B = B
    return R + G + B
end

function sendToDiscord(title, description, R, G, B)
    local embed = {
        {
            title = title,
            description = description,
            footer = {
                icon_url = "https://i.imgur.com/notBtrZ.png",
                text = "Created by Andyyy#7666"
            },
            color = fromRGB(R, G, B)
        }
    }
    PerformHttpRequest(discord_config.discordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {["Content-Type"] = "application/json"})
end

-- find out how much money the player has, if they're new and don't have money then it will give them the starting value.
RegisterNetEvent("getMoney")
AddEventHandler("getMoney", function()
    local player = source
    local license = GetPlayerIdentifierFromType("license", player)
    local cash = nil
    local bank = nil
    exports.oxmysql:query("SELECT cash, bank FROM money WHERE license = ?", {license}, function(result)
        if result then
            for _, v in pairs(result) do
                cash = v.cash
                bank = v.bank
                TriggerClientEvent("returnMoney", player, cash, bank)
            end
            if cash == nil or bank == nil then
                exports.oxmysql:query("INSERT INTO money (license, cash, bank) VALUES (?, ?, ?)", {license, config.startingCash, config.startingBank})
                exports.oxmysql:query("SELECT cash, bank FROM money WHERE license = ?", {license}, function(result)
                    if result then
                        for _, v in pairs(result) do
                            cash = v.cash
                            bank = v.bank
                            TriggerClientEvent("returnMoney", player, cash, bank)
                        end
                    end
                end)
            end
        end
    end)
end)

-- update the money
RegisterNetEvent("updateMoney")
AddEventHandler("updateMoney", function()
    local player = source
    exports.oxmysql:query("SELECT cash, bank FROM money WHERE license = ?", {GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            local cash = result[1].cash
            local bank = result[1].bank
            TriggerClientEvent("returnMoney", player, cash, bank)
        end
    end)
end)

--Added by Resq to work with the submitted client.lua edit that adds the ClientEvent for updateAddMoney to facilitate the display of a + symbol instead of a - symbol when using the export and event trigger in an external script where the player should receive money.
RegisterNetEvent("updateAddMoney")
AddEventHandler("updateAddMoney", function()
    local player = source
    exports.oxmysql:query("SELECT cash, bank FROM money WHERE license = ?", {GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            local cash = result[1].cash
            local bank = result[1].bank
            TriggerClientEvent("returnMoney", player, cash, bank)
        end
    end)
end)

-- Paying money from the bank account command.
RegisterCommand(config.payCommand, function(source, args, raw)
    local player = source
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    
    exports.oxmysql:query("SELECT bank FROM money WHERE license = ?", {GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            if player == target then
                TriggerClientEvent("chat:addMessage", player, {
                    color = {255, 0, 0},
                    args = {"Error", "You can't send money to yourself."}
                })
            elseif GetPlayerPing(target) == 0 then
                TriggerClientEvent("chat:addMessage", player, {
                    color = {255, 0, 0},
                    args = {"Error", "That player does not exist."}
                })
            elseif result[1].bank < amount then
                TriggerClientEvent("chat:addMessage", player, {
                    color = {255, 0, 0},
                    args = {"Error", "You don't have enough money."}
                })
            else
                exports.oxmysql:query("UPDATE money SET bank = bank - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
                exports.oxmysql:query("UPDATE money SET bank = bank + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", target)})
                
                TriggerClientEvent("chat:addMessage", player, {
                    color = {0, 255, 0},
                    args = {"Success", "You paid " .. GetPlayerName(target) .. " $" .. amount .. "."}
                })
                TriggerClientEvent("updateMoney", player, amount, "bank")
                TriggerClientEvent("receiveBank", target, amount, GetPlayerName(player), player)
            end
        end
    end)
end)

-- Giving cash command.
RegisterCommand(config.giveCommand, function(source, args, raw)
    local player = source
    local amount = tonumber(args[1])

    exports.oxmysql:query("SELECT cash FROM money WHERE license = ?", {GetPlayerIdentifierFromType("license", player)}, function(result)
        if result then
            local playerFound = false
            local playerCoords = GetEntityCoords(GetPlayerPed(player))
            if result[1].cash < amount then
                TriggerClientEvent("chat:addMessage", player, {
                    color = {255, 0, 0},
                    args = {"Error", "You don't have enough money."}
                })
            else
                for _, target in pairs(GetPlayers()) do 
                    local target = tonumber(target)
                    local targetCoords = GetEntityCoords(GetPlayerPed(target))
                    if (#(playerCoords - targetCoords) < 2.0) and target ~= player and not playerFound then
                        exports.oxmysql:query("UPDATE money SET cash = cash - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
                        exports.oxmysql:query("UPDATE money SET cash = cash + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", target)})
                        playerFound = true
                        TriggerClientEvent("chat:addMessage", player, {
                            color = {0, 255, 0},
                            args = {"Success", "You gave " .. GetPlayerName(target) .. " $" .. amount .. "."}
                        })
                        TriggerClientEvent("updateMoney", player, amount, "cash")
                        TriggerClientEvent("receiveCash", target, amount, GetPlayerName(player), player)
                    end 
                end
                if not playerFound then
                    TriggerClientEvent("chat:addMessage", player, {
                        color = {255, 0, 0},
                        args = {"Error", "No players nearby."}
                    })
                end
                playerFound = false
            end
        end
    end)
end)

-- Giving money to players as a admin command.
RegisterCommand(config.adminAddCommand, function(source, args, raw)
    local player = source
    local target = args[1]
    local amount = args[2]
    local hasPerms = false

    for _, role in pairs(discord_config.roles) do
        if IsRolePresent(player, role) then
            hasPerms = true
            break
        end
    end

    if not hasPerms then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "You don't have access to this command."}
        })
    elseif GetPlayerPing(target) == 0 then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "That player does not exist."}
        })
    else
        exports.oxmysql:query("UPDATE money SET bank = bank + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", target)})
        TriggerClientEvent("adminReceiveNotification", target, amount, GetPlayerName(player), player)
        if discord_config.enableDiscordLogs then
            sendToDiscord("Admin command used", GetPlayerName(player) .. " added $" .. amount .. " to " .. GetPlayerName(target) .. ".", 255, 0, 0)
        end
    end
end)

-- Salary
local salaryInterval = config.salaryInterval * 60000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(salaryInterval)
        for _, player in pairs(GetPlayers()) do
            exports.oxmysql:query("UPDATE money SET bank = bank + ? WHERE license = ?", {config.salaryAmount, GetPlayerIdentifierFromType("license", player)})
            TriggerClientEvent("receiveSalary", player, config.salaryAmount)
        end
    end
end)

-- This is a edited version of discord-roles (everything below), original discord-roles resource: https://forum.cfx.re/t/discord-roles-for-permissions-im-creative-i-know/233805?u=andyyy7666
local FormattedToken = "Bot " .. discord_config.discordToken

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function IsRolePresent(user, role)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			--print("Found discord id: " .. discordId)
			break
		end
	end

	local theRole = nil
	if type(role) == "number" then
		theRole = tostring(role)
	else
		theRole = discord_config.roles[role]
	end

    if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(discord_config.guildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			for i = 1, #roles do
				if roles[i] == theRole then
					--print("Found role")
					return true
				end
			end
			--print("Not found!")
			return false
		else
			--print("Error occurred, maybe they are not in discord?")
			return false
		end
    else
		--print("missing identifier")
		return false
	end
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/" .. discord_config.guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("Permission system guild set to: " .. data.name .. " (" .. data.id .. ")")
	else
		print("You might not have a valid token. Error: " .. (guild.data or guild.code)) 
	end
end)
