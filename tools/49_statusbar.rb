  class Button < Thread
    ##
    # Creates a new button at the given node and updates its label
    # according to the given refresh rate (measured in seconds).  The
    # given block is invoked to calculate the label of the button.
    #
    # The return value of the given block must be either an array (whose
    # first item is a color sequence for the button, and the second is the
    # label of the button) or a string containing the label of the button.
    #
    def initialize bar_node, refresh_rate, &bar_label
      raise ArgumentError unless block_given?

      super(bar_node) do |b|
        b.create unless b.exist?

        while true
          ary = Array(bar_label.call)

          # provide a default color
          unless ary.length > 1
            ary.unshift Color::NORMAL
          end

          b.write ary.join(' ')
          sleep refresh_rate
        end
      end
    end
  end

  VOLUMEBARNAME="u_volume"
  fs.rbar.clear

  action :status do
    if defined? @buttons
      @buttons.each {|s| s.kill }
    end

    @buttons = [
      Button.new(fs.rbar.clock, 1) do
        Time.now.strftime("%a %b %d %H:%M:%S")
      end,

      Button.new(fs.rbar.batmon, 20) do
        battmon
      end,

      Button.new(fs.rbar.volume, 10) do
        refresh_volume_display
      end,

      Button.new(fs.rbar.cpu_load, 5) do
        File.read('/proc/loadavg').split[0..2].join(' ')
      end,

#      Button.new(fs.rbar.disk_space, 10) do
#        rem, use, dir = `df -h ~`.split[-3..-1]
#        "#{dir} #{use} used #{rem} free"
#      end,
    ]
  end
