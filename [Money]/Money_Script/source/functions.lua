------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

-- Functions for exports

-- Add to bank
function AddBank(amount)
    amount = tonumber(amount)
    if not config.hudAlways then
        HUD = true
    end
    bankAddedAmount = amount
	BankAdded = true
	Wait(1000)
	TriggerServerEvent("Andyyy:AddBank", amount)
	BankAdded = false
    if not config.hudAlways then
        if HUD == true then
            Wait(7000)
            HUD = false
        end
    end
end

-- Add to wallet
function AddCash(amount)
    amount = tonumber(amount)
    if not config.hudAlways then
        HUD = true
    end
    cashAddedAmount = amount
	CashAdded = true
	Wait(1000)
	TriggerServerEvent("Andyyy:AddCash", amount)
	CashAdded = false
    if not config.hudAlways then
        if HUD == true then
            Wait(7000)
            HUD = false
        end
    end
end

-- Remove from bank
function RemoveBank(amount)
    amount = tonumber(amount)
    if not config.hudAlways then
        HUD = true
    end
    bankRemovedAmount = amount
	BankRemoved = true
	Wait(1000)
	TriggerServerEvent("Andyyy:RemoveBank", amount)
	BankRemoved = false
    if not config.hudAlways then
        if HUD == true then
            HUD = false
        end
    end
end

-- Remove from cash
function RemoveCash(amount)
    amount = tonumber(amount)
    if not config.hudAlways then
        HUD = true
    end
    cashRemovedAmount = amount
	CashRemoved = true
	Wait(1000)
	TriggerServerEvent("Andyyy:RemoveCash", amount)
	CashRemoved = false
    if not config.hudAlways then
        if HUD == true then
            HUD = false
        end
    end
end

-- Deposits money from your wallet to your bank account.
function ToBank(amount)
	RemoveCash(amount)
	AddBank(amount)
end

-- Withdraws money from your bank account to your wallet.
function ToWallet(amount)
	RemoveBank(amount)
	AddCash(amount)
end

-- Cecks how much money you have in your bank.
function CheckBank()
	return bank
end

-- Checks how much cash you have in your wallet.
function CheckWallet()
	return cash
end

-- Transfer money from client to another player.
function TransferMoney(amount, playerId)
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
end

-- Give Cash to nearby player.
function GiveCash(amount)
    target, distance = GetClosestPlayer()
	if (distance ~= -1 and distance < 3) then
        print(GetPlayerServerId(target))
        local CashID = GetPlayerServerId(target)
        local SendingCashPlayerID = GetPlayerServerId(PlayerId(PlayerPedId(-1)))
        local RecivingCashPlayer = GetPlayerName(target)
        local SendingCashPlayer = GetPlayerName(PlayerId())
        local SendingCashAmount = tonumber(amount)
        if SendingCashAmount > cash then
            TriggerEvent("chat:addMessage", {
                template = "<div style='background-color: rgba(250, 22, 10, 0.5); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;'><b>ERROR: {0}.</b></div>",
                args = {"You don't have enough money."}
            })
        else
            RemoveCash(SendingCashAmount)
            TriggerServerEvent("Andyyy:GiveCash", CashID, SendingCashAmount, RecivingCashPlayer, SendingCashPlayer, SendingCashPlayerID)
        end
    else
		notify("No players nearby")
	end
end

-- Other Functions --
function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Text for money
function Text(text, x, y)
    SetTextFont(7)
    SetTextProportional(0)
    SetTextScale(0.55, 0.55)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Text for emojis
function Text2(text, x, y)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.35, 0.35)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Notification
function notify(Text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    DrawNotification(true, true)
end

-- Get closest player to you.
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end