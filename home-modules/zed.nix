{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [
      "make"
      "nix"
      "sql"
      "opentofu"
      "toml"
    ];
    userSettings = {
      "buffer_font_features" = {
        # Disable font ligatures
        "calt" = false;
      };
      "dap" = {
        "CodeLLDB" = {
          "binary" = "${pkgs.lldb}/bin/lldb-dap";
        };
      };
      "languages" = {
        "Nix" = {
          "language_servers" = [
            "nil"
            "!nixd"
          ];
        };
      };
      "language_models" = {
        "openai_compatible" = {
          "localmodel" = {
            "api_url" = "http://localhost:8080/v1";
            "available_models" = [
              {
                "name" = "ggml-org/gpt-oss-20b-GGUF";
                "max_tokens" = 200000;
                # "max_output_tokens": 32000,
                # "max_completion_tokens": 200000,
                "capabilities" = {
                  "tools" = true;
                  "images" = false;
                  "parallel_tool_calls" = false;
                  "prompt_cache_key" = false;
                };
              }
            ];
          };
        };
      };
      "load_direnv" = "shell_hook";
      "inlay_hints" = {
        "enabled" = true;
        "show_type_hints" = true;
      };
      "lsp" = {
        "nil" = {
          "binary" = {
            "path" = lib.getExe pkgs.nil;
          };
          "initialization_options" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "settings" = {
              "diagnostics" = {
                "ignored" = [ "unused_binding" ];
              };
            };
          };
        };
        "rust-analyzer" = {
          "initialization_options" = {
            "inlayHints" = {
              "maxLength" = null;
              "lifetimeElisionHints" = {
                "enable" = "skip_trivial";
                "useParameterNames" = true;
              };
              "closureReturnTypeHints" = {
                "enable" = "always";
              };
            };
          };
        };
        # Because of AWS Cloud formation.  List came from here: https://zed.dev/docs/languages/yaml
        "yaml-language-server" = {
          "settings" = {
            "yaml" = {
              "customTags" = [
                "!And scalar"
                "!And mapping"
                "!And sequence"
                "!If scalar"
                "!If mapping"
                "!If sequence"
                "!Not scalar"
                "!Not mapping"
                "!Not sequence"
                "!Equals scalar"
                "!Equals mapping"
                "!Equals sequence"
                "!Or scalar"
                "!Or mapping"
                "!Or sequence"
                "!FindInMap scalar"
                "!FindInMap mapping"
                "!FindInMap sequence"
                "!Base64 scalar"
                "!Base64 mapping"
                "!Base64 sequence"
                "!Cidr scalar"
                "!Cidr mapping"
                "!Cidr sequence"
                "!Ref scalar"
                "!Ref mapping"
                "!Ref sequence"
                "!Sub scalar"
                "!Sub mapping"
                "!Sub sequence"
                "!GetAtt scalar"
                "!GetAtt mapping"
                "!GetAtt sequence"
                "!GetAZs scalar"
                "!GetAZs mapping"
                "!GetAZs sequence"
                "!ImportValue scalar"
                "!ImportValue mapping"
                "!ImportValue sequence"
                "!Select scalar"
                "!Select mapping"
                "!Select sequence"
                "!Split scalar"
                "!Split mapping"
                "!Split sequence"
                "!Join scalar"
                "!Join mapping"
                "!Join sequence"
                "!Condition scalar"
                "!Condition mapping"
                "!Condition sequence"
              ];
            };
          };
        };
      };
    };
  };
}
