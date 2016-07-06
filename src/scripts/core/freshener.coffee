require "./../tag.styl"

tagTemplate = require "./../tag.jade"

module.exports = class

    constructor: ( @options )->
        @queue = []

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
        time = +new Date
        if time < @lastGetTitleTime + 100 then return

        if element.textContent is "Title"
            @titleIndex = @getNodeIndex element
            @processQueue()


    processQueue: ->
        if not @queue?.length then return

        for i in [(@queue.length - 1)..0]
            element = @queue[i]
            if element
                @processRow element
            @queue.splice i, 1


    addToQueue: ( element )->
        unless @queue.includes element
            @queue.push element


    processRow: ( element )->

        if @titleIndex?
            cell = element.children[ @titleIndex ]
            @processCell cell
        else
            @addToQueue element


    getNodeIndex: ( element )->
        [].indexOf.call element.parentNode.children, element


    processCell: ( element ) ->
        if @options.useTagDecorators
            html = element.innerHTML
            element.innerHTML = html.replace /\[(.+?)]/g, tagTemplate()


