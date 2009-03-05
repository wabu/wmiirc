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

    # focus the previous view
    key 'Control-XF86Back' do
      prev_view.focus
    end

    # focus the next view
    key 'Control-XF86Forward' do
      next_view.focus
    end
    
    10.times do |i|
      # focus the {i}'th view
      key Key::FOCUS + i.to_s do
        focus_view tags[i - 1] || i
      end
    end
