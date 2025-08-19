---
title: "繼續用 Arch"
date: 2025-08-18T10:56:50+08:00 # 撰寫時間
publishDate: 2025-08-19T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: true
tags: ["🖥️科技"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

我的筆電上安裝了 Arch + Hyprland 的組合，這是我第一次嘗試。用了兩個禮拜下來的體驗很不錯，筆電跑得飛快又不會像以前裝 dwm 那樣問題一大堆（設定還要重新編譯才能生效）。但是上週四（2025-08-14），在一次更新後，sddm 無法正確的帶我進入 Hyprland，我進入了好久不見的 tty 開始除錯 ...

# 試著啟動 Hyprland

我從 tty 直接透過指令啟動 Hyprland：

```zsh
hyprland
```

以前用 X11 + dwm 時都是直接在 tty 輸入 `startx` ，不透過 Display Manager 的 ...

好了，Hyprland 正常啟動，我的漂亮 waybar、視窗邊框彩虹特效什麼的都還在，但是透過 ~/.config/autostart 啟動的 syncthing 有問題。為了晚上睡得著，還是來除錯吧。

# uwsm

一開始我還以為是 uwsm 的問題，我不記得當初為何我會在 Hyprland 官方 Wiki 不建議嘗試的前提下還使用 uwsm，反正我現在要來繞過它：

```zsh
sudo mv /usr/share/wayland-sessions/uwsm-hyprland.desktop /usr/share/wayland-sessions/uwsm-hyprland.desktop.backup
# 然後
sudo rm /usr/share/wayland-sessions/uwsm-hyprland.desktop
```

我直接把 uwsm 的 Desktop Entry 給刪了，然後自己寫一個只用 Hyprland 的 Desktop Entry：

```zsh
[Desktop Entry]
Name=Hyprland 
Comment=Hyprland compositor without uwsm
Exec=hyprland
Type=Application
DesktopNames=Hyprland
```

類似這樣。

但是問題沒有獲得解決。

# dbus

後來我又以為是 dbus 的問題，因為 dbus 並沒有被啟用，所以：

```zsh
sudo systemctl enable dbus

sudo systemctl start dbus

systemctl status dbus

systemctl --user status dbus

systemctl --user enable dbus
systemctl --user start dbus
```

這樣，一連串指令下來，重開機，問題還在。

# sddm

那就是 sddm 有問題囉？我問了 Claude 要怎麼解決這個問題，它建議我使用自訂的腳本來啟動 Hyprland 除錯；第一版腳本長這樣：

```bash
#!/bin/bash
exec 2>&1
exec > /tmp/hyprland-session.log

echo "=== Hyprland Session Debug $(date) ==="
echo "User: $USER ($(id))"
echo "Environment:"
env | sort
echo "=== Groups ==="
groups
echo "=== XDG Runtime Dir ==="
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
ls -la "$XDG_RUNTIME_DIR" 2>/dev/null || echo "XDG_RUNTIME_DIR not accessible"

echo "=== Device Access ==="
ls -la /dev/dri/ 2>/dev/null || echo "No DRI devices"
ls -la /dev/input/event* 2>/dev/null | head -5 || echo "No input devices accessible"

echo "=== Starting Hyprland ==="
exec /usr/bin/hyprland
```

接下來呢，我就按照 Claude 的指示一步步除錯。我剛才數了一下，它來回給了我十個版本的除錯腳本都沒有解決問題，到後來我已經完全搞不懂情況是怎麼回事了。

從建立日誌到監視進程都找不到啟動失敗的原因，花了我三天的時間，自己也什麼都沒學到，未來碰到類似的問題我大概還是不知道要怎麼辦吧。

最後我直接棄用 Display Manager，把沒有成功啟動的程式全部都交給 `hyprland.conf` 處理，回到最極簡的方式，用 tty 啟動 Hyprland，就這樣用了一天，什麼問題都沒碰到。

# 檢討

看來用 LLM 解決技術問題還是有個大缺點，那就是當使用者的技術程度不足時，就算僥倖解決了問題也只是一知半解，最終只會變成依賴 LLM 的[廢物](https://tux24.xyz/articles/based)。

相對的，如果我是自己一步步看日誌、手冊解決問題的話，雖然比較辛苦，但是應該是能帶走比較多東西的吧？

總之，這篇文章就是我對現況不滿的自言自語 ... 嗯 ... 文筆也不太好 ...



