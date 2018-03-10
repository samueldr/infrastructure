{ config, pkgs, lib, ... }:
let
  readJSON = file: builtins.fromJSON
    (builtins.readFile file);
  cfg = config;
in {

  nixpkgs.config.packageOverrides = {
    ofborg = (import ../../repos/ofborg {}).ofborg.rs;
    webhook_api = (import ../../repos/ofborg {}).ofborg.php;
    #logviewer = (import ../../repos/logviewer {});
    logviewer = let
      src = import ../../repos/logviewer/release.nix { inherit pkgs; };
    in pkgs.runCommand "logviewer-site-only" {} ''
      cp -r ${src}/website $out
    '';
    log_api = "${../../repos/ofborg}/log-api";
  };

  services.ofborg.rabbitmq = {
    cookie = "sweet-insecurity";
    domain = "rabbitmq.borg";
    monitoring_username = "monitoring";
    monitoring_password = "monitoring";
  };
  services.ofborg.monitoring = {
    enable = lib.mkForce false;
    domain = "monitoring.borg";
  };
  services.ofborg.webhook = {
    domain = "webhook.borg";
    rabbit_username = "webhook";
    rabbit_password = "webhook";
    github_shared_secret = "notsecret";
  };
  services.ofborg.website = {
    domain = "website.borg";
  };
  services.ofborg.log-viewer = {
    domain = "logs.borg";
  };

}
