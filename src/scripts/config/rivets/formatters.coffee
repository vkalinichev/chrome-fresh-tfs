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
        switch colorId
            when 0 then "#ffffdd"
            when 1 then "#ffddff"
            when 2 then "#ddffff"
            when 3 then "#ffdddd"
            when 4 then "#ddddff"
            when 5 then "#ddffdd"
            when 6 then "#eeffdd"
            when 7 then "#ddffee"
            when 8 then "#ffeedd"
            when 9 then "#ffddee"