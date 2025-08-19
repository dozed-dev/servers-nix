{...}: {
  networking.firewall.allowedTCPPorts = [ 443 ];
  services.xray = {
    enable = true;
    settings = {
      log = {
        loglevel = "debug";
      };
      inbounds = [{
        port = 443;
        protocol = "vless";
        settings = {
          clients = [
            {
              "id" = "";
              "flow" = "xtls-rprx-vision";
            }
          ];
          decryption = "none";
        };
        streamSettings = {
          network = "tcp";
          security = "reality";
          realitySettings = {
            dest = "www.google.com:443";
            serverNames = [ "www.google.com" ];
            privateKey = "";
            shortIds = [ "" ];
            maxTimeDiff = 60000;
          };
          tlsSettings = {
            serverName = "www.google.com";
            #alpn = [];
          };
        };
      }];
      outbounds = [{
        protocol = "freedom";
        tag = "direct";
      }];
    };
  };
}
