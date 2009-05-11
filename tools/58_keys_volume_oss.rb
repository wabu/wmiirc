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
