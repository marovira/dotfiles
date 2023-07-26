M = {}

function M.has_value(table, val)
    for _, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

return M
