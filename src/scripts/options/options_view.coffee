OptionsModel = require "./options_model"

class OptionsView

    template: require "./options_template"
    styles: require "./options.styl"
    elementId: "options"

#    model:
#        useTagDecorators: true
#        useOtherStyling: false

    constructor: ( @options )->
        @el = document.getElementById @elementId
        @model = new OptionsModel options
        @render()

    render: ->
        @el.innerHTML = @template()
        Rivets.bind @el, @model




module.exports = new OptionsView()
