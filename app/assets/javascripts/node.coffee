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

open_websocket = () ->
    uri    = "ws://" + window.document.location.host + window.document.location.pathname
    ws     = new WebSocket(uri)
    ws.onmessage = (message) ->
        data = JSON.parse(message.data)
        console.log(data)
        set_presence(data)
    ws.onerror = (evt) ->
        console.log("websocket error")
    ws.onclose = (event) ->
        console.log("websocket closed")

$(document).ready((event) ->
    $('#node-edit').autoGrow()
    if(window.history.replaceState)
        window.history.replaceState({},"",window.location.pathname.replace(/%20/g, "\u00A0"))
    open_websocket()
    $('input.title').val( $('#page-name').val() )
    $('input.title').on("keydown", (event) ->
        if(event.keyCode == 27)
            $('input.title').val( $('#page-name').val() )
            $("#content").css("opacity", "1.00")
    )
    $('input.title').on("input", ->
        if($('input.title').val() != $('#page-name').val())
            $("#content").css("opacity", "0.05")
        else
            $("#content").css("opacity", "1.00")
    )
    $('input.title').on("change", ->
        $('form.title').submit()
    )
    $('input.title').on("blur", ->
        $("#content").css("opacity", "1.0")
    )

    anchorNode = null
    parentNode = null
    highlightNode = null
    startOffset = null
    endOffset = null
    selectionTimer = null
    $(document).on("selectionchange", (event) ->
        selection = document.getSelection()
        if(selection.anchorNode &&
        selection.anchorNode == selection.focusNode &&
        selection.anchorNode.nodeType == Node.TEXT_NODE &&
        selection.anchorNode.parentNode.className == "node-body" &&
        selection.anchorNode.parentNode.tagName == "DIV" &&
        selection.anchorOffset != selection.focusOffset)
            if(selectionTimer)
                clearTimeout(selectionTimer)
            selectionTimer = setTimeout( ->
                $("#annotate-destination").on("blur")
                anchorNode = selection.anchorNode
                [startOffset, endOffset] = [selection.anchorOffset, selection.focusOffset].sort((a,b) -> return a > b)
                region = selection.anchorNode.data
                text = region.substring(startOffset, endOffset).trim()
                $("form#annotate").animate({"height": "64px"}, 500)
                show_text = text
                if text.length > 30
                    show_text = text.substring(0,30) + "..."
                $("#annotate-match").text(show_text)
                $("#annotate-text").val(text)
                $("#annotate-destination").val(text)
                $("#annotate-node-id").val($(selection.anchorNode.parentNode).attr("node_id"))
            , 1000)
        else
            if(selectionTimer)
                clearTimeout(selectionTimer)
            if ! $("#annotate-destination").is(":focus")
                selectionTimer = setTimeout( ->
                    $("form#annotate").animate({"height": "0px"}, 500)
                , 100)
    )

    $("#annotate-destination").on("focus", (event) ->
        if (anchorNode)
            if(selectionTimer)
                clearTimeout(selectionTimer)
            region = anchorNode.data
            parentNode = anchorNode.parentNode
            text = region.substring(startOffset, endOffset)
            $("form#annotate").animate({"height": "64px"}, 500)
            $("#annotate-destination").val(text.trim())
            highlighted_html = "<span class=\"highlighted-node\">" + region.substring(0, startOffset) +
            "<span class=\"highlighted-selection\">"+ text + "</span>" + region.substring(endOffset) +
            "</span>"
            highlightNode = $(highlighted_html)[0]
            parentNode.replaceChild(highlightNode, anchorNode)
    )

    $("#annotate-destination").on("blur", (event) ->
        if(selectionTimer)
            clearTimeout(selectionTimer)
        if (anchorNode && $(".highlighted-node").length)
            parentNode.replaceChild(anchorNode, highlightNode)
        $("form#annotate").animate({"height": "64px"}, 0)
    )
)


