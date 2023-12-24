{ pkgs, ... }:
{
  # Define the wireshark group and set dumpcap with it.  This allows us to capture as nonroot
  # The wireshark package won't do this for us
  users.groups.wireshark = { };
  security.wrappers.dumpcap = {
    source = "${pkgs.wireshark}/bin/dumpcap";
    permissions = "u+xs,g+x";
    owner = "root";
    group = "wireshark";
  };

  # Add myself to this new group
  users.users.stusmall.extraGroups = [ "wireshark" ];

  environment.systemPackages = [
    pkgs.wireshark
  ];
}
