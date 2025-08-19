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
      allowedUDPPorts = [ 20158 ];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "awg0" ];
      externalInterface = "ens3";
    };
    wg-quick.interfaces = {
      awg0 = {
        address = [ "10.100.0.1/24" "fdc9:281f:04d7::1/64" ];
        listenPort = 20158;
        privateKeyFile = "/root/awg0.key"; # LfSV6/ei/tmaKmqqC6cakChlrMRFJ8i7kOtxHpIXlXY=

        peers = [
          { # lappy
            publicKey = "OiO3aBDjsCxQYkEr4lqyKA1o1zd0Ddq8U7K72YbUAgk=";
            allowedIPs = [ "10.100.0.2/32" "fdc9:281f:04d7::2/80" ];
          }
        ];
      };
    };
  };
}
