------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

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

-- Add to bank
function AddBank(amount)
    amount = tonumber(amount)
    HUD = true
    bankAddedAmount = amount
	BankAdded = true
	Wait(1000)
	bank = bank + amount
	BankAdded = false
    if HUD == true then
        Wait(7000)
        HUD = false
    end
end

-- Add to wallet
function AddCash(amount)
    amount = tonumber(amount)
    HUD = true
    cashAddedAmount = amount
	CashAdded = true
	Wait(1000)
	cash = cash + amount
	CashAdded = false
    if HUD == true then
        Wait(7000)
        HUD = false
    end
end

-- Remove from bank
function RemoveBank(amount)
    amount = tonumber(amount)
    HUD = true
    bankRemovedAmount = amount
	BankRemoved = true
	Wait(1000)
	bank = bank - amount
	BankRemoved = false
    if HUD == true then
        HUD = false
    end
end

-- Remove from cash
function RemoveCash(amount)
    amount = tonumber(amount)
    HUD = true
    cashRemovedAmount = amount
	CashRemoved = true
	Wait(1000)
	cash = cash - amount
	CashRemoved = false
    if HUD == true then
        HUD = false
    end
end

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