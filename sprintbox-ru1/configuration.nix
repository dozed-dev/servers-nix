{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  networking = {
    interfaces.ens3.ipv4.addresses = [{
      address = "185.185.70.168";
      prefixLength = 22;
    }];
    defaultGateway = {
      address = "185.185.68.1";
      interface = "ens3";
    };
    nameservers = ["141.8.194.254" "141.8.197.254"];
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/perlless.nix")
  ];

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDjBF39he6/uZfi/1u4AFiXRpGMjLhphCAMeV+cw1O0bAAAABHNzaDo= Yubikey 5 NFC"
  ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 2 * 1024;
  }];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };

  zramSwap.enable = true;

  system.stateVersion = "25.05";
}
