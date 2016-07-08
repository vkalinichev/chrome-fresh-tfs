keycode = require "keycode"
colors = require "../config/colors"
defaults = require "../config/defaults"

class OptionsModel

    constructor: ->
        @load options: defaults
        @fetch()


    fetch: ->
        chrome.storage.sync.get @load


    load: ( {options} )=>
        for option, value of options
            @[ option ] = value


    save: =>
        options = {}

        for option, value of @
            if typeof value isnt "function"
                if option is "colorizedTags"
                    value.map ( color )-> delete color["opened"]
                options[option] = value

        chrome.storage.sync.set { options }
        setTimeout close, 100


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


    toggleNewTagColorPicker: =>
        toggle = => @newTag.opened = not @newTag.opened
        setTimeout toggle, 0


    hideTooltips: =>
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


    cancel: ->
        setTimeout close, 100


module.exports = OptionsModel