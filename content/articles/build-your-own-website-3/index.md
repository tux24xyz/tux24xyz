---
title: "架網站教學 Pt.3 - 測試一下"
date: 2025-08-02T10:26:42+08:00 # 撰寫時間
publishDate: 2025-08-03T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: false
tags: ["🖥️科技", "📝創作", "⭐️重要"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---
如果你已經照著我前兩篇教學連結好主機和域名，代表你現在可以連線到你的主機開始設定你的網站了。

注意喔，這個系列的教學文章是針對 Debian 系統而寫的，如果你在第一篇文章中的第二步中沒有選擇 Debian 的話，抱歉，你要自己研究其他發行版的操作方式了🥲

等下我們會用到終端機和一個叫做 ssh 的工具，如果你現在的電腦上運行的是 Mac OS 或 Linux 的話，可以直接開始了。Windows 的用戶要先裝好 ssh 才行，我記得是沒有內建的。



不會很困難，別被文字介面給唬住了，放輕鬆

# 架網站第四步 - 設定一個叫做 nginx 的東西

## 安裝一些必要的 ... 軟體[^1]
[^1]: 我本來想寫「套件」的，但還是算了

首先，打開你的 Vultr 主機管理頁面

複製你的主機密碼，打開終端機，並且輸入：

```
ssh root@你的域名
# 例如：ssh root@tux24.online
```

接下來它應該會要求你輸入你的密碼，你就把密碼貼上。在終端機下，複製/貼上的快速鍵是 Ctrl + Shift + C/ Ctrl + Shift + V 喔，別按到 Ctrl + C 了，那在終端機下是「強迫中止運行中的指令」的意思 

好了，現在你可以遠端透過 ssh 操控你的主機了。你的主機沒有，也不會有圖形介面，如果你是第一次使用終端機的話，未來你就會習慣，並且愛上它的，我保證。

現在輸入以下指令：

```
apt update
apt upgrade
apt install nginx
```

前兩行指令的意思是叫你的主機先更新整個系統，第三行指令則是叫你的主機安裝 nginx。

nginx 是什麼呢？~~因為我懶得寫那麼多字所以~~今天就先不解釋，你有興趣再自己研究喔😉

## 要如何設定 nginx 呢？

我先對比較不懂電腦的人說明一下，我們以後在「改設定」的時候，做的事情都差不多：**打開一個文字檔，修改裡面的內容**，記得我剛才說「沒有圖形介面給你用」嗎？要慢慢習慣喔。

nginx 的網頁設定檔放在 `/etc/nginx/` 這個目錄，這個目錄下有兩個 ... 小目錄（我不知道如何說明），分別為 `/etc/nginx/sites-available` 和 `/etc/nginx/sites-enabled`。

邏輯是這樣的：你可以先到 `/etc/nginx/sites-available` 修改好你的設定檔之後，再把設定檔連結到 `/etc/nginx/sites-enabled` 使設定檔生效。

你要修改設定檔，所以你需要一個終端機下能用的文字編輯器，對吧？我建議沒有經驗的人可以安裝一個叫做 `micro` 的文字編輯器，你可以在裡面使用 Ctrl +C, Ctrl + V 這些比較直覺的操作。

要安裝 micro，輸入以下指令：

```
apt install micro
```

## 正式開始吧！

首先，新增一個設定檔，輸入以下指令

```
micro /etc/nginx/sites-available/yourwebsite
# 請把 yourwebsite 替換成你的域名（不一定要，這只是我的小建議），像我就替換成 tux24xyz。記得要把 . 去掉
```

接下來貼上我幫你寫好的這段文字：

```
server {
        listen 80 ;
        listen [::]:80 ;
        server_name tux24.xyz ; # 把 tux24.xyz 替換成你的域名
        root /var/www/yourwebsite ; # 把 yourwebsite 也替換成你的域名，記得去掉中間的點，像我就替換成 tux24xyz
        index index.html index.htm index.nginx-debian.html ;
        location / {
                try_files $uri $uri/ =404 ;
        }
}

```

懶得解釋了，想看解釋的人自己去看[原文](https://landchad.net/basic/nginx/)吧 ...

我先說明，這個設定檔是測試用的，在未來的教學中我們還要修改它。

## 測試(做出一個簡陋的網頁)

首先輸入指令：

```
mkdir /var/www/yourwebsite # 替換成你剛才在設定檔裡面寫的名稱
```

指令的意思是建立一個目錄，`mkdir` 是 `make directory` 的縮寫

再輸入指令：

```
micro /var/www/yourwebsite/index.html
```

貼上下面的測試用內容

```
<!DOCTYPE html>
<h1>Hello World!</h1>
<p>我做出了一個網頁了欸！</p>
<p>測試成功！</p>
```

再來要啟用你的設定檔，輸入以下指令：

```
ln -s /etc/nginx/sites-available/yourwebsite /etc/nginx/sites-enabled
# 記得替換 ...
```

然後再輸入這個指令，重載 nginx：

```
systemctl reload nginx
```

### 防火牆

Vultr 和一些其他的主機商預設會幫你安裝好 `ufw`，一個管理防火牆的工具，他們預設會把所有東西都擋掉，所以我們要輸入以下指令：

```
ufw allow 80
ufw allow 443
```

### 安全小建議

nginx 預設會在錯誤頁面顯示它的版本號碼，為了安全，我們要把這個設定給關了。

打開 nginx 自己的設定檔 `/etc/nginx/nginx.conf`並找到 `# server_tokens off` 這行，取消註解（把 # 刪掉），然後重載 nginx，你需要輸入以下指令：

```
micro /etc/nginx/nginx.conf
# 找到 `# server_tokens off` 這行，取消註解（把 # 刪掉）
# 儲存並退出
systemctl reload nginx 
```

記得定期更新你主機上的軟體（尤其是 nginx），確保獲得最新的安全性修復！

### 完成！

打開你的瀏覽器，輸入你的域名，你應該會看到剛才你貼上的測試用內容。

注意到左上角的的連線並不安全提示了嗎？那是因為你的網站目前沒有設定好 https，連線沒有被加密，下一篇文章我就會教你如何設定。
# 明天見！
