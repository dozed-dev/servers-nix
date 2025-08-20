{
  pkgs,
  config,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ amneziawg ];
  environment.systemPackages = with pkgs; [ amneziawg-tools ];

  networking = {
    firewall = {
      enable = true;
      allowedUDPPorts = [ 51820 ];
    };
    wg-quick.interfaces = {
      awg0.configFile = "/root/awg0.conf";
    };
  };
}
