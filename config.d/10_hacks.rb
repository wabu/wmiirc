  # wmii puts subsequent firefox instances on the same
  # view as the first instance. bypass this and move
  # the newly created firefox to the current view
  #
  # this "feature" applies to all programs
  # that provide window grouping hints. so
  # we'll just have this event handler
  # bypass the feature for ALL programs! :-(
  event :CreateClient do |id|
    c = Client.new(id)

    case c.props.read
    when /Gran Paradiso - Restore Previous Session/
      c.tags = 'web'
    when /:(Firefox|Gran Paradiso|jEdit|Epiphany)/i
      c.tags = curr_tag
      c.focus
    when /:(stjerm|yakuake)/i
      c.tags = curr_tag
      c.focus
    end
  end
