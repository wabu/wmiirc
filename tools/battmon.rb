def battmon
  # This is just a ugly workaround, until I know (or more likely sunaku) 
  # why IO.readlines doesn't work
  rem_per = File.open('/sys/devices/platform/smapi/BAT0/remaining_percent', 'r') { |f| f.readline }.chomp
  rem_run = File.open('/sys/devices/platform/smapi/BAT0/remaining_running_time', 'r') { |f| f.readline }.chomp
  rem_charge = File.open('/sys/devices/platform/smapi/BAT0/remaining_charging_time', 'r') { |f| f.readline }.chomp
  state = File.open('/sys/devices/platform/smapi/BAT0/state', 'r'){ |f| f.readline }.chomp
  present = (File.open('/sys/devices/platform/smapi/BAT0/installed', 'r'){ |f| f.readline }.chomp) == "1"

  return "N/A" unless present
  case state
  when "discharging"
    text = "%d:%02d" % rem_run.to_i.divmod(60)
    color = case rem_per.to_i
    when 40..100
      "#00ff00 #000000 #202020"
    when 10..39
      "#ffff00 #000000 #202020"
    when 0..9
      "#ff0000 #000000 #202020"
    end
  when "charging"
    color = "#0000ff #000000 #202020"
    text = "%d:%02d" % rem_charge.to_i.divmod(60)
  when "idle"
    color = "#0000ff #000000 #202020"
    text = "idle"
  end
  return [color, text]
end
