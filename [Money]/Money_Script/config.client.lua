------------------------------------------------------------------------
--                                                                    --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
--                                                                    --
------------------------------------------------------------------------

config = {
    startingCash = 2500, -- Amount of starting money in wallet.
    startingBank = 8000, -- Amount of starting money in the bank.

    salaryAmount = 300, -- the daily amount that players will receive.
    salaryInterval = 24, -- every x minutes the player will receive the salaryAmount.

    payCommand = "pay", -- Command to transfer someone money from bank account.
    giveCommand = "give", -- Command to give someone close money from wallet.
    adminAddCommand = "addmoney", -- The command admins can use to add money to people. (Permissions and logs can be set for this in the config.)
}