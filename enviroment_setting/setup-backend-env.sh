#!/bin/bash

# Mac用開発環境セットアップスクリプト

set -e  # エラーが発生したら停止

echo "🔍 Homebrew の存在確認..."
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew が見つかりません。インストールします..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "🔧 PATH 設定中..."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew は既にインストールされています。"
fi

echo "🔄 Homebrew 更新中..."
brew update

echo "🐳 Docker をインストール中..."
if ! command -v docker &> /dev/null; then
    brew install --cask docker
else
    echo "✅ Docker は既にインストールされています。"
fi

echo "🧬 Git をインストール中..."
if ! command -v git &> /dev/null; then
    brew install git
else
    echo "✅ Git は既にインストールされています。"
fi

echo "🐹 Golang をインストール中..."
if ! command -v go &> /dev/null; then
    brew install go
else
    echo "✅ Golang は既にインストールされています。"
fi

echo "🐍 Python をインストール中..."
if ! command -v python &> /dev/null; then
    brew install python
else
    echo "✅ Python は既にインストールされています。"
fi

echo "✅ すべてのツールがインストールされました。"

echo "📌 補足：Docker.app を一度手動で起動して、初回設定を完了してください。"
