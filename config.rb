# Ruby-based configuration file for wmii.

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

# events
  event :CreateTag do |tag|
    bar = fs.lbar[tag]
    bar.create
    bar.write "#{Color::NORMAL} #{tag}"
  end

  event :DestroyTag do |tag|
    fs.lbar[tag].remove
  end

  event :FocusTag do |tag|
    fs.lbar[tag].write "#{Color::FOCUSED} #{tag}"
  end

  event :UnfocusTag do |tag|
    btn = fs.lbar[tag]
    btn.write "#{Color::NORMAL} #{tag}" if btn.exist?
  end

  event :UrgentTag do |tag|
    btn = fs.lbar[tag]
    btn.write "*#{tag}" if btn.exist?
  end

  event :NotUrgentTag do |tag|
    btn = fs.lbar[tag]
    btn.write tag if btn.exist?
  end

  event :LeftBarClick do |button, viewId|
    case button.to_i
    when Mouse::PRIMARY
      focus_view viewId

    when Mouse::MIDDLE
      # add the grouping onto the clicked view
      grouping.each do |c|
        c.tag viewId
      end

    when Mouse::SECONDARY
      # remove the grouping from the clicked view
      grouping.each do |c|
        c.untag viewId
      end
    end
  end

  event :ClientClick do |clientId, button|
    case button.to_i
    when Mouse::SECONDARY
      # toggle the clicked client's grouping
      Client.toggle_group clientId
    end
  end

  # wmii puts subsequent firefox instances on the same
  # view as the first instance. bypass this and move
  # the newly created firefox to the current view
  #
  # this "feature" applies to all programs
  # that provide window grouping hints. so
  # we'll just have this event handler
  # bypass the feature for ALL programs! :-(
  event :CreateClient do |id|
    c = Client.new(id)

    case c.props.read
    when /Gran Paradiso - Restore Previous Session/
      c.tags = 'web'
    when /:(Firefox|Gran Paradiso|jEdit|Epiphany)/i
      c.tags = curr_tag
      c.focus
    when /:(stjerm|yakuake)/i
      c.tags = curr_tag
      c.focus
    end
  end

# actions
  action :rehash do
    @programMenu  = find_programs ENV['PATH'].squeeze(':').split(':')
    @actionMenu   = find_programs File.dirname(__FILE__)
  end

  action :kill do
    fs.ctl.write 'quit'
  end

  action :quit do
    action :clear
    action :kill
  end

  action :clear do
    # firefox's restore session feature doesn't
    # work unless the whole process is killed.
    system 'killall firefox firefox-bin thunderbird thunderbird-bin deluge'

    # gnome-panel refuses to die by other means
    system 'killall -s TERM gnome-panel'

    until (clients = Rumai.clients).empty?
      clients.each do |c|
        begin
          c.focus
          c.ctl.write :kill
        rescue
        end
      end
    end
  end

  class StatusBar < Thread
    def initialize aBarNode, aRefreshRate, aBarColor = Color::NORMAL, &aBarText
      raise ArgumentError unless block_given?

      super aBarNode do |b|
        b.create unless b.exist?

        while true
          b.write "#{aBarColor} #{aBarText.call}"
          sleep aRefreshRate
        end
      end
    end
  end

  action :status do
    if defined? @statusBars
      @statusBars.each {|s| s.kill }
    end

    @statusBars = [
      StatusBar.new(fs.rbar.volume, 10) do
        refresh_volume_display
      end,

      StatusBar.new(fs.rbar.clock, 1) do
        Time.now.strftime "%a %b %d %H:%M:%S"
      end,

      StatusBar.new(fs.rbar.cpu_load, 5) do
        File.read('/proc/loadavg').split[0..2].join(' ')
      end,

      StatusBar.new(fs.rbar.wlan, 20) do
               
      end 

#      StatusBar.new(fs.rbar.disk_space, 10) do
#        rem, use, dir = `df -h ~`.split[-3..-1]
#        "#{dir} #{use} used #{rem} free"
#      end,
    ]
  end

