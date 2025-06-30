{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) waybarChoice;
in {
  imports = [
    ./bash.nix
    ./bashrc-personal.nix
    ./bat.nix
    ./btop.nix
    ./cava.nix
    ./emoji.nix
    ./eza.nix
    ./fastfetch
    ./fzf.nix
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./lazygit.nix
    ./nvf.nix
    ./rofi
    ./qt.nix
    ./scripts
    ./stylix.nix
    ./swappy.nix
    ./swaync.nix
    ./virtmanager.nix
    waybarChoice
    ./wlogout
    ./xdg.nix
    ./yazi
    ./zoxide.nix
    ./zsh
  ];
}
