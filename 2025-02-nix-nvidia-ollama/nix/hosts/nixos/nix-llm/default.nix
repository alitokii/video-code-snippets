{ config, inputs, pkgs, name, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../common/nixos-common.nix
      ./../../common/common-packages.nix
    ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network configuration
  networking = {
    firewall.enable = false;
    hostName = "nixos-llms";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.121";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.254";
    nameservers = [ 
	"1.1.1.1" # Cloudflare DNS
	"8.8.8.8" # Google DNS
    ];
  };

  # System localization
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = false;
    videoDrivers = [ "amdgpu" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.qemuGuest.enable = true;
  services.tailscale.enable = true;
  # services.ollama = {
  #   enable = true;
  #   host = "0.0.0.0";
  # };

  # userland
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  #home-manager.users.zaphod = { imports = [ ./../../../home/zaphod.nix ]; };
  users.users.zaphod = {
    isNormalUser = true;
    description = "zaphod";
    extraGroups = [ "networkmanager" "wheel" "docker" "render" "video" ];
    packages = with pkgs; [
      #home-manager
    ];
  };

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    enableRedistributableFirmware = true;
    rocm.enable = true;
  };

}
