#!/bin/bash

# 快速同步腳本 - 簡化版
# 適合日常快速更新使用

# 顏色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

echo "🔄 快速同步網站..."

# 1. 拉取最新變更
log "拉取遠端變更..."
if git pull origin main; then
    success "代碼同步完成"
else
    error "代碼同步失敗"
    exit 1
fi

# 2. 更新子模組（如果有）
if [ -f ".gitmodules" ]; then
    log "更新子模組..."
    git submodule update --init --recursive
    success "子模組更新完成"
fi

# 3. 建置網站
log "建置網站..."
if hugo --minify --gc; then
    success "網站建置完成"
else
    error "網站建置失敗"
    exit 1
fi

# 4. 重載服務（如果可能）
if sudo -n systemctl reload nginx 2>/dev/null; then
    success "Nginx 重載完成"
else
    warning "請手動重載 Nginx: sudo systemctl reload nginx"
fi

success "同步完成！"