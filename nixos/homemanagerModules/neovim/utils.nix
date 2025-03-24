{}:
let
  fromLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  fromLua = str: "lua << EOF\n${str}\nEOF\n";
in
{
  inherit fromLuaFile fromLua;
  makeLazy =
    { plugin, ft ? null, config ? "" }:
    let
      inherit (plugin) pname;
    in
    {
      inherit plugin;
      optional = true;
      config = fromLua /*lua*/ ''
        vim.api.nvim_create_autocmd("BufEnter", {
          callback = function()
              vim.cmd.packadd("${pname}")
              ${config}
          end,
          once = true,
        })
      '';
    };
}
