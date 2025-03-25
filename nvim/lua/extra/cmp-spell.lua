-- Custom implementation for spell completion for blink.

---@module "blink.cmp"

local common = require("common")
local defaults = {
    max_entries = 3,
    keep_all_entries = false,
    preselect_correct_word = true,
    preserve_case = true,
}

---@return boolean
local function enable_in_context()
    return common.in_treesitter_capture("spell")
        or common.is_buffer_filetype({ "markdown", "gitcommit", "tex", "text" })
end

---@param len integer
---@return integer
local function len_to_loglen(len) return math.ceil(math.log10(len + 1)) end

---@param input string
---@param number integer
---@param loglen integer
---@return string
local function number_to_text(input, number, loglen)
    return string.format(input .. "%0" .. loglen .. "d", number)
end

---@class cmp-spell.Source : blink.cmp.Source
---@field max_entries integer
---@field keep_all_entries boolean
---@field preselect_correct_word boolean
---@field preserve_case boolean
local source = {}

function source.new(opts)
    ---@type cmp-spell.Source
    local config = vim.tbl_deep_extend("keep", opts or {}, defaults)
    vim.validate({
        max_entries = { config.max_entries, "number" },
        keep_all_entries = { config.keep_all_entries, "boolean" },
        preselect_correct_word = { config.preselect_correct_word, "boolean" },
        preserve_case = { config.preserve_case, "boolean" },
    })

    return setmetatable(config, { __index = source })
end

---@return boolean
function source:enabled() return vim.wo.spell end

---@param input string
---@param items blink.cmp.CompletionItem[]
---@return blink.cmp.CompletionItem[]
function source:adjust_case(input, items)
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
---
---@param input string
---@return table
function source:candidates(input)
    local items = {}
    local entries = vim.fn.spellsuggest(input, self.max_entries)
    local offset
    local loglen
    local kind = vim.lsp.protocol.CompletionItemKind.Text
    if self.preselect_correct_word and vim.tbl_isempty(vim.spell.check(input)) then
        offset = 1
        loglen = len_to_loglen(#entries + offset)

        items[offset] = {
            label = input,
            filterText = input,
            kind = kind,
            sortText = number_to_text(input, offset, loglen),
            preselct = true,
        }
        if not self.keep_all_entries then return items end
    else
        offset = 0
        loglen = len_to_loglen(#entries + offset)
    end

    for k, v in ipairs(entries) do
        items[k + offset] = {
            label = v,
            filterText = self.keep_all_entries and input or v,
            sortText = self.keep_all_entries
                    and number_to_text(input, k + offset, loglen)
                or v,
            kind = kind,
            preselct = false,
        }
    end

    if self.preserve_case then items = self:adjust_case(input, items) end

    return items
end

---@param context blink.cmp.Context
---@param callback blink.cmp.CompletionResponse
function source:get_completions(context, callback)
    vim.schedule(function()
        local input = string.sub(
            context.line,
            context.bounds.start_col,
            context.bounds.start_col + context.bounds.length - 1
        )
        if enable_in_context() then
            callback({
                items = self:candidates(input),
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

return source
