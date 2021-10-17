$(function() {
    // Hide/show ui function
    function display(bool) {
        if (bool) {
            $("#overlay").show();
        } else {
            $("#overlay").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {       // check if message is ui
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }

        // Recive message from client.lua
        $('#playername').text(event.data.playerName);
        $('#balance').text(event.data.bankAmount);
    })

    // Close ui when ESC is pressed
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://Bank_Script/main', JSON.stringify({}));
            return
        }
    };

    $("#WithdrawButton").click(function () {
        let WithdrawValue = $("#enteredAmount").val()
        if (WithdrawValue > 2500) {
            $.post("http://Bank_Script/withdrawError", JSON.stringify({
                error: "Max withdraw amount: $2500"
            }))
            return
        } else if (!WithdrawValue) {
            $.post("http://Bank_Script/withdrawError", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        $.post('http://Bank_Script/withdraw', JSON.stringify({
            text: WithdrawValue,
        }));
        return;
    })

    $("#DepositButton").click(function () {
        let DepositValue = $("#enteredAmount").val()
        if (DepositValue > 2500) {
            $.post("http://Bank_Script/depositError", JSON.stringify({
                error: "Max deposit amount: $2500"
            }))
            return
        } else if (!DepositValue) {
            $.post("http://Bank_Script/depositError", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        $.post('http://Bank_Script/deposit', JSON.stringify({
            text: DepositValue,
        }));
        return;
    })

    $("#TransferButton").click(function () {
        let TransferValue = $("#TransferAmount").val()
        let PlayerIDValue = $("#TransferId").val()
        if (TransferValue > 10000) {
            $.post("http://Bank_Script/transferError", JSON.stringify({
                error: "Max transfer amount: $10000"
            }))
            return
        } else if ((!TransferValue) || (!PlayerIDValue)) {
            $.post("http://Bank_Script/transferError", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        $.post('http://Bank_Script/transfer', JSON.stringify({
            amount: TransferValue,
            playerId: PlayerIDValue,
        }));
        return;
    })

    $("#closeButton").click(function () {
        $.post('http://Bank_Script/main', JSON.stringify({}));
        return
    })
});