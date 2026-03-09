-- ── Neovim init.lua ───────────────────────────────────────────────────────────
-- Managed by chezmoi — edit with: chezmoi edit --apply ~/.config/nvim/init.lua
-- LazyVim distribution: https://www.lazyvim.org/
-- This file only bootstraps lazy.nvim and LazyVim.
-- All customisation lives in lua/plugins/*.lua

-- ── Bootstrap lazy.nvim ───────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to continue..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- ── Setup lazy.nvim with LazyVim ─────────────────────────────────────────────
require("lazy").setup({
    spec = {
        -- LazyVim base distribution
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- LazyVim extras (opt-in feature sets)
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.tailwind" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.yaml" },
        { import = "lazyvim.plugins.extras.lang.docker" },
        { import = "lazyvim.plugins.extras.lang.ansible" },
        { import = "lazyvim.plugins.extras.formatting.biome" },
        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
        -- Our custom plugins
        { import = "plugins" },
    },
    defaults = {
        lazy    = false,
        version = false,  -- Use latest git commit, not pinned versions
    },
    install = {
        colorscheme = { "catppuccin" },
    },
    checker = {
        enabled = true,   -- Notify on plugin updates
        notify  = false,  -- Don't pop up every session
    },
    performance = {
        rtp = {
            -- Disable built-in plugins we don't use
            disabled_plugins = {
                "gzip", "matchit", "matchparen",
                "netrwPlugin", "tarPlugin", "tohtml",
                "tutor", "zipPlugin",
            },
        },
    },
})
