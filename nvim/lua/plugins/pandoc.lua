return {
    {
        "vim-pandoc/vim-pandoc",
        dependencies = {
            { "vim-pandoc/vim-pandoc-syntax" },
        },
        config = function()
            vim.cmd([[
                let g:pandoc#command#autoexec_command = "Pandoc! pdf"
                let g:pandoc#command#latex_engine = "pdflatex"
                let g:pandoc#formatting#mode = "h"
                let g:pandoc#formatting#textwidth = &tw
                let g:pandoc#modules#disabled = ['folding']
            ]])
        end
    },
}
