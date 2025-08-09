---
title: "架網站教學 Pt.6 自動化 I"
date: 2025-08-05T13:50:36+08:00 # 撰寫時間
publishDate: 2025-08-06T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: false
tags: ["🖥️科技", "📝創作", "⭐️重要"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

這篇教學將帶你了解如何利用 Git 來管理你的網站，並優化你的工作流程。我們將從版本控制開始，並導入自動更新的腳本，讓你更輕鬆地管理網站內容。

# 架網站第七步：自動化 I
## 搞定 GitHub

首先，你需要一個 GitHub 帳號。如果沒有，請前往 [GitHub.com](https://github.com/) 建立一個帳號。建立帳號後，你需要建立一個新的 Repository（專案）。

在建立 Repository 的過程中，請注意以下幾點：

*   **Repository 名稱：**  建議你使用你的域名，例如 `tux24.xyz`，將點號移除。
*   **Ｄescription 描述：**  可以為你的網站寫一個簡短的描述。
*   **Visibility 能見度：**  將 Visibility 設定為公開（Public）的話，你的網站就開源了，如果你不想要的話可以選擇私人（Private）。

## 搞定 Git

{{<notice tip>}}注意，以下內容如果你沒有先看過 git 教程再來的話會有點像咒語，出事我不負責{{</notice>}}

接著你需要把 Git 的設定搞定：

1. 安裝 Github-cli（我上一篇文章有叫你裝了）
2. 登入 Github 帳號：

	```bash
	gh auth login
	```
	
	接著你就照著它的指引登入你的 GitHub 帳號

3. 連結 Git 和 GitHub[^1]，輸入指令：

	```bash
	cd ~/yourwebsite # 確保你人在網站目錄下
	git remote add origin "你的專案 git 連結"
	```
	
	那個"連結"要如何獲得呢？請你打開你的專案頁面找到右上角的綠色 Code，下拉選單複製 https 連結，例如：
	
	```bash
	https://github.com/tux24xyz/tux24xyz.git
	```
	
4. 提交 & 推送程式碼：

	```bash
	git commit -m "測試測試"
	git push origin main
	# 第一次應該會報錯
	# 你要先照著它的說明留下你的名字和 E-mail，這麼做是為了要紀錄下專案的更動是誰做的
	```
	
[^1]: 我知道有比較專業的講法
## 太麻煩了

你知道剛才那樣還沒完嗎？你只是把本地寫好的東西同步到 GitHub 上了而已，你的主機還沒更新喔？

所以，我提供你一個我叫 Claude.ai 寫出來的腳本，它幫我省了超多時間：

```bash
#!/bin/bash

# 部落格快速更新腳本
# 使用方法: ./update-blog.sh "commit 訊息"

set -e  # 遇到錯誤立即停止

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置變數（請根據你的設定修改）
VPS_USER="xxxxxx"
VPS_HOST="xxxxxxx"
VPS_PATH="xxxxxxxx"
GITHUB_REPO="xxxxxxxxxxx"

# 函數：輸出彩色訊息
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

# 檢查參數
if [ $# -eq 0 ]; then
    COMMIT_MSG="Update blog: $(date '+%Y-%m-%d %H:%M:%S')"
else
    COMMIT_MSG="$1"
fi

log_info "開始部落格更新流程..."
log_info "Commit 訊息: $COMMIT_MSG"

# 確保本地沒有 public 目錄被提交
if [ -d "public" ]; then
    log_info "檢查本地 public 目錄..."
    echo "public/" >> .gitignore 2>/dev/null || true
    git rm -r --cached public/ 2>/dev/null || true
    log_info "已確保 public 目錄不會被提交到 Git"
fi

# 1. 檢查是否有未提交的變更
log_info "檢查 Git 狀態..."
if ! git diff --quiet || ! git diff --cached --quiet; then
    log_info "發現未提交的變更，準備提交..."
    
    # 顯示變更內容
    echo "=== 變更內容 ==="
    git status --short
    echo "=================="
    
    # 添加所有變更（排除 public）
    git add .
    
    # 提交變更
    git commit -m "$COMMIT_MSG"
    log_success "本地提交完成"
else
    log_warning "沒有發現新的變更"
fi

# 2. 推送到 GitHub
log_info "推送到 GitHub..."
if git push origin main; then
    log_success "推送到 GitHub 成功"
else
    log_error "推送到 GitHub 失敗"
    exit 1
fi

# 3. 部署到 VPS
log_info "部署到 VPS..."
ssh "$VPS_USER@$VPS_HOST" << 'EOF'
    set -e
    
    log_info() {
        echo -e "\033[0;34m[VPS-INFO]\033[0m $1"
    }
    
    log_success() {
        echo -e "\033[0;32m[VPS-SUCCESS]\033[0m $1"
    }
    
    log_error() {
        echo -e "\033[0;31m[VPS-ERROR]\033[0m $1"
    }
    
    log_warning() {
        echo -e "\033[1;33m[VPS-WARNING]\033[0m $1"
    }
    
    log_info "切換到網站目錄..."
    cd /tux24xyz
    
    # 檢查 public 是否被 Git 追蹤，如果是則移除追蹤
    if git ls-files --error-unmatch public/ >/dev/null 2>&1; then
        log_warning "發現 public 目錄被 Git 追蹤，正在移除..."
        git rm -r --cached public/ 2>/dev/null || true
        echo "public/" >> .gitignore
        git add .gitignore
        git commit -m "Remove public directory from Git tracking" || log_info "沒有變更需要提交"
    fi
    
    # 備份當前 public 目錄（如果存在且不為空）
    if [ -d "public" ] && [ "$(ls -A public 2>/dev/null)" ]; then
        BACKUP_NAME="public_backup_$(date +%Y%m%d_%H%M%S)"
        log_info "備份當前版本到 $BACKUP_NAME..."
        cp -r public "$BACKUP_NAME"
        log_success "備份完成"
    fi
    
    # 重置任何對 public 的本地修改
    git checkout -- . 2>/dev/null || true
    git clean -fd 2>/dev/null || true
    
    log_info "拉取最新代碼..."
    git pull origin main
    
    # 完全清理舊的 public 目錄
    log_info "清理舊的 public 目錄..."
    if [ -d "public" ]; then
        rm -rf public/*
        log_info "已清空 public 目錄內容"
    fi
    
    log_info "建置網站..."
    # 使用 --cleanDestinationDir 確保完全清理
    hugo --minify --gc --cleanDestinationDir
    
    # 檢查建置結果
    if [ -d "public" ] && [ "$(ls -A public)" ]; then
        log_success "網站建置成功"
        
        log_info "重載 Nginx..."
        if sudo systemctl reload nginx; then
            log_success "Nginx 重載成功"
        else
            log_warning "Nginx 重載可能失敗，但網站應該仍可正常運作"
        fi
        
        log_success "網站部署完成！"
        
        # 清理舊備份（保留最近3個，避免佔用太多空間）
        log_info "清理舊備份（保留最近3個）..."
        if ls public_backup_* 1> /dev/null 2>&1; then
            ls -t public_backup_* | tail -n +4 | xargs rm -rf 2>/dev/null || true
            BACKUP_COUNT=$(ls public_backup_* 2>/dev/null | wc -l)
            log_info "目前保留 $BACKUP_COUNT 個備份"
        else
            log_info "沒有找到舊備份"
        fi
    else
        log_error "建置失敗，public 目錄為空或不存在"
        
        # 如果建置失敗，嘗試恢復最新的備份
        LATEST_BACKUP=$(ls -t public_backup_* 2>/dev/null | head -n 1)
        if [ -n "$LATEST_BACKUP" ]; then
            log_warning "嘗試恢復最新備份: $LATEST_BACKUP"
            rm -rf public
            cp -r "$LATEST_BACKUP" public
            log_info "已恢復備份，網站應該可以正常運作"
        fi
        exit 1
    fi
EOF

if [ $? -eq 0 ]; then
    log_success "部落格更新完成！"
    log_info "網站連結: https://tux24.xyz" # 改成你自己的
    log_info "如果網站有快取，可能需要等待幾分鐘或清除瀏覽器快取"
else
    log_error "VPS 部署失敗"
    exit 1
fi
```

這個腳本是這樣工作的：

1. 執行我們剛才的操作，提交變更到 Git 儲存庫和 GitHub 上
2. 自動用 ssh 登入你的主機，更新你的網站

每次寫完文章運行一次腳本就行了，省事。

這個腳本預設的 commit message 就是當下的時間，你也可以自訂 commit message，詳情請見腳本開頭的內容。

### 怎麼用呢？

你只需要複製這一大串文字，貼到文字編輯器裡（記得 micro 嗎？），存成 `.sh` 檔，然後在終端機內輸入 `./update-blog.sh` 按 Enter 運行腳本就行了。

Windows 預設是沒有 Bash 的，你要自己想辦法（或許你可以考慮[切換到 Linux](https://wiwi.blog/blog/your-computer-is-not-yours)）。[^2]

[^2]: 你可以找 LLM 幫你

啊，忘記叫你修改開頭我打 "xxx" 的部份了。

等我一下，先別運行這腳本。

## 搞定 ssh

這部分的教學非常實用，因為完成了後你將再也不需要使用密碼登入你的主機，詳情請見[原文](https://landchad.net/sshkeys/)。很誘人吧？咱們趕快開始：

1. 輸入指令：

	```bash
	ssh-keygen
	# 選每個預設選項，password 留空
	```

	這個指令會在你的 `~/.ssh/` 生成一個「鑰匙」，有了鑰匙，每次登入主機就不用輸密碼了。
	
	你最好把整個 `~/.ssh` 目錄都妥善的備份起來，你可以在另一臺電腦繼續用。

2. 輸入指令：

	```bash
	ssh-copy-id root@你的域名
	```
	
	它接著會問你的主機 root 密碼，你就輸入。
	
3. 測試：

	```bash
	ssh root@你的域名
	```
	
	接者輸入這個指令測試有沒有成功，如果成功了它就不會再問你密碼，如果失敗：
	
4. 除錯：

	```bash
	chmod 700 ~/.ssh/
	chmod 644 ~/.ssh/id_rsa.pub
	chmod 600 ~/.ssh/id_rsa
	chmod 644 ~/.ssh/authorized_keys
	```
	
	在你本地端的電腦輸入以下指令。
	
## 搞定腳本

好了，來修改你的腳本吧：

```bash
# 配置變數（請根據你的設定修改）
VPS_USER="xxxxxx" # 應該換成 root
VPS_HOST="xxxxxxx" # 換成你的域名
VPS_PATH="xxxxxxxx" # 你的網站根目錄，根據我之前的教學是 /var/www/yoursite，記得替換 yoursite 成 ...
GITHUB_REPO="xxxxxxxxxxx" # 格式是這樣的："你的 GitHub 用戶名/你的專案名"
# 所有的值都要放在 "" 裡面喔
```

這樣應該就可以了，不過為了避免出錯，我們還要再做一步：

## 保險起見

輸入指令：

```bash
ssh root@yourdomain
cd  /var/www
rm -rf yoursite
git clone "專案連結"
```

解釋一下，我把你原本放在 `/var/www` 的 `yoursite` 資料夾給整個刪了，跟你第一次寫的測試用內容說拜拜～

然後我重新從你的 git 儲存庫抓了你的網站下來，現在那個資料夾裡面應該有完整的網站架構了。

如果你當初設定 GitHub 儲存庫為私人的話，你可能要在主機裝好 GitHub-cli 登入之後才能 `git clone`。

## 運行腳本，完成！

這篇教學的內容量比較大，而且我也不太記得我當初是怎麼設定的了，所以如果有問題請 [`/contact`](https://tux24.xyz/contact) 我，我會上來修改文章的。

# 明天的明天的明天見！