  # external programs
    require 'fileutils'

    # Open a new terminal and set its working directory
    # to be the same as the currently focused terminal.
    key Key::EXECUTE + 's' do
      c = curr_client
      d = File.expand_path(c.label.read.split(' ')[1]) rescue nil
      d = ENV['HOME'] unless File.directory? d.to_s

      system "urxvt -cd #{d} &" unless system "urxvtc -cd #{d} &"
    end

    key Key::EXECUTE + 'q' do
      curr_client.kill
    end
    
    key Key::EXECUTE + 'less' do
      system 'stjerm --toggle &'
    end

    key Key::EXECUTE + 'diaeresis' do
      system 'xscreensaver-command -lock &'
    end
