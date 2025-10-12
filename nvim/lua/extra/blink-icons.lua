M = {}

---@module "blink.cmp"

---@param kind string
---@param icon string
---@return string
function M.get_lsp_icon(kind, icon)
    local mini_icon, _, _ = require("mini.icons").get("lsp", kind)
    if mini_icon then icon = mini_icon end
    return icon
end

---@param kind string
---@param hl string
---@return string
function M.get_lsp_hl(kind, hl)
    local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", kind)
    if mini_icon then hl = mini_hl end
    return hl
end

---@param kind string
---@return string
function M.filesystem_kind_to_category(kind)
    local category = "default"
    if kind == "Folder" then
        category = "directory"
    elseif kind == "File" then
        category = "file"
    end

    return category
end

---@param ctx blink.cmp.DrawItemContext
---@param icon string
---@return string
function M.get_path_icon(ctx, icon)
    local mini_icon, _, _ =
        require("mini.icons").get(M.filesystem_kind_to_category(ctx.kind), ctx.label)
    if mini_icon then icon = mini_icon end
    return icon
end

---@param ctx blink.cmp.DrawItemContext
---@param hl string
---@return string
function M.get_path_hl(ctx, hl)
    local mini_icon, mini_hl, _ =
        require("mini.icons").get(M.filesystem_kind_to_category(ctx.kind), ctx.label)
    if mini_icon then hl = mini_hl end
    return hl
end

---@param source_name string
---@param icon string
---@return string
function M.get_special_icon(source_name, icon)
    local lspkind = require("lspkind")
    if vim.tbl_contains({ "spell", "cmdline", "markdown", "Dict" }, source_name) then
        return lspkind.symbolic(source_name, { mode = "symbol" })
    end
    return icon
end

---@param ctx blink.cmp.DrawItemContext
---@return string
function M.get_text(ctx)
    local icon = ctx.kind_icon

    if vim.tbl_contains({ "LSP" }, ctx.source_name) then
        icon = M.get_lsp_icon(ctx.kind, icon)
    elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
        icon = M.get_path_icon(ctx, icon)
    else
        icon = M.get_special_icon(ctx.source_name, icon)
    end

    return icon .. ctx.icon_gap
end

---@param ctx blink.cmp.DrawItemContext
---@return string
function M.get_highlight(ctx)
    local hl = "BlinkCmpKind" .. ctx.kind
        or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)

    if vim.tbl_contains({ "LSP" }, ctx.source_name) then
        hl = M.get_lsp_hl(ctx.kind, hl)
    elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
        hl = M.get_path_hl(ctx, hl)
    end

    return hl
end

return M
