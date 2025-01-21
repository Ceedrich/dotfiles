{ pkgs, lib, config, ...}: {
  programs.neovim = let
    fromLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    fromLua = str: "lua << EOF\n${str}\nEOF\n";
  in
  {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      # LSP
      lua-language-server
      nixd
      # Formatters
      nixpkgs-fmt
      prettierd
      stylua
    ];

    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp
      vim-nix
      otter-nvim
      luasnip
      diffview-nvim
      lspkind-nvim
      which-key-nvim
      telescope-fzf-native-nvim
      render-markdown-nvim
      rustaceanvim
      vim-tmux-navigator
      nvim-web-devicons
      plenary-nvim
      dropbar-nvim
      dressing-nvim
      {
        plugin = none-ls-nvim;
        config = fromLuaFile ./neovim/plugin/none-ls.lua;
      }
      {
        plugin = todo-comments-nvim;
        config = fromLuaFile ./neovim/plugin/todo-comments.lua;
      }
      {
        plugin = nvim-surround;
        config = fromLua /* lua */ ''require("nvim-surround").setup({})'';
      }
      {
        plugin = indent-blankline-nvim;
        config = fromLua /* lua */ ''require("ibl").setup({ indent = { char = ""}})'';
      }
      {
        plugin = nvim-autopairs;
        config = fromLuaFile ./neovim/plugin/auto-pairs.lua;
      }
      {
        plugin = harpoon2;
        config = fromLua /* lua */ ''require("harpoon").setup({})'';
      }
      {
        plugin = oil-nvim;
        config = fromLuaFile ./neovim/plugin/oil.lua;
      }
      {
        plugin = gitsigns-nvim;
        config = fromLua /* lua */ ''require("gitsigns").setup()'';
      }
      {
        plugin = neogit;
        config = fromLuaFile ./neovim/plugin/neogit.lua;
      }
      {
        plugin = nvim-cmp;
        config = fromLuaFile ./neovim/plugin/nvim-cmp.lua;
      }
      {
        plugin = alpha-nvim;
        config = fromLuaFile ./neovim/plugin/greeter.lua;
      }
      {
        plugin = nvim-lspconfig;
        config = fromLuaFile ./neovim/plugin/lspconfig.lua;
      }
      {
        plugin = catppuccin-nvim;
        config = /* vim */ "colorscheme catppuccin-mocha";
      }
      {
        plugin = lualine-nvim;
        config = fromLuaFile ./neovim/plugin/lualine.lua;
      }
      {
        plugin = comment-nvim;
        config = fromLua /* lua */ ''require("Comment").setup()'';
      }
      {
        plugin = telescope-nvim;
        config = fromLuaFile ./neovim/plugin/telescope.lua;
      }
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          # Web dev
          p.tree-sitter-html
          p.tree-sitter-astro
          p.tree-sitter-css
          p.tree-sitter-typescript
          p.tree-sitter-javascript

          # Main Programming languages
          p.tree-sitter-rust
          p.tree-sitter-cpp
          p.tree-sitter-java

          # Scripting
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua

          # General purpose
          p.tree-sitter-json
          p.tree-sitter-toml
          p.tree-sitter-yaml

        ]));
        config = fromLuaFile ./neovim/plugin/treesitter.lua;
      }
    ];

    extraLuaConfig = ''
    	${builtins.readFile ./neovim/options.lua}
      ${builtins.readFile ./neovim/keymaps.lua}
    '';
  };
}

