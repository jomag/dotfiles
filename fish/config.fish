# Bundle and Rails aliases
alias be="bundle exec"
alias br="bundle exec rails"
alias brails="bundle exec rails"
alias brake="bundle exec rake"

# Copy Kitty terminfo to remote machines automatically
# if test $TERM = "xterm-kitty"
#   alias ssh="kitty +kitten ssh"
# end

# Always display ls with color
switch (uname)
case Darwin
    alias ls="ls -F -G"
case "*"
    alias ls="ls -F --color=yes"
end

# Alias 'm' to build using make and say "OK" or "FAILED" on completion
alias m='make; and say OK; or say Misslyckades'
# alias n="ninja"

# Alias: "v" to show current week
alias v="date +'Vecka %-W'"

# Alias: "n" to nvim
alias n=nvim
alias n.=nvim .

# Add /usr/local/bin to system path
set PATH /usr/local/bin $PATH

# Add the local node binaries to path
set PATH ./node_modules/.bin $PATH

# Add Android tools to path
if test -d $HOME/Library/Android
	set PATH ~/Library/Android/sdk/platform-tools $PATH
	set PATH ~/Library/Android/sdk/tools $PATH
	set PATH ~/Library/Android/sdk/emulator $PATH
end

if test -d $HOME/Android
	set PATH ~/Android/Sdk/platform-tools $PATH
	set PATH ~/Android/Sdk/tools $PATH
	set PATH ~/Android/Sdk/emulator $PATH
end

# Add Homebrew in /opt to path
if test -d /opt/homebrew
	set PATH /opt/homebrew/bin $PATH

	# Add Homebrew libraries to library path
	set LIBRARY_PATH (brew --prefix)/lib $LIBRARY_PATH
	export LIBRARY_PATH
end

# Add NeoVim to path
if test -d /opt/nvim
    set PATH /opt/nvim/bin $PATH
end

# Add Rust to path
if test -d $HOME/.cargo
    set PATH ~/.cargo/bin $PATH
end

# Add Go to path. $GOPATH is by default $HOME/go.
if test -d $HOME/go
    set PATH ~/go/bin $PATH
end

if test -d /opt/go
	set PATH /opt/go/bin $PATH
end

# Add Qt to path (keg only)
if test -d /usr/local/opt/qt/bin
    set PATH /usr/local/opt/qt/bin $PATH
end

# Add Node installed in /opt to path
if test -d /opt/node
	set PATH /opt/node/bin $PATH
end

# Add Flutter to path
if test -d $HOME/flutter
    set PATH ~/flutter/bin $PATH
end

# Add Homebrew for Linux to path
if test -d /home/linuxbrew/.linuxbrew
    set PATH /home/linuxbrew/.linuxbrew/bin $PATH
end

if test -d $HOME/.linuxbrew
    set PATH $HOME/.linuxbrew/bin $PATH
end

# Add GNU Arm Embedded Toolchain to path

if test -d $HOME/.gcc-arm
    set PATH $HOME/.gcc-arm/bin $PATH
end

# Check for .rbenv
if test -d $HOME/.rbenv
    # Add ~/.rbenv/bin to path
    set PATH $HOME/.rbenv/bin $PATH

    # Enable rbenv
    status --is-interactive; and . (rbenv init -|psub)
end

# Add Homebrew Ruby to path
# if test -d /usr/local/opt/ruby/bin
#    set PATH /usr/local/opt/ruby/bin $PATH
# end

# Heroku
# set PATH /usr/local/heroku/bin $PATH

# Add user bin
if test -d ~/bin
	set PATH ~/bin $PATH
end

if test -d ~/.local/bin
  set PATH ~/.local/bin $PATH
end

# Add ARM toolchain to path
if test -d /usr/local/gcc-arm
	set PATH /usr/local/gcc-arm/bin $PATH
end

