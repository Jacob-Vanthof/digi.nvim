local M = {}

function M.search_by_card_number(card_number)
    local url = "https://digimoncard.io/api-public/search.php?card=" .. vim.fn.shellescape(card_number)
    
    vim.schedule(function()
        local handle = io.popen("curl -s " .. url)
        if not handle then
            vim.notify("Failed to execute curl command", vim.log.levels.ERROR)
            return
        end
        
        local response = handle:read("*a")
        handle:close()
        
        local ok, data = pcall(vim.fn.json_decode, response)
        if not ok or type(data) ~= "table" then
            vim.notify("Failed to parse JSON response", vim.log.levels.ERROR)
            return
        end
        
        if #data == 0 then
            vim.notify("No card found for: " .. card_number, vim.log.levels.INFO)
            return
        end
        
        -- Create a new buffer to display results
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            "Card Number: " .. data[1].card_number,
            "Name: " .. data[1].name,
            "Color: " .. data[1].color,
            "Type: " .. data[1].type,
            "Attribute: " .. (data[1].attribute or "N/A"),
            "Stage: " .. data[1].stage,
            "Digi-Type: " .. data[1].digi_type,
            "DP: " .. data[1].dp,
            "Play Cost: " .. data[1].play_cost,
            "Evolution Cost: " .. (data[1].evolution_cost or "N/A"),
            "Effect: " .. data[1].effect,
        })
        
        -- Open the buffer in a split window
        vim.cmd("split")
        vim.api.nvim_win_set_buf(0, buf)
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end)
end

return M

