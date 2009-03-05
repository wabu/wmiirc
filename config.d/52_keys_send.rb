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

    10.times do |i|
      # send current grouping to {i}'th view
      key Key::SEND + i.to_s do
        grouping.each do |c|
          c.tags = tags[i - 1] || i
        end
      end
    end
