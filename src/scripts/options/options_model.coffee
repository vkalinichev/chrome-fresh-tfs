keycode = require "keycode"
colors = require "../config/colors"

class OptionsModel

    useTagDecorators: true
    colorizeTags: true
    colorizedTags: [
        { color: 0, name: "iteration" }
        { color: 1, name: "backlog" }
        { color: 2, name: "ksu 2.0" }
        { color: 4, name: "js" }
        { color: 5, name: "c++" }
        { color: 6, name: "guip" }
    ]
    newTag:
        name: ""
        color: 0

    colors: colors

    useOtherStyling: false

    constructor: ->
        console.log window.om = @
        @fetch()

    fetch: ->
        chrome.storage.sync.get @load

    load: ( {options} )=>
        for option, value of options
            @[ option ] = value

    save: =>
        options = {}

        for option, value of @
            if typeof value is "function" then continue
            options[option] = value

        chrome.storage.sync.set { options }


    deleteTag: ( event, element )=>
        @colorizedTags.splice element.index, 1


    addTag: =>
        newTag = Object.assign {}, @newTag
        @colorizedTags.push newTag
        @newTag.name = ""

        @newTag.color = ++@newTag.color % 10


    addTagKeyDown: ( event )=>
        if event.keyCode is keycode "enter"
            @addTag event


    toggleTag: ( event, element )=>
        tag = @colorizedTags[ element.index ]
        toggle = -> tag.opened = not tag.opened
        setTimeout toggle, 0

    toggleNewTagColorPicker: ( event, element )=>
        toggle = => @newTag.opened = not @newTag.opened
        setTimeout toggle, 0

    hideTooltips: ( event )=>
        for tag,index in @colorizedTags
            tag.opened = false
        @newTag.opened = false

    setColorForTag: ( event, element )=>
        color = element[ "%color%" ]
        tag = element[ "%tag%" ]
        @colorizedTags[ tag ].color = color

    setColorForNewTag: ( event, element )=>
        color = element[ "%color%" ]
        @newTag.color = color


    cancel: =>
        chrome.storage.sync.clear()
        console.log "cancel"


module.exports = OptionsModel