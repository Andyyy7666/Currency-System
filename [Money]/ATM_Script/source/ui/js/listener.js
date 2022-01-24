$(function() {
    let deposit = false
    let withdraw = false

    function display(bool) {
        if (bool) {
            $("#overlay").show();
        } else {
            $("#overlay").hide();
        }
    }
    function atmDisplay(bool) {
        if (bool) {
            $("#atm").show();
            $("#loader").hide();
            $("#confirmationScreen").hide();
            $("#successScreen").hide()
        } else {
            $("#atm").hide();
        }
    }
    function loader(bool) {
        if (bool) {
            $("#loader").show();
            $("#atm").hide();
            $("#confirmationScreen").hide();
            $("#successScreen").hide()
        } else {
            $("#loader").hide();
        }
    }
    function confirmationScreen(bool) {
        if (bool) {
            $("#confirmationScreen").show();
            $("#atm").hide();
            $("#loader").hide();
            $("#successScreen").hide()
        } else {
            $("#confirmationScreen").hide();
        }
    }
    function successScreen(bool) {
        if (bool) {
            $("#successScreen").show()
            $("#confirmationScreen").hide();
            $("#atm").hide();
            $("#loader").hide();
        } else {
            $("#successScreen").hide()
        }
    }
    display(false)
    atmDisplay(true)
    loader(false)
    confirmationScreen(false)
    successScreen(false)

    const options = {year: 'numeric', month: 'long', day: 'numeric'};
    const today = new Date();

    window.addEventListener("message", function(event) {
        const item = event.data;
        if (item.status) {
            display(true)
            $("#playername").text(item.playerName)
            $("#balance").text(item.balance)
            $("#date").text(`${item.date}, ${today.toLocaleDateString("en-US", options)}`)
            $("#time").text(item.time)
        } else {
            display(false)
        }
    })

    $("#withdrawButton").click(function() {
        withdraw = true
        $.post(`https://${GetParentResourceName()}/sound`);
        atmDisplay(false)
        loader(true)
        setTimeout(() => {
            loader(false)
            confirmationScreen(true)
        }, 400);
        return false
    })

    $("#depositButton").click(function() {
        deposit = true
        $.post(`https://${GetParentResourceName()}/sound`);
        atmDisplay(false)
        loader(true)
        setTimeout(() => {
            loader(false)
            confirmationScreen(true)
        }, 400);
        return false
    })

    $("#cancelButton").click(function() {
        withdraw = false
        deposit = false
        $.post(`https://${GetParentResourceName()}/sound`);
        confirmationScreen(false)
        loader(true)
        setTimeout(() => {
            loader(false)
            atmDisplay(true)
        }, 300);
        return false
    })

    $("#atm").submit(function() {
        $.post(`https://${GetParentResourceName()}/sound`);
        confirmationScreen(false)
        loader(true)
        setTimeout(() => {
            loader(false)
            if (withdraw) {
                $.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
                    amount: $("#enteredAmount").val()
                }));
            } else if (deposit) {
                $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({
                    amount: $("#enteredAmount").val()
                }));
            }
            withdraw = false
            deposit = false
            successScreen(true)
        }, 2500);
        return false
    })

    $("#mainMenuButton").click(function() {
        $.post(`https://${GetParentResourceName()}/sound`);
        successScreen(false)
        loader(true)
        setTimeout(() => {
            loader(false)
            atmDisplay(true)
        }, 300);
        return false
    })

    $("#closeButton").click(function() {
        $.post(`https://${GetParentResourceName()}/close`);
        return
    })
});