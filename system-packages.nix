{ pkgs }:

with pkgs;
let dicts = with hunspellDicts; [ en_GB-ize fr-classique el-gr ]; in
[ adwaita-icon-theme
  baobab
  bemoji
  bibata-cursors
  btop
  catppuccin-cursors.latteDark
  chromium
  curl
  delta
  dig
  direnv
  dstat
  file
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
  swaynotificationcenter
  tmate
  tofi
  traceroute
  tree
  unzip
  vlc
  whois
  wl-clipboard
  zotero
]
