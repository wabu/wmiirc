  # alphabet keys
    # focus the view whose name begins with an alphabet key
    ('a'..'z').each do |k|
      key Key::VIEW + k do
        if t = tags.grep(/^#{k}/i).first
          focus_view t
        end
      end
    end
