"use strict";

var connection = new signalR.HubConnectionBuilder().withUrl("/colorHub").build();

connection.on("ReceiveMessage", function (color) {
    document.getElementById('overlay').style.background = color;
    document.getElementById('current').style.background = color;
});

connection.start().then(function () {
}).catch(function (err) {
    return console.error(err.toString());
});

