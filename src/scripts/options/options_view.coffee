OptionsModel = require "./options_model"

defaults = require "../config/defaults"

class OptionsView

    template: require "./options_template"
    styles: require "./options.styl"
    elementId: "options"


    constructor: ( options )->
        @el = document.getElementById @elementId
        @model = new OptionsModel options
        @render()

    render: ->
        @el.innerHTML = @template()
        Rivets.bind @el, @model




module.exports = new OptionsView()
