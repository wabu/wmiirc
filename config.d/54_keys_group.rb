  # client grouping
    # include/exclude the currently focused client from the grouping
    key Key::GROUP + 'g' do
      curr_client.toggle_group
    end

    # include all clients in the currently focused view into the grouping
    key Key::GROUP + 'v' do
      curr_view.group
    end

    # exclude all clients in the currently focused view from the grouping
    key Key::GROUP + 'Shift-v' do
      curr_view.ungroup
    end

    # include all clients in the currently focused area into the grouping
    key Key::GROUP + 'c' do
      curr_area.group
    end

    # exclude all clients in the currently focused column from the grouping
    key Key::GROUP + 'Shift-c' do
      curr_area.ungroup
    end

    # include all clients in the floating area into the grouping
    key Key::GROUP + 'f' do
      curr_view.floating_area.group
    end

    # exclude all clients in the currently focused column from the grouping
    key Key::GROUP + 'Shift-f' do
      curr_view.floating_area.ungroup
    end

    # include all clients in the managed areas into the grouping
    key Key::GROUP + 'm' do
      curr_view.columns.each do |c|
        c.group
      end
    end

    # exclude all clients in the managed areas from the grouping
    key Key::GROUP + 'Shift-m' do
      curr_view.columns.each do |c|
        c.ungroup
      end
    end

    # invert the grouping in the currently focused view
    key Key::GROUP + 'i' do
      curr_view.toggle_group
    end

    # exclude all clients everywhere from the grouping
    key Key::GROUP + 'n' do
      Rumai.ungroup
    end
