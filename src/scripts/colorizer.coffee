_ = require "./utils"

module.exports = class

    constructor: ( @columns = ["Title"] )->
        @queue = {}
        @indexes = {}
        for column in @columns
            @queue[ column ] = []
#        console.log @queue
        @bindEvents()


    bindEvents: ->
        list = document.getElementsByClassName("work-item-list")[0]

        list.addEventListener "DOMNodeInserted", ( event )=>
            element = event.target
            classes = element.classList
            switch
                when classes.contains( "grid-header-column" )
                    @processTitles element
                when classes.contains( "grid-row" )
                    @processRow element

    processTitles: ( element )->
        name = element.textContent
        if @columns.includes name
            @indexes[ name ] = _.getNodeIndex element
            @processQueue name

    processQueue: ( queueName )->
        queue = @queue[ queueName ]
        titleIndex = @indexes[ queueName ]
        console.log "processQueue #{queueName}, index: #{titleIndex}, size: #{queue?.length})"
        if queue?.length
            console.log "queue:", queue
            for element,i in queue
                if element then @processRow element
                delete @queue[ "Title" ][i]
                console.log "processed ##{i} element from queue"
            console.log "queue:", queue


    processRow: ( element )->
        index = @indexes[ "Title" ]
        cell = element.children[index]

        if index?.length
            console.log "decorate tags for row #{cell.textContent}"
            _.decorateTags cell
        else
            console.log "add to queue row #{element.textContent}"
            @queue[ "Title" ].push element

#        if ["Title"]?
#            titleElement = row.children[ targetColumns["Title"] ]
#            tagRegexp = /\[.+]/
#            if tagRegexp.test titleElement.textContent
#                _.decorateTags titleElement
#        else
#            if queueElements[ "Title" ] is undefined
#                queueElements[ "Title" ] = []
#            queueElements[ "Title" ].push row

        

#                when event.target.classList.contains( "grid-row" )
#                    console.info "render row"


#        $ document
#            .on allevents, @logEvents
#            .on events, ".work-item-list .grid-row", @onElementChange
#            .on "DOMNodeInserted", ".grid-header-canvas", @onTitleInsert

#
#    logEvents: ( event )->
#        switch
#            when event.target.classList.contains( "html" )
#                console.info "REPAINT ALL"
#                if targetColumns[ "Title" ]?.length
#                    @targetColumns[ "Title" ].length = 0
#                else
#                    if event.target
#                        if event.target.className
#                            console.log event.type, ".#{event.target.className}"
#                    else
#                        console.log event.type
#
#
#    onTitleInsert: ( event )=>
#        element = event.target
#        title = element.textContent.trim()
#
#        if observingTitles.indexOf( title ) >= 0
#            index = _.getNodeIndex element
#            targetColumns[ title ] = index
#            if queueElements[ title ]?.length
#                for row in queueElements[ title ]
#                    @process row
#                queueElements[ title ] = []
#
#
#    onElementChange: (event)=>
#        element = event.target
#        if element.classList.contains "grid-row"
#            @process element
#
#
