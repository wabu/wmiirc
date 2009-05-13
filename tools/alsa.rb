class Alsa
  def initialize mixer='Master', status_id='volume'
    @mixer = mixer
    @status_id = status_id
  end

  def refresh
    status(@status_id)
  end

  def toggle
    system "amixer set #{@mixer} toggle"
    refresh
  end
  def raise
    system "amixer set #{@mixer} 3dB+"
    refresh
  end
  def lower
    system "amixer set #{@mixer} 3dB-"
    refresh
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
