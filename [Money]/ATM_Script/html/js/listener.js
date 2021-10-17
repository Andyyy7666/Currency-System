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
        if (item.type === "ui") { // check if message is ui
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }

        // Recive message from client.lua
        $('#playername').text('Account - ' + event.data.playerName);
        $('#balance').text(event.data.bankAmount);
    })

    // Close ui when ESC is pressed
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://ATM_Script/main', JSON.stringify({}));
            return
        }
    };

    $("#WithdrawButton").click(function() {
        let WithdrawValue = $("#enteredAmount").val()
        if (WithdrawValue > 2500) {
            $.post("http://ATM_Script/withdrawError", JSON.stringify({
                error: "Max withdraw amount: $2500"
            }))
            return
        } else if (!WithdrawValue) {
            $.post("http://ATM_Script/withdrawError", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        $.post('http://ATM_Script/withdraw', JSON.stringify({
            text: WithdrawValue,
        }));
        return;
    })

    $("#DepositButton").click(function() {
        let DepositValue = $("#enteredAmount").val()
        if (DepositValue > 2500) {
            $.post("http://ATM_Script/depositError", JSON.stringify({
                error: "Max deposit amount: $2500"
            }))
            return
        } else if (!DepositValue) {
            $.post("http://ATM_Script/depositError", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        $.post('http://ATM_Script/deposit', JSON.stringify({
            text: DepositValue,
        }));
        return;
    })

    $("#closeButton").click(function() {
        $.post('http://ATM_Script/main', JSON.stringify({}));
        return
    })
});