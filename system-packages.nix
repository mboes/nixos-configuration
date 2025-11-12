{ pkgs }:

with pkgs;
let
  chatgpt = makeDesktopItem {
    name = "chatgpt";
    desktopName = "ChatGPT";
    exec = "${chromium}/bin/chromium --app=https://chat.openai.com";
    icon = "chromium";
    categories = [
      "Network"
      "ArtificialIntelligence"
    ];
  };
  gemini = makeDesktopItem {
    name = "gemini";
    desktopName = "Gemini";
    exec = "${chromium}/bin/chromium --app=https://gemini.google.com";
    icon = "chromium";
    categories = [
      "Network"
      "ArtificialIntelligence"
    ];
  };
in
[
  adwaita-icon-theme
  baobab
  bat
  bemoji
  bibata-cursors
  broot
  btop
  catppuccin-cursors.latteDark
  chatgpt
  chromium
  comma
  curl
  delta
  dig
  direnv
  dool
  eza
  fastfetch
  fd
  file
  fzf
  gemini
  gh
  ghostty
  gimp
  gnome-calculator
  grim
  grimblast
  hunspell
  hunspellDicts.en_GB-ize
  hunspellDicts.fr-classique
  hunspellDicts.el-gr
  hyprpicker
  hyprshot
  hyprsunset
  impala
  imv
  jq
  keymapp
  libnotify
  libqalculate
  localsend
  jujutsu
  mako
  mpv
  nmap
  obsidian
  pavucontrol
  pax-utils
  pciutils
  pinta
  powertop
  pwgen
  ripgrep
  satty
  swayosd
  tmate
  tofi
  tokei
  traceroute
  trash-cli
  tree
  unzip
  usbutils
  vlc
  whois
  wl-clipboard
  zotero
  zoxide
]
