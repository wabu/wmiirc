# {{{ Battery monitor
# Originally by Wael Nasreddine <wael@phoenixlinux.org>.
  def battmon
    statefile = '/proc/acpi/battery/BAT0/state'
    infofile = '/proc/acpi/battery/BAT0/info'
    low = 5
    low_action = 'echo "Low battery" | xmessage -center -buttons quit:0 -default quit -file -'
    critical =  2
    critical_action = 'echo "Critical battery" | xmessage -center -buttons quit:0 -default quit -file -'
    warned_low = false
    warned_critical = false
    batt = IO.readlines(statefile)
    battinfo = IO.readlines(infofile)
    battpresent = battinfo[0].gsub(/.*:\s*/,'').chomp
    if battpresent == "yes"
      batt_percent = ((batt[4].gsub(/.*:\s*/,'').chomp.chomp("mAh").to_f / battinfo[2].gsub(/.*:\s*/,'').chomp.chomp(" mAh").to_f ) * 100).to_i
      batt_state = batt[2].gsub(/.*:\s*/,'').chomp
      # Take action in case battery is low/critical
      if batt_state == "discharging" && batt_percent <= critical && ! warned_critical
        LOG.info "Warning about critical battery."
        system("#{critical_action} &")
        warned_critical = true
      elsif batt_state == "discharging" && batt_percent <= low && ! warned_low
        LOG.info "Warning about low battery."
        system("#{low_action} &")
        warned_low = true
      else
        warned_low = false
        warned_critical = false
      end
      # If percent is 100 and state is discharging then
      # the battery is full and not discharging.
      batt_state = "=" if batt_state == "charged" || ( batt_state == "discharging" && batt_percent >= 97 )
      batt_state = "^" if batt_state == "charging"
      batt_state = "v" if batt_state == "discharging"
      text = "#{batt_state} #{batt_percent} #{batt_state}"
      return text
    else
      return "N/A"
    end
  end
