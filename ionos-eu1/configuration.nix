{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko-config.nix
    ./xray.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDjBF39he6/uZfi/1u4AFiXRpGMjLhphCAMeV+cw1O0bAAAABHNzaDo= Yubikey 5 NFC"
  ];
  networking.firewall.allowedTCPPorts = [ 22 ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 2 * 1024;
  }];

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.max_pool_percent=80"
    "zswap.shrinker_enabled=1"
  ];

  system.stateVersion = "25.05";
}
