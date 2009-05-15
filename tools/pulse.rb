class Pulse
  def initialize mixer='Master'
    @mixer = mixer
  end

  def toggle
    system "amixer set #{@mixer} toggle"
  end
  def raise
    system "amixer set #{@mixer} 5%+"
  end
  def lower
    system "amixer set #{@mixer} 5%-"
  end

  def show_mixer
    toggle_launch self, 'pavucontrol'
  end

  def status
    per,state,on,off = `amixer get Master`.match(/\[(\d+)%\] \[((on)|(off))\]/).captures
    ["%02d%%" % per, state]
  end
end
