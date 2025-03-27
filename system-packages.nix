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
  curl
  delta
  dig
  direnv
  dstat
  eza
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
  imv
  jq
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
  tree
  unzip
  vlc
  whois
  wl-clipboard
  zotero
  zoxide
]
