{ config, pkgs, lib, ... }:
let
  #cfg = config;
  cfg = config.services.ofborg;
in
{
  #nix.gc_free_gb = 1;
  imports = builtins.filter (e:
  e != ./../nixops/local.nix
  && e != ./../nixops/modules/hetzner.nix
  && e != ./../nixops/modules/standard.nix
  && e != ./../nixops/modules/packet.nix
  )
  (
  (import ./../nixops/modules/default.nix) ++ [
    ./local.nix
    # FIXME : do not copy standard.nix but upstream the needed fixes.
    ./standard.nix
  ]
  );

  roles.core = {
    enable = true;
  };

  services.nginx = {
    #enable = true;
    virtualHosts."${cfg.rabbitmq.domain}" =  {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
    };
    virtualHosts."${cfg.monitoring.domain}" =  {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
    };
    virtualHosts."${cfg.webhook.domain}" =  {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
    };
    virtualHosts."${cfg.website.domain}" =  {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
    };
    virtualHosts."${cfg.log-viewer.domain}" =  {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
    };
  };

  services.rabbitmq = {
    #config = lib.mkForce
    #''
    #  [
    #    {rabbit, [
    #      {tcp_listen_options, [
    #        {keepalive, true}]},
    #      {heartbeat, 10},
    #      {listeners, [{"::", 5671}]},
    #      {log_levels, [{connection, debug}]}
    #    ]},
    #    {rabbitmq_management, [{listener, [{port, 15672}]}]}
    #  ].
    #'';
  };
}
