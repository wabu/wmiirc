# events
  event :CreateTag do |tag|
    bar = fs.lbar[tag]
    bar.create
    bar.write "#{Color::NORMAL} #{tag}"
  end

  event :DestroyTag do |tag|
    fs.lbar[tag].remove
  end

  event :FocusTag do |tag|
    fs.lbar[tag].write "#{Color::FOCUSED} #{tag}"
  end

  event :UnfocusTag do |tag|
    btn = fs.lbar[tag]
    btn.write "#{Color::NORMAL} #{tag}" if btn.exist?
  end

  event :UrgentTag do |tag|
    btn = fs.lbar[tag]
    btn.write "*#{tag}" if btn.exist?
  end

  event :NotUrgentTag do |tag|
    btn = fs.lbar[tag]
    btn.write tag if btn.exist?
  end

  event :LeftBarClick do |button, viewId|
    case button.to_i
    when Mouse::PRIMARY
      focus_view viewId

    when Mouse::MIDDLE
      # add the grouping onto the clicked view
      grouping.each do |c|
        c.tag viewId
      end

    when Mouse::SECONDARY
      # remove the grouping from the clicked view
      grouping.each do |c|
        c.untag viewId
      end
    end
  end

  event :ClientClick do |clientId, button|
    case button.to_i
    when Mouse::SECONDARY
      # toggle the clicked client's grouping
      Client.toggle_group clientId
    end
  end
