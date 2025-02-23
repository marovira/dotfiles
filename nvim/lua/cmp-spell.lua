-- Custom implementation for spell completion for blink.

local common = require("common")

---@module "blink.cmp"

---@class cmp-spell.Config
local defaults = {
    max_entries = 3,
    keep_all_entries = false,
    preselect_correct_word = true,
    preserve_case = true,
}

---@class cmp-spell.Source: blink.cmp.Source
local M = {}

M.max_entries = 0 ---@type integer
M.keep_all_entries = false ---@type boolean
M.preselect_correct_word = true ---@type boolean
M.preserve_case = true ---@type boolean

---@param opts? cmp-spell.Config
function M.new(opts)
    local config = vim.tbl_deep_extend("keep", opts or {}, defaults)
    vim.validate({
        max_entries = { config.max_entries, "number" },
        keep_all_entries = { config.keep_all_entries, "boolean" },
        preselect_correct_word = { config.preselect_correct_word, "boolean" },
        preserve_case = { config.preserve_case, "boolean" },
    })

    return setmetatable({
        max_entries = config.max_entries,
        keep_all_entries = config.keep_all_entries,
        preselect_correct_word = config.preselect_correct_word,
        preserve_case = config.preserve_case,
    }, { __index = M })
end

---@return boolean
function M:enabled() return vim.wo.spell end

---@param len integer
---@return integer
function M:len_to_loglen(len) return math.ceil(math.log10(len + 1)) end

---@param input string
---@param number integer
---@param loglen integer
---@return string
function M:number_to_text(input, number, loglen)
    return string.format(input .. "%0" .. loglen .. "d", number)
end

---@param input string
---@param items blink.cmp.CompletionItem[]
---@return blink.cmp.CompletionItem[]
function M:adjust_case(input, items)
    local correct, case
    if input:match("^%l") then
        correct = "^%u%l+$"
        case = string.lower
    elseif input:match("^%u") then
        correct = "^%l+$"
        case = string.upper
    else
        return items
    end

    local seen = {}
    local out = {}
    for _, item in ipairs(items) do
        local raw
        if item.insertText ~= nil then
            raw = item.insertText
        else
            raw = item.label
        end

        if raw == nil then goto continue end

        local modified = raw
        if raw:match(correct) then
            local text = case(raw:sub(1, 1)) .. raw:sub(2)
            modified = text
            item.label = text
        end
        if not seen[modified] then
            seen[modified] = true
            table.insert(out, item)
        end

        ::continue::
    end
    return out
end

---@param input string
---@param src cmp-spell.Source
---@return table
function M:candidates(input, src)
    local items = {}
    local entries = vim.fn.spellsuggest(input, src.max_entries)
    local offset
    local loglen
    local kind = vim.lsp.protocol.CompletionItemKind.Text
    if src.preselect_correct_word and vim.tbl_isempty(vim.spell.check(input)) then
        offset = 1
        loglen = self:len_to_loglen(#entries + offset)

        items[offset] = {
            label = input,
            filterText = input,
            kind = kind,
            sortText = self:number_to_text(input, offset, loglen),
            preselct = true,
        }
        if not src.keep_all_entries then return items end
    else
        offset = 0
        loglen = self:len_to_loglen(#entries + offset)
    end

    for k, v in ipairs(entries) do
        items[k + offset] = {
            label = v,
            filterText = src.keep_all_entries and input or v,
            sortText = src.keep_all_entries
                    and self:number_to_text(input, k + offset, loglen)
                or v,
            kind = kind,
            preselct = false,
        }
    end

    if src.preserve_case then items = self:adjust_case(input, items) end

    return items
end

---@return boolean
function M:enable_in_context()
    return common.in_treesitter_capture("spell")
        or common.has_value({ "markdown", "gitcommit", "tex", "text" }, vim.bo.filetype)
end

---@param context blink.cmp.Context
---@param callback blink.cmp.CompletionResponse
function M:get_completions(context, callback)
    vim.schedule(function()
        local input = string.sub(
            context.line,
            context.bounds.start_col,
            context.bounds.start_col + context.bounds.length - 1
        )
        if self:enable_in_context() then
            callback({
                items = self:candidates(input, self),
                is_incomplete_forward = true,
                is_incomplete_backward = true,
            })
        else
            callback({
                items = {},
                is_incomplete_forward = true,
                is_incomplete_backward = true,
            })
        end
    end)
end

return M
