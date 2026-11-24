local lint = {}

local common = require("common")

--- Custom parser for clang-tidy to ensure that it parses Windows paths properly. The
--- default parser that ships with nvim-lint removes the leading drive letter, which
--- causes diagnostics to be dropped altogether.
---@param output string
---@param bufnr number
---@param _ string
---@return vim.Diagnostic[]
function lint.clangtidy_parser(output, bufnr, _)
    local severity_map = {
        ["error"] = vim.diagnostic.severity.ERROR,
        ["warning"] = vim.diagnostic.severity.WARN,
        ["information"] = vim.diagnostic.severity.INFO,
        ["hint"] = vim.diagnostic.severity.HINT,
        ["note"] = vim.diagnostic.severity.HINT,
    }

    local diagnostics = {}
    local bufname = vim.api.nvim_buf_get_name(bufnr):gsub("\\", "/"):lower()

    for line in output:gmatch("[^\r\n]+") do
        -- lintatch optional Windows drive prefix (e.g. "E:") so ":" doesn't split the path
        local drive, rest = line:match("^([a-zA-Z]:)(.+)$")
        local target = drive and rest or line

        local file, lnum, col, sev, message, code =
            target:match("^([^:]+):(%d+):(%d+): (%w+): ([^[]+) %[(.*)%]$")

        if file and lnum and col and sev and message then
            local full_path = (drive and (drive .. file) or file):gsub("\\", "/")
            if full_path:lower() == bufname then
                local trimmed_msg = vim.trim(message)
                if code and code ~= "" then
                    trimmed_msg = string.format("%s [%s]", trimmed_msg, code)
                end

                table.insert(diagnostics, {
                    bufnr = bufnr,
                    lnum = math.max(0, tonumber(lnum) - 1),
                    col = math.max(0, tonumber(col) - 1),
                    severity = severity_map[sev] or vim.diagnostic.severity.WARN,
                    message = trimmed_msg,
                    source = "clang-tidy",
                })
            end
        end
    end

    return diagnostics
end

---@param prefix string
---@param min_version integer?
---@param max_version integer?
---@return string
local function find_llvm_cmd(prefix, min_version, max_version)
    if common.is_windows() or common.is_mac() then return prefix end

    local start_ver = min_version or 18
    local end_ver = max_version or 50

    for ver = start_ver, end_ver do
        local cmd = string.format("%s-%d", prefix, ver)
        if vim.fn.executable(cmd) == 1 then return cmd end
    end

    return prefix
end

---@return string
function lint.get_clangformat_cmd() return find_llvm_cmd("clang-format") end

---@return string
function lint.get_clangtidy_cmd() return find_llvm_cmd("clang-tidy") end

return lint
