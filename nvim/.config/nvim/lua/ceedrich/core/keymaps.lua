vim.g.mapleader = " "

local keymap = vim.keymap

-- Use the system clipboard
keymap.set({ "v", "n" }, "<C-y>", '"+y')
keymap.set({ "v", "n" }, "<C-p>", '"+p')
keymap.set({ "v", "n" }, "<C-x>", '"+x')

-- Window management
-- splits
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Go to previous buffer
keymap.set("n", "<bs>", ":edit #<cr>", { silent = true })

-- spell checking
keymap.set("n", "<leader>Ss", ":set spell!<CR>", { desc = "Activate spell checking" })
keymap.set("n", "<leader>Sd", ":set spelllang=de_ch<CR>", { desc = "Set spell checking language to german" })
keymap.set("n", "<leader>Se", ":set spelllang=en_gb<CR>", { desc = "Set spell checking language to english (GB)" })
keymap.set("n", "<leader>Sf", ":set spelllang=en_gb<CR>", { desc = "Set spell checking language to french" })
keymap.set(
	"n",
	"<leader>Sm",
	":set spelllang=en_gb,de_ch<CR>",
	{ desc = "Set spell checking language to english (GB)" }
)
