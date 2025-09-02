---
title: "RSS Feed 要顯示全文還是摘要比較好？"
date: 2025-09-02T21:12:14+08:00 # 撰寫時間
publishDate: 2025-09-03T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: false
tags: ["📝創作", "🖥️科技"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

這篇文章會有我對於網站 RSS Feed 設定的一些看法、相關建議。[^1]

話說我還沒做網站 RSS Feed 設定的教學 ... 再說吧。
[^1]: 這是此文摘要 XD
# 規則之零：要有 RSS Feed，還要讓讀者找得到

聽起來像廢話但這很重要所以我再講一次：都做出一個[獨立、小眾、用愛發電的個人網站](https://wiwi.blog/blogroll/)了，還不做 RSS Feed 讓其他和你一樣的人可以方便的讀你的網站內容？拜託！

除此之外，你還要讓網站的 RSS Feed 連結很容易就能被讀者找到，不然就是在浪費讀者時間。我知道有像 [RSSHub Radar](https://github.com/DIYgod/RSSHub-Radar) 這種方便工具可以用，但這不影響我的論點強度。

像我的網站就把 RSS Feed 連結放在首頁（那個看起來像電波的按鈕），不過可能還是不夠明顯，之後再改進。

# 規則之一：RSS Feed 要顯示全文而非摘要

我認為網站架設者要把 RSS Feed 設定為會包含完整的文章內容而非只有文章的標題或摘要。

給你幾個理由：

1. 我（讀者）想在 RSS Reader 裡讀完所有我訂閱的 RSS Feed，不想一個個跳出去看每個網站，這樣使用 RSS Feed 節省不到時間啊。
2. RSS Reader 可能有「在此閱讀」功能[^2]，像我使用的 [Yarr](https://github.com/nkanaev/yarr) 就有，但是這功能不一定每次都能正常運作，讀者也懶得每次都要按這個按鈕，再說讀者用的 RSS Reader 也不一定有這個功能。我覺得網站架設者把 RSS Feed 的顯示內容設定為全文、盡量做好閱讀體驗才是一勞永逸的作法。

但是摘要還是可以做，給[搜尋引擎的機器人](https://wiwi.blog/blog/im-not-a-robot)看的，就是 SEO 啦。

# 規則之二：可以的話，RSS Feed 要包含「所有」文章

如果你的網站和我一樣是輕量的靜態網站、文章內容主要是圖文的話，讓 RSS Feed 包含所有文章的成本應該不會很高。我建議你這麼做的理由和上一點一樣：加強讀者體驗、讓讀者不需要離開 RSS Reader，而且還能讓讀者更容易看到你以前的經典文章。

如果設定只讓 RSS Feed 包含最近的幾篇文章的話，讀者就不能在 RSS Reader 裡一次往下滑看到你以前寫過的文章，~~說不定還會被你[最近寫的廢文](https://tux24.xyz/articles/daily-drops-once-school-kicks-off/)[影響印象](https://tux24.xyz/articles/bad-articles-dont-belong-here/)~~。

一個我覺得好的例子是 [wiwi.blog](https://wiwi.blog)，我以前用 NetNewsWire 在 iPhone 上看他的文章時就是直接在 Reader 裡一口氣看完的，完全不需要打開 wiwi.blog。

[我的網站的 RSS Feed](https://tux24.xyz/index.xml) 也包含了我的所有文章啦，只是沒分類就會有比較亂的問題，但好處是只需要一個 RSS Feed。
[^2]: 就是 Reader 會主動去抓取這個網頁的內容顯示，這樣就能在 Reader 裡看到完整文章