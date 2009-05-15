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
    head = 'v'
    text = "%d:%02d" % rem_run.to_i.divmod(60)
    color = case rem_per.to_i
    when 40..100
      CONFIG['display']['color']['success']
    when 10..39
      CONFIG['display']['color']['notice']
    when 0..9
      CONFIG['display']['color']['error']
    end
  when "charging"
    head = '^'
    color = CONFIG['display']['color']['focus']
    text = "%d:%02d" % rem_charge.to_i.divmod(60)
  when "idle"
    head = '='
    color = CONFIG['display']['color']['normal']
    text = "full"
  end
  status = head + [rem_per.to_i, 99].min.to_s + head
  return [color, status, text]
end