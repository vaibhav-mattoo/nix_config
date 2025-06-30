{host, ...}: {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  # Enable GPU Drivers
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  vm.guest-services.enable = true;
}
