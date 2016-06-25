Rivets.formatters["localize"] = ( key )->
    chrome["i18n"]?.getMessage( key ) or "%#{key}%"