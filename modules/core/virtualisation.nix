{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
    libvirtd.enable = false;
    docker.enable = true;
    podman.enable = false;
  };
  users.extraGroups.vboxusers.members = [ "fuckotheclown" ];
  users.users.fuckotheclown.extraGroups = [ "vboxusers" "docker" ];
  programs = {
    virt-manager.enable = false;
  };
  environment.systemPackages = with pkgs; [
    # virt-viewer # View Virtual Machines
  ];
  boot.blacklistedKernelModules = [ "kvm" "kvm_amd" ];
}
