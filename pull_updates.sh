#!/bin/bash

# GitHub 內容拉取腳本
# 使用方法: ./pull-updates.sh
# 功能: 從 GitHub 獲取最新的網站內容，適用於多電腦同步

set -e  # 遇到錯誤立即停止

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
    echo -e "${CYAN}[STEP]${NC} $1"
}

# 顯示開始訊息
echo "=================================="
log_info "GitHub 內容拉取腳本"
log_info "時間: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================="

# 1. 檢查是否在 Git 倉庫中
log_step "檢查 Git 倉庫狀態..."
if [ ! -d ".git" ]; then
    log_error "當前目錄不是 Git 倉庫！"
    log_info "請確保你在網站根目錄中執行此腳本"
    exit 1
fi

# 2. 檢查網路連接
log_step "檢查網路連接..."
if ! ping -c 1 github.com &> /dev/null; then
    log_error "無法連接到 GitHub，請檢查網路連接"
    exit 1
fi
log_success "網路連接正常"

# 3. 檢查當前分支
CURRENT_BRANCH=$(git branch --show-current)
log_info "當前分支: $CURRENT_BRANCH"

# 4. 檢查本地是否有未提交的變更
log_step "檢查本地變更狀態..."
if ! git diff --quiet || ! git diff --cached --quiet; then
    log_warning "發現未提交的本地變更！"
    echo ""
    echo "=== 未提交的變更 ==="
    git status --short
    echo "===================="
    echo ""
    
    # 詢問用戶如何處理
    echo "請選擇處理方式："
    echo "1) 暫存變更並繼續拉取 (git stash)"
    echo "2) 放棄本地變更並強制拉取"
    echo "3) 取消操作"
    read -p "請輸入選擇 (1-3): " choice
    
    case $choice in
        1)
            log_info "暫存本地變更..."
            git stash push -m "Auto-stash before pull: $(date '+%Y-%m-%d %H:%M:%S')"
            STASHED=true
            ;;
        2)
            log_warning "放棄本地變更..."
            git reset --hard HEAD
            git clean -fd
            ;;
        3)
            log_info "操作已取消"
            exit 0
            ;;
        *)
            log_error "無效的選擇，操作取消"
            exit 1
            ;;
    esac
else
    log_success "沒有未提交的變更"
    STASHED=false
fi

# 5. 獲取遠端資訊
log_step "獲取遠端倉庫資訊..."
git fetch origin

# 6. 檢查是否有新的提交
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/$CURRENT_BRANCH)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    log_success "本地已是最新版本！"
    
    # 如果之前有暫存變更，詢問是否恢復
    if [ "$STASHED" = true ]; then
        echo ""
        read -p "是否要恢復之前暫存的變更？ (y/n): " restore_choice
        if [ "$restore_choice" = "y" ] || [ "$restore_choice" = "Y" ]; then
            log_info "恢復暫存的變更..."
            git stash pop
            log_success "變更已恢復"
        else
            log_info "暫存的變更保持不動，可用 'git stash pop' 手動恢復"
        fi
    fi
    
    exit 0
fi

# 7. 顯示將要拉取的變更
log_step "顯示即將拉取的變更..."
echo ""
echo "=== 新的提交 ==="
git log --oneline $LOCAL_COMMIT..$REMOTE_COMMIT
echo "================="
echo ""

# 8. 拉取最新內容
log_step "拉取最新內容..."
if git pull origin $CURRENT_BRANCH; then
    log_success "成功拉取最新內容！"
else
    log_error "拉取失敗！"
    
    # 如果有暫存的變更且拉取失敗，提醒用戶
    if [ "$STASHED" = true ]; then
        log_warning "注意：你的本地變更已暫存，可用 'git stash pop' 恢復"
    fi
    exit 1
fi

# 9. 更新子模組（如果有的話，比如 Hugo 主題）
if [ -f ".gitmodules" ]; then
    log_step "更新子模組..."
    git submodule update --init --recursive
    log_success "子模組更新完成"
fi

# 10. 顯示更新摘要
echo ""
echo "=== 更新摘要 ==="
NEW_COMMIT=$(git rev-parse HEAD)
echo "• 從提交: ${LOCAL_COMMIT:0:7}"
echo "• 更新到: ${NEW_COMMIT:0:7}"
echo "• 新增提交數: $(git rev-list --count $LOCAL_COMMIT..$NEW_COMMIT)"
echo "================="

# 11. 恢復暫存的變更（如果有的話）
if [ "$STASHED" = true ]; then
    echo ""
    read -p "是否要恢復之前暫存的變更？ (y/n): " restore_choice
    if [ "$restore_choice" = "y" ] || [ "$restore_choice" = "Y" ]; then
        log_step "恢復暫存的變更..."
        if git stash pop; then
            log_success "變更已成功恢復"
        else
            log_warning "恢復變更時出現衝突，請手動解決"
            log_info "你可以使用以下命令查看狀態："
            echo "  git status"
            echo "  git diff"
        fi
    else
        log_info "暫存的變更保持不動"
        log_info "如需恢復，請執行: git stash pop"
    fi
fi

# 12. 顯示當前狀態
echo ""
log_step "當前倉庫狀態："
echo "• 分支: $(git branch --show-current)"
echo "• 最新提交: $(git log -1 --pretty=format:'%h - %s (%cr)' --abbrev-commit)"
echo "• 工作目錄: $(pwd)"

# 13. 檢查是否需要其他操作
echo ""
log_info "拉取完成！"
log_warning "注意事項："
echo "• 如果網站內容有更新，你可能需要重新建置網站"
echo "• 如果配置文件有變更，請檢查相關設定"
echo "• 如果有新的依賴，可能需要重新安裝"

echo ""
log_success "所有操作完成！"