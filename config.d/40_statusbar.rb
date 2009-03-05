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


#      StatusBar.new(fs.rbar.disk_space, 10) do
#        rem, use, dir = `df -h ~`.split[-3..-1]
#        "#{dir} #{use} used #{rem} free"
#      end,
    ]
  end
