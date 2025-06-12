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
VPS_USER="root"
VPS_HOST="tux24.xyz"
VPS_PATH="/tux24xyz"
GITHUB_REPO="tux24xyz/tux24xyz"

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

# 1. 檢查是否有未提交的變更
log_info "檢查 Git 狀態..."
if ! git diff --quiet || ! git diff --cached --quiet; then
    log_info "發現未提交的變更，準備提交..."
    
    # 顯示變更內容
    echo "=== 變更內容 ==="
    git status --short
    echo "=================="
    
    # 添加所有變更
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
ssh "$VPS_USER@$VPS_HOST" << EOF
    set -e
    
    log_info() {
        echo -e "\033[0;34m[VPS-INFO]\033[0m \$1"
    }
    
    log_success() {
        echo -e "\033[0;32m[VPS-SUCCESS]\033[0m \$1"
    }
    
    log_error() {
        echo -e "\033[0;31m[VPS-ERROR]\033[0m \$1"
    }
    
    log_info "切換到網站目錄..."
    cd $VPS_PATH
    
    log_info "備份當前版本..."
    if [ -d "public" ]; then
        cp -r public public_backup_\$(date +%Y%m%d_%H%M%S)
        log_info "備份完成"
    fi
    
    log_info "拉取最新代碼..."
    git pull origin main
    
    log_info "建置網站..."
    hugo --minify --gc
    
    if [ -d "public" ] && [ "\$(ls -A public)" ]; then
        log_info "重載 Nginx..."
        sudo systemctl reload nginx
        log_success "網站部署完成！"
        
        log_info "清理舊備份（保留最近5個）..."
        ls -t public_backup_* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true
        log_info "清理完成"
    else
        log_error "建置失敗，public 目錄為空"
        exit 1
    fi
EOF

if [ $? -eq 0 ]; then
    log_success "部落格更新完成！"
    log_info "網站連結: https://tux24.xyz"
else
    log_error "VPS 部署失敗"
    exit 1
fi
