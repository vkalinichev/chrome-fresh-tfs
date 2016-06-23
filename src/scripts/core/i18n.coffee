module.exports = class I18n

    localize = ( key )->
        chrome?.i18n.getMessage key

    constructor: ->
        @i18n =
            text: document.querySelectorAll "[data-text]"
            placeholder: document.querySelectorAll "[data-placeholder]"
            title: document.querySelectorAll "[data-title]"

        @localizeAll()

    localizeAll: ->
        types = ["text", "placeholder", "title"]

        for type in types
            @i18n[ type ].forEach (item)->
                result = localize item.dataset[ type ]

                if type is text
                    item.innerText = result
                else
                    item[ type ] = result