local common = require("common")

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            { "williamboman/mason.nvim" },
            { "mfussenegger/nvim-dap" },
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
    { "mfussenegger/nvim-dap" },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        opts = {
            layouts = {
                {
                    elements = {
                        {
                            id = "breakpoints",
                            size = 0.33,
                        },
                        {
                            id = "stacks",
                            size = 0.33,
                        },
                        {
                            id = "watches",
                            size = 0.33,
                        },
                    },
                    position = "left",
                    size = 50,
                },
                {
                    elements = {
                        {
                            id = "console",
                            size = 0.5,
                        },
                        {
                            id = "repl",
                            size = 0.5,
                        },
                    },
                    position = "bottom",
                    size = 20,
                },
            },
        },
        config = function(_, opts)
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup(opts)
            dap.defaults.python.exception_breakpoints = { "raised" }

            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

            vim.keymap.set(
                "n",
                "<F5>",
                function() require("dap").continue() end,
                { desc = "Launch DAP" }
            )
            vim.keymap.set(
                "n",
                "<F10>",
                function() require("dap").step_over() end,
                { desc = "DAP step over" }
            )
            vim.keymap.set(
                "n",
                "<F11>",
                function() require("dap").step_into() end,
                { desc = "DAP step into" }
            )
            vim.keymap.set(
                "n",
                "<S-F11>",
                function() require("dap").step_out() end,
                { desc = "DAP step out" }
            )
            vim.keymap.set(
                "n",
                "<Leader>b",
                function() require("dap").toggle_breakpoint() end,
                { desc = "DAP toggle breakpoint" }
            )
            vim.keymap.set(
                "n",
                "<Leader>lp",
                function()
                    require("dap").set_breakpoint(
                        nil,
                        nil,
                        vim.fn.input("Log point message: ")
                    )
                end,
                { desc = "DAP set breakpoint with message" }
            )
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
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
            dap_py.setup(path)
            dap_py.test_runner = "pytest"
        end,
    },
}
