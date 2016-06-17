require "./tag.styl"

module.exports = class

    constructor: ->
        @queue = []
        @titleIndex = null
        @counter1 = 0
        @counter2 = 0
        @bindEvents()


    bindEvents: ->
        list = document.getElementsByClassName("work-item-list")[0]

        list.addEventListener "DOMNodeInserted", @onEvent

    onEvent: ( event )=>
        element = event.target
        classes = element.classList

        if not classes? then return

        switch
            when classes.contains "grid-row" then @processRow element
            when classes.contains "grid-header-column" then @processTitles element


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
            @decorateTags cell
        else
            @addToQueue element


    getNodeIndex: ( element )->
        [].indexOf.call element.parentNode.children, element


    decorateTags: ( element ) ->
        template = "<span class='marked_tag'>$1</span> "
        element.innerHTML = element.innerHTML.replace /\[(.+?)]/g, template


