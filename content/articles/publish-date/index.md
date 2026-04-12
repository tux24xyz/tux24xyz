---
title: "文章發布日期"
date: 2026-04-12T17:05:14+08:00 # 撰寫時間
publishDate: 2026-04-12T17:05:14+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: false
tags: ["📝創作"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

讀到 [Alex Hsu 的這篇文章](https://alexhsu.com/publish-date)，發現雖然[我已經用腳本解決](https://tux24.xyz/articles/build-your-own-website-7/)寫作時沒有精確紀錄時間的問題了，但我總是把文章發布時間（`publishDate`）設定在文章完成隔天的早上六點（UTC+8），而我的網站和 RSS Feed 顯示的都是文章的 `date`，也就是寫作時間。這樣我的 RSS 文章壽命還是一樣短。

所以我改了我的腳本，現在 `publishDate` 和 `date` 是同一個時間。

不過那些我放了很久才發的文章一樣會有這個問題，目前先擱著不管，我想到的時候再[手動加上當天時間](https://e89295.com/blog/2026-04-11_1.html)[^1]就好。

之後再更新我的教學文章好了（很久之後）。

[^1]: 很佩服我