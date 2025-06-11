#!/bin/bash
echo "=== 環境診斷 ==="
echo "用戶: $(whoami)"
echo "Hugo: $(hugo version 2>/dev/null || echo '未安裝')"
echo "Git: $(git --version 2>/dev/null || echo '未安裝')"
echo "Nginx: $(nginx -v 2>&1 || echo '未安裝')"

echo -e "\n=== 目錄檢查 ==="
ls -la /tux24xyz/ 2>/dev/null || echo "目錄不存在"

echo -e "\n=== 權限檢查 ==="
ls -ld /tux24xyz 2>/dev/null || echo "無法檢查權限"

echo -e "\n=== Git 狀態 ==="
cd /tux24xyz 2>/dev/null && git status || echo "非 Git 倉庫"
