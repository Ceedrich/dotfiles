local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  ls.add_snippets("nix", {
    s(
      "mod",
      fmt(
        [[
      {{ lib, config, ... }}:

      {{
        options = {{
          {}.enable = lib.mkEnableOption "enable {}";
        }};
        config = lib.mkIf config.{}.enable {{

        }};
      }}
      ]],
        {
          i(1),
          rep(1),
          rep(1),
        }
      )
    ),
    s(
      "shell",
      fmt(
        [[
    {{ pkgs ? import <nixpkgs> {{}} }}:

    pkgs.mkShell {{

    }}
    ]],
        {}
      )
    ),
  }),
}
