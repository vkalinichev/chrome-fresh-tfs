list = document.getElementsByClassName("work-item-list")[0]

if list

    Freshener = require "./core/freshener"

    chrome.storage.sync.get ( {options} )->

        new Freshener options