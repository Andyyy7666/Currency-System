-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

money = {}
money.players = {}
money.functions = {}

function getServerObject()
    return money
end

-- Used to retrive the players discord server nickname, discord name and tag, and the roles.
function getUserDiscordInfo(discordUserId)
    local data
    PerformHttpRequest("https://discordapp.com/api/guilds/" .. server_config.guildId .. "/members/" .. discordUserId, function(errorCode, resultData, resultHeaders)
		if errorCode ~= 200 then
            return
        end
        local result = json.decode(resultData)
        local roles = {}
        for _, roleId in pairs(result.roles) do
            roles[roleId] = roleId
        end
        data = {
            nickname = result.nick,
            discordTag = tostring(result.user.username) .. "#" .. tostring(result.user.discriminator),
            roles = roles
        }
    end, "GET", "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. server_config.discordServerToken})
    while not data do
        Citizen.Wait(0)
    end
    return data
end

-- Get player any identifier, available types: steam, license, xbl, ip, discord, live.
function GetPlayerIdentifierFromType(type, source)
    local identifierCount = GetNumPlayerIdentifiers(source)
    for count = 0, identifierCount do
        local identifier = GetPlayerIdentifier(source, count)
        if identifier and string.find(identifier, type) then
            return identifier
        end
    end
    return nil
end

-- Turn RGB to decimal color.
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
    PerformHttpRequest(config.discordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {["Content-Type"] = "application/json"})
end

function money.functions.update(player)
    local player = tonumber(player)
    local license = GetPlayerIdentifierFromType("license", player)
    exports.oxmysql:query("SELECT cash, bank FROM money WHERE license = ?", {license}, function(result)
        if result then
            local cash = result[1].cash
            local bank = result[1].bank
            money.players[player].cash = cash
            money.players[player].bank = bank
            TriggerClientEvent("updateMoney", player, cash, bank)
        end
    end)
end

function money.functions.transferBank(amount, player, target)
    local amount = tonumber(amount)
    local player = tonumber(player)
    local target = tonumber(target)
    if player == target then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "You can't send money to yourself."}
        })
        return false
    elseif GetPlayerPing(target) == 0 then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "That player does not exist."}
        })
        return false
    elseif amount <= 0 then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "You can't send that amount."}
        })
        return false
    elseif money.players[player].bank < amount then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "You don't have enough money."}
        })
        return false
    else
        MySQL.query.await("UPDATE money SET bank = bank - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        money.functions.update(player)
        MySQL.query.await("UPDATE money SET bank = bank + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", target)})
        money.functions.update(target)
        TriggerClientEvent("chat:addMessage", player, {
            color = {0, 255, 0},
            args = {"Success", "You paid " .. GetPlayerName(target) .. " $" .. amount .. "."}
        })
        TriggerClientEvent("chat:addMessage", targetId, {
            color = {0, 255, 0},
            args = {"Success", GetPlayerName(player) .. " sent you $" .. amount .. "."}
        })
        return true
    end
end

function money.functions.giveCashToClosestTarget(amount, player)
    local player = tonumber(player)
    local amount = tonumber(amount)
    local playerFound = false
    local playerCoords = GetEntityCoords(GetPlayerPed(player))
    if money.players[player].cash < amount then
        TriggerClientEvent("chat:addMessage", player, {
            color = {255, 0, 0},
            args = {"Error", "You don't have enough money."}
        })
        return false
    else
        for _, target in pairs(GetPlayers()) do
            local targetId = tonumber(target)
            local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
            if (#(playerCoords - targetCoords) < 2.0) and (targetId ~= player) and not playerFound then
                exports.oxmysql:query("UPDATE money SET cash = cash - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
                money.functions.update(player)
                exports.oxmysql:query("UPDATE money SET cash = cash + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", targetId)})
                money.functions.update(targetId)
                playerFound = true
                TriggerClientEvent("chat:addMessage", player, {
                    color = {0, 255, 0},
                    args = {"Success", "You gave " .. GetPlayerName(target) .. " $" .. amount .. "."}
                })
                TriggerClientEvent("chat:addMessage", targetId, {
                    color = {0, 255, 0},
                    args = {"Success", GetPlayerName(player) .. " gave you $" .. amount .. "."}
                })
                break
            end 
        end
        if not playerFound then
            TriggerClientEvent("chat:addMessage", player, {
                color = {255, 0, 0},
                args = {"Error", "No players nearby."}
            })
            return false
        end
        playerFound = false
        return true
    end
end

