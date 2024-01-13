#!/bin/bash
rm -rf public .hugo_build.lock
git pull origin main
# 生成網頁
hugo --gc --minify


