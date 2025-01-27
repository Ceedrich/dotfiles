{ pkgs, ... }: {
  home.shellAliases = { v = "nvim"; };
  programs.neovim =
    let
      fromLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
      fromLua = str: "lua << EOF\n${str}\nEOF\n";
    in
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        # Plugin dependencies
        git
        fd
        ripgrep

        # LSP
        lua-language-server
        nixd
        typescript-language-server
        astro-language-server
        taplo
        rust-with-analyzer

        # Formatters
        nixpkgs-fmt
        prettierd
        stylua
      ];

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        nvim-web-devicons

        render-markdown-nvim
        rustaceanvim # Missing debugging features
        vim-nix

        cmp-nvim-lsp
        luasnip
        telescope-fzf-native-nvim

        otter-nvim
        diffview-nvim
        lspkind-nvim
        dropbar-nvim
        dressing-nvim

        vim-tmux-navigator
        which-key-nvim
        {
          plugin = crates-nvim;
          config = fromLua /* lua */ ''require("crates").setup()'';
        }
        {
          plugin = none-ls-nvim;
          config = fromLuaFile ./plugin/none-ls.lua;
        }
        {
          plugin = todo-comments-nvim;
          config = fromLuaFile ./plugin/todo-comments.lua;
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
          config = fromLuaFile ./plugin/auto-pairs.lua;
        }
        {
          plugin = harpoon2;
          config = fromLua /* lua */ ''require("harpoon").setup({})'';
        }
        {
          plugin = oil-nvim;
          config = fromLuaFile ./plugin/oil.lua;
        }
        {
          plugin = gitsigns-nvim;
          config = fromLua /* lua */ ''require("gitsigns").setup()'';
        }
        {
          plugin = neogit;
          config = fromLuaFile ./plugin/neogit.lua;
        }
        {
          # TODO: look at the dependencies
          plugin = nvim-cmp;
          config = fromLuaFile ./plugin/nvim-cmp.lua;
        }
        {
          plugin = alpha-nvim;
          config = fromLuaFile ./plugin/greeter.lua;
        }
        {
          plugin = nvim-lspconfig;
          config = fromLuaFile ./plugin/lspconfig.lua;
        }
        {
          plugin = catppuccin-nvim;
          config = /* vim */ "colorscheme catppuccin-mocha";
        }
        {
          plugin = lualine-nvim;
          config = fromLuaFile ./plugin/lualine.lua;
        }
        {
          plugin = comment-nvim;
          config = fromLua /* lua */ ''require("Comment").setup()'';
        }
        {
          plugin = telescope-nvim;
          config = fromLuaFile ./plugin/telescope.lua;
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
          config = fromLuaFile ./plugin/treesitter.lua;
        }
      ];

      extraLuaConfig = ''
        	${builtins.readFile ./options.lua}
          ${builtins.readFile ./keymaps.lua}
      '';
    };
}
