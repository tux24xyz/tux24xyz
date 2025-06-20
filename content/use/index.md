---
title: "我所使用的各種工具和一些有的沒的"
date: 2025-06-18T18:19:00+08:00 # 撰寫時間
publishDate: 2025-06-20T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-05-30T15:30:00+08:00 # 最後修改時間
draft: false
tags: ["🖥️科技"]["🐧我的事"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

_最後更新：2025-06-18_

這篇文章會列出我有在使用 / 沒在使用 / 推薦 / 討厭的各項軟硬體。
我喜歡的這些工具其實多少有些共通點（當然不是大家都符合），例如：

1. [是自由軟體](https://wiwi.blog/blog/your-computer-is-not-yours)
2. It's Based 註：關於這點我之後會寫文章說明
3. 重視隱私
4. 我覺得好用
5. 我[認同](https://wiwi.blog/blog/seeking-approval)的人在用，所以我也用

_這篇文章其實是從[這裡](https://wiwi.blog/use)複製過來再做修改過的，謝謝你`wiwi`!_

_（沒錯！真．宅男說出的 `wiwi` 會自帶等寬字體和底色！）_

## 🖥️ 電腦軟體

### 💾 作業系統

* [Nobara Linux](https://nobaraproject.org/) - 玩遊戲用，但是不玩遊戲也能用，我的主力系統。btw It's bloat for those who don't play video games or just minimalist.
* [Linux Mint](https://linuxmint.com/) - 最容易用的 Linux 發行版，我裝在沒有要拿來玩遊戲的次要電腦上
* [Arch Linux](https://archlinux.org/) - 目前沒在用，天天處理電腦問題太麻煩了。之後筆電可能會考慮裝 Arch  +  WM，就像我以前（一年多前）那樣
* Debian - 我的伺服器（現在這個網站用的）上運行的作業系統。具體而言是 Debian 12

### 🌏 瀏覽器

* [Brave](https://brave.com/) - 內建擋廣告、擋追蹤程式的瀏覽器，iPhone 上也只有這個能用。再來就是一些網站（例如[教育部因材網](https://adl.edu.tw/)，TMD，害我要多裝一個瀏覽器，希望高中的老師不要用這個出作業）需要 Chromium Based 瀏覽器的時候用，所以我的電腦都會裝
* [LibreWolf](https://librewolf.net/) - 我打算之後從 Firefox 跳槽到這
* [Firefox](https://www.mozilla.org/zh-TW/firefox/new/) - w/[arkenfox.js](https://github.com/arkenfox/user.js)，沒有的話就是個間諜軟體。我用 Firefox 應該有四、五年以上了，每次看到 Gecko 引擎被一些網站排擠我都是又傷心又憤怒
* [Ungoogled Chromium](https://ungoogled-software.github.io/) - 以前在電腦上會用這個處理那些網站，但每次都要重裝 Ad Blocker 太麻煩了，所以改用 Brave
 
### 📟 終端機相關

* konsole - 聽起來很遜我知道，但我在 KDE Plasma 都用這個
* GNOME Terminal - 聽起來很遜我知道，但我在 Linux Mint 和 GNOME 都用這個
* [st](https://st.suckless.org/) - st 是 simple terminal 的縮寫。很酷的終端機模擬器，以前在筆電上的 Arch + dwm (學 Luke Smith 的) 配置中都用這個。一陣子沒用了
* bash - 現在寫這篇文章的 Linux Mint 電腦就在用預設的 bash，還堪用。我覺得電腦預設 bash 不是問題，預設用 zsh/fish 也不算是什麼優點，換自己喜歡的 Shell 應該是使用者要做的事（說的就是我）
* zsh - 換著不同花樣，有 Oh my zsh / 沒有 Oh my zsh 都用過了。目前懶得折騰，所以還沒裝
* fish - 功能很多，我都數不清了，我對使用體驗的印象很不錯，但現在也懶得裝

        Damn，我現在找不到我的 zsh 設定檔在哪。

* [ranger](https://ranger.fm/) - 終端機裡的檔案管理器，偶爾用
* [yt-dlp](https://github.com/yt-dlp/yt-dlp) - 影音下載工具，超好用
* [FFmpeg](https://ffmpeg.org/) - 多媒體轉檔軟體，但是都到 2025 年了[還是不支援HEIF格式](https://tux24.xyz/articles/heic)
* [pandoc](https://pandoc.org/) - 文件轉檔軟體

### 📻 媒體播放器

* [mpv](https://mpv.io/) - 世界最好（用）的播放軟體，但我都不用。未來重回 WM 懷抱的話會考慮一下
* [VLC Player](https://www.videolan.org/vlc/) - 世界第二好的播放軟體，我都用這個
* Rhythmbox / Elisa - 我對音樂播放器都沒什麼研究（因為之前都用串流的），現在用這些內建的播放器來播我買的 CD

### 💿️ CD Ripper

* K3b - KDE 的 CD Ripper，介面我覺得有點復古，我目前用這個。有人有其他推薦嗎？

### 📊 簡報

* [LibreOffice Impress](https://zh-tw.libreoffice.org/discover/impress/) - 不介紹了。老實說我覺得 Powerpoint 比較好用
* [sent](https://tools.suckless.org/sent/) - 終端機下的極簡報軟體，還真的能用。詳情請見 [Luke Smith 影片](https://www.youtube.com/watch?v=aCLCl96eNaI)

### 📝 筆記軟體 / 文字編輯器

* [Zettlr](https://www.zettlr.com/) - Blog 上的文章都用這個寫，我主要的 Markdown 編輯器。正體中文版譯者好像是 [wiwi](https://wiwi.blog) ?
* [Micro](https://micro-editor.github.io/) - 終端機下的、容易使用的文字編輯器。要簡單的編輯中文內容時用這個
* [Neovim](https://neovim.io/) - 很棒，但是用來寫中文內容實在是太痛苦了（切輸入法切到腦袋當機），我用來寫程式或英文內容剛剛好
* [Google Colab](https://colab.research.google.com/) - 寫在這只是因為以前在資訊科技課會被強迫用
* [VS Code](https://code.visualstudio.com/) - 寫在這只是因為很久以前用過，我碰到的資訊科技課老師不是叫你用 Colab 就是用這個

### 🗂️ 辦公室軟體

* [LibreOffice](https://zh-tw.libreoffice.org/)

### 💬 通訊軟體

* LINE - 我不喜歡用它，但在台灣大家都被強迫用它
* Discord - 我現在很常用，雖然是專有軟體，但是比 LINE 好用太多了（我不懂為何大家還在用 LINE）。我知道這樣不好，勢必得跳槽到 Matrix 
* Signal - 我以前（國小六年級）曾經成功推銷幾個同學用這個跟我聯絡，但他們現在都不跟我聯絡了😢

我覺得在社群媒體氾濫的年代，[有自己的網站](https://wiwi.blog/blog/just-blog)，用通訊軟體（Email 也行）約人線下見面是最理想的社交方式。

_如果你想和我聯絡的話，歡迎來信 tux24xyz@protonmail.com !_

### 🔑 密碼管理器

* [Bitwarden](https://bitwarden.com/) - 最推薦新手使用的密碼管理器，可以自架喔

### 🎨 圖片

* [Flameshot](https://flameshot.org/) - 看了別人推薦剛開始用的螢幕抓圖軟體
* Gwenview - KDE 下的圖片瀏覽器，也能做簡單的修改，我覺得很好用

### 🎹 音樂製作

* [Milky Tracker](https://milkytracker.titandemo.org/) - 很好玩！推薦 Milky Tracker 給沒聽過 Tracker 是什麼的人

### 🎞️ 影片製作

* [Kdenlive](https://kdenlive.org/) - 應該是最強大的自由的影片剪輯軟體了
* Shotcut - 也不錯用的自由剪片軟體
* [FFmpeg](https://ffmpeg.org/) - 你沒看錯，Luke Smith 說過他都用這個剪片（他很少剪片）。我其實沒用過，只是放在這等某位讀者和我分享用這個剪片的感想
* [OBS](https://obsproject.com/) - 好用的螢幕錄製和直播軟體，不過我只用來螢幕錄製

### 💻 網站製作

* [Hugo](https://gohugo.io/) - 把 Markdown 直接變成網站；這裡就是用這個架的。
* [Docusaurus](https://docusaurus.io/) - 專門用來架「文件」網站的軟體，[wiwi.blog](https://wiwi.blog)就是用它架的。我對這個很感興趣，因為在 RSS Reader 上的閱讀體驗很棒，而且站內搜尋功能也很好用。

### 🤖 AI

先空著

## ☁️ 雲端服務

### 🏡 自架服務

* Dnsmasq - 可以自架 DNS 擋廣告，很有效，不過目前沒在用
* SearXNG - 自架搜尋引擎，強烈建議每個人都架一個（架在個人網站的子域名下就可以了）

### 💰 訂閱制服務

* [Claude.ai](https://claude.ai/) - 個人覺得最好的線上語言模型，我沒付錢都覺得很好用（但是當然不如[離線 AI !](https://wiwi.blog/blog/offline-ai) ）
* [Vultr](https://www.vultr.com/) - 我用的 Linux 主機商，這個網站就架在那台 VPS 上，花費很低
* [Spotify](https://open.spotify.com/) - 很討厭它，但我偶爾還是會好奇某首歌的 Spotify 表現（然後被強迫聽 30 秒廣告）
* [Protonmail](https://mail.proton.me) - 我的主要 E-mail 服務商。我還是有在用 Gmail，但我設定了轉寄讓我不用開啟 Gmail 的客戶端

## 📱 手機

我目前用 256 GB 的 iPhone 11 Pro。糟糕到我認真想過把它丟出窗外或是交給父母改用 Dumb Phone

### 📲 作業系統

* 糟糕的 iOS
* 不過我還在用 iOS 15.6 + Trollstore，比原本的樣子好一點

### ⚙️ Apps（不分類）

* Apple Podcast - Podcast 播放器
* Kiwix - 離線也能查 Wikipedia 和其他
但是 iOS 15.6 竟然不能裝，可惡
* Organic Maps - 好用的離線地圖
* VLC Player - 好用的影音播放程式
* Trollstore - 透過觸發特定 iOS 版本的特定漏洞，來達到免越獄、免重簽就能側載第三方 ipa 的目的，超好用。我本來不知道這東西的存在，多虧了 [ivon 的這篇文章](https://ivonblog.com/posts/ios-trollstore/)才改變了我的人生
* YouTube w/ uYouPlus - 乾淨的 YouTube，用 Trollstore 裝的。本來想在 iPhone 上看沒廣告的 YouTube 只能用 [Invidious](https://invidious.io/) 或是 Brave 瀏覽器，現在用這個體驗好多了。不過這會不會也是我浪費許多時間的原因......
* Delta - GBA 模擬器，螢幕太小了不好玩（App Store 就有）
* PPSSPP - PSP 模擬器，螢幕太小加上按鍵＋手指擋住螢幕，不好玩（推薦用電腦版）
* Retroarch - 其實裝這個就不用裝 PPSSPP，用 Trollstore 裝第三方 ipa 還是有數量上限，失策。但遊戲存檔的轉移問題讓我懶得處理，就這樣吧
* iSH - iOS 上的終端機
註：我後來發現 PPSSPP 和 Retroarch App Store 就有提供

## 📚️ 閱讀

### 電子書

 * 你覺得我會用電子書？
好啦，我在 2021 年確實用過 1-2 個月的 Kindle (記得是 2012 年製造，原本是我媽的)，然後它就壞了🥲
記得我當時對那個新玩具愛不釋手，很認真的讀了裡面的某部東野圭吾的小說（看到一半就壞了，名字忘了，很精彩）（當時我還會花很多時間看書）。
之後我會再寫一篇文章講講這段故事。
我認為 實體書 >> 電子書，但是電子書也有方便攜帶、因為是新玩具所以會比實體書更認真讀（？）等優點。總之有閱讀>>>>>>>>>>>沒閱讀。
但是現今市面上的電子書作業系統都不自由（可能除了 PineNote，我沒研究，總之在台灣很難買到），買到的書也多半有 [DRM](https://wiwi.blog/blog/drm-doesnt-work)，這是個大缺點，不越獄就用不了。
所以還是讀實體書最好。

## 🖥️ 電腦硬體

### 內部硬體

#### 1 號電腦 （陪了我很久）
CPU: Intel i5-9***U
GPU: Nvidia GeForce GTX 1650
Memory: 16GB
Disk: 250GB+1TB

#### 2 號電腦 （最強）

#### 3 號電腦 （Intel NUC 小電腦） 
CPU: Intel i5-5250U (4) @ 2.700GHz 
GPU: Intel HD Graphics 6000 
Memory: 16GB 
Disk: 500GB

#### 1 號筆電

### 外部硬體

#### 1 號電腦
Screen: ROG, 27 inches, 2K 

#### 2 號電腦

#### 3 號電腦
沒有名字的薄膜鍵盤和便宜滑鼠
Screen: AOC, 27 inches, 2K / 我家的電視螢幕

## 🎧️耳機

* Razer Hammerhead True Wireless 2nd Generation
* Philips TAH5209 （市長獎贈品）