# SSH to babbage directly or via nodens
function babbage
  if /sbin/ifconfig | grep 10.11.100 >/dev/null
    ssh 10.11.100.102
  else
    ssh -t nodens.cmteknik.se ssh 10.11.100.102
  end
end

function rubik
  if /sbin/ifconfig | grep 10.0.42 >/dev/null
    ssh 10.0.42.5
  else
    ssh rubik.cmip.se
  end
end

function pascal
  if /sbin/ifconfig | grep 10.0.42 >/dev/null
    ssh pascal.local
  else
    ssh rubik.cmip.se
  end
end


# SSH aliases
alias nodens="ssh jonatan@nodens.cmteknik.se"
alias yig="ssh jonatan@yig.cmteknik.se"
alias monroe="ssh monroe.local"
alias dagon="ssh jonatan@dagon.cmteknik.se"

# Default tmux to run in 256 color mode
alias tmux="tmux -2"

# Handle typos...
alias cd..="cd .."

# Git shortcuts
alias gs="git status"
alias gd="git diff"

# Default options for `less`
# Quit if one screen: -F
# Highlight search matches: -g
# Long prompt: -m
# Disable termcap init/deinit: -X
# Don't escape ANSI codes: -R
set LESS "-FgmXR"

# Use `less` as pager for ag
alias ag="ag $argv --pager 'less -FgmXR'"

function olle
  # Display character from Stugan. The image is automatically
  # stretch to fill width of terminal.
  set PADDING (math \((tput cols) - 42\) / 2)
  set S (printf ' %.0s' (seq $PADDING))
  set U (printf '_%.0s' (seq $PADDING))

  echo
  echo -s $S "             IIIIIIIIIIIIIIII"
  echo -s $S " _ _ _      II              II      _ _ _"
  echo -s $U "I I I I_____I                I_____I I I I$U"
  echo -s $S "I I I I     I   I--I  I--I   I     I I I I"
  echo -s $S "I_I_I_I     I   I  I  I  I   I     I_I_I_I"
  echo -s $S "            I   I  I  I  I   I    "
  echo -s $S "            I   I *I  I* I   I"
  echo -s $S "            I   I__I  I__I   I"
  echo -s $S "            II              II"
  echo -s $S "             II            II"
  echo -s $S "              II          II"
  echo -s $S "               I__      __I"
  echo -s $S "                  I    I"
  echo -s $S "                  I    I"
  echo -s $S "                  I    I"
  echo -s $S "                  I    I"
  echo -s $S "                  II  II"
  echo -s $S "                   I__I"
  echo

  set -e PADDING
  set -e S
  set -e U
end

function alt_fish_greeting
  if type -f -q neofetch
    neofetch
  else if type -f -q screenfetch
    screenfetch
  else
    if type -f -q fortune
      if type -f -q cowsay
        if type -f -q lolcat
          fortune -a | cowsay -f eyes | lolcat
        else
          fortune -a | cowsay -f eyes
        end
      else
        fortune -a
      end
    else
      echo "No screenfetch, no fortune..."
    end
  end
end

# funcsave -q fish_greeting
# funcsave fish_greeting

# funcsave -q =
# funcsave =

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jonatan/google-cloud-sdk/path.fish.inc' ]; . '/Users/jonatan/google-cloud-sdk/path.fish.inc'; end

if type -q starship
  set --append UTILS_FOUND "starship"
  starship init fish | source
else
  set --append UTILS_MISSING "starship"
end

# If "exa" is installed, use it instead of "ls"
# if type -q exa
#  set --append UTILS_FOUND "exa"
#  alias ls="exa --git --classify --group-directories-first --header"
#else
#  set --append UTILS_MISSING "exa"
#end

# Use "bat" instead of "cat" if available
# In Debian, the command name is "batcat"
if type -f -q batcat
  alias bat=batcat
end

if test -f bat
   or test -f batcat
  # Probably not a good idea:
  # alias cat=bat
  alias less='bat --paging=always'
end
