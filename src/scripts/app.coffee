Freshener = require "./core/freshener"

chrome.storage.sync.get ( {options} )->

    new Freshener options