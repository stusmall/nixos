{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    steam
  ];

  services.opensnitch.rules = {
    rule-500-steam = {
      name = "Allow Steam";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "regexp";
            sensitive = false;
            operand = "process.path";
            data = "^/home/stusmall/.local/share/Steam/ubuntu12_32/steam|/home/stusmall/.local/share/Steam/ubuntu12_64/steamwebhelper$";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(api.steampowered.com|([a-z0-9|-]+\.)*steamcontent.com|([a-z0-9|-]+\.)*steamstatic.com|([a-z0-9|-]+\.)*steamserver.net|steamcommunity.com|steamstore-a.akamaihd.net|([a-z0-9|-]+\.)*.steampowered.com)$";
          }
        ];
      };
    };
  };

}
