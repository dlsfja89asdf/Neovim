local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- local mason_registry = require("mason-registry")
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local default_servers = { "lua_ls", "pyright", "typos_lsp" }

-- lsps with default config
for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    }
end

-- clangd
lspconfig.clangd.setup({
    filetypes = { "c", "cpp", "cc", "h", "hpp", "mpp", "ixx", "objc", "objcpp", "cuda" },
    cmd = {
        "clangd",
        "--query-driver=/**/*",
        "--clang-tidy",
        "--completion-style=detailed",
        "--enable-config",
        "--header-insertion=never",
        "--offset-encoding=utf-16",
        "--all-scopes-completion",
        "--background-index"
    },
    capabilities = capabilities,
    single_file_support = true,
    root_dir = util.root_pattern(
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git'
    )
})

-- pyright
lspconfig.pyright.setup({
    filetypes = { "python" },
    capabilities = capabilities,
    single_file_support = true,
    settings = {
        python = {
            pythonPath = vim.fn.exepath("python"),
        },
    },
})

-- powershell
lspconfig.powershell_es.setup({
    shell = "powershell",
    capabilities = capabilities,
    bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    settings = {
        powershell = {
            powerShellExePath = 'powershell',
            codeFormatting = {
                Preset = 'OTBS',
            },
        },
    },
})

-- mappings
local map = vim.keymap.set
map("n", "gD", vim.lsp.buf.declaration)
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'K', vim.lsp.buf.hover)
map('n', 'gi', vim.lsp.buf.implementation)
map('n', '<C-k>', vim.lsp.buf.signature_help)
map('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)
map('n', '<space>D', vim.lsp.buf.type_definition)
map('n', '<space>rn', vim.lsp.buf.rename)
map('n', 'gr', vim.lsp.buf.references)
map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action)
map('n', '<space>e', vim.diagnostic.open_float)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<space>q', vim.diagnostic.setloclist)

map('n', '<M-o>', '<cmd>ClangdSwitchSourceHeader<CR>', { desc = 'Switch source/header' })
