# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready((event) ->
    $('#node-edit').autoGrow()
    if(window.history.replaceState)
        window.history.replaceState({},"",window.location.pathname.replace(/%20/g, "\u00A0"))
    scheme = "ws://"
    uri    = scheme + window.document.location.host + "/"
    ws     = new WebSocket(uri)
    ws.onmessage = (message) ->
        data = JSON.parse(message.data)
        $("#chat-text").append("<div class='panel panel-default'><div class='panel-heading'>" + data.handle + "</div><div class='panel-body'>" + data.text + "</div></div>")
        $("#chat-text").stop().animate({
            scrollTop: $('#chat-text')[0].scrollHeight
        }, 800)
    $("#input-form").on("submit", (event) ->
        event.preventDefault()
        handle = $("#input-handle")[0].value
        text   = $("#input-text")[0].value
        ws.send(JSON.stringify({ handle: handle, text: text }))
        $("#input-text")[0].value = ""
    )

)


