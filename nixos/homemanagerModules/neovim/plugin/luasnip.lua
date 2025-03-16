local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function clone(args, parent, user_args)
  return args[1][1]
end

return {
  ls.add_snippets("nix", {
    s("mod", {
      t({ "{ lib, config, ... }:", "", "{", "" }),
      t({ "  options = {", "    " }),
      i(1),
      t('.enable = lib.mkEnableOption "enable '),
      f(clone, { 1 }),
      t({ '";', "  };", "" }),
      t("  config = lib.mkIf config."),
      f(clone, { 1 }),
      t({ ".enable {", "    " }),
      i(2),
      t({ "", "  };", "}" }),
    }),
  }),
}
