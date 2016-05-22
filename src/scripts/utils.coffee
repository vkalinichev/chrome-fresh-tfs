module.exports = new class

    getNodeIndex: ( element )->
        [].indexOf.call element.parentNode.children, element

    decorateTags: ( element ) ->
        template = "<h1 class='marked_tag'>$1</h1> "
        element.innerHTML = element.innerHTML.replace /\[(.+?)]/g, template
