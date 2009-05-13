class Alsa
  def initialize mixer='Master'
    @mixer = mixer
  end

  def toggle
    system "amixer set #{@mixer} toggle"
  end
  def raise
    system "amixer set #{@mixer} 3dB+"
  end
  def lower
    system "amixer set #{@mixer} 3dB-"
  end

  def show_mixer
    curr_view.select(:toggle)
    terminal 'alsamixer'
  end

  def to_s
    per,tuned,db,state,on,off = `amixer get Master`.match(/\[(\d+)%\] \[(-)?(\d+)\.\d+dB\] \[((on)|(off))\]/).captures
    ["%02d%%" % per, on ? (tuned ? "-%02ddB" % db.to_i : "00dB") : (tuned ? "muted" : "mute")].join(' ')
  end
end
