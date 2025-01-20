require("todo-comments").setup({
  keywords = {
    ERROR = {
      icon = "",
      color = "error",
    },
  },
  highlight = {
    pattern = [[.*<(KEYWORDS)\s*]],
  },
})
