local actions = require("telescope.actions")

require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      case_mode = "smart_case",
    }
  },
  defaults = {
    path_display = { "truncate" },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-x>"] = actions.delete_buffer,
      }
    }
  }
})

require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>1", function()print("hello")end)

-- vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
vim.keymap.set("n", "<Leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
vim.keymap.set("n", "<Leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Find open buffers" })
