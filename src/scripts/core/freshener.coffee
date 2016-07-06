require "./../tag.styl"
tagTemplate = require "./../tag.jade"

module.exports = class

    constructor: ( @options = {} )->
        @queue = []

        if @options.colorizeTags
            for color,i in @options.colors
                document.documentElement.style.setProperty "--fresh-color-#{i}", color, null

        @bindEvents()


    bindEvents: ->
        list = document.getElementsByClassName("work-item-list")[0]

        list.addEventListener "DOMNodeInserted", @onEvent

        
    onEvent: ( event )=>
        element = event.target
        classes = element.classList

        if not classes? then return
        if classes.contains "fresh-tfs-tag" then return

        switch
            when classes.contains "grid-header-column" then @processTitle element
            when classes.contains "grid-row" then @processRow element
            when classes.contains "grid-cell" then @processCell element


    processTitle: ( element )->
        if element.title is "Title"
            @titleIndex = @getNodeIndex element
            @processQueue()


    processQueue: ->
        if not @queue?.length then return

        for i in [(@queue.length - 1)..0]
            element = @queue[i]
            @processRow element, true if element
            @queue.splice i, 1


    addToQueue: ( element )->
        unless @queue.includes element
            @queue.push element


    processRow: ( element, forced )->
        if not forced and @getNodeIndex( element ) is 2
            delete @titleIndex

        if @titleIndex?
            cell = element.children[ @titleIndex ]
            @processCell cell
        else
            @addToQueue element


    getNodeIndex: ( element )->
        [].indexOf.call element.parentNode.children, element


    escapeRegExp = (str)->
        str.replace /[\-\[\]\/\{\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"


    processCell: ( element ) ->
        if @options.useTagDecorators
            html = element.innerHTML
            html = html.replace /\[(.+?)]/g, tagTemplate()

            if @options.colorizeTags
                for tag in @options.colorizedTags
                    needle = "data-fresh-tfs-tag=\"#{ tag.name }\""
                    html = html.replace (new RegExp escapeRegExp( needle ), "gi"), "#{ needle } style=\"background-color: var(--fresh-color-#{ tag.color })\""

            element.innerHTML = html

