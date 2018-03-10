{ config, pkgs, lib, ... }:
let
  #cfg = config;
  cfg = config.services.ofborg;
  hostname = "development";
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
    ./webhook
  ]
  );

  roles.core = {
    enable = true;
  };

  services.nginx = {
    #enable = true;
    virtualHosts = {
      "000-default" = {
        default = true;
        root = "/vagrant/development/webroot";
        locations = {
          # Proxies to the proper domain.
          "/log-viewer/" = { proxyPass = "http://${cfg.log-viewer.domain}/"; };
          "/monitoring/" = { proxyPass = "http://${cfg.monitoring.domain}/"; };
          "/webhook/" = { proxyPass = "http://${cfg.webhook.domain}/"; };
          "/website/" = { proxyPass = "http://${cfg.website.domain}/"; };

          # Proxies to port 15672.
          "/rabbitmq/" = { proxyPass = "http://${cfg.rabbitmq.domain}:15672/"; };
        };
      };
      "${cfg.rabbitmq.domain}" =  {
        enableACME = lib.mkForce false;
        forceSSL = lib.mkForce false;
      };
      "${cfg.monitoring.domain}" =  {
        enableACME = lib.mkForce false;
        forceSSL = lib.mkForce false;
      };
      "${cfg.webhook.domain}" =  {
        enableACME = lib.mkForce false;
        forceSSL = lib.mkForce false;
      };
      "${cfg.website.domain}" =  {
        enableACME = lib.mkForce false;
        forceSSL = lib.mkForce false;
      };
      "${cfg.log-viewer.domain}" =  {
        enableACME = lib.mkForce false;
        forceSSL = lib.mkForce false;
      };
    };
  };

  # Eh, development environment
  networking.firewall.enable = lib.mkForce false;
  services.rabbitmq = {
    config = lib.mkForce
    ''
      [
        {rabbit, [
          {tcp_listen_options, [
            {keepalive, true}]},
          {heartbeat, 10},
          {log_levels, [{connection, debug}]}
        ]},
        {rabbitmq_management, [{listener, [{port, 15672}]}]},
        {rabbitmq_web_stomp,
                 [{tcp_config, [{port,       15671},
                  {backlog,    1024}
             ]}]}
      ].
    '';
    listenAddress = "0.0.0.0";
  };

  networking.hostName = lib.mkForce "${hostname}.borg";

  networking.extraHosts = ''
     127.0.0.1 ${hostname}
     127.0.0.1 ${hostname}.local
     127.0.0.1 ${hostname}.borg
     127.0.0.1 ${cfg.rabbitmq.domain}
     127.0.0.1 ${cfg.monitoring.domain}
     127.0.0.1 ${cfg.webhook.domain}
     127.0.0.1 ${cfg.website.domain}
     127.0.0.1 ${cfg.log-viewer.domain}
  ''; 

}
