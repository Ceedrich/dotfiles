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

    local wk = require("which-key")
    wk.add({ "<leader>gh", group = "Git Hunk" })

    map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git stage *buffer*" })
    map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git reset *buffer*" })

    map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "git stage *hunk*" })
    map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "git stage *hunk*" })

    map("v", "<leader>ghs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "git stage *hunk*" })
    end)

    map("v", "<leader>ghr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "git stage *hunk*" })
    end)
  end,
})
