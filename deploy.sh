#!/bin/bash

rm -r public

# 生成網頁
hugo --gc --minify

# (選擇性) 推送網站原始碼至Github
rm -r public resources .hugo_build.lock
git add -A
git commit -m "網站更新"
git push origin master

