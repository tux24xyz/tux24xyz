#!/bin/bash

# 快速寫作助手 v2.0 - 樂評自動化整合版
# 功能：模板選擇、標籤管理、MusicBrainz 封面抓取、ImageMagick 壓縮、Page Bundle 自動組織

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' 

# 配置變數
TEMPLATE_DIR="templates"
REVIEWS_DIR="./content/reviews" # 樂評專用目錄
CONFIG_FILE=".writing-config"

# 預設標籤
AVAILABLE_GENRES=("🇯🇵J-Pop" "🎸Rock" "🎹Electronic")

# 輸出函數
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_prompt() { echo -e "${CYAN}[PROMPT]${NC} $1"; }

# 1. 基礎準備
create_directories() {
    mkdir -p "$TEMPLATE_DIR"
    mkdir -p "$REVIEWS_DIR"
}

list_templates() {
    local templates=($(find "$TEMPLATE_DIR" -name "*.md" -type f))
    if [ ${#templates[@]} -eq 0 ]; then
        log_error "模板目錄不存在或為空: $TEMPLATE_DIR"
        exit 1
    fi
    echo -e "\n${MAGENTA}=== 可用模板 ===${NC}"
    for i in "${!templates[@]}"; do
        echo -e "${YELLOW}$((i+1)).${NC} $(basename "${templates[$i]}" .md)"
    done
}

select_template() {
    local templates=($(find "$TEMPLATE_DIR" -name "*.md" -type f))
    while true; do
        log_prompt "請選擇模板 (輸入數字):"
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#templates[@]} ]; then
            SELECTED_TEMPLATE="${templates[$((choice-1))]}"
            break
        fi
    done
}

# 2. 樂評資訊獲取
get_album_info() {
    log_info "步驟 2: 輸入樂評資訊"
    
    while true; do
        log_prompt "請輸入歌手名稱 (Artist):"
        read -r ALBUM_ARTIST
        log_prompt "請輸入專輯名稱 (Album Title):"
        read -r ARTICLE_TITLE
        if [ -n "$ALBUM_ARTIST" ] && [ -n "$ARTICLE_TITLE" ]; then break; fi
        log_error "歌手與專輯名稱均不能為空"
    done

    log_prompt "請輸入評分 (0.0 - 10.0):"
    read -r ALBUM_SCORE
    
    log_prompt "請輸入一句關鍵引言 (Intro Quote):"
    read -r ALBUM_QUOTE
    
    log_prompt "請輸入發行年份:"
    read -r RELEASED

    log_prompt "請輸入資料夾/文件名 (英文或數字較佳):"
    read -r FILE_SLUG
    ARTICLE_FILENAME="${FILE_SLUG}.md"
}

# 3. 標籤選擇 (保留原有功能)
select_genres() {
    local selected_genres=()
    echo -e "\n${MAGENTA}=== 可用標籤 ===${NC}"
    for i in "${!AVAILABLE_GENRES[@]}"; do
        echo -e "${YELLOW}$((i+1)).${NC} ${AVAILABLE_GENRES[$i]}"
    done
    
    while true; do
        log_prompt "請選擇標籤 (輸入數字, c 自定義, done 完成):"
        read -r genre_input
        case "$genre_input" in
            "done") break ;;
            "c") read -r ct; selected_genres+=("$ct"); ;;
            *) 
                IFS=',' read -ra nums <<< "$genre_input"
                for n in "${nums[@]}"; do
                    local t="${AVAILABLE_GENRES[$((n-1))]}"
                    selected_genres+=("$t")
                done ;;
        esac
    done
    
    # 格式化為 YAML 陣列
    SELECTED_GENRES_YAML=""
    for genre in "${selected_genres[@]}"; do
        [ -z "$SELECTED_GENRES_YAML" ] && SELECTED_GENRES_YAML="\"$genre\"" || SELECTED_GENRES_YAML="$SELECTED_GENRES_YAML, \"$genre\""
    done
}

# 4. 自動化封面抓取與處理 (New!)
fetch_and_process_cover() {
    local target_folder=$1
    local target_img="${target_folder}/cover.jpg"

    log_info "步驟 4.5: 正在搜尋 MusicBrainz 封面..."

    # 搜尋 MBID
    local query="artist:\"$ALBUM_ARTIST\" AND release:\"$ARTICLE_TITLE\""
    local encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$query'''))")
    local mbid=$(curl -s --connect-timeout 5 "https://musicbrainz.org/ws/2/release/?query=$encoded_query&fmt=json" | jq -r '.releases[0].id // empty')

    if [ -z "$mbid" ]; then
        log_warning "未能自動匹配封面，請稍後手動放入 cover.jpg"
        return 1
    fi

    log_info "找到 MBID: $mbid，下載中..."
    if curl -L -s --connect-timeout 10 -o "$target_img" "https://coverartarchive.org/release/$mbid/front"; then
        log_info "正在優化圖片 (800px, 壓縮, 去除 Metadata)..."
        # 使用 ImageMagick 處理
        if command -v magick &> /dev/null; then
            magick "$target_img" -resize 800x -quality 85 -strip "$target_img"
        else
            convert "$target_img" -resize 800x -quality 85 -strip "$target_img"
        fi
        log_success "封面自動化處理完成！"
    else
        log_error "封面下載失敗。"
    fi
}

# 5. 檔案組織與寫入
process_and_organize() {
    local folder_path="${REVIEWS_DIR}/${FILE_SLUG}"
    mkdir -p "$folder_path"
    
    local current_time=$(date '+%Y-%m-%dT%H:%M:%S+08:00')
    local template_content=$(cat "$SELECTED_TEMPLATE")
    
    # 變數替換
    template_content=$(echo "$template_content" | sed "s/{{TITLE}}/\"$ARTICLE_TITLE\"/g")
    template_content=$(echo "$template_content" | sed "s/{{ARTIST}}/\"$ALBUM_ARTIST\"/g")
    template_content=$(echo "$template_content" | sed "s/{{SCORE}}/$ALBUM_SCORE/g")
    template_content=$(echo "$template_content" | sed "s/{{QUOTE}}/\"$ALBUM_QUOTE\"/g")
    template_content=$(echo "$template_content" | sed "s/{{DATE}}/$current_time/g")
    template_content=$(echo "$template_content" | sed "s/{{RELEASED}}/$RELEASED/g") 
    template_content=$(echo "$template_content" | sed "s/{{GENRES}}/[$SELECTED_GENRES_YAML]/g")
    
    echo "$template_content" > "${folder_path}/index.md"
    
    # 執行封面抓取
    fetch_and_process_cover "$folder_path"
    
    log_success "樂評資料夾已生成: $folder_path"
}

# 主程序
main() {
    echo -e "${MAGENTA}╔══════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║      專輯樂評自動化助手 v2.0         ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════╝${NC}"
    
    create_directories
    list_templates
    select_template
    get_album_info
    select_genres
    process_and_organize
    
    echo -e "\n${GREEN}🎉 樂評框架已準備好！請至 ${REVIEWS_DIR}/${FILE_SLUG}/index.md 開始寫作。${NC}"
}

trap 'log_error "執行過程中發生錯誤"; exit 1' ERR
main "$@"
