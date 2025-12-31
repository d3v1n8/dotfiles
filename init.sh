#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 사용법 출력
show_usage() {
    echo "사용법: ./init.sh [명령어]"
    echo ""
    echo "명령어:"
    echo "  all          전체 설치 (기본값)"
    echo "  brew         Homebrew 설치"
    echo "  apps         GUI 앱 설치 (iterm, chrome, ...)"
    echo "  cli          CLI 도구 설치 (tmux, bat, fzf, ...)"
    echo "  link         전체 설정 파일 링크"
    echo "  link:iterm   iTerm2 설정 리셋"
    echo "  link:zshrc   zshrc 설정 리셋"
    echo "  link:ideavim ideaVim 설정 리셋"
    echo "  link:tmux    tmux 설정 리셋"
    echo "  link:claude  Claude 설정 리셋"
    echo "  help         도움말 출력"
    echo ""
}

# Xcode Command Line Tools 설치 확인
check_xcode_clt() {
    if ! xcode-select -p &> /dev/null; then
        echo "[xcode] Xcode Command Line Tools 설치 중..."
        xcode-select --install
        echo ""
        echo "⚠️  Xcode Command Line Tools 설치 팝업이 표시됩니다."
        echo "    설치 완료 후 이 스크립트를 다시 실행해주세요."
        exit 1
    else
        echo "[xcode] Xcode Command Line Tools 이미 설치됨"
    fi
}

# Homebrew 설치 확인 및 설치
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "[brew] Homebrew 설치 중..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "[brew] Homebrew 이미 설치됨"
    fi

    # Apple Silicon Mac인 경우 PATH 설정
    if [[ $(uname -m) == "arm64" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
        if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
    fi
}

# 앱이 이미 설치되어 있는지 확인
is_app_installed() {
    local cask_name="$1"

    # brew로 설치된 경우
    if brew list --cask "$cask_name" &> /dev/null; then
        return 0
    fi

    # /Applications에 직접 설치된 경우 확인
    case "$cask_name" in
        "iterm2") [ -d "/Applications/iTerm.app" ] && return 0 ;;
        "google-chrome") [ -d "/Applications/Google Chrome.app" ] && return 0 ;;
        "discord") [ -d "/Applications/Discord.app" ] && return 0 ;;
        "slack") [ -d "/Applications/Slack.app" ] && return 0 ;;
        "zoom") [ -d "/Applications/zoom.us.app" ] && return 0 ;;
        "figma") [ -d "/Applications/Figma.app" ] && return 0 ;;
        "claude") [ -d "/Applications/Claude.app" ] && return 0 ;;
        "topnotch") [ -d "/Applications/TopNotch.app" ] && return 0 ;;
    esac

    return 1
}

# Brew Cask 앱 설치
install_apps() {
    echo "[apps] 앱 설치 중..."

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
        "font-meslo-lg-nerd-font"
    )

    for app in "${CASK_APPS[@]}"; do
        if is_app_installed "$app"; then
            echo "  ✓ $app 이미 설치됨"
        else
            echo "  → $app 설치 중..."
            brew install --cask "$app" || echo "  ⚠ $app 설치 실패"
        fi
    done
}