function money.functions.deduct(amount, player, from)
    local amount = tonumber(amount)
    local player = tonumber(player)
    if from == "bank" then
        exports.oxmysql:query("UPDATE money SET bank = bank - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        Citizen.Wait(500)
        money.functions.update(player)
    elseif from == "cash" then
        exports.oxmysql:query("UPDATE money SET cash = cash - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        Citizen.Wait(500)
        money.functions.update(player)
    end
end

function money.functions.add(amount, player, to)
    local amount = tonumber(amount)
    local player = tonumber(player)
    if to == "bank" then
        exports.oxmysql:query("UPDATE money SET bank = bank + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        Citizen.Wait(500)
        money.functions.update(player)
    elseif to == "cash" then
        exports.oxmysql:query("UPDATE money SET cash = cash + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        Citizen.Wait(500)
        money.functions.update(player)
    end
end

function money.functions.withdraw(amount, player)
    local amount = tonumber(amount)
    local player = tonumber(player)
    if money.players[player].bank >= amount then
        exports.oxmysql:query("UPDATE money SET bank = bank - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        exports.oxmysql:query("UPDATE money SET cash = cash + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        Citizen.Wait(500)
        money.functions.update(player)
        return true
    end
    return false
end

function money.functions.deposit(amount, player)
    local amount = tonumber(amount)
    local player = tonumber(player)
    if money.players[player].cash >= amount then
        exports.oxmysql:query("UPDATE money SET cash = cash - ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        exports.oxmysql:query("UPDATE money SET bank = bank + ? WHERE license = ?", {amount, GetPlayerIdentifierFromType("license", player)})
        Citizen.Wait(500)
        money.functions.update(player)
        return true
    end
    return false
end

-- find out how much money the player has, if they're new and don't have money then it will give them the starting value.
RegisterNetEvent("getMoney")
AddEventHandler("getMoney", function()
    local player = source
    local license = GetPlayerIdentifierFromType("license", player)
    local cash = nil
    local bank = nil
    TriggerClientEvent("chat:addSuggestion", player, "/" .. server_config.payCommand, "Transfer money to player", {{name="id", help="Player server id" }, {name="amount", help="amount to pay"}})
    TriggerClientEvent("chat:addSuggestion", player, "/" .. server_config.giveCommand, "Give money to closeby player", {{ name="amount", help="amount to give" }})
    TriggerClientEvent("chat:addSuggestion", player, "/" .. server_config.adminAddCommand, "Add money to player", {{name="id", help="Player server id" }, {name="amount", help="amount to add"}})
    exports.oxmysql:query("SELECT cash, bank FROM money WHERE license = ?", {license}, function(result)
        if result then
            if not result[1] then
                exports.oxmysql:query("INSERT INTO money (license, cash, bank) VALUES (?, ?, ?)", {license, server_config.startingCash, server_config.startingBank})
                TriggerClientEvent("updateMoney", player, server_config.startingCash, server_config.startingBank)
                money.players[player] = {["cash"] = server_config.startingCash, ["bank"] = server_config.startingBank}
                return
            end
            local cash = result[1].cash
            local bank = result[1].bank
            money.players[player] = {["cash"] = cash, ["bank"] = bank}
            TriggerClientEvent("updateMoney", player, cash, bank)
        end
    end)
end)

-- Paying money from the bank account command.
RegisterCommand(server_config.payCommand, function(source, args, raw)
    local player = source
    local target = args[1]
    local amount = args[2]
    money.functions.transferBank(amount, player, target)
end)

-- Giving cash command.
RegisterCommand(server_config.giveCommand, function(source, args, raw)
    local player = source
    local amount = args[1]
    money.functions.giveCashToClosestTarget(amount, player)
end)

-- Giving money to players as a admin command.
if server_config.enableAddCommand then
    RegisterCommand(server_config.adminAddCommand, function(source, args, raw)
        local player = source
        local target = args[1]
        local amount = args[2]
        local discordUserId = string.gsub(GetPlayerIdentifierFromType("discord", player), "discord:", "")
        local roles = getUserDiscordInfo(discordUserId).roles
        local hasPerms = false

        for _, roleId in pairs(server_config.roles) do
            if roles[roleId] then
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
            if money.functions.add(amount, target, "bank") then
                TriggerClientEvent("chat:addMessage", target, {
                    color = {0, 130, 255},
                    args = {"Admin", "$" .. amount .. " was added to your bank account by the admin " .. GetPlayerName(player) .. " server id #" .. player .. "."}
                })
                if server_config.enableDiscordLogs then
                    sendToDiscord("Admin command used", GetPlayerName(player) .. " added $" .. amount .. " to " .. GetPlayerName(target) .. ".", 255, 0, 0)
                end
            end
        end
    end)
end

-- Salary
local salaryInterval = server_config.salaryInterval * 60000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(salaryInterval)
        for _, player in pairs(GetPlayers()) do
            if money.functions.add(server_config.salaryAmount, player, "bank") then
                TriggerClientEvent("chat:addMessage", target, {
                    color = {0, 255, 0},
                    args = {"Salary", "$" .. server_config.salaryAmount .. " received."}
                })
            end
        end
    end
end)
