{ pkgs }:

with pkgs;
let dicts = with hunspellDicts; [ en_GB-ize fr-classique el-gr ]; in
[ adwaita-icon-theme
  baobab
  bemoji
  btop
  catppuccin-cursors.latteDark
  chromium
  curl
  delta
  direnv
  dstat
  gh
  ghostty
  gimp
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
