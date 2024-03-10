# This page documents the git integration quite well:
#
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish

set VIRTUAL_ENV_DISABLE_PROMPT 'yes'

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

set __fish_git_prompt_showdirtystate 'yes'
# set __fish_git_prompt_showstashstate 'yes'
# set __fish_git_prompt_showuntrackedfiles 'yes'
# set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

set __fish_git_prompt_char_stateseparator ''
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'
	
set -q fish_prompt_dir_length 100

function fish_prompt --description 'Write out the prompt'
	# Just calculate this once, to save a few cycles when displaying the prompt
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
	end

	set -l color_cwd
	set -l suffix

	switch $USER
	case root toor
		if set -q fish_color_cwd_root
			set color_cwd $fish_color_cwd_root
		else
			set color_cwd $fish_color_cwd
		end
		set suffix '#'
	case '*'
		set color_cwd $fish_color_cwd
		set suffix '>'
	end

	if [ "$VIRTUAL_ENV" ]
		set virtenv_prompt (set_color green)"🐍 "(set_color normal)(basename "$VIRTUAL_ENV")
	end
    
    set -l ipwd (echo $PWD | sed "s|$HOME|~|")

    # This one with git status runs very very slow on nfs/sshfs!
    echo -s (set_color magenta) "┌ " (set_color -o magenta) "$USER@$__fish_prompt_hostname" (set_color normal) (__fish_git_prompt) " $virtenv_prompt"
    
    # echo -s (set_color magenta) "┌ " (set_color -o yellow) "$USER@$__fish_prompt_hostname" (set_color normal) " $virtenv_prompt"
	echo -n -s (set_color magenta) "└ " (set_color $color_cwd) "$ipwd" (set_color normal) "$suffix "
	
	#echo -n -s "└ $USER" @ "$__fish_prompt_hostname" ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
end