# keyboard shortcuts
  # focusing / showing
    # focus client at left
    key Key::FOCUS + Key::LEFT do
      curr_view.ctl.write 'select left' rescue nil
    end

    # focus client at right
    key Key::FOCUS + Key::RIGHT do
      curr_view.ctl.write 'select right' rescue nil
    end

    # focus client below
    key Key::FOCUS + Key::DOWN do
      curr_view.ctl.write 'select down'
    end

    # focus client above
    key Key::FOCUS + Key::UP do
      curr_view.ctl.write 'select up'
    end

    # toggle focus between floating area and the columns
    key Key::FOCUS + 'space' do
      curr_view.ctl.write 'select toggle'
    end

    # apply equal-spacing layout to current column
    key Key::ARRANGE + 'w' do
      curr_area.layout = :default
    end

    # apply equal-spacing layout to all columns
    key Key::ARRANGE + 'Shift-w' do
      curr_view.columns.each do |a|
        a.layout = :default
      end
    end

    # apply stacked layout to currently focused column
    key Key::ARRANGE + 'v' do
      curr_area.layout = :stack
    end

    # apply stacked layout to all columns in current view
    key Key::ARRANGE + 'Shift-v' do
      curr_view.columns.each do |a|
        a.layout = :stack
      end
    end

    # apply maximized layout to currently focused column
    key Key::ARRANGE + 'm' do
      curr_area.layout = :max
    end

    # apply maximized layout to all columns in current view
    key Key::ARRANGE + 'Shift-m' do
      curr_view.columns.each do |a|
        a.layout = :max
      end
    end

    # focus the previous view
    key 'Control-XF86Back' do
      prev_view.focus
    end

    # focus the next view
    key 'Control-XF86Forward' do
      next_view.focus
    end

  # sending / moving
    key Key::SEND + Key::LEFT do
      grouping.each do |c|
        c.send :left
      end
    end

    key Key::SEND + Key::RIGHT do
      grouping.each do |c|
        c.send :right
      end
    end

    key Key::SEND + Key::DOWN do
      grouping.each do |c|
        c.send :down
      end
    end

    key Key::SEND + Key::UP do
      grouping.each do |c|
        c.send :up
      end
    end

    # send all grouped clients from managed to floating area (or vice versa)
    key Key::SEND + 'space' do
      grouping.each do |c|
        c.send :toggle
      end
    end

    # close all grouped clients
    key Key::SEND + 'Delete' do
      grouping.each do |c|
        c.ctl.write 'kill'
      end
    end

    # toggle fullscreen of the current client - TODO implement to rumai
    key Key::SEND + 'f' do
      curr_client.ctl.write "Fullscreen toggle"
    end

    # swap the currently focused client with the one to its left
    key Key::SWAP + Key::LEFT do
      curr_client.swap :left
    end

    # swap the currently focused client with the one to its right
    key Key::SWAP + Key::RIGHT do
      curr_client.swap :right
    end

    # swap the currently focused client with the one below it
    key Key::SWAP + Key::DOWN do
      curr_client.swap :down
    end

    # swap the currently focused client with the one above it
    key Key::SWAP + Key::UP do
      curr_client.swap :up
    end

    # Changes the tag (according to a menu choice) of each grouped client and
    # returns the chosen tag. The +tag -tag idea is from Jonas Pfenniger:
    # <http://zimbatm.oree.ch/articles/2006/06/15/wmii-3-and-ruby>
    key Key::SEND + 'v' do
      choices = tags.map {|t| [t, "+#{t}", "-#{t}"]}.flatten

      if target = show_menu(choices, 'tag as:')
        grouping.each do |c|
          case target
          when /^\+/
            c.tag $'

          when /^\-/
            c.untag $'

          else
            c.tags = target
          end
        end
      end
    end

  # zooming / sizing
    ZOOMED_SUFFIX = /~(\d+)$/

    # Sends grouped clients to temporary view.
    key Key::PREFIX + 'b' do
      if curr_tag =~ ZOOMED_SUFFIX
        src, num = $`, $1.to_i
        dst = "#{src}~#{num+1}"
      else
        dst = "#{curr_tag}~1"
      end

      grouping.each do |c|
        c.tag dst
      end

      v = View.new dst
      v.focus
      v.arrange_in_grid
      #if c = grouping.shift then c.focus unless c.focus? end
    end

    # Sends grouped clients back to their original view.
    key Key::PREFIX + 'Shift-b' do
      src = curr_tag

      if src =~ ZOOMED_SUFFIX
        dst = $`

        grouping.each do |c|
          c.with_tags do
            delete src

            if empty?
              push dst
            else
              dst = last
            end
          end
        end

        focus_view dst
      end
    end

  # client grouping
    # include/exclude the currently focused client from the grouping
    key Key::GROUP + 'g' do
      curr_client.toggle_group
    end

    # include all clients in the currently focused view into the grouping
    key Key::GROUP + 'v' do
      curr_view.group
    end

    # exclude all clients in the currently focused view from the grouping
    key Key::GROUP + 'Shift-v' do
      curr_view.ungroup
    end

    # include all clients in the currently focused area into the grouping
    key Key::GROUP + 'c' do
      curr_area.group
    end

    # exclude all clients in the currently focused column from the grouping
    key Key::GROUP + 'Shift-c' do
      curr_area.ungroup
    end

    # include all clients in the floating area into the grouping
    key Key::GROUP + 'f' do
      curr_view.floating_area.group
    end

    # exclude all clients in the currently focused column from the grouping
    key Key::GROUP + 'Shift-f' do
      curr_view.floating_area.ungroup
    end

    # include all clients in the managed areas into the grouping
    key Key::GROUP + 'm' do
      curr_view.columns.each do |c|
        c.group
      end
    end

    # exclude all clients in the managed areas from the grouping
    key Key::GROUP + 'Shift-m' do
      curr_view.columns.each do |c|
        c.ungroup
      end
    end

    # invert the grouping in the currently focused view
    key Key::GROUP + 'i' do
      curr_view.toggle_group
    end

    # exclude all clients everywhere from the grouping
    key Key::GROUP + 'n' do
      Rumai.ungroup
    end

  # visual arrangement
    key Key::ARRANGE + 't' do
      curr_view.arrange_as_larswm
    end

    key Key::ARRANGE + 'g' do
      curr_view.arrange_in_grid
    end

    key Key::ARRANGE + 'd' do
      curr_view.arrange_in_diamond
    end

  # interactive menu
    # launch an internal action by choosing from a menu
    key Key::MENU + 'i' do
      if choice = show_menu(@actionMenu + ACTIONS.keys, 'run action:')
        unless action choice.to_sym
          system choice << '&'
        end
      end
    end

    # launch an external program by choosing from a menu
    key Key::MENU + 'a' do
      if choice = show_menu(@programMenu, 'run program:')
        system choice << '&'
      end
    end

    # focus any view by choosing from a menu
    key Key::MENU + 'e' do
      if choice = show_menu(tags, 'show view:')
        focus_view choice
      end
    end

    # focus any client by choosing from a menu
    key Key::MENU + 'd' do
      choices = []
      clients.each_with_index do |c, i|
        choices << "%d. [%s] %s" % [i, c[:tags].read, c[:props].read.downcase]
      end

      if target = show_menu(choices, 'show client:')
        i = target.scan(/\d+/).first.to_i
        clients[i].focus
      end
    end

  # external programs
    require 'fileutils'

    # Open a new terminal and set its working directory
    # to be the same as the currently focused terminal.
    key Key::EXECUTE + 's' do
      c = curr_client
      d = File.expand_path(c.label.read.split(' ')[1]) rescue nil
      d = ENV['HOME'] unless File.directory? d.to_s

      system "urxvtc -cd #{d} &"
    end

    key Key::EXECUTE + 'q' do
      curr_client.kill
    end
    
    key Key::EXECUTE + 'less' do
      system 'stjerm --toggle &'
    end

    # volume controls
      def refresh_volume_display
        level = `ossmix vmix0-outvol`.scan(/\d{1,2}.\d/).first
        label = "#{level} dB"

        b = Rumai.fs.rbar.volume
        b.create unless b.exist?
        b.write "#{Color::NORMAL} #{label}"

        label
      end

      key 'XF86AudioRaiseVolume' do
        system 'ossmix vmix0-outvol -- +1'
        refresh_volume_display
      end

      key 'XF86AudioLowerVolume' do
        system 'ossmix vmix0-outvol -- -1'
        refresh_volume_display
      end

      key 'XF86AudioMute' do
        system 'ossmix misc.lineout-mix.mute.front TOGGLE'
        refresh_volume_display
      end

    # music controls
      print 'connecting to MPD... ',
      begin
        require 'rubygems'
        require 'librmpd'

        @mpd = MPD.new
        @mpd.connect(true) # true keeps connection alive
      rescue => e
        puts e # ignore
      end

      key(Key::PREFIX + 'x')  { @mpd.previous }
      key(Key::PREFIX + 'y')   { @mpd.next }

      key Key::PREFIX + 'c' do # play / pause
        if @mpd.stopped?
          @mpd.play
        else
          # toggle play/pause
          @mpd.pause = !@mpd.paused?
        end
      end

      # load an MPD playlist
      key(Key::PREFIX + 'v') do
        choices = @mpd.playlists

        if target = show_menu(choices, 'load MPD playlist:')
          @mpd.clear
          @mpd.load target
          @mpd.play
        end
      end

      # add current song to an MPD playlist
      key(Key::PREFIX + 'End') do
        choices = @mpd.playlists

        if target = show_menu(choices, 'add current song to MPD playlist:')
          song = @mpd.current_song

          file = File.join(File.expand_path('~/.mpd/playlists'), target + '.m3u')
          list = File.read(file).split(/\r?\n/) rescue []

          list.push song.file
          list.uniq!

          File.open(file, 'w') {|f| f.puts list }
        end
      end


  # wmii-2 style client detaching
    DETACHED_TAG = '|'

    # Detach the current grouping from the current view.
    key Key::PREFIX + 'o' do
      grouping.each do |c|
        c.with_tags do
          delete curr_tag
          push DETACHED_TAG
        end
      end
    end

    # Attach the most recently detached client onto the current view.
    key Key::PREFIX + 'Shift-o' do
      v = View.new DETACHED_TAG

      if v.exist? and c = v.clients.last
        c.with_tags do
          delete DETACHED_TAG
          push curr_tag
        end
      end
    end

  # number keys
    10.times do |i|
      # focus the {i}'th view
      key Key::FOCUS + i.to_s do
        focus_view tags[i - 1] || i
      end

      # send current grouping to {i}'th view
      key Key::SEND + i.to_s do
        grouping.each do |c|
          c.tags = tags[i - 1] || i
        end
      end

      # swap current client with the primary client in {i}'th column
      key Key::SWAP + i.to_s do
        curr_view.ctl.write "swap sel #{i+1}" # XXX: +1 b/c floating area is column 1: until John-Galt fixes this!
      end

      # apply grid layout with {i} clients per column
      key Key::ARRANGE + i.to_s do
        curr_view.arrange_in_grid i
      end
    end

  # alphabet keys
    # focus the view whose name begins with an alphabet key
    ('a'..'z').each do |k|
      key Key::VIEW + k do
        if t = tags.grep(/^#{k}/i).first
          focus_view t
        end
      end
    end

# wallpaper
  system "xsetroot -solid #{Color::BACKGROUND.inspect} &"
  system 'sh ~/.fehbg &' # set desktop wallpaper

# bootstrap
  action :status
  action :rehash
