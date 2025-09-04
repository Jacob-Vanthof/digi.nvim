local M = {}

local function make_api_request(card_number)
    local url = "https://digimoncard.io/api-public/search.php?card=" .. vim.fn.shellescape(card_number)
    
    -- Use curl to make the API request
    local command = "curl -s " .. url
    local handle = io.popen(command)
    if not handle then
        return nil, "Failed to execute curl command"
    end
    
    local response = handle:read("*a")
    handle:close()
    
    return response, nil
end

local function parse_response(response)
    local ok, data = pcall(vim.fn.json_decode, response)
    if not ok or type(data) ~= "table" then
        return nil, "Failed to parse JSON response"
    end
    
    return data, nil
end

local function display_results(data, card_number)
    if #data == 0 then
        vim.notify("No card found for: " .. card_number, vim.log.levels.INFO)
        return
    end
    
    -- Create a new buffer to display results
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    
    -- Add card information to the buffer
    local card = data[1]
    table.insert(lines, "Card Number: " .. (card.id or "N/A"))
    table.insert(lines, "Name: " .. (card.name or "N/A"))
    table.insert(lines, "Color: " .. (card.color or "N/A"))
    table.insert(lines, "Type: " .. (card.type or "N/A"))
    table.insert(lines, "Attribute: " .. (card.attribute or "N/A"))
    table.insert(lines, "Stage: " .. (card.stage or "N/A"))
    table.insert(lines, "Digi-Type: " .. (card.digi_type or "N/A"))
    table.insert(lines, "DP: " .. (card.dp or "N/A"))
    table.insert(lines, "Play Cost: " .. (card.play_cost or "N/A"))
    table.insert(lines, "Evolution Cost: " .. (card.evolution_cost or "N/A"))
    table.insert(lines, "")
    table.insert(lines, "Effect: " .. (card.main_effect or "N/A"))
    table.insert(lines, "Rarity: " .. (card.rarity or "N/A"))
    
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_name(buf, "Digimon Card: " .. card_number)
    
    -- Open the buffer in a split window
    vim.cmd("vsplit")
    vim.api.nvim_win_set_buf(0, buf)
end

function M.search_by_card_number(card_number)
    -- Validate input
    if not card_number or card_number == "" then
        vim.notify("Card number is required", vim.log.levels.ERROR)
        return
    end
    
    -- Make API request
    local response, err = make_api_request(card_number)
    if err then
        vim.notify(err, vim.log.levels.ERROR)
        return
    end
    
    -- Parse response
    local data, parse_err = parse_response(response)
    if parse_err then
        vim.notify(parse_err, vim.log.levels.ERROR)
        return
    end
    
    -- Display results
    display_results(data, card_number)
end

return M

