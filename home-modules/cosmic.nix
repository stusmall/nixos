# To be frank, none of this works very well.  Sometimes on a fresh install I have to do some intial set up before it starts to recongize the settings in here.  I suspect
# This means there are some interdepdent settings that the nix config are missing but I can't find them.  That's okay.  this at least gets us in the ball park.
#
# To watch for updates from the UX:
#
#  nix-shell -p inotify-tools --command "inotifywait -m -r -e modify,create,delete,move ~/.config/cosmic"
#
# At startup check for erros with:
#   journalctl -r -b --grep 'cosmic'
#
# To clear bad state:
#   rm -rf  ~/.config/cosmic; rm ~/.config/cosmic-initial-setup-done
{
  cosmicLib,
  ...
}:
{
  imports = [
    <cosmic-manager/modules>
  ];

  wayland.desktopManager.cosmic.enable = true;

  # Set favorite apps on the dock
  wayland.desktopManager.cosmic.applets.app-list.settings = {
    enable_drag_source = true;
    favorites = [
      "firefox"
      "signal"
      "dev.zed.Zed"
      "Alacritty"
    ];
  };

  # Set dark mode
  wayland.desktopManager.cosmic.appearance.theme.mode = "dark";

  # Set the accent color around the active window
  wayland.desktopManager.cosmic.appearance.theme.dark.accent = cosmicLib.cosmic.mkRON "optional" {
    blue = 1.0;
    green = 1.0;
    red = 0.890196;
  };

  # Power settings
  wayland.desktopManager.cosmic.idle = {
    # Screen off in 15 minutes
    screen_off_time = cosmicLib.cosmic.mkRON "optional" 900000;
    # On AC, suspend in 30 minutes
    suspend_on_ac_time = cosmicLib.cosmic.mkRON "optional" 1800000;
    # On battery, suspend in 15 minutes
    suspend_on_battery_time = cosmicLib.cosmic.mkRON "optional" 900000;
  };

  # Touchpad inputs
  wayland.desktopManager.cosmic.compositor.input_touchpad = {
    click_method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "Clickfinger");
    disable_while_typing = cosmicLib.cosmic.mkRON "optional" false;
    state = cosmicLib.cosmic.mkRON "enum" "Enabled";
    tap_config = cosmicLib.cosmic.mkRON "optional" {
      button_map = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "LeftMiddleRight");
      drag = true;
      drag_lock = false;
      enabled = false;
    };
  };

  wayland.desktopManager.cosmic.panels = [
    # Setting up the top panel of the UX
    {
      anchor = cosmicLib.cosmic.mkRON "enum" "Top";
      anchor_gap = false;
      autohide = cosmicLib.cosmic.mkRON "optional" null;
      background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
      expand_to_edges = true;
      margin = 0;
      name = "Panel";
      opacity = 1.0;
      output = cosmicLib.cosmic.mkRON "enum" "All";
      plugins_center = cosmicLib.cosmic.mkRON "optional" [
        "com.system76.CosmicAppletTime"
      ];
      plugin_wings = cosmicLib.cosmic.mkRON "optional" (
        cosmicLib.cosmic.mkRON "tuple" [
          [

          ]
          [
            "com.system76.CosmicAppletStatusArea"
            "com.system76.CosmicAppletTiling"
            "com.system76.CosmicAppletAudio"
            "com.system76.CosmicAppletBluetooth"
            "com.system76.CosmicAppletNetwork"
            "com.system76.CosmicAppletBattery"
            "com.system76.CosmicAppletNotifications"
            "com.system76.CosmicAppletPower"
          ]
        ]
      );
      size = cosmicLib.cosmic.mkRON "enum" "XS";
    }
    # Set up the bottom dock
    {
      anchor = cosmicLib.cosmic.mkRON "enum" "Bottom";
      anchor_gap = false;
      autohide = cosmicLib.cosmic.mkRON "optional" {
        handle_size = 4;
        transition_time = 200;
        unhide_delay = 200;
        wait_time = 1000;
      };
      autohover_delay_ms = cosmicLib.cosmic.mkRON "optional" 500;
      background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
      border_radius = 12;
      exclusive_zone = false;
      expand_to_edges = false;
      keyboard_interactivity = cosmicLib.cosmic.mkRON "enum" "OnDemand";
      layer = cosmicLib.cosmic.mkRON "enum" "Top";
      margin = 0;
      name = "Dock";
      opacity = 1.0;
      output = cosmicLib.cosmic.mkRON "enum" "All";
      padding = 4;
      padding_overlap = 0.5;
      plugins_center = cosmicLib.cosmic.mkRON "optional" [
      ];
      plugin_wings = cosmicLib.cosmic.mkRON "optional" (
        cosmicLib.cosmic.mkRON "tuple" [
          [
            "com.system76.CosmicPanelAppButton"
            "com.system76.CosmicAppList"
          ]
          [ ]
        ]
      );
      size = cosmicLib.cosmic.mkRON "enum" "L";
      size_wings = null;
      spacing = 0;
    }
  ];
}
