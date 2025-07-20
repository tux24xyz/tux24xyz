#!/bin/bash

# 網站同步與部署腳本
# 運行位置：網站根目錄
# 功能：從 GitHub 獲取最新內容並部署網站

set -e  # 遇到錯誤立即停止

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# 配置變數（請根據你的設定修改）
GITHUB_REPO_URL="https://github.com/tux24xyz/tux24xyz.git"  # 你的 GitHub 倉庫 URL
BRANCH_NAME="main"  # 要同步的分支
BACKUP_DIR="backups"  # 備份目錄

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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# 函數：檢查命令是否存在
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 未安裝，請先安裝後再運行此腳本"
        exit 1
    fi
}

# 函數：創建備份
create_backup() {
    if [ -d "public" ]; then
        local backup_name="${BACKUP_DIR}/backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        cp -r public "$backup_name"
        log_info "已創建備份: $backup_name"
        
        # 清理舊備份（保留最近10個）
        ls -t ${BACKUP_DIR}/backup_* 2>/dev/null | tail -n +11 | xargs rm -rf 2>/dev/null || true
        log_info "已清理舊備份，保留最近10個"
    fi
}

# 函數：檢查 Git 狀態
check_git_status() {
    if [ ! -d ".git" ]; then
        log_error "當前目錄不是 Git 倉庫"
        log_info "如果這是第一次運行，請執行："
        log_info "git clone $GITHUB_REPO_URL ."
        exit 1
    fi
}

# 函數：處理本地變更
handle_local_changes() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        log_warning "發現本地未提交的變更："
        git status --short
        
        echo
        read -p "是否要儲存這些變更？ (y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "儲存本地變更..."
            git stash push -m "Auto stash before sync $(date '+%Y-%m-%d %H:%M:%S')"
            log_success "變更已儲存到 stash"
            return 0
        else
            log_warning "將丟棄本地變更..."
            git reset --hard HEAD
            git clean -fd
            log_success "本地變更已丟棄"
            return 0
        fi
    fi
    return 0
}

# 函數：同步遠端變更
sync_from_remote() {
    log_info "正在從遠端拉取最新變更..."
    
    # 獲取遠端更新
    git fetch origin "$BRANCH_NAME"
    
    # 檢查是否有新的提交
    local local_commit=$(git rev-parse HEAD)
    local remote_commit=$(git rev-parse origin/$BRANCH_NAME)
    
    if [ "$local_commit" = "$remote_commit" ]; then
        log_info "本地已是最新版本，無需更新"
        return 1
    else
        log_info "發現新的遠端提交，準備更新..."
        
        # 重設到遠端版本
        git reset --hard origin/$BRANCH_NAME
        
        # 更新子模組（如果有的話）
        if [ -f ".gitmodules" ]; then
            log_info "更新 Git 子模組..."
            git submodule update --init --recursive
        fi
        
        log_success "同步完成"
        return 0
    fi
}

# 函數：建置網站
build_website() {
    log_info "開始建置網站..."
    
    # 檢查是否有 Hugo 配置檔案
    if [ ! -f "hugo.toml" ] && [ ! -f "config.toml" ] && [ ! -f "config.yaml" ]; then
        log_error "未找到 Hugo 配置檔案"
        exit 1
    fi
    
    # 建置網站
    hugo --minify --gc
    
    if [ -d "public" ] && [ "$(ls -A public)" ]; then
        log_success "網站建置完成"
        
        # 顯示建置資訊
        local file_count=$(find public -type f | wc -l)
        local dir_size=$(du -sh public | cut -f1)
        log_info "生成檔案數: $file_count"
        log_info "網站大小: $dir_size"
    else
        log_error "網站建置失敗或 public 目錄為空"
        exit 1
    fi
}

# 函數：重載服務
reload_services() {
    # 檢查是否為 root 或有 sudo 權限
    if [ "$EUID" -eq 0 ] || sudo -n true 2>/dev/null; then
        log_info "重載 Nginx..."
        if sudo systemctl reload nginx 2>/dev/null; then
            log_success "Nginx 重載成功"
        else
            log_warning "Nginx 重載失敗，可能需要手動重載"
        fi
    else
        log_warning "無 sudo 權限，跳過服務重載"
        log_info "請手動執行: sudo systemctl reload nginx"
    fi
}

# 函數：顯示狀態資訊
show_status() {
    echo
    echo "=== 部署狀態 ==="
    log_info "當前 Git 提交: $(git rev-parse --short HEAD)"
    log_info "最後提交時間: $(git log -1 --format='%cd' --date=format:'%Y-%m-%d %H:%M:%S')"
    log_info "最後提交訊息: $(git log -1 --format='%s')"
    
    if [ -d "public" ]; then
        local file_count=$(find public -type f | wc -l)
        local dir_size=$(du -sh public | cut -f1)
        log_info "網站檔案數: $file_count"
        log_info "網站大小: $dir_size"
    fi
    echo "==================="
}

# 主程式開始
echo "🚀 網站同步與部署腳本"
echo "=============================="

# 檢查必要命令
log_step "1. 檢查環境依賴"
check_command "git"
check_command "hugo"
log_success "環境檢查通過"

# 檢查 Git 狀態
log_step "2. 檢查 Git 倉庫"
check_git_status
log_success "Git 倉庫檢查通過"

# 創建備份
log_step "3. 創建備份"
create_backup

# 處理本地變更
log_step "4. 處理本地變更"
handle_local_changes

# 同步遠端變更
log_step "5. 同步遠端變更"
if sync_from_remote; then
    HAS_UPDATES=true
    log_success "發現並同步了新的變更"
else
    HAS_UPDATES=false
    log_info "沒有新的遠端變更"
fi

# 詢問是否強制重新建置
if [ "$HAS_UPDATES" = false ]; then
    echo
    read -p "沒有新變更，是否仍要重新建置網站？ (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "跳過建置，腳本結束"
        exit 0
    fi
fi

# 建置網站
log_step "6. 建置網站"
build_website

# 重載服務
log_step "7. 重載服務"
reload_services

# 顯示最終狀態
log_step "8. 完成"
show_status

log_success "網站同步與部署完成！"

# 如果有域名，提示檢查
if grep -q "baseURL.*https://" hugo.toml 2>/dev/null || grep -q "baseURL.*https://" config.toml 2>/dev/null; then
    DOMAIN=$(grep "baseURL" *.toml 2>/dev/null | head -1 | sed "s/.*['\"]https\?:\/\/\([^'\"]*\)['\"].*/\1/")
    if [ -n "$DOMAIN" ]; then
        echo
        log_info "可以訪問你的網站："
        echo -e "${GREEN}https://$DOMAIN${NC}"
    fi
fi
