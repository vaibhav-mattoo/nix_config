{...}: {
  imports = [
    ./local-hardware-clock.nix
    ./nvidia-drivers.nix
    ./nvidia-prime-drivers.nix
    ./vm-guest-services.nix
  ];
}
