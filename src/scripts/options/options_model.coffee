keycode = require "keycode"

class OptionsModel

    useTagDecorators: true
    colorizeTags: true
    colorizedTags: [
        { color: 0, name: "iteration" }
        { color: 2, name: "backlog" }
        { color: 5, name: "screenshotter" }
        { color: 1, name: "ksu" }
        { color: 7, name: "installer" }
    ]
    newTag:
        name: ""
        color: 0
    colors: [
        "#ffffdd", "#ffddff", "#ddffff", "#ffdddd", "#ddddff"
        "#ddffdd", "#eeffdd", "#ddffee", "#ffeedd", "#ffddee"
    ]

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