{pkgs, ...}: {
  home.packages = with pkgs; [pyprland];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
    ]

    [scratchpads.term]
    animation = "fromTop"
    command = "ghostty --class term-dropdown"
    class = "term-dropdown"
    size = "70% 70%"
    max_size = "1920px 100%"
  '';
}
