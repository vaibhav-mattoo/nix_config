{ pkgs, ... }:

let
  treesitter-parsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    lua
    nix
    python
    bash
    json
    yaml
    markdown
  ];

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

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
      nvim-treesitter
    ] ++ treesitter-parsers;

    extraLuaConfig = ''
      vim.g.mapleader = " "

      -- CRITICAL: Add runtime paths *before* Lazy loads plugins
      vim.opt.runtimepath:append("${grammarsPath}")
      vim.opt.runtimepath:append(vim.fn.stdpath("cache") .. "/treesitters")

      require("lazy").setup({
        spec = {
          {
            "nvim-treesitter/nvim-treesitter",
            opts = {
              parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters",
              ensure_installed = {},
              auto_install = false,
              highlight = { enable = true },
              indent = { enable = true },
            },
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

          {
            "MeanderingProgrammer/markdown.nvim",
            name = "render-markdown.nvim",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            ft = { "markdown" },
            config = function()
              require("render-markdown").setup({
                headings = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                bullets = { "●", "○", "◆", "◇" },
              })
            end,
          },
        },
        ui = {
          icons = false,
          border = "rounded",
          animate = false,
        },
        performance = {
          reset_packpath = false,
          rtp = {
            reset = false,
          },
        },
      })

      -- AFTER lazy.setup: apply UI and editing settings
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.g.snacks_animate = false
    '';
  };
}

