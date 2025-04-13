{ config, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" "snd-aloop" ];
    extraModulePackages = [ ];
    kernelParams = [ "kvm.enable_virt_at_load=0" ]; # <https://github.com/NixOS/nixpkgs/issues/363887#issuecomment-2536693220>
  };

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p4";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics.enable32Bit = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Fix that rtw88 doesn't work after suspending
  powerManagement = {
    enable = true;
    resumeCommands = ''
      /run/current-system/sw/bin/modprobe rtw88_8822ce
    '';
    powerDownCommands = ''
      /run/current-system/sw/bin/modprobe -r rtw88_8822ce
    '';
  };
}
