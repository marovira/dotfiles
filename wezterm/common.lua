M = {}

local wezterm = require("wezterm")

---@return boolean
function M.is_windows() return wezterm.target_triple == "x86_64-pc-windows-msvc" end

---@return boolean
function M.is_mac()
    return wezterm.target_triple == "x86_64-apple-darwin"
        or wezterm.target_triple == "aarch64-apple-darwin"
end

---@return boolean
function M.is_linux() return wezterm.target_triple == "x86_64-unknown-linux-gnu" end

--- Merge all the given tables into a single one
---@param ... table
---@return table
function M.merge_all(...)
    local ret = {}
    for _, tbl in ipairs({ ... }) do
        for k, v in pairs(tbl) do
            ret[k] = v
        end
    end
    return ret
end

---@return string
function M.get_default_cwd()
    if M.is_windows() then
        return "E:/"
    else
        return "~"
    end
end

return M
