class OptionsModel

    defaults:
        useTagDecorators: true
        useOtherStyling: false

    constructor: ->
        @fetch()

    fetch: ->
        chrome.storage.sync.get @load.bind @

    load: ( {options} )->
        options = Object.assign {}, @defaults, options

        for option, value of options
            @[ option ] = value

    save: =>
        options = {}
        for option, value of @
            if typeof value isnt "function"
                options[option] = value
        console.log options
        chrome.storage.sync.set { options }
        @fetch()


    cancel: =>
        chrome.storage.sync.clear()
        console.log "cancel"


module.exports = OptionsModel