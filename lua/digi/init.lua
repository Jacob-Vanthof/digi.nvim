local search = require("digi.commands.search")

local M = {}

function M.setup(opts)
    vim.api.nvim_create_user_command('DigiSearch', function(opts)
        search.search_by_card_number(opts.args)
    end, {
            nargs = 1,
            desc = "Search Digimon card by card number (e.g. BT4-016)"})

    -- Add some options here later
end

