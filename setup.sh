#!/bin/bash
set -euo pipefail
# ============================================================
# 新机一键设置脚本
# 用法: curl -fsSL <raw-url> | bash
# ============================================================
DOTFILES_REPO="https://github.com/ARE404/dotfiles.git"

echo "🚀 开始设置新机器..."

# 1. Homebrew
if ! command -v brew &>/dev/null; then
    echo "📦 安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    [[ $(uname -m) == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. chezmoi + dotfiles
if ! command -v chezmoi &>/dev/null; then
    echo "📦 安装 chezmoi..."
    brew install chezmoi
fi
chezmoi init --apply "$DOTFILES_REPO"

# 3. 第三方 tap（先于 bundle，避免顺序问题）
brew tap nikitabobko/tap 2>/dev/null || true

# 4. Brew 应用
if [[ -f "$HOME/Brewfile" ]]; then
    brew bundle install --file="$HOME/Brewfile"
else
    echo "⚠️  Brewfile 未找到，跳过。chezmoi apply 应该已恢复它"
fi

echo "✨ 完成!"
