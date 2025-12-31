#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Mac 초기 설정 스크립트 ==="
echo ""

# Xcode Command Line Tools 설치 확인
check_xcode_clt() {
    if ! xcode-select -p &> /dev/null; then
        echo "[0/4] Xcode Command Line Tools 설치 중..."
        xcode-select --install
        echo ""
        echo "⚠️  Xcode Command Line Tools 설치 팝업이 표시됩니다."
        echo "    설치 완료 후 이 스크립트를 다시 실행해주세요."
        exit 1
    else
        echo "[0/4] Xcode Command Line Tools 이미 설치됨"
    fi
}

# Homebrew 설치 확인 및 설치
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "[1/4] Homebrew 설치 중..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "[1/4] Homebrew 이미 설치됨"
    fi

    # Apple Silicon Mac인 경우 PATH 설정
    if [[ $(uname -m) == "arm64" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
        if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
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

# CLI 도구 설치 (tmux, powerlevel10k 포함)
install_cli_tools() {
    echo "[3/4] CLI 도구 설치 중..."

    CLI_TOOLS=(
        "tmux"
        "powerlevel10k"
    )

    for tool in "${CLI_TOOLS[@]}"; do
        if brew list "$tool" &> /dev/null; then
            echo "  ✓ $tool 이미 설치됨"
        else
            echo "  → $tool 설치 중..."
            brew install "$tool" || echo "  ⚠ $tool 설치 실패"
        fi
    done

    # Oh My Zsh 설치
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "  → Oh My Zsh 설치 중..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "  ✓ Oh My Zsh 이미 설치됨"
    fi

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

    PREFS_DIR="$DOTFILES_DIR/preferences"

    # tmux 설정
    if [ -f "$PREFS_DIR/tmux/.tmux.conf" ]; then
        ln -sf "$PREFS_DIR/tmux/.tmux.conf" ~/.tmux.conf
        echo "  ✓ tmux 설정 링크됨"
    fi

    # tmux powerline 설정
    mkdir -p ~/.config/tmux
    if [ -f "$PREFS_DIR/tmux/.tmux.powerline.conf" ]; then
        ln -sf "$PREFS_DIR/tmux/.tmux.powerline.conf" ~/.config/tmux/.tmux.powerline.conf
        echo "  ✓ tmux powerline 설정 링크됨"
    fi

    # iTerm2 설정 복원
    if [ -f "$PREFS_DIR/iterm/com.googlecode.iterm2.plist" ]; then
        cp "$PREFS_DIR/iterm/com.googlecode.iterm2.plist" ~/Library/Preferences/com.googlecode.iterm2.plist
        echo "  ✓ iTerm2 설정 복원됨"
        echo "    (iTerm2를 재시작하면 설정이 적용됩니다)"
    fi

    # ideavimrc 설정
    if [ -f "$PREFS_DIR/.ideavimrc" ]; then
        ln -sf "$PREFS_DIR/.ideavimrc" ~/.ideavimrc
        echo "  ✓ ideavimrc 설정 링크됨"
    fi

    # zsh 설정
    if [ -f "$PREFS_DIR/zsh/.zshrc" ]; then
        ln -sf "$PREFS_DIR/zsh/.zshrc" ~/.zshrc
        echo "  ✓ zshrc 설정 링크됨"
    fi

    # powerlevel10k 설정
    if [ -f "$PREFS_DIR/zsh/.p10k.zsh" ]; then
        ln -sf "$PREFS_DIR/zsh/.p10k.zsh" ~/.p10k.zsh
        echo "  ✓ p10k 설정 링크됨"
    fi
}

# 메인 실행
main() {
    check_xcode_clt
    install_homebrew
    install_apps
    install_cli_tools
    link_configs

    echo ""
    echo "=== 설치 완료 ==="
    echo ""
    echo "추가 작업:"
    echo "  1. 터미널 재시작하여 zsh/p10k 설정 적용"
    echo "  2. iTerm2 재시작하여 설정 적용"
    echo "  3. tmux 실행 후 prefix + I 로 플러그인 설치"
    echo ""
}

main
