# This is a template file that will be customized by the install script
# The install script will run: sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix
# to replace this with the actual hardware configuration for the target machine.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Generic kernel modules - will be customized by nixos-generate-config
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # File systems will be detected and configured by nixos-generate-config
  # fileSystems."/" = { ... };
  # fileSystems."/boot" = { ... };

  # LUKS devices will be detected and configured by nixos-generate-config
  # boot.initrd.luks.devices."..." = { ... };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
