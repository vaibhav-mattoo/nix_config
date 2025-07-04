{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodejs
    code-cursor
    cargo
    virtualbox
  ];
}
