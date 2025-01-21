local on_attach = function(_, bufnr)
  local keymap = vim.keymap
  local opts = { buffer = bufnr, silent = true }


  opts.desc = "Show LSP definitions"
  keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

  opts.desc = "Show LSP definitions"
  keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

  opts.desc = "Show buffer diagnostics"
  keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

  opts.desc = "Show line diagnostics"
  keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

  opts.desc = "Show documentation for what is under cursor"
  keymap.set("n", "K", vim.lsp.buf.hover, opts)

  opts.desc = "Code actinos"
  keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)

  opts.desc = "Rename symbol"
  keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local lspconfig = require("lspconfig")

local defaultSetup = function(server_name)
  lspconfig[server_name].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

defaultSetup("nixd")
defaultSetup("astro")
defaultSetup("taplo")
defaultSetup("ts_ls")