# CLI 도구 설치 (tmux, powerlevel10k 포함)
install_cli_tools() {
    echo "[cli] CLI 도구 설치 중..."

    CLI_TOOLS=(
        "tmux"
        "powerlevel10k"
        "bat"
        "zsh-autosuggestions"
        "fzf"
        "zoxide"
        "eza"
        "lazygit"
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

# 설정 파일 링크 - 개별 함수들
PREFS_DIR="$DOTFILES_DIR/preferences"

link_iterm() {
    echo "[link] iTerm2 설정 리셋 중..."
    if [ -f "$PREFS_DIR/iterm/com.googlecode.iterm2.plist" ]; then
        cp "$PREFS_DIR/iterm/com.googlecode.iterm2.plist" ~/Library/Preferences/com.googlecode.iterm2.plist
        echo "  ✓ iTerm2 설정 복원됨"
        echo "    (iTerm2를 재시작하면 설정이 적용됩니다)"
    else
        echo "  ⚠ iTerm2 설정 파일을 찾을 수 없습니다"
    fi
}

link_zshrc() {
    echo "[link] zshrc 설정 리셋 중..."
    if [ -f "$PREFS_DIR/zsh/.zshrc" ]; then
        ln -sf "$PREFS_DIR/zsh/.zshrc" ~/.zshrc
        echo "  ✓ zshrc 설정 링크됨"
    else
        echo "  ⚠ zshrc 설정 파일을 찾을 수 없습니다"
    fi

    if [ -f "$PREFS_DIR/zsh/.p10k.zsh" ]; then
        ln -sf "$PREFS_DIR/zsh/.p10k.zsh" ~/.p10k.zsh
        echo "  ✓ p10k 설정 링크됨"
    fi
}

link_ideavim() {
    echo "[link] ideaVim 설정 리셋 중..."
    if [ -f "$PREFS_DIR/.ideavimrc" ]; then
        ln -sf "$PREFS_DIR/.ideavimrc" ~/.ideavimrc
        echo "  ✓ ideavimrc 설정 링크됨"
    else
        echo "  ⚠ ideavimrc 설정 파일을 찾을 수 없습니다"
    fi
}

link_tmux() {
    echo "[link] tmux 설정 리셋 중..."
    if [ -f "$PREFS_DIR/tmux/.tmux.conf" ]; then
        ln -sf "$PREFS_DIR/tmux/.tmux.conf" ~/.tmux.conf
        echo "  ✓ tmux 설정 링크됨"
    else
        echo "  ⚠ tmux 설정 파일을 찾을 수 없습니다"
    fi

    mkdir -p ~/.config/tmux
    if [ -f "$PREFS_DIR/tmux/.tmux.powerline.conf" ]; then
        ln -sf "$PREFS_DIR/tmux/.tmux.powerline.conf" ~/.config/tmux/.tmux.powerline.conf
        echo "  ✓ tmux powerline 설정 링크됨"
    fi
}

link_claude() {
    echo "[link] Claude 설정 리셋 중..."
    mkdir -p ~/.claude
    if [ -f "$PREFS_DIR/claude/CLAUDE.md" ]; then
        ln -sf "$PREFS_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
        echo "  ✓ Claude 설정 링크됨"
    else
        echo "  ⚠ Claude 설정 파일을 찾을 수 없습니다"
    fi
    if [ -f "$PREFS_DIR/claude/settings.local.json" ]; then
        ln -sf "$PREFS_DIR/claude/settings.local.json" ~/.claude/settings.local.json
        echo "  ✓ Claude settings 링크됨"
    fi
}

# 전체 설정 파일 링크
link_configs() {
    echo "[link] 전체 설정 파일 링크 중..."
    link_tmux
    link_iterm
    link_ideavim
    link_zshrc
    link_claude
}

# 설정 파일 링크 서브메뉴
show_link_menu() {
    echo ""
    echo "설정 파일 리셋 메뉴:"
    echo ""
    echo "  1) iTerm2 설정 리셋"
    echo "  2) zshrc 설정 리셋"
    echo "  3) ideaVim 설정 리셋"
    echo "  4) tmux 설정 리셋"
    echo "  5) Claude 설정 리셋"
    echo "  6) 전체 설정 링크"
    echo "  b) 뒤로 가기"
    echo ""
    read -p "선택: " link_choice

    case "$link_choice" in
        1) link_iterm ;;
        2) link_zshrc ;;
        3) link_ideavim ;;
        4) link_tmux ;;
        5) link_claude ;;
        6) link_configs ;;
        b|B) return ;;
        *) echo "잘못된 선택입니다." ;;
    esac
}

# 완료 메시지
show_complete() {
    echo ""
    echo "=== 설치 완료 ==="
    echo ""
    echo "추가 작업:"
    echo "  1. 터미널 재시작하여 zsh/p10k 설정 적용"
    echo "  2. iTerm2 재시작하여 설정 적용"
    echo "  3. tmux 실행 후 prefix + I 로 플러그인 설치"
    echo ""
}

# 전체 설치
run_all() {
    echo "=== Mac 초기 설정 스크립트 ==="
    echo ""
    check_xcode_clt
    install_homebrew
    install_apps
    install_cli_tools
    link_configs
    show_complete
}

# 인터랙티브 메뉴
show_menu() {
    echo "=== Mac 초기 설정 스크립트 ==="
    echo ""
    echo "실행할 작업을 선택하세요:"
    echo ""
    echo "  1) 전체 설치"
    echo "  2) Homebrew 설치"
    echo "  3) GUI 앱 설치"
    echo "  4) CLI 도구 설치"
    echo "  5) 설정 파일 링크"
    echo "  q) 종료"
    echo ""
    read -p "선택: " choice

    case "$choice" in
        1) run_all ;;
        2) check_xcode_clt && install_homebrew ;;
        3) install_apps ;;
        4) install_cli_tools ;;
        5) show_link_menu ;;
        q|Q) echo "종료합니다." && exit 0 ;;
        *) echo "잘못된 선택입니다." && exit 1 ;;
    esac
}

# 메인 실행
if [ $# -eq 0 ]; then
    show_menu
else
    case "$1" in
        all)
            run_all
            ;;
        brew)
            check_xcode_clt
            install_homebrew
            ;;
        apps)
            install_apps
            ;;
        cli)
            install_cli_tools
            ;;
        link)
            link_configs
            ;;
        link:iterm)
            link_iterm
            ;;
        link:zshrc)
            link_zshrc
            ;;
        link:ideavim)
            link_ideavim
            ;;
        link:tmux)
            link_tmux
            ;;
        link:claude)
            link_claude
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            echo "알 수 없는 명령어: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
fi
