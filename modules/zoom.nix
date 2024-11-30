{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.zoom-us
  ];

  services.opensnitch.rules = {
    # Zoom has a MASSIVE list of 300 something CIDRS for traffic I could white list.  I'm a bit lazy for this so I'm just whitelisting the application
    # https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0060548
    rule-901-zoom = {
      name = "Allow Zoom";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "simple";
        sensitive = false;
        operand = "process.path";
        data = "${lib.getBin pkgs.zoom-us}/opt/zoom/.zoom";
      };
    };
  };
}
