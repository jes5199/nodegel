# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready((event) ->
    $('#node-edit').autoGrow()
    if(window.history.replaceState)
        window.history.replaceState({},"",window.location.pathname.replace(/%20/g, "\u00A0"))
    scheme = "ws://"
    uri    = scheme + window.document.location.host + window.document.location.pathname
    ws     = new WebSocket(uri)
    ws.onmessage = (message) ->
        data = JSON.parse(message.data)
        console.log(data)
)


