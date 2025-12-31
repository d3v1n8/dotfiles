#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Mac 초기 설정 스크립트 ==="
echo ""

# Homebrew 설치 확인 및 설치
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "[1/4] Homebrew 설치 중..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Apple Silicon Mac인 경우 PATH 설정
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo "[1/4] Homebrew 이미 설치됨"
    fi
}

# Brew Cask 앱 설치
install_apps() {
    echo "[2/4] 앱 설치 중..."

    # Cask 앱 목록
    CASK_APPS=(
        "iterm2"
        "google-chrome"
        "discord"
        "slack"
        "zoom"
        "figma"
        "claude"
        "topnotch"
    )

    for app in "${CASK_APPS[@]}"; do
        if brew list --cask "$app" &> /dev/null; then
            echo "  ✓ $app 이미 설치됨"
        else
            echo "  → $app 설치 중..."
            brew install --cask "$app" || echo "  ⚠ $app 설치 실패"
        fi
    done
}

# CLI 도구 설치 (tmux 포함)
install_cli_tools() {
    echo "[3/4] CLI 도구 설치 중..."

    CLI_TOOLS=(
        "tmux"
    )

    for tool in "${CLI_TOOLS[@]}"; do
        if brew list "$tool" &> /dev/null; then
            echo "  ✓ $tool 이미 설치됨"
        else
            echo "  → $tool 설치 중..."
            brew install "$tool" || echo "  ⚠ $tool 설치 실패"
        fi
    done

    # TPM (Tmux Plugin Manager) 설치
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "  → TPM (Tmux Plugin Manager) 설치 중..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        echo "  ✓ TPM 이미 설치됨"
    fi
}

# 설정 파일 링크
link_configs() {
    echo "[4/4] 설정 파일 링크 중..."

    # tmux 설정
    if [ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]; then
        ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf
        echo "  ✓ tmux 설정 링크됨"
    fi

    # tmux powerline 설정
    mkdir -p ~/.config/tmux
    if [ -f "$DOTFILES_DIR/tmux/.tmux.powerline.conf" ]; then
        ln -sf "$DOTFILES_DIR/tmux/.tmux.powerline.conf" ~/.config/tmux/.tmux.powerline.conf
        echo "  ✓ tmux powerline 설정 링크됨"
    fi

    # iTerm2 설정 복원
    if [ -f "$DOTFILES_DIR/iterm/com.googlecode.iterm2.plist" ]; then
        cp "$DOTFILES_DIR/iterm/com.googlecode.iterm2.plist" ~/Library/Preferences/com.googlecode.iterm2.plist
        echo "  ✓ iTerm2 설정 복원됨"
        echo "    (iTerm2를 재시작하면 설정이 적용됩니다)"
    fi

    # ideavimrc 설정
    if [ -f "$DOTFILES_DIR/.ideavimrc" ]; then
        ln -sf "$DOTFILES_DIR/.ideavimrc" ~/.ideavimrc
        echo "  ✓ ideavimrc 설정 링크됨"
    fi
}

# 메인 실행
main() {
    install_homebrew
    install_apps
    install_cli_tools
    link_configs

    echo ""
    echo "=== 설치 완료 ==="
    echo ""
    echo "추가 작업:"
    echo "  1. iTerm2 재시작하여 설정 적용"
    echo "  2. tmux 실행 후 prefix + I 로 플러그인 설치"
    echo ""
}

main
