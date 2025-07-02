{ pkgs, ... }:

let
  #    Define only the parsers you need.
  #    Customize this list for the languages you actually use.
  treesitter-parsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    lua
    nix
    python
    bash
    json
    yaml
    markdown # For LazyVim's default filetypes
  ];

  # This path now only contains your selected grammars.
  grammarsPath = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = treesitter-parsers;
  };
in
{
  home.packages = with pkgs; [
    gcc
    ripgrep
    fd
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraPackages = with pkgs; [ wl-clipboard ];
    # 2. Install only the specific parsers you defined above.
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
      nvim-treesitter
    ] ++ treesitter-parsers; # Append the list of parsers here

    extraLuaConfig = ''
      vim.g.mapleader = " "

      -- CRITICAL FIX: Add both paths BEFORE lazy.setup
      -- Add Nix-provided grammars to the runtime path.
      vim.opt.runtimepath:append("${grammarsPath}")
      -- Also add the writable cache directory to the runtime path. This prevents
      -- nvim-treesitter from trying to re-install parsers it can't find [3].
      vim.opt.runtimepath:append(vim.fn.stdpath("cache") .. "/treesitters")

      require("lazy").setup({
        performance = {
          reset_packpath = false,
          rtp = { reset = false },
        },
        spec = {
          {
            "nvim-treesitter/nvim-treesitter",
            opts = {
              -- Point to a writable directory to prevent all write errors [3].
              parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters",
              -- Ensure no runtime installations are ever attempted.
              ensure_installed = {},
              auto_install = false,
              highlight = { enable = true },
              indent = { enable = true },
            },
            -- Disable the build step, as Nix handles all parsers.
            build = "",
          },
          {
            "LazyVim/LazyVim",
            import = "lazyvim.plugins",
            extras = {
              ["lazyvim.plugins.treesitter"] = false,
            }
          },
          { "williamboman/mason.nvim", enabled = false },
        },
      })
    '';
  };
}

