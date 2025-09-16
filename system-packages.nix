{ pkgs }:

with pkgs;
let dicts = with hunspellDicts; [ en_GB-ize fr-classique el-gr ]; in
[ adwaita-icon-theme
  baobab
  bat
  bemoji
  bibata-cursors
  broot
  btop
  catppuccin-cursors.latteDark
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
  gh
  ghostty
  gimp
  gnome-calculator
  grim
  grimblast
  (hunspellWithDicts dicts)
  impala
  imv
  jq
  keymapp
  localsend
  mpv
  nmap
  obsidian
  pavucontrol
  pax-utils
  pciutils
  powertop
  pwgen
  ripgrep
  swaynotificationcenter
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
