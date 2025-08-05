---
title: "架網站教學 Pt.4 - 加密"
date: 2025-08-04T12:15:57+08:00 # 撰寫時間
publishDate: 2025-08-05T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: false
tags: ["🖥️科技", "📝創作", "⭐️重要"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

在今天的文章，我會教你如何使用一個叫做 CertBot 的工具來加密你的網站和你的電腦之間的通訊，讓你的網站能用上 HTTPS 協議。如果不這麼做的話，應該沒人會想要看你的網站，畢竟現在是 2025 年。

很抱歉斷更了一天，之後可能會更常斷更（？）

這篇文章可以說是[**這篇文章**](https://landchad.net/basic/certbot/)的中文翻譯＋更新版，我當初也是看著 landchad.net 的教學架好這個網站的，所以如果你覺得我寫的很爛 ... 你可以去看英文版沒關係。

# 架網站第五步：讓你的網站用上 HTTPS

## 安裝必要套件

首先，在你的主機上輸入指令：

```
apt install python3-certbot-nginx
```

這個指令會幫你裝好 CertBot。

## 執行 CertBot，開始加密

然後接下來

{{<notice warning>}}先不要！{{</notice>}}

運行指令：

```
certbot --nginx
```

這個指令運行之後，它應該會問你的 Email。

### Email 設定說明

這個 Email 的作用是每三個月它會寄一封信給你，讓你去重新更新你的加密憑證。

但你也可以把它設定成會自動重新更新，如果你懶得每三個月要檢查一次 Email 的話，你可以加上第二個參數：

```
certbot --nginx --register-unsafely-without-email
```

我建議你使用這個版本的指令。

### 設定過程

它可能還是會再問你一次是否提供 E-mail, 我建議你直接拒絕，不會出事的。

完成後，它會問你要加密那一個域名，你直接按 Enter 就好（因為應該也只有一個）。

![看到這個算你厲害](https://landchad.net/pix/certbot-01.png)

等一下它會問你 NoRedirect 還是 Redirect，你就按 2。

![看到這算你厲害](https://landchad.net/pix/certbot-02.png)

這樣就成功了。

## 對於那些剛才輸入的指令中沒有加上 `--register-unsafely-without-email` 參數的人 ...

你必須要看一下[這篇文章的最後一段](https://landchad.net/basic/certbot/)，我懶得翻譯了。

_提醒你：剛才太心急執行到第一個指令的人其實你可以按 Ctrl + C 強迫中止指令，記得我上一篇文章是怎麼寫的嗎？_

---

到這裡，基本設定已經完成，我將會在接下來的教學中深入的教你如何使用 [Hugo](https://gohugo.io/) 做出一個靜態的個人網站。

基本設定已經完成的意思是：你可以參考 [landchad.net](https://landchad.net)，或是網路上的其他教學開始在你的主機上架設各種服務，那些你原本依賴雲端的服務，例如自己的 VPN、自己的搜尋引擎、自己的 E-mail 伺服器等等 ...

想成為[網路上的地主而非佃農](https://wiwi.blog/blog/internet-peasant)，這步是必要的。不過我目前沒有很多時間寫這些教學，就留給你自己研究了😉