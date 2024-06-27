function fish_greeting
  if type -f -q fastfetch
    fastfetch
  else if type -f -q neofetch
    neofetch
  end

  if false

  if set -q UTILS_FOUND
    echo -n "Using: "
    set_color green
    echo -n $UTILS_FOUND
    set_color normal

    if set -q UTILS_MISSING
      echo -n ". "
    else
      echo ""
    end
  end

  if set -q UTILS_MISSING
    echo -n "Missing: "
    set_color red
    echo -n $UTILS_MISSING
    set_color normal
    echo "."
  end
  
  end
end
