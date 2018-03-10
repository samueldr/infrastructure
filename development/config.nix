{ config, pkgs, ... }:
let
  secrets = {
    rabbitmq = {
      cookie = "tasty insecurity";
      queue_monitor = {
        user = "queue_monitor";
        password = "queue_monitor";
      };
    };
  };
in
{
  imports = [
    (import ./modules/events.nix.nix { inherit secrets; })
    ./modules/ofborg.nix
  ];

  services = {
    ofborg = {
      enable = true;
      enable_evaluator = true;
      enable_builder = true;
      enable_administrative = true;
    };
  };
}
