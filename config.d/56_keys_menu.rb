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
