return {
    {
        "lervag/vimtex",
        dependencies = {
            { "hrsh7th/cmp-omni" },
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                sources = {
                    { name = "spell" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "omni" },
                },
            })
        end,
    },
}
