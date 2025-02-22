{ pkgs, lib, ... }:
{

  services.ollama = {
    enable = true;
    loadModels = [ ];
  };

  services.opensnitch.rules = {
    rule-500-fetch-cuda = {
      name = "Allow fetching CUDA drivers";
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
            data = "^.*/bin/curl$";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "developer.download.nvidia.com";
          }
        ];
      };
    };

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
            data = "${lib.getBin pkgs.ollama}/bin/.ollama-wrapped";
          }
          {
            type = "simple";
            operand = "dest.host";
            sensitive = false;
            data = "registry.ollama.ai";
          }
        ];
      };
    };
  };
}
