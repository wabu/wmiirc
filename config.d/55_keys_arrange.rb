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
