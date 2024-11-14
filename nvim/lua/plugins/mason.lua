local mason_build = function()
    pcall(vim.api.nvim_command, "MasonUpdate")
end

local mason_dap_config = function()
    require("mason").setup()
    require("mason-nvim-dap").setup({
        automatic_setup = true,
        ensure_installed = {
            "python",
            "codelldb",
        },
        handlers = {
            function(config)
                require("mason-nvim-dap").default_setup(config)
            end,
            python = function() end
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
    })
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
        build = mason_build,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            { "williamboman/mason.nvim" },
            { "mfussenegger/nvim-dap" },
        },
        lazy = false,
        config = mason_dap_config,
    },
}
