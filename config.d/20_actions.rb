# actions
  action :rehash do
    @programMenu  = find_programs ENV['PATH'].squeeze(':').split(':')
    @actionMenu   = find_programs WMIIRCDIR
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
