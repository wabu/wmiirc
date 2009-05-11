################################################################################
# GENERAL CONFIGURATION
################################################################################

module Key
  MOD         = 'Mod4'
  UP          = 'k'
  DOWN        = 'j'
  LEFT        = 'h'
  RIGHT       = 'l'

  PREFIX      = MOD + '-'
  FOCUS       = PREFIX
  SEND        = PREFIX + 'Shift-'
  SWAP        = PREFIX + 'w,'
  ARRANGE     = PREFIX + 'z,'
  GROUP       = PREFIX + 'g,'
  VIEW        = PREFIX + 'v,'
  MENU        = PREFIX
  EXECUTE     = PREFIX
end

module Mouse
  PRIMARY     = 1
  MIDDLE      = 2
  SECONDARY   = 3
  SCROLL_UP   = 4
  SCROLL_DOWN = 5
end

module Color
  { # Color tuples are "<text> <background> <border>"
    :NORMCOLORS   => NORMAL     = '#5ad25a #000000 #202020',
    :FOCUSCOLORS  => FOCUSED    = '#ffffff #000000 #5ad25a',
    :BACKGROUND   => BACKGROUND = '#000000',
  }.each_pair do |k, v|
    ENV["WMII_#{k}"] = v
  end
end

WMII_FONT = '-*-dejavu sans mono-*-r-*-*-14-*-*-*-*-*-*-*'


################################################################################
# DETAILED CONFIGURATION
################################################################################

# WM Configuration
fs.ctl.write <<EOF
grabmod #{Key::MOD}
border 2
font #{WMII_FONT}
focuscolors #{Color::FOCUSED}
normcolors #{Color::NORMAL}
EOF

# Column Rules
fs.colrules.write <<EOF
/./ -> 50+50
EOF

# Tagging Rules
#fs.tagrules.write <<EOF
#/Gran Paradiso - Restore Previous Session/ -> web
#/.*notes.*/ -> note
#/Deluge/ -> tor
#/Buddy List.*/ -> chat
#/XChat.*/ -> chat
#/Thunderbird.*/ -> mail
#/Liferea.*/ -> mail
#/Gimp.*/ -> gimp
#/xconsole.*/ -> ~
#/alsamixer.*/ -> ~
#/QEMU.*/ -> ~
#/XMMS.*/ -> ~
#/MPlayer.*/ -> ~
#/.*/ -> !
#/.*/ -> 1
#EOF
