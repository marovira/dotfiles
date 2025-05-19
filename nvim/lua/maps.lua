vim.keymap.set("i", "jk", "<ESC>", { desc = "Remap ESC to jk" })

local number_mode = false
vim.keymap.set("n", "<leader>tn", function()
    if number_mode then
        vim.opt.number = true
        vim.opt.relativenumber = true
        number_mode = false
    else
        vim.opt.number = true
        vim.opt.relativenumber = false
        number_mode = true
    end
end, { desc = "Toggle between relative and absolute numbers" })

vim.keymap.set(
    "n",
    "<ESC>",
    ":noh<CR><ESC>",
    { silent = true, desc = "Clear search highlight" }
)

vim.keymap.set("n", "<Space>", "@q", { desc = "Play macro stored in buffer q" })

-- LSP diagnostic keymaps
vim.keymap.set(
    "n",
    "gl",
    "<cmd>lua vim.diagnostic.open_float()<cr>",
    { desc = "LSP diagnostic open float" }
)
vim.keymap.set(
    "n",
    "[d",
    "<cmd>lua vim.diagnostic.goto_prev()<cr>",
    { desc = "LSP go to previous diagnostic" }
)
vim.keymap.set(
    "n",
    "]d",
    "<cmd>lua vim.diagnostic.goto_next()<cr>",
    { desc = "LSP go to next diagnostic" }
)

-- Movement keymaps
-- Allow returning to starting position when doing relative vertical jumps with C-o.
vim.keymap.set("n", "j", function()
    if vim.v.count > 0 then return "m'" .. vim.v.count .. "j" end
    return "j"
end, { expr = true })
vim.keymap.set("n", "k", function()
    if vim.v.count > 0 then return "m'" .. vim.v.count .. "k" end
    return "k"
end, { expr = true })

-- Return to the start of search.
local mark_search_keys = {
    ["/"] = "Search forward",
    ["?"] = "Search backward",
    ["*"] = "Search current word (forward)",
    ["#"] = "Search current word (backward)",
    ["g*"] = "Search current word (forward, not whole word)",
    ["g#"] = "Search current word (backward, not whole word)",
}

for key, desc in pairs(mark_search_keys) do
    vim.keymap.set("n", key, "ms" .. key, { desc = desc })
end

-- Clear search highlight when jumping back tot he beginning.
vim.keymap.set("n", "`s", function()
    vim.cmd("normal! `s")
    vim.cmd.nohlsearch()
end)

-- P4 commands
vim.keymap.set("n", "<leader>pe", function()
    local p4 = require("extra.p4").new()
    p4:edit()
end, { desc = "Checkout file for edit in Perforce" })

vim.keymap.set("n", "<leader>pr", function()
    local p4 = require("extra.p4").new()
    p4:revert()
end, { desc = "Revert file in Perforce" })
