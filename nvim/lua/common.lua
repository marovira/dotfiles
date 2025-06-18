M = {}

---@param table table
---@param val any
---@return boolean
function M.has_value(table, val)
    for _, value in ipairs(table) do
        if value == val then return true end
    end

    return false
end

---@param str string
---@return boolean
function M.is_empty_string(str) return str == nil or str == "" end

---@return boolean
function M.is_windows() return vim.fn.has("win32") ~= 0 or vim.fn.has("win64") ~= 0 end

---@return boolean
function M.is_mac() return vim.fn.has("mac") ~= 0 end

---@return string?
function M.get_mode()
    local CTRL_V = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
    local CTRL_S = vim.api.nvim_replace_termcodes("<C-s>", true, true, true)

    local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    if mode == "i" then
        return "i" -- insert
    elseif mode == "v" or mode == "V" or mode == CTRL_V then
        return "x" -- visual
    elseif mode == "s" or mode == "S" or mode == CTRL_S then
        return "s" -- select
    elseif mode == "C" and vim.fn.getcmdtype() ~= "=" then
        return "c" -- cmdline
    end
    return nil
end

---@param t table | string
---@return boolean
function M.is_buffer_filetype(t)
    if type(t) == "string" then return vim.bo.filetype == t end
    return vim.tbl_contains(t, vim.bo.filetype)
end

---@param buf integer
---@param t table | string
---@return boolean
function M.is_filetype(buf, t)
    if type(t) == "string" then return vim.bo[buf] == t end
    return vim.tbl_contains(t, vim.bo[buf].filetype)
end

---@return boolean
function M.is_insert_mode() return M.get_mode() == "i" end

---@param group string | []string
---@return boolean
function M.in_syntax_group(group)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if not M.is_insert_mode() then col = col + 1 end

    for _, syn_id in ipairs(vim.fn.synstack(row, col)) do
        syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
        local g = vim.fn.synIDattr(syn_id, "name")
        if type(group) == "string" and g == group then
            return true
        elseif type(group) == "table" and vim.tbl_contains(group, g) then
            return true
        end
    end

    return false
end

---@param capture string | []string
---@return boolean
function M.in_treesitter_capture(capture)
    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    if vim.api.nvim_get_mode().mode == "i" then col = col - 1 end

    local get_captures_at_pos = -- See neovim/neovim#20331
        require("vim.treesitter").get_captures_at_pos -- for neovim >= 0.8 or require('vim.treesitter').get_captures_at_position -- for neovim < 0.8

    local captures_at_cursor = vim.tbl_map(
        function(x) return x.capture end,
        get_captures_at_pos(buf, row, col)
    )

    if vim.tbl_isempty(captures_at_cursor) then
        return false
    elseif
        type(capture) == "string" and vim.tbl_contains(captures_at_cursor, capture)
    then
        return true
    elseif type(capture) == "table" then
        for _, v in ipairs(capture) do
            if vim.tbl_contains(captures_at_cursor, v) then return true end
        end
    end

    return false
end

---@return boolean
function M.in_wezterm()
    local pane = vim.env.WEZTERM_PANE
    return pane ~= nil
end

---@param data string
---@return string
function M.base64(data)
    data = tostring(data)
    local bit = require("bit")
    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local b64, len = "", #data
    for i = 1, len, 3 do
        local a, b, c = data:byte(i, i + 2)
        local buffer = bit.bor(bit.lshift(a, 16), bit.lshift(b or 0, 8), c or 0)
        for j = 0, 3 do
            local index = bit.rshift(buffer, (3 - j) * 6) % 64
            b64 = b64 .. b64chars:sub(index + 1, index + 1)
        end
    end
    local padding = (3 - len % 3) % 3
    b64 = b64:sub(1, -1 - padding) .. ("="):rep(padding)
    return b64
end

---@param key string
---@param value any
function M.set_wezterm_user_var(key, value)
    if not M.in_wezterm() then return end
    io.write(string.format("\027]1337;SetUserVar=%s=%s\a", key, M.base64(value)))
end

return M
