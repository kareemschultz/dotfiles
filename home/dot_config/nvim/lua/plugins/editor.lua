-- ── Editor plugins ────────────────────────────────────────────────────────────
return {
    -- ── Harpoon 2: quick-jump between bookmarked files ─────────────────────────
    -- Usage: <leader>ha = add, Ctrl+e = menu, Ctrl+1/2/3/4 = jump
    {
        "ThePrimeagen/harpoon",
        branch       = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ha", function() require("harpoon"):list():add() end,
                desc = "Harpoon: add file" },
            { "<C-e>", function()
                local h = require("harpoon")
                h.ui:toggle_quick_menu(h:list())
            end, desc = "Harpoon: menu" },
            { "<C-1>", function() require("harpoon"):list():select(1) end, desc = "Harpoon: file 1" },
            { "<C-2>", function() require("harpoon"):list():select(2) end, desc = "Harpoon: file 2" },
            { "<C-3>", function() require("harpoon"):list():select(3) end, desc = "Harpoon: file 3" },
            { "<C-4>", function() require("harpoon"):list():select(4) end, desc = "Harpoon: file 4" },
        },
    },

    -- ── Trouble: LSP diagnostics + TODOs in a panel ───────────────────────────
    {
        "folke/trouble.nvim",
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location list" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix list" },
        },
    },

    -- ── Octo: GitHub PRs and issues inside Neovim ────────────────────────────
    {
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true,
        cmd    = "Octo",
        keys   = {
            { "<leader>ghi", "<cmd>Octo issue list<cr>",  desc = "GitHub: issues" },
            { "<leader>ghp", "<cmd>Octo pr list<cr>",     desc = "GitHub: PRs" },
            { "<leader>ghr", "<cmd>Octo review start<cr>",desc = "GitHub: review" },
        },
    },
}
