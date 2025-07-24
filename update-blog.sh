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
    log_info "網站連結: https://tux24.xyz"
    log_info "如果網站有快取，可能需要等待幾分鐘或清除瀏覽器快取"
else
    log_error "VPS 部署失敗"
    exit 1
fi