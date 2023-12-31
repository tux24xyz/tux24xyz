#!/bin/bash
rm -rf public .hugo_build.lock
git pull origin main
# 生成網頁
hugo --gc --minify

# (選擇性) 推送網站原始碼至Github

