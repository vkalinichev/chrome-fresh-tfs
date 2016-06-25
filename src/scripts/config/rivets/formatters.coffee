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
            when 0 then "red"
            when 1 then "green"
            when 2 then "blue"
            when 3 then "magenta"
            when 4 then "brown"
            when 5 then "pink"
            when 6 then "yellow"
            when 7 then "orange"
            when 8 then "cyan"
            when 9 then "skyblue"