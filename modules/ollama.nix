{ pkgs, lib, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  services.opensnitch.rules = {
    rule-500-download-models = {
      name = "Allow ollama to fetch models";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        list = [
          {
            type = "simple";
            sensitive = false;
            operand = "process.path";
            data = "${lib.getBin pkgs.ollama-rocm}/bin/.ollama-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.host";
            sensitive = false;
            data = "^(registry.ollama.ai)|(([a-z0-9|-]+\\.)*cloudflarestorage.com)$";
          }
        ];
      };
    };
  };
}
