    # swap the currently focused client with the one to its left
    key Key::SWAP + Key::LEFT do
      curr_client.swap :left
    end

    # swap the currently focused client with the one to its right
    key Key::SWAP + Key::RIGHT do
      curr_client.swap :right
    end

    # swap the currently focused client with the one below it
    key Key::SWAP + Key::DOWN do
      curr_client.swap :down
    end

    # swap the currently focused client with the one above it
    key Key::SWAP + Key::UP do
      curr_client.swap :up
    end
    10.times do |i|
      # swap current client with the primary client in {i}'th column
      key Key::SWAP + i.to_s do
        curr_view.ctl.write "swap sel #{i+1}" # XXX: +1 b/c floating area is column 1: until John-Galt fixes this!
      end
    end
