require "./../tag.styl"

tagTemplate = require "./../tag.jade"

module.exports = class

    constructor: ( @options )->
        @queue = []

        @bindEvents()


    bindEvents: ->
        list = document.getElementsByClassName("work-item-list")[0]

        if not list then return

        list.addEventListener "DOMNodeInserted", @onEvent

        
    onEvent: ( event )=>
        element = event.target
        classes = element.classList

        if not classes? then return
        if classes.contains "marked_tag" then return

        switch
            when classes.contains "grid-header-column" then @processTitles element
            when classes.contains "grid-row" then @processRow element
            when classes.contains "grid-cell" then @processCell element


    processTitles: ( element )->
        if element.textContent is "Title"
            @titleIndex = @getNodeIndex element
            @processQueue name


    processQueue: ->
        if not @queue?.length then return

        for i in [(@queue.length - 1)..0]
            element = @queue[i]
            if element
                @processRow element
            @queue.splice i, 1


    getPositionInQueue: ( element )->
        @queue.reduceRight (previous, current, index)->
            if current.id is element.id then index else previous
        , null


    addToQueue: ( element )->
        currentIndexInQueue = @getPositionInQueue element

        if currentIndexInQueue?
            @queue[currentIndexInQueue] = element
        else
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
        html = element.innerHTML
        element.innerHTML = html.replace /\[(.+?)]/g, tagTemplate()


