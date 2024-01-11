# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin installation:

# autosuggestions --> "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# zsh-syntax-highlighting --> "sudo apt install -y zsh-syntax-highlighting && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# fzf --> "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"

# ..
# then "source ~/.zshrc"
plugins=(
	git
	zsh-autosuggestions
	z
	zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf keybinds
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Various keybinds
bindkey '^ ' autosuggest-accept
setxkbmap -option caps:escape
setxkbmap ch 

# Setup of xserver for qt in docker
xhost + local: >> /dev/null

# Change key repetiton speed
xset r rate 300 50

ENABLE_CORRECTION="true"

# Aliases
#alias "sudo"="sudo "
#fix ssh issues with kitty
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

alias rm="echo Use 'del', or the full path i.e. '/bin/rm' && cat ~/.monkey"
alias t="tree -L 2"
alias "tg"="/home/marc/naviswiss/tracker/fxload -i /home/marc/naviswiss/tracker/Camera.img ; /home/marc/naviswiss/tracker/tracker  >> /dev/null 2>&1 &" # bring-up of tracker
alias "cp"="rsync -ah --progress"
alias "apt"="nala"
alias "apt-get"="nala"
alias "vim"="nvim"

## Medivation aliases
alias meditool="(cd /home/marc/tools/MediTool\ V1.2.0 ; ./MediTool.AppImage)"
alias "cg"="/home/marc/private/git/dotfiles_private/nixos/connect_wifi_guest.sh"
alias "ci"="/home/marc/private/git/dotfiles_private/nixos/connect_wifi_inside.sh"
