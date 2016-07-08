list = document.getElementsByClassName("work-item-list")[0]
defaults = require "./config/defaults"

if list

    Freshener = require "./core/freshener"

    chrome.storage.sync.get ( {options} )->

        options = Object.assign {}, defaults, options

        new Freshener options