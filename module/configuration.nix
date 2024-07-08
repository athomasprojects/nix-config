{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  nix = {
	settings = {
		auto-optimise-store = true;
      		builders-use-substitutes = true;
      		experimental-features = [ "nix-command" "flakes" ];
      		substituters = [
      			"https://nix-community.cachix.org"
      		];
		trusted-public-keys = [
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
		];
		trusted-users = [ "@wheel" ];
		warn-dirty = false;
	};
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  services.xserver.enable = true;
  services.xserver.dpi = 163;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  	# Modesetting is required.
    	modesetting.enable = true;

    	# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    	# Enable this if you have graphical corruption issues or application crashes after waking
    	# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    	# of just the bare essentials.
    	powerManagement.enable = false;

    	# Fine-grained power management. Turns off GPU when not in use.
    	# Experimental and only works on modern Nvidia GPUs (Turing or newer).
    	powerManagement.finegrained = false;

    	# Use the NVidia open source kernel module (not to be confused with the
    	# independent third-party "nouveau" open source driver).
    	# Support is limited to the Turing and later architectures. Full list of 
    	# supported GPUs is at: 
    	# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    	# Only available from driver 515.43.04+
    	# Currently alpha-quality/buggy, so false is currently the recommended setting.
    	open = false;

    	# Enable the Nvidia settings menu,
    	# accessible via `nvidia-settings`.
    	nvidiaSettings = true;

    	# Optionally, you may need to select the appropriate driver version for your specific GPU.
    	# package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_CA.UTF-8";
    LC_IDENTIFICATION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_CA.UTF-8";
    LC_MONETARY = "en_CA.UTF-8";
    LC_NAME = "en_CA.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "en_CA.UTF-8";
    LC_TELEPHONE = "en_CA.UTF-8";
    LC_TIME = "en_CA.UTF-8";
  };

  users.mutableUsers = false;  

  system.stateVersion = "24.05";
}
