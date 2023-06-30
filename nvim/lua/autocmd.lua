local function should_lsp_be_enabled()
    local lsp_filetypes = { 'python', 'cpp', 'lua', 'cmake' }
    local common = require('common')

    return common.has_value(lsp_filetypes, vim.bo.filetype)
end

local function should_diagnostic_be_enabled()
    local diagnostic_filetypes = { 'python' }
    local common = require('common')

    return common.has_value(diagnostic_filetypes, vim.bo.filetype)
end

function enable_diagnostic(enable)
    if enable then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

local function enable_lsp_autocomp(enable)
    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()

    if enable then
        vim.cmd('execute "MUcompleteAutoOff"')
        cmp.setup({
            enabled = function()
                local context = require 'cmp.config.context'
                if context.in_treesitter_capture('comment') == true or context.in_syntax_group('Comment') then
                    return false
                else
                    return true
                end
            end,
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'buffer', keyword_length = 3 },
            },
            mapping = {
                ['<Tab>'] = cmp_action.tab_complete(),
                ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
            }
        })
    else
        vim.cmd('execute "MUcompleteAutoOn"')
        cmp.setup({ enabled = false })
    end
end

local function set_state_for_large_files()
    vim.opt_local.bufhidden = 'unload'
    vim.opt_local.buftype = 'nowrite'
    vim.opt_local.eventignore = vim.opt_local.eventignore + 'FileType'
    vim.opt_local.undolevels = -1
    vim.opt_local.foldenable = false
    vim.cmd('execute "MUcompleteAutoOff"')
end

local function is_large_file()
    -- Large files start at 100MB
    local min_size = 1024 * 1024 * 100
    local f = vim.fn.expand('<afile>')
    if vim.fn.getfsize(f) > min_size then
        return true
    end

    return false
end

M = {}
function M.on_buffer_change(enter)
    local enable_lsp = should_lsp_be_enabled()
    local enable_diag = should_diagnostic_be_enabled()

    if enter then
        enable_diagnostic(enable_diag)
        enable_lsp_autocomp(enable_lsp)
    else
        enable_diagnostic(not enable_diag)
        enable_lsp_autocomp(not enable_lsp)
    end
end

function M.handle_large_buffer()
    if is_large_file() then
        set_state_for_large_files()
    end
end

return M
