-- ── Colorscheme: Catppuccin Mocha ─────────────────────────────────────────────
return {
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        priority = 1000,
        opts = {
            flavour               = "mocha",
            background            = { light = "latte", dark = "mocha" },
            transparent_background = false,
            show_end_of_buffer    = false,
            term_colors           = true,
            dim_inactive = {
                enabled    = false,
                shade      = "dark",
                percentage = 0.15,
            },
            styles = {
                comments   = { "italic" },
                conditionals = { "italic" },
                keywords   = { "italic" },
                functions  = {},
                variables  = {},
            },
            integrations = {
                cmp          = true,
                gitsigns     = true,
                nvimtree     = true,
                telescope    = true,
                treesitter   = true,
                which_key    = true,
                harpoon      = true,
                mason        = true,
                mini         = { enabled = true },
                noice        = true,
                notify       = true,
                lsp_trouble  = true,
                snacks       = true,
            },
        },
    },
    -- Tell LazyVim to use catppuccin
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "catppuccin" },
    },
}
