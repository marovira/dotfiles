return {
    settings = {
        ty = {
            disableLanguageService = false, -- Enable/disable LSP
            diagnosticMode = "off", -- Disable diagnostics (until ALE supports ty)
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
