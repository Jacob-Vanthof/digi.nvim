local digimon = require('digi.nvim')

local M = {}

function M.setup(opts)
    -- Add some options here later
end

vim.api.nvim_create_user_command('DigiSearch', function(opts)
    digimon.search_by_card_number(opts.args)
end, {nargs = 1, desc = "Search Digimon card by card number (e.g. BT4-016)"})
