{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }:
    {
      # nixos-anywhere --flake .#ionos-eu1 --generate-hardware-config nixos-facter facter.json <hostname>
      nixosConfigurations = {
        ionos-eu1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            { disko.devices.disk.main.device = "/dev/vda"; }
            ./configuration.nix
            nixos-facter-modules.nixosModules.facter
            {
              config.facter.reportPath =
                if builtins.pathExists ./facter.json then
                  ./facter.json
                else
                  throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
            }
          ];
        };
        iso-x86-64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ modulesPath, ... }: {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
              services.openssh.enable = true;
              users.users.root.openssh.authorizedKeys.keys = [
                "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDjBF39he6/uZfi/1u4AFiXRpGMjLhphCAMeV+cw1O0bAAAABHNzaDo= Yubikey 5 NFC"
              ];
            })
          ];
        };
      };
    };
}
