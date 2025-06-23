# Git 共同作業セットアップガイド

## 🚀 初期セットアップ

### 1. Git のインストール

#### Windows
```bash
# Chocolatey を使用
choco install git

# または公式サイトからダウンロード
# https://git-scm.com/download/win
```

#### macOS
```bash
# Homebrew を使用
brew install git

# または Xcode Command Line Tools
xcode-select --install
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git

# CentOS/RHEL
sudo yum install git
```

### 2. Git の初期設定

```bash
# ユーザー名とメールアドレスを設定
git config --global user.name "あなたの名前"
git config --global user.email "your.email@example.com"

# デフォルトブランチ名を設定
git config --global init.defaultBranch main

# 日本語ファイル名の表示設定
git config --global core.quotepath false
git config --global gui.encoding utf-8
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8
```

### 3. SSH キーの設定（GitHub を使用する場合）

```bash
# SSH キーを生成
ssh-keygen -t ed25519 -C "your.email@example.com"

# SSH エージェントを起動
eval "$(ssh-agent -s)"

# SSH キーを追加
ssh-add ~/.ssh/id_ed25519

# 公開キーを表示（GitHub に登録する）
cat ~/.ssh/id_ed25519.pub
```

## 📦 リポジトリの初期化

### 1. ローカルリポジトリの初期化

```bash
# プロジェクトディレクトリに移動
cd 就活管理アプリ

# Git リポジトリを初期化
git init

# 最初のコミット
git add .
git commit -m "Initial commit: 就活管理アプリの初期版"

# ブランチ名を main に変更
git branch -M main
```

### 2. リモートリポジトリの設定

#### GitHub を使用する場合
```bash
# GitHub でリポジトリを作成後
git remote add origin https://github.com/your-username/就活管理アプリ.git

# または SSH を使用
git remote add origin git@github.com:your-username/就活管理アプリ.git

# リモートリポジトリにプッシュ
git push -u origin main
```

#### GitLab を使用する場合
```bash
git remote add origin https://gitlab.com/your-username/就活管理アプリ.git
git push -u origin main
```

## 🔄 共同作業のワークフロー

### 1. 開発ブランチの作成

```bash
# 最新の変更を取得
git pull origin main

# 開発用ブランチを作成
git checkout -b develop
git push -u origin develop

# 機能ブランチを作成
git checkout -b feature/企業管理機能
```

### 2. 日常的な作業フロー

```bash
# 作業開始前
git pull origin develop

# 作業中
git add .
git commit -m "feat: 企業管理画面の検索機能を追加"

# 作業完了後
git push origin feature/企業管理機能
```

### 3. プルリクエストの作成

1. GitHub/GitLab の Web インターフェースでプルリクエストを作成
2. `feature/企業管理機能` → `develop` へのマージリクエスト
3. レビュー後にマージ

## 🛠️ 便利な Git コマンド

### 基本的なコマンド
```bash
# 状態確認
git status

# 変更履歴確認
git log --oneline

# ブランチ一覧
git branch -a

# 変更を破棄
git checkout -- <ファイル名>

# コミットを修正
git commit --amend
```

### 高度なコマンド
```bash
# 変更を一時保存
git stash
git stash pop

# ブランチをマージ
git merge <ブランチ名>

# コンフリクト解決
git status  # コンフリクトファイルを確認
# ファイルを編集してコンフリクトを解決
git add .
git commit
```

## 📋 チーム開発のベストプラクティス

### 1. ブランチ戦略
- **main**: 本番環境用（安定版のみ）
- **develop**: 開発統合用
- **feature/***: 機能開発用
- **hotfix/***: 緊急修正用

### 2. コミットメッセージのルール
```
feat: 新機能
fix: バグ修正
docs: ドキュメント
style: フォーマット
refactor: リファクタリング
test: テスト
chore: その他
```

### 3. プルリクエストのルール
- 小さな変更に分ける
- 明確なタイトルと説明
- レビューを必ず実施
- テストを追加

## 🔧 トラブルシューティング

### よくある問題と解決方法

#### 1. コンフリクトの解決
```bash
# コンフリクトが発生した場合
git status  # コンフリクトファイルを確認
# ファイルを編集してコンフリクトを解決
git add .
git commit
```

#### 2. 間違ったブランチで作業した場合
```bash
# 変更を一時保存
git stash

# 正しいブランチに移動
git checkout correct-branch

# 変更を復元
git stash pop
```

#### 3. コミットを取り消したい場合
```bash
# 直前のコミットを取り消し
git reset --soft HEAD~1

# 変更を破棄
git reset --hard HEAD~1
```

## 📚 参考資料

- [Git 公式ドキュメント](https://git-scm.com/doc)
- [GitHub ガイド](https://guides.github.com/)
- [GitLab ドキュメント](https://docs.gitlab.com/)

## 🆘 サポート

問題が発生した場合は、以下を確認してください：

1. Git のバージョン確認: `git --version`
2. 設定確認: `git config --list`
3. リモートリポジトリ確認: `git remote -v`

---

このガイドに従って、効率的な共同作業を実現しましょう！🎉 