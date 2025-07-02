# /path/to/your/neovim.nix
{ pkgs, ... }:

{
  # Install dependencies that plugins might need at runtime
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

    # 1. You MUST include both plugins.
    #    - lazy-nvim: The core plugin manager.
    #    - LazyVim: The starter kit distribution with all the plugins and configs.
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
    ];

    # 2. This Lua block is the "glue" that makes Nix and LazyVim compatible.
    #    It's NOT optional.
    extraLuaConfig = ''
      -- Set mapleader before lazy so keymaps are applied correctly
      vim.g.mapleader = " "
      
      -- Bootstrap lazy.nvim with Nix-specific settings
      require("lazy").setup({
        -- This is the MOST IMPORTANT setting. It tells lazy.nvim to NOT
        -- reset the plugin paths that Nix has carefully set up. If this is
        -- missing or incorrect, lazy.nvim can't find its own files.
        performance = {
          reset_packpath = false,
          rtp = {
            reset = false,
          },
        },
        -- This tells lazy.nvim which "spec" to load from the plugins
        -- provided by Nix in the runtime path.
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        },
      })
    '';
  };
}

