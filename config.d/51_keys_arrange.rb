    # apply equal-spacing layout to current column
    key Key::ARRANGE + 'w' do
      curr_area.layout = :default
    end

    # apply equal-spacing layout to all columns
    key Key::ARRANGE + 'Shift-w' do
      curr_view.columns.each do |a|
        a.layout = :default
      end
    end

    # apply stacked layout to currently focused column
    key Key::ARRANGE + 'v' do
      curr_area.layout = :stack
    end

    # apply stacked layout to all columns in current view
    key Key::ARRANGE + 'Shift-v' do
      curr_view.columns.each do |a|
        a.layout = :stack
      end
    end

    # apply maximized layout to currently focused column
    key Key::ARRANGE + 'm' do
      curr_area.layout = :max
    end

    # apply maximized layout to all columns in current view
    key Key::ARRANGE + 'Shift-m' do
      curr_view.columns.each do |a|
        a.layout = :max
      end
    end

    10.times do |i|
      # apply grid layout with {i} clients per column
      key Key::ARRANGE + i.to_s do
        curr_view.arrange_in_grid i
      end
    end

  # visual arrangement
    key Key::ARRANGE + 't' do
      curr_view.arrange_as_larswm
    end

    key Key::ARRANGE + 'g' do
      curr_view.arrange_in_grid
    end

    key Key::ARRANGE + 'd' do
      curr_view.arrange_in_diamond
    end
