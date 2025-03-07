require("gitsigns").setup({
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      local additional_opts = { buffer = bufnr }

      for k, v in pairs(additional_opts) do
        opts[k] = v
      end

      vim.keymap.set(mode, l, r, opts)
    end
    map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset hunk" })

    map("v", "<leader>ghs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "Stage hunk" })
    end)

    map("v", "<leader>ghr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "Reset hunk" })
    end)
  end,
})
