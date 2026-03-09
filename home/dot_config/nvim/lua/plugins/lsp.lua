-- ── LSP + Mason ───────────────────────────────────────────────────────────────
return {
    -- Ensure these LSP servers/tools are installed via Mason
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                -- TypeScript / JS (Better-T-Stack)
                "typescript-language-server",
                "tailwindcss-language-server",
                "biome",
                -- Infrastructure / ops (NDMA stack)
                "ansible-language-server",
                "yaml-language-server",
                "dockerfile-language-server-nodejs",
                "bash-language-server",
                "helm-ls",
                -- Formatting
                "stylua",
                "shfmt",
                "prettier",
                -- Python
                "pyright",
                "black",
                "ruff-lsp",
                -- Misc
                "json-lsp",
                "marksman",    -- Markdown
                "taplo",       -- TOML
            })
        end,
    },

    -- LSP-specific options
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = true },
            servers = {
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            schemas = {
                                -- Docker Compose
                                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yaml",
                                -- Ansible
                                ["https://json.schemastore.org/ansible-playbook.json"] = "playbooks/*.yaml",
                                ["https://json.schemastore.org/ansible-tasks.json"]    = "tasks/*.yaml",
                                ["https://json.schemastore.org/ansible-vars.json"]     = "vars/*.yaml",
                                -- GitHub Actions
                                ["https://json.schemastore.org/github-workflow.json"]  = ".github/workflows/*.yaml",
                            },
                        },
                    },
                },
                bashls  = {},
                dockerls = {},
                ansiblels = {},
            },
        },
    },
}
