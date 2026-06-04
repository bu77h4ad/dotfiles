# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.substituters = [
    "https://mirror.yandex.ru/nix-channels/store"
    "https://cache.nixos.org"
  ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Загружаем Home Manager из официальных каналов
      #<home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  # Очищать поколения при каждом переключении
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [
    pkgs.networkmanager-openvpn
  ];

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bu77h4ad = {
    isNormalUser = true;
    description = "andy";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    #fastfetch
    #htop
    #btop
    #kitty
    ];
  };


  programs.zsh.enable = true;
  services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gparted
    parted
    dosfstools
    mtools
    mc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Глобальные настройки Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Настройки конкретно для вашего пользователя
  home-manager.users.bu77h4ad = { pkgs, ... }: {
    # Указываем версию Home Manager (должна совпадать с вашей версией NixOS)
    home.stateVersion = "25.11";
        # Список пакетов для установки в пользовательское окружение
    home.packages = with pkgs; [
      fastfetch
      htop
      btop
      kitty
      telegram-desktop
      firefox
      remmina
      freerdp
      openvpn
      libreoffice-fresh
      #networkmanager-openvpn
      #starship
      #thunderbird  # если нужно
    ];

    # --- ЗДЕСЬ БУДУТ НАСТРОЙКИ ВАШИХ ПРОГРАММ ---
    programs.zsh = {
      enable = true;
      enableCompletion = true; # Включает базовое автодополнение
      autosuggestion.enable = true; # Подсказки на основе истории (как в Fish)
      syntaxHighlighting.enable = true; # Подсветка правильности ввода команд (цвета)

      # Опционально: удобные настройки для истории команд
      history = {
        size = 10000;
        path = "$HOME/.zsh_history";
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };
      # Запуск fastfetch при открытии интерактивной сессии
      initContent = ''
        fastfetch
      '';
        # Oh My Zsh (включает всё остальное)
      oh-my-zsh = {
        enable = true;
        plugins = [
          #"git"       # алиасы для git
          #"sudo"      # два раза Esc добавит sudo
          #"extract"   # распаковка любых архивов командой "extract"
          "colored-man-pages"  # цветные man
        ];
      };

    };

    # Настройка терминала Kitty
    programs.kitty = {
      enable = true;

      # 1. Задание цветовой темы оформления (выберите любую из репозитория)
      # Популярные темы: "Tokyo Night", "Catppuccin-Mocha", "One Dark", "Gruvbox Dark Hard"
      theme = "Ayu";

      # 2. Настройки шрифтов и эффектов (включая трейлинг курсора)
      settings = {
        # Настройки формы курсора
        cursor_shape = "block";
        cursor_blink_interval = "0.5";

        # Эффект шлейфа (трейлинга) курсора (доступен в актуальных версиях Kitty)
        cursor_trail = 3;                  # Длина шлейфа (количество шагов анимации)
        cursor_trail_decay = "0.1 0.4";    # Скорость затухания шлейфа (минимум и максимум в сек)
        cursor_trail_start_threshold = 2;  # Минимальное расстояние сдвига курсора для включения шлейфа

        # Опционально: Настройки прозрачности и размытия окна (если хотите)
        background_opacity = "0.95";
        background_blur = 1;
        # ВАЖНЫЕ НАСТРОЙКИ ДЛЯ ВКЛАДОК
        tab_bar_edge = "top";          # расположение панели вкладок — сверху
        tab_min_tabs = 1;  # показывать панель, если есть хотя бы 1 вкладка
        tab_bar_style = "fade";  # или "hidden", "slanted", "powerline"
        show_tabs_separator = true;  # показывать разделитель между вкладками
        tab_title_template = "{title}";  # шаблон заголовка вкладки
        tab_font_size = "10";  # размер шрифта вкладок
        tab_min_width = "150";  # минимальная ширина вкладки

      };
    };
    programs.starship = {
    enable = true;
    # Starship сам добавит свою инициализацию в нужное место
    };


    # Сюда же в будущем можно перенести настройки zsh/fish/starship, если захотите
  };


}
