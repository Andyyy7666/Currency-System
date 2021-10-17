------------------------------------------------------------------------
--                                                                    --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
--                                                                    --
------------------------------------------------------------------------

config = {
    startingWallet = 2500, -- Amount of starting money in wallet.
    startingBank = 80000, -- Amount of starting money in the bank.

    payCommand = "pay", -- Command to transfer someone money from bank account.
    giveCommand = "give", -- Command to give someone close money from wallet.
    
    hudAlways = true, -- (Recomended) Set to true if you would like the Money HUD to always be active.
    showHUD = 20, -- Only if HudAlways is false then this will be the Keybind that will display your money on the top right of the screen. More buttons here: https://docs.fivem.net/docs/game-references/controls/

    salaryAmount = 300, -- the daily amount that players will receive.
    salaryInterval = 24, -- every x minutes the player will receive the salaryAmount.
}