Object.assign Rivets.binders,

    "style-*": ( el, value )->
        prop = @args[0]
        el.style.setProperty prop, value