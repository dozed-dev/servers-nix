{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ./secrets/eu1/eu1.yaml;
    defaultSopsFormat = "yaml";
  };
}
