-- ── UI plugins ───────────────────────────────────────────────────────────────
-- Theme is in colorscheme.lua. This file handles UI behaviour plugins.
return {

    -- ── Flash.nvim: jump anywhere on screen in 2-3 keystrokes ─────────────────
    -- Already included in LazyVim — just ensuring it's configured
    {
        "folke/flash.nvim",
        opts = {
            modes = {
                search = { enabled = true },   -- Flash during / search
                char   = { enabled = true },   -- Flash on f/t/F/T
            },
        },
    },

    -- ── Snacks.nvim: Folke's utility meta-plugin ───────────────────────────────
    -- Already in LazyVim; configuring dashboard and notifications
    {
        "folke/snacks.nvim",
        opts = {
            dashboard = {
                enabled = true,
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "startup" },
                },
            },
            notifier  = { enabled = true, timeout = 3000 },
            indent    = { enabled = true },
            scroll    = { enabled = true },
        },
    },

    -- ── which-key: keybind popup ───────────────────────────────────────────────
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>g",  group = "git" },
                { "<leader>gh", group = "github" },
                { "<leader>x",  group = "diagnostics/quickfix" },
                { "<leader>cs", group = "symbols/trouble" },
            },
        },
    },

    -- ── obsidian.nvim: edit Obsidian vault from Neovim ────────────────────────
    -- Vault path set to ~/notes (adjust to your actual vault path)
    {
        "epwalsh/obsidian.nvim",
        version      = "*",
        lazy         = true,
        ft           = "markdown",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            workspaces = {
                { name = "personal", path = "~/notes" },
            },
            completion = {
                nvim_cmp    = true,
                min_chars   = 2,
            },
            mappings = {
                ["gf"] = {
                    action  = function() return require("obsidian").util.gf_passthrough() end,
                    opts    = { noremap = false, expr = true, buffer = true },
                },
                ["<leader>ch"] = {
                    action  = function() return require("obsidian").util.toggle_checkbox() end,
                    opts    = { buffer = true },
                },
                ["<CR>"] = {
                    action  = function() return require("obsidian").util.smart_action() end,
                    opts    = { buffer = true, expr = true },
                },
            },
            ui = {
                enable          = true,
                checkboxes      = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                },
                bullets         = { char = "•", hl_group = "ObsidianBullet" },
                external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                reference_text  = { hl_group = "ObsidianRefText" },
                highlight_text  = { hl_group = "ObsidianHighlightText" },
                tags            = { hl_group = "ObsidianTag" },
                hl_groups = {
                    ObsidianTodo       = { bold = true, fg = "#f38ba8" },
                    ObsidianDone       = { bold = true, fg = "#a6e3a1" },
                    ObsidianRightArrow = { bold = true, fg = "#fab387" },
                    ObsidianTilde      = { bold = true, fg = "#cba6f7" },
                    ObsidianBullet     = { bold = true, fg = "#89b4fa" },
                    ObsidianRefText    = { underline = true, fg = "#cba6f7" },
                    ObsidianExtLinkIcon = { fg = "#cba6f7" },
                    ObsidianTag        = { italic = true, fg = "#89b4fa" },
                    ObsidianHighlightText = { bg = "#f9e2af" },
                },
            },
            -- Note ID format: YYYYMMDDHHMMSS-title-slug
            note_id_func = function(title)
                local suffix = ""
                if title ~= nil then
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.date("%Y%m%d%H%M%S")) .. "-" .. suffix
            end,
            -- Open in Obsidian app from nvim
            follow_url_func = function(url)
                vim.fn.jobstart({ "open", url })
            end,
        },
        keys = {
            { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "Obsidian: new note" },
            { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Obsidian: open in app" },
            { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: find note" },
            { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Obsidian: search" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Obsidian: backlinks" },
            { "<leader>ot", "<cmd>ObsidianTags<cr>",        desc = "Obsidian: tags" },
            { "<leader>od", "<cmd>ObsidianDailies<cr>",     desc = "Obsidian: dailies" },
            { "<leader>ol", "<cmd>ObsidianLinks<cr>",       desc = "Obsidian: links" },
            { "<leader>op", "<cmd>ObsidianPasteImg<cr>",    desc = "Obsidian: paste image" },
        },
    },
}
