# dotfiles

macOS 초기 설정 자동화 스크립트

## 포함된 설정

### GUI 앱 (brew cask)
- iTerm2, Google Chrome, Discord, Slack, Zoom, Figma, Claude, TopNotch

### CLI 도구 (brew)
- tmux, powerlevel10k, bat, zsh-autosuggestions, fzf, btop

### 설정 파일
- `preferences/zsh/` - zsh, powerlevel10k 설정
- `preferences/tmux/` - tmux 설정
- `preferences/iterm/` - iTerm2 설정
- `preferences/.ideavimrc` - IdeaVim 설정

## 사용법

### 전체 설치 (새 맥북)
```bash
git clone https://github.com/d3v1n8/dotfiles.git
cd dotfiles
./init.sh
```

### 부분 실행
```bash
./init.sh all      # 전체 설치 (기본값)
./init.sh brew     # Homebrew만 설치
./init.sh apps     # GUI 앱만 설치
./init.sh cli      # CLI 도구만 설치
./init.sh link     # 설정 파일 링크만
./init.sh help     # 도움말
```

### 설치 후 추가 작업
1. 터미널 재시작하여 zsh/p10k 설정 적용
2. iTerm2 재시작하여 설정 적용
3. tmux 실행 후 `prefix + I`로 플러그인 설치
