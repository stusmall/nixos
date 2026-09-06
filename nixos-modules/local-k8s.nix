{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    argocd
    cilium-cli
    hubble
    kubectl # just here for auto completes
    kubernetes-helm
    libvirt
    minikube
  ];

  programs.bash.shellAliases = {
    kubectl = "minikube kubectl --";
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.stusmall = {
    extraGroups = [
      "libvirtd"
    ];
  };
  virtualisation.podman.enable = true;
}
