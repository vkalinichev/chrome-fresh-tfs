colors = require "../colors"

Object.assign Rivets.formatters,

    isEmpty: ( value = "" )->
        "#{ value }".length is 0

    isFilled: ( value = "" )->
        "#{ value }".length isnt 0

    localize: ( key = "" )->
        chrome["i18n"]?.getMessage( key ) or "%#{key}%"

    length: ( array = [] )->
        array.length

    colorize: ( colorId = 0 )->
        colors[ colorId ]