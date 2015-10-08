# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

set_presence = (data) ->
    if(! data["presence"])
        return
    $(".presence-" + data.presence).remove()
    presence_message = data["user"]
    if(data["action"] == 'departed')
        [namespace, name] = data["to"]
        presence_message += " left via " + "<a href=\"/"+namespace+"/"+name+"\">"+name+"</a>"
    if(data["action"] == 'arrived')
        [namespace, name] = data["from"]
        presence_message += " arrived from " + "<a href=\"/"+namespace+"/"+name+"\">"+name+"</a>"
    if(data["action"] == 'is')
        presence_message += " is " + (data["verbing"] || "here")
    $(".presences").prepend("<span class=\"presence-" + data.presence + "\">" + presence_message + ". </span>")

document.set_presence = set_presence

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
        set_presence(data)
        ws.send("{}")
    ws.onerror = (evt) ->
        console.log("websocket error")
    ws.onclose = (event) ->
        console.log("websocket closed")
)


