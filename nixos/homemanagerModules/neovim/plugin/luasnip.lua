local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("nix", {
  s("enable", fmt([[ {}.enable = lib.mkEnableOption "enable {}"; ]], { i(1), rep(1) })),
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
          {}
        }};
      }}
      ]],
      {
        i(1),
        rep(1),
        rep(1),
        i(2),
      }
    )
  ),
  s(
    "shell",
    fmt(
      [[
    {{ pkgs ? import <nixpkgs> {{}} }}:

    pkgs.mkShell {{
      {}
    }}
    ]],
      { i(1) }
    )
  ),
  s(
    "shell-flake",
    fmt(
      [[
  {{
    description = "{}";
    inputs = {{
      nigpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      flake-utils.url = "github:numtide/flake-utils";
    }};

    outputs = {{ nixpkgs, flake-utils, ... }}:
      flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${{system}}; in
	       {{ devShells.default = import ./shell.nix {{ inherit pkgs; }}; }}
      );
  }}
    ]],
      { i(1) }
    )
  ),
})

require("luasnip.loaders.from_vscode").lazy_load()
