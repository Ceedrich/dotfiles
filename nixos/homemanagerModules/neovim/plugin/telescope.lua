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
