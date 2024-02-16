# startup script
ulimit -n 10240

# Link zsh to asdf
. $(brew --prefix)/opt/asdf/libexec/asdf.sh

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        if [ ${config:e} = "zwc" ] ; then continue ; fi
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [[ -f $config && ${config:e} != "zwc" ]]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        if [ ${config:e} = "zwc" ] ; then continue ; fi
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
DEFAULT_USER=$(whoami)

export EDITOR=/opt/homebrew/bin/vim
export VISUAL=/opt/homebrew/bin/vim

# Use ripgrep for fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git history history-substring-search postgres)

# Disable autocorrect
unsetopt correct_all
unsetopt correct

DISABLE_AUTO_TITLE="true"

# Attach or start new tmux session
if [[ -z "$TMUX" ]] ;then
    ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        exec tmux new-session -A -s workspace
    else
        tmux attach-session -t "$ID" # if available attach to it
    fi
fi

# Add postgres to path
# export PATH="/usr/local/opt/postgresql@10/bin:$PATH"
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# # openssl
# # For compilers to find openssl@1.1 you may need to set:
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
#
# # For pkg-config to find openssl@1.1 you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
#
# # python3
# export PATH="/usr/local/opt/python3/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# # Load work zshrc settings
# [[ -f ~/.zshrc.work.local ]] && source ~/.zshrc.work.local

# TODO: remove?
# export PATH="$HOME/.bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
source /opt/homebrew/opt/asdf/libexec/asdf.sh
### Added by node-macos-certs on Thu Feb 15 17:22:32 PST 2024 ###
export NODE_EXTRA_CA_CERTS="/Users/tony.chung/.local/node-macos-certs/certs.pem"
