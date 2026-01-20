return {
    settings = {
        ty = {
            disableLanguageService = false, -- Enable/disable LSP
            diagnosticMode = "workspace", -- Enable diagnostics on workspace
            showSyntaxErrors = true,
            inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
            },
            completions = {
                autoImport = false, -- Don't add imports. May change this later
            },
        },
    },
}
