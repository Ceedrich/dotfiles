vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap

-- Use the system clipboard
keymap.set({ "v", "n" }, "<C-y>", '"+y')
keymap.set({ "v", "n" }, "<C-p>", '"+p')
keymap.set({ "v", "n" }, "<C-x>", '"+x')

-- Explorer
keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "open parent directory" })

-- Telescope
do
  local builtin = require("telescope.builtin")
  keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
  keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
  keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
  keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
  keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
end

-- neogit
keymap.set("n", "<leader>G", "<cmd>Neogit<cr>", { desc = "Open Git Window" })

-- harpoon
do
  local harpoon = require("harpoon")

  vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add current file to harpoon list" } )
  vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon list" } )

  vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Open file 1 from harpoon list" })
  vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Open file 2 from harpoon list" })
  vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Open file 3 from harpoon list" })
  vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Open file 4 from harpoon list" })

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<C-S-H>", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<C-S-L>", function() harpoon:list():next() end)
end
