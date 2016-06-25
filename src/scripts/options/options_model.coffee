keycode = require "keycode"

class OptionsModel

    defaults:
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

        useOtherStyling: false

    constructor: ->
        @fetch()

    fetch: ->
        chrome.storage.sync.get @load.bind @

    load: ( {options} )->
        options = Object.assign {}, @defaults, options

        for option, value of options

            if option isnt "defaults"
                @[ option ] = value

    save: =>
        options = {}

        for option, value of @
            if typeof value is "function" then continue
            if option is "defaults" then continue
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



    cancel: =>
        chrome.storage.sync.clear()
        console.log "cancel"


module.exports = OptionsModel