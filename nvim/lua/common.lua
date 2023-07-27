M = {}

function M.has_value(table, val)
    for _, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

function M.is_windows()
    return vim.fn.has("win32") ~= 0 or vim.fn.has("win64") ~= 0
end

function M.is_mac()
    return vim.fn.has("mac") ~= 0
end

return M
