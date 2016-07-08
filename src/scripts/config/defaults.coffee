colors = require "./colors"

module.exports =

    useTagDecorators: true

    colorizeTags: false

    colorizedTags: [
        {color: 0, name: "iteration"}
        {color: 1, name: "backlog"}
    ]

    newTag:
        name: ""
        color: 0

    colors: colors

    useOtherStyling: false