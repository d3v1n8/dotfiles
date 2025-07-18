#!/bin/bash

brew_apps=(
  "neovim" "mas" "git" "tmux"
  "romkatv/powerlevel10k/powerlevel10k"
  "zsh-autosuggestions" "zsh-syntax-highlighting"
  "z" "lsd" "nvm" "ripgrep" "htop" "wget"
)

cask_apps=(
  "topnotch" "google-chrome" "iterm2"
  "notion" "postman" "slack" "intellij-idea" "todoist"
)

mas_apps=("KakaoTalk")

function log_info() {
  echo -e "$1 \033[32;1m$2\033[m"
}

function log_start() {
  echo -e "$1 \033[31;1m$2\033[m"
}

function install_brew() {
  if ! command -v brew &> /dev/null; then
    log_start "<brew>" "Start Install..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    log_info "<brew>" "Install Finish!!"
  fi

  brew update
  brew upgrade
}

function install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log_start "<oh-my-zsh>" "Start Install..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    log_info "<oh-my-zsh>" "Install Finish!!"
  else
    log_info "<oh-my-zsh>" "Already Installed!!"
  fi
}

function install_apps() {
  local -n app_list=$1
  local option=$2

  for app in "${app_list[@]}"; do
    if ! brew list ${option} "${app}" &> /dev/null; then
      log_start "<$app>" "Start Install..."
      [[ "$app" == "font-hack-nerd-font" ]] && brew tap homebrew/cask-fonts
      brew install ${option} "${app}"
      log_info "<$app>" "Install Finish!!"
    else
      log_info "<$app>" "Already Installed!!"
    fi
  done
}

function install_mas_apps() {
  for app in "${mas_apps[@]}"; do
    if ! mas list | grep -q "${app}"; then
      log_start "<$app>" "Start Install..."
      mas search "${app}" | sed -n "/${app}/p" | sed -nr "s/ ${app}.+//p" | xargs -I{} mas install {}
      log_info "<$app>" "Install Finish!!"
    else
      log_info "<$app>" "Already Installed!!"
    fi
  done
}

function install_sdkman() {
  if [[ ! -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    log_start "<sdkman>" "Start Install..."
    curl -s "https://get.sdkman.io" | bash
    log_info "<sdkman>" "Install Finish!!"
  else
    log_info "<sdkman>" "Already Installed!!"
  fi
}

function copy_configs() {
  cp -r ../nvim ~/.config/
  cp -r ../tmux ~/.config/
  cp ../shell/.zshrc ~
  cp ../.ideavimrc ~
}

# 실행 순서
install_brew
install_oh_my_zsh
install_apps brew_apps
install_apps cask_apps "--cask"
install_mas_apps
install_sdkman
copy_configs
