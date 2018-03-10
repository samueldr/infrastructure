{ pkgs, config, lib, ... }:
let
  cfg = config.services.ofborg.webhook;
  rabbitcfg = config.services.ofborg.rabbitmq;

  configuredWebhook = pkgs.runCommand "configured-webhook"
    {
      src = pkgs.webhook_api;
      config = pkgs.mutate ./config.php {
        domain = rabbitcfg.domain;
        username = cfg.rabbit_username;
        password = cfg.rabbit_password;
        vhost = "ofborg";
        github_shared_secret = cfg.github_shared_secret;
      };
    }
    ''
      cp -r $src $out
      chmod -R u+w $out
      cp -r $config $out/config.php
    '';
in
  {
    services.nginx = {
      virtualHosts."${cfg.domain}" = lib.mkOverride 60
      (
      lib.mkMerge [
        (pkgs.nginxVhostPHP "${configuredWebhook}/web")
        {
          enableACME = lib.mkForce false;
          forceSSL = lib.mkForce false;
        }
      ]
      );
    };
  }
