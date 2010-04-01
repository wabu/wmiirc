#--
# Copyright protects this work.
# See LICENSE file for details.
#++

require 'pathname'

module Wmiirc

  ##
  # Launches the given command in the background.
  #
  # ==== Parameters
  #
  # [command]
  #   The name or path to the program you want
  #   to launch.  This can be a self-contained
  #   shell command if no arguments are given.
  #
  # [arguments]
  #   Command-line arguments for the command being launched.
  #
  # ==== Examples
  #
  # Launch a self-contained shell command (while making sure that
  # the arguments within the shell command are properly quoted):
  #
  #   launch "xmessage 'hello world' '#{Time.now}'"
  #
  # Launch a command with explicit arguments (while not
  # having to worry about shell-quoting those arguments):
  #
  #   launch 'xmessage', 'hello world', Time.now.to_s
  #
  def launch command, *arguments
    unless arguments.empty?
      command = [command, *arguments].shelljoin
    end
    if wiargs = Thread.current[:wihack]
      hack = ['wihack', *wiargs.map{|k,v| ["-#{k}", v]}.flatten].shelljoin
      command = [hack,command].join(' ')
    end
    system "#{command} &"
  end

  ##
  # Modifies environment to launch commands using wihack
  #
  # Inside the proc, the :wihack threadlocal variable will be set,
  # so you can use it in your own functions
  #
  # ==== Parameters
  #
  # [spec]
  #   keyworded hash with wihack parameters
  #
  # [proc]
  #   in which calls to launch use wihack with the given parameters
  #
  # ==== Examples
  #
  #   wihack :tags => "/./" do
  #     launch "xclock"
  #   end
  #
  def wihack spec, &proc
    old_wihack = Thread.current[:wihack]
    Thread.current[:wihack] = (old_wihack || {}).merge(spec)
    proc.call
  ensure
    Thread.current[:wihack] = old_wihack
  end

  ##
  # Modifies environment to launch commands on a specific tag using wihack
  #
  # ==== Parameters
  #
  # [tag]
  #   Tag on which commands should be lanuched. 
  #   This can be a Regexp, Symbol or String.
  #
  # [proc]
  #   in which calls to launch use wihack with the tag parameter
  #
  def tagged tag, &proc
    tag = tag.inspect if tag.is_a? Regexp
    wihack :tags => tag.to_s, &proc
  end

  ##
  # Shows a dialog box containing the given message.
  #
  # This is a "fire and forget" operation.  The result of
  # the launched dialog box is NOT returned by this method!
  #
  # ==== Parameters
  #
  # [message]
  #   The message to be displayed.
  #
  # [arguments]
  #   Additional command-line arguments for `xmessage`.
  #
  def dialog message, *arguments
    # show dialog in floating area
    Rumai.curr_view.floating_area.focus

    arguments << message
    launch 'xmessage', '-nearmouse', *arguments
  end

  ##
  # Returns the basenames of executable files present in the given directories.
  #
  def find_programs *dirs
    dirs.flatten.
    map {|d| Pathname.new(d).expand_path.children rescue [] }.flatten.
    map {|f| f.basename.to_s if f.file? and f.executable? }.compact.uniq.sort
  end

end
