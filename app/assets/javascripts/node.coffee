# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

set_presence = (data) ->
    if(! data["presence"])
        return
    $(".presence-" + data.presence).remove()
    if(data["user"] == $(".your-name").text())
        return
    presence_message = data["user"]
    if(data["action"] == 'departed')
        [namespace, name] = data["to"]
        presence_message += " left"
        if(name)
            presence_message += " via " + "<a href=\"/"+namespace+"/"+name+"\">"+name+"</a>"
    if(data["action"] == 'arrived')
        [namespace, name] = data["from"]
        if(name)
            presence_message += " arrived from " + "<a href=\"/"+namespace+"/"+name+"\">"+name+"</a>"
        else
            presence_message += " is here"
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
    document.ws = ws
    ws.onopen = () ->
        setTimeout ( ->
            console.log("sending")
            ws.send(JSON.stringify({"echo": 1}))
        ), 500
    document.shout = () ->
        ws.send(JSON.stringify({"echo": 1}))
    ws.onmessage = (message) ->
        data = JSON.parse(message.data)
        console.log(data)
        set_presence(data)
        setTimeout ( ->
            console.log("sending")
            ws.send(JSON.stringify({"echo": 1}))
        ), 500
    ws.onerror = (evt) ->
        console.log("websocket error")
    ws.onclose = (event) ->
        console.log("websocket closed")
)


