#
!/bin/bash

# Next.js環境セットアップスクリプト
# Node.js、pnpm、Next.jsの環境を整えます

set -e  # エラーが発生した場合にスクリプトを終了

echo "🚀 Next.js開発環境のセットアップを開始します..."

# カラー出力用の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Homebrewがインストールされているかチェック
check_homebrew() {
    log_info "Homebrewの確認中..."
    if ! command -v brew &> /dev/null; then
        log_warning "Homebrewがインストールされていません。インストールします..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Homebrewのパスを追加
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
        
        log_success "Homebrewのインストールが完了しました"
    else
        log_success "Homebrewは既にインストールされています"
    fi
}

# Node.jsのインストール
install_nodejs() {
    log_info "Node.jsの確認中..."
    if ! command -v node &> /dev/null; then
        log_warning "Node.jsがインストールされていません。インストールします..."
        brew install node
        log_success "Node.jsのインストールが完了しました"
    else
        log_success "Node.jsは既にインストールされています ($(node --version))"
    fi
}

# pnpmのインストール
install_pnpm() {
    log_info "pnpmの確認中..."
    if ! command -v pnpm &> /dev/null; then
        log_warning "pnpmがインストールされていません。インストールします..."
        
        # pnpmの公式インストール方法を使用
        curl -fsSL https://get.pnpm.io/install.sh | sh -
        
        # pnpmのパスを追加
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.zshrc
        echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.zshrc
        
        log_success "pnpmのインストールが完了しました"
    else
        log_success "pnpmは既にインストールされています ($(pnpm --version))"
    fi
}

# Next.jsプロジェクトの作成（オプション）
create_nextjs_project() {
    read -p "Next.jsプロジェクトを作成しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "プロジェクト名を入力してください: " project_name
        if [ -n "$project_name" ]; then
            log_info "Next.jsプロジェクト '$project_name' を作成中..."
            pnpm create next-app@latest "$project_name" --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
            log_success "Next.jsプロジェクト '$project_name' が作成されました"
            
            echo
            log_info "プロジェクトを開始するには:"
            echo "  cd $project_name"
            echo "  pnpm dev"
        fi
    fi
}

# バージョン情報の表示
show_versions() {
    echo
    log_info "インストールされたバージョン情報:"
    echo "Node.js: $(node --version)"
    echo "npm: $(npm --version)"
    echo "pnpm: $(pnpm --version)"
}

# メイン実行部分
main() {
    echo "========================================"
    echo "  Next.js開発環境セットアップスクリプト"
    echo "========================================"
    echo
    
    check_homebrew
    install_nodejs
    install_pnpm
    
    # シェルの再読み込み
    source ~/.zshrc 2>/dev/null || true
    
    show_versions
    create_nextjs_project
    
    echo
    log_success "🎉 Next.js開発環境のセットアップが完了しました！"
    echo
    log_info "新しいターミナルを開くか、以下のコマンドを実行してください:"
    echo "  source ~/.zshrc"
}

# スクリプト実行
main "$@"
