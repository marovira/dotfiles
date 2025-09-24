local common = require("common")

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        lazy = true,
        dependencies = {
            { "williamboman/mason.nvim" },
        },
        opts = {
            automatic_setup = true,
            ensure_installed = {
                "python",
                "codelldb",
            },
            handlers = {
                function(config) require("mason-nvim-dap").default_setup(config) end,
                python = function() end,
            },
            cpp = function(config)
                config.adapters = {
                    type = "server",
                    port = "${port}",
                    executable = {
                        command = vim.fs.joinpath(
                            ---@diagnostic disable-next-line: param-type-mismatch
                            vim.fn.stdpath("data"),
                            "mason",
                            "bin",
                            "codelldb"
                        ),
                        args = { "--port", "${port}" },
                    },
                }
                config.configurations = {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = "${fileDirname}/" .. "${fileBasenameNoExtension}",
                    cwd = "${fileDirname}",
                    stopOnEntry = false,
                    args = {},
                }
                require("mason-nvim-dap").default_setup(config)
            end,
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "jay-babu/mason-nvim-dap.nvim" },
        },
        config = function()
            local dap = require("dap")
            dap.defaults.python.exception_breakpoints = { "raised" }

            -- Hide the default terminal so it doesn't interfere with the layout.
            dap.defaults.fallback.terminal_win_cmd = function()
                return vim.api.nvim_create_buf(false, false)
            end

            -- Make sure dap-view starts when DAP is launched
            local auto_open = { "attach", "launch" }
            for _, listener in ipairs(auto_open) do
                dap.listeners.before[listener]["dap-view"] = function()
                    require("dap-view").open()
                end
            end

            local auto_close = { "event_terminated", "event_exited" }
            for _, listener in ipairs(auto_close) do
                dap.listeners.before[listener]["dap-view"] = function()
                    require("dap-view").close(true)
                end
            end
        end,
        keys = {
            {
                "<F5>",
                function() require("dap").continue() end,
                desc = "DAP start/continue",
            },
            {
                "<F10>",
                function() require("dap").step_over() end,
                desc = "DAP step over",
            },
            {
                "<F11>",
                function() require("dap").step_into() end,
                desc = "DAP step into",
            },
            {
                "<S-F11>",
                function() require("dap").step_out() end,
                desc = "DAP step out",
            },
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc = "DAP toggle breakpoint",
            },
            {
                "<leader>dl",
                function()
                    require("dap").set_breakpoint(
                        nil,
                        nil,
                        vim.fn.input("Log point message: ")
                    )
                end,
                desc = "DAP breakpoint with message",
            },
        },
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        opts = {
            enabled = false,
            virt_text_pos = "eol",
        },
        keys = {
            {
                "<leader>dt",
                function() require("nvim-dap-virtual-text").toggle() end,
                desc = "DAP toggle virtual text",
            },
        },
    },
    {
        "igorlfs/nvim-dap-view",
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text" },
        },
        opts = {
            winbar = {
                show = true,
                sections = {
                    "watches",
                    "scopes",
                    "exceptions",
                    "breakpoints",
                    "repl",
                    "threads",
                },
                default_section = "repl",
                controls = { enabled = true },
            },
            windows = {
                position = "below",
                terminal = {
                    position = "right",
                },
            },
            auto_toggle = true,
        },
        keys = {
            {
                "<leader>dv",
                function() require("dap-view").toggle() end,
                desc = "DAP toggle view",
            },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local path = vim.fs.joinpath(
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.fn.stdpath("data"),
                "mason",
                "packages",
                "debugpy",
                "venv"
            )
            if common.is_windows() then
                path = vim.fs.joinpath(path, "Scripts", "python")
            else
                path = vim.fs.joinpath(path, "bin", "python3")
            end

            local dap_py = require("dap-python")
            dap_py.setup(path, { include_configs = false })
            dap_py.test_runner = "pytest"

            local dap = require("dap")

            local get_args = function()
                local args_string = vim.fn.input("Arguments: ")
                local utils = require("dap.utils")
                return utils.splitstr(args_string)
            end

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "file",
                    program = "${file}",
                    console = "integratedTerminal",
                    justMyCode = true,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "sys:file",
                    program = "${file}",
                    console = "integratedTerminal",
                    justMyCode = false,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "file:args",
                    program = "${file}",
                    args = get_args,
                    console = "integratedTerminal",
                    justMyCode = true,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "sys:file:args",
                    program = "${file}",
                    args = get_args,
                    console = "integratedTerminal",
                    justMyCode = false,
                },
                {
                    type = "python",
                    request = "attach",
                    name = "attach",
                    connect = function()
                        local host = vim.fn.input("Host [127.0.0.1]: ")
                        host = host ~= "" and host or "127.0.0.1"
                        local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
                        return { host = host, port = port }
                    end,
                },
            }
        end,
        keys = {
            {
                "<leader>dpm",
                function() require("dap-python").test_method() end,
                desc = "DAP Python test method",
            },
            {
                "<leader>dpc",
                function() require("dap-python").test_class() end,
                desc = "DAP Python test class",
            },
            {
                "<leader>dps",
                function() require("dap-python").debug_selection() end,
                desc = "DAP Python selection",
            },
        },
    },
}
