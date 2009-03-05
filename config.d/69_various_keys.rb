  # zooming / sizing
    ZOOMED_SUFFIX = /~(\d+)$/

    # Sends grouped clients to temporary view.
    key Key::PREFIX + 'b' do
      if curr_tag =~ ZOOMED_SUFFIX
        src, num = $`, $1.to_i
        dst = "#{src}~#{num+1}"
      else
        dst = "#{curr_tag}~1"
      end

      grouping.each do |c|
        c.tag dst
      end

      v = View.new dst
      v.focus
      v.arrange_in_grid
      #if c = grouping.shift then c.focus unless c.focus? end
    end

    # Sends grouped clients back to their original view.
    key Key::PREFIX + 'Shift-b' do
      src = curr_tag

      if src =~ ZOOMED_SUFFIX
        dst = $`

        grouping.each do |c|
          c.with_tags do
            delete src

            if empty?
              push dst
            else
              dst = last
            end
          end
        end

        focus_view dst
      end
    end

  # wmii-2 style client detaching
    DETACHED_TAG = '|'

    # Detach the current grouping from the current view.
    key Key::PREFIX + 'o' do
      grouping.each do |c|
        c.with_tags do
          delete curr_tag
          push DETACHED_TAG
        end
      end
    end

    # Attach the most recently detached client onto the current view.
    key Key::PREFIX + 'Shift-o' do
      v = View.new DETACHED_TAG

      if v.exist? and c = v.clients.last
        c.with_tags do
          delete DETACHED_TAG
          push curr_tag
        end
      end
    end
