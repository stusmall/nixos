{ pkgs, lib, ... }:
{
  users.users."stusmall".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXvDVfUlSpHGbL2uVPuEuTVyYWAC3f0eJJjAWyZI2gkFEFFCzVhKGL1VII0iN6pxkmWhygsUMJnS0TvHXI0TXQIG1Yd1qAC34cAG5Nasm6oTMi+fmyy+kjncstLHCB8theLEBQgTPfJHBbX+5v/O6hFkYTdUUG8KvMcjnNVwIrVXolgZWdf6ivdBYiAZFyYA6nnGBEknzPnYfmRmf3wNZVYq1iqybpNc7zSl65x7MiRUpjDWVpM3e++mAG7pZ5KCzoYh0oVa0QBMpJUYUw9DjvtPSnptdKEoy7e0Seh7eCkOmLFxk5W+P9o843W28UdIcbkqXlhgFUZMMHdAu5kCG16Y+g5bcsGxEUIX50+opIH4BGs82leheGoX8USwYRzIaVTYCKDg57WmPn2gLZZIgUXR2j1/DKDOfqpe3Kpw2y9vh/krGvld9ttEAugjEfEPozvaXlg3wJj8/BHXlVzeeDg5WXcRYdlLQ5YijY1UxpKOG84GLstc2LKSYotIkBKceipt0qp18rEo2PhVB0CPYVStVawYQMs+E8RlSOyNhpQ9MYFcu7TAkc1esExPlVybbiGes2OM+dyouGOn6luitCOMo48EyItYIvrrtdySHpcAS9Dg8C9FyUt05yuxaU+A2smvO9boAhBA2lk4GXCxrkH61R7WKtoGDz+4YLh8YJCQ== stusmall"
  ];
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
