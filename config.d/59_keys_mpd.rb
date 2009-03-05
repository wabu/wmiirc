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
